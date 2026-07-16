# henri-cartan — States.tex, Round 13

## Verdict: NOT-YET

The formal core is obviously right and is genuinely proved, not asserted. The single
residue is a universal completeness claim whose supporting proof is explicitly omitted.

## What is obviously right (no missing proof)

- **Conservation (§Why It Is Right, lines 350–360).** The argument is complete and
  follows directly from the code: `applyMove` is the sole writer of `psBal`; it writes the
  two legs `negQty q` and `q` for one unit; their sum is `mempty`; `register`/`settle`
  touch only `ledgerUnit`; base case `emptyLedger` sums to zero; the sealed constructor and
  withheld selectors leave no other door. Induction closes. The self-move/zero-move case
  (zero legs written) is handled in §Construction (lines 299–328) and the net delta is
  `mempty` either way, so the slightly loose phrasing "writes the two legs together" in
  §right does not break the conclusion.
- **Deterministic replay (lines 367–386).** `apply` is pure and total over the three
  events; `replay = foldM (flip apply)`; checkpointing soundness rests on the standard
  `foldM`-over-concatenation law for `Maybe`. Complete.
- **The code itself.** `netDeltas`/`writeNet` net correctly for distinct wallets and for
  self-moves; `register` refuses duplicates; `settle` overwrites only the status half via
  `Map.adjust` on `snd`; the seal (unexported constructor + selectors) genuinely blocks the
  record-update bypass it names; `position`'s `Maybe` cleanly separates *never held* from
  *held and flat*. No bug found.

## Residue (located, actionable)

**The headline completeness claim "exactly three homes / fourth cell empty by
construction" rests on a universal that is admitted unproven.**

- Location: §The Answer, lines 60–67 ("Every economic fact about a wallet ... is a
  (holder, unit) fact on a reification: every economic relationship a wallet has is itself
  a unit the wallet holds"); and §Why Three, managed-account paragraph, lines 154–161, plus
  the fourth-cell paragraph, lines 144–152.
- The defect: the document states "exactly three homes carry state" and "the externally
  authored cell is empty by construction" as universals, but the step that forces *all*
  economic wallet-state into the (holder, unit) home — that every economic relationship
  reifies as one unit — is proved only for a single managed-account mandate (one `+1/-1`
  unit). The document twice concedes (lines 65–67, 160–161) that the multi-instrument case
  "is assumed, not proved here." A single example is not a proof of a universal, so the
  word "exactly" and the phrase "by construction" overclaim relative to what is
  established. By the project's own standard (CLAUDE.md: "A claim is proved, not
  asserted"), this is the one place the omitted proof is missed: a competent reader meeting
  "exactly three homes" and then "assumed, not proved" is left to take the completeness of
  the placement on faith.
- Actionable fix (either suffices):
  1. Prove that a relationship spanning several instruments reifies as a single unit (one
     `(holder, unit)` row) — i.e., that no multi-instrument economic relationship requires
     a wallet-keyed economic home; or
  2. Restrict the headline claim to its proved scope (single-instrument / single-mandate
     relationships) and state the multi-instrument reification as declared future scope,
     so the universal "exactly three / fourth cell empty by construction" no longer exceeds
     what is shown.

## Not raised as residue

The wallet-alone facts (KYC, permissions, audit cursor) classified as "identity, not
economic state" (lines 67–69) are placed by definitional carve-out rather than proof; this
is an acceptable boundary, not a missing proof, and I do not count it against the verdict.
