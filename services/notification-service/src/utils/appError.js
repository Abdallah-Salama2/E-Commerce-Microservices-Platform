export class AppError extends Error {
  constructor(message, statusCode, isOperational) {
    super(message); //this.message =message ?
    this.statusCode = statusCode;
    this.isOperational = isOperational ?? true;

    //"The presence of this line tells Node.js: 'Completely ignore the AppError class,
    // and start the stack trace from the actual place where new AppError was called
    // (such as the Controller or the Service).
    Error.captureStackTrace(this, this.constructor);
    //     When logging the error using Pino:
    // Without the line: The stack trace points to appError.js:5 (which is unhelpful
    // because you already know the class works).

    // With the line: The stack trace points directly to auth.service.js:42
    // (the line that actually caused the issue in the business logic).
  }
}

const SQL_ERROR_MAP = {
  1205: {
    message:
      "This action conflicted with another request in progress. Please try again.",
    statusCode: 409,
  },
  50301: { message: "Order not found.", statusCode: 404 },
  50302: {
    message:
      "Order status has changed since it was last read. Please refresh and try again.",
    statusCode: 409,
  },
  // 50202, 50203, 50304 removed — cart/inventory-domain codes, never thrown
  // by any order-service SP; leftover from copy-pasting another service's map
};
export function mapSqlError(err) {
  if (err instanceof AppError) {
    return err;
  }

  const mapped = SQL_ERROR_MAP[err.number];
  if (mapped) return new AppError(mapped.message, mapped.statusCode);

  return new AppError("Internal server error", 500);
}
