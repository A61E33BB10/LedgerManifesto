# Round 5 — KARPATHY scorecard

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** The one-pass test. Can the target reader (a competent quant engineer who has NOT
read the 27 review rounds) read each section once, top to bottom, without backtracking?
Linear flow, self-documenting, nothing cryptic in my domain, nothing cuttable without loss.

**Grade: A (93%)**

I stake my lens on this. The document passes the one-pass test, and Round 5's single edit is
a strict improvement on my axis.

---

## Round-5 change verified on my lens

The accessor name `position(w,u)` is now consistent at every site:

- §4.1 C1(a) defines it: `position(w,u)` returns `Option[PositionState]` (line 287).
- §6 (untraded) uses it: `position(w,u)` is `None` until first touch (line 465).
- §9 migration alias now reads `get_unit_state(w,u)` ... maps to `position(w,u)` (line 615).

In Round 4 the migration alias still wrote `position_state(w,u)` while the canonical accessor
everywhere else — and in the reference (`StatesHome.hs` export `position`, line 53; definition
context lines 147–153) — is `position`. A careful one-pass reader hitting §9 would have
stalled for a beat ("is it `position` or `position_state`?"), a small but real backtrack
reflex. Round 5 removes it. `grep` confirms `position_state(` no longer appears anywhere in
the document; only `position(w,u)` survives (lines 287, 465, 615). Net improvement, no new
term, no new forward-reference.

---

## My prior blockers — all still cleared (re-confirmed on a fresh top-to-bottom pass)

- **P3 fold identity, `>=>` glossed** (lines 685–692). `f >=> g` named at first use as the
  error-returning composition that stops at the first error, then the law restated in plain
  words ("Replaying a concatenated log equals replaying each part and composing the two").
  `foldM` reads in one pass because its meaning is recovered by the adjacent plain-words law;
  the precise Haskell stays in the reference for its literate reader. Correct prose/reference
  split.
- **Out-of-order condition numbering** (§4 intro, lines 212–218). "read as tags, not as a
  sequence ... the first condition met below is C2" pre-empts the "did I skip C1?" reflex.
- **Conservation notation** (§4.1, lines 250–254). "conservation as defined for `h` extends
  to it, `∑ ac(w,u)=0`." No hyphenated coinage.

---

## Cross-checked one-pass health of the rest

- **Result-first spine intact:** Question → Notation → Answer → four instruments →
  conditions index → why-three → v10.3 effect → alternatives → unrepresentable → testing →
  risk → reference → one-sentence. No mental jumping between sections. Conditions are *defined*
  inline in §4 at the forcing instrument, then *recapped* in §5; a top-to-bottom reader meets
  each before the index, so §5 is recall not lookahead — no backtrack.
- **Every load-bearing term defined before use:** `StateDelta`, `0_P`/flat, conserved field,
  registration-total, monotone carrier, append-only, Option/Some/None — all in the §2 table
  ahead of §3+.
- **C11 vs C2 two-axis disambiguation** (lines 311–319) holds; field-writers
  (settle/trade/transfer/fee_crystallise/subscribe) vs event classes
  (Trade/SettleVM/CorporateAction/QISRebalance/MandateAmend) are named distinct, matching the
  reference GADT `FieldWrite` constructors (`StatesHome.hs` 196–201). No conflation.
- **No type-vs-value over-claim.** §10 intro states "Unrepresentable is used in this precise
  sense, not as a claim that every guarantee is a type-level fact: conservation, in
  particular, is a value-level check (signal S4)." Consistent with the abstract's "render ...
  unrepresentable rather than merely tested" and with the P1 gloss ("The check is
  value-level (signal S4), not a type fact"). Signals S1–S4 all resolve to labelled blocks in
  the reference (`StatesHome.hs` 448, 462, 469, 478).
- **Count consistency:** abstract "seven of the ten" (line 59) = §10 list P1,P3,P5,P6,P7,P9,P10
  = 7; §10 closing "no other design makes more than three of the ten" agrees.
- **Pareto table** framed as ordinal judgments by a named scorer; the per-design forcing
  reason carries the argument. Dominance checks: corr≥7 candidates B(9,9,8), D(7,7,5),
  E(8,9,2); B dominates. No one-pass stall.

---

## Non-blocking observation (noted, not counted against the grade)

- **Notation conserved-field cell** (lines 122–127) remains the densest cell — definition of
  conserved field + why `balance` is a second conserved field + what `balance` is not. It is
  precise and correct, and it is *not cuttable without loss*: `balance` is load-bearing in the
  reference (it exercises C11's per-field-writer discipline with a writer distinct from
  `ac`'s) and in C11 itself, so a reader who meets `balance` at C11/§4 needs this cell to
  avoid stalling on "what is this and why a second conserved field?". It lives in a glossary,
  scanned on demand, not read as linear prose — so not a linear-flow blocker. Its
  "demonstrative / by intent" status is re-signposted at every later encounter (lines 127,
  203–205, 311), so the reader is never left to reconstruct it.

---

## Why A and not B

Round 4 cleared my last residual note; Round 5's single edit removes the one remaining
accessor-name mismatch that could trigger a micro-backtrack at §9. The target reader gets a
result-first spine, tag-oriented condition numbering, every load-bearing term defined before
use, a fully self-documenting P3 law, a guarded (not over-claimed) "unrepresentable", and an
educational reference whose names now match the prose exactly. Nothing in my domain is
cryptic, nothing forces a backtrack, nothing is cuttable without loss. This clears my bar; I
stake my lens on it.
