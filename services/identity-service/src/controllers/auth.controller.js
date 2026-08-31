import { env } from "../config/env.js";
//utils
import { AppError, mapSqlError } from "../utils/appError.js";
import { getLogger } from "../utils/logger.js";
import { sendSuccess } from "../utils/response.js";
//sevice
import {
  createUserService,
  forgotPasswordService,
  getMeService,
  loginService,
  logoutService,
  resetPasswordService,
} from "../services/auth.service.js";
import { refreshTokenService } from "../services/token.service.js";

const REFRESH_COOKIE_OPTIONS = {
  httpOnly: true, // Prevents client-side JS access to mitigate XSS attacks
  secure: env.NODE_ENV === "production", // Enforces HTTPS transmission in production Currently on dev so return false for secure and work with http for local host
  // on production it return true when we change on env so it will work with https with secure = true and cooke wont be send to any request without https
  sameSite: "strict", // Protects against CSRF attacks
};

export const register = async (req, res, next) => {
  try {
    const { email, password, firstName, lastName, phone } = req.body;
    const newUser = await createUserService({
      email,
      password,
      firstName,
      lastName,
      phone,
    });

    return sendSuccess(res, {
      status: 201,
      data: newUser,
      message: "New user created",
    });
  } catch (err) {
    getLogger().error({ err }, "User registration failed");
    next(mapSqlError(err));
  }
};

export const login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    const guestSessionId = req.cookies?.guestSessionId ?? null;

    const { user, accessToken, refreshToken, cart } = await loginService({
      email,
      password,
      guestSessionId: guestSessionId,
    });

    const cookieMaxAge =
      Number(env.JWT.REFRESH_EXPIRES_IN_DAYS) * 24 * 60 * 60 * 1000;

    res.cookie(env.JWT.REFRESH_COOKIE_NAME, refreshToken, {
      ...REFRESH_COOKIE_OPTIONS,
      maxAge: cookieMaxAge,
    });

    // if (guestSessionId) {
    //   res.clearCookie("guestSessionId", GUEST_COOKIE_OPTIONS);
    // }

    return sendSuccess(res, {
      message: "Login successful",
      data: {
        user,
        cart,
        accessToken,
      },
    });
  } catch (err) {
    getLogger().error({ err }, "User login failed");
    next(mapSqlError(err));
  }
};

export const refresh = async (req, res, next) => {
  try {
    const rawRefreshToken = req.cookies?.[env.JWT.REFRESH_COOKIE_NAME];

    const { accessToken, refreshToken } =
      await refreshTokenService(rawRefreshToken);

    const cookieMaxAge =
      Number(env.JWT.REFRESH_EXPIRES_IN_DAYS) * 24 * 60 * 60 * 1000;

    res.cookie(env.JWT.REFRESH_COOKIE_NAME, refreshToken, {
      ...REFRESH_COOKIE_OPTIONS,
      maxAge: cookieMaxAge,
    });

    return sendSuccess(res, {
      message: "Token refreshed",
      data: { accessToken },
    });
  } catch (err) {
    getLogger().error({ err }, "Token refresh failed");
    next(mapSqlError(err));
  }
};

export const logout = async (req, res, next) => {
  try {
    const rawRefreshToken = req.cookies?.[env.JWT.REFRESH_COOKIE_NAME];

    await logoutService(rawRefreshToken);

    res.clearCookie(env.JWT.REFRESH_COOKIE_NAME, REFRESH_COOKIE_OPTIONS);

    return sendSuccess(res, {
      message: "Logged out successfully",
      data: null,
    });
  } catch (err) {
    getLogger().error({ err }, "User logout failed");
    next(mapSqlError(err));
  }
};

export const forgotPassword = async (req, res, next) => {
  try {
    const { email } = req.body;
    if (!email) {
      return next(new AppError("Email is required.", 400));
    }

    await forgotPasswordService(email);

    return sendSuccess(res, {
      message: "If that email exists, a reset link has been sent",
      data: null,
    });
  } catch (err) {
    getLogger().error({ err }, "Forgot password request failed");
    next(mapSqlError(err));
  }
};

export const resetPassword = async (req, res, next) => {
  try {
    const { token, newPassword } = req.body;
    if (!token || !newPassword) {
      return next(new AppError("Token and new password are required", 400));
    }
    const result = await resetPasswordService(token, newPassword);

    return sendSuccess(res, {
      message: "Password reset successfully",
      data: result,
    });
  } catch (err) {
    getLogger().error({ err }, "Reset password failed");
    next(mapSqlError(err));
  }
};

// auth.controller.js — add
export const getMe = async (req, res, next) => {
  try {
    const userId = req.user.userId;
    const user = await getMeService(userId);
    return sendSuccess(res, { data: { user } });
  } catch (err) {
    next(mapSqlError(err));
  }
};
