# Round 7 Scorecard — chris-lattner

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Progressive disclosure — simple path first and unobstructed; each abstraction
earns its place; notation is interface, not obstacle.

**Grade: A (92%)** — clears the bar, staked on my lens.

## Method this round

Fresh full pass over the .tex (843 lines), reference confirmed present
(`reference/StatesHome.hs`, 573 lines) and `\lstinputlisting` resolves. The document is
byte-stable on my surface since R4; R7 introduces no regression. I deliberately did not
rubber-stamp from the R6 basis — I re-ran the A-bar from scratch and stress-tested the
three carried friction items to decide whether any has crossed into blocking. None has.

The A-bar I test: can a competent quant engineer who has read none of the 27 rounds reach
the correct model in one careful pass, with nothing cryptic in my domain, correctness
preserved, and nothing cuttable without loss.

## Why this clears A

- **Simple path is first and unobstructed, at three altitudes.** Abstract (48–62) → §1
  question (72–83) → §3 three-line map block (155–159) → §13 one-sentence answer (825–830).
  The reader reaches the schema — three maps, one mutation discipline each, no W-sector —
  before any condition, type, or proof is demanded of them. The four instruments (§4) and
  the reference (§12) are descents taken only as far as needed. Gentle on-ramp, no ceiling:
  this is the property I most want, and it holds.

- **Each abstraction earns its place.** §6 (560–585) discharges "and *only* three" with
  exactly one forcing constraint per map; removing any one breaks a named constraint. The
  absent fourth map (W-sector) is a *named, load-bearing absence* (C12 in §4.2; design D in
  §10), not a silent gap. No map is present "in case." This is the minimum-basis argument
  made structurally rather than asserted.

- **Complexity is progressively disclosed across the type machinery.** C2 lands as plain
  arithmetic sum-to-zero in the body (254–270); the fold-homomorphism / `>=>` framing is
  deferred to §9/§11 and the reference, and `>=>` is glossed at first use (683–690).
  Beginner sees a fact, expert sees the law. C11's note that field-writers and C2 event
  classes are *different axes whose names are not meant to coincide* (313–316) pre-empts the
  single worst name-collision a careful reader would otherwise hit.

- **Notation is interface, not obstacle.** `0_P` (the one all-fields-zero value) vs `flat`
  (the conserved-fields-zero equivalence class) are cleanly separated (128–131); every
  inline tag in the §3 block (`reg-total`, `monotone, Option accessor`) is glossed up front
  in §2. The §3 note that map value types share their sector names by intent while the
  reference uses `ledgerUS`/`ledgerPS` to keep them apart (161–164) removes a name-collision
  before it bites.

- **Honest about where the encoding stops.** §11 intro (668–676) defines "unrepresentable"
  in a precise, non-inflated sense and concedes conservation is a value-level check (S4).
  That honesty — naming the seam between type-level and value-level guarantees — is the mark
  of an interface built to be extended, not a demo.

Nothing in my domain is cryptic; correctness is preserved; I found nothing whose removal is
a clear net gain.

## Residual non-blocking friction (carried, re-examined, still below my bar)

- **The `balance` demonstrator is the sharpest exposition cost**, and I re-tested
  cuttability this round rather than carrying the R6 conclusion. The notation entry
  (122–127) front-loads a dense, motivation-before-context clause: a conserved field carried
  *only by the reference* to exercise C11 with a writer (`transfer`) distinct from `ac`'s,
  "neither the framework holding nor an economic datum." On first read it is genuinely odd.
  But it is *not* cleanly cuttable: C11 must be demonstrated on a **conserved** field with a
  writer distinct from `ac`'s, and the only other writers (`hwm`→crystallise,
  `entry_nav`→subscribe) sit on **non-conserved** fields. So `balance` earns its place for
  the correctness demonstration even though it taxes exposition, and it is signposted at all
  three occurrences (122–127, 203–205, 305–311). Friction, not obstacle — does not gate one
  careful pass. (A later pass could shrink the §2 entry to a one-clause pointer "demonstrator;
  see C11" and move the rationale to its point of use; pure elegance, no comprehension cost.)

- **§2 puts some notation before its motivation** (`$\Delta f$`, `$0_P$`, `$u_{MA}$`, and
  the `balance` rationale, before C11/the reference exist). Conventional for a spec; forward
  pointers mitigate; first-skim takeaways survive.

- **§4 presents conditions out of numeric order** (C2 before C1 in §4.1; §4.4 runs C7, C5,
  C9, C10, C6, C8). Pre-warned as stable tags up front (212–216), indexed one-line-each in
  §5, each condition self-contained at its definition. The numbers are names, not a
  dependency order. Comprehension intact.

None of the three gates a single careful pass, which is my A-bar. I re-stake my lens on the
A at 92% — at the bar, deliberately not inflated above it, because the `balance` exposition
cost and the documented-not-renumbered condition scheme keep the simple path from being
*frictionless*, only unobstructed.
