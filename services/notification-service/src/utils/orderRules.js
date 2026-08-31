// Map of allowed state transitions and authorized roles
export const ALLOWED_TRANSITIONS = {
  Pending: { Processing: ["Admin"], Cancelled: ["Admin", "Customer"] },

  // IMMEDIATELY BLOCKED: Cancelled removed to prevent inventory leaks.
  // TODO: Restore Cancelled once order.cancelled outbox event and inventory restocking are built.
  Processing: { Confirmed: ["Admin"] },

  Confirmed: { Shipped: ["Admin"] }, // no Cancelled — refunds don't exist yet
  Shipped: { Delivered: ["Admin"] },
  Delivered: {},
  Cancelled: {},
};

/**
 * Checks whether an order can transition from one
 * status to another based on the user's role.
 * @param {string} currentStatus - The current status of the order
 * @param {string} newStatus - The requested target status
 * @param {string} role - The user's role (Admin, Customer, etc.)
 * @returns {boolean}
 */
export const canTransitionTo = (currentStatus, newStatus, role) => {
  // Guard clause: Return false immediately if any argument is missing
  if (!currentStatus || !newStatus || !role) {
    return false;
  }

  // Look up allowed roles using Optional Chaining (?.)
  const allowedRoles = ALLOWED_TRANSITIONS[currentStatus]?.[newStatus];

  // Check if the current user's role is included in the allowed roles list
  return Boolean(allowedRoles?.includes(role));
};
