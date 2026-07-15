# MILEWSKI — FutureLifeCycle, Round 3

**Verdict: CORRECT-AND-COMPLETE.**

Lens: Haskell builds step by step; settlement and Close handlers faithful, total,
conserving; Expired terminal; flag anything awkward.

This round I re-verified only what changed since R2 (trade positivity, the
Expire-on-Registered reversal) and re-walked the whole life for conservation. The
two non-blocking observations I raised in R2 are addressed below.

## The two R2 observations, both resolved

### (a) Expire on a never-traded unit — now rejected, symmetrically
In R2 I noted `Expire` fell through to `_` and admitted `Registered → Expired` with
an empty fan-out, asymmetric with `SettleVM`'s `NotActive` rejection. R3 fixes this:
`handle`'s `Expire` case now matches `Registered → Left (NotActive u)` (FutureLifeCycle.hs
lines 516–521), the same G4 ground as settle (no position, no mark slot, no economic
content to a fabricated final mark). This is the right resolution, and it *buys a
stronger invariant*: `EXPIRED` is now reachable only from `ACTIVE`, so the lifecycle
is the linear chain `REGISTERED → ACTIVE → EXPIRED` with no skips. Documented in the
`.tex` invariants section (lines 408–409) and settlement_answer.md (lines 112–115).
Both the `Expire`-before-trade and `SettleVM`-before-trade rejections are now demoed
in `main` (lines 812–819). Coherent across all three files.

### (b) Trade-quantity positivity — now a parse boundary (Minsky G5)
The Trade leg carried a raw `Qty`, so `q = 0` would promote `REGISTERED → ACTIVE` and
fabricate `Just zeroP` rows for two never-held wallets — collapsing the very
never-held/held-flat distinction `position` certifies — and `q < 0` would conserve
while swapping buyer/seller roles. R3 resolves this with parse-don't-validate:
`newtype PosQty` is abstract (export list line 33 exposes `PosQty, mkPosQty, unPosQty`
but **not** the constructor, so the positive cone cannot be re-entered with a bad
value), `mkPosQty :: Qty -> Maybe PosQty` is the sole gate (`n > 0`), the `Event`
alphabet still carries a raw `Qty` (lines 286 — the free-monoid alphabet stays total,
so deserialised streams remain total), `handle` parses once (lines 505–507 →
`Left (NonPositiveQty u q)` on `Nothing`), and `tradeDelta` accepts only `PosQty`
(line 400). This is exactly the same boundary shape as conservation
(`StateDelta → ValidDelta`): the untrusted edge is `handle`, and `q ≤ 0` is
unrepresentable downstream of it. The choice to keep `Qty` in the event rather than
push `PosQty` into the alphabet is the correct one — it keeps the log alphabet total
and locates the single trusted boundary at `handle`, mirroring `validate`. Both
rejections are demoed in `main` (lines 820–827). This is the right structure.

## The three anchor sub-questions — answered without evasion

Stated plainly in `.tex` §8 ("The three answers, stated plainly", lines 287–303) and
settlement_answer.md §1–3:

1. *Settlement is a state update split by layer.* Shared one-write on `UnitStatus`
   (the embedded mark; coarse rank `REGISTERED<ACTIVE<EXPIRED` unchanged at a settle),
   per-holder fan-out on `PositionState` (`ac` reset + cash leg). `handle`'s `SettleVM`
   case builds exactly one `StateDelta` (lines 509–514).
2. *One atomic event that fans out, not a price-derived consequence.* Forced by the
   cash leg — real daily money, conservation-bearing — plus the single-writer
   discipline for `ac`. The load-bearing subtlety (A's day-2 VM = −100, not the naive
   −300) is exhibited; `naiveVM` is carried purely for contrast and never moves money
   (lines 727–728, 773–774).
3. *Price only in shared state, consequence only in per-wallet state.*
   `last_settlement_*` are projections of the `Settlement` on the stage
   (`settlementPrice`/`settlementDate`, lines 199–203); the `ac` reset and VM cash
   live in `PositionState` and the move stream.

No evasion; the answer commits to "hybrid event" and proves both halves.

## Conservation shown — not asserted — at every event

I re-derived the full life independently. All three sums are zero at every step, and
each is now stated in the `.tex` prose (the R3 fix closing the ΣVM-at-trade omission):

| Event | Σ Δnet | Σ Δac | Σ VM |
|---|---|---|---|
| Listing | 0 (empty, C9) | 0 (empty) | 0 (empty) |
| T1 | +10−10 = 0 | −50000+50000 = 0 | — (no cash) |
| Settle d1 (S=102) | 0 | (−51000+50000)+(51000−50000) = 0 | +1000−1000 = 0 |
| T2 | +4−4 = 0 | −20600+20600 = 0 | — (no cash) |
| Settle d2 (S=101) | 0 | 0 | −100+500−400 = 0 |
| T3 | +4−4 = 0 | −20200+20200 = 0 | — (no cash) |
| Expiry (S=105) | 0 | 0 | +1200−1200 = 0 |
| Close | −6+6+0 = 0 | +31500−31500+0 = 0 | 0 (no cash) |

The centrepiece identity `VM = −Δac = net·S·m + ac` makes VM zero-sum the *same* fact
as `ac` conservation (`settlementFanout` emits the cash leg as `cashNeg (deltaAc)`,
lines 448–453), so it is surfaced, not re-reconciled. `validate` still checks both
columns: for a `Trade` they are independent (Δac ≠ 0 with empty cash), so the cash
check is non-redundant in general — correct. The `.hs` `report` asserts all three
sums (`assertZeroQty`/`assertZero`) after every event, and the final `replay` block
confirms the three sums are zero on the independently-folded stream (lines 837–849).

## Settlement and Close handlers — faithful, total, conserving

- `settlementFanout` (lines 445–453): `target = −net·S·m`, `Δac = target − ac`,
  `VM = −Δac`. I checked the arithmetic for d1, d2, and Expiry against the worked
  example (A −100 on d2 reproduced from the stored `ac`, not from the price delta). A
  flat holder gives Δac = 0, VM = 0 — its retained row is touched to no effect. The
  zero-holder case is the empty `foldMap`, i.e. `mempty` (C9). The handler **sums**
  deltas and never divides by a holder count, so the apportionment bug class cannot
  arise.
- `closeDelta` (lines 458–465): additive negation per row (Δnet = −net, Δac = −ac),
  no cash, `sdStage = Nothing`. Conserves because it negates two columns already
  summing to zero. Rows retained at zero (monotone carrier; no PS/cash deleter
  exported). A second Close is a harmless no-op (all rows already flat). Correct.
- Both are pure functions of `(event, ledger)` reading current holders — state-
  dependent, not impure; determinism preserved. `holdersOf` draws from `Map.toList`
  and the result is an order-independent `Map`, so replay is stable.

## Expired is genuinely terminal — defended at two boundaries

- `handle` rejects `Trade`/`SettleVM`/`Expire` on an `Expired` unit (`UnitExpired`,
  G2); `Close` is the one admissible event (`sdStage = Nothing`).
- `applyDelta` independently rejects *any* stage-writing delta when `isExpired cur`
  (line 592). This is the precise rule: `stageRank` alone is too weak because
  `Expired(105)` and `Expired(110)` share rank 2, so a strict `new < cur` guard would
  re-admit a second Expire — the author correctly uses the explicit `isExpired` test.
  `activateTrade (Expired s) = Active (Just s)` would attempt an `Expired → Active`
  downgrade; the absorbing guard blocks it before application. Right structure.

## Totality / determinism

Every handler and ledger operation is total over its domain — all `Map` ops total,
`foldM` total, every `case` exhaustive, `mkPosQty` total (Maybe), `PosQty` abstract.
`replay = foldM (flip step)` satisfies the Kleisli homomorphism
`replay (xs <> ys) = replay xs >=> replay ys`, so checkpoint independence is a
consequence of the law, not a test. No partiality, no non-determinism enters.

## Non-blocking, carried forward (not a gap)

- **Cash as `Map WalletId Cash`, no materialised CH row.** Faithful within the
  cash-settled scope because the holder legs sum to zero, so the CH residual is zero.
  Signal E1 already names the fully faithful encoding — cash as a first-class unit
  keyed `(wallet, cashUnit)` with a CH counterparty leg, the future delta being one
  per-unit slice of a multi-unit atomic event (the same cross-unit point as
  StatesHome S1). This is a correctly-signalled design deferral for the design agent,
  not a correctness defect of this reference.

## Minor diagnostic ordering (cosmetic, no action)

In `handle`'s Trade case the guards order self-trade, then `isExpired`, then
`mkPosQty`, so a self-trade or zero-qty trade on an expired unit reports
`SelfTrade`/`NonPositiveQty` rather than `UnitExpired`. All are `Left`; only the
diagnostic differs. No correctness consequence.

## Disposition

The Haskell builds step by step with each abstraction introduced where it is forced;
the settlement and Close handlers are faithful, total, and conserving; `EXPIRED` is
absorbing at both boundaries and now reachable only from `ACTIVE`; trade positivity
is a clean parse boundary that removes the never-held/held-flat collapse and the
role-swap; the three anchor sub-questions are answered directly; and conservation is
demonstrated — not asserted — at every event, with all three sums now in the prose.
Both R2 observations are resolved. I find no correctness, totality, or determinism
gap.
