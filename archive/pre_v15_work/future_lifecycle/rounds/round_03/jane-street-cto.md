# Round 3 review — jane-street-cto

Lens: clear in six months to someone new; the settlement answer unambiguous, not evasive;
artifacts consistent.

Artifacts reviewed:
- `/home/renaud/Ledger/future_lifecycle/FutureLifeCycle.tex`
- `/home/renaud/Ledger/future_lifecycle/settlement_answer.md`

## Verdict: CORRECT-AND-COMPLETE

## What I verified, not took on faith

I recomputed the entire worked example from the primitives (m=50) and checked all three
conservation sums (ΣΔnet_qty, ΣΔac, ΣVM) at every one of the eight events.

| Event | net_qty (A,B,C) | ac (A,B,C) | VM (A,B,C) | ΣΔnetq | ΣΔac | ΣVM |
|---|---|---|---|---|---|---|
| Listing | (0,0,0) | (−,−,−) | — | 0 (vacuous) | 0 | 0 |
| T1 buy 10@100 | (10,−10,0) | (−50000,+50000,0) | — | 0 | 0 | 0 |
| Settle d1 @102 | (10,−10,0) | (−51000,+51000,0) | (+1000,−1000,0) | 0 | 0 | 0 |
| T2 C buys 4@103 | (6,−10,4) | (−30400,+51000,−20600) | — | 0 | 0 | 0 |
| Settle d2 @101 | (6,−10,4) | (−30300,+50500,−20200) | (−100,+500,−400) | 0 | 0 | 0 |
| T3 B buys 4@101 | (6,−6,0) | (−30300,+30300,0) | — | 0 | 0 | 0 |
| Expiry @105 | (6,−6,0) | (−31500,+31500,0) | (+1200,−1200,0) | 0 | 0 | 0 |
| Close | (0,0,0) | (0,0,0) | — | 0 | 0 | 0 |

Every figure reproduces. Conservation holds at every event, including the vacuous Listing
(empty sum, C9) and the day-1 settle where C has no row.

The load-bearing anchor checks out: A's day-2 VM is −100, not the price-derived −300. I
confirmed the decomposition — A's 4 sold at 103 (one point above mark 102) gain
4·(+1)·50=+200, offsetting the −300 mark loss on the held 6. The daily VM equals true daily
P&L only because `ac` is per-wallet stored state. This is the correct justification for C11,
and it is the crux of why the derived-consequence alternative (E2) fails.

Closing identity verified independently: cumulative VM (A=+2100, B=−1700, C=−400, CH=0,
Σ=0) equals economic P&L computed from trade prices. Cash ties to P&L by construction.

I also checked the Close arithmetic that a careful reader will question: zeroing `ac` with no
cash leg. After the final settle, ac(w) = −net_qty·S_final·m, so the position's net value
(markValue + ac = net_qty·105·50 + ac) is exactly zero at the final mark — extinguishing it
for zero cash is correct, and zeroing `ac` enforces the clean invariant that every flat row
carries ac=0. Consistent with C going flat at T3 (where it landed at ac=0 because the trade
price equaled the last mark).

## The three anchor sub-questions — answered, not evaded

1. State update, parts split by layer: shared mark on UnitStatus (one write), per-position
   ac reset + cash leg on PositionState (fan-out). Direct "Yes."
2. Atomic event that fans out, not a derived consequence: committed plainly, with the cash
   leg named as the forcing reason. No hedging.
3. Price only in shared state, consequence only in per-wallet state: direct "Yes."

The `.tex` §7 "three answers, stated plainly" and the `.md` sub-question sections agree word
for word in substance. Neither document softens or splits the difference.

## Artifact consistency

The two documents agree on: the trade rule (ac += −Δ·p·m), the settlement identity
(VM = net_qty·S·m + ac = −Δac), the reset target (−net_qty·S·m), the stage algebra
(Registered | Active (Maybe Settlement) | Expired Settlement, with last_settlement_price/date
as projections), the boundary rules (mkPosQty, q>0), the absorbing/monotone stage discipline,
and both escalations E1/E2 including owner routing. No contradictions found.

## Non-blocking observations (do not affect verdict)

- `.tex` line 63: `\label{sec:answer-recalled}` is a dangling label — it sits after a
  `center`/`tabular`, not after a sectioning command or float caption. The reference at line
  50, "(addendum §\ref{sec:answer-recalled})", will therefore resolve to the current section
  number (§1, a self-reference) rather than to the external addendum §4.1. The word
  "addendum" disambiguates intent, so meaning survives, but the rendered cross-reference is
  wrong. Cosmetic; fix by removing the `\ref` and writing the addendum section literally, or
  by anchoring the label to a real target.
- `.tex` §9 Close: the prose "returns the contracts to CH" sits next to Δnet_qty(CH)=0.
  This is correct (A's −6 and B's +6 annihilate through CH as residual, consistent with the
  cash-residual framing used throughout), but a new reader may pause. The residual sentence
  immediately following resolves it. No change required.

Neither observation touches correctness, conservation, or the anchor answers.
