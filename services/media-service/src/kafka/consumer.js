import { Kafka } from "kafkajs";
import { getLogger } from "../utils/logger.js";

const kafka = new Kafka({
  clientId: "media-service",
  brokers: (process.env.KAFKA_BROKERS ?? "localhost:9092").split(","),
});

const consumer = kafka.consumer({ groupId: "media-service-group" });
let isConnected = false;

export const getConsumer = async () => {
  if (!isConnected) {
    await consumer.connect();
    isConnected = true;
    getLogger().info("Kafka consumer Connected");
  }
  return consumer;
};