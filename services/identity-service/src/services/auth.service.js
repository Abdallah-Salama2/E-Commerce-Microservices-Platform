//packages
import mssql from "mssql";
import bcrypt from "bcryptjs";
import crypto from "crypto";
//utils
import { AppError } from "../utils/appError.js";
import { BaseRepository } from "../repositories/base.repository.js";
import { env } from "../config/env.js";
//service
import {
  generateAccessToken,
  generateRefreshToken,
  getUserRolesByUserIdService,
  hashToken,
} from "./token.service.js";

import { sendPasswordResetEmail } from "../config/mailer.config.js";
import axios from "axios";
import { getLogger } from "../utils/logger.js";

const saltRounds = Number(env.BCRYPT_SALT_ROUNDS);

/**
 * Creates a new user record in the database with a hashed password and default "Customer" role.
 *
 * @param {Object} params - User registration details.
 * @param {string} params.email - User's email address.
 * @param {string} params.password - Plain-text password to be hashed.
 * @param {string} params.firstName - User's first name.
 * @param {string} params.lastName - User's last name.
 * @param {string} [params.phone] - Optional phone number.
 * @returns {Promise<Object>} Result of the database insertion procedure.
 */
export const createUserService = async ({
  email,
  password,
  firstName,
  lastName,
  phone,
}) => {
  // 2️⃣ Hashing password before sending it
  const passwordHash = await bcrypt.hash(password, saltRounds);

  const repo = new BaseRepository();
  const result = await repo.execute("create_user", [
    { name: "Email", type: mssql.NVarChar(255), value: email },
    { name: "PasswordHash", type: mssql.NVarChar(255), value: passwordHash },
    { name: "FirstName", type: mssql.NVarChar(100), value: firstName },
    { name: "LastName", type: mssql.NVarChar(100), value: lastName },
    { name: "Phone", type: mssql.NVarChar(20), value: phone || null },
    { name: "RoleName", type: mssql.NVarChar(20), value: "Customer" },
  ]);

  return result;
};

/**
 * Authenticates user credentials and generates access and refresh tokens upon success.
 *
 * @param {Object} params - Credentials payload.
 * @param {string} params.email - User's registered email address.
 * @param {string} params.password - User's plain-text password to verify.
 * @returns {Promise<Object>} Object containing sanitized user profile data, access token, and refresh token.
 * @throws {AppError} 401 - If email does not exist or password is invalid.
 */
export const loginService = async ({ email, password, guestSessionId }) => {
  const repo = new BaseRepository();
  const userResult = await repo.execute("get_user_by_email", [
    { name: "Email", type: mssql.NVarChar(255), value: email },
  ]);

  const user = userResult?.[0];
  if (!user) {
    throw new AppError("Invalid email or password", 401);
  }

  const isPasswordValid = await bcrypt.compare(password, user.password_hash);

  if (!isPasswordValid) {
    throw new AppError("Invalid email or password", 401);
  }

  const roles = await getUserRolesByUserIdService(user.id);
  const accessToken = generateAccessToken(user.id, roles);
  const rawRefreshToken = await generateRefreshToken(user.id);

  let cart = null;
  if (guestSessionId) {
    try {
      cart = await mergeCart(user.id, guestSessionId);
    } catch (err) {
      getLogger().error(
        { err, userId: user.id },
        "Guest cart merge failed during login",
      );
    }
  }
  return {
    user: {
      id: user.id,
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      roles: roles,
    },
    accessToken: accessToken,
    cart: cart
      ? {
          success: cart.success,
          data: cart.data,
          message: cart.message,
        }
      : null,
    refreshToken: rawRefreshToken,
  };
};

/**
 * Revokes a given refresh token to invalidate the user session during logout.
 *
 * @param {string|null} rawRefreshToken - Raw refresh token from the request cookie/body.
 * @returns {Promise<void>}
 */
export const logoutService = async (rawRefreshToken) => {
  // If no refresh token cookie is present, resolve early without error
  // since the user is practically already logged out.
  if (!rawRefreshToken) {
    return;
  }

  const repo = new BaseRepository();

  // 1. Hash the raw token using SHA-256 (matching the login hashing mechanism)
  const tokenHash = hashToken(rawRefreshToken);

  // 2. Query the database to find the token record
  const result = await repo.execute("get_refresh_token_by_hash", [
    { name: "TokenHash", type: mssql.NVarChar(255), value: tokenHash },
  ]);

  const row = result?.[0];

  // 3. Revoke this specific token if it exists and hasn't been revoked yet
  if (row && !row.revoked_at) {
    await repo.execute("revoke_refresh_token", [
      { name: "OldTokenId", type: mssql.BigInt, value: row.id },
      { name: "NewTokenId", type: mssql.BigInt, value: null }, // Pass null as no new token replaces it during logout
    ]);
  }
};

/**
 * Handles password reset requests by generating a temporary token and emailing it to the user.
 *
 * @param {string} email - The email address requesting a password reset.
 * @returns {Promise<void>}
 * @throws {AppError} 401 - If no account is registered under the provided email address.
 */
export const forgotPasswordService = async (email) => {
  const repo = new BaseRepository();

  const userResult = await repo.execute("get_user_by_email", [
    { name: "Email", type: mssql.NVarChar(50), value: email },
  ]);

  const user = userResult[0];

  if (!user) {
    // throw new AppError("No user exists with this email", 401);
    return;
  }

  const resetToken = crypto.randomBytes(32).toString("hex");
  const tokenHash = hashToken(resetToken);
  const expiresAt = new Date(Date.now() + 15 * 60 * 1000);

  await repo.execute("create_password_reset_tokens", [
    { name: "UserId", type: mssql.BigInt, value: user.id },
    { name: "TokenHash", type: mssql.NVarChar(255), value: tokenHash },
    { name: "ExpiresAt", type: mssql.DateTime2, value: expiresAt },
  ]);

  await sendPasswordResetEmail(user.email, resetToken);
};

/**
 * Resets a user's password using a valid reset token and hashes the new password.
 *
 * @param {string} resetToken - Raw password reset token received via user's email.
 * @param {string} newPassword - Plain-text replacement password.
 * @returns {Promise<{message: string}>} Confirmation message indicating successful reset.
 */
export const resetPasswordService = async (resetToken, newPassword) => {
  const tokenHash = hashToken(resetToken);
  const repo = new BaseRepository();
  const passwordHash = await bcrypt.hash(newPassword, saltRounds);

  const rows = await repo.execute("reset_password", [
    { name: "TokenHash", type: mssql.NVarChar(255), value: tokenHash },
    { name: "NewPasswordHash", type: mssql.NVarChar(255), value: passwordHash },
  ]);
  return rows[0];
};

const mergeCart = async (userId, guestSessionId) => {
  try {
    const response = await axios.post(
      `${env.CART_SERVICE_URL}/api/cart/merge`,
      { userId: userId, guestSessionId: guestSessionId },
      { timeout: 5000 },
    );
    return response.data;
  } catch (err) {
    console.log(err);
    if (err.code === "ECONNREFUSED" || err.code === "ECONNABORTED") {
      throw new AppError("Cart service is currently unavailable", 503);
    }
    throw err;
  }
};

// auth.service.js — add
export const getMeService = async (userId, repo = new BaseRepository()) => {
  const rows = await repo.execute("get_user_by_id", [
    { name: "Id", type: mssql.BigInt, value: userId },
  ]);
  if (!rows[0]) {
    throw new AppError("User not found.", 404);
  }
  return rows[0];
};
