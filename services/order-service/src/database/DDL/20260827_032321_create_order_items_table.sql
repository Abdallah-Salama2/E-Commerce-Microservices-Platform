-- 20260827_032321_create_order_items_table.sql
-- Service: order-service
-- Type: DDL
-- Created: 2026-08-27T00:23:21.891Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'order_items')
    BEGIN
        CREATE TABLE order_items (
            id                    BIGINT          IDENTITY (1, 1) NOT NULL PRIMARY KEY,
            order_id              BIGINT          NOT NULL,
            product_id            BIGINT          NOT NULL,
            -- references catalog-service's products.id — no FK possible
            product_name_snapshot NVARCHAR (255)  NOT NULL,
            unit_price_snapshot   DECIMAL (10, 2) NOT NULL,
            quantity              INT             NOT NULL,
            CONSTRAINT FK_order_items_order FOREIGN KEY (order_id) REFERENCES orders (id),
            CONSTRAINT UQ_order_items_order_product UNIQUE (order_id, product_id)
        );
        CREATE INDEX IX_order_items_order_id
            ON order_items(order_id)
            INCLUDE(product_id, product_name_snapshot, unit_price_snapshot, quantity);
    END