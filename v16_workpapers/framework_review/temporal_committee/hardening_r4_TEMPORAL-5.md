# Hardening R4 — TEMPORAL-5 (LEAD: S1 compute/emit split + refold; S7 failover mid-gate)

Model: `runModel` (non-local activity, result memoized in history) → separate `proposeToDoor(recordedBytes)`; door = external single writer; idempotence = cause-derived txid over recorded inputs (cut, model-version, seed, env-version).

## S1 — mid-refold / mid-write worker crash

**Crash (i) — after compute, before completion durable.** HOLDS, with one requirement. The lost result was never recorded and never emitted, so "one payload reaches the door" survives: Temporal re-runs `runModel`, the RECOMPUTE is the sole payload. Identical bytes iff BIT-EXACT (same recorded seed+env ⇒ same P, same txid); else TOLERANCE-BOUNDED(τ), |P−P′|≤τ, bounded to dispute tolerance by the r3 consumption check (τ ≤ VM-6). Crash (i) is the only place divergence is possible — and it VALIDATES the reproducibility class, it does not break the split.
**REQUIREMENT (the real finding):** cut+seed+env are workflow-deterministic and recorded as the request BEFORE `runModel` dispatches. If the seed were drawn *inside* `runModel`, crash (i) re-draws a fresh seed → a DIFFERENT txid → two distinct observations could both commit (double-record). Pre-recording makes the re-run recompute the same txid — and, for BIT-EXACT, the same bytes. The load-bearing invariant.

**Crash (ii) — compute durable, before door-propose.** HOLDS. Replay reads the memoized bytes (never re-runs the model); `proposeToDoor` runs with identical bytes+txid. One payload frozen in history — divergence impossible.

**Crash (iii) — door admits, before workflow records completion.** HOLDS. Replay re-invokes `proposeToDoor` (same bytes+txid); the door finds the txid on the log, commits zero further, idempotently RETURNS the prior admit; workflow advances. At-least-once → exactly-once-at-the-door; no double-append, no rewind — why the txid must be pure over recorded inputs.

**Refold crash (writer-side).** HOLDS. The refold is the single writer's serialized idempotent work (`prop_refoldIdempotent`; snapshot keyed by the stable (exec,door,hash) triple, re-run to identical state). The substrate does NOT refold — it re-reads the QUIESCENT closure only, backstopped by the overdue sweep; a partial refold is never observable, the workflow re-fires FORWARD only.

## S7 — namespace failover mid-gate

**Single-transaction state+verdict.** HOLDS — no half-verdict window. State and verdict are ONE door transaction over one pinned cut (Fork A, atomic); the single append admits both or neither. A half-verdict window exists only under the rejected two-write pole.
**Split-brain double-drive.** HOLDS. Both clusters re-pin the same recorded cut, re-run the pure gate+construct, propose the SAME txid; the DOOR (external, the idempotence authority) admits once — why the door sits outside Temporal.
**Replication-lag residual (honest).** If failover precedes replication of `runModel`'s completion, the new cluster re-runs the model → crash-(i) behaviour, contained by the reproducibility class. Degrades (ii)→(i), never a break.

## Verdict
All S1 crash points and S7 HOLD; no BREAK. One load-bearing invariant surfaced: cut+seed+env recorded BEFORE compute — without it crash (i) re-draws a seed and can double-record. The split's "one payload reaches the door" survives crash (i) because the lost compute is never emitted; divergence there is a value-level event bounded by the r3 reproducibility class, not an admission defect.
