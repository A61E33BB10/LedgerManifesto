# DIRAC — Round 5 scorecard

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Notation minimal and revealing; special-case sprawl unified where one structure
exists, but every unified symbol introduced concretely — never dumped.

**Grade: A (91%)**

The file is byte-identical to the Round-4 source. I re-read it cold and re-checked the
spine against `reference/StatesHome.hs` rather than deferring to my prior self. Every
unified symbol is introduced concretely, the reference agrees symbol-for-symbol, nothing in
my domain is cryptic on one careful pass, and correctness is preserved. The residuals are
exactly the four non-blocking blemishes I logged before; none has moved. I hold at 91 —
neither inflating nor cutting.

---

## Verified this round (cold, against the reference)

- **Conservation is one structure, not a branch per instrument.** C2 (256–268) states
  ∑_w Δf(w,u)=0 once; 2-leg, K-leg, VM fan-out, and the vacuous zero-holder case are
  *instances*. The reference carries it as `conserved :: FieldWrite h -> PosDelta` folded by
  `foldMap` into `mempty` (`validate`, ref. lines ~300), so C9 needs no special case. This
  is the Dirac moment of the document; prose and code coincide.
- **W-sector collapse is concrete, not asserted.** C12 (§4.2) shows the "inherently
  wallet-attached" managed account is (w,u_MA)-keyed because the mandate is a unit,
  conserving by the standard issuance law (329–333); the would-be fourth map is named,
  typed, and shown empty, with the rejected sentinel (design C) as the concrete contrast
  that *breaks* ∑_w h=0 (363–368).
- **The two axes are enumerated and declared disjoint** (313–318): C11 field-writers
  {settle, trade, transfer, fee_crystallise, subscribe} vs C2 event classes {Trade,
  SettleVM, CorporateAction, QISRebalance, MandateAmend}. Exactly the name-collision this
  lens exists to catch, pre-empted in the prose.
- **The `FieldWrite h` GADT *is* the C11 writer table** (ref. `WAc/WAcTrade/WBalance/WHwm/
  WEntryNav`, `_c11_ok_*`, commented `_c11_bad`). Type error at authorship, index erased at
  the stored row via `SomeWrite` (signal S3). Minimal and revealing; matches 307–319.
- **P3 typechecks as a homomorphism.** `replay (xs <> ys) = replay xs >=> replay ys`
  (684–688) is Kleisli composition in `Either LedgerError`, matching `replay = foldM …` in
  the reference. Checkpoint independence is a consequence, not a test.
- **Counts close.** §10 names exactly seven invariants (P1, P3, P5, P6, P7, P9, P10) —
  "seven of the ten." All twelve labels C1–C12 appear in the body and in the §6 index.

## Residual blemishes (non-blocking — do not deny A)

- **C1–C12 are in index order, not first-appearance order.** First met is C2, then C1, C11,
  C12, C3, …, forcing the disclaimer at 212–218. On a purist reading, notation that needs a
  disclaimer is notation fighting the reader. But the §6 index gives a clean lookup, the rule
  is stated once and obeyed, and the labels are honestly flagged as tags. Friction, not
  crypticness.
- **Prose/reference accessor-name drift.** Prose writes `product_terms(u)` / `unit_status(u)`
  / `position(w,u)` / `get_unit_state` (465, 615, etc.); the reference exports `productTerms`,
  `unitStatus`, `position`. Map names *are* bridged (161–164 → `ledgerUS`/`ledgerPS`); the
  accessor names are not. Conceptual vs Haskell spelling; no reader is misled. Cosmetic.
- **`balance` is a deliberately demonstrative conserved field** (122–127, 203–205). A
  minimalist could ask whether it is cuttable, since `hwm`→fee_crystallise and
  `entry_nav`→subscribe already furnish distinct writers for C11. The document is fully
  transparent about its pedagogical role and excludes it from the economic inventory by
  intent. A minimalism call other lenses own more than mine; on notation it reads cleanly.
- **"signal S1–S4" forward-reference the §13 Haskell comments** (first at 311). The substance
  is stated inline at each call site; the pointer is parenthetical. Harmless.

## Why A and not higher

The four residuals — index-ordered labels needing a disclaimer, accessor-name drift, the
demonstrative `balance`, the S-signal forward refs — are real but none is cryptic and none
costs correctness. They hold the score at 91 rather than higher. On notation and unification
the document is at target: every unified symbol (the conservation sum, the W-sector collapse,
the `FieldWrite` writer table, the `replay` homomorphism) is introduced concretely and
corroborated by the reference. I stake my lens on A.
