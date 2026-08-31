-- 20260823_161000_get_refresh_token_by_hash.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:00.080Z
-- ============================================================================
CREATE OR ALTER PROCEDURE get_refresh_token_by_hash
@TokenHash NVARCHAR (255)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT id,
           user_id,
           jti,
           session_id,
           token_hash,
           expires_at,
           revoked_at,
           replaced_by_token_id
    FROM   refresh_tokens
    WHERE  token_hash = @TokenHash;
END