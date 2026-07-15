# DIRAC — Round 2 scorecard

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Notation minimal and revealing; special-case sprawl unified where one structure
exists, but every unified symbol introduced concretely — never dumped.

**Grade: A (91%)**

I staked my Round 1 verdict on a single sentence: "Fix B1 and B2 and this is an A on my
lens." Both are fixed, cleanly, and B3/B4 too. I honor that standard rather than move it.

---

## Round 1 issues — all discharged

- **B1 (ill-typed P3 equation).** The prose `apply_all(...) ++ events[k:]` that joined a
  ledger to an event list is gone. P3 (lines 671–674) now states the correct law
  `replay (xs <> ys) = replay xs >=> replay ys` in the `Either LedgerError` Kleisli
  category, matching `StatesHome.hs` line 369–371. It typechecks, and it states the right
  thing: checkpoint-independence is a *consequence* of a composition law, not a test.
  **The notational failure is resolved.**
- **B2 (conserved-field extension never given in prose).** Line 122–124 now names the
  partition concretely: conserved = `accumulated_cost`, `balance`; non-conserved = `hwm`,
  `entry_nav`. The latent overstatement I flagged is also sharpened: the `0_P` row (126–128)
  now says a flat row "need not be `0_P`" since it may retain a non-conserved field, and
  C1(a) (282–283) reads "Some(p) with p flat" against the `flat` term defined at line 125.
  A prose-only reader can now decide whether `hwm` is bound by ∑Δf=0 without opening the
  appendix. **Resolved.**
- **B3 (sector name = value-type name).** Line 158–161 annotates that each map's value type
  carries its sector's name by intent and points to `ledgerUS`/`ledgerPS` for
  disambiguation. Addressed by one of the two routes I offered.
- **B4 ("sheaf" dropped as a bare label).** Replaced by "state indexed only over the held
  set {(w,u): position(w,u)=Some}" (lines 626, 643). The unconcretized term is gone.

## What is beautiful here (survives the round)

- **One conservation law, no branch per instrument (C2).** ∑_w Δf(w,u)=0 stated once;
  2-leg, K-leg, VM fan-out, and the vacuous zero-holder case fall out as instances. The
  reference carries this as a monoid homomorphism into `PosDelta` landing at `mempty`, so
  C9 needs no special case. This is the document's Dirac moment.
- **W-sector collapse (C12).** The "inherently wallet-attached" managed account is shown
  (w,u_MA)-keyed because the mandate is a unit, conserving by the standard issuance law; the
  would-be fourth map is named, typed, and shown empty, and the rejected sentinel (design C)
  is the concrete contrast that *breaks* ∑_w h=0.
- **New in this round and squarely in my lens:** lines 304–308 head off the
  one-symbol-two-meanings hazard between the C11 field-writer axis (settle, trade, transfer,
  fee_crystallise, subscribe) and the C2 event-class axis (Trade, SettleVM, …), naming both
  sets concretely and stating they are not meant to coincide. This is exactly the kind of
  collision the lens exists to catch, pre-empted.

## Residual blemishes (non-blocking — do not deny A)

- **C1–C12 appear scrambled** (order of first appearance is C2, C1, C11, C12, C3, C4, C7,
  C5, C9, C10, C6, C8), requiring the disclaimer at lines 205–209 to "read them as tags, not
  a sequence." On a purist Dirac reading, notation that needs a disclaimer is notation
  fighting the reader; appearance-order renumbering would be marginally more revealing. But
  the §6 index supplies a clean lookup and the rule is stated once and obeyed, so it is
  friction, not crypticness. Not blocking.
- **Prose/reference accessor-name drift:** prose uses `position_state(w,u)`,
  `product_terms(u)`, `unit_status(u)` (e.g. line 605) where the reference exports
  `position`, `productTerms`, `unitStatus`. Conceptual vs Haskell naming; recoverable,
  cosmetic.
- **"signal S1–S4" are forward references** into the §13 Haskell comments (first hit: line
  307). Harmless because the substance is stated inline at each call site and the pointer is
  parenthetical.

## Why A and not higher

The two residual blemishes (scrambled labels needing a disclaimer; minor accessor-name
drift) are real but neither is cryptic and neither costs correctness. They hold the score
at 91 rather than higher. Nothing in my domain is now cryptic on one careful pass; every
unified symbol is introduced concretely; the corrected P3 law and the enumerated
conserved-field partition close the only two genuine notational failures I found. I stake my
lens on this: on notation and unification, the document is at target.
