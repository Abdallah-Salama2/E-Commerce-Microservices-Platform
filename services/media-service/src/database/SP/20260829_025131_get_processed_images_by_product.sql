-- 20260829_025131_get_processed_images_by_product.sql
-- Service: media-service
-- Type: SP
-- Created: 2026-08-28T23:51:31.669Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_processed_images_by_product
    @ProductId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    -- Only 'processed' rows — a 'pending'/'processing' image has no real
    -- URLs yet and should never be shown to an end user; a 'failed' one
    -- (if that status is ever actually set anywhere) shouldn't either.
    SELECT
        id,
        product_id AS productId,
        thumbnail_url AS thumbnailUrl,
        preview_url AS previewUrl,
        is_primary AS isPrimary,
        created_at AS createdAt
    FROM images
    WHERE product_id = @ProductId AND status = 'processed'
    ORDER BY is_primary DESC, created_at ASC; -- primary image first, then upload order
END;

