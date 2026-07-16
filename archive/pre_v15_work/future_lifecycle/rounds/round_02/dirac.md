# DIRAC — Round 2 review

Lens: trade and settlement as instances of one event structure; notation minimal and revealing.
Verdict: **CORRECT-AND-COMPLETE.**

## The unity, found and confirmed

Both documents reduce every event — listing, trade, settle, close, expiry — to a single object:
one atomic `StateDelta` = (≤1 stage write; a map of per-holder `(Δnetq, Δac)`; a map of per-holder
cash legs), applied all-or-nothing through `validate`. Trade and settlement are then not two
mechanisms but two *occupations* of the same form:

- **Trade**: `Δnetq ≠ 0`, `Δac = −Δ·p·m` per leg, cash empty.
- **Settle**: `Δnetq = 0`, `ac ← −netq·S·m`, cash `VM = netq·S·m + ac`.

This is the right unification, and it is inevitable rather than imposed. I checked the deeper
identity the documents only gesture at: with `ac` carrying `−netq·S_prev·m` from the last mark and a
trade of `Δ` at `p` writing `ac += −Δ·p·m`, the next settle yields

    VM(w) = netq_new·S·m + ac_new = netq_old·(S − S_prev)·m + Δ·(S − p)·m.

Mark gain on the held position plus mark gain on the freshly traded lot, from its own entry price.
That is exactly the day-2 anchor: `10·(101−102)·50 + (−4)·(101−103)·50 = −500 + 400 = −100`. The
field `ac` *is* the negative cost basis at the running marks, and `VM` is the universal `value −
basis`. Trade and settlement are the same equation evaluated at two prices. Beautiful, and load-
bearing — the §6 "subtlety" is a corollary of this single identity, not a separate fact.

## The centrepiece identity

`VM(w) = −Δac(w)` ⇒ `Σ VM = −Σ Δac`. Variation-margin zero-sum and `ac` conservation are one fact,
not two reconciliations. This is the strongest structural claim in the document and it holds:
`Σ Δac = −S·m·Σ Δnetq − Σ ac = 0`. The clearinghouse leg is the residual of a set that already sums
to zero, hence identically zero at every settle and at Close — CH is the hub yet never moves net
cash. Correct and elegant.

## Notation

Minimal and revealing. The single multiplication `markValue = netq·S·m : Cash` is the only place
`Qty` and `Price` meet, and `Price` carrying no addition is what makes `VM = netq·S·m + ac`
typecheck — both summands `Cash`. The type discipline does real proof work, not decoration. The
`Some`/`Some-flat`/`None` trichotomy on `PositionState` carries three distinct readings on a monotone
carrier with no deleter. Nothing is redundant; every symbol earns its place.

## Conservation, independently verified

I reran the whole life. Every event: `Σ Δnetq = 0`, `Σ Δac = 0`, `Σ VM = 0`. Cumulative VM per
wallet `(A,B,C) = (+2100, −1700, −400)`, summing to zero, and each equals the wallet's economic P&L
computed independently. Listing is vacuous (empty sum). Re-settle at a fixed mark is idempotent
(`Δac = 0`, `VM = 0`). `EXPIRED` is absorbing with the `2 < 2` gap closed by an explicit test, and
`Close` (no stage write) is the one event still admissible afterward — clean.

## The three anchors, answered without evasion

1. *State update; shared vs per-wallet* — yes: one shared mark write on `UnitStatus`, a per-holder
   `ac` reset + cash fan-out on `PositionState`, in one delta. Stated plainly.
2. *Atomic fan-out vs derived consequence of price* — atomic fan-out, forced by the cash (real daily
   money, conservation-bearing), with the `ac` reset riding the same delta under the single writer.
   The shared-only `net_qty·(S−S_prev)·m` formula is shown wrong for the intraday trader. No hedging.
3. *Price only shared, consequence only per-wallet* — yes, with the immutable terms correctly placed
   in `ProductTerms`. Direct.

## Minor observations (non-blocking)

- §2 promises "each shows the three conservation sums `ΣΔnetq, ΣΔac, ΣVM`," but the trade steps T2
  and T3 print only the first two. For a trade the cash set is empty, so `ΣVM = 0` is vacuous and is
  established generically at T1 ("entering a futures position pays no notional"). Conservation of the
  non-vacuous fields is shown at every event; the omission is presentational, not a hole. Tightening
  would be a one-clause addition ("no cash legs, `ΣVM = 0`") at T2/T3.
- Physical settlement is treated in one paragraph as a Close-only variant. The claim that the
  figures are unchanged is correct: daily VM has already paid the price path, so a final delivery
  invoice at the settlement price nets each wallet to its entry price — no double count. Brief but
  sound; appropriate given the worked example is cash-settled.

Neither observation touches correctness or the anchors. The formalism is consistent, minimal, and
its strange-looking prediction (A's `−100`, not `−300`) is the one the mathematics demands.
