# Independence Note — Temporal Committee (Part II, FrameworkReview)

**How Round-1 independence was enforced.** The five committee members (TEMPORAL-1..TEMPORAL-5,
each an independent `temporal-engineer` instance on model opus) were spawned *simultaneously*, in a
single dispatch, before any member had produced any output. Every member received an *identical*
mandate; the only text that differed between the five prompts was the member's own identifier and the
path of the file it was to write (`proposal_TEMPORAL-N_r1.md`). Each was instructed, in writing, not to
read any other member's proposal and to write only to its own file. Because all five were launched
before the first write existed, no member could have seen another's proposal during Round 1 — the
independence is structural, not merely requested: there was nothing to read. The five Round-1 files
landed as five separately-authored artifacts, and only after all five were on disk were members
permitted (from Round 2 onward) to read one another, at which point convergence became the goal.

The evidence of genuine independence is in the artifacts: the five Round-1 proposals reached the same
core thesis (no second substrate/door/book; model outputs re-enter through the one door as re-entered
observations; projections are read-only; the refold is the single writer's work and Temporal re-fires
forward only) by five separate routes, and they *differed* on the real forks (MD-16 write atomicity,
valuation re-mark cadence, the value-determinism closure, the refuse-vs-flag question) — differences
that only independent derivation would produce.

**Referee independence.** The two referees (FORMALIS on rigor; TuringAward on architecture and §4
anti-bias) were spawned *fresh each round*, never carrying an authored stake, and no agent ever
certified work it authored. Consensus was gated on the referees' signatures on the actual final text,
not on the authors' agreement and not on any second-hand report of agreement.

**Runner attestation.** I, the Protocol Runner, wrote no design content at any point. I enforced the
parallel Round-1 launch, carried referee feedback between rounds, drove the fork resolutions the
referees identified, ran the mandatory red-team scenarios (S1–S7), and declared consensus only after
verifying — on disk — that the blocking conditions were closed and that both referees and all five
members signed the same round-11 artifact. Where an external status message asserted that referees
"had signed," I did not rely on it: I convened the referees to sign the actual r11 text and grounded
the consensus declaration in their own recorded signatures.

— Protocol Runner, Temporal Committee Part II
