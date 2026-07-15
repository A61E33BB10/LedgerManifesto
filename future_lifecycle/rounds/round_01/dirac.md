# DIRAC — Round 1 scorecard

Lens: trade and settlement as instances of one event structure where they are; notation
minimal and revealing.

Targets: `FutureLifeCycle.tex`, `settlement_answer.md`.

## Verdict: NOT-YET

One located, actionable gap. The substantive criteria — three anchor sub-questions
answered without evasion, conservation shown at every event — are met. Completeness fails
on a self-disclosed authority contradiction.

## What is beautiful and correct

- **One event structure.** Every step is one atomic `StateDelta` (shared stage write,
  per-holder (Δnetq, Δac), per-holder cash). Trade, settlement, expiry, and close are all
  instances. Close reduces to a trade against CH at the final mark
  (Δac(A) = −(−6)·105·50 = +31500 obeys the trade rule ac += −Δ·p·m). The unification is
  real, not decorative.
- **The hidden identity is named and trusted.** VM(w) = −Δac(w) = netq·S·m + ac, hence
  Σ VM = −Σ Δac. Variation-margin zero-sum *is* ac-conservation — the same fact, not a
  second reconciliation. This is the Dirac move: two things that look different shown to be
  one.
- **Notation carries dimension.** Price admits no addition; the sole multiplication
  netq·S·m : Cash makes VM = netq·S·m + ac typecheck only because both summands are Cash.
  Minimal and revealing.
- **Unspellable illegal states.** Stage = Registered | Active (Maybe Settlement) |
  Expired Settlement fuses the mark onto the stage; the two unreachable states cannot be
  written. Inevitable structure.

## Conservation, checked at every event (not taken on faith)

| Event | ΣΔnetq | ΣΔac | ΣVM |
|---|---|---|---|
| Listing | 0 (empty) | 0 (empty) | 0 |
| T1 | +10−10 = 0 | −50000+50000 = 0 | 0 |
| Settle d1 | 0 | (−51000+50000)+(51000−50000) = 0 | +1000−1000 = 0 |
| T2 | +4−4 = 0 | −20600+20600 = 0 | 0 |
| Settle d2 | 0 | 0 | −100+500−400 = 0 |
| T3 | +4−4 = 0 | −20200+20200 = 0 | 0 |
| Expiry | 0 | 0 | +1200−1200 = 0 |
| Close | −6+6 = 0 (CH net 0) | +31500−31500 = 0 | — |

Anchor subtlety verified: A's day-2 VM = −100, not the price-derived −300; the +200 from
the intraday 4@103 (one point over the prior mark 102) is exactly the difference. Per-wallet
stored ac is load-bearing — confirmed. P&L tie-out: (+2100, −1700, −400), Σ = 0, each equal
to the wallet's economic P&L. Cash ties to P&L by construction.

## The three anchor answers — assessed

1. *Settlement is a state update split by layer.* Answered. Shared write on UnitStatus +
   per-holder fan-out on PositionState, one atomic delta. No evasion.
2. *One atomic event that fans out, not a price-derived consequence.* Answered. The cash leg
   is real daily money and forces the per-holder pass; the ac reset rides the same delta.
   The "derived consequence" alternative is declined with reasons (E2). No evasion.
3. *Price only shared, consequence only per-wallet.* Answered. last_settlement_price on
   UnitStatus alone; ac reset + VM cash on PositionState + move stream alone. No evasion.

## Gap

**Authority contradiction: reference implementation vs. worked example at Close.**
The abstract (lines 19, 32–34) names `FutureLifeCycle.hs` the reference implementation and
claims the figures "reproduce WORKED_EXAMPLE_FUTURE.md exactly." The closing section
(lines 402–410) admits `FutureLifeCycle.hs` `main` stops at `Expire`, retaining
netq=(6,−6,0), ac=(−31500,+31500,0), and models neither the cash-settlement Close-to-zero
nor delivery. Two artifacts each claimed authoritative disagree on the final two rows. The
prose is, by its own statement, ahead of the reference.

This is not a flaw in the settlement answer — that is complete — but it blocks
CORRECT-AND-COMPLETE for the lifecycle deliverable: a document cannot be complete while its
normative source and its worked example contradict each other on the terminal state.

Actionable resolution (already scoped in the document, returned to the SME): either add a
`Close` event to `FutureLifeCycle.hs` (flatten-against-CH for cash, or a delivery-versus-
payment transaction), or remove the Close row from the worked example and reconcile the
abstract's "reference implementation" claim. Pick one authority; make the artifacts agree.
