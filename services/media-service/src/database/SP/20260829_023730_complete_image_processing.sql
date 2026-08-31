-- 20260829_023730_complete_image_processing.sql
-- Service: media-service
-- Type: SP
-- Created: 2026-08-28T23:37:30.819Z
-- ============================================================================
CREATE OR ALTER PROCEDURE complete_image_processing
    @ImageId       BIGINT,
    @ProductId     BIGINT,
    @ThumbnailUrl  NVARCHAR(500),
    @PreviewUrl    NVARCHAR(500),
    @IsPrimary     BIT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE images
        SET status = 'processed',
            thumbnail_url = @ThumbnailUrl,
            preview_url = @PreviewUrl,
            processed_at = SYSUTCDATETIME()
        WHERE id = @ImageId;

        INSERT INTO outbox_events (event_type, payload)
        VALUES (
            'image.processed',
            (SELECT @ImageId AS imageId, @ProductId AS productId,
                    @ThumbnailUrl AS thumbnailUrl, @PreviewUrl AS previewUrl,
                    @IsPrimary AS isPrimary
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

