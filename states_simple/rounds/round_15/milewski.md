# Round 15 — milewski review of `states_simple/States.{tex,hs}`

## Verdict: OBVIOUS

The Haskell reads like Hutton, each step forced by the one before; the solution as
`States.tex` now presents it is obviously right for a competent engineer meeting the
problem for the first time. Empty residue.

## What changed in R15 (and what did not)

`States.hs` is **unchanged** (mtime 12:33, predates the R15 `.tex` edit at 13:20). The
code has been OBVIOUS and untouched in substance since R5. R15 is a STYLUS `.tex`-only
pass:

1. **Premise hoisted to the head of §The Answer** — "Every economic relationship a wallet
   has is itself a unit the wallet holds," with the count "three homes, two maps" made
   conditional on it from the first sentence ("Granted it, state lives in three homes").
   Demonstrated for n=1 (one mandate), assumed for the multi-instrument case. Honest and
   clear.
2. **Settlement-price illustration cut** at the axis definition; the benchmark
   level-vs-identity example is now the single worked sort of the authorship criterion
   ("who owns the record's history, not who sources the number"). Strictly stronger
   (same provider lands in both cells), no KEEP item dropped — the table still enumerates
   "last settlement price" under Status.
3. **§Why-Terms authority re-derivation shortened**; terms-vs-status remains grounded on
   change discipline (NonEmpty + `appendVersion` vs single value + `settle`), authorship
   kept only as the *reason* terms are append-only — the framing settled in R12.
4. **psHwm listing comment shortened** in the `.tex` to `-- high-water mark: not conserved`
   (the writer-out-of-scope / stays-zero fact now lives once, in the prose above the
   listing). The `.hs` comment is independent and untouched.
5. **psHwm/Price reconciliation added** (~1.5 lines, §"A position carries more than a
   balance") — see below; within my lens and correct.

## Build

`pdflatex` x2 clean: exit 0, 3 pages, 0 undefined refs, 0 overfull/underfull boxes.
All four labels resolve (`answer`=2, `why`=3, `construction`=4, `right`=5); every `\ref`
lands on its cited content.

## Hutton-bar pass (fresh)

- Every abstraction named after its referent and earned at introduction: `Qty` group
  (only to make a transfer's two legs cancel), `Price` deliberately *not* a monoid,
  `NonEmpty` terms, the `(ProductTerms, UnitStatus)` pair (co-presence is the shape),
  net-first `applyMove`, `foldM` replay.
- Destination derived bottom-up; the "no fourth home" headline is stated **conditionally**
  on the multi-instrument reification, shown for n=1 and assumed in general — the file does
  not assume its own headline.
- Laws classified honestly: priced-iff-active / NonEmpty / pair co-presence / two-key
  balance / two-leg move are **shape-enforced**; conservation, append-only history, and the
  unregistered-unit gate are **writer/seal soundness arguments** (the store type can hold a
  non-conserving map; the sealed constructor makes the reachable set exhaustive). Replay
  determinism = purity of `apply` + the monadic left-fold law.
- All `.tex` listings type-correct and match `.hs` semantically (deriving elided per the
  stated convention).

## psHwm flag (jane-street-cto, returned to milewski) — re-affirmed REJECTED

The R15 prose now carries the in-remit justification verbatim in the spirit of my standing
resolution: "psHwm is also a Qty, and rightly: a high-water mark is a quantity, so adding
two is legal, unlike a price (above), whose sum is meaningless. What psHwm lacks is psBal's
paired writer ... so it carries no zero-sum invariant ... with no aggregate over holders
claimed for it."

This is exactly right and squarely in my lens:
- A high-water mark **is** a quantity; it combines under the same `Qty` monoid; adding two
  is legal. The contrast with `Price` (no group structure, sum meaningless) is now drawn
  explicitly, which is an improvement.
- What it lacks is a cancelling-pair writer, so it carries no zero-sum invariant.
  Conservation is a property of *how a field is written*, not of its type.
- The prose **discloses** (does not type-claim) that no aggregate over holders is claimed —
  a disclosed discipline, honest, FORMALIS-confirmed across prior rounds.

A non-group newtype for psHwm would only decorate: it removes no representable bug (adding
HWMs is legal) and removes no code. By the restraint rule, rejected. Not residue.

## Carried non-blocking nit (now 12 rounds — NOT residue)

`.tex` renders `TermsVersion` (:213) and `Move` (:297) as positional constructors where
`.hs` uses records (`tvLabel`, `mvUnit/mvFrom/mvTo/mvQty`). The `.tex` is internally
consistent (never uses the dropped accessors), so a reader of the `.tex` alone is not
misled; FORMALIS (R13) calls it a licensed simplification. STYLUS-owned, left as is.

## Standing flag returned to subject-matter (NOT my lens, NOT residue)

The multi-instrument reification proof (every multi-instrument relationship reifies as a
single unit) is a domain/subject-matter obligation, not a representation defect. STYLUS has
made the count conditional on the premise; the general proof is owed by the domain agents
(routes a/b/c in the iteration log). The Haskell faithfully represents the n=1 case it is
given. Outside my mandate.

No GHC in env; type-correctness verified by reading (unchanged since R5). `.tex` verified by
building.
