# DIRAC — Round 17 — States.tex

## Verdict: OBVIOUS

The three-home structure falls out of a single classification rule, and the rule
is honest about its one axiom. I tested it the way I trust an equation: by
predicting where each fact must land before reading the prose, then checking that
nothing in the document needs a criterion I had not already been handed.

## The rule, stated minimally

A 2×2 over two orthogonal questions:

1. **Key**: does the fact depend on the holder, or only on the unit?
2. **Authorship**: does an outside authority own and restate the record, or does
   the ledger produce and overwrite it?

Cells:

|              | ledger-authored | externally authored |
|--------------|-----------------|---------------------|
| per unit     | Status          | Terms               |
| (holder,unit)| Position        | — empty —           |

Three occupied → three homes. Two distinct keys → two maps; the unit-key row
carries two occupied cells, so its value is the pair (Terms, Status). The
asymmetry "three homes, two maps" is forced, not chosen: cells sharing a key
share a map entry, and co-presence becomes the shape of the value rather than an
invariant to police.

## Why it passes the bar

**No competing criteria.** The decisive test: each of the four §"Why Three"
paragraphs maps to exactly one of the two questions, and to nothing else.

- Position keyed by (holder, unit) — Question 1 (buyer +1000, seller −1000).
- Status keyed by unit alone — Question 1 (one settlement price, one writer).
- Terms distinct from Status — Question 2 (different authorities of record).
- Fourth cell empty — Question 2 (no authority authors a position fact).

No fifth principle appears anywhere in the derivation. There is no place where
two criteria contend to place the same fact.

**The obvious rival criterion is preemptively excluded.** Conservation is the
criterion a careless designer would promote to an axis. The document refuses it:
`psHwm` (non-conserved) rides in the *same* Position home as `psBal`
(conserved). Conservation is therefore a property of one field, not a home
boundary. This is exactly the kind of "special case that does not exist"
prediction I look for — and the formalism makes it unspellable.

**No unexplained special case.** Every apparent irregularity is derived:
- The empty fourth cell — argued from origin: positions are folded from the move
  stream and written by valuation events; external position reports are
  reconciliation inputs, never adopted records. Consistent with the project's
  scope boundary (the ledger reconciles against external authorities, does not
  perform them).
- The managed-account "counterexample" (per-holder HWM/fee) — discharged by
  reification: the mandate is itself an issued unit (−1 manager, +1 client),
  so the fact is a (client, mandate-unit) Position, not a wallet-keyed fact.
- Wallet-only facts (KYC, permissions, audit cursor) — pruned before the 2×2 as
  identity, not economic state (they enter none of conservation, valuation, P&L).
  This removes the third key-shape cleanly rather than smuggling it in.
- The benchmark, split level/identity by the single authorship test — one
  criterion sorts the whole category; same provider, two cells, no ambiguity.

**The boundary of inevitability is named, not hidden.** The structure is
inevitable *given* the premise that every economic relationship is itself a unit
the wallet holds. The document states this as its premise, proves it for the
single-mandate case (§Why Three), and explicitly marks the multi-instrument case
as assumed, not proved. That is an axiom honestly flagged — not a special case
and not a competing criterion. It does not violate this round's bar, which
concerns whether the three-home structure follows from the rule; it does, once
the premise is granted, and the premise is exactly the grant the document asks
for.

## Notational / construction check

- `Qty` group (monoid + `negQty`) makes the two transfer legs exact inverses;
  conservation is then `negQty q <> q = mempty` — predicted without solving.
- `Price` deliberately has no identity and no inverse (never summed). Correct:
  the type witnesses that a price is not a balance.
- `Active Price` makes "active with no price" and "priced yet listed"
  unrepresentable — the correlation holds by the type, not by a trusted writer.
- Sealed `Ledger` constructor + withheld selectors leave conservation no other
  door. The pair value carries co-presence; the seal carries conservation —
  two concerns, two mechanisms, neither overloaded.

## Residue

None against this round's bar. The structure reads as inevitable from one
classification rule; the single axiom it rests on is named and scoped.
