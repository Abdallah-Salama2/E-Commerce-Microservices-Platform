// media-service/src/kafka/consumers/index.js
import { getConsumer } from "../consumer.js";
import { handleImageUploaded, parseMessage } from "./imageUploaded.consumer.js";
import { getLogger } from "../../utils/logger.js";

export const startConsumers = async () => {
  const consumer = await getConsumer();
  await consumer.subscribe({ topic: "image.uploaded", fromBeginning: true });

  await consumer.run({
    eachMessage: async ({ topic, message }) => {
      try {
        const payload = parseMessage(message);
        if (topic === "image.uploaded") {
          await handleImageUploaded(payload);
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
  getLogger().info("Media consumers running");
};
