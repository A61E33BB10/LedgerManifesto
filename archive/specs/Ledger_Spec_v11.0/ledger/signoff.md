# Sign-off

## Gate history

| Round | Pages | Fatal | refsClean | minsky | jane-street-cto | formalis | Blockers | Findings |
|-------|-------|-------|-----------|--------|-----------------|----------|----------|----------|
| 1 | 142 | 0 | false | false | false | false | 20 | 29 |
| 2 | 143 | 0 | false | false | false | true  | 2  | 8  |
| 3 | 143 | 0 | false | false | false | false | 3  | 3  |
| 4 | 143 | 0 | false | **true** | **true** | **true** | 0 | 4 |
| 5 | 143 | 0 | false | **true** | **true** | **true** | 0 | 6 |
| 6 (final) | 143 | 0 | **true** | **true** | **true** | **true** | **0** | **0** |

**Final voter gates (round 6, on the cleaned state):** minsky = true, jane-street-cto =
true, formalis = true. **refsClean = true. Blockers = 0. Gate MET: YES.**

### Why `refsClean` read `false` in rounds 1–5

Two distinct causes, now separated and both cleared:

1. **Grep false positives.** The round-1–5 `refsClean` check matched legitimate C8
   amendment vocabulary — `superseded_by`, `supersedeTx`, `SetSupersededBy`,
   `DanglingSupersede` — and matched `FutStateDelta`/`FutValidDelta` as substrings of the
   removed-type names `StateDelta`/`ValidDelta`. These are the *current* supersession
   mechanism and the deliberate futures-kernel boundary, not prior-version references. The
   three named voters correctly recognised this and voted `true` from round 4. The
   automated flag stayed `false` on the over-broad pattern alone.
2. **Genuine residue, now fixed.** A small tail of real residue survived into round 5 and
   was cleared in round 6:
   - `appD.tex:61` "indivisible **StateDelta**" → "indivisible **Transaction**".
   - `sec07.tex:75` "no validate gate and no **StateDelta** type" → "no separate validate
     gate" (named a non-existent type).
   - `reference/Ledger.hs:31` "is **superseded by** the §10 Balances monoid" → "is
     **restated as** the §10 Balances monoid".
   - Five prior-thread source-file names (`StatesHome.hs`, `FutureLifeCycle.hs`) named as
     "the reference" → normalised to the single deliverable `reference/Ledger.hs`
     (appB, sec04 ×3, sec06, sec15).
   - Non-deliverable Phase-1 scaffolding `drafts/hs/` (the last home of stale "v10.3" /
     "Addendum A1" / `supersedes decimal float` comments and an obsolete
     `newtype Transaction = Transaction [Move]`) **removed**; its content is captured
     canonically by `reference/Ledger.hs` and the in-`.tex` listings, none of it in the PDF.

## minsky + jane-street-cto — self-containment & taxonomy (Concern 1)

- §4.9 "Supersession of v10.3 §7.3" deleted in full; nothing lost — every fact restated
  positively (three-home state model, positive accessors, no wallet-keyed sector;
  supersession itself relocated to the C8 two-track amendment). Vote: **true** (rounds 4–6).
- No prior-version token survives in the deliverables: minsky's round-6 grep returns only
  domain-legitimate hits ("v11.0" self-label; "consolidated reference"; real-world
  "legacy/migration" deployment; external CDM versioning; append-only "never rewrite"
  invariants; forward-looking "next-version agenda"). Zero `StatesHome.hs`,
  `FutureLifeCycle.hs`, `drafts/hs/`, `v10.x`, "previous/prior/earlier version",
  "formerly", "addendum", or "A1". Vote: **GATE MET**.
- Taxonomy complete and consistent: one core `Transaction` (moves + state delta); boundary
  types named off the core and shown to project onto it; invented `type =` discriminators
  removed. The unified model is declared once (sec04) and restated, never contradicted, in
  sec02/sec03/appE.

## formalis — correctness (Concerns 2 & 3)

- **Transaction carries moves + state, invariants by construction.** Conservation is a
  property of the type: the signed per-unit edge-sum of `txMoves` is `mempty` for any list,
  empty included (the vacuous C9 case). No `StateDelta`/`ValidDelta`/`validate` gate exists
  in the core; the only `validate` tokens are negations. No unconserved `Transaction` is
  representable to need rejecting. `WBalance` is absent from the `FieldWrite` GADT — balance
  is written only by the `Move` edge, so an off-ledger balance change is unrepresentable.
  Supersede referential integrity holds (`requireSupersedeTargets` → `DanglingSupersede`;
  successor `registerTx`'d before `supersedeTx`). Vote: **GATE MET**.
- **Registration is a transaction, stated once.** The move-less `txIntroduce = Just`
  instance, vacuously conserved; `register = applyTx . registerTx`; `replay = foldM
  applyTx`; `applyTx` the sole door. Prose and Haskell agree across sec04, sec07, Ledger.hs.
  Vote: **GATE MET**.
- **Futures kernel boundary (not a defect).** `FutStateDelta`/`FutValidDelta`/`futValidate`
  (Part K) are the futures engine's own constructions projecting onto the one core
  `Transaction` — the conserved triple (net, ac, cash) is not edge-shaped, so it keeps its
  own abstract gate. Framed explicitly in sec08 as a boundary, like the CDM and settlement
  boundary types; reviewer-approved, not a second transaction model.

## Verdict

All three named reviewers vote **GATE MET** on the cleaned round-6 state. The composite
gate is **MET**: `refsClean = true`, 0 blockers, 0 findings, build clean (143 pp; 0 fatal,
0 warnings, 0 `[?]`, 0 overfull > 15 pt).

- Concern 1 — no reference to any previous version remains; the document presupposes none.
- Concern 2 — the `Transaction` type carries moves and state, with the invariants holding
  by construction.
- Concern 3 — registration's status is decided (it *is* a move-less transaction), stated
  once, and consistent in prose and Haskell across all files.
- Nothing of substance was lost deleting §4.9.

**Status: APPROVED.**
