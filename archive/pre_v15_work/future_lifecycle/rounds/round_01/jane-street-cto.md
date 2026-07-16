# Scorecard — jane-street-cto — Round 1

**Lens:** Clear in six months to someone new; the settlement answer is unambiguous, not evasive.
**Targets:** `future_lifecycle/FutureLifeCycle.tex`, `future_lifecycle/settlement_answer.md`.

## Verdict: NOT-YET

The settlement answer itself is excellent — the three anchor sub-questions are answered
without evasion, the day-2 intraday anchor is rigorous, and settlement-event conservation is
shown, not asserted. But the full-lifecycle prose closes on an event (**Close**) whose
conservation is asserted rather than shown, and which the document itself flags as diverging
from the reference implementation it claims to be the prose of. A new reader who runs
`FutureLifeCycle.hs` gets a different terminal state than the document describes. That is a
3am-debugging hazard, disclosed but unresolved. Disclosure of an open contradiction is not
completeness.

## What is solid (and should not be touched)

- **Three anchor sub-questions, no evasion.** Both `settlement_answer.md` (§sub-question 1/2/3)
  and `.tex` §"The three answers, stated plainly" answer the same three questions directly:
  settlement is a state update split by layer; it is one atomic event that fans out (not a
  price-derived consequence); price lives only in shared state, consequence only per-wallet.
  Stated result-first, no hedging.
- **The load-bearing subtlety is the centrepiece, not buried.** Day-2 A = −100 vs naive −300,
  with the +200 intraday offset spelled out (`.tex` §sec:anchor lines 265-270;
  `settlement_answer.md` lines 42-53). This is the one place the design could be faked by a
  price-derived shortcut, and it is exactly where the argument is sharpest.
- **Conservation = zero-sum identity, structural.** `Σ VM = −Σ Δac` derived (line 206-207,
  and `settlement_answer.md` lines 64-73), so VM zero-sum and ac conservation are one fact, not
  two reconciliations. Correct and well-stated.
- **Arithmetic verified end to end.** I recomputed every row (T1, Settle d1, T2, Settle d2,
  T3, Expiry, Close, closing identity, economic PnL for A/B/C). All figures match across `.tex`,
  `WORKED_EXAMPLE_FUTURE.md`, and the `.hs` comments through Expiry. CumVM = economic PnL per
  wallet (A +2100, B −1700, C −400, CH 0, sum 0).
- **Make-illegal-states-unrepresentable is done by type, not check.** `Stage = Registered |
  Active (Maybe Settlement) | Expired Settlement` fuses the mark onto the stage so
  "registered-with-price" and "expired-without-mark" are unspellable (`.tex` lines 162-165,
  confirmed `.hs` lines 175-216). This is the right instinct.

## Gaps (located, actionable)

### G1 — Close diverges from the reference the document claims to be prose of. (blocking)
The abstract states "The reference implementation is `FutureLifeCycle.hs`; this document is its
prose" (`.tex` lines 33-34) and "figures that reproduce `WORKED_EXAMPLE_FUTURE.md` exactly"
(line 32). But `FutureLifeCycle.hs` `main` stops at `Expire` (lines 634-642) with terminal
state net `(6,−6,0)`, ac `(−31500,+31500,0)`; the `.tex` (Close row, lines 138-139) and
`WORKED_EXAMPLE_FUTURE.md` (line 21) both carry a further **Close** step to `(0,0,0)`. The
document discloses this in "Source divergence" (`.tex` lines 402-410) and states "Resolution
required." A spec that is, by its own words, "ahead of the reference" and demands resolution is
not yet complete. **Action:** resolve per the document's own two options — either add a `Close`
event (flatten-against-CH for cash settlement, or a delivery-versus-payment transaction) to
`FutureLifeCycle.hs`, or remove the Close row from the worked example and the `.tex`. Until then
the abstract's "this document is its prose" claim is false at the terminal state and must not
stand unqualified.

### G2 — Close-event conservation is asserted, not shown. (blocking, same event)
Criterion: conservation shown at every event. At Close the `.tex` says "conservation holding on
both fields" (line 326) but only enumerates the A/B legs (Δac(A)=+31500, Δac(B)=−31500). The
clearinghouse wallet CH absorbs the returned contracts, yet CH's Δnet_qty and Δac legs are never
written down, so the reader cannot see the sum close to zero across {A, B, CH}. Every other event
in the document shows its sums explicitly; Close is the lone exception. **Action:** enumerate
CH's legs — Δnet_qty(CH) from A delivering 6 and B covering 6 (net 0), and Δac(CH)=0 since the
A/B ac legs already cancel — and display Σ over {A,B,CH} for both net_qty and ac, matching the
rigor of T1–Expiry.

### G3 — Settle-d2 omits the explicit Δnet_qty sum. (minor)
Settle d1 states "Σ Δnet_qty = 0 (no quantity moved)" (line 230); Settle d2 (lines 261-263)
gives Σ VM and Σ Δac but drops the net_qty sum. Trivially zero for a settle, but the criterion
is "shown at every event," and the asymmetry will make a careful reader wonder if it was checked.
**Action:** add "Σ Δnet_qty = 0" to the Settle-d2 conservation line for symmetry.

## Note on settlement_answer.md
Scoped to the settlement event only, it is clean and complete: the three sub-questions answered
without evasion, conservation derived, escalations E1/E2 recorded. It does not mention Close, and
correctly so — Close is outside the settlement question. The gaps above are entirely in the
`.tex` full-lifecycle treatment. If `settlement_answer.md` were reviewed in isolation it would be
CORRECT-AND-COMPLETE; the NOT-YET is driven by the `.tex` Close event (G1, G2).
