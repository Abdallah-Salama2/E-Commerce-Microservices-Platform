import jwt from "jsonwebtoken";
import crypto from "crypto";
import { env } from "../config/env.js";

export const GUEST_COOKIE_OPTIONS = {
  httpOnly: true,
  secure: env.NODE_ENV === "production",
  sameSite: "strict",
  maxAge: 30 * 24 * 60 * 60 * 1000, // 30 يوم
};

export const cartOwner = (req, res, next) => {
  // 1. First check: Look for Authorization Header (authenticated user)
  const authHeader = req.headers.authorization;
  if (authHeader && authHeader.startsWith("Bearer ")) {
    const token = authHeader.split(" ")[1];
    try {
      const decoded = jwt.verify(token, env.JWT.ACCESS_SECRET);
      req.user = decoded; // Attach logged-in user data to the request object
      return next();
    } catch (err) {
      // If token is expired or invalid, ignore it and fall back to guest verification
    }
  }

  // 2. Second check: Look for an existing guest cookie
  const guestSessionCookieName = "guestSessionId";
  const existingGuestId = req.cookies?.[guestSessionCookieName];

  if (existingGuestId) {
    req.guestSessionId = existingGuestId;
    req.isNewGuest = false;
    return next();
  }

  // 3. Third check: Completely new guest (no valid token, no cookie)
  // Generate a random ID and attach it to req without sending the cookie to res yet
  req.guestSessionId = crypto.randomUUID();
  req.isNewGuest = true;

  // Optional: If you want to automatically save the cookie here for new guests:
  // res.cookie(guestSessionCookieName, req.guestSessionId, { httpOnly: true, maxAge: 30 * 24 * 60 * 60 * 1000 });
  res.cookie(guestSessionCookieName, req.guestSessionId, GUEST_COOKIE_OPTIONS);
  next();
};
