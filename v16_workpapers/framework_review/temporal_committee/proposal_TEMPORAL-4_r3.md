# Temporal as Execution Substrate for the WHOLE Framework — TEMPORAL-4, Round 3

Settled and not relitigated: the spine; Fork A (state + passing gate decision = ONE door
transaction over ONE pinned cut, MD-12); Fork B (contractual-vs-system re-mark split, and the
sweep's pricing activity reads node/frame/cut FROM THE RECORD, VM-2); Forks C/D (settled-soft);
the namespace seam (five-way on one predicate — does a real unit's chain read it back). The
determinism gap is closed two-tier, primary mechanism the **compute/emit split**.

**R3 corrects exactly three things in my catalogue; everything else stands.**
1. **D15 flips REFUSE → FLAG.** My r2 was wrong on two counts, both referees concurring and
   certified MD-16 (kleppmann_dyn_review l.15) adjudicating: (a) I misread **C-11.3**, which is a
   *structural* quantity/price-coordinate consistency guard (manifesto l.433; VM-9 phantom-
   valuation), NOT a tip-freshness check; (b) a base moved under the pinned cut stales the
   **state** (kind-2), it does not make the **decision** (kind-3, pinned as-known) meaningless —
   so the door does not refuse; the single writer flags m\* stale-forward on the refold
   (MD-8/MD-10). REFUSE also livelocks (a 90 s model re-pinned by 45 s corrections never converges).
2. **D14's content-hash is re-positioned** to an OPTIONAL door-side diagnostic for a buggy *fused*
   worker; the primary mechanism is the compute/emit split, under which only one payload ever
   reaches the door (the substrate never compares payloads).
3. **New row D16** closes FORMALIS's sharpest open item — nobody bounds the value spread |Pᵢ−Pⱼ|
   — with a producer-attested reproducibility class the door checks *structurally* against VM-6
   tolerance, keeping my pole-(b) C-Scope.11 ground.

**Three record kinds** (load-bearing for D15/D16, naming an existing shape not a new primitive,
per T-1): **kind-1** a projection (recompute-on-read, stores nothing); **kind-2** a re-entered
observation (a stored model number — stales on a consumed-input move, MD-8); **kind-3** a
recorded decision pinned as-known (the MD-16 gate verdict; the door's admit/refuse, spec l.1051)
— NOT stale-on-input-move, it decided against inputs as they then stood.

## 1. Mapping table (only the MD-16 row changes from r2, in **bold**)

| Framework object | Temporal construct | Note / register tie |
|---|---|---|
| The immutable log (book of record) | *nothing in Temporal* | disposable cache; never the log (R-02) |
| The Transaction Executor (the door) | ONE idempotent `admit/refuse` activity, sole write credential | the only write path (R-01, M6) |
| A smart contract | version-pinned, queue-routed activity (never workflow, never local) | economics off replay (R-06) |
| A unit | one long-lived workflow per `unitId` | node/watch mirror the ledger, rehydrated (R-03/04) |
| A watch | date → durable timer; condition → signal-driven eval | lifecycle on the log; timer = liveness half (R-08) |
| A transaction / move | proposed by an activity, admitted by the door | txid = cause-derived from recorded inputs (R-07) |
| A projection (kind-1) | read-only activity / Query | stores nothing |
| The total order and refold | the single writer's work; NOT Temporal | substrate re-fires FORWARD only (§sec:substrate) |
| ContinueAsNew | carries `{unitId, nodeId, log-cursor}` only | = cold rebuild-from-ledger (R-15) |
| Signal / signal-with-start | timing/reference only; fan-out to maybe-not-running units | branches stay in-workflow (R-11, R-14) |
| Child workflow | **not** for ledger-created units; split legs = new units, market-claim leg = branch | do not conflate split with ContinueAsNew (R-14) |
| An **observation** | ingestion activity → moveless observation-recording transaction through the ONE door | a non-recording fetch is the forbidden bare read (§sec:obs-door, D1) |
| The **market data operator** | projection computed at read; declared data on the log | never a workflow (C-9.2, MD-13) |
| A **derived object — projection kind (kind-1)** | read+compute activity, recomputes on read | stores nothing (MD-6) |
| A **derived object — re-entered observation (kind-2)** | version-pinned model activity + separate door-propose activity | staleness recorded; **value canonical by first admission via compute/emit split (D14)** |
| A **valuation mark** (chain link, kind-2) | model activity + door re-entry | chain/NAV = projection (VM-1/3) |
| A **PnL explain certificate** | projection over two marks | residual bound = declared log term (VM-4/6) |
| A **CA valuation sandwich** | two model activities + operator projection + certificate, in the unit's workflow | late CA = refold + forward re-read (D3) (VM-9) |
| An **MD-16 derived state `m*` (kind-2) + its gate decision (kind-3)** | construct + two-gate predicate activities; **state AND decision cross the door in ONE transaction over ONE pinned cut** | **prevention at construction, detection at audit (D7); a base moved under the cut FLAGS m\* stale-forward, never refused (D15); value spread bounded by attested class (D16)** (MD-16, MD-12) |
| A **production-serving** derived object | PRODUCTION lineage, tagged derived stream, PRODUCTION door | credential separation within the namespace (R-18) |
| A **simulation** derived state | ISOLATED namespace, own lineage's door | never the production door (R-20) |
| Temporal Schedules | system cadence only (EoD marks, overdue-watch/stale-fit sweeps) | contractual/graph re-marks are per-unit watches (R-09) |

## 2. Decomposition (only the MD-16 write paragraph changes; Fork B unchanged from r2)

### 2.1 Ledger — unchanged (seed R-03/05/06/14). Fan-out by signal-with-start; market-claim leg
is a branch (same workflow), partial-split legs are new units. Settlement failure re-enters as a
recorded event walking the settlement-obligation unit's graph — never a Temporal saga.

### 2.2 Market data
- **Ingestion**: capture activity's only success is proposing an observation-recording
  transaction through the one door; a fetch recording nothing is a retryable no-op (D1).
- **Derived objects**: projection kind → read activity; re-entered kind → **compute/emit split**
  (a version-pinned model activity computes once and its output is the recorded result; a
  *separate* door-propose activity re-presents those exact bytes — never fuse the two, D14).
  Staleness on input correction is a recorded flag (MD-8/10); re-derivation is forward (D4).
- **MD-16 gates (Fork A settled + A′ corrected)**: one `apply-dynamic` activity constructs `m*`
  from an admissible base pinned at a single cut; one `gate` activity evaluates Gate 1
  (no-arbitrage `m* ∈ Θ_AF`) and Gate 2 (realism: per-functional/per-underlying percentiles vs the
  underlying's own as-known history, joint where marginals would hide an inversion). On pass, **the
  derived state (kind-2) and the gate decision (kind-3) cross the door as ONE transaction over that
  one cut** (MD-12) — atomicity from the shared pinned cut, no inconsistent-read window. **If a
  correction to a consumed input is admitted at ≤ the pinned cut between pin and door-admit, m\*
  admits as the as-known-at-cut value it was gated as and the single writer flags it stale-forward
  on the refold (MD-8/MD-10) — it is NOT refused** (the decision is kind-3, pinned as-known; only
  the state is kind-2, staleable; C-11.3 is a structural consistency guard, not a freshness check;
  and REFUSE would livelock under periodic corrections). Refusal is reserved for a **gate
  fail/undecidable verdict** (the gate decides) or an **unresolvable structural reference** (the
  door decides). Optional, never load-bearing: a producer-side freshness pre-check (re-read the tip
  before proposing; skip and re-pin if already superseded) — the flag path catches any born-stale
  state that races through. Consumers name a derived state by its admission record.

### 2.3 Valuation — unchanged from r2. Marks/chain/certificate as above; **re-mark cadence
splits** by the spec's contractual-vs-system axis: EoD desk marks → a Schedule sweep dispatching
record-reading pricing activities (the sweep chooses *which* units; the pricing activity always
reads node/frame/cut FROM THE RECORD, VM-2, so a mid-CA unit is never priced in a stale frame);
contractual/graph-triggered or input-moved re-marks → per-unit watches. Backtests/risk in isolated
namespaces (R-20); marks re-enter the derived path's own record.

### 2.4 The production-vs-simulation seam — unchanged (pinned). "Derived stream" ≠ "isolated
namespace": a real unit's chain reading it back ⇒ production lineage, production door, tagged
derived (R-18); a hypothetical ⇒ isolated namespace, own door (R-20).

## 3. Divergences and containments (**D14 re-positioned, D15 flipped, D16 new**; rest as r2)

| # | Divergence | Containment |
|---|---|---|
| D1 | **Bare-read prohibition vs activity I/O.** A fetch that records nothing is the forbidden bare read (§sec:obs-door). | Every ingestion activity's only success is proposing an observation-recording transaction; read activities read the record, never a live feed. A non-recording fetch is a retryable no-op, never consumed. |
| D2 | **Model non-determinism vs replay.** Pricing/calibration is float/solver/seed-dependent; in workflow code it is a non-determinism error. | Model runs are version-pinned activities (never workflow, never local); output RECORDED. Replay reads the recorded result. Model-eval and door-propose are **separate** activities (D14). |
| D3 | **Refold's past-dated synthesised firings vs forward-only timers** (§sec:totalorder step c). | Past-dated synthesis is the SINGLE WRITER's work. On refold the unit workflow is signalled-to-re-read, rehydrates, and re-fires FORWARD only; never rewinds. The late-CA sandwich rides this path. |
| D4 | **Staleness propagation vs workflow state** (MD-8, VM-7). | Staleness is a recorded fact; the projection selects latest non-superseded and carries the flag. Orchestration only triggers forward re-derivation. |
| D5 | **History size** — long chains, high-cadence marks, backtest fan-out. | Marks live on the LEDGER log; Temporal holds only cadence orchestration. ContinueAsNew every K firings, identifier triple only (R-15). |
| D6 | **Undecidable / gate fail / refuse vs retry-to-infinity.** | A returned value (recorded event-outcome), not a retryable error — breaks the retry loop, stands as a visible blocked item (R-22). |
| D7 | **MD-16 "prevention" in an untrusted constructor.** Gate 1 is prevention, but the door checks no arbitrage (C-13.2). | The gate is a decidable predicate on a projection, so any party recomputes it: a mis-gate degrades to a **detectable, forward-repaired defect, as an economically-wrong contract does**. Prevention *at construction*; detection *at audit*. No new admission privilege. |
| D8 | **Workflow-code nondeterminism** — wall clock, randomness, unordered-map iteration, direct I/O, local activities. | Confined to activities; `workflow.Now` never fed to a contract or model; the three times come from the log (D12). |
| D9 | **Versioning — THREE axes.** | (a) orchestration = Worker/Build-ID (R-17); (b) contract economics = ProductTerms on the log; (c) model/recipe/dynamic/gate-declared-term versions on the log (MD-6, MD-16), bearing C-2.2, never touching workflow code. |
| D10 | **Retry vs exactly-once ADMISSION.** Activities are at-least-once. | The door's cause-derived txid over **recorded inputs — the `(input-cut, model/recipe-version)` identity, never a Temporal run/attempt id**. Temporal dedup is optimisation, never load-bearing. |
| D11 | **Queue/signal/observation arrival order vs the fold.** | Arrival order is orchestration sequencing only; committed order is the total order `(exec, door, hash)` at the door alone (R-25). A late observation refolds; a same-instant non-commuting pair is ordered by declared precedence or refused. |
| D12 | **Timer semantics vs the three times.** | Timers carry NO time authority; execution/monitor/door live on the log; the substrate's clock orders nothing. A late-firing timer produces the identical transaction (C-3.7). |
| D13 | **Attribution/dispersion convention as worker config** (VM-5, VM-11 Σ). | The convention (held-invariant factor, partition π, dispersion D, normalisation ν) is a declared, recorded term read by the projection — never a worker default; else two workers disagree. |
| **D14** | **Exactly-once ADMISSION ≠ deterministic VALUE.** A non-bit-reproducible model (float non-associativity, GPU reduction order, solver optima) run at-least-once could present two payloads under the same txid; a *fused* compute-and-propose activity that retries recomputes, so the canonical value would turn on a door-arrival race. | **Primary — compute/emit split (adopt T-1/T-5):** model-eval and door-propose are separate activities. The model runs once; its output is the recorded activity result (memoized in history); the door-propose activity re-presents those exact bytes, so retries never recompute and **only one payload ever reaches the door — the race is structurally REMOVED, not reduced.** Canonical-by-first-admission is the spec floor (Tier-1 read-back, discharging MD-14/VM-8). **Bit-reproducibility is NEVER an admission precondition** — that would pull model+numerical-environment governance into scope, which C-Scope.11 forbids (my pole-(b), the committee position). A pinned **numerical-environment version** in lineage is a governance-optional **Tier-2** re-derivation term (adopt T-5 §3c). **Actor boundary (re-positions r2's guard):** the *substrate* never compares payloads; the *door* (trusted single writer) MAY record a **content-hash beside the txid** as an OPTIONAL diagnostic — meaningful only for a buggy worker that violated the split by fusing eval with propose — and it never changes which value is canonical (still first-admitted). |
| D15 | **MD-16 write atomicity + a base moved under the pinned cut** (Fork A / A′). | Derived state + gate decision cross the door as **ONE transaction over the one pinned cut** (MD-12); atomicity from the shared cut. **A base moved under the cut FLAGS m\* stale-forward** (kind-2, MD-8/MD-10, single writer on refold) — **not refused**: the decision is kind-3, pinned as-known; C-11.3 is a structural consistency guard, not a freshness check; and REFUSE livelocks (90 s model, 45 s corrections). Refusal belongs ONLY to a gate fail/undecidable verdict or an unresolvable structural reference. |
| **D16** | **Read-back proves byte-reproducibility, not VALUE correctness.** For a non-bit-reproducible model the recorded value is one arbitrary member of `{P₁,P₂,…}`; nobody bounds `|Pᵢ−Pⱼ|`. If that spread can exceed the VM-6 residual tolerance, a mark that "reproduces bit-for-bit against the record" is one no honest independent re-derivation would produce within tolerance — MD-14/VM-8 then guarantees the record's self-consistency, not the mark's correctness. | The door cannot check numerics (C-Scope.11). So the **producer attests a reproducibility class** in the re-entered observation's lineage — a declared, recorded term (like the model version, MD-6) asserting a bound `β` on `|Pᵢ−Pⱼ|` for that `(model-version, input-cut, numerical-environment)`. The **door checks a STRUCTURAL predicate — `β ≤ τ`, the consuming unit's declared VM-6 tolerance** — comparing two declared numbers on the record, holding no model knowledge (as it checks any declared-term lineage). `β ≤ τ` (or `β=0`, a bit-reproducible producer) ⇒ dispute-ready within tolerance; `β > τ` or no attestation ⇒ admissible only OUTSIDE the certified/dispute-ready set, surfaced like a too-loose VM-6 bound or a VM-7 broken chain, never silently passed. **Pole-(b) preserved:** `β=0` is never *required*; a producer may attest `β>0` and the door checks it structurally. The attestation's adequacy is a named trust assumption **TA-REPRO** (sibling of TA-KIND and VM-6 bound-adequacy): a too-loose `β` is versioned, auditable, counterparty-challengeable, never hidden. |

**Task-queue families.** Seed's five plus a **derivation/models** family (SOFT, Fork C —
load-model scaling, not architecture; I do not commit). Simulation namespaces mirror these
against their own door.

## 4. Open questions (parking EXERCISED, not asserted empty)

1. **Constitutional seams tested — no new park.** (i) derived stream as a "second store" — no,
   same immutable-log mechanism on a distinct lineage (C-2.8, C-12.5); (ii) storing a gate
   decision vs recompute-on-read (C-4.11) — MD-16 reconciles it as a pinned as-known event-outcome
   (kind-3), and this design must NOT turn on the Valuation Manifesto's **PARK-1**: mark and
   gate-decision recording ride the existing re-entered-observation mechanism, which MD-16
   "neither reopens nor turns on"; (iii) MD-16 prevention vs capture-then-classify — contained in
   D7. (T2's exercised-index discipline.)
2. **Load model (biggest unknown).** Event + mark + derived-state volume per unit/underlying per
   day sizes K, the door pool, the derivation pool, the sim-namespace door. Forks C/D gate on it,
   both explicitly non-correctness.
3. **TA-REPRO adequacy (the D16 residual).** Whether a producer's attested reproducibility class
   is honest is a governance/trust assumption, caught by audit and counterparty challenge — the
   sibling of TA-KIND. The framework bounds the value spread structurally (D16) but cannot police
   the attestation's truth from inside the boundary; that is a perimeter reconciliation, named not
   assumed. Routing the exact C-11.3-vs-MD-8 and VM-6-vs-TA-REPRO clause readings to
   CONCORDIA/FORMALIS for a certifying signature (the A′ answer is already on record via MD-16).
