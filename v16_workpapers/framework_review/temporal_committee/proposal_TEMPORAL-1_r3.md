# Temporal Committee — Proposal TEMPORAL-1, Round 3 (consensus-candidate mapping assembly)

**Stance.** This is the assembly: the mapping on **three record kinds + one lineage discipline**,
the divergence catalogue on TEMPORAL-4's rows, with every settled fork folded in and the two live
items (Fork A′, the value-level determinism bound) resolved. The three record kinds:
1. **Projection** — stores nothing, recompute-on-read, *never stale* (NAV, PnL, the valuation chain
   as assembled, the market data operator, settlement instructions).
2. **Re-entered observation** — a model output stored as a fact; read-back unconditional; *stale when
   a consumed input moves* (MD-8), superseded forward (a mark, a greek, a fitted surface).
3. **Recorded decision, pinned as-known** — a verdict recorded with the event it decides; *not
   recompute-on-read, not stale-on-input-move*. Not a new primitive: the base ledger already has it as
   the door's admit/refuse (spec l.1051); the MD-16 gate verdict is the same shape.

Lineage discipline: cause-derived `txid` over **recorded inputs**, pinned **cut**, forward-only
refold. Resolved positions carried committee-wide: **Fork A** single-transaction write; **Fork A′**
FLAG (§2.2); **Fork B** contractual-vs-system split; **determinism** = compute/emit split (primary) +
numerical-environment pin (Tier-2) + content-hash diagnostic (optional), actor boundary stated;
**scope boundary one voice**; **value-level bound** closed by a producer-attested reproducibility class
(all §3). Acceptance test: strip Temporal, rebuild chain + derived states + gate verdicts from the log (R-02).

---

## 1. Mapping table

| Temporal primitive | Framework correspondence (ledger / market data / valuation) |
|---|---|
| **Workflow** | One long-lived **unit** workflow per `unitId` walking the product graph (R-03). Derived-object builds, MD-16 dynamic applications, and valuation-chain links are sequences it (or a derived-lineage workflow) runs — no new workflow *kind*. |
| **Activity** | Every side effect: `captureArrival` (envelope-first through the door), `readCut`, `runModel` (version-pinned), `proposeToDoor`, `applyOperator`, `computeCertificate`, `checkResidual`, `gate1_noArb`, `gate2_realism`. Operator/NAV/PnL/certificate/settlement are pure read-time **projection** activities. A read that records nothing is the forbidden **bare read** (§sec:obs-door, D1) — a retryable no-op, never consumed. |
| **Signal / signal-with-start** | Timing + reference only (R-11, M4): watch satisfaction, CA cascade fan-out, "re-read: the fold moved" (sec:substrate). Ledger-created units start their own; **graph branches stay in-workflow** (market-claim leg = branch → same workflow; partial-split legs = new units → own workflows — **do not conflate split with ContinueAsNew**, R-14). |
| **Query** | Non-authoritative liveness view (R-13). A **dispute** (VM-8/MD-14) is a *replay* — read-only re-derivation from the log. |
| **Continue-as-new** | History-size control; carries `{unitId\|lineageId, nodeId, cut}` only (R-15). Chain, derived states, gate verdicts live on the log and rehydrate. |
| **Durable timer** | Date-**watch** liveness half only (R-08). Ex-date/due-date/frame boundary are the *recorded* event's **execution time**, read back as data; the timer authors none of the three times. |
| **Schedule** | System cadence only (R-09): end-of-day desk marks, overdue-watch and stale-fit sweeps. Never a per-unit contractual date. |
| **Namespace** | Two orthogonal separations (§2.4): **base vs derived stream** = tagged sub-streams of one **production** lineage, **same door**; **production vs simulation** = isolated namespaces, each its **own door** (R-18/R-20). |
| **Task queue** | Split by trust/scaling (R-18): door (sole write credential), contracts, ingestion, unit-orchestration, settlement; a **models/derivation** family is a soft sixth (§4). Search attributes are an ops projection reconciled to the log, never authoritative (R-19). |
| **Worker Versioning / Build-ID** | Orchestration axis only (R-17). **Three** economics axes on the log, off Temporal's surface: ProductTerms (contract); model/recipe (re-entered obs); dynamic/gate declared-terms (MD-16). |

**Idempotence key (committee-wide).** Every re-entry dedupes via the door's `txid` on recorded
`(input-cut, model/recipe-version, seed, numerical-environment-version)` — **never** a Temporal run/attempt id; at-least-once → exactly-once *admission*.

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
  envelope-first (R-12). No second door; absorption is the door's cause-derived-id job at the
  registered grain.
- **Derived object — projection kind** (discount factor, operator-adjusted value): pure read-time
  activity, recomputed on read (MD-6/MD-8).
- **Derived object — re-entered kind** (fitted surface, filter): `readCut` → `runModel(version-pinned;
  seed + environment recorded)` → `proposeToDoor`. The ledger runs no model (C-14.9/V1); output
  re-enters with complete lineage. Staleness on input correction is a **recorded flag** (MD-8),
  re-derivation forward.
- **MD-16 dynamic application — Fork A (single transaction).** `pinCut(C)` (one application cut) →
  `gate1_noArb(C)` + `gate2_realism(C, as-known history)` + `constructState(C)` all over the **one
  pinned cut** (MD-12) → **state and its passing gate verdict cross the door as ONE transaction**
  (never record-pass-then-construct). No window where an ungated state exists. Fail/undecidable → the
  **refusal** is recorded, no state admitted (prevention). Consumers name a state by its admission
  record; an ungated state is unnameable.
- **Fork A′ (base moved under the pinned cut, between pinCut and admit) = FLAG** (committee wording,
  certified upstream). A later correction to a consumed input does **not** create a TOCTOU and does
  **not** refuse: it **flags m\* stale-forward** (MD-8/MD-10), m\* remaining the **as-known-at-cut value
  it was gated as** — the **single writer** decides this on the refold, not the door, not the gate. By
  the taxonomy the m\* *state* is kind-2 (stales on consumed-input move) and the *decision* is kind-3
  (pinned as-known, never stale); REFUSE conflates them. C-11.3 is a **structural** guard (auth,
  idempotence, consistency-of-reference, writer-discipline; VM-9 phantom-valuation), **not** a
  tip-freshness check — "refuse on stale cut (C-11.3)" misreads it. **Refuse is reserved for a gate
  fail/undecidable verdict (gate decides) or an unresolvable structural reference (door decides) —
  never a fresher tip.** *Livelock proof:* a 90 s calibration pins C at t=0, a correction at ≤C admits
  at t=45 s; under REFUSE the door re-pins and re-runs the 90 s model, and with corrections every 45 s
  **never converges**; FLAG admits and flags for forward re-derivation — progress guaranteed.
- **MD-16 prevention placement — derived, not asserted.** Gate 1 (`m*∈Θ_AF`) is decidable but needs
  **model/product knowledge** (the arbitrage-free set), which the door must not hold (generic
  machinery, product-knowledge-free, spec l.917). So Gate 1 runs in a version-pinned gate activity like
  a contract; the door enforces the generic decidable invariants and commits verdict-and-state
  atomically. A mis-gate degrades to detection-at-audit (ch15), like an economically-wrong contract.
- **Corporate action / operator**: CA = first-class recorded transaction; the operator = read-time
  projection (never stored, original never overwritten, MD-13/B4). Late/corrected CA → refold + re-read.

### 2.3 Valuation
- **Chain link (VM-1/VM-3)**: `readCut` → `priceLeg(version-pinned; re-enters via door)` →
  `computeCertificate(entry+exit greeks)` → `checkResidual` → append via door. Chain and certificates
  live on the log; the workflow holds only the chain-head cursor. NAV/PnL = pure projection; one recipe
  serves risk (VM-10), so risk and books cannot disagree.
- **Re-mark cadence — Fork B (split by contractual-vs-system axis).** End-of-day desk marks (system) →
  **Schedule sweep** that chooses *which* units to re-mark; the pricing activity **reads the unit's
  node/frame/cut from the record (VM-2)**, so a mid-CA unit is never priced in a stale frame. No
  per-unit state on the sweep. Contractual/CA/input-moved re-marks (ex-date sandwich node; a corrected
  leaf staling a link) → **per-unit watch** reading the node.
- **CA valuation sandwich (VM-9)**: before-mark (old frame) + operator projection + after-mark (new
  frame) + certificate; struck as a projection from the log (CAN-boundary safe). The residual within
  its **declared tolerances** — minor-unit rounding once at read, the convention's rounding, any
  re-derived surface's calibration tolerance (VM-9's three, VM-6) — is the proof; **not an asserted
  ≈0**. Late resolved CA → retroactive sandwich at ex-date via the single writer's refold.
- **Three returned-value outcomes at three loci** (never a retryable error, never a saga):

  | Outcome | Locus / decider | Record |
  |---|---|---|
  | **Broken chain (VM-7)** | the valuation **projection** (certificate) | residual over bound / staled leaf → named explain line + staleness flag; open item |
  | **Gate fail / undecidable (MD-16)** | the untrusted **gate activity** (construction-time) | refusal outcome; m\* never produced (prevention) |
  | **Door refusal (R-22)** | the trusted **door** (admission-time) | structural / consistency-of-reference / auth / idempotence → blocked item |

- **Staleness propagation**: corrected leaf → refold (single writer) → affected valuation workflows
  **signalled to re-read**, re-derive **forward** under fresh `txid`s (sec:substrate); staleness read
  from the record, never held in workflow memory.
- **Risk/backtest (VM-10/VM-11)**: same recipe on **shifted** data in an isolated namespace against its
  own door; the **shift** is the recorded seed (MD-11); the strategy is itself a **unit** (C-10.2).
  Simulated re-entries enter the simulated path's own record; equal production by recomputation.

### 2.4 Production-vs-simulation seam (pinned, five-way predicate)
Discriminator: *does a real production unit's valuation chain read it back?* **Yes** (today's
calibrated surface serving a real mark; a production MD-16 state a real limit consumes) → **production
lineage, tagged derived stream, production door**; isolation is credential separation *within* the
namespace (the derivation queue holds no write credential; only the door does, R-18). **No**
(scenario, backtest, what-if) → **isolated namespace, own door** (R-20); only a final result re-enters
production as an observation. "Derived states never enter the base stream" (MD-16) is a **stream**
boundary, not a namespace one; credential separation follows the production/simulation boundary.

---

## 3. Divergences + containment

**Determinism closure — the round's centerpiece, four composable parts with the actor boundary stated.**
- **(Primary) compute/emit split — removes the race, not merely reduces it.** `runModel` is one
  activity whose output Temporal memoizes in history; `proposeToDoor(recordedResult)` is a *separate*
  downstream activity re-presenting the recorded bytes under the txid. Every propose-retry carries
  identical bytes → the door absorbs with **no competing candidate**. The only recompute window is a
  `runModel` crash *before* Temporal records it → exactly **one** value reaches the door (no race).
  **Never fuse model-eval with door-propose.**
- **(Scope boundary, one voice.)** Canonical-by-first-admission is the spec default — a **declared
  rule**, *not* MD-1 absorption (two differing payloads are not same-fact duplicates at grain, so
  first-wins is a fiat, stated as one). Bit-reproducibility is **never** a door/admission precondition
  (out-of-scope numerics, C-Scope.11). The **numerical-environment version** pin is a
  **governance-optional Tier-2** dispute-readiness term, caught at audit — never an admission gate.
  Guard against §1-narrowing: dispute-readiness must not quietly become an admission gate.
- **(Value-level bound — FORMALIS's sharpest open item, CLOSED.)** Read-back reproduces the recorded
  *bytes*, not proof the mark is within VM-6 tolerance of an honest independent re-derivation: for a
  non-bit-reproducible model the recorded value is one arbitrary member of {P₁,P₂,…} with nothing
  bounding |Pᵢ−Pⱼ|; if that spread exceeds VM-6 tolerance, "reproduces bit-for-bit against the record"
  satisfies MD-14/VM-8 only trivially (against itself). Close it with a **producer-attested
  reproducibility class** in the lineage (a declared, recorded, versioned term, like the VM-5
  convention). Admission as a **dispute-ready** mark requires a **model-knowledge-free door predicate**:
  the attested bound `ε_repro` ≤ the instrument's declared VM-6 residual tolerance — the door compares
  two *recorded numbers*, no numerics, exactly as consistency-of-reference compares coordinates
  (bit-exact ε=0 trivially passes). A class the producer cannot bound, or `ε_repro > VM-6`, is admitted
  (canonical-by-first) but **flagged uncertifiable-for-dispute** (VM-7 locus), never a silent
  trivially-dispute-ready pass. The attestation is **untrusted**: a false one degrades to
  detection-at-audit (re-derivation reveals spread > `ε_repro`), repaired forward like a wrong contract.
  This ties the admissible re-entry-value spread to VM-6 **without** the door reaching into out-of-scope
  numerics.
- **(Actor boundary.)** The **substrate** never compares two attempts' payloads; the **door** *may*
  record a content-hash beside the txid — flagging an absorbed redelivery whose payload differs as
  "model-non-reproducible" (closing MD-1's over-coarse-absorption residual) — **without** changing which
  value is canonical (still first-admitted). "Never compare" (substrate) and "record a content-hash"
  (door) are different actors, not a contradiction.

| # | Divergence | Containment |
|---|---|---|
| D1 | **Bare-read** vs activity I/O. | Every ingestion activity's only success is proposing an observation-recording transaction; a non-recording fetch is a retryable no-op, never consumed (§sec:obs-door). |
| D2 | **Model nondeterminism** vs replay. | Version-pinned activities (never workflow, never local); output recorded; heavy runs heartbeat with bounded ScheduleToClose so retry fires only on genuine failure. |
| D3 | **Refold's past-dated firings** vs forward-only timers. | Past-dated synthesis is the single writer's work; on refold the unit is signalled-to-re-read, re-fires **forward** only; the late-CA sandwich rides this. |
| D4 | **Staleness** vs workflow state. | Staleness is a recorded fact; the projection "current fit" selects latest non-superseded and carries the flag; orchestration only triggers forward re-derivation. |
| D5 | **History size** (chains, high-cadence marks, backtest fan-out). | Marks/states/verdicts live on the **log**; CAN every K, triple only (R-15); derived-state volume isolated to sim namespaces. |
| D7 | **MD-16 prevention in an untrusted constructor.** | Decidable predicate → any party recomputes it; prevention-at-construction + consumption-by-reference, detection-at-audit (ch15). No door privilege added. |
| D9 | **Versioning — three axes.** | Orchestration = Build-ID (R-17); contract economics = ProductTerms; model/recipe/dynamic/gate-terms on the log — pinned per derived object, bearing C-2.2, never touching workflow code. |
| D10 | **Retry vs exactly-once admission.** | Cause-derived txid over recorded inputs — the `(input-cut, model/recipe-version, seed, env-version)` identity, never a Temporal run/attempt id. Dedup is optimisation, never load-bearing. |
| D11/D12 | **Queue/signal/timer time vs the fold** (order is meaning, MD-5). | Committed order = total order `(exec, door, hash)` at the door alone (R-25); timers carry no time authority (the three times live on the log); a late observation or late-firing timer refolds / yields the identical transaction. |
| D13 | **Attribution/dispersion convention as worker config** (VM-5, VM-11 Σ). | The convention (held-invariant factor, π, D, ν) is a declared, recorded term read by the projection — never a worker default. |
| D14/D15 | **Admission ≠ deterministic value; MD-16 write atomicity** (Fork A/A′). | Closed in the §3 centerpiece (compute/emit split, canonical-by-first, `ε_repro`≤VM-6) and §2.2 (state+verdict as one transaction over one pinned cut, MD-12; moved base **flags stale**, never refuses). |

---

## 4. Open questions

- **Parking test exercised, empty.** Seams tested: (i) derived stream as a "second store" — no, same
  immutable-log mechanism on a tagged sub-stream / distinct lineage (C-2.8, C-12.5); (ii) storing a
  gate verdict vs recompute-on-read (C-4.11) — MD-16 argues it a pinned event-outcome, not a live
  projection; (iii) late-CA sandwich vs compensation — the reordering path. The live neighbour is the
  Valuation Manifesto's **PARK-1** (valuation storage); this design must **not** turn it on —
  gate-verdict and chain-link recording ride the existing re-entered-observation/decision mechanism,
  which MD-16 states neither reopens nor turns on. Empty index, *exercised*.
- **Numerical-environment retention (Tier-2, governance).** Retaining a pinned environment version
  bounds how far MD-14/VM-8 dispute-readiness reaches (read-back always; bit-equal re-derivation only
  if retained) — a governance decision, not a substrate one; the value-level bound (§3) already stops
  an unbounded-spread mark passing as dispute-ready regardless.
- **Load model (biggest unknown, MEDIUM on constants).** Event + mark + derived-state volume per
  unit/underlying per day sizes `K`, the door pool, and derived-stream storage. **Fork C** (models
  queue split) and **Fork D** (sim fan-out shape — child-workflows *inside* a sim namespace for
  history-bounding, *not* the seed's forbidden lineage-coupling use) both gate on it and are explicitly
  non-correctness; do not force. Gate-2 "undecidable" on sparse joint history parks by design
  (prevention) — a flagged blocked item, never retry-to-infinity; a sweep may pre-compute joint-history
  sufficiency so risk runs fail fast.
