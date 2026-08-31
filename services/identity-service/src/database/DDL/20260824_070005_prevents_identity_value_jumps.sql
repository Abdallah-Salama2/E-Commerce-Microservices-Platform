-- 20260824_070005_prevents_identity_value_jumps.sql
-- Service: identity-service
-- Type: DDL
-- Created: 2026-08-24T04:00:05.930Z
-- ============================================================================
-- Commit the transaction started by your Node.js runner
COMMIT TRANSACTION;

-- Run the non-transactional configuration
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = OFF;

-- Start a new transaction so the runner's underlying COMMIT/ROLLBACK doesn't crash
BEGIN TRANSACTION;