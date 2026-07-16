# Round 5 Scorecard — chris-lattner

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Progressive disclosure — simple path first and unobstructed; each abstraction
earns its place; notation is interface, not obstacle.

**Grade: A (92%)** — clears the bar, staked on my lens.

## State of the document at R5

No change on my lens surface since R4. The R4 basis holds verbatim and I re-verified it on
a fresh pass. The document has been stable across R2–R4 on the progressive-disclosure axis,
and R5 does not regress it.

## Why this clears A (re-staking my lens)

- **Simple path is first and unobstructed at three altitudes.** Abstract → §1 question
  (lines 72–83) → §3 three-line map listing (155–159) → §13 one-sentence answer (827–832).
  A competent quant engineer who has read none of the prior rounds reaches the correct
  model from §1 → §3 → §13 alone, then descends into the four instruments (§4) and the
  reference (§12) only as far as needed. The on-ramp is gentle; there is no ceiling.

- **Each abstraction earns its place.** §6 discharges "and only three maps" with exactly
  one forcing constraint per map (lines 570–582); the W-sector is a named, load-bearing
  absence (C12, design D), not an unexplained gap. The §3 listing's inline tags
  (`reg-total`, `monotone, Option accessor`) are all glossed up front in §2.

- **Type machinery stays deferred.** C2 appears as arithmetic sum-to-zero in the body
  (lines 256–268); the fold-homomorphism / `>=>` framing lives in §9/§11 and the reference.
  Beginner sees a fact; expert sees the law. `>=>` is glossed at first use (lines 688–692).

- **Notation is interface, not obstacle.** `0_P` (one unambiguous all-zero value) vs `flat`
  (the conserved-fields-zero equivalence class) are cleanly separated (lines 128–131);
  `balance` is pinned as a demonstrative C11 field, not schema state, from both §2 and §3.
  C11's note that field-writers and C2 event classes are different axes whose names are not
  meant to coincide (lines 314–318) pre-empts the one name-collision a careful reader hits.

- **Honest about where the encoding stops.** §11 intro (lines 670–678) states
  "unrepresentable" in a precise, non-inflated sense and concedes conservation is a
  value-level check (S4). Honesty about the encoding's edge is the mark of an interface
  built for extension, not a demo.

Nothing in my domain is cryptic, correctness is preserved, and I found nothing cuttable
without loss.

## Residual non-blocking friction (carried from R3/R4, still below my bar)

- **Notation precedes motivation** in §2: the `balance` rationale is front-loaded
  (lines 122–127) before C11/the reference exist; `$\Delta f$`, `$0_P$`, `$u_{MA}$` are
  defined before they bite. Conventional for a spec; forward-pointers mitigate; takeaways
  graspable on first skim. The `balance` entry remains the sharpest instance — a later pass
  could shrink it to a one-clause pointer ("demonstrator; see C11"). Not an obstacle.

- **§4 presents conditions in non-ascending numeric order** (C2 before C1 in §4.1, etc.).
  Pre-warned and documented as stable tags (lines 213–218), indexed in §5, each
  self-contained at its definition. Comprehension intact.

Neither gates one-pass comprehension, which is my A-bar. A reader gets through in one
careful pass. I stake my lens on the A.
