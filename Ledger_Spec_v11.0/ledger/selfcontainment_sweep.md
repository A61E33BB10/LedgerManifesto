# Self-Containment Sweep (Concern 1)

The document is a new, standalone specification. No sentence may presuppose an earlier
version. This records every prior-version reference found, file by file, with its
disposition: what was removed and how the fact it carried was restated positively.

Rule applied: where a fact lived only inside a supersession passage, it was restated
positively in its own right *first*, then the version framing was removed. No substance
was dropped to clear a reference.

## Disposition by file

### sec02.tex
- Line 3 label comment `% v10.3 semantic label: ...` -> `% semantic label: ...`.
  Fact preserved verbatim (this `\label` is referenced by other sections, including the
  Move-positivity home); only the version token dropped. Grep clean afterward.

### sec03.tex
- `\paragraph{Where evolving state lives (supersedes the v10.3 state fields).}` ->
  parenthetical removed. Restated positively: the unit entry holds identity and static
  terms only; lifecycle stage and product-specific state are not entry fields; a unit
  carries immutable versioned terms in `ProductTerms[u]`, shared lifecycle status in
  `UnitStatus[u]`, per-position state in `PositionState[w,u]` (the three-home model).
- Registration-conservation paragraph: removed the obsolete `StateDelta` reference.
  Restated: a registration is a move-less transaction whose edge-sum is `mempty`,
  vacuously conserved. Grep clean afterward.

### sec04.tex
- Intro clause "it supersedes the per-unit/per-(wallet,unit) state dictionary of
  v10.3 §7.3" -> deleted. Placement now asserted in its own right (minimum basis, unique
  under any correctness gate); the dictionary's content already lives positively in the
  §4 intro and §4.2–§4.3.
- **§4.9 "Supersession of v10.3 §7.3" -> deleted entirely.** Confirmed first that every
  fact it carried is stated positively elsewhere: immutable `ProductTerms[u]` + shared
  `UnitStatus[u]`; `PositionState[w,u]` (never-held vs held-and-flat); mandate/strategy
  state at `PositionState[w,u_MA]`; no wallet-keyed sector. Accessors `productTerms`,
  `unitStatus`, `position` defined positively in the construction listings. The legacy
  `get_unit_state(u)` / `get_unit_state(w,u)` mapping and the line-1034/2287 citations
  were dropped (they existed only to bridge an old reader). **Nothing lost.**
- Pareto alternative A "(v10.3: per-unit, plus per-(w,u) for futures only)" ->
  "(per-unit state, plus per-(w,u) for futures only)".
- FORMALIS-clearance remark: removed "the FORMALIS-cleared reference for Addendum A1" and
  "the single Integer-minor-units deviation from the superseded Python listing".
  Restated: listings are excerpted from the FORMALIS-cleared reference core; exact
  `Integer` minor units are a correctness choice.
- Remaining `supersede` occurrences are the domain term `superseded_by` (breaking-amendment
  stamp), not version framing.

### sec06.tex
- Line 21: struck "which supersedes the fixed-precision decimal requirement of prior
  versions---a correctness upgrade." Restated positively: a quantity is an exact integer
  in the unit's smallest denomination; never a decimal, never a float.

### sec08.tex
- Line 94: struck "This supersedes the decimal-arithmetic requirement of §contracts:
  exact-integer minor units are a correctness upgrade." Restated: "no rounding breaks
  conservation at any scale: the minor-unit scale is exact-integer." (Did not import the
  settlement-boundary rounding fact, established elsewhere, not here.)
- `FutStateDelta` / `futValidate` / `FutValidDelta` are **deliberately retained** — Part K
  is a self-contained futures kernel named apart from the core; not prior-version framing.

### sec09.tex
- Line 403: struck "This discharges open risk F5 of the three-home addendum." The positive
  fact (mandate issuance is not reportable — a discretionary mandate is the MiFID II
  Annex I §A(4) portfolio-management service, not a Section C instrument) is stated in the
  preceding sentence.
- `SetSupersededBy` / `superseded_by` (lines 57, 75) **retained** — core unit-lifecycle
  vocabulary (a unit superseded by a successor unit), not document versioning. Line 57
  `SupersededBy` -> `SetSupersededBy` to match `reference/Ledger.hs`.

### sec12.tex, sec13.tex, sec14.tex
- No prior-version framing found (swept clean). Edits here were taxonomy/name-collision
  fixes (boundary types renamed off the core `Transaction`), not Concern-1.

### sec15.tex
- Line 103: struck "the addendum's local numbering, which this section supersedes."
  Restated: guarantees carry the canonical P1–P23 names this section fixes; §4 presents
  the same map under its own local labels, for which the P1–P23 names are canonical.

### sec19.tex
- "Resolved Since v10.0" / "identified as open in earlier versions" -> "Resolved Design
  Problems"; the three resolutions stand on their own merit.
- "Addendum Risk Register (F1--F8)" -> "State-Model Adoption Risk Register (F1--F8)".
- F1 row: `get_unit_state` "deprecated alias" framing removed; mitigation restated
  generically (read-compatibility accessor, additive split, parallel run).
- F8 row: `v10.3 WalletState` -> "pre-migration combined wallet-state representation";
  migration-irreversibility fact and four-quarter mirror preserved.

### appE.tex
- `UnitStatus` entry: removed "Supersedes the v10.3 'unit state dictionary'." Restated:
  "It is the sole home of unit-level shared state."
- `SupersededBy` (C8) **retained** — the breaking-amendment stamp field.

### appH.tex, appI.tex, sec16.tex
- No prior-version framing found. Edits were taxonomy alignment (removal of the invented
  `type =`/`SETTLEMENT` transaction discriminators).

## Final gate status (round 6) — CLEAN

The round-1–5 residue listed above has been cleared, and the round-1–5 `refsClean: false`
flag was shown to be driven largely by an over-broad grep (it matched legitimate C8
`superseded_by` vocabulary and the `Fut*Delta` boundary names as substrings). The genuine
tail is now fixed:

- **appD.tex:61** — "indivisible **StateDelta**" → "indivisible **Transaction**". FIXED.
- **sec07.tex:75** — "no validate gate and no **StateDelta** type" → "no separate validate
  gate" (the negation named a type that no longer exists). FIXED.
- **reference/Ledger.hs:31** — "is **superseded by** the §10 Balances monoid" → "is
  **restated as** the §10 Balances monoid". FIXED.
- **`StatesHome.hs` / `FutureLifeCycle.hs`** named as "the reference" in appB, sec04 (×3),
  sec06, sec15 → normalised to the single deliverable name `reference/Ledger.hs`. The
  document now names its Haskell reference once. FIXED.
- **`drafts/hs/`** (non-deliverable Phase-1 scaffolding; the last home of stale
  "v10.3" / "Addendum A1" / "supersedes decimal float" comments and an obsolete
  `newtype Transaction = Transaction [Move]`) — **removed**. Its content is captured
  canonically by `reference/Ledger.hs` and the in-`.tex` listings; none of it appeared in
  the PDF. FIXED.
- **appE.tex** — `StateDelta`/`ValidDelta` glossary entries and the "Atomic StateDelta" C3
  phrasing are gone (live grep returns zero bare `StateDelta`/`ValidDelta` across all
  `drafts/*.tex`). FIXED.

A live grep over the deliverables (`drafts/*.tex` + `reference/Ledger.hs`) now returns:
zero `v10.x`, zero "previous/prior/earlier version", zero `StatesHome.hs`/`FutureLifeCycle.hs`,
zero bare `StateDelta`/`ValidDelta`, zero `Transaction [Move]`. The three named voters
(minsky, jane-street-cto, formalis) confirmed GATE MET on this cleaned state.

Legitimate non-hits (correctly retained): `superseded_by` / `SetSupersededBy` /
`supersedeTx` / `DanglingSupersede` (the C8 unit-lifecycle supersession mechanism);
`Fut*Delta` / `futValidate` (the Part K futures-kernel boundary, projecting onto the core
`Transaction`); "v11.0" (the current self-label); "consolidated reference", real-world
"legacy/migration" deployment, and external CDM versioning (domain vocabulary).

**Verdict: self-containment COMPLETE. §4.9 was deleted with nothing lost, every
prior-version reference is cleared, and the document presupposes no earlier draft.
`refsClean = true`; the gate is MET on this concern.**
