import mssql from "mssql";
import jwt from "jsonwebtoken";
import { env } from "../config/env.js";
import crypto from "crypto";
import { AppError } from "../utils/appError.js";
import { BaseRepository } from "../repositories/base.repository.js";

export const hashToken = (rawRefreshToken) =>
  crypto.createHash("sha256").update(rawRefreshToken).digest("hex");

const computeExpiresAt = () => {
  const expiresAt = new Date();
  expiresAt.setDate(
    expiresAt.getDate() + Number(env.JWT.REFRESH_EXPIRES_IN_DAYS),
  );
  return expiresAt;
};

export const generateAccessToken = (userId, roles) => {
  const payload = {
    userId: userId,
    roles: roles,
  };
  return jwt.sign(payload, env.JWT.ACCESS_SECRET, {
    expiresIn: env.JWT.ACCESS_EXPIRES_IN,
  });
};

export const generateRefreshToken = async (
  userId,
  repo = new BaseRepository(),
) => {
  const jti = crypto.randomUUID();

  // creating raw refresh
  const rawRefreshToken = crypto.randomBytes(32).toString("hex");
  // Now Hashed
  const hashedRefreshToken = hashToken(rawRefreshToken);

  // SessionId
  const sessionId = crypto.randomUUID();
  const expiresAt = computeExpiresAt();

  await repo.execute("create_refresh_token", [
    { name: "UserId", type: mssql.BigInt, value: userId },
    { name: "Jti", type: mssql.UniqueIdentifier, value: jti },
    { name: "SessionId", type: mssql.UniqueIdentifier, value: sessionId },
    { name: "TokenHash", type: mssql.NVarChar(255), value: hashedRefreshToken },
    { name: "ExpiresAt", type: mssql.DateTime2, value: expiresAt },
  ]);

  return rawRefreshToken;
};

//
export const getUserRolesByUserIdService = async (
  userId,
  repo = new BaseRepository(),
) => {
  const rolesResult = await repo.execute("get_user_roles_by_user_id", [
    { name: "UserId", type: mssql.BigInt, value: userId },
  ]);

  return rolesResult.map((r) => r.name);
};

export const refreshTokenService = async (
  rawRefreshToken,
  repo = new BaseRepository(),
) => {
  if (!rawRefreshToken) {
    throw new AppError("Invalid refresh token", 401);
  }
  const tokenHash = hashToken(rawRefreshToken);

  const tokenResult = await repo.execute("get_refresh_token_by_hash", [
    { name: "TokenHash", type: mssql.NVarChar(255), value: tokenHash },
  ]);

  const tokenRow = tokenResult?.[0];

  // 1) Token doesnt exist ?
  if (!tokenRow) {
    throw new AppError("Invalid refresh token", 401);
  }
  // Token revoked at != null means its closed if  token we got with token hash was revoked somewhere means secuirty risk so we close all sessions related to this  hash token
  if (tokenRow.revoked_at !== null) {
    await repo.execute("revoke_session_tokens", [
      {
        name: "SessionId",
        type: mssql.UniqueIdentifier,
        value: tokenRow.session_id,
      },
    ]);

    throw new AppError("Invalid refresh token", 401);
  }

  if (new Date(tokenRow.expires_at) < new Date()) {
    throw new AppError("Invalid refresh token", 401);
  }

  const roles = await getUserRolesByUserIdService(tokenRow.user_id, repo);
  const accessToken = generateAccessToken(tokenRow.user_id, roles);

  const newJti = crypto.randomUUID();
  const newRawRefreshToken = crypto.randomBytes(32).toString("hex");
  const newTokenHash = hashToken(newRawRefreshToken);

  await repo.execute("rotate_refresh_token", [
    { name: "OldTokenId", type: mssql.BigInt, value: tokenRow.id },
    { name: "UserId", type: mssql.BigInt, value: tokenRow.user_id },
    { name: "NewJti", type: mssql.UniqueIdentifier, value: newJti },
    {
      name: "NewSessionId",
      type: mssql.UniqueIdentifier,
      value: tokenRow.session_id,
    }, // نفس الـ session، مش جديدة
    { name: "NewTokenHash", type: mssql.NVarChar(255), value: newTokenHash },
    {
      name: "ExpiresInDays",
      type: mssql.Int,
      value: Number(env.JWT.REFRESH_EXPIRES_IN_DAYS),
    },
  ]);

  return {
    accessToken,
    refreshToken: newRawRefreshToken,
  };
};
