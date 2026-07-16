# Round 3 — henri-cartan (rigour / documentation architecture)

**Verdict: OBVIOUS**

## Lens

Does the answer follow from its definitions so directly that the omitted proof
is not missed? My checks: definitions precede use, proofs complete, no
handwaving, cases exhaustive, no notation collision.

## What I verified

The document carries two classes of claim, and neither leaves a missed proof.

### Formal claims — proofs present and direct

- **Conservation.** Base case (`emptyLedger`, per-unit `netBal = mempty`) plus
  inductive step: `register`/`settle` touch only `ledgerPT`/`ledgerUS`;
  `applyMove` writes two legs from one quantity into a single unit, changing
  that unit's sum by `negQty q <> q = mempty`. I checked the `from == to`
  degenerate case: legs are sequenced, the single cell returns to `cur`, net
  zero. The sum argument is robust to whether one or two cells change. The
  invariant proven is the strong one — every unit's total net is exactly zero
  (no minting; units are issued). Sound induction.
- **Deterministic replay.** `apply` is pure and total (total Map and Integer
  ops), so identical events from identical `l0` give identical results,
  including identical `Nothing`. Checkpoint soundness rests on the genuine
  `foldM` monad law, which short-circuits correctly under `Maybe`. Direct.

### The placement argument — forced, not asserted

The 2x2 axes (dependency key; retention discipline) are justified bottom-up:
each occupied cell carries a concrete forcing reason (two holders hold opposite
quantities -> holder in key; one writer -> unit key; differing history
discipline -> terms apart from status). The wallet-alone dependency is excluded
by argument, and the empty fourth cell is closed by the mandate reduction: any
external, per-relationship, version-requiring fact is modeled by issuing a unit
whose versioned facts land in the *terms* cell, never in the (holder,unit)-
retained cell. This disposes of the managed-account counterexample and supplies
the mechanism that keeps the cell empty by modeling discipline.

## Candidate gaps probed and dismissed

- **Universal emptiness of cell four vs. cost-basis / wash-sale / tax-lot
  history.** The document's stance is consistent: per-position history is
  recovered by replay; only externally-authored, directly-audited version lists
  are stored, and those attach to a unit (possibly a mandate unit), landing in
  the terms cell. The terms/position asymmetry is grounded in provenance and
  stated as such, not smuggled in.
- **Self-transfer (`from == to`).** Handled correctly by leg sequencing.
- **`Maybe` overloading.** Disambiguated explicitly: `Nothing`/`Just 0` for
  holdings, and `applyMove`'s `Nothing` guards input (unknown unit), never the
  balance invariant.

## Not residue (out of scope of this .tex)

`States.hs` field-selector export discipline (record-update mutation of `psBal`
by external code if labels are exported) is an implementation concern of the
companion module, not of the document under review. The .tex states the sealing
intent, and `psBal` write-once-writer is its abstract claim.

## Conclusion

Definitions precede use throughout; the proofs that matter are present and
follow directly; where the document argues rather than proves (the taxonomy),
each cell carries an explicit forcing reason and the empty cell a closing
reduction. No omitted proof is missed. OBVIOUS.
