-- 20260823_161002_rotate_refresh_token.sql
-- Service: identity-service
-- Type: SP
-- Created: 2026-08-23T13:10:02.051Z
-- ============================================================================
CREATE OR ALTER PROCEDURE rotate_refresh_token
@OldTokenId BIGINT, @UserId BIGINT, @NewJti UNIQUEIDENTIFIER, @NewSessionId UNIQUEIDENTIFIER, @NewTokenHash NVARCHAR (255), @ExpiresInDays INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @NewTokenId AS BIGINT;
    DECLARE @SessionStartedAt AS DATETIME2;
    BEGIN TRY
        BEGIN TRANSACTION;
        
        SELECT @SessionStartedAt = MIN(created_at)
        FROM   refresh_tokens
        WHERE  session_id = @NewSessionId;
        
        DECLARE @CalculatedExpiresAt AS DATETIME2 = DATEADD(DAY, @ExpiresInDays, @SessionStartedAt);
        
        INSERT  INTO refresh_tokens (user_id, jti, session_id, token_hash, expires_at)
        VALUES                     (@UserId, @NewJti, @NewSessionId, @NewTokenHash, @CalculatedExpiresAt);
        SET @NewTokenId = SCOPE_IDENTITY();
        
        UPDATE refresh_tokens
        SET    revoked_at           = SYSUTCDATETIME(),
               replaced_by_token_id = @NewTokenId
        WHERE  id = @OldTokenId;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW;
    END CATCH
END

