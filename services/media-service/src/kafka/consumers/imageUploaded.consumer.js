// media-service/src/kafka/consumers/imageUploaded.consumer.js
import mssql from "mssql";
import sharp from "sharp";
import fs from "fs/promises";
import path from "path";
import crypto from "crypto";
import { BaseRepository } from "../../repositories/base.repository.js";
import { getLogger } from "../../utils/logger.js";
import { invalidateProductImagesCache } from "../../services/image.service.js";

const UPLOAD_DIR = path.join(process.cwd(), "public", "uploads", "products");

export const parseMessage = (message) => {
  return JSON.parse(String(message.value));
};

export const handleImageUploaded = async (
  { imageId, productId, rawFilePath },
  repo = new BaseRepository(),
) => {
  // Step 1 — claim the work. This IS the idempotency guard: a redelivered
  // image.uploaded for something already 'processing' or 'processed'
  // updates zero rows, so `claimed` comes back 0 and we skip everything below.
  const claimRows = await repo.execute("claim_image_for_processing", [
    { name: "ImageId", type: mssql.BigInt, value: imageId },
  ]);
  const claimed = claimRows[0]?.claimed;

  if (!claimed) {
    getLogger().info(
      { imageId },
      "image.uploaded already processed or in progress, skipping",
    );
    return;
  }

  // Step 2 — the actual slow work, deliberately OUTSIDE any transaction.
  // rawFilePath is a PUBLIC url path (e.g. "/uploads/products/xxx-raw.jpg"),
  // so it needs to be resolved back to a real disk path under ./public
  // before fs can read it.
  const absoluteRawPath = path.join(process.cwd(), "public", rawFilePath);
  const fileBuffer = await fs.readFile(absoluteRawPath);

  const baseFilename = crypto.randomUUID();
  const thumbnailFilename = `${baseFilename}-thumb.webp`;
  const previewFilename = `${baseFilename}-preview.webp`;
  const thumbnailPath = path.join(UPLOAD_DIR, thumbnailFilename);
  const previewPath = path.join(UPLOAD_DIR, previewFilename);

  const thumbnailBuffer = await sharp(fileBuffer)
    .resize(400, 400, { fit: "inside", withoutEnlargement: true })
    .webp({ quality: 70 })
    .toBuffer();

  const previewBuffer = await sharp(fileBuffer)
    .resize(1600, 1600, { fit: "inside", withoutEnlargement: true })
    .webp({ quality: 82 })
    .toBuffer();

  await fs.writeFile(thumbnailPath, thumbnailBuffer);
  await fs.writeFile(previewPath, previewBuffer);

  const thumbnailUrl = `/uploads/products/${thumbnailFilename}`;
  const previewUrl = `/uploads/products/${previewFilename}`;

  // Step 3 — record the result. Note: we already claimed this row
  // successfully in step 1, so there's no idempotency concern here — this
  // only runs once per successful claim, ever.
  await repo.execute("complete_image_processing", [
    { name: "ImageId", type: mssql.BigInt, value: imageId },
    { name: "ProductId", type: mssql.BigInt, value: productId },
    { name: "ThumbnailUrl", type: mssql.NVarChar(500), value: thumbnailUrl },
    { name: "PreviewUrl", type: mssql.NVarChar(500), value: previewUrl },
    { name: "IsPrimary", type: mssql.Bit, value: 0 }, // matches monolith default — altText/isPrimary aren't settable on upload
  ]);
  await invalidateProductImagesCache(productId);
  getLogger().info({ imageId, productId }, "Image processed successfully");
};
