-- 20260829_023654_claim_image_for_processing.sql
-- Service: media-service
-- Type: SP
-- Created: 2026-08-28T23:36:54.215Z
-- ============================================================================
CREATE OR ALTER PROCEDURE claim_image_for_processing
    @ImageId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    -- Conditional UPDATE, same optimistic-concurrency shape as
    -- transition_order_status: only claim it if it's still 'pending'.
    -- This IS the idempotency guard — a redelivered image.uploaded for
    -- something already 'processing' or 'processed' updates ZERO rows here.
    UPDATE images
    SET status = 'processing'
    WHERE id = @ImageId AND status = 'pending';

    SELECT @@ROWCOUNT AS claimed; -- 1 if we claimed it, 0 if someone/something already did
END;

