-- 20260827_134017_mark_outbox_events_published.sql
-- Service: catalog-service
-- Type: SP
-- Created: 2026-08-27T10:40:17.040Z
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

