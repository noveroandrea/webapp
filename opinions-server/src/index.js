import express from "express";
import { router } from "./routes.js";
import "./db.js"; // initializes DB connection

const app = express();
app.use(express.json());
app.use("/api", router);

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
