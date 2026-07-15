# karpathy — States, Round 13

Verdict: **NOT-YET**

Bar applied: a competent engineer who has never seen this problem reads once and
sees both *what* the answer is and *why each load-bearing claim must hold* — no
leap of faith, no backtracking.

## What is obviously right (and it is most of the document)

- **The 2×2 placement.** Two questions (holder-dependence; who owns the record)
  give four cells; the table and the criterion paragraph (lines 80–98) sort the
  whole category cleanly. The settlement-price-is-ledger-authored subtlety and
  the benchmark-level vs benchmark-identity contrast are both pre-empted and
  resolved in place. One pass, no stumble.
- **Three homes, two maps.** `ledgerUnit : Map UnitId (ProductTerms, UnitStatus)`
  and `ledgerPS : Map (WalletId,UnitId) PositionState`. Co-presence of terms and
  status is the *shape* of the pair, not a policed invariant — visibly correct.
- **Conservation by construction.** `applyMove` is the only `psBal` writer; it
  writes `negQty q` and `q` together; `register`/`settle` touch only
  `ledgerUnit`; base case `emptyLedger` sums to zero; the sealed constructor and
  withheld selectors leave no other door. I traced `netDeltas`/`writeNet`: the
  distinct-wallet case nets `-q`/`+q`, the self-move and zero-quantity cases net
  to `mempty` and write no row. Matches the prose exactly.
- **Deterministic replay.** `apply` is pure and total over three events; `replay`
  is `foldM (flip apply)`; checkpoint-splitting rests on the monadic left-fold
  law. Airtight and one-pass visible.
- **The `Maybe` distinction** (never held / held-and-flat) and the retained-row
  rationale are clear and motivated.

The engineering core is exemplary: each piece forced by the one before, code and
prose in lockstep, every asserted invariant shown rather than promised.

## Residue that blocks "obviously right"

### R1 (primary) — the completeness of the placement rests on an unproven keystone

The answer's central structural claim — *the fourth cell is empty, so exactly
three homes suffice* — depends on the reification claim at lines 60–67: "every
economic relationship a wallet has is itself a unit the wallet holds ... so a
fact about the relationship is a fact about the wallet's position in that unit."

The document proves this for **one** case (the single managed-account mandate,
lines 154–161) and then states, twice and explicitly, that the general case is
not proved:

- line 66: "that a relationship spanning several instruments likewise reifies as
  one unit is **assumed, not proved here**."
- line 161: "that a relationship spanning several instruments is likewise a
  single unit, and so a single row, is **assumed here, not proved**."

`States.hs` repeats it: "on a reification this file establishes for one mandate
and **assumes in general**."

Consequence for the reader: when they reach "The fourth cell ... is empty" they
cannot see *why it must hold* in general. The natural fresh-reader question —
"is a netting/relationship spanning several instruments really one unit, or
could it carry an externally-authored (holder, unit) fact and populate the
fourth cell?" — is answered with "assumed." That is a disclosed leap of faith,
but a leap nonetheless: the completeness of the whole placement (its headline
result, "three homes and no fourth") is conditional on a lemma the document
declines to prove. Disclosure makes the gap *visible*; it does not make the
conclusion *obvious*.

Actionable, two ways out:
1. Prove the multi-instrument reification (one unit per relationship spanning
   several instruments), so the empty fourth cell follows; or
2. Narrow the completeness claim so it no longer leans on the unproven lemma —
   state the result for single-relationship units and treat multi-instrument
   relationships as out of scope rather than as an assumed-true special case
   inside the conclusion.

Secondary to R1, the paragraph carrying this keystone (lines 60–67) is the one
place in the document that fails the read-once test on prose alone: four
em-dash clauses nesting "economic fact → (holder,unit) fact → reification →
relationship is a unit → fact about position." Even granting the assumption, a
fresh reader re-reads this sentence. Splitting it would help, but the proof gap
above is the real blocker.

### R2 (minor) — a backtrack trigger in The Construction

Line 263: "The seal **no longer** carries coherence --- the pair does --- and is
left to keep conservation true by construction." "No longer" refers to a prior
design state the fresh reader never saw; it sends them looking back for where the
seal previously carried coherence and finding nothing. State it positively, e.g.
"Coherence is carried by the pair, not the seal; the seal is left to keep
conservation true by construction." One-line fix.

## Why NOT-YET rather than OBVIOUS

Everything the document claims *to have proved*, it proves visibly and in one
pass. But the solution's headline — *where a unit's state lives is exactly three
homes, no fourth* — is, by the authors' own twice-repeated admission, established
only for the single-relationship case and assumed for the general one. A solution
whose completeness rests on a disclosed-but-unproven load-bearing lemma is right
*modulo an assumption the reader must grant*; it is not yet obviously right.
Close — R1 is the only substantive item, and it is a known, named, contained gap.
