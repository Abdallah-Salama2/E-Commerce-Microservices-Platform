import { Router } from "express";
import { getPool } from "../config/db.config.js";

const router = Router();

// app.js

router.get("/", async (req, res) => {
  try {
    await getPool();

    return res.status(200).json({
      status: "UP",
      message: "Server is healthy and Database connection is active.",
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    return res.status(503).json({
      status: "DOWN",
      message: "Server is running, but Database connection failed.",
      error: error.message,
      timestamp: new Date().toISOString(),
    });
  }
});


// Liveness Probe: Checks if Express itself is running
router.get("/liveness", (req, res) => {
  return res
    .status(200)
    .json({ status: "UP", timestamp: new Date().toISOString() });
});

// Readiness Probe: Checks if DB can execute queries
router.get("/readiness", async (req, res) => {
  const startTime = Date.now();
  try {
    const pool = await getPool();

    // Execute a real, minimal DB round-trip
    await pool.request().query("SELECT 1 AS alive");

    const latency = `${Date.now() - startTime}ms`;

    return res.status(200).json({
      status: "UP",
      database: "CONNECTED",
      latency,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    return res.status(503).json({
      status: "DOWN",
      database: "DISCONNECTED",
      error: error.message,
      timestamp: new Date().toISOString(),
    });
  }
});
export default router;
