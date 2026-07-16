# Round 8 Reviews — on candidate_r7.md (convergence attempt #4: NOT converged)

Tally: 3 APPROVE (rosetta-cdm, jane-street-cto, sbl-specialist), 4 BREAK — reducing to
THREE surfaces. All R7 items across all seven reviewers RESOLVED. jane-street confirmed
per-coordinate Terminality introduces NO new race (atomic Spine-read + the log's total
order) and that the per-coordinate split in fact REMOVES the leg-inconsistent-settled-mass
hazard a joint split would force.

## BREAKS

### R8-B1 (minsky) — the mixed-case successor is a same-direction non-DvP bundle
SO-2 = {70 XYZ forward-IN, $500 USD return-IN} puts both legs in the same direction: not a
DvP. (i) A root reference is ONE CSD matching instruction (N5's own definition); a
securities FoP receipt and a cash refund are TWO instructions — the bundle is
unconstructible on N5's own terms. (ii) The legs settle through different external events
at different times; one node cannot express "securities settled, cash still open."
Numbers: the 70-share delivery lands first ⇒ predicted depot 30 vs statement 100 →
transient false r=+70 (or r=−500 on the other walk). (jane-street's non-blocking
emission-decomposition flag is the same point — discharged by this fix.)
**Fix:** the mixed case mints TWO units — a forward securities receipt (own root ref,
walks settled on the delivery) and a cash return obligation (own root ref, exactly
R6-B1's SO-R). Pure forward-forward and return-return stay single DvP units.

### R8-B2 + R8-B3 (nazarov + correctness-architect, composing) — cross-check (b) has the wrong witness AND the wrong selector
- (nazarov) (b) confronts a lateness charge with the dispatch-INTENT, recorded before the
  send. A stalled send across the ISD boundary makes a timely intent coexist with
  genuinely-late CSD entry ⇒ (b) false-BREAKs a CORRECT $10,400 charge. Witness must
  timestamp the fact being reconciled (instruction reaching the CSD): a CSD
  receipt-acknowledgment, or failing that the dispatch-RECEIPT (send completion) — never
  the intent. Send→CSD-entry gap folds into the named TA-CUSTODY residual.
- (correctness-architect) (b) is under-specified on re-dispatch: a timely-but-unmatchable
  first dispatch (wrong BIC, Wed) + re-dispatch (Fri) leaves TWO dispatch records; the
  earliest-pick exonerates us and refuses a VALID $10,400 LMFP. Selector: (b) confronts
  the dispatch of the instruction bearing the MATCHED reference, never the earliest.
  Property: (b) BREAKs only when the matched instruction's own dispatch is timely.
**Joint fix:** check (b) confronts the MATCHED instruction's dispatch-RECEIPT (or CSD
acknowledgment where available) — matched-reference selector + send-completion witness.
Both false cases die; nazarov's original protection (refusing the false charge when our
matched dispatch was timely) survives.

### R8-B4 (regulatory-reporter) — the LMFP/SEFP boundary needs the matching TIMESTAMP vs the CSD settlement cut-off; endpoint convention pinned
Verified vs RTS 2018/1229 / CDR 2017/389 as operationalised by the ECSDA Penalties
Framework: sequential, never share a business day, SEFP from later-of — R7-B3's core
holds. But the boundary on matching day M turns on the matching TIMESTAMP vs the CSD's
settlement CUT-OFF on M, not the matched date:
- matched BEFORE cut-off ⇒ LMFP = [ISD, M) (M excluded); M is an SEFP day if it then fails;
- matched AFTER cut-off ⇒ LMFP = [ISD, M] (M included); SEFP starts M+1.
Endpoint pin: SEFP accrues each business day unsettled at end-of-day, ISD INCLUSIVE,
actual settlement date EXCLUSIVE (buy-in date likewise exclusive).
candidate_r7's §6 is internally inconsistent (LMFP "Thursday and Friday" + SEFP
"Friday→Monday" double-counts Friday; before-cut-off LMFP days are WEDNESDAY and
THURSDAY). Worked both cases: before-cut-off LMFP $10,400 (Wed+Thu) + SEFP $5,200 (Fri);
after-cut-off LMFP $15,600 (Wed+Thu+Fri) + SEFP $0. Same total, different lines — and the
flipped day moves between our payable and our receivable (LMFP charges the late-matcher;
SEFP charges the fail-cause).
**Fix:** carry the matching timestamp (or a before/after-cut-off flag) on the
match-confirmation witness; the CSD's declared settlement cut-off enters as a venue/
calendar declared term (already needed for the cadence calendar); apply the two-case
boundary; pin ISD-inclusive / settlement-exclusive; rework §6's penalty lines.

## Non-blocking carries for the .tex
1. (sbl-specialist) State that A″'s CLM-CO (securities-value + collateral) COMPOSES with
   the accrued rebate/fee/manufactured-payment income leg (GMSLA para 11) — route as an
   interface to the queued billing/income problem (like DS10→NS-02), never read as the
   complete close-out amount.
2. (jane-street) Mixed-emission flag — DISCHARGED by R8-B1's two-unit fix; no separate
   action.

## Convergence note
All three surfaces are completions of R6/R7-introduced machinery; nothing touches
R1–R5-adopted mechanisms. R8-B1 restores N5's own one-root-ref-one-instruction rule.
R8-B2/B3 is one selector+witness sentence on check (b). R8-B4 is one datum (timestamp/
flag) + one declared term (cut-off) + the two-case rule + reworked §6 lines. The three
R8 approvers each red-teamed the changed surfaces and found nothing; the four breakers
each declared their item the sole blocker.
