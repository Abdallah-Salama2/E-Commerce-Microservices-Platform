import { Router } from "express";
import redis from "../config/redis.config.js";

const router = Router();

router.get("/", async (req, res) => {
  try {
    let ping = await redis.ping();
    return res.status(200).json({
      status: "UP",
      message: `Server is healthy and Redis connection is active. ${ping}`,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    return res.status(503).json({
      status: "DOWN",
      message: "Server is running, but Redis connection failed.",
      error: error.message,
      timestamp: new Date().toISOString(),
    });
  }
});

export default router;
