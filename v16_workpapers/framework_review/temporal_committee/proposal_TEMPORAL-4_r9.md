# Temporal as Execution Substrate for the WHOLE Framework — TEMPORAL-4, Rounds 8+9 (final batched red-team)

R8+R9 close the last divergence (key arity), correct the S3 byte-identity wording, and add the
two final red-team rows (S2 deploy mid-backtest; S5 clock skew). Both HOLD. β is the only
reproducibility symbol. Everything else stands as r7.

**Fixes (both referees):** (1) **Key arity — the 3-tuple, seed dropped.** Canonical key =
`(input-cut, model-version, recipe/dynamic-version)`; the seed is a **recorded parameter OF the
recipe/dynamic term** (a Tier-2 re-derivation coordinate), not a separate slot — a free seed slot
reopens the double-admit (two seeds → two txids for one fact, the env-in-key failure), so seed AND
numerical-environment are lineage terms, never identity. Closes the last cross-file divergence.
(2) **S3 byte-identity softened** to what survival actually needs (read-back for admitted legs;
S4-idempotent + β-bounded for re-driven legs). (3) Sandwich legs keyed on the **canonical shapes**,
no ad-hoc `leg-tag`. (4) The **mark kind-1/kind-2 rule** stated once.

## 1. Corrected / new rows

| # | Divergence | Containment |
|---|---|---|
| **D10** | **Retry vs exactly-once ADMISSION — the door's dedup is load-bearing.** | Exactly-once-admission = the cause-derived txid is a **UNIQUE KEY enforced by an ATOMIC conditional-append at the single writer** (not check-then-append/TOCTOU); a **total function of the DURABLE LOG**, invariant under redelivery/interleaving/door-crash-restart (S4). Preconditions, by construction: (i) **durable-before-ack**; (ii) **one leader + quorum log per lineage** (a fence token; failover moves the fence, never duplicates it); (iii) **exact-grained input-cut** (log-position/content-hash, never a coarse label → else false-dedup / silent under-admit). **Canonical key = the 3-tuple `(input-cut, model-version, recipe/dynamic-version)`.** The **seed is a recorded parameter OF the recipe/dynamic term** — a distinct draw is a distinct recipe/dynamic-version, so the 3rd coordinate already separates it; a separate seed slot would reopen the double-admit (two seeds → two txids for one fact). **Seed and numerical-environment are Tier-2 re-derivation terms in lineage, NOT identity coordinates.** Never a Temporal run/attempt id. |
| **S2** | **Workflow-code deploy mid-backtest** (§2). | DEPLOY-IS-ORCHESTRATION-ONLY — see §2. No row breaks; confirms I4 axis-non-leak is load-bearing. |
| **S3** | **History-limit continue-as-new mid CA-sandwich** (§2, wording corrected). | SANDWICH-CARRIES-NO-WORKFLOW-STATE — see §2. No row breaks. |
| **S5** | **Clock skew across workers/DCs** (§2). | THREE-TIMES-ARE-RECORDED-VALUES — see §2. No row breaks; confirms times-on-the-log / door-logical-order is load-bearing. |

## 2. Red-team R8+R9 (and the S3 wording corrections)

### S2 — workflow-code deploy mid-backtest → DEPLOY-IS-ORCHESTRATION-ONLY
A Build-ID deploy injected at any backtest step cannot change a recorded result:
- **Economics.** Every admitted `(txid, value)` is a version-pinned fold/read-back over terms **on
  the log** — ProductTerms, model/recipe, dynamic/gate-terms (axes 2/3) — under the canonical
  3-tuple; the **Build-ID (axis 1) is not in the domain of the fold** (I4 axis-non-leak). A
  version-pinned activity fires the *recorded* version, so the same log folds to the same value.
- **Orchestration.** An in-flight run stays **Build-ID-pinned** (R-17 Worker Versioning): it drains
  on its pinned Build-ID or continues-as-new onto the new code at a boundary — either way the result
  is deploy-invariant, because the economic computation is a function of `{recorded input-cut,
  pinned model/recipe-version}`, not the deployed binary.
- **Isolation.** A production deploy leaves an isolated simulation namespace's admitted set untouched
  (R-20), and vice versa.
- An economic change is therefore never an in-place mutation: it is a **new recipe/dynamic-version =
  a new txid = a distinct fact** (the three-axis separation, D9).
- **Finding (contained):** holds ONLY IF economics are not fused into the Build-ID. IF a deploy could
  change a recipe default a running workflow reads (economics smuggled into worker code), the result
  would change — the exact break T-3 named for S6. Containment: economics live on the log as
  version-pinned pure functions, never in workflow code (D9/I4/R-17); the same guard defends both.
  Witness `prop_deployMidBacktestInvariant` — inject a Build-ID change at each step, assert admitted
  set + total order = no-deploy run — MUST fire (zero firings = defect, C-2.5).

### S5 — clock skew across workers/DCs → THREE-TIMES-ARE-RECORDED-VALUES
Adversarial per-worker/per-DC clock offsets cannot cause a wrong time or a wrong order:
- The committed order is the door's **logical total order `(exec, door, hash)` read from the log**,
  never sampled from a wall clock at replay (D11/D12). Each of the three times is a **recorded
  coordinate**: execution = the source-asserted as-of (court-enforceable, recorded); monitor = the
  boundary observation (recorded provenance, null when the Monitor emits); door = the single writer's
  admission stamp, **monotone per lineage** (the writer's admission sequence, not wall-clock
  accuracy — and the hash backstops any monotonicity gap, so the order is total regardless).
- **No bare clock read stamps a recorded fact** — enforced by type (the bare-read analog of D1):
  `workflow.Now` never reaches a contract, a model, or the committed order (D8).
- Skew is admissible **only into watch/timer FIRING** (a liveness effect): a skewed timer fires
  early/late, but the transaction it produces is keyed on the recorded as-of/cut, so it yields the
  **identical txid** (C-3.7), **S4-absorbed** if duplicated, and surfaces as an overdue-watch event —
  never a reordered fold. Two skewed DCs replaying the same events commit the **identical order**.
- **Finding (contained):** holds ONLY IF no wall clock authors any of the three times or the order.
  IF the fold ordered on a wall clock sampled at replay, or a timer's fire-time entered a txid, skew
  would mint a different fact. Containment: door time is the single writer's logical admission
  sequence (not a wall clock); execution/monitor times are recorded; the tiebreak hash is
  content-derived. Witness `prop_clockSkewInvariant` — adversarial offsets over a history with
  timers/watches, assert admitted set + total order + recorded three-times = zero-skew run (only the
  firing schedule differs) — MUST fire.

### S3 wording corrections (survival already proven r7; determinism wording tightened)
- **Byte-identity, precisely.** A leg **already admitted** before the continue-as-new is byte-identical
  on resume **by READ-BACK of its durably-recorded emission**, not by recompute. A leg **not yet
  admitted** when the CAN fired is **re-driven**: for a non-bit-reproducible model it may re-draw a
  different value — a fresh first-admission, **S4-idempotent and β-bounded**, not byte-identical. The
  property S3 needs — **no half-sandwich, no double-strike** — holds either way; only the determinism
  of a re-driven kind-2 leg is bounded by β, not guaranteed.
- **Canonical leg keys** (no ad-hoc axis): a model-priced mark (kind-2) keys on the 3-tuple
  `(input-cut, model-version, recipe/dynamic-version)` — the two marks differ because they read
  different cuts (pre-/post-CA, hence different frames); the certificate (kind-3) keys on
  `H(cause, contract, unit, seq)`.
- **Mark kind rule (once):** a sandwich mark is **kind-1** when it is an operator-reframe (a projection
  at read) and **kind-2** when it is model-priced (a re-entered observation).
- **Completion domain / real hazard:** completion is a deterministic function of `{nodeId, cut}`
  **resolved against the log** (the pre-/post-CA cuts are recovered via nodeId, not carried). The
  break is NOT a dropped un-admitted mark (safely re-struck from the log) but a **carried STALE mark**;
  containment: CAN carries only `{unitId|lineageId, nodeId, cut}`, every mark struck as a
  projection/re-entry from the log, never held in workflow memory.

**Both reduce to already-proven invariants** (no new mechanism): S2 → I4 axis-non-leak (the guard T-3
named for S6); S5 → D11/D12 times-on-the-log + R-08 timer-liveness. The deep invariant is unchanged:
the substrate holds no atomic state, no write credential, and authors none of the three times or the
order, so a crash, failover, storm, CAN, cache poison, deploy, or clock skew degrades to a
liveness/backpressure incident or a detectable-and-repaired economic defect — never a wrong,
duplicated, half, or reordered admitted fact (R-21/R-02, generalized).

## 3. Firing-witness harvest (the one consensus gate — each MUST fire, C-2.5)
Named and owed, one spelling each: `prop_refoldIdempotent`, `prop_refoldEqualsTimely`,
`prop_everyKind2ConsumerChecksBeta` (COVERAGE-β), `prop_sandwichCANInvariant`,
`prop_wipeRebuildEqualsLog`, `prop_fabricatedTxidRefusedOrAudited`, `prop_deployMidBacktestInvariant`,
`prop_clockSkewInvariant`. A named property whose precondition is never generated is a defect (zero
firings), not a green test — the harvest must be delivered, not just listed.

## 4. Open questions (unchanged; no new park)
Parking exercised, empty (derived stream ≠ second store; gate verdict = kind-3 pinned event-outcome;
must not turn on Valuation-Manifesto PARK-1). Residuals: **TA-REPRO adequacy** (a producer's attested
β honesty is a governance/perimeter reconciliation — the same standing as S6's economic
detection-at-audit edge); the **load model** (K, door/derivation pools); Forks C/D settled-soft,
non-correctness. All ten red-team scenarios (S1 refold-crash, S2 deploy, S3 CAN-sandwich, S4 retry
storm, S5 clock skew, S6 poisoned-cache, S7 failover-mid-gate) now argued and HOLD; the only work left
before consensus is the firing-witness harvest (§3) and the assembly's merge-hygiene closes.
