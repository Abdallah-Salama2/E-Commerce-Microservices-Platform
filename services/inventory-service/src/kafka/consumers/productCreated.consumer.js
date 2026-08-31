import { getConsumer } from "../consumer.js";
import { BaseRepository } from "../../repositories/base.repository.js";
import { getLogger } from "../../utils/logger.js";
import mssql from "mssql";

const PK_VIOLATION_ERROR_NUMBER = 2627;

export const parseMessage = (message) => {
  return JSON.parse(String(message.value));
};

export const handleProductCreated = async (
  { productId, initialStock },
  repo = new BaseRepository(),
) => {
  try {
    await repo.execute("insert_initial_stock", [
      { name: "ProductId", type: mssql.BigInt, value: productId },
      { name: "Quantity", type: mssql.Int, value: initialStock },
    ]);
    getLogger().info({ productId, initialStock }, "Stock row created");
  } catch (err) {
    if (err.number === PK_VIOLATION_ERROR_NUMBER) {
      // Redelivered message for a product we've already stocked — no-op.
      getLogger().info({ productId }, "product.created already processed, skipping");
      return;
    }
    throw err; // anything else is a real failure, let it surface
  }
};

