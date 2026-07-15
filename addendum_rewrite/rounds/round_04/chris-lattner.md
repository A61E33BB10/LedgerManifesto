# Round 4 Scorecard — chris-lattner

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Progressive disclosure — simple path first and unobstructed; each abstraction
earns its place; notation is interface, not obstacle.

**Grade: A (92%)** — clears the bar, staked on my lens.

## What changed since R3

Exactly one edit landed (iteration log, Round 4): the §9 migration alias was rewritten
from a type-incorrect `product_terms(u) ++ unit_status(u)` to the pair
`(product_terms(u), unit_status(u))`. This was a milewski type-correctness finding, not a
progressive-disclosure one. Effect on my lens: neutral-to-positive. The replacement
introduces no new notation, the tuple form reads cleanly to a newcomer
(lines 610–612), and it removes a latent snag a Haskell-aware reader would have tripped on.
Nothing in the simple-path surface moved or regressed.

## Why this still clears A (re-staking my lens)

The R3 basis holds verbatim and I re-verified it on a fresh pass:

- **Simple path is first and unobstructed at three altitudes.** Abstract → §1 question →
  §3 three-line map listing → §13 one-sentence answer. A competent quant engineer who has
  read none of the prior rounds reaches the correct model from §1 → §3 → §13 alone, then
  descends into the four instruments and the reference only as far as needed.
- **Each abstraction earns its place.** §6 discharges "and only three maps" with one
  forcing constraint per map; the W-sector is a named, load-bearing absence (C12, design
  D), not an unexplained gap. The §3 listing's inline tags (`reg-total`, `monotone, Option
  accessor`) are all glossed up front in §2.
- **Type machinery stays deferred.** C2 appears as arithmetic sum-to-zero in the body; the
  homomorphism / `>=>` framing lives in §9 and the reference. Beginner sees a fact; expert
  sees the law. `>=>` remains glossed at first use (the R3 fix).
- **Notation is interface.** `0_P` vs `flat` is one unambiguous value vs an equivalence
  class; `balance` is pinned as a demonstrative field, not schema state, from both sides
  (§2 and §3). C11's note that field-writers and C2 event classes are different axes whose
  names are not meant to coincide pre-empts the one name-collision a careful reader hits.
- **Honest about where the encoding stops.** §9 states "unrepresentable" in a precise,
  non-inflated sense and concedes conservation is value-level (S4).

Nothing in my domain is cryptic, correctness is preserved, and I found nothing cuttable
without loss.

## Residual non-blocking friction (carried from R3, still below my bar)

- **Notation precedes motivation** in a few places (`balance` rationale front-loaded in
  §2 before C11/the reference exist; `$\Delta f$`, `$0_P$`, `$u_{MA}$` defined before they
  bite). Conventional for a spec; forward-pointers mitigate; takeaways graspable on first
  skim. Not an obstacle.
- **§4 presents conditions in non-ascending numeric order** (C2 before C1, etc.).
  Documented as stable tags up front, indexed in §5, each self-contained at its definition.
  Comprehension intact.

These do not gate one-pass comprehension, which is my A-bar. A reader gets through in one
careful pass. I stake my lens on the A.
