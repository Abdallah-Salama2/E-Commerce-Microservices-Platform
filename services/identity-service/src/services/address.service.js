import mssql from "mssql";
import { BaseRepository } from "../repositories/base.repository.js";

/**
 * @param {BaseRepository} [repo] - Repository instance (defaults to a real DB-backed one; override in tests with a fake).
 */
export const createAddressService = async (
  {
    userId,
    label,
    fullName,
    phone,
    line1,
    line2,
    city,
    governorate,
    country,
    postalCode,
    isDefault,
  },
  repo = new BaseRepository(),
) => {
  const rows = await repo.execute("create_address", [
    { name: "UserId", type: mssql.BigInt, value: userId },
    { name: "Label", type: mssql.NVarChar(50), value: label ?? null },
    { name: "FullName", type: mssql.NVarChar(150), value: fullName },
    { name: "Phone", type: mssql.NVarChar(20), value: phone },
    { name: "Line1", type: mssql.NVarChar(255), value: line1 },
    { name: "Line2", type: mssql.NVarChar(255), value: line2 ?? null },
    { name: "City", type: mssql.NVarChar(100), value: city },
    { name: "Governorate", type: mssql.NVarChar(100), value: governorate },
    { name: "Country", type: mssql.NVarChar(100), value: country ?? "Egypt" },
    {
      name: "PostalCode",
      type: mssql.NVarChar(20),
      value: postalCode ?? null,
    },
    { name: "IsDefault", type: mssql.Bit, value: isDefault ? 1 : 0 },
  ]);
  return rows[0];
};

/**
 * @param {number|string} userId
 * @param {BaseRepository} [repo] - Repository instance (defaults to a real DB-backed one; override in tests with a fake).
 */
export const getAddressesService = async (
  userId,
  repo = new BaseRepository(),
) => {
  const rows = await repo.execute("get_addresses", [
    { name: "UserId", type: mssql.BigInt, value: userId },
  ]);
  return rows;
};

/**
 * @param {BaseRepository} [repo] - Repository instance (defaults to a real DB-backed one; override in tests with a fake).
 */
export const getAddressByIdService = async (
  { id, userId },
  repo = new BaseRepository(),
) => {
  const rows = await repo.execute("get_address_by_id", [
    { name: "Id", type: mssql.BigInt, value: id },
    { name: "UserId", type: mssql.BigInt, value: userId },
  ]);
  return rows[0];
};
