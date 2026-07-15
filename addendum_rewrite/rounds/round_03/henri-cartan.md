# Round 3 Scorecard — henri-cartan

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Documentation architecture — definitions before use, brief motivation first,
explicit quantifiers, no handwaving, self-contained, layered.

## Grade: A (91%)

## Round 2 → Round 3: the single blocking issue is resolved

My Round 2 grade (B, 89%) rested on exactly one blocking defect, and I committed on the
record that fixing it would take the document to A on my lens. It is fixed:

- **§10 P3 dangling notation (`>=>` / "Kleisli category").** The undefined term "Kleisli
  category" is gone. P3 now reads "the monotone carrier (C1(b)) makes replay a *fold
  homomorphism*: `replay (xs <> ys) = replay xs >=> replay ys`, where `f >=> g` is the
  composition that runs the error-returning step `f`, feeds its result to `g`, and stops at
  the first error" (lines 682–688). Both operators are now glossed in plain prose: `>=>`
  explicitly, and `<>` by the immediately following sentence "Replaying a concatenated log
  equals replaying each part and composing the two." The named term "fold homomorphism" is
  introduced then explained in the next clause (term-then-gloss). No undefined symbol
  survives in the one place the document states a replay law. Resolved.

## Why this clears the A bar

For the stated target reader — a competent quant engineer who has not read the review
rounds — the document is comprehensible in one careful pass within my domain:

- **Definitions precede use.** §2 fixes every document-local symbol before §3–§10 consume
  it; `StateDelta` is in the notation table (line 132); the conserved-field set is
  enumerated (lines 122–127); $0_P$ is grounded in `zeroP` with `flat` defined locally.
- **Motivation first.** Abstract → §1 question → §3 answer → §4 derivation; each instrument
  states why it forces a condition before the condition is stated.
- **Explicit, correctly ordered quantifiers** throughout ("for every $u$", "for all but
  finitely many $w$", $\sum_{w\in\mathcal{W}}$).
- **No handwaving.** C2 discharges its proof obligation by enumerated worked legs
  (two-leg, $K$-leg, VM fan-out, vacuous case); no "obvious"/"similar reasoning."
- **Layered.** One-sentence answer (§13) and abstract for the casual reader; full
  derivation, condition index (§6), and Haskell reference for the specialist.
- **Out-of-order C-labels are signposted** (lines 212–216), neutralising the one-pass
  hazard of meeting C2 before C1.

Correctness is preserved: every claim is either proved in-line (C2 legs), made structural
by the encoding (§12 bullet list mapping C-conditions to constructors), or precisely
deferred to a labelled external reference. Nothing in the prose is cuttable without loss;
the apparent redundancy on `balance` (lines 122–127 and 203–205) is load-bearing — it is
the demonstrative second conserved field that exercises C11's distinct-writer discipline.

## Non-blocking observations (carried, none reaches the A bar)

1. **"signal S1–S4" is review-process jargon (8 occurrences; first at line 434).** The word
   "signal" is never defined in prose, and S1–S4 are defined only as `[S1]`–`[S4]` comments
   inside the included `reference/StatesHome.hs`. This is acceptable as a precise internal
   reference — exactly parallel to the v10.3 §11 citations — because in every case the
   substantive claim is fully stated in the surrounding prose and the parenthetical is a
   pointer, not load-bearing for comprehension. A one-line note in §10 or §11 saying "S1–S4
   are the labelled design notes in the reference listing" would close the seam, but its
   absence does not trip a one-pass read.

2. **P2, P4, P8 are never named (abstract line 59; §10 line 704).** The document says "seven
   of the ten" are made unrepresentable and "no other design makes more than three of the
   ten," but the three that remain merely tested are not named, nor is the reason. One
   sentence would close the last self-containment seam. Comprehension of StatesHome does not
   require it; non-blocking, carried from Rounds 1–2.

3. **"refinement type" unglossed (§4.1, line 251).** The intent (a type enforcing the
   sum-zero constraint) is carried by context. Acceptable.

## Verdict

Every Round 1 and Round 2 blocking defect on my lens is closed. The deductive order is
clean, notation is fixed before use, quantifiers are explicit, the proofs do not handwave,
and the layering genuinely serves both casual and specialist readers. I stake my lens on
this: it is an A for documentation architecture. The residual items are cosmetic
self-containment seams, not comprehension barriers.
