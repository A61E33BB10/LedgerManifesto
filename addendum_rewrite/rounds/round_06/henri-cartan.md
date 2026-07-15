# Round 6 Scorecard — henri-cartan

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Documentation architecture — definitions before use, brief motivation first,
explicit quantifiers, no handwaving, self-contained, layered.

## Grade: A (92%)

## Standing

I awarded A in Rounds 3, 4, and 5 and staked my lens each time. For Round 6 I re-ran the
full one-pass check against the current text with fresh eyes rather than leaning on the
prior verdict, and I confirmed the one dependency my lens rests on that I had not previously
checked at the file level: the included reference listing. The bar still holds.

## Re-verification against the A bar

Target reader: a competent quant engineer who has NOT read the review rounds, one careful
pass.

- **Definitions precede use.** §2 (Notation) fixes every document-local symbol before §3–§13
  consume it: `Map`/`Option`/`NonEmptyList` (lines 109–113);
  `total`/`registration-total`/`append-only`/`monotone carrier` (114–118); the
  `conserved field` enumeration (`accumulated_cost`, `balance`; `hwm`, `entry_nav`
  non-conserved, 120–127); `flat` and `0_P` grounded in `zeroP` (128–131); `StateDelta`
  (132). C2 (256) and C3 (426) consume these with no forward dependency.
- **Motivation first.** Abstract → §1 the question → §3 the answer → §4 per-instrument
  derivation. Each instrument states *why* the keying is forced before naming the condition
  (§4.1 "Why per-(wallet, unit) is forced," 242–246, precedes C1/C11).
- **Explicit, correctly ordered quantifiers** throughout: "for every $u$," "for all but
  finitely many $w$," $\sum_{w\in\mathcal{W}}$, and the empty-sum base case (C9).
- **No handwaving.** C2 discharges its proof obligation by enumerated worked legs (two-leg,
  $K$-leg, VM fan-out, vacuous zero-holder case, 263–270); P3 states the fold-homomorphism
  law explicitly (684–690); no "obvious" / "by similar reasoning."
- **Out-of-order C-labels are signposted** (212–216): labels follow the §6 index, not order
  of appearance; "the first met below is C2"; read as stable tags. The one genuine one-pass
  hazard is neutralised in-text.
- **Signal vocabulary glossed before use.** "signals S1--S4 point to the labelled
  expressibility notes in the reference" (216), ahead of the first consuming parenthetical at
  C11 (314). I verified the referents exist: `reference/StatesHome.hs` carries the `[S1]`–
  `[S4]` notes (lines 448, 462, 469, 478) and the `_c11_ok_*` / commented `_c11_bad`
  examples (437–443) the prose cites. The included listing makes the references resolvable on
  the page, so self-containment holds.
- **Layered.** §13 one-sentence answer and the abstract serve the casual reader; the §4
  derivation, §6 index, §9 forcing-reasons, §10 unrepresentability mechanisms, and the §12
  Haskell reference serve the specialist.
- **Correctness preserved.** Every claim is proved in-line, made structural by the encoding
  (§12 maps each C-condition to a constructor), or precisely deferred to a labelled external
  citation (v10.3 §11). The apparent `balance` redundancy (120–127 vs 203–205) is
  load-bearing — the demonstrative second conserved field exercising C11's distinct-writer
  discipline — and is explicitly flagged as not an economic datum.

## Non-blocking observations (carried; none reaches the A bar)

1. **P2, P4, P8 are never named** (abstract 59 "seven of the ten"; §10 706 "no other design
   makes more than three of the ten"). The three merely-tested invariants are not
   enumerated. Their canonical statements live in v10.3 §11, the parent of this addendum, so
   self-containment holds relative to that parent and naming them is unnecessary for
   comprehension of StatesHome. Non-blocking.
2. **"refinement type" unglossed** (§4.1, 251). Intent — a type enforcing the sum-zero
   constraint — is carried by the immediate context ("a refinement type on a sum of decimals
   is not free in any production language"). Acceptable.

## Verdict

Deductive order is clean, notation is fixed before use, quantifiers are explicit and
correctly ordered, the proofs do not handwave, the included reference resolves the S1–S4
signals and C11 examples on the page, and the layering serves both casual and specialist
readers. No blocking issue remains on my lens. This clears the A bar for documentation
architecture, and I stake my lens on it.
