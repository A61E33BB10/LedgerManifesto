# jane-street-cto — Round 17 — States.tex

**Verdict: NOT-YET**

## What I checked

I read `States.tex` end to end and verified the load-bearing technical claims,
cross-checking the seal and the high-water-mark treatment against `States.hs`.

The core is correct and the proofs hold:

- **The 2×2 and "three homes, two maps"** is a clean, exhaustive sort. The two
  criteria (holder-dependence; authority of record) are stated once and applied
  consistently. The benchmark-level / benchmark-identity example (lines 89–94)
  pre-empts the obvious objection ("both come from the provider") with the stated
  criterion (ownership of history, not source of number). Good.
- **Illegal states unrepresentable.** `Active Price` makes "active without price"
  and "listed yet priced" unspellable (lines 184–193); `NonEmpty TermsVersion`
  makes "registered but versionless" unspellable (203–219); the (terms,status)
  pair makes "in terms but not status" unspellable (239–259). This is the right
  instinct, executed correctly.
- **Conservation by construction** (336–350) is sound. `applyMove` is the only
  writer of `psBal`; it lays down two inverse legs from one `Qty`; the unexported
  `Ledger` constructor and field selectors close every other door. I verified the
  subtle point the text makes at 244–249: exporting `PositionState(..)` is
  harmless because a bad `PositionState` still cannot be *installed* without the
  `Ledger` selectors. The seal is placed on exactly the load-bearing boundary.
- **`netDeltas` / self-move** (292–306, 308–314). The `insertWith (<>)`
  construction nets the two legs to `mempty` on a self-move and to `-q`/`+q` on
  distinct wallets; `writeNet` drops zero nets. Correct, and the prose carries the
  reader through the self-move case.
- **Deterministic replay** (352–374). `apply` is pure and total (total Map ops,
  `NE.last` total, total patterns); `foldM` halts at the first `Nothing`; the
  checkpoint-splitting claim rests on the monadic left-fold law. Correct.
- The reification premise (a multi-instrument relationship is one unit) is
  explicitly flagged as assumed, not proved (58, 148–149). That is honest scoping,
  not overclaim — a reader is told where the floor is, so it does not force
  commentary. Not residue.

This is careful, correct work. One thing keeps it from "obvious."

## Residue (located, actionable)

**`psHwm` contradicts the document's own typing principle, and the reader cannot
tell what it measures.** Lines 221–237.

One paragraph earlier the document establishes a rule and uses it as a design
argument: a thing that is *never summed* must not be given a summable type —
"`Price` is a separate newtype with neither identity nor inverse, never summed
into a balance" (191–193). `psHwm` is then introduced as a field that is
explicitly *never* summed: "no move writes it as a cancelling leg," "never folded
over holders" (227–229). Yet it is typed `Qty` — the group with identity and
inverse whose whole purpose is summation. The justification given is only "typed
`Qty` to match its source" (228), but the source is out of scope and its units are
never named, so the reader is handed a summable type for a value the same document
says must not be summed, with no way to see why the type is right.

Two concrete consequences a new reader hits at 3am:

1. *Inconsistency.* By the document's own Price argument, a peak that is never
   added should carry a non-summable newtype (`Price`, or a dedicated `Level`),
   precisely to make the illegal operation — `foldMap` over high-water marks —
   unrepresentable. As written, the type *invites* the very mistake the Price
   paragraph was constructed to forbid. The reader writes a margin note: "why is
   this `Qty` and Price isn't?"

2. *Ambiguity of meaning.* "High-water mark … retained for tax reporting" (223,
   and the table entry at 84) reads as a peak of *value* (price-like), but the
   type `Qty` says peak of *quantity*. The text never says a peak *of what*. A
   reader cannot decide whether `psHwm` is a quantity or a value, and the type and
   the name point in opposite directions.

Note: `States.hs` (lines 579–591) actually resolves this — it states plainly that
the file "leans on *none* of `Qty`'s group structure for `psHwm`" and that "its
algebra belongs to its out-of-scope writer." That candor is exactly what makes the
`.hs` reading not stumble here. The `.tex` compresses it to four words ("to match
its source") and loses the resolution. The fix is to port that candor into the
`.tex`: either (a) carry the one sentence from `States.hs` ("this file leans on
none of `Qty`'s group structure for `psHwm`; its algebra belongs to its
out-of-scope writer"), and say what the peak measures; or (b) better, give it a
non-summable newtype consistent with the Price principle, which makes the
non-summing claim hold by the type rather than by prose.

Until one of those lands, a competent reader new to the problem writes commentary
at lines 221–237 to reconcile `psHwm : Qty` with the Price rule. That is the gap
between this and "obvious."
