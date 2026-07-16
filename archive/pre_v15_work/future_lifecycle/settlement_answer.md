# Settlement — the answer to the anchor question

Grounded in `SETTLEMENT_SEED.md`, addendum §4.1 (the futures test case), and the verified
`WORKED_EXAMPLE_FUTURE.md`. The reference is `FutureLifeCycle.hs`. Derive, then state; show
conservation; escalate the real tension.

## The mental model, in one line

Daily variation-margin settlement is a **hybrid event**: one atomic `StateDelta` that touches
both layers at once — a single shared price write on `UnitStatus`, and a per-holder fan-out that
resets each `accumulated_cost` and moves variation-margin cash. It is neither a pure shared-state
transition nor a derived consequence of the price. Presenting it as either would be false.

## Sub-question 1 — Is settlement a state update, and which parts are shared, which per-wallet?

Yes. `SettleVM` is one atomic `StateDelta` across the three maps (C3), in two parts:

- **Shared**, one value per contract — `UnitStatus[u]`: `last_settlement_price ← S`,
  `last_settlement_date ← d`. The **coarse stage rank** (`REGISTERED → ACTIVE → EXPIRED`) is
  unchanged at a settle — it advances only at expiry — while the **embedded settlement mark**
  updates every settle; `last_settlement_price` and `last_settlement_date` are projections of that
  mark, not independent fields.
- **Per-position**, one row per current holder — `PositionState[w,u]`: `accumulated_cost` reset to
  `−net_qty(w)·S·multiplier`, plus a variation-margin cash leg for that holder.

The shared part is one write. The per-position part is a fan-out over the current holders.

## Sub-question 2 — One atomic event that fans out, or a derived consequence of the price?

**One atomic event that fans out over the current holders.** Two facts force this form.

1. **The cash leg forces the fan-out.** Variation margin is real daily cash moving between longs
   and shorts through the clearinghouse. Every cash move is a recorded, conservation-bearing event
   (`Σ_w VM = 0` per settlement); it cannot be a lazy derivation, because money changes hands
   daily. A per-holder pass is therefore unavoidable regardless of how `accumulated_cost` is
   stored.
2. **`accumulated_cost` has a single canonical writer** (C11: `ac` → settle/trade; C12: per-wallet
   economic state lives in `PositionState`). The cash fan-out being already required, materialising
   the `ac` reset in the same atomic event is the consistent choice (C3 atomicity, C11 writer), and
   it measures the next period's profit and loss from `S`.

The handler fires over `holders_of(u)`. A contract with no open positions settles vacuously — the
empty sum is zero (C9) — the shared price still updates, no cash moves.

**Why `accumulated_cost` cannot be dropped (the load-bearing point).** Per-wallet `ac` is what
makes each holder's variation margin correct when that holder trades intraday. The shared-only
formula `VM(w) = net_qty(w)·(S − S_prev)·multiplier` is wrong for any wallet that traded since the
last settle. The correct figure is

    VM(w) = net_qty(w)·S·multiplier + ac(w),

where `ac(w)` has already absorbed the intraday trades (`ac += −Δsigned_qty·trade_price·multiplier`
on each leg). The worked example exhibits this on day 2: wallet A's variation margin is **−100**,
not the naive `6·(101−102)·50 = −300`, because A sold 4 contracts at 103 intraday — one point above
the prior mark 102 — gaining `4·(+1)·50 = +200`, which offsets the −300 mark loss. A price-derived
model cannot produce the correct per-wallet cash.

## Sub-question 3 — Price only in shared state, consequence only in per-wallet state?

Yes. `last_settlement_price` lives only in shared `UnitStatus[u]` — one value per contract. Its
economic consequence — the `accumulated_cost` reset and the variation-margin cash leg — lives only
in per-position `PositionState[w,u]` and the move stream. The price is shared; its consequence is
per-wallet. (`multiplier`, `currency`, `expiry`, `clearinghouse`, `exchange`, `product_id` are
immutable `ProductTerms`; the CME and ICE contracts are distinct units.)

## Conservation, shown — not asserted

At all times `Σ_w net_qty(w,u) = 0` (trades conserve the unit) and `Σ_w ac(w,u) = 0` (each trade's
two legs contribute `∓Δsigned·p·m`, cancelling). The settlement reset writes `Δac(w) = target − ac`
with `target = −net_qty·S·m`, and the cash leg is `VM(w) = −Δac(w) = net_qty·S·m + ac`. Therefore

    Σ_w VM = −Σ_w Δac,   and   Σ_w Δac = −S·m·Σ_w net_qty − Σ_w ac = 0 + 0 = 0,

so `Σ_w VM = 0` and post-reset `Σ_w ac = −S·m·Σ_w net_qty = 0`. Variation-margin zero-sum is the
same fact as `ac` conservation — structural, not a runtime reconciliation. The clearinghouse leg is
zero because the holder legs already sum to zero.

## Escalations — recorded, not buried

- **E1 — Fan-out cost at scale.** A settlement writes one `PositionState` row and emits one cash leg
  per open holder, every day. Across ~10^6 contracts each with up to thousands of holders, daily
  settlement is `O(open positions)` writes and cash legs — large daily fan-out and write
  amplification (the same key-space pressure as addendum risk F3). This is intrinsic to per-wallet
  variation margin, not an artefact of the model. Mitigations (batching the fan-out, snapshotting)
  trade against the conservation-per-event and single-writer disciplines. The cost stands; it is
  not smoothed over. **Return to:** the performance/risk agent — decide whether a batching or
  snapshot discipline is adopted, and prove it preserves C2 and C11.

- **E2 — The derived-consequence alternative, and why it is declined.** One could store only the
  shared `last_settlement_price` and compute each wallet's mark lazily, never materialising the `ac`
  reset. The design declines this. The reason is decisive: it saves nothing on the dominant cost
  (the cash leg is per-wallet and unavoidable, E1 and sub-question 2 item 1), it cannot produce the
  correct variation margin for intraday traders without reconstructing `ac` anyway, and it would
  split the single-writer discipline for `ac` (C11). The fan-out is forced by the cash, not chosen
  for the bookkeeping.

## Stage naming

The instrument is a **listed future** (exchange-traded). Its initial ledger lifecycle **stage** is
`REGISTERED` — a unit recorded in and known to the ledger before any settlement — not the
stage-name "Listed". Stages: `REGISTERED → ACTIVE → EXPIRED`.

## Event legality — boundary rules

A trade leg carries a strictly positive quantity `q > 0`, parsed at the boundary (`mkPosQty`);
`q ≤ 0` is rejected (`NonPositiveQty`) and never recorded. `q = 0` would promote `REGISTERED → ACTIVE`
and create `Some`-flat rows for two never-held wallets, collapsing the never-held/held-flat
distinction and silently activating a never-traded unit; `q < 0` would swap the buyer and seller
roles, violating the move primitive's positivity. The sign of the position change is supplied by the
leg — buyer `+q`, seller `−q` — not by `q`.

Settle and expire act only on an `ACTIVE` unit; both reject a `REGISTERED` (never-traded) unit
(`NotActive`), which has no holders and no mark slot to update. `EXPIRED` is reachable only from
`ACTIVE`, and is absorbing: trade, settle, and re-expire are rejected on it; only `Close` (no stage
write) remains. The lifecycle is the linear chain `REGISTERED → ACTIVE → EXPIRED` with no skips.
