# Round 8 Scorecard — henri-cartan

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Documentation architecture — definitions before use, brief motivation first,
explicit quantifiers, no handwaving, self-contained, layered.

## Grade: A (92%)

## Standing

I awarded A in Rounds 3–7 and staked my lens each time. For Round 8 I re-ran the full
one-pass check with fresh eyes against the current text rather than leaning on the prior
verdict, and re-confirmed at the file level the one external dependency my lens rests on —
the included reference listing `reference/StatesHome.hs`. The bar holds.

## Re-verification against the A bar

Target reader: a competent quant engineer who has NOT read the review rounds, one careful
pass.

- **Definitions precede use.** §2 (Notation) fixes every document-local symbol before §3–§13
  consume it: `W`/`U`/`h(w,u)` and the conservation law (101–107); `Map`/`Option`/
  `NonEmptyList` (109–113); `total`/`registration-total`/`append-only`/`monotone carrier`
  (114–118); `Delta f(w,u)` (120–121); the `conserved field` enumeration (122–127);
  `flat`/`0_P` grounded in `zeroP` (128–131); `StateDelta` (132). C2 (254) and C3 (424)
  consume these with no forward dependency on a definition.
- **Motivation first.** Abstract → §1 the question → §3 the answer → §4 the per-instrument
  derivation. Each instrument states *why* the keying is forced before naming the condition
  ("Why per-(wallet, unit) is forced," 242–246, precedes C1/C11).
- **Explicit, correctly ordered quantifiers** throughout: "for every $u$," "for all but
  finitely many $w$," `\sum_{w\in\mathcal{W}}`, the empty-sum base case (C9, 483–488).
- **No handwaving.** C2 discharges its proof obligation by enumerated worked legs — two-leg,
  $K$-leg, VM fan-out, vacuous zero-holder (263–270); P3 states the fold-homomorphism law
  explicitly with `>=>` defined inline (684–690); no "obvious" / "by similar reasoning."
- **Out-of-order C-labels are signposted** (212–216): labels follow the §6 index, not order
  of appearance; "the first met below is C2"; read as stable tags. The one genuine one-pass
  hazard is neutralised in-text.
- **Signal vocabulary glossed before use and resolvable on the page.** Line 216 defines what
  S1–S4 are and locates them in the reference (§12), ahead of the first consuming
  parenthetical at C11 (312). I re-verified the referents exist in the included listing:
  `reference/StatesHome.hs` carries the `[S1]`–`[S4]` notes (lines 448, 462, 469, 478) and
  the `_c11_ok_*` / commented `_c11_bad` examples (437–443) the prose cites. The
  `lstinputlisting` (818) makes the citations resolve on the page; self-containment holds.
- **Layered.** §13 one-sentence answer and the abstract serve the casual reader; the §4
  derivation, §6 index, §9 forcing-reasons, §10 unrepresentability mechanisms, and the §12
  Haskell reference serve the specialist.
- **Correctness preserved.** Every claim is proved in-line, made structural by the encoding
  (§12 maps each C-condition to a constructor), or precisely deferred to a labelled external
  citation (v10.3 §11). §10 names exactly seven invariants (P1, P3, P5, P6, P7, P9, P10),
  consistent with the abstract's "seven of the ten." The apparent `balance` redundancy
  (122–127 vs 203–205 vs 826) is load-bearing — the demonstrative second conserved field
  exercising C11's distinct-writer discipline — and is explicitly flagged as not an economic
  datum at every occurrence.

## Non-blocking observations (carried; none reaches the A bar)

1. **P2, P4, P8 are never named** (abstract 59 "seven of the ten"; §10 706 "no other design
   makes more than three of the ten"). The three merely-tested invariants are not
   enumerated. Their canonical statements live in v10.3 §11, the parent of this addendum, so
   self-containment holds relative to that parent; naming them is unnecessary for
   comprehension of StatesHome. Non-blocking.
2. **"refinement type" unglossed** (§4.1, 251). Intent — a type enforcing the sum-zero
   constraint — is carried by the immediate context ("a refinement type on a sum of decimals
   is not free in any production language"). Acceptable.
3. **`C11` forward-referenced in the notation table** (124), before its definition (305) and
   before the C-label signpost (212–216). It sits inside the deliberately demonstrative
   `balance` parenthetical; the phrase "per-field-writer discipline" carries the meaning, and
   the tag is a forward pointer, not a load-bearing term. Minor friction, non-blocking.
4. **"registered" used before registration is formalised** (115; formalised at C7/C10). The
   plain-English reading suffices on first pass. Non-blocking.

These four are exactly the residual friction points that keep the score a clear A rather
than higher; none impedes a careful one-pass comprehension.

## Verdict

Deductive order is clean, notation is fixed before use, quantifiers are explicit and
correctly ordered, the proofs do not handwave, the included reference resolves the S1–S4
signals and C11 examples on the page, and the layering serves both casual and specialist
readers. No blocking issue remains on my lens. This clears the A bar for documentation
architecture, and I stake my lens on it.
