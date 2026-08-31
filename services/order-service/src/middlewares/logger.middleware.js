import { randomUUID } from "crypto";
import { baseLogger, requestContext } from "../utils/logger.js";

export const requestLogger = (req, res, next) => {
  const requestId = randomUUID();
  const childLogger = baseLogger.child({ requestId });

  requestContext.run({ logger: childLogger }, () => {
    childLogger.info(
      { method: req.method, url: req.originalUrl },
      "Request received",
    );
    next();
  });
};
