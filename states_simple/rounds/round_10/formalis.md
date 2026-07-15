# FORMALIS — States.tex, Round 10

**Verdict: OBVIOUS**

My lens: correctness must be *visible* — conservation and deterministic replay must be
evident consequences of the structure — and nothing load-bearing in the essence may have
been dropped, weakened, or hidden to read clean. I re-read `States.tex` against
`SOLUTION_ESSENCE.md` and cross-checked every listing against `States.hs` (both edited
after round 9).

## Listings are faithful to the source

I verified the load-bearing declarations reproduce `States.hs` exactly:

- `applyMove` (tex 314–326) ↔ `States.hs` 520–555: same `Map.foldrWithKey writeNet …
  (netDeltas from to q)`, same `netDeltas` two-`insertWith` net, same `writeNet` with the
  `d == mempty = ps` short-circuit and `Map.findWithDefault zeroP` first-touch row.
- `register` (tex 292–296) ↔ 466–471; `settle` (tex 297–302) ↔ 485–490: `Map.adjust` over
  the pair's `snd`, terms untouched.
- `replay = foldM (flip apply)` (tex 381–383) ↔ 74-area export and the `foldM` import.
- `position` (tex 347–349) ↔ 505–506.

The elisions are derive-clauses and teaching scaffolding — the path, exactly as the essence
licenses.

## Conservation is visibly forced

A clean induction the first-time reader can reconstruct unaided:

- **Base.** `emptyLedger` has both maps empty, so every per-unit holding sum is `mempty`.
- **Step.** `applyMove` is the *sole* writer of `psBal`; it writes both legs from one
  quantity (`negQty q`, `q`), net change `negQty q <> q = mempty`. `register`/`settle`
  touch only `ledgerUnit`.
- **Closure.** The `Ledger` constructor is unexported — no other door — so every reachable
  ledger conserves.

Both edge cases conserve by the same shape: `q == mempty` (both legs no-ops, no row written)
and `from == to` (legs net on one wallet to `mempty`, no row written). The invariant is
per-unit (legs share `u`; `netBal` filters `u'==u`), matching the issued-unit-sums-to-zero
model (mandate −1/+1).

## Deterministic replay is visibly forced

`apply` is pure and total (every branch returns a value, `Nothing` on a failed guard);
`replay` is `foldM (flip apply)`. Same events → same ledger. Checkpoint soundness rests on
the monadic left-fold split law, true in `Maybe`. `Data.Map` is ordered (not hash-keyed) and
`Qty` addition is abelian, so `netBal` projection is order-independent. No non-determinism
survives. The paper correctly attributes determinism to purity and row-retention to the
audit distinction, not to replay — the more precise attribution, not a weakening.

## Every KEEP item present and unweakened

1. Three homes, no fourth — §Answer 2×2 (three occupied cells), §Why Three (empty fourth). ✓
2. No wallet-keyed economic sector — KYC/permissions/audit-cursor ruled out as identity;
   mandate reified as `(holder, unit)`. ✓
3. never-held vs held-and-flat — "Reading a position": `Nothing` (no key) vs `Just`/`psBal`
   zero, row retained because a close-out leg never deletes; both readings cited
   (entitlement vs lookback). ✓
4. Three forcing reasons by concrete example — buyer +1000/seller −1000; one settle
   price/index level; `appendVersion` keeps vs `settle` discards. ✓
5. Conservation + replay shown forced by the shape, in a few lines. ✓
6. Mandate-as-unit grounds the absence of a fourth sector (−1/+1, two mandates = two rows). ✓

## Honesty of the licensed drops

- `psHwm` carried but "stays zero here" *exhibits* a non-conserved field beside conserved
  `psBal` — load-bearing, not hidden.
- Amendment event / multi-version growth out of scope, but the append-only discipline holds
  by type (`NonEmpty`, unexported constructor) and is demonstrated by the two writers. The
  load-bearing fact (two irreconcilable change disciplines) survives.
- "Covers every multi-instrument relationship is assumed, not established here" is flagged in
  the open, scoped into the dropped path by KEEP 6 — disclosure, not concealment.

No DROP-list material leaked (no Pareto, no C/F catalogues, no round counts, no rejected
designs, no "we considered X").

## Veto check

No load-bearing fact was dropped, weakened, or hidden to buy simplicity. The §Answer
boundary-test paragraph is dense, but it *over*-states (fully present) the term/status
placement rule rather than hiding it — a STYLUS clarity matter, not a FORMALIS veto, and it
does not touch the visibility of conservation or replay. The code listings are correct on
the edges I exercised and faithful to the source.

## Residue

None.

**OBVIOUS.**

— FORMALIS Committee
