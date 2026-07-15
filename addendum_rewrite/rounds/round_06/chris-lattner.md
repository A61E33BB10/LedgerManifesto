# Round 6 Scorecard — chris-lattner

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Progressive disclosure — simple path first and unobstructed; each abstraction
earns its place; notation is interface, not obstacle.

**Grade: A (92%)** — clears the bar, staked on my lens.

## Method this round

I did not lean on the R5 basis. Fresh full pass over the .tex (842 lines) plus confirmation
the reference (`reference/StatesHome.hs`, 573 lines) is present and `\lstinputlisting`
resolves. The document is byte-stable since R4 on my surface; R6 introduces no regression. I
re-tested the A-bar from scratch: can a competent quant engineer who has read none of the 27
rounds reach the correct model in one careful pass, with nothing cryptic in my domain,
correctness preserved, and nothing cuttable without loss.

## Why this clears A

- **Simple path is first and unobstructed, at three altitudes.** Abstract (48–62) → §1
  question (72–83) → §3 three-line map block (155–159) → §13 one-sentence answer (825–830).
  The reader reaches the schema before any condition, type, or proof is demanded of them.
  The four instruments (§4) and the reference (§12) are descents taken only as far as
  needed. Gentle on-ramp, no ceiling — this is the property I most want and it holds.

- **Each abstraction earns its place.** §6 (560–585) discharges "and *only* three" with
  exactly one forcing constraint per map, and the absent fourth (W-sector) is a named,
  load-bearing absence (C12; design D in §10), not a silent gap. No map is present "in case."

- **Complexity is progressively disclosed across the type machinery.** C2 lands as plain
  arithmetic sum-to-zero in the body (254–270); the fold-homomorphism / `>=>` framing is
  deferred to §9/§11 and the reference. Beginner sees a fact, expert sees the law. `>=>` is
  glossed at first use (684–690). C11's note that field-writers and C2 event classes are
  *different axes whose names are not meant to coincide* (314–316) pre-empts the single
  worst name-collision a careful reader would otherwise hit.

- **Notation is interface, not obstacle.** `0_P` (the one all-zero value) vs `flat` (the
  conserved-fields-zero class) are cleanly separated (128–131); every inline tag in the §3
  block (`reg-total`, `monotone, Option accessor`) is glossed up front in §2.

- **Honest about where the encoding stops.** §11 intro (668–676) defines "unrepresentable"
  in a precise, non-inflated sense and concedes conservation is a value-level check (S4).
  That honesty is the mark of an interface built to be extended, not a demo.

Nothing in my domain is cryptic; correctness is preserved; I found nothing whose removal is
a clear net gain.

## Residual non-blocking friction (carried, re-examined, still below my bar)

- **The `balance` demonstrator is the sharpest exposition cost.** A synthetic conserved
  field carried only to exercise C11 with a writer (`transfer`) distinct from `ac`'s
  (`settle/trade`) — see 122–127, 203–205, 308–311. On first read it is genuinely odd: a
  field that is "neither the framework holding nor an economic datum." I re-tested whether it
  is cuttable without loss. It is *not* cleanly cuttable: C11 must be shown on a **conserved**
  field with a writer distinct from `ac`'s, and the only other writers (`hwm`→crystallise,
  `entry_nav`→subscribe) sit on **non-conserved** fields. So `balance` earns its place for
  the correctness demonstration even though it taxes the exposition. It is signposted at
  every one of its three occurrences, so it does not gate one-pass comprehension. Friction,
  not obstacle.

- **§2 puts some notation before its motivation** (`$\Delta f$`, `$0_P$`, `$u_{MA}$`, and
  the `balance` rationale) before C11/the reference exist. Conventional for a spec; forward
  pointers mitigate; first-skim takeaways survive.

- **§4 presents conditions out of numeric order** (C2 before C1 in §4.1). Pre-warned as
  stable tags (213–216), indexed in §5, each self-contained at its definition. Comprehension
  intact.

None of the three gates a single careful pass, which is my A-bar. I re-stake my lens on the
A.
