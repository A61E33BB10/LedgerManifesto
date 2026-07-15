# henri-cartan — Round 7 — States.tex

## Verdict: NOT-YET

## What is obviously right

Two of the three substantive claims hold by construction and need no proof beyond
what is on the page:

- **Conservation.** The argument is a clean induction with the inductive step
  exhibited algebraically. `applyMove` is the sole writer of `psBal`; it writes
  `negQty q` and `q`, whose sum is `mempty`; `register`/`settle` do not touch
  `psBal`; `emptyLedger` has sum zero; the sealed constructor admits no other
  writer. The per-unit net therefore stays zero on every reachable ledger. The
  self-transfer case (from == to) is not separately discussed, but the sequential
  `leg` composition still nets to zero, so the omission is not missed. Solid.

- **Deterministic replay.** `apply` is pure and total (every branch returns a
  `Just`/`Nothing`; no partial patterns; `NE.last` on `NonEmpty` is total),
  so equal event sequences yield equal ledgers. Checkpointing follows from the
  `foldM` left-fold split law. Obvious as stated.

The construction (homes, maps, writers) is concrete and the co-presence of terms
and status is enforced by the pair-valued map rather than by an invariant, which
is correctly noted.

## Residue (why not OBVIOUS)

The central answer is not conservation or replay — it is the *placement*: that a
unit's economic state lives in exactly three homes on exactly two keys. That
result rests on the exhaustiveness of the key dichotomy {unit, (holder, unit)},
and the exhaustiveness is asserted, not derived. Two located gaps:

1. **"economic state" is the load-bearing discriminator and is never defined.**
   Location: §The Answer, final paragraph (lines 96–103, "No fourth home holds
   economic state ... is identity, not economic state, and is none of the three").
   The closure of holder-alone keying turns on classifying KYC, permissions, and
   the audit cursor as "identity, not economic state." Without a definition of
   "economic state," this classification is enumeration by example, not deduction;
   a fresh reader cannot check it or extend it to a fact not on the list.
   Actionable fix: define "economic state" by a positive criterion (e.g. state
   that participates in conservation, valuation, or P&L projection), then the
   wallet-only exclusion follows from the definition rather than from a list.

2. **The "no wider key arises" claim is generalised from a single worked case.**
   Location: §The Answer, lines 60–63 ("a relationship spanning several
   instruments is itself a unit issued to its parties"), supported only by the
   managed-account mandate of §Why Three. The collapse of every multi-instrument
   relationship to a (holder, that-unit) fact is a modelling postulate on which
   the entire "three homes" count depends — if one genuinely multi-unit-keyed
   fact existed (a cross-margining or netting-set relationship not itself reified
   as a unit), a fourth home would appear. One example is exhibited and the
   conclusion is stated universally. By the project's own bar ("a claim is proved,
   not asserted"), this reification should be an explicit assumption/lemma with an
   argument that it covers all multi-instrument relations, or the scope should be
   narrowed to the class it does cover. As written, the proof a competent reader
   would want is omitted and missed.

Both residues sit in the same place: the 2×2's *key* axis is exhausted by
assertion, while its *correction-discipline* axis (append-keep vs
overwrite-in-place, deletion barred by immutability) is genuinely argued to be
exhaustive. Close the key axis to the same standard and the placement becomes
obvious.
