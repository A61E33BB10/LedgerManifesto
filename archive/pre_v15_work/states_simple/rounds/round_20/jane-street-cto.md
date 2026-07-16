# jane-street-cto — States.tex, Round 20

**Verdict: NOT-YET**

## What is right (and verified)

- Listings faithfully reproduce `States.hs` (deriving clauses elided, as stated). Spot-checked
  `Lifecycle`, `UnitStatus`, `defaultStatus`, `PositionState`, `zeroP`, `Ledger`, `register`,
  `settle`, `applyMove`, `position`, `netBal`, `apply`, `replay`.
- The code is correct. `netDeltas` builds `{from: -q, to: +q}` and collapses to a single
  `mempty` entry when `from == to`; `writeNet` skips `mempty`, so self-moves and zero-moves
  write no row. Conservation follows from `applyMove` being the sole `psBal` writer of two
  cancelling legs, plus the sealed constructor and withheld selectors. Replay is a pure, total
  `foldM`. The `Maybe` semantics (`Nothing` = unknown unit, never = "balance failed") and the
  `Nothing` / `Just zeroP` distinction in `position` are clean and well-motivated.
- The home-placement logic is sound: Position keyed by (holder, unit) because two holders
  differ; Status keyed by unit because one value is read identically; Terms split from Status
  on authority of record. The empty fourth cell is argued concretely (managed account reduces
  to a (client, mandate-unit) position).

This is a mature, correct artifact. The design is right. The residue below is in the
**argument**, not the code.

## Residue (blocker)

**§2 "The Answer", lines 64–68 — the exhaustiveness of the two questions is asserted, not
derived, and the sentence garden-paths.**

The entire taxonomy claims to be the *complete* minimal basis: three homes, no further
questions. That completeness rests entirely on the claim that a single-source-of-truth fact
can fail in **exactly two** ways and therefore there are **exactly two** questions. The text
gives:

> "A fact fails the rule in only two ways: keyed wrong …; authored wrong …. Each of the two
> questions forestalls one failure, and because there are only these two, there is no third
> question: whether the fact depends on the holder, and who authors it."

Two problems:

1. **Asserted, not proved.** Project principle one is "a claim is proved, not asserted." The
   rule is stated as "one home and one writer." The two-ness of the failure modes is exactly
   the two clauses of that rule: *one home* can fail (wrong key) and *one writer* can fail
   (wrong authority). That derivation — two clauses, hence two questions, hence no third — is
   the load-bearing step and it is left implicit. A fresh reader must reconstruct why "two" is
   complete rather than incidental. Make it explicit: the rule names two things (home, writer);
   each is one failure mode; the two questions are those two and there is no third because the
   rule names nothing else.

2. **Mis-punctuated.** "there is no third question: whether the fact depends on the holder, and
   who authors it" reads as if the colon introduces the *contents of the absent third question*,
   when it is actually listing the *two existing questions*. This forces a re-read on the one
   sentence the reader most needs to land cleanly. Restructure so the two questions are plainly
   the two, e.g. state the two questions first, then conclude there is no third.

Fixing this converts the spine of the framework from "trust me, two" to "here is why exactly
two," which is the difference between a reader nodding and a reader writing a margin note.

## Noted, not blocking

- The headline "three homes, no fourth" is correctly scoped at the grammatical subject of §2
  ("every economic relationship … *that reifies as a single unit it holds*"), and §3's final
  paragraph honestly excludes non-reducing multi-instrument relationships as a (holder,
  several-units) fact outside scope. This is disclosed, not overclaimed — the generalization
  from the one worked mandate to "all reifying relationships" is a stated scope boundary, not a
  hidden gap. Acceptable as written; flagged only so the committee confirms the boundary is
  intended.
- `psHwm` is always `mempty` with no in-scope writer. It reads at first as dead weight against
  the minimalism principle, but it earns its place by demonstrating the Position home carries a
  non-conserved per-(holder, unit) fact — part of the thesis, not gratuitous. The justifying
  paragraph (§4) is adequate. Not residue.
