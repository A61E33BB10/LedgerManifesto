# Round-1 fixes — convergence guidance (FutureLifeCycle)

All eight reviewers returned NOT-YET. The Haskell is FORMALIS-cleared and the settlement answer's
substance is accepted; the gaps are internal-consistency between the three artifacts, two real
`.hs` bugs, and conservation shown-not-asserted at the final event. Fix every item; the
load-bearing ones:

## Haskell (milewski; FORMALIS re-clears)
- **G1 — add the Close so the reference reaches flat.** `main` stops at `Expire` retaining
  net=(6,−6,0), ac=(−31500,+31500,0); the worked example and `.tex` carry a Close to (0,0,0). Add a
  terminal **Close/flatten event** (or fold it into `Expire`): at the final settlement price the
  positions are extinguished against CH — for cash settlement the final VM already moved the value,
  so Close returns the units to CH with **zero further cash** and resets ac→0; rows are retained at
  zero (monotone). Discharge `Σ Δnet_qty = 0`, `Σ Δac = 0`, `Σ VM = 0` through `validate`/
  `ValidDelta` like every other event, run it in `main`, and include it in the replay demonstration.
  This makes the reference reach the worked example's terminal state.
- **G2 — make `Expired` terminal (idempotency bug).** `stageRank (Expired _) = 2` with a strict
  guard `new < cur` lets a second `Expire` (2 < 2 = False) through, rerunning the fan-out and moving
  cash post-expiry. Reject any transition out of (or re-into) `Expired`: a unit at `Expired` admits
  no further `Trade`, `SettleVM`, or `Expire`. (Lifecycle idempotency.)
- **G4 (minor) — a `SettleVM` on a never-traded `REGISTERED` unit** currently jumps it to `Active`
  with an empty fan-out. Either keep it `REGISTERED` (update the shared mark only) or reject settling
  a unit with no holders; do not silently promote it to `Active`.
- **G3, G5, terms⇔status (minor)** — optional: a `buyer==seller` self-trade guard with a clear
  diagnostic; add `Σ net_qty = 0` to `report`; note the terms⇔status co-registration is a `register`
  boundary convention.

## Prose and consistency (STYLUS)
- **Reconcile all three artifacts on the terminus and the abstract.** Once milewski adds Close, the
  `.tex` table, `WORKED_EXAMPLE_FUTURE.md`, and the `.hs` `main` all end at (0,0,0)/(0,0,0); remove
  the self-flagged "Source divergence / Resolution required" note and make the abstract's "the
  reference is `FutureLifeCycle.hs`; this document is its prose" and "reproduces the worked example
  exactly" simultaneously true. Do not claim prose-equality beyond what the `.hs` computes.
- **Show conservation at the Close/expiry event** explicitly — `Σ Δnet_qty = 0` (write the per-wallet
  deltas, including CH), `Σ Δac = 0`, `Σ VM = 0` — matching every other event. (FORMALIS veto item.)
  Also add `Σ Δnet_qty = 0` to the day-2 settle line for symmetry.
- **Disambiguate "stage".** The model fuses the settlement mark into the stage ADT
  (`Active (Just (Settlement S d))`), so the *coarse rank* `REGISTERED → ACTIVE → EXPIRED` is
  unchanged at a settle while the *embedded settlement mark* updates every settle. State this once
  and use it consistently in `settlement_answer.md` (revise the "lifecycle_stage unchanged" clause to
  "the coarse rank is unchanged; the settlement mark updates") and the `.tex`. Note that
  `last_settlement_price`/`last_settlement_date` are projections of the `Settlement` carried by the
  `Active` stage.
- **CH's cash leg is the residual.** Where the prose says VM is "routed through CH," add one clause:
  the holder legs sum to zero, so CH's leg is the residual — zero in this example — and no CH cash
  row materialises. Keep this consistent with the `.hs` (legs emitted over holders).

## Unchanged
6–8 pages, lifecycle in deductive order, conservation shown at every event, the verified worked
example numbers exact, the settlement answer non-evasive (hybrid event, both layers, E1/E2
escalations). Instrument = "listed future"; initial stage = `REGISTERED`.
