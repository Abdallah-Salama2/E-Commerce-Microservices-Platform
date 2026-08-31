-- 20260828_144123_get_unpublished_outbox_events.sql
-- Service: Inventory-service
-- Type: SP
-- Created: 2026-08-28T11:41:23.528Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_unpublished_outbox_events
    @BatchSize INT = 50
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP (@BatchSize) id, event_type, payload
    FROM outbox_events
    WHERE published_at IS NULL
    ORDER BY id ASC;
END;

