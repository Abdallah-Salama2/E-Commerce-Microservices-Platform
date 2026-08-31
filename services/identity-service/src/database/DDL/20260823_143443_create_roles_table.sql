-- 20260823_143443_create_roles_table.sql
-- Service: identity-service
-- Type: DDL
-- Created: 2026-08-23T11:34:43.251Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'roles')
    CREATE TABLE roles (
        id   INT           IDENTITY (1, 1) PRIMARY KEY,
        name NVARCHAR (50) UNIQUE NOT NULL
    );