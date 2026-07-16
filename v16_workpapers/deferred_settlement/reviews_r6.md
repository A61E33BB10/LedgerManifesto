# Round 6 Reviews — on candidate_r5.md (convergence attempt #2: NOT converged)

Tally: 3 APPROVE (rosetta-cdm, nazarov, jane-street-cto), 4 BREAK — collapsing to THREE
mechanisms, because correctness-architect and sbl-specialist independently found the SAME
defect with the same numbers (R6-B3). All R5 items across all seven reviewers RESOLVED.
The three approvers each red-teamed fresh surfaces and found nothing breaking.

## BREAKS

### R6-B1 (minsky) — the restated Binding is not total below settled mass
successor = restated − settled goes ill-typed when a correction lands BELOW already-settled
quantity (routine trade-bust-after-partial). Numbers: buy 100 @$50; 30-clip settles; bust ⇒
restated = 0 ⇒ successor = 0 − 30 = **−30**: a negative directed leg (T3 forbids). The
identity accidentally reads r=0 (predicted depot = 0−(−30) = 30 = statement), which MASKS
the real state — owned = 0 while 30 shares sit in depot owed back — and the fails-cascade,
penalty fold, and buy-in binding, all keyed on leg direction, mis-route.
**Fix (doctrine-compatible case-split):** restated ≥ settled → forward successor (current
formula); restated < settled → mint an OPPOSITE-DIRECTION return obligation of
(settled − restated); settled mass stays terminal, unwound forward by a new
positive-directed leg, never a negative one.

### R6-B2 (regulatory-reporter) — penalty fold models only ONE of CSDR's two daily penalties
N5 models the SEFP (RTS 2018/1229 Art.17, unsettled qty over [ISD, settlement]) but not the
LMFP (Art.16, on the late-matching party, over [ISD, matching date], instruction quantity).
The lifecycle has no *matched* milestone; row 14 covers dispatch/cancel, not the CSD match
confirmation. An LMFP line on semt.044 has no fold counterpart ⇒ check 3 false-BREAKs on
EVERY late-matched instruction and row 16 under-books. Numbers: 1,000,000 sh, ISD Wed,
matched Fri (2 bd late), ref $52.00, 1.0 bp/day ⇒ LMFP = $10,400 missing from our fold.
**Fix (carries, no redesign):** record the matching event (matched date + late-matching
side) as an N1-family witness sibling to the dispatch receipt; extend the fold + the three
decidable checks + row 16 to both SEFP [ISD, settlement] and LMFP [ISD, matching]. Until
then DS14 cannot claim the full regime.

### R6-B3 (sbl-specialist AND correctness-architect, independently, same numbers) — A″ is single-sided
The terminal close-out write-off reconciles only the LENDER. The claim (CLM-CO) is
cash-denominated; 1,000,000 SIGMA cannot conserve into a cash claim — conservation is per
(unit, coordinate). The defaulted borrower still physically holds the shares (A′'s own
setup: statement a_B depot = 1,000,000); with RU-1 extinguished and nothing booked on w_B,
predicted a_B = 0 vs statement 1,000,000 ⇒ **r = +1,000,000 BREAK on the borrower,
permanent**; SIGMA Σ = 0+0 vs 1,000,000 real shares — the lender's −1M write-off is
unpaired (door must refuse) or sunk wrongly.
**Fix:** the mini close-out books the borrower-side owned(SIGMA) 0 → +1,000,000 (the
defaulter keeps the securities it failed to return), PAIRED with the lender write-off, so
a_B reconciles CLEAN and Σ=0 holds on the SIGMA coordinate; A″ shown BOTH-SIDED like A′.

## Non-blocking carries for the .tex (accumulate; do not lose)
1. (nazarov) Pin check-2's reconciled close to the SECR-DESIGNATED reference source, so the
   de-minimis tolerance is achievable and never a widened band.
2. (regulatory-reporter) The governed tolerance in check 2 must be sized to absorb genuine
   multi-venue dispersion (CSDR reference = most-relevant-market close, RTS Art.17) — same
   surface as carry 1; resolve together.
3. (jane-street) The composition property must GENERATE the price-change-on-settled-mass
   case (restate 90@$49 over 30 settled @$50), not only quantity changes — clean
   reconciliation there rests on both sides netting settled mass identically.

## Convergence note
R6-B1 completes the Terminality/Binding doctrine below settled mass (the R5-B2 formula's
missing branch). R6-B2 is a witness-kind + window extension inside the adopted penalty
architecture. R6-B3 is the A′ both-sidedness rule applied to A″ — two reviewers, one fix.
No item contradicts anything adopted R1–R5; all three are completions, not redesigns.
