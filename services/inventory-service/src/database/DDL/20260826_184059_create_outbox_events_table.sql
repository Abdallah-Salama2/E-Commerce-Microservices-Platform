-- 20260826_184059_create_outbox_events_table.sql
-- Service: Inventory-service
-- Type: DDL
-- Created: 2026-08-26T15:40:59.426Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'outbox_events')
    CREATE TABLE outbox_events (
        id           BIGINT         IDENTITY (1, 1) NOT NULL PRIMARY KEY,
        event_type   NVARCHAR (50)  NOT NULL,
        payload      NVARCHAR (MAX) NOT NULL,
        created_at   DATETIME2 (7)  DEFAULT SYSUTCDATETIME() NOT NULL,
        published_at DATETIME2 (7)  NULL
    );

