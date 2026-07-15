# Round 4 Scorecard — henri-cartan

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Documentation architecture — definitions before use, brief motivation first,
explicit quantifiers, no handwaving, self-contained, layered.

## Grade: A (91%)

## Standing

In Round 3 I awarded A (91%) and staked my lens on it, having confirmed every Round 1 and
Round 2 blocking defect closed. The Round 4 text is materially the same document; I re-ran
the full one-pass check against my bar with fresh eyes rather than relying on the prior
verdict. The bar still holds. I confirm A and re-stake my lens.

## Re-verification against the A bar (one careful pass, target reader: competent quant
## engineer who has NOT read the review rounds)

- **Definitions precede use.** §2 (Notation) fixes every document-local symbol before
  §3–§13 consume it: `Map`/`Option`/`NonEmptyList` (lines 109–113), `total`/
  `registration-total`/`append-only`/`monotone carrier` (114–118), the `conserved field`
  predicate with its full enumeration `accumulated_cost`, `balance` and the non-conserved
  `hwm`, `entry_nav` (122–127), `flat` and `0_P` grounded in `zeroP` (128–131), `StateDelta`
  (132). C2 (line 254) and C3 (line 423) consume these without forward dependency.
- **Motivation first.** Abstract → §1 the question → §3 the answer → §4 the per-instrument
  derivation. Each instrument states *why* per-(w,u) keying is forced before naming the
  condition (e.g. §4.1 "Why per-(wallet, unit) is forced," lines 242–246, precedes C1/C11).
- **Explicit, correctly ordered quantifiers** throughout: "for every $u$," "for all but
  finitely many $w$," $\sum_{w\in\mathcal{W}}$, the empty-sum base case (C9).
- **No handwaving.** C2 discharges its proof obligation by enumerated worked legs (two-leg,
  $K$-leg, VM fan-out, vacuous zero-holder case, lines 261–270); no "obvious" / "by similar
  reasoning."
- **Out-of-order C-labels are signposted** (lines 212–216): labels follow the §6 index, not
  appearance order; "the first condition met below is C2"; read as tags. The one genuine
  one-pass hazard is neutralised in-text.
- **Layered.** §13 one-sentence answer and the abstract serve the casual reader; the §4
  derivation, the §6 condition index, the §9 forcing-reasons, §10 unrepresentability
  mechanisms, and the §12 Haskell reference serve the specialist.
- **Correctness preserved.** Every claim is proved in-line (C2 legs), made structural by the
  encoding (§12 bullet list maps each C-condition to a constructor and the reference carries
  `[S1]`–`[S4]` design notes at lines 448/462/469/478), or precisely deferred to a labelled
  external citation (v10.3 §11). The apparent `balance` redundancy (122–127 vs 203–205) is
  load-bearing: it is the demonstrative second conserved field that exercises C11's
  distinct-writer discipline, and is explicitly flagged as not an economic datum.

## Non-blocking observations (carried from Round 3; none reaches the A bar)

1. **"signal S1–S4" is review-process vocabulary; the word "signal" is not defined in
   prose** (8 occurrences, first at line 311; also 434, 503, 674, 681, 698, 701, 807). The
   `S1`–`S4` notes do exist as labelled comments in `reference/StatesHome.hs` (lines
   448–478), so each prose pointer resolves. In every case the substantive claim is stated
   in full in the surrounding prose and the parenthetical is a pointer, not load-bearing for
   comprehension — exactly parallel to the v10.3 §11 citations. A one-line gloss ("S1–S4 are
   the labelled design notes in the §12 listing") would close the seam, but its absence does
   not trip a one-pass read.
2. **P2, P4, P8 are never named** (abstract line 59 "seven of the ten"; §10 line 704 "no
   other design makes more than three of the ten"). The three merely-tested invariants are
   not enumerated. Their canonical statements live in v10.3 §11, the parent document, so
   self-containment is satisfied relative to that parent; naming them is unnecessary for
   comprehension of StatesHome. Non-blocking.
3. **"refinement type" unglossed** (§4.1, line 251). Intent (a type enforcing the sum-zero
   constraint) is carried by the immediate context "a refinement type on a sum of decimals
   is not free in any production language." Acceptable.

## Verdict

Deductive order is clean, notation is fixed before use, quantifiers are explicit and
correctly ordered, the proofs do not handwave, and the layering genuinely serves both
casual and specialist readers. The residual items are cosmetic self-containment seams, not
comprehension barriers. This clears the A bar for documentation architecture, and I stake
my lens on it.
