// kafka/consumers/index.js — add the subscription + handler, and while
// this file's being touched, apply the same poison-pill-only fix
// order-service's version already got, replacing the old swallow-all catch.
import { getConsumer } from "../consumer.js";
import { handleProductCreated, parseMessage } from "./productCreated.consumer.js";
import { handleOrderCreated } from "./orderCreated.consumer.js";
import { handleStockReleaseRequested } from "./stockRelease.consumer.js";
import { getLogger } from "../../utils/logger.js";
import { Kafka } from "kafkajs";

export const startConsumers = async () => {
  const consumer = await getConsumer();
  await consumer.subscribe({ topic: "product.created", fromBeginning: true });
  await consumer.subscribe({ topic: "order.created", fromBeginning: true });
  await consumer.subscribe({ topic: "order.stock_release_requested", fromBeginning: true });

  await consumer.run({
    eachMessage: async ({ topic, message }) => {
      try {
        const payload = parseMessage(message);
        if (topic === "product.created") await handleProductCreated(payload);
        else if (topic === "order.created") await handleOrderCreated(payload);
        else if (topic === "order.stock_release_requested") await handleStockReleaseRequested(payload);
      } catch (err) {
        getLogger().error({ err, topic }, "Failed to process message");
        if (err instanceof SyntaxError) {
          getLogger().warn({ topic }, "Poison pill detected (malformed message), skipping.");
          return;
        }
        throw err; // genuine failures propagate so Kafka redelivers
      }
    },
  });

  getLogger().info("Inventory consumers running");
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