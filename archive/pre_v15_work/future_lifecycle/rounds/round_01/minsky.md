# MINSKY scorecard — FutureLifeCycle, Round 1

Lens: the state types make illegal lifecycle states unrepresentable; the
never-held / held / flat distinction is exact.

Verdict: **NOT-YET**

## What holds (verified, not assumed)

- **The `Stage` fuse is exact.** `Registered | Active (Maybe Settlement) |
  Expired Settlement` removes the two unreachable status states named in §3 /
  Sec.3: `(REGISTERED, Just p)` and `(EXPIRED, Nothing)` are unspellable.
  `settlement`, `settlementPrice`, `settlementDate`, `stageRank` are total over
  all three constructors with no wildcard. Good.
- **never-held / held / flat is exact.** `position :: ... -> Maybe PositionState`.
  `Nothing` = never held; `Just zeroP` = held-and-flat. `applyDelta.applyRow`
  uses `findWithDefault zeroP` then insert — once touched, always `Some`, never
  deleted (no PS deleter exported; `Ledger` abstract). C goes flat at T3 and is
  retained as `Just (PositionState (Qty 0) (Cash 0))`; settling a flat holder
  yields `Δac = 0`, `VM = 0` (row touched to no effect). The distinction is
  preserved through expiry. Good.
- **Conservation shown at every event.** `validate` discharges
  `netDelta sd == mempty` (a monoid identity) before any application; the
  `ValidDelta` witness is abstract, so an unconserved delta cannot reach
  `applyDelta`. The .tex shows the three sums (`ΣΔnet_qty`, `ΣΔac`, `ΣVM`) at
  T1, Settle d1, T2, Settle d2, T3, Expiry; Listing is the vacuous empty sum
  (C9). I re-checked every row of the table arithmetically — all sum to zero.
  The centrepiece identity `VM = -Δac = net_qty·S·m + ac` is implemented
  correctly in `settlementFanout` (`deltaAc = -(markValue netq s m) - ac`;
  cash leg = `cashNeg deltaAc`), so VM zero-sum is the same fact as `ac`
  conservation. Good.
- **The three anchor sub-questions are answered without evasion** in
  `settlement_answer.md`: (1) state update, shared vs per-wallet split stated;
  (2) one atomic event that fans out, with the two forcing facts (cash leg
  forces the per-holder pass; `ac` single-writer); (3) price only shared,
  consequence only per-wallet. The day-2 A = −100 vs naive −300 is exhibited in
  prose and in `main` (`naiveVM` shown for contrast, not used to move money).
  Good.

## Gaps (each forces NOT-YET)

### G1 — Re-expiry is representable; `Expired` is not absorbing
The monotone-stage guard rejects only a *strictly* lower rank:
`stageRank new < stageRank cur` (FutureLifeCycle.hs:461). A second `Expire` on
an already-expired unit proposes `Expired` (rank 2) against current rank 2;
`2 < 2` is False, so it **applies**: `handle` builds a fresh settlement fan-out,
`validate` passes (each fan-out conserves), and `applyDelta` runs it — moving a
second round of post-expiry VM cash and resetting `ac` again at the new price.
This contradicts the stated invariant (FutureLifeCycle.tex:377–381): "the stage
rank … never regresses; a proposed stage of strictly lower rank is rejected …,
excluding post-expiry trades and **re-settles**." A second `Expire` *is* a
post-expiry re-settle, and it is not excluded. (Post-expiry `Trade` and
`SettleVM` *are* correctly rejected — both propose `Active`, rank 1 < 2 — which
is why `main`'s single rejection test passes and hides this.)
- Location: FutureLifeCycle.hs:461 (`applyDelta`); invariant claim
  FutureLifeCycle.tex:377–381; settlement_answer.md E2 ("split the single-writer
  discipline … out") implicitly assumes terminality.
- Actionable fix: make `Expired` absorbing — reject any stage-writing delta when
  `cur` is `Expired` (e.g. `case cur of Expired _ -> Left (StageRegression …);
  _ -> if stageRank new < stageRank cur then Left … else …`). A bare `<=` is
  wrong: it would also reject the intended `Active → Active` daily re-settle.

### G2 — Reference and narrative diverge at the Close step (overclaimed)
WORKED_EXAMPLE_FUTURE.md and FutureLifeCycle.tex (table line 139) both carry a
final **Close** row flattening positions to `net_qty = (0,0,0)`,
`ac = (0,0,0)`. The reference `main` stops at `Expire` and retains
`net_qty = (6,−6,0)`, `ac = (−31500,+31500,0)` (FutureLifeCycle.hs:634–658).
There is no `Close`/`Deliver` event constructor in `Event`. Yet the abstract
claims figures "reproduce `WORKED_EXAMPLE_FUTURE.md` exactly"
(FutureLifeCycle.tex:31–34) and the .hs header claims "every figure in `main`
reproduces the verified worked example" (FutureLifeCycle.hs:9–11). With the
Close row present in both worked examples, both claims are false as delivered.
The .tex honestly flags this (FutureLifeCycle.tex:402–410) and escalates, but
the deliverable set is internally inconsistent until resolved.
- Location: FutureLifeCycle.hs:9–11 (header claim), 256–260 (no Close event),
  581–658 (`main` ends at Expire); FutureLifeCycle.tex:31–34 ("exactly"),
  139 (Close row), 402–410 (escalation); WORKED_EXAMPLE_FUTURE.md Close row.
- Actionable fix: either add a `Close`/`Deliver` event to `FutureLifeCycle.hs`
  (the flatten-against-CH transaction, `Δac(A)=+31500`, `Δac(B)=−31500`,
  `Δnet_qty(A)=−6`, `Δnet_qty(B)=+6`, both conserving) and extend `main` to it,
  or remove the Close row from both worked examples and soften the "exactly"
  claims. Pick one; do not leave the two artifacts disagreeing.

## Minor (does not by itself block, but in-lens)

### M1 — `terms ⇔ status` is a convention, not a type fact
`Ledger` holds `ledgerTerms` and `ledgerStatus` as two independent maps
(FutureLifeCycle.hs:421–426). The invariant "u ∈ terms ⇔ u ∈ status" is
established only by `register` writing both, and relied on by `handle`'s
`_ -> Left (UnknownUnit u)` wildcard (FutureLifeCycle.hs:410), which silently
collapses the unreachable `(Just,Nothing)`/`(Nothing,Just)` cases. The illegal
desynchronised state is *representable* in the `Ledger` record; only the abstract
boundary keeps it out. Fusing into one `Map UnitId (ProductTerms, UnitStatus)`
would make it unrepresentable and let the wildcard become an exhaustive
`Nothing -> UnknownUnit`. Worth doing for the lens, not load-bearing given the
abstract ledger.

## Bottom line
The type-level work that is the heart of my lens — the `Stage` fuse and the
never-held/held/flat trichotomy — is correct and exact, and conservation is
genuinely shown (not asserted) at every event. But an illegal *transition*
survives (G1: `Expired` is not absorbing, so a unit can expire twice and move
post-expiry cash), and the reference contradicts its own worked example at Close
(G2). Both are located and actionable. NOT-YET.
