# FORMALIS — Round 5 verdict on `States.tex`

**VERDICT: OBVIOUS**

My lens: correctness must be *visible* — conservation and deterministic replay
must be evident consequences of the structure, and nothing load-bearing in the
essence may be dropped, weakened, or hidden to read cleaner. I do not affirm to
be agreeable; OBVIOUS stakes the lens.

## Conservation is visibly forced

I reconstruct the closed argument from the page alone:

1. `applyMove` is the *only* writer of `psBal`. `register` and `settle` touch
   only `ledgerUnit`; `applyMove` touches `ledgerPS` via `leg`, which is the sole
   site that writes `psBal`. True of the exhibited listings.
2. Each move writes two legs from one quantity — `negQty q` at `from`, `q` at
   `to` — so the per-unit delta is `negQty q <> q = mempty`. This holds for every
   `from`/`to`, including the degenerate `from == to`: the second `leg` reads the
   map already updated by the first (`orig <> negQty q <> q = orig`), net zero.
   No edge case escapes the claim.
3. Base case: `emptyLedger` has empty maps, every `netBal` is `mempty`; a freshly
   `register`ed unit lays down no position row, so the base survives unit
   introduction. Issuance is itself a `Move` (manager `-1` / client `+1`), so
   there is no one-sided mint that could open a hole — the only door to a position
   is a two-legged transfer.
4. Closure: the `Ledger` constructor is sealed, so the reachable set is exactly
   what the four writers produce. Conservation is correctly disclosed as a
   *writer* invariant, not a type guarantee — the store type can hold a
   non-conserving map, and the document says so rather than pretending the type
   forbids it. `netBal` computes the very sum the invariant ranges over. Σ = 0 is
   a consequence I can *see*, not assert.

`psHwm` is honestly carried as the contrast: same type `Qty`, adds, but has no
paired cancelling writer, so it bears no zero-sum invariant. This is disclosure,
not concealment.

## Deterministic replay is visibly forced

`apply` is total (each of the three constructors maps to a writer returning a
defined `Maybe`) and pure. `replay = foldM (flip apply)`. Determinism follows
from purity — no clock, no randomness, and `Map.toList`/`foldMap` over the
commutative monoid `Qty` are order-stable, so there is no dictionary-iteration
nondeterminism. Checkpoint-independence follows from the monadic left-fold law,
stated correctly. The `Maybe` is `foldM`'s failure; its meaning ("is this unit
known?", never "did the balance hold?") stays distinct from conservation. "Every
view is a projection of the stream" is literally true because
`Registered`/`Settled`/`Moved` are all events; the document also correctly
separates row-retention (an audit property) from determinism (purity alone) —
a sharpening over the essence's looser coupling, not a loss.

## KEEP items — all present, none weakened

1. Three homes, no fourth — the 2×2 (key × correction discipline), three
   occupied cells, fourth empty with its own concrete reason. ✓
2. No wallet-keyed economic sector; KYC, permissions, audit cursor named as
   identity, not economic state. ✓
3. never-held vs held-and-flat — carried by the `Maybe`, both readings used
   (settlement entitlement vs wash-sale lookback), inherited by the enriched
   position map. ✓
4. Three forcing reasons, each with a concrete example (buyer `+1000` / seller
   `-1000`; one settle price read identically; terms append vs status
   overwrite). ✓
5. Conservation + deterministic replay visibly forced (above). ✓
6. Mandate-as-unit example, summing to zero, grounds the absence of a fourth
   sector; two mandates are two rows. ✓

DROP items (Pareto frontier, rejected designs, C1–C12, risk register, test
catalogue, "we considered X") are absent. Retained examples are the allowed
forcing kind.

## The point that changed since Round 4, examined and cleared

In Round 4 the terms/status split was framed as "by provenance, not necessity";
Round 5 reframes it as forced — *"their correction disciplines cannot inhabit one
value... a single value admitting both writers would be at once an append-only
list and an overwrite-in-place cell"* — and line 76–77 now states the placement
rule explicitly: *what places a fact is how its correction is recorded, not who
authored the number.*

I pressured this for an overclaim and it holds. The necessity is type-level and
true: one homogeneous cell cannot honor *both* "append and retain prior" and
"overwrite and discard prior" — retaining-vs-discarding forces a version-list
shape against a scalar shape, two distinct types. The document does not deny that
both can be *carried together*; it concludes exactly that — two distinct values
riding as a pair under one key, "a third home, not a third map." So the
spellable "combined cell" Round 4 noted is precisely the pair the document
builds; nothing is suppressed. The reframing is a correct sharpening, and it
makes the whole document consistent on one rule (placement = correction
discipline), removing the provenance/authorship hedge rather than hiding a fact.
This raises the document's correctness standing; it does not trip the veto.

## Minor (non-blocking)

- `defaultStatus` and the deriving clauses appear in `States.hs`, not the `.tex`
  listings; the file states the listings reproduce `States.hs` with deriving
  elided, and the prose supplies meaning. Not load-bearing.
- The Σ = 0 conclusion is stated as "every reachable ledger conserves" rather
  than as the explicit equation `netBal l u = mempty`; `netBal` immediately below
  makes the referent unambiguous. Not load-bearing.

Neither touches conservation, replay, or any KEEP item.

## Conclusion

A competent engineer reading only these pages sees conservation fall out of "a
move is two cancelling legs, written by the one sealed door, from an empty base,"
and replay fall out of "apply is pure and total, replay is its fold." Totality,
determinism, and the sealed-constructor closure are all visible. No omitted proof
is missed. Simplicity did not cost a load-bearing fact.

**OBVIOUS.**
