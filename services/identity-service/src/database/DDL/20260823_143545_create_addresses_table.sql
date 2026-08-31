-- 20260823_143545_create_addressess_table.sql
-- Service: identity-service
-- Type: DDL
-- Created: 2026-08-23T11:35:45.002Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'addresses')
    BEGIN
        CREATE TABLE addresses (
            id          BIGINT         IDENTITY (1, 1) PRIMARY KEY,
            user_id     BIGINT         NOT NULL,
            label       NVARCHAR (50)  NULL,
            full_name   NVARCHAR (150) NOT NULL,
            phone       NVARCHAR (20)  NOT NULL,
            line1       NVARCHAR (255) NOT NULL,
            line2       NVARCHAR (255) NULL,
            city        NVARCHAR (100) NOT NULL,
            governorate NVARCHAR (100) NOT NULL,
            country     NVARCHAR (100) DEFAULT 'Egypt' NOT NULL,
            postal_code NVARCHAR (20)  NULL,
            is_default  BIT            DEFAULT 0 NOT NULL,
            created_at  DATETIME2      DEFAULT SYSUTCDATETIME() NOT NULL,
            updated_at  DATETIME2      DEFAULT SYSUTCDATETIME() NOT NULL,
            -- Foreign Key referencing the Users table with CASCADE delete
        CONSTRAINT FK_addresses_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        );
        -- Unique Filtered Index to ensure only ONE default address per user
        -- Note: By default, CREATE INDEX creates a Non-Clustered Index under the hood
        CREATE UNIQUE INDEX IX_addresses_user_default
            ON addresses(user_id) WHERE is_default = 1; -- We Need Fast response for default or like active addresses only 
    END

