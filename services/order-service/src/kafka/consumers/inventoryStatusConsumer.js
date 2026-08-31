import { clearCartForUser } from "../../clients/cart.client.js";
import { BaseRepository } from "../../repositories/base.repository.js";
import { getLogger } from "../../utils/logger.js";
import mssql from "mssql";

export const parseMessage = (message) => {
  return JSON.parse(String(message.value));
};

export const handleInventoryStatus = async (
  { topic, orderId },
  repo = new BaseRepository(),
) => {
  try {
    if (topic === "inventory.rejected") {
      await repo.execute("transition_order_status_with_event", [
        { name: "Id", type: mssql.BigInt, value: orderId },
        { name: "ExpectedCurrentStatus", type: mssql.NVarChar(20), value: "Pending" },
        { name: "NewStatus", type: mssql.NVarChar(20), value: "Cancelled" },
        { name: "EventType", type: mssql.NVarChar(50), value: "order.cancelled" },
        { name: "UpdatedBy", type: mssql.BigInt, value: null },
      ]);
      return;
    }

    await repo.execute("transition_order_status_with_event", [
      { name: "Id", type: mssql.BigInt, value: orderId },
      { name: "ExpectedCurrentStatus", type: mssql.NVarChar(20), value: "Pending" },
      { name: "NewStatus", type: mssql.NVarChar(20), value: "Processing" },
      { name: "EventType", type: mssql.NVarChar(50), value: "order.confirmed" },
      { name: "UpdatedBy", type: mssql.BigInt, value: null },
    ]);
  } catch (err) {
    if (err.number === 50302) {
      getLogger().info({ orderId }, "inventory status event already processed, skipping");
      return;
    }
    throw err;
  }

  try {
    const orderRows = await repo.execute("get_order_by_id", [
      { name: "Id", type: mssql.BigInt, value: orderId },
      { name: "UserId", type: mssql.BigInt, value: null },
    ]);
    const userId = orderRows[0]?.userId;
    await clearCartForUser(userId);
  } catch (err) {
    getLogger().error({ err, orderId }, "Best-effort cart clear failed after order confirmation");
  }
};