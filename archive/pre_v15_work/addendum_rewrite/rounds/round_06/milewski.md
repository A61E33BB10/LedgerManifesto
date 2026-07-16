# Round 6 — MILEWSKI (Expressibility lens)

**Grade: A (92%)**

Lens: does each concept map cleanly to Haskell? Awkwardness is read as a signal about
prose, notation, or design.

## Verdict

The addendum and `reference/StatesHome.hs` are mutually faithful and every load-bearing
concept maps cleanly onto an idiomatic Haskell construct. The categorical claims in my
exact domain are all correct, all honestly scoped, and all genuinely discharged by the
code. The single Round-5 non-blocker is resolved. I stake my lens on the A.

## Round-5 carryover — resolved

- Paragraph header (line 300) now reads **"A canonical writer set per field."** — the
  earlier "One writer per field." overstatement (while `ac` has two writers,
  `WAc 'Settle` / `WAcTrade 'Trade`) is gone. Header now matches body and GADT.

## Concept-by-concept check (all pass)

- **Three maps** (§3, lines 155–159) ↔ `ledgerPT : Map UnitId ProductTerms`,
  `ledgerUS : Map UnitId UnitStatus`, `ledgerPS : Map (WalletId,UnitId) PositionState`.
  Exact correspondence. `Map`/`Option`/`NonEmptyList` notation (lines 109–113) maps
  directly to `Map`/`Maybe`/`NonEmpty`.
- **C1** Option accessor + monotone carrier ↔ `position :: … -> Maybe PositionState`
  plus an abstract `Ledger` with no exported row-deleter. Both halves present, stated as
  orthogonal (lines 297–298), and both delivered.
- **C2 conservation** = group homomorphism `Map WalletId [SomeWrite] -> PosDelta`,
  "conserving" = image is `mempty`. Categorical name stated last (line 233), per the
  restraint rule. Vacuous zero-holder case (C9) falls out of the empty `foldMap` — the
  `dividend/len(holders)` bug class is excluded by construction, not tested.
- **`validate` / `ValidDelta`** abstract, sole constructor: unconserved delta cannot
  reach `applyDelta`. Honestly scoped as value-level (S4), not a type fact — §10 P1 and
  the abstract (line 59) both repeat the caveat. This is exactly the honest framing the
  recurring "prose over-claims encoding" finding demands.
- **C3 atomic StateDelta** ↔ `applyDelta` returns whole ledger or `Left` — no partial
  state representable.
- **P3 replay determinism** — `replay (xs <> ys) = replay xs >=> replay ys`. Verified:
  `foldM applyDelta` over list concatenation satisfies this Kleisli/monoid homomorphism;
  checkpoint-independence is a consequence, not a test. Correctly labelled homomorphism
  (not antihomomorphism). `>=>` is explained inline for the target reader (lines 685–687).
- **C11 per-field writer** GADT `FieldWrite (h :: Handler)`. Prose (lines 305–317) is
  honest: type error binds at authorship, erased at the row via `SomeWrite` (S3). The
  field-writer axis (Settle/Trade/Transfer/FeeCrystallise/Subscribe) vs C2 event-class
  axis (Trade/SettleVM/CorporateAction/QISRebalance/MandateAmend) divergence is stated
  explicitly — the recurring vocabulary-divergence finding stays closed.
- **C6/C7 ProductTerms** ↔ abstract `newtype ProductTerms = ProductTerms (NonEmpty …)`;
  growth only via `register` (singleton) / `appendVersion`. `NonEmpty` makes
  "registered but versionless" untypable.
- **C8 two-track amendment** ↔ `amend` with total `FungibilityPredicate`; cross-unit
  re-subscription correctly pushed out to paired issuance (S1), not faked inside a
  single-unit delta.
- **`balance`** declared a demonstrative second conserved field (lines 122–127, 203–205),
  explicitly neither `h(w,u)` nor a §3 economic datum — the prior B5 reconciliation holds.

## Non-blocking observation (not holding off A)

- **P5 idempotency — "dedup" vs "structural" wobble.** The P5 gloss (line 692) says the
  single `(w,u)`-keyed row plus C11 "make idempotency a **per-key dedup**", while the
  testing section (line 722) calls "P5, whose idempotency is **structural**." These pull
  slightly opposite ways: a replacement (UnitStatus `Map.insert`, `WHwm` max, `WEntryNav`
  write-once) is structurally idempotent and needs no dedup, whereas the additive fields
  (`WAc`/`WBalance`, `psAc p <> q`) are *not* idempotent and would need event dedup the
  reference does not implement. Read strictly — P5 = lifecycle (status / per-position OTC
  lifecycle) events, which are replacement-semantics and thus structurally idempotent —
  both lines are defensible, so this is not wrong. But P5 is the murkiest of the seven on
  a single pass: the gloss cites `(w,u)`-keyed PositionState machinery while the headline
  invariant is "lifecycle events," and the word "dedup" implies a runtime mechanism that
  "structural" denies. Pre-existing (not a Round-6 regression). If a future round touches
  §10, aligning the two phrasings (e.g. "replacement-idempotent at a single key; additive
  fields are conserved, not idempotent, and rely on event-id dedup") would remove the only
  fog left in my domain. Not a blocker.

## No blocking issues.
