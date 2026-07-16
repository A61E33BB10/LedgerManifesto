# Round 7 — chris-lattner — States.tex

## Verdict: OBVIOUS

My lens: architecture and over-inclusion. The bar is that the simple path *is* the
whole document — nothing present that fails to serve the answer. I read the document
hunting for dead weight, blessed-combination magic, and apparatus carried for a
hypothetical future. I found none I can stake a NOT-YET on.

## Why the architecture earns the verdict

The answer is *forced*, not chosen, and the document shows the forcing rather than
asserting it. Two orthogonal distinctions — key (unit vs (holder, unit)) and
correction discipline (append-keep vs overwrite) — give a 2×2; three cells are
occupied and the fourth is closed twice (by the seal, and by the holder-alone
argument). That is the right shape for infrastructure: the classification is a
property of the problem, so a fact that does not exist yet still has exactly one home.
This is the LLVM lesson — get the decomposition right and the system absorbs cases you
did not enumerate.

The single-writer seal is the load-bearing architectural move and it is honest about
it. Conservation is stated as a *writer* invariant, not a store-type guarantee
("the store ... can hold a non-conserving assignment"). The sealed constructor
("constructor not exported") is what makes the invariant hold by construction with no
other door. Coherence of the (terms, status) pair is moved out of the seal and into
the *shape* of the map — co-presence is "the shape of the map, not an invariant to
police." That is precisely the right instinct: make illegal states unrepresentable in
the type, and reserve the runtime guard for what the type genuinely cannot say.

Progressive disclosure is respected. The simple writers (`register`, `settle`,
`applyMove`) are the whole exercised surface; the powerful path (amendment events
growing the version list, valuation events writing the high-water mark) is named, scoped
out, and architecturally accommodated without being thrust into the file. The
`NonEmpty` version list is the terms home's *capability*; its driving event is deferred.
That is a gentle on-ramp with no ceiling, and the ceiling is documented, not hidden.

The `Maybe` discipline is clean and the document tells the reader exactly what each
arm means: `applyMove`'s `Nothing` answers "is this unit known?", never "did the
balance hold?" — error semantics as UI, with the source of failure named. The
`position` read distinguishes *never held* from *held and flat* by row retention, and
ties that to two concrete consumers (settlement entitlement, wash-sale lookback).

## The one element I stress-tested: `psHwm`

`psHwm` is the only candidate for residue: a field that stays zero in this file, with
no in-scope writer, carrying `Qty`'s representation while disclaiming `Qty`'s monoid
(its true combine is running-max, not addition). A field that is never written and
whose type implies the wrong operation is exactly the kind of thing my bar exists to
catch, and `entry NAV` — a comparable position field — is *elided* rather than
materialized, so the asymmetry demanded an answer.

It survives, on architectural grounds:

- It is load-bearing for the conservation argument. The central claim — "conservation
  is a property of how a field is written, not of its store type" — is only *visible*
  if a non-conserved field sits in the same record as the conserved one. `psHwm`
  makes the store's neutrality concrete: the type admits a non-conserving field, and
  the seal, not the type, is what conserves. Eliding it to prose would reduce a
  demonstrated property to an assertion.
- The asymmetry with `entry NAV` is therefore principled, not sloppy. `psHwm` is
  materialized because it demonstrates something the answer needs (a non-conserved
  field co-resident in the position home, justifying one home rather than two);
  `entry NAV` demonstrates nothing new and is elided. That is consistent minimalism.
- The `Qty`-representation reuse is the *minimal* choice. A dedicated max-monoid
  `Hwm` newtype would import an apparatus whose writer is out of scope — more weight
  for an inert field — and the document explicitly disclaims the borrowed semantics,
  so no code relies on the wrong combine.

I record this as examined-and-cleared, not as a blemish.

## Correctness spot-checks (no NOT-YET, recorded for the committee)

- `appendVersion` appends at the tail, `currentTerms = NE.last` — newest-in-force is
  consistent.
- `applyMove` writes `negQty q` / `q`; sum delta `= mempty`. Self-transfer
  (`from == to`) nets zero correctly.
- `register`/`settle`/`applyMove` registration guards are mutually consistent with
  `replay`'s `foldM`; checkpoint-splitting rests on the left-fold law as stated.

Nothing in the file is carried for a future it does not also accommodate by
construction here. The simple path is the whole document.
