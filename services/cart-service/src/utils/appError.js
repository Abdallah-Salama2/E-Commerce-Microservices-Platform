export class AppError extends Error {
  constructor(message, statusCode, isOperational) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = isOperational ?? true;
    Error.captureStackTrace(this, this.constructor);
  }
}
 