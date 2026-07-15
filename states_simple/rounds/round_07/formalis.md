# FORMALIS — States.tex, Round 7

**Verdict: OBVIOUS**

My lens: correctness must be *visible* — conservation and deterministic replay must be
evident consequences of the structure, and no load-bearing fact of the solution may have
been dropped, weakened, or hidden to read cleaner.

## What I checked

I read `States.tex` against `SOLUTION_ESSENCE.md`, and confirmed the listings in the `.tex`
reproduce `States.hs` declaration-for-declaration (`Qty`/`negQty`, the two keys, `Lifecycle`/
`UnitStatus`/`defaultStatus`, `ProductTerms`/`currentTerms`/`appendVersion`, `PositionState`/
`zeroP`, `Ledger`/`emptyLedger`, `register`/`settle`, `Move`/`applyMove`, `position`, `netBal`,
`Event`/`apply`/`replay`). GHC is not installed in this environment, so I verified the two
load-bearing properties by hand against the code.

## Conservation is visible

The argument is a complete, structurally-forced induction, all of it on the page (§Why It Is Right,
lines 343–359):

- **Base.** `emptyLedger` has both maps empty, so every holding sum is `foldMap` over the empty
  list = `mempty` = 0.
- **Step.** `applyMove` is the *sole* writer of `psBal`; it writes both legs `negQty q` and `q`
  of one unit `u` together (line 310), so the per-unit holding sum changes by
  `negQty q <> q = mempty`. `register` and `settle` touch only `ledgerUnit`, never `psBal`.
- **Closure.** The `Ledger` constructor is not exported, so these are the only doors — the reach
  is exhaustive.

The degenerate `from == to` case still conserves (`leg` reads `findWithDefault` from the
already-updated map, so the second leg cancels the first), so the claim holds without
qualification even though the `.tex` does not belabour it. The `.tex` does not lean on any
"units are issued zero-sum" premise — conservation is derived purely from `emptyLedger` + the
single writer, which is the stronger, more visible form.

Crucially, the `.tex` does **not** hide that conservation is a *writer* invariant rather than a
store-type property, and explicitly distinguishes the conserved `psBal` from the non-conserved
`psHwm` (lines 343–345, 352–354). That honesty is itself a KEEP item, kept.

## Deterministic replay is visible

`apply` is a pure, total function of event and prior ledger; `replay = foldM (flip apply)`.
Same events → same ledger (no clock, no nondeterministic iteration — `netBal` uses `Map.toList`
but folds a commutative monoid). Checkpoint-independence is the monadic left-fold law, stated
(lines 374–383). Registration, settlement, and moves are all events, so every view (terms,
status, positions) is a projection of the stream from `emptyLedger`.

## No load-bearing fact dropped (KEEP audit)

1. **Three homes, no fourth** — present: the 2×2 with three occupied cells (§Answer), plus the
   two distinct closures of "no fourth" (the empty `(holder,unit)` definition cell *and* the
   holder-alone keying, lines 91–103, 141–159).
2. **No wallet-keyed economic sector** — present (lines 97–103); KYC/permissions called out as
   identity, not economic state.
3. **never-held vs held-and-flat** — present (§Reading a position), with both readings used
   (settlement entitlement vs wash-sale lookback).
4. **Three forcing reasons, by example** — present (§Why Three): buyer/seller ±1000; one settle
   price read by all; append-keep vs overwrite disciplines.
5. **Conservation + replay visibly forced** — present (above).
6. **Mandate-as-unit example** — present (lines 161–166), kept minimal.

Honest scoping (amendment event and HWM writer out of scope) does **not** drop a load-bearing
fact: the *structural* capabilities — the non-empty append-only version list (`appendVersion`)
and the non-conserved field beside the conserved balance (`psHwm`) — are retained in the types.
What is deferred is runtime path, which is exactly what the essence says to drop.

No DROP item leaked: no Pareto frontier, no rejected designs, no C1–C12, no risk register, no
test catalogue, no "we considered X and rejected it." The empty-cell argument establishes the
answer (no fourth home), not a rejected alternative design.

## Conclusion

The structure forces conservation and deterministic replay so plainly that the omitted proofs
are not missed, and every load-bearing fact of the solution survives intact. A competent engineer
reading only this would reach for no further justification. I stake my lens on it.

**OBVIOUS.**
