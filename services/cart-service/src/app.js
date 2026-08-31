import express from "express";
import cookieParser from "cookie-parser";
import { requestLogger } from "./middlewares/logger.middleware.js";
import { globalErrorHandler } from "./middlewares/errorHandler.middleware.js";

import healthRouter from "./routes/health.routes.js";
import cartRouter from "./routes/cart.routes.js";
import internalRouter from "./routes/internal.routes.js";

const app = express();

app.use(requestLogger);
app.use(express.json({ limit: "10kb" }));
app.use(cookieParser());

app.use("/api/health", healthRouter);
app.use("/api/cart", cartRouter);
app.use("/api/internal", internalRouter);
app.use(globalErrorHandler);

export default app;
