-- 20260827_155450_place_order.sql
-- Service: order-service
-- Type: SP
-- Created: 2026-08-27T12:54:50.654Z
-- ============================================================================
CREATE OR ALTER PROCEDURE place_order
    @UserId                    BIGINT,
    @IdempotencyKey            UNIQUEIDENTIFIER,
    @ShippingAddressSnapshot   NVARCHAR(MAX),
    @Subtotal                  DECIMAL(10,2),
    @OrderItemsJson            NVARCHAR(MAX)  -- JSON array: [{productId, quantity, unitPriceSnapshot, productNameSnapshot}]
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Pre-check short-circuit (decision #3) — cheap, handles the common
        -- case (client retries after a timeout) without ever opening a transaction
        IF EXISTS (SELECT 1 FROM orders WHERE idempotency_key = @IdempotencyKey)
        BEGIN
            SELECT id, status, total_amount AS totalAmount, created_at AS createdAt
            FROM orders WHERE idempotency_key = @IdempotencyKey;
            RETURN;
        END

        BEGIN TRANSACTION;

        DECLARE @OrderId BIGINT;

        INSERT INTO orders (
            user_id, status, idempotency_key, shipping_address_snapshot,
            subtotal, shipping_fee, tax_amount, discount_amount,
            total_amount, coupon_id, payment_method
        )
        VALUES (
            @UserId, 'Pending', @IdempotencyKey, @ShippingAddressSnapshot,
            @Subtotal, 0, 0, 0,
            @Subtotal, NULL, 'COD'
        );
        SET @OrderId = SCOPE_IDENTITY();

        -- OPENJSON turns the JSON array parameter into a real rowset —
        -- avoids sending N separate INSERTs for N line items
        INSERT INTO order_items (order_id, product_id, product_name_snapshot, unit_price_snapshot, quantity)
        SELECT @OrderId, productId, productNameSnapshot, unitPriceSnapshot, quantity
        FROM OPENJSON(@OrderItemsJson)
        WITH (
            productId BIGINT '$.productId',
            productNameSnapshot NVARCHAR(255) '$.productNameSnapshot',
            unitPriceSnapshot DECIMAL(10,2) '$.unitPriceSnapshot',
            quantity INT '$.quantity'
        );

        -- Outbox row — SAME transaction as the order write (decision #2)
        INSERT INTO outbox_events (event_type, payload)
        VALUES (
            'order.created',
            (SELECT
                @OrderId AS orderId,
                (SELECT productId, quantity
                FROM OPENJSON(@OrderItemsJson)
                WITH (productId BIGINT '$.productId', quantity INT '$.quantity')
                FOR JSON PATH) AS items
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        );

        COMMIT TRANSACTION;

        SELECT id, status, subtotal, total_amount AS totalAmount, created_at AS createdAt
        FROM orders WHERE id = @OrderId;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        -- The genuine concurrent-race case (decision #3): two identical
        -- idempotency keys both passed the pre-check before either committed.
        -- The UNIQUE constraint on idempotency_key rejects the second INSERT
        -- with 2627 — catch that specifically and return the winner's row
        -- instead of surfacing a raw 500.
        IF ERROR_NUMBER() = 2627
        BEGIN
            SELECT id, status, total_amount AS totalAmount, created_at AS createdAt
            FROM orders WHERE idempotency_key = @IdempotencyKey;
            RETURN;
        END

        ;THROW
    END CATCH
END;

