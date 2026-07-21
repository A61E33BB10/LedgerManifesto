# Proposal TEMPORAL-5 — Temporal as execution substrate for the WHOLE framework (r1)

**Stance.** The seed (`temporalv16.tex`) solves the ledger. It runs the two untrusted
machines and fronts the trusted single writer with one idempotent door activity. I extend
that one discipline — *Temporal supplies liveness; the immutable log is the sole book of
record* — to market data and valuation **without adding a second philosophy**. Every
market-data derivation, every valuation, every gate decision, every backtest step is either
(a) a **model run in a version-pinned activity whose output re-enters through the door as a
recorded observation**, or (b) a **projection** read by a read-only query activity that never
writes. Nothing new owns truth. The acceptance test is unchanged: wipe the substrate, and
observations, derived objects, valuation chains, gate decisions, and backtests all
re-derive from the log.

---

## 1. Mapping table

| Framework object | Temporal object | Note |
|---|---|---|
| **the Event Monitor** | durable timers + signal-waits inside a unit-workflow | liveness only; clock never feeds a coordinate |
| **the Events Executor** (capture) | ingestion activity (must-not-lose queue) proposing a moveless observation-recording transaction | capture precedes routing |
| **the Events Executor** (firing) | contract-firing activity, version-pinned, queue-routed | carries timing, not economics |
| **smart contract** | version-pinned queue-routed activity (never a local activity) | economics off Temporal's replay/version surface |
| **the Transaction Executor + the immutable log** | external single-writer service, the **door activity** (sole write path) | trusted; outside Temporal |
| **unit** | one long-lived workflow, keyed by `unitId` | node + armed-watch set mirror the ledger, rehydrated |
| **move / transaction** | value returned by a contract activity, admitted at the door | proposal, not fact, until admitted |
| **watch** (date) | in-workflow durable timer | |
| **watch** (observation / barrier) | signal-driven evaluation activity over recorded observations | never a timer poll |
| **projection** (balances, three homes, NAV, PnL) | read-only query activity | never writes |
| **total order / refold** | single writer's work; workflow **re-reads + re-fires forward** | Temporal never rewinds |
| **corporate-action cascade** | fan-out via signal-with-start to referencing unit-workflows | each proposes its own txid |
| **observation door** (market data) | the **same** door activity | one door; no second write path |
| **the data-kind registry** | ledger state (registration = a transaction through the door) | **not** a Temporal object |
| **derived object** (curve, surface, calibration, posterior) | **derivation activity** (model), version-pinned; output re-enters via the door as a **re-entered observation** | model lives outside the fold |
| **the market data operator** (CA frame change) | projection computed at read; the frame-change *event* fires the unit's contract | operator itself is not a Temporal object |
| **MD-16 dynamic / shift / surface-move $\mathcal D$** | declared, recorded terms (a data version) | **not** workflow code |
| **MD-16 Gate 1 (no-arbitrage) / Gate 2 (realism, joint)** | predicate-evaluation activity over a projection at a pinned cut | prevention: workflow proposes state only on pass |
| **MD-16 gate decision** (recorded outcome) | part of the derived-state transaction, one cut, one admission | atomic with construction |
| **valuation** (model price + greeks) | pricing activity, version-pinned; re-enters via the door | a re-entered observation |
| **valuation chain / link (re-mark)** | new proposal to the door; cadence driven by a workflow timer | chain lives on the ledger, not in Temporal history |
| **profit-and-loss explain certificate** | projection computed per link; residual-below-bound a decidable diagnostic | |
| **broken chain (VM-7) / gate failure / door refusal** | returned value → recorded flag, a visible overdue/blocked item | never a retryable error, never a saga |
| **corporate-action valuation sandwich (VM-9)** | two pricing activities bracketing the frame-change transaction | explain a projection |
| **risk report (VM-10) / simulated path (MD-11)** | fan-out of pricing activities under recorded shifts, in an **isolated namespace** against its own door | never a link in the real chain |
| **backtest (VM-11)** | a strategy-unit-workflow in a simulation namespace, driven by a served/stressed trajectory | output an ordinary valuation chain |
| **simulated / virtual ledger, derived world** | isolated namespace + its own lineage's door | only observations re-enter production |
| **branch point / generator version / seed** | recorded inputs; idempotence keys of the simulated path | fix the three, the path replays |

---

## 2. Decomposition

### 2.1 Ledger (restating the seed compactly)
One workflow per unit walks the product graph; pending timers + signal-waits equal the
current node's out-edges (the armed watch list). Side effects are activities only; the door
activity is the sole writer. Idempotence is the door's cause-derived `txid` computed from
recorded inputs. ContinueAsNew at every node transition and every K fixings, carrying only
`{unitId, nodeId, log-cursor}`. Late/back-dated arrivals refold on the single writer; the
workflow is *signalled to re-read*, rehydrates its node + watch set, and re-fires forward —
it never replays its own history against a new fold.

### 2.2 Market data
- **Ingest.** Pushed arrival → ingestion activity (must-not-lose queue) → moveless
  observation-recording transaction at the door, envelope-first, before payload validation.
  A bare read against a live feed is *refused* (unreproducible); no second door exists.
- **Registry.** Data-kind and event-kind registration are ledger facts (transactions), read
  by activities as data. The operator menu and routing are declared terms, never Temporal
  config.
- **Derived objects.** A curve/surface/calibration **runs a model** → a version-pinned
  derivation activity computes it outside the fold; its output re-enters through the door as
  a re-entered observation with complete lineage (input cut, model version, seed). A
  *projection*-type derived object (a discount factor off recorded quotes, an
  operator-adjusted value) is instead a read-only query — it stores nothing.
- **The two MD-16 gates.** For a **constructed** derived state $m^\ast$ (dynamic applied to
  an admissible base): a **gate-evaluation activity** computes Gate 1 (no-arbitrage,
  $m^\ast\in\Theta_{\mathrm{AF}}$) and Gate 2 (realistic/conservative percentiles of the
  underlying's *own as-known* history, joint where marginals would hide an inversion) as
  decidable predicates on a projection **at one pinned base cut**. The workflow proposes the
  derived state **only on pass**; state + gate decision (pass / fail / *undecidable*) cross
  the door in **one transaction over that cut**, so the base cannot move between gating and
  construction. Consumption is by reference: a risk/backtest names a derived state by its
  passing gate-decision, so an ungated state is unnameable.
- **Corporate actions.** The market data operator is a projection at read; the frame-change
  event fires the unit's contract (a normal cascade). A corrected/late CA is a superseding
  event → refold (§2.1), never a Temporal un-adjust.

### 2.3 Valuation
- **Mark.** A model price + greeks re-enter via the door as a re-entered observation
  (pricing activity, version-pinned). NAV/PnL/chain are projections (read-only queries).
- **Chain.** Each re-mark is a new link (a proposal to the door), forward, never an edit.
  Cadence is a workflow timer/schedule; the chain grows on the **ledger**, not in Temporal
  history. The profit-and-loss explain certificate is a projection per link; VM-6's
  residual-below-bound is a recorded diagnostic.
- **Broken chain (VM-7).** A residual over bound, or a staled leaf input, is a recorded
  staleness flag standing as a visible open item — surfaced by the workflow as overdue,
  repaired forward, never a Temporal compensation.
- **CA sandwich (VM-9).** Two pricing activities bracket the frame-change transaction; the
  zero-profit frame re-coordination is the operator's; the near-zero residual is the
  projection's proof. The *late-CA* case is the reordering path: the sandwich is struck
  retroactively at the ex-date by the refold, the spurious market-move line reclassified —
  the workflow re-reads and re-fires forward.
- **Risk (VM-10).** Same recipe on shifted data, in an isolated namespace against its own
  door; a fan-out of pricing activities over composed shifts; every mark re-enters the
  *simulated path's own* record, never the real chain. Greek-vs-reval gap recorded.
- **Backtest (VM-11).** A strategy is already a unit, so a backtest is a strategy-unit-
  workflow in a simulation namespace, driven step-by-step by a served/stressed trajectory
  (branch point + generator version + seed all recorded), emitting an ordinary valuation
  chain by the same contract/pricing activities and the same door. ContinueAsNew every K
  steps. Where coordinates coincide with production its chain *equals* production's by
  determinism — recomputed, never a second stored copy.

---

## 3. Divergences + containments (one per row)

| # | Divergence | Containment |
|---|---|---|
| D1 | Workflow-code nondeterminism (wall clock, randomness, map iteration, direct I/O) | all such logic in activities Temporal records; `workflow.Now` schedules only and never feeds a coordinate; the three times are read from the record |
| D2 | Model **numerical** nondeterminism (floating point, MC seeds, solver convergence) | models run in version-pinned activities **outside both folds**; output re-enters as a re-entered observation, **read back** unconditionally; seed + numerical environment recorded (MD-6, MD-11); re-derivation is governance; Temporal replay and model numerics never meet |
| D3 | Workflow versioning vs model/dynamic/gate versioning | two axes: Temporal Build-IDs for orchestration (ContinueAsNew = cutover); model, dynamic $\mathcal D$, and gate thresholds are recorded recipes/terms (MD-6, MD-16) that alone bear C-2.2 and never touch workflow code |
| D4 | History size: long chains, daily re-marks, N-step backtests, MD-16 derived-state firehose | chains + derived states grow on the **ledger** (designed for it); Temporal bounded by ContinueAsNew every K links/steps/fixings carrying `{unit/path, node, cut}`; derived-state volume isolated to simulation namespaces, never the base stream |
| D5 | Retry vs exactly-once for expensive model activities | the re-entered observation's cause-derived `txid` keys on recorded inputs (cut, model version, seed): a retry recomputes the same id and is absorbed at the door; heartbeat + bounded ScheduleToClose so retry fires only on genuine failure; door idempotence is correctness, Temporal dedup only optimisation |
| D6 | MD-16 gate atomicity vs task-queue ordering (base moving between gating and construction) | pin the base at one log-cursor passed to **both** gate and construction activities; derived state + gate decision cross the door as **one** transaction over that cut; a moved base = stale cut → refused (consistency of reference) or lineage-flagged; atomicity from the shared cut, not from Temporal ordering |
| D7 | MD-16 "prevention, not detection" vs untrusted orchestration | prevention = the construction activity refuses to *emit* a failing state, so no consumer meets one; consumption-by-reference makes an ungated state unnameable; the gate is a decidable predicate on a projection, so any party recomputes it — a mis-gate degrades to a **detectable, forward-repaired** defect, exactly as an economically-wrong contract does |
| D8 | Task-queue arrival order vs the total order | signal/queue order is orchestration sequencing only; committed order is decided at the door alone (execution-time total order); the reordering/refold is the writer's — extends to derivation/pricing queues identically |
| D9 | Timer semantics vs the three times / served-history as-known reads | Temporal timers give liveness; a fired timer's event carries a record-derived execution time, null monitor time, door-assigned door time; a backtest's as-at is pinned to its as-of by the served-history read (MD-4) — a ledger coordinate, never `workflow.Now`; look-ahead structurally impossible |
| D10 | Broken chain / gate fail / door refusal / settlement fail as a Temporal error | each is a returned value / recorded flag standing as a visible overdue/blocked item, never a retryable error, never a saga rollback; repair is forward through the door |
| D11 | Derived-world runs against the production door | isolated namespaces, each against its **own lineage's door** (C-12.5, C-2.8); derived states, gate decisions, and simulated chains live in the simulation namespace's record; no move crosses back — only observations re-enter production, through the production door, with full provenance |

**Task-queue families (extending the seed's five).** door / contracts / ingestion /
unit-orchestration / settlement, plus a **derivation** family (model runs: calibration,
surface fit, pricing, gate evaluation — read-only, version-pinned, heartbeated,
independently scaled, possibly GPU), and, per simulation namespace, its **own** door pool.

**Constitution conflict:** none found. The extension keeps the log as sole truth and demands
nothing of the Constitution — consistent with the seed's DEFERRED-TO-OWNER: none.

---

## 4. Open questions

1. **Load model (biggest unknown).** Derived-state volume per underlying per risk run, and
   pricing cost per backtest step, size the derivation pool, the simulation-namespace door,
   and the ContinueAsNew cadence K. MD-16's *joint* gates are the data-hungriest and the most
   likely to report *undecidable* — their compute/latency is unmeasured.
2. **Undecidable gate verdict.** Confirm the door **records the refusal** of an undecidable
   (thin-history) Gate 2 and the workflow surfaces it as a blocked derived-world item —
   prevention, never a silent pass (MD-16 says so; confirm the substrate mechanics).
3. **Read-back vs re-derivation.** Does the framework pin a numerical-environment version
   beside the model version so a re-entered observation is bit-for-bit *re-derivable*, or is
   read-back the only guarantee (MD-6 leaves this to governance)? A reference-implementation
   decision, but it bounds dispute-readiness (MD-14/VM-8) for model numbers.
4. **Risk fan-out: child-workflows vs activities.** Independent failure domains, separate
   history, and independent queryability argue for a child-workflow per shift/underlying; a
   pure revaluation with no waits could be a bare activity fan-out. Decision pends per-scenario
   pricing cost — same unknown as (1).
5. **Derivation queue: one family or split?** Contract-eval (short, CPU), model-eval (long,
   heartbeated, GPU), and gate-eval (projection-heavy) have different scaling profiles;
   whether to split them is a load-model call.
