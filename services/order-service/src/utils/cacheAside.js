import redis from "../config/redis.config.js";
import { getLogger } from "./logger.js";

/**
 * Cache-aside read-through helper. Redis failures (read OR write) never
 * break the caller's request -- they degrade to "just hit SQL Server",
 * the same guarantee the monolith's original cacheAsideRead/cacheAsideWrite
 * helpers made explicit. A cache is optional infrastructure; its own
 * failure should never be more disruptive than a slightly slower response.
 *
 * Note what's deliberately UNCHANGED: if fetchFn() itself throws (e.g. a
 * 404 AppError from "product not found"), that's a real business-logic
 * error, not a cache problem -- it's intentionally left OUTSIDE any
 * try/catch here so it propagates straight to the caller, same as before.
 */
export const getOrSetCache = async (key, fetchFn, baseTtlSeconds = 300) => {
  try {
    const cachedData = await redis.get(key);
    if (cachedData) {
      return JSON.parse(cachedData);
    }
  } catch (err) {
    getLogger().error({ err, key }, "Cache read failed, falling through to source");
  }

  // Cache miss OR cache read failed -- either way, go to the real source.
  const sqlServerData = await fetchFn();

  if (sqlServerData !== null && sqlServerData !== undefined) {
    try {
      // Jitter (0-30s) staggers when different keys expire relative to
      // each other, reducing clustered cache-repopulation load. Note this
      // does NOT protect against many concurrent requests all missing the
      // SAME key at the same instant (a "thundering herd" on one hot key)
      // -- that's a different problem, solved with a lock/single-flight
      // pattern if it's ever actually needed at this project's scale.
      const ttl = baseTtlSeconds
        ? baseTtlSeconds + Math.floor(Math.random() * 30)
        : null;

      if (ttl) {
        await redis.set(key, JSON.stringify(sqlServerData), "EX", ttl);
      } else {
        await redis.set(key, JSON.stringify(sqlServerData));
      }
    } catch (err) {
      getLogger().error({ err, key }, "Cache write failed after fetching from source");
      // deliberately swallowed -- we already have valid data to return,
      // a failed cache write must not turn a successful request into a
      // failed one.
    }
  }

  return sqlServerData;
};