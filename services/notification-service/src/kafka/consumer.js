import { Kafka } from "kafkajs";
import { getLogger } from "../utils/logger.js";

const kafka = new Kafka({
  clientId: "notification-service",
  brokers: (process.env.KAFKA_BROKERS ?? "localhost:9092").split(","),
});

const consumer = kafka.consumer({ groupId: "notification-service-group" });
let isConnected = false;

//lazy connection to use when needed only
export const getConsumer = async () => {
  if (!isConnected) {
    await consumer.connect();
    isConnected = true;
    getLogger().info("Kafka consumer Connected");
  }
  return consumer;
};


