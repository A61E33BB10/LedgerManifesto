# henri-cartan — Round 6 — States.tex

## Verdict: NOT-YET

The formal core is, to my eye, obvious in the strict sense: its omitted proofs are
not missed. Conservation, deterministic replay, and the unrepresentability of
illegal states follow from the definitions directly. One classification step does
not — and a competent reader who has never seen this stumbles there.

## What is obviously right (no residue)

- **Conservation (§Why It Is Right).** `applyMove` is the sole writer of `psBal`;
  it composes two legs `negQty q <> q = mempty` on the abelian `Qty` group;
  `register`/`settle` leave `psBal` untouched; `emptyLedger` has per-unit sum
  `mempty`. The induction closes, and the algebra even covers the `from == to`
  case (both deltas compose on one entry, netting `mempty`), so no case is
  silently dropped. The unexported `Ledger` constructor seals the only other door.
  Proof present, forced, not missed.
- **Deterministic replay.** `apply` is total (every branch is `Map.member` +
  total map op) and pure; `replay = foldM (flip apply)`; checkpoint soundness is
  the `Maybe` monad left-fold law. Each claim is discharged from the code shown.
- **Illegal states.** `NonEmpty` forbids "registered but versionless"; `Price`
  riding on `Active` forbids "active without price"; unexported constructors close
  the bypasses. Each is checkable against the listing and holds.
- **Occupied cells (§Why Three).** Position-needs-holder (buyer +1000 / seller
  -1000), status-is-shared (one value, one writer), terms-vs-status (two
  correction disciplines cannot inhabit one cell) are each given one concrete,
  sufficient reason. The managed-account counterexample is explicitly dismantled.

## Residue (located, actionable)

**The 2×2's column axis is defined by one criterion and the empty cell is proved by
another; the linking equivalence is asserted, not derived.**

- §The Answer (lines ~64–67) defines the second axis as *correction discipline*:
  append-a-version-keep-the-prior (definition) versus overwrite-in-place
  (observation). It then insists — correctly and pointedly — that this axis is
  *not* provenance: "what places a fact is how its correction is recorded, not who
  authored the number ... the same index provider's benchmark identity is terms,
  its benchmark level status." So an externally-authored fact may land in *either*
  column.

- §Why Three, fourth-cell paragraph (lines ~132–146) proves the empty cell on a
  *different* axis — provenance: "the ledger versions what it receives, derives
  what it owns. A position is owned ... so no received per-(holder, unit)
  definition exists to version." The conclusion "only the unit key receives one"
  turns on *received* (provenance), whereas the grid's column turns on *correction
  discipline*.

- The document senses the seam and patches it with a disclaimer ("This does not
  reopen authorship ... the question here is which key may host a definition at
  all"). A disclaimer at the exact point a reader expects a derivation is evidence
  the gap is real. The hinge that the disclaimer presumes — *append-keep discipline
  is warranted exactly for facts whose priors the ledger cannot reconstruct from
  its own stream* — is the theorem that makes the two axes coincide and the fourth
  cell empty by the grid's own column definition. Its two ingredients are both in
  the text but scattered: "auditable at the boundary" (received priors are
  irrecoverable, so kept) and "any prior recovered by replay" (owned priors are
  recoverable, so not kept). The minimalism that forbids storing the recoverable
  is a project axiom, not invoked here.

**Action.** At the 2×2 (§The Answer), state the biconditional once and derive it:
append-keep discipline is adopted *iff* the prior cannot be reconstructed by replay
(received boundary artifacts), and overwrite *iff* it can (ledger-derived facts);
by minimalism the recoverable is never versioned. Then the (holder, unit) row —
where the ledger is sole writer and every prior is replay-reconstructible — has no
append-keep cell as a *consequence of the column axis itself*, and the fourth-cell
paragraph's provenance language becomes a theorem rather than a second, separately
introduced criterion. With that one sentence the placement is forced; without it the
reader must assemble the bridge from three distant passages, which is exactly the
re-read the document otherwise never demands.

## Secondary (minor, not load-bearing)

- The correction-discipline axis is presented as binary (append-keep / overwrite)
  without an explicit word that these exhaust the disciplines a record-of-truth may
  use (immutable folds into terms-with-one-version; write-once owned folds into
  observation; delete is excluded by the immutability premise). One clause naming
  this exhaustion would seal the axis. Not required for the verdict.
