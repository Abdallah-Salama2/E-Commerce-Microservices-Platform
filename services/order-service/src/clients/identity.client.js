// order-service/src/clients/identity.client.js
import axios from "axios";
import { env } from "../config/env.js";
import { AppError } from "../utils/appError.js";

export const getAddressById = async (addressId, authHeader) => {
  try {
    const response = await axios.get(
      `${env.IDENTITY_SERVICE_URL}/api/addresses/${addressId}`,
      { headers: { Authorization: authHeader }, timeout: 3000 },
    );
    return response.data.data || response.data;
  } catch (err) {
    if (err.code === "ECONNREFUSED" || err.code === "ECONNABORTED") {
      throw new AppError("Identity service is currently unavailable", 503);
    }

    if (err.response) {
      // identity-service responded with a real error — preserve its
      // status/message instead of letting mapSqlError flatten it to a 500
      throw new AppError(
        err.response.data?.message ?? "Address lookup failed",
        err.response.status,
      );
    }
    // identity-service's own get_address_by_id proc should 404 if the
    // address doesn't belong to this user — let that surface as-is
    // rather than masking it as a 503
    throw err;
  }
};
