-- 20260823_161003_revoke_refresh_token.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:03.881Z
-- ============================================================================
CREATE OR ALTER PROCEDURE revoke_refresh_token
    @OldTokenId BIGINT,
    @NewTokenId BIGINT = NULL 
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE refresh_tokens
    SET 
        revoked_at = SYSUTCDATETIME(),
        replaced_by_token_id = @NewTokenId
    WHERE id = @OldTokenId
      AND revoked_at IS NULL; 
END


