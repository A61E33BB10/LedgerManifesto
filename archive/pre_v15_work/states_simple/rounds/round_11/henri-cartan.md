# henri-cartan — Round 11 — States.tex

**Verdict: NOT-YET**

## What is obviously right

The formal core stands on its definitions and needs no omitted proof:

- **Conservation.** `applyMove` is the only writer of `psBal`; it derives both legs
  from one `q` as `negQty q` and `q`, exact inverses in the `Qty` group, summing to
  `mempty`. `register`/`settle` touch only `ledgerUnit`. Induction from `emptyLedger`
  (sum zero) with the sealed constructor closing all other doors gives the invariant.
  Self-move and zero move net `mempty` on every wallet and are correctly skipped by
  the `d == mempty` guard. The argument is complete.
- **Deterministic replay.** `apply` is pure and total over the three constructors;
  `replay = foldM (flip apply)`. Determinism follows from purity; the
  concatenation-split law for `foldM` is standard and its citation is acceptable.
- **The two maps, the pair, the NonEmpty/overwrite type split, the `Maybe` of
  `position` (never-held vs held-and-flat).** Each follows from the declarations
  shown; co-presence is the shape of the map, not a policed invariant. Sound.
- **Fourth cell empty** and the managed-account instance: a position exists only from
  ledger events, so the (holder, unit) externally-authored cell is empty by
  construction. The "every economic relationship is a unit" stance is a stated
  modeling axiom, fair to assert. Sound.

## Residue (load-bearing, located, actionable)

**The authorship axis, as defined, mis-sorts two of its own examples.**

- *Definition* (lines 69–72): "An externally authored fact is owned by an outside
  authority — the exchange, the contract, the reference-data provider — which the
  ledger consumes but never writes." The criterion is source-ownership.
- *Table* (lines 79–81): the ledger-authored **Status** column contains "last
  settlement price" and "benchmark level."
- *But* the settlement price is owned by the exchange, and the benchmark level by the
  reference-data provider — both authorities the definition explicitly names as
  external. Applying the stated definition literally, a competent engineer places both
  in the externally-authored **Terms** column, exactly beside the multiplier and the
  benchmark identity. The placement that the whole answer turns on does not follow
  from the definition given.

The justification offered (lines 93–95, 124–131) asserts "the ledger owns status / a
settlement is the ledger's event / Status is the ledger's own," but never states the
criterion that separates an exchange-sourced **settlement price** (placed
ledger-authored, overwritten) from an exchange-sourced **multiplier** (placed
externally-authored, versioned). Both are external in source; both enter the store
through a ledger event (settlement; amendment, conceded as an event on line 134). So
"authorship/ownership" cannot be the discriminator — under it the two are the same.

The real discriminator appears to be **contractual identity, preserved as the
authority's record (Terms)** versus **current valuation mark, overwritten as the
ledger's own reckoning (Status)** — with both histories also recoverable from the
event stream. The document gestures at this but labels and defines the axis as
source-authorship instead.

**Fix (either):** (a) replace the source-ownership definition on lines 69–72 with the
identity-vs-current-reckoning criterion that actually sorts the table, and re-derive
the Terms/Status split from it; or (b) keep the authorship axis but state explicitly
why an exchange-sourced settlement price and a refdata-sourced benchmark level are
ledger-authored while an exchange-sourced multiplier is not — i.e. name the additional
criterion the placement silently relies on. Until then the per-unit split (the load-
bearing half of the answer) does not follow from its stated definition.
