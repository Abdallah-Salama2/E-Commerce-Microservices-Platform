-- 20260829_061433_insert_notification_log.sql
-- Service: notification-service
-- Type: SP
-- Created: 2026-08-29T03:14:33.931Z
-- ============================================================================
CREATE OR ALTER PROCEDURE insert_notification_log
    @OrderId    BIGINT,
    @EventType  NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO notification_log (order_id, event_type)
    VALUES (@OrderId, @EventType);
END;

