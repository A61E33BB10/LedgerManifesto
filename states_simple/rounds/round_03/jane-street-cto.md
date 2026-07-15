# States.tex — Round 3 review (jane-street-cto lens)

**Verdict: NOT-YET**

The three round-2 residues are resolved, cleanly:

- `psHwm` no longer claims dynamic behavior it cannot show. Lines 209–224 now say
  what is true — both fields are `Qty`, what separates them is the writer, the
  writer is a valuation event out of scope, so `psHwm` stays zero here and exists
  only to exhibit a non-conserved column. The conservation argument (line 300–302)
  now rests on "never written as cancelling legs," not on a behavior never
  exhibited. Honest.
- `Lifecycle` is cut to `Listed | Active` (line 186), both stages reached by a
  shown writer, and the prose says so (lines 180–182). The forced-`Active` problem
  is gone with the stages that made it a problem.
- `register` is now shown (lines 250–255); the coherence invariant ("a unit
  appears in the terms map exactly when it appears in the status map," line 230) is
  visible, not promised.

The core remains obvious: three homes, the empty fourth cell, the 2×2, the
conservation argument (only `applyMove` writes `psBal`, two legs cancel, sealed
constructor leaves no other door), and replay-as-`foldM`. That part needs no
commentary.

One new residue blocks the bar.

## Residue

### `appendVersion` is orphaned from the event stream, contradicting "every view is a projection of the stream" (lines 314, 205–206, 114, 332, 244–247)

The document makes append-vs-overwrite the *pivotal* reason terms and status are
separate homes (lines 108–117, 244–247): "`appendVersion` keeps history, `settle`
throws it away." It then claims terms history is rebuilt by replay — line 114:
"Both are rebuilt by replay, yet terms additionally retain their version list in
the store" — and line 332: "every view is a projection of the stream ... replay
from `emptyLedger` introduces each unit and rebuilds its status and positions."

But the `Event` type (line 314) is
`Registered UnitId TermsVersion | Moved Move | Settled UnitId Price`. There is **no
event that calls `appendVersion`.** A unit gets version one via `Registered` and
never a second version through the stream. So:

- `settle` (the overwrite writer) is reachable from the stream via `Settled`.
  `appendVersion` (the append writer) is reachable from *nothing*. The two writers
  the document pairs as its central contrast are asymmetric in reachability, and
  the document never says so.
- Replay can only ever produce single-version terms. The multi-version retention
  that *defines* the terms home — the whole reason it is a third home and not
  folded into status — is never exercised by the stream. `appendVersion` (shown as
  a headline primitive, lines 205–206) is dead with respect to the event model.
- Therefore line 114's "terms ... rebuilt by replay" and line 332's "every view is
  a projection of the stream" are, for any terms correction, false in the shown
  construction — true only vacuously, at one version. This collides with the
  project's own premise (CLAUDE.md: "every other view ... is a projection of that
  stream").

A reader six months on, tracing "an external authority corrects a multiplier —
how does that enter the ledger and survive replay?", lands on the missing event,
sees `appendVersion` reachable by no `Event`, and writes the margin note. That is
exactly the failure the bar forbids.

**Fix (either):**

1. Add `Amended UnitId TermsVersion` to `Event` (line 314) with
   `apply (Amended u tv) = amend u tv`, where `amend` looks up the unit's
   `ProductTerms` and `appendVersion`s — refusing an unregistered unit, same
   `Maybe` shape as the others. Then the append writer is reachable, the
   append-vs-overwrite contrast is symmetric, and "terms rebuilt by replay" / "every
   view is a projection" become literally true. This is the answer consistent with
   the thesis.
2. Or, if amendment is deliberately deferred, say so where `appendVersion` is
   introduced (lines 192–207) and where replay claims projection (line 332):
   amendment events are out of scope here, `appendVersion` is the primitive they
   will use, and "every view is a projection" is asserted only for the events shown.
   Weaker, but at least the document stops contradicting itself.

As written it does neither: it shows `appendVersion` as a first-class writer, leans
on it for the separation argument, claims it is replayed — and provides no event
that reaches it.
