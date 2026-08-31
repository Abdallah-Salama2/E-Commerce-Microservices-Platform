-- 20260829_184409_release_stock_for_order.sql
-- Service: order-service
-- Type: SP
-- Created: 2026-08-29T15:44:09.518Z
-- ============================================================================
-- release_stock_for_order.sql
CREATE OR ALTER PROCEDURE release_stock_for_order
    @OrderId         BIGINT,
    @OrderItemsJson  NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Idempotency: only release if this order is currently 'Reserved'.
        -- A redelivered release event, or a release request for an order
        -- that was actually 'Rejected' (nothing was ever decremented),
        -- both correctly no-op here — same @@ROWCOUNT idiom used
        -- everywhere else in this project.
        UPDATE processed_orders
        SET decision = 'Released'
        WHERE order_id = @OrderId AND decision = 'Reserved';

        IF @@ROWCOUNT = 0
        BEGIN
            COMMIT TRANSACTION;
            RETURN;
        END

        DECLARE @Items TABLE (ProductId BIGINT, Quantity INT);
        INSERT INTO @Items (ProductId, Quantity)
        SELECT productId, quantity
        FROM OPENJSON(@OrderItemsJson)
        WITH (productId BIGINT '$.productId', quantity INT '$.quantity');

        -- Same lock-ordering discipline as reserve_stock_for_order — lock
        -- in ascending product_id order first, so this can never deadlock
        -- against a concurrent reservation touching overlapping products.
        DECLARE @LockedStock TABLE (ProductId BIGINT);
        INSERT INTO @LockedStock (ProductId)
        SELECT s.product_id
        FROM stock s WITH (UPDLOCK, ROWLOCK)
        INNER JOIN @Items i ON i.ProductId = s.product_id
        ORDER BY s.product_id ASC;

        UPDATE s
        SET s.quantity = s.quantity + i.Quantity,
            s.updated_at = SYSUTCDATETIME()
        FROM stock s
        INNER JOIN @Items i ON i.ProductId = s.product_id;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

