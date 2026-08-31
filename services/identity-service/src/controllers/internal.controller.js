import { getUserContactService } from "../services/internal.service.js";
import { mapSqlError } from "../utils/appError.js";
import { getLogger } from "../utils/logger.js";
import { sendSuccess } from "../utils/response.js";

export const getUserContact = async (req, res, next) => {
  try {
    const { id } = req.params;
    const contact = await getUserContactService(id);

    return sendSuccess(res, {
      data: contact,
      message: "User contact fetched successfully",
    });
  } catch (err) {
    getLogger().error({ err, userId: req.params.id }, "Internal contact lookup failed");
    next(mapSqlError(err));
  }
};