# Temporal Committee — Proposal TEMPORAL-1, Round 2 (nominated mapping base)

**Stance.** The extension is **three record kinds + one lineage discipline** — the minimum basis,
corrected from R1's "two kinds" (FORMALIS: the MD-16 gate verdict is a third). The three:
1. **Projection** — stores nothing, recompute-on-read, *never stale* (NAV, PnL, the valuation chain
   as assembled, the market data operator, settlement instructions).
2. **Re-entered observation** — a model output stored as a fact; read-back unconditional; *stale when
   a consumed input moves* (MD-8), superseded forward (a mark, a greek, a fitted surface, a calibration).
3. **Recorded decision, pinned as-known** — a verdict recorded with the event it decides; *not
   recompute-on-read, not stale-on-input-move* (it decided against inputs as they then stood). This is
   **not a new primitive**: the base ledger already has it as the door's admit/refuse (spec l.1051); the
   MD-16 gate verdict (pass/fail/undecidable) is the same shape.

The lineage discipline is unchanged: cause-derived `txid` over **recorded inputs**, pinned **cut**,
forward-only refold. Every object below is a projection, a re-entered observation, or a decision, so
stripping Temporal rebuilds market data, every derived object, every valuation chain, and every gate
verdict from the log (R-02). Determinism-gap closure and the two live forks are resolved in §3.

---

## 1. Mapping table

| Temporal primitive | Framework correspondence (ledger / market data / valuation) |
|---|---|
| **Workflow** | One long-lived **unit** workflow per `unitId` walking the product graph (R-03). A derived-object build, an MD-16 dynamic application, and a valuation-chain link are sequences the owning unit-workflow (or a derived-lineage workflow) runs — no new workflow *kind*. |
| **Activity** | Every side effect: `captureArrival` (envelope-first through the door), `readCut`, `runModel` (version-pinned), `proposeToDoor`, `applyOperator`, `computeCertificate`, `checkResidual`, `gate1_noArb`, `gate2_realism`. The market data operator, NAV, PnL, the certificate, and settlement are pure read-time **projection** activities that store nothing. A read that records nothing is the forbidden **bare read** (§sec:obs-door) — a retryable no-op, never a value consumed. |
| **Signal** | Timing + reference only (R-11, M4): a condition-**watch** satisfaction, a CA cascade fan-out, a "re-read: the fold moved under you" notice (sec:substrate). Every signal has a record-derived backstop. |
| **Query** | Non-authoritative liveness view (R-13). A **dispute** (VM-8/MD-14) is a *replay* — read-only re-derivation from the log. |
| **Child workflow** | Not for lineage coupling (R-14). Ledger-created units start their own via signal-with-start; **graph branches stay in the owning workflow** (market-claim leg = branch → same workflow; partial-split legs = new units → own workflows — **do not conflate split with ContinueAsNew**). |
| **Continue-as-new** | History-size control; carries `{unitId|lineageId, nodeId, cut}` only (R-15). Chain, derived objects, and gate verdicts live on the log and rehydrate from it. |
| **Durable timer** | Date-**watch** liveness half only (R-08). The frame boundary, ex-date, due-date are the *recorded* event's **execution time**, read back as data; the timer fires forward, authors none of the three times. |
| **Schedule** | System cadence only (R-09): end-of-day desk marks, overdue-watch and stale-fit sweeps. Never a per-unit contractual date. |
| **Update** | Human gates only (R-13). Boundary capture and valuation never ride an Update. |
| **Namespace** | Two orthogonal separations (§2.2): **base vs derived stream** = tagged sub-streams of one **production** lineage, **same door**; **production vs simulation** = physically isolated namespaces, each its **own lineage's door** (R-18/R-20). |
| **Task queue** | Split by trust/scaling (R-18): door (sole write credential; admits base + production-derived re-entries + gate verdicts), contracts, ingestion, unit-orchestration, settlement. A **models/derivation** family is a soft sixth, load-model-gated (§4). |
| **Search attribute** | Ops projection reconciled to the log, never authoritative (R-19): next watch due, node, chain-head staleness, gate verdict. |
| **Worker Versioning / Build-ID** | Orchestration axis only (R-17). **Three** economics axes on the log, off Temporal's surface: ProductTerms (contract), model/recipe (re-entered obs), dynamic/gate declared-terms (MD-16). |

**Idempotence key (adopt committee-wide).** Every re-entry (re-entered observation, gate verdict,
valuation link) dedupes on the recorded `(input-cut, model/recipe-version, seed)` identity via the
door's `txid` — **never** a Temporal run/attempt id. At-least-once → exactly-once admission at the door.

---

## 2. Decomposition

### 2.1 Ledger (from the seed, compact)
Unit-workflow: pending timers + signal-waits = current node's out-edge set; node is a mirror,
rehydrated on start/CAN/doubt. Activities: `captureArrival` → `evaluateContract` (version-pinned,
queue-routed, never local, R-06/R-26) → `proposeToDoor`. Door = external single-writer, one idempotent
`admit` activity (M6). CA cascade = signal-with-start fan-out; each firing its own `txid`, all *n* commit.

### 2.2 Market data
- **Ingestion**: `captureArrival` records the observation through the **one door** (B1, MD-1),
  envelope-first (R-12). No second door; absorption is the door's cause-derived-id job at the
  registered grain, never substrate dedup.
- **Derived object — projection kind** (discount factor, operator-adjusted value): pure read-time
  activity, stores nothing, recomputed on read (MD-6/MD-8).
- **Derived object — re-entered-observation kind** (fitted surface, filter): `readCut` →
  `runModel(version-pinned; seed recorded)` → `proposeToDoor`. The ledger runs no model (C-14.9/V1);
  output re-enters with complete lineage. Staleness on input correction is a **recorded flag** (MD-8);
  re-derivation is forward, triggered by the correction signal or a stale-fit Schedule sweep.
- **MD-16 dynamic application (derived STATE) — Fork A resolved (single transaction):**
  `pinCut` (one application cut for the admissible base) → `gate1_noArb(cut)` + `gate2_realism(cut,
  as-known history)` + `constructState(cut)` all over the **one pinned cut** (MD-12) → **state and its
  passing gate verdict cross the door as ONE transaction** (not record-pass-then-construct). There is
  no window where an ungated state exists. Fail/undecidable → the **refusal** is recorded, no state
  admitted (prevention). Consumers name a state by its **admission record**; an ungated state is
  unnameable. **Refuse-vs-flag tie-break** (TEMPORAL-5's loose end): *refuse* is a construction-time
  verdict (gate fail/undecidable, or the door's consistency-of-reference check fails — the state never
  exists); *flag-stale* is later (a validly-admitted pinned-cut state is superseded when a consumed
  input moves — MD-8, forward re-derivation). Different events, different times; a moved base **flags
  stale**, it does not retroactively refuse.
- **Where MD-16 prevention lives — derived, not asserted (answers FORMALIS).** Gate 1 (`m*∈Θ_AF`) is a
  decidable predicate, but one requiring **model/product knowledge** (the arbitrage-free set), which the
  door must not hold — the door is generic machinery, product-knowledge-free (spec l.917). So Gate 1
  runs in a version-pinned gate activity, *like a contract*; the door enforces the generic decidable
  invariants (conservation, consistency of reference) and commits the verdict-and-state **atomically**.
  A mis-gate then degrades to detection-at-audit (recompute the predicate, ch15), exactly as an
  economically-wrong contract does. Placement follows from the door's product-knowledge-free invariant.
- **Seam pinned (production derived stream vs simulation).** A **production-serving** derived object or
  MD-16 state (today's calibrated surface serving real marks, a state a production risk limit consumes)
  lives in the **production lineage**, re-entered through the **production door**, tagged derived-stream
  (never the base stream). A **simulation/scenario/backtest** lives in an **isolated namespace** with
  its **own door** (R-20). Test: *does a production consumer name it by its admission record?* Yes →
  production lineage; only-a-hypothetical → isolated namespace. Door-credential separation (R-18) rides
  this: base/derived share the production door; a derived *world* has its own.
- **Corporate action / operator**: CA = first-class recorded transaction; the operator = read-time
  projection (never stored, original never overwritten, MD-13/B4). Late/corrected CA → refold + re-read.

### 2.3 Valuation
- **Chain link (VM-1/VM-3)**: `readCut` → `priceLeg(version-pinned; re-enters via door)` →
  `computeCertificate(entry+exit greeks)` → `checkResidual(returns explained|breached)` → append via
  door. Chain and certificates live on the log; the workflow holds only the chain-head cursor.
- **NAV/PnL** = pure projection over the log (VM-1). One recipe serves risk (VM-10), so risk and books
  cannot disagree.
- **Re-mark cadence — Fork B resolved (split by the spec's contractual-vs-system axis).** End-of-day
  desk marks (system cadence) → **Schedule sweep** holding no per-unit chain state. Contractually- or
  input-moved re-marks (a CA-driven re-mark, a corrected-leaf → VM-7) → **per-unit watch** that reads
  the unit's node — so a CA-driven re-mark is priced in the *right frame*, not by a blind sweep.
- **CA valuation sandwich (VM-9)**: at a CA node transition, before-mark (old frame) + operator
  projection + after-mark (new frame) + certificate. Struck as a projection from the log, so the CAN
  boundary at the node (R-15) is safe. The residual within its **declared tolerances** — minor-unit
  rounding once at read, the convention's rounding, and any re-derived surface's calibration tolerance
  (VM-9's three, VM-6) — is the proof; **not an asserted ≈0**. Late resolved CA → retroactive sandwich
  at ex-date via the single writer's refold; spurious market-move line reclassified to zero-profit
  frame re-coordination; the unit workflow re-reads and re-fires forward.
- **Broken chain (VM-6/VM-7)**: residual over bound, or a moved leaf, is a **recorded** flag + open
  item (a returned value, R-22), never a workflow error/crash/retry-to-infinity.
- **Staleness propagation**: a corrected leaf → refold (single writer) → affected valuation workflows
  **signalled to re-read**, re-derive **forward** under fresh `txid`s (sec:substrate). Never edit an
  old proof; never rewind workflow state. Staleness is read from the record, never held in workflow memory.
- **Risk/backtest (VM-10/VM-11)**: same recipe on **shifted** market data, in an isolated namespace
  against its own door. The **shift** is the recorded seed (MD-11); the strategy is itself a **unit**
  (C-10.2). Simulated re-entries enter the simulated path's own record, never the real chain; where
  coordinates coincide the chain *equals* production by determinism, recomputed, never a second copy.

---

## 3. Divergences + containment

- **Set-wide determinism gap — CLOSED (the round's key obligation).** The recorded VALUE of a
  re-entered observation is deterministic-on-the-record but bit-equal on re-derivation only if the model
  is bit-reproducible. Containment: **split compute from emission** — `runModel` (result memoized in
  Temporal history) then `proposeToDoor(recordedResult)`. On retry `proposeToDoor` re-presents identical
  bytes under the identical `txid`, so the door absorbs with **no competing candidate** — the "door-arrival
  race" is removed, not merely reduced. The only recompute window is a `runModel` crash *before* Temporal
  records its result → exactly **one** value ever reaches the door (no race). There, doctrine already
  governs: **first-admitted is canonical** (MD-1 absorption — the existing rule, not a new fiat),
  **read-back unconditional** (MD-6). Bit-equality on independent re-derivation is an *optional stronger
  property* needing a pinned **numerical-environment version** beside the model version (governance,
  MD-6); MD-14/VM-8 already bound dispute-readiness to "read-back unconditional, re-derivation with the
  model," never bit-equality-without-the-environment. So (b) canonical-by-first-admission is the faithful
  default; (a) bit-reproducibility is available where dispute-readiness must reach it. Reconciled.
- **Nondeterminism in workflow code** (model eval, RNG, wall clock, unordered-map iteration, direct I/O).
  Version-pinned queue-routed activities only, never workflow code, never local activities (R-06/R-26);
  `workflow.Now` schedules only, never feeds a coordinate; the three times come from the log.
- **Mid-update valuation / derived object** (reading the fold at two points). Pin **one cut**, pass it to
  every activity in the evaluation; activities never read "current" live (VM-2, MD-12). One evaluation = one cut.
- **Retry vs exactly-once meaning.** At-least-once activities; exactly-once at the **record** via
  cause-derived `txid` (R-07). For heavy model runs, heartbeat + bounded ScheduleToClose so a retry fires
  only on genuine failure. Door refusal, residual breach, gate fail/undecidable are **returned values**,
  never retried to infinity (R-22).
- **Task-queue / signal order vs execution order (order is meaning, MD-5).** Committed meaning-order is
  the total order `(exec, door, hash)` at the door alone (R-25/C-2.7). A derived object binds to its
  pinned cut, not delivery order; a late observation → refold → downstream projections recompute,
  re-entered observations flag stale.
- **Attribution/dispersion convention as worker config (adopt TEMPORAL-4 D13).** VM-5 attribution and
  VM-11 Σ (invariant held, partition π, dispersion D, normalisation ν) are **declared, recorded terms**
  read by the projection — never a worker default, else two workers disagree. Same discipline as idempotence keys.
- **Timer semantics vs the three times.** Durable timers are liveness only; the three times live on the
  log. The CA sandwich strikes against the *recorded* CA event and its resolution observation, never the
  wall-clock fire. Past-dated/retroactive firings are the single writer's refold work, never substrate-authored.
- **Workflow-code versioning vs economics.** Two orchestration/economics axes stay separate (R-17); the
  economics side is the three log axes above. A Temporal non-determinism bug degrades to a **liveness**
  incident, never wrong ledger/valuation state (R-21).
- **History-size limits.** Chain links, certificates, derived states, gate verdicts live on the **log**,
  not Temporal history. Per-workflow history bounded by CAN (R-15), `K` = `max(fixing, mark)` cadence;
  derived-state volume isolated to simulation namespaces (R-20). Carried state = the triple only.
  Acceptance test: strip Temporal, rebuild chain + derived states + gate verdicts from the log.
- **Staleness/refold vs Temporal replay.** Forbidden: replay workflow history against the new fold, or
  compensate substrate-side (both smuggle ledger state). Contain by signalled-re-read + forward
  re-derivation under fresh `txid`s (sec:substrate) — identical for a stale observation and a stale link.
- **Settlement/model failure invites a saga.** Never (R-24). Settlement failure and a wrong model output
  are recorded events walking the relevant unit's graph; money moves back only as authorised
  compensation through the door (C-12.4), never a substrate rollback.

---

## 4. Open questions

- **Parking test exercised, empty (adopt TEMPORAL-2's discipline).** Seams tested: (i) the derived
  stream as a "second store" — no, the same immutable-log mechanism on a tagged sub-stream / distinct
  lineage (C-2.8, C-12.5); (ii) storing a gate verdict vs recompute-on-read (C-4.11) — MD-16 already
  argues it a pinned event-outcome, not a live projection; (iii) late-CA sandwich vs compensation —
  resolved by the reordering path. The one live neighbour is the Valuation Manifesto's **PARK-1**
  (valuation storage); this design must **not** turn it on — gate-verdict and chain-link recording ride
  the existing re-entered-observation/decision mechanism, which MD-16 states neither reopens nor turns
  on. Empty index, *exercised*, not merely asserted.
- **Owner-acknowledgement (now derived, not just flagged).** MD-16 Gate-1 "prevention" lives in a gate
  activity, not the door, *because the door must be product-knowledge-free* (spec l.917); atomic
  verdict-and-state commit + consumption-by-reference make prevention structural, backed by
  detection-at-audit. Worth a one-line cross-manifesto acknowledgement so no reader mistakes it for
  door-enforced prevention.
- **Numerical-environment pin (keep live, TEMPORAL-5 Q3).** Does the framework pin a numerical-environment
  version beside the model version for bit-for-bit *re-derivation*, or is read-back the only guarantee?
  A reference-implementation decision that bounds MD-14/VM-8 dispute-readiness for model numbers.
- **Load model (biggest unknown, MEDIUM confidence).** Event + mark + derived-state volume per unit per
  day sizes `K`, the door pool, and derived-stream storage. **Fork C (models queue)** — a compute-heavy
  sixth queue family — is a scaling call gated on this, not an architecture fork; the mapping is identical
  either way. **Fork D (sim fan-out)** — child-workflows *inside a simulation namespace* for
  history-bounding — is a decomposition choice, not correctness (and is *not* the seed's forbidden
  lineage-coupling use of child workflows). Both settle against the load model; do not force in R2.
- **Gate-2 "undecidable" cadence.** On sparse joint history a derived-state build parks as undecidable by
  design (prevention). Confirm it degrades to a flagged blocked item, never a retry-to-infinity; and
  whether a Schedule sweep should pre-compute joint-history sufficiency so risk runs fail fast.
