import {
  adjustStockService,
  getStocksByIdsService,
  setStockService,
} from "../services/stock.service.js";
import { AppError, mapSqlError } from "../utils/appError.js";
import { getLogger } from "../utils/logger.js";
import { sendSuccess } from "../utils/response.js";

export const getStocksByIds = async (req, res, next) => {
  try {
    const ids = req.validatedQuery ? req.validatedQuery.ids : req.query.ids;
    const stocks = await getStocksByIdsService(ids);
    return sendSuccess(res, {
      data: stocks,
      message: "Stocks fetched successfully",
    });
  } catch (err) {
    getLogger().error({ err, ids: req.query.ids }, "Failed to fetch stocks");
    next(mapSqlError(err));
  }
};

export const adjustStock = async (req, res, next) => {
  try {
    const productId = req.validatedParams
      ? req.validatedParams.productId
      : req.params.productId;
    const delta = req.validatedBody ? req.validatedBody.delta : req.body.delta;

    const updated = await adjustStockService({ productId, delta });
    return sendSuccess(res, {
      data: updated,
      message: "Stock adjusted successfully",
    });
  } catch (err) {
    getLogger().error(
      { err, productId: req.params.productId, delta: req.body.delta },
      "Failed to adjust stock",
    );
    next(mapSqlError(err));
  }
};
export const setStock = async (req, res, next) => {
  try {
    const productId = req.validatedParams
      ? req.validatedParams.productId
      : req.params.productId;
    const newQuantity = req.validatedBody
      ? req.validatedBody.newQuantity
      : req.body.newQuantity;



    const updated = await setStockService({ productId, newQuantity });
    return sendSuccess(res, {
      data: updated,
      message: "Stock updated successfully",
    });
  } catch (err) {
    getLogger().error(
      {
        err,
        productId: req.params.productId,
        newQuantity: req.body.newQuantity,
      },
      "Failed to update stock",
    );
    next(mapSqlError(err));
  }
};
