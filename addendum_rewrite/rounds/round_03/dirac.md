# DIRAC — Round 3 scorecard

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Notation minimal and revealing; special-case sprawl unified where one structure
exists, but every unified symbol introduced concretely — never dumped.

**Grade: A (91%)**

In Round 2 I staked my lens on A and named the exact residuals I was willing to live with.
Re-reading cold in Round 3, the spine is intact, the four Round-1 notational failures stay
discharged, and the residuals are exactly those I judged non-blocking. I hold the line at
91 rather than nudge it — nothing changed that would justify either inflation or a cut.

---

## The four Round-1 issues remain discharged

- **P3 law typechecks.** Lines 683–687 carry `replay (xs <> ys) = replay xs >=> replay ys`
  as Kleisli composition in `Either LedgerError`, matching the reference. Checkpoint
  independence is a *consequence* of a homomorphism law, not a test. The ill-typed
  `apply_all(...) ++ events[k:]` is gone for good.
- **Conserved-field partition given in prose.** Lines 122–131 name it concretely:
  conserved = `accumulated_cost`, `balance`; non-conserved = `hwm`, `entry_nav`. The
  `0_P` row (129–131) keeps the sharpened reading — a flat row "need not be `0_P`" because
  it may retain a non-conserved field — so C1(a) no longer overstates. A prose-only reader
  can decide whether `hwm` is bound by ∑Δf=0 without opening the appendix.
- **Sector name = value-type name.** Lines 161–164 annotate that each map's value type
  carries its sector's name by intent and point to `ledgerUS`/`ledgerPS`. The one
  one-symbol-two-meanings site is defused.
- **"sheaf" no longer dropped as a bare label.** Design E is "state indexed only over the
  held set {(w,u): position(w,u)=Some}" (lines 633, 647). The unconcretized term is gone.

## What is beautiful (survives the round)

- **One conservation law, no branch per instrument (C2, lines 254–266).** ∑_w Δf(w,u)=0
  stated once; 2-leg, K-leg, VM fan-out, and the vacuous zero-holder case fall out as
  instances. The reference carries it as a monoid homomorphism into `PosDelta` landing at
  `mempty`, so C9 needs no special case. The document's Dirac moment.
- **W-sector collapse (C12, §4.2).** The "inherently wallet-attached" managed account is
  shown (w,u_MA)-keyed because the mandate is a unit, conserving by the standard issuance
  law; the would-be fourth map is named, typed, and shown empty. The rejected sentinel
  (design C) is the concrete contrast that *breaks* ∑_w h=0 — the opposite introduced, not
  asserted.
- **Two axes named, collision pre-empted (lines 309–316).** The C11 field-writer axis
  (settle, trade, transfer, fee_crystallise, subscribe) and the C2 event-class axis (Trade,
  SettleVM, CorporateAction, QISRebalance, MandateAmend) are each enumerated concretely and
  declared not to coincide. Exactly the collision the lens exists to catch.
- **`FieldWrite h` GADT *is* the C11 writer table.** A write by the wrong handler is a type
  error at authorship; the index is erased at the stored row (S3). Minimal and revealing.

## Residual blemishes (non-blocking — do not deny A)

- **C1–C12 are in index order, not first-appearance order** (first met is C2, then C1, C11,
  C12, C3, …), forcing the disclaimer at lines 212–216 to read them "as tags, not as a
  sequence." On a purist reading, notation that needs a disclaimer is notation fighting the
  reader, and appearance-order renumbering would be marginally more revealing. But the §6
  index gives a clean lookup, the rule is stated once and obeyed, and the labels are honestly
  flagged as tags. Friction, not crypticness.
- **Prose/reference accessor-name drift.** Prose uses `position_state(w,u)` (line 612),
  `product_terms(u)` / `unit_status(u)` (lines 470, 474) where the reference exports
  `position`, `productTerms`, `unitStatus`. Conceptual vs Haskell naming; recoverable,
  cosmetic.
- **`balance` is a deliberately demonstrative field** (lines 122–127, 203–205): a second
  conserved field carried only by the reference to exercise the C11 per-field-writer
  discipline. A minimalist could ask whether it is cuttable, since `hwm`→fee_crystallise and
  `entry_nav`→subscribe already give distinct writers. But the document is fully transparent
  about its pedagogical role and excludes it from the economic inventory by intent, so it is
  not cryptic and not load-bearing on correctness. A minimalism call other lenses own more
  than mine; on notation it reads cleanly.
- **"signal S1–S4" forward-reference the §13 Haskell comments** (first at line 311).
  Harmless: the substance is stated inline at each call site and the pointer is parenthetical.

## Why A and not higher

The residuals — index-ordered labels needing a disclaimer, accessor-name drift, the
demonstrative `balance`, the S-signal forward refs — are real but none is cryptic and none
costs correctness. They hold the score at 91 rather than higher. Nothing in my domain is
cryptic on one careful pass; every unified symbol is introduced concretely; the corrected
P3 law and the enumerated conserved-field partition keep the two genuine notational failures
closed. I stake my lens on this again: on notation and unification, the document is at
target.
