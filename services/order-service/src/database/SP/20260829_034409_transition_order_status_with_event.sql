-- 20260829_034409_transition_order_status_with_event.sql
-- Service: order-service
-- Type: SP
-- Created: 2026-08-29T00:44:09.343Z
-- ============================================================================
CREATE OR ALTER PROCEDURE transition_order_status_with_event
    @Id                     BIGINT,
    @ExpectedCurrentStatus  NVARCHAR(20),
    @NewStatus              NVARCHAR(20),
    @EventType              NVARCHAR(50),
    @UpdatedBy              BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM orders WHERE id = @Id)
        BEGIN
            ;THROW 50301, 'Order not found.', 1;
        END

        DECLARE @UserId BIGINT;
        SELECT @UserId = user_id FROM orders WHERE id = @Id;

        UPDATE orders
        SET status = @NewStatus,
            updated_by = @UpdatedBy,
            updated_at = SYSUTCDATETIME()
        WHERE id = @Id AND status = @ExpectedCurrentStatus;

        IF @@ROWCOUNT = 0
        BEGIN
            ;THROW 50302, 'Order status has changed since it was last read. Please refresh and try again.', 1;
        END

        -- userId now travels with the event — notification-service has no
        -- local table to look it up from, unlike order-service's own
        -- get_order_by_id lookup for the cart-clear case
        INSERT INTO outbox_events (event_type, payload)
        VALUES (
            @EventType,
            (SELECT @Id AS orderId, @UserId AS userId FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        );

        COMMIT TRANSACTION;

        SELECT id, status, updated_at AS updatedAt FROM orders WHERE id = @Id;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;