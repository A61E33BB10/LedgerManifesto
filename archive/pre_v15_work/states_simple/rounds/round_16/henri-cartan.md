# Round 16 — henri-cartan on States.tex

**Verdict: OBVIOUS**

Bar applied: the answer follows from its definitions so directly that the omitted
proof is not missed. Reader = a competent engineer new to the problem.

## What I checked

I read `States.tex` in full and verified its load-bearing prose against the source
it reproduces, `States.hs` — in particular the module export list, since the entire
conservation argument rests on a seal that the .tex only asserts in code comments.

### The seal is real (the linchpin of "by construction")

The conservation and append-only claims reduce to two export facts. Both hold in
`States.hs`:

- `Ledger` is exported as a type only (line 61), without constructor or the field
  selectors `ledgerUnit`/`ledgerPS`. So no outside code can lay down a
  non-conserving position map by record construction or update. The .tex comment
  "constructor + field selectors not exported" is accurate.
- `ProductTerms` is exported without its constructor (line 47); only
  `currentTerms`/`appendVersion` and the sole first-version writer `register`
  reach it. History cannot be shortened. Accurate.

With the seal verified, "applyMove is the only door that writes psBal" and
"register/settle touch only ledgerUnit" are checkable from the listings, and the
inductive conservation argument (base: emptyLedger sum zero; step: each event
preserves per-unit netBal) is complete and direct.

### Formal claims follow directly from definitions

- **Conservation.** A move's effect is `netDeltas`, which places `negQty q` at the
  source and `q` at the destination; for distinct wallets they net `-q, +q`, for a
  self-move they collapse to `mempty`. `writeNet` skips `mempty` deltas. Either way
  the per-unit sum changes by `negQty q <> q = mempty`. register/settle do not touch
  `psBal`. Induction closes. No step is missing.
- **psHwm.** Set to `mempty` by `zeroP`, never written by `applyMove`
  (`cur { psBal = ... }` leaves it), so it stays zero in this file and carries no
  invariant — exactly as claimed.
- **The Maybe distinction.** `applyMove` only inserts/updates rows, never deletes;
  a zero/self-move writes no row. So `Nothing` = never held, `Just psBal=0` = held
  and flat. Direct from the code.
- **Deterministic replay.** `apply` is pure and total over `Maybe`; `replay` is
  `foldM`. Same stream from same start gives same ledger. Checkpoint-independence is
  the standard monadic left-fold law over concatenation. All immediate.
- **Projection.** Every field of `Ledger` is written only by the three events;
  from `emptyLedger` the state is a function of the stream alone. Direct.

I found no technical error and no silently skipped step in any claim presented as
proved.

## The one unproved element is openly declared, not missed

The exhaustiveness of "three homes, no fourth" rests on the reification premise:
every per-wallet economic fact is a position in some unit. The .tex proves this for
a single mandate (the managed-account paragraph, §Why Three) and states plainly,
twice (§The Answer line 58; §Why Three lines 148-149), that the multi-instrument
case is "assumed here, not proved." The empty fourth cell inherits the same
conditional.

Under this bar this does not block OBVIOUS. The bar asks whether an omitted proof
is *missed* — whether the reader hits an unexplained "why is this true?". Here the
reader does not: the dependency is named, the assumption is flagged as a hypothesis,
and the headline "no fourth home" is explicitly marked conditional on it. A declared
hypothesis is not a hidden gap. This is the project's prescribed handling of
unsettled content (flag, do not fill), and it is exemplary here — the document even
separates shape-guaranteed facts from writer-invariant facts so the reader is never
asked to take a discipline on faith as if it were a type.

## Conclusion

Every claim asserted as established follows from the definitions directly, the seal
on which "by construction" depends is genuine, and the single non-trivial premise is
disclosed as an assumption rather than passed off as proved. Nothing an omitted
proof would supply is missed.

OBVIOUS.
