# ============================================================================
# Shared multi-stage Dockerfile — identical for every service in this repo
# (identity-service, catalog-service, inventory-service, cart-service,
# order-service, media-service). Copy this file unchanged into each
# services/<name>-service/Dockerfile.
#
# Two build targets:
#   dev        -> installs devDependencies (nodemon etc.), used by
#                 docker-compose.override.yml with a bind-mounted source tree
#   production -> installs ONLY dependencies (npm ci --omit=dev), copies the
#                 pruned node_modules from a separate stage so nothing from
#                 devDependencies (nodemon, etc.) ends up in the final image
# ============================================================================

# ---------- base: just the manifest, shared by every stage below ----------
FROM node:20-alpine AS base
WORKDIR /app
COPY package*.json ./

# ---------- dev ----------
FROM base AS dev
ENV NODE_ENV=development
RUN npm ci
COPY . .
CMD ["npm", "run", "dev"]

# ---------- prod-deps: install production deps only, in their own stage ----------
FROM base AS prod-deps
ENV NODE_ENV=production
RUN npm ci --omit=dev

# ---------- production ----------
FROM node:20-alpine AS production
WORKDIR /app
ENV NODE_ENV=production

# Run as the non-root "node" user baked into the official image, not root.
COPY --from=prod-deps --chown=node:node /app/node_modules ./node_modules
COPY --chown=node:node . .
USER node

CMD ["node", "src/server.js"]
