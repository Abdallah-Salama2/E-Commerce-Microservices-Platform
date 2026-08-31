import mssql from "mssql";
import { BaseRepository } from "../repositories/base.repository.js";

export const getUserContactService = async (
  userId,
  repo = new BaseRepository(),
) => {
  const rows = await repo.execute("get_user_contact", [
    { name: "UserId", type: mssql.BigInt, value: userId },
  ]);
  return rows[0];
};