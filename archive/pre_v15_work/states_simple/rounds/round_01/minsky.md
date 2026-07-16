# minsky — Round 1

**Lens:** Do the types make the illegal states *visibly* impossible — does the reader *see* it, rather than take it on faith?

**Verdict: NOT-YET**

The document earns three genuine, self-evident wins, and then overstates a fourth in
exactly the way my lens exists to catch.

## What is genuinely obvious (credit where due)

- **`ProductTerms (NonEmpty TermsVersion)`** makes "registered but versionless"
  unrepresentable, and `currentTerms` is total via `NE.last` with no `Maybe`. This is a
  real *illegal-states-unrepresentable* result, visible from the type alone. (States.hs
  254–260; States.tex 167–171.)
- **A move carries one `mvQty`**; `applyMove`/`transfer` derive the two legs as `q` and
  `negQty q` from that single quantity. An unbalanced *single move* is genuinely not a
  sentence the language can write. Visible. (States.hs 192–195, 367–382.)
- **`Maybe` on `holding`/`position`** keeps never-held (`Nothing`) apart from held-and-flat
  (`Just`), and the distinction survives the upgrade to a record. Visible and correct.

## Residue that blocks obviousness

### 1. Ledger conservation is presented as a property of the shape; it is a property of the API.
States.tex 201–207 claims "For every unit, the holdings sum to zero ... This is a fact of
the shape, not a check run afterward," and States.hs 206–207 reinforces it: "not a
precondition the caller is trusted to honour." But the store is
`Map (WalletId, UnitId) PositionState` (and the pedagogical `type Balances = Map ...`),
and that type *freely represents non-conserving states* — the document itself builds one at
States.hs 143 (`Map.fromList [((wB,uES), Qty 1000)]`, net 1000). Conservation holds only
because the `Ledger` constructor is unexported and all three builders (`emptyLedger`,
`register`, `applyMove`) preserve `netAc l u = 0` by induction. That is *illegal states made
unreachable via encapsulation*, **not** *unrepresentable via the shape* — precisely the
distinction this lens turns on. A reader who reads the type to verify the claim finds the
claim false at face value. Note the inconsistency: the terms/status coherence invariant is
described honestly as resting on the hidden constructor (States.hs 322–329), while
conservation — which rests on the *same* hidden constructor — is described as "the shape."
Fix: state conservation as an inductive invariant of the exported API, and exhibit its small
audit surface (the only three functions that return a `Ledger`), or make the sum-to-zero
genuinely unrepresentable.

### 2. "Retained rows ⇒ replay is a fold" is a non-sequitur.
States.tex 208–221 / States.hs 463–470 justify checkpoint-independence by "closed positions
are kept ... so the set of keys never shrinks, and replay is a plain fold." The actual reason
`replay (xs ++ ys) l0 == (replay xs l0 >>= replay ys)` is the monadic left-fold law on
`foldM`, full stop — it holds whether or not closed rows are deleted. Deleting flat rows would
break the never-held/held-flat distinction (a semantic concern), but would not make replay
non-deterministic or non-composable. The stated causal link does not hold, so the reader who
pauses on it does not find the section self-evident; they find an unsupported reason.

### 3. The terms-vs-status discipline (the load-bearing reason for *three* homes) is only half-realized.
"Why Three" rests on terms being append-only and status being overwrite-in-place (States.tex
83–89). The code shows the append discipline (`appendVersion`, no in-place rewriter), but
there is **no settle / status-overwrite function anywhere** — `applyMove` never touches
`ledgerUS`, and `Lifecycle` never transitions. So in the implementation both maps are written
once at `register` and the contrasting "overwrite" discipline that motivates the split is
never demonstrated. The reader cannot see the two disciplines differ because only one is
present. Add the overwrite path (a `settle`/status update), or weaken the justification to
what the code actually shows.

A document whose thesis is "each fact is visible in the shape" (States.hs 499–500) must not
rest its central correctness claim — conservation — on encapsulation it describes as shape.
Until residue 1 is reconciled, the correctness is asserted where it claims to be seen.
