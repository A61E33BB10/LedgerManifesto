# States.tex — Round 15 review (jane-street-cto)

Verdict: **NOT-YET**

Reader frame: a competent engineer, six months on, who has never seen this
problem. Can they read it once and call it obvious, with no commentary, no
overclaim?

## What is right

The skeleton holds up under scrutiny. I checked the load-bearing claims, not
just the prose:

- **Conservation.** `applyMove` is the sole writer of `psBal`; `netDeltas`
  builds the per-wallet delta map and `writeNet` folds it in. Two distinct
  wallets net `{from: negQty q, to: q}`; a self-move collapses to
  `{from: mempty}` via `insertWith (<>)` and is then skipped by the
  `d == mempty` guard. Per-unit sum is preserved by every event from
  `emptyLedger` (sum zero). The sealed constructor + withheld field selectors
  close the "other door." This is correct and the argument is complete.
- **Deterministic replay.** `apply` is pure and total (Maybe-returning, no
  partial matches, no divergence); `replay = foldM (flip apply)`. The
  checkpoint-splitting appeal to the monadic left-fold law is sound.
- **Type discipline.** `Listed | Active Price` makes "active with no price" and
  "listed with a price" unspellable — genuinely by construction. `NonEmpty` +
  unexported constructor makes "registered but versionless" and history-shortening
  unrepresentable. `Price` as a non-monoid newtype (no sum) is well motivated.
- **`Maybe` semantics.** "never held" (Nothing) vs "held and flat"
  (`Just` row, `psBal` zero) is cleanly separated and the retained-row rationale
  (settlement entitlement, wash-sale lookback) is concrete.
- **Honesty about scope.** The multi-instrument reification is explicitly
  *assumed, not proved*; `appendVersion` and the valuation writer are explicitly
  out of scope. No overclaim there.

The structure (Question → Answer → Why Three → Construction → Why It Is Right)
is the right spine, and the 2×2 placement test is a clean organizing idea.

## Residue (located, actionable)

### R1 — The high-water mark's type is asserted, not derived, and contradicts the document's own Price rationale.

Locations:
- §The Construction, "A position carries more than a balance," lines 221–233;
  the claim at lines 227–228: *"\texttt{psHwm} is also a \texttt{Qty}, and
  rightly: a high-water mark is a quantity, so adding two is legal, unlike a
  price (above), whose sum is meaningless."*
- Listing line 238: `psHwm :: Qty`.
- §Why Three, managed account, lines 142–146: the high-water mark appears
  beside "accrued fee" and "entry NAV."
- §The Answer, line 83 (table) and line 136.

The defect. The document's central discriminator for `Price` (lines 190–193) is
that prices are *never added*, so `Price` is given a newtype with **no monoid,
no inverse** — addition is made unrepresentable precisely because it is
meaningless. The high-water mark is then handed the opposite type, `Qty` (a full
group), with the justification "a high-water mark is a quantity, so adding two
is legal."

But the document never states what the high-water mark is a quantity *of*. Every
place it grounds the concept points the other way: it is "written by the
valuation event" (line 136), it sits beside "entry NAV" and "accrued fee"
(lines 136, 142–146). A performance-fee / NAV high-water mark is a value-level —
price-like, not a share count. By the document's own Price reasoning, summing
such a thing is as meaningless as summing prices. So the reader is left with a
direct contradiction: the same paragraph that forbids `Price` from being summed
because the sum is meaningless permits `psHwm` to be summed, for a quantity whose
sum is — on the only semantics the document offers — equally meaningless.

The escape hatch the prose reaches for ("a non-conserved field ... with no
aggregate over holders claimed for it," line 232) makes it worse, not better:
"we never claim the aggregate" is a runtime-discipline argument, exactly the kind
of "writer trusted to behave" the document elsewhere refuses in favor of types.
If no meaningful aggregate exists, then by this document's stated standard the
type should forbid the aggregate — as `Price` does — rather than permit it and
ask the reader to trust that no one sums it. As written, `netBal` could be
`foldMap psHwm` and would typecheck and produce nonsense; that is the illegal
state the document claims to make unrepresentable.

A new reader will stop here and write commentary: "What does the high-water mark
measure? Why is it summable when a price isn't?" The document does not let them
answer it from the page.

Actionable fix — one of:
1. State the high-water mark's referent explicitly and show that addition is
   meaningful for it (i.e., that it genuinely is a count, not a value-level). If
   so, the `Qty` typing is justified and the contradiction with `Price`
   dissolves — but the grounding (currently NAV/fee-flavored) must be corrected
   to match.
2. If the high-water mark is a value-level (as the NAV/fee framing implies), give
   it a non-summable value newtype consistent with `Price`, and drop the
   "adding two is legal" claim. This restores the document's own discriminator.
3. If `psHwm` exists in this file *only* to exhibit a non-conserved field beside
   a conserved one and its real type is deferred with the valuation writer, say
   exactly that and stop asserting "a high-water mark is a quantity, adding is
   legal" — replace it with "its type is fixed by the valuation event, out of
   scope; here it is an opaque placeholder." Either commit to the type rationale
   or defer it; do not assert a rationale that fights the rest of the document.

This is not a style nit. The document's thesis is "illegal states are not
representable; distinguish the summable from the non-summable by type." `psHwm`
is the one field where that thesis is, by the document's own evidence, applied
backwards. It is the thing a maintainer trips over at 3am.

## Verdict

NOT-YET, on R1 alone. Everything else clears the bar; the conservation and
replay arguments are correct and the type construction is mostly exemplary. But
"obviously right, no overclaim" cannot survive a typed field whose stated type
rationale contradicts the document's own governing principle and whose referent
is never defined. Resolve R1 and this is APPROVE territory.
