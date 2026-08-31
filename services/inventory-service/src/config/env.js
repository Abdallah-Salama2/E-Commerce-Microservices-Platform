import dotenv from "dotenv";
dotenv.config();

const REQUIRED_ENV_VARS = [
  "PORT",
  "NODE_ENV",
  "DB_USER",
  "DB_PASSWORD",
  "DB_PORT",
  "DB_SERVER",
  "DB_NAME",
  "JWT_ACCESS_SECRET",
];

const missingEnvVars = REQUIRED_ENV_VARS.filter((varName) => {
  const value = process.env[varName];
  return !value || value.trim() === "";
});

if (missingEnvVars.length > 0) {
  console.error("❌ CRITICAL ERROR: Missing required environment variables!");
  console.error(`🔍 Missing Variables: ${missingEnvVars.join(", ")}`);
  console.error(
    "💡 Please check your .env file and ensure all required values are defined.",
  );

  //Will stop the whole server cause not written in async func or try,catch for express to solve
  throw new Error(
    `Environment validation failed. Missing: [${missingEnvVars.join(", ")}]`,
  );
}

console.log("✅ Environment variables validated successfully.");

export const env = {
  PORT: process.env.PORT || 5001,
  NODE_ENV: process.env.NODE_ENV || "development",

  DB: {
    USER: process.env.DB_USER,
    PASSWORD: process.env.DB_PASSWORD,
    SERVER: process.env.DB_SERVER,
    PORT: parseInt(process.env.DB_PORT, 10) || 1450,
    NAME: process.env.DB_NAME,
  },

  JWT: {
    ACCESS_SECRET: process.env.JWT_ACCESS_SECRET,
  },
  REDIS: {
    HOST: process.env.REDIS_HOST || "localhost",
    PORT: parseInt(process.env.REDIS_PORT, 10) || 6379,
  },
};
