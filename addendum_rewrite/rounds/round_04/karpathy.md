# Round 4 — KARPATHY scorecard

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** The one-pass test. Can the target reader (a competent quant engineer who has NOT
read the 27 review rounds) read each section once, top to bottom, without backtracking?
Linear flow, self-documenting, nothing cryptic in my domain, nothing cuttable without loss.

**Grade: A (92%)**

I stake my lens on this. The document passes the one-pass test, and Round 4 introduced no
friction on my axis.

---

## Round-4 change verified on my lens

Round 4 made exactly one targeted edit (milewski's lens — type correctness of the migration
alias). I read it in context and checked for one-pass regressions:

- **§9 migration alias** (lines 610–612). Now reads: "`get_unit_state(u)` remains a
  deprecated alias for the pair `(product_terms(u), unit_status(u))`; the
  `get_unit_state(w,u)` of line 2287 maps to `position_state(w,u)`." The prior form wrote
  `product_terms(u) ++ unit_status(u)`, which a careful reader would stall on (`++` is list
  concatenation, but these accessors return two distinct `Maybe`-wrapped record types). The
  pair form is type-correct against the reference accessors (`StatesHome.hs` 381–385) and
  expresses the same "old single unit-state now split across two maps" intent. This is a net
  *improvement* on my axis: a one-pass reader no longer hits a spurious type pause. No new
  term, no new forward-reference, no new backtrack reflex.

No other line of the document changed since Round 3.

---

## My blockers — all still cleared (re-confirmed on a fresh pass)

- **P3 fold identity, `>=>` glossed** (lines 681–688). `f >=> g` is named at first use as the
  error-returning composition that stops at the first error; the law is restated in plain
  words. Reads in one pass; the precise Haskell term stays in the reference for its literate
  reader. Correct prose/reference split.
- **Out-of-order condition numbering** (§4 intro, lines 212–216). The orientation that
  C1–C12 are tags indexed in §5, first met is C2, read as tags not a sequence, pre-empts the
  "did I skip C1?" reflex.
- **`∑_w h`-style conservation** (§4.1, line 249). "conservation as defined for `h` extends
  to it, `∑ ac(w,u)=0`." The hyphenated coinage is gone.

---

## Cross-checked one-pass health of the rest

- Result-first spine intact: Question → Answer → four instruments → why-three →
  alternatives → invariants → reference → one-sentence answer. No mental jumping between
  sections.
- Every load-bearing term defined before use: `StateDelta`, `0_P`/flat, conserved field,
  registration-total, monotone carrier, Option/Some/None — all in the §2 notation table.
- C11 vs C2 two-axis disambiguation (lines 311–315) holds; the
  authorship-then-erased caveat is consistent across C11, P10, the §10 P3 bullet, and the
  §11 intro. No type-vs-value over-claim.
- Signal pointers (`§reference, signal S1/S2/S3/S4`) are explicit, named forward-references
  that resolve to clearly-labelled `[S1]`..`[S4]` blocks in `StatesHome.hs` (lines 448–482).
  They read as "where this is encoded" pointers, not as gating tokens. No one-pass stall.
- Pareto table framed as ordinal judgments by a named scorer; the per-design forcing reason
  carries the argument. Dominance claim checks: corr≥7 candidates B(9,9,8), D(7,7,5),
  E(8,9,2); B dominates.

---

## Non-blocking observations (noted, not counted against the grade)

- **Notation conserved-field cell** (lines 122–127) remains the densest cell in the document
  after the `balance` pin (definition + why `balance` exists + what it is not). It is precise
  and correct; in a glossary it is scanned on demand, not read top-to-bottom, so it is not a
  linear-flow stall. The `balance` demonstrative field is consistently signposted everywhere
  it appears ("by intent", "demonstrative second conserved field"), so the reader is told its
  status at each encounter and never has to reconstruct it. If a future round trims, this cell
  is the candidate (move the "why balance exists" digression to a footnote at §reference).
  Pure polish, not a blocker — and not cuttable without loss as long as `balance` lives in the
  reference and C11.

---

## Why A and not B

Round 3 closed my one residual non-blocking note (the unglossed `>=>`); Round 4's single edit
is a strict one-pass improvement and introduces nothing. The target reader gets a result-first
spine, tag-oriented condition numbering, every load-bearing term defined before use, a fully
self-documenting P3 law, an educational reference, and a now type-clean migration alias.
Nothing in my domain is cryptic, nothing forces a backtrack, and the one dense cell is
reference material scanned on demand, not linear prose. This clears my bar.
