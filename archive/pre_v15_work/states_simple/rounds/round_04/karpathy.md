# Round 4 — karpathy review of states_simple/States.tex

## Verdict: NOT-YET

The construction half is genuinely obvious — built from scratch, one piece at a
time, each forced by the one before, verified at the end. Qty-as-group →
balance-as-transfer → status → terms → position → ledger → writers →
conservation → replay reads in a single pass with no leap. The conservation
induction (sole writer of `psBal`, cancelling legs, base case `emptyLedger`,
sealed constructor) and the replay/checkpoint argument (pure total `apply`,
`foldM` left-fold law) each close cleanly. I have no quarrel with The
Construction or Why It Is Right.

My quarrel is with the foundation the taxonomy stands on. The answer is "three
homes," and that count is only as solid as the partition that produces it. The
partition is asserted, not derived, at the exact point a first-time reader most
needs it derived.

## Residue (located, actionable)

### 1. The root dichotomy is asserted, not grounded — §The Answer, first sentence

> "A fact depends either on the unit alone or on a (holder, unit) pair."

This is the load-bearing claim of the whole document — the three homes are the
three occupied cells of a 2×2 whose first axis *is* this dichotomy — and it
arrives as a flat "either/or." A competent post-trade engineer reading this once
stops here, because the obvious objection is in their working memory: where does
a fact keyed by **more than one unit** live? Netting sets, portfolio/cross
margin, cross-currency offset — these are everyday post-trade objects that key on
a *set* of holdings, neither "the unit alone" nor a single "(holder, unit)
pair." The dichotomy silently excludes them and never says why.

The document *has* the resolution but never assembles it at the point of the
claim: a multi-instrument relationship is reified as its own unit (the strategy
contract, the mandate), and the holder's state under it is then an ordinary
(holder, that-unit) position — this is exactly the managed-account move in §Why
Three. So the true reason the dichotomy is exhaustive is twofold: (a) the
question is scoped to *one unit's* state, so the only variables in view are the
unit and a holder of it; and (b) any relationship spanning instruments is itself
made a unit, collapsing back into case (a). Neither (a) nor (b) is stated where
the dichotomy is introduced. The reader must reconstruct both, which is a
backtrack, or accept the dichotomy on faith, which is the leap the bar forbids.

Action: at the first sentence of §The Answer, ground the "either/or" — one
clause scoping to a single unit's state (excluding holder-alone and excluding
cross-unit keys from the frame), and one clause stating that cross-unit
relationships are reified as units (forward-pointing to the mandate/strategy
treatment). Then the 2×2 is forced rather than posited.

### 2. The "No fourth home" paragraph closes only half the exclusion — §The Answer

The paragraph "No fourth home holds economic state…" rigorously rules out the
**wallet-alone** key (KYC, permissions, audit cursor are identity, not economic
state). Good — but that is the *other* missing case, not the multi-unit one. As
written it reads as if it discharges the completeness of the partition, when it
only discharges one of the two excluded keyings. After fixing (1) this paragraph
should explicitly note it is closing the holder-alone case, so the reader sees
both exclusions accounted for rather than mistaking one for the whole.

## Non-blocking

- §The Answer frames authorship as "Unit-keyed state divides *again* by
  authorship" (a hierarchical, key-first split) and three sentences later treats
  it as a full 2×2 in which the (holder, unit) row also carries an authorship
  axis (the empty "fourth cell"). The reader builds a tree, then must flatten it
  to a grid to place the empty cell. Minor revision of the mental model on one
  pass; not disqualifying on its own, but worth smoothing once (1) is in.
- The terms/status split being "by provenance, not necessity" is honestly
  disclosed and adequately argued (authorship → write-shape → boundary
  auditability). I do not count it as residue; the honesty is what makes it
  pass.
