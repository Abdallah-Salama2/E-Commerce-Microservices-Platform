-- 20260823_160957_create_refresh_token.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:09:57.643Z
-- ============================================================================
CREATE OR ALTER PROCEDURE create_refresh_token
@UserId BIGINT, @Jti UNIQUEIDENTIFIER, @SessionId UNIQUEIDENTIFIER, @TokenHash NVARCHAR (255), @ReplacedByTokenId BIGINT=NULL, @ExpiresAt DATETIME2
AS
BEGIN
    SET NOCOUNT ON;
    INSERT  INTO refresh_tokens (user_id, jti, session_id, token_hash, replaced_by_token_id, expires_at)
    VALUES                     (@UserId, @Jti, @SessionId, @TokenHash, @ReplacedByTokenId, @ExpiresAt);
END