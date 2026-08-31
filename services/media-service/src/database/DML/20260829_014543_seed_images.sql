-- 20260829_014543_seed_images.sql
-- Service: media-service
-- Type: DML
-- Created: 2026-08-28T22:45:43.557Z
-- ============================================================================
-- ============================================================================
-- media-service seed data — images
-- Ported from the old monolith's product_images table (see legacy
-- 003_seed-ecommerce.sql) now that images live in their own service/DB.
--
-- IMPORTANT — cross-service product_id mapping
-- images.product_id has no FK (catalog-service owns products), so this
-- seeder can't do `(SELECT id FROM products WHERE slug = ...)` like the old
-- monolith did. The literal IDs below assume catalog-service's own seeder
-- (20260823_235014_seed_products_and_categories.sql) has already been run
-- ONCE against a fresh DB, so IDENTITY assigned products.id = 1..50 in the
-- exact order those INSERTs appear in that script. If catalog was seeded
-- differently (re-run, reordered, rows deleted/re-inserted, etc.) these IDs
-- will be wrong and this seeder will silently attach images to the wrong
-- products. Safer alternative: have catalog-service expose the slug->id
-- mapping (e.g. a small export) and generate this file from that instead
-- of hardcoding it.
--
-- Photo credits: see 003_seed-ecommerce.sql in the old monolith repo for the
-- full Unsplash attribution list (still required wherever these images are
-- displayed in the UI).
-- ============================================================================

DECLARE @SeedUserId BIGINT = NULL;  -- set to a real identity-service user id if you want created_by populated

-- iphone-15-pro-max (product_id = 1)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 1
    AND thumbnail_url = N'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxpcGhvbmUlMjBzbWFydHBob25lfGVufDB8Mnx8fDE3ODc1OTY3Nzl8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  1,
  N'iphone-15-pro-max-0-1511707171634.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxpcGhvbmUlMjBzbWFydHBob25lfGVufDB8Mnx8fDE3ODc1OTY3Nzl8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxpcGhvbmUlMjBzbWFydHBob25lfGVufDB8Mnx8fDE3ODc1OTY3Nzl8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 1
    AND thumbnail_url = N'https://images.unsplash.com/photo-1591337676887-a217a6970a8a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxpcGhvbmUlMjBzbWFydHBob25lfGVufDB8Mnx8fDE3ODc1OTY3Nzl8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  1,
  N'iphone-15-pro-max-1-1591337676887.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1591337676887-a217a6970a8a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxpcGhvbmUlMjBzbWFydHBob25lfGVufDB8Mnx8fDE3ODc1OTY3Nzl8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1591337676887-a217a6970a8a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxpcGhvbmUlMjBzbWFydHBob25lfGVufDB8Mnx8fDE3ODc1OTY3Nzl8MA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- samsung-galaxy-s24 (product_id = 2)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 2
    AND thumbnail_url = N'https://images.unsplash.com/photo-1597762470488-3877b1f538c6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxzYW1zdW5nJTIwZ2FsYXh5JTIwcGhvbmV8ZW58MHwyfHx8MTc4NzU5Njc4MHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  2,
  N'samsung-galaxy-s24-0-1597762470488.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1597762470488-3877b1f538c6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxzYW1zdW5nJTIwZ2FsYXh5JTIwcGhvbmV8ZW58MHwyfHx8MTc4NzU5Njc4MHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1597762470488-3877b1f538c6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxzYW1zdW5nJTIwZ2FsYXh5JTIwcGhvbmV8ZW58MHwyfHx8MTc4NzU5Njc4MHww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 2
    AND thumbnail_url = N'https://images.unsplash.com/photo-1592813630413-1124aa567638?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxzYW1zdW5nJTIwZ2FsYXh5JTIwcGhvbmV8ZW58MHwyfHx8MTc4NzU5Njc4MHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  2,
  N'samsung-galaxy-s24-1-1592813630413.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1592813630413-1124aa567638?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxzYW1zdW5nJTIwZ2FsYXh5JTIwcGhvbmV8ZW58MHwyfHx8MTc4NzU5Njc4MHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1592813630413-1124aa567638?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxzYW1zdW5nJTIwZ2FsYXh5JTIwcGhvbmV8ZW58MHwyfHx8MTc4NzU5Njc4MHww&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- google-pixel-8 (product_id = 3)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 3
    AND thumbnail_url = N'https://images.unsplash.com/photo-1756487564871-7ecc5a9c229f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxnb29nbGUlMjBwaXhlbCUyMHBob25lfGVufDB8Mnx8fDE3ODc1OTY3ODJ8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  3,
  N'google-pixel-8-0-1756487564871.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1756487564871-7ecc5a9c229f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxnb29nbGUlMjBwaXhlbCUyMHBob25lfGVufDB8Mnx8fDE3ODc1OTY3ODJ8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1756487564871-7ecc5a9c229f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxnb29nbGUlMjBwaXhlbCUyMHBob25lfGVufDB8Mnx8fDE3ODc1OTY3ODJ8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 3
    AND thumbnail_url = N'https://images.unsplash.com/photo-1756487564693-5d5f4c196fd5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxnb29nbGUlMjBwaXhlbCUyMHBob25lfGVufDB8Mnx8fDE3ODc1OTY3ODJ8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  3,
  N'google-pixel-8-1-1756487564693.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1756487564693-5d5f4c196fd5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxnb29nbGUlMjBwaXhlbCUyMHBob25lfGVufDB8Mnx8fDE3ODc1OTY3ODJ8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1756487564693-5d5f4c196fd5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxnb29nbGUlMjBwaXhlbCUyMHBob25lfGVufDB8Mnx8fDE3ODc1OTY3ODJ8MA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- oneplus-12 (product_id = 4)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 4
    AND thumbnail_url = N'https://images.unsplash.com/photo-1603129468615-8e7831c49f12?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxvbmVwbHVzJTIwc21hcnRwaG9uZXxlbnwwfDJ8fHwxNzg3NTk2Nzg0fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  4,
  N'oneplus-12-0-1603129468615.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1603129468615-8e7831c49f12?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxvbmVwbHVzJTIwc21hcnRwaG9uZXxlbnwwfDJ8fHwxNzg3NTk2Nzg0fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1603129468615-8e7831c49f12?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxvbmVwbHVzJTIwc21hcnRwaG9uZXxlbnwwfDJ8fHwxNzg3NTk2Nzg0fDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 4
    AND thumbnail_url = N'https://images.unsplash.com/photo-1773293915418-fb03a80120a7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxvbmVwbHVzJTIwc21hcnRwaG9uZXxlbnwwfDJ8fHwxNzg3NTk2Nzg0fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  4,
  N'oneplus-12-1-1773293915418.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1773293915418-fb03a80120a7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxvbmVwbHVzJTIwc21hcnRwaG9uZXxlbnwwfDJ8fHwxNzg3NTk2Nzg0fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1773293915418-fb03a80120a7?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxvbmVwbHVzJTIwc21hcnRwaG9uZXxlbnwwfDJ8fHwxNzg3NTk2Nzg0fDA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- dell-xps-15 (product_id = 5)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 5
    AND thumbnail_url = N'https://images.unsplash.com/photo-1577375729152-4c8b5fcda381?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxsYXB0b3AlMjBjb21wdXRlcnxlbnwwfDJ8fHwxNzg3NTk2Nzg1fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  5,
  N'dell-xps-15-0-1577375729152.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1577375729152-4c8b5fcda381?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxsYXB0b3AlMjBjb21wdXRlcnxlbnwwfDJ8fHwxNzg3NTk2Nzg1fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1577375729152-4c8b5fcda381?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxsYXB0b3AlMjBjb21wdXRlcnxlbnwwfDJ8fHwxNzg3NTk2Nzg1fDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 5
    AND thumbnail_url = N'https://images.unsplash.com/photo-1667058014960-b4d3c76047a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxsYXB0b3AlMjBjb21wdXRlcnxlbnwwfDJ8fHwxNzg3NTk2Nzg1fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  5,
  N'dell-xps-15-1-1667058014960.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1667058014960-b4d3c76047a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxsYXB0b3AlMjBjb21wdXRlcnxlbnwwfDJ8fHwxNzg3NTk2Nzg1fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1667058014960-b4d3c76047a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxsYXB0b3AlMjBjb21wdXRlcnxlbnwwfDJ8fHwxNzg3NTk2Nzg1fDA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- macbook-air-m3 (product_id = 6)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 6
    AND thumbnail_url = N'https://images.unsplash.com/photo-1569770218135-bea267ed7e84?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxtYWNib29rJTIwbGFwdG9wfGVufDB8Mnx8fDE3ODc1OTY3ODd8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  6,
  N'macbook-air-m3-0-1569770218135.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1569770218135-bea267ed7e84?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxtYWNib29rJTIwbGFwdG9wfGVufDB8Mnx8fDE3ODc1OTY3ODd8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1569770218135-bea267ed7e84?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxtYWNib29rJTIwbGFwdG9wfGVufDB8Mnx8fDE3ODc1OTY3ODd8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 6
    AND thumbnail_url = N'https://images.unsplash.com/photo-1606248897732-2c5ffe759c04?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxtYWNib29rJTIwbGFwdG9wfGVufDB8Mnx8fDE3ODc1OTY3ODd8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  6,
  N'macbook-air-m3-1-1606248897732.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1606248897732-2c5ffe759c04?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxtYWNib29rJTIwbGFwdG9wfGVufDB8Mnx8fDE3ODc1OTY3ODd8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1606248897732-2c5ffe759c04?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxtYWNib29rJTIwbGFwdG9wfGVufDB8Mnx8fDE3ODc1OTY3ODd8MA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- asus-rog-zephyrus (product_id = 7)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 7
    AND thumbnail_url = N'https://images.unsplash.com/photo-1547731030-cd126f44e9c5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxnYW1pbmclMjBsYXB0b3B8ZW58MHwyfHx8MTc4NzU5Njc5MHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  7,
  N'asus-rog-zephyrus-0-1547731030-cd.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1547731030-cd126f44e9c5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxnYW1pbmclMjBsYXB0b3B8ZW58MHwyfHx8MTc4NzU5Njc5MHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1547731030-cd126f44e9c5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxnYW1pbmclMjBsYXB0b3B8ZW58MHwyfHx8MTc4NzU5Njc5MHww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 7
    AND thumbnail_url = N'https://images.unsplash.com/photo-1600861195091-690c92f1d2cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxnYW1pbmclMjBsYXB0b3B8ZW58MHwyfHx8MTc4NzU5Njc5MHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  7,
  N'asus-rog-zephyrus-1-1600861195091.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1600861195091-690c92f1d2cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxnYW1pbmclMjBsYXB0b3B8ZW58MHwyfHx8MTc4NzU5Njc5MHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1600861195091-690c92f1d2cc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxnYW1pbmclMjBsYXB0b3B8ZW58MHwyfHx8MTc4NzU5Njc5MHww&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- sony-wh-1000xm5 (product_id = 8)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 8
    AND thumbnail_url = N'https://images.unsplash.com/photo-1638803782506-d975a6809f43?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHx3aXJlbGVzcyUyMGhlYWRwaG9uZXN8ZW58MHwyfHx8MTc4NzU5Njc5Mnww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  8,
  N'sony-wh-1000xm5-0-1638803782506.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1638803782506-d975a6809f43?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHx3aXJlbGVzcyUyMGhlYWRwaG9uZXN8ZW58MHwyfHx8MTc4NzU5Njc5Mnww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1638803782506-d975a6809f43?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHx3aXJlbGVzcyUyMGhlYWRwaG9uZXN8ZW58MHwyfHx8MTc4NzU5Njc5Mnww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 8
    AND thumbnail_url = N'https://images.unsplash.com/photo-1660391532247-4a8ad1060817?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHx3aXJlbGVzcyUyMGhlYWRwaG9uZXN8ZW58MHwyfHx8MTc4NzU5Njc5Mnww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  8,
  N'sony-wh-1000xm5-1-1660391532247.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1660391532247-4a8ad1060817?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHx3aXJlbGVzcyUyMGhlYWRwaG9uZXN8ZW58MHwyfHx8MTc4NzU5Njc5Mnww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1660391532247-4a8ad1060817?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHx3aXJlbGVzcyUyMGhlYWRwaG9uZXN8ZW58MHwyfHx8MTc4NzU5Njc5Mnww&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- apple-airpods-pro (product_id = 9)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 9
    AND thumbnail_url = N'https://images.unsplash.com/photo-1600375104627-c94c416deefa?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHx3aXJlbGVzcyUyMGVhcmJ1ZHN8ZW58MHwyfHx8MTc4NzU5Njc5NHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  9,
  N'apple-airpods-pro-0-1600375104627.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1600375104627-c94c416deefa?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHx3aXJlbGVzcyUyMGVhcmJ1ZHN8ZW58MHwyfHx8MTc4NzU5Njc5NHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1600375104627-c94c416deefa?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHx3aXJlbGVzcyUyMGVhcmJ1ZHN8ZW58MHwyfHx8MTc4NzU5Njc5NHww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 9
    AND thumbnail_url = N'https://images.unsplash.com/photo-1598900863662-da1c3e6dd9d9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHx3aXJlbGVzcyUyMGVhcmJ1ZHN8ZW58MHwyfHx8MTc4NzU5Njc5NHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  9,
  N'apple-airpods-pro-1-1598900863662.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1598900863662-da1c3e6dd9d9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHx3aXJlbGVzcyUyMGVhcmJ1ZHN8ZW58MHwyfHx8MTc4NzU5Njc5NHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1598900863662-da1c3e6dd9d9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHx3aXJlbGVzcyUyMGVhcmJ1ZHN8ZW58MHwyfHx8MTc4NzU5Njc5NHww&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- jbl-flip-speaker (product_id = 10)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 10
    AND thumbnail_url = N'https://images.unsplash.com/photo-1588131153911-a4ea5189fe19?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxibHVldG9vdGglMjBzcGVha2VyfGVufDB8Mnx8fDE3ODc1OTY3OTd8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  10,
  N'jbl-flip-speaker-0-1588131153911.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1588131153911-a4ea5189fe19?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxibHVldG9vdGglMjBzcGVha2VyfGVufDB8Mnx8fDE3ODc1OTY3OTd8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1588131153911-a4ea5189fe19?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxibHVldG9vdGglMjBzcGVha2VyfGVufDB8Mnx8fDE3ODc1OTY3OTd8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 10
    AND thumbnail_url = N'https://images.unsplash.com/photo-1665672629999-0994c3f052a9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxibHVldG9vdGglMjBzcGVha2VyfGVufDB8Mnx8fDE3ODc1OTY3OTd8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  10,
  N'jbl-flip-speaker-1-1665672629999.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1665672629999-0994c3f052a9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxibHVldG9vdGglMjBzcGVha2VyfGVufDB8Mnx8fDE3ODc1OTY3OTd8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1665672629999-0994c3f052a9?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxibHVldG9vdGglMjBzcGVha2VyfGVufDB8Mnx8fDE3ODc1OTY3OTd8MA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- apple-watch-series-9 (product_id = 11)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 11
    AND thumbnail_url = N'https://images.unsplash.com/photo-1641457474717-26e699f45414?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxhcHBsZSUyMHdhdGNoJTIwc21hcnR3YXRjaHxlbnwwfDJ8fHwxNzg3NTk2Nzk5fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  11,
  N'apple-watch-series-9-0-1641457474717.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1641457474717-26e699f45414?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxhcHBsZSUyMHdhdGNoJTIwc21hcnR3YXRjaHxlbnwwfDJ8fHwxNzg3NTk2Nzk5fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1641457474717-26e699f45414?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxhcHBsZSUyMHdhdGNoJTIwc21hcnR3YXRjaHxlbnwwfDJ8fHwxNzg3NTk2Nzk5fDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 11
    AND thumbnail_url = N'https://images.unsplash.com/photo-1704942968209-6c1e05ef3f95?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxhcHBsZSUyMHdhdGNoJTIwc21hcnR3YXRjaHxlbnwwfDJ8fHwxNzg3NTk2Nzk5fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  11,
  N'apple-watch-series-9-1-1704942968209.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1704942968209-6c1e05ef3f95?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxhcHBsZSUyMHdhdGNoJTIwc21hcnR3YXRjaHxlbnwwfDJ8fHwxNzg3NTk2Nzk5fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1704942968209-6c1e05ef3f95?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxhcHBsZSUyMHdhdGNoJTIwc21hcnR3YXRjaHxlbnwwfDJ8fHwxNzg3NTk2Nzk5fDA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- fitbit-charge-6 (product_id = 12)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 12
    AND thumbnail_url = N'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxmaXRuZXNzJTIwdHJhY2tlciUyMGJhbmR8ZW58MHwyfHx8MTc4NzU5NjgwMXww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  12,
  N'fitbit-charge-6-0-1575311373937.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxmaXRuZXNzJTIwdHJhY2tlciUyMGJhbmR8ZW58MHwyfHx8MTc4NzU5NjgwMXww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1575311373937-040b8e1fd5b6?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxmaXRuZXNzJTIwdHJhY2tlciUyMGJhbmR8ZW58MHwyfHx8MTc4NzU5NjgwMXww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 12
    AND thumbnail_url = N'https://images.unsplash.com/photo-1575054092299-4a300e7a2511?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxmaXRuZXNzJTIwdHJhY2tlciUyMGJhbmR8ZW58MHwyfHx8MTc4NzU5NjgwMXww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  12,
  N'fitbit-charge-6-1-1575054092299.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1575054092299-4a300e7a2511?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxmaXRuZXNzJTIwdHJhY2tlciUyMGJhbmR8ZW58MHwyfHx8MTc4NzU5NjgwMXww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1575054092299-4a300e7a2511?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxmaXRuZXNzJTIwdHJhY2tlciUyMGJhbmR8ZW58MHwyfHx8MTc4NzU5NjgwMXww&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- garmin-forerunner-265 (product_id = 13)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 13
    AND thumbnail_url = N'https://images.unsplash.com/photo-1750776100861-30c172651817?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxnYXJtaW4lMjBzcG9ydHMlMjB3YXRjaHxlbnwwfDJ8fHwxNzg3NTk2ODAzfDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  13,
  N'garmin-forerunner-265-0-1750776100861.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1750776100861-30c172651817?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxnYXJtaW4lMjBzcG9ydHMlMjB3YXRjaHxlbnwwfDJ8fHwxNzg3NTk2ODAzfDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1750776100861-30c172651817?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxnYXJtaW4lMjBzcG9ydHMlMjB3YXRjaHxlbnwwfDJ8fHwxNzg3NTk2ODAzfDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- classic-denim-jacket-men (product_id = 14)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 14
    AND thumbnail_url = N'https://images.unsplash.com/photo-1617178388553-a9d022974a5c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxkZW5pbSUyMGphY2tldCUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgwNHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  14,
  N'classic-denim-jacket-men-0-1617178388553.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1617178388553-a9d022974a5c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxkZW5pbSUyMGphY2tldCUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgwNHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1617178388553-a9d022974a5c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxkZW5pbSUyMGphY2tldCUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgwNHww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 14
    AND thumbnail_url = N'https://images.unsplash.com/photo-1632140548303-146425c0564a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxkZW5pbSUyMGphY2tldCUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgwNHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  14,
  N'classic-denim-jacket-men-1-1632140548303.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1632140548303-146425c0564a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxkZW5pbSUyMGphY2tldCUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgwNHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1632140548303-146425c0564a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxkZW5pbSUyMGphY2tldCUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgwNHww&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- slim-fit-chino-pants (product_id = 15)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 15
    AND thumbnail_url = N'https://images.unsplash.com/photo-1718252540511-e958742e4165?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxjaGlubyUyMHBhbnRzJTIwZmxhdCUyMGxheXxlbnwwfDJ8fHwxNzg3NTk2ODA2fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  15,
  N'slim-fit-chino-pants-0-1718252540511.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1718252540511-e958742e4165?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxjaGlubyUyMHBhbnRzJTIwZmxhdCUyMGxheXxlbnwwfDJ8fHwxNzg3NTk2ODA2fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1718252540511-e958742e4165?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxjaGlubyUyMHBhbnRzJTIwZmxhdCUyMGxheXxlbnwwfDJ8fHwxNzg3NTk2ODA2fDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- leather-belt-men (product_id = 16)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 16
    AND thumbnail_url = N'https://images.unsplash.com/photo-1752386223406-b3d94092d790?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxsZWF0aGVyJTIwYmVsdCUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgwOHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  16,
  N'leather-belt-men-0-1752386223406.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1752386223406-b3d94092d790?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxsZWF0aGVyJTIwYmVsdCUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgwOHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1752386223406-b3d94092d790?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxsZWF0aGVyJTIwYmVsdCUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgwOHww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- wool-sweater-men (product_id = 17)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 17
    AND thumbnail_url = N'https://images.unsplash.com/photo-1611911813383-67769b37a149?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHx3b29sJTIwc3dlYXRlciUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgxMHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  17,
  N'wool-sweater-men-0-1611911813383.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1611911813383-67769b37a149?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHx3b29sJTIwc3dlYXRlciUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgxMHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1611911813383-67769b37a149?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHx3b29sJTIwc3dlYXRlciUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgxMHww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- floral-summer-dress (product_id = 18)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 18
    AND thumbnail_url = N'https://images.unsplash.com/photo-1739474019626-526d6d0dbcea?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxmbG9yYWwlMjBkcmVzcyUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgxMnww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  18,
  N'floral-summer-dress-0-1739474019626.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1739474019626-526d6d0dbcea?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxmbG9yYWwlMjBkcmVzcyUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgxMnww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1739474019626-526d6d0dbcea?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwxfHxmbG9yYWwlMjBkcmVzcyUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgxMnww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 18
    AND thumbnail_url = N'https://images.unsplash.com/photo-1614416943242-9e18ce1ea19b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxmbG9yYWwlMjBkcmVzcyUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgxMnww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  18,
  N'floral-summer-dress-1-1614416943242.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1614416943242-9e18ce1ea19b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxmbG9yYWwlMjBkcmVzcyUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgxMnww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1614416943242-9e18ce1ea19b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTAyMjF8MHwxfHNlYXJjaHwyfHxmbG9yYWwlMjBkcmVzcyUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5NjgxMnww&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- wool-blend-coat (product_id = 19)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 19
    AND thumbnail_url = N'https://images.unsplash.com/photo-1614532188535-2fa164c9ea24?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8d29vbCUyMGNvYXQlMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg1NTd8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  19,
  N'wool-blend-coat-0-1614532188535.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1614532188535-2fa164c9ea24?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8d29vbCUyMGNvYXQlMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg1NTd8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1614532188535-2fa164c9ea24?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8d29vbCUyMGNvYXQlMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg1NTd8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 19
    AND thumbnail_url = N'https://images.unsplash.com/photo-1592878807783-48ae9d36750c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8d29vbCUyMGNvYXQlMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg1NTd8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  19,
  N'wool-blend-coat-1-1592878807783.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1592878807783-48ae9d36750c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8d29vbCUyMGNvYXQlMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg1NTd8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1592878807783-48ae9d36750c?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8d29vbCUyMGNvYXQlMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg1NTd8MA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- silk-blouse (product_id = 20)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 20
    AND thumbnail_url = N'https://images.unsplash.com/photo-1594632019379-421c5c70bf54?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8c2lsayUyMGJsb3VzZSUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5ODU1OXww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  20,
  N'silk-blouse-0-1594632019379.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1594632019379-421c5c70bf54?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8c2lsayUyMGJsb3VzZSUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5ODU1OXww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1594632019379-421c5c70bf54?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8c2lsayUyMGJsb3VzZSUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5ODU1OXww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- pleated-midi-skirt (product_id = 21)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 21
    AND thumbnail_url = N'https://images.unsplash.com/photo-1639600280258-90a5cbfd4220?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8cGxlYXRlZCUyMHNraXJ0JTIwZmxhdCUyMGxheXxlbnwwfDJ8fHwxNzg3NTk4NTYxfDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  21,
  N'pleated-midi-skirt-0-1639600280258.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1639600280258-90a5cbfd4220?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8cGxlYXRlZCUyMHNraXJ0JTIwZmxhdCUyMGxheXxlbnwwfDJ8fHwxNzg3NTk4NTYxfDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1639600280258-90a5cbfd4220?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8cGxlYXRlZCUyMHNraXJ0JTIwZmxhdCUyMGxheXxlbnwwfDJ8fHwxNzg3NTk4NTYxfDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- running-sneakers (product_id = 22)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 22
    AND thumbnail_url = N'https://images.unsplash.com/photo-1491553895911-0055eca6402d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8cnVubmluZyUyMHNob2VzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjN8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  22,
  N'running-sneakers-0-1491553895911.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1491553895911-0055eca6402d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8cnVubmluZyUyMHNob2VzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjN8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1491553895911-0055eca6402d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8cnVubmluZyUyMHNob2VzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjN8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 22
    AND thumbnail_url = N'https://images.unsplash.com/photo-1750493101721-72dbceafef2f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8cnVubmluZyUyMHNob2VzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjN8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  22,
  N'running-sneakers-1-1750493101721.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1750493101721-72dbceafef2f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8cnVubmluZyUyMHNob2VzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjN8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1750493101721-72dbceafef2f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8cnVubmluZyUyMHNob2VzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjN8MA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- leather-boots (product_id = 23)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 23
    AND thumbnail_url = N'https://images.unsplash.com/photo-1550998358-08b4f83dc345?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8bGVhdGhlciUyMGJvb3RzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjV8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  23,
  N'leather-boots-0-1550998358-08.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1550998358-08b4f83dc345?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8bGVhdGhlciUyMGJvb3RzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjV8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1550998358-08b4f83dc345?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8bGVhdGhlciUyMGJvb3RzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjV8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 23
    AND thumbnail_url = N'https://images.unsplash.com/photo-1646215279503-7dd99848a8ee?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8bGVhdGhlciUyMGJvb3RzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjV8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  23,
  N'leather-boots-1-1646215279503.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1646215279503-7dd99848a8ee?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8bGVhdGhlciUyMGJvb3RzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjV8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1646215279503-7dd99848a8ee?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8bGVhdGhlciUyMGJvb3RzJTIwcHJvZHVjdCUyMHBob3RvfGVufDB8Mnx8fDE3ODc1OTg1NjV8MA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- canvas-sneakers (product_id = 24)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 24
    AND thumbnail_url = N'https://images.unsplash.com/photo-1561909848-977d0617f275?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FudmFzJTIwc25lYWtlcnMlMjBwcm9kdWN0JTIwcGhvdG98ZW58MHwyfHx8MTc4NzU5ODU2Nnww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  24,
  N'canvas-sneakers-0-1561909848-97.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1561909848-977d0617f275?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FudmFzJTIwc25lYWtlcnMlMjBwcm9kdWN0JTIwcGhvdG98ZW58MHwyfHx8MTc4NzU5ODU2Nnww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1561909848-977d0617f275?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FudmFzJTIwc25lYWtlcnMlMjBwcm9kdWN0JTIwcGhvdG98ZW58MHwyfHx8MTc4NzU5ODU2Nnww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- dress-shoes-men (product_id = 25)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 25
    AND thumbnail_url = N'https://images.unsplash.com/photo-1616696038562-574c18066055?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZHJlc3MlMjBzaG9lcyUyMHByb2R1Y3QlMjBwaG90b3xlbnwwfDJ8fHwxNzg3NTk4NTY4fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  25,
  N'dress-shoes-men-0-1616696038562.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1616696038562-574c18066055?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZHJlc3MlMjBzaG9lcyUyMHByb2R1Y3QlMjBwaG90b3xlbnwwfDJ8fHwxNzg3NTk4NTY4fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1616696038562-574c18066055?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZHJlc3MlMjBzaG9lcyUyMHByb2R1Y3QlMjBwaG90b3xlbnwwfDJ8fHwxNzg3NTk4NTY4fDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- espresso-machine (product_id = 26)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 26
    AND thumbnail_url = N'https://images.unsplash.com/photo-1637029436347-e33bf98a5412?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZXNwcmVzc28lMjBtYWNoaW5lfGVufDB8Mnx8fDE3ODc1OTQ2ODV8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  26,
  N'espresso-machine-0-1637029436347.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1637029436347-e33bf98a5412?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZXNwcmVzc28lMjBtYWNoaW5lfGVufDB8Mnx8fDE3ODc1OTQ2ODV8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1637029436347-e33bf98a5412?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZXNwcmVzc28lMjBtYWNoaW5lfGVufDB8Mnx8fDE3ODc1OTQ2ODV8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 26
    AND thumbnail_url = N'https://images.unsplash.com/photo-1637030157778-794c92f75e97?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8ZXNwcmVzc28lMjBtYWNoaW5lfGVufDB8Mnx8fDE3ODc1OTQ2ODV8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  26,
  N'espresso-machine-1-1637030157778.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1637030157778-794c92f75e97?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8ZXNwcmVzc28lMjBtYWNoaW5lfGVufDB8Mnx8fDE3ODc1OTQ2ODV8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1637030157778-794c92f75e97?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8ZXNwcmVzc28lMjBtYWNoaW5lfGVufDB8Mnx8fDE3ODc1OTQ2ODV8MA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- high-speed-blender (product_id = 27)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 27
    AND thumbnail_url = N'https://images.unsplash.com/photo-1668074201943-a142177d7f58?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8a2l0Y2hlbiUyMGJsZW5kZXJ8ZW58MHwyfHx8MTc4NzU5ODU3Mnww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  27,
  N'high-speed-blender-0-1668074201943.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1668074201943-a142177d7f58?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8a2l0Y2hlbiUyMGJsZW5kZXJ8ZW58MHwyfHx8MTc4NzU5ODU3Mnww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1668074201943-a142177d7f58?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8a2l0Y2hlbiUyMGJsZW5kZXJ8ZW58MHwyfHx8MTc4NzU5ODU3Mnww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- ergonomic-office-chair (product_id = 28)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 28
    AND thumbnail_url = N'https://images.unsplash.com/photo-1611001476049-a59a2736d410?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8b2ZmaWNlJTIwY2hhaXJ8ZW58MHwyfHx8MTc4NzU5NDY4N3ww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  28,
  N'ergonomic-office-chair-0-1611001476049.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1611001476049-a59a2736d410?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8b2ZmaWNlJTIwY2hhaXJ8ZW58MHwyfHx8MTc4NzU5NDY4N3ww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1611001476049-a59a2736d410?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8b2ZmaWNlJTIwY2hhaXJ8ZW58MHwyfHx8MTc4NzU5NDY4N3ww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 28
    AND thumbnail_url = N'https://images.unsplash.com/photo-1609798310302-2cd56312db02?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8b2ZmaWNlJTIwY2hhaXJ8ZW58MHwyfHx8MTc4NzU5NDY4N3ww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  28,
  N'ergonomic-office-chair-1-1609798310302.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1609798310302-2cd56312db02?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8b2ZmaWNlJTIwY2hhaXJ8ZW58MHwyfHx8MTc4NzU5NDY4N3ww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1609798310302-2cd56312db02?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8b2ZmaWNlJTIwY2hhaXJ8ZW58MHwyfHx8MTc4NzU5NDY4N3ww&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- wooden-dining-table (product_id = 29)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 29
    AND thumbnail_url = N'https://images.unsplash.com/photo-1758977405163-f2595de08dfe?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8d29vZGVuJTIwZGluaW5nJTIwdGFibGV8ZW58MHwyfHx8MTc4NzU5NDY4OHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  29,
  N'wooden-dining-table-0-1758977405163.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1758977405163-f2595de08dfe?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8d29vZGVuJTIwZGluaW5nJTIwdGFibGV8ZW58MHwyfHx8MTc4NzU5NDY4OHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1758977405163-f2595de08dfe?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8d29vZGVuJTIwZGluaW5nJTIwdGFibGV8ZW58MHwyfHx8MTc4NzU5NDY4OHww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 29
    AND thumbnail_url = N'https://images.unsplash.com/photo-1759473718260-2f1e162e5939?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8d29vZGVuJTIwZGluaW5nJTIwdGFibGV8ZW58MHwyfHx8MTc4NzU5NDY4OHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  29,
  N'wooden-dining-table-1-1759473718260.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1759473718260-2f1e162e5939?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8d29vZGVuJTIwZGluaW5nJTIwdGFibGV8ZW58MHwyfHx8MTc4NzU5NDY4OHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1759473718260-2f1e162e5939?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8d29vZGVuJTIwZGluaW5nJTIwdGFibGV8ZW58MHwyfHx8MTc4NzU5NDY4OHww&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- 3-seat-fabric-sofa (product_id = 30)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 30
    AND thumbnail_url = N'https://images.unsplash.com/photo-1667584523543-d1d9cc828a15?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZmFicmljJTIwc29mYSUyMGxpdmluZyUyMHJvb218ZW58MHwyfHx8MTc4NzU5ODU3OHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  30,
  N'3-seat-fabric-sofa-0-1667584523543.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1667584523543-d1d9cc828a15?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZmFicmljJTIwc29mYSUyMGxpdmluZyUyMHJvb218ZW58MHwyfHx8MTc4NzU5ODU3OHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1667584523543-d1d9cc828a15?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZmFicmljJTIwc29mYSUyMGxpdmluZyUyMHJvb218ZW58MHwyfHx8MTc4NzU5ODU3OHww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- 5-tier-bookshelf (product_id = 31)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 31
    AND thumbnail_url = N'https://images.unsplash.com/photo-1769987935921-ae3e9ebca21b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8d29vZGVuJTIwYm9va3NoZWxmfGVufDB8Mnx8fDE3ODc1OTg1ODB8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  31,
  N'5-tier-bookshelf-0-1769987935921.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1769987935921-ae3e9ebca21b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8d29vZGVuJTIwYm9va3NoZWxmfGVufDB8Mnx8fDE3ODc1OTg1ODB8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1769987935921-ae3e9ebca21b?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8d29vZGVuJTIwYm9va3NoZWxmfGVufDB8Mnx8fDE3ODc1OTg1ODB8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- adjustable-dumbbells (product_id = 32)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 32
    AND thumbnail_url = N'https://images.unsplash.com/photo-1652364649008-99b647d0d1d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZHVtYmJlbGxzJTIwZ3ltfGVufDB8Mnx8fDE3ODc1OTQ2OTB8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  32,
  N'adjustable-dumbbells-0-1652364649008.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1652364649008-99b647d0d1d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZHVtYmJlbGxzJTIwZ3ltfGVufDB8Mnx8fDE3ODc1OTQ2OTB8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1652364649008-99b647d0d1d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZHVtYmJlbGxzJTIwZ3ltfGVufDB8Mnx8fDE3ODc1OTQ2OTB8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 32
    AND thumbnail_url = N'https://images.unsplash.com/photo-1770734265339-d2d3005cc267?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8ZHVtYmJlbGxzJTIwZ3ltfGVufDB8Mnx8fDE3ODc1OTQ2OTB8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  32,
  N'adjustable-dumbbells-1-1770734265339.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1770734265339-d2d3005cc267?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8ZHVtYmJlbGxzJTIwZ3ltfGVufDB8Mnx8fDE3ODc1OTQ2OTB8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1770734265339-d2d3005cc267?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8ZHVtYmJlbGxzJTIwZ3ltfGVufDB8Mnx8fDE3ODc1OTQ2OTB8MA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- yoga-mat (product_id = 33)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 33
    AND thumbnail_url = N'https://images.unsplash.com/photo-1552286450-4a669f880062?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8eW9nYSUyMG1hdHxlbnwwfDJ8fHwxNzg3NTk0NjkyfDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  33,
  N'yoga-mat-0-1552286450-4a.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1552286450-4a669f880062?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8eW9nYSUyMG1hdHxlbnwwfDJ8fHwxNzg3NTk0NjkyfDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1552286450-4a669f880062?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8eW9nYSUyMG1hdHxlbnwwfDJ8fHwxNzg3NTk0NjkyfDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- resistance-bands-set (product_id = 34)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 34
    AND thumbnail_url = N'https://images.unsplash.com/photo-1550101733-1301db7ba32a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8cmVzaXN0YW5jZSUyMGJhbmRzJTIwZml0bmVzc3xlbnwwfDJ8fHwxNzg3NTk4NTg1fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  34,
  N'resistance-bands-set-0-1550101733-13.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1550101733-1301db7ba32a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8cmVzaXN0YW5jZSUyMGJhbmRzJTIwZml0bmVzc3xlbnwwfDJ8fHwxNzg3NTk4NTg1fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1550101733-1301db7ba32a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8cmVzaXN0YW5jZSUyMGJhbmRzJTIwZml0bmVzc3xlbnwwfDJ8fHwxNzg3NTk4NTg1fDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- 4-person-camping-tent (product_id = 35)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 35
    AND thumbnail_url = N'https://images.unsplash.com/photo-1744843936424-b6206cde80e0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FtcGluZyUyMHRlbnR8ZW58MHwyfHx8MTc4NzU5ODU5MHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  35,
  N'4-person-camping-tent-0-1744843936424.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1744843936424-b6206cde80e0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FtcGluZyUyMHRlbnR8ZW58MHwyfHx8MTc4NzU5ODU5MHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1744843936424-b6206cde80e0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FtcGluZyUyMHRlbnR8ZW58MHwyfHx8MTc4NzU5ODU5MHww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 35
    AND thumbnail_url = N'https://images.unsplash.com/photo-1630700619765-ae2f6eae16df?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8Y2FtcGluZyUyMHRlbnR8ZW58MHwyfHx8MTc4NzU5ODU5MHww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  35,
  N'4-person-camping-tent-1-1630700619765.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1630700619765-ae2f6eae16df?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8Y2FtcGluZyUyMHRlbnR8ZW58MHwyfHx8MTc4NzU5ODU5MHww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1630700619765-ae2f6eae16df?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8Mnx8Y2FtcGluZyUyMHRlbnR8ZW58MHwyfHx8MTc4NzU5ODU5MHww&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- sleeping-bag (product_id = 36)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 36
    AND thumbnail_url = N'https://images.unsplash.com/photo-1630700619765-ae2f6eae16df?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FtcGluZyUyMHNsZWVwaW5nJTIwYmFnfGVufDB8Mnx8fDE3ODc1OTg1OTJ8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  36,
  N'sleeping-bag-0-1630700619765.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1630700619765-ae2f6eae16df?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FtcGluZyUyMHNsZWVwaW5nJTIwYmFnfGVufDB8Mnx8fDE3ODc1OTg1OTJ8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1630700619765-ae2f6eae16df?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FtcGluZyUyMHNsZWVwaW5nJTIwYmFnfGVufDB8Mnx8fDE3ODc1OTg1OTJ8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- hiking-backpack (product_id = 37)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 37
    AND thumbnail_url = N'https://images.unsplash.com/photo-1600599067176-1f47e3b6fe47?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8aGlraW5nJTIwYmFja3BhY2t8ZW58MHwyfHx8MTc4NzU5ODU5M3ww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  37,
  N'hiking-backpack-0-1600599067176.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1600599067176-1f47e3b6fe47?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8aGlraW5nJTIwYmFja3BhY2t8ZW58MHwyfHx8MTc4NzU5ODU5M3ww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1600599067176-1f47e3b6fe47?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8aGlraW5nJTIwYmFja3BhY2t8ZW58MHwyfHx8MTc4NzU5ODU5M3ww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- portable-camping-stove (product_id = 38)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 38
    AND thumbnail_url = N'https://images.unsplash.com/photo-1770433942218-1f177e12ce81?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FtcGluZyUyMHN0b3ZlJTIwb3V0ZG9vcnxlbnwwfDJ8fHwxNzg3NTk4NTk1fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  38,
  N'portable-camping-stove-0-1770433942218.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1770433942218-1f177e12ce81?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FtcGluZyUyMHN0b3ZlJTIwb3V0ZG9vcnxlbnwwfDJ8fHwxNzg3NTk4NTk1fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1770433942218-1f177e12ce81?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8Y2FtcGluZyUyMHN0b3ZlJTIwb3V0ZG9vcnxlbnwwfDJ8fHwxNzg3NTk4NTk1fDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- mystery-novel-collection (product_id = 39)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 39
    AND thumbnail_url = N'https://images.unsplash.com/photo-1471970471555-19d4b113e9ed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8bXlzdGVyeSUyMGJvb2tzJTIwc3RhY2t8ZW58MHwyfHx8MTc4NzU5ODU5N3ww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  39,
  N'mystery-novel-collection-0-1471970471555.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1471970471555-19d4b113e9ed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8bXlzdGVyeSUyMGJvb2tzJTIwc3RhY2t8ZW58MHwyfHx8MTc4NzU5ODU5N3ww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1471970471555-19d4b113e9ed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8bXlzdGVyeSUyMGJvb2tzJTIwc3RhY2t8ZW58MHwyfHx8MTc4NzU5ODU5N3ww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- fantasy-novel-trilogy (product_id = 40)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 40
    AND thumbnail_url = N'https://images.unsplash.com/photo-1499332251574-a76a01d733fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZmFudGFzeSUyMGJvb2tzJTIwc3RhY2t8ZW58MHwyfHx8MTc4NzU5ODU5OXww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  40,
  N'fantasy-novel-trilogy-0-1499332251574.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1499332251574-a76a01d733fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZmFudGFzeSUyMGJvb2tzJTIwc3RhY2t8ZW58MHwyfHx8MTc4NzU5ODU5OXww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1499332251574-a76a01d733fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8ZmFudGFzeSUyMGJvb2tzJTIwc3RhY2t8ZW58MHwyfHx8MTc4NzU5ODU5OXww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- scifi-anthology (product_id = 41)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 41
    AND thumbnail_url = N'https://images.unsplash.com/photo-1499332251574-a76a01d733fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8c2NpZW5jZSUyMGZpY3Rpb24lMjBib29rc3xlbnwwfDJ8fHwxNzg3NTk4NjAwfDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  41,
  N'scifi-anthology-0-1499332251574.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1499332251574-a76a01d733fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8c2NpZW5jZSUyMGZpY3Rpb24lMjBib29rc3xlbnwwfDJ8fHwxNzg3NTk4NjAwfDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1499332251574-a76a01d733fc?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDI0MjYzfDB8MXxzZWFyY2h8MXx8c2NpZW5jZSUyMGZpY3Rpb24lMjBib29rc3xlbnwwfDJ8fHwxNzg3NTk4NjAwfDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- personal-finance-guide (product_id = 42)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 42
    AND thumbnail_url = N'https://images.unsplash.com/photo-1632976032753-2b209dd0a921?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8ZmluYW5jZSUyMGJvb2slMjByZWFkaW5nfGVufDB8Mnx8fDE3ODc1OTg2OTV8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  42,
  N'personal-finance-guide-0-1632976032753.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1632976032753-2b209dd0a921?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8ZmluYW5jZSUyMGJvb2slMjByZWFkaW5nfGVufDB8Mnx8fDE3ODc1OTg2OTV8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1632976032753-2b209dd0a921?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8ZmluYW5jZSUyMGJvb2slMjByZWFkaW5nfGVufDB8Mnx8fDE3ODc1OTg2OTV8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- everyday-cookbook (product_id = 43)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 43
    AND thumbnail_url = N'https://images.unsplash.com/photo-1769987935916-2a72e6d5dacd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8Y29va2Jvb2slMjBraXRjaGVufGVufDB8Mnx8fDE3ODc1OTg2OTZ8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  43,
  N'everyday-cookbook-0-1769987935916.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1769987935916-2a72e6d5dacd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8Y29va2Jvb2slMjBraXRjaGVufGVufDB8Mnx8fDE3ODc1OTg2OTZ8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1769987935916-2a72e6d5dacd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8Y29va2Jvb2slMjBraXRjaGVufGVufDB8Mnx8fDE3ODc1OTg2OTZ8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- biography-collection (product_id = 44)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 44
    AND thumbnail_url = N'https://images.unsplash.com/photo-1471970471555-19d4b113e9ed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8YmlvZ3JhcGh5JTIwYm9va3MlMjBzdGFja3xlbnwwfDJ8fHwxNzg3NTk4Njk4fDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  44,
  N'biography-collection-0-1471970471555.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1471970471555-19d4b113e9ed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8YmlvZ3JhcGh5JTIwYm9va3MlMjBzdGFja3xlbnwwfDJ8fHwxNzg3NTk4Njk4fDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1471970471555-19d4b113e9ed?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8YmlvZ3JhcGh5JTIwYm9va3MlMjBzdGFja3xlbnwwfDJ8fHwxNzg3NTk4Njk4fDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- vitamin-c-serum (product_id = 45)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 45
    AND thumbnail_url = N'https://images.unsplash.com/photo-1710410815589-dd83514104d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8c2tpbmNhcmUlMjBzZXJ1bSUyMGJvdHRsZXxlbnwwfDJ8fHwxNzg3NTk4NzAwfDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  45,
  N'vitamin-c-serum-0-1710410815589.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1710410815589-dd83514104d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8c2tpbmNhcmUlMjBzZXJ1bSUyMGJvdHRsZXxlbnwwfDJ8fHwxNzg3NTk4NzAwfDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1710410815589-dd83514104d0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8c2tpbmNhcmUlMjBzZXJ1bSUyMGJvdHRsZXxlbnwwfDJ8fHwxNzg3NTk4NzAwfDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 45
    AND thumbnail_url = N'https://images.unsplash.com/photo-1781948237644-4bb872b37c79?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8Mnx8c2tpbmNhcmUlMjBzZXJ1bSUyMGJvdHRsZXxlbnwwfDJ8fHwxNzg3NTk4NzAwfDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  45,
  N'vitamin-c-serum-1-1781948237644.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1781948237644-4bb872b37c79?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8Mnx8c2tpbmNhcmUlMjBzZXJ1bSUyMGJvdHRsZXxlbnwwfDJ8fHwxNzg3NTk4NzAwfDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1781948237644-4bb872b37c79?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8Mnx8c2tpbmNhcmUlMjBzZXJ1bSUyMGJvdHRsZXxlbnwwfDJ8fHwxNzg3NTk4NzAwfDA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- daily-moisturizer-cream (product_id = 46)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 46
    AND thumbnail_url = N'https://images.unsplash.com/photo-1763503836825-97f5450d155a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8bW9pc3R1cml6ZXIlMjBjcmVhbSUyMGphcnxlbnwwfDJ8fHwxNzg3NTk4NzAyfDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  46,
  N'daily-moisturizer-cream-0-1763503836825.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1763503836825-97f5450d155a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8bW9pc3R1cml6ZXIlMjBjcmVhbSUyMGphcnxlbnwwfDJ8fHwxNzg3NTk4NzAyfDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1763503836825-97f5450d155a?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8bW9pc3R1cml6ZXIlMjBjcmVhbSUyMGphcnxlbnwwfDJ8fHwxNzg3NTk4NzAyfDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- mineral-sunscreen-spf50 (product_id = 47)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 47
    AND thumbnail_url = N'https://images.unsplash.com/photo-1623676714504-edd78728155e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8c3Vuc2NyZWVuJTIwYm90dGxlJTIwcHJvZHVjdHxlbnwwfDJ8fHwxNzg3NTk4NzAzfDA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  47,
  N'mineral-sunscreen-spf50-0-1623676714504.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1623676714504-edd78728155e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8c3Vuc2NyZWVuJTIwYm90dGxlJTIwcHJvZHVjdHxlbnwwfDJ8fHwxNzg3NTk4NzAzfDA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1623676714504-edd78728155e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8c3Vuc2NyZWVuJTIwYm90dGxlJTIwcHJvZHVjdHxlbnwwfDJ8fHwxNzg3NTk4NzAzfDA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- matte-lipstick-set (product_id = 48)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 48
    AND thumbnail_url = N'https://images.unsplash.com/photo-1598452963314-b09f397a5c48?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8bGlwc3RpY2slMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg3MDV8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  48,
  N'matte-lipstick-set-0-1598452963314.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1598452963314-b09f397a5c48?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8bGlwc3RpY2slMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg3MDV8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1598452963314-b09f397a5c48?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8bGlwc3RpY2slMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg3MDV8MA&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 48
    AND thumbnail_url = N'https://images.unsplash.com/photo-1614159102350-fc3c9eedead5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8Mnx8bGlwc3RpY2slMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg3MDV8MA&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  48,
  N'matte-lipstick-set-1-1614159102350.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1614159102350-fc3c9eedead5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8Mnx8bGlwc3RpY2slMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg3MDV8MA&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1614159102350-fc3c9eedead5?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8Mnx8bGlwc3RpY2slMjBmbGF0JTIwbGF5fGVufDB8Mnx8fDE3ODc1OTg3MDV8MA&ixlib=rb-4.1.0&q=80&w=1080',
  0,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- eyeshadow-palette (product_id = 49)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 49
    AND thumbnail_url = N'https://images.unsplash.com/photo-1596462502278-27bfdc403348?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8ZXllc2hhZG93JTIwcGFsZXR0ZSUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5ODcwN3ww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  49,
  N'eyeshadow-palette-0-1596462502278.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1596462502278-27bfdc403348?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8ZXllc2hhZG93JTIwcGFsZXR0ZSUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5ODcwN3ww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1596462502278-27bfdc403348?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8ZXllc2hhZG93JTIwcGFsZXR0ZSUyMGZsYXQlMjBsYXl8ZW58MHwyfHx8MTc4NzU5ODcwN3ww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);


-- liquid-foundation-bottle (product_id = 50)
IF NOT EXISTS (
  SELECT 1 FROM images
  WHERE product_id = 50
    AND thumbnail_url = N'https://images.unsplash.com/photo-1647507653704-bde7f2d6dbf0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8Zm91bmRhdGlvbiUyMGJvdHRsZSUyMHByb2R1Y3R8ZW58MHwyfHx8MTc4NzU5ODcwOXww&ixlib=rb-4.1.0&q=80&w=400'
)
INSERT INTO images (product_id, original_filename, status, thumbnail_url, preview_url, is_primary, created_by, created_at, processed_at)
VALUES (
  50,
  N'liquid-foundation-bottle-0-1647507653704.jpg',
  N'processed',
  N'https://images.unsplash.com/photo-1647507653704-bde7f2d6dbf0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8Zm91bmRhdGlvbiUyMGJvdHRsZSUyMHByb2R1Y3R8ZW58MHwyfHx8MTc4NzU5ODcwOXww&ixlib=rb-4.1.0&q=80&w=400',
  N'https://images.unsplash.com/photo-1647507653704-bde7f2d6dbf0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMDQyMDQ4fDB8MXxzZWFyY2h8MXx8Zm91bmRhdGlvbiUyMGJvdHRsZSUyMHByb2R1Y3R8ZW58MHwyfHx8MTc4NzU5ODcwOXww&ixlib=rb-4.1.0&q=80&w=1080',
  1,
  @SeedUserId,
  DATEADD(SECOND, -30, SYSUTCDATETIME()),
  SYSUTCDATETIME()
);

