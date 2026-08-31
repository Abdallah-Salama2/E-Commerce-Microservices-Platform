import jwt from "jsonwebtoken";
import { env } from "../config/env.js";
import { AppError } from "../utils/appError.js";
import { getLogger } from "../utils/logger.js";
//requireAuth
export const authenticate = (req, res, next) => {
  try {
    const authHeader = req.headers?.authorization;

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      throw new AppError("Invalid or missing Token", 401);
    }

    const accessToken = authHeader.split(" ")[1];
    //What happens when you call jwt.verify?
    //If the token is 100% valid:
    // It returns the decoded payload object stored inside the token (e.g., { userId: "4", roles: ["Customer"] }).
    const decodedPayload = jwt.verify(accessToken, env.JWT.ACCESS_SECRET);
    req.user = decodedPayload;

    next();
  } catch (err) {
    // if err catched from above app error
    if (err instanceof AppError) {
      return next(err);
    }

    //     If the token is invalid, expired, or tampered with:
    // It does not return false or null. Instead, it immediately throws an error/exception, interrupting normal code execution!
    // thats why wrap it with try,catch not if condition
    getLogger().error({ err });
    next(new AppError("Invalid or expired token", 401));
  }
};
