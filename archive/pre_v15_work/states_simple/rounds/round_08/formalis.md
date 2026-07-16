# FORMALIS — States.tex, Round 8

**Verdict: OBVIOUS**

## Lens

Is correctness *visible* — are conservation and deterministic replay evidently
consequences of the structure, with nothing load-bearing dropped, weakened, or
hidden to read cleaner?

## What I checked

I read `States.tex` against `SOLUTION_ESSENCE.md`, and cross-checked every
listing in the paper against `States.hs` to confirm the reproduced declarations
are faithful (they are; the elisions are derive-clauses and teaching scaffolding,
i.e. the path, exactly as the essence permits).

### KEEP items — all six present and load-bearing-intact

1. **Three homes, no fourth.** §Answer (Terms / Status / Position) and §Why Three
   (empty fourth cell). Present.
2. **No wallet-keyed economic sector.** §Answer (¶ "No fourth home holds economic
   state…") closes holder-alone keying; KYC/permissions/audit-cursor named as
   identity, not economic state. Present.
3. **never-held vs held-and-flat.** §Construction "Reading a position" — `Nothing`
   = never held, `Just`/`psBal 0` = held and flat, row retained by `applyMove`'s
   first touch and never deleted; both readings used (settlement entitlement vs.
   wash-sale lookback). Present.
4. **Three forcing reasons, by example not elimination.** §Why Three:
   buyer +1000 / seller −1000 (position), one settle price / one index level
   (status), append-version vs. overwrite (terms vs. status). Concrete, positive.
5. **Conservation + replay visibly forced.** §Why It Is Right — see below.
6. **Mandate-as-unit grounds reason 2.** §Why Three final ¶ (−1/+1, sums to zero,
   two mandates = two rows). Present and bounded.

### Correctness is visible

- **Conservation.** The argument is a clean structural induction: base case
  `emptyLedger` sum is zero; `applyMove` is the *sole* writer of `psBal` and
  writes `negQty q <> q = mempty`; `register`/`settle` touch only `ledgerUnit`;
  the sealed constructor makes the reach exhaustive ("no other door"). The paper
  is also honest that conservation is a writer invariant, not a store-type
  property, and that `psHwm` carries no such invariant. This is exactly the
  `{P} code {Q}` discharge I require, and it is forced by the shape.
- **Deterministic replay.** `apply` is pure and total (returns `Maybe`, defined on
  all inputs); `replay = foldM (flip apply)`; checkpointing sound by the monadic
  left-fold split law `foldM (xs++ys) = foldM xs >=> foldM ys`. Determinism
  follows from purity alone. No non-determinism source: `Data.Map` is ordered (not
  hash-keyed), and `Qty`'s fold is abelian, so `netBal` is order-independent.

### A divergence from the essence that is a *correction*, not a weakening

The essence (item 5) loosely ties row-retention to "replay is a plain left fold."
The paper instead states determinism comes from purity alone and assigns row
retention to the audit distinction (never-held vs. flat). This is the more precise
attribution: deleting rows deterministically would not break replay determinism,
whereas it *would* collapse the never-held/flat distinction. The paper keeps both
facts (KEEP 3 and KEEP 5) and attributes each correctly. FORMALIS reads this as a
gain in precision, not a dropped fact — no veto.

### Empty-fourth-cell soundness

§Why Three's "empty by the seal" gives a positive chain (every (holder,unit) fact
is ledger-owned and replay-recoverable; the minimal owned/recoverable fact is
never versioned; a definition there would double the writer of a fact `applyMove`
already owns, breaking the seal conservation rests on). This is the load-bearing
reason the fourth home is absent, and it is stated, not assumed away. The single
genuine assumption — that every multi-instrument relationship reduces to a unit
issued to its parties — is explicitly flagged as assumed-not-established (§Answer),
which is honest disclosure, not hiding.

## Residue

None.

— FORMALIS Committee
