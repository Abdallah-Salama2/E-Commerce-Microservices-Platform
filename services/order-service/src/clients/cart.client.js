import axios from "axios";
import { env } from "../config/env.js";
import { AppError } from "../utils/appError.js";

export const getCart = async (authHeader) => {
  try {
    const response = await axios.get(`${env.CART_SERVICE_URL}/api/cart`, {
      headers: { Authorization: authHeader },
      timeout: 3000,
    });
    if (response.data) return response.data.data || response.data;
  } catch (err) {
    if (err.code === "ECONNREFUSED" || err.code === "ECONNABORTED") {
      throw new AppError("Cart service is currently unavailable", 503);
    }

    if (err.response) {
      // cart-service responded with a real error — preserve its
      // status/message instead of letting mapSqlError flatten it to a 500
      throw new AppError(
        err.response.data?.message ?? "Cart lookup failed",
        err.response.status,
      );
    }
    throw err;
  }
};

export const clearCartForUser = async (userId) => {
  try {
    await axios.post(
      `${env.CART_SERVICE_URL}/api/internal/cart/clear`,
      { userId },
      {
        headers: { "x-internal-secret": env.INTERNAL_SERVICE_SECRET },
        timeout: 3000,
      },
    );
  } catch (err) {
    // Map connection errors to a clean AppError for better logging by the caller
    if (err.code === "ECONNREFUSED" || err.code === "ECONNABORTED") {
      throw new AppError("Cart service is currently unavailable", 503);
    }

    if (err.response) {
      // cart-service responded with a real error — preserve its status/message
      throw new AppError(
        err.response.data?.message ?? "Failed to clear cart",
        err.response.status,
      );
    }

    // Best-effort by design (decision #8) — the CALLER (handleInventoryStatus)
    // is responsible for catching this and logging it without letting it
    // affect the already-confirmed order. This function just reports failure
    // honestly; it doesn't swallow anything itself.
    throw err;
  }
};