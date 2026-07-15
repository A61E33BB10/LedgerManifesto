# KARPATHY review — States.tex, Round 12

Verdict: **OBVIOUS**

Reader assumed: a competent engineer, comfortable with monoids and able to
read Haskell narrated by prose. Never seen this problem.

## What I verified (not skimmed)

I traced every load-bearing claim against the listings rather than trusting the
prose.

### Conservation (the central correctness claim)
The proof in §"Why It Is Right" is a complete induction and follows in one pass:

- Base: `emptyLedger` has empty `ledgerPS`, so any unit's `netBal` is
  `foldMap` over `[]` = `mempty` = zero. True.
- Step, the only psBal writer: `applyMove`'s `netDeltas` produces, for distinct
  wallets, `{f: negQty q, t: q}`; the written deltas sum to
  `negQty q <> q = mempty`, so the holding sum is unchanged. For a self-move
  (`f == t`) the inner/outer `insertWith (<>)` collapse to `{f: mempty}` and
  `writeNet` skips it — sum unchanged either way. Verified by hand-evaluating
  `insertWith` order: `insertWith f k new old = f new old`, giving
  `qty <> negQty qty = mempty`. Correct.
- `register` / `settle` touch only `ledgerUnit`, never `psBal`. Verified in the
  listings. Sum unchanged.
- Closure: constructor and field selectors withheld, so no other door writes
  `psBal`. Stated and used correctly — this is what upgrades "holds for these
  writers" to "holds by construction."

Note the claim is true under both readings (per-unit, via `netBal`'s `UnitId`
argument, and global), since every move shifts within one unit. No ambiguity
that changes the truth value.

### Row semantics (held / held-and-flat / never-held)
Traced `writeNet`: a zero net is skipped (no row); a nonzero delta inserts/updates
and is never deleted, so a close-out leaves `psBal = 0` retained. Therefore
"ever named in a nonzero-netting move" iff a row exists iff `position` returns
`Just`. The `Nothing` vs `Just`-zero distinction the text leans on is real and
preserved. Consistent.

### Determinism / replay
`apply` is total (each of `register`/`settle`/`applyMove` returns `Maybe`, no
partial patterns, no error) and pure, so same events → same ledger. The
`foldM`-splits-at-a-cut law is a genuine monad law, correctly cited for
checkpointing. Followable.

### Placement (the 2x2)
Two binary questions give an exhaustive 2x2 by construction; three cells get
concrete, independent justifications:
- Position keyed by (holder,unit): buyer +1000 / seller -1000 cannot collapse to
  one number. Decisive.
- Status keyed by unit alone: one value read identically; per-holder copies drift
  = reconciliation break. Decisive.
- Terms distinct from Status: external authority owns and restates (append,
  `appendVersion` keeps) vs ledger owns and overwrites (`settle` discards).
  Co-mingling is the SSOT violation. Clear.
- Empty fourth cell: no authority issues a fact about one holder's position;
  custodian/PB reports are reconciliation inputs, not adopted records. The
  managed-account "counterexample" is dissolved (mandate is itself an issued
  unit, -1/+1, so its HWM is a (client, mandate-unit) fact). Convincing.

The type-level points check out too: `Active Price` makes "active without price"
and "listed yet priced" unspellable; `NonEmpty TermsVersion` makes "registered
but versionless" unrepresentable; withheld `ProductTerms` constructor blocks
laying down a fresh one-version value.

## Why not NOT-YET

I looked hard for a blocking leap. The strongest candidate was the §Answer claim
"every economic relationship a wallet has is itself a unit," a universal
supported in-text by one forward-referenced instance. But it is presented as an
inherited framework premise, and — decisively — it is not actually load-bearing
for any correctness conclusion: each placement (Position's key, the empty cell)
carries its own concrete, self-standing argument in §"Why Three." So a reader who
withholds assent to the universal still reaches every conclusion. Not a blocker.

Forward references (§why, §right) defer justification but are resolved in reading
order, not circularly. Dense register, but no backtracking is required: the prose
narrates each listing so a non-Haskeller can follow `insertWith`, `adjust`,
`foldM`, `NonEmpty`.

No correctness gap found. No load-bearing claim rests on faith. The answer
(three homes, two maps) and why it must hold are visible in a single pass.
