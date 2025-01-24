import express from "express";
import cors from "cors";
import dotenv from "dotenv";

// Load environment variables from .env file
dotenv.config();

// Create express app
const app = express();

// Parse request body as JSON
app.use(express.json());

// Enable CORS and allow all origins
app.use(
  cors({
    origin: "*",
  })
);

// Define port and start server
const PORT: number = Number(process.env.PORT || 5001);
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
