# Temporal as Execution Substrate for the WHOLE Framework — TEMPORAL-4, Round 4 (red-team)

Convergence is certified. R4 does exactly two things: **(JOB 1)** corrects the value-bound
placement in D16 and confirms the D14 content-hash is now a deletable diagnostic; **(JOB 2)**
red-teams the catalogue against the two crown-jewel scenarios (S1 mid-refold crash, S7 namespace
failover mid-gate). Neither attack breaks a row; each confirms a specific design choice is
load-bearing. Everything else stands as r3.

**Mapping table and decomposition §2.1–2.4 unchanged from r3**, with one delta folded in below:
the D16 value-bound check splits across two loci (door = presence; consumption = tolerance).

**Three record kinds** (load-bearing for D15/D16, naming an existing shape not a new primitive):
**kind-1** projection (recompute-on-read, never stale); **kind-2** re-entered observation (a
stored model number — stale on a consumed-input move, MD-8); **kind-3** recorded decision pinned
as-known (MD-16 gate verdict; the door's admit/refuse, spec l.1051 — not stale-on-input-move).

## 1. Divergence catalogue (D14 and D16 corrected; D1–D13, D15 as r3, condensed)

| # | Divergence | Containment |
|---|---|---|
| D1 | **Bare-read** vs activity I/O. | Every ingestion activity's only success is proposing an observation-recording transaction; a non-recording fetch is a retryable no-op, never consumed (§sec:obs-door). |
| D2 | **Model nondeterminism** vs replay. | Version-pinned activities (never workflow, never local); output recorded; model-eval and door-propose are **separate** (D14). Heavy runs heartbeat with bounded ScheduleToClose. |
| D3 | **Refold's past-dated firings** vs forward-only timers. | Past-dated synthesis is the single writer's work; on refold the unit is signalled-to-re-read, re-fires **forward** only; the late-CA sandwich rides this (see S1). |
| D4 | **Staleness** vs workflow state. | Staleness is a recorded fact; the projection selects latest non-superseded and carries the flag; orchestration only triggers forward re-derivation. |
| D5 | **History size** (chains, high-cadence marks, backtest fan-out). | Marks/states/verdicts live on the LEDGER log; ContinueAsNew every K, identifier triple only (R-15); derived-state volume isolated to sim namespaces. |
| D6 | **Undecidable / gate fail / refuse** vs retry-to-infinity. | A returned value (recorded event-outcome), not a retryable error — breaks the retry loop, a visible blocked item (R-22). |
| D7 | **MD-16 "prevention" in an untrusted constructor.** | Decidable predicate on a projection → any party recomputes it; prevention *at construction* + consumption-by-reference, detection *at audit* (ch15). No door privilege added. |
| D8 | **Workflow-code nondeterminism** (wall clock, RNG, map iteration, direct I/O, local activities). | Confined to activities; `workflow.Now` never fed to a contract or model; the three times come from the log (D12). |
| D9 | **Versioning — THREE axes.** | (a) orchestration = Worker/Build-ID (R-17); (b) contract economics = ProductTerms; (c) model/recipe/dynamic/gate-term versions on the log (MD-6, MD-16), bearing C-2.2, never touching workflow code. |
| D10 | **Retry vs exactly-once ADMISSION.** | The door's cause-derived txid over recorded inputs — `(input-cut, model/recipe-version, seed, env-version)`, never a Temporal run/attempt id. Dedup is optimisation, never load-bearing. |
| D11 | **Queue/signal/observation arrival order** vs the fold. | Committed order is the total order `(exec, door, hash)` at the door alone (R-25); a late observation refolds; a same-instant non-commuting pair is ordered by declared precedence or refused. |
| D12 | **Timer semantics vs the three times.** | Timers carry NO time authority; execution/monitor/door live on the log; a late-firing timer produces the identical transaction (C-3.7). |
| D13 | **Attribution/dispersion convention as worker config** (VM-5, VM-11 Σ). | The convention (held-invariant factor, π, D, ν) is a declared, recorded term read by the projection — never a worker default. |
| **D14** | **Exactly-once ADMISSION ≠ deterministic VALUE.** A non-bit-reproducible model (float non-associativity, GPU reduction order, solver optima) run at-least-once could present two payloads under one txid; a *fused* compute-and-propose activity that retries would recompute, so the canonical value would turn on a door-arrival race. | **Primary — compute/emit split (T-1/T-5):** model-eval and door-propose are SEPARATE activities. The model runs once; its output is the recorded activity result; door-propose re-presents those exact bytes, so retries never recompute and **only one payload reaches the door — the race is structurally REMOVED.** Canonical-by-first-admission is the spec floor (Tier-1 read-back, MD-14/VM-8). Bit-reproducibility is NEVER an admission precondition (C-Scope.11 — pole-(b), committee position). A pinned numerical-environment version is a governance-optional **Tier-2** term (T-5 §3c). **The r2 content-hash guard is now DEAD under the split — only one payload reaches the door, so a door-side compare structurally never fires (a zero-firings property). It is DELETABLE**, retained at most as an OPTIONAL diagnostic the trusted single writer MAY record for a buggy *fused* worker, never changing the canonical value (still first-admitted). **Actor boundary:** the substrate never compares payloads; the door may. |
| D15 | **MD-16 write atomicity + a base moved under the pinned cut** (Fork A / A′). | State + verdict cross the door as **ONE transaction over the one pinned cut** (MD-12); atomicity from the shared cut. A base moved under the cut **FLAGS m\* stale-forward** (kind-2, MD-8/10, single writer on refold) — **not refused** (the decision is kind-3, pinned as-known; C-11.3 is a structural consistency guard, not a freshness check; REFUSE livelocks — 90 s model, 45 s corrections). Refusal belongs ONLY to a gate fail/undecidable verdict or an unresolvable structural reference. |
| **D16** | **Read-back proves byte-reproducibility, not VALUE correctness.** For a non-bit-reproducible model the recorded value is one arbitrary member of `{P₁,P₂,…}`; nobody bounds `\|Pᵢ−Pⱼ\|`. If that spread exceeds the *consuming instrument's* VM-6 tolerance, a mark that "reproduces bit-for-bit against the record" is one no honest independent re-derivation would produce within tolerance — MD-14/VM-8 then guarantees the record's self-consistency, not the mark's correctness. | The producer attests a **reproducibility class** in the re-entered observation's lineage — a declared, recorded, versioned term (like the VM-5 convention) carrying **`ε_repro`**, a bound on `\|Pᵢ−Pⱼ\|` for that `(model-version, input-cut, numerical-environment)`. **Two loci (corrected from r3, which wrongly put the whole check at the door):** (1) at ADMISSION the DOOR checks only **PRESENCE + structural validity** of the attested class (present in lineage, well-formed, versioned) — a model-knowledge-free structural check; it *cannot* check `ε_repro ≤` tolerance because the VM-6 tolerance is the **consuming instrument's** and is ill-defined at the admission of a shared derived object (one surface, many consumers, each its own tolerance). (2) at CONSUMPTION the **`ε_repro ≤` the consuming instrument's VM-6 residual tolerance** comparison is a **VM-7 broken-chain check** (the valuation chain reading the surface as a leaf): `≤` ⇒ dispute-ready within tolerance; `>` tolerance or no attested class ⇒ a **broken chain**, surfaced as an open item (VM-7 locus), never a silent trivially-dispute-ready pass. **Pole-(b) preserved:** `ε_repro = 0` (bit-reproducible) is never *required*; a producer may attest `ε_repro > 0` and the consuming chain checks it. The attestation is untrusted: a false one degrades to detection-at-audit (re-derivation reveals spread > `ε_repro`), repaired forward like a wrong contract. Adequacy is a named trust assumption **TA-REPRO** (sibling of TA-KIND / VM-6 bound-adequacy): a too-loose `ε_repro` is versioned, auditable, counterparty-challengeable. |
| **S1** | **Mid-refold worker crash** (crown-jewel; §2). | REFOLD-ATOMIC — see §2. No row breaks; confirms the D3 boundary is load-bearing. |
| **S7** | **Namespace failover mid-gate** (crown-jewel; §2). | GATE-STATE-ATOMIC — see §2. No row breaks; confirms Fork A's one-transaction pole is load-bearing. |

## 2. Red-team R4

Both attacks are contained by **one invariant: the substrate holds no atomic state.** Every atomic
boundary — admission, refold, the gate write — is the LEDGER single writer's, keyed by cause-derived
txid, forward-only, append-only. A Temporal crash or namespace failover therefore degrades to at most
a liveness/latency incident (a lost re-read signal caught by the overdue-watch sweep), never wrong or
half state (R-21, generalized). Neither attack breaks a catalogue row; each confirms a load-bearing choice.

### S1 — mid-refold worker crash → REFOLD-ATOMIC
The refold runs in the single-writer service, NOT Temporal workflow code (D3). It is a deterministic,
idempotent (`prop_refoldIdempotent`), append-only recomputation of a pure function of the ordered log.
A crash mid-refold resumes **forward** from the nearest surviving snapshot — keyed by the stable
`(exec, door, hash)` triple, never an ordinal position (an interior insertion renumbers ordinals) —
re-deriving the same sort order and the same firing closure (`Lemma:closure` fixpoint). Already-committed
tail transactions and synthesised firings are absorbed by their cause-derived txid: **no double-fire,
no rewind.** Every refold-dependent row survives:
- **A′ FLAG** — the m\* staleness flag is a recomputed consequence of the ordered log, re-applied on
  resume (MD-8/MD-10); a lost re-read signal is backstopped by the overdue-watch sweep.
- **D3 past-dated synthesis** — synthesised firings key on `H(correction, watch, occasion)`, door time
  `⊤`, monitor null: record-derived and rerun-stable, so a crash re-derives identical firings.
- **D15 write atomicity** — the MD-16 transaction is all-or-nothing at the door (C-11.2); re-proposed
  under the same txid, absorbed if already committed.
- **Finding (contained):** atomicity is a LEDGER property, not Temporal's. IF the refold were driven
  from Temporal workflow state, a mid-refold workflow crash + replay could re-drive against a stale fold
  — the forbidden pattern (D3). Containment: the refold stays the single writer's; Temporal only re-reads
  forward. **The attack confirms the D3 boundary is safety-critical, not incidental.**

### S7 — namespace failover mid-gate → GATE-STATE-ATOMIC
State + verdict = ONE door transaction over ONE pinned cut (Fork A / D15). The gate activity is
replay-deterministic on the pinned cut (a recorded log cursor, not cluster state), so on the failover
cluster it re-runs against the SAME cut → the SAME verdict. The door is the external single writer,
independent of the Temporal namespace; the transaction is all-or-nothing (state + verdict commit
together or neither); a re-proposal is absorbed by cause-derived txid.
- **No ungated state** — a state exists only if its verdict committed atomically with it; **no
  half-verdict** — the verdict is atomic with the state; consumption-by-reference makes an un-admitted
  state **unnameable**.
- **Even active-active split-brain collapses to one admission** — two proposals with the same
  cause-derived txid → one admitted, one absorbed, at the single-writer door (R-18).
- **Finding (contained):** safety comes from Fork A's ONE-transaction pole. The losing two-write pole
  (verdict, then state) would let a failover *between* the two writes leave a recorded verdict with no
  state, or a state with no verdict — a nameable half-state. **The attack confirms Fork A's
  single-transaction pole is load-bearing for failover safety.**

## 3. Open questions (unchanged; no new park)
Parking exercised, empty (derived stream ≠ second store, C-2.8/C-12.5; gate verdict vs recompute-on-read
reconciled by MD-16 as a kind-3 pinned event-outcome; must NOT turn on Valuation-Manifesto PARK-1). The
one residual is **TA-REPRO adequacy** (D16): whether a producer's attested `ε_repro` is honest is a
governance/trust assumption caught by audit and counterparty challenge — the framework bounds the value
spread structurally (door presence-check + consumption VM-7 check) but cannot police the attestation's
truth from inside the boundary; a perimeter reconciliation, named not assumed. Load model remains the
biggest operational unknown (K, door/derivation pools); Forks C/D settled-soft, non-correctness.
