# Round 3 Scorecard — chris-lattner

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Progressive disclosure — simple path first and unobstructed; each abstraction
earns its place; notation is interface, not obstacle.

**Grade: A (92%)** — clears the bar, staked on my lens.

## What changed since R2, in my domain

I staked A (90%) in R2. Round 3 touched exactly the two things that live in my lens, and
both moved notation from obstacle toward interface:

### P3 `>=>` is now glossed at first use — FIXED (was a latent notation-as-obstacle)
Lines 683–688. The operator `f >=> g` is now named where it appears: "the composition
that runs the error-returning step `f`, feeds its result to `g`, and stops at the first
error," with a plain-words restatement immediately after ("replaying a concatenated log
equals replaying each part and composing the two"). The bare term "Kleisli category" is
gone. This is the correct progressive-disclosure move: the formal law
`replay (xs <> ys) = replay xs >=> replay ys` stays for the expert, the gloss carries the
newcomer, and the operator no longer demands outside knowledge to parse. Exactly notation
functioning as interface.

### `balance` is pinned — FIXED (was a three-way ambiguity)
Notation entry (lines 122–127) now states plainly that `balance` is a *demonstrative*
second conserved field, transfer-moved, carried **only by the reference** to exercise the
C11 per-field-writer discipline with a writer distinct from `accumulated_cost`'s — and
explicitly **not** the framework holding `h(w,u)` and **not** a §3 economic datum. The §3
inventory note (lines 203–205) says the same from the other side. A reader can no longer
mistake `balance` for real schema state. The one open question (is `balance` ever meant to
be a real cash datum?) is correctly flagged as unsettled in the iteration log, not
silently resolved — honesty about where the demonstrator stops, which is the right posture
for an artifact built to teach a discipline.

## Why this clears A (staking my lens)

The simple path is first and unobstructed at three altitudes: abstract → §1 question → §3
three-line listing → §13 one sentence. A competent quant engineer who has read none of the
27 rounds reaches the right model from §1 → §3 → §13 alone, then descends into the four
instruments and the reference only as far as needed.

Each abstraction earns its place and disclosure is staged deliberately:
- §6 discharges "and only three maps" with one forcing constraint per map; the W-sector is
  a named absence, load-bearing for the negative thesis (C12, design D), not a smell.
- Type machinery stays deferred: C2 is arithmetic sum-to-zero in the body; the
  homomorphism / `>=>` framing lives in §9 and the reference. Beginner sees a fact; expert
  sees the law.
- §9 states "unrepresentable" in a precise, non-inflated sense and concedes conservation
  is value-level (S4). Honesty about where the encoding stops is the mark of an interface
  built for extension.
- C11's note that field-writers and C2 event classes are different axes whose names are
  not meant to coincide (lines 309–315) pre-empts the exact name-collision a careful
  reader would trip on.

Nothing in my domain is cryptic, correctness is preserved, and I found nothing cuttable
without loss.

## Residual non-blocking friction (for the record, not gating)

- **The `balance` notation entry now front-loads rationale.** Lines 122–127 explain *why*
  a demonstrative field exists ("to exercise the C11 per-field-writer discipline") before
  the reader has met C11 or the reference. The takeaway ("not a real economic datum") is
  still graspable on a first skim, so this is not a blocker — but it is the sharpest
  instance of notation-precedes-motivation in the document. If a later pass wants pure
  frictionlessness, this rationale could shrink to a one-clause pointer ("demonstrator;
  see C11") and let the full explanation sit at its point of use.
- **§4 still presents conditions in non-ascending numeric order** (C2 before C1; C7, C5,
  C9, C10, C6, C8 in §4.4). Documented as stable tags up front and indexed in §5;
  comprehension intact. Carried unchanged from R2, below my bar then and now.
- **§2 Notation precedes motivation** generally (`$\Delta f$`, `$0_P$`, `$u_{MA}$` before
  they bite). Conventional for a spec; forward-pointers mitigate. Not an obstacle.

These are below my blocking threshold. A reader gets through in one careful pass, and the
two R3 edits made the path cleaner than it was at R2.
