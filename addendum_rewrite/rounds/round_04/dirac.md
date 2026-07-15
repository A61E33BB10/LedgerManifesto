# DIRAC — Round 4 scorecard

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Notation minimal and revealing; special-case sprawl unified where one structure
exists, but every unified symbol introduced concretely — never dumped.

**Grade: A (91%)**

The file is unchanged from Round 3: every line reference from my Round-3 scorecard still
lands exactly (P3 law 683–688, conserved-field partition 122–131, sector-name annotation
161–164, design E 633/647), and the reference `StatesHome.hs` corroborates every structural
claim the prose makes. I re-read cold and re-verified the spine against the source rather
than deferring to my prior self. Nothing regressed, nothing in my domain is cryptic on one
careful pass, and the residuals are exactly those I judged non-blocking. I hold the line at
91 — neither inflating nor cutting.

---

## Verified this round (cold, against the reference)

- **Counts close.** §10 names exactly seven invariants (P1, P3, P5, P6, P7, P9, P10) —
  matches "seven of the ten." All twelve C-labels C1–C12 are present in the body and in the
  §6 index.
- **Conservation is one structure, not a branch per instrument.** C2 (254–266) states
  ∑_w Δf(w,u)=0 once; 2-leg, K-leg, VM fan-out, and the vacuous zero-holder case are
  *instances*. The reference carries it as `conserved :: FieldWrite h -> PosDelta` folded by
  `foldMap` into `mempty` (lines 251–294), so C9 needs no special case. The Dirac moment of
  the document; the prose and the code agree symbol for symbol.
- **W-sector collapse is concrete, not asserted.** C12 (§4.2) shows the "inherently
  wallet-attached" managed account is (w,u_MA)-keyed because the mandate is a unit,
  conserving by the standard issuance law (326–330); the would-be fourth map is named,
  typed, and shown empty, with the rejected sentinel (design C) as the concrete contrast that
  *breaks* ∑_w h=0.
- **The two axes are enumerated and declared disjoint** (309–316): C11 field-writers
  {settle, trade, transfer, fee_crystallise, subscribe} vs C2 event classes {Trade,
  SettleVM, CorporateAction, QISRebalance, MandateAmend}. Exactly the collision this lens
  exists to catch, pre-empted.
- **The `FieldWrite h` GADT *is* the C11 writer table** (reference 196–211, `_c11_ok_*`,
  commented `_c11_bad`). Type error at authorship, index erased at the stored row via
  `SomeWrite` (S3). Minimal and revealing; matches the prose at 305–316.
- **P3 typechecks as a homomorphism.** `replay (xs <> ys) = replay xs >=> replay ys`
  (684–688) is Kleisli composition in `Either LedgerError`, matching `replay = foldM ...`
  in the reference (376–377). Checkpoint independence is a consequence, not a test.

## Residual blemishes (non-blocking — do not deny A)

- **C1–C12 are in index order, not first-appearance order.** First met is C2, then C1, C11,
  C12, C3, …, forcing the disclaimer at 212–216 ("read as tags, not as a sequence"). On a
  purist reading, notation that needs a disclaimer is notation fighting the reader, and
  appearance-order renumbering would be marginally more revealing. But the §6 index gives a
  clean lookup, the rule is stated once and obeyed, and the labels are honestly flagged.
  Friction, not crypticness.
- **Prose/reference accessor-name drift (confirmed by grep).** Prose writes
  `product_terms(u)` / `unit_status(u)` / `position_state(w,u)` / `get_unit_state` (461, 469,
  474, 610–612, 742); the reference exports `productTerms`, `unitStatus`, `position`. The map
  names *are* bridged (161–164 → `ledgerUS`/`ledgerPS`); the accessor names are not. Same
  symbol, two spellings, but no reader is misled — conceptual vs Haskell. Cosmetic.
- **`balance` is a deliberately demonstrative conserved field** (122–127, 203–205): a second
  conserved field carried only by the reference to exercise the C11 per-field-writer
  discipline. A minimalist could ask whether it is cuttable, since `hwm`→fee_crystallise and
  `entry_nav`→subscribe already give distinct writers. The document is fully transparent
  about its pedagogical role and excludes it from the economic inventory by intent — not
  cryptic, not load-bearing on correctness. A minimalism call other lenses own more than
  mine; on notation it reads cleanly.
- **"signal S1–S4" forward-reference the §13 Haskell comments** (first at 311). The
  substance is stated inline at each call site and the pointer is parenthetical. Harmless.

## Why A and not higher

The residuals — index-ordered labels needing a disclaimer, accessor-name drift, the
demonstrative `balance`, the S-signal forward refs — are real but none is cryptic and none
costs correctness. They hold the score at 91 rather than higher. On notation and
unification the document is at target: every unified symbol (the conservation sum, the
W-sector collapse, the `FieldWrite` writer table, the `replay` homomorphism) is introduced
concretely and corroborated by the reference. I stake my lens on A again.
