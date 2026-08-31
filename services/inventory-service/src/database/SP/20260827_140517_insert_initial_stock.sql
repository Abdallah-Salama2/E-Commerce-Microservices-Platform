-- 20260827_140517_insert_initial_stock.sql
-- Service: Inventory-service
-- Type: SP
-- Created: 2026-08-27T11:05:17.451Z
-- ============================================================================
CREATE OR ALTER PROCEDURE insert_initial_stock
    @ProductId BIGINT,
    @Quantity  INT
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO stock (product_id, quantity)
    VALUES (@ProductId, @Quantity);
END;

