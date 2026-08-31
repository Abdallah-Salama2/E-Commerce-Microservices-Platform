-- 20260829_013858_create_outbox_event_table.sql
-- Service: media-service
-- Type: DDL
-- Created: 2026-08-28T22:38:58.468Z
-- ============================================================================
-- Two event types will flow through here: 'image.uploaded' (written by the
-- upload route, the instant the raw file is saved — this is what the
-- worker consumes to know there's work to do) and 'image.processed'
-- (written by the worker once sharp() finishes — this is what
-- catalog-service consumes to populate its product_image_views table).
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'outbox_events')
    BEGIN
        CREATE TABLE outbox_events (
            id           BIGINT         IDENTITY (1, 1) NOT NULL PRIMARY KEY,
            event_type   NVARCHAR (50)  NOT NULL,
            payload      NVARCHAR (MAX) NOT NULL,
            created_at   DATETIME2 (7)  DEFAULT SYSUTCDATETIME() NOT NULL,
            published_at DATETIME2 (7)  NULL
        );
    END