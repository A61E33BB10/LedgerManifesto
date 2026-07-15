# karpathy — States, Round 11

Verdict: **NOT-YET**

## What works (verified, not just skimmed)

I traced the code, not only the prose. The mechanics are sound and the proofs in
§"Why It Is Right" land cleanly:

- `netDeltas`/`writeNet`: distinct wallets net `-q` and `+q`; a self-move folds both
  legs onto one key and `insertWith (<>)` collapses them to `mempty`, which `writeNet`
  skips. Conservation per unit therefore holds because `applyMove` is the only writer of
  `psBal` and always emits a cancelling pair on the same unit. The base case
  (`emptyLedger` sum zero) plus "register/settle never touch psBal" closes the induction.
  This is genuinely obvious.
- The NonEmpty + unexported-constructor + `register`-refuses-existing chain makes
  "registered but versionless" and "history shortened" both unrepresentable. Clean.
- `Lifecycle = Listed | Active Price` makes "active with no price" unspellable. Good.
- `position`'s `Maybe` distinction (never-held vs held-and-flat) is well motivated and
  matches the code (first touch writes a row; close-out leaves it at zero, never deleted).
- Determinism: `apply` is pure/total, `foldM` over `++` splits at any cut. Fine.

The spine of the argument — two questions give a 2×2, three cells occupied, three homes
collapse to two maps because terms+status share a key — is well constructed and pays off
its own opening promise ("three homes, two maps") inside §The Answer.

## Residue (the reason for NOT-YET)

### 1. The authorship column contradicts its own definition at first read — §The Answer, lines 69–72 vs lines 79–81 (primary)

The definition given immediately before the table (lines 70–72):

> "An externally authored fact is owned by an outside authority --- **the exchange**, the
> contract, **the reference-data provider** --- which the ledger consumes but never writes."

The table two lines later (lines 79–81) places under **ledger-authored / Status**:

> "lifecycle stage, **last settlement price**, current weights, **benchmark level**"

The settlement price is set by the exchange; the benchmark level comes from the
reference-data provider — the exact two authorities the definition just named as
*external*. A single-pass reader applies the definition literally ("ledger consumes but
never writes") and concludes these belong in the externally-authored column. They are in
the other column. At the table the reader hits an apparent contradiction.

The resolution exists, but only ~50 lines later: §Why Three line 128 ("a settlement is the
ledger's event, so the ledger overwrites the status it produced") and §Construction line
199 ("the price ... rides on the `Active` constructor ... data the stage carries"). The
distinguishing principle is real and correct — the *status/stage* is ledger-produced and
overwritten, the externally-originated number is payload riding on it, not an authority
record the ledger must preserve — but it arrives after the reader has already had to defer
a contradiction. That is a backtrack, which the bar forbids.

Actionable fix (one of):
- Add one clause at the table or right after the line-72 definition: the authorship test
  asks who owns the *record's history discipline*, not who originated the number — a
  settlement price is data the ledger's own `settle` event records and overwrites, hence
  ledger-authored, even though the exchange originated it.
- Or pull the line-128 sentence ("a settlement is the ledger's event ...") up to sit with
  the definition before the table is shown.

### 2. Unargued table examples sharpen the same snag — §The Answer, lines 79–81 (secondary, same root)

"current weights" and "benchmark level" appear only in the table and are never tied back
in code or argument. "benchmark level" (ledger-authored/Status) sits in the same row as
"benchmark identity" (externally-authored/Terms); a reader naturally asks why the
benchmark's identity is external but its level is the ledger's, and the file never answers
for the level specifically — it answers only for settlement price (line 128). Either drop
the unargued examples or let the settlement-price clause explicitly cover the level too,
so the parallel is stated rather than left for the reader to construct.

## Noted but not counted as residue

The pivotal universal — "the framework models every economic relationship a wallet has as
itself a unit the wallet holds" (lines 62–66, restated 156–158) — is generalized from a
single instance (the managed-account mandate). I do not count this against the bar because
the file explicitly labels it "the framework's stance in general," i.e. an adopted premise
of the surrounding framework rather than a claim this file purports to derive. Accepting it
as a stated axiom, the empty fourth cell follows. (If the committee wants this file fully
self-standing, that stance would need to be either proved or pointed to its source; as a
named premise it is acceptable.)

## Bottom line

The code and its two proofs are obvious. The *placement argument* — specifically the
authorship axis that defines the table's columns and the empty cell — forces a backtrack
at the table because two of its own listed examples (settlement price, benchmark level)
contradict the authorship definition stated two lines earlier, and the reconciliation lands
only much later. Fix the ordering/clause and this becomes OBVIOUS.
