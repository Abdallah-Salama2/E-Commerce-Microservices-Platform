//packages
import express from "express";
import cookieParser from "cookie-parser";
import swaggerUi from "swagger-ui-express";
import { swaggerSpec } from "./config/swagger.config.js";

//utils
import { requestLogger } from "./middlewares/logger.middleware.js";
import { globalErrorHandler } from "./middlewares/errorHandler.middleware.js";

//routes
import healthRouter from "./routes/health.routes.js";
import authRouter from "./routes/auth.routes.js";
import addressRoutes from "./routes/address.routes.js";
import internalRoutes from "./routes/internal.routes.js";

const app = express();

app.use(requestLogger);
app.use(express.json({ limit: "10kb" }));
app.use(express.urlencoded({ extended: true, limit: "10kb" }));
app.use(cookieParser());
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));

app.get("/", (req, res) => {
  res.send("🎮Hello Worlds Identity service");
});

//Api Routes
app.use("/api/health", healthRouter);
app.use("/api/auth", authRouter);
app.use("/api/addresses", addressRoutes);
app.use("/api/internal", internalRoutes);

//Error Handler
app.use(globalErrorHandler);

export default app;
