-- 20260823_143519_create_refresh_tokens_table.sql
-- Service: identity-service
-- Type: DDL
-- Created: 2026-08-23T11:35:19.291Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'refresh_tokens')
    BEGIN
        CREATE TABLE refresh_tokens (
            id                   BIGINT           IDENTITY (1, 1) PRIMARY KEY,
            user_id              BIGINT           NOT NULL,
            jti                  UNIQUEIDENTIFIER NOT NULL UNIQUE,
            session_id           UNIQUEIDENTIFIER NOT NULL,
            token_hash           NVARCHAR (255)   NOT NULL,
            replaced_by_token_id BIGINT           NULL,
            expires_at           DATETIME2        NOT NULL,
            revoked_at           DATETIME2        NULL,
            created_at           DATETIME2        DEFAULT SYSUTCDATETIME() NOT NULL,
            -- Foreign Key referencing the Users table (Cascade delete if user is removed)
        CONSTRAINT FK_refresh_tokens_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
            -- Self-Referencing Foreign Key for Refresh Token Rotation chain (NO CASCADE to avoid multiple cascade paths) (For Security and protection from hackers)
        CONSTRAINT FK_refresh_tokens_replaced_by FOREIGN KEY (replaced_by_token_id) REFERENCES refresh_tokens (id)
        );
    END

