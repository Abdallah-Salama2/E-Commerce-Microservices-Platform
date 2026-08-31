-- 20260828_031731_get_orders.sql
-- Service: order-service
-- Type: SP
-- Created: 2026-08-28T00:17:31.734Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_orders
    @UserId BIGINT = NULL,          -- non-null = customer's own orders; null = admin sees all
    @Status NVARCHAR(20) = NULL,
    @SortOrder NVARCHAR(4) = 'DESC',-- 'ASC' = oldest first (your "finish sooner" admin use case)
    @Page INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@Page - 1) * @PageSize;

    SELECT COUNT(*) AS totalCount
    FROM orders
    WHERE (@UserId IS NULL OR user_id = @UserId)
      AND (@Status IS NULL OR status = @Status);

    SELECT
        id,
        user_id AS userId,
        status,
        total_amount AS totalAmount,
        created_at AS createdAt,
        (SELECT COUNT(*) FROM order_items WHERE order_id = orders.id) AS itemCount
    FROM orders
    WHERE (@UserId IS NULL OR user_id = @UserId)
      AND (@Status IS NULL OR status = @Status)
    ORDER BY
        CASE WHEN @SortOrder = 'ASC' THEN created_at END ASC,
        CASE WHEN @SortOrder = 'DESC' THEN created_at END DESC,
        id ASC                      -- tiebreaker, always unique
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END;

