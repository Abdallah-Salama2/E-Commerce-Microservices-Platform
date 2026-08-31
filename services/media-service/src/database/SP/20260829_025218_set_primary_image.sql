-- 20260829_025218_set_primary_image.sql
-- Service: media-service
-- Type: SP
-- Created: 2026-08-28T23:52:18.876Z
-- ============================================================================
CREATE OR ALTER PROCEDURE set_primary_image
    @ProductId BIGINT,
    @ImageId   BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF NOT EXISTS (SELECT 1 FROM images WHERE id = @ImageId AND product_id = @ProductId AND status = 'processed')
        BEGIN
            ;THROW 50202, 'Processed image not found for this product.', 1;
        END

        BEGIN TRANSACTION;

        UPDATE images SET is_primary = 0 WHERE product_id = @ProductId;
        UPDATE images SET is_primary = 1 WHERE id = @ImageId;

        COMMIT TRANSACTION;

        SELECT id, product_id AS productId, thumbnail_url AS thumbnailUrl,
               preview_url AS previewUrl, is_primary AS isPrimary
        FROM images WHERE id = @ImageId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

