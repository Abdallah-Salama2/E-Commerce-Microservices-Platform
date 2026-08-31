# E-Commerce Microservices Platform

A production-grade, event-driven e-commerce backend built as **7 independently deployable microservices**, communicating via **Apache Kafka** with a **transactional outbox pattern** for guaranteed at-least-once delivery. Designed around distributed-systems fundamentals: per-service data ownership, idempotent messaging, saga-style order orchestration, and concurrency-safe checkout.

---

## Table of Contents

- [Architecture Overview](#architecture-overview)
- [Services](#services)
- [Tech Stack](#tech-stack)
- [Key Design Decisions](#key-design-decisions)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [API Documentation](#api-documentation)
- [Event Flow (Order Saga)](#event-flow-order-saga)

---

## Architecture Overview

The platform started as a monolith and was decomposed into 7 domain-driven microservices, each with:

- **Its own database** — no cross-service foreign keys, no shared schema.
- **Its own outbox table** — every service that publishes events writes to an `outbox_events` table in the same transaction as its business write, then a poller (`outboxPoll.js`) reliably publishes to Kafka.
- **Its own Kafka consumers** — for services that react to events from other domains.
- **A layered internal architecture** — routes → controllers → services → repositories, with SQL Server stored procedures as the data-access boundary.

Services communicate synchronously via internal REST clients (`clients/`) for request/response needs (e.g., Order fetching Cart contents), and asynchronously via Kafka for domain events (e.g., `OrderCreated`, `StockReserved`).

All services sit behind an **Nginx** API gateway handling path-based routing and centralized CORS, and are orchestrated together with **Docker Compose**.

---

## Services

| Service | Responsibility | Key Tech |
|---|---|---|
| **identity-service** | Auth, JWT issuance/rotation, RBAC, user addresses, password reset | SQL Server, JWT, Nodemailer |
| **catalog-service** | Products, categories, product search | SQL Server, Redis (cache-aside), Kafka |
| **inventory-service** | Stock levels, reservations, releases | SQL Server, Kafka |
| **cart-service** | Guest/user cart, cart merge on login | Redis, Kafka clients |
| **order-service** | Order placement, order state machine, coupons, payments | SQL Server, Kafka |
| **media-service** | Product image upload, processing, thumbnails | Multer, Sharp, Kafka |
| **notification-service** | Order/status notifications (email) | Nodemailer, Kafka |

---

## Tech Stack

- **Runtime:** Node.js, Express
- **Database:** SQL Server (T-SQL, stored procedures, migrations)
- **Messaging:** Apache Kafka (event choreography, transactional outbox)
- **Caching:** Redis (cache-aside for catalog, cart storage)
- **Auth:** JWT (short-lived access + rotating httpOnly refresh cookies)
- **Gateway:** Nginx (path-based routing, CORS)
- **Containerization:** Docker, Docker Compose (multi-stage builds)
- **Docs:** OpenAPI / Swagger per service
- **Testing:** k6 (load and concurrency testing)

---

## Key Design Decisions

**Database-per-service.** Each service owns its schema exclusively; nothing reaches across service boundaries at the database level. Cross-service reads go through internal REST clients or are denormalized via events.

**Transactional outbox.** Rather than publishing to Kafka directly inside a request handler (which risks losing events on a crash between DB commit and publish), every write and its corresponding event are committed atomically to the local database. A background poller (`outboxPoll.js`) then reads unpublished events and publishes them to Kafka, marking them published only after a successful send.

**Idempotent consumers.** Kafka guarantees at-least-once delivery, so every consumer is built to safely process the same message twice — via dedicated ledger/processed-event tables and primary-key-violation guards that make duplicate processing a no-op.

**Concurrency-safe checkout.** Stock reservation uses pessimistic locking (`UPDLOCK`/`ROWLOCK`) with consistent lock ordering to prevent deadlocks, and checkout is idempotent via client-generated idempotency keys enforced with database `UNIQUE` constraints. Correctness under load was validated with k6, simulating concurrent purchases of the last unit in stock.

**Order saga.** Order fulfillment is coordinated via Kafka event choreography (no central orchestrator): Order → Inventory (reserve stock) → Notification, with compensating events (e.g., stock release on cancellation) keeping state consistent across services without distributed transactions.

**Security.** JWT access tokens are short-lived (15 min) with rotating, httpOnly refresh cookies (30-day, reuse-detection). Ownership checks are enforced directly in SQL `WHERE` clauses to prevent IDOR vulnerabilities, verified via adversarial cross-account testing.

---

## Project Structure

```
ecommerce-microservices/
├─ nginx/                      # API gateway config (path-based routing, CORS)
│  └─ nginx.conf
├─ schemas/                    # Reference schema docs
├─ services/
│  ├─ identity-service/        # Auth, JWT, RBAC, addresses
│  ├─ catalog-service/         # Products, categories
│  ├─ inventory-service/       # Stock, reservations
│  ├─ cart-service/            # Cart (Redis-backed)
│  ├─ order-service/           # Orders, saga, payments
│  ├─ media-service/           # Image upload/processing
│  └─ notification-service/    # Email notifications
├─ shared/                     # Shared utilities/contracts (if any)
├─ tools/
│  └─ make-migration.js        # Migration scaffolding CLI
├─ docker-compose.yml
├─ docker-compose.override.yml
├─ eslint.config.js
└─ package.json
```

Each service follows a consistent internal layout:

```
<service-name>/
├─ src/
│  ├─ clients/          # Internal HTTP clients to other services
│  ├─ config/           # env, db, redis, swagger config
│  ├─ controllers/      # Request handlers
│  ├─ database/
│  │  ├─ DDL/            # Table creation migrations
│  │  ├─ DML/            # Seed data
│  │  ├─ scripts/        # migrate.js runner
│  │  └─ SP/              # Stored procedures
│  ├─ kafka/
│  │  ├─ consumers/      # Event consumers
│  │  ├─ outboxPoll.js   # Outbox → Kafka publisher
│  │  └─ producer.js
│  ├─ middlewares/      # auth, RBAC, validation, error handling, rate limiting
│  ├─ repositories/     # Data-access layer (base.repository.js + service-specific)
│  ├─ routes/
│  ├─ services/         # Business logic
│  ├─ utils/
│  ├─ validations/      # Request schema validation
│  ├─ app.js
│  └─ server.js
├─ Dockerfile
├─ .env
└─ package.json
```

---

## Getting Started

### Prerequisites
- Docker & Docker Compose
- Node.js (for local development outside containers)

### Run the full stack

```bash
git clone <repo-url>
cd ecommerce-microservices
docker compose up --build
```

This spins up all 7 services, SQL Server, Redis, Kafka, and the Nginx gateway.

### Run migrations (per service)

```bash
cd services/<service-name>
node src/database/scripts/migrate.js
```

### Environment variables

Each service has its own `.env` — see `src/config/env.js` in each service for the required variables (DB connection, Redis, Kafka brokers, JWT secrets, etc.).

---

## API Documentation

Each service exposes its own OpenAPI/Swagger docs at `/api-docs` (or the configured base path), defined via `src/config/swagger.config.js`.

---

## Event Flow (Order Saga)

```
1. Client → Order Service: POST /orders (idempotency key)
2. Order Service: writes order + outbox event (OrderCreated) in one transaction
3. outboxPoll.js: publishes OrderCreated → Kafka
4. Inventory Service: consumes OrderCreated → reserves stock (UPDLOCK/ROWLOCK)
   → writes outbox event (StockReserved | StockReservationFailed)
5. Order Service: consumes reservation result → transitions order status
6. Notification Service: consumes order status change → sends email
   (Cancellation path: compensating StockRelease event returns stock)
```

---

## Author

**Abdallah Fawzi Salamah**
[LinkedIn](https://www.linkedin.com/in/abdallah-salamah/) · [GitHub](https://github.com/Abdallah-Salama2)