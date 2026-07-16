# FORMALIS — Round 3 scorecard (FutureLifeCycle)

Reviewer lens: conservation shown at EVERY event (incl. close/expiry); the
settlement answer correct and complete; replay determinism holds; lifecycle
idempotent. VETO on any unshown conservation or weakened guarantee.

Artifacts reviewed:
- `/home/renaud/Ledger/future_lifecycle/FutureLifeCycle.tex`
- `/home/renaud/Ledger/future_lifecycle/settlement_answer.md`
- `/home/renaud/Ledger/future_lifecycle/FutureLifeCycle.hs` (the reference)
against `SETTLEMENT_SEED.md`, addendum §4.1 (`addendum_stateshome_v2.tex`),
and `WORKED_EXAMPLE_FUTURE.md`.

## Verdict: CORRECT-AND-COMPLETE

The one residual defect blocking round 2 (G6) is closed. I re-derived all eight
events from scratch (independent decimal check, reproduced below) and
`ΣΔnet_qty = ΣΔac = ΣVM = 0` holds at every event including Close and Expiry; the
three anchor sub-questions are answered plainly and correctly; replay-through-Close
is deterministic; idempotency at a fixed mark and the EXPIRED-absorbing rule hold.
Nothing under the VETO lens remains open.

## Round-2 gap G6: closed

Round 2's sole block was that the document's universal promise — "each event shows
the three conservation sums `ΣΔnet_qty`, `ΣΔac`, `ΣVM`" (`FutureLifeCycle.tex:146`)
— was unmet at the two intraday trades. Both are now fixed:
- T2 (`FutureLifeCycle.tex:258`): "`ΣΔnet_qty=+4−4=0`, `ΣΔac=−20600+20600=0`,
  `ΣVM=0` (a trade moves no variation-margin cash)." All three shown.
- T3 (`FutureLifeCycle.tex:315`): "`ΣΔnet_qty=0`, `ΣΔac=0`, `ΣVM=0` (no cash leg)."
  All three shown.

All eight events now discharge three sums explicitly: Listing
(`:169`, vacuous empty sum, C9), T1 (`:193`), Settle d1 (`:244`), T2 (`:258`),
Settle d2 (`:276`), T3 (`:315`), Expiry (`:335`), Close (`:349–350`). The universal
at line 146 is now true as written. Round 1's G1–G5 remain resolved (verified in
round 2; re-confirmed below).

## Conservation, re-derived independently (not glossed)

Decimal re-derivation, m=50, wallets (A,B,C); each line reports the three sums:

| Event | net (A,B,C) | ac (A,B,C) | VM (A,B,C) | Σnet | Σac | ΣVM |
|---|---|---|---|---|---|---|
| T1   | (10,−10,0) | (−50000,+50000,0)      | —              | 0 | 0 | 0 |
| S d1 | (10,−10,0) | (−51000,+51000,0)      | (+1000,−1000,0)| 0 | 0 | 0 |
| T2   | (6,−10,4)  | (−30400,+51000,−20600) | —              | 0 | 0 | 0 |
| S d2 | (6,−10,4)  | (−30300,+50500,−20200) | (−100,+500,−400)| 0 | 0 | 0 |
| T3   | (6,−6,0)   | (−30300,+30300,0)      | —              | 0 | 0 | 0 |
| Exp  | (6,−6,0)   | (−31500,+31500,0)      | (+1200,−1200,0)| 0 | 0 | 0 |
| Close| (0,0,0)    | (0,0,0)                | —              | 0 | 0 | 0 |

Every figure matches `WORKED_EXAMPLE_FUTURE.md`, the `.tex` table (`:131–140`), and
the per-section prose exactly. Conservation is shown, not asserted, at each.

- **Close (`:344–352`) — the event a VETO lens scrutinises hardest.** Close negates
  two columns that already sum to zero: `Δnet=(−6,+6,0)`, `Δac=(+31500,−31500,0)`,
  CH legs the residual (zero, since holder legs balance). `ΣΔnet=−6+6+0=0`,
  `ΣΔac=+31500−31500+0=0`, `ΣVM=0` (no cash). It is not a weakened guarantee: Close
  behaves like a trade-back at the final mark — `Δac(A)=−(−6)·105·50=+31500` is
  exactly a sell of 6 @105 — so ac is extinguished at the price it was already marked
  to, with no residual PnL and no cash. The "no-cash-mirroring-Δac" property is
  correct because the VM=−Δac identity binds only at settle events; trades and Close
  legitimately move ac without cash (T1 does the same). Conservation discharged, not
  narrated.
- **Expiry (`:330–337`).** Settlement fan-out over A,B (C flat, touched to no
  effect: `VM(C)=0·105·50+0=0`), composed with the stage write to EXPIRED.
  `ΣΔnet=0`, `ΣVM=+1200−1200=0`, `ΣΔac=0`. Shown.

## The three anchor sub-questions — answered without evasion

Consistent across `settlement_answer.md` and `FutureLifeCycle.tex:287–303`:
1. **State update; shared vs per-wallet.** Shared = one write of
   `last_settlement_price`/`last_settlement_date` on `UnitStatus[u]` (one value per
   contract; the coarse rank REGISTERED<ACTIVE<EXPIRED is unchanged at a settle, the
   embedded mark updates). Per-position = ac-reset + cash leg fan-out on
   `PositionState[w,u]`. One atomic `StateDelta` touching both layers (C3).
2. **One atomic event that fans out, not a derived consequence of the price.**
   Forced by the cash leg (real daily money, conservation-bearing, `Σ_w VM=0`) and
   the single canonical ac writer (C11). Derived. The load-bearing proof: A's day-2
   VM is **−100**, not the naive `6·(101−102)·50=−300`; the `+200` from selling 4
   @103 (one point above the prior mark 102) offsets the −300 mark loss. Only stored
   per-wallet ac yields the correct figure — I re-derived this independently.
3. **Price only in shared state, consequence only per-wallet.** Yes;
   `last_settlement_price` lives solely on `UnitStatus[u]`, its consequence (ac reset
   + VM cash) solely on `PositionState[w,u]` and the move stream.

The settlement-answer's structural conservation proof (`settlement_answer.md:68–76`)
— `Σ_w VM = −Σ_w Δac`, and `Σ_w Δac = −S·m·Σ net_qty − Σ ac = 0` — is correct: VM
zero-sum is the same fact as ac conservation, surfaced not reconciled. Complete.

## Replay determinism and idempotency

- **Determinism (C1(b)).** `replay = foldM (flip step)` with the Kleisli
  homomorphism `replay (xs<>ys) = replay xs >=> replay ys` (`.hs:620–625`); the
  monotone carrier keeps the key set stable across cuts. Fan-out reads `holdersOf`
  (key-ordered `Map.toList`) and conservation sums commute, so there is no
  dictionary-iteration nondeterminism. The replay demonstration includes
  `Close uF` (`.hs:845`) and re-asserts `Σnet=Σac=ΣcumVM=mempty` at the terminal
  `(0,0,0)` state (`.hs:847–848`). Holds over the full life.
- **Idempotency.** Re-settle at a fixed mark is a no-op (`Δac=0`, `VM=0`,
  `.tex:415–416`). EXPIRED is absorbing: a second Expire, a post-expiry Trade, and a
  post-expiry Settle are rejected via `isExpired` (`.hs:219–221`, rejections at
  `:504,510,517`), and the rank guard's insufficiency (`2<2` false) is correctly
  handled by the explicit absorbing test. Close is the one event admissible on
  EXPIRED (no stage write, `.hs:523–525`) and is idempotent by construction —
  re-Close recomputes zero deltas over flat rows. The chain
  REGISTERED→ACTIVE→EXPIRED admits no skips (`NotActive` on settle/expire of a
  never-traded unit, `.hs:511,518`).

## Reference machinery (re-confirmed)

`ValidDelta` has the single constructor `validate` (`.hs:344–348`), which folds rows
AND cash to `mempty`; `step` is the only path to `applyDelta` and routes every event
— Trade, SettleVM, Expire, **Close** — through `handle → validate → applyDelta`
(`.hs:611–616`). `main` runs through Close (`l7`, `.hs:794`) and asserts the three
terminal zero sums (`.hs:796–801`). Close conservation is machine-discharged, not
prose. (GHC is unavailable in this environment, so I could not execute `main`; the
conservation claim under review lives in the `.tex` and is independently re-derived
above, so execution is corroborating, not load-bearing for the verdict.)

## Notes (not gaps)

- The round 1/2 "lifecycle_stage unchanged at settle" wording is now reconciled in
  `settlement_answer.md:19–22`: it distinguishes the coarse rank (unchanged) from the
  embedded mark (updated every settle), matching `.tex`/`.hs`. No residual
  discrepancy.
- "Units returned to CH" at Close (`.tex:342–343`) with `ΔnetCH=0` is consistent: two
  moves through CH (A→CH q=6, CH→B q=6) net CH to zero, equivalent to the A→B
  transfer the deltas encode. Narrative and arithmetic agree; conservation holds.
- The cash-as-summary-`Map` (E1) is honestly recorded as key-space pressure, not a
  hole: `Σ_w VM=0` is validated per event and the CH leg is the residual (zero here
  only because A,B,C net within the ledger). Correctly escalated, not smoothed.

## Disposition

No open gaps under the VETO lens. Conservation is shown at every event including
Close and Expiry; the settlement answer is correct and complete on all three
anchors; replay is deterministic through the terminal state; lifecycle idempotency
and the EXPIRED-absorbing rule hold. CORRECT-AND-COMPLETE.
