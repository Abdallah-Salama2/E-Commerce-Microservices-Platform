-- 20260823_160135_seed_roles.sql
-- Service: identity-service
-- Type: DML
-- Created: 2026-08-23T13:01:35.400Z
-- ============================================================================
-------------------------------------------------------------------
-- Seed Default System Roles (Safe for re-execution)
-------------------------------------------------------------------
-- 1. Insert 'Customer' Role
IF NOT EXISTS (SELECT 1
               FROM   roles
               WHERE  name = 'Customer')
    BEGIN
        INSERT  INTO roles (name)
        VALUES            ('Customer');
    END

-- 2. Insert 'Admin' Role
IF NOT EXISTS (SELECT 1
               FROM   roles
               WHERE  name = 'Admin')
    BEGIN
        INSERT  INTO roles (name)
        VALUES            ('Admin');
    END

