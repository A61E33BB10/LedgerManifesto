# Round 2 Scorecard — henri-cartan

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Documentation architecture — definitions before use, brief motivation first,
explicit quantifiers, no handwaving, self-contained, layered.

## Grade: B (89%)

## Round 1 → Round 2: all six of my blocking issues resolved

1. **"$(w,u)$ lattice"** — gone. P5 now reads "a single $(w,u)$-keyed row" (line 679).
   Resolved.
2. **`StateDelta` used before characterised** — now in the §2 notation table (line 130,
   "the change one event proposes, for a single unit, across the three maps;
   conservation-checked and atomic, C2/C3"). C2 (line 247) and C3 (line 416) no longer
   depend on a forward reference. Resolved.
3. **Conserved-field set never enumerated** — §2 now defines the predicate and enumerates:
   conserved = `accumulated_cost`, `balance`; non-conserved = `hwm`, `entry_nav`
   (lines 122–124). The universal quantifier in C2 and the definition of $0_P$ are now
   evaluable. Resolved.
4. **Condition numbering out of reading order, no signpost** — §4 now opens with an
   orientation paragraph (lines 205–209): C1–C12 are stable labels indexed in §6, not
   appearance order; first met is C2; read as tags. Resolved.
5. **$0_P$ notation forward-referenced "first-touch"/"held-and-flat"** — §2 now defines
   `flat` locally and grounds $0_P$ in `zeroP` (lines 125–128) without leaning on §4 terms.
   Resolved.
6. **Pareto scores without a rubric** — §8 intro (lines 614–616) names the scorer (the
   adversarial multi-agent review), frames the 0–10 figures as ordinal/relative judgments,
   marks correctness as the gate axis, and states the per-design forcing reason carries the
   argument. Resolved.

The architecture remains exemplary for my lens: motivation precedes mechanism (abstract →
§1 question → §3 answer → §4 derivation); notation fixed before use and split into framework
vs. document-local; conditions introduced where forced and collected in an index (§5);
genuine layering (one-sentence answer §13 / abstract for casual readers, full derivation +
Haskell reference for specialists); quantifiers explicit and correctly ordered.

## Blocking issues

1. **Dangling notation: Kleisli category and the `>=>` operator, undefined at first use
   (§9, P3, lines 676–677).** P3's gloss reads: "the monotone carrier (C1(b)) makes replay a
   Kleisli fold: `replay (xs <> ys) = replay xs >=> replay ys` in the `Either LedgerError`
   Kleisli category." The term "Kleisli category" and the operator `>=>` appear nowhere else
   in the prose and are never defined. This sits in a prose section (Invariants Made
   Unrepresentable), not the reference-implementation section, so the "code context excuses
   the jargon" defence does not apply. For the stated target reader — a competent quant
   engineer who has not read the review rounds — this trips a one-pass read on the one
   place the document states a replay law. The plain-English takeaway ("checkpoint-
   independence is a consequence of this law") does survive, which keeps this minor, but it
   is a genuine instance of the dangling-notation anti-pattern.
   *Fix:* gloss `>=>` at first use (monadic/Kleisli composition, short-circuiting on
   `Left`), or state the law in plain terms — "replaying a concatenation equals replaying
   each segment in sequence, short-circuiting on the first error" — and keep the formal line
   as the precise statement.

## Non-blocking observations

- **P2, P4, P8 never named (§9, lines 660, 694; abstract line 59).** The abstract and §9 both
  say "seven of the ten" invariants are made unrepresentable and §9 closes "No other
  candidate design makes more than three of the ten." The three that remain merely tested are
  never named, nor is the reason they stay tested given. Comprehension of StatesHome does not
  require them, so this is not blocking, but one sentence accounting for P2/P4/P8 would close
  the last self-containment seam. (Carried from Round 1; still open.)
- **"refinement type" unglossed (§4.1, line 244).** "a refinement type on a sum of decimals
  is not free in any production language." The intent (a type enforcing the sum constraint)
  is conveyed by context, so this is acceptable, but it is a second specialized term used
  without definition in prose.
- **`StateDelta` (prose) vs `ValidDelta` (reference) seam.** §9/§12 bridge the two names;
  acceptable, but the naming change across sections still costs the reader a small
  reconciliation.

## Verdict

This is a near-A document for documentation architecture: every Round 1 defect is fixed, the
deductive order is clean, and the layering genuinely serves both the casual and the
specialist reader. It is held off A by one dangling-notation defect (`>=>` / Kleisli in §9
P3). Fixing that single gloss would, on my lens, take it to A.
