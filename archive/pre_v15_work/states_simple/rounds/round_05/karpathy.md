# Round 5 — karpathy review of states_simple/States.tex

## Verdict: OBVIOUS

The document now reads end-to-end in a single pass. The answer ("three homes, two
maps") and why it must hold both land without a leap or a backtrack. My two
blocking residues from round 4 are discharged at the exact locations I named, and
the second axis has been re-grounded in a way that also retires my standing
non-blocking honesty caveat.

## Round-4 residue, checked against the current text

**(1) The root dichotomy is now grounded at the point of claim.** §The Answer's
opening no longer asserts a flat either/or. It first scopes — "The scope is one
unit's state, so only the unit and a holder of it are in view" — then forces the
dichotomy with the reification clause: "no wider key arises, because a
relationship spanning several instruments --- a netting set, a cross-margin
portfolio, a cross-currency offset --- is itself a unit, and a fact about it is a
(holder, that-unit) fact." Both clauses I asked for (scope; cross-unit reified as
unit) are present where the reader needs them. The 2×2 is now forced, not posited.

**(2) The "No fourth home" paragraph now closes both exclusions explicitly.** It
states "This closes the holder-alone keying" for KYC/permissions/audit-cursor
(identity, not economic state), and immediately adds "The multi-unit keying was
closed already: a relationship over several units is itself a unit. Both
excluded." The reader sees both missing keyings accounted for, not one mistaken
for the whole.

## Independent re-walk (fresh, not deferring to round 4)

**Axis 2 reframed from authorship to correction discipline — a strengthening.**
The second axis is now "how a correction is recorded" (correctable definition,
append-and-keep, vs superseding observation, overwrite-in-place), not provenance.
The Status bullet drives it home with the index-provider example: same author,
two homes — "what places a fact is how its correction is recorded, not who
authored the number." This is what made my round-4 provenance caveat
non-blocking; making correction discipline the primary axis removes the caveat
entirely.

**The keying exhaustiveness is self-contained and does not lean on conservation.**
I tested the one sentence a cold reader is most likely to stop at — "a netting
set ... is itself a unit." The load-bearing claim there is purely about keys: if a
relationship is given a unit identity, then a fact about it under a holder is
(holder, that-unit) — a key already in the partition, not a wider one. That a unit
includes mandates and strategy contracts is a stated scope premise (§The
Question). The zero-sum decomposition of such a unit (the mandate −1/+1 in §Why
Three) is a separate, conservation concern; the partition does not depend on it.
So the surprising-sounding reification claim is, for the answer's foundation, an
obvious keying step, not a deferred leap.

**The empty fourth cell closes by an exhaustive dichotomy.** A (holder, unit)
fact is either ledger-internal (positions and folded fields — entry NAV folded
from the opening event with no prior version; high-water mark keeping only a
running peak; both superseding or write-once, never version-retained) or external
(custodian/prime-broker statements — boundary reconciliation inputs, not stored
definitions). Neither branch yields a version-retained definition, so the cell is
empty. The dichotomy (internal-derived vs external-supplied) is visibly complete
and each branch is discharged.

**Construction and proofs (re-verified, unchanged and still obvious).** Qty-as-
group → balance-as-transfer → status (price riding `Active`, illegal states
unspellable) → terms (NonEmpty, sealed constructor, `register` sole first-version
writer) → position → sealed two-map `Ledger` → writers → conservation → replay,
each step forced by the one before. Conservation: `applyMove` is the sole `psBal`
writer, writes two legs from one quantity (`negQty q <> q = mempty`),
base case `emptyLedger` sum zero, sealed constructor leaves no other door —
induction closes. Replay: pure total `apply`, `foldM` left-fold law gives
checkpoint-independence, `Maybe` is the only divergence and it diverges
identically. The prose matches the listings throughout (settle adjusts `snd`;
register refuses a present unit; applyMove gated on registration). No regression.

## Non-blocking (not residue; recorded for honesty in staking OBVIOUS)

- The reification mechanism that nets a relationship-unit to zero
  ("summing to zero like any issued unit") is shown only for the mandate in §Why
  Three, while §The Answer names netting set / cross-margin / cross-currency
  offset without the decomposition. This is correct to leave deferred — the
  partition needs only the keying step, not the netting — but a single clause at
  the netting-set mention tying it to the issued-unit zero-sum would spare the
  reader a momentary "is that really holdable?" eyebrow before §Why Three answers
  it. Cosmetic; does not gate comprehension of the answer.
- `psHwm` is carried though it stays zero in this file. Explained as a deliberate
  exhibit of a non-conserved field beside the conserved balance, and used in the
  conservation argument. Mildly unusual but justified in place.
