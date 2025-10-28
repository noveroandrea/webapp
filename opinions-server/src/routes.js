import express from "express";
import { db } from "./db.js";

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

router.post("/vote", async (req, res) => {
  const { user_id, topic_id, vote } = req.body;
  try {
    await db.query(
      "INSERT INTO votes (user_id, topic_id, vote) VALUES ($1, $2, $3)",
      [user_id, topic_id, vote]
    );
    res.json({ message: "Vote recorded" });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Internal server error" });
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
