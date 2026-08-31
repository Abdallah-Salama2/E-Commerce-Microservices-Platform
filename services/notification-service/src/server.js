import app from "./app.js";
import { env } from "./config/env.js";
import { runMigrations } from "./database/scripts/migrate.js";
import { setupTopics, startConsumers } from "./kafka/consumers/index.js";

async function startServer() {
  try {
    console.log("⏳ Initializing database and running pending migrations...");
    await runMigrations();

    app.listen(env.PORT, () => {
      console.log(`🚀 Server running on http://localhost:${env.PORT}`);
    });

    // No startOutboxPoller() here — this service has no outbox_events
    // table at all, since it never publishes anything downstream.
    await setupTopics(['order.confirmed','order.cancelled'])
    startConsumers();
  } catch (error) {
    console.error("💥 Failed to start server due to Database Initialization issue!", error);
    process.exit(1);
  }
}

startServer();