import { checkoutService, getOrderByIdService, getOrdersService, transitionOrderStatusService } from "../services/order.service.js";
import { mapSqlError } from "../utils/appError.js";
import { getLogger } from "../utils/logger.js";
import { sendSuccess } from "../utils/response.js";


export const index = async (req, res, next) => {
  try {
    const { page, pageSize, sortOrder } = req.validatedQuery;

    const result = await getOrdersService({
      userId: req.user.userId,
      page,
      pageSize,
      sortOrder,
    });

    return sendSuccess(res, {
      data: result.orders,
      pagination: result.pagination,
      message: "Orders fetched successfully",
    });
  } catch (err) {
    getLogger().error({ err }, "Failed to fetch orders");
    next(mapSqlError(err));
  }
};



export const placeOrder = async (req, res, next) => {
  try {
    const userId = req.user.userId;
    const { addressId, idempotencyKey } = req.body;
    const authHeader = req.headers.authorization;

    const order = await checkoutService({
      userId,
      addressId,
      idempotencyKey,
      authHeader,
    });

    return sendSuccess(res, {
      status: 201,
      data: order,
      message: "Order placed successfully",
    });
  } catch (err) {
    getLogger().error({ err, userId: req.user?.userId }, "Checkout failed");
    next(mapSqlError(err));
  }
};




export const adminIndex = async (req, res, next) => {
  try {
    const { page, pageSize, sortOrder, status } = req.validatedQuery;
    const result = await getOrdersService({
      userId: null,
      status,
      page,
      pageSize,
      sortOrder,
    });

    return sendSuccess(res, {
      data: result.orders,
      pagination: result.pagination,
      message: "All orders fetched successfully",
    });
  } catch (err) {
    getLogger().error({ err }, "Failed to fetch admin order list");
    next(mapSqlError(err));
  }
};

/**
 * GET /orders/:id
 * Retrieve details for a specific order by ID
 */
export const show = async (req, res, next) => {
  try {
    const { id } = req.params;
    const isAdmin = req.user.roles.includes("Admin");
    const order = await getOrderByIdService(id, {
      userId: req.user.userId,
      isAdmin,
    });

    return sendSuccess(res, {
      data: order,
      message: "Order fetched successfully",
    });
  } catch (err) {
    getLogger().error({ err }, "Get order by ID failed");
    next(mapSqlError(err));
  }
};


/**
 * PUT /orders/:id/status
 * Update order status
 */
export const updateOrderStatus = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { newStatus } = req.body;
    const { roles, userId } = req.user;

    const updatedOrder = await transitionOrderStatusService({
      orderId: id,
      newStatus,
      roles,
      userId,
    });

    return sendSuccess(res, {
      data: updatedOrder,
      message: "Order status updated successfully.",
    });
  } catch (err) {
    getLogger().error({ err }, "Update order status failed");
    next(mapSqlError(err));
  }
};



export const cancelOrder = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { roles, userId } = req.user;

    const cancelledOrder = await transitionOrderStatusService({
      orderId: id,
      newStatus: "Cancelled",
      roles,
      userId,
    });

    return sendSuccess(res, {
      data: cancelledOrder,
      message: "Order cancelled successfully.",
    });
  } catch (err) {
    getLogger().error(
      { err },
      "Order cancellation failed",
    );
    next(mapSqlError(err));
  }
};
