import pg from "pg";
import dotenv from "dotenv";
dotenv.config();

export const db = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
});

db.connect()
  .then(() => console.log("Database connected"))
  .catch(err => console.error("DB connection error", err));
