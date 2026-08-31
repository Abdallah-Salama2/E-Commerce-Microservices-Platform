// kafka/consumers/index.js
import { getConsumer } from "../consumer.js";

import { getLogger } from "../../utils/logger.js";
import {
  handleInventoryStatus,
  parseMessage,
} from "./inventoryStatusConsumer.js";

export const startConsumers = async () => {
  const consumer = await getConsumer();
  await consumer.subscribe({
    topic: "inventory.reserved",
    fromBeginning: true,
  });
  await consumer.subscribe({
    topic: "inventory.rejected",
    fromBeginning: true,
  });

  await consumer.run({
    eachMessage: async ({ topic, message }) => {
      try {
        const payload = parseMessage(message);
        if (topic === "inventory.reserved" || topic === "inventory.rejected") {
          await handleInventoryStatus({ topic, ...payload });
        }
      } catch (err) {
        getLogger().error({ err, topic }, "Failed to process message");
        if (err instanceof SyntaxError) {
          getLogger().warn(
            { topic },
            "Poison pill detected (malformed message), skipping.",
          );
          return; // بنخرج من غير throw عشان كاڤكا يعديها
        }
        throw err;
      }
    },
  });

  getLogger().info("Order consumers running");
};
