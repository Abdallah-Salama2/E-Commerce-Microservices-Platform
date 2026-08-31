-- 20260829_020114_create_pending_image.sql
-- Service: media-service
-- Type: SP
-- Created: 2026-08-28T23:01:14.417Z
-- ============================================================================
CREATE OR ALTER PROCEDURE create_pending_image
    @ProductId          BIGINT,
    @OriginalFilename    NVARCHAR(500),
    @CreatedBy           BIGINT,
    @RawFilePath         NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @ImageId BIGINT;

        INSERT INTO images (product_id, original_filename, status, created_by)
        VALUES (@ProductId, @OriginalFilename, 'pending', @CreatedBy);
        SET @ImageId = SCOPE_IDENTITY();

        -- rawFilePath lives ONLY in the event payload, not in the images
        -- table itself — the worker is the only thing that ever needs it,
        -- exactly once, so there's no reason to give it a permanent column
        INSERT INTO outbox_events (event_type, payload)
        VALUES (
            'image.uploaded',
            (SELECT @ImageId AS imageId, @ProductId AS productId, @RawFilePath AS rawFilePath
             FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)
        );

        COMMIT TRANSACTION;

        SELECT id, product_id AS productId, status, created_at AS createdAt
        FROM images WHERE id = @ImageId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

