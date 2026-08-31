-- 20260823_161017_reset_password.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:17.237Z
-- ============================================================================
CREATE OR ALTER PROCEDURE reset_password
@TokenHash NVARCHAR (255), @NewPasswordHash NVARCHAR (255)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- forces a full auto-rollback on any runtime error inside this batch,
    -- not just the ones we explicitly THROW ourselves
    DECLARE @TokenId AS BIGINT, @UserId AS BIGINT;
    BEGIN TRY
        BEGIN TRANSACTION;
        -- UPDLOCK + ROWLOCK: prevents a second concurrent reset request using the
        -- same token from reading it as still-valid before this transaction commits
        -- and marks it used. Without this, two near-simultaneous requests with the
        -- same reset link could both succeed.
        SELECT @TokenId = id,
               @UserId = user_id
        FROM   user_tokens WITH (UPDLOCK, ROWLOCK)
        WHERE  token_hash = @TokenHash
               AND type = 'PasswordReset'
               AND used_at IS NULL
               AND expires_at > SYSUTCDATETIME();
               
        IF @TokenId IS NULL
            BEGIN
                ;THROW 50003, 'Invalid or expired password reset token.', 1;
            END
        UPDATE users
        SET    password_hash = @NewPasswordHash,
               updated_at    = SYSUTCDATETIME()
        WHERE  id = @UserId;
        
        UPDATE user_tokens
        SET    used_at = SYSUTCDATETIME()
        WHERE  id = @TokenId;
        
        UPDATE refresh_tokens
        SET    revoked_at = SYSUTCDATETIME()
        WHERE  user_id = @UserId
               AND revoked_at IS NULL;

        COMMIT TRANSACTION;
        SELECT id AS userId, email
        FROM   users
        WHERE  id = @UserId;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK;
        THROW;
    END CATCH
END

