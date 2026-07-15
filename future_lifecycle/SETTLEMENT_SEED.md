# Settlement answer — grounded seed for the anchor question

This is the settled answer the group converges on, grounded in addendum §4.1 (the futures test
case) and the event-handler model. It fixes the mental model `FutureLifeCycle.tex` uses and the
content of `settlement_answer.md`. Derive, do not assert; state the model plainly; escalate the
real tension rather than smoothing it.

## The mental model, in one line
**Daily variation-margin settlement is a hybrid event that necessarily touches both layers in one
atomic `StateDelta`: a single shared price update on `UnitStatus`, plus a per-holder fan-out that
resets each `accumulated_cost` and moves variation-margin cash.** It is *not* purely a shared
state transition, and presenting it as such to look tidy would be false.

## Sub-question 1 — Is settlement a state update, and which parts are shared vs per-wallet?
Yes. Settlement (`SettleVM`) is one atomic `StateDelta` (C3) across the three maps, with two
distinct parts:
- **Shared** (`UnitStatus[u]`, one value per contract): `last_settlement_price ← S`,
  `last_settlement_date ← d`; `lifecycle_stage` unchanged here (it changes only at expiry).
- **Per-position** (`PositionState[w,u]`, one row per current holder): `accumulated_cost` reset to
  `−net_qty(w) · S · multiplier`, and a **variation-margin cash move** per holder.
So the event touches both layers. The shared part is one write; the per-position part is a fan-out
over the current holders.

## Sub-question 2 — One atomic event that fans out, or a derived consequence of the shared price?
**One atomic settlement event that fans out over the current holders — not a derived consequence.**
Two reasons fix this form:
1. **The cash leg forces the fan-out.** Variation margin is real daily cash that moves between
   holders (longs and shorts) through the clearinghouse. Every cash move is a recorded,
   conservation-bearing event (`Σ_w Δcash = 0` per settlement); it cannot be left as a lazy
   derivation, because money actually changes hands daily. So a per-holder pass is unavoidable
   regardless of how `accumulated_cost` is stored.
2. **`accumulated_cost` is stored per-position state with a unique writer** (C11: `ac` →
   settle/trade; C12: per-wallet economic state lives in `PositionState`). Given the cash fan-out
   is already required, materialising the `ac` reset in the *same* atomic event is the consistent
   choice (C3 atomicity, C11 canonical writer), and it keeps the next period's PnL measured from
   `S`.
The handler fires over `holders_of(u)`; a contract with no open positions settles **vacuously**
(`Σ = 0` over the empty set, C9) — the shared price still updates, no cash moves.

**Why `accumulated_cost` cannot be dropped (the load-bearing point).** Per-wallet `ac` is what
makes each holder's VM correct when that holder *trades intraday*. The naive shared-only formula
`VM(w) = net_qty(w)·(S − S_prev)·multiplier` is **wrong** for any wallet that traded since the last
settle. The correct VM is `VM(w) = net_qty(w)·S·multiplier + ac(w)`, where `ac(w)` already absorbed
the intraday trades (`ac += −Δsigned_qty · trade_price · multiplier` on each trade). The worked
example exhibits this: on day 2 wallet A's VM is `−100`, not the naive `−300`, precisely because A
sold intraday above the prior mark. A purely shared, derived-from-price model cannot produce the
right per-wallet cash.

## Sub-question 3 — Price only in shared state, consequence only in per-wallet state?
Yes, exactly. `last_settlement_price` lives **only** in shared `UnitStatus[u]` — one value per
contract. Its economic consequence — the `accumulated_cost` reset and the variation-margin cash
move — lives **only** in per-position `PositionState[w,u]` and the move stream. The price is shared;
its consequence is per-wallet. (`multiplier`, `currency`, `expiry`, `clearinghouse`, `exchange`,
`product_id` are immutable `ProductTerms`; CME-ES and ICE-ES are distinct units.)

## Conservation, shown structurally (not asserted)
At any time `Σ_w net_qty(w,u) = 0` (trades conserve the unit) and `Σ_w ac(w,u) = 0` (each trade's
two legs contribute `∓Δsigned·p·m`, cancelling). Therefore at settlement
`Σ_w VM(w) = Σ_w(net_qty·S·m) + Σ_w ac = S·m·Σ_w net_qty + 0 = 0`, and the post-reset
`Σ_w ac = −S·m·Σ_w net_qty = 0`. Variation-margin cash zero-sum is **structural**, not a runtime
reconciliation.

## Escalations (record honestly; do not bury)
- **E1 — Settlement fan-out cost at scale.** A settlement event writes one `PositionState` row and
  emits one cash leg per *open holder* of the contract, every day. Across `~10^6` contracts each
  with up to thousands of holders, daily settlement is `O(open positions)` writes and cash legs —
  a large daily fan-out and write-amplification (the same key-space pressure as addendum risk F3).
  This is intrinsic to per-wallet variation margin, not an artefact of the model; mitigations
  (batching the fan-out, snapshotting) trade against the conservation-per-event and
  one-canonical-writer disciplines. State the cost plainly.
- **E2 — The derived-consequence alternative, and why it is not taken.** One could store only the
  shared `last_settlement_price` and compute each wallet's mark lazily, never materialising the
  `ac` reset. The design declines this, and the reason is decisive: it saves nothing on the
  dominant cost (the cash leg is per-wallet and unavoidable, item 1 above), it cannot produce the
  correct VM for intraday traders without reconstructing `ac` anyway, and it would split the `ac`
  writer discipline (C11). The fan-out is forced by the cash, not chosen for the bookkeeping.

## Stage naming note
The instrument is a **listed future** (exchange-traded — correct usage). Its initial *ledger
lifecycle stage* is **`REGISTERED`** (not the stage-name "LISTED"), per the addendum's corrected
terminology: a unit recorded in and known to the ledger before any trade. Stages:
`REGISTERED → ACTIVE → EXPIRED`. (Using "Listed" for the stage was the misleading term just
corrected; keep "listed future" for the instrument, `REGISTERED` for the stage.)
