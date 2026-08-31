// kafka/consumers/stockRelease.consumer.js
import { BaseRepository } from "../../repositories/base.repository.js";
import { getLogger } from "../../utils/logger.js";
import mssql from "mssql";

export const parseMessage = (message) => JSON.parse(String(message.value));

export const handleStockReleaseRequested = async (
  { orderId, items },
  repo = new BaseRepository(),
) => {
  await repo.execute("release_stock_for_order", [
    { name: "OrderId", type: mssql.BigInt, value: orderId },
    { name: "OrderItemsJson", type: mssql.NVarChar(mssql.MAX), value: JSON.stringify(items) },
  ]);
  getLogger().info({ orderId }, "order.stock_release_requested processed (released or already handled)");
};