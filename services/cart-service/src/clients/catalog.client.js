import axios from "axios";
import { env } from "../config/env.js";
import { AppError } from "../utils/appError.js";
import { getLogger } from "../utils/logger.js";

/**
 * Fetches batch product details from catalog-service
 * @param {Array<string|number>} productIds
 * @returns {Promise<Array<{id: string, name: string, price: number, isActive: boolean}>>}
 */
export const getProductsByIds = async (productIds) => {
  if (!productIds || productIds.length === 0) return [];

  try {
    const idsQuery = productIds.join(",");
    const response = await axios.get(
      `${env.CATALOG_SERVICE_URL}/api/products/batch`,
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
      { err, productIds },
      "Failed to fetch products from catalog-service",
    );

    if (err.code === "ECONNREFUSED" || err.code === "ECONNABORTED") {
      throw new AppError("Catalog service is currently unavailable", 503);
    }

    if (err.response) {
      // 👈 صلحنا الكومنت لـ catalog-service
      // catalog-service responded with a real error — preserve its
      // status/message instead of letting mapSqlError flatten it to a 500
      throw new AppError(
        err.response.data?.message ?? "Products lookup failed",
        err.response.status,
      );
    }
    throw err;
  }
};
