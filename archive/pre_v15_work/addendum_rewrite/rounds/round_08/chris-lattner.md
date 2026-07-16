# Round 8 Scorecard — chris-lattner

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Progressive disclosure — simple path first and unobstructed; each abstraction
earns its place; notation is interface, not obstacle.

**Grade: A (92%)** — clears the bar, staked on my lens.

## Method this round

Fresh full read of the .tex (843 lines) and the full reference (`reference/StatesHome.hs`,
573 lines), not a carry-forward of R7. I re-verified that every cross-surface the prose
leans on actually resolves: the four expressibility signals S1–S4 are present in the
reference and say what §4/§9/§11 claim they say; the C11 demonstrators `_c11_ok_settle`,
`_c11_ok_fee` and the commented `_c11_bad` exist exactly as cited at line 807; `\lstinputlisting`
resolves. The document is byte-stable on my surface and introduces no regression.

The A-bar I test: can a competent quant engineer who has read none of the prior rounds
reach the correct model in one careful pass, with nothing cryptic in my domain, correctness
preserved, and nothing cuttable without loss. I deliberately re-stress-tested the three
carried friction items rather than inheriting last round's verdict.

## Why this clears A

- **Simple path is first and unobstructed, at three altitudes.** Abstract (48–62) → §1
  question (72–83) → §3 three-line map block (155–159) → §13 one-sentence answer (825–830).
  The reader gets the whole schema — three maps, one mutation discipline each, no W-sector —
  before any condition, GADT, or proof is demanded. The four instruments (§4) and the
  reference (§12) are descents taken only as far as the reader chooses. Gentle on-ramp, no
  ceiling. This is the property I most care about and it holds cleanly.

- **Each abstraction earns its place.** §6 (560–585) discharges "and *only* three" with one
  forcing constraint per map and an explicit "removing any one breaks the corresponding
  constraint." The absent fourth map is a *named, load-bearing absence* (C12, §4.2; design D,
  §10), not a silent gap. No map is present "in case."

- **Complexity is progressively disclosed across the type machinery.** C2 lands as plain
  sum-to-zero arithmetic in the body (254–270); the fold-homomorphism / `>=>` framing is
  deferred to §9/§11 and the reference, with `>=>` glossed at first use (683–690). Beginner
  sees a fact, expert sees the law. C11's note that field-writers and C2 event classes are
  *different axes whose names are not meant to coincide* (313–316) defuses the single worst
  name-collision a careful reader would otherwise hit.

- **Notation is interface, not obstacle.** `0_P` (the all-fields-zero value) vs `flat` (the
  conserved-fields-zero class) are cleanly separated (128–131); the §3 note that map value
  types share their sector names while the reference uses `ledgerUS`/`ledgerPS` to keep them
  apart (161–164) removes a collision before it bites; every inline tag in the §3 block is
  pre-glossed in §2.

- **Honest about where the encoding stops.** §11 intro (668–676) defines "unrepresentable"
  precisely and concedes conservation is value-level (S4). Naming the seam between type-level
  and value-level guarantees is the mark of infrastructure built to be extended, not a demo.

Nothing in my domain is cryptic; correctness is preserved; I found nothing whose removal is
a clear net gain to the document as a whole.

## Residual non-blocking friction (re-tested this round, still below my bar)

- **The `balance` demonstrator is the sharpest exposition cost.** The §2 notation entry
  (122–127) front-loads a dense motivation-before-context clause for a field that exists only
  to exercise C11 on a *conserved* field with a writer distinct from `ac`'s. On first read it
  is genuinely odd, encountered before C11 is defined. I re-tested cuttability: it is not
  cuttable from the *document* — C11's per-field-writer claim must be demonstrated on a
  conserved field with a non-`ac` writer, and the only other writers (`hwm`→crystallise,
  `entry_nav`→subscribe) sit on non-conserved fields, so `balance` earns its place. It is
  *relocatable* (the §2 entry could shrink to a one-clause pointer "reference-only
  demonstrator; see C11" with the rationale living at C11), which would cut friction at zero
  comprehension cost — but relocation is not cutting, so the A-bar's "nothing cuttable without
  loss" is not violated. This is what keeps the grade at the bar rather than above it.

- **§2 places some notation before its motivation** (`$\Delta f$`, `$0_P$`, `$u_{MA}$`, the
  `balance` rationale, before C11/the reference exist). Conventional for a spec; forward
  pointers mitigate; first-skim takeaways survive.

- **§4 presents conditions out of numeric order** (C2 before C1 in §4.1; §4.4 runs C7, C5,
  C9, C10, C6, C8). Pre-warned as stable tags, not a sequence (212–216), indexed one line
  each in §5, each condition self-contained at its definition. The numbers are names, not a
  dependency order. Comprehension intact.

None of the three gates a single careful pass. I re-stake my lens on A at 92% — deliberately
at the bar, not inflated above it: the `balance` exposition cost and the
documented-not-renumbered condition scheme keep the simple path unobstructed but not
frictionless.
