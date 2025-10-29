import express from "express";
import { db } from "./db.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";


export const router = express.Router();

router.get("/topics", async (req, res) => {
  try {
    const result = await db.query("SELECT * FROM topics");
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
  }
});

const SECRET_KEY = process.env.SECRET_KEY || "your_secret_key";

// Registration endpoint
router.post("/register", async (req, res) => {
  const { name, email, password } = req.body;
  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    await db.query(
      "INSERT INTO users (name, email, password) VALUES ($1, $2, $3)",
      [name, email, hashedPassword]
    );
    res.json({ message: "User registered successfully" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Registration failed" });
  }
});

// Login endpoint
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    const result = await db.query("SELECT * FROM users WHERE email = $1", [email]);
    const user = result.rows[0];

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    const token = jwt.sign({ userId: user.id, email: user.email }, SECRET_KEY, { expiresIn: "1m" });
    res.json({ token });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Login failed" });
  }
});

router.post("/vote", async (req, res) => {
  const { topic_id, vote } = req.body;
  const token = req.headers.authorization?.split(" ")[1];


  try {
    if (!token) {
      return res.status(401).json({ error: "Token not provided" });
    }

    const decoded = jwt.verify(token, SECRET_KEY);
    const user_id = decoded.userId;

    await db.query(
      "INSERT INTO votes (user_id, topic_id, vote) VALUES ($1, $2, $3)",
      [user_id, topic_id, vote]
    );
    res.json({ message: "Vote recorded" });
  } catch (err) {
    console.error(err);
    res.status(401).json({ error: "Unauthorized" });
  }
});

// New: status endpoint to inspect full DB table contents
router.get("/status", async (req, res) => {
    try {
        const topicsRes = await db.query("SELECT * FROM topics ORDER BY id");
        const usersRes = await db.query("SELECT * FROM users ORDER BY id");
        const votesRes = await db.query("SELECT * FROM votes ORDER BY id");

        res.json({
            topics: topicsRes.rows,
            users: usersRes.rows,
            votes: votesRes.rows,
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Could not read DB status" });
    }
});
