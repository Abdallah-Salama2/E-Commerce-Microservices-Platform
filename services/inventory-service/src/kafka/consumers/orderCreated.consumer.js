import { getConsumer } from "../consumer.js";
import { BaseRepository } from "../../repositories/base.repository.js";
import { getLogger } from "../../utils/logger.js";
import mssql from "mssql";

export const parseMessage = (message) => {
  return JSON.parse(String(message.value));
};
export const handleOrderCreated = async (
  { orderId, items },
  repo = new BaseRepository(),
) => {
  try {
    await repo.execute("reserve_stock_for_order", [
      { name: "OrderId", type: mssql.BigInt, value: orderId },
      {
        name: "OrderItemsJson",
        type: mssql.NVarChar(mssql.MAX),
        value: JSON.stringify(items),
      },
    ]);
    getLogger().info({ orderId }, "order.created processed (reserved, rejected, or already handled)");
  } catch (err) {
    // No special "already processed" branch here — the proc's own
    // processed_orders check handles that silently and cleanly (an early
    // RETURN, not a thrown error). Anything that reaches this catch is a
    // genuine failure: a real SQL error, a deadlock that exhausted
    // BaseRepository's retries, a malformed payload, etc. — always rethrow.
    throw err;
  }
};