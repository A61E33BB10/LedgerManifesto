# FORMALIS — States.tex, Round 9

**Verdict: OBVIOUS**

My lens: correctness must be *visible* — conservation and replay must be evident
consequences of the structure — and nothing load-bearing in the essence may have been
dropped, weakened, or hidden to read clean. I checked both halves.

## Conservation is visibly forced

The argument is a clean induction the reader can reconstruct unaided:

- **Base.** `emptyLedger` has both maps empty, so every per-unit holding sum is `mempty`.
- **Step.** `applyMove` is the *only* writer of `psBal`. It writes both legs from one
  quantity — `negQty q` at the source, `q` at the destination — so the net change to the
  per-unit sum is `negQty q <> q = mempty`. `register` and `settle` touch only
  `ledgerUnit`, never `psBal`.
- **Closure.** The `Ledger` constructor is unexported, so the only doors are these three
  writers; every reachable ledger therefore conserves.

I checked the two non-obvious edge cases and both conserve by the same structure:
- `q == mempty`: both legs are no-ops (`d == mempty = ps`), net change zero, no rows written.
- `from == to`: the legs nest (`leg to q (leg from (negQty q) ...)`), the second reads the
  updated map, net change `negQty q <> q = mempty`.

The invariant is per-unit (legs share `u`; `netBal` filters `u'==u`), matching the
issued-unit-sums-to-zero model the essence endorses (mandate `-1/+1`). Visible and correct.

## Deterministic replay is visibly forced

`apply` is pure and total (every branch returns a value, `Nothing` on a failed guard);
`replay` is `foldM (flip apply)`. Same events, same ledger. Checkpoint soundness rests on
the `foldM`-over-concatenation law, true in the `Maybe` monad. `Map.toList` is ordered and
`Qty` addition is commutative, so projections are order-independent. No source of
non-determinism survives.

## Every KEEP item is present and unweakened

1. Three homes, no fourth — §Answer 2×2 (three occupied cells), §Why Three. ✓
2. No wallet-keyed economic sector — KYC/permissions/audit ruled out as identity; mandate
   reified as a `(holder, unit)` position. ✓
3. Never-held vs held-and-flat — "Reading a position": `Nothing` (no key) vs `Just` row with
   `psBal` zero, retained because a close-out leg never deletes. Both readings cited
   (entitlement vs lookback). ✓
4. The three forcing reasons, each by a concrete example — buyer `+1000`/seller `-1000`;
   one settlement price/index level; the two correction disciplines (`appendVersion` keeps,
   `settle` discards). ✓
5. Conservation + replay shown forced by the shape, in a few lines. ✓
6. Mandate-as-unit grounds the absence of a fourth sector. ✓

## Why the simplifications are honesty, not concealment

- `psHwm` is carried but "stays zero here": this *exhibits* a non-conserved field beside the
  conserved `psBal` — load-bearing (it is why per-position state must hold more than a
  balance), not hidden.
- The amendment event / multi-version growth is out of scope, but the append-only discipline
  is preserved by the type (`NonEmpty`, unexported constructor) and demonstrated by the two
  writers' behavior. The load-bearing fact (two irreconcilable change disciplines) survives.
- "Covers every multi-instrument relationship is assumed, not established here" — the essence
  (KEEP 6) explicitly scopes the full managed-account treatment into the dropped path. The
  tex flags the assumption rather than burying it. This is the licensed drop, not a veto.

No DROP-list material leaked (no Pareto, no C/F catalogues, no round counts, no rejected
designs, no "we considered X").

## Veto check

No load-bearing fact was dropped, weakened, or hidden to buy simplicity. The code listings
are correct on the edges I exercised. A competent first-time reader sees conservation and
replay fall out of the sealed single-writer discipline and the pure total fold. The dropped
proofs are not missed.

**OBVIOUS.**
