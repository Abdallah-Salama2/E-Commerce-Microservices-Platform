-- 20260828_031802_transition_order_status.sql
-- Service: order-service
-- Type: SP
-- Created: 2026-08-28T00:18:02.237Z
-- ============================================================================
CREATE OR ALTER PROCEDURE transition_order_status
    @Id BIGINT,
    @ExpectedCurrentStatus NVARCHAR(20),
    @NewStatus NVARCHAR(20),
    @UpdatedBy BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Ensure the order exists first (to return 404 if not found)
        IF NOT EXISTS (SELECT 1 FROM orders WHERE id = @Id)
        BEGIN
            ;THROW 50301, 'Order not found.', 1;
        END

        -- 2. Attempt conditional update based on expected status (Optimistic Concurrency)
        UPDATE orders
        SET status = @NewStatus,
            updated_by = @UpdatedBy,
            updated_at = SYSUTCDATETIME()
        WHERE id = @Id 
          AND status = @ExpectedCurrentStatus;

        -- 3. If no rows were affected, the status changed between read and update (409 Conflict)
        IF @@ROWCOUNT = 0
        BEGIN
            ;THROW 50302, 'Order status has changed since it was last read. Please refresh and try again.', 1;
        END

        COMMIT TRANSACTION;

        -- 4. Return the updated result
        SELECT id, status, updated_at AS updatedAt 
        FROM orders 
        WHERE id = @Id;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 
            ROLLBACK TRANSACTION;
            
        THROW; -- Re-throw error to be caught by the backend layer
    END CATCH
END;

