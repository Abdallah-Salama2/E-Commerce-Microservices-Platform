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
  "BCRYPT_SALT_ROUNDS",
  "JWT_ACCESS_SECRET",
  "JWT_ACCESS_EXPIRES_IN",
  "JWT_REFRESH_SECRET",
  "REFRESH_COOKIE_NAME",
  "CART_SERVICE_URL",
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
  PORT: process.env.PORT || 5000,
  NODE_ENV: process.env.NODE_ENV || "development",
  BCRYPT_SALT_ROUNDS: parseInt(process.env.BCRYPT_SALT_ROUNDS, 10) || 10,
  JWT: {
    ACCESS_SECRET: process.env.JWT_ACCESS_SECRET,
    REFRESH_SECRET: process.env.JWT_REFRESH_SECRET,
    ACCESS_EXPIRES_IN: process.env.JWT_ACCESS_EXPIRES_IN || "15m",
    REFRESH_EXPIRES_IN_DAYS: process.env.JWT_REFRESH_EXPIRES_IN_DAYS || 30,
    REFRESH_COOKIE_NAME: process.env.REFRESH_COOKIE_NAME || "refreshToken",
  },
  DB: {
    USER: process.env.DB_USER,
    PASSWORD: process.env.DB_PASSWORD,
    SERVER: process.env.DB_SERVER,
    PORT: parseInt(process.env.DB_PORT, 10) || 1450,
    NAME: process.env.DB_NAME,
  },
  SMTP: {
    HOST: process.env.SMTP_HOST,
    PORT: Number(process.env.SMTP_PORT) || 587,
    USER: process.env.SMTP_USER,
    PASSWORD: process.env.SMTP_PASSWORD,
    FROM: process.env.SMTP_FROM || process.env.SMTP_USER,
  },
  CART_SERVICE_URL: process.env.CART_SERVICE_URL,
  INTERNAL_SERVICE_SECRET: process.env.INTERNAL_SERVICE_SECRET,
};
