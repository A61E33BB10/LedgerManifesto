# DIRAC — Round 3 review

Lens: trade and settlement as two occupations of one event structure; notation minimal and
revealing.

Verdict: **CORRECT-AND-COMPLETE.**

## The one structure, re-confirmed

Every event — listing, trade, settle, close, expiry — is one atomic `StateDelta` =
(≤1 stage write; a map of per-holder `(Δnetq, Δac)`; a map of per-holder cash legs), applied
all-or-nothing through `validate`. Trade and settlement are not two mechanisms; they are the same
form evaluated at two prices:

- **Trade**: `Δnetq ≠ 0`, `Δac = −Δ·p·m` per leg, cash empty.
- **Settle**: `Δnetq = 0`, `ac ← −netq·S·m`, cash `VM = netq·S·m + ac`.

The field `ac` is the negative cost basis carried at the running mark; `VM` is the universal
`value − basis`. The §6 "load-bearing subtlety" (A's `−100`, not the naive `−300`) is a corollary
of this single identity, not an extra fact: with `ac = −netq·S_prev·m` and a trade of `Δ` at `p`,
the next settle yields `netq_old·(S−S_prev)·m + Δ·(S−p)·m` = `10·(101−102)·50 + (−4)·(101−103)·50
= −500 + 400 = −100`. The mathematics demands the strange-looking number; the document trusts it.

## The centrepiece identity holds

`VM(w) = −Δac(w)` ⇒ `Σ VM = −Σ Δac`. Variation-margin zero-sum and `ac` conservation are one fact,
not two reconciliations: `Σ Δac = −S·m·Σ Δnetq − Σ ac = 0`. The clearinghouse leg is the residual
of a set that already sums to zero — identically zero at every settle and at Close. CH is the hub
yet never moves net cash. Elegant and correct.

## Notation

Minimal and revealing. The single multiplication `markValue = netq·S·m : Cash` is the only place
`Qty` and `Price` meet; `Price` carrying no `<>` is precisely what makes `VM = netq·S·m + ac`
typecheck (both summands `Cash`). The `None` / `Some-flat` / `Some` trichotomy on a monotone
carrier with no deleter carries three distinct readings and no redundancy. The mark is fused onto
the stage (`Registered | Active (Maybe Settlement) | Expired Settlement`), making the two
unreachable states — never-traded-with-price, expired-without-mark — unspellable. Every symbol
earns its place.

## Conservation, shown at every event — independently re-derived

I reran the whole life by hand and against the expected figures embedded in `FutureLifeCycle.hs`
(lines 757–800), which match the prose line for line:

| Event | Σ Δnetq | Σ Δac | Σ VM |
|---|---|---|---|
| Listing | 0 (empty) | 0 (empty) | 0 (empty) |
| T1 | +10−10=0 | −50000+50000=0 | 0 (no leg) |
| Settle d1 | 0 | (−51000+50000)+(51000−50000)=0 | +1000−1000=0 |
| T2 | +4−4=0 | −20600+20600=0 | 0 (no leg) |
| Settle d2 | 0 | 0 | −100+500−400=0 |
| T3 | +4−4=0 | −20200+20200=0 | 0 (no leg) |
| Expiry | 0 | +31500−31500... reset, 0 | +1200−1200=0 |
| Close | −6+6+0=0 | +31500−31500+0=0 | 0 (no leg) |

Cumulative VM `(A,B,C) = (+2100, −1700, −400)`, sum 0, each equal to the wallet's independently
computed economic P&L (`§Closing identity`). All three sums appear explicitly at every non-vacuous
event; the vacuous case (Listing) is the empty sum. Re-settle at a fixed mark is idempotent
(`Δac=0`, `VM=0`); `EXPIRED` is absorbing with the `2<2` rank gap closed by an explicit test, and
`Close` (no stage write) is the one event still admissible afterward.

## The three anchors, answered without evasion

1. *State update; shared vs per-wallet* — yes: one shared mark write on `UnitStatus[u]`, a
   per-holder `ac` reset + cash fan-out on `PositionState[w,u]`, in one atomic delta. (§7 answer 1.)
2. *Atomic fan-out vs derived consequence of price* — atomic fan-out, forced by the cash (real
   daily money, conservation-bearing), with the `ac` reset riding the same delta under the single
   writer. The shared-only `netq·(S−S_prev)·m` formula is shown wrong for the intraday trader, with
   the worked number. No hedging. (§7 answer 2; settlement_answer §2 + load-bearing point.)
3. *Price only shared, consequence only per-wallet* — yes, with immutable terms correctly placed in
   `ProductTerms`. (§7 answer 3.)

## Round-2 observation, now resolved

In Round 2 I noted §2 promised "the three conservation sums" at every event but trade steps T2/T3
printed only two. This version states all three at T2 (line 258, "`ΣVM=0` (a trade moves no
variation-margin cash)") and T3 (line 315, "`ΣVM=0` (no cash leg)"). Closed. The physical-settlement
paragraph remains a sound one-paragraph Close-only variant; the cash-settled figures are correctly
unchanged.

## Assessment

The formalism is beautiful: no special cases that do not fall out of the general delta, minimal
notation doing real proof work, and the one prediction that looks wrong (`−100`) is the one the
equations force. Nothing left to add from this lens.
