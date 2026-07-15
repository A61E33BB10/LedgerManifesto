# FORMALIS — Round 1 scorecard (FutureLifeCycle)

Reviewer lens: conservation shown at every event; the settlement answer correct and
complete; replay determinism holds. VETO on any dropped or weakened guarantee or
unshown conservation.

Artifacts reviewed:
- `/home/renaud/Ledger/future_lifecycle/FutureLifeCycle.tex`
- `/home/renaud/Ledger/future_lifecycle/settlement_answer.md`
- `/home/renaud/Ledger/future_lifecycle/FutureLifeCycle.hs` (the reference)
against `SETTLEMENT_SEED.md`, addendum §4.1, and `WORKED_EXAMPLE_FUTURE.md`.

## Verdict: NOT-YET

The conservation arithmetic and the three anchor answers are sound — I re-derived
every step independently (T1, Settle d1, T2, Settle d2, T3, Expiry, Close) and
`Σ Δnet_qty = Σ Δac = Σ VM = 0` at every event, with the closing identity
A=+2100, B=−1700, C=−400, CH=0, sum 0, equal to economic P&L. The intraday-trade
subtlety (A's day-2 VM = −100, not the naive −300) is correct and load-bearing.

But the body fails the *completeness/consistency* half of the mandate: the three
artifacts disagree on where the lifecycle ends, the abstract makes a claim its own
escalation contradicts, and the Close event's conservation is asserted in prose
rather than discharged by the `validate → ValidDelta` machinery that every other
event passes through. Under a strict VETO on weakened guarantees, the Close step's
conservation is *narrated*, not *shown* in the machine-checkable sense the rest of
the document upholds.

## What passes (recorded, not glossed)

- **Conservation per modeled event (C2).** Every `StateDelta` in `.hs` reaches
  `applyDelta` only through `validate`, which discharges `Σ_w Δf = 0` for net_qty,
  ac, and cash. The vacuous (zero-holder) case is the empty `foldMap`, `mempty`
  (C9). Day-1 settle over non-holder C is vacuous and correct.
- **The three anchor sub-questions** are answered plainly and without evasion in
  both `settlement_answer.md` and `FutureLifeCycle.tex` §anchor: (1) state update,
  shared price/date on UnitStatus + per-wallet ac-reset/cash fan-out on
  PositionState; (2) one atomic event that fans out, forced by the cash leg, not a
  derived consequence; (3) price only in shared state, consequence only per-wallet.
- **VM = −Δac.** Variation-margin zero-sum is the *same fact* as ac conservation,
  surfaced rather than reconciled. Correct and elegant.
- **Replay determinism** as the Kleisli homomorphism law
  `replay (xs<>ys) = replay xs >=> replay ys`; checkpoint independence is a
  consequence of the monotone carrier (C1(b)). Holds — for the event set it covers.

## Gaps (located, actionable)

### G1 — Abstract overclaims exact reproduction; contradicted by the doc's own escalation
`FutureLifeCycle.tex:32-34` (abstract): "runs the whole life with figures that
reproduce `WORKED_EXAMPLE_FUTURE.md` exactly. The reference implementation is
`FutureLifeCycle.hs`." This is false: `FutureLifeCycle.tex:402-410` (Source
divergence) admits the reference `main` stops at `Expire` and retains
`net_qty=(6,−6,0)`, `ac=(−31500,+31500,0)` — it does *not* reproduce the worked
example's final Close row `(0,0,0)`. The abstract and the escalation cannot both
stand. Fix: either implement Close in the reference or strike "exactly" and the
Close row, so the three artifacts agree on the lifecycle's endpoint.

### G2 — Close event's conservation is asserted, not discharged (weakened guarantee)
`WORKED_EXAMPLE_FUTURE.md:21` and `FutureLifeCycle.tex:322-327` present Close as a
settled lifecycle step bringing positions and ac to zero. But `FutureLifeCycle.hs`
has no Close/Deliver constructor in `Event` (lines 256-260) and `main` ends at
`Expire` (lines 634-642). Therefore the worked example's terminal guarantee — rows
flat at zero, ac→0, cash ties to P&L — is shown by hand in prose but never passes
`validate`/`ValidDelta` like every other event. Under the lens "conservation shown
at every event," the Close event is the one event whose conservation is *not*
machine-discharged. Fix: add a Close event (flatten-against-CH, or the
delivery-versus-payment transaction the §Expiry "Physical settlement" paragraph
describes) whose `StateDelta` is validated, so Close conservation is checked, not
narrated.

### G3 — Reference header repeats the false claim
`FutureLifeCycle.hs:10-11`: "every figure in `main` reproduces the verified worked
example." `main` omits the Close row, so the last worked-example figure is not
reproduced. Same defect as G1, in the code's own documentation. Fix with G1/G2.

### G4 — Close shows two of the three promised conservation sums
`FutureLifeCycle.tex:144-146` promises "each [event] shows the three conservation
sums `Σ Δnet_qty`, `Σ Δac`, `Σ VM`." The Close treatment
(`FutureLifeCycle.tex:322-327`) shows `Σ Δnet_qty` and `Σ Δac` ("conservation
holding on both fields") but not the explicit `Σ VM = 0`. It is trivially zero (no
cash moves at the final mark, since `VM = 6·105·50 + (−31500) = 0`), but the
document set the standard of three sums per event and Close breaks it. Fix: state
`Σ VM = 0` at Close for uniformity, or scope the "three sums" promise to cash-
bearing events.

### G5 — Replay check does not cover the canonical terminal state
`FutureLifeCycle.hs:650-658`: the replay/checkpoint-independence demonstration
replays through `Expire` only. So "replay reproduces the same final ledger" is
established for the Expire-terminal state, not for the `(0,0,0)` Close-terminal
state the worked example presents as the lifecycle's end. Resolving G2 closes this:
add Close to the replayed stream and re-assert `Σ ac = Σ cumVM = 0`.

## Note (not a gap)
`settlement_answer.md:21` / `SETTLEMENT_SEED.md` say "lifecycle_stage unchanged" at
SettleVM, while the fused-Stage model in `.tex`/`.hs` writes
`Active Nothing → Active (Just (Settlement S d))`. These are consistent: the
addendum's discrete stage *rank* (REGISTERED<ACTIVE<EXPIRED) is unchanged; only the
fused mark moves. No conservation or determinism consequence. Recorded so a later
reviewer does not mistake it for a contradiction.

## Disposition
Lift to CORRECT-AND-COMPLETE once G1–G3 are reconciled (one endpoint across the
three artifacts) and the Close event passes `validate` (G2), with G4–G5 following.
The mathematics is right; the artifacts must stop disagreeing about where the life
ends, and the final event must be discharged by the same machinery as the rest.
