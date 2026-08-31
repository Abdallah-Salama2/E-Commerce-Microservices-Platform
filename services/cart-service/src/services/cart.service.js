import axios from "axios";
import { env } from "../config/env.js";
import { AppError } from "../utils/appError.js";
import redis from "../config/redis.config.js";
import { getProductsByIds } from "../clients/catalog.client.js";
import { getStocksByIds } from "../clients/stock.client.js";

const GUEST_CART_TTL = 30 * 24 * 60 * 60; // 30 days in seconds

const cartKeyFor = ({ userId, guestSessionId }) => {
  if (userId) return `cart:user:${userId}`;
  if (guestSessionId) return `cart:guest:${guestSessionId}`;
  throw new AppError("userId or guestSessionId is required", 400);
};




/**
 * Returns the full current cart with LIVE price/name resolved from
 * catalog-service in ONE batch call -- never per-item. Items whose
 * product no longer exists or has been deactivated since being added
 * are still returned (isAvailable: false), not silently dropped --
 * same "surface it, don't hide it" precedent as the monolith's
 * isOverStock flag. subtotal only counts available items; itemCount
 * counts everything, matching the monolith's existing convention.
 */
export const getCartService = async ({
  userId = null,
  guestSessionId = null,
}) => {
  const cartKey = cartKeyFor({ userId, guestSessionId });

  const rawCart = await redis.hgetall(cartKey); // { "26": "2", "31": "1" } {'productId':'quantity'}

  const productIds = Object.keys(rawCart); // get keys only  //[arrays of strings of product ids ]

  if (productIds.length === 0) {
    return { items: [], subtotal: 0, itemCount: 0 };
  }

  const [products, stocks] = await Promise.all([
    getProductsByIds(productIds.map(Number)),
    getStocksByIds(productIds.map(Number)),
  ]); //arrays of objects
  const productById = new Map(products.map((p) => [String(p.id), p])); // we used map cause it use hashtable to store values so searching it with o(1)
  // Map(2) {
  //   "productId" => { id: productId, name: "productName", price: productPrive, isActive: activeStatus },
  //   "31" => { id: 31, name: "Pants", price: 200, isActive: false }
  // }
  const stockById = new Map(
    stocks.map((s) => [String(s.product_id), s.quantity]),
  );

  // to return map in json form for api we loop each product and print quantuty ,etc  and store them in items array (act as key for the array of objects sent in response)
  const items = productIds.map((productId) => {
    const quantity = Number(rawCart[productId]);
    // O(1) Lookup using Map (Optimized performance)
    const product = productById.get(productId);
    // BAD PRACTICE ALTERNATIVE:
    // const product = products.find((p) => String(p.id) === productId);
    // ^ This would be O(N) lookup inside O(N) loop -> O(N^2) complexity

    const availableStock = stockById.get(productId) ?? 0;
    const isActive = Boolean(product?.isActive);
    const isOverStock = quantity > availableStock;

    return {
      productId: Number(productId),
      quantity,
      availableStock,
      name: product?.name ?? null,
      price: product?.price ?? null,
      isActive,
      isOverStock,
    };
  });

  const subtotal = items.reduce(
    (sum, item) => (item.isActive ? sum + item.price * item.quantity : sum),
    0,
  );
  const itemCount = items.reduce(
    (sum, item) => (item.isActive ? sum + item.quantity : sum),
    0,
  );
  return { items, subtotal, itemCount };
};

export const addItemToCartService = async ({
  userId = null,
  guestSessionId = null,
  productId,
  quantity,
}) => {
  const cartKey = cartKeyFor({ userId, guestSessionId });
  //get data for product id to be added to the cart since its added one by one for each request no need to loop just get index 0
  const [products, stocks] = await Promise.all([
    getProductsByIds([productId]),
    getStocksByIds([productId]),
  ]);
  const product = products[0];
  const availableStock = stocks[0]?.quantity ?? 0;

  if (!product || !product.isActive) {
    throw new AppError("Product not found or is no longer available", 400);
  }

  const currentInCart = Number(
    (await redis.hget(cartKey, String(productId))) || 0,
  );
  if (currentInCart + quantity > availableStock) {
    throw new AppError(
      `Cannot add more. Only ${availableStock} items available in stock`,
      400,
    );
  }

  // Atomically increment the quantity of the specific productId field inside the Redis Hash
  const newQuantity = await redis.hincrby(cartKey, String(productId), quantity); //redis hashed used to stop race condition cuz its atomic , single threaded
  // Note: We can't use a pipeline here to manual read-modify-write, because pipeline just groups commands
  // without returning the intermediate 'hget' value to Node.js before execution.

  // if the one added to cart is guest not user set ttl for him
  if (!userId && guestSessionId) {
    await redis.expire(cartKey, GUEST_CART_TTL);
  }
  return {
    productId,
    quantity: newQuantity,
    name: product.name,
    price: product.price,
  };
};

export const updateCartItemQuantityService = async ({
  userId = null,
  guestSessionId = null,
  productId,
  quantity,
}) => {
  const cartKey = cartKeyFor({ userId, guestSessionId });
  //get data for product id to be added to the cart since its added one by one for each request no need to loop just get index 0
  const [products, stocks] = await Promise.all([
    getProductsByIds([productId]),
    getStocksByIds([productId]),
  ]);
  const product = products[0];
  const availableStock = stocks[0]?.quantity ?? 0;

  if (!product || !product.isActive) {
    throw new AppError("Product not found or is no longer available", 400);
  }
  const exists = await redis.hexists(cartKey, String(productId));
  if (!exists) {
    throw new AppError("Item not found in cart", 400);
  }

  if (quantity > availableStock) {
    throw new AppError(
      `Cannot add more. Only ${availableStock} items available in stock`,
      400,
    );
  }

  //update hset like set in sql server
  await redis.hset(cartKey, String(productId), quantity);

  //since operation occured in redis we reset ttl
  if (!userId && guestSessionId) {
    await redis.expire(cartKey, GUEST_CART_TTL);
  }
  return {
    productId,
    quantity: quantity,
    name: product.name,
    price: product.price,
  };
};

export const removeCartItemService = async ({
  userId = null,
  guestSessionId = null,
  productId,
}) => {
  const cartKey = cartKeyFor({ userId, guestSessionId });
  await redis.hdel(cartKey, String(productId));
  return { productId };
};

export const clearCartService = async ({
  userId = null,
  guestSessionId = null,
}) => {
  const cartKey = cartKeyFor({ userId, guestSessionId });
  await redis.del(cartKey);
  return { cleared: true, cartKey };
};

// ============================================================================
// Approach 2: Atomic Lua Script (Recommended)
// ============================================================================
export const mergeGuestCartService = async ({ userId, guestSessionId }) => {
  if (!userId || !guestSessionId) {
    throw new AppError("userId and guestSessionId are required", 400);
  }

  const guestKey = `cart:guest:${guestSessionId}`;
  const userKey = `cart:user:${userId}`;

  // Lua script runs atomically on the Redis server in a single operation
  const luaScript = `
    -- 1. Read all fields and values from the guest cart
    local guestItems = redis.call('HGETALL', KEYS[1])
    
    -- Return 0 if guest cart is empty
    if #guestItems == 0 then
      return 0
    end
    
    -- 2. Loop through guest items and add them to user cart
    -- HGETALL returns flat array [field1, value1, field2, value2], so step by 2
    for i = 1, #guestItems, 2 do
      local productId = guestItems[i]
      local quantity = guestItems[i+1]
      redis.call('HINCRBY', KEYS[2], productId, quantity)
    end
    
    -- 3. Delete the guest cart after transferring items
    redis.call('DEL', KEYS[1])
    
    return 1
  `;

  // Execute Lua script directly: 2 keys passed (KEYS[1] = guestKey, KEYS[2] = userKey)
  const result = await redis.eval(luaScript, 2, guestKey, userKey);

  if (result === 0) {
    return { merged: false, reason: "guest cart was empty or already merged" };
  }

  return { merged: true };
};

// ============================================================================
// Approach 1: Optimistic Locking with WATCH / MULTI / EXEC
// ============================================================================
// Commented out in favor of the atomic Lua Script approach below.
//
// export const mergeGuestCartService = async ({ userId, guestSessionId }) => {
//   if (!userId || !guestSessionId) {
//     throw new AppError("userId and guestSessionId are required", 400);
//   }
//
//   const guestKey = `cart:guest:${guestSessionId}`;
//   const userKey = `cart:user:${userId}`;
//
//   const MAX_ATTEMPTS = 5;
//   // Retry loop to handle concurrent updates during the merge process
//   for (let attempt = 1; attempt <= MAX_ATTEMPTS; attempt++) {
//     // Watch the guest key for any changes made by other concurrent requests
//     await redis.watch(guestKey);
//
//     // Fetch all items from the guest cart: { "26": "2", "31": "1" }
//     const guestItems = await redis.hgetall(guestKey);
//
//     // If the cart is empty, unwatch the key and exit early
//     if (Object.keys(guestItems).length === 0) {
//       await redis.unwatch();
//       return {
//         merged: false,
//         reason: "guest cart was empty or already merged",
//       };
//     }
//
//     // Start queuing transactional commands
//     const multi = redis.multi();
//
//     // Object.entries converts object { "26": "2" } into array of entries: [ [ "26", "2" ] ]
//     for (const [productId, quantity] of Object.entries(guestItems)) {
//       multi.hincrby(userKey, productId, Number(quantity));
//     }
//     // Delete guest cart after queuing transfers
//     multi.del(guestKey);
//
//     // Execute transaction. Returns null if guestKey was modified mid-operation
//     const execResult = await multi.exec();
//
//     // Transaction failed due to concurrent modification; retry loop
//     if (execResult === null) {
//       getLogger().warn(
//         { attempt, guestSessionId, userId },
//         "Guest cart changed mid-merge, retrying",
//       );
//       continue;
//     }
//
//     return { merged: true, attempt };
//   }
//
//   throw new AppError(
//     "Cart merge failed after multiple attempts due to concurrent activity",
//     409,
//   );
// };
