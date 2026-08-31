-- 20260827_032352_create_outbox_events_table.sql
-- Service: order-service
-- Type: DDL
-- Created: 2026-08-27T00:23:52.285Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'outbox_events')
    BEGIN
        CREATE TABLE outbox_events (
            id           BIGINT         IDENTITY (1, 1) NOT NULL PRIMARY KEY,
            event_type   NVARCHAR (50)  NOT NULL,
            -- 'inventory.reserved' | 'inventory.rejected'
            payload      NVARCHAR (MAX) NOT NULL,
            created_at   DATETIME2 (7)  DEFAULT SYSUTCDATETIME() NOT NULL,
            published_at DATETIME2 (7)  NULL
        );
    END