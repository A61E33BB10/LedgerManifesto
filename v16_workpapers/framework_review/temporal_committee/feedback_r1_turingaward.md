# TuringAward — Temporal Committee Referee Feedback, Round 1

Role: standing referee for architecture judgment and convergence steering; enforcer of Constitution §4
(no categorical primitive telling). Advisory, no veto. Lenses applied: L1 (ordering/refold), L2
(transactions — write atomicity, idempotence key, exactly-once), L3 (MD-12 one-cut invariant,
"undecidable" as returned value), L5 (the two record primitives; door substitutability), L6
(minimalism, queue families, what to delete), touching L8 (audit/cause-derived txid) and L9 (model
float nondeterminism, seed/numeric-env recording).

**§4 anti-bias check — all five PASS.** No proposal introduces anything categorically first; none reaches
for a functor, adjunction, or commutative diagram to explain a thing instead of explaining it. The
whole family works in plain terms (one door, re-entered observation, projection, pinned cut, refold,
forward-only re-fire) with concrete examples. "Injective cascade" (TEMPORAL-2) is ordinary math, not a
box. Nothing to flag under §4 this round.

**The shared thesis is sound and convergent.** All five answer the committee's central question —
*is market data / valuation a second substrate?* — with the same NO, via one economical move: every
model number (mark, calibration, greek, gate decision) is a **re-entered observation** that runs
outside the fold and re-enters through the **one** door; every curve/NAV/chain/certificate is a
**projection** that stores nothing. No second door, no second book, no new mapping primitive. That is
the right architecture and it should be treated as settled ground, not relitigated. The real work of
rounds 2+ is the handful of genuine forks below, not the spine.

---

## TEMPORAL-1

- Strongest *reductive* framing: the extension is "two record kinds (a **projection**; a **re-entered
  observation**) plus one lineage discipline (cause-derived txid, pinned cut, forward-only refold)."
  This is the minimum basis stated as a minimum basis — the others are variations on it.
- Acceptance test is the crispest three-way: strip Temporal, rebuild chain + derived states + gate
  decisions from the log (R-02). Good executable framing.
- Owns the sharpest owner-acknowledgement flag (§4): "prevention-at-construction = detection-at-audit"
  under the single-trusted-door model. That is a real seam and naming it is correct.
- Weakness (named missing case): §2.2 runs MD-16 construction "in a derived lineage/namespace." But a
  *production-serving* daily surface fit is a production derived object, not a simulation world. The
  proposal never separates "derived stream (production)" from "isolated namespace (simulation)"; it
  collapses both into "derived lineage." That boundary needs pinning (see convergence note).
- Verdict: **nominated architectural base for the mapping** — its primitive count is the smallest and
  the others reduce to it.

## TEMPORAL-2

- Cleanest exposition; the "Binding note" column is good discipline. Correctly elevates `sec:substrate`
  to *governing clause* and binds the seed under it.
- Best constitutional read (Q2): names Valuation-Manifesto **PARK-1** and states the design "must NOT
  turn it on." The most careful seam-probing of the five; adopt its list of three tested seams.
- Best statement of the re-entry idempotence key (D4): dedupe on recorded `(input-cut,
  model/recipe-version)` identity, **never** a Temporal run/attempt id. Adopt this wording committee-wide.
- Weakness (counterexample) — this is Fork A: §2.2 makes MD-16 a **two-write** sequence — "the
  construction activity is **gated on the recorded pass**." Under at-least-once, the construct step can
  retry after the pass is recorded but before the state commits, leaving a recorded pass with no state
  until the retry lands: a visible inconsistent read the single-transaction pole (TEMPORAL-5) avoids.
- Verdict: adopt as base for the **constitutional seam-probing and idempotence-key** wording; its MD-16
  write ordering loses to TEMPORAL-5/-1.

## TEMPORAL-3

- Cleanest one-sentence thesis: every model output "RE-ENTERS through the one door under a cause-derived
  identifier computed from recorded inputs." Good.
- Only proposal to face the *diverging-retry* subtlety honestly (divergence bullet 2): "a retry that
  computes a **different** number is still absorbed: the first admitted output is canonical, a re-mark
  is forward-only ... so the seed must be recorded to keep the number reproducible." The others gloss it.
- Names the THREE versioning axes explicitly (orchestration / contract economics / model-recipe-dynamic).
  Correct — the extension does add a third axis and it should be stated, not folded into the second.
- Weakness (counterexample) — this is Fork B, one pole: §2c asserts "Valuation cadence is system cadence,
  so it rides a **Schedule**." But a unit mid-CA-node, whose frame just changed, marked by a blind
  end-of-day sweep that "holds no chain state," can be priced in the wrong frame because the sweep does
  not read the unit's graph position. All-marks-on-Schedule over-reaches; see Fork B resolution.
- Verdict: supplies the correct Schedule pole for Fork B and the best retry-divergence and versioning-axis
  wording; do not adopt "all valuation cadence is system cadence."

## TEMPORAL-4

- Most operationally concrete, and the only one anchored to specific spec sections (`sec:obs-door`,
  `sec:totalorder` step c, `sec:registry COUNTERPARTY-DEFAULT`). Richest divergence catalogue (13 rows).
- Owns two containments no one else names, both real: **D1** the bare-read prohibition (an ingestion
  activity that records nothing is the forbidden bare read — a genuine failure mode), and **D13** the
  attribution/dispersion convention as a *declared, recorded term* not worker config (else two workers
  disagree — a real leak the other four leave open). Adopt both.
- Best split-vs-branch nuance: "market-claim leg is a **branch** → same workflow; partial-split legs are
  **new units** → own workflows ... Do not conflate split with ContinueAsNew." Adopt this wording.
- Weakness (named, and it flags this itself in Q2) — Fork B, other pole: places re-mark watches on the
  *unit's* workflow. A unit carrying many chains at many cadences (VM-3) then puts N durable timers on
  one workflow's replay surface; TEMPORAL-3's stateless sweep avoids that bloat. Neither pole is right
  for all marks.
- Verdict: **nominated base for the divergence catalogue** (D1, D13, split/branch); Fork B and the
  models-queue split are open, not settled, and it says so.

## TEMPORAL-5

- Near-twin of TEMPORAL-4 in structure; distinct real contributions. **D5**: heartbeat + bounded
  ScheduleToClose so an expensive model activity retries only on genuine failure — the only proposal to
  address retry *economics* of heavy compute concretely (L2/L6). Adopt.
- **Q3** raises a real dispute-readiness question MD-6 leaves open: pin a *numerical-environment* version
  beside the model version so a re-entered observation is bit-for-bit re-derivable, not merely readable
  back. This bounds MD-14/VM-8 dispute readiness for model numbers (L9). Keep it live.
- Clearest reconciliation of the MD-16 prevention/detection tension (D7): a mis-gate "degrades to a
  detectable, forward-repaired defect, exactly as an economically-wrong contract does." Adopt this line.
- Strength — Fork A, correct pole: "state + gate decision cross the door in **one transaction** over that
  cut ... atomic with construction." This matches MD-12 ("gates + construction are one evaluation over
  one pinned cut") better than TEMPORAL-2's two-write.
- Weakness (named missing case): D6 leaves the tie-break unresolved — "a moved base = stale cut →
  **refused** ... **or** lineage-flagged." Refuse and flag are different outcomes with different liveness
  consequences; which one, and who decides, is not pinned. Resolve in round 2.

---

## Convergence map

### The spine (settled; do not relitigate)
All five agree on, and round 2 should treat as fixed: (1) immutable log = sole book of record, Temporal
history = disposable cache; (2) the Transaction Executor = external single-writer service fronted by
**one** idempotent door activity; (3) one long-lived workflow per unit keyed `unitId`, ledger-created
units start their own via signal-with-start, **no** child workflows for lineage coupling, graph branches
stay in-workflow; (4) model output = re-entered observation through the one door, projections store
nothing; (5) exactly-once at the door via cause-derived txid over **recorded inputs**, never a Temporal
run/attempt id; (6) three times = execution/monitor/door, only execution orders the fold, durable timer
= liveness half, a late fire yields the identical transaction; (7) refold is the single writer's work,
Temporal is signalled-to-re-read and re-fires **forward only**, never rewinds history against a new
fold, never compensates substrate-side; (8) simulation/backtest in isolated namespaces against their
own lineage's door; (9) undecidable/fail/refuse = returned value, recorded, never a retryable error or
saga; (10) two-plus versioning axes, economics/model versions on the log, off Temporal's version surface.

**One convergence worth surfacing so it is not relitigated:** all five agree the MD-16 gate decision is
a **recorded event-outcome pinned as-known**, and explicitly *not* a recompute-on-read projection
(TEMPORAL-1 says so outright; TEMPORAL-2 Q2(ii) tests it against C-4.11 and cites MD-16 as already
reconciling it). This brushes the Constitution's recompute-on-read rule and all five land on the same
side. Treat as convergent, not open.

### Fork A — MD-16 write atomicity (REAL; correctness; L2). **The sharpest fork.**
Does the derived state and its passing gate decision commit as **one** door transaction over the pinned
cut (TEMPORAL-5, and TEMPORAL-1 "construct + record the admission"), or is the pass **recorded first**
and construction **gated on the recorded pass** (TEMPORAL-2 §2.2)? The two-write pole opens an
inconsistent-read window under at-least-once retry (pass recorded, state not yet committed). MD-12 —
"gates + construction are one evaluation over one pinned cut" — favors the atomic pole.
**Base: TEMPORAL-5's single-transaction framing**, cross-checked against MD-12; fold in TEMPORAL-1's
admission/refusal record vocabulary. Resolve TEMPORAL-5's own loose end (refuse-vs-flag tie-break, D6).

### Fork B — valuation re-mark cadence (REAL; minimalism vs coupling; L6/L3).
System **Schedule** sweep holding no per-unit state (TEMPORAL-3), or a per-unit **watch/timer** on the
unit workflow (TEMPORAL-4, TEMPORAL-5)? Each proposal wrongly applied one pole to *all* marks. The spec
already draws the resolving line: `temporalv16.tex:58-59,99` — "Schedules serve system cadence only
(end-of-day sweeps ...) — a 252-fixing swap is one workflow, not 252 schedules ... per-unit contractual
dates never use them."
**Base: split by the spec's own contractual-vs-system axis.** End-of-day desk marks (system cadence) →
Schedule sweep (TEMPORAL-3's pole). Contractually-triggered or input-moved re-marks → watch on the unit
(TEMPORAL-4's pole). Neither proposal's blanket claim survives; the synthesis does. This also answers
TEMPORAL-3's wrong-frame counterexample: a contractual/CA-driven re-mark is a watch that reads the
unit's node, not a blind sweep.

### Fork C — models/derivation queue: split from contracts, or shared? (SOFT; operational, not architecture.)
TEMPORAL-4 and TEMPORAL-5 commit to a dedicated models/derivation queue family (compute-heavy, bursty,
possibly GPU); TEMPORAL-1 adds a derived-object/gate queue; TEMPORAL-2 keeps contracts+models in one
class; TEMPORAL-3 flags it open. This is a load-model-gated scaling parameter, **not** a genuine
architecture fork — the mapping is identical either way. TEMPORAL-3's honest position (flag it, decide
against the load model) is correct. Do **not** force a decision in round 2; carry the load model as the
gating unknown all five already name as their biggest.

### Fork D — simulation/backtest fan-out shape (REAL but low-stakes; explicitly non-correctness; L4/L6).
Child-workflow per shift/underlying/segment (for failure-domain isolation, separate history,
queryability) vs bare activity fan-out folded by one workflow. TEMPORAL-2/-3/-5 all label this "a
decomposition choice, never a correctness one" (TEMPORAL-2 Q3). Note this is a *different* use of child
workflows than the seed forbids: the seed bans child workflows for **lineage coupling**, not for
history-bounding inside a simulation namespace — so no spine violation either way.
**Base: TEMPORAL-2's framing** (decomposition, not correctness); settle against the same load model as
Fork C. Rank below A and B.

### Under-specified seam to pin next round (not yet a fork)
The boundary between the **production derived stream** (e.g. today's calibrated surface serving real
marks) and an **isolated simulation namespace** is collapsed by all five into "derived lineage." No two
proposals cleanly disagree, so it is not a fork — but it is unpinned, and Fork A/D both touch it. Round 2
should state whether a production-serving MD-16 derived state lives in the production lineage (tagged) or
in a physically isolated namespace, because door-credential separation (R-18/R-20) depends on the answer.

### Nomination
**Architectural base for the mapping: TEMPORAL-1** (smallest primitive count — two record kinds plus one
lineage discipline; the others reduce to it). **Base for the divergence catalogue: TEMPORAL-4** (D1
bare-read, D13 declared-convention, split/branch nuance). Merge TEMPORAL-2's idempotence-key and
constitutional-seam wording, TEMPORAL-3's retry-divergence and Schedule pole, and TEMPORAL-5's atomic
MD-16 write and heartbeat/ScheduleToClose economics. No consensus is declared this round; Forks A and B
are the two that must be resolved before the mapping can be called correct.
