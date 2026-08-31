-- 20260823_161005_revoke_session_tokens.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:05.707Z
-- ============================================================================

CREATE OR ALTER PROCEDURE revoke_session_tokens
    @SessionId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
 
    UPDATE refresh_tokens
    SET revoked_at = SYSUTCDATETIME()
    WHERE session_id = @SessionId
      AND revoked_at IS NULL;
END
