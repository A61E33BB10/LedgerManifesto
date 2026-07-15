# FORMALIS — States, Round 3

**Verdict: OBVIOUS**

## Lens

Correctness must be *visible*: conservation and deterministic replay are evident
consequences of the structure, and no load-bearing fact of the essence is
dropped, weakened, or hidden to read cleaner. VETO if simplicity was bought
against a KEEP item.

## Conservation is visibly forced

The argument is a two-line induction the reader can carry out unaided:

- **Base.** `emptyLedger` has every map empty, so for every `u`,
  `netBal = foldMap psBal [] = mempty`.
- **Step.** `applyMove` is the *only* writer of `psBal`, and it writes the two
  legs `negQty q` (source) and `q` (destination) together from one quantity, so
  each move changes the holding sum by `negQty q <> q = mempty`. `register` and
  `settle` touch only `ledgerPT` / `ledgerUS`, never `psBal`.

Three things make this airtight rather than asserted, and all three are present
in the text:

1. **The sole-writer claim is true.** Verified against `States.hs`: `register`
   writes `ledgerPT`/`ledgerUS`; `settle` adjusts `ledgerUS`; only `applyMove`
   constructs `psBal`. The document states it and the code bears it.
2. **No minting door.** There is no primitive that credits one side without
   debiting the other — every move is a transfer whose two legs are derived from
   a single `q`. The `findWithDefault zeroP` first-touch creates both rows, never
   one. The `from == to` case still nets `mempty`. So `Σ = 0` holds for *every*
   unit, including units that enter only via moves.
3. **The constructor is sealed.** `Ledger`/`PositionState` constructors are not
   exported, so no importer can lay down a non-cancelling assignment. The
   invariant is of the writer, and the only writer writes it balanced. The
   document says exactly this ("the sealed constructor leaves no other door").

The text also correctly refuses to over-claim: `psHwm` adds but is never written
as cancelling legs, so it carries no zero-sum invariant — conservation is a
property of *how a field is written*, not of its type. This is the right
distinction, stated plainly.

## Deterministic replay is visibly forced

`apply` is a total, pure function of `(Event, Ledger)`: the `Event` match is
exhaustive over three constructors, each delegate returns `Maybe` and is total.
`replay = foldM (flip apply)`. Determinism follows from purity; checkpoint
soundness follows from the monadic left-fold law (`foldM` over a concatenation =
`foldM` of the prefix, then of the suffix from where it stopped), which holds in
`Maybe`. The `Maybe` is `foldM`'s failure channel — "two replays differ only if
one refuses an event, and then both do." All of this is correct and self-evident
from the shown code.

## KEEP items — all present, none weakened

1. Three homes, no fourth — §Answer + §Why Three, the 2×2 with three occupied
   cells and the empty cell argued, not merely asserted. ✓
2. No wallet-keyed economic sector — "No fourth home holds economic state" plus
   the KYC/permissions = identity-not-economic carve-out. ✓
3. Never-held vs held-and-flat — `holding` returns `Nothing` (no key) vs
   `Just 0` (key, flat); the replay paragraph ties flat-row retention to the
   distinction. ✓
4. Three forcing reasons, each by a concrete example (buyer +1000 / seller −1000;
   one settle price read identically; terms append vs status overwrite) — §Why
   Three, not by elimination. ✓
5. Conservation + deterministic replay shown forced by the structure — §Why It
   Is Right. ✓
6. Mandate-as-unit grounding the absence of a fourth sector (−1 manager / +1
   client, summing to zero) — present, scoped to making the third home obvious,
   without importing the full managed-account treatment. ✓

The path (Pareto frontier, rejected designs, C1–C12, F1–F8, round counts,
mutation scores) does not appear. Dropping it cost no KEEP item.

## Residue considered and cleared

- The Ledger-level position accessor (the `Maybe PositionState` analogue of
  `holding`) is not given its own listing; the never-held/held-flat distinction
  is established at the `Balances` layer and carried by prose into replay. The
  load-bearing *fact* is visible and stated; only one accessor function is
  elided, and the `Map (WalletId,UnitId)` key makes the lookup identical. Not a
  weakening.
- The Position cell prose lists "accumulated cost, entry NAV" though the code
  carries only `psBal` and `psHwm`; `psHwm` openly stands as the illustrative
  non-conserved field, writer out of scope. This is disclosed, not hidden.

Neither rises to a dropped or hidden load-bearing fact.

A competent engineer reading these pages sees conservation fall out of "one
writer, two cancelling legs, sealed constructor, zero base case" and replay fall
out of "total pure step, monadic left fold," and reaches for no further proof.
The dropped proofs are not missed.

**OBVIOUS.**
