-- 20260827_142750_set_stock_quantity.sql
-- Service: Inventory-service
-- Type: SP
-- Created: 2026-08-27T11:27:50.031Z
-- ============================================================================
CREATE OR ALTER PROCEDURE set_stock_quantity
    @ProductId    BIGINT,
    @NewQuantity  INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (SELECT 1 FROM stock WITH (UPDLOCK, ROWLOCK) WHERE product_id = @ProductId)
        BEGIN
            ;THROW 50201, 'Stock row for this product does not exist.', 1;
        END

        UPDATE stock
        SET quantity = @NewQuantity,
            updated_at = SYSUTCDATETIME()
        WHERE product_id = @ProductId;

        COMMIT TRANSACTION;

        SELECT product_id AS productId, quantity, updated_at AS updatedAt
        FROM stock WHERE product_id = @ProductId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

