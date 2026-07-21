# FORMALIS — Referee feedback, Round 1 (Temporal Committee, Part II)

Remit: rigor of the Temporal↔Ledger mapping and containment claims — equivocation, undischarged
determinism obligations, doctrine violation, and assertion-where-proof-is-owed. Grounded against
`temporalv16.tex` (seed), `ledger_v16_1.tex` (§sec:totalorder l.1153, §sec:substrate l.1449,
§sec:obs-door l.2550), `MarketDataManifesto_1.3.tex` (MD-16 l.423-561), `ValuationManifesto_1.0.tex`.
Round 1 of ≥10 — defects exposed, no push for consensus.

---

## TEMPORAL-1

- [DEFECT] The opening reduction to **"two record kinds (a projection; a re-entered observation)"**
  (l.7-8) under-counts. MD-16's gate decision is a *recorded event-outcome pinned as-known* (MD-16
  l.539-540), which is neither a stateless projection nor a re-entered observation. TEMPORAL-1's own
  l.76 concedes exactly this ("recorded event-outcome... not a projection recomputed on read"),
  contradicting the reduction. One record class silently standing for three ledger kinds = equivocation.
- [OK] §4 is honest where it counts: it names the seam "prevention-at-construction = detection-at-audit
  under the single-trusted-door model" rather than burying it — the correct disclosure of the
  untrusted-constructor problem.
- [DEFECT] §3 bullet 4 forecloses door-enforced prevention by fiat ("the door does not check
  no-arbitrage"), but MD-16 l.449/461 makes Gate 1 **"a decidable predicate on a projection over the
  record"** — precisely the invariant class the seed assigns to the door ("invariant enforcement...
  the admission decision itself", §"What Temporal Must Never Own"). Routing it into the untrusted
  constructor is the choice that demotes MD-16 "prevention" to detection-at-audit; it is asserted, not derived.
- [OK] Gate-atomicity via one pinned cut passed to every activity (l.114, MD-12) is the correct
  containment: the base cannot move between gating and construction.
- [DEFECT] "residual ≈ 0 is the proof" for the CA sandwich (l.90) states VM-9 as if self-evident; the
  bound is a *declared tolerance* (VM-6), not an identity. State the bound, do not assert ≈0.

## TEMPORAL-2

- [OK] **Strongest constitutional-seam rigor.** Q2 (l.84) actually *exercises* the parking mechanism:
  it names three seams and cites the exact clauses (C-4.11, PARK-1, C-2.8, C-12.5), faithful to MD-16
  l.546-548 ("no collision with C-4.11... PARK-1 neither reopened nor turned on"). This is what an
  "empty-but-exercised" index should look like; the other four assert emptiness.
- [DEFECT] Stance l.12 "**only execution time orders the fold**" is imprecise. Spec l.199 gives the
  total order as (execution, door, hash), with door and hash as genuine tiebreakers for same-instant
  events; TEMPORAL-2's own l.34 says "(exec, door, hash)". Internal contradiction — fix the stance line.
- [DEFECT] l.51 "gated on the recorded pass, so an arbitrageable state is **never constructed**
  (prevention)" is circular: the gate runs in the same untrusted activity that computes the pass.
  Unlike TEMPORAL-1/5 it omits the detection-at-audit caveat, so "never constructed" overstates what an
  untrusted constructor can guarantee.
- [OK] The three-activity-class mapping (event-through-door / version-pinned pure eval / projection) is
  clean; D4 correctly binds re-entry dedupe to (input-cut, model/recipe-version), never a Temporal
  run/attempt id.
- [DEFECT] D6 "a late fire yields the **identical transaction**" is true only via the ⊤/null
  construction (door time ⊤, monitor time null, spec l.1241) that makes a synthesised firing
  record-derived and rerun-stable. TEMPORAL-2 asserts identity without stating that mechanism.

## TEMPORAL-3

- [DEFECT] l.92 "**Valuation cadence is system cadence, so it rides a Schedule (R-09)**" collides with
  VM-3 (Val l.245: a unit may carry several valuation chains at different cadences). Per-unit, per-chain
  cadence is exactly the "per-unit contractual date" R-09 forbids on a Schedule. TEMPORAL-4 (l.104) and
  TEMPORAL-5 (l.90) correctly place re-mark on a per-unit watch.
- [DEFECT] Same passage models re-marking as an EoD sweep only, missing the *input-moved* trigger (a
  corrected leaf → VM-7 broken chain) which is a condition watch, not a date Schedule.
- [OK] D2 is the sharpest idempotence analysis in the set: it faces the retry-computes-a-different-number
  case ("first admitted output is canonical, re-mark forward-only") — the only proposal to confront
  value-nondeterminism directly.
- [DEFECT] D2 then stops short. "First admitted output is canonical" makes the recorded VALUE depend on
  which at-least-once attempt reaches the door first — a door-arrival race for a non-bit-reproducible
  model. "The seed must be recorded" does not neutralise float/GPU nondeterminism at fixed seed; the
  containment is asserted, not shown to remove the divergence.
- [OK] Keystone (l.161-167) is explicit and correct: past-dated/retroactive firings incl. the ex-date
  sandwich are the single writer's work, Temporal signalled to re-read and re-fires forward — matches
  §sec:substrate l.1456-1458.
- [OK] The prevention→detection degradation is stated honestly ("the door still records only facts; no
  new admission privilege is created", l.173).

## TEMPORAL-4

- [OK] **Broadest correctly-grounded divergence catalogue (13 rows).** Only proposal to raise the
  bare-read divergence (D1), grounded in §sec:obs-door (spec l.2550, l.6757 "a bare read"): a
  non-recording fetch is a retryable no-op, never consumed. A real source the other four omit.
- [OK] D3 is the most precise statement of the keystone: "the refold synthesises firings at *past*
  execution positions (§sec:totalorder step c)... past-dated synthesis is the SINGLE WRITER's work...
  substrate only re-fires FORWARD" — verbatim-faithful to spec l.1456-1458.
- [OK] D13 (attribution/dispersion convention is a declared recorded term, never a worker default) is a
  nondeterminism source NO other proposal names — two workers with divergent defaults would disagree;
  grounded in VM-5.
- [DEFECT] Mapping table l.44 states "prevention, not detection (MD-16)" baldly, while Q4 (l.149)
  simultaneously flags the same gate as "the one place to look" and concludes "I find no conflict."
  Asserting no-conflict *and* deferring to an open question is having it both ways; the
  untrusted-constructor degradation (resolved in TEMPORAL-5 D7) is left uncontained here.
- [OK] Q2 honestly flags re-mark cadence ownership (unit workflow vs per-(unit,chain) workflow) — the
  nuance TEMPORAL-3 flattens.
- [DEFECT] Neither D2 nor D10 addresses that the door's exactly-once (on txid) does not make the
  re-entered VALUE deterministic for a non-bit-reproducible model — the set-wide gap, uncovered by any
  D-row despite the catalogue's breadth.

## TEMPORAL-5

- [OK] **Deepest on the model-numerics obligation.** D2 separates "read-back unconditionally" (the
  recorded number stands) from "re-derivation" (needs a recorded numerical environment), and Q3
  explicitly asks whether a numerical-environment version is pinned for bit-reproducibility — which
  bounds MD-14/VM-8 dispute-readiness. The honest containment of the hardest determinism issue.
- [OK] D7 gives the crispest prevention→detection statement: "a mis-gate degrades to a detectable,
  forward-repaired defect, exactly as an economically-wrong contract does" — resolved in a containment,
  not deferred (cf. TEMPORAL-4 Q4).
- [OK] D6 gate-atomicity is precise: shared pinned cut to both gate and construction, "atomicity from
  the shared cut, not from Temporal ordering"; a moved base → stale cut → refused (consistency of
  reference). Correct locus (MD-12).
- [DEFECT] D5's "heartbeat + bounded ScheduleToClose so retry fires only on genuine failure" reduces but
  does not eliminate concurrent double-execution (worker crash after emit, before ack). For a
  non-bit-reproducible model the canonical VALUE still turns on a door-arrival race; D2's read-back makes
  one number authoritative but not deterministic across reruns. Named in Q3, not contained.
- [DEFECT] Mapping table l.42 collapses "broken chain (VM-7) / gate failure / door refusal" into one
  row. These are three doctrinally distinct returned-value outcomes at three loci (a projection residual
  breach; a construction-time verdict; an admission-time verdict). Collapsing risks a reader treating a
  VM-7 broken chain as if it were a door refusal. Name them separately.
- [OK] Constitutional handling is honest (D11 cites C-12.5/C-2.8; only observations re-enter production,
  no move crosses back).

---

## Cross-cutting

**Strongest on rigor (Round 1): TEMPORAL-4**, on the breadth and fidelity of its mapping/containment
catalogue — it is the only proposal to name the bare-read divergence (D1) and the attribution-convention
nondeterminism (D13), it states the past-dated-firing keystone (D3) with verbatim fidelity to
§sec:substrate, and it does not equivocate on record kinds the way TEMPORAL-1's "two record kinds"
opening does. Two rivals lead on specific axes and the committee should harvest from all three:
**TEMPORAL-5** is TEMPORAL-4's equal on determinism depth (D2/D7 — the numerics and the
prevention→detection degradation), and **TEMPORAL-2** is strongest on constitutional-seam rigor (Q2
genuinely exercises C-4.11/PARK-1 rather than asserting an empty index). TEMPORAL-4's own weakness is
the mirror image: it defers the prevention tension that TEMPORAL-5 contains.

**Single most important unresolved determinism obligation (whole set).** The recorded VALUE of a
re-entered observation (a model output) is deterministic only if the model is **bit-reproducible given
its recorded inputs and seed**. Under at-least-once retry, two attempts of a float/GPU-nondeterministic
model present the *same* cause-derived txid with *different* payloads. The door's idempotence then
preserves exactly-once ADMISSION (first-wins) but makes the canonical value depend on a door-arrival
race — a genuine nondeterminism source. "Record the seed" (TEMPORAL-1/3) does not neutralise
nondeterminism at fixed seed; TEMPORAL-5's read-back/numerical-environment split (D2/Q3) names the
divergence but leaves it open; TEMPORAL-2/4 do not confront it at all. No proposal contains it. The
committee must close it — plausibly by either (a) making bit-reproducibility an admission precondition
for re-entered observations, or (b) declaring the first-admitted value canonical-by-fiat and stating
plainly that re-derivation guarantees read-back only, not bit-equality — and in either case reconciling
the choice with MD-14/VM-8 dispute-readiness. This is distinct from, and currently weaker than, the
exactly-once ADMISSION claim, which the whole set discharges correctly via the door's txid.
