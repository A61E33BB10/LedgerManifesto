# FORMALIS — Round 4 verdict on `States.tex`

**VERDICT: OBVIOUS**

My lens: correctness must be *visible* — conservation and deterministic replay
must be evident consequences of the structure, and nothing load-bearing in the
essence may be dropped, weakened, or hidden to read cleaner.

## Conservation is visibly forced

The argument is closed and I can reconstruct it from the page alone:

1. `applyMove` is the *only* writer of `psBal` (`register`/`settle` touch only
   `ledgerPT`/`ledgerUS`). Stated, and true of the exhibited code.
2. Each move writes two legs from one quantity: `negQty q` at `from`, `q` at
   `to`, so the per-unit delta is `negQty q <> q = mempty`. This holds for every
   `from`/`to`, including `from == to` (the second `leg` reads the map already
   updated by the first), so there is no edge case the claim misses.
3. Base case: `emptyLedger` has empty maps, so every `netBal` is `mempty`. A
   freshly `register`ed unit has no position rows, so its `netBal` is `mempty`
   too — the base case survives unit introduction.
4. Closure: the `Ledger` constructor is sealed ("leaves no other door"), so the
   reachable set is exactly what the four writers produce. The store *type* can
   hold a non-conserving map; conservation is correctly disclosed as a *writer*
   invariant, not a type guarantee. This honesty is the correct call: a `Map`
   cannot cheaply carry "sums to zero," and the doc says so rather than
   pretending the type forbids the bad value.

`netBal` computes the very sum the invariant is stated over. The Σ = 0 property
is therefore a consequence of structure I can *see*, not assert.

## Deterministic replay is visibly forced

`apply` is a total function (every constructor maps to a writer that always
returns a defined `Maybe`), and pure. `replay = foldM (flip apply)`.
Determinism follows from purity; checkpoint-independence follows from the
monadic left-fold law, stated correctly. The `Maybe` is `foldM`'s failure and
its meaning ("is this unit known?", never "did the balance hold?") is kept
distinct from the conservation guard. "Every view is a projection of the stream"
is literally true because `Registered`/`Settled`/`Moved` are all events.

## KEEP items — all present, none weakened

1. Three homes, no fourth — present (2×2, three occupied cells, fourth empty). ✓
2. No wallet-keyed economic sector; KYC/permissions/audit-cursor named as
   identity, not economic state. ✓
3. never-held vs held-and-flat — carried by the `Maybe` on `holding`, with both
   readings used (settlement entitlement vs wash-sale lookback); the enriched
   position map inherits it. ✓
4. Three forcing reasons, each with a concrete example (buyer +1000 / seller
   −1000; one settle price read identically; terms append vs status overwrite). ✓
5. Conservation + deterministic replay visibly forced (above). ✓
6. Mandate-as-unit example, summing to zero, grounds the absence of a fourth
   sector. ✓

DROP items (Pareto frontier, rejected designs, C1–C12, risk register, test
catalogue, "we considered X") are all absent. The small examples retained are
exactly the allowed kind.

## One point examined, and cleared (not a veto)

The "Terms are separate from status" paragraph says the split is "by provenance,
not necessity" — "a combined cell is spellable." The essence (reason 4, third
bullet) frames this as forced ("two change disciplines cannot share one home
without conflating them"). The `.tex` is the *more honest* statement: a single
home carrying both a version list and a current value is indeed spellable, so
the split is a provenance-driven design choice, not a logical necessity. The
*load-bearing* fact — that terms are an external authority's auditable, versioned
artifact while status is the ledger's own overwritten record, and that the kept
shape (version list vs single value) follows authorship — is fully present and
correctly attributed. This reveals more than it hides; it does not weaken a
load-bearing fact, so it does not trip the veto. If anything it raises the
document's correctness standing.

## Minor (non-blocking) observations

- `defaultStatus` is referenced in the `register` listing but defined only in
  `States.hs`; the prose ("`Listed` at registration") supplies its meaning, and
  the file declares its excerpts draw from `States.hs`. Not load-bearing.
- The `.tex` exhibits the never-held/held-and-flat distinction on `holding`
  (`Balances`) rather than on a `Ledger`-level `position` accessor; the
  "balance map enriched" sentence carries it forward. Adequate as presented.

Neither touches conservation, replay, or any KEEP item.

## Conclusion

A competent engineer reading only these pages sees conservation fall out of
"a move is two cancelling legs, written by the one sealed door, from an empty
base," and replay fall out of "apply is pure and total, replay is its fold." No
omitted proof is missed. The simplicity did not cost a load-bearing fact.

**OBVIOUS.**
