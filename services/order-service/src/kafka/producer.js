import { Kafka } from "kafkajs";
import { getLogger } from "../utils/logger.js";

const kafka = new Kafka({
  clientId: "order-service",
  brokers: (process.env.KAFKA_BROKERS ?? "localhost:9092").split(","),
});

const producer = kafka.producer();
let isConnected = false;

export const getProducer = async () => {
  if (!isConnected) {
    await producer.connect();
    isConnected = true;
    getLogger().info("Kafka Producer Connected");
  }
  return producer;
};