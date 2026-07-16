# Round 5 Reviews — on candidate_r4.md (convergence round: NOT converged)

Tally: 1 APPROVE (jane-street-cto), 6 BREAK. All R4 items across all seven reviewers
RESOLVED. **TA-scoping ruled UNANIMOUSLY 7/7: UMBRELLA** — semt.044 + dispatch/cancel
receipts ride under TA-CUSTODY; no sixth named TA. Governing reason (jane-street's
formulation, echoed by all): a new named assumption is earned by a different PROPOSITION,
never a different publisher or message family. Caveats that MUST appear in TA-CUSTODY's
four-part text (not swept in):
- Enumerate the asserter classes explicitly: balance statement / penalty advice / emission
  receipt (correctness-architect).
- Flag the dispatch receipt as an INTERNAL-EGRESS witness (our gateway attesting our own
  send) whose detection is indirect — only the downstream settlement identity surfaces a
  lie (nazarov).
- semt.044's distinct detection stays named under the umbrella: penalty-reconciliation
  identity, appeal supersession — never collapsed into "same as custody" (sbl-specialist).

## BREAKS (each declared its reviewer's SOLE blocker)

### R5-B1 (regulatory-reporter) — penalty CASH SETTLEMENT has no fold row
The CSD nets penalties monthly at participant level and debits/credits the nostro as one
net cash amount with no settlement-obligation leg behind it. Numbers: $26,000 collection
hits camt.053; predicted(owned + in-flight) unchanged ⇒ r = −$26,000 BREAK, recurring
every cycle, bidirectional (credit side breaks r > 0). The exact "external cash movement
with no recorded internal counterpart" defect, one regime over.
**Fix:** a fold row booking the reconciled penalty as a recorded owned(USD) charge /
receivable (or a payable coordinate the identity excludes until settled), settled on the
collection date so predicted tracks camt.053 and r stays 0.

### R5-B2 (correctness-architect) — partial × re-instruction composition double-counts settled mass
Buy 100, auto-partial 30 settles (SO-1s settled / SO-1r residual, CLEAN). Then correction
to restated 90 ⇒ mandatory re-instruction; the literal Binding derives the successor from
Q′=90 ⇒ predicted depot 0 vs statement 30 → r=+30; nostro r=−$1,500 — the settled 30
double-counted.
**Fix (one clause):** successor legs = restated total NET of mass already settled under
the cancelled reference (90−30=60); retire only the residual SO-1r, never the settled
SO-1s; add a conservation property over the partial-then-reinstruct COMPOSITION. General
rule: first-class lifecycle mechanisms must be property-tested in composition, not singly.

### R5-B3 (minsky) — live(ref) keyed on the wrong event (send/receipt gap)
The dispatch RECEIPT is recorded after the external send. A correction arriving in the gap
(send 09:00:00.000, receipt 09:00:00.400, correction 09:00:00.200) reads live=FALSE, takes
the Correction branch, in-place amends to 90 — while REF-001 is live at the CSD for 100.
CSD settles 100 ⇒ r=+10 / −$500 permanent: R4-B2's exact break through the gap. Fails
"unrepresentable, not merely unlikely."
**Fix:** key live(ref) on a DISPATCH-INTENT fact recorded through the door BEFORE the send
— the egress dual of witness-before-signal (same reasoning §5 already uses to gate
amendment emission on the recorded cancel confirmation).

### R5-B4 (nazarov) — EXPECTED-DIFF is an ungoverned band; retire it
EXPECTED-DIFF accepts differences "within declared tolerance" explained by NO named
quantity, on an ungoverned band, using an un-attested reference price. Numbers: semt.044
asserts ref $52.00 but amount $3,100 (its own arithmetic gives $2,600 — a $500 overcharge);
vs our $2,575 expectation the $525 diff sits inside any band wide enough for the genuine
$25 convention diff ⇒ silent payment. B2's masks-a-real-loss backdoor, one regime over.
**Fix:** (a) a DECIDABLE arithmetic check on semt.044's own carried fields (qty ×
its-reference-price × rate = its-amount → CLEAN/BREAK); (b) the CSD reference price
crosses the door as ATTESTED data reconciled against our recorded close under a GOVERNED
de-minimis tolerance (B2 discipline: named owner + audit trail). Retire EXPECTED-DIFF as
a fuzzy class.

### R5-B5 (rosetta-cdm) — emission status and CDM trade-event action are orthogonal axes
N6 binds "no live ref → CDM Correction" / "live ref → Amendment (terminate+new)". Wrong:
CDM's action axis is trade-level economic INTENT; emission status is settlement-layer.
Counterexample: booking error discovered after dispatch ⇒ live=true ⇒ N6 files terminate +
new BusinessEvent — two TR lifecycle events where the regime expects ONE Correction, and
the audit record falsely says a 100-trade existed. Mirror: genuine pre-dispatch amendment
gets labelled Correction.
**Fix:** decouple. Emission status stays the SETTLEMENT-layer mechanism (undispatched →
fix in place; dispatched → cancel + re-instruct; cancel-confirmation ≈ CDM
action=Cancellation on the instruction). The CDM trade-event action (Correct vs
New/QuantityChange) is a separate axis driven by economic intent. A booking error on a
dispatched instruction is BOTH. Relabel N6's two forms as settlement mechanisms, not CDM
event classes.

### R5-B6 (sbl-specialist) — terminally-failed RETURN has no owned-plane write-off; DS9 over-claimed
Agency loan 1,000,000 SIGMA (owned 1M / lent_out 1M / depot 0). Recall → RU-1; borrower
TERMINALLY fails (most SBL fails are on returns); loan closes against collateral (GMSLA
9.3 mini close-out). RU-1 is extinguished but owned(SIGMA) stays 1,000,000 vs depot 0 ⇒
r = −1,000,000 permanent REAL break. Buy-in variant worse: owned → 2,000,000 vs depot
1,000,000 ⇒ r = −1M plus a double-long mismark. N4's "no second long" is owned-neutral on
the TRADE plane only; it does not carry to the possession plane.
**Fix:** specify the possession-plane write-off in N7 (owned −1M when a recalled loan
terminally fails and closes against collateral/compensation), OR route the terminal
failed-return to §9 close-out AND downgrade DS9 from "completed by N4" to ROUTED. The
current DS9 text narrows the guarantee (CLAUDE.md §1) — fix or downgrade honestly, never
leave as-is.

## APPROVE residual (jane-street — non-blocking, fold in now)
N6 amendment path: settlement can win the race against the emitted cancel. A settlement
confirmation on a unit with a pending cancellation resolves in SETTLEMENT'S favour (DS7,
terminal); the correction re-routes to a post-settlement adjustment (new compensating
trade), never a hung amendment waiting on a cancel confirmation that will never come.
(Identity stays sound throughout — no false break; the stall is M7-visible. One sentence.)
Note: composes with R5-B2 — both are settlement-racing-the-correction cases; one doctrine
should cover both (settled mass is terminal and always netted/respected).

## Convergence note
R5-B1+R5-B4 are one penalty-regime completion (cash leg + decidable checks). R5-B2 +
jane-street's residual are one doctrine (settled mass is terminal; successors net it).
R5-B3 is a one-line re-keying of live(ref). R5-B5 is a relabel + one added axis. R5-B6 is
the one genuinely new mechanism (possession-plane write-off or honest routing to §9).
Nothing contradicts anything adopted in R1–R4.
