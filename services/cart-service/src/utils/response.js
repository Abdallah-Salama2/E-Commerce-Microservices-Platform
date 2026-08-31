export const sendSuccess = (
  res,
  { status = 200, data = null, message = "Success", pagination = null },
) => {
  const body = { success: true, data, message };
  if (pagination) body.pagination = pagination;
  return res.status(status).json(body);
};
