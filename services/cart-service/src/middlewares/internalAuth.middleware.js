import { AppError } from "../utils/appError.js";
import { env } from "../config/env.js";

// Gatekeeper for service-to-service calls — NOT for logged-in users.
// A regular user never hits routes behind this; only other backend
// services (order-service, currently) do, using a shared secret both
// sides know ahead of time. This is why it checks a static header value
// instead of verifying a JWT like `authenticate` does — there's no user
// session involved here at all, just "prove you're one of our own services."
export const requireInternalSecret = (req, res, next) => {
  const secret = req.headers["x-internal-secret"];

  // Comparing directly against env config, not a database — this secret
  // is a fixed, pre-shared value configured identically in both services'
  // .env files. If it doesn't match, we don't know (or care) who's
  // calling — just refuse.
  if (secret !== env.INTERNAL_SERVICE_SECRET) {
    return next(new AppError("Forbidden", 403));
  }

  next();
};