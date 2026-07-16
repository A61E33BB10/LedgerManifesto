# Round 3 — chris-lattner

**Lens:** the lifecycle reads as one clean progression; nothing present that does not
serve it; artifacts agree.

**Verdict: CORRECT-AND-COMPLETE.**

## What I checked, and how

I re-derived the entire worked example from the two stated rules (trade
`ac += −Δnet·p·m`; settle `VM = net·S·m + ac`, `ac ← −net·S·m`) in an independent
script, ran it through Close, and compared every cell against both artifacts. Every
figure matches to the integer, and the three conservation sums (`ΣΔnet`, `ΣΔac`,
`ΣVM`) are zero at every one of the eight events:

| Event | net (A,B,C) | ac (A,B,C) | VM (A,B,C) | ΣΔnet / ΣΔac / ΣVM |
|---|---|---|---|---|
| Listing | (0,0,0) | (–,–,–) | – | 0/0/0 (empty sum, C9) |
| T1 | (10,−10,0) | (−50000,+50000,0) | – | 0/0/0 |
| Settle d1 | (10,−10,0) | (−51000,+51000,0) | (+1000,−1000,0) | 0/0/0 |
| T2 | (6,−10,4) | (−30400,+51000,−20600) | – | 0/0/0 |
| Settle d2 | (6,−10,4) | (−30300,+50500,−20200) | (−100,+500,−400) | 0/0/0 |
| T3 | (6,−6,0) | (−30300,+30300,0) | – | 0/0/0 |
| Expiry | (6,−6,0) | (−31500,+31500,0) | (+1200,−1200,0) | 0/0/0 |
| Close | (0,0,0) | (0,0,0) | – | 0/0/0 |

Cumulative VM `A=+2100, B=−1700, C=−400, sum 0` equals economic P&L computed
independently. "Cash ties to economic P&L by construction" is not asserted — it holds.

## The three anchor sub-questions — answered without evasion

1. **Is settlement a state update, which parts shared / per-wallet?** Yes. Shared: one
   write of the embedded mark on `UnitStatus[u]` (coarse rank unchanged). Per-wallet:
   the `ac` reset and the cash leg, fanned out over current holders on
   `PositionState[w,u]`. Stated identically in §anchor item 1 (tex) and sub-question 1
   (md).

2. **One atomic event that fans out, or a derived consequence of price?** One atomic
   event that fans out. The reason given is the right one and is not hedged: the cash
   leg is real daily money and is per-wallet, so the fan-out is forced by the cash, not
   chosen for the bookkeeping. A derived-price model cannot be a lazy consequence
   because money changes hands. tex §anchor item 2 / E2; md sub-question 2 / E2.

3. **Price only in shared state, consequence only in per-wallet state?** Yes. tex item
   3 and md sub-question 3 agree verbatim in substance.

The load-bearing subtlety carries the whole argument: A's day-2 VM is `−100`, not the
naive shared-price `6·(101−102)·50 = −300`, because the intraday sale of 4 @103 booked
`+200` into `ac` against the prior mark 102. I verified the decomposition
(`+200` realized − `300` mark = `−100`). This is the correct justification for `ac`
being per-position stored state rather than read off the shared price, and it is the
thing a weaker treatment would get wrong.

## Architecture observations (why this is right, in my terms)

- **The dimension bridge is doing real work.** `Price` carrying no addition, with the
  single `markValue` multiplication into `Cash`, makes `VM = net·S·m + ac` typecheck
  only because both summands are `Cash`. This is types-as-documentation eliminating a
  whole class of unit-confusion bugs by construction, not by review. Good.
- **Conservation is structural, not a runtime check.** `ΣVM = −ΣΔac` makes
  variation-margin zero-sum the *same fact* as `ac` conservation. The proof in the md
  (`ΣΔac = −S·m·Σnet − Σac = 0`) is clean. One invariant, one writer, one delta —
  this is the modular, all-or-nothing discipline (C3) that lets replay be a fold.
- **The CH leg is the residual and is zero throughout.** I confirmed this is correct,
  not a hole: in a balanced book longs = shorts, so the holder legs already sum to
  zero and CH never materialises a row. The clearinghouse is present as the
  counterparty model and the Close sink; its deltas being zero is a consequence, not an
  omission.
- **Close is a trade-to-flat at the final mark.** I verified that `Δac(A)=+31500`
  with no cash leg is exactly a trade at price 105 (`−Δnet·105·m`), which yields
  `VM=0` because post-expiry `ac = −net·105·m` already. This is internally consistent
  and explains "no further cash" precisely.

## Non-blocking notes (do not block the verdict; worth a line if a revision occurs)

- **Citation density differs, substance does not.** The md cites `C12`
  ("per-wallet economic state lives in PositionState") which the tex folds into `C11`.
  No contradiction; the artifacts agree on every number, formula, stage model, and
  answer. Flagging only because my lens is artifact agreement and this is the single
  label mismatch I found.
- **Close legality outside EXPIRED is described, not guarded.** The tex says Close is
  "still admissible on an EXPIRED unit" and frames it as terminal, but states no
  guard forbidding Close on an ACTIVE unit. Pre-expiry flattening is already handled by
  trade-to-flat (T3 flattens C), so a stray Close path would be redundant. The
  presented linear progression is unaffected; an explicit "Close requires EXPIRED" (or
  an explicit statement that Close is just trade-to-flat at the mark and needs no
  separate guard) would close the edge. Edge only — not a gap in the lifecycle as
  shown.

## Conclusion

The lifecycle reads as one clean progression, every section serves it, the two
artifacts agree on all load-bearing content, the three anchor sub-questions are
answered directly, and conservation is shown — and independently reproduces — at every
event. CORRECT-AND-COMPLETE.
