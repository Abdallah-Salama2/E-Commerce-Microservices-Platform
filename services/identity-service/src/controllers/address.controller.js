import {
  createAddressService,
  getAddressesService,
  getAddressByIdService,
} from "../services/address.service.js";
import { AppError, mapSqlError } from "../utils/appError.js";
import { getLogger } from "../utils/logger.js";
import { sendSuccess } from "../utils/response.js";
import { BaseRepository } from "../repositories/base.repository.js";
export const store = async (req, res, next) => {
  try {
    const userId = req.user.userId;
    const {
      label,
      fullName,
      phone,
      line1,
      line2,
      city,
      governorate,
      country,
      postalCode,
      isDefault,
    } = req.body;

    const address = await createAddressService({
      userId,
      label,
      fullName,
      phone,
      line1,
      line2,
      city,
      governorate,
      country,
      postalCode,
      isDefault,
    });

    return sendSuccess(res, {
      status: 201,
      data: address,
      message: "Address created successfully",
    });
  } catch (err) {
    getLogger().error({ err }, "Failed to create address");
    next(mapSqlError(err));
  }
};

export const index = async (req, res, next) => {
  try {
    const addresses = await getAddressesService(req.user.userId);

    return sendSuccess(res, {
      data: addresses,
      message: "Addresses fetched successfully",
    });
  } catch (err) {
    getLogger().error({ err }, "Failed to fetch addresses");
    next(mapSqlError(err));
  }
};

export const show = async (req, res, next) => {
  try {
    const { id } = req.params;
    const address = await getAddressByIdService({
      id,
      userId: req.user.userId,
    });
    if (!address) {
      throw new AppError("No address found", 404);
    }

    return sendSuccess(res, {
      data: address,
      message: "Address fetched successfully",
    });
  } catch (err) {
    getLogger().error({ err }, "Failed to fetch address");
    next(mapSqlError(err));
  }
};
