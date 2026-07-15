# MILEWSKI — FutureLifeCycle Round 1 scorecard

**Lens:** the Haskell builds step by step; the settlement handler is faithful, total,
conserving; flag anything awkward to express.

**Verdict: NOT-YET.**

The core is strong: the three scalar types earn their keep, the settlement centrepiece is
faithful and conserving, `VM = -Δac` is surfaced rather than reconciled, and the pipeline
`handle >=> validate >=> applyDelta` is total and deterministic. Two real gaps block sign-off —
one is the document's own self-flagged divergence, the other is an illegal transition that the
stated invariant claims is rejected but the guard lets through and which moves real cash.

---

## The three anchor sub-questions — answered, no evasion

- **SQ1 (state update; shared vs per-wallet split).** Answered. `settlement_answer.md` §SQ1 and
  `.tex` §8 answer "yes": shared = one `last_settlement_price`/`date` write on `UnitStatus[u]`;
  per-position = `ac` reset + cash leg on `PositionState[w,u]`. The `.hs` `handle`/SettleVM branch
  realises exactly this (one `sdStage`, a `sdRows`+`sdCash` fan-out).
- **SQ2 (atomic fan-out vs derived consequence).** Answered: one atomic event that fans out. The
  cash leg forces the per-holder pass (real daily money, conservation-bearing); `ac` single-writer
  (C11) makes materialising the reset in the same delta the consistent choice. The load-bearing
  intraday case (A = −100, not the naive −300) is proved in prose and re-exhibited in `main` lines
  617–624. Not evaded.
- **SQ3 (price only shared, consequence only per-wallet).** Answered: `last_settlement_price` only
  in `UnitStatus`; `ac` reset + VM cash only in `PositionState` + the move stream. Matches the `.hs`
  field homes.

## Conservation shown at every event — checked

Per-event sums verified against the prose and re-derived from the handlers:
Listing (vacuous, empty sum, C9) ✓; T1 Σnet=Σac=0 ✓; Settle d1 Σnet=Σac=ΣVM=0 ✓; T2 Σnet=Σac=0 ✓;
Settle d2 ΣVM=ΣΔac=0 ✓; T3 Σnet=Σac=0 ✓; Expiry ΣVM=ΣΔac=0 ✓; Close Σnet=Σac=0 ✓ (but see G1 —
Close is not in the `.hs`). `settlementFanout` conserves structurally: ΣΔac = −S·m·Σnet − Σac = 0
given the pre-state invariant, and VM = −Δac ⇒ ΣVM = 0. `validate` re-checks both at runtime, so the
property is by-construction, not asserted.

---

## Gaps (each located and actionable)

### G1 — HIGH — Close step: prose/worked-example reach (0,0,0); the `.hs` stops at Expire
`.tex` §"Expiry and final settlement" + §Escalations "Source divergence" (lines 322–335, 402–410)
carry a **Close** row flattening to `net=(0,0,0)`, `ac=(0,0,0)`; `FutureLifeCycle.hs` `main`
(lines 634–642) stops at `Expire`, retaining `net=(6,-6,0)`, `ac=(-31500,+31500,0)`. There is **no
`Close` event in the `Event` type** (lines 256–260). A reader cannot reproduce the worked example's
final row in the reference. The `.tex` itself flags this as "Resolution required" — it is therefore
an open, unresolved divergence, not a settled design.
**Action:** either add a `Close` event to `FutureLifeCycle.hs` (a flatten-against-CH transaction,
or DvP for the physical variant) and assert `(0,0,0)` in `main`, or remove the Close row from the
worked example and the `.tex` table. Pick one; the three artifacts must agree.

### G2 — HIGH — `Expired` is not terminal: a repeated `Expire` slips the monotone guard and moves cash
`.tex` §Invariants (lines 377–381) and `.hs` E2 (lines 529–536) both claim the monotone-stage guard
"rejects post-expiry trades and re-settles." It does for `Trade` and `SettleVM` (both propose
`Active`, rank 1 < `Expired` rank 2 ⇒ `StageRegression`). It does **not** for a second `Expire`:
`stageRank (Expired _) = 2` regardless of price (`.hs` line 203), and `applyDelta`'s guard is
`stageRank new < stageRank cur` (line 461) — strict. So `Expired(105) → Expired(110)` gives `2 < 2 =
False` and is **accepted**: `settlementFanout` at the new price runs over A,B, moves real cash
(VM(A)=+1500 for S=110), and overwrites the final mark. Conservation holds, so `validate` passes —
this is a *conserving but illegal* post-expiry cash move. The stated invariant overclaims.
**Action:** make `Expired` absorbing — reject any delta whose current stage is `Expired` (or reject a
proposed `Expired` when already `Expired`). Then narrow/keep the invariant claim to match. Related:
`handle`'s `Expire` branch never checks the event day against `ptExpiry` (lines 407–409), so expiry
can also fire on any day; decide whether that is enforced or deliberately not.

### G3 — LOW — self-trade (`buyer == seller`) is caught, but only incidentally
`tradeDelta` builds `Map.fromList [(buyer,…),(seller,…)]` (lines 345–348). If `buyer == seller`,
`Map.fromList` keeps the last entry, so net = −q, ac = +q·p·m, and `validate` rejects it as
`NotConserved` — total and safe, but the diagnostic is misleading (it reads as a conservation bug,
not a self-trade). **Action (optional):** an explicit `buyer == seller` guard returning a clearer
`LedgerError`, or a note that self-trades surface as `NotConserved` by design.

### G4 — LOW — settling a never-traded `Registered` unit jumps it to `Active` with a mark
`handle`'s SettleVM branch on a `Registered` unit (no holders) emits stage `Active (Just …)` with an
empty fan-out; `applyDelta` accepts it (rank 1 > 0). Representable and harmless (no cash moves), but
it contradicts the `.tex` premise that the mark "is written only by settle/expire, which act on a
traded unit." **Action (optional):** decide whether a pre-trade settle is legal; if not, reject it.

### G5 — LOW — `main` claims "conservation asserted after EVERY step" but checks two of three sums
`report` (lines 594–600) asserts `sum ac = 0` and `sum cumVM = 0`, not `sum net_qty = 0`. The latter
is guaranteed by `validate` per step (a violation would error via `expect`), so it is indirectly
covered, but the header comment (lines 557–558) overstates what `report` checks.
**Action (optional):** add a `sum net_qty` assertion to `report`, or soften the comment.

---

## What is solid (recorded so it is not relitigated)

- `Qty`/`Cash`/`Price` separation with `Price` carrying no `Monoid` makes `VM = net_qty·S·m + ac`
  typecheck only because both summands are `Cash`; the dimension bridge `markValue` is the single
  crossing point. Earns its place.
- The `Stage` fuse (`Registered | Active (Maybe Settlement) | Expired Settlement`) removes the two
  unreachable states the naive product admits. Correct purchase.
- Conservation as a monoid homomorphism into `Conserved`, with `ValidDelta` abstract behind
  `validate`, is the right boundary; the vacuous (zero-holder) case is `mempty` for free (C9), and no
  apportionment/division-by-holder-count bug class can arise.
- `settlementFanout` is faithful and total; `VM = -Δac` makes VM zero-sum the *same* fact as `ac`
  conservation for settle/expire — a genuine structural saving, not decoration.
- `replay = foldM (flip step)` with the Kleisli homomorphism law gives checkpoint independence by
  consequence. Determinism preserved (`handle` is a pure function of `(event, ledger)`;
  `Map.toList` order is stable).

Resolve G1 and G2; G3–G5 are optional polish. On those, this submission is sound.
