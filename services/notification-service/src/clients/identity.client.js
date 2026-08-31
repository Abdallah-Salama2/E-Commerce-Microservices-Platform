// notification-service/src/clients/identity.client.js
import axios from "axios";
import { env } from "../config/env.js";
import { AppError } from "../utils/appError.js";

export const getUserContact = async (userId) => {
  try {
    const response = await axios.get(
      `${env.IDENTITY_SERVICE_URL}/api/internal/users/${userId}/contact`,
      {
        headers: { "x-internal-secret": env.INTERNAL_SERVICE_SECRET },
        timeout: 3000,
      },
    );
    return response.data.data || response.data;
  } catch (err) {
    if (err.code === "ECONNREFUSED" || err.code === "ECONNABORTED") {
      throw new AppError("Identity service is currently unavailable", 503);
    }
    if (err.response) {
      throw new AppError(err.response.data?.message ?? "Contact lookup failed", err.response.status);
    }
    throw err;
  }
};