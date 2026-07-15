# MILEWSKI — Round 5 — `states_simple/States.tex` (+ `States.hs`)

## Verdict: OBVIOUS

My lens: does the Haskell read like Hutton — each step obvious from the last,
nothing assuming the answer in advance, no abstraction arriving before it is
earned? It does.

## What Round 5 changed, and why it clears the bar

The only material change since R4 is the collapse of the two unit-keyed maps
into one, plus un-exporting the step 3–4 scaffolding.

- **Two maps for three homes.** `ledgerUnit :: Map UnitId (ProductTerms,
  UnitStatus)` replaces the separate `ledgerPT`/`ledgerUS`. This is *earned*, not
  assumed: step 5 flags that status "shares a home with terms, assembled in step 8";
  step 6 observes both are unit-keyed and "need not be two maps"; step 8 then derives
  the pair from the plain fact that two maps under one key, obliged to rise and fall
  together, *already are* one map whose value is a pair. The reader meets the pair
  only after the reason for it is on the page. Co-presence becomes structural — "in
  terms but not status" is no longer spellable — which is the file's own step-5 rule
  (prefer the shape; disclose an invariant only when the shape cannot carry it),
  applied a second time. The append-vs-overwrite disciplines survive in the value
  types (`fst` a `NonEmpty` grown by `appendVersion`, `snd` overwritten by `settle`),
  so "third home, not third map" still holds.

- **The carried sub-threshold note from R3/R4 is now closed.** Previously `applyMove`
  gated on `ledgerPT` and `settle` on `ledgerUS` — equivalent only under the coherence
  invariant. With one map, all three writers (`register`, `settle`, `applyMove`) gate
  uniformly on `Map.member u (ledgerUnit l)`. The asymmetry is gone.

- **Conservation survives the collapse intact.** I re-checked the load-bearing point:
  `register` and `settle` write `ledgerUnit` only; `applyMove` writes `ledgerPS` only,
  as two legs `negQty q` and `q` from one quantity. So `psBal` is untouched by the two
  non-transfer writers, every move changes the holding sum by `mempty`, and from
  `emptyLedger` every reachable ledger conserves. Still honestly disclosed as a
  *writer* invariant (the store type can hold a non-conserving map), not as something
  the type forbids — the correct framing.

- **Un-exporting `Balances`/`holding`/`netOf`/`transfer`** is right: they are step 3–4
  scaffolding, genuinely superseded by `PositionState`/`applyMove`/`netBal`. Exporting
  them would offer a second, unsealed move API able to build a non-conserving balance
  map by hand. The export-list comment says exactly this. The thread still reads
  bottom-up with them present-but-sealed.

## Re-verified end to end

- **Naming after the thing.** `Qty` named a monoid/group only after the instances are
  written; `foldMap`, `foldM` named only once the page already shows what they are the
  word for. No abstraction precedes its motivation.
- **Totality.** `negQty`, `<>`, `holding`, `currentTerms` (total via `NonEmpty`),
  `appendVersion`, `settlementPrice` (both reachable cases), `register`/`settle`/
  `applyMove` (total, `Maybe`-valued), `apply`/`replay` (`foldM`). No partial function.
- **Determinism.** Pure core, no clock/randomness; `netBal`/`netOf` fold over
  `Map.toList` (key-ordered) and over the commutative `Qty` monoid, so order is
  irrelevant. `replay = foldM (flip apply)` is a pure function of events and start.
- **Checkpoint law.** `replay (xs++ys) l0 == replay xs l0 >>= replay ys` is exactly the
  `foldM`-over-concatenation law in `Maybe`; the GHCi instance on line 700/777 is a
  genuine instance of it, attributed to purity of `apply` (not to row retention, which
  is correctly separated as an audit property).
- **GHCi / `main` outputs.** Hand-checked against the derived/custom Show: `Qty`'s
  custom `show` (`1000`, `0`, `-1000`); `ProductTerms (TermsVersion {tvLabel = "ES-v1"}
  :| [])`; `UnitStatus {usLifecycle = Listed}` and `... Active (Price 4200)`;
  `PositionState {psBal = 1000, psHwm = 0}`; the nested `Just (Just ..., Just ...)` on
  line 692. All correct.
- **`.tex` ↔ `.hs` agreement.** The Qty, Price/Lifecycle/UnitStatus, ProductTerms,
  PositionState, Ledger, register/settle, applyMove, Event/apply/replay, and netBal
  listings agree semantically with the source.

## Sub-threshold note (non-blocking; not residue)

The `.tex` listings render `Move` and `TermsVersion` with *positional* constructors
(`data Move = Move UnitId WalletId WalletId Qty`, `data TermsVersion = TermsVersion
String`) where `.hs` uses *records* (`mvUnit…`, `tvLabel`). The `.tex` preamble claims
the listings "reproduce its declarations, deriving clauses elided" — record→positional
is slightly more than deriving elision. This does not impair the `.tex`, which is
self-consistent: its own `applyMove` pattern-matches positionally `(Move u from to q)`,
and the reader of the `.tex` never sees a field selector. Semantically identical;
clearer, if anything, in the document. Left to the author.

## Bottom line

The classification (the 2×2, three occupied cells) is stated result-first in the `.tex`
Answer section as the document register requires, but the Haskell *derives* it from the
ground up — the conclusion is never smuggled into a step. Each home is forced by one
concrete reason; conservation and determinism fall out of structure (group inverse,
pure fold) rather than being asserted. OBVIOUS.
