# Proposal TEMPORAL-3 (Round 2) — convergence

**Stance.** The spine is settled ground (both referees) — I do not restate it. This round I
(i) **close the set-wide determinism gap** the referees assign me as closest, with a two-tier
reproducibility contract the manifestos already force; (ii) **adopt Fork A** (atomic MD-16
write) and **resolve its loose end**; (iii) **adopt the Fork B split** — my Schedule pole
survives for system cadence only; (iv) **pin the derived-stream vs sim-namespace seam**;
(v) carry forward my two best-in-set items (retry-divergence, three versioning axes) and
**harvest** the committee-flagged wording from TEMPORAL-1/2/4/5. One correction to the spine's
framing: the extension has **three** record kinds, not two.

---

## 1. Mapping — deltas from the settled spine (market data + valuation)

| Framework object | Temporal object | Binding constraint (R2 resolution) |
|---|---|---|
| **record kind 1 — projection** | projection-read activity | stores nothing; recompute on read |
| **record kind 2 — re-entered observation** | model-run activity → one door | a stored model number; MD-8-stale when a lineage input moves |
| **record kind 3 — recorded event-outcome pinned as-known** | door transaction (admit/refuse; MD-16 gate decision) | NOT recompute-on-read, NOT MD-8-stale; an as-known fact (MD-16 l.539) |
| observation ingestion | ingestion activity → door | a non-recording fetch is the forbidden **bare read** (adopt T-4 D1) |
| the market data operator | projection-read activity, at read | original never overwritten (C-9.3) |
| **MD-16 derived state + its passing gate decision** | **ONE door transaction over one pinned cut** | Fork A atomic pole (T-5); pass → both cross, fail → only decision crosses |
| MD-16 stale-cut construction | refused, returned value, re-issued at fresh cut | a derived state at a moved base is a broken state, forbidden (resolves T-5 D6) |
| valuation chain | append-only re-entered observations ON THE LOG | never Temporal history |
| **EoD desk mark (system cadence)** | **Schedule sweep, holds no chain state** | my pole — system cadence ONLY |
| **contractual / input-moved re-mark** | **per-unit watch reading the unit's node** | Fork B other pole (T-4/T-5); reads node → correct frame |
| PnL-explain certificate | projection-read activity decomposing ΔNAV | residual-breach = recorded broken state (VM-7), a distinct locus from a door refusal |
| CA valuation sandwich | bounded sub-graph at the unit's CA node | branch of the unit's graph, stays in-workflow (adopt T-4 split/branch) |
| partial-split legs | new units, own workflows via signal-with-start | do NOT conflate split with ContinueAsNew (adopt T-4) |
| production derived stream | production lineage, **derived-stream tagged**, production door | never enters the base stream (MD-16 l.549) |
| isolated simulation / backtest | **physically isolated namespace**, own lineage's door | credential-separated (R-18/R-20) |
| attribution / dispersion convention | declared, recorded term on the log | never worker config, else two workers disagree (adopt T-4 D13) |

---

## 2. Decomposition — R2 resolutions

### 2a. The set-wide determinism gap (CLOSED) — a two-tier reproducibility contract
FORMALIS is right: keying the re-entered observation's identifier on recorded inputs makes
all retries collapse to the **first-admitted** payload, so a float/GPU-nondeterministic model
lets the canonical VALUE turn on a door-arrival race; "record the seed" does not neutralise
nondeterminism at fixed seed. The manifestos have **already chosen** the resolution, and it is
option (b) — MD-6 and MD-14 state it outright. I make it a contract:

- **Tier 1 — read-back (spec-mandatory, unconditional).** The first-admitted number is
  canonical; any party reads it back from the record bit-for-bit. This alone discharges C-2.2,
  MD-14, and VM-8: a mark is defended by **exhibiting the recorded number and its lineage and
  reading it back** — the dispute is settled on the record, never by re-running the model.
  MD-14 bounds itself here: "a value reproduces from recorded prices unconditionally, a model's
  number once the model is supplied, **never wider**." Read-back asks nothing of the numerics.
- **Tier 2 — re-derivation (governance-optional, declared).** Bit-exact *recomputation* from
  the recorded inputs needs the retained model **plus a pinned numerical-environment version**
  (T-5 Q3). MD-6 places this "outside this scope"; C-14.9/C-Scope.11 make numerics the
  reference implementation's. So it is a **declared, recorded term per model** (the third
  versioning axis, extended), turned on only where a counterparty contract demands
  bit-equal re-derivation — **never a spec-level admission precondition**, because that would
  reach into out-of-scope numerics.
- **The race is not a correctness violation.** A model run is an untrusted source outside the
  fold (C-14.9); its output is an **observation** — a fact about what the model said under
  those inputs at that attempt, not a truth (MD-1). Which retry lands first is which "print"
  the record captures, exactly as source-arrival order resolves two simultaneous vendor prints.
  Tier 1 is deterministic *given the record*; production is one path (C-2.8).
- **Operational containment (adopt T-5 D5).** Heartbeat + bounded ScheduleToClose so a heavy
  model activity retries only on genuine failure, not on a slow-but-live worker; the door's
  first-admitted-wins serialisation does the rest. This bounds — does not need to eliminate —
  concurrent double-execution, because Tier 1 makes the outcome sound whichever attempt wins.

### 2b. Fork A — MD-16 atomic write (adopted, loose end resolved)
The derived state $m^\ast$ and its **passing** gate decision commit as **one door transaction
over the one pinned cut** (MD-12): pass → a transaction carrying both a re-entered observation
(the state, kind 2) and an event-outcome (the decision, kind 3); fail/undecidable → a
transaction carrying only the decision, the state never constructed (prevention). No two-write
inconsistent-read window (this is where TEMPORAL-2's gated-on-recorded-pass pole loses).
**Refuse-vs-flag tie-break (T-5 D6), resolved by locus:** a *stale cut at construction* (the
pinned base moved under the demand) is **refused** — a returned value, re-issued at a fresh
cut, the state never existing; an *already-admitted* derived state whose lineage input later
moves is **lineage-flagged stale** (MD-8). Two loci, two outcomes, no ambiguity.

### 2c. Fork B — valuation cadence split (adopted; my blanket claim withdrawn)
- **System-cadence desk marks → Schedule sweep** (my pole), holding no chain state, off every
  unit's replay surface — the correct answer for the 252-fixing-style mass EoD re-mark.
- **Contractual / input-moved re-marks → a per-unit watch that reads the unit's node.** A
  CA-driven or contractual re-mark prices in the **correct post-CA frame** because the watch
  reads the node (answers my own wrong-frame counterexample). An **input-moved** re-mark (a
  corrected leaf → VM-7 broken chain) is a **condition watch** — signal-driven evaluation over
  recorded observations, not a date Schedule (closes FORMALIS's second defect on me).
- The VM-3 multi-chain concern (T-4's pole: N timers on one unit) is bounded by the split:
  system-cadence chains ride the shared sweep (no per-unit timer); only contractual chains need
  a per-unit watch, and those are **already** among the unit's declared out-edges — no new
  timer surface.

### 2d. The derived-stream vs sim-namespace seam (pinned)
The **derived stream is not an isolated namespace.** Test: does the derived state serve a
**real** mark on a real unit's chain? If yes → it lives in the **production lineage**, tagged
derived-stream, written through the **production door** as a real re-entered observation, and
never entering the base stream (MD-16). If it is a hypothetical/shift-driven path → an
**isolated simulation namespace** against its **own** lineage's door (R-20), never the
production door. Two separations for two purposes: base/derived sub-streams *within* production;
authoritative/simulation *across* namespaces. Door-credential separation (R-18/R-20) follows
the second, not the first.

---

## 3. Divergences and containments (R2 — deltas and adoptions)

- **Re-entered VALUE nondeterminism under retry.** *Containment:* the two-tier contract (§2a).
  Tier 1 read-back is the spec guarantee and the whole of dispute-readiness; Tier 2
  re-derivation is a declared governance term (numerical-environment pin); the race is the
  observation model applied to a model-source, sound whichever attempt wins.
- **Bare read.** *Containment (adopt T-4 D1):* an ingestion or fetch activity that records
  nothing is the forbidden bare read — a retryable no-op, never consumed; every read a valuation
  makes is against a recorded observation (B1), never a live feed.
- **Convention as hidden worker state.** *Containment (adopt T-4 D13):* the attribution and
  dispersion conventions (VM-5, VM-11 $\pi,D,\nu$) are declared, recorded terms on the log — the
  third versioning axis — never a worker default; two workers with divergent defaults would
  otherwise record divergent attributions from one record.
- **Three versioning axes (kept explicit; both referees endorse).** (i) Temporal orchestration
  (Build-IDs, cut over at ContinueAsNew); (ii) contract economics (ProductTerms on the log);
  (iii) model/recipe/dynamic/declared-term versions on the log — now extended with the optional
  numerical-environment version of §2a Tier 2. Kept physically apart; a model or gate-term
  change never touches workflow code.
- **Record-kind under-count.** *Containment:* name **three** kinds (§1) — projection,
  re-entered observation, recorded event-outcome-pinned-as-known — so a reader never treats the
  MD-16 gate decision (kind 3) as a recompute-on-read projection, nor a VM-7 broken chain (a
  projection residual breach) as a door refusal (an admission verdict): distinct loci.
- **Keystone (unchanged, spine-settled).** The refold and every past-dated/retroactive firing —
  including the retro CA sandwich struck at the ex-date — are the single writer's work; Temporal
  is signalled to re-read and re-fires FORWARD only.

---

## 4. Open questions (narrowed)

1. **Load model — the one gating unknown (Forks C, D stay soft).** Whether model runs get a
   dedicated queue family (compute-heavy, bursty, possibly GPU) vs share the contracts class
   (Fork C), and child-workflow vs bare-activity backtest fan-out (Fork D), are decomposition/
   scaling choices, not architecture — decide against the load model, not in committee. Fork D's
   child workflows inside a sim namespace are history-bounding, **not** the lineage coupling the
   seed forbids — no spine violation either way.
2. **Numerical-environment pin — keep live (T-5 Q3).** §2a makes it a declared Tier-2 term. The
   open governance question is which counterparty contracts *require* it turned on; that is model
   governance (out of scope), surfaced here so the door lineage carries the slot.
3. **MD-16 undecidable liveness.** A thin as-known history → Gate-2 undecidable → the derived
   state is refused (prevention). Confirm this degrades to a visible blocked/overdue item like a
   door refusal (R-22), never a retry-to-infinity.

**Parked constitutional conflicts: none.** Every re-entered observation and every gate decision
keeps the log as sole truth; the two-tier contract adds no store and reaches into no out-of-scope
numerics.

**Convergence recommendation.** Build the consensus mapping on TEMPORAL-1's minimal base
(corrected to three record kinds) and TEMPORAL-4's divergence catalogue; fold in this proposal's
two-tier determinism contract (§2a), the Fork A refuse-vs-flag resolution (§2b), the Fork B split
(§2c), the derived-stream/sim-namespace pin (§2d), and the three versioning axes.
