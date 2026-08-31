import { BaseRepository } from "../repositories/base.repository.js";
import mssql from "mssql";
import { getProducer } from "./producer.js";
import { getLogger } from "../utils/logger.js";

const POLL_INTERVAL_MS = Number(process.env.OUTBOX_POLL_INTERVAL_MS ?? 2000);
let isPolling = false;

export const groupByEventType = (rows) => {
  const groups = new Map();
  for (const row of rows) {
    if (!groups.has(row.event_type)) {
      groups.set(row.event_type, []);
    }
    groups.get(row.event_type).push(row);
  }
  return groups;
};

// Keyed by imageId — media-service's outbox rows (image.uploaded,
// image.processed) both describe something about one image, same
// reasoning as order-service keying by orderId.
export const toMessage = (row) => {
  const parsedRow = JSON.parse(row.payload);
  return {
    key: String(parsedRow.imageId),
    value: row.payload,
  };
};

export const toTopicMessages = (groups) => {
  return Array.from(groups).map(([eventType, rowsForThisType]) => ({
    topic: eventType,
    messages: rowsForThisType.map(toMessage),
  }));
};

export const pollOnce = async (repo = new BaseRepository()) => {
  const rows = await repo.execute("get_unpublished_outbox_events", [
    { name: "BatchSize", type: mssql.Int, value: 50 },
  ]);
  if (rows.length === 0) return;

  const groups = groupByEventType(rows);
  const topicMessages = toTopicMessages(groups);
  const producer = await getProducer();

  try {
    await producer.sendBatch({ topicMessages });
  } catch (err) {
    getLogger().error({ err }, "failed to send topic messages");
    return;
  }

  const ids = rows.map((r) => r.id).join(",");
  await repo.execute("mark_outbox_events_published", [
    { name: "Ids", type: mssql.NVarChar(mssql.MAX), value: ids },
  ]);
};

export const startOutboxPoller = () => {
  setInterval(async () => {
    if (isPolling) return;
    isPolling = true;
    try {
      await pollOnce();
    } catch (err) {
      getLogger().error({ err }, "outbox poll cycle failed");
    } finally {
      isPolling = false;
    }
  }, POLL_INTERVAL_MS);

  getLogger().info({ intervalMs: POLL_INTERVAL_MS }, "outbox poller started");
};