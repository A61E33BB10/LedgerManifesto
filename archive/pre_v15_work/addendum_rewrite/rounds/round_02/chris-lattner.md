# Round 2 Scorecard — chris-lattner

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Progressive disclosure — is the simple path first and unobstructed? Does each
abstraction earn its place? Is notation an interface, not an obstacle?

**Grade: A (90%)** — at the bar, staked on my lens.

## Verdict against my Round-1 holds

R1 held this at B (85%) on two blocking defects in my exact lens. Both are resolved to A
standard:

### Issue 2 (R1) — `$0_P$` defined and used ambiguously — FULLY FIXED
This was the one with correctness reach: the symbol meant to anchor the load-bearing
"never held vs held-and-flat" distinction was wobbly, and it contradicted the wind-down
case that retains a final HWM on a flat row.

The fix is clean and structural, not cosmetic:
- The notation (lines 122–128) now carries three distinct entries — `conserved field`,
  `flat` (conserved fields zero), and `$0_P$` (every field zero, `= zeroP`) — and states
  plainly "a first-touch row is `$0_P$`; a flat row need not be."
- C1(a) (line 282) now reads `Some(p)` with `p` flat, not `Some(0_P)`.
- C1(b) close-out "leaves a flat row"; the §4.3 wind-down's retained final HWM is now
  consistent with both.
- The reference agrees: `zeroP` is all-fields-zero (line 173–174), and the comment
  "held-and-flat means psAc = psBalance = 0; psHwm/psEntryNav are [unconstrained]"
  (line 161) matches the prose `flat`.

`$0_P$` is now one unambiguous value and `flat` is the equivalence class. Exactly the
split I asked for, and the symbol now does its job without hedging.

### Issue 1 (R1) — condition numbering vs reading order — MITIGATED TO BELOW MY BAR
The committee kept the load-bearing labels (referenced by §8, §12, §7, and the checklist)
and added one orientation paragraph at the head of §4 (lines 205–209): conditions are
introduced where forced; C1–C12 are stable labels indexed in §5, not appearance order;
the first met is C2; "they are read as tags, not as a sequence."

I asked for renumber-or-explain. They explained rather than renumbered, so §4.4 still
runs C7, C5, C9, C10, C6, C8. But this no longer blocks one-pass comprehension, which is
my actual A-bar — and on reflection it never threatened comprehension, only navigational
neatness:
- Every condition is fully self-contained at its point of definition. Understanding C2
  never requires having seen C1. The numbers are names, not a dependency order.
- The reader is now armed up front (the labels are declared as tags) and the §5 index is
  one section away, one line per label. This is a documented, indexed stable-tag scheme —
  the same contract as RFC requirement labels or stable error codes. That is notation
  functioning as an interface, not an obstacle.

This is the honest tension that keeps the A at the bar rather than above it: the
near-zero-cost cleanest fix (ascending within subsections) was declined in favour of a
meta-explanation. From a pure progressive-disclosure standpoint, an abstraction that must
explain "do not read these as a sequence" earns frictionlessness only with a footnote.
But a footnote that fully pre-empts the confusion is sufficient for one careful pass. Not
a blocker.

## Why this clears A (staking my lens)

The simple path is first and unobstructed, at three altitudes: abstract → §1 question →
§3 three-line listing → §13 one sentence. A competent quant engineer who has read none of
the review history reaches the right model from §1 → §3 → §13 alone.

Each abstraction earns its place and the disclosure is staged deliberately:
- §6 discharges "and only three maps" with one forcing constraint per map; the W-sector,
  a named absence, is load-bearing for the negative thesis (C12, design D), so reasoning
  about a non-existent thing is justified rather than a smell.
- The categorical/type machinery stays deferred: C2 is arithmetic in the body, the
  homomorphism/Kleisli framing lives in §9 and the reference. Beginner sees a sum-to-zero
  fact; expert sees the law.
- §9 now states "unrepresentable" in a precise, non-inflated sense and concedes
  conservation is a value-level check (S4) — honesty about where the encoding stops is
  the mark of an interface built for extension, not a demo.
- New clarifications that actively help one-pass reading: C11's explicit note that
  field-writers and C2 event classes are different axes whose names are not meant to
  coincide (lines 305–308); the §3 note that the map value types share their sector names
  by intent while the reference uses `ledgerUS`/`ledgerPS` to keep them apart (lines
  158–161). Both remove exactly the kind of name-collision a careful reader would trip on.

Nothing in my domain is cryptic, correctness is preserved, and I found nothing cuttable
without loss.

## Residual non-blocking friction (for the record, not gating)

- **§4.4 still presents six conditions in non-ascending numeric order.** Documented as
  tags, indexed in §5; comprehension intact. If a later pass wants to retire the §4
  orientation paragraph entirely, ordering conditions ascending within each subsection
  would let that paragraph shrink. Pure elegance, no comprehension cost.
- **§2 Notation precedes motivation** (carried from R1). Position-state symbols
  (`$\Delta f$`, `$0_P$`, `$u_{MA}$`) are introduced before they bite. Conventional for a
  spec; forward-pointers mitigate. Notation-first rather than need-first, but not an
  obstacle.
- **§9 leans on v10.3 §11 P-statements** not inline. Parenthetical glosses are the right
  accommodation given the addendum format; nothing to change.

These are below my blocking threshold. A reader gets through in one careful pass.
