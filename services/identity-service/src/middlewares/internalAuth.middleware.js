import { AppError } from "../utils/appError.js";
import { env } from "../config/env.js";

// Same pattern as cart-service's internal route — proves "I'm one of our
// own backend services," never a logged-in user. No req.user gets set here.
export const requireInternalSecret = (req, res, next) => {
  const secret = req.headers["x-internal-secret"];
  if (secret !== env.INTERNAL_SERVICE_SECRET) {
    return next(new AppError("Forbidden", 403));
  }
  next();
};