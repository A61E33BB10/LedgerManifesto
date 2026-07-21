# Proposal TEMPORAL-3 (Round 1) — Temporal across the whole framework

**Stance.** The seed (`temporalv16.tex`) settles the ledger core: Temporal runs the two
untrusted machines, the door is an external single-writer fronted by one idempotent
activity, history is a disposable cache. I extend that *unchanged* to market data and
valuation by one move applied a second and third time: **every model output — a
calibration, a mark, a greek, an MD-16 gate decision — is a non-deterministic activity
result that RE-ENTERS through the one door as a re-entered observation under a
cause-derived identifier computed from recorded inputs.** Temporal's execution plane and
the ledger's meaning plane never touch. The keystone the seed under-states is the spec's
own substrate section (§sec:substrate): **the refold is the single writer's work;
Temporal only re-fires FORWARD and is signalled to re-read — it never rewinds its own
history against a new fold, never compensates substrate-side.**

---

## 1. Mapping table

| Framework object | Temporal object | Binding constraint |
|---|---|---|
| The immutable log (book of record) | *nothing* | history is disposable; wipe-and-rebuild is the acceptance test (C-2.2) |
| The Transaction Executor (door, single writer) | ONE idempotent propose-to-door activity | the only write path; external single-writer service (M6) |
| The Event Monitor (time/attention, watches) | per-unit workflow: durable timers + signal-waits | armed-watch set = current node's out-edges; emits, never writes |
| The Events Executor (capture + fire + collect) | ingestion activities + workflow orchestration | capture precedes routing; proposals only |
| smart contract (pure economics) | version-pinned, queue-routed activity | never a local activity; never workflow code |
| transaction / move | proposal returned by a contract activity | becomes fact only at the door |
| projection (NAV, PnL, settlement, three homes) | projection-read activity, writes nothing | also the rehydration source |
| watch: declared→armed→fired/expired | date = durable timer; condition = signal-driven eval | lifecycle authoritative on the log; timer is liveness only |
| unit (ledger position) | one long-lived workflow keyed `unitId` | ledger-created units start their own via signal-with-start |
| continue-as-new | node transitions + every K fixings | carries `{unitId,nodeId,log-cursor}` only; = cold rehydrate |
| signal | timing + reference (cause id, log position) | never economic payload; record-derived backstop |
| query / search attributes | non-authoritative liveness/ops view | reconciled to the ledger, never authoritative |
| child workflow | *not* used for lineage coupling | parental linkage is ledger-absent relational state |
| **observation** (market-data atom) | ingestion activity → door | moveless observation-recording transaction; same door, no second door |
| **re-entered observation** (model output) | model-run activity → door | idempotence on cause-derived id over (cut, recipe-version, seed) |
| **the market data operator** (CA frame map) | projection-read activity, computed at read | original never overwritten; derived recomputed from adjusted inputs |
| **MD-16 dynamic / derived state** | derived-world construction workflow, isolated namespace | lives in the derived stream; never enters the base stream |
| **MD-16 two gates** (no-arb, realism) | version-pinned gate activities over ONE pinned cut | decision re-enters via door as recorded event-outcome |
| **valuation chain** | append-only re-entered observations ON THE LOG | never Temporal history; head read back from the record |
| **profit-and-loss explain certificate** | projection-read activity (decomposes ΔNAV) | reconciles by construction; residual-breach = recorded broken state |
| **corporate-action valuation sandwich** | bounded sub-graph at the unit's CA node | pre-price / operator / post-price / certificate; stays in the unit workflow |
| **shift** (scenario perturbation) | recorded through the simulation lineage's door | the single non-record input; makes the path replay |
| **simulated path / backtest** | workflow in isolated sim namespace, `lineageId:unitId` | same recipe, same door, own lineage; never the production door |
| the three times (execution/monitor/door) | live on the log | Temporal timers are NONE of them (liveness half only) |
| total order / refold | the single writer's work | Temporal re-fires FORWARD only; never rewinds |

---

## 2. Decomposition

### 2a. Ledger (restates the seed, unchanged)
- **Workflow code:** timers, signal-waits, selectors, ContinueAsNew, sequencing — nothing else.
- **Activities:** capture-arrival, fetch-projection, evaluate-contract (version-pinned,
  queued), propose-to-door (sole writer), emit-settlement-instruction (egress).
- **One workflow per unit**, keyed `unitId`; ledger-created units (settlement-obligation,
  market-claim, split legs) start independent workflows by signal-with-start.
- **Settlement** = pure projection (`settle :: Ledger -> [Instruction]`, writes nothing);
  failure re-enters as a recorded external event walking the settlement-obligation unit's
  graph — never a Temporal compensation/saga.

### 2b. Market data (NEW)
- **Observation ingestion** rides the seed's ingestion queue family: capture-envelope
  activity (source + three times) → propose the moveless observation-recording
  transaction through the **same** door. No second door (MD-1). Absorption of a redelivery
  is the door's cause-derived-identifier check, not Temporal dedup.
- **Projections over the record** (discount factor, operator-adjusted value) = projection-
  read activities; store nothing, rebuild from the log (MD-6, MD-13).
- **Model runs** (a fitted surface, a calibration, a filter) run OUTSIDE the fold
  (C-14.9): a model-run activity computes the number, then proposes it to the door as a
  re-entered observation carrying its recipe-version, resolved input cut, and seed.
- **The two MD-16 gates on a derived state $m^\ast$:** the construction workflow pins ONE
  base-state cut (a workflow-deterministic log cursor read once) and dispatches, all
  reading that same pinned cut: (i) construct-$m^\ast$ activity (apply the dynamic);
  (ii) Gate-1 activity (no-arbitrage set membership — decidable predicate on a projection,
  version-pinned like a contract); (iii) Gate-2 activity (functionals vs the underlying's
  own as-known historical distribution, MD-4 served history; declared-term percentile
  bands). The **gate decision** (pass/fail/undecidable + functionals + percentiles +
  history basis) re-enters through the door as an event-outcome with declared-term
  lineage. A failed/undecidable state is **never proposed** — it does not exist
  (prevention); only the decision crosses the door. Construction lives in an isolated
  namespace against its own lineage's door (never the production door).

### 2c. Valuation (NEW)
- **Two layers, never confused (VM-1).** Each model-priced leg (mark + greeks) is a
  **re-entered observation** — a pricing activity runs the model outside the fold, output
  re-enters via the door. NAV / PnL / the valuation chain are a **projection** — a
  projection-read activity that folds the log, consuming legs as leaves, storing nothing.
- **Valuation cadence** is system cadence, so it rides a **Schedule** (seed R-09), not
  per-unit contractual timers: an end-of-day sweep fans out pricing activities over open
  units × their declared chains. The chain head (previous mark) is read from the record,
  so no chain state lives in Temporal.
- **Valuation chain (VM-3)** is append-only re-entered observations ON THE LOG. A re-mark
  is a new link forward, never an edit; multiple chains per unit (per convention/cadence/
  desk) are independent fan-out targets.
- **PnL-explain certificate (VM-4)** = projection-read activity decomposing ΔNAV with
  measured entry/exit greeks; reconciles to ΔNAV by construction. **Residual below its
  declared bound** is the earned certification; a breach (VM-6/VM-7) re-enters as a named
  explain line + a flagged **broken state** — visible, never absorbed.
- **CA valuation sandwich (VM-9)** fires at the affected unit's CA node (reached by the CA
  cascade signal, seed R-14): a bounded, deterministic sub-graph — price-before activity,
  the market data operator (projection, zero-profit frame re-coordination), price-after
  activity, sandwich-certificate activity (residual ≈ 0 proves consistency). Stays inside
  the unit's own workflow (a graph branch), not a child workflow.
- **Risk = valuation in simulated worlds (VM-10); backtest = a strategy unit through a
  trajectory (VM-11).** Both run in an isolated sim namespace, keyed `lineageId:unitId`,
  against that lineage's own door, using the SAME pricing/contract activities as
  production — so risk and books cannot disagree by construction. The strategy is itself a
  unit → its own unit-workflow, rebalancing on stamped observations. A backtest fans out
  one production valuation per step; every derived state it roots in is named by its MD-16
  admission record (detection at the root, prevention at every derived step).

---

## 3. Divergences and containments (one per bullet)

- **Nondeterminism of model runs (float, optimiser, iteration).** *Containment:* model
  runs live only in activities; Temporal replay reads the recorded activity result from
  history and never re-runs the model, while the ledger reads back the re-entered
  observation. Reproducibility rides the recorded seed + recipe-version (MD-6/MD-11):
  read-back is unconditional, re-derivation needs the retained model — a governance
  matter, not Temporal's. Workflow-code rules unchanged (no wall clock, no unordered-map
  iteration, no direct I/O).
- **Retry vs exactly-once, extended to model outputs.** *Containment:* every re-entered
  observation (valuation record, calibration, MD-16 derived state, gate decision) carries
  a cause-derived identifier over RECORDED INPUTS (coordinates, cut, recipe-version, seed),
  never a Temporal run/attempt id. An at-least-once pricing/model activity that retries
  re-presents the same identifier → the door absorbs it once (MD-1). A retry that computes
  a *different* number is still absorbed: the first admitted output is canonical, a re-mark
  is forward-only (MD-8) — so the seed must be recorded to keep the number reproducible.
  (Generalises my memory's Flag B: per-derived-object egress inherits door idempotence,
  riding inputs, never a Temporal id.)
- **Workflow-code versioning vs recipe/model versioning — now THREE axes.** *Containment:*
  keep them physically apart. (i) Temporal orchestration = Build-IDs/GetVersion, cut over
  at ContinueAsNew boundaries; (ii) contract economics = ProductTerms versions on the log;
  (iii) **NEW** model/recipe/dynamic/declared-term versions = lineage pinned per derived
  object on the log (MD-6, MD-16 "declared, versioned, attestable"). A model or gate-term
  upgrade is a new version + new re-entered observations forward — it never touches
  workflow code. The gate decision pins declared-term versions as as-known facts (MD-16).
- **History size — valuation chains and backtest fan-out.** *Containment:* the chain lives
  on the ledger, not Temporal, so Temporal history stays bounded provided (a) valuation
  cadence is a stateless Schedule-driven sweep holding no chain state, and (b) any
  long-lived valuation or backtest orchestration ContinueAsNews per step-batch, carrying
  only `{strategyUnitId, trajectoryCursor, lineageId}`; per-step marks re-enter the sim
  lineage's own record and rehydrate from it (same wipe-and-rebuild discipline).
- **Task-queue ordering vs the pinned-cut gate evaluation.** *Containment:* the two MD-16
  gates and the construction are ONE evaluation over ONE pinned cut (MD-12). The cut is a
  workflow-deterministic log cursor read once and passed to every gate/construction
  activity, so their arrival/delivery order cannot move the decision — it is a pure
  function of the pinned cut. Committed order is the door's alone (seed R-24).
- **Timer semantics vs the three times.** *Containment:* a Temporal durable timer is NONE
  of execution/monitor/door time (§sec:substrate) — it is the Monitor's liveness half. A
  re-mark cadence timer says only "time to re-mark"; the pricing activity reads the
  valuation coordinates (as-of/as-at cuts, frame) from the record. A late re-mark yields
  the identical valuation for the same coordinates, exactly as a late firing yields the
  identical transaction. A backtest pins as-at to historical as-of (MD-4) as a record
  coordinate, never from a Temporal clock; emitted re-marks bear null monitor time.
- **The refold, and Temporal's forbidden temptation (the keystone).** A late arrival —
  a back-dated observation, a resolved CA reaching the door after valuations chained
  across its ex-date (VM-9 third case) — triggers a refold. *Containment:* detection, the
  refold, and the retroactive/past-dated firings (including the retroactively-struck
  sandwich at the ex-date) are the SINGLE WRITER's work. Temporal is **signalled to
  re-read**: the affected unit-workflow discards its in-memory mirror, rehydrates node +
  armed-watch set from the refolded projection ("any doubt"), and re-fires FORWARD under
  fresh cause-derived identifiers. It never replays its own history against the new fold
  and never compensates substrate-side — both smuggle ledger state into the substrate. A
  timer already fired stays fired; the C-12.6 flags reconcile it; settled quantity moves
  back only under authorised compensation (C-12.4).
- **MD-16 "prevention" vs the door's "capture-then-classify".** A constructed derived
  state is gated *before* it re-enters (prevention), yet a captured observation is always
  admitted then classified (MD-2/MD-9). *Containment:* the gate runs inside the
  construction activity (untrusted economics, like a contract) and only the gate DECISION
  crosses the door — never the rejected state. The door still records only facts; no new
  admission privilege is created. Not a Constitution conflict — MD-16 itself reconciles it.

---

## 4. Open questions

1. **K and cadence sizing.** The seed's biggest unknown (event volume per unit/day) now
   compounds: derived-state and per-step valuation volume sizes the sim-namespace history
   and the pricing-queue pool. Needs a load model before K, sweep cadence, and pool sizes
   are more than estimates. **Confidence MEDIUM** on these constants, HIGH on the mapping.
2. **Pricing/model queue family.** Should model runs share the contracts queue (both
   version-pinned, read-only, queued) or get their own pool? They differ in cost profile
   (pricing/calibration can be heavy) and may need independent scaling and heartbeating —
   likely a sixth queue family beside the seed's five. To be settled against the load model.
3. **Backtest fan-out shape.** Fan-out over a trajectory of cuts vs a per-step child chain:
   which keeps history bounded and failure domains clean without a cascade multiplier? The
   MD-16 gate pre-pass (construct admitted derived states, then name them by admission
   record) must complete before the backtest names them — a fan-in barrier whose overlap
   policy (skip/buffer) needs a decision.
4. **Gate-2 "undecidable" liveness.** A thin as-known history makes Gate-2 report
   undecidable → the derived state is refused (prevention). At scale this is a visible
   blocked/overdue item like a door refusal (seed R-22): confirm it degrades to a flagged
   open item, never a retry-to-infinity or a crash.

**Parked constitutional conflicts: none.** The extension demands nothing of the
Constitution or the two subordinate manifestos; every re-entered observation keeps the log
as sole truth and every gate decision is a recorded fact, not a substrate-held state.
