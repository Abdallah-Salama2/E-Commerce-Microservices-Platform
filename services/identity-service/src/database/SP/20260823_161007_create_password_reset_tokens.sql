-- 20260823_161007_create_password_reset_tokens.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:07.595Z
-- ============================================================================
CREATE OR ALTER PROCEDURE create_password_reset_tokens
@UserId BIGINT, @TokenHash NVARCHAR (255), @ExpiresAt DATETIME2
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE user_tokens
        SET    used_at = SYSUTCDATETIME()
        WHERE  user_id = @UserId
               AND type = 'PasswordReset'
               AND used_at IS NULL;
        INSERT  INTO user_tokens (user_id, type, token_hash, expires_at, used_at, created_at)
        VALUES                  (@UserId, 'PasswordReset', @TokenHash, @ExpiresAt, NULL, SYSUTCDATETIME());
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END

