# Verified worked example — listed future lifecycle (conservation-checked)

One cash-settled listed future `u_F`, `multiplier = 50`. Wallets A, B, C (traders) and the
clearinghouse virtual wallet CH (the variation-margin hub and central counterparty). Rules:
- trade of signed-quantity change `Δ` at price `p`: `ac += −Δ · p · multiplier` (each leg);
- settlement at price `S`: `VM(w) = net_qty(w)·S·multiplier + ac(w)` (cash, routed through CH);
  then `ac(w) ← −net_qty(w)·S·multiplier`.

All figures verified by a decimal check: `Σ_w net_qty = 0`, `Σ_w ac = 0`, and `Σ_w VM = 0` after
**every** step.

Scale: prices are whole index points and cash is whole USD for readability (so `markValue(10,102,50)
= 51000` is $51,000, not 51000 cents). Price and cash share one fixed minor-unit scale; a production
scale carries price in scaled minor units (a quarter-point for ES, a cent for a bond in 32nds) so
sub-point ticks are exact. The arithmetic is integer and never divides, so conservation is exact at
any scale.

| Step | Event | net_qty (A,B,C) | accumulated_cost (A,B,C) | VM cash (A,B,C) |
|---|---|---|---|---|
| Listing | `u_F` registered; `UnitStatus`: stage `REGISTERED`, no settle price; no position rows | (0,0,0) | (—,—,—) | — |
| T1 | A buys 10 from B @100 | (10, −10, 0) | (−50000, +50000, 0) | — |
| Settle d1 | `S₁=102`; shared price ← 102 | (10, −10, 0) | (−51000, +51000, 0) | (+1000, −1000, 0) |
| T2 | C buys 4 from A @103 | (6, −10, 4) | (−30400, +51000, −20600) | — |
| Settle d2 | `S₂=101`; shared price ← 101 | (6, −10, 4) | (−30300, +50500, −20200) | (−100, +500, −400) |
| T3 | B buys 4 from C @101 (C → flat) | (6, −6, 0) | (−30300, +30300, 0) | — |
| Expiry | stage → `EXPIRED`; final `S=105` | (6, −6, 0) | (−31500, +31500, 0) | (+1200, −1200, 0) |
| Close | units returned to CH; positions → 0 | (0, 0, 0) | (0, 0, 0) | — |

**The load-bearing subtlety (day 2).** A's day-2 VM is **−100**, not the naive
`net_qty·(S₂−S₁)·m = 6·(101−102)·50 = −300`. A sold 4 @103 intraday (one point above the prior mark
102), gaining `4·(+1)·50 = +200`, which offsets the `−300` mark loss on the held position. Only the
stored per-wallet `accumulated_cost` (which absorbed the intraday trade) yields the correct `−100`.
A shared, price-derived-only model gives the wrong cash. This is why `accumulated_cost` is
per-position stored state, not a derived consequence of the shared price.

**Closing identity (cash ties to economic PnL).** Total VM cash per wallet:
A `= +1000 −100 +1200 = +2100`; B `= −1000 +500 −1200 = −1700`; C `= −400`; CH `= 0`. Sum `= 0`.
Each equals the wallet's economic PnL: A `4·(103−100)·50 + 6·(105−100)·50 = +2100`; B (short)
`4·(100−101)·50 + 6·(100−105)·50 = −1700`; C `4·(101−103)·50 = −400`. ✓

**Retention.** After T3, C's row is kept at `(qty 0, ac 0)` — `Some(zero)`, not deleted (monotone
carrier). After expiry, all rows are retained at zero; `UnitStatus` holds stage `EXPIRED` and last
price 105; `ProductTerms` is immutable; `first_touch_date` is **derived from the event log**, not
stored.
