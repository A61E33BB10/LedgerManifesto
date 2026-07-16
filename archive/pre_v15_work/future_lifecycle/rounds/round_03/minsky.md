# minsky — Round 3 review (FutureLifeCycle)

Lens: state types make illegal lifecycle states unrepresentable (incl. re-expiry);
never-held / held / flat distinction exact.

Verdict: **CORRECT-AND-COMPLETE**

---

## Prior gaps, now discharged

### G-minsky-1 (R2) — trade-quantity positivity — RESOLVED

The q=0 / q<0 hole that broke never-held/held-flat exactness is closed by a
parse boundary. `Trade` still carries a raw `Qty` in the alphabet, but `handle`
parses it once into the abstract `PosQty` (`FutureLifeCycle.hs:505-507`), whose
sole constructor `mkPosQty` returns `Nothing` for `n <= 0` (`:389-392`).
`tradeDelta` accepts only `PosQty` (`:400`), so `q <= 0` is unrepresentable
downstream — exactly the same boundary shape as conservation's `validate ->
ValidDelta`. `NonPositiveQty` is a first-class error (`:561`), tested for both
q=0 and q<0 in `main` (`:820-827`). The rule is now stated in prose in `.tex`
§"First trade" (the "Positive quantity" paragraph, lines 197-202) and in
`settlement_answer.md` ("Event legality — boundary rules"). With q>0 enforced, a
trade can no longer fabricate `Just zeroP` rows for never-held wallets, and the
"Nothing = never held" distinction this lens certifies is exact.

### G-minsky-2 (R2) — Expire/Settle asymmetry on REGISTERED — RESOLVED

The two events are now symmetric: `handle`'s `Expire` case rejects a
never-traded unit with `Registered -> Left (NotActive u)` (`:518`), mirroring
`SettleVM` (`:511`). `EXPIRED` is therefore reachable only from `ACTIVE`; the
lifecycle is the linear chain `REGISTERED -> ACTIVE -> EXPIRED` with no skips.
The decision is documented in `.tex` §invariants (lines 408-409: "both reject a
REGISTERED (never-traded) unit ... EXPIRED is reachable only from ACTIVE: the
chain is REGISTERED→ACTIVE→EXPIRED with no skips"), in `settlement_answer.md`
("both reject a REGISTERED ... with no skips"), and tested in `main` (`:816-819`).

### R1 gaps — confirmed still closed

- **Re-expiry / absorbing EXPIRED.** `isExpired` guards every stage-writing
  delta at both `handle` (`:504,:510,:517` G2) and `applyDelta` (`:592`); the
  rank guard is correctly noted as too weak (`2 < 2` is false). `Close` carries
  `sdStage = Nothing` (`:464`) and is the one delta admissible on EXPIRED.
- **Close divergence.** `Close` is now a real event (`:289`), `main` runs through
  it to `net=(0,0,0)/ac=(0,0,0)` (`:794-796`), and the `.tex` table line 140
  matches. Header claims no longer overclaim.
- **terms/status desync.** Fused into one `Map UnitId (ProductTerms, UnitStatus)`
  (`:547`); "u in terms <=> u in status" is now a type fact, and the lookups in
  `handle`/`applyDelta` are exhaustive on `Maybe (ProductTerms, UnitStatus)`.

---

## What holds under the lens (re-verified, not assumed)

**Status fuse is exact.** `Stage = Registered | Active (Maybe Settlement) |
Expired Settlement` (`:179-184`) makes `Registered`-with-price and
`Expired`-without-mark unspellable even against raw `StateDelta` construction
(constructors are exported). `settlement`, `settlementPrice`, `settlementDate`
are total over all three constructors with no wildcard (`:192-203`). The mark is
never wiped while Active: `activateTrade cur = Active (settlement cur)` (`:398`)
preserves any existing mark on a trade.

**never-held / held / flat is exact.** `position :: ... -> Maybe PositionState`
(`:634`). Rows are created only by `applyRow` (`:604-609`) over wallets present
in `sdRows`, which originate solely from `tradeDelta` (real buyer/seller, q>0),
`settlementFanout`, and `closeDelta` — the latter two iterating `holdersOf`
(existing rows only, `:641-642`). No phantom row can be minted for a non-holder;
C settles vacuously on day 1 with no row, then becomes `Just zeroP` (held-flat)
after going flat at T3, retained through Close by the monotone carrier (no
exported deleter; `Ledger` abstract). `Nothing` = never held, `Just zeroP` =
held-and-flat remain distinct and load-bearing.

**The three anchor sub-questions are answered without evasion**, consistently
across `settlement_answer.md` (§1-3) and `.tex` §anchor ("The three answers,
stated plainly"): (1) settlement is a state update split by layer — one shared
price write on `UnitStatus`, a per-holder fan-out on `PositionState`; (2) one
atomic event that fans out, not a derived consequence — the cash leg is real
daily money and forces the per-holder pass; (3) price only in shared state,
consequence only in per-wallet state. The day-2 anchor (A = −100, not the naive
−300) is exhibited in prose and in `main` (`naiveVM` shown for contrast only,
never used to move money, `:769-774`).

**Conservation shown at every event** (re-derived independently; all three sums
vanish at each step):

| Event | ΣΔnet | ΣΔac | ΣVM |
|-------|------|------|-----|
| Listing | empty sum (C9) | empty sum | empty sum |
| T1 (A buys 10/B@100) | +10−10=0 | −50000+50000=0 | — |
| Settle d1 (S=102) | 0 | (−51000+50000)+(51000−50000)=0 | +1000−1000=0 |
| T2 (C buys 4/A@103) | +4−4=0 | −20600+20600=0 | — |
| Settle d2 (S=101) | 0 | 0 | −100+500−400=0 |
| T3 (B buys 4/C@101) | +4−4=0 | −20200+20200=0 | — |
| Expiry (S=105) | 0 | 0 | +1200−1200=0 |
| Close | −6+6+0=0 | +31500−31500+0=0 | 0 |

`validate` discharges `netDelta sd == mempty` (a monoid identity) before any
application; `ValidDelta` is abstract so an unconserved delta cannot reach
`applyDelta`. The `VM = −Δac` identity makes VM zero-sum the *same* fact as ac
conservation. Closing identity ties cumVM to economic P&L per wallet (A=+2100,
B=−1700, C=−400, Σ=0); both columns re-checked arithmetically and agree.

---

## Note (not a gap)

`handle`'s `Close` case uses a wildcard — `Expired _ -> Right (closeDelta ...);
_ -> Left (NotExpired u)` (`:523-525`) — swallowing `Registered` and `Active`.
Both legitimately share the `NotExpired` outcome, so this is benign today, but
it is the one place a future `Stage` constructor would route silently. Every
other case analysis over `Stage` (`settlement`, `stageRank`, the `SettleVM`/
`Expire` arms) is explicit. Below my blocking threshold; recorded for the
record, consistent with the deliberately value-level transition-legality stance
honestly documented in signal E2 (`:661-670`).

---

## Why CORRECT-AND-COMPLETE

The two illegalities this lens must keep unrepresentable at the state level — the
status fuse's two impossible marks and the terms/status desync — are
unrepresentable. Re-expiry is exactly handled by the `isExpired` absorbing test
(the rank guard's `2 < 2` weakness is correctly diagnosed and covered). The
never-held / held / flat trichotomy is exact, and the last way to corrupt it (a
q=0 trade) is closed by the `PosQty` parse boundary. Both R2 gaps are resolved
and documented in all three artifacts; conservation is shown — not asserted — at
every event, and the three anchor sub-questions are answered without evasion.
Nothing remains open under this lens.
