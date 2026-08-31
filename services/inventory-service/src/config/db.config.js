import mssql from "mssql";
import { env } from "./env.js";

const Max_Pool = 10;
const Min_Pool = 0;
const isProduction = env.NODE_ENV === "production";
const dbConfig = {
  user: env.DB.USER,
  password: env.DB.PASSWORD,
  server: env.DB.SERVER,
  port: env.DB.PORT, // Enforces port 1450
  database: env.DB.NAME,
  options: {
    // Enable encryption in production (TLS/SSL)
    encrypt: env.DB?.ENCRYPT ?? isProduction,
    // Validate SSL certificate authority in production; allow self-signed in dev
    trustServerCertificate: env.DB?.TRUST_SERVER_CERT ?? !isProduction,
  },
  pool: {
    max: Max_Pool,
    min: Min_Pool,
    idleTimeoutMillis: 30000,
  },
};

// Extracted Outside getPool Functoin so in case of retry connection and failure it doesnt keep creating unused objects (new)
//every failure try would have left new unused object in memory

const pool = new mssql.ConnectionPool(dbConfig);

pool.on("error", (err) => {
  console.error("⚠️ Background SQL Pool Error:", err.message);
  // Reset promise so the next getPool() call tries to establish a fresh connection pool
  poolPromise = null;
});

let poolPromise = null;

export async function getPool() {
  if (poolPromise == null) {
    try {
      poolPromise = pool.connect(); // No await here To avoid race condition
      // if someone else calls request and find pool promise=null cuz not assigned waiting for await to finish

      const connectedPool = await poolPromise;

      console.log("✅ Connected to SQL Server (via Pool) successfully!");

      return connectedPool;
    } catch (err) {
      console.error("❌ Initial Database Connection Failed!");
      console.error("🔍 Details:", err.message);
      poolPromise = null;
      throw err;
    }
  }
  return await poolPromise;
}
