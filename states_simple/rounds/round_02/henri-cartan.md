# henri-cartan — Round 2 — States.tex

## Verdict: NOT-YET

The two formal theorems — conservation and deterministic replay — are proved
essentially in full and I do not miss the omitted steps. Conservation is a clean
induction: base `emptyLedger` has psBal-sum `mempty`; `applyMove` shifts the sum
by `negQty q <> q = mempty`; `settle` leaves psBal untouched; the sealed
constructor closes every other door. Determinism follows from `apply` being pure
and total, with checkpointing justified by the `foldM` concatenation law. On my
lens these two cells are OBVIOUS.

The verdict is NOT-YET because the document's *answer* — the placement, and the
claim that "every view is a projection of the stream" — has located residue a
competent engineer will trip on, not skim past.

## Residue

### R1 (primary) — "Every view is a projection of the stream" is contradicted by the construction.

Location: §"Why It Is Right", deterministic-replay paragraph: "Settled is an
event, so replay rebuilds status with positions: every view is a projection of
the stream." Cross-cuts the stated Purpose ("every other view ... is a projection
of that stream").

The `Event` type is `data Event = Moved Move | Settled UnitId Price`
(§"Deterministic replay"), and "An event is a move or a settle" is given as a
definition. There is no registration or terms-amendment event. Therefore:

- `replay` never writes `ledgerPT`. Terms enter only through the separate writer
  named in §"Two writers" ("Registration writes a unit's terms and status
  together"), which is not in the stream.
- `replay` from `emptyLedger` can apply no move: `applyMove` gates on
  `Map.member u (ledgerPT l)`, and `emptyLedger` has empty terms. Every move is
  refused until an out-of-stream `register` pre-populates the ledger. (Confirmed
  in States.hs: the worked example is `l0 = register uES ... emptyLedger`, then
  replay folds from `l0`.)

So of the three homes, status and positions are projections of the stream; terms
are a *precondition* established outside it. The universally-quantified claim
"every view is a projection of the stream" is false for one of the three views it
quantifies over. This is the document's headline guarantee, so the gap is not
cosmetic.

Action — one of:
- (a) Add a registration/terms-amendment constructor to `Event` so terms become
  stream-projected, and show `appendVersion` is the writer it dispatches to; or
- (b) Restrict the claim precisely: "status and positions are projections of the
  stream; terms are established by registration, a writer outside the stream,
  versioned in the store because their history is not reconstructable from it."
  Option (b) is the smaller edit and also supplies the forcing argument R2 needs.

### R2 — The second axis of the 2×2 ("discipline") bundles two independent attributes without the forcing argument that makes it binary.

Location: §"The Answer": "Unit-keyed state divides again by discipline: an
externally-sourced authority, versioned and never rewritten, or an internal value
overwritten in place." And §"Why Three", paragraph "Terms are separate from
status...".

"Discipline" silently fuses two distinct binary attributes: provenance
(external vs internal) and history (versioned/append-only vs overwritten). The
document asserts external ⟺ versioned and internal ⟺ overwritten, but does not
prove the binding is forced rather than chosen. Taken as independent, the
classification is 2×2×2, not 2×2, and the reader cannot see why the
internal-versioned and external-overwritten combinations are excluded.

The forcing argument exists and is the right one, but it is never stated: an
internal value (status, settlement price) is reconstructable from the event
stream because `Settled` is an event, so its store copy may be safely
overwritten; an external fact (terms) is *not* in the stream (R1), so its history
must live in the store and is therefore versioned. State this once in §"Why
Three" and the second axis collapses to binary by necessity, and the empty fourth
cell's emptiness inherits the same reason.

Note: R2's resolution depends on R1 — the argument "internal is reconstructable
from the stream, external is not" is only sound once the relationship between the
`Event` type and each home is made honest.

### R3 (minor) — "applyMove is the only function that touches psBal" is load-bearing but unverifiable from the document.

Location: §"Why It Is Right", conservation paragraph. The conservation induction
rests on this "only", yet the writer `register` is described, not shown, in the
`.tex`. The reader cannot confirm `register` (and any other writer) leaves
`psBal` untouched from the document alone. One clause stating that the
non-position writers touch `ledgerPT`/`ledgerUS` exclusively would close the
induction's coverage of the registration step.
