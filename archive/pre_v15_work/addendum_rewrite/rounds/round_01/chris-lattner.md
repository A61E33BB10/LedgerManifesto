# Round 1 Scorecard — chris-lattner

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Progressive disclosure — is the simple path first and unobstructed? Does each abstraction earn its place? Is notation an interface, not an obstacle?

**Grade: B (85%)**

## What works (and why it works)

This is a well-architected spec. The simple path is genuinely first and unobstructed:

- **The on-ramp is clean.** §1 states a single question. §3 answers it in a three-line listing
  that is the conceptual crux and is immediately legible. §13 restates it in one sentence. The
  abstract front-loads the same answer. A newcomer can read §1 → §3 → §13 and leave with the
  right model. That is progressive disclosure done correctly — the answer is available at three
  altitudes.
- **Each of the three maps earns its place**, and §6 ("Why Exactly Three Maps") discharges the
  "and only three" obligation with one forcing constraint per map. Removing any map breaks a
  named constraint. This is the minimum-basis argument made structurally, not asserted.
- **The categorical machinery is deferred, not thrust forward.** C2 states "sums to zero, by
  event class" in words; the group-homomorphism framing lives in the reference comments, which
  explicitly say "the categorical name is the LAST thing said, not the first." That is exactly
  the right ordering: the beginner sees an arithmetic fact, the expert sees a homomorphism.
- **The reference (§12) is the expert drop-down**, placed last, with prose bullets bridging each
  condition to its code construct. Powerful, available, not in the reader's face. The
  expressibility signals (S1–S4) are an honest record of where the encoding stops, which is the
  mark of an interface designed for extension rather than a demo.
- **The W-sector — a named absence — earns its place** because the thesis is a negative claim
  ("no wallet-keyed state"). Reasoning repeatedly about a thing that does not exist is normally a
  smell, but here it is load-bearing: C12 and design D both turn on it.

## Blocking issues (friction that keeps this off an A)

### 1. Condition numbering conflicts with reading order — notation as obstacle
**Location:** §4 throughout; index in §5; worst within §4.4 (`sec:untraded`).

The conditions are *defined at the instrument that forces them*, but their *numbers* follow a
different (roughly thematic) order. The order in which a careful first-pass reader actually meets
them is: C2, C1, C11 (§4.1), C12 (§4.2), C3, C4 (§4.3), then C7, C5, C9, C10, C6, C8 (§4.4).

So the very first condition the reader encounters is labelled **C2**, before **C1**, and §4.4
presents six conditions in the scrambled order C7, C5, C9, C10, C6, C8. The labels therefore
carry an ordering that matches neither the reading order nor any locally visible logic. The
reader is forced to treat every C-number as an opaque tag and bounce to the §5 index to place it.
This is precisely the case where notation stops being an interface and becomes a lookup tax.

*Actionable fix:* renumber the conditions to definition/reading order so the first condition met
is C1 and §4.4 runs in ascending order; or, if the thematic numbering is intentional, present the
conditions *within each subsection in ascending numeric order* and state the grouping rationale
once. Either removes the tax at near-zero cost.

### 2. `$0_P$` is defined and used ambiguously
**Location:** Notation table (lines 122–123); C1(a) (line 264); wind-down (§4.3, lines 406–409).

The notation defines `$0_P$` as "the zero PositionState: all conserved fields zero," then hedges
"the first-touch row and the held-and-flat row are both `$0_P$` *in their conserved fields*." So
`$0_P$` is simultaneously presented as a concrete value ("the zero PositionState") and as an
equivalence-class representative on conserved fields only. C1(a) then drops the hedge: "Some(0_P)
means held once, now flat." But the §4.3 wind-down keeps a flat row that *retains a non-zero
final HWM* for tax reporting, and the reference's `zeroP` is all-fields-zero (hwm = 0,
entryNav = Nothing). A flat-with-retained-HWM row is therefore **not** `zeroP`, so "Some(0_P)
means flat" contradicts the wind-down case. The symbol that is meant to anchor the load-bearing
"never held vs held-and-flat" distinction is itself wobbly.

*Actionable fix:* split the two ideas. Reserve `$0_P$` for the all-fields-zero first-touch row,
define "flat" as conserved-fields-zero (HWM/entry-NAV unconstrained), and in C1(a) write
"Some(p) with p flat" rather than "Some(0_P)." Then `$0_P$` is one unambiguous value and "flat"
is the equivalence class.

## Minor (non-blocking) friction

- **§2 Notation precedes motivation.** Symbols `$\Delta f(w,u)$`, `$0_P$`, `$u_{MA}$`,
  `$u_{QIS}$` are introduced before the reader has any need for them. Forward section-pointers
  mitigate this and it is conventional for a spec, but it is notation-first rather than
  need-first; consider deferring the position-state symbols to §3/§4 where they first bite.
- **§9** leans on P1/P3/.../P10 from v10.3 §11 that the reader does not have inline. The
  parenthetical glosses are the right accommodation; nothing to change given the addendum format.

## Why B and not A

The simple path is first and clean, abstractions earn their place, and disclosure is staged
deliberately — this is squarely above C. It is held off A by two notation defects in my exact
lens: a condition-numbering scheme that forces index lookups on a first careful pass (C2 before
C1), and a `$0_P$` symbol that is internally inconsistent against its own wind-down case. Neither
is cryptic and neither compromises the core correctness argument, but both are real friction a
careful reader hits, and both are cheap to remove.
