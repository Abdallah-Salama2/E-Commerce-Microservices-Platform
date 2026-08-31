import { BaseRepository } from "../repositories/base.repository.js";
import { getCart } from "../clients/cart.client.js";
import { getProductsByIds } from "../clients/catalog.client.js";
import { getAddressById } from "../clients/identity.client.js";
import { AppError } from "../utils/appError.js";
import mssql from "mssql";
import { canTransitionTo } from "../utils/orderRules.js";

export const checkoutService = async (
  { userId, addressId, idempotencyKey, authHeader },
  repo = new BaseRepository(),
) => {
  const cart = await getCart(authHeader);
  // console.log(cart);
  if (!cart.items || cart.items.length === 0) {
    throw new AppError("Cart is empty", 400);
  }

  const productIds = cart.items.map((item) => item.productId);
  const freshProducts = await getProductsByIds(productIds);

  // Build a lookup so we can check each cart item against fresh catalog data
  const freshById = new Map(freshProducts.map((p) => [p.id, p]));

  const invalidItems = cart.items.filter((item) => {
    const fresh = freshById.get(String(item.productId));
    return !fresh || fresh.isActive === false;
  });

  if (invalidItems.length > 0) {
    const names = invalidItems.map((item) => item.name).join(", ");
    throw new AppError(
      `The following items are no longer available: ${names}`,
      400,
    );
  }
  const address = await getAddressById(addressId, authHeader);

  const shippingAddressSnapshot = JSON.stringify({
    fullName: address.fullName,
    phone: address.phone,
    line1: address.line1,
    line2: address.line2,
    city: address.city,
    governorate: address.governorate,
    country: address.country,
    postalCode: address.postalCode,
  });

  // Recompute subtotal from FRESH catalog prices, not cart's cached price —
  // cart.subtotal could be stale if prices changed since items were added
  const orderItems = cart.items.map((item) => {
    const fresh = freshById.get(String(item.productId)); // same fix here
    return {
      productId: item.productId,
      quantity: item.quantity,
      unitPriceSnapshot: fresh.price,
      productNameSnapshot: fresh.name,
    };
  });
  const subtotal = orderItems.reduce(
    (sum, item) => sum + item.unitPriceSnapshot * item.quantity,
    0,
  );

  // next piece: idempotency check + the actual INSERT transaction, using
  // orderItems + subtotal computed above

  const rows = await repo.execute("place_order", [
    { name: "UserId", type: mssql.BigInt, value: userId },
    {
      name: "IdempotencyKey",
      type: mssql.UniqueIdentifier,
      value: idempotencyKey,
    },
    {
      name: "ShippingAddressSnapshot",
      type: mssql.NVarChar(mssql.MAX),
      value: shippingAddressSnapshot,
    },
    { name: "Subtotal", type: mssql.Decimal(10, 2), value: subtotal },
    {
      name: "OrderItemsJson",
      type: mssql.NVarChar(mssql.MAX),
      value: JSON.stringify(orderItems),
    },
  ]);
  return rows[0];
};

/**
 * @param {BaseRepository} [repo] - Repository instance (defaults to a real DB-backed one; override in tests with a fake).
 */
export const getOrdersService = async (
  { userId = null, status = null, sortOrder = "DESC", page = 1, pageSize = 20 },
  repo = new BaseRepository(),
) => {
  const [countRows, rows] = await repo.executeMultiple("get_orders", [
    { name: "UserId", type: mssql.BigInt, value: userId },
    { name: "Status", type: mssql.NVarChar(20), value: status },
    { name: "SortOrder", type: mssql.NVarChar(4), value: sortOrder },
    { name: "Page", type: mssql.Int, value: page },
    { name: "PageSize", type: mssql.Int, value: pageSize },
  ]);

  const totalCount = countRows[0]?.totalCount ?? 0;
  return {
    orders: rows,
    pagination: {
      totalItems: totalCount,
      totalPages: Math.ceil(totalCount / pageSize),
      currentPage: page,
      pageSize,
    },
  };
};


/**
 * Fetches order details along with the list of items (Order + Items)
 *
 * @param {number|string} orderId
 * @param {BaseRepository} [repo] - Repository instance (defaults to a real DB-backed one; override in tests with a fake).
 */
export const getOrderByIdService = async (
  orderId,
  { userId, isAdmin } = {},
  repo = new BaseRepository(),
) => {
  const [orders, items] = await repo.executeMultiple("get_order_by_id", [
    { name: "Id", type: mssql.BigInt, value: orderId },
    { name: "UserId", type: mssql.BigInt, value: isAdmin ? null : userId },
  ]);

  if (!orders || orders.length === 0) {
    throw new AppError("Order not found.", 404);
  }

  const order = orders[0];
  order.items = items || [];
  return order;
};



/**
 * Safely and concurrently transitions an order status
 *
 * @param {BaseRepository} [repo] - Repository instance (defaults to a real DB-backed one; override in tests with a fake).
 */
export const transitionOrderStatusService = async (
  { orderId, newStatus, roles, userId },
  repo = new BaseRepository(),
) => {
  const isAdmin = roles.includes("Admin");
  const current = await getOrderByIdService(orderId, { userId, isAdmin }, repo);

  const allowed = roles.some((role) => canTransitionTo(current.status, newStatus, role));
  if (!allowed) {
    throw new AppError(
      `Transitioning order from '${current.status}' to '${newStatus}' is not allowed for your role(s).`,
      400,
    );
  }

  // Cancellation always routes through cancel_order, regardless of
  // whether it came from PATCH /:id/cancel or an admin's PUT /:id/status —
  // it's the only transition that notifies AND conditionally releases
  // stock, so there must be exactly one place that logic can happen.
  if (newStatus === "Cancelled") {
    const rows = await repo.execute("cancel_order", [
      { name: "Id", type: mssql.BigInt, value: orderId },
      { name: "ExpectedCurrentStatus", type: mssql.NVarChar(20), value: current.status },
      { name: "UpdatedBy", type: mssql.BigInt, value: userId },
    ]);
    return rows[0];
  }

  const rows = await repo.execute("transition_order_status", [
    { name: "Id", type: mssql.BigInt, value: orderId },
    { name: "ExpectedCurrentStatus", type: mssql.NVarChar(20), value: current.status },
    { name: "NewStatus", type: mssql.NVarChar(20), value: newStatus },
    { name: "UpdatedBy", type: mssql.BigInt, value: userId },
  ]);
  return rows[0];
};