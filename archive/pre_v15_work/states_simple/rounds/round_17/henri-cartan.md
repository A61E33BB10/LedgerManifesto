# henri-cartan — States, Round 17

## Verdict: NOT-YET

## What is obviously right

The in-scope construction is tight and its proofs follow directly from the
definitions; nothing there is missed.

- **Conservation (§5).** `applyMove` is the sole writer of `psBal`; `netDeltas`
  produces a two-key (or, on a self-move, one-key) map whose values sum to
  `mempty` (`negQty q <> q`), `writeNet` adds those deltas to the per-unit rows,
  and `register`/`settle` never touch `ledgerPS`. With `emptyLedger` summing to
  zero, the induction is immediate. The sealed constructor + withheld field
  selectors genuinely close the door: Haskell record-update `l { ledgerPS = … }`
  requires the field name in scope, so external code cannot install a
  non-conserving map. This part needs no further proof.

- **Determinism (§5).** `apply` is total (no partial matches, finite fold) and
  pure; `replay = foldM (flip apply)`. Determinism and the `Nothing`-on-first-
  refusal behaviour follow at sight. The checkpointing claim rests on the named
  monadic left-fold law, which is standard and citable.

- **Mechanics.** First-touch via `zeroP`; "held = named in a move that nets
  nonzero" (zero-qty and self-moves net `mempty`, write no row); the
  `Nothing`/`Just zero`/`Just nonzero` trichotomy on `position`; co-presence of
  terms+status as the shape of one map value; `Price` as a non-monoid newtype.
  All follow directly.

The document is also honest about its deliberately out-of-scope items
(`appendVersion` amendment, the valuation event writing `psHwm`, entry NAV).
Those are scoped boundaries, not hidden gaps.

## Residue (located, actionable)

**The multi-instrument reification is load-bearing for the headline result and
is asserted, not proved — and it does not follow from the single-mandate proof.**

- Location: §2 "The Answer", lines 58–66 ("every economic fact … is a
  (holder, unit) fact or a unit fact … never about a wider key") and §3
  "Why Three", lines 142–149 (the managed-account argument, closing with
  "that a relationship spanning several instruments is likewise a single unit,
  and so a single row, is assumed here, not proved").

- Why it is load-bearing, not a cosmetic scope note. The exhaustiveness of the
  2×2 — in particular the claim "never about a wider key" and hence the absence
  of any `(holder, set-of-units)` home — depends entirely on the premise that
  *every* economic relationship reduces to a position in a single wrapper unit.
  If some relationship spanning several instruments carries a per-holder,
  non-conserved economic fact (a portfolio-level high-water mark, a netted
  exposure, a cross-margin entitlement) that attaches to no single unit, then
  that fact lives at a `(holder, {units})` key. That is a fourth home and breaks
  both the three-home count and the two-map structure. So this is the linchpin
  of the classification's completeness, not an aside.

- Why the omitted proof is genuinely missed. The single-mandate case discharges
  cleanly precisely *because* the mandate is itself one issued unit (±1), so the
  client holds the wrapper, not the instruments. The proof exhibited therefore
  turns on the existence of a single wrapper unit. The general claim needs
  exactly the converse: that a relationship spanning several instruments is
  *guaranteed* to present as a single wrapper unit rather than as a
  bundle the holder holds severally. A competent reader cannot fill this in from
  the definitions, because the realistic instances (managed portfolios, netting
  sets, portfolio-margin agreements) are the ones where a single wrapper is *not*
  obviously present — which is why the proof is the hard one and why its absence
  is felt. The document naming it "assumed" confirms the doubt rather than
  discharging it.

- Actionable discharge — one of:
  1. Prove the reification: state and establish the condition under which a
     relationship spanning several instruments necessarily admits a single
     wrapper unit (and show every per-holder non-conserved economic fact attaches
     to that wrapper, not to the underlying instruments held severally); or
  2. Bound the headline to its proved scope: state in §2 that "three homes"
     holds for relationships reducible to a single unit, and that multi-instrument
     reducibility is a precondition imported from the unit definition, not a
     result of this file.

A secondary, smaller point feeding the same residue: §2 lines 63–67 take
"economic state" to be exactly what enters conservation, valuation, or P&L, and
assert that nothing keyed by the wallet alone enters any of the three. This is a
definitional move plus an example list (KYC, permissions, audit cursor); its
exhaustiveness is the same reification claim viewed from the wallet-only side,
and stands or falls with the residue above.
