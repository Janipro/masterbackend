import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { postgraphile } from "postgraphile";
import ConnectionFilterPlugin from "postgraphile-plugin-connection-filter";

dotenv.config();
const app = express();
app.use(express.json());

app.use(
  cors({
    origin: "http://localhost:5173", // Local vite
  })
);

app.use(
  postgraphile(process.env.DATABASE_URL, "public", {
    watchPg: true,
    graphiql: true,
    enhanceGraphiql: true,
    appendPlugins: [ConnectionFilterPlugin],
    graphileBuildOptions: {
      connectionFilterRelations: true,
    },
  })
);

const PORT: number = Number(process.env.PORT || 5001);
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
