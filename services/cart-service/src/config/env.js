import dotenv from "dotenv";
dotenv.config();

const REQUIRED_ENV_VARS = ["REDIS_HOST", "REDIS_PORT", "JWT_ACCESS_SECRET"];

const missing = REQUIRED_ENV_VARS.filter((v) => !process.env[v]?.trim());
if (missing.length > 0) {
  console.error(
    `❌ Missing required environment variables: ${missing.join(", ")}`,
  );
  throw new Error(
    `Environment validation failed. Missing: [${missing.join(", ")}]`,
  );
}

export const env = {
  PORT: process.env.PORT || 5003,
  NODE_ENV: process.env.NODE_ENV || "development",
  REDIS: {
    HOST: process.env.REDIS_HOST,
    PORT: Number(process.env.REDIS_PORT),
  },

  JWT: {
    ACCESS_SECRET: process.env.JWT_ACCESS_SECRET,
  },


  CATALOG_SERVICE_URL:
    process.env.CATALOG_SERVICE_URL || "http://localhost:5001",
  INVENTORY_SERVICE_URL:
    process.env.INVENTORY_SERVICE_URL || "http://localhost:5002",
  INTERNAL_SERVICE_SECRET: process.env.INTERNAL_SERVICE_SECRET,
};
