import mssql from "mssql";
import fs from "fs/promises";
import path from "path";
import crypto from "crypto";
import { BaseRepository } from "../repositories/base.repository.js";
import { getOrSetCache } from "../utils/cacheAside.js";
import redis from "../config/redis.config.js";
import { getLogger } from "../utils/logger.js";
const UPLOAD_DIR = path.join(process.cwd(), "public", "uploads", "products");

const imagesCacheKey = (productId) => `images:product:${productId}`;
export const invalidateProductImagesCache = async (productId) => {
  try {
    await redis.del(imagesCacheKey(productId));
  } catch (err) {
    getLogger().error(
      { err, productId },
      "Failed to invalidate product images cache",
    );
    // swallowed deliberately — same philosophy as getOrSetCache: a cache
    // failure must never surface as if the actual write (which already
    // succeeded in SQL Server) had failed
  }
};
export const addProductImageService = async (
  { productId, fileBuffer, originalFilename, createdBy },
  repo = new BaseRepository(),
) => {
  await fs.mkdir(UPLOAD_DIR, { recursive: true });

  const rawFilename = `${crypto.randomUUID()}-raw${path.extname(originalFilename)}`;
  const rawFilePath = path.join(UPLOAD_DIR, rawFilename);
  const publicRawPath = `/uploads/products/${rawFilename}`;

  await fs.writeFile(rawFilePath, fileBuffer);

  try {
    const rows = await repo.execute("create_pending_image", [
      { name: "ProductId", type: mssql.BigInt, value: productId },
      {
        name: "OriginalFilename",
        type: mssql.NVarChar(500),
        value: originalFilename,
      },
      { name: "CreatedBy", type: mssql.BigInt, value: createdBy },
      { name: "RawFilePath", type: mssql.NVarChar(500), value: publicRawPath },
    ]);
    return rows[0];
  } catch (err) {
    // compensating cleanup — same instinct as the monolith version, just
    // now protecting the RAW file instead of the resized variants
    await fs.unlink(rawFilePath).catch(() => {});
    throw err;
  }
};


export const getProductImagesService = async (
  productId,
  repo = new BaseRepository(),
) => {
  return getOrSetCache(
    imagesCacheKey(productId),
    async () => {
      return repo.execute("get_processed_images_by_product", [
        { name: "ProductId", type: mssql.BigInt, value: productId },
      ]);
    },
    300, // 5 min base TTL — images change rarely, a slightly stale list for a few minutes is a non-issue
  );
};

export const deleteProductImageService = async (
  { productId, imageId },
  repo = new BaseRepository(),
) => {
  const rows = await repo.execute("delete_product_image", [
    { name: "ProductId", type: mssql.BigInt, value: productId },
    { name: "ImageId", type: mssql.BigInt, value: imageId },
  ]);
  await invalidateProductImagesCache(productId);

  const { thumbnailUrl, previewUrl } = rows[0] ?? {};

  // Best-effort — matches the monolith's own pattern. A missing/already-
  // gone file shouldn't block the DB deletion from having already succeeded.
  if (thumbnailUrl) {
    await fs
      .unlink(path.join(process.cwd(), "public", thumbnailUrl))
      .catch(() => {});
  }
  if (previewUrl) {
    await fs
      .unlink(path.join(process.cwd(), "public", previewUrl))
      .catch(() => {});
  }
};

export const setPrimaryImageService = async (
  { productId, imageId },
  repo = new BaseRepository(),
) => {
  const rows = await repo.execute("set_primary_image", [
    { name: "ProductId", type: mssql.BigInt, value: productId },
    { name: "ImageId", type: mssql.BigInt, value: imageId },
  ]);
  await invalidateProductImagesCache(productId);

  return rows[0];
};


export const getProductPrimaryImagesBatchService = async (productIds) => {
  const results = await Promise.all(
    productIds.map(async (productId) => {
      // Reuses the SAME per-product cache as the single-product endpoint —
      // a batch of 20 cards means 20 cheap parallel Redis reads (mostly
      // cache hits after the first page load), not 20 HTTP round trips
      // from the frontend and not 20 fresh SQL Server queries either.
      const images = await getProductImagesService(productId);
      const primary = images.find((img) => img.isPrimary) ?? images[0] ?? null;
      return primary ? { productId, thumbnailUrl: primary.thumbnailUrl } : null;
    }),
  );
  // Omit products with no processed image at all — matches catalog's own
  // batch endpoint convention of silently omitting nonexistent/invalid ids
  // rather than returning nulls the frontend has to filter out itself.
  return results.filter(Boolean);
};
