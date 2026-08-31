#!/usr/bin/env node
import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

// This tool's own location is the one stable reference point, regardless
// of where it's INVOKED from (repo root, or via a relative path from
// inside a service folder like `node ../../tools/make-migration.js`).
// Resolving against process.cwd() instead would silently double up the
// path when called from inside a service directory — that's a real bug
// this fix corrects, found by actually testing both invocation styles.
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const REPO_ROOT = path.resolve(__dirname, "..");

// -----------------------------------------------------------------------
// Usage:
//   node tools/make-migration.js <service-name> <DDL|DML|SP> <migration_name>
//
// Example:
//   node tools/make-migration.js identity-service DDL create_role_table
//
// Produces:
//   services/identity-service/src/database/DDL/20260823_091534_create_role_table.sql
//
// WHY TIMESTAMPS INSTEAD OF 001_, 002_:
//   Sequential numbers collide the moment two migrations get created
//   around the same time (two branches, or just you working fast) — both
//   end up wanting "007_", and now there's a manual renumbering fight.
//   A timestamp down to the second is, in practice, always unique, and
//   because it's zero-padded YYYYMMDD_HHMMSS, plain alphabetical sort
//   (which is exactly what your migrate.js already does with
//   `.sort()`) puts them in correct chronological order for free —
//   nothing about migrate.js needs to change.
// -----------------------------------------------------------------------

const [, , serviceName, migrationType, ...nameParts] = process.argv;
const migrationName = nameParts.join("_");

const VALID_TYPES = ["DDL", "DML", "SP"];

if (!serviceName || !migrationType || !migrationName) {
  console.error("Usage: node tools/make-migration.js <service-name> <DDL|DML|SP> <migration_name>");
  console.error("Example: node tools/make-migration.js identity-service DDL create_role_table");
  process.exit(1);
}

if (!VALID_TYPES.includes(migrationType)) {
  console.error(`Invalid type "${migrationType}". Must be one of: ${VALID_TYPES.join(", ")}`);
  process.exit(1);
}

function buildTimestamp() {
  const now = new Date();
  const pad = (n) => String(n).padStart(2, "0");
  const y = now.getFullYear();
  const mo = pad(now.getMonth() + 1);
  const d = pad(now.getDate());
  const h = pad(now.getHours());
  const mi = pad(now.getMinutes());
  const s = pad(now.getSeconds());
  return `${y}${mo}${d}_${h}${mi}${s}`;
}

function slugify(name) {
  return name
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "");
}

const targetDir = path.resolve(
  REPO_ROOT,
  "services",
  serviceName,
  "src",
  "database",
  migrationType,
);

if (!fs.existsSync(targetDir)) {
  console.error(`Target directory does not exist: ${targetDir}`);
  console.error(`Check the service name and that its database/${migrationType} folder has been scaffolded.`);
  process.exit(1);
}

const timestamp = buildTimestamp();
const slug = slugify(migrationName);
const fileName = `${timestamp}_${slug}.sql`;
const filePath = path.join(targetDir, fileName);

if (fs.existsSync(filePath)) {
  console.error(`A file with this exact name already exists: ${fileName}`);
  console.error("This means two migrations were generated in the same second — wait a moment and try again.");
  process.exit(1);
}

// -----------------------------------------------------------------------
// Same-SLUG check (ignoring the timestamp prefix), not same-filename.
// This is the check that actually matters: running the generator twice
// with the same descriptive name produces two DIFFERENT filenames (they
// have different timestamps) — the exact-filename check above won't catch
// that. But two files both named "..._create_addresses_table.sql" are
// almost always a mistake, and if both get filled in with the same
// CREATE TABLE statement, migrate.js will hit the identical
// "table already exists" error we already proved happens with
// SchemaMigrations — just self-inflicted this time. Warn loudly, but
// don't block: there ARE legitimate reasons to reuse a name later
// (e.g. a genuine follow-up migration), so this stays a warning, not
// a refusal.
// -----------------------------------------------------------------------
const existingFiles = fs.readdirSync(targetDir).filter((f) => f.endsWith(".sql"));
const timestampPrefixPattern = /^\d{8}_\d{6}_/;
const duplicates = existingFiles.filter((f) => f.replace(timestampPrefixPattern, "") === `${slug}.sql`);

if (duplicates.length > 0) {
  console.warn(`⚠️  WARNING: a migration with this same name already exists:`);
  duplicates.forEach((f) => console.warn(`     ${f}`));
  console.warn(`   If this is a mistake (e.g. you ran the command twice), delete the`);
  console.warn(`   redundant file now — two migrations creating the same object will`);
  console.warn(`   fail at runtime with a duplicate-object error, not at generation time.`);
  console.warn("");
}

const header = `-- ${fileName}
-- Service: ${serviceName}
-- Type: ${migrationType}
-- Created: ${new Date().toISOString()}
-- ============================================================================


`;

fs.writeFileSync(filePath, header);

console.log(`Created: services/${serviceName}/src/database/${migrationType}/${fileName}`);