import express from "express";
import { postgraphile } from "postgraphile";
import ConnectionFilterPlugin from "postgraphile-plugin-connection-filter";
import dotenv from "dotenv";
import cors from "cors";
import pg from "pg";
import buildPrompt from "./gptPrompt.ts";
const { Pool } = pg;
import { OpenAI } from "openai";
import { encoding_for_model } from "@dqbd/tiktoken";

dotenv.config();

const app = express();
app.use(express.json());

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

// To avoid server crashing on disconnect
pool.on('error', (err) => {
  console.error('Unexpected PostgreSQL error on idle client:', err);
});

const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

app.use(
  cors({
    origin: "http://localhost:5173", // Local vite
  })
);

app.use(
  postgraphile(pool, "public", {
    watchPg: false, //set to false when using the session poole connection. Direct connection which works with watchpg requires ipv4 (costs money). db changes wont show in graphql api unless restarting the node server
    graphiql: true,
    enhanceGraphiql: true,
    appendPlugins: [ConnectionFilterPlugin],
    graphileBuildOptions: {
      connectionFilterRelations: true,
    },
  })
);

app.post("/login", async (req, res) => {
  const { user } = req.body;

  if (!user) {
    return res.status(400).json({ error: "No user provided" });
  }

  try {
    const response = await pool.query(
      "SELECT * FROM users WHERE email = $1 AND password_hash = $2",
      [user.email, user.password]
    );

    const data = response.rows;
    return res.json(data);
  } catch (error) {
    console.error("Execution Error:", error);
    return res.status(500).json({ error: "Failed to login" });
  }
});

app.post("/execute", async (req, res) => {
  const { code } = req.body;

  if (!code) {
    return res.status(400).json({ error: "No code provided" });
  }

  try {
    const response = await fetch(
      "https://python-runner-879157704586.europe-north1.run.app/run",
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code }),
      }
    );

    const data = await response.json();
    return res.json(data);
  } catch (error) {
    console.error("Execution Error:", error);
    return res.status(500).json({ error: "Failed to execute code" });
  }
});

app.post("/help", async (req, res) => {
  const { code, taskId } = req.body;
  const encoder = encoding_for_model("gpt-4o");

  type Task = {
    task_id: number;
    task_name: string;
    task_description: string;
    expected_code: string;
    expected_output: string;
    code_template: string;
    difficulty: string;
    level: string;
    type: string;
    course_id: number;
    user_id: number;
    public_access: boolean;
    image_url: string;
    is_active: boolean;
    codeTemplate?: string;
  };

  type Requirement = {
    requirement_id: number;
    requirement_name: string;
  };

  let userCodeOutput = "";
  let requirements: Requirement[] = [];
  let task: Task;
  

  const MAX_TOKENS_OUTPUT = 350;
  const TEMPERATURE = 0.7;
  const MAX_TOTAL_TOKENS = 4096; // default for gpt 3.5, gpt-4o-mini has a limit of 128000 tokens

  // should maybe implement a gpt output history so that it can take into consideration the previous tips as well as if the person is
  // still struggling with the same code problem and did not manage to solve it with the previous feedback. Can maybe save like 5 last stored in a store in frontend.
  // reset on refresh or changing task, like the current code in editor (if not autosaved in codehistory).
  // should also support print() in code tasks. Must change, frontend, backend and python contaienr for this.

  if (!code) {
    return res.status(400).json({ error: "No code provided" });
  }

  if (!taskId) {
    return res.status(400).json({ error: "No task provided" });
  }

  try {
    const response = await fetch(
      "https://python-runner-879157704586.europe-north1.run.app/run",
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code }),
      }
    );

    const data = await response.json();
    userCodeOutput = data.output;
  } catch (error) {
    console.error("Execution Error:", error);
    return res.status(500).json({ error: "Failed to execute code" });
  }


  try {
    const taskResult = await pool.query(
      'SELECT * FROM tasks WHERE task_id = $1',
      [taskId]
    );
    
    if (taskResult.rows.length === 0) {
      return res.status(404).json({ error: 'Task not found' });
    }
    
    task = taskResult.rows[0];
    
    const requirementResult = await pool.query(
      `
      SELECT r.*
      FROM requirements r
      INNER JOIN taskrequirements tr ON r.requirement_id = tr.requirement_id
      WHERE tr.task_id = $1
      `,
      [taskId]
    );

    requirements = requirementResult.rows;

    } catch (error) {
      console.error('Failed to fetch task:', error);
      return res.status(500).json({ error: 'Error fetching task' });
    }

  if (
    !task.task_name ||
    !task.task_description ||
    !requirements ||
    !task.level ||
    !task.expected_code ||
    !task.expected_output
  ) {
    return res
      .status(400)
      .json({ error: "Missing one or more required fields in the prompt." });
  }


  const prompt = buildPrompt({
    taskTitle: task.task_name,
    taskDescription: task.task_description,
    requirements: requirements,
    level: task.level,
    expectedCode: task.expected_code,
    expectedOutput: task.expected_output,
    code: code,
    userCodeOutput: userCodeOutput,
    codeTemplate: task.code_template,
  });

  const promptTokens = encoder.encode(prompt).length;

  const totalTokens = promptTokens + MAX_TOKENS_OUTPUT;

  if (totalTokens > MAX_TOTAL_TOKENS) {
    return res.status(400).json({
      error: `Prompt is too long. Estimated tokens: ${totalTokens} / ${MAX_TOTAL_TOKENS}`,
    });
  }

  encoder.free();

  try {
    const completion = await openai.chat.completions.create({
      model: "gpt-4o", //gpt-4o-mini is not available, gpt-4o uses the same tokenizer as gpt-4o-mini
      store: true,
      messages: [
        {
          role: "system",
          content: `Du er en læringsassistent som hjelper en elev på ${task.level}-nivå i Norge med en programmeringsoppgave skrevet i Python.`,
        },
        {
          role: "user",
          content: prompt,
        },
      ],
      temperature: TEMPERATURE, // default value of precision and creativeness of ouput
      max_tokens: MAX_TOKENS_OUTPUT, // upper limit of gpt output
    });

    return res.json({ message: completion.choices[0].message.content });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: "Error generating AI help" });
  }
});

app.post("/submit", async (req, res) => {
  const { code, taskId } = req.body;

  type Task = {
    task_id: number;
    task_name: string;
    task_description: string;
    expected_code: string;
    expected_output: string;
    code_template: string;
    difficulty: string;
    level: string;
    type: string;
    course_id: number;
    user_id: number;
    public_access: boolean;
    image_url: string;
    is_active: boolean;
    codeTemplate?: string;
  };


  let userCodeOutput = "";
  let task: Task;

  if (!code) {
    return res.status(400).json({ error: "No code provided" });
  }

  if (!taskId) {
    return res.status(400).json({ error: "No task provided" });
  }

  try {
    const response = await fetch(
      "https://python-runner-879157704586.europe-north1.run.app/run",
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ code }),
      }
    );

    const data = await response.json();
    userCodeOutput = data.output;
  } catch (error) {
    console.error("Execution Error:", error);
    return res.status(500).json({ error: "Failed to execute code" });
  }


  try {
    const taskResult = await pool.query(
      'SELECT * FROM tasks WHERE task_id = $1',
      [taskId]
    );
    
    if (taskResult.rows.length === 0) {
      return res.status(404).json({ error: 'Task not found' });
    }
    
    task = taskResult.rows[0];

    } catch (error) {
      console.error('Failed to fetch task:', error);
      return res.status(500).json({ error: 'Error fetching task' });
    }

  if (
    !task.expected_output
  ) {
    return res
      .status(400)
      .json({ error: "Missing expected output." });
  }

  // needs a mopre advanced comparison, maybe use ai as well? This will fail to check correctly for tasks that depends on spaces, like:
  // print this with foor loops:
  //   *
  //  ***
  // *****
  // because of trim()
  const normalize = (str: string) =>
    str
      .toString()
      .trim()
      .toLowerCase()
      .replace(/\r\n|\r/g, '\n')
      .replace(/\s+$/gm, '')
  const isCorrect = normalize(userCodeOutput) == normalize(task.expected_output);

  return res.json({ message: isCorrect? 'Outputen samsvarer med fasiten. Oppgaven er løst. Bra jobba!' : 'Outputen samsvarer ikke med fasiten. Oppgaven er ikke løst.', isSolved: isCorrect});
});

const PORT: number = Number(process.env.PORT || 6001);
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
