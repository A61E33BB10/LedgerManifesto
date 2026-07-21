# Temporal Committee — Proposal TEMPORAL-1, Round 1

**Stance.** `temporalv16.tex` maps Temporal onto the *ledger's* two untrusted machines and stops
there. Market data and valuation are not a second substrate: they are the **same** machine folding
**observations** and **re-entered observations** through the **one door**, so the extension adds no
new mapping primitive — it adds new *object kinds* that ride the existing one. The whole framework
reduces to two record kinds (a **projection** that stores nothing; a **re-entered observation**
whose model runs outside the fold and re-enters through the door) plus one lineage discipline
(cause-derived `txid`, pinned **cut**, forward-only refold). Every Temporal object below is chosen
so that stripping Temporal rebuilds market data, every derived object, every valuation chain, and
every MD-16 gate decision from the immutable log alone (R-02).

---

## 1. Mapping table

| Temporal primitive | Framework correspondence (ledger / market data / valuation) |
|---|---|
| **Workflow** | One long-lived **unit** workflow per `unitId`, walking the product graph (seed R-03). MD/valuation add no new workflow *kind*: a derived-object build, an MD-16 dynamic application, and a valuation-chain link are all sequences the owning unit-workflow (or a keyed derived-object workflow in a derived lineage) runs. |
| **Activity** | Every side effect: `captureArrival` (envelope-first through the door), `fetchProjection`/`readCut`, `runModel` (version-pinned), `proposeToDoor`, `applyOperator`, `computeExplainCertificate`, `checkResidual`, `gate1_noArb`, `gate2_realism`. The **market data operator**, NAV, PnL, and the settlement projection are pure read-time projection activities that store nothing. |
| **Signal** | Timing + reference only, never economic payload (R-11, M4): a condition-**watch** satisfaction (observation/barrier), a corporate-action cascade fan-out, a "re-read: the fold moved under you" notice (sec:substrate). Every signal has a record-derived backstop; a lost signal costs latency, never the record. |
| **Query** | Non-authoritative liveness view (R-13). A **dispute** (VM-8/MD-14) is a *replay*, i.e. a read-only re-derivation from the log — a Query at most, never authoritative. |
| **Child workflow** | Not used for parental linkage (ledger-absent relational state, R-14). Ledger-created units (settlement-obligation unit, market-claim leg's successor, MD-16 derived state in a derived lineage) start their **own** workflows via signal-with-start; graph *branches* stay in the owning unit's workflow. |
| **Continue-as-new** | History-size control only; carries `{unitId|lineageId, nodeId, cut/log-cursor}` and nothing else (R-15). The valuation **chain**, derived objects, and gate decisions live on the log and rehydrate from it — never in carried state. |
| **Durable timer** | Date-**watch** liveness half only (R-08). The frame boundary, ex-date, and due-date are the *recorded* event's **execution time**, read back as data; the timer fires forward and never authors any of the three times. |
| **Schedule** | System cadence only (end-of-day sweep, overdue-watch reconciliation) — never a per-unit contractual date, never one Schedule per fixing (R-09). |
| **Update** | Human gates only (R-13): quarantine disposition, authorised fork, bound recalibration. Boundary capture and valuation never ride an Update. |
| **Namespace** | Trust/lineage isolation. Production = one authoritative lineage. Risk, scenario, backtest, authorised fork = isolated namespaces against their **own lineage's door**, `lineageId:unitId` keyed (R-03, R-20). |
| **Task queue** | Split by trust/scaling (R-18): door (sole write credential), contracts+models (read-only, version-pinned), ingestion (must-not-lose), unit-orchestration, settlement/egress, plus a **derived-object/gate** queue for MD-16 and valuation model runs. |
| **Search attribute** | Ops projection reconciled to the log, never authoritative (R-19): next watch due, node, obligation status, **chain-head staleness**, **gate verdict** (pass/fail/undecidable). |
| **Worker Versioning / Build-ID** | Orchestration axis only; CAN boundaries are cutover points (R-17). The **economics** axis (ProductTerms, model versions, dynamics, gate declared-terms) lives on the log as version-pinned pure functions and never touches workflow code. |

**Book of record vs cache.** Immutable log = sole truth (R-02, C-2.2). Temporal history = disposable.
The one door absorbs at-least-once delivery into exactly-once at the record via the cause-derived
`txid` (R-07). This holds identically for a trade booking, a market-data observation, a re-entered
model price, and an MD-16 gate decision.

---

## 2. Decomposition

### 2.1 Ledger (restated from the seed, compact)
- **Unit-workflow**: pending timers + signal-waits = current node's out-edge set (the armed watch
  list). In-memory node is a mirror; rehydrated from the ledger on start, on CAN, on any doubt.
- **Activities**: `captureArrival` → `evaluateContract` (version-pinned, queue-routed, never a local
  activity, R-06/R-26) → `proposeToDoor`. Door = external single-writer service, one idempotent
  `admitTransaction` activity (the only writer, M6).
- **CA cascade** = fan-out: parent CA event → signal-with-start to each affected unit-workflow; each
  firing proposes its own `txid`, so all *n* commit (R-14).

### 2.2 Market data
- **Ingestion**: `captureArrival` records the observation through the **one door** as a moveless
  observation-recording transaction (B1, MD-1); envelope-first, before payload validation (R-12).
  No second door for market data.
- **Derived object — projection kind** (discount factor, operator-adjusted value): a pure read-time
  activity, stores nothing, idempotent by construction; no workflow needed — it is recomputed from
  the record on every read (MD-6, MD-8).
- **Derived object — re-entered-observation kind** (fitted surface, filter, optimiser): a build
  sequence — `pinCut` → `fetchInputs(cut)` → `runModel(version-pinned; recorded seed)` →
  `proposeObservation(door)`. The ledger runs no model (C-14.9/V1); the output re-enters as an
  observation with complete lineage (MD-6).
- **MD-16 dynamic application (derived STATE)** — the new gate workflow, running in a **derived
  lineage/namespace**:
  1. `pinCut` — one application cut for the admissible base state (surface + rate/dividend curves +
     correlation block).
  2. `gate1_noArb(cut)` — decidable predicate `m* ∈ Θ_AF`; **prevention** (state not constructed if
     it fails).
  3. `gate2_realism(cut, as-known history)` — per-functional, per-underlying percentiles against the
     underlying's own as-known past; **joint** functionals tested against the point cloud, not
     marginals.
  4. If both pass: `constructDerivedState` + record the **admission** (the passing gate decision)
     through the door. If fail/undecidable: record the **refusal**. No derived state exists without
     its admission record; consumers name it by that record.
  Gates + construction are **one evaluation over the one pinned cut** (MD-12) — the base cannot move
  between gating and construction. The gate decision is a recorded event-outcome, pinned as-known
  with declared-term lineage — not a base-stream projection recomputed on read.
- **Corporate action / market data operator**: CA = first-class recorded transaction; the operator
  = read-time **projection** (never stored, computed at read, original never overwritten, MD-13/B4).
  Frame is a coordinate. Late/corrected/provisional CA → refold + re-read (below).

### 2.3 Valuation
- **Chain link (VM-1/VM-3)**: `pinCut` → `priceLeg(version-pinned model; re-enters as observation via
  door)` → `computeExplainCertificate(entry+exit greeks)` → `checkResidual(returns explained|breached)`
  → append link through the door. The **valuation chain** and its **certificates** live on the log;
  the workflow holds only the chain-head cursor.
- **NAV / PnL** = pure projection over the log, stores nothing (VM-1, C-8.2). One recipe; the same
  recipe serves risk (VM-10) so risk and books cannot disagree.
- **CA valuation sandwich (VM-9)**: at a CA node transition, strike before-mark (old frame) and
  after-mark (new frame), operator projection between; residual ≈ 0 is the proof. Struck as a
  projection from the log, so the CAN boundary at the node (R-15) is safe — both marks are on the
  log. Late resolved CA → retroactive sandwich at ex-date via refold, spurious market-move line
  reclassified as zero-profit frame re-coordination.
- **Broken chain (VM-6/VM-7)**: residual over bound, or a moved leaf, is a **recorded** flag + open
  item (a returned value, mirroring R-22), never a workflow error/crash/infinite retry.
- **Staleness propagation**: a corrected leaf → refold (single writer) → affected valuation
  workflows **signalled to re-read**, re-derive **forward** from the superseding predecessor under
  fresh `txid`s (sec:substrate). Never edit an old proof; never rewind workflow state.
- **Risk / scenario / backtest (VM-10/VM-11)**: same recipe on **shifted** market data, in an
  isolated namespace against its own lineage's door. The **shift** is the recorded seed (MD-11); the
  strategy is itself a **unit** (C-10.2), so a backtest reuses one-workflow-per-unit unchanged.
  Simulated re-entered valuations enter the simulated path's own record, never the real chain. A
  strategy comparison is valid only at identical coordinates — a decidable lineage-set check.

---

## 3. Divergences + containment (one per bullet)

- **Nondeterminism (model eval, RNG, wall clock, unordered-map iteration, direct I/O).** Contain in
  version-pinned, queue-routed activities only — never workflow code, never local activities
  (R-06/R-26). Reproducibility authority is the **recorded seed + retained model on the log**
  (MD-6/MD-11), not Temporal's memoized activity result.
- **Mid-update valuation / derived object** (reading the fold at two different points). Pin **one
  cut** and pass it to every activity in the evaluation (position-read and price-read take the same
  cut); activities never read "current" live (VM-2, MD-12). One evaluation = one cut.
- **MD-16 gate atomicity vs at-least-once retry.** Gates + construction run over the one pinned cut;
  the decision re-enters via the door keyed on `(dynamic, base-cut)` → idempotent under retry.
  **Undecidable** (thin/sparse joint history) and **fail** are *returned values* recorded as a
  refusal, never a retryable error; the state is simply not admitted (prevention, not detection).
- **Prevention living in an untrusted constructor.** MD-16 Gate 1 is "prevention" but the door does
  not check no-arbitrage (economic correctness is never gated at admission, MD-2/C-13.2). Contain by
  recording the gate decision with declared-term lineage; auditability **re-derives** it (ch15
  recomputation), so a lying constructor degrades to detection-at-audit — the same defence used for
  an economically-wrong contract. (Flagged in §4.)
- **Retry semantics vs exactly-once meaning.** Activities are at-least-once; exactly-once is at the
  **record** via cause-derived `txid` at the door (R-07). Door refusal, residual breach, and gate
  fail/undecidable are values, never retried to infinity (R-22).
- **Task-queue / signal-arrival order vs execution order (order is meaning, MD-5).** Committed
  meaning-order is the total order `(exec, door, hash)` at the door alone (R-25/C-2.7). A derived
  object binds to its pinned cut, not to delivery order; a late observation → refold → downstream
  projections recompute and re-entered observations are flagged stale.
- **Timer semantics vs the three times.** Durable timers are the liveness half only; the three times
  (execution/monitor/door) live on the log and are read back as data. The CA sandwich strikes
  against the **recorded** CA event and its resolution observation, never the timer's wall-clock
  firing. Timers fire forward only; past-dated/retroactive firings are the single writer's refold
  work (sec:substrate), never substrate-authored.
- **Workflow-code versioning vs economics versioning.** Two axes stay separate (R-17): Worker
  Versioning for orchestration (CAN = cutover), ProductTerms + version-pinned pure functions for
  economics, pricing, dynamics, and gate terms. A Temporal non-determinism bug degrades to a
  liveness incident, never wrong ledger/valuation state (R-21).
- **History-size limits (valuation cadence + derived-stream volume).** Chain links, certificates,
  and gate decisions live on the **ledger log**, not Temporal history. Per-workflow history is
  bounded by ContinueAsNew (R-15) with `K` sized to `max(fixing, mark)` cadence; derived-stream
  volume is isolated to derived lineages/namespaces (R-20). Carried state = the identifier triple
  only.
- **Chain / gate decisions must not live in Temporal history.** The workflow holds only a cursor;
  every link, derived state, and gate verdict re-enters via the door. Acceptance test: strip
  Temporal, rebuild the whole chain + derived states + gate decisions from the log (R-02).
- **Staleness/refold vs Temporal replay.** Forbidden: replay a workflow's recorded history against
  the new fold, or compensate substrate-side (both smuggle ledger state into the substrate). Contain
  by signalled-re-read + forward re-derivation under fresh `txid`s (sec:substrate) — identical for a
  stale market-data re-entered observation and a stale valuation link.
- **Simulation isolation.** Risk/backtest in isolated namespaces, own lineage's door, `lineageId:unitId`
  keys (R-03/R-20). Simulated re-entered valuations enter the simulated path's own record, never the
  real chain; comparison is valid only at identical coordinates (VM-11), a decidable lineage check.

---

## 4. Open questions

- **Parking test exercised, empty.** The extension is a substrate mapping: every market-data and
  valuation object stays a **projection** or a **re-entered observation** on the log, the log stays
  sole book of record, and no constitutional clause is narrowed. Like the certified seed, it demands
  nothing of the Constitution. (Stated so the empty index is a checked result, not an unexercised
  mechanism.)
- **Strongest seam for owner acknowledgement (not a conflict).** MD-16 Gate 1 "prevention" is
  enforced in an *untrusted* construction activity, backed by recorded-decision recomputation. Worth
  an explicit cross-manifesto note that "prevention-at-construction = detection-at-audit" under the
  single-trusted-door model, so no reader mistakes it for door-enforced prevention.
- **Load model (inherited MEDIUM confidence).** Event + mark + derived-state volume per unit per day
  sizes `K` (CAN cadence), the door pool, and derived-stream storage. The single biggest unknown.
- **Derived-stream lifecycle.** Every scenario/backtest step and every MD-16 admission multiplies
  re-entered observations. C-2.8 sanctions the volume, but: does each simulation lineage get its own
  Transaction Executor instance, and how are spent derived lineages garbage-collected without
  touching the append-only production log?
- **Gate-2 "undecidable" cadence.** On sparse joint history a derived-state build parks as
  undecidable by design. Is that a liveness alarm or an expected steady state, and what declared-term
  calibration keeps it from masking a feed gap? Needs the load model + the declared percentile terms.
