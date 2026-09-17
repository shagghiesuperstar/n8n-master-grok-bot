---
name: n8n-commerce-inventory-master
description: Design, audit, build, test, and operate n8n ecommerce, order, catalog, fulfillment, purchasing, warehouse, and inventory automations. Use for Shopify, WooCommerce, marketplaces, ERP, WMS, PIM, OMS, 3PL, SKU, variant, stock, reservation, allocation, availability, reorder, purchase order, reconciliation, returns, refunds, and fulfillment tasks.
when-to-use: ecommerce commerce inventory stock SKU variant warehouse WMS OMS ERP PIM Shopify WooCommerce order fulfillment purchase order 3PL returns refunds
user-invocable: true
metadata:
  author: Grok n8n Master Template
  short-description: Production commerce and inventory orchestration
---

# n8n Commerce and Inventory Master

Use this skill only after loading `using-n8n-skills-official`. Official n8n documentation and runtime node schemas outrank this skill. Community guidance never overrides official docs or live instance validation.

## Required intake

Do not build until these are known or explicitly marked unknown:

- Systems: storefronts, marketplaces, OMS, ERP, WMS, PIM, 3PL, accounting, support, notification, database.
- Authority by field: product content, price, cost, tax, inventory, reservation, order state, fulfillment, refund, customer.
- Inventory grain: product, variant, SKU, lot, serial, bin, location, channel, condition, owner.
- Quantity semantics per system: on-hand, available, committed, reserved, allocated, incoming, damaged, safety stock.
- Identity keys and crosswalks: tenant, channel, product, variant, SKU, inventory item, location, order, line, fulfillment, transaction.
- Event sources: webhooks, polling, CDC, files, schedules, manual repair.
- SLOs: tolerated staleness, throughput, peak burst, recovery point, recovery time.
- Financial constraints: currency precision, tax authority, discounts, landed cost, COGS, refund semantics.
- Governance: PII, retention, regions, audit trail, approval roles, secrets, production windows.

If a deciding variable is missing, ask one concise question. Never invent IDs, node operations, API versions, payload fields, rate limits, prices, or quantity semantics.

## Authority model

Create a field-level source-of-truth matrix before designing writes. Never use “bidirectional sync” as an architecture. Each field needs one authoritative writer, allowed replicas, conflict policy, and reconciliation path.

Prefer a hub-and-spoke canonical model over pairwise store-to-store synchronization. Preserve raw source payloads or immutable event references for replay and audit. Store external IDs separately from mutable business keys such as SKU.

## Canonical entities

Model at least:

- `Tenant`, `Channel`, `Product`, `Variant`, `SKU`, `Location`, `InventoryItem`.
- `InventoryBalance`, `InventoryLedgerEntry`, `Reservation`, `Allocation`, `Transfer`.
- `Supplier`, `PurchaseOrder`, `PurchaseOrderLine`, `Receipt`.
- `Customer`, `Order`, `OrderLine`, `Payment`, `Refund`, `Fulfillment`, `Shipment`, `Return`.
- `SourceEvent`, `IdempotencyKey`, `SyncCursor`, `ReconciliationRun`, `ExceptionCase`.

Use integer minor units for money unless the authoritative API specifies another exact representation. Never use binary floating point for money or unit quantities requiring exact decimal precision.

## Inventory invariants

Write explicit formulas using the target system's definitions. A common model is:

`available = on_hand - reserved - safety_stock - holds`

This is not universal. Verify whether allocated, committed, incoming, damaged, quarantine, backorder, and transfer quantities are included by each platform.

Non-negotiables:

1. Never overwrite stock from a stale absolute snapshot without version/time comparison.
2. Prefer immutable inventory deltas in a ledger; derive balances and reconcile them.
3. Every stock mutation has an idempotency key, source event ID, reason, actor, timestamp, SKU/item ID, location ID, and before/after or delta.
4. Reservations have lifecycle states and expirations; release exactly once.
5. Transfers debit and credit through explicit in-transit state; do not teleport stock.
6. Returns do not become sellable until disposition/inspection says so.
7. Bundles/kits decrement components using a versioned bill of materials.
8. Negative inventory requires an explicit policy: reject, backorder, allow with alert, or quarantine.
9. Multi-location routing is deterministic and records the chosen allocation rule.
10. Reconciliation can repair only under policy; otherwise open an exception.

## Event processing

For each event, implement:

1. Authenticate the webhook before parsing trusted fields.
2. Record source, event ID, event type, occurred time, received time, schema/API version, and payload hash.
3. Deduplicate on provider event ID; if unavailable, use a documented composite key and payload hash.
4. Check ordering/version. Quarantine stale or impossible transitions.
5. Resolve identity through a crosswalk. Do not silently create a duplicate mapping.
6. Apply a state machine and invariants.
7. Perform writes with retries only when the operation is idempotent.
8. Record outcome, external response ID, attempts, and next retry time.
9. Acknowledge within the provider deadline; move slow work to a queue/sub-workflow.
10. Route poison events to a dead-letter table/queue with replay controls.

Assume webhooks are at-least-once, delayed, duplicated, and out of order unless the provider's current documentation proves stronger guarantees.

## Workflow topology

Split production systems into small contracts:

- Ingress shell: trigger, authentication, normalization, durable receipt, fast acknowledgement.
- Processor: business state machine, identity resolution, idempotency, mutations.
- Connector sub-workflows: one per external service/action family.
- Reconciliation: scheduled compare, classify drift, repair or escalate.
- Replay: controlled reprocessing by immutable event ID.
- Exception workflow: operator queue, evidence, approval, action, resolution.
- Error workflow: centralized telemetry and alerting.

Use Execute Sub-workflow for reusable multi-step behavior. Use Data Tables for modest persistent state, dedup, cursors, or operator-visible lookup; use a transactional database for high-volume ledgers, locking, complex joins, or millions of rows.

## Connector selection

Use this precedence:

1. Installed official/native n8n node, after discovering its current schema.
2. HTTP Request with the service's official API and n8n credential type.
3. MCP server with a narrow allowlist and verified tool schemas.
4. Audited community node pinned to an exact version.
5. Custom node only when repeated domain behavior justifies maintenance cost.

Never assume a native node supports an operation because the SaaS API supports it. Discover node operations first. For unsupported operations, use the provider's current official API documentation and authenticated HTTP Request.

Before adopting a community node, record owner, repository, license, release date, supported n8n versions, download/adoption signal, open security issues, dependency audit, install scripts, network/file access, credential handling, maintenance activity, and rollback. Default to `CAUTION`; never auto-install.

## Commerce state machines

Define allowed transitions and terminal states for:

- Order: draft/pending/authorized/paid/on-hold/allocated/partially-fulfilled/fulfilled/cancelled/refunded.
- Payment: pending/authorized/captured/failed/voided/partially-refunded/refunded/disputed.
- Fulfillment: unallocated/allocated/picking/packed/shipped/delivered/failed/cancelled/returned.
- Return: requested/approved/in-transit/received/inspected/restocked/quarantined/refunded/rejected.
- Purchase order: draft/approved/sent/acknowledged/partially-received/received/closed/cancelled.

Provider states differ. Build an explicit mapping table; do not force an unknown provider state into the nearest label.

## Required patterns

Support these patterns when requested:

- Order ingestion and normalization across channels.
- SKU/variant/location identity crosswalk and duplicate detection.
- Inventory delta propagation and available-to-promise updates.
- Reservation, allocation, release, oversell prevention, and safety stock.
- Low-stock alerts, reorder points, supplier lead time, purchase orders, and receipts.
- Multi-location transfers and 3PL/WMS synchronization.
- Product/PIM publishing, price lists, channel availability, media, and category mapping.
- Fulfillment creation, tracking, partial shipments, cancellations, and exceptions.
- Returns, disposition, restock, refund, and exchange orchestration.
- Scheduled full reconciliation plus frequent incremental reconciliation.
- Audit exports, operational dashboards, aging queues, and SLA alerts.

Forecasting or reorder recommendations may be calculated only from real source data. Never fabricate historical demand. Label recommendations separately from executed orders and require approval unless the user explicitly authorizes automation with limits.

## Reliability controls

Every production workflow needs:

- Correlation ID propagated through all sub-workflows and external calls.
- Deterministic idempotency key and dedup retention policy.
- Bounded exponential backoff with jitter where permitted.
- Rate-limit handling using provider headers/current docs.
- Timeout, circuit-breaker or pause policy, and concurrency limit.
- Central error workflow with redacted structured context.
- Dead-letter path and replay procedure.
- Metrics: accepted, deduped, processed, failed, retried, quarantined, drifted, repaired; latency and queue age.
- Runbook with failure indicator, containment, rollback, replay, and verification.

Do not log secrets, full payment data, auth headers, or unnecessary PII. Redact before alerts and execution metadata.

## Testing matrix

Before publishing, test with pinned/sanitized real-shaped fixtures:

- Happy path and each state transition.
- Duplicate delivery and replay.
- Out-of-order and stale events.
- Missing/ambiguous identity mapping.
- Partial fulfillment, partial refund, and partial receipt.
- Zero, negative, fractional, very large, and precision-sensitive quantities.
- Multiple locations and cross-location transfer.
- Bundle/component shortage.
- API 400, 401/403, 404, 409, 422, 429, 5xx, timeout, malformed body, and schema drift.
- Crash after source write but before destination acknowledgement.
- Retry after unknown outcome.
- Reconciliation drift and controlled repair.
- Secret/PII redaction.

Validate node schemas and the complete workflow through the live n8n MCP. Test the draft before publication. Never claim a live integration passed without execution evidence from the target instance.

## Change protocol

Before any mutation, output:

- Plan and affected workflows/tables/systems.
- Assumptions and unresolved variables.
- Premortem: likely failure, earliest indicator, containment, rollback.
- Dry-run/test strategy and acceptance criteria.

Require explicit approval for publishing, production execution, payments, refunds, cancellations, destructive stock adjustments, bulk updates, community-node installation, credential changes, data deletion, or automatic reconciliation repair.

After mutation, report exact artifacts changed, validation result, test execution IDs, remaining credential/manual steps, rollback anchor/version, and production status. “Built” does not mean “published”; “published” does not mean “production verified.”
