-- 20260823_161015_revoke_all_user_sessions.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:15.401Z
-- ============================================================================
CREATE OR ALTER PROCEDURE revoke_all_user_sessions
    @UserId BIGINT
AS
BEGIN
    SET NOCOUNT ON;
 
   
       UPDATE refresh_tokens
    SET revoked_at = SYSUTCDATETIME()
    WHERE user_id = @UserId
      AND revoked_at IS NULL;
END

