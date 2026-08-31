-- 20260829_025158_delete_product_image.sql
-- Service: media-service
-- Type: SP
-- Created: 2026-08-28T23:51:58.002Z
-- ============================================================================
CREATE OR ALTER PROCEDURE delete_product_image
    @ProductId BIGINT,
    @ImageId   BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM images WHERE id = @ImageId AND product_id = @ProductId)
    BEGIN
        ;THROW 50201, 'Product image not found.', 1;
    END

    -- Return whatever URLs exist BEFORE deleting the row, so the service
    -- layer knows which files (if any) to remove from disk. A pending/
    -- processing image will come back with NULLs here — that's expected,
    -- there's nothing processed yet to clean up beyond the raw file.
    SELECT thumbnail_url AS thumbnailUrl, preview_url AS previewUrl
    FROM images WHERE id = @ImageId;

    DELETE FROM images WHERE id = @ImageId;
END;

