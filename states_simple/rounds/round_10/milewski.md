# Round 10 — milewski review of states_simple/States.tex (+ States.hs)

## Verdict: OBVIOUS

My lens (Hutton bar): each step obvious from the last, nothing assuming the answer in
advance, no abstraction arriving before it is earned. The thread clears it.

## What I checked this round

Both R10 fixes (settled per my memory) are present and correct:

1. **Self-move / zero-move conjure no row — now one rule.** `applyMove`
   (States.hs:520-555) computes the move's per-wallet *net delta* first
   (`netDeltas f t q = Map.insertWith (<>) t q (Map.insertWith (<>) f (negQty q)
   Map.empty)`), then folds `writeNet`, which skips any wallet whose net is `mempty`
   (`| d == mempty = ps`). Type-correct: `netDeltas :: ... -> Map WalletId Qty`;
   `Map.foldrWithKey writeNet (ledgerPS l) :: Map WalletId Qty -> Map (WalletId,UnitId)
   PositionState`. For `from /= to` this is the same two `±q` rows as the step-4
   transfer; for `from == to` the two legs land on one wallet and cancel to `mempty`,
   so nothing is written. The zero-quantity case (R9 guard) and the self-move case
   (R10) are now **one** rule — net-zero ⇒ no row — not two. This closes the
   self-move sub-threshold note I surfaced in R9: "held = named in a move that nets
   nonzero on it" is now a clean, single definition, and the never-held vs
   held-and-flat distinction is protected uniformly. Conservation is untouched: the
   net map still sums to `negQty q <> q = mempty` over wallets.

2. **"No fourth home" stated conditionally, not asserted.** The .hs (421-435, the
   step-10 summary 778-781, the top teaser 14-17) now says no-fourth holds *given*
   the reification "every per-wallet economic fact is a position in some unit,"
   shown for the single-mandate case (n=1) and **assumed** for the general
   multi-instrument case. The .tex discloses the same (62-64: "that it covers every
   multi-instrument relationship is assumed, not established here"; 163-170: the
   mandate "discharges this assumption for one relationship"). This is the decisive
   Hutton-bar point: the file does **not** assume its own headline — it flags the
   one unproved link and conditionalises the conclusion on it. An honest conditional
   passes "nothing assuming the answer in advance" precisely because it names what is
   not yet proved.

## Fresh Hutton-bar pass (clean)

- **No abstraction before its referent.** `Qty` is named a monoid/group only after
  the instances are written (102-118); `foldMap` for conservation only after the
  monoid exists (190-193); `foldM` for replay only once the threaded-with-failure
  fold is on the page (704-709). Every name lands on a thing already built.
- **Homes discovered bottom-up, not declared.** The .hs does not open with the 2×2
  taxonomy; it reaches each home when its distinguishing reason appears — status
  because one value is read identically by all (step 5), terms because the change
  discipline differs (step 6), the pair-collapse because both share the unit key
  (step 8). The destination is derived, not assumed. (The .tex presents the 2×2
  top-down in §The Answer — that is the formal companion's job and STYLUS's prose,
  outside my code+laws lens.)
- **The step-4 → step-8 move refactor is earned.** Step 4's naive two-leg `transfer`
  becomes step 8's net-first `applyMove`; the comment (526-550) motivates the change
  by the load-bearing never-held distinction that only matters once positions are
  real. A legitimate Hutton refinement, not a silent rewrite.
- **Laws stated and honestly classified** (the step-10 shape-enforced vs
  soundness-argued split, 798-814): conservation = writer invariant (sole `psBal`
  writer writes two cancelling legs; sealed constructor makes the reach exhaustive
  from `emptyLedger`); append-only terms = `NonEmpty` + unexported constructor +
  `register` refusing duplicates; priced-iff-active = shape (`Active Price`);
  co-presence = pair shape; replay determinism = purity of `apply` + the monadic
  left-fold law. None dressed as a shape it is not.
- **Totality / determinism** hold by reading: `currentTerms` total via `NonEmpty`;
  `settlementPrice` total over both reachable cases; all three writers total,
  returning `Nothing` only for an out-of-bounds unit; `apply` a pure total function
  of event and prior ledger. No GHC in env; verified by inspection.

## Non-blocking note (carried, not residue)

The .tex listings render `TermsVersion` (233) and `Move` (313) as positional
constructors where the .hs uses records (327-329, 513-518) — a minor strain on
"the listings reproduce its declarations." Carried unblocking since R5; cosmetic
cross-artifact fidelity, author's call. Not a correctness or clarity defect; the
.tex is internally self-consistent.

Residue: empty.
