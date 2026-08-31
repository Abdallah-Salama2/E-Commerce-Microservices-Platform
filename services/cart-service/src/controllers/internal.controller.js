import { clearCartService } from "../services/cart.service.js";
import { getLogger } from "../utils/logger.js";
import { sendSuccess } from "../utils/response.js";

// Note the userId comes from req.body here, NOT req.user — there's no
// req.user on this route at all, since requireInternalSecret doesn't set
// one (unlike `authenticate`, which decodes a JWT into req.user). The
// calling service is explicitly telling us which user's cart to clear;
// the internal secret is what earns it the right to make that claim.
export const clearCartForUser = async (req, res, next) => {
  try {
    const { userId } = req.body;
    await clearCartService({ userId });

    return sendSuccess(res, {
      message: "Cart cleared successfully",
    });
  } catch (err) {
    getLogger().error(
      { err, userId: req.body?.userId },
      "Internal cart clear failed",
    );
    next(err);
  }
};
