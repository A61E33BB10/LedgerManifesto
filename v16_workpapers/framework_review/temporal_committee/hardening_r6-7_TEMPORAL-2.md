# Red-team R6-7 — TEMPORAL-2 (LEAD on S6): poisoned-cache/wipe-rebuild + CAN mid-sandwich

## S6 (LEAD) — LOG-IS-SOLE-TRUTH under a poisoned Temporal cache. HOLDS (honest detection-at-audit bound).
**Core containment:** the cache holds no write credential; the door re-validates every proposal against
the log and **recomputes** txid = H(cause, contract, unit, seq) from the tuple it resolves on the log —
it never trusts cache-presented content, txid, or gate verdict. The poisoned-cache surface therefore
collapses onto the pre-existing untrusted-contract surface; the cache adds no new attack.

- **(i-a) replay a txn never in the log.** Door admits only: structure-valid + cause resolvable on the
  log + recomputed-txid-matches + consistency-of-reference + writer-discipline. Fabricated/absent cause →
  **refused**. Real cause + contract-correct content → legitimate re-derivation (not poison). Real cause +
  wrong economics → admitted (door is no economic oracle) but **detection-at-audit** (the economic edge).
  No transaction with no recorded cause can enter, conservation is paired-leg by construction. HOLDS.
- **(i-b) suppress an on-log txn.** The fold reads the **log, not the cache** (R-02); a suppressing cache
  cannot filter the fold — the cache is downstream of the log, never a gate on it. It can only fail to
  re-fire *forward*, caught by the overdue-watch sweep + the `prop_refoldEqualsTimely` acceptance test at
  quiescence. Suppression → detectable liveness gap, never silent loss of an admitted fact. HOLDS.
- **(ii) phantom derived state / gate decision.** The door does **not** run the gate (MD-16
  prevention-at-construction), so a poisoned "pass" for a failing state *is* admissible at the door — BUT
  the gate is a decidable predicate on a projection over the pinned cut, so **recomputation catches the
  phantom** (re-evaluate the predicate on the log's cut, compare to the recorded verdict). A fully
  fabricated derived state (no recorded cause) → refused. Honestly detection-at-audit, **not**
  door-prevention — and the design already says so; overclaiming prevention here would be the error. HOLDS.
- **(iii) fabricated txid.** The door recomputes txid from the resolved (cause, contract, unit, seq); a
  presented txid not matching its tuple → refused; a cause not on the log → refused. The txid is derived,
  never trusted-as-presented — you cannot fabricate one. HOLDS.
- **Economic-causality edge — confirmed honest.** Wrong economics and phantom gate verdicts are caught by
  recomputation (re-run the map / re-evaluate the gate predicate) and repaired forward, **never**
  overclaimed as door-prevention. The cache can do no more than a buggy contract / mis-gating constructor
  already could — the trust model already accounts for it.
- **Bonus (the wipe cleanses):** un-admitted poisoned memoised values are wiped; on rebuild the model
  re-runs fresh; only log-admitted values survive, all audit-checkable. **Precondition to state
  explicitly:** the rebuild reads **only** the log; the cache is reconstructed from it, never consulted as
  truth. An implementation whose rebuild reads Temporal state as authoritative is the one real break —
  enforce log-only rebuild physically (no read dependency on Temporal state).

## S3 — SANDWICH-CARRIES-NO-WORKFLOW-STATE across continue-as-new mid-sandwich. HOLDS.
Steps: before-mark → CA frame-change txn → after-mark → certificate. **Each is a log fact** (re-entered
observation / transaction / projection); none is workflow state.
- **CAN between any two steps** carries only {unitId, nodeId, log-cursor}; on resume the workflow reads
  which steps are on the log (before-mark? CA-txn? after-mark?) and resumes at the first absent one.
  Sub-step position is **derived from the log, not carried**; re-firing a step already on the log is
  absorbed (cause-derived txid keyed on the CA event + the mark's cut). No double-strike, no skip. HOLDS.
- **CAN mid step-2** (CA txn proposed, not yet admitted): re-proposed on resume, idempotent → admitted
  once or absorbed. No double-apply of the frame change. HOLDS.
- **Visible half-sandwich (the real attack):** between the frame change and the after-mark, can a
  projection show new-count × old-frame-price (a phantom, C-11.3)? **No** — the invariance witness (V4/B5)
  refuses a stale-frame read; the projection reads price and quantity at one frame, or flags the new-frame
  mark pending (MD-8). Prevented structurally at the projection, independent of CAN. HOLDS.
- **Late-CA retroactive sandwich** is the D7 refold path (single writer's past-dated work; the workflow
  re-reads forward) — CAN does not interfere. HOLDS.

**Verdict:** S6 HOLDS (door recomputes txid + re-validates against the log; economics/gates honestly
detection-at-audit; wipe cleanses un-admitted poison). S3 HOLDS (sub-step derived from the log; the
invariance witness blocks the mid-frame phantom). Two preconditions to state in the design: **rebuild
reads only the log**; **the sandwich carries no sub-step progress in CAN/workflow state.**
