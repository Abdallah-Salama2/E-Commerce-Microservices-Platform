// scripts/migrate.js
import fs from "fs";
import path from "path";
import sql from "mssql";
import { getPool } from "../../config/db.config.js";
import { fileURLToPath, pathToFileURL } from "url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const DDL_DIR = path.resolve(__dirname, "../DDL");
const DML_DIR = path.resolve(__dirname, "../DML");
const SP_DIR = path.resolve(__dirname, "../SP");

async function ensureDatabaseExists() {
  const dbName = process.env.DB_NAME || "Ecommerce";
  const isProduction = process.env.NODE_ENV === "production";

  const masterConfig = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    port: parseInt(process.env.DB_PORT, 10) || 1450,
    database: "master",
    options: {
      encrypt: process.env.DB_ENCRYPT
        ? process.env.DB_ENCRYPT === "true"
        : isProduction,
      trustServerCertificate: process.env.DB_TRUST_SERVER_CERT
        ? process.env.DB_TRUST_SERVER_CERT === "true"
        : !isProduction,
    },
  };

  const pool = await new sql.ConnectionPool(masterConfig).connect();

  try {
    console.log(`Checking if database '${dbName}' exists...`);

    // NOTE: T-SQL does not permit direct parameterization of DDL identifiers
    // (e.g. CREATE DATABASE @dbName is invalid T-SQL syntax).
    // We bind @dbName safely as an input parameter and execute server-side
    // QUOTENAME() with sp_executesql to avoid raw JavaScript string interpolation.
    const query = `
      IF NOT EXISTS (SELECT 1 FROM sys.databases WHERE name = @dbName)
      BEGIN
        DECLARE @sql NVARCHAR(MAX) = N'CREATE DATABASE ' + QUOTENAME(@dbName);
        EXEC sp_executesql @sql;
      END
    `;

    await pool
      .request()
      .input("dbName", sql.NVarChar(128), dbName)
      .query(query);

    console.log(`Database '${dbName}' is ready.`);
  } finally {
    await pool.close();
  }
}

function splitSqlBatches(sqlContent) {
  return sqlContent
    .split(/^\s*GO\s*$/gim)
    .map((batch) => batch.trim())
    .filter((batch) => batch.length > 0);
}

async function runSqlBatches(transaction, sqlContent) {
  const batches = splitSqlBatches(sqlContent);
  for (const batch of batches) {
    const request = transaction.request();
    await request.query(batch);
  }
}

async function ensureTrackingTableExists(pool) {
  const tableCheck = await pool.request().query(`
    SELECT CASE WHEN EXISTS (
      SELECT 1 FROM sys.tables WHERE name = 'schema_migrations'
    ) THEN 1 ELSE 0 END AS TableExists
  `);

  if (tableCheck.recordset[0].TableExists === 0) {
    console.log("schema_migrations table not found — creating it now...");
    await pool.request().query(`
      CREATE TABLE schema_migrations (
        FileName NVARCHAR(255) PRIMARY KEY,
        AppliedAt DATETIME2 DEFAULT SYSUTCDATETIME()
      )
    `);
  }
}

async function runMigrationsFromDir(pool, dir, alreadyApplied) {
  const allFiles = fs
    .readdirSync(dir)
    .filter((f) => f.endsWith(".sql"))
    .sort();

  const pendingFiles = allFiles.filter((f) => !alreadyApplied.has(f));
  const dirName = path.basename(dir);

  if (pendingFiles.length === 0) {
    console.log(`No pending files in ${dirName}.`);
    return;
  }

  console.log(`Found ${pendingFiles.length} pending file(s) in ${dirName}:`);
  pendingFiles.forEach((f) => console.log(`  - ${f}`));

  for (const fileName of pendingFiles) {
    const filePath = path.join(dir, fileName);
    const sqlContent = fs.readFileSync(filePath, "utf-8");

    console.log(`Running: ${fileName}...`);
    const transaction = pool.transaction();

    try {
      await transaction.begin();
      await runSqlBatches(transaction, sqlContent);
      await transaction
        .request()
        .input("fileName", fileName)
        .query("INSERT INTO schema_migrations (FileName) VALUES (@fileName)");

      await transaction.commit();
      console.log(`  Done: ${fileName}`);
    } catch (err) {
      try {
        await transaction.rollback();
      } catch (rollbackErr) {
        console.error("  Rollback also failed:", rollbackErr.message);
      }

      console.error(`  FAILED at: ${fileName}`);
      console.error(err.message);
      throw err; // Throw error so server.js catches it properly
    }
  }
}

export async function runMigrations() {
  await ensureDatabaseExists();
  const pool = await getPool();
  await ensureTrackingTableExists(pool);

  const result = await pool
    .request()
    .query("SELECT FileName FROM schema_migrations");
  const alreadyApplied = new Set(result.recordset.map((row) => row.FileName));

  await runMigrationsFromDir(pool, DDL_DIR, alreadyApplied);
  await runMigrationsFromDir(pool, DML_DIR, alreadyApplied);
  await runMigrationsFromDir(pool, SP_DIR, alreadyApplied);

  console.log(
    "All migrations, seeds, and stored procedures applied successfully.",
  );
}

// Check if running directly via CLI (e.g. node scripts/migrate.js)
if (
  process.argv[1] &&
  import.meta.url === pathToFileURL(process.argv[1]).href
) {
  runMigrations()
    .then(() => process.exit(0))
    .catch((err) => {
      console.error("Migration runner crashed:", err);
      process.exit(1);
    });
}
