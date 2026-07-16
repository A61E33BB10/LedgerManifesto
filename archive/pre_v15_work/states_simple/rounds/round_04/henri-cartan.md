# henri-cartan — Round 4 — States.tex

## Verdict: OBVIOUS

The bar: the answer follows from its definitions so directly that the omitted
proof is not missed. The document clears it.

## What I checked, and why it holds

### The two formal invariants are complete proofs, checkable from the code shown

**Conservation.** The claim is: for every reachable ledger and every unit `u`,
the net held quantity is `mempty`. The proof is a clean induction with a sealed
constructor closing the door:

- Base: `emptyLedger` — `netBal` folds over the empty list to `Qty 0`.
- `register`, `settle` touch only `ledgerPT`/`ledgerUS`, never `psBal`, so every
  net is unchanged.
- `applyMove` is the only writer of `psBal`; it writes `negQty q` and `q` from
  one quantity, so the net of the affected unit changes by
  `negQty q <> q = mempty`, and no other unit's net changes.

I checked the degenerate `from == to` case the prose does not call out: the legs
apply sequentially (`leg to q (leg from (negQty q) ...)`), so the cell receives
`(-q)` then `(+q)` and returns to its prior value — still conserving. The
sealed, unexported `Ledger` constructor and the single-writer fact ("no other
door") make the induction exhaustive. Nothing is missed.

**Determinism / replay.** `apply :: Event -> Ledger -> Maybe Ledger` is pure and
total (always returns a value, possibly `Nothing`), so the fold is a deterministic
function of the event list. Checkpoint soundness is justified by the foldM
concatenation law, which holds for the `Maybe` monad. Both are citable facts, not
hand-waves. Not missed.

### The PT/US key invariant is derivable from the writers

"A unit appears in the terms map exactly when it appears in the status map":
`register` is the only key-adding writer and adds to both at once; `settle` gates
on `ledgerUS` membership and only overwrites; `applyMove` gates on `ledgerPT` and
touches only `ledgerPS`; nothing deletes. Hence `keys(PT) = keys(US)` always, and
the two gates are interchangeable. The document's claim stands by construction.

### The taxonomy's load-bearing claims are stated, not merely asserted

- **Position keyed by (holder, unit):** forced, shown by the +1000/-1000 buyer/
  seller example. A unit-keyed value provably collapses the two.
- **Status keyed by unit alone:** the necessity argument (per-holder storage =
  copies free to drift = reconciliation break by construction) is sound.
- **Empty fourth cell:** this is close to a derivation, not an assertion. A
  position is *defined* as the fold of internal move events, hence ledger-authored
  by construction; therefore it cannot be an external versioned artifact. Combined
  with the reduction principle below, positions are the only (holder, unit)
  economic state, all ledger-authored, so the external-(holder,unit) cell has no
  possible occupant.
- **No wallet-only economic state:** the reduction principle is stated explicitly
  ("every economic fact about a wallet is a fact about that wallet's relationship
  to some unit"), grounded in the definition "a unit is anything that can be held,"
  and the one tempting counterexample (managed account: high-water mark, entry NAV,
  accrued fee) is worked in full by reifying the mandate as a `-1/+1` issued unit.

### Forced vs. chosen is kept honest

Where the design is not forced, the document says so: the version-list shape of
terms "follows authorship; a combined cell is spellable, so the split is by
provenance, not necessity." This is exactly the rigour my lens demands — it does
not over-claim necessity, so no false "QED" is left for the reader to trip on.

## Residue I considered and dismissed

- *The dichotomy "unit alone or (holder, unit)" omits a global / "neither" key
  class.* It does not actually escape: global market data is reified as units —
  "benchmark identity" is listed under Terms and "benchmark level" under Status.
  Global economic facts therefore land in unit-keyed homes, and the reader can see
  this directly from the lists. The closure is shown by example rather than by a
  closing sentence, but the answer is present, so the omitted sentence is not a
  missed proof.

A competent engineer new to the problem can follow every step and reconstruct the
two invariants from the code as printed. OBVIOUS.
