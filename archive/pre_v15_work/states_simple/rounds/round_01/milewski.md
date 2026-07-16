# Round 1 — MILEWSKI verdict on `states_simple/States.tex` + `States.hs`

**Lens:** Does the Haskell read like Hutton — each step obvious from the last, nothing
assuming the answer in advance, no abstraction arriving before it is earned, and does the
code obviously support the claims the prose makes about it?

**Verdict: NOT-YET.**

The thread is, in the main, exactly the Hutton shape I want: `Qty` as group with `negQty`
named only because step 4 needs it; `foldMap` introduced after the monoid is on the page;
`NonEmpty` earned by "always has a current version"; `foldM` named only once the failing
left fold is already written; `Ledger` sealed (constructor and selectors unexported) with
the coherence invariant argued from that sealing. The conservation example and the
`replay (xs<>ys) = replay xs >=> replay ys` checkpoint law are true instances, not
decoration. Most of the document is obvious.

One step, however, **contradicts its own stated claim**, and a second is asserted in prose
without a witness on the page. Either is enough to block "self-evidently right."

---

## CRITICAL — the append-only claim is defeated by the export list

`States.hs` step 6, lines 263–264:

> "There is deliberately no function that rewrites a version in place; the append-only
> discipline is enforced by the absence of any such function."

`States.tex` §Construction makes the same claim ("Terms grow only by appending… the prior
version stays") and rests the entire *third home* on it (§Why Three: "Append-only and
overwrite-in-place are two disciplines; one home cannot enforce both").

But the export list (lines 35–37) exports the constructor:

```
  , ProductTerms (..)
```

For `newtype ProductTerms = ProductTerms (NonEmpty TermsVersion)`, `(..)` puts the
`ProductTerms` constructor in scope for every importer. So append-only is **not** enforced
by absence: external code can write

```haskell
ProductTerms (newVersion :| [])   -- prior versions discarded
```

i.e. rewrite-in-place is reachable, and history can be dropped, by anyone outside the
module. The discipline the third map exists to enforce is open.

This is exactly the seam the author got right for `Ledger` (line 46: `Ledger` exported
*without* `(..)`, with a comment explaining why) and wrong for `ProductTerms`. The claim
"properties hold by construction" is, for terms, currently false: the property holds only
by convention. Under the Hutton bar, the code visibly contradicts the sentence written
about it.

**Actionable fix:** make `ProductTerms` abstract — export `ProductTerms` (the type) without
`(..)`, exposing only `currentTerms` (reader) and `appendVersion` (the one mutator). Then
the "enforced by the absence of any such function" sentence becomes true. (`TermsVersion`,
`UnitStatus`, `PositionState` exporting their fields is fine — they are plain records with
no by-construction discipline riding on them.)

---

## MEDIUM — the overwrite discipline that forces map #3 has no witness in the code

The separation of *status* from *terms* — the load-bearing "why three, not two" argument —
rests on a contrast of disciplines: terms **append**, status **overwrites**
(`States.tex` §Why Three; `States.hs` step 5 "shared, mutable value", step 6 "Status is
overwritten on every settle").

The append side is demonstrated: `appendVersion` is on the page. The overwrite side is
not: there is no `settle :: Qty -> UnitStatus -> UnitStatus` (or any status mutator)
anywhere in `States.hs`. `UnitStatus` is only ever written once, by `register`, to
`defaultStatus`. So a reader cannot see, in the Haskell, why status could not equally be a
`NonEmpty`-appended thing like terms — the contrast that forces two maps is told, not
shown.

For a thread whose thesis is "each home forced by one concrete reason," the overwrite home
is the one home whose forcing reason never appears as code. This is located (steps 5–6) and
actionable: add the one-line overwrite function (`settle`, updating `usLastSettle`) so the
append-vs-overwrite contrast is concrete on the page, or state explicitly that the writer
is out of scope and the distinction is argued, not demonstrated.

---

## Noted, not blocking

- `transfer`/`Balances` (steps 3–4) are pedagogical scaffolding: `applyMove` re-derives the
  two-leg logic via `bump` rather than reusing `transfer` (signature does not fit a record
  field). This is in keeping with Hutton's evolve-and-supersede style and the prose says so;
  no action needed, but it is a re-derivation, not a reuse.
- Conservation/totality/determinism are otherwise clean: `applyMove` gates on registration
  with a typed `Nothing`, `foldM` in `Maybe` is total and deterministic, `currentTerms` is
  total via `NonEmpty`. No premature categorical machinery — the restraint rule is honoured.

Resolve the CRITICAL (and ideally the MEDIUM) and I expect this to reach OBVIOUS.
