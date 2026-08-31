-- 20260829_013847_create_images_table.sql
-- Service: media-service
-- Type: DDL
-- Created: 2026-08-28T22:38:47.943Z
-- ============================================================================
IF NOT EXISTS (SELECT *
               FROM   sys.tables
               WHERE  name = 'images')
    BEGIN
        CREATE TABLE images (
            id                BIGINT         IDENTITY (1, 1) NOT NULL PRIMARY KEY,
            product_id        BIGINT         NOT NULL,
            -- references catalog-service's products.id — no FK possible
            original_filename NVARCHAR (500) NOT NULL,
            status            NVARCHAR (20)  DEFAULT 'pending' NOT NULL,
            -- 'pending' -> 'processing' -> 'processed' | 'failed'
            thumbnail_url     NVARCHAR (500) NULL,
            -- filled in once processed
            preview_url       NVARCHAR (500) NULL,
            -- filled in once processed
            is_primary        BIT            DEFAULT 0 NOT NULL,
            created_by        BIGINT         NULL,
            -- references identity-service's users.id — no FK possible
            created_at        DATETIME2 (7)  DEFAULT SYSUTCDATETIME() NOT NULL,
            processed_at      DATETIME2 (7)  NULL,
            CONSTRAINT CHK_images_status CHECK (status IN ('pending', 'processing', 'processed', 'failed'))
        );
        CREATE INDEX IX_images_product_status
            ON images(product_id, status)
            INCLUDE(thumbnail_url, preview_url, is_primary);
    END