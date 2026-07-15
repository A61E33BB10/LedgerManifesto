# DIRAC — Round 14 — States.tex

**Verdict: OBVIOUS**

## The bar

The three-home structure must read as inevitable from one rule — no unexplained
special case, no competing criteria. Reader: a competent engineer new to the problem.

## The rule

The placement is a single classification: each economic fact is sorted by two
orthogonal binary observables — *key-scope* (per unit / per holder-unit) and
*record-owner* (ledger / external). This is one rule, not two competing ones. The
two questions never conflict: every fact has a determinate answer on each axis, and
their product is a 2×2. A 2×2 from two orthogonal observables is a complete basis,
not a pair of rivals — the most beautiful classification there is. The count three
is then the basis minus one predicted-empty cell.

I checked the obvious failure modes and each is closed:

- **Authorship could be a competing criterion (source vs owner).** The text
  decisively picks ownership ("who owns the record's history, not who sources the
  number") and discharges the tempting counterexample: a settlement price sourced
  from the exchange is ledger-authored because the *record* is the ledger's own
  settlement event. The benchmark example splits one provider's output into a
  ledger-authored level and an externally-authored identity — two facts, each
  landing cleanly. The axis is binary and exhaustive by decomposition, never
  co-authored. Disambiguated to one criterion. PASS.

- **Authorship could be applied unevenly (a special-case split).** It splits the
  per-unit row into Status/Terms but leaves the per-holder row with one occupied
  cell. This asymmetry is a *derived prediction*, not an assumption: the fourth cell
  is empty "for one concrete reason" — no authority issues a fact about one holder's
  position; a custodian/PB statement is a reconciliation input, not an adopted
  record. A predicted, then explained, empty cell (Dirac would call it the hole in
  the sea). The authorship axis is global; the asymmetry is a result. PASS.

- **Each occupied cell forced by one concrete reason** (§Why Three): Position
  because two holders of one contract hold opposite quantities; Status because one
  value is read identically by every holder (per-holder storage = drift =
  reconciliation break by construction); Terms distinct from Status because an
  outside authority owns the history (co-mingling = the single-source-of-truth
  violation the system exists to prevent). Four crisp reasons, one per cell. The
  structure reads as forced.

- **Every residual special case is explained, none unexplained:** three-homes /
  two-maps (Terms+Status share the unit key, bundled as a pair so co-presence is the
  map's shape); self-move and zero-move (net to `mempty`, write no row); held /
  never-held / held-and-flat via `Maybe` (motivated by settlement entitlement and
  wash-sale lookback); `psHwm` non-conserved with writer out of scope; the seal on
  the constructor (conservation by construction). No branch is arbitrary.

## The one load-bearing assumption — disclosed, not residue

The binary holder-axis (and so the count three) rests on the reification: every
economic relationship a wallet has is itself a unit the wallet holds, so no fact
needs a wider key (e.g. a wallet-pair). This is demonstrated for one mandate
(−1/+1, summing to zero like any issued unit) and **explicitly assumed, not proved**,
for a relationship spanning several instruments. The text flags this twice and names
it as the thing the count rests on.

This is not residue against *this* bar. It is not a competing criterion, not a
special case, and not unexplained — it is a named, bounded proof obligation the file
deliberately defers to scope. The action it implies ("prove general reification") is
explicitly out of scope for this file, so demanding it here would contradict the
file's own boundary. The structure reads as inevitable *given* a clearly-marked
assumption the document is honest about. That honesty is the correct register; it
does not dent obviousness of structure.

## The DIRAC test

1. Beautiful — 2×2, one predicted-empty cell, three homes, two maps. Inevitable feel.
2. Notation right — minimal Haskell, each newtype earns its place (`Price` has no
   monoid, so it can never be summed into a balance; `Qty`'s group forces the two
   legs to cancel).
3. Understood without solving — conservation and determinism are read off the
   structure (sealed constructor, single writer of `psBal`, total pure `apply`).
4. Unified — Status/Terms under one key; both maps under one `Ledger`; all events
   under one `apply`/`replay` fold.
5. Formalism trusted — the empty cell is investigated and explained, not dismissed.
6. Minimal — two maps, three events, no surplus.

No unexplained special case. No competing criteria. The three homes are inevitable.

**OBVIOUS.**
