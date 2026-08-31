import { getPool } from "../config/db.config.js";

const DEADLOCK_ERROR_NUMBER = 1205;
const MAX_RETRIES = 3;

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

/**
 * Generic base repository offering utility execution methods for SQL Server procedures.
 */
export class BaseRepository {
  /**
   * Private helper to establish connection pool and bind parameters.
   *
   * @private
   * @param {Array<{name: string, type: any, value: any}>} inputs
   * @returns {Promise<import("mssql").Request>} Bound SQL request object.
   */
  async #buildRequest(inputs = []) {
    const pool = await getPool();
    const request = pool.request();

    for (const { name, type, value } of inputs) {
      request.input(name, type, value);
    }

    return request;
  }

  /**
   * Runs fn (a fresh request + execute call each attempt — a deadlock
   * victim's connection/transaction is already dead, so retrying MUST
   * rebuild the request from scratch, not reuse the failed one) up to
   * MAX_RETRIES times if SQL Server reports a deadlock (1205). Any other
   * error is thrown immediately, unretried — a deadlock is transient by
   * definition, a business-rule error (like insufficient stock) is not,
   * and retrying that would just waste round trips reproducing the same
   * failure.
   */
  async #withDeadlockRetry(fn) {
    let lastErr;
    for (let attempt = 1; attempt <= MAX_RETRIES; attempt++) {
      try {
        return await fn();
      } catch (err) {
        lastErr = err;
        if (err.number !== DEADLOCK_ERROR_NUMBER || attempt === MAX_RETRIES) {
          throw err;
        }
        // Small random backoff so retries from a burst of colliding
        // transactions don't all retry at the exact same instant and
        // immediately deadlock each other again.
        await sleep(50 * attempt + Math.random() * 50);
      }
    }
    throw lastErr;
  }

  /**
   * Executes a stored procedure and returns only the first recordset.
   */
  async execute(procName, inputs = []) {
    return this.#withDeadlockRetry(async () => {
      const request = await this.#buildRequest(inputs);
      const result = await request.execute(procName);
      return result.recordset;
    });
  }

  /**
   * Executes a stored procedure and returns all generated recordsets.
   */
  async executeMultiple(procName, inputs = []) {
    return this.#withDeadlockRetry(async () => {
      const request = await this.#buildRequest(inputs);
      const result = await request.execute(procName);
      return result.recordsets;
    });
  }
}
