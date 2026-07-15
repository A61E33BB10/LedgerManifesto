# karpathy — Round 2 review of FutureLifeCycle

Lens: each lifecycle step readable in one pass; linear flow; no leap of faith.

## Verdict

**CORRECT-AND-COMPLETE.**

## What I did

I did not trust the tables. I recomputed every figure from the two stated rules
(`ac += -Δ·p·m` for a trade leg; `VM = net·S·m + ac`, then `ac ← -net·S·m` for a settle,
with `m=50`) and checked all three conservation sums at each of the eight events. Every
number reproduces, and conservation of the conserved fields (`net_qty`, `ac`) holds at every
event; the variation-margin cash sum holds at every cash-bearing event.

| Event | net (A,B,C) | ac (A,B,C) | Σnet | Σac | ΣVM |
|---|---|---|---|---|---|
| Listing | (0,0,0) | (—,—,—) | vacuous | vacuous | vacuous |
| T1 @100 | (10,-10,0) | (-50000,+50000,0) | 0 | 0 | 0 |
| Settle d1 S=102 | (10,-10,0) | (-51000,+51000,0) | 0 | 0 | 0 |
| T2 @103 | (6,-10,4) | (-30400,+51000,-20600) | 0 | 0 | (no cash) |
| Settle d2 S=101 | (6,-10,4) | (-30300,+50500,-20200) | 0 | 0 | 0 |
| T3 @101 | (6,-6,0) | (-30300,+30300,0) | 0 | 0 | (no cash) |
| Expiry S=105 | (6,-6,0) | (-31500,+31500,0) | 0 | 0 | 0 |
| Close | (0,0,0) | (0,0,0) | 0 | 0 | 0 |

Closing identity confirmed: cumulative VM = (+2100, -1700, -400, CH 0), sum 0; each equals the
wallet's independently computed economic P&L. The day-2 anchor (A's VM = -100, not the naive
-300) is correct and its decomposition (+200 intraday gain offsetting -300 mark loss) is exact.

## The three anchor sub-questions — answered without evasion

1. *Is settlement a state update; which parts shared, which per-wallet?* Answered directly
   (§anchor item 1; answer.md SQ1). Shared = one `UnitStatus[u]` mark write; per-position =
   `ac` reset + cash leg fan-out over current holders. No hedging.
2. *One atomic event that fans out, or a derived consequence of the price?* Answered: one
   atomic fan-out, **forced by the cash leg**, not chosen for bookkeeping (§anchor item 2;
   answer.md SQ2 with the two forcing facts). The derived-consequence alternative is named and
   declined with reasons (E2), not waved away.
3. *Price only in shared state, consequence only in per-wallet state?* Answered yes, with the
   clean split: price in `UnitStatus[u]`, consequence (`ac` reset + VM cash) in
   `PositionState[w,u]` and the move stream (§anchor item 3; answer.md SQ3).

## Readability / no-leap-of-faith checks I ran, and passed

- **The "VM = -Δac" identity at Close.** A reader could fear a contradiction: at Close `Δac` is
  ±31500 but no cash moves, while the boxed settlement identity ties cash to `Δac`. This is
  **not** a leap, because the document established at T1 already that a trade changes `ac`
  (-50000) with zero cash — the identity is settlement-specific, and the precedent is set four
  events before Close. Close is structurally a closing trade at the final mark. Internally
  consistent; conservation (`Σnet=0, Σac=0, ΣVM=0`) holds.
- **CH leg = 0 at Close.** `Δnet(CH)=0` while prose says "returned to CH" reads loose at first,
  but the residual framing ("CH leg is the residual of holder legs — zero since they balance")
  is correct: A's +6 and B's -6 net directly, CH absorbs nothing. Reconciled in-text.
- **Type bridge.** The claim that `VM = net·S·m + ac` typechecks only because both summands are
  `Cash`, and that `Price` carries no addition (forbidding the naive `net·(S−S_prev)·m`),
  correctly turns the leaky shared-price shortcut into a compile error. Sound.
- **Idempotence / absorbing EXPIRED / vacuous settle over a flat holder.** Each verified:
  re-settle at same S gives `Δac=0, VM=0`; the rank guard plus explicit absorbing test on
  stage-writing deltas is justified (2<2 is false); a flat holder settles to no effect.

## Non-blocking observation (does not affect the verdict)

§2 promises that each event "shows the three conservation sums ΣΔnetq, ΣΔac, ΣVM," and T1 duly
shows ΣVM=0. The two later trades T2 (§6) and T3 (§8) show only ΣΔnetq and ΣΔac, omitting the
ΣVM=0 line. This is structurally vacuous (a trade carries no cash leg, so ΣVM is identically 0)
and is precedented by T1, so it blocks no understanding and is not a gap. If a future pass wants
the document to honor its own §2 promise verbatim, add "ΣVM = 0 (no cash leg)" to T2 and T3.

## Conclusion

Every figure independently reproduces; conservation is shown at every event; the three anchor
questions are answered plainly and the rejected alternative is recorded. The document reads
linearly, one delta per event, with the load-bearing subtlety isolated and demonstrated. It
passes my lens.
