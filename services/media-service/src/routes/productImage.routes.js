import { Router } from "express";
import { authenticate } from "../middlewares/auth.middleware.js";
import { authorize } from "../middlewares/role.middleware.js";
import { uploadSingleImage } from "../middlewares/upload.image.middleware.js";
import { validate } from "../middlewares/validate.middleware.js";
import {
  imagesBatchQuerySchema,
  productIdParamSchema,
  productImageParamSchema,
} from "../validations/productImage.validation.js";
import {
  deleteImage,
  listProductImages,
  listProductImagesBatch,
  setPrimaryImage,
  uploadProductImage,
} from "../controllers/image.controller.js";
const router = Router();

router.post(
  "/products/:id/images",
  authenticate,
  authorize("Admin"),
  validate(productIdParamSchema, "params"),
  uploadSingleImage,
  uploadProductImage,
);

router.get("/products/images/batch", validate(imagesBatchQuerySchema, "query"), listProductImagesBatch);


router.get(
  "/products/:id/images",
  validate(productIdParamSchema, "params"),
  listProductImages,
);

router.delete(
  "/products/:id/images/:imageId",
  authenticate,
  authorize("Admin"),
  validate(productImageParamSchema, "params"),
  deleteImage,
);

router.patch(
  "/products/:id/images/:imageId/primary",
  authenticate,
  authorize("Admin"),
  validate(productImageParamSchema, "params"),
  setPrimaryImage,
);
export default router;
