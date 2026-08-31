-- 20260827_142718_adjust_stock_quantity.sql
-- Service: Inventory-service
-- Type: SP
-- Created: 2026-08-27T11:27:18.858Z
-- ============================================================================
-- database/SP/xxx_adjust_stock_quantity.sql
CREATE OR ALTER PROCEDURE adjust_stock_quantity
    @ProductId BIGINT,
    @Delta      INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Lock the row before checking/adjusting — same UPDLOCK, ROWLOCK
        -- discipline we'll use in the reservation logic later, so this
        -- endpoint can never race with a concurrent checkout reservation
        -- on the same product.
        DECLARE @CurrentQty INT;
        SELECT @CurrentQty = quantity
        FROM stock WITH (UPDLOCK, ROWLOCK)
        WHERE product_id = @ProductId;

        IF @CurrentQty IS NULL
        BEGIN
            ;THROW 50201, 'Stock row for this product does not exist.', 1;
        END

        IF (@CurrentQty + @Delta) < 0
        BEGIN
            ;THROW 50202, 'Adjustment would result in negative stock.', 1;
        END

        UPDATE stock
        SET quantity = quantity + @Delta,
            updated_at = SYSUTCDATETIME()
        WHERE product_id = @ProductId;

        COMMIT TRANSACTION;

        SELECT product_id AS productId, quantity, updated_at AS updatedAt
        FROM stock
        WHERE product_id = @ProductId;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

