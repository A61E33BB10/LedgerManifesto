# Round 10 — KARPATHY scorecard

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** The one-pass test. Can the target reader (a competent quant engineer who has NOT
read the review rounds) read each section once, top to bottom, without backtracking? Linear
flow, self-documenting, nothing cryptic in my domain, correctness preserved, nothing
cuttable without loss.

**Grade: A (93%)**

I stake my lens on this. The document clears the one-pass test on my axis. I re-read the
file fresh top to bottom and re-ran every structural check; the state is consistent with
rounds 8 and 9 and introduces no new one-pass hazard.

---

## Fresh verification this round (full read + structural greps)

- **Condition count.** Exactly 12 `condition` blocks = C1–C12 index in §5 = abstract's
  "twelve disciplines." No drift.
- **Label/ref integrity.** No duplicate `\label`. Every `\ref` resolves (zero MISSING). The
  spine has no dangling pointer.
- **Accessor name is single.** `position(w,u)` is the only accessor name, at exactly three
  sites (C1(a) line 285, §4.4 line 463, §7 line 613). `position_state(` appears nowhere.
  One name, one operation.
- **Invariant count.** §10 makes {P1,P3,P5,P6,P7,P9,P10} = seven unrepresentable, matching
  "seven of the ten" in the abstract and the §10 closing "no other design makes more than
  three of the ten."
- **Signals pre-announced, then cited.** §4 intro declares S1–S4 as labelled notes in the
  reference; citations resolve cleanly: S1 (×2), S2 (×1), S3 (×3), S4 (×2). Each reads as a
  forward pointer to §13, never a stall.
- **Prose names match the reference exactly.** `ledgerUS`, `ledgerPS`, `zeroP`,
  `appendVersion`, `usSupersededBy`, `SomeWrite`, `sdRows`, `settleHandler`, `ValidDelta`,
  `erase`, `_c11_bad`, `FieldWrite`, `validate`, `applyDelta`, `ReRegistration` all present
  in `reference/StatesHome.hs` as named in the prose. A reader crossing from §3/§4 prose into
  the §13 listing meets no renamed entity.
- **Every load-bearing term defined before linear use.** `StateDelta`, `0_P`/`flat`,
  conserved field, registration-total, monotone carrier, append-only, Option/Some/None — all
  in the §2 table ahead of §3+. `ValidDelta`, `>=>`, S1–S4 glossed at or before first use.

---

## Standing blockers — all still cleared

- **Out-of-order condition numbering** (§4 intro). "stable tags, not a sequence … so the
  first met below is C2" disarms the "did I skip C1?" reflex before it fires.
- **P3 fold identity with `>=>`** (§10). `f >=> g` named at first use as the error-returning
  composition that stops at the first error, then the law restated in plain words; precise
  Haskell stays in the reference. Correct prose/reference split.
- **C11 vs C2 two-axis disambiguation** (C11 body). Field-writers (settle, trade, transfer,
  fee_crystallise, subscribe) named explicitly distinct from event classes (Trade, SettleVM,
  CorporateAction, QISRebalance, MandateAmend), matching the reference `FieldWrite` GADT. No
  conflation.
- **No type-vs-value over-claim.** §10 intro defines "unrepresentable" precisely and flags
  conservation as value-level (S4); consistent with abstract, P1 gloss, and S4.
- **Single-unit `StateDelta` vs multi-unit event** (C3, §4.3, §4.4). One `StateDelta` per
  unit composing to event-level conservation, applied all-or-nothing; the cross-unit holder
  move is a separate paired issuance (S1). Reads in one pass.
- **Lifecycle ordering vs P5** (§11 testing line). Transition ordering is test-enforced (flat
  enumeration), explicitly distinguished from P5's structural idempotency. No contradiction.

---

## Non-blocking observation (noted, not counted against the grade)

- **Notation conserved-field cell** (lines 122–127) remains the single densest passage: it
  defines `conserved field`, lists them, justifies `balance` as a demonstrative second
  conserved field by forward-reference to C11 (defined later in §4.1) and §13, and states
  what `balance` is *not* — all in one glossary entry. A strict linear reader meets "C11"
  here before C11 is defined. It does not block: (1) it lives in a glossary scanned on
  demand, not in linear argument prose; (2) "per-field-writer discipline" self-glosses enough
  to carry the reader past the forward tag; (3) `balance`'s demonstrative status is
  re-signposted at every later encounter (lines 127, 203–205, 311). Not cuttable without loss
  — `balance` is load-bearing in the reference (exercises C11 with a writer distinct from
  `ac`) and in C11.

---

## Why A and not B

The target reader gets a result-first spine, every load-bearing term defined before use,
tag-oriented condition numbering that disarms the skip reflex, a self-documenting P3 law, a
guarded (not over-claimed) "unrepresentable," and an educational reference whose names match
the prose exactly. Nothing in my domain is cryptic, nothing forces a backtrack on a careful
first pass, and nothing is cuttable without loss. This clears my bar; I stake my lens on it.
