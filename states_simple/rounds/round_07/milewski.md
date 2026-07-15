# milewski — Round 7 — States.tex / States.hs

## Verdict: OBVIOUS

My lens: does the Haskell, as States.tex presents it, read like Hutton — each
step obvious from the last, nothing assuming the answer in advance, no
abstraction arriving before it is earned.

## What changed since Round 6

The `.hs` is unchanged (mtime predates the R7 edits; every declaration matches
the file I cleared OBVIOUS in R5/R6). The R7 delta is confined to §Why Three
prose: the empty-fourth-cell argument is now anchored on the **seal** rather than
on received-vs-owned — "the fourth cell is empty by the seal, not by survey"
(States.tex:141), the (holder, unit) key carrying only writers that overwrite, so
admitting a correctable definition there "would open a writer beside applyMove,
breaking the seal conservation rests on" (States.tex:146–148), reinforced by
minimalism ("the recoverable and unaudited is never versioned", :149) and an
explicit "this does not reopen authorship … the seal answers it" (:152–154).
This resolves the R6 NOT-YETs (jane-street-cto, karpathy: *if owned state can be
append-only — the log is — why is a position not versioned?*). It is prose domain
reasoning, outside my lens. I note only that it is internally coherent, ties the
fourth-cell exclusion to the same seal the Haskell already enforces (sole
`psBal` writer = `applyMove`, hidden constructor), and does not change the home
count — still exactly `ledgerUnit` (the `(ProductTerms, UnitStatus)` pair) plus
`ledgerPS`.

## Hutton-bar pass (fresh, not a rubber stamp)

Every abstraction is named only after the thing it names is on the page, and each
buys something concrete:

- `Qty` monoid then group (`negQty`): the group structure exists solely so a
  transfer's two legs cancel; the forward-pointer is honest (States.tex:184–187).
- `Price` newtype, deliberately *not* a monoid/group: keeps a price from being
  summed into a balance — earned by contrast with `Qty` (States.tex:207–209).
- `Active Price`: the price rides on the constructor, so "active with no price"
  and "listed yet priced" are unspellable; correctly contrasted with conservation
  as a *disclosed* writer-invariant where the shape cannot afford the guarantee
  (States.tex:200–209, and the symmetry note in the .hs at step 5).
- `NonEmpty` for `ProductTerms`: "registered but versionless" not representable;
  constructor unexported so no door shortens history (States.tex:219–235).
- pair `(ProductTerms, UnitStatus)` under one key: co-presence is the shape, not
  a policed invariant — the file's own step-5 rule applied (States.tex:255–272).
- `foldMap` / `foldM`: each named where its referent is on the page (netBal,
  replay).

No step assumes the answer. The `.tex` is the result-first spec — it states the
answer (§The Answer), derives it (§Why Three), then constructs from the smallest
pieces, each forced by the one before (§The Construction); the derivation
precedes the build, so the conclusion is reached, not smuggled into a premise.
Conservation is still disclosed honestly as a writer-invariant (States.tex:343–
354), not falsely as a type guarantee. Replay determinism is attributed to
purity/totality of `apply`, the checkpoint property resting on the monadic
left-fold law, with row retention correctly disentangled as a separate audit
property (States.tex:361–383). `apply` matches all three `Event` constructors —
a new event class forces a new arm; no wildcard. All accessors total; every
refusing writer makes failure explicit in `Maybe`, and the document is careful
that the `Maybe` answers "is this unit known?", never "did the balance hold?"
(States.tex:318–321).

## Sub-threshold note (non-blocking, carried from R5/R6 — not a NOT-YET)

The `.tex` listings render `TermsVersion` (line 229) and `Move` (line 306) as
*positional* constructors, where States.hs declares both as records
(`TermsVersion { tvLabel }`, `Move { mvUnit, mvFrom, mvTo, mvQty }`). The `.tex`
says "the listings reproduce its declarations, deriving clauses elided"
(line 174); record→positional is more than deriving elision, so the claim is
slightly overstated. Not an obviousness defect: each file is internally
self-consistent (the .tex's `applyMove (Move u from to q)` matches its positional
`Move`), and the constructor arity/types agree. Cross-artifact fidelity nit
(STYLUS/formalis territory), left to the author. Does not move my verdict.

No GHC in this environment; totality, exhaustiveness, and the derived-`Show`
GHCi/`main` echoes were verified by reading, which is what this lens turns on.

A competent engineer new to the problem can read the Haskell and watch
conservation fall out of "a move is two cancelling legs, written by the one
sealed door, from an empty base," and replay fall out of "apply is pure and
total, replay is its fold." Each abstraction arrives only when earned.

**OBVIOUS.**
