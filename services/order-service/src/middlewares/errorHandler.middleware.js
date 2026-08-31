import { getLogger } from "../utils/logger.js";

// errorHandler.middleware.js
export const globalErrorHandler = (err, req, res, next) => {
  if (err.isOperational === true) {
    return res.status(err.statusCode).json({
      success: false,
      message: err.message,
    });
  }

  if (err.type === "entity.parse.failed" || err instanceof SyntaxError) {
    return res
      .status(400)
      .json({ success: false, message: "Malformed JSON in request body." });
  }

  // If not app error log it and send internal server error to client
  getLogger().error({ err }, "Unhandled error reached global handler");

  return res.status(500).json({
    success: false,
    message: "Internal server error.",
  });
};
