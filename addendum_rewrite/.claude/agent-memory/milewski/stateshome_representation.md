---
name: stateshome-representation
description: Settled Haskell representation decisions for the StatesHome addendum (three state maps, conservation, replay, C1-C12)
metadata:
  type: project
---

StatesHome addendum (`addendum_rewrite/addendum_stateshome_v2.tex`, reference
`addendum_rewrite/reference/StatesHome.hs`) answers "where does unit state live?" with
three maps, each with its own mutation discipline:

- **ProductTerms** `Map UnitId (NonEmpty TermsVersion)` — immutable, append-only, versioned,
  registration-total. Abstract; only growers are `register` (singleton) and `appendVersion`.
  `NonEmpty` makes "registered but versionless" untypable. (C6/C7)
- **UnitStatus** `Map UnitId UnitStatus` — mutable, shared across holders, registration-total.
  The "shared observable" sector (Reader/representable at the consuming layer; a plain shared
  cell in the reference). (C5)
- **PositionState** `Map (WalletId,UnitId) PositionState` — per (holder,unit). Two orthogonal
  halves of C1: (a) `Maybe` accessor distinguishes never-held (`Nothing`) from held-and-flat
  (`Just zeroP`); (b) monotone carrier — no row deleter exported, so rows are never removed.

Structures that earned their keep (named purchase):
- Conservation (C2) = group homomorphism `Map WalletId [SomeWrite] -> PosDelta`, "conserving"
  = image is `mempty`. Vacuous zero-holder case (C9) falls out of the empty `foldMap` for free
  — kills the `dividend/len(holders)` bug class.
- `ValidDelta` abstract, sole constructor `validate` — unconserved delta cannot reach
  `applyDelta`. Conservation is value-level (S4), not a type fact; this is acknowledged, not
  hidden.
- Replay = Kleisli fold (`foldM applyDelta`). Law: `replay (xs<>ys) = replay xs >=> replay ys`
  in the `Either LedgerError` Kleisli category. This is a monoid **homomorphism** (order
  preserving), NOT an antihomomorphism — checkpoint-independence is a consequence of the law.
- Abstract `Ledger` (no setter/deleter) keeps monotone carrier + PT⇔US invariant by
  construction (register writes both; applyDelta only replaces for a registered unit).

Rejected / weak: C11 per-field-writer via `FieldWrite (h::Handler)` GADT + DataKinds. The
type error binds only at handler-authorship site and is erased once writes share a row via
`SomeWrite` (S3). It is the weakest mapping — purchase described, not demonstrated (no real
typed handler in `main`). Acceptable under the restraint rule only if prose stays honest
("type error at authorship, erased at the row"), NOT "structurally unrepresentable like P1".

See [[stateshome-recurring-findings]] for review history.
