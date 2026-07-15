# Round 1 — KARPATHY scorecard

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** The one-pass test. Can the target reader (a spec-literate engineer/architect
with post-trade domain knowledge) read each section once, top to bottom, without
backtracking? Linear flow, self-documenting, no cleverness for its own sake.

**Grade: B (85%)**

---

## What works (reads cleanly in one pass)

- **Result-first spine.** The Question → The Answer → the four instruments → why three →
  alternatives → invariants. The reader gets the conclusion (three maps, no W-sector)
  before the derivation. Good.
- **Signposting is genuinely good.** §1 promises "conditions are introduced where the
  instrument forces them, then collected in §ref" and the document delivers exactly that.
  Forward references (§ma, §qis, §why-three, §pareto) mostly land.
- **Tables carry the reference load.** The Field/Home/Reason tables (§4.1, §4.2, §4.3) and
  the "Home of each datum" table (§3) are scanned, not read linearly, and are clean.
- **Concrete forcing examples.** "Two mandates, two rows" (§4.2) and "a client holding two
  strategies carries two high-water marks" (§4.3) are the right kind of single-batch
  overfit: one concrete case that forces the keying. This is the document at its best.
- **The reference implementation (`StatesHome.hs`) is educational by default.** Every
  abstraction (`Ledger` abstract → no row deleter → monotone carrier; `ValidDelta` abstract
  → only `validate` builds it → conservation) is explained where it is encoded. A reader
  learns *why* the type shapes are what they are. This is exactly the standard.
- **The dominance argument in §8 is internally consistent.** I checked the A–F table against
  the "B is the unique Pareto-optimum under correctness gate ≥7" claim: candidates with
  corr≥7 are B(9,9,8), D(7,7,5), E(8,9,2); B dominates both. Holds.

---

## Blocking issues for an A (each actionable)

### 1. The P3 fold-identity formula is garbled / type-incoherent (cryptic)
**Location:** §9, P3 gloss, line ~630.

The formula reads:
`apply_all(events[:k]) ++ events[k:] ≡ apply_all(events)`

This mixes a *folded ledger state* (`apply_all(events[:k])`) with a *raw event list*
(`events[k:]`) via `++` (list concatenation). It does not typecheck conceptually, and on
first read it forces the reader to stop and reverse-engineer what was meant. The reference
Haskell states the same law correctly: `replay (xs <> ys) = replay xs >=> replay ys`.
**Fix:** rewrite the gloss as a composition of folds, e.g.
`apply_all(events[k:]) ∘ apply_all(events[:k]) = apply_all(events)`, or use the Kleisli
form from the reference. This is the one place in the document that is genuinely cryptic in
my domain.

### 2. Condition numbers are not monotone in order of appearance
**Location:** §4 throughout. Encounter order is C2 (line 229), C1 (259), C11 (280), C12
(323), C3 (389), C4 (400), C7 (426), C5 (431), C9 (441), C10 (449), C6 (467), C8 (472).

The very first condition the reader meets is **C2, before C1**. Numeric labels imply an
order; the presentation contradicts it. This triggers a "did I skip C1?" backtrack reflex
repeatedly through §4 — the exact mental jumping the linear-flow test forbids. The §5 index
(numeric order) and the line "Each condition is defined once, at the instrument that forces
it" both arrive *after* §4, too late to prevent the reflex on first read.
**Fix:** add one orientation sentence at the start of §4 (or §4.1): "Conditions are
numbered by their position in the §ref index, not by order of appearance; each is
introduced where its instrument forces it." One line removes the friction without
renumbering (the numbers are load-bearing references in §9 and §12, so they should stay).

### 3. Cryptic shorthand "∑_w h-style conservation"
**Location:** §4.1, "Conservation of ac", line ~224.

"$\sum_{w} h$-style conservation extends to it" reads as a typo/shorthand; the token
"$\sum_w h$-style" stalls the reader. **Fix:** state it plainly, e.g. "conservation as
defined for $h$ extends to ac: $\sum_{w\in\mathcal{W}}\texttt{ac}(w,u)=0$ for every $u$."
The conclusion sentence already gives the equation, so the lead-in just needs to drop the
hyphenated coinage.

---

## Non-blocking observations (noted, not counted against the grade)

- §4.2 line ~330 forward-references "design C, §pareto" before §8 introduces it, but the
  paragraph defines the sentinel inline, so it stays self-contained. Acceptable as-is.
- The abstract's first body sentence ("Four instruments answer it by forcing distinct
  keyings that no single attachment can carry") is dense, but for a spec abstract aimed at
  this reader it parses in one careful pass.
- §3 and the abstract both assert "there is no wallet-keyed state sector." Repetition, but
  it is the thesis being hammered; defensible.

---

## Why B and not A

The document is well above average for one-pass readability — strong spine, good
signposting, concrete forcing cases, an educational reference. But an A stakes my lens on
*nothing cryptic and no backtracking*, and two real defects remain: the P3 formula is
genuinely cryptic (issue 1), and the out-of-order condition numbering forces a recurring
backtrack reflex through the longest section (issue 2). Both are localized and pinpoint-
fixable, which is why this is high-B friction, not C-level rereading. Clear all three above
and this is an A.
