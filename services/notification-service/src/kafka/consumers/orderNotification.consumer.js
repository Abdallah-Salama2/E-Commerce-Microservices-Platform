// notification-service/src/kafka/consumers/orderNotification.consumer.js
import mssql from "mssql";
import { BaseRepository } from "../../repositories/base.repository.js";
import { getLogger } from "../../utils/logger.js";
import { getUserContact } from "../../clients/identity.client.js";
import { sendOrderConfirmedEmail, sendOrderCancelledEmail } from "../../config/mailer.config.js";

const UNIQUE_VIOLATION_ERROR_NUMBER = 2627;

export const parseMessage = (message) => {
  return JSON.parse(String(message.value));
};

export const handleOrderNotification = async (
  { topic, orderId, userId },
  repo = new BaseRepository(),
) => {
  const contact = await getUserContact(userId);

  if (topic === "order.confirmed") {
    await sendOrderConfirmedEmail(contact.email, orderId);
  } else if (topic === "order.cancelled") {
    await sendOrderCancelledEmail(contact.email, orderId);
  }

  try {
    await repo.execute("insert_notification_log", [
      { name: "OrderId", type: mssql.BigInt, value: orderId },
      { name: "EventType", type: mssql.NVarChar(50), value: topic },
    ]);
  } catch (err) {
    if (err.number === UNIQUE_VIOLATION_ERROR_NUMBER) {
      getLogger().info({ orderId, topic }, "Notification already logged, skipping duplicate log");
      return;
    }
    throw err;
  }
};