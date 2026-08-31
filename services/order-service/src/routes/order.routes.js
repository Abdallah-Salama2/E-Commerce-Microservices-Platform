import { Router } from "express";
import { authenticate } from "../middlewares/auth.middleware.js";
import { authorize } from "../middlewares/role.middleware.js";
import { validate } from "../middlewares/validate.middleware.js";
import {
  index,
  adminIndex,
  show,
  placeOrder,
  updateOrderStatus,
  cancelOrder,
} from "../controllers/order.controller.js";
import {
  placeOrderSchema,
  updateOrderStatusSchema,
  getOrdersQuerySchema,
  orderIdParamSchema,
} from "../validations/order.validation.js";
import { checkoutLimiter } from "../middlewares/rateLimiter.middleware.js";

const router = Router();

router.use(authenticate); // no guest access to any order route

router.get("/", validate(getOrdersQuerySchema, "query"), index);

router.get(
  "/admin",
  authorize("Admin"),
  validate(getOrdersQuerySchema, "query"),
  adminIndex,
);

router.get(
  "/:id", 
  validate(orderIdParamSchema, "params"), 
  show
);

router.post(
  "/",
  checkoutLimiter,
  validate(placeOrderSchema, "body"),
  placeOrder,
);

router.put(
  "/:id/status",
  authorize("Admin"),
  validate(orderIdParamSchema, "params"),
  validate(updateOrderStatusSchema, "body"),
  updateOrderStatus,
);

router.patch(
  "/:id/cancel", 
  validate(orderIdParamSchema, "params"), 
  cancelOrder
);

export default router;