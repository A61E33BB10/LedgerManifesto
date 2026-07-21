# Temporal Committee — Proposal TEMPORAL-1, Round 5 (assembly + S4 red-team)

**Stance.** The assembly on **three record kinds + one lineage discipline**; both referees held S1/S7
and flagged residuals, folded here. R5: states the door admit as an **atomic unique-key insert** and
proves **S4 (retry storm)** as the root property S1/S7 reduce to; pins the **canonical idempotence key**
(env OUT); adds the **COVERAGE-β** invariant from the consumption-locus move; and promotes the
single-writer and axis-non-leak invariants to **by-construction**. Three kinds: **(1) projection**
(stores nothing, recompute-on-read, never stale); **(2) re-entered observation** (model output;
read-back unconditional; stale when a consumed input moves, MD-8); **(3) recorded decision, pinned
as-known** (a verdict recorded with the event — the base ledger's own door admit/refuse, spec l.1051;
the MD-16 gate verdict is the same shape). Lineage discipline: cause-derived `txid` over recorded
inputs, pinned **cut**, forward-only refold. Settled: **Fork A** single-transaction write; **A′** FLAG;
**Fork B** contractual-vs-system split; **determinism** = compute/emit split (fused worker
unrepresentable); **value bound** = reproducibility class **β**, door checks presence, `β ≤ VM-6` at
consumption. Acceptance test: strip Temporal, rebuild chain + derived states + gate verdicts from the
log (R-02).

## 1. Mapping table

| Temporal primitive | Framework correspondence (ledger / market data / valuation) |
|---|---|
| **Workflow** | One long-lived **unit** workflow per `unitId` (R-03); derived-object builds, MD-16 applications, chain links are sequences it runs — no new workflow *kind*. |
| **Activity** | Every side effect: `captureArrival`, `readCut`, `runModel` (version-pinned), `proposeToDoor`, `applyOperator`, `computeCertificate`, `gate1_noArb`, `gate2_realism`. Operator/NAV/PnL/certificate/settlement are read-time **projection** activities. A read that records nothing is the forbidden **bare read** (D1). |
| **Signal / signal-with-start** | Timing + reference only (R-11, M4); ledger-created units start their own; **graph branches stay in-workflow** (market-claim leg = branch; split legs = new units — **do not conflate split with CAN**, R-14). |
| **Query / Continue-as-new** | Query = non-authoritative liveness (R-13), a **dispute** is a *replay* from the log. CAN carries `{unitId\|lineageId, nodeId, cut}` only (R-15); chain/states/verdicts live on the log and rehydrate. |
| **Durable timer / Schedule** | Timer = date-**watch** liveness half only (R-08), authoring none of the three times; Schedule = system cadence only (R-09), never a per-unit contractual date. |
| **Namespace** | Two orthogonal separations (§2.4): base vs derived **stream** = tagged sub-streams of one production lineage, same door; production vs simulation = isolated **namespaces**, each its own door (R-18/R-20). |
| **Task queue / versioning** | Queues split by trust/scaling (R-18): **door (sole write credential — a fenced lease, I1)**, contracts, ingestion, unit-orchestration, settlement; models/derivation a soft sixth (§6). Worker Versioning = orchestration axis only (R-17); the three economics axes live on the log: ProductTerms, model/recipe, dynamic/gate-terms (MD-16). |

**Idempotence key (canonical — the one pin; T-4/T-5 align to this).** The identity `txid` is
cause-derived over recorded `(input-cut, model-version, recipe/dynamic-version)`, plus `seed` where the
recipe is stochastic (a different seed is a different fact, MD-11) — the **seed drawn and recorded
before compute**, never inside `runModel` (else a re-run re-draws → a distinct txid → two admissions).
**Env-version is OUT of the key** — a Tier-2 governance lineage term for re-derivation, never identity:
including it makes two environments two facts, contradicting the β mechanism (defined to bound the
spread *across* environments) and, under a cross-DC split-brain, minting two txids → two admissions,
breaking S7. `input-cut` must stay in the key (drop it and a correction is silently absorbed). Never a
Temporal run/attempt id. At-least-once → exactly-once *admission* (S4).

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
  projection kind**: read-time activity, recomputed on read (MD-6/8). **Re-entered kind** (fitted
  surface): `readCut` → `runModel(version-pinned; seed recorded before compute)` → `proposeToDoor`;
  ledger runs no model (C-14.9); staleness on input correction is a **recorded flag** (MD-8).
- **MD-16 dynamic application — Fork A (single transaction).** `pinCut(C)` → `gate1_noArb(C)` +
  `gate2_realism(C)` + `constructState(C)` over the **one pinned cut** (MD-12) → **state + passing
  verdict cross the door as ONE transaction** (no ungated-state window). Fail/undecidable → **refusal**
  recorded, no state admitted; consumers name a state by its admission record, so an ungated state is
  unnameable.
- **Fork A′ (base moved under the pinned cut, before admit) = FLAG.** A later correction to a consumed
  input **flags m\* stale-forward** (MD-8/10), m\* remaining the as-known-at-cut value it was gated as —
  the **single writer** decides on the refold. State is kind-2 (staleable), decision kind-3 (pinned,
  never stale); REFUSE conflates them, and C-11.3 is a **structural** guard, not a tip-freshness check.
  **Refuse is reserved for a gate fail/undecidable verdict (gate) or an unresolvable structural
  reference (door) — never a fresher tip.** *Livelock:* a 90 s calibration with corrections every 45 s
  never converges under REFUSE; FLAG admits + flags forward — progress guaranteed.
- **Prevention placement (D7); CA/operator**: Gate 1 (`m*∈Θ_AF`) needs model knowledge the door must
  not hold (spec l.917), so it runs in a gate activity; a mis-gate degrades to detection-at-audit. CA =
  first-class recorded transaction; operator = read-time projection (original never overwritten,
  MD-13/B4); late/corrected CA → refold + re-read.

### 2.3 Valuation
- **Chain link (VM-1/3)**: `readCut` → `priceLeg(version-pinned; re-enters via door)` →
  `computeCertificate` → `checkResidual` → append via door. Chain/certificates live on the log; the
  workflow holds only the chain-head cursor. NAV/PnL = pure projection.
- **Re-mark cadence — Fork B**: EoD desk marks (system) → **Schedule sweep**, the pricing activity
  **reading node/frame/cut from the record (VM-2)** so a mid-CA unit is never priced in a stale frame;
  contractual/CA/input-moved re-marks → **per-unit watch** reading the node.
- **CA sandwich (VM-9)**: before-mark + operator projection + after-mark + certificate, struck as a
  projection from the log (CAN-safe, S3). Residual within its **declared tolerances** (VM-9's three,
  VM-6) is the proof, not an asserted ≈0. Late resolved CA → retroactive sandwich at ex-date via refold.
- **Three returned-value outcomes at three loci** (never a retryable error, never a saga): **broken
  chain (VM-7)** at the valuation projection (residual over bound, staled leaf, **or β > this unit's
  tolerance**); **gate fail/undecidable** at the gate activity (m\* never produced); **door refusal
  (R-22)** at the door (structural/consistency/auth/idempotence). Staleness (D4) is a recorded fact;
  risk/backtest run the same recipe on **shifted** data in an isolated namespace against its own door,
  the shift the recorded seed (MD-11), equal production by recomputation.

### 2.4 Production-vs-simulation seam
*Does a real unit's valuation chain read it back?* **Yes** → production lineage, tagged derived stream,
production door (isolation = credential separation *within* the namespace, R-18). **No** → isolated
namespace, own door (R-20). MD-16's "derived states never enter the base stream" is a **stream**
boundary, not a namespace one.

## 3. Divergences + containment

**Determinism closure.** `runModel` is one activity whose output Temporal memoizes; `proposeToDoor` is a
*separate* activity whose **only input is that recorded output** — a typed boundary, so the "fused
worker" that would reopen the race is **not representable** (CLAUDE.md §3). Retries re-present identical
bytes; only a `runModel` crash before its result is recorded recomputes → one value reaches the door
(no race). The **content-hash diagnostic is deleted**: it never fires for the *retry race it was built
to catch* (the split memoises that away); a split-brain two-payload arrival at the one door is not a
hash case either — the atomic unique-key insert (§5, S4) admits one, and β bounds the discard at
consumption. Canonical-by-first-admission is a **declared rule**, not MD-1 absorption; bit-reproducibility
is **never** a door/admission precondition (out-of-scope numerics, C-Scope.11); the env-version is a
governance-optional Tier-2 dispute term caught at audit.

**Value-level bound — two loci.** For a non-bit-reproducible model the recorded value is one member of
{P₁,P₂,…} with nothing bounding |Pᵢ−Pⱼ|; if the spread exceeds the consuming instrument's VM-6
tolerance, read-back satisfies MD-14/VM-8 only trivially. Close it with a **producer-attested
reproducibility class** carrying bound **β** (the one symbol). **Door — presence + structure only**:
records whether the class field is present and the transaction structurally valid; does **not** compare
β to any tolerance (the tolerance is the *consuming* instrument's, not single-valued at admission — one
surface β=3 bp feeds U₁@5 bp and U₂@1 bp). A **missing** attestation is **admit-and-flag** (MD-2), never
refused (economic metadata, not envelope validity). **Consumption — VM-7 broken chain** when β > that
unit's tolerance (or β absent). A false β degrades to detection-at-audit (TA-REPRO). A′-consistent:
admit + flag, never refuse.

**Invariant COVERAGE-β (new; the consumption-locus move's obligation).** No valuation path consuming a
kind-2 leaf escapes the β check — the "bare valuation read" analog of the forbidden bare read (D1).
**By construction:** a valuation reads a kind-2 leaf *only* through the "current fit" selector (MD-8)
that carries the reproducibility class and raises VM-7 when β > the consuming unit's tolerance or β
absent; there is no raw path to a kind-2 leaf. Executable property below (§5).

**Remaining divergences (containment):** bare-read → ingestion's only success is proposing a
recording transaction (D1); model nondeterminism → version-pinned activities, output recorded, heavy
runs heartbeat with bounded ScheduleToClose (D2); refold past-dated firings / staleness / history size →
single writer's work, forward re-read, on the log (D3/4/5, S1); versioning three axes / retry vs
exactly-once → Build-ID orchestration-only, economics on the log, cause-derived txid (D9/10, S4);
queue/timer time vs the fold → total order `(exec,door,hash)` at the door alone, timers no time
authority (D11/12); convention as worker config → a declared recorded term, never a worker default (D13).

## 4. Red-team + named invariants

**S4 — retry storm at the one door. Property EXACTLY-ONCE-ADMISSION (the ROOT; S1 and S7 reduce to it).**
The door's admit is an **atomic unique-key insert on the cause-derived `txid`** at the single writer —
**not** check-then-append (a read-modify-write TOCTOU that double-admits under a storm). Exactly-once is
a **total function of the durable log**: dedup is decided against the committed txid-set *on the log*,
never an in-memory in-flight set or arrival order. So under **N redeliveries × W racing workers × a door
crash-restart mid-storm**: concurrent same-txid proposals serialize on the unique-key constraint and
**exactly one lands** (first to commit), the rest are no-ops; a restart loses no dedup state (it is on
the log); each *distinct* txid is admitted exactly once and **none is starved** — throughput degrades,
the door never blocks, drops-silently, or lies (backpressure = schedule-to-start alarmed, R-18). This
reconciles D10: the **unique-key insert is load-bearing and by-construction**; only the pre-log
early-drop is the "optimisation." Where a storm or split-brain delivers *differing* payloads under one
txid, the insert admits first-wins and **β bounds the discard** at consumption. **S1** (crash mid-refold
re-proposes tail txids) and **S7** (failover mid-gate re-proposes the {state,verdict} txid) both reduce
to this — each re-proposal collapses to one row.

**S1 — REFOLD-ATOMIC (HOLDS, corollary of S4 + append-only + I3).** The refold is the single writer's
append-only work (edits no byte → **rewind not representable**) and recomputes **no model in-fold** (I3:
kind-2 outputs are immutable leaves, so the fold is a pure function → idempotent). A crash re-runs from
the last durable point; re-proposed transactions and synthesised firings (keyed `H(correction, watch,
occasion)`) collapse to one row by S4. Only crash-*before-record* recomputes the model → one payload
reaches the door, spread bounded by β. Resume key is the stable `(exec, door, hash)` triple, never an
ordinal (an interior insertion renumbers ordinals). This is what **A′=FLAG** rests on.

**S7 — GATE-STATE-ATOMIC (HOLDS, corollary of S4 + Fork A + I1).** State + verdict are one transaction
over one pinned cut C (a recorded log-cursor, not volatile); failover re-runs `gate(C)/construct(C)` —
pure functions of C — to the **same txid**, collapsed by S4. No ungated/half-verdict state is nameable;
consumption-by-reference backstops. (A Byzantine *forged* pass is a separate guarantee — D7's decidable
recheck at audit — not S7's interrupted-honest-work case.)

**Named invariants — promoted to by-construction, not deployment discipline:**
- **I1 single writer per lineage.** The write credential is a **fenced lease**: the durable log rejects
  any append not carrying the current fence token, so a split-brain stale door's writes are rejected *by
  the log* — never two admitting doors. Failover moves the fence, never duplicates it.
- **I2 identity key** — the canonical txid above (env OUT, seed-before-compute, input-cut IN).
- **I3 no model in-fold** — the refold is `apply∘contract`, a pure fold; kind-2 outputs are immutable
  leaves; re-derivation is forward/out-of-fold. Enforced by type, not assumed.
- **I4 axis non-leak.** The activity reads the recipe/model/dynamic version *from the log*, never from
  its binary; Build-ID pins orchestration only. A deploy changes the Build-ID, never a recorded economic
  value — by construction (the version is an input read, not a constant compiled in).
- **COVERAGE-β** — §3 (the only β-check path to a kind-2 leaf is the VM-7-raising selector).

**Required firing properties (executable; zero firings = defect, CLAUDE.md §3):** `prop_refoldIdempotent`
(refold twice = once); `refold-equals-timely` (refolded = timely fold, over generated late-arrival
interleavings); the fault-generators for **S4** (storm + restart → one row per txid), **S1** (crash at
each tail position → recovered log = crash-free refold), **S7** (failover at each of
gate1/gate2/construct/propose → whole {state,verdict} pair or nothing); **COVERAGE-β** (paths with β
above/below tolerance → every β>tol path raises VM-7).

## 5. Open questions
- **Parking test exercised, empty.** Derived stream as a "second store" (no — tagged sub-stream,
  C-2.8/12.5); gate verdict vs recompute-on-read (C-4.11 — a pinned event-outcome); late-CA sandwich vs
  compensation (reordering). Must **not** turn on the Valuation Manifesto's **PARK-1**; MD-16's mechanism
  neither reopens nor turns it on.
- **TA-REPRO + env retention (Tier-2, governance).** β bounds the spread when truthful; a false β is
  caught at audit — the perimeter status of the VM-6 tolerance itself. Env-version retention bounds how
  far MD-14/VM-8 reaches; §3's bound already stops an unbounded-spread mark passing as dispute-ready.
- **Load model (biggest unknown).** Volume per unit/underlying/day sizes `K`, the door pool,
  derived-stream storage. **Fork C** (models queue) and **Fork D** (sim fan-out inside a namespace, *not*
  the seed's forbidden lineage-coupling use) gate on it and are non-correctness; do not force. Gate-2
  "undecidable" on sparse history parks by design — a flagged blocked item, never retry-to-infinity.
