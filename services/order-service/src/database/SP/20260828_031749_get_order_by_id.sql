-- 20260828_031749_get_order_by_id.sql
-- Service: order-service
-- Type: SP
-- Created: 2026-08-28T00:17:49.421Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_order_by_id
    @Id BIGINT,
    @UserId BIGINT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1 FROM orders
        WHERE id = @Id
          AND (@UserId IS NULL OR user_id = @UserId)
    )
    BEGIN
        ;THROW 50301, 'Order not found.', 1;
    END

    SELECT
        id,
        user_id AS userId,
        status,
        total_amount AS totalAmount,
        created_at AS createdAt,
        updated_at AS updatedAt
    FROM orders
    WHERE id = @Id;

    SELECT
        i.id,
        i.order_id AS orderId,
        i.product_id AS productId,
        i.product_name_snapshot AS productTitle,
        i.quantity,
        i.unit_price_snapshot AS unitPrice,
        (i.quantity * i.unit_price_snapshot) AS totalPrice
    FROM order_items i
    WHERE i.order_id = @Id;
END;

