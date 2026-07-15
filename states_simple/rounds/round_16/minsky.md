# minsky — Round 16 — States.tex / States.hs

## Verdict: NOT-YET

## Lens

Does each illegal state the design relies on excluding become *visibly* impossible in
the shape a first-time reader reads — not on faith? And, since the task hands the reader
*both* artifacts, does the account cohere across them, so the reader *sees* the design
rather than backtracking between two contradicting statements of it?

## What is live this round

`States.hs` is unchanged (mtime 12:33, byte-identical to my R13–R15 pass). `States.tex`
was re-edited at 13:28 (R16). Per `iteration_log.md`, the sole R16 change is the
`§Construction` psHwm paragraph: STYLUS took "route 3" and **reversed the R15 port** of
the source's additivity rationale, rewriting the `.tex` to *defer* psHwm's algebra to the
out-of-scope valuation writer. Build is clean: `States.log` shows no undefined references
and no warnings, so no cut left a dangling cross-reference.

Everything I confirmed type-carried and visible in R15 remains so, unchanged in the code:
price-on-`Active` (tex:197 / hs:258), `NonEmpty` terms with unexported constructor
(tex:214 / hs:333,47), the co-present `(ProductTerms, UnitStatus)` pair (tex:259 / hs:437),
the `(WalletId, UnitId)` dual key (tex:260 / hs:438), the single-`Qty` `Move` whose
cancelling legs are derived in `applyMove` (tex:297 / hs:512,533–554), `Price` with no
`Semigroup`/`Monoid` (hs:249). Conservation, append-only history, the registration gate,
and never-held/held-and-flat remain honestly disclosed as writer/seal disciplines with
bounded arguments, never dressed as shapes. The seal is intact (`Ledger` exported bare,
hs:61; selectors withheld). `apply` and `settlementPrice` remain exhaustive with no
swallowing wildcard. None of that is residue.

## The residue this round is new and one-sided

The R16 edit changed *one* of the two artifacts the reader is told to read, and left the
two giving **opposite accounts of the same load-bearing design decision** — whether this
file takes a position on psHwm's algebra.

- `States.tex` (tex:227–230): "psHwm is typed `Qty`, matching the source, but the file
  leans on none of `Qty`'s group structure for it: what a high-water mark measures ---
  and so whether two compose, and how --- is fixed by its writer, a valuation event out
  of scope here, **not by this file**."

- `States.hs` (hs:579–591): "psHwm is the same type `Qty`, and **that is right**: a
  high-water mark is a quantity, and **it combines with the same monoid** ... There is
  nothing here to make unrepresentable -- **adding high-water marks is legal** -- so a
  separate newtype ... **would only decorate, and we do not add it**."

The `.tex` says the file declines to decide whether HWMs compose ("not by this file"); the
`.hs` decides exactly that — affirms the monoid, calls the addition legal, and records a
deliberate choice *not* to give psHwm a separating, group-free newtype. These are not two
emphases of one claim; one disowns the position the other commits to. This is not a stale
detail the reader can ignore: the `.tex` itself invites the cross-check at tex:157–159
("The Haskell is `States.hs`; the listings reproduce its declarations"). A competent
first-time engineer reading both, as instructed, asks "does this design defer the
high-water-mark algebra, or commit to `Qty` and reject a separating type?" and finds the
spec and the code answering oppositely. That is precisely the "reader takes it on faith /
must backtrack" failure my bar excludes — and, given the project's single-source-of-truth
charter, two source artifacts contradicting each other on a design rationale is the wrong
note for this committee to leave standing.

Note this does **not** demote to residue the standing jane-street-cto flag itself
(give psHwm a `Price`-style group-free newtype). That remains a *should-strengthen*
returned to source: neither file claims the meaningless cross-holder HWM sum is
type-impossible — both explicitly disclaim any aggregate — so no illegal state is dressed
as a shape, and `netBal` folds only `psBal` (hs:597–598). My core type-bar is met. The
residue is narrower and entirely a product of the R16 one-sided edit: the spec and the
implementation now *disagree* about whether the file decides psHwm's algebra.

## Actionable fix (either closes it)

- Bring `States.hs` hs:579–591 into line with the R16 `.tex`: replace the "that is right
  / combines with the same monoid / a separate newtype would only decorate, we do not add
  it" rationale with the same deferral the `.tex` now states — the field's type and
  combining operation are the valuation writer's to fix, out of scope here; in this file
  psHwm carries only the role of a non-conserved field beside the conserved balance and
  stays zero. (Lowest-risk: it makes the teaching thread match the spec without touching a
  declaration or a property.)
- Or re-port the source rationale back into the `.tex` (re-instating R15) so both commit
  to the same account. This re-opens the contradiction-with-the-Price-criterion that
  drove the R16 reversal, so the first option is preferable.

## Smaller in-.tex tension at the same site (not counted as separate residue)

tex:230 ("the file leans on none of `Qty`'s group structure for it") sits two lines above
the listing `zeroP = PositionState mempty mempty` (tex:240–242), where the second `mempty`
*is* `Qty`'s monoid identity supplying psHwm's initial value. Under the natural reading
"no invariant leans on it" the sentence survives — `zeroP` needs some zero and nothing
depends on it being the identity — so I do not raise it as an independent blocker. Folding
it: the rewording that aligns `.hs` with `.tex` should keep the phrasing precise enough
that a reader does not read "leans on none of the group structure" against an adjacent use
of `mempty` for that very field.

## Residue

1. `States.tex` tex:227–230 vs `States.hs` hs:579–591 — the R16 edit rewrote only the
   `.tex` to *defer* psHwm's algebra to the out-of-scope writer ("not by this file"),
   while the unchanged `.hs` still *commits* to it ("that is right ... combines with the
   same monoid ... a separate newtype would only decorate, and we do not add it"). The two
   artifacts the reader is asked to read, and which the `.tex` cross-references
   (tex:157–159), now contradict each other on whether the file takes a position on the
   high-water mark's composition. Align the `.hs` comment with the `.tex` deferral (or
   re-port the rationale into the `.tex`) so the reader sees one coherent account.
