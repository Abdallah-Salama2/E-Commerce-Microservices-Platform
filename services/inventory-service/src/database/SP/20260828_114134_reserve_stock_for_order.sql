-- 20260828_114134_reserve_stock_for_order.sql
-- Service: Inventory-service
-- Type: SP
-- Created: 2026-08-28T08:41:34.017Z
-- ============================================================================
CREATE OR ALTER PROCEDURE reserve_stock_for_order
    @OrderId         BIGINT,
    @OrderItemsJson  NVARCHAR(MAX)  -- [{productId, quantity}, ...]
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Idempotency ledger check FIRST, before any locking — a redelivered
        -- order.created for an order we've already decided on (reserved OR
        -- rejected) must be a total no-op. Unlike product.created, there's
        -- no natural PK to lean on here (we're touching N stock rows, not
        -- inserting one row) — that's exactly why processed_orders exists.
        IF EXISTS (SELECT 1 FROM processed_orders WHERE order_id = @OrderId)
        BEGIN
            RETURN; -- already decided, nothing to do
        END

        BEGIN TRANSACTION;

        -- Materialize the incoming items into a real table variable —
        -- lets us JOIN/aggregate against it cleanly below
        DECLARE @Items TABLE (ProductId BIGINT, Quantity INT);
        INSERT INTO @Items (ProductId, Quantity)
        SELECT productId, quantity
        FROM OPENJSON(@OrderItemsJson)
        WITH (productId BIGINT '$.productId', quantity INT '$.quantity');

        DECLARE @LockedStock TABLE (ProductId BIGINT, Quantity INT);
        INSERT INTO @LockedStock (ProductId, Quantity)
        SELECT s.product_id, s.quantity
        FROM stock s WITH (UPDLOCK, ROWLOCK)
        INNER JOIN @Items i ON i.ProductId = s.product_id
        ORDER BY s.product_id ASC;

        -- All-or-nothing check (decision #6) — evaluate EVERY item before
        -- touching any of them. A short quantity on ANY item rejects the
        -- WHOLE order; nothing gets decremented if anything's short.
        DECLARE @IsRejected BIT = 0;
        DECLARE @ShortProductIds NVARCHAR(MAX);

        IF EXISTS (
            SELECT 1 FROM @Items i
            LEFT JOIN @LockedStock ls ON ls.ProductId = i.ProductId
            WHERE ls.ProductId IS NULL OR ls.Quantity < i.Quantity
        )
        BEGIN
            SET @IsRejected = 1;
            SELECT @ShortProductIds = STRING_AGG(CAST(i.ProductId AS NVARCHAR(20)), ',')
            FROM @Items i
            LEFT JOIN @LockedStock ls ON ls.ProductId = i.ProductId
            WHERE ls.ProductId IS NULL OR ls.Quantity < i.Quantity;
        END

        IF @IsRejected = 0
        BEGIN
            UPDATE s
            SET s.quantity = s.quantity - i.Quantity,
                s.updated_at = SYSUTCDATETIME()
            FROM stock s
            INNER JOIN @Items i ON i.ProductId = s.product_id;
        END

        -- Write the ledger — this row's existence IS the idempotency guard
        -- for any future redelivery of this same order_id
        INSERT INTO processed_orders (order_id, decision)
        VALUES (@OrderId, CASE WHEN @IsRejected = 1 THEN 'Rejected' ELSE 'Reserved' END);

        -- Outbox event — SAME transaction as the ledger write + the
        -- decrement (decision #2), so a crash between them is impossible
        INSERT INTO outbox_events (event_type, payload)
        VALUES (
            CASE WHEN @IsRejected = 1 THEN 'inventory.rejected' ELSE 'inventory.reserved' END,
            (SELECT @OrderId AS orderId, @ShortProductIds AS shortProductIds FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        );

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW; -- deadlocks (1205) get caught by BaseRepository's retry wrapper, not here
    END CATCH
END;

