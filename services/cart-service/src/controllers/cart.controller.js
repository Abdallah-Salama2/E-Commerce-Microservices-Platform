import {
  addItemToCartService,
  getCartService,
  updateCartItemQuantityService,
  removeCartItemService,
  clearCartService,
  mergeGuestCartService,
} from "../services/cart.service.js";
import { getLogger } from "../utils/logger.js";
import { sendSuccess } from "../utils/response.js";

export const index = async (req, res, next) => {
  try {
    const cart = await getCartService({
      userId: req.user?.userId ?? null,
      guestSessionId: req.user ? null : req.guestSessionId,
    });

    return sendSuccess(res, {
      data: cart,
      message: "Cart fetched successfully",
    });
  } catch (err) {
    getLogger().error({ err }, "Failed to fetch cart");
    next(err);
  }
};

export const store = async (req, res, next) => {
  try {
    const { productId, quantity } = req.body;

    const result = await addItemToCartService({
      userId: req.user?.userId ?? null,
      guestSessionId: req.user ? null : req.guestSessionId,
      productId,
      quantity,
    });

    return sendSuccess(res, {
      status: 201,
      data: result,
      message: "Item added to cart successfully",
    });
  } catch (err) {
    getLogger().error({ err, body: req.body }, "Failed to add item to cart");
    next(err);
  }
};

export const update = async (req, res, next) => {
  try {
    const { productId } = req.params;
    const { quantity } = req.body;

    const result = await updateCartItemQuantityService({
      userId: req.user?.userId ?? null,
      guestSessionId: req.user ? null : req.guestSessionId,
      productId: Number(productId),
      quantity,
    });

    return sendSuccess(res, {
      data: result,
      message: "Cart item quantity updated successfully",
    });
  } catch (err) {
    getLogger().error(
      { err, productId: req.params.productId },
      "Failed to update cart item",
    );
    next(err);
  }
};

export const removeCartItem = async (req, res, next) => {
  try {
    const { productId } = req.params;

    const result = await removeCartItemService({
      userId: req.user?.userId ?? null,
      guestSessionId: req.user ? null : req.guestSessionId,
      productId: Number(productId),
    });

    return sendSuccess(res, {
      data: result,
      message: "Item removed from cart successfully",
    });
  } catch (err) {
    getLogger().error(
      { err, productId: req.params.productId },
      "Failed to remove cart item",
    );
    next(err);
  }
};

export const clearCart = async (req, res, next) => {
  try {
    const result = await clearCartService({
      userId: req.user?.userId ?? null,
      guestSessionId: req.user ? null : req.guestSessionId,
    });

    return sendSuccess(res, {
      data: result,
      message: "Cart cleared successfully",
    });
  } catch (err) {
    getLogger().error({ err }, "Failed to clear cart");
    next(err);
  }
};

/**
 * Internal endpoint -- called by identity-service's login flow, never by
 * the browser directly. Both userId and guestSessionId come from the
 * request body explicitly (see cart.routes.js for why this bypasses
 * cartOwner entirely).
 */
export const mergeCart = async (req, res, next) => {
  try {
    const { userId, guestSessionId } = req.body;

    const result = await mergeGuestCartService({ userId, guestSessionId });

    return sendSuccess(res, {
      data: result,
      message: "Guest cart merged successfully",
    });
  } catch (err) {
    getLogger().error({ err, body: req.body }, "Failed to merge guest cart");
    next(err);
  }
};
