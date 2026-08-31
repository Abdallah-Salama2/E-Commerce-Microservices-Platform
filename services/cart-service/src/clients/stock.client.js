import axios from "axios";
import { env } from "../config/env.js";
import { AppError } from "../utils/appError.js";
import { getLogger } from "../utils/logger.js";

export const getStocksByIds = async (ids) => {
  if (!ids || ids.length === 0) return [];

  try {
    const idsQuery = ids.join(",");
    const response = await axios.get(
      `${env.INVENTORY_SERVICE_URL}/api/stock/batch`,
      {
        params: { ids: idsQuery },
        timeout: 3000, // 3s timeout to avoid hanging cart requests
      },
    );

    // Expecting response.data.data or response.data based on sendSuccess helper
    return response.data.data || response.data;
  } catch (err) {
    // 👈 استبدلنا console.log بالـ Logger
    getLogger().error(
      { err, ids },
      "Failed to fetch stock from inventory-service",
    );

    if (err.code === "ECONNREFUSED" || err.code === "ECONNABORTED") {
      throw new AppError("Inventory service is currently unavailable", 503);
    }

    if (err.response) {
      // 👈 صلحنا الكومنت لـ inventory-service
      // inventory-service responded with a real error — preserve its
      // status/message instead of letting mapSqlError flatten it to a 500
      throw new AppError(
        err.response.data?.message ?? "Stock lookup failed",
        err.response.status,
      );
    }
    throw err;
  }
};
