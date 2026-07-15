# Round 4 — milewski review of states_simple/States.tex (+ States.hs)

## Verdict: OBVIOUS

The Haskell reads like Hutton: each step follows from the one before, nothing
assumes the three-homes answer in advance, and every abstraction (monoid,
`foldMap`, `foldM`) is named only after the thing it names is already on the page.

This round's only material change since my Round-3 OBVIOUS is the fuse of the
settlement price onto the lifecycle stage — `data Lifecycle = Listed | Active
Price`, a single-field `newtype UnitStatus = UnitStatus { usLifecycle ::
Lifecycle }`, and a total `settlementPrice :: UnitStatus -> Maybe Price`. That
change strictly improves the file: it removes two unreachable illegal states
(`Active` unpriced, `Listed` priced) that the previous `Lifecycle x Maybe Price`
shape could spell, and it earns the fusion by exhibiting the bad shape it
forbids (step 5). The "priced iff active" correlation now holds by the type, not
by a writer trusted to set two fields in lockstep.

## What I verified

- **.tex / .hs code blocks agree.** Every listing in States.tex matches
  States.hs up to derived instances: Qty/negQty, Balances/holding,
  Price/Lifecycle/UnitStatus, ProductTerms/currentTerms/appendVersion,
  PositionState/zeroP, Ledger/emptyLedger, register/settle, applyMove, netBal,
  Event/apply/replay. No drift.
- **The fuse is consistent with the steps before it.** Step 5's contrast to
  conservation ("the opposite case from conservation — the type can cheaply
  carry this correlation, a Map cannot cheaply carry sums-to-zero") does not
  contradict step 4. Step 4 already frames `transfer` — the *writer* — as what
  cancels ("not a precondition the caller is trusted to honour"), so the
  writer-invariant framing the fuse references is already established in concept;
  only the single phrase "Map cannot cheaply carry sums-to-zero" foreshadows
  step 8, and it is paid off there in full. Tolerable foreshadowing, not a
  Hutton violation.
- **GHCi/main outputs hand-checked** (no GHC in env): derived Show gives
  `UnitStatus {usLifecycle = Listed}`,
  `UnitStatus {usLifecycle = Active (Price 4200)}`, and
  `ProductTerms (TermsVersion {tvLabel = "ES-v1"} :| [])`. All as printed.
- **Totality:** currentTerms total via NonEmpty; settlementPrice total over both
  reachable cases; all three writers total `-> Maybe Ledger`, refusing
  out-of-bounds units uniformly.
- **Determinism / checkpoint law:** replay = `foldM (flip apply)`, apply pure and
  total, so the final equality
  `replay [eR,e1,eS,e2] e == (replay [eR,e1] e >>= replay [eS,e2])` holds by the
  monadic left-fold law; `Eq Ledger` derives, so it evaluates True.
- **Conservation stays honestly disclosed** as a writer invariant (the store
  type can hold a non-conserving map; applyMove is the sole psBal writer and
  writes two cancelling legs; sealed constructor makes the reachable set
  exhaustive from emptyLedger). Not overstated as "unrepresentable."

## Non-blocking note (sub-threshold, carried from Round 3)

`applyMove` gates on `Map.member u (ledgerPT l)` while `settle` gates on
`ledgerUS`. Equivalent under the terms/status coherence invariant (register
writes both maps together, constructor sealed), so neither can be true without
the other. Cosmetic non-uniformity only; left to the author.
