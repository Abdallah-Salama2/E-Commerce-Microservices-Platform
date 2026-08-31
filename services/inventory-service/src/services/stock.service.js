import { BaseRepository } from "../repositories/base.repository.js";
import { AppError } from "../utils/appError.js";
import { getLogger } from "../utils/logger.js";
import mssql from "mssql";

export const getStocksByIdsService = async (
  ids,
  repo = new BaseRepository(),
) => {
  if (!ids || ids.trim() === "") return [];
  const rows = await repo.execute("get_stocks_by_ids", [
    { name: "Ids", type: mssql.NVarChar(mssql.MAX), value: ids },
  ]);

  return rows;
};

export const adjustStockService = async (
  { productId, delta },
  repo = new BaseRepository(),
) => {
  const rows = await repo.execute("adjust_stock_quantity", [
    { name: "ProductId", type: mssql.BigInt, value: productId },
    { name: "Delta", type: mssql.Int, value: delta },
  ]);
  return rows[0];
};
export const setStockService = async (
  { productId, newQuantity },
  repo = new BaseRepository(),
) => {
  const rows = await repo.execute("set_stock_quantity", [
    { name: "ProductId", type: mssql.BigInt, value: productId },
    { name: "NewQuantity", type: mssql.Int, value: newQuantity },
  ]);
  return rows[0];
};
