# Temporal as Execution Substrate for the WHOLE Framework — TEMPORAL-4, Round 5 (red-team S4)

R5 corrects the two idempotence rows the referees flagged on my file, unifies the symbol,
adds the coverage-totality obligation the value-bound move created, and red-teams the retry
storm (S4). Everything else stands as r4.

**Corrections (both referees):** (1) **D10** — my r4 "dedup is optimisation, never load-bearing"
was WRONG; S1/S7/S4 all rely on the door's txid dedup, so it is **load-bearing, by construction**.
(2) **Idempotence key** pinned to T-1's canonical form `(input-cut, model-version,
recipe/dynamic-version, seed)` — **env-version is OUT of the key** (r4 had it IN and dropped
dynamic-version; both wrong). (3) **One symbol:** `ε_repro → β` everywhere (CLAUDE.md §1, no
synonyms). (4) **D14 content-hash** cleanly DELETED (fused worker unrepresentable by type),
matching T-1 — not "retained as a diagnostic." (5) **D16 door verb** = *records whether present*
(admit-and-flag, never refuse-on-absent). (6) New **COVERAGE** and **S4** rows.

**Mapping table and decomposition §2.1–2.4 unchanged from r4** except the idempotence-key line
(D10) and the `β` rename. **Three record kinds** unchanged (kind-1 projection; kind-2 re-entered
observation, stale-on-consumed-input-move; kind-3 recorded decision pinned as-known).

## 1. Divergence catalogue (D10/D14/D16 corrected; COVERAGE + S4 new; rest condensed as r4)

| # | Divergence | Containment |
|---|---|---|
| D1 | **Bare-read** vs activity I/O. | Ingestion activity's only success is proposing an observation-recording transaction; a non-recording fetch is a retryable no-op (§sec:obs-door). |
| D2 | **Model nondeterminism** vs replay. | Version-pinned activities (never workflow/local); output recorded; model-eval and door-propose are **separate** (D14). Heavy runs heartbeat with bounded ScheduleToClose. |
| D3 | **Refold's past-dated firings** vs forward-only timers. | Past-dated synthesis is the single writer's work; on refold the unit is signalled-to-re-read, re-fires **forward** only (§sec:substrate; see S1). |
| D4 | **Staleness** vs workflow state. | Staleness is a recorded fact; the projection selects latest non-superseded, carries the flag; orchestration only triggers forward re-derivation. |
| D5 | **History size.** | Marks/states/verdicts live on the LEDGER log; ContinueAsNew every K, identifier triple only (R-15); derived-state volume isolated to sim namespaces. |
| D6 | **Undecidable / gate fail / refuse** vs retry-to-infinity. | A returned value, not a retryable error — breaks the retry loop, a visible blocked item (R-22). |
| D7 | **MD-16 "prevention" in an untrusted constructor.** | Decidable predicate on a projection → any party recomputes it; prevention at construction + detection at audit (ch15). No door privilege added. |
| D8 | **Workflow-code nondeterminism.** | Confined to activities; `workflow.Now` never fed a contract/model; the three times come from the log (D12). |
| D9 | **Versioning — THREE axes.** | Orchestration = Build-ID (R-17); contract economics = ProductTerms; model/recipe/dynamic/gate-term versions on the log — bearing C-2.2, never touching workflow code. Axis non-leak is by-construction (a deploy changes only orchestration). |
| **D10** | **Retry vs exactly-once ADMISSION — and is the door's dedup load-bearing?** | **Load-bearing, by construction** (my r4 "optimisation, never load-bearing" was WRONG — S1/S7/S4 all rely on it). Exactly-once-admission = the cause-derived txid is a **UNIQUE KEY enforced by an ATOMIC conditional-append (unique-key insert) at the single writer** — NOT read-log-then-append (a TOCTOU that a storm double-admits). It is a **total function of the DURABLE LOG**, invariant under redelivery, interleaving, and door crash-restart (S4). Only Temporal's OWN pre-log early-drop is optimisation. **Key = `(input-cut, model-version, recipe/dynamic-version, seed)`, all recorded BEFORE the compute activity dispatches** (a seed drawn *inside* compute re-draws on a crash → a different txid → double-record). **Numerical-environment version is OUT of the key**: env-in-key makes two environments two facts → reopens the race and double-admits under DC split-brain; the cross-environment value spread is bounded by `β` (D16), not made a second fact. Env-version is a recorded Tier-2 governance term (lineage), never identity. Never a Temporal run/attempt id. |
| D11 | **Queue/signal/observation arrival order** vs the fold. | Committed order = total order `(exec, door, hash)` at the door alone (R-25); a late observation refolds; a same-instant non-commuting pair is ordered by declared precedence or refused. |
| D12 | **Timer semantics vs the three times.** | Timers carry NO time authority; the three times live on the log; a late-firing timer produces the identical transaction (C-3.7). |
| D13 | **Attribution/dispersion convention as worker config** (VM-5, VM-11 Σ). | A declared, recorded term read by the projection — never a worker default. |
| **D14** | **Exactly-once ADMISSION ≠ deterministic VALUE.** A non-bit-reproducible model run at-least-once could present two payloads under one txid; a *fused* compute-and-propose activity that retries would recompute, so the canonical value would turn on a door-arrival race. | **Primary — compute/emit split:** model-eval and door-propose are SEPARATE activities; the model runs once, its output is memoized, door-propose re-presents identical bytes → **only one payload reaches the door, the race is structurally REMOVED.** Canonical-by-first-admission is the spec floor (Tier-1 read-back, MD-14/VM-8). Bit-reproducibility is NEVER an admission precondition (C-Scope.11). Numerical-environment pin = governance-optional Tier-2 (never in the txid key). **The r2 content-hash is DELETED (matching T-1's clean cut):** the fused worker is made **unrepresentable by type** (`proposeToDoor`'s sole input is `runModel`'s recorded output), so a two-payload door compare would guard an unrepresentable state — §7 minimalism, deletion safe because `β`/TA-REPRO (D16) already bounds the value divergence. (It never fired for the retry race it was built to catch — memoised bytes; the design defers any residual cross-environment divergence to `β`, not a hash compare.) |
| D15 | **MD-16 write atomicity + a base moved under the pinned cut** (Fork A / A′). | State + verdict cross the door as **ONE transaction over one pinned cut** (MD-12). A base moved under the cut **FLAGS m\* stale-forward** (kind-2, MD-8/10) — not refused (the decision is kind-3, pinned as-known; C-11.3 is a structural guard, not a freshness check; REFUSE livelocks). Refusal belongs only to a gate fail/undecidable verdict or an unresolvable structural reference. |
| **D16** | **Read-back proves byte-reproducibility, not VALUE correctness.** For a non-bit-reproducible model the recorded value is one arbitrary member of `{P₁,P₂,…}`; nobody bounds `\|Pᵢ−Pⱼ\|`. If that spread exceeds the *consuming instrument's* VM-6 tolerance, a mark that "reproduces bit-for-bit against the record" is one no honest re-derivation would produce within tolerance. | The producer attests a **reproducibility class** carrying **`β`** (one symbol committee-wide; r4's `ε_repro` renamed) — a bound on `\|Pᵢ−Pⱼ\|` for `(model-version, input-cut, numerical-environment)`, a declared recorded versioned term (like the VM-5 convention). **Two loci:** at ADMISSION the DOOR **records whether the attested class is present + structurally valid** (admit-and-flag, model-free — **never refuse-on-absent**: economic metadata is not envelope validity); it does *not* compare `β` to any tolerance, because the VM-6 tolerance is the CONSUMING instrument's and is ill-defined at a shared surface (`β=3bp` feeds U₁@5bp and U₂@1bp). At CONSUMPTION the **`β ≤` the consuming instrument's VM-6 tolerance** comparison is a VM-7 broken-chain check; `>` tolerance, or no class, ⇒ a broken chain, surfaced (COVERAGE makes this total). Pole-(b): `β=0` never required; a false attestation degrades to detection-at-audit; adequacy = TA-REPRO. |
| **COVERAGE** | **The value-bound move traded one door chokepoint for N valuation legs.** A valuation path consuming a kind-2 surface could **escape the β check** — a "bare valuation read", the analog of D1's forbidden bare read. | **Totality, by construction + executable.** Every valuation path consuming a kind-2 leaf routes through the certificate/VM-7 leg that reads the leaf's attested `β` against the consuming instrument's VM-6 tolerance; there is **no read path to a kind-2 leaf that bypasses it** (the valuation analog of "no data enters as a bare read"). Stated as an executable property `prop_everyKind2ConsumerChecksBeta` over generated valuation graphs — it **MUST fire** (zero firings = defect, C-2.5), as adjustment-schedule totality and attribution-convention totality do. A kind-2 leaf consumed with no class, or `β >` tolerance, is a VM-7 broken chain. |
| **S1** | **Mid-refold worker crash** (r4 §2). | REFOLD-ATOMIC (r4). Confirms the D3 boundary is load-bearing. |
| **S4** | **Retry storm at the one door + door crash-restart** (§2). | EXACTLY-ONCE-UNDER-CONCURRENCY — see §2. No row breaks; confirms the atomic-unique-key (not check-then-append) statement is load-bearing. |
| **S7** | **Namespace failover mid-gate** (r4 §2). | GATE-STATE-ATOMIC (r4). Confirms Fork A's one-transaction pole is load-bearing. |

## 2. Red-team R5 — S4 retry storm at the one door → EXACTLY-ONCE-UNDER-CONCURRENCY

**Property.** Exactly-once-admission is a **total function of the durable, append-only, hash-chained
log** — invariant under unbounded redelivery, arbitrary interleaving, AND a door crash-restart; no
distinct txid is starved; the door never blocks, drops silently, or lies. It depends on **no
in-memory in-flight set** and on **no which-retry-arrives-first** ordering.

**Mechanism.** The door admit is an **atomic conditional-append (unique-key insert) keyed on the
cause-derived txid** at the single writer — NOT read-log-then-append. Consequences under a storm:
- **Same-txid flood** (a flapping worker, a partition replaying) — N concurrent retries serialize
  at the unique-key constraint; **exactly one lands, the rest collapse to the existing row
  (absorbed), none dropped.** One admitted fact regardless of N or arrival order.
- **Distinct-txid burst** (a wide cascade fanning out) — each txid admits once; the storm is
  throughput, not double-admit. It manifests as **door-pool schedule-to-start latency (alarmed,
  R-18/L7)** — the door degrades in throughput, never blocks/drops/lies; the ingestion queue is
  must-not-lose, so nothing is silently shed.
- **Door crash-restart mid-storm** — exactly-once does not depend on door memory; on restart a
  re-presented txid already on the log is absorbed, an in-flight one is either already committed or
  retried and admitted. **Crash-restart is transparent** (the log is the state).
- **Why env is OUT of the key (I2):** if env-version were in the txid, two environments computing
  one logical fact would produce two txids → two admissions, and the storm/split-brain would
  double-admit. Env out + `β` (D16) keeps one fact and bounds its value spread.

**Finding (contained).** S4 holds **only** if the admit is an atomic unique-key insert. IF the door
used check-then-append (read the log, then append), concurrent same-txid retries race between the
read and the append → double-admit (a classic read-modify-write TOCTOU), which would retroactively
break S1 and S7 too (both reduce to exactly-once at the door). Containment: the admit is
**by-construction** an atomic conditional-append on the txid unique key (D10). **The attack confirms
the atomic-unique-key statement is load-bearing** — the single sharpest precondition the referees
flagged.

**Deep invariant (S1/S4/S7 all reduce to it).** Exactly-once at the door is the **ledger single
writer's** atomic-unique-key property on the durable log, NOT Temporal's; **one write credential per
lineage, un-forgeable by construction** (not deployment discipline), with no active-active ledger
door. Temporal's own dedup is a pre-log early-drop optimisation only, never the correctness
mechanism. A Temporal crash, failover, or retry storm therefore degrades to at most a
liveness/backpressure incident, never a wrong or duplicated fact (R-21, generalized).

## 3. Open questions (unchanged; no new park)
Parking exercised, empty (derived stream ≠ second store; gate verdict = kind-3 pinned event-outcome;
must not turn on Valuation-Manifesto PARK-1). Residuals: **TA-REPRO adequacy** (a producer's attested
`β` honesty is a governance/perimeter reconciliation, caught by audit and counterparty challenge);
the **load model** (K, door/derivation pools); Forks C/D settled-soft. Queued red-team scenarios not
yet argued: S3 (CAN mid-CA-sandwich → sandwich-is-pure-projection), S6 (poisoned-cache replay →
log-is-sole-truth), S2 (deploy mid-backtest → axis-isolation), S5 (clock skew → times-on-the-log).
