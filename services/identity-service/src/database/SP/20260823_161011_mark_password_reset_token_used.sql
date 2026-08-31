-- 20260823_161011_mark_password_reset_token_used.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:11.613Z
-- ============================================================================
CREATE OR ALTER PROCEDURE mark_password_reset_token_used
@TokenId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE user_tokens
    SET    used_at = SYSUTCDATETIME()
    WHERE  id = @TokenId
           AND used_at IS NULL;
END

