# Round 1 Scorecard — henri-cartan

Lens: definitions before use; each step follows from what precedes; explicit
quantifiers; no handwaving. Conservation shown — not asserted — at every event.
Three anchor sub-questions answered without evasion.

Artifacts reviewed:
- `/home/renaud/Ledger/future_lifecycle/FutureLifeCycle.tex`
- `/home/renaud/Ledger/future_lifecycle/settlement_answer.md`
Cross-checked against `WORKED_EXAMPLE_FUTURE.md` and `FutureLifeCycle.hs`.

## Verdict: NOT-YET

The mathematics is sound and the three anchor questions are answered squarely.
Every conserved sum I recomputed holds. The verdict is held back by one
unresolved inconsistency in the deliverable set (self-flagged) plus two smaller
rigor/clarity defects, all actionable.

## What is correct (verified independently)

Arithmetic re-derived from the stated rules
(trade: `ac += −Δ·p·m`; settle: `VM = netq·S·m + ac`, then `ac ← −netq·S·m`,
`m = 50`):

| Event | Σ Δnetq | Σ Δac | Σ VM | figures match table |
|---|---|---|---|---|
| Listing | empty (0) | empty (0) | empty (0) | yes (vacuous, C9) |
| T1 | +10−10 = 0 | −50000+50000 = 0 | — | yes |
| Settle d1 | 0 | −1000+1000 = 0 | +1000−1000 = 0 | yes |
| T2 | +4−4 = 0 | −20600+20600 = 0 | — | yes |
| Settle d2 | 0 | 0 | −100+500−400 = 0 | yes |
| T3 | +4−4 = 0 | −20200+20200 = 0 | — | yes |
| Expiry | 0 | 0 | +1200−1200 = 0 | yes |
| Close | (−6,+6) → 0 | +31500−31500 = 0 | — | yes |

- The load-bearing day-2 figure VM(A) = −100 (not the naive −300) is correct and
  its decomposition (+200 intraday gain offsetting −300 mark loss) is exact.
- Closing identity verified: cumulative VM (A,B,C,CH) = (+2100,−1700,−400,0),
  sum 0, each equal to the independently computed economic P&L.
- The identity `VM = −Δac` and hence `Σ VM = −Σ Δac = 0` is genuinely derived
  (settlement_answer.md "Conservation, shown"; .tex §settle-mech box), not asserted.
- Dimension bridge (`markValue : Qty·Price·m → Cash`, Price carries no addition)
  correctly justifies why `VM = netq·S·m + ac` typechecks. Definitions precede use.
- Three anchor sub-questions are each answered Yes/No with the mechanism, in both
  documents, without evasion (.tex §anchor "The three answers, stated plainly";
  settlement_answer.md §§1–3). No hedging.

## Gaps (each located, each actionable)

### G1 (blocking) — Worked example asserts a Close the reference cannot reproduce
Location: `FutureLifeCycle.tex` abstract (l.32–34) and table row "Close" (l.139);
`FutureLifeCycle.hs` `main` (ends at `Expire`, l.635–637; no `Close`/delivery event
in the `Event` ADT, l.251–265).
The abstract claims "this document is its prose" of `FutureLifeCycle.hs` and
reproduces `WORKED_EXAMPLE_FUTURE.md` "exactly." The first claim is currently
false: the narrative and worked example carry a Close step to (0,0,0) that the
reference stops short of (it retains netq=(6,−6,0), ac=(−31500,+31500,0)). The
document's own "Source divergence" note (l.402–410) identifies exactly this and
marks it "Resolution required." Until resolved, the deliverable set is internally
inconsistent and the abstract over-claims.
Action: either add a Close event (flatten-against-CH, or delivery-versus-payment)
to `FutureLifeCycle.hs`, or remove the Close row from the worked example and the
abstract's "exactly"/"its prose" claims. Pick one; do not leave both standing.

### G2 (minor) — Conservation at Close is asserted on the netq leg, not shown
Location: `FutureLifeCycle.tex` §Expiry, "Cash settlement" paragraph (l.322–327).
The paragraph writes Δac(A)=+31500, Δac(B)=−31500 explicitly but gives the netq
leg only as "netq→(0,0,0)" with the phrase "conservation holding on both fields."
For the standard "conservation shown at every event," write the two quantity
deltas (Δnetq(A)=−6, Δnetq(B)=+6, Σ=0) as is done for every other event. One line.

### G3 (minor) — "stage" overloaded between the two documents
Location: `settlement_answer.md` §1 ("`lifecycle_stage` is unchanged here; it
changes only at expiry") vs `FutureLifeCycle.tex` §settle-mech ("the stage becomes
`Active (Just (Settlement S d))`").
Both are consistent with `FutureLifeCycle.hs` (the `stageRank` stays ACTIVE while
the `Stage` ADT value gains the `Just Settlement`), but the word "stage" denotes
the rank in one document and the ADT value in the other. A reader comparing the
two sees an apparent contradiction. Disambiguate: "rank unchanged; the Stage value
acquires the mark," consistently in both. Relatedly, the .tex §1 field table lists
`lifecycle_stage`, `last_settlement_price`, `last_settlement_date` as three
UnitStatus fields, while §Listing fuses them into one `Stage` ADT; a half-line
noting the price/date are projections of the `Settlement` carried in `Stage` would
remove the apparent three-vs-one field mismatch.

## Summary
Correctness of the mathematics: passes. Completeness: fails on G1 (an open,
self-acknowledged inconsistency between the narrative/worked-example and the
reference implementation, compounded by an abstract that over-claims). G2 and G3
are small rigor/clarity fixes. Resolve G1 and the document is ready.
