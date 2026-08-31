import express from "express";
import swaggerUi from "swagger-ui-express";
import { swaggerSpec } from "./config/swagger.config.js";
//utils
import { requestLogger } from "./middlewares/logger.middleware.js";
import { globalErrorHandler } from "./middlewares/errorHandler.middleware.js";

//routes
import healthRouter from "./routes/health.routes.js";
import stockRouter from "./routes/stock.routes.js";


const app = express();

app.use(requestLogger);
app.use(express.json({ limit: "10kb" }));
app.use(express.urlencoded({ extended: true, limit: "10kb" }));
app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec));


app.get("/", (req, res) => {
  res.send("🎮Hello Worlds Stock Service");
});

app.use("/api/health", healthRouter);

app.use("/api/stock",stockRouter)


//Error Handler
app.use(globalErrorHandler);


export default app;