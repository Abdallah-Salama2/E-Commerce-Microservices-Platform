import { Router } from "express";
import {
  index,
  store,
  update,
  removeCartItem,
  clearCart,
  mergeCart,
} from "../controllers/cart.controller.js";
import { cartOwner } from "../middlewares/cartOwner.middleware.js";
import { validate } from "../middlewares/validate.middleware.js";
import {
  addCartItemSchema,
  updateCartItemSchema,
  productIdParamSchema,
  mergeCartSchema,
} from "../validations/cart.validation.js";

const router = Router();

// /merge is registered BEFORE router.use(cartOwner) below -- Express runs
// middleware/routes in registration order, and this route sends its own
// response without calling next(), so it never reaches cartOwner at all.
// This is the ONE route that must skip it: cartOwner infers a SINGLE
// identity per request (JWT or guest cookie), while merge needs BOTH ids
// explicitly, since it's combining two different identities' carts into
// one. It's also an internal, service-to-service call (identity-service ->
// here on login), not something the browser calls directly.
router.post("/merge", validate(mergeCartSchema, "body"), mergeCart);

// Everything registered from here on gets cartOwner automatically.
router.use(cartOwner);

router.get("/", index);

router.post("/items", validate(addCartItemSchema, "body"), store);

router.patch(
  "/items/:productId",
  validate(productIdParamSchema, "params"),
  validate(updateCartItemSchema, "body"),
  update,
);

router.delete(
  "/items/:productId",
  validate(productIdParamSchema, "params"),
  removeCartItem,
);

router.delete("/", clearCart);

export default router;