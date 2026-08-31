import express from "express";
import cors from "cors";
import helmet from "helmet";
import healthRoutes from "./routes/health.routes.js";
// import { errorHandler } from "./middlewares/errorHandler.middleware.js";
// import { requestLogger } from "./middlewares/logger.middleware.js";

const app = express();

app.use(helmet());
app.use(cors());
app.use(express.json());
// app.use(requestLogger);
app.get("/", (req, res) => {
  res.send("🎮Hello Worlds Notification Service");
}); // No /api/orders, no /api/notifications — this service has nothing for a
// human or frontend to call directly. Its only job is reacting to Kafka
// events in the background; health check exists purely for infra
// (docker-compose's depends_on: condition: service_healthy) to poll.
app.use("/api", healthRoutes);

// app.use(errorHandler);

export default app;
