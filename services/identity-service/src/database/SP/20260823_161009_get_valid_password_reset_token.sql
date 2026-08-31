-- 20260823_161009_get_valid_password_reset_token.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:09.674Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_valid_password_reset_token
@TokenHash NVARCHAR (255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id,
           user_id,
           type,
           expires_at,
           created_at
    FROM   user_tokens
    WHERE  token_hash = @TokenHash
           AND type = 'PasswordReset'
           AND used_at IS NULL
           AND expires_at > SYSUTCDATETIME();
END

