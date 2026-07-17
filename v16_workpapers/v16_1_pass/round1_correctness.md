# v16.1 Round 1 — Correctness review (correctness-architect)

Target: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex`. Lenses A1–A4 (TuringAward) + red-team.
No self-certification: where the DRAFT copies memo_w3 verbatim I attack harder. The worst
finding (RT-1) is a defect my own memo (D.5) seeded and STYLUS inherited.

---

## A1 — Detection branch: clock-free & replayable — VERDICT: SOUND (one flagged dependency)

Lines 1191–1199, diagram 1311. Detection is `x = exec(e)` vs `X = exec(head)` where `head`
is the fold's last event (1193); the diagram check is `exec(e) >= exec(head)` (1311). Both
operands are recorded execution times; line 1198 states "reads no clock" and that is
accurate. No `now()` leaks into the branch. Insertion (b) re-derives position from the
recorded triple regardless of the branch, so detection is a *performance* gate, not a
correctness gate — even a wrong branch cannot corrupt state. SOUND.

One dependency to record (not a clock leak): the fast-path `x >= X` is *correctly* classifying
only under **door-time strict monotonicity** (the property-tested, not-typed obligation at
1175, `prop_doorTimeMonotonic`). If exec(e) == exec(head) and door monotonicity failed so
door(e) < door(head), the fast path would skip a reorder e in fact needs. The branch stays
clock-free; its *classification correctness* inherits the same H that totality inherits.
Add half a sentence at 1198 pinning this to `prop_doorTimeMonotonic`.

## A2 — Snapshot key stability under interior renumbering — VERDICT: DEFECT

Lines 1257–1259; table rows 1268, 1273. Snapshots are "keyed by **total-order position**"
— an ordinal. An interior insertion at `p` renumbers every event ≥ p, so the ordinal is a
**mutable, renumbering-on-insert key**, not a record-alone identifier. The invalidation rule
"≥ p, leave < p intact" is *logically* correct (surviving snapshots sit below p and are never
renumbered), so it does not return wrong state — but the key choice is wrong on three counts:

1. It contradicts the section's own ethos: the total order is "computable by any party from
   the record alone" via the triple (1164), yet the acceleration index is keyed by a position
   ordinal that is **not a record fact** and shifts on every late insertion.
2. Evaluating "position ≥ p" requires a **live order-statistic index** maintained under
   insertion — the very O(n) renumber the snapshot exists to avoid.
3. The table's contrast is not crisp: row 1273 rejects *door*-position keying as "stale
   after an interior insertion," but the **same staleness argument applies to any positional
   key, including total-order position**; what actually saves it is "invalidate ≥ p," which
   could equally rescue door-position keying. The real distinguisher is missing.

**Fix.** Key each snapshot by the **(exec, door, hash) triple `T_last` of its last folded
event** — immutable (exec never edited per TA-EXECUTION-TIME/H2 at 1250; door assigned once;
hash content-derived). Restate invalidation as a comparison in the *stable* key space: an
insertion of `e` with triple `T_e` invalidates every snapshot with `T_last ≥ T_e`; the
nearest survivor is the greatest `T_last < T_e`; refold folds events with triple in
`(T_last, head]`. No ordinal index, no renumbering, decidable from the log alone. Rewrite
1257–1259 accordingly and fix table row 1273's reason to "any *positional* key is stale under
interior insertion; the conforming key is the stable last-event triple."

## A3 — prop_refoldEqualsOnTime: non-vacuous firing + cross-unit — VERDICT: DEFECT

Lines 6106–6110 (`prop_refoldEqualsOnTime`), 6113–6114 (`prop_reorderFlagged`). Three gaps:

(i) **Vacuous-firing gap.** The witness `prop_refoldEqualsOnTime_fires` covers only
`insertsBeforeHead` — a *non-empty tail*, not a *state-changing* refold. A generator of
disjoint-footprint late arrivals satisfies it while every refolded tail state is identical
(independent commutation), so `prop_reorderFlagged`'s `restatedExactlyChangedStates` fires
with an empty changed-set and the covered-call case is never generated. Add a coverage clause
forcing footprint overlap:
```haskell
prop_refoldChangesState_fires =
  checkCoverage $ cover 1.0 (\l h -> insertsBeforeHead l h && refoldChangesState l h)
    "late arrival restates >= 1 tail state" genOverlappingLateArrival
  where refoldChangesState l h =            -- refold is NOT merely additive
    foldLedger (insertAtOrder l h) /= addOnly l (foldLedger h)
```

(ii) **Cross-unit flag gap.** `foldLedger` is whole-ledger, so the *equality* half is global —
good. But `restatedExactlyChangedStates` has no witness that the changed set spans **>1 unit**.
A late assignment on unit U that moves a margin call on agreement G (valuation watch reading
U) or a netting-set read on unit V must flag V's states too, else a cross-unit restatement is
silent (C-12.6 violated). The Interactions prose (1278–1289) asserts such effects exist;
nothing in the property block forces the generator to produce one:
```haskell
prop_reorderCrossUnit_fires =
  checkCoverage $ cover 1.0 (\l h -> distinctUnits (restatedSet l h) >= 2)
    "refold on U restates a state on unit/agreement V /= U" genCrossUnitLateArrival
```

(iii) **The oracle is not the timely world (worst of the three).** The RHS
`foldLedger (sortByOrder (late : events h))` folds the **same event set** as the LHS. Both
sides are `fold` over one sequence, so the property is nothing but **permutation-invariance
of fold** — a determinism check mislabelled "refold equals on-time." It is *blind by
construction* to any event the genuine timely world would have **newly generated** (RT-1).
The independent oracle must run the **full pipeline with `late` present from the start** —
Monitor included — so timely-only firings appear, then compare:
```haskell
prop_refoldEqualsTimely late h = insertsBeforeHead late h ==>
  refoldState late h === timelyState late h
  where timelyState l h = runPipeline (injectAtExec l (worldOf h))  -- Monitor may fire anew
        refoldState l h = refold (admitLate l (runPipeline (worldOf h)))
```

## A4 — Substrate wipe-and-rebuild decidable from the log — VERDICT: DEFECT

Lines 1339–1362. **Narrow claim is SOUND:** arming/firing are recorded events (verified
against the watch handshake 972–982, 1395–1405), so "this timer already fired" is a log fact,
and old firings persist (C-12.5, never erased), so the rebuild-after-refold case reconstructs
the fired-set. Two defects sit on top:

- **Ill-posed acceptance test.** "rebuild == what the in-place re-read reached" (1359–1361)
  is only well-defined at **quiescence** — after the re-read has deposited its fresh
  arming/firing acknowledgements on the log. Before that the two are compared at different
  stream positions. State "at quiescence" explicitly.
- **The test cannot detect a missing derived firing.** It compares substrate to rebuild, not
  rebuild to **timely**. When the refold *newly satisfies* a past predicate (RT-1), neither
  path produces the firing, so both agree and the test passes while the state is wrong. The
  acceptance test must be strengthened to `rebuild == timely` (the A3(iii) oracle), else it
  green-lights the smuggling-equivalent failure of an absent derived event.

---

## RT-1 (red-team, worst finding — connects A3(iii), A4, and Theorem thm:refold)

**The refold does not synthesise watch firings the reordered history newly satisfies, so
`thm:refold` (1237–1252) rests on a false "same sequence" premise and is false as stated for
state-dependent watches.** My memo D.5 handled only the *true→false* direction (a watch that
fired but now shouldn't, 1278–1281); the *false→true* direction is unhandled and the DRAFT
inherited the asymmetry.

Worked counterexample. A corrected close print for last Tuesday shows 79.00 (below an 80
knock-in), arriving today; it inserts at Tuesday. The refolded history shows the barrier
breached Tuesday — but the knock-in watch **never fired** (Tuesday's old close was 81), so no
firing event exists to refold. The timely world (correct close present from the start) *would*
have had the Monitor emit a knock-in firing F at execution time Tuesday (Monitor fires "the
moment a condition is met," 955). Hence:

- timely event set contains F; refold event set does not ⇒ the theorem's premise "both are
  fold step over **the same sequence**" (1241) is violated ⇒ `S_refold ≠ S_timely`.
- The substrate re-read "re-fires **forward** ... never rewinding its own history" (1352)
  **structurally cannot** emit F at its past execution time.
- "a date that matters cannot pass silently" (1408) fails for barrier/threshold watches under
  late correction.
- A3(iii)'s oracle folds the same event set and is blind to it; A4's acceptance test lets
  both paths miss it equally. Nothing in the regime catches this.

The emitted-firing set is **not invariant under reordering** because firings are *derived from
the projection* and the projection changes under refold. `thm:refold` silently assumes
invariance.

**Two fixes (owner's choice):**
- **Fix-A (correct design).** The refold re-evaluates every armed/eligible watch predicate
  over the refolded prefix and emits, **at its execution-time position**, any firing the new
  order newly satisfies — firings become a **pure deterministic derivation of the projection**,
  which is exactly what 968–970 already claims ("any party ... recomputes which events should
  have been emitted, and when"). This restores "same sequence," makes `thm:refold` true, and
  makes wipe-and-rebuild reconstruct the timely state. Cost: watch firing is no longer merely
  an untrusted Monitor emission but a recomputable derivation (a real model commitment).
- **Fix-B (park, don't fudge — constitution §1).** Explicitly scope `thm:refold` to events
  whose existence is reorder-invariant (external arrivals + already-emitted firings), and
  **park** the state-dependent-firing residual with exact amendment text. The current draft
  *fudges* by asserting `thm:refold` unconditionally while the Interactions paragraph covers
  only one direction — the narrowing §1 forbids.

Recommend **Fix-A**; it is the only route on which `thm:refold`, prop_refoldEqualsTimely, and
the substrate acceptance test are simultaneously true, and 968–970 already licenses it.

---

## Blockers (must resolve before approval)
1. **RT-1** — `thm:refold` false as stated; adopt Fix-A or Fix-B (park). Highest priority.
2. **A2** — re-key snapshots by the stable (exec,door,hash) triple; fix table row 1273 reason.
3. **A3(iii)** — replace the permutation-invariance oracle with a full-pipeline timely oracle.
4. **A4** — strengthen acceptance test to `rebuild == timely`; state quiescence.

## Recommendations (lower priority)
5. A3(i)/(ii) — add `refoldChangesState` and cross-unit firing witnesses.
6. A1 — pin the detection fast-path's classification correctness to `prop_doorTimeMonotonic`.
