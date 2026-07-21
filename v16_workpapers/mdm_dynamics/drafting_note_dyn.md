# Drafting note — MDM 1.3, Market Data Dynamics (MD-16)

Author: GATHERAL (lead). Binding input: `memo_jacobi_distributions.md`. Co-pass to
follow: THORP (dividends). Rigor: FORMALIS (gate formalism). Review: KLEPPMANN,
TALEB. Certification: CONCORDIA (duties: no numeric thresholds; page delta ≤3).

## Review round 1 — applied (FORMALIS RETURN light, KLEPPMANN 1M+2m, TALEB PASS 1M+minors)
THORP's dividend co-pass had already landed (dividend non-monotonicity + the
"undecidable" thin-history honesty in H1); I re-read the live file before editing.
Applied, all funded by tightening **inside MD-16** — doc stays **12pp** (cap), ×2 exit 0,
0 overfull, **1.2 byte-stable** (git-clean).
- **FORMALIS blocker (operator overload):** genus "operator family" → "family of
  declared **world-maps**" (his wording); "a declared operator built it" → "a declared
  **dynamic** built the state"; amendment-record + header comment renamed. Lineage
  ambiguity fixed: lineage now names **the dynamic applied** AND **any market data
  operator its span crossed (MD-13)** separately. Only "market data operator" (qualified)
  survives in MD-16 → FORMALIS's one-component-per-name breach closed.
- **KLEPPMANN MATERIAL (attack 4):** consumption now (i) enforced **by admission record**
  (a state with no passing gate-decision cannot be named/consumed) and (ii) scope-bounded
  — prevention on the **constructed** layer, **MD-9 detection** at the calibrated base a
  world roots in, so a backtest inherits detection-at-root + prevention-at-every-derived-
  step, **not uniform prevention**. M1: base **pinned at one application cut**, gates+
  construction one evaluation (MD-12), no TOCTOU. M3: derived stream never enters the base
  stream, base-history serving (MD-4) unaffected by derived-state volume.
- **TALEB MATERIAL (F1):** joint gate is the **hungriest for data** — undecidable most
  often on high-dim vectors; a joint-plausibility convention on sparse history is a
  disclosed, versioned **modelling assumption about the joint tail**. Minors: too-loose
  region named (VM-6 precedent, auditable/never silent); **undecidable ⇒ not admitted, the
  refusal recorded** (ruled with prevention, per coordinator, not TALEB's admit-with-flag);
  "acceptance region" glossed at first use.
- **Dropped (not requested by coordinator, budget-bound):** F-min-3 (vol-spread sharpen),
  F-min-1 (consolidate declaration burden). Flag if a later round wants them.
- **Net budget:** additions ~+16 lines funded by tightening the gate-decision paragraph
  (dropped the non-load-bearing C-4.11 "balance-coordinate scope" clause FORMALIS flagged;
  kept the load-bearing pinned/as-known/no-drift argument), the Gate-1 grounds sentence,
  the redundant second MD-9 reconciliation, and the placement sentence. Still 12pp.
- **Sign-off status:** FORMALIS said "apply the naming fix and FORMALIS signs" — done.
  KLEPPMANN/TALEB material both addressed within-framework, no park.

## File / compile / pages
- `MarketData/MarketDataManifesto_1.3.tex` = verbatim copy of 1.2 + one new article
  + one MD-11 sentence + a 1.3 amendment record. **1.2 is untouched** (byte-stable).
- pdflatex ×2, **exit 0**, 0 overfull hboxes, no undefined refs.
- **Pages: 1.2 = 9 → 1.3 = 11. Delta = +2** (budget ≤3; one page of headroom left
  for THORP's dividend co-pass, which should refine in place, not add net length).

## Article decision: ONE new MD-n, not extensions
1.2 preferred extensions; here the doctrine is a genuinely new primitive (a
first-class *dynamic* + two admissibility *gates*) that would be **hidden** if
scattered across MD-9/MD-11/MD-13. So: one article, **MD-16**. Identifier is
append-only; it is **placed physically after MD-11** (adjacent to the shift/
derived-worlds doctrine, as instructed) though it carries number 16 — a one-line
orientation sentence tells the reader why it reads MD-16 before MD-12.

## Cross-references established (cited, not restated)
- **MD-11** (shift) + **VM PE-1/PE-5** (surface-move rule 𝒟): one *operator family*;
  "dynamic" = the member acting on a single datum. VM-5≡𝒟 bridge cited as the VM's,
  not restated. MD-11 gains one sentence: risk consumes only gated states.
- **VM PE-1(A5)**: Gate 1 *grounds* the standing hypothesis Σ(·;S)∈𝒜 — "what A5
  assumes, this gate guarantees at application." One sentence, no restatement.
- **MD-9**: explicit reconciliation — prevention (Gate 1) is available because a
  declared operator's output admissibility is a decidable predicate on a projection;
  MD-9's detection-not-admission stands where no-arbitrage needs a model to test.
- **MD-2**: the gates govern *constructed* states only; a real observation is always
  captured. This is the master reconciliation that keeps MD-2 and MD-9 intact.
- **MD-15** (price-space validation in derived worlds), **MD-14** (lineage,
  dispute-ready), **MD-6/MD-8** (projection vs re-entered; read-back/re-derive),
  **MD-4** (as-known cut), **MD-13** (sibling operator). Corpus: Vol I §2.6 / Ch.4
  Axiom A3 for Θ_AF (the admissibility ladder).

## Storage-architecture threading (PARK-1's shadow) — the line WAS drawable, no STOP
The application of a dynamic is an **event** in the derived stream (MD-11). Its gate
decision (pass/fail, functionals, percentiles, history basis) is the **recorded
outcome of that event**, pinned at application with declared-term lineage — like the
single writer's admit/refuse — **not a projection of the base stream recomputed on
read**. The honest reason it is recorded, not recomputed: the decision turns on
*versioned* declared terms and an *as-known* history, so the number that stood at
application is an as-known fact (MD-4), re-derived only against terms/history as they
then stood (MD-6 split). **No collision with C-4.11:** "computed when needed, never
stored" governs quantities read off *balance coordinates*; a gate decision is an
*event-outcome*, and recording it is MD-11's discipline that a path capture its
outputs. PARK-1 (the VM's parked storage question) is cited in one honest line as
*not reopened and not turned on* — the architect's "like the product instantaneous
volatility" is read as the **audit discipline** (auditable, dispute-ready), not an
import of the parked question. FORMALIS/KLEPPMANN: this is the paragraph to stress.

## Rigor / doctrine coverage checklist (all present in MD-16)
Dynamic defined + versioned/attributable; operator-family cross-ref; two gates at
application; Gate 1 prevention-by-construction + grounds A5 + MD-9 reconciliation;
Gate 2 realistic/conservative percentiles per-functional-per-underlying-own-history;
both architect examples verbatim in spirit (1m–1y spread realistic; downward-spot →
total expected dividend conservative); joint essential + inverted-FV counterexample;
no numeric thresholds → declared-terms list; H1–H4 as four decidability conditions;
monitored functionals (FV, forward div yield, 1m–1y spread, total div; joint FV,
joint ATM); gate decision recorded (audit of verification); coherence (datum-model
pair, MD-15, broken-state forbidden, consume-only-admissible, MD-14 lineage).

## Unsettled / for reviewers
1. **THORP (dividends).** The dividend gate is stated at principle level (downward
   spot → total expected dividend, conservative percentile of the underlying's own
   dividend history). THORP to confirm the *dynamic's direction* (dividends fall when
   spot falls) and whether discounted vs undiscounted Dtot needs a declared-convention
   word. **Refine in place — +1 page headroom only.**
2. **FORMALIS (gate formalism).** H1–H4 are in prose, not labelled; the memo labels
   them. Confirm the four conditions map 1-1 and that "decidable predicate on a
   projection" for Gate 1 is the right formal footing for prevention-not-detection.
3. **MD-9 boundary.** The prevention/detection line is the one place MD-16 could be
   read as narrowing MD-9. It is written as *disjoint domains* (constructed state vs
   received observation / declared operator vs black-box fit), not a narrowing. If a
   certifier still reads a conflict, it parks with exact text — not drafted around.
4. **Θ_AF citation.** Cited to Vol I §2.6 / Ch.4 Axiom A3 by JACOBI's memo; if the
   corpus renumbers, re-resolve by label at integration (same discipline as Part B).

## THORP co-pass (dividends + practitioner functionals), 2026-07-21 — applied in place

Pages 11 → 12 (budget ≤12, met). pdflatex ×2 exit 0, 0 overfull, no undefined. 1.2 byte-stable.

**(1) Dividend doctrine — CONFIRMED direction, three refinements applied.**
- *Direction is desk-true.* "Expected dividend falls when spot falls" is the standard positive
  dividend–spot relationship (dividend futures carry equity beta; a sell-off marks forecast
  dividends down). Confirmed as the dynamic.
- *Non-monotone caveat added (example 2).* The dynamic governs the **forecast** portion only:
  already-declared dividends are fixed and spot-insensitive, and special dividends and outright
  cuts are not monotone in spot — which is precisely why the gate is the underlying's own history
  at a **conservative** percentile, not a point forecast a clean monotone rule would imply.
- *Dtot discounting ruled a DECLARED TERM* (not a manifesto constant): parenthetical at the
  functional ("discounted or undiscounted per a declared convention") + added to the declared-terms
  list. Matches JACOBI's memo.
- *Thin-history clause added (the material dividend-side gap).* Nonempty history was not enough:
  a name with too few dividend events to populate its dividend functionals' distribution supports
  no realistic percentile — Gate 2 now reports realism **undecidable**, "a hypothesis failure
  honestly flagged, never silently waved through." Closes drafting-note unsettled item 1.

**(2) Practitioner functionals — the four + two joints are the desk-watched set; ONE material flag
for the record (NOT added, per instruction).** FV(T1,T2), q_fwd, 1m–1y ATM spread, Dtot, joint FV,
joint ATM — all correct and desk-standard for a stressed-state sanity check. **Gap flagged: no SKEW
/ risk-reversal functional.** The set covers ATM level, ATM term structure, and forward variance,
but nothing on the surface's strike-slope. A derived surface with sane ATM and term structure but an
implausible skew after a down-move (the leverage effect should steepen skew) would pass all six.
Forward variance carries skew only indirectly (varswap strip); the joint ATM is ATM-only. For
equity vol this is the second sanity check a desk runs after ATM. Recorded for the architect's
decision; not added, as the monitored list is the architect's.

**(3) Architect examples — both desk-true and concrete.** 1m–1y spread within a realistic
percentile ✓ (term-structure slope has a historical cone). Down-move ⇒ Dtot within a conservative
percentile ✓ (guards the dangerous overstatement — a stressed state that keeps dividends too high
after a crash overstates the forward and underprices puts); example 2 now carries the "why
conservative" rationale.

**(4) Bans sweep (THORP seat) — CLEAN.** No practice narration in MD-16 (no "desks/traders/in
practice/typically/most"). The dynamic direction is stated as the content of a declared rule, not
as narrated behaviour; the refinements are structural facts (forecast vs declared-fixed dividends,
thin history), not custom.

**Unsettled after co-pass:** the skew-functional gap (item 2) — a desk-reality flag for the
architect: monitor a risk-reversal/skew functional (and its joint across tenors) or accept that
skew realism is out of the gate's explicit scope. Not a defect in what is written; a completeness
question on the monitored set.
