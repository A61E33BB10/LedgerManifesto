# Round 5 Scorecard — henri-cartan

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Documentation architecture — definitions before use, brief motivation first,
explicit quantifiers, no handwaving, self-contained, layered.

## Grade: A (92%)

## Standing

I awarded A (91%) in Rounds 3 and 4 and staked my lens both times, having confirmed every
Round 1 and Round 2 blocking defect closed. I re-ran the full one-pass check on the Round 5
text with fresh eyes rather than leaning on the prior verdict. The bar still holds, and one
carried non-blocking seam has been closed since Round 4, so I nudge to 92%.

## What improved since Round 4

- **"signal S1–S4" vocabulary now glossed before use.** The §4 orientation paragraph
  (line 218) reads: "Parenthetical references to signals S1--S4 point to the labelled
  expressibility notes in the reference (§\ref{sec:reference})." This defines the term
  "signal" and locates S1–S4 at first mention in the body, ahead of the first consuming
  parenthetical at C11 (line 314). This was carried non-blocking item #1 in Rounds 3 and 4;
  it is now resolved. The dangling-vocabulary seam is closed.

## Re-verification against the A bar

Target reader: a competent quant engineer who has NOT read the review rounds, one careful
pass.

- **Definitions precede use.** §2 (Notation) fixes every document-local symbol before
  §3–§13 consume it: `Map`/`Option`/`NonEmptyList` (lines 109–113);
  `total`/`registration-total`/`append-only`/`monotone carrier` (114–118); the
  `conserved field` enumeration `accumulated_cost`, `balance` with `hwm`, `entry_nav`
  non-conserved (120–127); `flat` and `0_P` grounded in `zeroP` (128–131); `StateDelta`
  (132). C2 (line 256) and C3 (line 426) consume these with no forward dependency.
- **Motivation first.** Abstract → §1 the question → §3 the answer → §4 the per-instrument
  derivation. Each instrument states *why* the keying is forced before naming the condition
  (§4.1 "Why per-(wallet, unit) is forced," lines 244–248, precedes C1/C11).
- **Explicit, correctly ordered quantifiers** throughout: "for every $u$," "for all but
  finitely many $w$," $\sum_{w\in\mathcal{W}}$, the empty-sum base case (C9).
- **No handwaving.** C2 discharges its proof obligation by enumerated worked legs (two-leg,
  $K$-leg, VM fan-out, vacuous zero-holder case, lines 263–272); no "obvious" / "by similar
  reasoning."
- **Out-of-order C-labels are signposted** (lines 212–218): labels follow the §6 index, not
  appearance order; "the first condition met below is C2"; read as tags. The one genuine
  one-pass hazard is neutralised in-text.
- **Layered.** §13 one-sentence answer and the abstract serve the casual reader; the §4
  derivation, §6 condition index, §9 forcing-reasons, §10 unrepresentability mechanisms,
  and the §12 Haskell reference serve the specialist.
- **Correctness preserved.** Every claim is proved in-line (C2 legs), made structural by the
  encoding (§12 maps each C-condition to a constructor; the reference carries the `[S1]`–
  `[S4]` notes), or precisely deferred to a labelled external citation (v10.3 §11). The
  apparent `balance` redundancy (120–127 vs 203–205) is load-bearing — the demonstrative
  second conserved field exercising C11's distinct-writer discipline — and is explicitly
  flagged as not an economic datum.

## Non-blocking observations (carried; none reaches the A bar)

1. **P2, P4, P8 are never named** (abstract line 59 "seven of the ten"; §10 line 708 "no
   other design makes more than three of the ten"). The three merely-tested invariants are
   not enumerated. Their canonical statements live in v10.3 §11, the parent document, so
   self-containment holds relative to that parent; naming them is unnecessary for
   comprehension of StatesHome. Non-blocking.
2. **"refinement type" unglossed** (§4.1, line 253). Intent — a type enforcing the sum-zero
   constraint — is carried by the immediate context "a refinement type on a sum of decimals
   is not free in any production language." Acceptable.

## Verdict

Deductive order is clean, notation is fixed before use, quantifiers are explicit and
correctly ordered, the proofs do not handwave, the layering serves both casual and
specialist readers, and the one remaining vocabulary seam (S1–S4) from prior rounds is now
closed. No blocking issue remains on my lens. This clears the A bar for documentation
architecture, and I stake my lens on it.
