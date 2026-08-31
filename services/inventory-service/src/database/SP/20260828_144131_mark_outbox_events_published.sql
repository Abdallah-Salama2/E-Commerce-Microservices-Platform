-- 20260828_144131_mark_outbox_events_published.sql
-- Service: Inventory-service
-- Type: SP
-- Created: 2026-08-28T11:41:31.348Z
-- ============================================================================
CREATE OR ALTER PROCEDURE mark_outbox_events_published
    @Ids NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE outbox_events
    SET published_at = SYSUTCDATETIME()
    WHERE id IN (SELECT CAST(value AS BIGINT) FROM STRING_SPLIT(@Ids, ','));
END;


