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

  "SMTP_HOST",
  "SMTP_PORT",
  "SMTP_USER",
  "SMTP_PASSWORD",
  "SMTP_FROM",

  "IDENTITY_SERVICE_URL",
  "INTERNAL_SERVICE_SECRET",
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
  NODE_ENV: process.env.NODE_ENV,
  PORT: process.env.PORT,

  DB: {
    SERVER: process.env.DB_SERVER,
    USER: process.env.DB_USER,
    PASSWORD: process.env.DB_PASSWORD,
    NAME: process.env.DB_NAME,
    PORT: parseInt(process.env.DB_PORT, 10) || 1450,
  },

  KAFKA_BROKERS: process.env.KAFKA_BROKERS,

  IDENTITY_SERVICE_URL: process.env.IDENTITY_SERVICE_URL,
  INTERNAL_SERVICE_SECRET: process.env.INTERNAL_SERVICE_SECRET,

  SMTP: {
    HOST: process.env.SMTP_HOST,
    PORT: Number(process.env.SMTP_PORT) || 587,
    USER: process.env.SMTP_USER,
    PASSWORD: process.env.SMTP_PASSWORD,
    FROM: process.env.SMTP_FROM,
  },
};
