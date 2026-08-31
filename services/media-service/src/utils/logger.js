import pino from "pino";
import { AsyncLocalStorage } from "async_hooks";

export const baseLogger = pino({
  level: process.env.LOG_LEVEL || "info",
  transport:
    process.env.NODE_ENV !== "production"
      ? {
          target: "pino-pretty",
          // pino-pretty is a separate transform stream that takes that JSON and renders it as colorized,
          // multi-line, human-friendly text.
          // It's a dev tool only — you never want it in production,
          //  because it adds CPU overhead per log line and produces output that's harder to parse programmatically
          // than raw JSON.
          options: { colorize: true, translateTime: "SYS:standard" },
        }
      : undefined,
  redact: {
    paths: [
      "req.headers.authorization",
      "headers.authorization",
      "req.headers.cookie",
      "headers.cookie",
      "*.password",
      "*.refreshToken",
      "body.password",
    ],
    censor: "[REDACTED]",
  },
});
export const requestContext = new AsyncLocalStorage();

export const getLogger = () => {
  const store = requestContext.getStore();
  return store?.logger ?? baseLogger; // fallback for startup/cron/scripts
};
