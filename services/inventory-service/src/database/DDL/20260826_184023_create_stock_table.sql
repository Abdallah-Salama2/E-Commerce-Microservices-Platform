-- 20260826_184023_create_stock_table.sql
-- Service: Inventory-service
-- Type: DDL
-- Created: 2026-08-26T15:40:23.981Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'stock')
    CREATE TABLE stock (
        product_id BIGINT        NOT NULL PRIMARY KEY,
        quantity   INT           NOT NULL CHECK (quantity >= 0),
        updated_at DATETIME2 (7) DEFAULT SYSUTCDATETIME() NOT NULL
    );