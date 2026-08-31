// middlewares/rateLimiter.js
import rateLimit from "express-rate-limit";

const makeAuthLimiter = (maxRequests, windowMinutes = 15) => {
  return rateLimit({
    windowMs: windowMinutes * 60 * 1000,
    max: maxRequests,
    message: "Too many requests, please try again later.",
  });
};

export const loginLimiter = makeAuthLimiter(5); 
export const registerLimiter = makeAuthLimiter(10); 
export const forgotPasswordLimiter = makeAuthLimiter(3); 
export const refreshLimiter = makeAuthLimiter(20); // الـ refresh ممكن نديله محاولات أكتر
export const resetPasswordLimiter = makeAuthLimiter(5);
