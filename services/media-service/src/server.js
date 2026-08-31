import app from "./app.js";
import { env } from "./config/env.js";
import { runMigrations } from "./database/scripts/migrate.js"; // Adjust relative path if migrate.js is in ./utils/migrate.js
import { startConsumers } from "./kafka/consumers/index.js";
import { startOutboxPoller } from "./kafka/outboxPoll.js";

async function startServer() {
  try {
    console.log("⏳ Initializing database and running pending migrations...");

    // Automatically creates DB if missing, applies DDL, DML seeds, and Stored Procedures
    await runMigrations();

    app.listen(env.PORT, () => {
      console.log(`🚀 Server running on http://localhost:${env.PORT}`);
    });
    startOutboxPoller();
    startConsumers();
  } catch (error) {
    console.error(
      "💥 Failed to start server due to Database Initialization issue!",
      error,
    );
    process.exit(1);
  }
}

startServer();
