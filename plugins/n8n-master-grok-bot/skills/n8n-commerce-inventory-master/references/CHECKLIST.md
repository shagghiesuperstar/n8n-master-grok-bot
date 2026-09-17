# Commerce and inventory release checklist

- [ ] Field-level authority matrix approved.
- [ ] Canonical entities and identity crosswalk documented.
- [ ] Quantity semantics confirmed for every system.
- [ ] State mappings and illegal transitions documented.
- [ ] Idempotency key, dedup retention, ordering, and replay defined.
- [ ] Reservation/allocation/release and transfer invariants tested.
- [ ] Native node schemas discovered from the target instance.
- [ ] API operations verified against current provider documentation.
- [ ] Credentials referenced by ID/name only; no secrets in workflow JSON.
- [ ] Error workflow, dead-letter path, correlation ID, metrics, and alerts present.
- [ ] Rate limits, retry eligibility, timeout, concurrency, and backpressure set.
- [ ] PII/secrets redacted from logs, alerts, and execution data.
- [ ] Draft workflow validates with zero errors.
- [ ] Pinned tests cover duplicates, ordering, partials, failures, and drift.
- [ ] Live test evidence recorded where credentials/environment permit.
- [ ] Version/rollback anchor recorded.
- [ ] Human approval captured for publish and side effects.
- [ ] Reconciliation and controlled replay runbooks tested.
