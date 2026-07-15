# FORMALIS — Round 2 scorecard (FutureLifeCycle)

Reviewer lens: conservation shown at EVERY event (incl. close/expiry); the
settlement answer correct and complete; replay determinism holds; lifecycle
idempotent. VETO on any unshown conservation or weakened guarantee.

Artifacts reviewed:
- `/home/renaud/Ledger/future_lifecycle/FutureLifeCycle.tex`
- `/home/renaud/Ledger/future_lifecycle/settlement_answer.md`
- `/home/renaud/Ledger/future_lifecycle/FutureLifeCycle.hs` (the reference)
against `SETTLEMENT_SEED.md`, addendum §4.1, and `WORKED_EXAMPLE_FUTURE.md`.

## Verdict: NOT-YET

One residual defect, minor and trivially fixable, but real and the same standard
round 1 enforced. Everything substantive now passes: I re-derived all eight events
independently and `Σ Δnet_qty = Σ Δac = Σ VM = 0` at each; the three anchor
sub-questions are answered plainly and correctly; replay-through-Close is
deterministic; idempotency at a fixed mark holds. The block is solely that the
document's own universal promise — "each event shows the three conservation sums" —
is not delivered at the two intraday trade events.

## Round-1 gaps: all resolved (recorded)

- **G1 (abstract overclaim).** `FutureLifeCycle.tex:26-34` now states the life runs
  "through the terminal Close, which flattens every position to (0,0,0)" and that
  `main` "computes these figures through Close." Consistent with the body's Close
  treatment and the worked example's final row. Resolved.
- **G2 (Close conservation asserted, not discharged).** `FutureLifeCycle.hs` now
  carries a `Close UnitId` constructor (line 286), a `closeDelta` (lines 426-433),
  and routes it through `step → handle → validate → applyDelta` (lines 481-483,
  569-573). Close's `StateDelta` passes the same `validate → ValidDelta` machinery
  as every other event; its conservation is machine-discharged, not narrated.
  Resolved.
- **G3 (reference header repeats false claim).** `FutureLifeCycle.hs:11-13` now says
  "NOW THROUGH THE TERMINAL CLOSE to net=(0,0,0)/ac=(0,0,0)." Resolved.
- **G4 (Close showed two of three sums).** `FutureLifeCycle.tex:338-339` now shows
  all three at Close: `ΣΔnet=−6+6+0=0`, `ΣΔac=+31500−31500+0=0`, `ΣVM=0`. Resolved
  *at Close* — but see G6 below, where the identical omission recurs at the trades.
- **G5 (replay did not cover the terminal state).** `FutureLifeCycle.hs:778-790`
  replays the full stream including `Close uF` and re-asserts
  `Σnet = Σac = ΣcumVM = mempty`. Checkpoint independence now covers the `(0,0,0)`
  terminal state. Resolved.

## What passes (verified, not glossed)

- **Conservation per event, all eight events.** Listing is the vacuous empty sum
  (C9). T1, Settle d1, Settle d2, Expiry, Close each show all three sums in the
  `.tex`, and every `StateDelta` in `.hs` — Trade, SettleVM, Expire, Close — reaches
  `applyDelta` only through `validate`, whose `netDelta` folds rows AND cash to
  `mempty` (lines 334-348). The Close flatten conserves because it negates two
  columns (`net_qty`, `ac`) that already sum to zero (lines 403-410, 426-433).
- **The three anchor sub-questions, answered without evasion** in both
  `settlement_answer.md` and `FutureLifeCycle.tex:278-294`: (1) settlement is a
  state update — shared price/date on `UnitStatus`, per-wallet `ac`-reset + cash
  fan-out on `PositionState`; (2) one atomic event that fans out, *forced by the
  cash leg* and the single `ac` writer, not a derived consequence of the price;
  (3) price only in shared state, consequence only per-wallet. Each is derived, not
  asserted.
- **VM = −Δac.** Variation-margin zero-sum is shown to be the *same fact* as `ac`
  conservation (`.tex:205-209`, `.hs:386-397`), surfaced rather than reconciled.
  Correct.
- **The intraday subtlety.** A's day-2 VM is `−100`, not the naive
  `6·(101−102)·50 = −300`; the `+200` from selling 4 @103 (one point above the prior
  mark) offsets the `−300` mark loss. Independently re-derived; correct, and the
  load-bearing argument for per-wallet stored `ac` (C11).
- **Replay determinism (P3).** `replay = foldM (flip step)`; the Kleisli
  homomorphism law `replay (xs<>ys) = replay xs >=> replay ys` makes checkpoint
  independence a consequence, not a test (`.hs:575-582`). `holdersOf` reads
  `Map.toList` (key-ordered) and the fan-out builds `Map.fromList` — no
  dictionary-iteration nondeterminism. Holds, and now over the full life incl. Close.
- **Idempotency.** Re-settle at a fixed mark is a no-op (`Δac=0`, `VM=0`,
  `.tex:399-400`). EXPIRED is absorbing: re-expiry, post-expiry trade, and
  post-expiry settle are rejected (`UnitExpired`, `.hs:469,476,465`). Close on an
  already-closed (still-EXPIRED) unit recomputes zero deltas over flat rows and is a
  validated no-op — idempotent by construction. Settle-before-first-trade
  (`NotActive`, G4) and self-trade (`SelfTrade`, G3) and close-before-expiry
  (`NotExpired`, G1) are all guarded with clear diagnostics.

## Gap (located, actionable)

### G6 — The "three conservation sums per event" promise is unmet at T2 and T3
`FutureLifeCycle.tex:144-146` states the universal: "Each event is one `StateDelta`;
each shows the three conservation sums `ΣΔnet_qty`, `ΣΔac`, `ΣVM`." This is the exact
standard round 1 enforced at Close (G4). It is now met at Listing, T1, Settle d1,
Settle d2, Expiry, and Close — but the two intraday **trade** events fall short:

- `FutureLifeCycle.tex:250` (T2): shows `ΣΔnet_qty=+4−4=0` and `ΣΔac=−20600+20600=0`
  only — `ΣVM` is omitted.
- `FutureLifeCycle.tex:305` (T3): shows `ΣΔnet_qty=0` and `ΣΔac=0` only — `ΣVM` is
  omitted.

The omitted sum is trivially zero (a trade emits no cash leg, so `ΣVM` is the empty
sum, C9; `.hs` `validate` discharges it via the empty `sdCash` fold at every trade).
The defect is not a conservation *failure* — it is a stated universal property that
the document's own body falsifies at two of eight events, in a document whose first
principle is "a claim is proved, not asserted." A reader checking the body against
line 144-146 finds two events that do not show three sums. Under the VETO lens
("conservation shown at EVERY event") and for consistency with round 1's treatment
of the identical omission, this must be closed.

**Fix (one line each).** Add `ΣVM = 0` (no cash leg) to the conservation clause at
T2 (`:250`) and T3 (`:305`) — mirroring T1 (`:192`), which already states it — or,
if the trade sections are to stay terse, rescope the promise at line 144-146 to
"each cash-bearing event shows three sums; trades move no cash, so `ΣVM=0` is
vacuous." Either makes the universal true as written. The former is preferred:
T1 already sets the three-sum pattern for a trade, so T2/T3 should match it.

## Note (not a gap)

`settlement_answer.md` / `SETTLEMENT_SEED.md` say "`lifecycle_stage` unchanged" at
SettleVM, while `.tex`/`.hs` write `Active Nothing → Active (Just (Settlement S d))`.
Consistent: the coarse rank (REGISTERED<ACTIVE<EXPIRED) is unchanged; only the fused
mark moves. No conservation or determinism consequence. (Carried over from round 1.)

The cash-as-summary-`Map` simplification (signal E1, `.hs:604-616`) is honest and
not a weakened guarantee: `Σ_w VM = 0` is validated per event, and the CH
counterparty leg is the residual — zero here only because A,B,C net to zero within
the ledger; a one-sided book would materialise a CH row that balances. The model is
general; it is correctly recorded as pointing at the multi-unit design, not a hole.

## Disposition

Lift to CORRECT-AND-COMPLETE once G6 is closed (state `ΣVM=0` at T2 and T3, or
rescope the line-144 promise). The mathematics, the three anchor answers, replay
determinism, and idempotency are all correct and complete; the document is one line
(×2) away. Nothing else blocks.
