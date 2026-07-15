# DIRAC — States, Round 13

**Verdict: NOT-YET.** One residue, located and actionable. Everything else is
inevitable and beautiful; the single gap is in the load-bearing claim that makes the
count *three* rather than *four*.

## What is right (and why I looked hard for a reason it wasn't)

The placement rule is genuinely one rule, not two competing ones. The two questions
are orthogonal axes of a single 2×2, and each axis has exactly one structural
consequence:

- Axis 1 (depends on holder?) fixes the **key**: `UnitId` vs `(WalletId, UnitId)`.
- Axis 2 (who owns the record?) fixes the **value discipline**: append-only versioned
  list (`ProductTerms`) vs overwritten single value (`UnitStatus`, `PositionState`).

So "three homes, two maps" is not an asymmetry to excuse — it falls out: maps are
keyed stores, the number of maps equals the number of distinct keys (2), and the two
unit-keyed homes ride as a pair because they share a key but differ in discipline.
Question1→key, question2→discipline is a clean unification, not two criteria fighting.
I tried to read "two questions" as a violation of "one rule" and could not: orthogonal
product axes are one classification.

The construction carries no unexplained special case I can find:
- `Lifecycle = Listed | Active Price` makes "active without price" unspellable —
  the correlation holds by the type, not by a trusted writer.
- The sealed `Ledger` (constructor + selectors withheld) closes the only door to a
  non-conserving write; conservation is then induction from `emptyLedger` over the
  sole `psBal` writer.
- `Maybe` on `position` carries a real three-way distinction (never held / held /
  held-and-flat) with a stated consumer.
- self-move and zero-move both net `mempty` and write no row — handled uniformly, not
  as cases.

These are inevitable. No objection.

## The residue (single, located, actionable)

**The reification of multi-instrument relationships is load-bearing for "exactly
three" and is assumed, not proved or anchored.**

Location: §The Answer, lines 64–67 ("a relationship spanning several instruments
likewise reifies as one unit is assumed, not proved here"); §Why Three, lines 158–161
("that a relationship spanning several instruments is likewise a single unit ... is
assumed here, not proved").

Why it is load-bearing, not a side note. The reification does two jobs at once:

1. It makes **Axis 1 binary**. Every economic per-wallet fact is claimed to be a
   `(holder, unit)` fact on a reification; pure per-wallet facts are pushed out as
   "identity, not economic state." If a relationship genuinely spans several
   instruments and does *not* collapse to one unit, its state is per-`(holder,
   set-of-units)` — a **third key shape**, breaking "two maps."
2. It empties the **fourth cell**. The managed-account counterexample is dissolved
   only by reifying the mandate into a unit so its high-water mark becomes a
   `(client, mandate-unit)` position.

So the headline count — three homes, two keys, fourth cell empty — is inevitable
*only if* an arbitrary economic relationship reifies to a single unit. The file proves
this for one mandate and then assumes it for the general case, with no pointer to where
the general case is established. The count is therefore conditional, not forced. A
competent first-time reader who asks the natural question ("is a portfolio-margin or
netting set spanning many instruments really one unit?") finds it named and deferred,
not answered. Rightness pending a proof is not obvious rightness.

Actionable discharge (any one suffices):
- Anchor the claim: cite the unit-model specification where "an economic relationship
  is a unit" is established, and restate this file's "three" as conditional on that
  named axiom rather than on a local unproved assumption. This converts a dangling
  assumption into a cited dependency, and "three" becomes inevitable relative to a
  named foundation.
- Or prove the multi-instrument reification here.
- Or show directly that an *unreified* multi-instrument relationship still lands in one
  of the three homes (i.e., demonstrate it cannot introduce a third key), which would
  make the reification unnecessary to the count.

Until one of these closes, the structure reads as *very probably* three, not
*inevitably* three.
