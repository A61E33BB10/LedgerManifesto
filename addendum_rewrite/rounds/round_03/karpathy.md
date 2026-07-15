# Round 3 — KARPATHY scorecard

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** The one-pass test. Can the target reader (a competent quant engineer who has NOT
read the 27 review rounds) read each section once, top to bottom, without backtracking?
Linear flow, self-documenting, nothing cryptic in my domain, nothing cuttable without loss.

**Grade: A (92%)**

I stake my lens on this. The document passes the one-pass test, and Round 3 closed the one
residual friction I had flagged.

---

## Round-3 changes verified on my lens

Round 3 made three targeted edits (for henri-cartan and milewski). I read each in context
and checked for regressions:

1. **§10 P3 `>=>` now glossed in prose** (lines 681–688). It reads:
   "`replay (xs <> ys) = replay xs >=> replay ys`, where `f >=> g` is the composition that
   runs the error-returning step `f`, feeds its result to `g`, and stops at the first error
   (composition of `Either LedgerError`-returning steps). Replaying a concatenated log
   equals replaying each part and composing the two."
   This is exactly the fix my Round-2 non-blocking note asked for: the Kleisli fish is now
   self-documenting at first use, the undefined "Kleisli category" token is removed from the
   prose, and the law is restated in plain words. The reference `.hs` keeps the precise term
   for its Haskell-literate reader — the right prose/reference split. Reads in one pass.

2. **`.hs` line 369** now reads "Kleisli homomorphism law" (the misleading "(anti)" is
   removed). It is order-preserving (lists under `<>` to arrows under `>=>`) and matches the
   §10 prose. No contradiction between the reference comment and the prose statement.

3. **`balance` pinned** as the reference's demonstrative second conserved field — notation
   conserved-field entry (lines 122–127) and the §3 absent-by-intent note (lines 203–205).
   The notation cell is dense (definition + why `balance` exists + what it is not), but it
   lives in a glossary table that is scanned on demand, not read linearly, and it forward-
   references §reference and §answer cleanly. It resolves a real ambiguity the reader would
   otherwise hit at C11 and in the listing (a field present in the reference but absent from
   the §3 economic inventory). Not cuttable without loss.

No new cryptic terms, no new forward-reference traps, no new backtrack reflex.

---

## My Round-1 blockers — all still cleared (re-confirmed)

- **P3 fold identity** — correct and now fully glossed (above).
- **Out-of-order condition numbering** — §4 opens (lines 212–216) with the orientation that
  C1–C12 are tags indexed in §5, first met is C2, read as tags not a sequence. The
  "did I skip C1?" reflex stays pre-empted.
- **`∑_w h-style conservation`** — §4.1 (line 249) reads "conservation as defined for `h`
  extends to it, `∑ ac(w,u)=0`." The hyphenated coinage is gone.

---

## Cross-checked one-pass health of the rest

- Result-first spine intact: Question → Answer → four instruments → why-three →
  alternatives → invariants → reference → one-sentence answer.
- Every load-bearing term defined before use: `StateDelta`, `0_P`/flat, conserved field,
  registration-total, monotone carrier — all in the §2 notation table.
- C11 handler-vocabulary axis vs C2 event-class axis still disambiguated in place (lines
  311–315). P10/C11 "authorship-then-erased" caveat consistent across C11, P10, §10 bullet,
  §11 intro. No type-vs-value over-claim.
- Pareto table framed as ordinal judgments by a named scorer; per-design forcing reason
  carries the argument. Dominance claim still checks: corr≥7 candidates B(9,9,8), D(7,7,5),
  E(8,9,2); B dominates both.

---

## Non-blocking observations (noted, not counted against the grade)

- **Notation conserved-field cell is now the densest cell in the table** after the `balance`
  pin. It is precise and correct; in a glossary it is scanned, not read top-to-bottom, so it
  is not a linear-flow stall. If a future round trims, this cell is the candidate — move the
  "why balance exists" digression to a one-line footnote at §reference and leave the
  glossary cell as the bare definition. Pure polish, not a blocker.
- **Signals S1/S2/S4 are still enumerated only in the `.hs` comments** (lines 448–478), with
  in-prose uses being deferrable "where this is encoded" pointers; only S3 is named in §10
  prose. Same minor wayfinding gap I noted in Round 2; it does not gate any sentence's
  meaning. Not a one-pass blocker.

---

## Why A and not B

In Round 2 this was an A held with one residual non-blocking note (the unglossed `>=>`).
Round 3 closed exactly that note and introduced no new friction; the two other edits
(`.hs` comment fix, `balance` pin) are precise and regression-free. The target reader gets
a result-first spine, tag-oriented condition numbering, every load-bearing term defined
before use, a now fully self-documenting P3 law, and an educational reference. Nothing in my
domain is cryptic, nothing forces a backtrack, and the one dense cell is reference material,
not linear prose. This clears my bar with a small margin over Round 2.
