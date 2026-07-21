# TuringAward — Temporal Committee Referee Feedback, Round 2

Role: standing referee, architecture judgment + convergence steering + Constitution §4 anti-bias. Advisory,
no veto. Lenses this round: L1 (liveness under contention — the new fork), L2 (write atomicity, idempotence,
value-vs-admission determinism), L3 (pinned-cut invariant, as-known verdict, termination/livelock), L5 (the
three record kinds; kind-2 vs kind-3 staleness semantics), L6 (minimalism — what to delete), touching L8/L9.

**§4 anti-bias — all five still PASS.** No R2 proposal introduces anything categorically first; none leans a
proof on a functor, adjunction, or box. "Injective/idempotent/projection/pinned cut/refold" are ordinary
terms with concrete examples. Nothing to flag under §4.

**Headline.** Forks A and B converged as steered, with no backsliding (T-2 explicitly *retracted* its two-write
pole; T-3 *withdrew* its blanket Schedule claim; T-4 *retracted* its Fork-C commitment). C and D are settled-soft.
The namespace seam is **pinned five-way on one predicate**. The determinism gap is **closed**, convergent on a
two-tier read-back/re-derivation contract. **But resolving Fork A's loose end split the committee into a NEW
fork — A′ (refuse-vs-flag on a base moved under the pinned cut) — and two members resolved it against certified
upstream doctrine.** That, plus one scope-boundary wording conflict, is the whole of what remains open.

---

## TEMPORAL-1 (nominated mapping base)

- Correctly re-based to **three record kinds** (projection / re-entered observation / recorded-decision-pinned-
  as-known), and the third is *not a new primitive*: "the base ledger already has it as the door's admit/refuse
  (spec l.1051)." This is right and it is load-bearing — see A′. Minimalism intact (naming an existing shape,
  not adding one).
- Fork A resolved atomic (§2.2 "state and its passing gate verdict cross the door as ONE transaction"). Matches
  MD-12 and the certified MDM-dynamics reading. Good.
- **A′ resolved correctly (FLAG):** §2.2 — "refuse is a construction-time verdict (gate fail/undecidable, or the
  door's consistency-of-reference check fails); flag-stale is later … a moved base **flags stale, it does not
  retroactively refuse**." This is the certified answer (see Fork A′ below). Adopt T-1's split verbatim.
- Fork B split + "reads the unit's node" (§2.3); seam pinned (§2.2); determinism closed by compute/emit split (§3).
- Verdict: **confirmed mapping base.** Its A′ wording is the one to carry committee-wide.

## TEMPORAL-2

- Sound merger: cedes base to T-1/T-4, retracts two-write, contributes the idempotence key, the Q2 seam list,
  and a clean determinism closure. Distinct value carried, nothing lost.
- **A′ gap (named missing case):** §2 asserts "the base **cannot** move between gating and construction — so
  staleness is never a construction-time verdict." That is true of the *internal* gate evaluation (all activities
  read one cut) but does **not** cover the pinCut→door-admit window, where the single writer can admit a
  correction at ≤C before the derived-state transaction lands. T-2 is silent on that window; it must take the
  FLAG side explicitly (it already leans there via "stale-forward").
- Determinism substrate rule is good ("never retry expecting a matching value, never compare two attempts'
  payloads") but must be reconciled with T-4's door-side content-hash — different actor, see path-to-consensus.
- Verdict: adopt idempotence-key + seam list + determinism substrate-rule; close the pinCut→admit gap on the FLAG side.

## TEMPORAL-3

- Sound merger; two-tier determinism contract (§2a) is the crisp statement — Tier 1 read-back (spec-mandatory),
  Tier 2 re-derivation (governance-optional, env-version). Adopt this framing.
- **A′ resolved wrongly (REFUSE):** §2b — "a stale cut at construction (the pinned base moved under the demand)
  is **refused** … the state never existing." This contradicts certified MD-16 (see A′): a moved input flags m*
  stale forward, it does not refuse. T-3's own §1 mapping calls the decision "record kind 3 … NOT MD-8-stale, an
  as-known fact" — so refusing it when the base later moves contradicts its own taxonomy.
- Correctly guards the scope boundary: Tier 2 is "never a spec-level admission precondition, because that would
  reach into out-of-scope numerics." Hold this line against T-5 §3(b).
- Verdict: adopt determinism framing + Fork B split; **flip A′ to FLAG.**

## TEMPORAL-4 (nominated catalogue base)

- Confirmed catalogue base: D1 bare-read, D13 declared-convention, split≠ContinueAsNew all carried; D7 (prevention/
  detection), D14 (value≠admission), D15 (write atomicity) are strong new rows. Fork-C commitment correctly
  retracted. The Fork-B refinement is the best in set: the Schedule sweep's **pricing activity reads the unit's
  node/frame/cut FROM THE RECORD (VM-2)**, so even the system sweep is frame-correct — adopt this wording.
- **A′ resolved wrongly (REFUSE), and internally inconsistent.** D15/§2.2: "A base moved under the pinned cut ⇒
  stale cut ⇒ the door **refuses** (C-11.3) … Refuse, not flag — a verdict against a base that no longer holds is
  meaningless." Two defects: (1) it *misreads C-11.3*, which is a **structural** quantity/price-coordinate guard
  (ledger_manifesto.tex l.433: "authorisation, idempotence, consistency of reference, writer discipline"; VM-9's
  phantom-valuation/zero-PnL guard), **not** a tip-freshness check; (2) it contradicts D9/its own kind-3 ("gate-
  decision pinned as-known, not stale-on-input-move") — a later base move stales the *state* (kind-2), it does not
  make the *decision* "meaningless."
- Verdict: catalogue base **confirmed**; D15's refuse pole must be corrected to FLAG (see A′). Everything else adopt.

## TEMPORAL-5

- Resolution carrier, sound. Two best-in-set contributions: (a) **compute/emit split removes the door-arrival race**
  ("Never fuse model-eval with door-propose — fusing is what reopens FORMALIS's race", §3a) — this is the primary
  determinism mechanism; (b) the numerical-environment pin as Tier-2 dispute bound (§3c). Also the three-returned-
  value-loci table (§2) and the stream-vs-namespace articulation (§5: "a *stream* boundary, not a *namespace* one").
- **A′ resolved correctly (FLAG):** §4 — "A moved base is **flagged stale, never refused** … the ledger's single
  writer decides this, on the refold — not the door, not the gate." This is the certified answer. Adopt §4 verbatim
  as the committee's A′ resolution.
- **Scope-boundary overreach (fix):** §3(b) calls bit-reproducibility "the producer's **admission-time contract**,
  enforced by … recompute and compare." This narrows the out-of-scope-numerics boundary and conflicts with T-3/T-4
  ("never a spec-level admission precondition"). §3(c) states the safe version. Drop §3(b)'s "admission-time
  contract" phrasing; keep §3(c). Also sync its stale concession line: T-1's base is **three** kinds, not "two."
- Verdict: adopt determinism split + env-version + loci table + A′; reconcile §3(b) to §3(c).

---

## Fork status

### Fork A — MD-16 single-transaction write. **SETTLED.**
All five: derived state + passing gate decision cross the door as **one transaction over one pinned cut** (MD-12).
T-2 retracted its two-write pole. This is not merely converged among the five — it is the certified MDM-dynamics
reading: "the gate and the constructed m* are **one projection-evaluation over that single pinned cut**"
(kleppmann_dyn_review.md l.15). No inconsistent-read window. Done.

### Fork A′ — refuse-vs-flag on a base moved under the pinned cut (NEW; REAL; correctness + liveness; L1/L3). **OPEN — but already adjudicated by certified doctrine; needs correction, not a new decision.**
Resolving A's loose end split the committee three ways on one scenario — *a correction to a consumed input is
admitted at ≤C between pinCut and door-admit*:
- **FLAG (T-1 §2.2, T-5 §4, T-2 leaning):** admit m* as-known-at-C; the single writer flags it stale-forward
  (MD-8/MD-10). Refusal reserved for gate fail/undecidable (gate decides) or an unresolvable structural reference
  (door decides).
- **REFUSE (T-3 §2b, T-4 D15):** the door refuses the stale cut (C-11.3); re-pin and re-gate. "A verdict against a
  base that no longer holds is meaningless."
- **T-2:** claims the scenario "cannot arise" — true internally, silent on the pinCut→admit window.

**Counterexample the fork turns on (livelock).** A 90-second GPU calibration pins C at t=0; a vendor correction to a
price at ≤C is admitted at t=45s; the derived-state transaction lands at t=90s. Under REFUSE the door refuses,
re-pins, re-runs the 90s model — and if corrections arrive every 45s it **never converges** (a liveness/termination
defect, L3). Under FLAG the state admits and is immediately flagged for forward re-derivation — progress guaranteed.

**Adjudication (certified upstream, not my opinion).** MD-16 as certified: "(A later correction to one of m's inputs
does not create a TOCTOU: it **flags m\* stale forward via MD-8/MD-10, exactly as any re-entered quantity, m\***
**remaining the as-known-at-cut value it was gated as**.)" (kleppmann_dyn_review.md l.15); headline: "replay uses the
terms **as declared at application, not as they later stand**." And C-11.3 is a **structural** consistency guard
(l.433; VM-9 phantom-valuation guard), **not** a freshness check — so T-4's "refuse (C-11.3)" misreads the clause.
By the committee's own three-kind taxonomy the m* state is **kind-2** (re-entered observation → flags stale on
consumed-input-move) and the decision is **kind-3** (pinned as-known, not stale). REFUSE conflates the two.
**Resolution: FLAG (T-1 §2.2 / T-5 §4 wording).** The final clause reading is CONCORDIA/FORMALIS's to certify, but
the answer is already on the record; T-3/T-4 must flip D15/§2b. This is the sharpest open item of the round.

### Fork B — valuation re-mark cadence. **SETTLED (with the strongest wording named).**
All five adopt the spec's contractual-vs-system split (`temporalv16.tex:58-59,99`). Two complementary mechanisms,
both required, don't muddle them: (1) **trigger cadence** — system EoD marks → Schedule sweep; contractual/CA/input-
moved re-marks → per-unit watch; (2) **frame correctness** — the sweep's pricing activity **reads the node/frame/cut
from the record (VM-2)** (T-4 §2.3, T-5 §5), so it is frame-correct regardless. My R1 wrong-frame counterexample is
now doubly closed. Adopt T-4/T-5's read-frame-from-record wording as canonical.

### Fork C — models/derivation queue. **SETTLED-SOFT.** All five: a load-model-gated scaling parameter, not an
architecture fork; the mapping is identical either way. T-4 retracted its commitment. Do not force; carry the load
model as the named gating unknown.

### Fork D — simulation fan-out shape. **SETTLED-SOFT.** All five: decomposition, not correctness. Correctly noted
this child-workflow use (history-bounding *inside* a sim namespace) is **not** the seed's forbidden lineage-coupling
use — no spine violation either way.

### Namespace seam (production derived stream vs isolated sim namespace). **SETTLED — five-way on one predicate.**
All five pin the same discriminator: *does a real production unit's valuation chain consume/read it back?* Yes →
**production lineage, tagged derived-stream (never the base stream), production door**; No → **isolated namespace,
own lineage's door** (R-20). Credential separation follows: production door admits base + production-derived states;
sim door is a separate credential. T-5's articulation is the crispest — "MD-16's 'derived states never enter the
base stream' is a **stream** boundary, not a **namespace** one" (two orthogonal separations). My R1 unpinned seam
is fully resolved.

### Determinism gap. **CLOSED — convergent on two tiers; one merge-hygiene item.**
Tier 1 read-back (canonical-by-first-admission, spec floor, discharges MD-14/VM-8); Tier 2 re-derivation
(governance-optional, needs the pinned numerical-environment version). Primary mechanism is the **compute/emit
split** (T-1 §3, T-5 §3a): the model runs once, its output is memoized, door-propose re-presents identical bytes —
the race is *structurally removed*, not merely reduced. T-4's **content-hash beside the txid** is a complementary
*diagnostic* for the residual case (a buggy fused worker), not a competing mechanism. These compose; see path.

---

## Path to consensus (what remains before a Pareto-optimal design all 5 can sign)

Two substantive items and two hygiene items. No consensus declared — this is Round 2 of ≥10.

1. **Resolve Fork A′ to FLAG (the one live correctness fork).** Adopt T-1 §2.2 / T-5 §4: a moved consumed input
   **flags m\* stale-forward** (MD-8/MD-10, single writer decides on refold); the door refuses **only** on a gate
   fail/undecidable verdict or an unresolvable structural reference; C-11.3 is a structural guard, not a freshness
   check. T-3 (§2b) and T-4 (D15) flip their refuse pole. Optional cleanliness without livelock: a **producer-side
   freshness pre-check** (re-read the tip before proposing; if C is already superseded, skip and re-pin) — an
   optimization, **never** load-bearing, because the flag path catches any born-stale state that races through.
   Route the exact C-11.3-vs-MD-8 clause reading to CONCORDIA/FORMALIS for a certifying signature (the answer is
   already on record via MD-16; this is confirmation, not a new decision).

2. **Reconcile the scope boundary to one voice.** State once: canonical-by-first-admission is the spec default;
   bit-reproducibility is **never** a door/admission precondition (out-of-scope numerics, C-Scope.11); the
   numerical-environment pin is a **governance-optional Tier-2** dispute-readiness term, caught at audit. T-5 §3(b)
   yields to §3(c)/T-3/T-4. This is a §1-narrowing guard: do not let dispute-readiness quietly become an admission gate.

3. **Merge hygiene — determinism.** Fold the closure as: compute/emit split (T-1/T-5, **primary**, removes the race)
   + numerical-environment pin (T-5, **Tier-2**) + content-hash diagnostic (T-4, **optional**), and state the
   actor boundary so T-2's "substrate never compares payloads" and T-4's "door records a content-hash" do not read
   as a contradiction: the *substrate* never compares; the *door* (trusted single writer) may record a hash as a
   diagnostic without changing which value is canonical (still first-admitted).

4. **Wording sync.** The mapping base is **three** record kinds; T-5's concession line still says "two." Fix so the
   merged artifact is internally consistent.

**Assembly target.** Build the merged mapping on **TEMPORAL-1** (three kinds + lineage discipline) and the divergence
catalogue on **TEMPORAL-4** (D1/D7/D13/D14/D15, with D15 corrected to FLAG); fold in T-2's idempotence key + seam
list, T-3's two-tier determinism + versioning axes + Fork-B split, T-5's compute/emit split + env-version + loci
table. After items 1–4, the artifact is ready for FORMALIS/CONCORDIA certification. The single biggest thing standing
between the committee and consensus is **Fork A′** — two proposals resolved it against certified MD-16 doctrine, and
until D15/§2b flip to FLAG the mapping is not correct.
