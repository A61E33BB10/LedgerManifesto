# karpathy — States, Round 3

**Verdict: NOT-YET**

The document is genuinely strong on one of its two axes. The *key* axis — Position
keyed by (holder, unit) vs Status keyed by unit — is obvious in one pass: the
buyer/seller +1000/-1000 collapse is a concrete illegal state, and conservation
falls straight out of "two legs from one quantity cancel." If the whole claim were
"economic state is (holder, unit)-keyed," I would say OBVIOUS.

It is the *retention* axis — Terms vs Status, the boundary that makes the answer
"three homes" instead of "two keys" — that forces a leap of faith and a
backtrack. Three located, actionable residues.

---

## R1 — The terms/status separation is asserted as forced, but no illegal state is shown. (§The Answer; §Why Three, para 3 "Terms are separate from status")

The document's register promises necessity: "each forced by the one before," "Why
Three," "Each occupied cell exists for one concrete reason." For Position-vs-Status
that promise is kept (collapse = reconciliation break = illegal state). For
Terms-vs-Status it is not.

The argument given is: "Combined in one cell, the home would carry a retained
version list and an overwritten value under two disciplines at once. Separated,
each home keeps history one way."

A first-time reader's immediate counter: a single unit-keyed record
`{ terms :: ProductTerms, status :: UnitStatus }` carries one versioned field and
one overwritten field perfectly well — `register` writes both, `settle` overwrites
the status field, `appendVersion` grows the terms field. That is an ordinary
record, not an illegal state. So "two disciplines at once" is treated as
self-evidently forbidden, but nothing is made unrepresentable by combining and
nothing breaks. The separation is a one-discipline-per-home *cleanliness*
preference, dressed as a correctness necessity.

Action: either exhibit an illegal state that becomes representable when terms and
status share a home (the same standard the Position cell meets), or stop calling
the split "forced"/"three homes" and state plainly that terms and status share the
unit key and are separated by convention for auditability. As written, the reader
must take the necessity on faith.

## R2 — Amended terms are not replayable, contradicting "every view is a projection of the stream." (§The Construction, Event type + appendVersion; §Why It Is Right, Deterministic replay; §Why Three, para 3)

This is the load-bearing one. The terms cell earns its separate existence *entirely*
from the amendment discipline: "a correction appends a version, and the prior
stays." That capability is the sole reason terms differ from status.

But the event model has no amendment event:
`Event = Registered UnitId TermsVersion | Moved Move | Settled UnitId Price`, and
the prose confirms the closure — "An event registers a unit, moves a quantity, or
settles a unit." Worse, `appendVersion` operates on `ProductTerms`, not on
`Ledger`; there is no ledger-level `amend` writer at all. So in this model terms
can never actually be appended after registration — the version list always has
exactly one element.

Two claims then collide in one pass:
- §Why Three para 3: "Both are rebuilt by replay" and "a correction appends a
  version" (amendments are live).
- §Why It Is Right: "every view is a projection of the stream."

If an amendment ever occurs, the resulting v2 is produced by `appendVersion`, which
is not an event — so the terms view is *not* a projection of the stream, and
"every view is a projection" is false. If an amendment never occurs (no wiring, no
event), then the append-only version list — the entire justification for the third
home (R1) — is a capability the model describes but does not provide.

Note the asymmetry with `psHwm`: the document is honest that the high-water mark's
writer is "out of scope here, so psHwm stays zero in this file." It is *not* honest
in the same way about terms amendment. Instead it stages "appendVersion keeps
history, settle throws it away" as the live, demonstrated contrast that forces the
split — but only `settle` is a real ledger/event operation; `appendVersion` is
neither wired nor replayable. The contrast is between a real operation and a
dangling one, and that asymmetry is hidden.

Action: pick one and make it consistent. Either (a) add an `Amended` event and a
ledger-level amend writer, so term versions are replayable and the projection claim
holds for terms too; or (b) flag amendment as out of scope exactly as `psHwm` is,
state that the version list therefore holds one element here, and narrow "every
view is a projection of the stream" to exclude the in-store term-version history —
and correspondingly fix "Both are rebuilt by replay" (only version one is).

## R3 — Unparseable clause carrying the core distinction. (§Why Three, para 3)

"...prior versions are queried directly for audit while a prior settlement value is
only ever needed as the current projection."

A *prior* value "needed as the current projection" is self-contradictory on its
face, and this clause is precisely where the terms/status retention difference is
supposed to land. The reader stalls and re-reads — a single-pass failure on the
sentence that matters most.

Action: reword to the intended meaning, e.g. "prior term versions are queried
directly for audit, whereas an earlier settlement price is never queried directly —
only the current price is read, and any earlier value is recovered by replaying to
the relevant prefix."

---

## What is already obvious (so the fix is local, not structural)

- The (holder, unit) key for Position: the +1000/-1000 collapse is a crisp illegal
  state. Solid.
- The unit key for Status: one writer, no drift. Solid.
- Conservation: "applyMove is the only writer of psBal; its two legs are exact
  inverses; emptyLedger sums to zero; sealed constructor leaves no other door."
  This is a clean by-construction proof, not an assertion. Solid.
- Determinism from purity of a total `apply`, and checkpoint soundness from the
  monadic left-fold law. Solid, and correctly separated from retention.

The defect is confined to the retention axis and its interaction with replay. Close
R1–R3 and the document reaches OBVIOUS; until then the reader cannot see, in one
pass, why terms *must* be a third home rather than a second field.
