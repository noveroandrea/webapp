import express from "express";
import { router } from "./routes.js";
import cors from "cors";
import "./db.js"; // initializes DB connection


const app = express();

app.use(cors({origin: "http://localhost:8080"}));
app.use(express.json());
app.use("/api", router);

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
