-- 20260827_134005_get_unpublished_outbox_events.sql
-- Service: catalog-service
-- Type: SP
-- Created: 2026-08-27T10:40:05.456Z
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

