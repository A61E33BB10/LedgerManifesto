# Temporal as Execution Substrate for the WHOLE Framework — TEMPORAL-4, Round 2

The spine is converged and I do not relitigate it: log = sole book / Temporal history =
disposable cache; one idempotent door fronting the Transaction Executor; one long-lived
workflow per unit, no child workflows for lineage; model output = re-entered observation,
projections store nothing; exactly-once *admission* via cause-derived txid over recorded
inputs; three times (execution/monitor/door), only execution orders the fold; refold =
single writer's work, substrate re-fires FORWARD only; sim/backtest in isolated namespaces;
undecidable/fail/refuse = returned value.

R2 closes the four things I owed. **(i)** The set-wide determinism gap — exactly-once
*admission* is not a deterministic *value* for a non-bit-reproducible model — is now a
catalogue row [D14], resolved by the doctrine's own read-back/re-derivation split, not left
open. **(ii)** The MD-16 prevention→detection tension moves out of my Q4 into a contained
row [D7] (adopting TEMPORAL-5's line). **(iii)** Fork A: the derived state and its gate
decision commit as ONE door transaction over ONE pinned cut [D15], and I resolve TEMPORAL-5's
refuse-vs-flag loose end. **(iv)** Fork B: re-mark cadence splits by the spec's own
contractual-vs-system axis, and I pin the production-derived-stream vs isolated-sim seam.
I keep D1/D13/split-branch (best-in-set) and harvest T2's idempotence-key wording, T3's
third versioning axis and Schedule pole, and T5's heartbeat/ScheduleToClose economics.

## 1. Mapping table (deltas from r1 in **bold**)

| Framework object | Temporal construct | Note / register tie |
|---|---|---|
| The immutable log (book of record) | *nothing in Temporal*; external hash-chained store | history is a disposable cache; never the log (R-02) |
| The Transaction Executor (the door) | NOT a workflow; ONE idempotent `admit/refuse` activity, sole write credential | the only write path (R-01, M6) |
| A smart contract | version-pinned, queue-routed activity (never workflow, never local) | economics off Temporal's replay surface (R-06) |
| A unit (walking its graph) | one long-lived workflow per `unitId` | node/watch mirror the ledger, rehydrated (R-03/04) |
| A watch (declared→armed→fired/expired) | date → durable timer; condition → signal-driven eval | lifecycle on the log; timer = liveness half (R-08) |
| A transaction / move | proposed by an activity, admitted by the door | txid = cause-derived from recorded inputs (R-07) |
| A projection (balances, NAV, chain, encumbrance) | read-only activity / Query | stores nothing |
| The total order and refold | the single writer's work; NOT Temporal | substrate re-fires FORWARD only (§sec:substrate) |
| ContinueAsNew | carries `{unitId, nodeId, log-cursor}` only | = cold rebuild-from-ledger (R-15) |
| Signal / signal-with-start | timing/reference only; fan-out to maybe-not-running units | never payload; branches stay in-workflow (R-11, R-14) |
| Child workflow | **not** for ledger-created units (own workflow via signal-with-start); split legs = new units, market-claim leg = branch (same workflow) | do not conflate split with ContinueAsNew (R-14) |
| An **observation** (market data) | ingestion activity proposes a moveless observation-recording transaction through the ONE door | no per-observation workflow; a non-recording fetch is the forbidden bare read (§sec:obs-door, D1) |
| The **market data operator** (CA frame transform) | projection computed at read; declared data on the log | never a workflow (C-9.2, MD-13) |
| A **derived object** — projection kind | read+compute activity, recomputes on read | stores nothing (MD-6) |
| A **derived object** — re-entered-observation kind (model fit) | version-pinned model activity + door re-entry | staleness is a recorded flag; **value canonical by first admission, read-back only (D14)** |
| A **valuation mark** (chain link) | model activity + door re-entry | chain/NAV = projection (VM-1/3) |
| A **profit-and-loss explain certificate** | projection over two marks | residual bound is a declared log term (VM-4/6) |
| A **corporate-action valuation sandwich** | two model activities + operator projection + certificate, in the unit's workflow | **late CA = refold + forward re-read (D3)** (VM-9) |
| An **MD-16 derived state `m*` + its gate decision** | construct + two-gate predicate activities; **state AND decision cross the door in ONE transaction over ONE pinned cut** | **prevention at construction, detection at audit (D7); stale cut ⇒ refused (D15)** (MD-16, MD-12) |
| A **production-serving** derived object (a real book's mark) | PRODUCTION lineage, tagged derived stream, PRODUCTION door | credential separation within the namespace (**R-18**) |
| A **simulation** derived state (risk/backtest/what-if) | ISOLATED namespace, own lineage's door | never the production door (**R-20**) |
| Temporal Schedules | **system cadence only** (EoD desk marks, overdue-watch/stale-fit sweeps) | contractual/graph-triggered re-marks are per-unit watches (R-09, Fork B) |

## 2. Decomposition (sharpened where R2 resolves a fork)

### 2.1 Ledger — unchanged from r1 (seed R-03/05/06/14). Fan-out by signal-with-start;
market-claim leg is a branch (same workflow), partial-split legs are new units (own
workflows). Settlement failure re-enters as a recorded event walking the
settlement-obligation unit's graph — never a Temporal saga.

### 2.2 Market data
- **Ingestion**: capture activity's only success is proposing an observation-recording
  transaction through the one door; a fetch recording nothing is a retryable no-op (D1).
- **Derived objects**: projection kind → read activity, recomputes on read; re-entered kind
  → version-pinned model activity + door re-entry with complete lineage (input cut, model
  version, seed). Staleness on input correction is a recorded flag (MD-8/10), re-derivation
  triggered forward — never workflow state (D4).
- **MD-16 gates (Fork A resolved)**: one `apply-dynamic` activity constructs `m*` from an
  admissible base **pinned at a single cut**; one `gate` activity evaluates **Gate 1**
  (no-arbitrage, `m* ∈ Θ_AF` — decidable predicate on a projection) and **Gate 2** (realism:
  per-functional/per-underlying percentiles vs the underlying's own as-known history, joint
  where marginals would hide an inversion). On pass, **the derived state and the gate
  decision cross the door as ONE transaction over that one cut** (MD-12) — atomicity from the
  shared pinned cut, not from Temporal ordering; no inconsistent-read window. If a late
  correction refolded the base under the pinned cut before the transaction admits, the cut is
  **stale ⇒ the door REFUSES** (consistency of reference, C-11.3); re-construction re-pins at
  the new cut and re-gates forward (this resolves T5's refuse-vs-flag: refuse, because a
  realism verdict against a base that no longer holds is meaningless). Fail/undecidable is a
  recorded returned value; the state is not admitted (prevention). Consumers name a derived
  state by its admission record, so an ungated state is unnameable.

### 2.3 Valuation
- **Marks / chain / certificate**: a mark is a re-entered observation (model runs outside the
  fold, C-14.9); the chain, NAV, and certificate are projections. A residual over its
  declared bound is a recorded broken chain (VM-7), a visible open item — not a workflow error.
- **Re-mark cadence (Fork B resolved)**: split by the spec's own axis (temporalv16.tex:58-59).
  **End-of-day desk marks = system cadence → a Schedule sweep** that dispatches record-reading
  pricing activities (the sweep chooses *which* units to re-mark; the pricing activity always
  reads the unit's node/frame/cut FROM THE RECORD per VM-2, so a mid-CA-node unit is never
  priced in a stale frame — answering T3's counterexample). **Contractual/graph-triggered or
  input-moved re-marks = per-unit watches** (the CA sandwich at the ex-date node; a corrected
  leaf staling a link). This puts no N-durable-timer bloat on the unit workflow for the
  system-cadence marks, and keeps the frame-sensitive re-marks graph-driven.
- **CA sandwich**: value-before (old frame) + operator + value-after (new frame) + certificate,
  in the unit's workflow. A late resolved CA is a reordering → refold re-strikes the sandwich
  retroactively at the ex-date (writer's work); the unit re-reads and re-fires forward (D3).
- **Backtests/risk**: isolated namespaces (R-20); per-step marks re-enter the derived path's
  own record; equal production by recomputation, never a second store.

### 2.4 The production-vs-simulation seam (pinned)
"Derived stream" (MD-16) is **not** synonymous with "isolated namespace". The discriminator is
*does a real unit's valuation chain read this back?* If yes — today's calibrated surface, an
MD-16 derived state serving a real mark — it lives in the **production lineage, tagged as
derived, admitted through the production door**; isolation is credential separation *within*
the namespace (the derivation queue holds no write credential; only the door does — R-18). If
it is a hypothetical (a scenario, a backtest, a what-if `m*`) it lives in an **isolated
namespace against its own lineage's door** (R-20), and only observations ever re-enter
production. The gate applies in both; the door credential is what differs.

## 3. Divergences and containments (one per row; **D7, D14, D15 new; D9 extended**)

| # | Divergence | Containment |
|---|---|---|
| D1 | **Bare-read prohibition vs activity I/O.** A fetch that records nothing is the forbidden bare read (§sec:obs-door). | Every ingestion activity's only success is proposing an observation-recording transaction; read activities read the record, never a live feed. A non-recording fetch is a retryable no-op, never consumed. |
| D2 | **Model non-determinism vs replay.** Pricing/calibration is float/solver/seed-dependent; in workflow code it is an instant non-determinism error. | Model runs are version-pinned activities (never workflow, never local); output RECORDED. Replay reads the recorded result. Heavy runs heartbeat with a bounded ScheduleToClose so retry fires only on genuine failure (adopt T5 D5). |
| D3 | **Refold's past-dated synthesised firings vs forward-only timers** (§sec:totalorder step c). | Past-dated synthesis is the SINGLE WRITER's work. On refold the unit workflow is signalled-to-re-read, rehydrates from the refolded projection, and re-fires FORWARD only under fresh ids; never rewinds. The late-CA sandwich rides this path. |
| D4 | **Staleness propagation vs workflow state** (MD-8, VM-7). | Staleness is a recorded fact; the projection "current fit for X" selects latest non-superseded and carries the flag. Orchestration only triggers forward re-derivation, reading staleness from the record. |
| D5 | **History size** — long chains, high-cadence marks, backtest fan-out. | Marks live on the LEDGER log; Temporal holds only cadence orchestration. ContinueAsNew at node transitions and every K firings, identifier triple only (R-15). Backtest marks live in the derived namespace's record. |
| D6 | **Undecidable / refuse vs retry-to-infinity.** Gate 2 can return *undecidable*; the door can refuse. | A returned value (recorded event-outcome), not a retryable error — breaks the retry loop, stands as a visible blocked item (R-22). |
| **D7** | **MD-16 "prevention" living in an untrusted constructor.** Gate 1 is prevention, but the door checks no arbitrage (economic correctness is never gated at admission, C-13.2). | The gate is a **decidable predicate on a projection**, so any party recomputes it: a mis-gate degrades to a **detectable, forward-repaired defect, exactly as an economically-wrong contract does** (adopt T5 D7). Prevention *at construction* (a failing state is never emitted, so no consumer meets one); detection *at audit* (ch15 recomputation). No new admission privilege; the door still records only facts. |
| D8 | **Workflow-code nondeterminism** — wall clock, randomness, unordered-map iteration, direct I/O, local activities. | Confined to activities; `workflow.Now` never fed to a contract or model; the three times come from the log (D12). |
| **D9** | **Versioning — THREE axes, not two** (the extension adds a third). | (a) orchestration = Worker/Build-ID, draining to the next ContinueAsNew boundary (R-17); (b) contract economics = ProductTerms on the log; (c) **model/recipe/dynamic/gate-declared-term versions on the log** (MD-6, MD-16) — pinned per derived object, bearing C-2.2, never touching workflow code (adopt T3). |
| D10 | **Retry vs exactly-once ADMISSION.** Activities are at-least-once. | Exactly-once admission is the door's cause-derived txid over **recorded inputs — the `(input-cut, model/recipe-version)` identity, never a Temporal run/attempt id** (adopt T2 wording). Temporal dedup is optimisation, never load-bearing. |
| D11 | **Queue/signal/observation arrival order vs the fold.** | Arrival order is orchestration sequencing only; committed order is the total order `(exec, door, hash)` at the door alone (R-25). A late observation refolds; a same-instant non-commuting pair is ordered by declared precedence or refused, never by an arrival-order tiebreak. |
| D12 | **Timer semantics vs the three times.** | Timers carry NO time authority; execution/monitor/door live on the log; the substrate's clock orders nothing (§sec:substrate). A late-firing timer produces the identical transaction (C-3.7). |
| D13 | **Attribution/dispersion convention as worker config** (VM-5, VM-11 Σ). | The convention (held-invariant factor, partition π, dispersion D, normalisation ν) is a declared, recorded term read by the projection — never a worker default; else two workers disagree. Same discipline as idempotence keys never coming from Temporal. |
| **D14** | **Exactly-once ADMISSION ≠ deterministic VALUE.** A non-bit-reproducible model (float non-associativity, GPU reduction order, solver optima) run at-least-once yields two payloads under the SAME txid; the door admits the first-arriving and absorbs the second, so the canonical value turns on a door-arrival race. | **Forced by the Constitution's scope, not chosen.** The ledger guarantees **read-back** (C-2.2 holds *for the record*: once admitted, the value reproduces bit-for-bit on every replay). It does **not** guarantee bit-equal **re-derivation** — that needs the retained model + numerical environment, explicitly a governance matter OUT of scope (C-14.15, MD-6); making bit-reproducibility an admission precondition would pull that governance into scope, which C-Scope.11 forbids. So the **first-admitted value is canonical-by-record** (option b), and this is exactly the bound MD-14/VM-8 already place on a model number's dispute-readiness ("a model's number once the model is supplied, never wider"). Two guards keep it honest: (1) the door records a **content-hash beside the txid**, so an absorbed redelivery whose payload DIFFERS is a recorded "model-non-reproducible" diagnostic, not a silent over-coarse absorption (closes MD-1's own named residual) — a structural check, not an economic one; (2) heartbeat + bounded ScheduleToClose make double-execution rare (D2). Replay of the *record* is deterministic; only first-admission is a boundary provenance fact, like which of two simultaneous prints the world delivered first. |
| **D15** | **MD-16 write atomicity vs at-least-once retry** (Fork A). Two-write (record the pass, then construct) opens an inconsistent-read window: a recorded pass with no state until the retry lands. | Derived state AND gate decision cross the door as **ONE transaction over the one pinned cut** (MD-12); atomicity from the shared cut, not Temporal ordering. A base moved under the pinned cut ⇒ **stale cut ⇒ the door refuses** (C-11.3); re-pin and re-gate forward. Refuse, not flag — a verdict against a base that no longer holds is meaningless. |

**Task-queue families.** Seed's five (door, contracts, ingestion, unit-orchestration,
settlement) plus a **derivation/models** family (pricing, calibration, gate evaluation —
version-pinned, heartbeated, possibly GPU). **SOFT (Fork C):** whether models split from
contracts is a load-model scaling call, not an architecture fork — the mapping is identical
either way; I no longer commit, per the referees. Simulation namespaces mirror these families
against their own door.

## 4. Open questions (parking mechanism EXERCISED, not asserted empty)

1. **Constitutional seams tested — no new park.** Three extension seams were checked against
   the Constitution and each is already resolved, so the index is empty *by test*: (i) the
   derived stream as a "second store" — no, it is the same immutable-log mechanism on a
   distinct lineage (C-2.8, C-12.5); (ii) storing a gate decision vs the recompute-on-read
   rule (C-4.11) — MD-16 reconciles it as a pinned as-known event-outcome, not a live
   projection, and this design must **not** turn on the Valuation Manifesto's **PARK-1**
   (valuation storage): gate-decision and mark recording ride the existing
   re-entered-observation mechanism, which MD-16 states "neither reopens nor turns on" PARK-1;
   (iii) MD-16 prevention vs the door's capture-then-classify — contained in D7, not a
   conflict. (Adopting T2's exercised-index discipline.)
2. **Load model (biggest unknown, MEDIUM confidence on constants).** Event + mark +
   derived-state volume per unit/underlying per day sizes K (ContinueAsNew), the door pool,
   the derivation pool, and the simulation-namespace door. Forks C (models queue split) and D
   (sim fan-out shape) both gate on it and are explicitly non-correctness (T2/T5 framing:
   child-workflow-per-shift vs bare activity fan-out is a decomposition choice; note the seed
   bans child workflows only for *lineage* coupling, so either is spine-compatible inside a
   sim namespace).
3. **Read-back vs re-derivation for disputes (D14 tail).** Whether the reference
   implementation ALSO pins a numerical-environment version beside the model version — making
   a re-entered observation bit-for-bit *re-derivable*, not merely read-back — bounds MD-14/VM-8
   dispute-readiness for model numbers. It is a governance/implementation decision, not a
   substrate one, but the committee should record which guarantee it targets (adopting T5's Q3).
