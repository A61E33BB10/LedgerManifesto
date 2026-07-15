# DIRAC — Round 16 — States.tex

**Verdict: OBVIOUS**

The three-home structure reads as inevitable. I tried to break it from six angles;
each is pre-answered in the text. What remains is two framing nuances in the opening,
non-blocking.

## What makes it inevitable

The derivation has the shape of a good physical law: one premise, two orthogonal
coordinates, and each coordinate doing double duty.

**Premise (the one rule).** Every economic relationship a wallet has *is* a unit it
holds. From this alone: a fact about a relationship is a fact about a position in a unit,
so every economic fact carries a unit in its key — never a wider key. This is what
excludes the wallet-only facts (KYC, permissions, audit cursor): they are not units, so
they are not economic state. The exclusion is a *consequence* of the premise, not a
separate gate. (Premise proved for one mandate §why; multi-instrument case honestly
flagged as assumed, not proved — the only acknowledged gap, and it is acknowledged.)

**Two coordinates, each load-bearing twice.** This is where the beauty is.

- *Holder axis* (does the fact depend on the holder?) determines **key arity**, hence
  **which map**. It is justified by conservation/drift: two holders hold opposite
  quantities (Position must be per holder); one settlement price is read identically by
  all (Status must be per unit, or it drifts across rows).
- *Authorship axis* (who owns the record's history?) determines **update discipline**,
  hence **value shape**. Ledger-authored → overwrite → single value (Status, Position).
  Externally authored → preserve versions → non-empty list (Terms). The same axis that
  places the fact fixes its data structure.

So: holder axis → 2 keys → 2 maps. Both axes → 4 cells, 3 occupied → 3 homes = 3 value
types. The count "three homes, two maps" is not a special case; it is the arithmetic of
two binary questions where one square is empty. The pairing of Terms+Status into one map
is forced — they share the key, so co-presence becomes the *shape* of the map rather than
an invariant to police.

**The empty cell is argued, not assumed.** No authority issues a fact about one holder's
position; a position is the ledger's own from origin (quantity folded from moves, HWM
from the valuation event). External position statements are reconciliation inputs, not
adopted records. The managed-account apparent counterexample is reified away (mandate is
itself an issued unit summing to zero). This is the load-bearing claim behind "three not
four," and it rests on a real principle rather than fiat.

## Objections I raised and found already answered

1. **Is conserved-vs-not a competing third criterion?** No — it is a property of a
   field's writer, orthogonal to placement. `psHwm` rides *within* Position; it creates no
   home. Pre-empted in §construction.
2. **Is "economic vs identity" a smuggled third criterion?** No — it follows from the
   premise (economic facts are about relationships = units), so wallet-only ⇒ non-economic.
3. **benchmark level vs benchmark identity — same provider, ambiguous?** The sharpest
   classification, and explicitly resolved: authorship = who owns the *history*, not who
   sources the number. The ledger overwrites the level (ledger-authored); the provider
   restates the identity version by version (externally authored).
4. **Why two maps, not one keyed by (Maybe Wallet, Unit)?** Unit-keyed-by-holder would
   copy one number across thousands of rows free to drift — a reconciliation break by
   construction. The two keys cannot be unified. §why.
5. **Why pair Terms+Status rather than separate maps?** Separation would require
   forbidding "in terms but not status." Pairing makes co-presence structural.
6. **`psHwm` typed `Qty` but inert in this file** — acknowledged in text; it earns its
   place by showing Position carries non-conserved state beside the conserved balance,
   i.e. Position ≠ a bare balance map. Honest, not a wart left unexplained.

Every objection a fresh reader would raise is met where they would raise it.

## Non-blocking observations (do not gate the verdict)

- **Opening goal pair vs second-axis motivation.** The abstract names the attainable
  properties as "conservation and deterministic replay." The holder axis maps cleanly to
  conservation; the authorship axis is in fact motivated by *single-source-of-truth /
  no co-mingling* (the project's stated core purpose, §why), while deterministic replay is
  delivered by a separate mechanism (purity + totality of replay). The thread is coherent,
  but a reader expecting the two placement axes to map onto the two named goals meets a
  small kink. Naming single-source-of-truth alongside the two in the abstract would close
  it. Framing only; the home structure is unaffected.
- **Wallet-only exclusion** is shown by example (KYC) and derived from the premise, but the
  structural reason — conservation, valuation, and P&L are each unit-anchored, so a
  unit-free key cannot enter them — is left implicit. Stating it once would make the
  exclusion read as forced rather than illustrated. Minor.

Neither observation touches the inevitability of three homes. The structure is beautiful
in the operative sense: the count falls out of the classification, the classification
falls out of one premise, and each axis is reused to fix both storage and shape.
