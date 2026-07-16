# Round 16 — jane-street-cto review of States.tex

## Verdict: NOT-YET

The document is correct, internally consistent with `States.hs`, and free of
overclaim. The 2x2 derivation, the seal/single-writer argument, the conservation
proof, and the replay/checkpointing claims all hold and are stated with measured
hedging. One located clarity defect keeps it short of "obvious."

## What I checked

- Listings reproduce the source declarations faithfully (`applyMove`,
  `netDeltas`/`writeNet`, `register`, `settle`, `appendVersion`, `currentTerms`,
  `PositionState`, `Ledger`, `replay`). Match confirmed against `States.hs`.
- Illegal-state claims hold: `Active Price` vs `Listed` makes "active w/o price"
  and "listed yet priced" unspellable; `NonEmpty` makes "registered but
  versionless" unrepresentable; the `(terms, status)` pair makes "terms without
  status" unwritable; unexported constructor + selectors close the
  record-update bypass (`l { ledgerPS = ... }`) — this subtlety is correctly
  named.
- Conservation: `applyMove` is the only `psBal` writer, writes two cancelling
  legs, base case `emptyLedger` is zero. Self-move and zero-qty move both net
  `mempty` per wallet and write no row. Sound.
- Replay: `apply` is pure and total (returns `Maybe`, terminates); `foldM`
  halts at first refusal; checkpointing rests on the monadic left-fold split
  law, which is valid. No overclaim in "every view is a projection."
- Scope honesty: the multi-instrument relationship is explicitly flagged as
  assumed, not proved (lines 58, 148-149). `appendVersion`/amendment out of
  scope is declared. These are disclosed, not residue.

## Residue (located, actionable)

### R1 — psHwm: the rationale is lead-buried; a dead field reads as a minimalism violation

Location: §The Construction, "A position carries more than a balance"
paragraph (lines 221-234), and the field declaration (lines 237-242).

`psHwm` is typed `Qty`, initialized to `mempty` by `zeroP`, never written and
never read anywhere in this file — it is permanently zero. The paragraph spends
roughly nine lines hedging it (no paired writer, no zero-sum invariant, no fold,
group structure unused, writer out of scope, "stays zero in this file") before
the actual justification arrives mid-paragraph: "One role is kept for psHwm
here, a non-conserved field beside the conserved balance."

A fresh reader hits this and writes the margin note the bar forbids: *why is a
field that is always zero, never written, never read, present at all — and why
reuse `Qty` if none of its group structure is used?* The document carries a
spec whose stated first principle is Minimalism ("the fewest primitives that
suffice"); an inert illustrative field collides with that principle, so the
justification must land first, not last. By the project's own clarity
convention ("result first"), this paragraph is mis-ordered at exactly the spot
most likely to confuse.

Notably, `States.hs` already states it result-first and cleanly: "its role is
purely to show a non-conserved field riding alongside the conserved balance"
(comment on `zeroP`). The .tex is *less* clear than its own source here.

Actionable fix (either):
- Lead the paragraph with the role in one sentence — psHwm exists solely to
  demonstrate that a position can carry non-conserved state beside the conserved
  balance, is inert in this file, and its semantics (and whether two compose)
  are fixed by an out-of-scope valuation writer — then cut the repeated hedging
  to one clause. Optionally state why it reuses `Qty` (it is a balance-like
  quantity from the same source) rather than a distinct type.
- Or, if the illustrative field is not earning its keep against Minimalism,
  drop psHwm and state in one line that a position may carry further
  non-conserved fields written by out-of-scope valuation events.

## Note (not blocking)

The vocabulary "home" / "cell" / "kind of state" / "map" is used
interchangeably ("three homes, held in two maps", "a third home ... not a third
map"). It is reconstructable from the §Answer table (3 occupied cells = 3 homes,
stored in 2 maps), so it does not by itself force commentary, but pinning
"home = an occupied cell of the 2x2 = a kind of state" once, on first use, would
remove the only other spot a reader pauses to reconcile the counting.
