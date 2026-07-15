# milewski — Round 6 — States.tex / States.hs

## Verdict: OBVIOUS

My lens: does the Haskell read like Hutton — each step obvious from the last,
nothing assuming the answer in advance, no abstraction arriving before it is
earned.

## What changed since Round 5

The only substantive delta R5→R6 is in §Why Three (States.tex:132–146): the
empty-fourth-cell argument is now stated in received-vs-owned terms ("the ledger
versions what it receives, derives what it owns; a position is owned, so no
received per-(holder, unit) definition exists to version"), with the explicit
reconciliation that this "does not reopen authorship" — among unit-keyed facts
correction discipline alone separates terms from status, while the fourth-cell
question is which key may host a *definition* at all. This resolves dirac's R5
NOT-YET (authorship-vs-discipline collision). It is prose domain reasoning,
outside my lens; I note only that it is internally coherent and does not change
the home count, which the Haskell already realizes as exactly `ledgerUnit`
(the `(ProductTerms, UnitStatus)` pair) plus `ledgerPS`. The Haskell is
unchanged from the R5 file I reviewed OBVIOUS.

## Hutton-bar pass (fresh, not a rubber stamp)

Every abstraction is named only after the thing it names is on the page, and
each earns a concrete purchase:

- `Qty` monoid then group (`negQty`): group structure exists solely so a
  transfer's two legs cancel; introduced with that justification up front
  (.tex:166–167, .hs step 1). Earned, forward-pointer honest.
- `Price` newtype, deliberately *not* a monoid/group: keeps a price from being
  summed into a balance. Earned by contrast with `Qty` (.tex:194–196).
- `Active Price`: price rides on the constructor, so "active without price" and
  "listed yet priced" are unspellable — the cheap-shape rule, correctly
  contrasted with conservation as a disclosed writer-invariant where the shape
  cannot afford it. Earned.
- `NonEmpty` for `ProductTerms`: "registered but versionless" not representable;
  constructor unexported so no door shortens history. Earned.
- pair `(ProductTerms, UnitStatus)` under one key: co-presence is the shape, not
  a policed invariant — applies the file's own step-5 rule. Earned.
- `foldMap`/`foldM`: each named at the point its referent is on the page.

No step assumes the answer. The .hs is the bottom-up discovery thread that
reaches "three homes, no fourth" at the end and not before (.hs:14); the .tex is
the result-first spec that states the answer, derives it in §Why Three, then
constructs — the appropriate register for a specification, and the derivation
precedes the build. Both legitimate; neither smuggles the conclusion into a
premise.

Conservation is still disclosed honestly as a writer-invariant (sole `psBal`
writer = `applyMove`, two cancelling legs; reachability closed by the sealed
constructor from `emptyLedger`), not falsely as a type guarantee (.tex:329–340).
Replay determinism is attributed to purity/totality of `apply`, with the
checkpoint property resting on the monadic left-fold law, and row retention
correctly disentangled as a separate audit property (.tex:347–371). Totality:
all accessors total; every refusing writer makes failure explicit in `Maybe`,
and the document is careful the `Maybe` answers "is this unit known?", never
"did the balance hold?". `apply` matches all three `Event` constructors, so a
new event forces a new arm. No case-arm wildcards.

## Sub-threshold note (non-blocking, carried from R5 — not a NOT-YET)

The .tex listings render `TermsVersion` (line 216) and `Move` (line 292) as
*positional* constructors, where States.hs declares both as records
(`TermsVersion { tvLabel }`, `Move { mvUnit, mvFrom, mvTo, mvQty }`). The .tex
claims "the listings reproduce its declarations, deriving clauses elided"
(line 161–162); record→positional is more than deriving elision, so the claim is
slightly overstated. It is not an obviousness defect: each file is internally
self-consistent and usable (the .tex's `applyMove (Move u from to q)` matches its
positional `Move`), and the constructor arity/types agree. It is a cross-artifact
fidelity nit (STYLUS/formalis territory), left to the author. It does not move my
verdict.

No GHC in this environment; totality, exhaustiveness, and the derived-`Show`
GHCi/`main` echoes were verified by reading, which is what this lens turns on.

A competent engineer who has never seen this problem can read the Haskell and
watch conservation fall out of "a move is two cancelling legs, written by the one
sealed door, from an empty base," and replay fall out of "apply is pure and
total, replay is its fold." Each abstraction arrives only when earned. The bar is
met.

**OBVIOUS.**
