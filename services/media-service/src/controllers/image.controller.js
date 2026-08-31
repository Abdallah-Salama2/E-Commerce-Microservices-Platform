import {
  addProductImageService,
  deleteProductImageService,
  getProductImagesService,
  getProductPrimaryImagesBatchService,
  setPrimaryImageService,
} from "../services/image.service.js";
import { getProductsByIds } from "../clients/catalog.client.js";
import { AppError, mapSqlError } from "../utils/appError.js";
import { getLogger } from "../utils/logger.js";
import { sendSuccess } from "../utils/response.js";

export const uploadProductImage = async (req, res, next) => {
  try {
    const { id } = req.params;

    if (!req.file) {
      return next(
        new AppError(
          "Please provide an image file under the 'image' field",
          400,
        ),
      );
    }
    console.log("id param:", JSON.stringify(id));
    const [product] = await getProductsByIds([id]);
    if (!product) {
      return next(new AppError("Product not found", 404));
    }

    const image = await addProductImageService({
      productId: id,
      fileBuffer: req.file.buffer,
      originalFilename: req.file.originalname,
      createdBy: req.user.userId,
    });

    return sendSuccess(res, {
      status: 201,
      data: image,
      message: "Image uploaded, processing in background",
    });
  } catch (err) {
    getLogger().error(
      { err, productId: req.params.id },
      "Failed to upload product image",
    );
    next(mapSqlError(err));
  }
};

// Public, read-only — no auth. Anyone browsing the storefront needs to
// see product images; this isn't an admin action like upload/delete.
export const listProductImages = async (req, res, next) => {
  try {
    const { id } = req.params;
    const images = await getProductImagesService(id);

    return sendSuccess(res, {
      data: images,
      message: "Product images fetched successfully",
    });
  } catch (err) {
    getLogger().error(
      { err, productId: req.params.id },
      "Failed to fetch product images",
    );
    next(mapSqlError(err));
  }
};

export const deleteImage = async (req, res, next) => {
  try {
    const { id, imageId } = req.params;
    await deleteProductImageService({ productId: id, imageId });
    return sendSuccess(res, {
      message: "Product image deleted successfully",
      data: null,
    });
  } catch (err) {
    getLogger().error(
      { err, productId: req.params.id, imageId: req.params.imageId },
      "Failed to delete product image",
    );
    next(mapSqlError(err));
  }
};

export const setPrimaryImage = async (req, res, next) => {
  try {
    const { id, imageId } = req.params;
    const updated = await setPrimaryImageService({ productId: id, imageId });
    return sendSuccess(res, {
      data: updated,
      message: "Primary product image updated successfully",
    });
  } catch (err) {
    getLogger().error(
      { err, productId: req.params.id, imageId: req.params.imageId },
      "Failed to set primary product image",
    );
    next(mapSqlError(err));
  }
};


export const listProductImagesBatch = async (req, res, next) => {
  try {
    const productIds = req.validatedQuery.ids.split(",").map(Number);
    const images = await getProductPrimaryImagesBatchService(productIds);

    return sendSuccess(res, {
      data: images,
      message: "Product thumbnails fetched successfully",
    });
  } catch (err) {
    getLogger().error({ err, ids: req.query.ids }, "Failed to fetch batch product images");
    next(mapSqlError(err));
  }
};