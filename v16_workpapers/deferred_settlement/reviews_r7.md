# Round 7 Reviews — on candidate_r6.md (convergence attempt #3: NOT converged)

Tally: 4 APPROVE (sbl-specialist, regulatory-reporter, rosetta-cdm, jane-street-cto),
3 BREAK. All R6 items across all seven reviewers RESOLVED. The four approvers red-teamed
fresh surfaces and found nothing breaking. All three breaks touch machinery introduced or
completed in R6; none touches anything older than R5.

## BREAKS

### R7-B1 (minsky) — the Binding case-split must be PER COORDINATE
The case-split is a single quantity-flavored decision, but netting is per coordinate, and
the two coordinates can land on opposite sides. Numbers: buy 100 XYZ @$50; 30 settle at $50
(settled cash $1,500). Price corrected to $10, quantity unchanged. Quantity: 100 ≥ 30 →
forward, deliver 70 ✓. Cash under that same branch: $1,000 − $1,500 = **−$500** — a
negative payment leg, the exact T3 violation R6-B1 eliminated, one coordinate over.
(Economically real: we paid $1,500 against a $1,000 restated total; the counterparty owes
$500 back while still delivering 70.)
**Fix:** state the case-split as INDEPENDENT PER COORDINATE — securities forward (deliver
70) and cash return obligation of settled − restated = $500 (counterparty → us) in the
same correction; all legs positive; work the mixed case in print.

### R7-B2 (nazarov) — matched date is single-source; §8 over-claims detection
LMFP's window ends at the CSD's own asserted matched date, so the LMFP "reconciliation"
checks a CSD number against a CSD number — self-consistency, not reconciliation. §8's
claims ("an inconsistent matched date surfaces as an LMFP check failure"; "corroborated
downstream by settlement") are over-claims: settlement only bounds matched ≤ settled.
Numbers: reality matched Wed (0 late); CSD asserts matched Fri + us-late ⇒ $10,400 paid
that should be $0, and every check reads CLEAN. (regulatory-reporter flagged the same
circularity as a carry; nazarov elevates with the false-charge scenario.)
**Fix:** (1) §8 honesty — the matched date is CSD-asserted, single-source; the identity
self-consistency-checks it, does not verify it; an erroneous late-side assertion is a
NAMED TA-CUSTODY residual, not a detected event (CLAUDE.md §1 — no over-claim). (2) Two
cross-checks from data already on the log: asserted matched-date ≤ recorded settlement
date, else BREAK; and when WE are the charged side, reconcile the CSD's late-side
assertion against our recorded dispatch-intent timestamp (fold row 14) — timely entry on
our record ⇒ BREAK. Residual after both: a CSD inflating the date inside our genuinely-
late window — honest, minimal, named.

### R7-B3 (correctness-architect) — the two penalty windows OVERLAP; correct advice false-BREAKs
R6 runs SEFP over [ISD, settlement] and LMFP over [ISD, matching] — but the regimes are
SEQUENTIAL, split at the matching date (RTS 2018/1229 Art.17 computes SEFP from the LATER
of ISD or matching). Numbers: ISD Wed, matched Fri, settles Mon ⇒ LMFP Thu+Fri $10,400;
the R6 fold ALSO accrues SEFP $5,200 × Thu+Fri = another $10,400 the CSD never charges ⇒
check-3 BREAKs against a CORRECT advice — false-positive-mutes-the-detector, the failure
mode this design retired EXPECTED-DIFF to avoid. §2's "two lines per day where both
apply" asserts the overlap in print.
**Fix:** partition the timeline at the matching date — LMFP over [ISD, matching], SEFP
over [max(ISD, matching), settlement], never overlapping; the fold then matches the
advice. regulatory-reporter pins the exact day convention (inclusive/exclusive endpoints)
in Round 8.

## Non-blocking carries for the .tex (accumulate)
1. (rosetta) State the match-confirmation and bust CDM dispositions in the §8 cross-walk
   (match milestone is CDM-uncarried — TransferStatusEnum has no Matched; bust →
   action=Cancellation + settlement-layer return obligation).
2. (jane-street, sbl's lane) Pin "virtual contra" (external-borrower case) to the loan
   unit's directed leg; state the external case follows the ordinary external-delivery +
   CLM-CO pattern — so the phrase cannot read as a resurrected mirror wallet.
3. (regulatory-reporter) Their honesty sentence re match-confirmation detection is
   SUBSUMED by R7-B2's fix (1) — discharge together.

## Convergence note
R7-B2 and R7-B3 are both completions of the R6-B2 penalty machinery (honest trust-typing;
sequential windows) — one surface, fix together. R7-B1 completes the R6-B1 case-split the
same way R6-B1 completed R5-B2 (totality per coordinate). Nothing contradicts anything
adopted R1–R6. Four APPROVEs already stand on the current text; the three breakers each
declared their item the sole blocker.
