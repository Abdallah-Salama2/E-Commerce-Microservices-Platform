import Redis from "ioredis";
import { env } from "./env.js";

const redis = new Redis({
  host: env.REDIS.HOST, // بيقرأ من الـ env.js بدل process.env
  port: env.REDIS.PORT,
  maxRetriesPerRequest: 3,
});

redis.on("connect", () => console.log("Redis connected"));
redis.on("error", (err) => console.error("Redis error:", err));

export default redis;