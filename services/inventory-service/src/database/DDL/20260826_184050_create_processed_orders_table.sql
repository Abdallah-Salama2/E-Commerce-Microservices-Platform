-- 20260826_184050_create_processed_orders_table.sql
-- Service: Inventory-service
-- Type: DDL
-- Created: 2026-08-26T15:40:50.840Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'processed_orders')
    CREATE TABLE processed_orders (
        order_id     BIGINT        NOT NULL PRIMARY KEY,
        decision     NVARCHAR (20) NOT NULL,
        processed_at DATETIME2 (7) DEFAULT SYSUTCDATETIME() NOT NULL
    );

