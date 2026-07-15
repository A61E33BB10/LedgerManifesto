# karpathy — States.tex, Round 20

Verdict: **NOT-YET** (one located, actionable residue at the keystone step)

## What I checked

- Read `States.tex` end to end as a competent engineer seeing the problem for the first time.
- Read `States.hs`; confirmed the TeX listings reproduce its declarations (deriving elided;
  `TermsVersion`/`Move` shown positionally vs. record syntax in the source — cosmetic, not
  load-bearing).
- Compiled and ran: `runghc States.hs` produces exactly the claimed outputs — `Nothing` on
  re-registration, `(Nothing,Nothing)` for the zero move, `Nothing` for the self-move,
  `psBal = 0` close-out row retained, `netBal = 0`, and checkpoint-independence `True`.
  The §4 construction and §5 proofs are backed by running code.

## What is obviously right (single pass, no leap)

- **The "what."** The 2×2 table and the three-homes/two-maps answer (§2) read off in one pass.
- **§3 (Why Three).** Each occupied cell gets one concrete unit (buyer/seller split → Position
  keyed by (holder,unit); one settlement number read by all → Status keyed by unit; two
  authorities of record → Terms split from Status). The empty fourth cell is argued cleanly,
  and the managed-account "counterexample" is disarmed by reifying the mandate as a unit.
- **Scope honesty.** The multi-instrument case is explicitly placed *outside* §answer's scope
  rather than smuggled in, so "three homes" is exact within scope, not a hidden assumption.
- **The settlement-price classification trap is pre-empted.** A reader's natural objection
  ("the exchange publishes the settlement price, so isn't it externally authored?") is answered
  in §2 by the criterion "who owns the record's history, not who sources the number," with the
  benchmark-level vs. benchmark-identity contrast. Good obviousness-awareness.
- **§5 Conservation.** Invariant = per-unit holding sum stays at its start value (zero). Only
  `applyMove` touches `psBal`, writing two cancelling legs; `register`/`settle` do not; the seal
  closes the reach. Clear and matched by the running `netBal = 0`.
- **§5 Replay.** `apply` total over three events, `replay` a `foldM`; determinism and
  checkpoint-independence follow. The "monadic left-fold law" is named rather than restated, but
  that is a standard result and the demo equality returns `True` — acceptable.

## Residue (the one blocker)

The keystone of the entire "three homes" derivation is the completeness claim in §2 paragraph 2:
*there are exactly two failure modes, hence exactly two questions, hence a 2×2.* This is what
makes "three" feel forced rather than chosen. But the sentence presents that argument
back-to-front and garden-paths the reader:

> "Each of the two questions forestalls one failure, and because there are only these two, there
> is no third question: whether the fact depends on the holder, and who authors it."

Two distinct single-pass stumbles, both on the load-bearing step:

1. **The two questions are counted and used before they are named.** "Each of the two questions
   forestalls one failure" forces the reader to hold an unfilled reference; the questions are
   only named at the very end of the same sentence. This is exactly the mental-jump the Linear
   Flow test forbids.
2. **"there is no third question:" garden-paths.** The colon primes the reader to expect the
   (nonexistent) third question, then instead lists the two existing ones. A first-time reader
   re-reads to recover the parse — backtracking at the one place the argument can least afford it.

Compounding this, the preceding clause packs three failure variants into one semicolon chain
("keyed wrong, one home collapses two facts *or* one fact duplicates across homes that drift;
authored wrong, two authorities keep one fact ..."), so the keyed/authored ↔ two-questions
mapping has to be reconstructed by the reader rather than handed to them in order.

The fix is local and does not touch the substance: name the two questions first (does the fact
depend on the holder? who authors it?), then state that each forestalls exactly one of the two
failure modes, then conclude "no third question." Order: questions → failure each forestalls →
completeness. The italicized paragraphs that follow already do this well per-question; §2 para 2
just needs to stop using "the two questions" before it has introduced them.

Everything downstream of this sentence is obvious in one pass; this single keystone sentence is
not, and because it is the completeness argument that makes "three" inevitable, it fails the bar.
