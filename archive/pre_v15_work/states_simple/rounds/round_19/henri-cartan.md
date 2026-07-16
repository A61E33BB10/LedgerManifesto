# henri-cartan — States committee, Round 19

Verdict: **OBVIOUS**

Bar applied: the answer follows from its definitions so directly that the omitted
proof is not missed. Reader = a competent engineer who has never seen this problem.

## What was checked

The "answer" has three load-bearing parts: the placement (three homes, two maps),
and the two by-construction properties (conservation, deterministic replay). For each
I verified that the document's own text supplies the deduction rather than leaving it
to be supplied.

### Conservation (§5) — sound, proof present

- Invariant: for every unit `u`, the sum of `psBal` over holders is `mempty`,
  starting from `emptyLedger`.
- Only `applyMove` writes `psBal`. `register` and `settle` write only `ledgerUnit`
  (verifiable directly from the listings — neither references `ledgerPS`).
- `netDeltas f t q` yields `{f ↦ -q, t ↦ +q}` for distinct wallets (sum `mempty`);
  for a self-move `f == t`, `insertWith (<>)` combines `q <> negQty q = mempty`
  (Qty addition commutes, so the `insertWith` arg order is harmless), giving one
  `mempty` entry that `writeNet` skips. Per-unit sum change is `mempty` either way.
- Base case `emptyLedger` is zero; the three event kinds each preserve the sum.
  The prose states exactly this induction. Nothing omitted.

### Deterministic replay (§5) — sound, proof present

- `apply` calls only `register`/`settle`/`applyMove`; all total (no partial
  primitives; `NE.last` total on `NonEmpty`) and pure. Same stream → same ledger.
- `foldM (flip apply)` short-circuits on the first `Nothing`. Checkpoint soundness
  cites the monadic left-fold split law, which holds in any monad and is fair to
  treat as known for this reader.
- No event produces multi-version terms or nonzero `psHwm`, consistent with the
  file's "one version each / mempty here" claims; replay stays deterministic.

### The seal — addressed, not hand-waved

"No other door" rests on the unexported constructor and field selectors. The
document explicitly raises and closes the record-update bypass
(`l { ledgerPS = ... }`) and confines selectors to in-module use. Within `States.hs`
the single-writer discipline holds.

### Taxonomy (§2–§4) — complete within declared scope

The 2×2 (holder-dependence × authorship) gives three occupied cells. This rests on
the reification, which is shown for the mandate case (`-1`/`+1` summing to zero; two
mandates = two rows), with multi-instrument relationships explicitly scoped out. The
empty fourth cell is justified by design rationale (custodian/PB statements are
reconciliation inputs, not adopted authoritative records). These are stated reasons
inside an explicit scope boundary, not concealed gaps.

### Secondary listings spot-checked

`currentTerms = NE.last` agrees with `appendVersion` appending at the tail;
`Active Price` makes both "active without price" and "listed with price" unspellable;
`register` refuses a present unit; `position`'s `Maybe` separates never-held
(`Nothing`) from held-and-flat (`Just` zero-`psBal`); "held = nets nonzero" matches
`writeNet` skipping `mempty`.

## Residue

None located. The conservation and replay proofs are present and direct; the
placement argument is complete within its declared scope. No omitted proof is missed.
