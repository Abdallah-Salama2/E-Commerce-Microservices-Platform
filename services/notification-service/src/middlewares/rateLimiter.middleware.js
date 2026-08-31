// middlewares/rateLimiter.js
import rateLimit from "express-rate-limit";

export const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 min
  max: 1000, // 10 tries for every ip every 15 min
  message: {
    success: false,
    message: "Too many attempts. Please try again later.",
  },
  standardHeaders: true, // بيرجع RateLimit-* headers في الـ response
  legacyHeaders: false, // بيمنع الـ X-RateLimit-* القديمة (مبقتش لازمة)
});

export const checkoutLimiter = rateLimit({
  windowMs: 10 * 60 * 1000, // 10 min
  max: 10000, //larger window for checkout
  message: {
    success: false,
    message: "Too many checkout attempts. Please slow down.",
  },
  standardHeaders: true,
  legacyHeaders: false,
});
