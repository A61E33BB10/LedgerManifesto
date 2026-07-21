# Temporal as Execution Substrate for the WHOLE Framework — TEMPORAL-4, Round 1

Stance: `temporalv16.tex` mapped the ledger's two untrusted machines onto Temporal and
kept the immutable log as sole book of record. I extend that unchanged frame to market
data and valuation. The frame does not bend: market data and valuation add **no new
writer, no new door, no new book**. Every model number and every gate verdict re-enters
through the *one* observation door (§sec:obs-door) as a recorded observation or a recorded
event-outcome; every curve, surface, NAV, chain, and certificate is a **projection** read
over the record. Temporal gains two things only — model-run activities and derived-world
namespaces — and owns neither truth. Acceptance test is unchanged and now three-way: wipe
the cluster, and units re-arm, marks read back, and gate verdicts stand, all from the log.

The one structural fact the seed predates and I build on: the v16.1 spec now has the
**refold with past-dated synthesised firings** (§sec:totalorder) and the **orchestration
substrate** section (§sec:substrate). Past-dated synthesis is the *single writer's* work;
the substrate only re-fires **forward**. That boundary is what makes Temporal's
forward-only timers safe, and it governs the late corporate-action sandwich too.

## 1. Mapping table

| Framework object | Temporal construct | Note / register tie |
|---|---|---|
| The immutable log (book of record) | *nothing in Temporal*; external hash-chained store | Temporal history is a disposable cache; never the log (R-02, C-2.2) |
| The Transaction Executor (the door, single writer) | NOT a workflow; external single-writer service fronted by ONE idempotent `admit/refuse` activity | the only write path (R-01, M6) |
| The Events Executor | capture activities + workflow sequencing | side effects in activities only (R-05) |
| The Event Monitor | per-unit workflow's durable timers + signal-waits | emits, never writes (R-08, R-10) |
| A smart contract | version-pinned, queue-routed activity (never workflow, never local) | economics off Temporal's replay surface (R-06, R-26) |
| A unit (walking its product graph) | one long-lived workflow per `unitId` | node/watch-set mirror the ledger, rehydrated (R-03, R-04) |
| A watch (declared→armed→fired/expired) | date → durable timer; condition → signal-driven eval over recorded observations | lifecycle authoritative on the log; timer is the liveness half (R-08, R-10) |
| A transaction / a move | proposed by an activity, admitted by the door activity | txid = cause-derived from recorded inputs (R-07) |
| A projection (balances, NAV, chain, encumbrance) | read-only activity / Query over the record | stores nothing (R-19 for ops search attrs) |
| The total order and the refold | the single writer's work; NOT Temporal | substrate re-fires FORWARD only (§sec:substrate) |
| ContinueAsNew | carries `{unitId, nodeId, log-cursor}` only | = cold rebuild-from-ledger (R-15) |
| A signal | timing/reference only (cause id, log position) | never payload; record-derived backstop (R-11) |
| A query | non-authoritative liveness view | reconciled to the ledger (R-13) |
| Child workflow | **not** used for ledger-created units | they start own workflows by signal-with-start; branches stay in-workflow (R-14) |
| An **observation** (market data) | ingestion activity proposes a moveless observation-recording transaction through the one door | no per-observation workflow (§sec:obs-door, MD-1) |
| The **market data operator** (CA frame transform) | projection computed at read; declared data on the log | never a workflow, never improvised (C-9.2, MD-13) |
| A **derived object** — projection kind (curve/surface off record) | read+compute activity, recomputes on read | stores nothing (MD-6) |
| A **derived object** — re-entered-observation kind (model fit) | model-run activity (version-pinned) + door re-entry | staleness is a recorded flag (MD-6, MD-8) |
| A **valuation mark** (chain link) | model-run activity + door re-entry as re-entered observation | the chain that assembles them is a projection (VM-1, VM-3) |
| A **profit-and-loss explain certificate** | projection over two marks (read+compute) | residual bound is a declared term on the log (VM-4, VM-6) |
| A **corporate-action valuation sandwich** | two model-runs (before/after) + operator projection + certificate, fired in the unit's workflow on the CA event | late CA = refold + forward re-read (VM-9) |
| An **MD-16 derived state** `m*` (dynamic applied) | construct activity + two-gate predicate activity; verdict recorded as event-outcome through the derived lineage's door | prevention, not detection (MD-16) |
| A backtest / risk report / derived world | isolated namespace; strategy-unit workflow(s) over a trajectory | marks re-enter the derived path's own record (R-20, VM-10/11) |
| Temporal Schedules | system cadence only (EoD sweeps, overdue-watch and stale-fit reconciliation) | never per-unit contractual dates (R-09) |

## 2. Decomposition

### 2.1 Ledger (restated from the seed, unchanged)
- **Workflow:** one per unit; holds timers (date watches) and signal-waits (condition
  watches) equal to the current node's out-edge set; orchestration only.
- **Activities:** capture-arrival (ingestion queue), evaluate-contract (contracts queue,
  version-pinned), propose-to-door / `admit` (door queue, sole write credential).
- **Fan-out:** a corporate-action cascade routes one cause to many units — one firing per
  referencing unit, separated by cause-derived identifier — by signal-with-start (R-14,
  §sec:registry `COUNTERPARTY-DEFAULT`). Not child workflows.
- **Ledger-created units:** settlement-obligation unit starts its own workflow; the
  market-claim leg is a *branch* of that unit's graph → same workflow; partial-split legs
  are *new* units → own workflows (R-14, §4116). Do not conflate split with ContinueAsNew.

### 2.2 Market data
- **No per-observation workflow.** A pushed arrival is captured by an ingestion activity
  whose *only* success is proposing a moveless observation-recording transaction through
  the one door; a fetch that records nothing is a no-op (the forbidden bare read,
  §sec:obs-door). Feed capture runs on the ingestion queue (must-not-lose).
- **Registry & operator are declared data**, not code: kind registration and the per-(data
  kind, event kind) operator are log-facts read by projections (§sec:registry, §sec:operator).
- **Projection-kind derived objects** (discount curve, adjusted price via the operator):
  read+compute activities, recomputed on read, stored nowhere.
- **Re-entered-observation-kind derived objects** (a fitted surface, a correlation block):
  model-run activity (models queue, version-pinned, seed recorded) → output re-enters
  through the door as an observation with complete lineage (MD-6). Staleness on input
  correction is a *recorded flag* (MD-8, MD-10); re-derivation is a forward action triggered
  by the correction signal or a Schedule-driven stale-fit sweep — never held in workflow state.
- **The two MD-16 gates** apply when a *dynamic* constructs a derived state `m*`:
  1. one `apply-dynamic` activity constructs `m*` from an admissible base pinned at a single
     cut (models queue);
  2. one `gate` activity evaluates **Gate 1** (no-arbitrage, `m* ∈ Θ_AF` — a decidable
     predicate on a projection: *prevention*) and **Gate 2** (realism: per-functional,
     per-underlying percentiles against that underlying's own as-known history, joint where
     marginals would hide it);
  3. the verdict — pass / fail / **undecidable** (thin history) — is recorded as the
     event-outcome of the dynamic-application event through the **derived lineage's** door.
     Fail/undecidable ⇒ `m*` is not admitted; a consumer names a derived state by its
     admission record, so an ungated state cannot be named (MD-16). Derived states live in
     the derived stream and never touch base-history serving.

### 2.3 Valuation
- **A mark is a re-entered observation.** Producing a chain link = (1) read coordinates
  from the record, (2) run the pricing model (models queue, version-pinned) — the ledger
  runs no model (C-14.9), (3) re-enter the mark + its greeks through the one door. The
  **valuation chain** and **NAV** are projections that consume marks as leaves (VM-1, VM-3).
- **The PnL-explain certificate** is a projection over two marks; the residual is the
  balancing term and the declared bound (VM-6) is a log term. A breach is a recorded broken
  chain (VM-7) — a visible open item, not a workflow error.
- **The CA valuation sandwich** fires inside the affected unit's workflow when the CA event
  fans in: value-before (model activity, old frame) + operator (projection) + value-after
  (model activity, new frame) + certificate. Frame re-coordination is a zero-profit identity;
  residual ≈ 0 is the proof. A **late** resolved CA is a *reordering*, handled by the single
  writer's refold: the sandwich is re-struck retroactively at the ex-date (writer's work),
  and the unit workflow is signalled-to-re-read and re-fires forward (VM-9, §sec:substrate).
- **Re-marking cadence is a watch** the unit declares (date → durable timer; input-moved →
  condition/signal). Many chains per unit sit as extra watches; heavy pricing stays on the
  models queue, off the workflow's replay surface.
- **Backtests / risk / derived worlds** run in isolated namespaces (R-20): a strategy unit
  is a workflow, its per-step marks re-enter the *derived path's own record*, never the real
  unit's chain (VM-10/11). Where coordinates coincide with production the chain *equals* it
  by determinism, reached by recomputation, never a second stored copy.

## 3. Divergences and containments (one per row)

| # | Divergence | Containment |
|---|---|---|
| D1 | **Bare-read prohibition vs activity I/O.** An activity that pulls a live feed and records nothing is the forbidden bare read (§sec:obs-door). | Every ingestion activity's only success path is proposing an observation-recording transaction; read activities read the record, never a live feed. A non-recording fetch is a retryable no-op, never a value consumed downstream. |
| D2 | **Model non-determinism vs replay.** Pricing/calibration is float- and solver- and seed-dependent; in workflow code it is an instant non-determinism error. | Model runs are version-pinned activities (never workflow, never local), output RECORDED as a re-entered observation with seed + model version in lineage (MD-6). Replay reads the recorded result. Bit-for-bit reproducibility is a *ledger* property (re-entered observation + lineage), not a Temporal-replay property. Same containment as contracts (R-06/R-26), extended to models. |
| D3 | **Refold's past-dated synthesised firings vs forward-only timers.** Temporal timers fire forward in wall-clock; the refold synthesises firings at *past* execution positions (§sec:totalorder step c). | Past-dated synthesis is the SINGLE WRITER's work, not the substrate's. On refold the unit workflow is signalled-to-re-read, rehydrates from the refolded projection, and re-fires FORWARD only under fresh cause-derived ids; it never rewinds its own history (§sec:substrate). The late-CA sandwich (D of VM-9) rides this exact path. |
| D4 | **Staleness propagation vs workflow state.** A corrected leaf flags stale every downstream re-entered observation (MD-8, VM-7). Holding "what is stale" in workflow memory smuggles ledger state into the substrate. | Staleness is a recorded fact — lineage shows the input moved; the projection "current fit for X" selects the latest non-superseded and carries the flag. Orchestration only *triggers* forward re-derivation, reading staleness from the record. |
| D5 | **History size — long chains / high-cadence marks / backtest fan-out.** A daily-marked unit over years, or a per-step backtest, generates thousands of firings. | The marks live on the LEDGER log, not Temporal history — Temporal holds only the cadence-timer orchestration. ContinueAsNew at node transitions and every K firings, carrying the identifier triple only (R-15). Backtest marks live in the derived namespace's record. |
| D6 | **MD-16 "undecidable" / door refusal vs retry-to-infinity.** Gate 2 can return *undecidable* (thin history); the door can *refuse*. Treated as a transient activity failure, an orchestration would retry forever. | Undecidable/fail/refuse is a RETURNED VALUE (recorded event-outcome), not a retryable error — it breaks the retry loop and stands as a visible blocked/overdue item (R-22). Prevention: an ungated `m*` is never produced, so no consumer meets one. |
| D7 | **Derived-world volume vs the production door/namespace.** Risk and backtests emit one model-run per step — potentially millions of re-entered observations. | Derived worlds run in isolated namespaces against their own lineage's door (R-20); derived states live in the derived stream and never enter base history (MD-16). Production door sizing (single writer) is unaffected. |
| D8 | **Nondeterminism sources in workflow code** — wall clock, randomness, unordered-map iteration, direct I/O, local activities for model/contract eval. | All confined to activities whose results Temporal records; `workflow.Now` only, never fed to a contract or model; the three times come from the log, never from a workflow clock (seed operational constraints). |
| D9 | **Workflow-code versioning vs economics versioning.** Two independent axes must not be conflated. | Orchestration changes ride Worker/Build-ID versioning, draining to the next ContinueAsNew boundary (R-17). Economics — ProductTerms, model versions, MD kind registrations, operator declarations — are new versions on the LOG and alone bear C-2.2; they never touch workflow code. |
| D10 | **Retry semantics vs exactly-once meaning.** Activities are at-least-once. | Exactly-once is won at the door by the cause-derived txid from recorded inputs (R-07); Temporal dedup is tolerated as optimisation, never load-bearing. Extends unchanged to the observation door and to gate-decision event-outcomes. |
| D11 | **Task-queue / signal / observation arrival order vs the fold.** Arrival order at a queue is not the meaning order. | Arrival order is orchestration sequencing only; the committed order is the total order (execution, door, hash) decided at the door alone (R-25, §sec:totalorder). A late observation refolds; a same-instant non-commuting pair is ordered by declared precedence or refused, never by an arrival-order tiebreak. |
| D12 | **Timer semantics vs the three times.** Durable timers look like a clock. | Timers carry NO time authority; execution/monitor/door all live on the log, and the substrate reads them back as data — its own clock orders nothing (§sec:substrate). A late-firing timer produces the identical transaction (C-3.7). |
| D13 | **Attribution/dispersion convention as worker config.** VM-5 attribution and VM-11 Σ depend on declared terms; a worker-side default would make two workers disagree. | The convention (invariant held, partition π, dispersion D, normalisation ν) is a declared, recorded term read by the projection — never a worker default. Same discipline as idempotence keys never coming from Temporal. |

**Task-queue families** (seed's five, extended): door (sole write credential; now also admits
observation-recording transactions and gate-decision event-outcomes), contracts (read-only,
version-pinned, cheap), **models** (NEW — pricing/calibration/gate evaluation; version-pinned,
compute-heavy, bursty under risk runs; split from contracts because their scaling profiles
differ), ingestion (must-not-lose), unit-orchestration (idle-many), settlement (egress-only).
Derived-world namespaces mirror these families against their own door.

## 4. Open questions
1. **Models queue vs contracts queue.** I split model-runs into their own queue family on a
   scaling argument (bursty, expensive) not yet load-modelled. If per-unit valuation volume
   is low this may over-engineer; sizing awaits the same load model the seed flagged (K,
   door-pool sizing, event volume per unit per day).
2. **Re-mark cadence ownership.** I place valuation-chain re-mark watches on the *unit's*
   workflow. A unit carrying many chains at many cadences (VM-3) could bloat its timer set;
   a separate per-(unit, chain) valuation-orchestration workflow is the alternative. Both
   keep marks on the log; the choice is a history-growth tradeoff, not a correctness one.
3. **Gate-2 joint-history sufficiency at scale.** "Undecidable" is a returned value (D6), but
   an operational question remains: should a Schedule-driven sweep pre-compute joint-history
   sufficiency per underlying so risk runs fail fast, rather than discovering undecidability
   mid-run? Architecture-neutral; flagged for the ops projection.
4. **No new Constitution park.** As with the seed, the extension demands nothing of the
   Constitution — the ledger stays sole truth, model numbers and gate verdicts re-enter
   through the one door. If a member finds MD-16's *prevention* gate in tension with the
   door's *admit-or-refuse-only* posture, that is the one place to look; I find no conflict
   (the gate is a contract-side predicate, the door still admits or refuses the outcome).
