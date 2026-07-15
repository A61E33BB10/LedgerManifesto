---
name: representation-decisions
description: Categorical structures that earn their keep in the Ledger spec, and abstractions deliberately stopped short of.
metadata:
  type: project
---

Settled representational choices (each buys a concrete purchase — bug class removed or code removed). See [[ref-ledger-hs]] for where they live.

- **Qty/Cash = additive abelian group** (exact `Integer` minor units, never Float). Conservation and deterministic replay are arithmetic facts a float forfeits. `Price`/`Quote` carry NO Monoid on purpose — summing prices is meaningless, so the type forbids the one wrong combination.
- **Conservation = monoid/group homomorphism into the zero of the delta group.** `validate` lands the per-wallet fold at `mempty`; the empty fold is `mempty`, so a zero-holder event conserves vacuously — the `dividend/len(holders)` bug class cannot arise (we sum, never divide). `ValidDelta` abstract → unconserved delta cannot reach `applyDelta`.
- **Replay = unique monoid homomorphism out of the free monoid of events** into Kleisli `Either LedgerError`. `replay (xs<>ys) = replay xs >=> replay ys`; checkpoint-independence and determinism are consequences of the law, not tests.
- **Monotone carrier (C1) by ABSENCE:** `Ledger` exported without setters/deleter, `applyDelta` only inserts/updates. The `Maybe` Option accessor distinguishes never-held (`Nothing`) from held-and-flat (`Just zeroP`) — load-bearing, never collapse them.
- **UnitStatus = shared observable / read cache of the log.** Single writer `applyStatus`, Ledger sealed → cache cannot drift; replay rebuilds it. Canonical verbatim wording lives as the Map-2 comment.
- **C11 per-field canonical writer = GADT phantom `Handler` index** (`FieldWrite (h :: Handler)`). A wrong-handler write is a type error at authorship; index erased to `SomeWrite` at the delta-row boundary.
- **ProductTerms = NonEmpty, append-only** → "registered but versionless" untypable; `currentTerms` total without Maybe.
- **CDM `forget` and balance `balances` = monoid homomorphisms** (concatMap / foldMap); settlement legs as a sum type make "instruction with no legs" unrepresentable.

**Stopped short of (restraint rule):** no free monad where a function suffices; C4 read-scoping kept OUT of the data shape (a capability/Reader concern at the boundary); UnitStatus single-writer uses a plain closed sum `StatusWrite`, not the phantom-`Handler` index (no handler-typing layer for it to constrain). §7 general lifecycle core not re-derived in the runnable module — §4 core + §8 futures already exercise the read→validate→commit `step` executor.
