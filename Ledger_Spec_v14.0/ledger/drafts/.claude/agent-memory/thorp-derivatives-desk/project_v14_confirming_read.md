---
name: v14-confirming-read-residuals
description: v14.0 confirming read closed at SHIP (2026-07-11); records the repaired SBL/sec05a residuals, verified conventions, and vocabulary traps to watch on future passes
metadata:
  type: project
---

Confirming read of v14.0 drafts closed at **SHIP** on 2026-07-11. The two substantive residuals from the first pass (2026-07) were repaired and re-verified by re-derivation:

1. **sec05h_sbl.tex conservation — FIXED.** Loan-open is now a 3-move transaction with the virtual wallet carrying a contra on *both* share coordinates (onloan −400 and borrowed −400). Law A (per-unit slot sum = 0) re-derives from the shown moves and the printed state is reachable; Law B (possess = own − onloan + borrowed + coll_recv, sums to shares in issue N = 1,000, not zero); Law C (lender own constant by construction). The old "sum over six coordinates = 0" claim is gone. Straddle: 1,200 real + 800 real-to-borrower + 800 manufactured on the on-loan line; book up 2,000 = own × c, borrower nets zero, agent out 2,000. Collateral 400 × €50 × 105% = €21,000. Recall = notification + obligation object, zero moves; mirror fires on the return.
2. **sec05a "stored reference" — FIXED.** Ordinary dividend €102 → €100 is now explicitly the transported cum-dividend *print* at the read seam; the stored price terms field STANDS. Split appends a new terms version (€100 → €50) because splits DO adjust terms fields. Consistent with sec03 stand/adjust. sec05a also books BOTH trade legs at trade date (cash to counterparty virtual wallet = unsettled payable); settlement generates no moves, recorded as state — verified desk-true (trade-date accounting, settled-cash is a boundary reconciliation).
3. **sec03 factor constraint** is f ≠ 0 (invertibility), negative f well-formed, zero refused — accepted as first-principles-minimal; no real CA has negative f but the spec doesn't need f > 0 for safety.
4. **sec05b** refusal phrasing fixed: "returns the payload with the refusal" — matches sec02/sec03 (refused payloads returned, never stored). Watch for "keeps the payload" regressions.
5. Conventions confirmed consistent and verified numerically: weld is a door check defined once in sec02 with (f,c) per-holder form, derived forms = same-effective-time and aggregate (elective); Shift −c means subtract c; composite Subst(Q,f)∘Shift(−c) applies Shift first, price action (p−c)/f; merger numbers 2450/51, 1,020 = 1,000 × 1.02, 51,000 = 1,000 × 51 all exact; boundary composition in declared effective order — (102−2)/2 = 50, never 102/2 − 2 = 49.

**How to apply:** on any future pass over these files these are settled — do not re-open them; check instead that later edits don't regress the both-contras loan open, the print-vs-terms-field vocabulary, or the returned-payload phrasing.
