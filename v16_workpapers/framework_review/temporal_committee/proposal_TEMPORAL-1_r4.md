# Temporal Committee — Proposal TEMPORAL-1, Round 4 (assembly + red-team)

**Stance.** The assembly on **three record kinds + one lineage discipline**, catalogue on TEMPORAL-4's
rows; both referees certified convergence. R4 folds the one seam they flagged (value-bound locus), pins
four housekeeping items, and red-teams the two crown-jewel invariants. Three kinds: **(1) projection**
(stores nothing, recompute-on-read, never stale); **(2) re-entered observation** (model output;
read-back unconditional; stale when a consumed input moves, MD-8); **(3) recorded decision, pinned
as-known** (a verdict recorded with the event it decides — not recompute-on-read, not
stale-on-input-move; the base ledger's own door admit/refuse, spec l.1051; the MD-16 gate verdict is the
same shape). Lineage discipline: cause-derived `txid` over recorded inputs, pinned **cut**, forward-only
refold. Settled and carried: **Fork A** single-transaction write; **A′** FLAG; **Fork B**
contractual-vs-system split; **determinism** = compute/emit split (primary, fused worker unrepresentable)
+ numerical-environment pin (Tier-2); **scope boundary one voice**; **value-level bound** = reproducibility
class, door checks presence, `β ≤ VM-6` at consumption (§3). Acceptance test: strip Temporal, rebuild
chain + derived states + gate verdicts from the log (R-02).

---

## 1. Mapping table

| Temporal primitive | Framework correspondence (ledger / market data / valuation) |
|---|---|
| **Workflow** | One long-lived **unit** workflow per `unitId` walking the product graph (R-03). Derived-object builds, MD-16 dynamic applications, valuation-chain links are sequences it (or a derived-lineage workflow) runs — no new workflow *kind*. |
| **Activity** | Every side effect: `captureArrival` (envelope-first through the door), `readCut`, `runModel` (version-pinned), `proposeToDoor`, `applyOperator`, `computeCertificate`, `checkResidual`, `gate1_noArb`, `gate2_realism`. Operator/NAV/PnL/certificate/settlement are read-time **projection** activities. A read that records nothing is the forbidden **bare read** (§sec:obs-door, D1). |
| **Signal / signal-with-start** | Timing + reference only (R-11, M4): watch satisfaction, CA cascade fan-out, "re-read: the fold moved" (sec:substrate). Ledger-created units start their own; **graph branches stay in-workflow** (market-claim leg = branch; partial-split legs = new units — **do not conflate split with ContinueAsNew**, R-14). |
| **Query / Continue-as-new** | Query = non-authoritative liveness view (R-13); a **dispute** (VM-8/MD-14) is a *replay* from the log. CAN carries `{unitId\|lineageId, nodeId, cut}` only (R-15); chain, derived states, gate verdicts live on the log and rehydrate. |
| **Durable timer / Schedule** | Timer = date-**watch** liveness half only (R-08); ex-date/due-date are the *recorded* event's **execution time**, the timer authoring none of the three times. Schedule = system cadence only (R-09: EoD marks, overdue-watch/stale-fit sweeps), never a per-unit contractual date. |
| **Namespace** | Two orthogonal separations (§2.4): **base vs derived stream** = tagged sub-streams of one **production** lineage, **same door**; **production vs simulation** = isolated namespaces, each its **own door** (R-18/R-20). |
| **Task queue / versioning** | Queues split by trust/scaling (R-18): door (sole write credential), contracts, ingestion, unit-orchestration, settlement; a **models/derivation** family is a soft sixth (§5). Worker Versioning is orchestration-axis only (R-17); the **three** economics axes live on the log: ProductTerms (contract), model/recipe (re-entered obs), dynamic/gate declared-terms (MD-16). |

**Idempotence key (pinned).** Every re-entry dedupes via the door's `txid` over recorded `(input-cut,
model/recipe/dynamic-version)` — plus `seed` where the recipe is stochastic (different seed = different
fact, MD-11) — **never** a Temporal run/attempt id, and **never** the numerical-environment version (a
Tier-2 lineage term: including it would admit two environments as two facts and reopen the race).

---

## 2. Decomposition

### 2.1 Ledger (compact)
Unit-workflow: timers + signal-waits = current node's out-edges; node is a mirror, rehydrated on
start/CAN/doubt. `captureArrival` → `evaluateContract` (version-pinned, queue-routed, never local,
R-06/R-26) → `proposeToDoor`. Door = external single-writer, one idempotent `admit` activity (M6). CA
cascade = signal-with-start fan-out; each firing its own `txid`, all *n* commit. Settlement failure
re-enters as a recorded event on the settlement-obligation unit's graph — never a saga.

### 2.2 Market data
- **Ingestion**: `captureArrival` records the observation through the **one door** (B1, MD-1),
  envelope-first (R-12); absorption is the door's cause-derived-id job at the registered grain.
- **Derived object — projection kind** (discount factor, operator-adjusted value): read-time activity,
  recomputed on read (MD-6/MD-8). **Re-entered kind** (fitted surface, filter): `readCut` →
  `runModel(version-pinned; seed recorded)` → `proposeToDoor`; the ledger runs no model (C-14.9/V1);
  staleness on input correction is a **recorded flag** (MD-8), re-derivation forward.
- **MD-16 dynamic application — Fork A (single transaction).** `pinCut(C)` → `gate1_noArb(C)` +
  `gate2_realism(C, as-known history)` + `constructState(C)` all over the **one pinned cut** (MD-12) →
  **state + passing verdict cross the door as ONE transaction** (no ungated-state window).
  Fail/undecidable → **refusal** recorded, no state admitted (prevention); consumers name a state by its
  admission record, so an ungated state is unnameable.
- **Fork A′ (base moved under the pinned cut, between pinCut and admit) = FLAG.** A later correction to a
  consumed input does **not** refuse: it **flags m\* stale-forward** (MD-8/MD-10), m\* remaining the
  as-known-at-cut value it was gated as — the **single writer** decides on the refold. The m\* state is
  kind-2 (stales on input move), the decision kind-3 (pinned, never stale); REFUSE conflates them, and
  C-11.3 is a **structural** guard, not a tip-freshness check. **Refuse is reserved for a gate
  fail/undecidable verdict (gate decides) or an unresolvable structural reference (door decides) — never a
  fresher tip.** *Livelock proof:* a 90 s calibration with corrections at ≤C every 45 s never converges
  under REFUSE; FLAG admits + flags forward — progress guaranteed.
- **Prevention placement (derived, D7); CA / operator**: Gate 1 (`m*∈Θ_AF`) needs model knowledge the
  door must not hold (spec l.917), so it runs in a gate activity, verdict-and-state committed atomically.
  CA = first-class recorded transaction; operator = read-time projection (original never overwritten,
  MD-13/B4). Late/corrected CA → refold + re-read.

### 2.3 Valuation
- **Chain link (VM-1/VM-3)**: `readCut` → `priceLeg(version-pinned; re-enters via door)` →
  `computeCertificate(entry+exit greeks)` → `checkResidual` → append via door. Chain and certificates
  live on the log; the workflow holds only the chain-head cursor. NAV/PnL = pure projection.
- **Re-mark cadence — Fork B (contractual-vs-system split).** End-of-day desk marks (system) →
  **Schedule sweep** choosing *which* units to re-mark; the pricing activity **reads the unit's
  node/frame/cut from the record (VM-2)**, so a mid-CA unit is never priced in a stale frame.
  Contractual/CA/input-moved re-marks → **per-unit watch** reading the node.
- **CA valuation sandwich (VM-9)**: before-mark + operator projection + after-mark + certificate, struck
  as a projection from the log (CAN-boundary safe). Residual within its **declared tolerances** (VM-9's
  three, VM-6) is the proof, **not an asserted ≈0**. Late resolved CA → retroactive sandwich at ex-date
  via the single writer's refold.
- **Three returned-value outcomes at three loci** (never a retryable error, never a saga):

  | Outcome | Locus / decider | Record |
  |---|---|---|
  | **Broken chain (VM-7)** | valuation **projection** (certificate) | residual over bound, staled leaf, **or β > this unit's tolerance** → named explain line + flag; open item |
  | **Gate fail / undecidable (MD-16)** | untrusted **gate activity** (construction-time) | refusal outcome; m\* never produced (prevention) |
  | **Door refusal (R-22)** | trusted **door** (admission-time) | structural / consistency-of-reference / auth / idempotence → blocked item |

- **Staleness (D4)**; **risk/backtest (VM-10/VM-11)**: a corrected leaf → refold → affected workflows
  **signalled to re-read**, re-derive **forward** under fresh `txid`s. Risk/backtest run the same recipe
  on **shifted** data in an isolated namespace against its own door; the shift is the recorded seed
  (MD-11); the strategy is itself a **unit** (C-10.2); equal production by recomputation, never a copy.

### 2.4 Production-vs-simulation seam (five-way predicate)
*Does a real production unit's valuation chain read it back?* **Yes** → **production lineage, tagged
derived stream, production door** (isolation is credential separation *within* the namespace — the
derivation queue holds no write credential, only the door does, R-18). **No** (scenario, backtest,
what-if) → **isolated namespace, own door** (R-20); only a final result re-enters production. MD-16's
"derived states never enter the base stream" is a **stream** boundary, not a namespace one.

## 3. Divergences + containment

**Determinism closure — three parts; the fused worker is unrepresentable.**
- **(Primary) compute/emit split — removes the race by construction.** `runModel` is one activity whose
  output Temporal memoizes; `proposeToDoor` is a *separate* activity whose **only input is that recorded
  output** — a typed boundary, so the "fused worker" that recomputes-and-proposes in one step (which
  would reopen the race) is **not representable** (CLAUDE.md §3). Retries re-present identical bytes; the
  only recompute window is a `runModel` crash before its result is recorded → exactly one value reaches
  the door (no race). The **content-hash diagnostic is deleted** — with the fused worker unrepresentable
  it guards nothing (referees' M2). Canonicality is **first-admission**, one rule; the substrate never
  compares two attempts' payloads.
- **(Scope boundary, one voice.)** Canonical-by-first-admission is the spec default — a **declared rule**,
  *not* MD-1 absorption (two differing payloads are not same-fact duplicates). Bit-reproducibility is
  **never** a door/admission precondition (out-of-scope numerics, C-Scope.11); the numerical-environment
  version is a **governance-optional Tier-2** dispute term caught at audit, never an admission gate.
- **(Value-level bound — CLOSED; locus seam folded.)** Read-back reproduces the recorded *bytes*, not
  proof the mark is within tolerance of an honest independent re-derivation: for a non-bit-reproducible
  model the recorded value is one arbitrary member of {P₁,P₂,…} with nothing bounding |Pᵢ−Pⱼ|; if that
  spread exceeds the consuming instrument's VM-6 tolerance, "reproduces bit-for-bit against the record"
  satisfies MD-14/VM-8 only trivially (against itself). Close it with a **producer-attested
  reproducibility class** in the lineage — a declared, recorded, versioned term carrying a bound **β**
  (one symbol; earlier drafts' ε_repro/τ/ε normalised to β), enforced at **two loci, not one:**
  - **Door — presence + structure only, model-free.** The door records whether the class field is
    *present* and the transaction structurally valid; it does **not** compare β to any tolerance — the
    tolerance is the *consuming* instrument's, not single-valued at admission (one surface β=3 bp feeds U₁
    at 5 bp and U₂ at 1 bp: dispute-ready for U₁, not U₂). A **missing** attestation is **admit-and-flag**
    (capture-then-classify, MD-2) — flagged "class-absent", never silently dropped, **never refused**
    (economic metadata is not envelope validity, so not the reserved "unresolvable structural reference").
  - **Consumption — the bound check as a VM-7 broken chain.** A consuming unit's valuation projection
    raises a **VM-7 broken chain** when β > *that* unit's VM-6 tolerance (or β absent/unbounded) — a
    recorded open item at the §2.3 locus, a *flag*, not an admission gate. The attestation is **untrusted**:
    a false β degrades to detection-at-audit (re-derivation reveals spread > β), repaired forward like a
    wrong contract (TA-REPRO). A′-consistent: admit + flag, never refuse.

| # | Divergence | Containment |
|---|---|---|
| D1/D2 | **Bare-read; model nondeterminism** vs replay. | Ingestion's only success is proposing an observation-recording transaction (a non-recording fetch is a no-op); models run in version-pinned activities (never workflow/local), output recorded, heavy runs heartbeat with bounded ScheduleToClose. |
| D3/D4/D5 | **Refold past-dated firings; staleness; history size.** | Past-dated synthesis is the single writer's work; on refold the unit re-reads and re-fires **forward** (see S1); staleness is a recorded fact read from the record; marks/states/verdicts live on the **log**, CAN every K (R-15), sim volume isolated. |
| D7 | **MD-16 prevention in an untrusted constructor.** | Decidable predicate → any party recomputes; prevention-at-construction + consumption-by-reference, detection-at-audit. No door privilege added. |
| D9/D10 | **Versioning (three axes); retry vs exactly-once admission.** | Orchestration = Build-ID (R-17); economics = ProductTerms + model/recipe/dynamic/gate-terms on the log, off workflow code. Exactly-once = cause-derived txid over recorded inputs (pinned key above), never a Temporal id. |
| D11/12/13 | **Queue/signal/timer time vs the fold; convention as worker config.** | Committed order = `(exec, door, hash)` at the door alone (R-25); timers carry no time authority (three times on the log). VM-5/VM-11 convention (invariant, π, D, ν) is a declared recorded term, never a worker default. |
| D14/15 | **Admission ≠ deterministic value; MD-16 write atomicity** (Fork A/A′). | Closed in the §3 centerpiece and §2.2: one transaction over one pinned cut; moved base **flags stale**, never refuses. |

---

## 4. Red-team R4

**S1 — mid-refold worker crash. Property REFOLD-ATOMIC (SURVIVES).** The refold is the **single
writer's** work (sec:substrate, sec:totalorder step c), append-only: it appends the recomputed tail
further down the log and **edits no byte**, so a **rewind is not representable** — (c) holds by
construction. A crash mid-refold leaves a partial appended tail; on recovery the single writer re-runs
from the last durable point. **(a) No duplication**: each appended transaction carries its cause-derived
`txid`; a re-proposed transaction whose txid already stands is committed zero further times (door dedup,
sec:txexec). **(b) No double past-dated firing**: a synthesised firing keys on `H(correction, watch,
occasion)` — constant under re-derivation — and the refold is a proven fixpoint (`prop_refoldIdempotent`:
refold twice = refold once). Temporal never emits a past-dated firing; on the re-read the unit re-fires
**forward** only under fresh ids, any duplicate deduped at the door. Witness: a fault generator crashing
the single writer at each tail position, asserting the recovered log equals the crash-free refold (Thm
refold-equals-timely) — must **fire** (zero firings = defect). This is what A′=FLAG rests on: staleness
is decided on a crash-atomic, idempotent, forward-only refold. **No defect.**

**S7 — namespace failover mid-gate. Property GATE-STATE-ATOMIC (SURVIVES).** State m\* and its passing
verdict cross the door as **one transaction over one pinned cut C** (Fork A); C is a recorded log-cursor
coordinate carried in the derivation request, not volatile state. **Failover before the commit lands**:
nothing is admitted; the failed-over worker rehydrates and re-runs `gate1(C)/gate2(C)/construct(C)` —
replay-deterministic pure functions of the pinned cut (MD-12: the base cannot move between gating and
construction) — recomputing the **identical** verdict and state, re-proposing the **same** `txid`; if the
pre-failover propose had committed, the door dedups, else this is the first admission. **Failover after
the commit**: the atomic {state, verdict} pair is on the log; the re-proposed txid dedups. Because state
and verdict are **one** transaction (Fork A killed the two-write pole), no log state holds a state lacking
its verdict or vice versa — **no ungated, no half-verdict state is nameable**; consumption-by-reference is
the backstop (an ungated state has no admission record, unnameable even if a buggy worker emitted one). A
correction admitted at ≤C during the failover is the A′ case (flag stale-forward), never an
ungated/half state. Witness: a failover injected at each point of `gate1/gate2/construct/propose`,
asserting the recovered log holds the whole pair or nothing, bit-for-bit vs the clean run — must
**fire**. **No defect.**

---

## 5. Open questions

- **Parking test exercised, empty.** Seams tested and already resolved: derived stream as a "second
  store" (no — one immutable-log mechanism on a tagged sub-stream, C-2.8/C-12.5); gate verdict vs
  recompute-on-read (C-4.11 — MD-16 argues it a pinned event-outcome); late-CA sandwich vs compensation
  (the reordering path). The live neighbour is the Valuation Manifesto's **PARK-1** (valuation storage);
  this design must **not** turn it on, and MD-16's existing mechanism neither reopens nor turns it on.
- **TA-REPRO (attestation truth) + numerical-environment retention (Tier-2, governance).** β bounds the
  spread *when truthful*; a false β is caught at audit by re-derivation — the perimeter status of the
  VM-6 tolerance itself. Retaining a pinned environment version bounds how far MD-14/VM-8 reaches
  (read-back always; bit-equal re-derivation only if retained); §3's bound already stops an
  unbounded-spread mark passing as dispute-ready regardless.
- **Load model (biggest unknown).** Volume per unit/underlying per day sizes `K`, the door pool,
  derived-stream storage. **Fork C** (models queue split) and **Fork D** (sim fan-out — child-workflows
  *inside* a sim namespace, *not* the seed's forbidden lineage-coupling use) gate on it and are
  non-correctness; do not force. Gate-2 "undecidable" on sparse history parks by design — a flagged
  blocked item, never retry-to-infinity.
