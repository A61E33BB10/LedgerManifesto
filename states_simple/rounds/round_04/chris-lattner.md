# chris-lattner — Round 4 — States.tex

**Verdict: NOT-YET**

## Lens

The simple path must *be* the whole document, and nothing present may fail to
serve the answer. The answer is: where a unit's state lives (three homes), and
that this placement yields conservation and deterministic replay. I read the
document end to end against that bar.

## What is right

The architecture is genuinely good and most of it stakes its own claims:

- The classification is a clean two-axis cut (depends-on × authorship), 2×2,
  three occupied cells, and the empty cell is *defended*, not asserted — including
  the managed-account objection (the one a sharp reader raises first), which is
  retired by reframing the mandate as an issued unit. That is meeting the reader
  where they are.
- The construction builds primitives each forced by the prior, and the sealed
  (unexported) constructors are the right move: they make "append-only terms" and
  "single psBal writer" hold by construction rather than by convention. The
  `Nothing`/`Just 0` distinction (never-held vs held-and-flat) is a real
  type-level distinction, not ceremony.
- The honesty about scope (hwm writer, amendment events out of scope) is correct
  and well-marked.

This is close. The reason it is NOT-YET is one load-bearing contradiction.

## Residue (the blocker)

**The thesis attributes the forcing to the wrong thing, and the proof says so.**

Line 47 (intro): *"This fixes where, and **shows the placement forces**
conservation and deterministic replay."*

Section 5 proves the opposite attribution:

- Conservation: *"Conservation is an invariant of **the writer, not the store
  type**, which can hold a non-conserving assignment"* and *"conservation is a
  property of **how a field is written, not of its type**."*
- Determinism: *"Replay is deterministic **because apply is a pure, total
  function**."*

Placement does not force either property. Placement is a *precondition*: keying
position by `(holder, unit)` is what keeps the two-leg cancelling write from
collapsing the buyer and seller into one number. But the document itself states
the store can hold a non-conserving assignment — so the keying permits, it does
not force. What forces conservation is the sealed single-writer discipline
(`applyMove` the only `psBal` writer, two legs from one quantity, unexported
constructor leaving "no other door"). What forces determinism is purity and
totality of `apply`. Neither is "the placement."

This is not a one-word slip — it is systematic across *both* promised properties,
and it sits in a project whose first principle is "a claim is proved, not
asserted." The headline asserts a causal story the proof contradicts. A competent
engineer reading the intro builds the model "the keys force the invariants," then
hits Section 5 and has to unwind it. That reconciliation work is exactly what
"obviously right" must not require.

Actionable fix: reword the thesis so the placement *enables* (makes conservation
expressible and replay well-defined) and the sealed single-writer discipline +
purity *force*. One sentence, and the document stops fighting itself.

## Residue (minor)

§4: `register` references `defaultStatus`; `applyMove` matches `Move u from to q`;
`Move`, `WalletId`, `UnitId`, `TermsVersion` are used but never declared in the
.tex. The prose ("Listed at registration") lets a reader infer
`defaultStatus = UnitStatus Listed`, and the doc points to States.hs, so this is
not a comprehension blocker — but a reader checking register/applyMove against the
document alone cannot confirm the initial stage or leg order. Either inline the
one-liners or state plainly these symbols live in States.hs. Not the reason for
NOT-YET; flagged for completeness.
