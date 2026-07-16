# Round 9 — milewski review of states_simple/States.tex (+ States.hs)

**Verdict: OBVIOUS.**

Lens: does the Haskell read like Hutton — each step obvious from the last, nothing
assuming the answer in advance, no abstraction arriving before it is earned.

## Round-9 deltas confirmed present
Both fixes my memory records as settled are in the files:
- **Zero-move guard.** `applyMove`'s `leg` now guards `| d == mempty = ps` before the
  insert (.hs:527, .tex:320). A `Move ... (Qty 0)` is well-formed (accepted) but writes no
  row, so it cannot conjure a false "held and flat" for a wallet that never held a nonzero
  position. "Held" now means *named in a nonzero move*. GHCi demo + `main` parity check added.
- **Closing overclaim removed.** The old `.hs` conclusion ("nothing asserted, all visible in
  the shape") is replaced by an explicit two-class split (.hs:760-777): **shape-enforced**
  (priced-iff-active on `Active`, `NonEmpty` terms, terms/status pair co-presence, two-key
  balance, two-leg move) vs **soundness-argued writer/seal invariants** (conservation,
  append-only terms history, the unregistered-unit gate). The `.tex` never carried the
  overclaim; its §Why-It-Is-Right keeps conservation as an honest writer-invariant
  (.tex:353-362).

## Hutton-bar pass (fresh)
- Every abstraction is named after the thing it names, never before: `monoid` after the `Qty`
  instances (step 1); `group`/`negQty` motivated by step-4 legs; `foldMap` after "combine all
  of these" (step 4); `NonEmpty` after "one or more, append-only" (step 6); `foldM` after
  describing the failing left-fold (step 9). No free monad, no profunctor, no decoration.
- The destination ("three homes, two maps, no fourth") is announced in the header as reached
  "at the end and not before" and is *derived* in §Answer from two axes (key; correction
  discipline) — not assumed as a premise.
- Conservation: honest writer-invariant — only `applyMove` writes `psBal`, two cancelling
  legs, register/settle never touch `psBal`, sealed constructor makes the reach from
  `emptyLedger` exhaustive. Not claimed as a type guarantee.
- Replay determinism: purity/totality of `apply` + monadic left-fold law (checkpoint
  splits at any cut). Row retention correctly disclaimed as a separate audit property, not the
  cause of determinism.
- Totality/determinism: `currentTerms` total via `NonEmpty`; `settlementPrice` total over both
  `Lifecycle` cases; all three writers total via `Maybe`; `apply` exhaustive over three `Event`
  constructors. No partiality, no nondeterminism. No GHC in env — verified by reading.

## Sub-threshold (non-blocking — do not gate the verdict)
1. **Carried fidelity nit.** `.tex` renders `TermsVersion` (:235) and `Move` (:312) as
   positional constructors while `.hs` uses records; `.tex` is internally self-consistent and
   only mildly strains "listings reproduce its declarations, deriving clauses elided." Left to
   author, as in rounds 5-8.
2. **Self-move, for the domain agents (outside my representation lens).** The file's definition
   "held = named in a nonzero move" admits a self-move (`from == to`, `q ≠ 0`): it nets to zero
   (conservation intact, determinism intact) but leaves a `Just (psBal = 0)` held-and-flat row
   for a wallet whose economic position never changed. The code is *internally consistent* with
   its stated definition — this is not a representation defect. Whether a self-move should count
   as a holding (the never-held vs held-and-flat distinction feeds the wash-sale lookback) is a
   ledger-semantics question for the domain agents, not for me to settle. Surfaced because the
   R9 zero-guard was added to protect exactly this distinction; the parallel self-move case is
   left to the definition rather than to a guard, and that is a defensible choice, not a gap.

Neither observation makes any step non-obvious, assumes the answer, or introduces an unearned
abstraction. Verdict stands: **OBVIOUS.**
