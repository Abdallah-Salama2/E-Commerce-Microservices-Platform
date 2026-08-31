import { getConsumer } from "../consumer.js";
import { handleOrderNotification, parseMessage } from "./orderNotification.consumer.js";
import { getLogger } from "../../utils/logger.js";
import { Kafka } from "kafkajs";

export const startConsumers = async () => {
  const consumer = await getConsumer();
  await consumer.subscribe({ topic: "order.confirmed", fromBeginning: true });
  await consumer.subscribe({ topic: "order.cancelled", fromBeginning: true });

  await consumer.run({
    eachMessage: async ({ topic, message }) => {
      try {
        const payload = parseMessage(message);
        if (topic === "order.confirmed" || topic === "order.cancelled") {
          await handleOrderNotification({ topic, ...payload });
        }
      } catch (err) {
        getLogger().error({ err, topic }, "Failed to process message");
      }
    },
  });

  getLogger().info("Notification consumers running");
};


export const setupTopics = async (topics) => {
  // 1. Instantiate the Kafka client (notice the lowercase 'kafka' for the instance)
  const kafka = new Kafka({
    clientId: "admin-topic-creator",
    brokers: [process.env.KAFKA_BROKERS || "kafka:9092"], 
  });

  // 2. Now call admin() on the instance, not the class
  const admin = kafka.admin();
  
  try {
    await admin.connect();
    
    const existingTopics = await admin.listTopics();
    const topicsToCreate = topics
      .filter(topic => !existingTopics.includes(topic))
      .map(topic => ({ topic }));

    if (topicsToCreate.length > 0) {
      await admin.createTopics({ topics: topicsToCreate });
      console.log(`✅ Created missing topics: ${topicsToCreate.map(t => t.topic).join(', ')}`);
    } else {
      console.log(`✅ All required topics already exist.`);
    }
  } catch (error) {
    console.error("💥 Failed to setup topics:", error);
    throw error;
  } finally {
    await admin.disconnect();
  }
};