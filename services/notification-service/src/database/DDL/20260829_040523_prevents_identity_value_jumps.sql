-- 20260829_040523_prevents_identity_value_jumps.sql
-- Service: identity-service
-- Type: DDL
-- Created: 2026-08-29T01:05:23.253Z
-- ============================================================================
-- Commit the transaction started by your Node.js runner
COMMIT TRANSACTION;

-- Run the non-transactional configuration
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = OFF;

-- Start a new transaction so the runner's underlying COMMIT/ROLLBACK doesn't crash
BEGIN TRANSACTION;

