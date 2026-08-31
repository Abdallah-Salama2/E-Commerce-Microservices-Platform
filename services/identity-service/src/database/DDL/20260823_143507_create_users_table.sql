-- 20260823_143507_create_users_table.sql
-- Service: identity-service
-- Type: DDL
-- Created: 2026-08-23T11:35:07.113Z
-- ============================================================================
IF NOT EXISTS (SELECT * 
               FROM   sys.tables 
               WHERE  name = 'users')
    CREATE TABLE users (
        id              BIGINT        IDENTITY (1, 1) PRIMARY KEY,
        email           NVARCHAR(255) UNIQUE NOT NULL,
        password_hash   NVARCHAR(255) NOT NULL,
        first_name      NVARCHAR(100) NOT NULL,
        last_name       NVARCHAR(100) NOT NULL,
        phone           NVARCHAR(20)  NULL,
        is_active       BIT           NOT NULL DEFAULT 1,
        is_email_verified BIT         NOT NULL DEFAULT 0,
        email_verified_at DATETIME2   NULL,
        created_at      DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME(),
        updated_at      DATETIME2     NOT NULL DEFAULT SYSUTCDATETIME()
    );