-- 20260823_143532_create_user_tokens_table.sql
-- Service: identity-service
-- Type: DDL
-- Created: 2026-08-23T11:35:32.819Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'user_tokens')
    BEGIN
        CREATE TABLE user_tokens (
            id         BIGINT         IDENTITY (1, 1) PRIMARY KEY,
            user_id    BIGINT         NOT NULL,
            type       NVARCHAR (30)  NOT NULL,
            token_hash NVARCHAR (255) NOT NULL,
            expires_at DATETIME2      NOT NULL,
            used_at    DATETIME2      NULL,
            created_at DATETIME2      DEFAULT SYSUTCDATETIME() NOT NULL,
            -- Foreign Key referencing the Users table with CASCADE delete
        CONSTRAINT FK_user_tokens_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
            -- Check constraint to enforce allowed token types
        CONSTRAINT CHK_user_tokens_type CHECK (type IN ('EmailVerification', 'PasswordReset'))
        );
    END

