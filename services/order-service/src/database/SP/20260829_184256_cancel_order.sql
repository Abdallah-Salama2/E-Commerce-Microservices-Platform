-- 20260829_184256_cancel_order.sql
-- Service: order-service
-- Type: SP
-- Created: 2026-08-29T15:42:56.436Z
-- ============================================================================
-- cancel_order.sql
CREATE OR ALTER PROCEDURE cancel_order
    @Id                     BIGINT,
    @ExpectedCurrentStatus  NVARCHAR(20),  -- 'Pending' or 'Processing' — the only two states Cancelled is reachable from
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
        SET status = 'Cancelled', updated_by = @UpdatedBy, updated_at = SYSUTCDATETIME()
        WHERE id = @Id AND status = @ExpectedCurrentStatus;

        IF @@ROWCOUNT = 0
        BEGIN
            ;THROW 50302, 'Order status has changed since it was last read. Please refresh and try again.', 1;
        END

        -- Always notify, regardless of which status it was cancelled from —
        -- matches notification-service's existing order.cancelled contract.
        INSERT INTO outbox_events (event_type, payload)
        VALUES (
            'order.cancelled',
            (SELECT @Id AS orderId, @UserId AS userId FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        );

        -- Only release stock if it was actually reserved. That only ever
        -- happened once the order reached Processing (inventory.reserved
        -- already fired by that point). Cancelling straight from Pending
        -- never reserved anything — nothing to give back.
        IF @ExpectedCurrentStatus = 'Processing'
        BEGIN
            INSERT INTO outbox_events (event_type, payload)
            VALUES (
                'order.stock_release_requested',
                (SELECT
                    @Id AS orderId,
                    (SELECT product_id AS productId, quantity
                     FROM order_items WHERE order_id = @Id
                     FOR JSON PATH) AS items
                 FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
            );
        END

        COMMIT TRANSACTION;

        SELECT id, status, updated_at AS updatedAt FROM orders WHERE id = @Id;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

