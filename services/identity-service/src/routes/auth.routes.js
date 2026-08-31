import { Router } from "express";
import {
  forgotPassword,
  getMe,
  login,
  logout,
  refresh,
  register,
  resetPassword,
} from "../controllers/auth.controller.js";
import {
  registerLimiter,
  loginLimiter,
  refreshLimiter,
  forgotPasswordLimiter,
  resetPasswordLimiter,
} from "../middlewares/rateLimiter.middleware.js";
import { validate } from "../middlewares/validate.middleware.js";
import {
  forgotPasswordSchema,
  loginSchema,
  registerSchema,
  resetPasswordSchema,
} from "../validations/auth.validation.js";
import { authenticate } from "../middlewares/auth.middleware.js";

const router = Router();

/**
 * @swagger
 * components:
 *   schemas:
 *     AuthUser:
 *       type: object
 *       description: Shape returned inside data.user by POST /auth/login.
 *       properties:
 *         id: { type: string, example: "8" }
 *         email: { type: string, example: "seed.customer1@example.com" }
 *         firstName: { type: string, example: "Sara" }
 *         lastName: { type: string, example: "Ahmed" }
 *         roles:
 *           type: array
 *           items: { type: string }
 *           example: ["Customer"]
 *         cart:
 *           type: object
 *           nullable: true
 *     TokenClaims:
 *       type: object
 *       description: Decoded JWT access-token payload (req.user).
 *       properties:
 *         userId: { type: string, example: "8" }
 *         roles:
 *           type: array
 *           items: { type: string }
 *           example: ["Customer"]
 *         iat: { type: integer, description: "JWT issued-at" }
 *         exp: { type: integer, description: "JWT expiry" }
 */

/**
 * @swagger
 * /auth/register:
 *   post:
 *     summary: Register a new customer account
 *     description: Rate-limited (10 requests / 15 min / IP). Always creates the user with the "Customer" role.
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [firstName, lastName, email, password]
 *             properties:
 *               firstName: { type: string, minLength: 2, maxLength: 50, example: "Sara" }
 *               lastName: { type: string, minLength: 2, maxLength: 50, example: "Ahmed" }
 *               email: { type: string, format: email, maxLength: 255, example: "sara@example.com" }
 *               password: { type: string, minLength: 8, maxLength: 72, example: "SuperSecret123" }
 *               phone: { type: string, example: "+201234567890" }
 *     responses:
 *       201:
 *         description: User created successfully.
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string, example: "New user created" }
 *                 data: { type: object }
 *       400:
 *         description: Validation error or Email already exists.
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       429:
 *         description: Rate limit exceeded (10 requests / 15 min / IP)
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 */
router.post("/register", registerLimiter, validate(registerSchema), register);
/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: Authenticate with email and password
 *     description: Rate-limited (10 requests / 15 min / IP). Sets an httpOnly refresh-token cookie and returns the access token.
 *     tags: [Auth]
 *     parameters:
 *       - in: cookie
 *         name: guestSessionId
 *         required: false
 *         schema: { type: string, format: uuid }
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [email, password]
 *             properties:
 *               email: { type: string, format: email, maxLength: 255, example: "seed.customer1@example.com" }
 *               password: { type: string, maxLength: 72, example: "Password123" }
 *     responses:
 *       200:
 *         description: Login successful
 *         headers:
 *           Set-Cookie:
 *             schema:
 *               type: string
 *               example: refreshToken=<raw_token>; HttpOnly; SameSite=Strict
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string, example: "Login successful" }
 *                 data:
 *                   type: object
 *                   properties:
 *                     user: { $ref: '#/components/schemas/AuthUser' }
 *                     accessToken: { type: string }
 *       400:
 *         description: Joi validation failure
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       401:
 *         description: Thrown when either the email does not exist or the password is wrong.
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *             example:
 *               success: false
 *               message: "Invalid email or password"
 *       429:
 *         description: Rate limit exceeded (10 requests / 15 min / IP)
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 */
router.post("/login", loginLimiter, validate(loginSchema), login);
/**
 * @swagger
 * /auth/refresh:
 *   post:
 *     summary: Rotate the refresh token and issue a new access token
 *     description: Rate-limited (10 requests / 15 min / IP). Rotates httpOnly refresh cookie.
 *     tags: [Auth]
 *     parameters:
 *       - in: cookie
 *         name: refreshToken
 *         required: true
 *         schema: { type: string }
 *     responses:
 *       200:
 *         description: Token refreshed
 *         headers:
 *           Set-Cookie:
 *             schema:
 *               type: string
 *               example: refreshToken=<new_raw_token>; HttpOnly; SameSite=Strict
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string, example: "Token refreshed" }
 *                 data:
 *                   type: object
 *                   properties:
 *                     accessToken: { type: string }
 *       401:
 *         description: Invalid or revoked refresh token
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       429:
 *         description: Rate limit exceeded (10 requests / 15 min / IP)
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 */
router.post("/refresh", refreshLimiter, refresh);
/**
 * @swagger
 * /auth/logout:
 *   post:
 *     summary: Revoke current refresh token and clear cookie
 *     tags: [Auth]
 *     parameters:
 *       - in: cookie
 *         name: refreshToken
 *         required: false
 *         schema: { type: string }
 *     responses:
 *       200:
 *         description: Logged out successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string, example: "Logged out successfully" }
 *                 data: { type: "null" }
 */
router.post("/logout", logout);

/**
 * @swagger
 * /auth/forgot-password:
 *   post:
 *     summary: Request a password reset email
 *     description: Rate-limited (10 requests / 15 min / IP). Generic 200 response to prevent email enumeration.
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [email]
 *             properties:
 *               email: { type: string, format: email, maxLength: 255, example: "seed.customer1@example.com" }
 *     responses:
 *       200:
 *         description: Reset link sent if email exists
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string, example: "If that email exists, a reset link has been sent" }
 *                 data: { type: "null" }
 *       400:
 *         description: Validation error
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       429:
 *         description: Rate limit exceeded (10 requests / 15 min / IP)
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 */
router.post(
  "/forgot-password",
  forgotPasswordLimiter,
  validate(forgotPasswordSchema),
  forgotPassword,
);

/**
 * @swagger
 * /auth/reset-password:
 *   post:
 *     summary: Reset password using the token from the reset email
 *     description: Rate-limited (10 requests / 15 min / IP).
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required: [token, newPassword]
 *             properties:
 *               token: { type: string, example: "3f9a1c...64chars" }
 *               newPassword: { type: string, minLength: 8, maxLength: 72, example: "NewSuperSecret456" }
 *     responses:
 *       200:
 *         description: Password reset successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success: { type: boolean, example: true }
 *                 message: { type: string, example: "Password reset successfully" }
 *                 data: { type: "null" }
 *       400:
 *         description: Validation error
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       401:
 *         description: Invalid or expired reset token
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 *       429:
 *         description: Rate limit exceeded (10 requests / 15 min / IP)
 *         content:
 *           application/json:
 *             schema: { $ref: '#/components/schemas/ErrorResponse' }
 */
router.post(
  "/reset-password",
  resetPasswordLimiter,
  validate(resetPasswordSchema),
  resetPassword,
);


router.get("/me", authenticate, getMe);

export default router;
