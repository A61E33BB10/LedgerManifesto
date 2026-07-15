# DIRAC — Round 8 — States.tex

## Verdict: NOT-YET

The skeleton is genuinely beautiful: two distinctions (key, correction
discipline) generate a 2×2; three cells occupied, one provably empty; three
homes ride in two maps. When that grid holds, the answer feels inevitable. But
inevitability of "three, not four" rests entirely on the empty cell, and the
empty cell is argued in a *different currency* than the three occupied ones.
That cross-currency switch is the unexplained seam.

## The residue (located, actionable)

**The fourth cell is placed by a criterion the document has already disclaimed.**

- §Answer (lines 75–77) fixes the second axis emphatically and twice: *"Both
  are replay-recoverable; what places a fact is not recoverability but whether a
  past-dated value is read at the boundary."* This is the test that fills the
  three occupied cells — terms vs status is settled by boundary-read, not by
  recoverability.

- §Why Three, the empty-cell paragraph (lines 152–156), then places the fourth
  cell by recoverability and the seal, not by boundary-read: *"by minimalism the
  owned and recoverable is never versioned, so no owned fact carries a version
  list."* This re-imports recoverability as the disqualifier — the very
  criterion §Answer said does not place a fact. As stated, "recoverable ⇒ never
  versioned" is also false on its face: terms are declared replay-recoverable
  (line 133) yet *are* versioned. A fresh reader hits a direct collision and
  cannot tell which rule governs.

- The true load-bearing reason is neither minimalism nor recoverability but the
  seal alone: every (holder, unit) fact already has `applyMove` as its writer
  (the closure argument, lines 100–108), so a correctable definition on that key
  would be a *second* writer of an owned fact. That is a clean, single-principle
  argument. The paragraph buries it under three competing strands (minimalism +
  recoverability + seal) and the reader cannot see which is doing the work.

- The tell is in the prose itself: the empty cell needs ~18 of the densest lines
  in the document and *three* defensive hedges — "This does not reopen
  authorship", "among unit-keyed facts correction discipline alone separates",
  "here the question is which key may host a definition at all, and the seal
  answers it." Each occupied cell is settled in two or three lines with one vivid
  example (buyer/seller, one settlement price, benchmark identity vs level). A
  cell that needs an order of magnitude more argument and three anticipated
  objections is not yet reading as inevitable — it is being defended.

## What would make it OBVIOUS

Place the empty cell by the *same* test that fills the other three. Either:

1. Show directly that no (holder, unit) fact requires a past-dated value read at
   the boundary without replay — the grid's own second axis — so the cell is
   empty on the same axis that distinguishes terms from status; or

2. Promote the seal to the single stated reason for occupancy (every
   (holder, unit) fact is owned by `applyMove`; a definition there is a second
   writer; hence empty) and *delete* the "owned and recoverable is never
   versioned by minimalism" clause that re-imports the disclaimed criterion and
   collides with versioned terms.

Until the fourth cell answers to the same judge as the other three, the
structure is correct-looking but the "three" rests on a special case argued in
borrowed currency.
