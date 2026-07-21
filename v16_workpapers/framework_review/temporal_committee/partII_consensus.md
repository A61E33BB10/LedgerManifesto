# Temporal as Execution Substrate for the WHOLE Ledger Framework
## Part II Consensus Artifact — Temporal Committee (unanimous, round 11)

Assembled from `proposal_TEMPORAL-1_r11.md` (mapping base) with `proposal_TEMPORAL-4_r11.md`
(catalogue) folded in. Signed by TEMPORAL-1..5 and both referees (FORMALIS, TuringAward). This is a
substrate proposal, not a Constitutional amendment: the immutable log remains the sole book of record;
Temporal workflow histories are never the source of truth.

---

## 1. Thesis and mapping

**Central result.** Market data and valuation are **not** a second substrate. The seed
(`temporalv16.tex`) mapped the ledger's two untrusted machines — the Event Monitor and the Events
Executor — onto Temporal, keeping the Transaction Executor outside as the single writer. The framework
extension adds no new writer, no new door, no new book: **the whole framework is the one machine folding
observations and re-entered observations through the one door.** Every market-data fact, every model
number, every gate verdict, and every valuation mark crosses the same door under the same cause-derived
identity; everything else is a projection recomputed from the log.

| Temporal primitive | Ledger / market-data / valuation object |
|---|---|
| **Workflow** (long-lived, keyed `unitId`) | one **unit** walking its product graph; pending timers + signal-waits = the current node's armed **watch** set (R-03). Derived-object builds, MD-16 dynamic applications, and valuation-chain links are sequences it runs — no new workflow kind. |
| **Activity** | every side effect: capture an arrival, read a **cut**, run a model (version-pinned), propose to the door, apply the **market data operator**, compute a certificate, evaluate an MD-16 gate. NAV/PnL/operator/settlement are read-time **projection** activities. A read that records nothing is the forbidden **bare read**. |
| **Signal / signal-with-start** | timing and reference only (a cause identifier, a log position), never economic payload; a **watch** satisfaction, a corporate-action cascade fan-out, or a "re-read: the fold moved" notice. Ledger-created units (the settlement-obligation unit, a market-claim leg, split successor legs) start their own workflows; graph branches stay in-workflow. |
| **Query** | a non-authoritative liveness view; a valuation or collateral **dispute** is a *replay* — a read-only re-derivation from the log, never a second authority. |
| **Child workflow** | **not** used for lineage coupling (parental linkage is ledger-absent relational state); a corporate-action cascade fans out by signal-with-start. Child workflows appear only *inside a simulation namespace* for history-bounding — not the forbidden use. |
| **Continue-as-new** | history-size control; carries `{unitId\|lineageId, nodeId, cut}` only. The **valuation chain**, the derived states, and the gate verdicts live on the log and rehydrate from it. |
| **Durable timer / Schedule** | timer = a date-**watch** liveness half only, authoring none of the three times; Schedule = system cadence only (end-of-day sweeps, overdue-watch reconciliation), never a per-unit contractual date. |
| **The Transaction Executor + the immutable log** | the trusted single writer, fronted by **one** idempotent door activity — the only write path. Never a workflow. |
| **The two MD-16 gates**, **the CA sandwich**, **the backtest** | the gates = version-pinned predicate activities whose verdict + state cross the door in one transaction; the sandwich = a sequence of idempotent legs struck as a projection from the log; a backtest = a strategy **unit** run through a trajectory in an isolated namespace against its own lineage's door. |

**Acceptance test.** Wipe the Temporal cluster: the entire workflow population re-derives from the log —
unit status re-read, watches re-armed, chains and derived states and gate verdicts rebuilt, nothing lost.

---

## 2. The three record kinds and the one lineage discipline

Every object the framework records is exactly one of three kinds, distinguished by **staleness
semantics**:

1. **Projection** — computes over the record and stores nothing; recomputed on every read; *never
   stale*. Balances, the three homes, NAV, profit-and-loss, the valuation chain as assembled, the market
   data operator, settlement instructions.
2. **Re-entered observation** — a model output evaluated *outside* the fold (the ledger runs no model)
   whose result re-enters through the one door as a recorded observation; read-back is unconditional;
   *stale when a consumed input moves* (MD-8), superseded forward. A fitted surface, a mark, a greek, a
   calibration.
3. **Recorded decision, pinned as-known** — a verdict recorded with the event it decides; *not
   recompute-on-read, not stale-on-input-move* — it decided against inputs as they then stood. This is
   **not a new primitive**: the base ledger already has it as the door's admit/refuse; the MD-16 gate
   verdict is the same shape.

**The lineage discipline.** Every re-entry carries a cause-derived transaction identifier over the
**canonical 3-tuple key** `(input-cut, model-version, recipe/dynamic-version)`. The `input-cut` is
recorded at **exact grain** (a log-position or content-hash, never a coarse "latest" label). A stochastic
recipe's drawn **seed** is a recorded parameter *of the recipe/dynamic-version term* — so the key stays a
3-tuple; a separate seed slot would mint two identifiers for two retries and double-admit, the same
failure that keeping the numerical environment in the key would cause. **Seed and numerical-environment
are out of identity** — both are recorded Tier-2 re-derivation terms, never txid coordinates. The refold
that honours a late arrival is **forward-only** and is the single writer's work; Temporal is signalled to
re-read and re-fires forward, never rewinding its own history against a new fold.

---

## 3. Decomposition per framework area

### 3.1 Ledger
The unit-workflow holds timers, signal-waits, selectors, and sequencing, and nothing else; its in-memory
node is a mirror, rehydrated from the ledger on start, on continue-as-new, and on any doubt. Side effects
are activities: capture-arrival → evaluate-contract (version-pinned, queue-routed, never a local
activity) → propose-to-door. The **Transaction Executor** is an external single-writer service fronted by
one idempotent `admit` activity whose write is an **atomic unique-key insert on the cause-derived
identifier** — not check-then-append. Exactly-once admission is therefore a **total function of the
durable log**: dedup is decided against the committed identifier-set on the log, never an in-memory
in-flight set or arrival order. A corporate-action cascade fans out by signal-with-start; each firing
proposes its own identifier, so all *n* legs commit. Settlement is a pure projection that writes nothing;
settlement failure re-enters as a recorded event walking the settlement-obligation unit's graph — never a
Temporal compensation or saga.

### 3.2 Market data
Capture records the observation through the **one door** (envelope-first, before payload validation);
absorption of a redelivery is the door's cause-derived-identifier job at the registered grain. A
**projection-kind** derived object (a discount factor, an operator-adjusted value) is a read-time
activity that stores nothing. A **re-entered-observation-kind** derived object (a fitted surface, a
filter) runs the model in a version-pinned activity whose seed is recorded to the log before compute and
reused on resume, then re-enters through the door.

**The two MD-16 gates and the single-transaction write.** Applying a declared *dynamic* to an admissible
base state yields a derived state, admitted only through two gates decided at application time: **Gate 1**,
no-arbitrage by construction (`m* ∈ Θ_AF`); **Gate 2**, realism against the underlying's own as-known
history (per-functional percentiles, joint where marginals would hide an inversion). The workflow pins
**one cut** and runs `gate1`, `gate2`, and `construct` all over that cut (MD-12), then **the derived
state and its passing gate verdict cross the door as one transaction** — never a pass recorded first with
construction gated on it, which would open an inconsistent-read window. Fail or undecidable is a recorded
**refusal**; the state is never constructed, and a consumer names a state only by its admission record,
so an ungated state is unnameable.

**Prevention-at-construction = detection-at-audit.** Gate 1 is a decidable predicate, but one requiring
model knowledge (the arbitrage-free set) that the door must not hold — the door is generic machinery,
carrying no product knowledge. So the gate runs in a version-pinned activity, like a contract; the door
commits verdict-and-state atomically; and a mis-gate degrades to detection-at-audit by recomputation,
exactly as an economically-wrong contract does. Under the single-trusted-door model, that is the honest
status of "prevention" here.

**A′ = FLAG.** A correction to a consumed input that lands under the pinned cut before admission does
**not** refuse: it **flags m\* stale-forward** (MD-8/MD-10), m\* remaining the as-known-at-cut value it
was gated as — the single writer decides staleness on the refold. The state is kind-2 (staleable), the
decision kind-3 (pinned, never stale); refusing would conflate them, and C-11.3 is a structural
consistency guard, not a tip-freshness check. **Refuse is reserved for a gate fail/undecidable verdict
(the gate decides) or an unresolvable structural reference (the door decides) — never a fresher tip.** A
90-second calibration under corrections every 45 seconds never converges under REFUSE; FLAG guarantees
progress.

**The value-level β bound.** A model number is one member of a set the attempts could have produced;
read-back reproduces the recorded bytes, not proof the mark is within tolerance of an honest independent
re-derivation. The producer attests a **reproducibility class** carrying a bound **β** in the lineage.
The **door checks presence and structure only** — it does not compare β to any tolerance, because the
tolerance is the *consuming* instrument's and is not single-valued at admission (one surface at β = 3 bp
serves a unit tolerant to 5 bp and one tolerant to 1 bp). A missing attestation is admit-and-flag, never
refused. **At consumption, `β ≤ VM-6` is compared as a VM-7 broken chain**: a consuming unit's valuation
projection raises a broken chain when β exceeds *that* unit's tolerance or β is absent. Totality is by
type (**COVERAGE-β**): the sole accessor to a kind-2 leaf is the "current fit" selector that carries the
class and raises the broken chain, so a raw path is a type error. A false β degrades to detection-at-audit.

**The compute/emit split** removes the door-arrival race for a non-bit-reproducible model: `runModel` is
one activity whose output Temporal memoizes; `proposeToDoor` is a separate activity whose only input is
that recorded output — a typed boundary, so a worker that recomputes-and-proposes in one step (which
would reopen the race) is not representable. Retries re-present identical bytes; canonical-by-first is a
declared rule, and bit-reproducibility is never an admission precondition (out-of-scope numerics).

**Corporate actions.** A corporate action is a first-class recorded transaction; the market data operator
is a read-time projection, the original never overwritten. A late or corrected corporate action is a
reordering handled by the refold, never a Temporal un-adjust.

### 3.3 Valuation
A **chain link** reads a cut, prices a leg (version-pinned, re-entering via the door), computes the
**profit-and-loss explain certificate** with entry-and-exit greeks, checks the residual against its
declared bound, and appends the link through the door. The chain and its certificates live on the log;
the workflow holds only the chain-head cursor. NAV and profit-and-loss are pure projections — one recipe
also serves risk, so risk and the books cannot disagree by construction.

**Re-mark cadence splits by the spec's own axis.** End-of-day desk marks are system cadence → a
**Schedule sweep** that chooses which units to re-mark, the pricing activity reading each unit's
node/frame/cut *from the record*, so a mid-corporate-action unit is never priced in a stale frame.
Contractual, corporate-action-driven, or input-moved re-marks are a **per-unit watch** reading the node.

**The corporate-action valuation sandwich** is a valuation struck immediately before the transition and
another immediately after, with the market data operator transporting the pre-frame mark into the
post-frame as a zero-profit identity, and a full explain across the pair. It is a **sequence of idempotent
legs** whose completion is a deterministic function of the recorded `{nodeId, cut}`: a mark is kind-1 when
it is the operator's frame re-coordination and kind-2 when model-priced; the certificate is the one
kind-3 admission. Because no leg is held in workflow memory, a continue-as-new at any step re-derives the
whole sandwich or resumes the one missing certificate admission — **a half-sandwich is never nameable**.
The residual within its three declared tolerances (minor-unit rounding, the convention's rounding, any
re-derived surface's calibration tolerance) is the proof the action went well.

**Risk, scenarios, and backtests** run the one per-unit recipe on shifted market data in an isolated
namespace against its own lineage's door. The **shift** is the recorded seed; a strategy is itself a
**unit**, so a backtest reuses one-workflow-per-unit unchanged; simulated re-entries enter the simulated
path's own record, and where coordinates coincide with production the chain equals it by determinism,
reached by recomputation, never a second stored copy.

---

## 4. Invariants, the canonical key, and the production/simulation seam

- **I1 — one single writer per lineage.** The write credential is a **fenced lease over a
  quorum-committed log**: an append is acknowledged only after it is durable in the quorum
  (durable-before-ack, so no lost admission), and the log rejects any append not carrying the current
  fence token, so a split-brain stale door's writes are rejected by the log — never two admitting doors.
  Failover moves the fence, never duplicates it.
- **I2 — the identity key.** The canonical 3-tuple `(input-cut, model-version, recipe/dynamic-version)`;
  seed and numerical-environment out of identity; input-cut exact-grained. The injectivity dual: distinct
  fine-grained causes yield distinct admissions.
- **I3 — no model in-fold.** The refold is `apply ∘ contract`, a pure fold; kind-2 outputs are immutable
  leaves; re-derivation is forward and out-of-fold. Enforced by type.
- **I4 — axis non-leak.** The activity reads the recipe/model/dynamic version *from the log*, never from
  its binary; the orchestration Build-ID pins orchestration only and is not in the fold. Three economics
  axes (ProductTerms, model/recipe, dynamic/gate-terms) live on the log.

**The production/simulation seam** is two orthogonal separations. **Base vs derived stream** is a
*stream* boundary within one production lineage — tagged sub-streams sharing the production door; a
production-serving derived object (today's calibrated surface serving a real mark) is production data.
**Production vs simulation** is a *namespace* boundary: a scenario, backtest, or authorised fork lives in
an isolated namespace against its own lineage's door, and only a final result re-enters production as an
observation. Door-credential separation follows the second boundary: the production door holds the sole
production write credential; a simulation namespace's door is a separate credential. The discriminating
test is *does a real production unit's valuation chain read it back?*

---

## 5. Divergence catalogue and red-team survival

**Divergences, each with its containment.**

- **D1 Bare-read** — a fetch that records nothing is forbidden; every ingestion activity's only success
  is proposing an observation-recording transaction, and read activities read the record, never a live
  feed.
- **D2 Model nondeterminism** — model runs are version-pinned activities (never workflow, never local),
  output recorded; heavy runs heartbeat under a bounded schedule-to-close so a retry fires only on
  genuine failure.
- **D3 Past-dated synthesised firings** — the refold's past-dated synthesis is the single writer's work;
  the substrate re-fires forward only; the late corporate-action sandwich rides this exact path.
- **D4 Staleness vs workflow state** — staleness is a recorded fact; the "current fit" projection selects
  the latest non-superseded value and carries the flag; orchestration only triggers forward re-derivation.
- **D5 History size** — marks, states, and verdicts live on the log; continue-as-new carries the
  identifier triple only; derived-state volume is isolated to simulation namespaces.
- **D6 Undecidable / refuse vs retry-to-infinity** — undecidable, refuse, and a broken chain are returned
  values, not retryable errors; each stands as a visible blocked or overdue item.
- **D7 Prevention in an untrusted constructor** — a decidable predicate any party recomputes;
  prevention-at-construction plus consumption-by-reference, detection-at-audit; no door privilege added.
- **D8 Workflow-code nondeterminism** — wall clock, randomness, unordered-map iteration, and direct I/O
  are confined to activities; the three times come from the log.
- **D9 Versioning — three axes** — orchestration Build-ID; contract economics; model/recipe/dynamic/gate
  terms on the log, never touching workflow code.
- **D10 Retry vs exactly-once admission** — the cause-derived identifier over the canonical 3-tuple, never
  a Temporal run/attempt id; dedup is load-bearing by construction, and only the pre-log early-drop is
  optimisation.
- **D11/D12 Queue/timer time vs the fold** — the committed order is the total order `(execution, door,
  hash)` at the door alone; timers carry no time authority; a late observation refolds; a late-firing
  timer yields the identical transaction.
- **D13 Attribution/dispersion convention as worker config** — the convention (the held-invariant factor,
  the partition, the dispersion rule, the normalisation) is a declared, recorded term read by the
  projection, never a worker default.
- **D14 Admission ≠ deterministic value** — closed by the compute/emit split, canonical-by-first, and the
  β bound at consumption.
- **D15 MD-16 write atomicity** — state + verdict as one transaction over one pinned cut; A′ = FLAG.
- **D16 Value spread bound** — the producer-attested reproducibility class, β ≤ VM-6 at consumption
  (COVERAGE-β), false β to audit.

**The seven red-team scenarios and the property each demonstrated survives.**

- **S4 EXACTLY-ONCE = A TOTAL FUNCTION OF THE DURABLE LOG (the root; S1/S3/S6/S7 reduce to it).** The
  atomic unique-key insert admits exactly one row per identifier under N redeliveries × W racing workers
  × a door crash-restart; none is starved; differing payloads under one identifier collapse to
  first-wins, β bounding the discard.
- **S1 REFOLD-ATOMIC.** Append-only ⇒ rewind not representable; no model recomputed in-fold; re-proposed
  transactions and synthesised firings collapse to one row; the resume key is the stable `(exec, door,
  hash)` triple, never an ordinal. This is what A′ = FLAG rests on.
- **S7 GATE-STATE-ATOMIC.** State + verdict are one transaction over one pinned cut; a failover re-runs
  the gate and construct as pure functions of the cut to the same identifier; no ungated or half-verdict
  state is nameable.
- **S3 SANDWICH-CARRIES-NO-WORKFLOW-STATE.** The sandwich holds no economic state in Temporal history; a
  continue-as-new re-derives it or resumes the one missing certificate; a pre-admitted leg is
  byte-identical by read-back, a re-driven leg is idempotent and β-bounded.
- **S6 LOG-IS-SOLE-TRUTH.** Rebuild reads only the log; the cache holds no write credential; a replayed
  identifier is absorbed; a fabricated novel identifier is door-refused, and a value-corrupted-but-
  consistent one is audit-caught. **Honest edge, no overclaim:** economic causality is
  **detection-at-audit, not door-prevention** — the guarantee is "no poison silently becomes trusted
  truth; no rebuilt state is not derivable from the log," not "no structurally-valid poison ever touches
  the log."
- **S2 DEPLOY-IS-ORCHESTRATION-ONLY.** A deploy touches only the Build-ID, which is not in the fold;
  every value is a fold/read-back under recorded economic versions read from the log; an economic change
  is a new recipe-version and a new identifier, never a silent rewrite.
- **S5 THREE-TIMES-ARE-RECORDED-VALUES.** The fold orders on the door's logical `(exec, door, hash)` read
  from the log; a bare clock-read stamping a recorded fact is unrepresentable by type; skew enters only
  timer firing, so a skewed fire yields the identical transaction and degrades to an overdue-watch event.

---

## 6. The firing-witness harvest

A guarantee defended only in prose is not an invariant. Each property below is owed to the property-test
regime over generated products, events, and histories, and must be shown to **fire** — a precondition
never generated is a defect, not a green test.

| Property | Generator that witnesses it fire | Obligation |
|---|---|---|
| `prop_refoldIdempotent` | random late-arrival interleavings + a second refold pass | refold twice = refold once |
| `prop_refoldEqualsTimely` | late arrivals vs the same events folded in execution order | refolded state = timely state |
| `prop_exactlyOnceAdmission` (S4, double-admit half of I2) | N redeliveries × W workers × a door crash-restart, same identifier | exactly one row per identifier; none starved |
| `prop_noSilentUnderAdmit` (S4, injectivity half of I2) | two fine-grained-distinct causes with near-identical input-cuts | distinct causes → two distinct admitted identifiers |
| `prop_gateStateAtomic` (S7) | failover at each of gate1 / gate2 / construct / propose | whole {state, verdict} pair or nothing |
| `prop_sandwichCANInvariant` (S3) | continue-as-new injected in both positions: after a leg's emission is durable, and mid-compute of a kind-2 leg | pre-admitted leg byte-identical by read-back; a re-driven leg idempotent, no half/no double, β-bounded |
| `prop_wipeRebuildEqualsLog` (S6) | wipe Temporal and rebuild from the log | rebuilt state = pre-wipe state, cache-independent |
| `prop_fabricatedTxidRefusedOrAudited` (S6) | two fabrications: a novel/inconsistent identifier, and a structurally-valid, value-corrupted one (real logged cause, wrong value) | the first door-refused; the second audit-caught (D7) — the audit branch fires |
| `prop_deployMidBacktestInvariant` (S2) | a Build-ID change at each backtest step | admitted `(txid, value)` set + order unchanged |
| `prop_clockSkewInvariant` (S5) | adversarial per-worker/DC offsets over a history including a commuting same-execution-time pair | admitted set, fold result, execution+monitor times invariant; door-order invariant up to commuting same-execution-time transposition; a skewed timer fire yields the identical identifier |
| `prop_everyKind2ConsumerChecksBeta` (COVERAGE-β) | valuation paths with β above/below tolerance | every β>tolerance path raises a VM-7 broken chain |

**Parking test exercised, empty.** The derived stream is not a second store (one immutable-log mechanism
on a tagged sub-stream); a gate verdict is a pinned event-outcome, not a recompute-on-read projection;
the late-corporate-action sandwich is the reordering path, not a compensation. The design must **not**
turn on the Valuation Manifesto's PARK-1, which the MD-16 mechanism neither reopens nor turns on. Residual
open items — the truthfulness of a producer's attested β (a perimeter reconciliation caught at audit),
and the load model that sizes the continue-as-new cadence and the door and derivation pools — are parked,
not swept.

---

## 7. Minority report

**None.** Unanimous consensus at round 11: TEMPORAL-1 through TEMPORAL-5 all SIGN, and both referees
(FORMALIS, TuringAward) sign the round-11 text. The design is Pareto-optimal across correctness,
minimalism, and simplicity, and — with the injectivity witness `prop_noSilentUnderAdmit` added and the
harvest completed — across testability. No entry demands anything of the Constitution; every object stays
a projection, a re-entered observation, or a recorded decision on the log, and the log stays the sole book
of record.
