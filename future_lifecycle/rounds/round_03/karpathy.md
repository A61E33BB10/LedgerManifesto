# KARPATHY — Round 3 review of the Future lifecycle

Lens: each lifecycle step readable in one pass; linear flow, top to bottom; no leap of
faith. Conservation shown at every event. The three anchor sub-questions answered without
evasion.

Verdict: **CORRECT-AND-COMPLETE**

## What I did — verified, did not trust

I recomputed the entire worked example from scratch (independent Python, not reading the
table back), applying only the two stated rules:

- trade leg: `ac += -Δsigned·p·m`
- settle: `VM(w) = netq·S·m + ac`, then `ac ← -netq·S·m`

Every figure in the §2 table reproduces to the integer:

| Event | netq (A,B,C) | ac (A,B,C) | VM (A,B,C) | ΣΔnetq | ΣΔac | ΣVM |
|---|---|---|---|---|---|---|
| T1 | (10,-10,0) | (-50000,+50000,0) | — | 0 | 0 | 0 |
| Settle d1 | (10,-10,0) | (-51000,+51000,0) | (+1000,-1000,0) | 0 | 0 | 0 |
| T2 | (6,-10,4) | (-30400,+51000,-20600) | — | 0 | 0 | 0 |
| Settle d2 | (6,-10,4) | (-30300,+50500,-20200) | (-100,+500,-400) | 0 | 0 | 0 |
| T3 | (6,-6,0) | (-30300,+30300,0) | — | 0 | 0 | 0 |
| Expiry | (6,-6,0) | (-31500,+31500,0) | (+1200,-1200,0) | 0 | 0 | 0 |
| Close | (0,0,0) | (0,0,0) | — | 0 | 0 | 0 |

Cumulative VM (A,B,C,CH) = (+2100,-1700,-400,0), sum 0; matches economic P&L computed
independently (A=+2100, B=-1700, C=-400). The closing identity holds by construction, not
assertion.

Conservation is shown — all three sums — at every one of the eight events, including the
vacuous Listing (empty sum, zero) and the all-zero Close. This satisfies the "conservation
at every event" bar without a single gap.

## The day-2 anchor passes the one-pass test

The load-bearing subtlety (§7) is the place a reader could lose the thread, and it is the
single best-written passage. A's VM is -100, not the naive `6·(101-102)·50 = -300`; the
+200 intraday gain (4 sold at 103, one point above mark 102) offsets the -300 mark loss.
I confirmed both numbers. The prose names exactly why per-position `ac` cannot be replaced
by a price-derived model. No leap: the counter-figure is given, not gestured at.

## The three anchor sub-questions — answered, not evaded

Both §7 ("The three answers, stated plainly") and `settlement_answer.md` answer all three
head-on:
1. Settlement is a state update; shared part = one `UnitStatus` mark write, per-position
   part = `ac` reset + cash leg fan-out. Split by layer, stated cleanly.
2. One atomic event that fans out — forced by the cash leg being real per-holder daily
   money, not chosen for bookkeeping. The derived-consequence alternative is named and
   declined (E2), with a reason that survives scrutiny.
3. Price only in shared state, consequence only in per-wallet state.

No hedging, no "it depends." The hybrid framing (neither pure-shared nor derived) is the
honest answer and is stated as such.

## The one place I expected a leap — and found none

My instinct flagged the Close: it changes `ac` by ±31500 with **zero** cash, which appears
to contradict the centerpiece settle identity "the cash leg is the mirror of the change in
accumulated cost." I chased this and it dissolves cleanly on two independent grounds, both
already present in the document:

1. `ac`-without-cash is not novel at Close — **every trade does it**. T1 moves `ac` by
   ±50000 with ΣVM=0; T2 and T3 likewise. The reader has seen this pattern three times
   before reaching Close. The `VM=-Δac` identity is explicitly scoped to the settlement
   section (§5), where `netq` is held fixed; Close, like a trade, is a different event.
2. The economic justification given ("cumulative variation margin already moved at the
   final settle") is exactly right and I verified it mechanically: the post-expiry residual
   mark value `netq·S·m + ac` is **0 for every holder** (A: 6·105·50-31500=0; B:
   -6·105·50+31500=0). There is no cash left to move because the position has zero
   remaining value. No leap of faith — the figure is zero by the prior reset.

So the apparent contradiction is a reader's expectation, not a defect, and the document
pre-empts it. I will not manufacture a gap here.

## Linear-flow and clarity checks

- Events are walked in occurrence order; the §2 table is the spine and each section walks
  one row. Top-to-bottom, no mental jumping.
- The EXPIRED-absorbing argument (§9) does not hand-wave the weak spot: it states outright
  that the rank guard fails for a second expiry (`2<2` is false) and adds an explicit
  absorbing test. That is the opposite of a leap — it names its own gap and closes it.
- The single-dimension bridge (`markValue : Qty→Price→Cash`, Price carries no addition) is
  motivated, not decreed; it makes `VM=netq·S·m+ac` typecheck for a stated reason.
- Why Close is a separate step from Expiry (rather than folded in) is justified: it is the
  polymorphic terminal — cash-flatten vs. delivery-versus-payment — "the variant differs
  only at the Close."

## Reference implementation

`FutureLifeCycle.hs` is present and its structure matches the prose exactly: `markValue`,
the settle fan-out with `deltaAc = -(markValue netq) - ac` (i.e. `VM = -Δac`), Close with
no stage write and no cash, the `isExpired` absorbing test, `NonPositiveQty` and
`NotActive` guards. GHC is not installed in this environment so I could not execute `main`;
I substituted an independent recomputation, which agrees to the integer. The document's
claim that the code computes these figures is consistent with the code I can read.

## Conclusion

Arithmetic exact, conservation shown at every event including the vacuous and terminal
ones, all three anchor questions answered without evasion, every step readable in one pass,
and the one candidate leap is pre-empted by the document itself. I find no located,
actionable gap. CORRECT-AND-COMPLETE.
