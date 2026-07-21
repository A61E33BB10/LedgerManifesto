# Temporal Committee — Proposal TEMPORAL-2, Round 2

**Convergence posture.** The spine (referees' 10 points) is settled; I do not relitigate it. This
round I (1) **cede** the mapping base to TEMPORAL-1 (smallest primitive count) and the divergence
catalogue base to TEMPORAL-4 (D1 bare-read, D13 declared-convention, split/branch), (2) **retract**
my R1 MD-16 two-write sequence for the single-transaction pole (Fork A), (3) **close** the set-wide
value-determinism gap that no R1 proposal closed, and (4) hand the committee two pieces flagged
best-in-set for adoption — the constitutional-seam list (Q2) and the re-entry idempotence key (D4) —
as drop-in wording. Everything in my R1 mapping/decomposition stands except the three deltas below.

**Stance line, corrected (FORMALIS defect).** ~~"only execution time orders the fold"~~ →
**execution time is the primary fold key; door time and the event hash are same-instant tiebreakers**
— the total order is lexicographic `(exec, door, hash)` (spec l.199, `sec:totalorder`). Meaning rides
execution time; door/hash only separate events of one execution instant.

---

## 1. Mapping-table deltas (all other rows carried from R1 unchanged)

| Row | R1 | R2 correction |
|---|---|---|
| MD-16 derived state | pass recorded first, construction "gated on the recorded pass" | **derived state + passing gate decision commit as ONE door transaction over ONE pinned cut** (MD-12). No two-write window. |
| Durable timer → date watch | "a late fire yields the identical transaction" | identical **because** the firing is an emitted event whose execution time is the record-derived declared date, **monitor time null, door time ⊤** (spec l.1241) — record-derived and rerun-stable, not because the timer is trusted. State the ⊤/null mechanism (FORMALIS D6). |
| Ingestion activity | (capture, envelope-first) | add **the bare-read prohibition** (adopt T-4 D1): an ingestion activity that records nothing is the forbidden bare read (B1, `sec:obs-door`) — a retryable no-op, never consumed by a valuation. |
| version-pinned pure-eval activity | contract eval; operator; projections; certificate; gate | add: **attribution / dispersion convention is a declared, recorded term** (VM-5, adopt T-4 D13), never worker config — two workers with divergent defaults would disagree, a nondeterminism leak. |

---

## 2. Decomposition — resolved forks and the determinism closure

### Fork A (MD-16 write atomicity) — adopt the single-transaction pole, with the tie-break resolved
A *dynamic* over an **admissible base pinned at one cut** either passes both gates or does not.
- **Gate returns pass** → the **derived state and its passing gate decision cross the one (derived-lineage) door in a single transaction over that pinned cut** (MD-12: gates + construction are one evaluation over one cut). There is no interval in which a pass stands with no state; the R1 inconsistent-read window is gone. Fold in TEMPORAL-1's vocabulary: the transaction *is* the admission record; consumption is by reference to it.
- **Gate returns fail / undecidable** → **no state is constructed; the refusal is the recorded outcome** (returned value, never a retryable error — spine point 9).
- **Tie-break (resolves TEMPORAL-5's D6 loose end: refuse vs flag).** "Refuse" and "flag-stale" are *two different events*, never a choice at one instant. Because gate+construction are one atomic transaction over one pinned cut, the base **cannot** move between gating and construction — so staleness is never a construction-time verdict. A later input that supersedes the pinned cut makes the committed derived state **stale-forward** (MD-8): flagged, re-derived forward at a fresh cut by the refold path (D7). Refusal belongs only to a fail/undecidable **gate verdict**; supersession belongs only to a **later** arrival. One locus each.
- **Honest bound (adopt T-5 D7, T-1 §4):** the constructor is untrusted, so this is *prevention-at-construction = detection-at-audit*; a mis-gate degrades to a detectable, forward-repaired defect, exactly as an economically-wrong contract does. The door creates no new admission privilege.

### Fork B (valuation re-mark cadence) — split by the spec's own contractual-vs-system axis
The spec draws the line (`temporalv16.tex:58-59,99`); neither R1 blanket pole survives:
- **System-cadence marks** (end-of-day desk revaluation of the whole book) → a **Schedule** sweep holding no per-unit state (T-3's pole).
- **Contractually-triggered or input-moved re-marks** (a CA-node frame change; a corrected leaf → VM-7 broken chain) → a **watch on the unit** that reads the unit's graph position (T-4/T-5's pole). This answers T-3's wrong-frame counterexample: a CA-driven re-mark must read the node, never a blind sweep.

### SET-WIDE DETERMINISM GAP — closed (the round-1 unresolved obligation)
**Problem.** The recorded *value* of a re-entered observation is deterministic only if the model is
bit-reproducible given recorded inputs + seed. Under at-least-once retry, two attempts of a
float/GPU-nondeterministic model present the **same** cause-derived txid with **different** payloads;
the door gives exactly-once *admission* (first-wins), so the canonical value turns on a door-arrival
race. "Record the seed" does not cure nondeterminism at fixed seed.

**Closure — two layers, reconciled with MD-14/VM-8:**
1. **Primary (dissolve the race).** Pin a **numerical-environment version** beside the model version
   (adopt T-5 Q3) as recorded lineage of every re-entered observation. Where the environment is pinned
   and the model is bit-reproducible, *both* retry attempts compute the **identical** payload — the two
   differing-payload attempts cannot arise, and there is no race to lose. The re-entry activity is then
   value-idempotent, not merely admission-idempotent.
2. **Residual (canonical-by-fiat, and it is not a weakening).** Where bit-reproducibility genuinely
   cannot be guaranteed (float/GPU at fixed seed), the **first-admitted payload is canonical by the
   door's exactly-once admission**, and re-derivation then guarantees **read-back only, never
   bit-equality**. This is *exactly* the MD-14/VM-8 dispute bound — "a value reproduces from recorded
   prices unconditionally, a model's number once the model [and environment] is supplied" — not a
   regression from it. Dispute is settled by exhibiting the recorded value and reproducing the **fold**
   bit-for-bit (the fold reads the admitted value back), never by re-running the model.
3. **Substrate rule that makes this safe.** The substrate must **never retry a re-entry expecting a
   matching value, and never compare two attempts' payloads.** On any doubt it **re-reads the admitted
   value** (the same rehydrate-from-record discipline as a refold, D7). The nondeterminism is thereby
   confined to *which* bit-reproducible-or-not attempt won admission, is invisible to the fold, and is
   bounded by MD-14. A Temporal non-determinism bug degrades to a liveness incident (R-21), never wrong
   ledger state.

### Under-specified seam (TuringAward) — production derived stream vs isolated simulation, pinned
The distinguishing predicate is **"does a real unit's valuation chain consume it?"**
- **Yes** (today's calibrated surface serving real marks; a production MD-16 derived state real marks
  consume) → it is **production data**: a re-entered observation in the **production lineage**, admitted
  through the **production door**. Tagged derived-stream, same book of record.
- **No** (feeds only a simulated path's own record — risk scenario, MC path, backtest) → **isolated
  namespace, own lineage's door** (R-20/R-03), never the production write credential.
This pins R-18/R-20 credential separation: the production door admits production derived states;
isolated-namespace doors admit simulation-only ones. "Derived lineage" alone was ambiguous; this is the
line.

### Versioning — three axes, not two (adopt T-3)
The extension adds a third axis: (i) orchestration (Temporal Build-IDs/GetVersion, CAN boundaries as
cutover); (ii) contract economics (ProductTerms on the log); (iii) **model / recipe / dynamic +
numerical-environment** version on the log. All economics/model versions ride the record, off Temporal's
version surface; eval activities are keyed by the recorded version so replay is against it.

---

## 3. Divergence rows changed or added this round (R1 D1–D10 otherwise stand)

| # | Divergence | Containment |
|---|---|---|
| D6′ | timer/wall-clock time vs execution time — "identical transaction" was asserted without mechanism | identical **via** the ⊤/null construction: a date-watch firing is an emitted event, execution time = record-derived declared date, monitor time null, door time ⊤ (spec l.1241); rerun-stable and party-invariant. A late fire is an ordinary late arrival → the **door** refolds; the substrate emits no past-dated firing. |
| D4′ | at-least-once retry vs exactly-once *value* (not just admission) | **(new, the set-wide gap)** pin numerical-environment version → value-idempotent re-entry where reproducible; else first-admitted canonical, re-derivation = read-back only (MD-14). Substrate never retries-for-value, never compares payloads, re-reads the admitted value. Re-entry dedupe keys on recorded `(input-cut, model/recipe/dynamic-version, numerical-environment-version)`, **never** a Temporal run/attempt id. |
| D11 | bare read (adopt T-4 D1) | an ingestion activity that records nothing is the forbidden bare read (B1); it is a retryable no-op and its result is never consumed — only a recorded observation is. |
| D12 | attribution/dispersion convention as worker default (adopt T-4 D13) | the convention is a declared, recorded term on the valuation (VM-5); two workers cannot disagree because neither holds it as config. |

---

## 4. Open questions and merge recommendation

- **Q1 (load model, MEDIUM).** K for CAN, door-pool sizing, and — new this round — whether reproducible
  compute (layer-1 of the determinism closure) is affordable for heavy models, or whether canonical-by-
  fiat (layer-2) is the operating reality for a given model class. A per-model-class governance fact,
  gated on the same load model all five name as the biggest unknown. Fork C (models queue) and Fork D
  (sim fan-out shape) are decomposition, not correctness — settle against this same model; do not force.
- **Q2 — constitutional-seam list, offered for committee-wide adoption (best-in-set, both referees).**
  Three seams tested against the Constitution, each already resolved: (i) derived stream as a "second
  store" — no, same immutable-log mechanism on a distinct lineage (C-2.8, C-12.5); (ii) storing a gate
  decision vs recompute-on-read (C-4.11) — MD-16 l.546-548 argues it is a pinned event-outcome, not a
  live projection, and *the single-transaction pole (Fork A) strengthens this*: the decision is admitted
  as-known in one transaction, never recomputed; (iii) late-CA sandwich vs Temporal compensation —
  resolved by the reordering path (D7). Live neighbour: Valuation-Manifesto **PARK-1** (valuation
  storage); this design must **not** turn it on — gate-decision and valuation-link recording ride the
  existing re-entered-observation mechanism, which MD-16 states "neither reopens nor turns on" PARK-1.
  No new parking; the index is *exercised*, not merely empty.
- **Merge recommendation.** Build the committee output on **TEMPORAL-1's mapping** + **TEMPORAL-4's
  catalogue**; fold in, verbatim, my **§2 determinism closure** (the round-1 unclosed obligation), my
  **Fork A single-transaction resolution with the refuse-vs-flag tie-break**, the **production-vs-
  simulation lineage predicate**, and my **Q2 seam list + D4′ idempotence key**. I do not need to own the
  base; these four pieces are the gaps the referees identified in the nominated bases.
