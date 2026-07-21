# Temporal Committee — Proposal TEMPORAL-1, Round 9 (consensus candidate: full red-team + firing harvest)

**Stance.** The assembly on **three record kinds + one lineage discipline**; all seven red-team
scenarios (S1–S7) now hold. This round folds the two MEDIUM residuals (canonical **3-tuple** key; S3
byte-identity **read-back** wording), adds **S2** (deploy mid-backtest) and **S5** (clock skew), and
delivers the **firing-witness harvest** the Constitution's §3 owes. Three kinds: **(1) projection**
(recompute-on-read, never stale); **(2) re-entered observation** (model output; read-back
unconditional; stale when a consumed input moves, MD-8); **(3) recorded decision, pinned as-known** (a
verdict recorded with the event — the base ledger's own door admit/refuse, spec l.1051; the MD-16 gate
verdict is the same shape). Lineage discipline: cause-derived `txid` over recorded inputs, pinned
**cut**, forward-only refold. Settled: **Fork A** single-transaction write; **A′** FLAG; **Fork B**
contractual-vs-system split; **determinism** = compute/emit split (fused worker unrepresentable); **value
bound** = reproducibility class **β**, door checks presence, `β ≤ VM-6` at consumption. Acceptance test
(exercised by S6): strip Temporal, rebuild chain + derived states + gate verdicts from the log (R-02).

## 1. Mapping table

| Temporal primitive | Framework correspondence |
|---|---|
| **Workflow** | One long-lived **unit** workflow per `unitId` (R-03); derived-object builds, MD-16 applications, chain links are sequences it runs — no new workflow *kind*. |
| **Activity** | Every side effect: `captureArrival`, `readCut`, `runModel` (version-pinned), `proposeToDoor`, `applyOperator`, `computeCertificate`, `gate1_noArb`, `gate2_realism`. Operator/NAV/PnL/certificate/settlement are read-time **projection** activities. A read that records nothing is the forbidden **bare read** (D1). |
| **Signal / signal-with-start** | Timing + reference only (R-11, M4); ledger-created units start their own; **graph branches stay in-workflow** (market-claim leg = branch; split legs = new units — **do not conflate split with CAN**, R-14). |
| **Query / Continue-as-new** | Query = non-authoritative liveness (R-13), a **dispute** is a *replay*. **CAN carries `{unitId\|lineageId, nodeId, cut}` only** (R-15) — no economic/sandwich state (S3); chain/states/verdicts live on the log and rehydrate. |
| **Durable timer / Schedule** | Timer = date-**watch** liveness half only (R-08), authoring **none** of the three times (S5); Schedule = system cadence only (R-09), never a per-unit contractual date. |
| **Namespace** | Two orthogonal separations (§2.4): base vs derived **stream** = tagged sub-streams of one production lineage, same door; production vs simulation = isolated **namespaces**, each its own door (R-18/R-20). |
| **Task queue / versioning** | Queues split by trust/scaling (R-18): **door (sole write credential — a fenced lease over a quorum-committed log, I1)**, contracts, ingestion, unit-orchestration, settlement; models/derivation a soft sixth (§5). **Worker Versioning = orchestration Build-ID only (axis 1, R-17); Build-ID ∉ the fold (S2)**; the three economics axes live on the log: ProductTerms, model/recipe, dynamic/gate-terms (MD-16). |

**Idempotence key (canonical — the one pin, a clean 3-tuple).** The identity `txid` is cause-derived
over recorded **`(input-cut, model-version, recipe/dynamic-version)`**. A stochastic recipe's drawn
**seed** is a recorded parameter *of the recipe/dynamic-version term* (the 3rd coordinate already
separates draws), so the key is a **3-tuple, never a 4-tuple with a seed slot** — if seed were a
separate identity coordinate, two retries with different seeds would mint two txids → double-admit, the
same failure env-in-key had. **`input-cut` is exact-grained** (a log-position / content-hash, never a
coarse "latest"/truncated label): a coarse label false-dedups two distinct causes → silent under-admit
(the injectivity dual of the key). **Seed and env-version are OUT of identity** — both are recorded
Tier-2 re-derivation terms, never txid coordinates. Never a Temporal run/attempt id. At-least-once →
exactly-once *admission* (S4).

## 2. Decomposition

### 2.1 Ledger (compact)
Unit-workflow: timers + signal-waits = current node's out-edges; node is a mirror, rehydrated on
start/CAN/doubt. `captureArrival` → `evaluateContract` (version-pinned, never local, R-06/R-26) →
`proposeToDoor`. Door = external single-writer, one idempotent `admit` activity (M6). CA cascade =
signal-with-start fan-out, each firing its own `txid`. Settlement failure re-enters as a recorded event
on the settlement-obligation unit's graph — never a saga.

### 2.2 Market data
- **Ingestion**: `captureArrival` records the observation through the **one door** (B1, MD-1),
  envelope-first; absorption is the door's cause-derived-id job at the registered grain. **Derived —
  projection kind**: read-time activity, recomputed on read (MD-6/8). **Re-entered kind**: `readCut` →
  `runModel(version-pinned; seed recorded to the log before compute, reused on CAN-resume)` →
  `proposeToDoor`; ledger runs no model (C-14.9); staleness on input correction is a **recorded flag**.
- **MD-16 dynamic application — Fork A (single transaction).** `pinCut(C)` → `gate1_noArb(C)` +
  `gate2_realism(C)` + `constructState(C)` over the **one pinned cut** (MD-12) → **state + passing
  verdict cross the door as ONE transaction** (no ungated-state window). Fail/undecidable → **refusal**
  recorded; consumers name a state by its admission record, so an ungated state is unnameable.
- **Fork A′ (base moved under the pinned cut, before admit) = FLAG.** A later correction to a consumed
  input **flags m\* stale-forward** (MD-8/10), m\* remaining the as-known-at-cut value it was gated as —
  the **single writer** decides on the refold. State is kind-2 (staleable), decision kind-3 (pinned);
  C-11.3 is a **structural** guard, not a tip-freshness check. **Refuse is reserved for a gate
  fail/undecidable verdict (gate) or an unresolvable structural reference (door) — never a fresher tip.**
  *Livelock:* a 90 s calibration with corrections every 45 s never converges under REFUSE; FLAG admits +
  flags forward.
- **CA/operator (prevention placement is D7)**: CA = first-class recorded transaction; operator =
  read-time projection (original never overwritten, MD-13/B4); late/corrected CA → refold + re-read.

### 2.3 Valuation
- **Chain link (VM-1/3)**: `readCut` → `priceLeg(version-pinned; re-enters via door)` →
  `computeCertificate` → `checkResidual` → append via door. Chain/certificates live on the log; the
  workflow holds only the chain-head cursor. NAV/PnL = pure projection.
- **Re-mark cadence — Fork B**: EoD desk marks (system) → **Schedule sweep**, the pricing activity
  **reading node/frame/cut from the record (VM-2)** so a mid-CA unit is never priced in a stale frame;
  contractual/CA/input-moved re-marks → **per-unit watch** reading the node.
- **CA sandwich (VM-9)**: before-mark + operator projection + after-mark + certificate. A mark is
  **kind-1** when it is the operator's frame re-coordination (a projection) and **kind-2** when
  model-priced (a re-entered observation); the certificate is the one **kind-3** admission. Residual
  within its **declared tolerances** (VM-9's three, VM-6) is the proof, not an asserted ≈0. Late resolved
  CA → retroactive sandwich at ex-date via refold.
- **Three returned-value outcomes at three loci** (never a retryable error, never a saga): **broken
  chain (VM-7)** at the valuation projection (residual over bound, staled leaf, **or β > this unit's
  tolerance**); **gate fail/undecidable** at the gate activity; **door refusal (R-22)** at the door.
  Staleness (D4) is a recorded fact; risk/backtest run the same recipe on **shifted** data in an
  isolated namespace against its own door, the shift the recorded seed (MD-11), equal production by
  recomputation.

### 2.4 Production-vs-simulation seam
*Does a real unit's valuation chain read it back?* **Yes** → production lineage, tagged derived stream,
production door. **No** → isolated namespace, own door (R-20). MD-16's "derived states never enter the
base stream" is a **stream** boundary, not a namespace one.

## 3. Divergences + containment

**Determinism closure.** `runModel` is one activity whose output Temporal memoizes; `proposeToDoor` is a
*separate* activity whose **only input is that recorded output** — a typed boundary, so the "fused
worker" that would reopen the race is **not representable** (CLAUDE.md §3). Retries re-present identical
bytes; only a `runModel` crash before its result is recorded recomputes → one value reaches the door.
The **content-hash diagnostic is deleted**: it never fires for the retry race it was built to catch, and
a split-brain two-payload arrival is not a hash case either — the atomic unique-key insert (S4) admits
one, β bounds the discard. Canonical-by-first-admission is a **declared rule**; bit-reproducibility is
**never** a door/admission precondition (C-Scope.11); env-version is a Tier-2 dispute term caught at audit.

**Value-level bound — two loci.** For a non-bit-reproducible model the recorded value is one member of
{P₁,P₂,…}; if the spread exceeds the consuming instrument's VM-6 tolerance, read-back satisfies
MD-14/VM-8 only trivially. Close it with a **producer-attested reproducibility class** carrying bound
**β**. **Door — presence + structure only**: records whether the class field is present and the
transaction structurally valid; does **not** compare β to any tolerance (the tolerance is the *consuming*
instrument's, not single-valued at admission — one surface β=3 bp feeds U₁@5 bp and U₂@1 bp). A
**missing** attestation is **admit-and-flag** (MD-2), never refused. **Consumption — VM-7 broken chain**
when β > that unit's tolerance (or β absent). A false β degrades to detection-at-audit (TA-REPRO).

**Invariant COVERAGE-β.** No valuation path consuming a kind-2 leaf escapes the β check — the
bare-valuation-read analog of D1. **By type:** the sole accessor reading a kind-2 leaf is the "current
fit" selector (MD-8) that carries the class and raises VM-7 when β > tolerance or β absent; a raw path
is a type error.

**Remaining divergences:** bare-read (D1); model nondeterminism → version-pinned activities, heartbeat +
bounded ScheduleToClose (D2); refold past-dated firings / staleness / history size → single writer's
work, forward re-read, on the log (D3/4/5, S1); versioning three axes / retry vs exactly-once (D9/10,
S4); queue/timer time vs the fold → total order `(exec,door,hash)` at the door alone (D11/12, S5);
convention a declared recorded term (D13).

## 4. Red-team (S1–S7) + named invariants

- **S4 EXACTLY-ONCE-ADMISSION (root; S1/S3/S6/S7 reduce to it).** The door admit is an **atomic
  unique-key insert on the cause-derived `txid`** at the single writer — **not** check-then-append (a
  TOCTOU that double-admits). Exactly-once is a **total function of the durable log** (dedup against the
  committed txid-set, never in-memory or arrival-order), invariant under N redeliveries × W racing
  workers × a door crash-restart: exactly one lands per txid, none starved (backpressure alarmed, R-18).
  The unique-key insert is **load-bearing, by construction**; only the pre-log early-drop is optimisation.
- **S1 REFOLD-ATOMIC** (S4 + append-only + I3): append-only → **rewind not representable**; refold
  recomputes **no model in-fold** (I3), re-proposed transactions and synthesised firings collapse to one
  row by S4; resume key is the stable `(exec, door, hash)` triple, never an ordinal. What **A′=FLAG** rests on.
- **S7 GATE-STATE-ATOMIC** (S4 + Fork A + I1): state + verdict = one transaction over one pinned cut C;
  failover re-runs `gate(C)/construct(C)` (pure functions of C) to the same txid, S4-collapsed — no
  ungated/half-verdict state nameable. (A Byzantine forged pass is a separate guarantee — D7 audit.)
- **S3 SANDWICH-CARRIES-NO-WORKFLOW-STATE** (S1 + S4): the sandwich holds no economic state in Temporal
  history; CAN carries `{nodeId, cut}` (resolved against the log), a sequence of idempotent legs whose
  completion is a deterministic function of the recorded cut. On CAN-resume a completed leg is
  byte-identical **by read-back of its durably-recorded emission** (not by recompute); a leg whose
  emission was not yet durable is **re-run and its first admission is canonical** (its txid dedups, β
  bounds any spread). A half-sandwich is never nameable.
- **S6 LOG-IS-SOLE-TRUTH** (S4 + I1 + D7): rebuild reads only the log (R-02); the cache holds **no write
  credential** (I1), so rebuilt = pre-wipe. A replayed txid is absorbed (S4); a fabricated novel txid is
  door-refused (the door recomputes the txid from the cause it resolves on the log, R-22) or, if
  structurally valid but economically uncaused, audit-caught (D7). **Honest edge:** economic causality is
  **detection-at-audit, not door-prevention** — the guarantee is "no poison silently becomes trusted
  truth; no rebuilt state is not derivable from the log," not "no structurally-valid poison ever touches
  the log."
- **S2 DEPLOY-CANNOT-CHANGE-A-RECORDED-VALUE** (I4): a workflow-code deploy touches **only the
  orchestration Build-ID (axis 1)**; **Build-ID ∉ the fold**, and every value is a fold/read-back under
  recorded economic versions (axes 2/3, on the log), which a version-pinned activity reads *from the log*,
  never from its binary. So the admitted `(txid, value)` set + total order are **invariant** under a
  mid-run/mid-backtest deploy; an in-flight run stays Build-ID-pinned (R-17); namespaces stay isolated
  (R-20). An economic change is a **new recipe-version = a new txid = a distinct fact**, never a silent
  rewrite. Break iff economics were pinned to the Build-ID — forbidden by I4.
- **S5 THREE-TIMES-ARE-RECORDED-VALUES-NOT-WALL-CLOCK** (D11/12 + R-08): the fold orders on the door's
  logical `(exec, door, hash)` read from the log, never sampled from a clock at replay; the three times
  are recorded terms, and a **bare clock-read that stamps a recorded fact is unrepresentable by type**
  (the D1 analog), so R-08 is by-construction. Skew enters **only timer FIRING** → a skewed fire yields
  the identical txid (S4-absorbed), degrading to an overdue-watch liveness event — never a reordered fold
  or a different value.

**Named invariants — by-construction, not deployment discipline:** **I1** single writer per lineage — a
**fenced lease over a quorum-committed log** (acked only after durable in the quorum → no lost admission;
the log rejects any append without the current fence token; failover moves the fence, never duplicates
it). **I2** identity key — the canonical 3-tuple (seed + env OUT of identity; input-cut exact-grained).
**I3** no model in-fold — the refold is `apply∘contract`, a pure fold; kind-2 outputs are immutable
leaves; enforced by type. **I4** axis non-leak — the activity reads the recipe/model/dynamic version
*from the log*, never its binary; Build-ID pins orchestration only. **COVERAGE-β** — §3.

## 5. Firing-witness harvest (Constitution §3 — a guarantee defended only in prose is not an invariant)

Each property is **owed to the property-test regime over generated products/events/histories** and must
be shown to **fire** (a precondition never generated = a defect, not a green test):

| Property | Generator that witnesses it fire | Obligation |
|---|---|---|
| `prop_refoldIdempotent` | random late-arrival interleavings + a second refold pass | refold twice = refold once |
| `prop_refoldEqualsTimely` | late arrivals vs the same events folded in execution order | refolded state = timely state |
| `prop_exactlyOnceAdmission` (S4) | N redeliveries × W workers × door crash-restart, same txid | exactly one row per txid; none starved |
| `prop_gateStateAtomic` (S7) | failover injected at each of gate1/gate2/construct/propose | whole {state,verdict} pair or nothing |
| `prop_sandwichCANInvariant` (S3) | CAN injected at before-mark/operator/after-mark/certificate | completed sandwich = CAN-free sandwich |
| `prop_wipeRebuildEqualsLog` + `prop_fabricatedTxidRefusedOrAudited` (S6) | forge/poison the cache, replay, wipe, rebuild-from-log; cache-fabricated novel/inconsistent txids | rebuilt = clean rebuild; every fabricated txid door-refused or audit-flagged, never silent |
| `prop_deployMidBacktestInvariant` (S2) | Build-ID change injected at each backtest step | admitted `(txid,value)` set + order unchanged |
| `prop_clockSkewInvariant` (S5) | adversarial per-worker/DC wall-clock offsets over timers | order + recorded three-times unchanged; skew only reschedules firing |
| `prop_everyKind2ConsumerChecksBeta` (COVERAGE-β) | valuation paths with β above/below tolerance | every β>tolerance path raises VM-7 |

## 6. Open questions
- **Parking test exercised, empty.** Derived stream as a "second store" (no — tagged sub-stream,
  C-2.8/12.5); gate verdict vs recompute-on-read (C-4.11 — a pinned event-outcome); late-CA sandwich vs
  compensation (reordering). Must **not** turn on the Valuation Manifesto's **PARK-1**; MD-16's mechanism
  neither reopens nor turns it on.
- **TA-REPRO + env retention (Tier-2, governance).** β bounds the spread when truthful; a false β is
  caught at audit. Env-version retention bounds how far MD-14/VM-8 reaches; §3's bound already stops an
  unbounded-spread mark passing as dispute-ready.
- **Load model (biggest unknown).** Volume per unit/underlying/day sizes `K`, the door pool, derived
  storage. **Fork C** (models queue) and **Fork D** (sim fan-out inside a namespace, *not* lineage
  coupling) gate on it, non-correctness; do not force. Gate-2 "undecidable" on sparse history parks by
  design — a flagged blocked item, never retry-to-infinity.
