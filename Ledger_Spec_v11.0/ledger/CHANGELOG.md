# CHANGELOG — Ledger Spec v11.0

Changes at section granularity, grouped as removed / retyped / redefined.

## Removed (prior-version references — Concern 1)

- **sec02** — version token in a `\label` comment.
- **sec03** — "(supersedes the v10.3 state fields)" paragraph qualifier; obsolete
  `StateDelta` reference in the registration-conservation paragraph.
- **sec04** — "supersedes the ... dictionary of v10.3 §7.3" intro clause; the entire
  **§4.9 "Supersession of v10.3 §7.3"** subsection; the `(v10.3: ...)` Pareto note; the
  "Addendum A1" / "superseded Python listing" framing in the FORMALIS remark; the
  `get_unit_state` legacy mapping and line-1034/2287 citations.
- **sec06** — "supersedes the fixed-precision decimal requirement of prior versions".
- **sec08** — "supersedes the decimal-arithmetic requirement of §contracts".
- **sec09** — "discharges open risk F5 of the three-home addendum".
- **sec15** — "the addendum's local numbering, which this section supersedes".
- **sec19** — "Resolved Since v10.0" heading; "Addendum Risk Register"; `get_unit_state`
  "deprecated alias"; `v10.3 WalletState` type name.
- **appE** — "Supersedes the v10.3 'unit state dictionary'".

In each case the load-bearing fact was first restated positively (see
`selfcontainment_sweep.md`); no substance was deleted to clear a reference.

## Retyped (unified Transaction model — Concerns 2/3)

- **sec02** — `newtype Transaction = Transaction [Move]` -> the six-field record
  (`txUnit, txMoves, txRows, txStatus, txIntroduce, txAppend`); `unitDelta` folds over
  `txMoves`; the buyAAPL example becomes a record-syntax trade (`txIntroduce = Nothing`).
- **sec03** — standalone `register` (direct `Map.insert`) -> `registerTx` building a
  move-less `txIntroduce = Just` Transaction, with `register = applyTx . registerTx`;
  `applyTx` is the sole door.
- **sec04** — removed `PosDelta`/`StateDelta`/`ValidDelta`/`validate`/`ConservationError`
  and the `WBalance` FieldWrite constructor (balance's sole writer is the Move edge);
  added unified `Transaction`, `unitDelta`/`netDelta`, and `registerTx`/`appendTx`/
  `supersedeTx`; `register = applyTx . registerTx`; `amend` Breaking = two `applyTx` calls;
  `replay :: [Transaction] -> ...` via `applyTx`.
- **sec06** — invented `Transaction(type = SETTLEMENT)` header -> `Transaction
  (settlement: txIntroduce = Nothing, ...)`.
- **sec12** — settlement-layer `data Transaction` (name collision) -> `SettlementTx`
  (`stId, stClass, stMoves, stCdm`); `Move` -> `SettleMove`; `TxType` -> `TxClass`.
- **sec13** — CDM `data Transaction` (name collision) -> `CdmTransaction`
  (`ctMoves, ctPayload`); `forget :: BusinessEvent -> CdmTransaction`; primitives
  `Pi*`-prefixed; reuses the canonical 6-field core Move.
- **sec15** — C3 `Atomic StateDelta` -> `Atomic Transaction`; conservation prose flipped
  from value-level check to by-construction; removed `WBalance`; `replay`/anchors retargeted
  to `applyTx`.
- **sec16, appH, appI, sec14** — removed the `type = SETTLEMENT|MARGIN_CALL|...`
  discriminator (no such field on the core Transaction); headers now bind move lists to
  `txMoves` with the economic role as a comment; move-less recall named as the vacuously
  conserved, state-delta-only case.
- **sec19** — netting conservation prose retargeted from "valid zero-sum transactions" to
  "signed edge-sum is zero, by construction".

### Dropped types/fields
- `StateDelta`, `ValidDelta`, `PosDelta`, the `validate` gate — removed from the core.
- `WBalance` FieldWrite constructor — dropped; balance is written only by the Move edge.

## Redefined (accessors stated positively)

- **sec04 / appE** — `productTerms`, `unitStatus`, `position` defined positively at their
  construction sites (each with the C1 Option "Nothing = unregistered" semantics), no
  longer via a `get_unit_state` legacy mapping.
- **appE** — `Transaction` and `Atomic move` glossary entries rewritten to the canonical
  primitives; new `Registration` entry added (move-less `txIntroduce = Just` Transaction).
- **UnitStatus** (sec03/sec04/appE) — stated as the sole home of unit-level shared state
  and as a projection, positively, without reference to a prior dictionary.

## Residue cleared (round 6 — gate now MET)

The residual references noted in round 5 have all been cleared; `refsClean = true` and the
three named voters confirmed GATE MET on the cleaned state (see `signoff.md`).

- **appD.tex:61** — "indivisible StateDelta" -> "indivisible Transaction". DONE.
- **sec07.tex:75** — "no validate gate and no StateDelta type" -> "no separate validate
  gate" (the negation named a type that no longer exists). DONE.
- **reference/Ledger.hs:31** — "is superseded by the §10 Balances monoid" -> "is restated
  as the §10 Balances monoid". DONE.
- **appE.tex** — `StateDelta`/`ValidDelta` glossary entries and the "Atomic StateDelta" C3
  phrasing removed; a live grep returns zero bare `StateDelta`/`ValidDelta` across all
  `drafts/*.tex`. DONE.
- **Reference-file naming** — `StatesHome.hs` / `FutureLifeCycle.hs` named as "the
  reference" in appB, sec04 (×3), sec06, sec15 -> normalised to the single deliverable name
  `reference/Ledger.hs`. The document now names its Haskell reference once. DONE.
- **`drafts/hs/`** — non-deliverable Phase-1 scaffolding (last home of stale "v10.3" /
  "Addendum A1" / "supersedes decimal float" comments and an obsolete
  `newtype Transaction = Transaction [Move]`) **removed**; captured canonically by
  `reference/Ledger.hs` and the in-`.tex` listings, never in the PDF. DONE.

## Deliberate boundary (retained by design, not residue)

- **sec07 / sec08, Part K** — the futures kernel keeps `FutStateDelta`/`FutValidDelta`/
  `futValidate` as its own constructions, projecting onto the one core `Transaction`. This
  is framed explicitly in sec08 as a boundary (like the CDM `BusinessEvent` and the
  settlement-layer `SettlementTx`): the conserved triple (net, ac, cash) is not edge-shaped,
  so the kernel keeps an abstract gate rather than edge-sum conservation. FORMALIS and the
  reviewers confirmed this is the intended, approved design — a self-contained engine that
  projects onto the core, not a second transaction model.

## Final status

Build clean (143 pp; 0 fatal, 0 warnings, 0 `[?]`, 0 overfull > 15 pt). Gate MET on all
three concerns: self-containment complete (Concern 1), `Transaction` carries moves + state
with invariants by construction (Concern 2), registration is a move-less transaction stated
once and consistently (Concern 3); nothing of substance lost deleting §4.9. **APPROVED.**
