# DIRAC — Round 6 scorecard

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Notation minimal and revealing; special-case sprawl unified where one structure
exists, but every unified symbol introduced concretely — never dumped.

**Grade: A (91%)**

I re-read the `.tex` cold and re-checked the spine against `reference/StatesHome.hs`
(`conserved`, `FieldWrite`/`SomeWrite`, `validate`/`ValidDelta`, `appendVersion`,
`usSupersededBy`, the `replay = foldM` homomorphism). The reference agrees with the prose
symbol-for-symbol. The body is substantively the Round-5 source; nothing in my domain has
regressed, every unified symbol is still introduced concretely, and correctness is preserved.
The same four non-blocking blemishes remain, none cryptic, none cuttable without loss of a
deliberate function. I hold at 91 — neither inflating nor cutting.

---

## Verified this round (cold, against the reference)

- **Conservation is one structure, not a branch per instrument.** C2 (254–266) states
  ∑_w Δf(w,u)=0 once; 2-leg, K-leg, VM fan-out, and the vacuous zero-holder case are
  *instances*. In the reference this is `conserved :: FieldWrite h -> PosDelta` (lines
  251–256) folded by `foldMap` into `mempty` in `validate` (288), so C9 needs no special
  case (`mempty` over the empty map). Prose and code coincide — the Dirac moment of the
  document.
- **W-sector collapse is concrete, not asserted.** C12 (§4.2) shows the "inherently
  wallet-attached" managed account is (w,u_MA)-keyed because the mandate is a unit,
  conserving by the standard issuance law (327–331); the would-be fourth map is named,
  typed, and shown empty, with the rejected sentinel (design C) as the concrete contrast
  that *breaks* ∑_w h=0 (361–366).
- **The two axes are enumerated and declared disjoint** (313–316): C11 field-writers
  {settle, trade, transfer, fee_crystallise, subscribe} vs C2 event classes {Trade,
  SettleVM, CorporateAction, QISRebalance, MandateAmend}. Exactly the name-collision this
  lens exists to catch, pre-empted in prose.
- **The `FieldWrite h` GADT *is* the C11 writer table** (ref. 196–211:
  `WAc`/`WAcTrade`/`WBalance`/`WHwm`/`WEntryNav`, then `SomeWrite` erasing the index).
  Type error at authorship, index erased at the stored row (signal S3). Matches 305–317.
- **P3 typechecks as a homomorphism.** `replay (xs <> ys) = replay xs >=> replay ys`
  (684–688) is Kleisli composition in `Either LedgerError`, matching `replay = foldM …`.
  Checkpoint independence is a consequence of C1(b), not a test.
- **Counts close.** §10 names exactly seven invariants (P1, P3, P5, P6, P7, P9, P10) —
  "seven of the ten." All twelve labels C1–C12 appear in the body and in the §6 index.

## Residual blemishes (non-blocking — do not deny A)

- **C1–C12 are in index order, not first-appearance order** (212–218). First met is C2,
  then C1, C11, C12, C3, … forcing the disclaimer. Notation that needs a disclaimer is mild
  friction, but the §6 index gives clean lookup, the rule is stated once and obeyed, and the
  labels are honestly flagged as tags. Friction, not crypticness.
- **Prose/reference accessor-name drift.** Prose writes `product_terms(u)` / `unit_status(u)`
  / `position(w,u)` (465, 602, 613); the reference exports `productTerms`, `unitStatus`,
  `position`. The map names *are* bridged (161–164 → `ledgerUS`/`ledgerPS`); accessor names
  are not. snake_case = spec convention, camelCase = Haskell convention; a competent reader
  maps them on sight. Cosmetic.
- **`balance` is a deliberately demonstrative conserved field** (122–127, 203–205). A
  minimalist could ask whether it is cuttable, since `hwm`→fee_crystallise and
  `entry_nav`→subscribe already furnish distinct writers for C11. The document is fully
  transparent about its pedagogical role and excludes it from the economic inventory by
  intent. A minimalism call other lenses own more than mine.
- **"signal S1–S4" forward-reference the §13 Haskell comments** (first at 311). The
  substance is stated inline at each call site; the pointer is parenthetical. Harmless.

## Why A and not higher

The four residuals — index-ordered labels needing a disclaimer, accessor-name drift, the
demonstrative `balance`, the S-signal forward refs — are real but none is cryptic and none
costs correctness. They hold the score at 91 rather than higher. On notation and unification
the document is at target: every unified symbol (the conservation sum, the W-sector collapse,
the `FieldWrite` writer table, the `replay` homomorphism) is introduced concretely and
corroborated by the reference. I stake my lens on A.
