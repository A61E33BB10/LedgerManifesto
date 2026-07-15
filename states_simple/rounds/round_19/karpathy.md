# karpathy — States.tex, Round 19

Verdict: **OBVIOUS**

Bar applied: a competent engineer who has never seen this problem sees *what* the answer
is and *why* it must hold in a single pass — no leap of faith, no backtracking.

## How I checked

I did not trust the prose. I traced the code listings by execution on a small batch
(register ES, move 1000 SELLER→BUYER, settle, close out), and cross-checked against the
runnable `States.hs`, whose GHCi transcripts and `main` reproduce exactly the behaviour
the .tex claims. The code is correct, and it is correct for the reasons the .tex gives.

Specific traces that hold:

- `netDeltas` for two distinct wallets yields `{f: -q, t: +q}`; for a self-move the two
  legs land on one key and `insertWith (<>)` collapses them to `mempty`. `writeNet` skips
  `mempty`, so neither a zero-quantity move nor a self-move writes a row. Matches the text
  ("held means named in a move that nets nonzero on it") exactly.
- `applyMove` is in fact the only writer of `psBal`; `register`/`settle` touch only
  `ledgerUnit`. So the conservation argument ("only door that writes the balance writes it
  balanced, sealed constructor leaves no other door, every reachable ledger sums to zero
  from emptyLedger") closes at the module boundary. The withheld constructor + selectors
  genuinely block the `l { ledgerPS = ... }` bypass the text names.
- `foldM` over `Maybe` obeys the concatenation law, so the checkpointing claim is sound;
  `apply` is pure and total (returns `Maybe`), so determinism holds.
- The "priced iff active" correlation rides on the `Active` constructor, not a parallel
  field, so both illegal states are unspellable — by the type, not a writer. Correct.

## Why it clears the bar

The document is result-first throughout and every deferral is *signposted*, so the reader
is never asked to believe something unproven without being told where the proof lands:

1. **The answer is a derivation, not an assertion.** Two binary questions (holder-dependent?
   externally authored?) give a 2×2; the key axis is justified by scope (only unit and a
   holder are in view) and the reification; the authorship axis is binary by definition.
   Three cells occupied, one empty — each justified concretely in §why.

2. **The cell/home vocabulary is self-defined and consistent.** §answer states "Each
   occupied cell is a home" — four cells, three homes. So "the fourth cell is empty" (a grid
   slot with no home) and "a fourth home" for a multi-instrument fact (a fourth *occupied*
   state, lying outside the 2×2 entirely) do not collide; they are consistent under the
   stated distinction. I specifically stress-tested this for a misread and it survives.

3. **Each home's necessity is shown with a vivid, minimal example.** Buyer +1000 / seller
   −1000 forces the holder into the key; one settlement price copied per holder "free to
   drift apart" forces the unit-only key; differing authorities of record force terms apart
   from status. These are the "overfit one batch" checks — each is a single concrete case
   that makes the general rule unmissable.

4. **The one genuine assumption is disclosed as an assumption.** The reification is *proved*
   for the single mandate (−1 manager / +1 client, summing to zero) and the multi-instrument
   case is explicitly declared out of scope / assumed, not smuggled. That honesty is what
   keeps "three homes, no fourth" from being a leap of faith — the boundary is drawn in ink.

5. **The two properties land cleanly.** Conservation is correctly framed as a writer
   invariant (the store type can hold a non-conserving map), and the seal is what makes the
   reachable set exhaustive. Replay determinism reduces to purity + totality of `apply`.

## Residue

None that crosses the bar. The prose is dense (STYLUS-compressed), and the term
"reifies as a single unit" arrives in §answer's first sentence before its proof — but it is
glossed inline ("a holding, a mandate, a strategy") and carries an explicit forward
reference to §why, which is the document's consistent result-first pattern, not a hidden
gap. Every cross-reference is a signpost, not a debt the reader must discover. I looked for
a correctness error or an unsupported load-bearing claim and found neither.
