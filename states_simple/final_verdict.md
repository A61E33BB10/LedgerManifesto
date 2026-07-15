# Final Verdict — "States": the simple statement of the solution

## Outcome: NOT UNANIMOUS at the hard cap — honest residue report

The loop ran the full **20 rounds**. It did **not** reach the termination condition (every member
OBVIOUS at a round ≥ 10). Per the iteration-control rule, the cap was honored and the run **stopped
without forcing a verdict or dropping content to manufacture one**. This is the honest report the
process calls for.

- **Best state reached:** round 15, **7 of 8 OBVIOUS** (only `jane-street-cto` holding).
- **Round 20 (final):** **4 of 8 OBVIOUS.**

| | round 20 verdict |
|---|---|
| `formalis` (correctness, veto) | **OBVIOUS** |
| `minsky` (types) | **OBVIOUS** |
| `milewski` (Haskell) | **OBVIOUS** |
| `henri-cartan` (architecture) | **OBVIOUS** |
| `karpathy` (one-pass) | NOT-YET |
| `chris-lattner` (only-what-serves) | NOT-YET |
| `dirac` (inevitability) | NOT-YET |
| `jane-street-cto` (six-months-later) | NOT-YET |

### Trajectory (OBVIOUS count per round)
```
Rd : 1  2  3  4  5  6  7  8  9 10 |11 12 13 14 15 16 17 18 19 20
#O : 0  0  3  3  5  4  3  2  3  3 | 3  4  3  4  7  3  4  4  6  4
```
Rounds 1–10 used the original framing; the round-11 pivot (discriminate Terms from Status by
**authorship**, not by an out-of-scope "past-dated boundary read") lifted the document to 7/8 by
round 15 but did not stabilise there.

## What is settled (and why this is a near-miss, not a failure of the solution)

The **solution is correct, and its correctness is self-evident to the lenses that judge
correctness.** `formalis` (which holds the veto on any dropped or weakened load-bearing fact)
returned OBVIOUS in 9 of the 10 final rounds, including round 20; `minsky` and `milewski` returned
OBVIOUS at round 20; the Haskell `States.hs` is FORMALIS-cleared. No correctness veto stands. The
document is exactly three pages, the path is fully absent (no Pareto, no `C1–C12`, no iteration log,
no rejected designs), and every KEEP item in `SOLUTION_ESSENCE.md` is present.

**The residue is in the writing, not in the solution.** It is concentrated almost entirely on one
paragraph: the **keystone completeness argument** — *exactly two questions ⇒ a 2×2 ⇒ exactly three
occupied homes and one structurally empty cell.* That step is what makes "three, no fourth" feel
inevitable rather than enumerated, and four reviewers judge it not yet readable in a single pass.

## The residue, precisely (the forward agenda)

1. **Exhaustiveness is asserted, not derived** (`dirac`, `jane-street-cto`). The document says there
   are "exactly two questions" but does not show *why two is complete*. The derivation it is missing
   is short and already implicit in its own rule: the placement rule is a conjunction of **exactly
   two atomic requirements — one key, one writer**; a fact can fail it only by violating one conjunct
   or the other, and the rule names no third thing; hence exactly two questions, hence a 2×2, hence
   three occupied cells and one structurally empty. Stating this derivation explicitly is the single
   highest-value fix.
2. **The keystone paragraph is back-to-front** (`karpathy`). It uses "each of the two questions"
   before naming them, and "there is no third question:" primes the reader to expect a third. Fix
   (local, no substance change): name the two questions first (holder-dependence; authorship), say
   each forestalls one of the two failure modes, then conclude there is no third.
3. **"home" equivocates** (`dirac`). The word denotes a *key/location* in the rule ("one home and
   one writer") but the *occupied cell* at the count ("each occupied cell is a home"). Reserve "home"
   for the occupied cell; name the two attributes distinctly — *where it is keyed* and *who writes
   it*.
4. **Two minor repetitions** (`chris-lattner`). The governing rule is stated near-verbatim in §1 and
   §2; the empty fourth cell is asserted three times before it is proved. Say each once.

None of these requires reopening the design or dropping content; each is an expository fix to the
one load-bearing paragraph, and the committee supplied the exact change in every case.

## Disposition

`States.tex` and `States.hs` are left at their round-20 state (three pages, compiles, Haskell
cleared). The loop was stopped at the cap rather than continued or hand-patched to a pass, in
keeping with the rule that an honest "not yet obvious, here is the residue" is the correct output and
a contrived pass is a failure. The residue above is the agenda for whoever next opens the document:
applied as four local edits to the keystone paragraph, it is the plausible path from 4/8 (and the
demonstrated 7/8) to unanimity, without touching the settled solution beneath it.

*Provenance: 20 rounds, eight-member committee reviewing independently each round (160 scorecards in
`rounds/`), STYLUS authoring the prose and milewski the FORMALIS-cleared Hutton-style Haskell. The
`clarifications/` directory is empty: STYLUS did not need a specialist consult it could not resolve
from the settled source and the cleared Haskell.*
