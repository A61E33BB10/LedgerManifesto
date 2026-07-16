# Round 13 — milewski review of `states_simple/States.{tex,hs}`

## Verdict: OBVIOUS

Bar applied: the Haskell reads like Hutton — each step obvious from the last, no
abstraction named before the thing it names is on the page. Reader = a competent engineer
who has never seen this problem.

## What changed since R12 and what I re-checked

The substantive `.hs` is unchanged since R5 (and OBVIOUS at every round 5–12). The R13
delta is `.tex`-only and is the resolution of the two FORMALIS findings I logged earlier
this round (mislabelled cross-references):

- §4 "The Construction" now carries `\label{sec:construction}` (line 165). `States.aux`
  confirms it resolves to section 4.
- Line 105 ("a third home, a third kind of state, not a third map") now `\ref`s
  `sec:construction` — the section where the two-maps pair (`ledgerUnit`) actually lives.
- Every other `\ref` resolves to its semantically correct section: the four uses pointing
  at `sec:why` (lines 65, 67, 101, 103, 282, 384) all cite reasons that live in §3 "Why
  Three"; in particular line 103 ("share the unit key but cannot be one value") correctly
  points at §3, where the cannot-be-one-value argument is made.

No `.hs` edit was required and I made none — the `.hs` cross-references are inline
`(step N)` and were already correct (the two-maps pair and `register`'s refusal both live
in step 8, which is where they are cited). Declining the no-op `.hs` edit is the restraint
rule, not laziness.

## Fresh Hutton-bar pass (both artifacts)

Clean. Spot-checks that matter:

- Every abstraction is named only after the value it abstracts is written: `Qty` monoid →
  group (`negQty`) before any transfer uses inverses (step 1); `foldMap` named only once
  `netOf` needs "combine all of these" (step 4); `foldM` named only once the failing
  left-fold is on the page (step 9).
- The destination ("three homes, two maps, no fourth") is derived bottom-up, not declared.
  The "no fourth home" claim is stated *conditionally* on the reification (shown for n=1,
  assumed in general) in both artifacts — the file does not assume its own headline.
- Laws are classified honestly as shape-enforced vs writer/seal-soundness: priced-iff-active
  (price on `Active`), NonEmpty terms, terms/status pair co-presence, two-key balance,
  two-leg move = shape; conservation, append-only history, unregistered-unit gate = writer +
  sealed-constructor invariants. Conservation is correctly *not* claimed as type-forbidden.
- `applyMove`'s net-first construction (`netDeltas` then `writeNet`, skip `mempty`) is
  motivated before it is mechanised — the self-move / zero-move phantom-row hazard is stated,
  then the minimal fix (net per wallet, write nothing on net-zero) is the obvious response.
  The step-4 → step-8 increment in the move's shape is earned by the load-bearing
  never-held vs held-and-flat distinction.
- All listings type-correct and matching `.hs` semantics. Replay determinism rests on
  purity of `apply` + the monadic left-fold law; row retention is correctly disclaimed as a
  separate audit property, not the cause of determinism.

No GHC in env; verified by reading (as in prior rounds).

## Residue

Empty (no blocking residue).

Carried non-blocking note, now in its 9th round, recorded only so it is not lost — it does
**not** affect the Hutton code bar and is STYLUS-owned, not mine:

- `States.tex` renders `TermsVersion` (line 225) and `Move` (line 307) as *positional*
  constructors, whereas `States.hs` declares both as records (`tvLabel`; `mvUnit/mvFrom/
  mvTo/mvQty`). Line 169 claims "the listings reproduce its declarations, deriving clauses
  elided" — positional-vs-record is more than a deriving elision. The `.tex` is internally
  consistent (its `applyMove`/`currentTerms` listings match positionally), so a reader of
  the `.tex` alone is not misled; it only mildly overstates the "reproduce" claim. Cosmetic
  cross-artifact fidelity, left to STYLUS.
