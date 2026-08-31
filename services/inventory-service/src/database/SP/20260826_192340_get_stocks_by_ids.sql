-- 20260826_192340_get_stocks_by_ids.sql
-- Service: Inventory-service
-- Type: SP
-- Created: 2026-08-26T16:23:40.851Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_stocks_by_ids
@Ids NVARCHAR (MAX)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT product_id AS productId,
           quantity
    FROM   stock
    WHERE  product_id IN (SELECT CAST (value AS BIGINT)
                          FROM   STRING_SPLIT (@Ids, ','));
END

