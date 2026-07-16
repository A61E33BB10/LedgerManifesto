# MILEWSKI — FutureLifeCycle, Round 2

**Verdict: CORRECT-AND-COMPLETE.**

Lens: Haskell builds step by step; settlement and Close handlers faithful, total,
conserving; Expired terminal; flag anything awkward.

## What I checked, and what holds

### 1. The three anchor sub-questions are answered without evasion
- Settlement is a state update split by layer — shared one-write on `UnitStatus`
  (the embedded mark, coarse rank unchanged), per-holder fan-out on `PositionState`
  (`ac` reset + cash leg). Stated in `settlement_answer.md` §1 and `.tex` answer (1).
- It is one atomic event that fans out, not a price-derived consequence — forced by
  the cash leg (real daily money, conservation-bearing) plus the single-writer
  discipline for `ac`. `settlement_answer.md` §2; `.tex` answer (2); `handle`'s
  `SettleVM` case builds exactly one `StateDelta`.
- Price only in shared state, consequence only in per-wallet state —
  `last_settlement_*` are projections of the `Settlement` on the stage; the `ac`
  reset and VM cash live in `PositionState`. `settlement_answer.md` §3; `.tex`
  answer (3). The load-bearing subtlety (A's day-2 VM = −100, not the naive −300)
  is exhibited, and the code carries `naiveVM` purely for contrast, never to move
  money.

### 2. Conservation shown — not asserted — at every event
I re-derived the full life independently. All three sums are zero at every step:

| Event | Σ Δnet | Σ Δac | Σ VM |
|---|---|---|---|
| Listing | 0 (empty) | 0 (empty) | 0 (empty) |
| T1 | 0 | 0 | — (no cash) |
| Settle d1 (S=102) | 0 | 0 | +1000−1000 = 0 |
| T2 | 0 | 0 | — |
| Settle d2 (S=101) | 0 | 0 | −100+500−400 = 0 |
| T3 | 0 | 0 | — |
| Expiry (S=105) | 0 | 0 | +1200−1200 = 0 |
| Close | 0 | 0 | 0 (no cash) |

The centrepiece identity `VM = −Δac = net·S·m + ac` makes VM zero-sum the *same*
fact as `ac` conservation, not a separate reconciliation — and the code surfaces
this rather than re-checking it (`settlementFanout`: cash leg = `cashNeg (deltaAc)`).
`validate` still discharges both columns because for a `Trade` they are independent
(Δac ≠ 0 with no cash), so the cash check is not redundant in general. Correct.

### 3. The settlement and Close handlers are faithful, total, conserving
- `settlementFanout`: `target = −net·S·m`, `Δac = target − ac`, `VM = −Δac`. Verified
  arithmetically against the worked example for d1, d2, and Expiry. A flat holder
  (net=0, ac=0) gives Δac=0, VM=0 — its retained row is touched to no effect. The
  zero-holder case is the empty `foldMap`, i.e. `mempty` (C9). No division by holder
  count anywhere; the apportionment bug class cannot arise.
- `closeDelta`: additive negation of each row (Δnet = −net, Δac = −ac), no cash, no
  stage write. Conserves because it negates two columns already summing to zero.
  Rows retained at zero (monotone carrier; no PS deleter exported).
- Both handlers are pure functions of `(event, ledger)` reading current holders —
  state-dependent, not impure; determinism preserved. `holdersOf` draws from
  `Map.toList` and the result is an order-independent `Map`, so replay is stable.

### 4. Expired is genuinely terminal
The absorbing rule is enforced at two boundaries, and I checked the defense is not
ornamental:
- `handle` rejects `Trade`/`SettleVM`/`Expire` on an `Expired` unit (`UnitExpired`,
  G2), and `Close` is the one event admissible (carries `sdStage = Nothing`).
- `applyDelta` independently rejects *any* stage-writing delta when `isExpired cur`.
  This catches the exact downgrade a directly-built `tradeDelta` would attempt:
  `activateTrade (Expired s) = Active (Just s)` would regress Expired→Active, but the
  absorbing guard blocks it before application. The author correctly notes that the
  rank guard alone is too weak (Expired<Expired is false), so the explicit
  `isExpired` test is the precise rule. This is the right structure.

### 5. The representation earns its keep (restraint rule satisfied)
- `Qty`/`Cash`/`Price` as three types, `Price` deliberately without `Monoid`: buys
  the removal of contract-count-plus-cash and price-summation bugs; the bridge
  `markValue` is the single crossing point. Concrete purchase named.
- `Stage` fuses the mark onto the lifecycle: `Registered | Active (Maybe Settlement)
  | Expired Settlement` removes two unrepresentable states
  (REGISTERED-with-price, EXPIRED-without-mark) at the cost of one sum type.
- Terms+status fused into one map makes the desync state unrepresentable and the
  lookups exhaustive.
- `ValidDelta` abstract behind `validate` keeps the unchecked delta out of
  `applyDelta`; conservation is correctly a value-level check, not a fake type fact
  (E3) — the honest boundary.
- `ProductTerms` deliberately *not* versioned here, with a stated escalation path to
  the StatesHome `NonEmpty` form if amendment enters scope. Minimalism respected.

The expressibility signals E1–E4 are recorded honestly and point at the design
(multi-unit atomic events for cash), not contorted around. That is the correct
disposition.

## Non-blocking observations (not gaps; no revision required)

- **Cash modelled as `Map WalletId Cash`, no materialised CH row.** Faithful within
  the cash-settled scope because holder legs sum to zero, so the CH residual is zero.
  E1 already names the fully faithful encoding (cash as a first-class unit with a CH
  counterparty leg, the future delta being one per-unit slice of a multi-unit atomic
  event). This is a design-level deferral, correctly signalled, not a correctness
  defect for this round.
- **`Expire` on a never-traded (`Registered`) unit is admitted**, whereas `SettleVM`
  on `Registered` is rejected (`NotActive`, G4). `handle`'s `Expire` case matches
  `_` for any non-Expired stage, so Registered→Expired with an empty fan-out is legal
  and conserves vacuously. This asymmetry is defensible — an instrument expires on
  schedule regardless of trading, while a settle implies promoting/marking a
  never-traded unit — but it is neither exercised by the worked example nor stated in
  the prose. One sentence in §"Invariants threaded through the life" justifying the
  asymmetry would close the documentation completeness, if desired. Not a correctness
  gap.

## Determinism / totality
Every handler and ledger operation is total over its domain (all `Map` ops total,
`foldM` total, all `case`s exhaustive). `replay = foldM (flip step)` satisfies the
Kleisli homomorphism `replay (xs<>ys) = replay xs >=> replay ys`, so checkpoint
independence is a consequence of the law, not a test. No partiality, no
non-determinism enters.

The Haskell typechecks by inspection, builds step by step with each abstraction
introduced where it is forced, the handlers are faithful/total/conserving, Expired is
absorbing at both boundaries, the three anchor questions are answered directly, and
conservation is demonstrated — not asserted — at every event.
