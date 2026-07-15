# Round 7 — KARPATHY scorecard

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** The one-pass test. Can the target reader (a competent quant engineer who has NOT
read the 27 review rounds) read each section once, top to bottom, without backtracking?
Linear flow, self-documenting, nothing cryptic in my domain, nothing cuttable without loss.

**Grade: A (93%)**

I stake my lens on this. The document clears the one-pass test. The `.tex` was edited at
01:56 (after my round-6 card at 01:53); I re-read the whole file fresh and re-ran the
structural checks. The edit preserved everything I verified and introduced no new one-pass
hazard on my axis.

---

## Fresh verification this round (full top-to-bottom pass + structural greps)

- **Build is clean.** No undefined references, no multiply-defined, no reference warnings in
  the log. Every `\ref` target (17 distinct sections) is backed by a `\label`; no dangling
  pointer.
- **Accessor name still single.** `position_state(` appears nowhere. Only `position(w,u)`
  survives, at three sites: C1(a) line 285, §4.4 line 463, §7 line 613. Reader meets one name
  for one accessor.
- **Count claims hold.** Seven invariants made unrepresentable = exactly {P1,P3,P5,P6,P7,P9,
  P10} in §10, matching abstract "seven of the ten" and the §10 closing "no other design
  makes more than three of the ten." Twelve `condition` blocks = C1–C12 index (§5) = abstract
  "twelve disciplines."
- **Signals pre-announced before linear use.** §4 intro (lines 215–216) declares S1–S4 as
  labelled notes in the reference; all four are then cited downstream, each read as "deferred
  to §13," never a stall.
- **Every load-bearing term defined before use.** `StateDelta`, `0_P`/`flat`, conserved
  field, registration-total, monotone carrier, append-only, Option/Some/None — all in the §2
  table ahead of §3+. `ValidDelta`, `>=>`, signals S1–S4 glossed at or before first use.
- **No condition leaned on before it is defined in reading order.** C1–C12 are all defined in
  §4 at the forcing instrument; §5 is recall, §10 glosses are downstream.

---

## Standing blockers — all still cleared

- **Out-of-order condition numbering** (§4 intro, lines 213–216). "stable tags, not a
  sequence … so the first met below is C2" pre-empts the "did I skip C1?" reflex.
- **P3 fold identity with `>=>`** (lines 681–692). `f >=> g` named at first use as the
  error-returning composition that stops at the first error, then the law restated in plain
  words. Precise Haskell stays in the reference. Correct prose/reference split.
- **C11 vs C2 two-axis disambiguation** (lines 311–317). Field-writers
  (settle/trade/transfer/fee_crystallise/subscribe) vs event classes
  (Trade/SettleVM/CorporateAction/QISRebalance/MandateAmend) named explicitly distinct,
  matching the reference `FieldWrite` GADT. No conflation.
- **No type-vs-value over-claim.** §10 intro defines "unrepresentable" precisely and flags
  conservation as value-level (S4); consistent with the abstract, the P1 gloss, and S4.
- **Single-unit `StateDelta` vs multi-unit event** (C3, §4.3, §4.4 Breaking-amendment).
  One `StateDelta` per unit, composing to event-level conservation, applied all-or-nothing;
  the cross-unit holder move is a separate paired issuance (S1). Reads in one pass.

---

## Non-blocking observation (noted, not counted against the grade)

- **Notation conserved-field cell** (lines 122–127) remains the single densest passage: it
  defines `conserved field`, lists the conserved fields, justifies `balance` as a second
  conserved field by forward-reference to C11 (defined later in §4.1) and §13, and states
  what `balance` is *not* — all in one glossary entry. A strict linear reader meets "C11"
  here before C11 is defined. It does not block, for three reasons that still hold: (1) it
  lives in a glossary scanned on demand, not in linear argument prose; (2) "per-field-writer
  discipline" is self-glossing enough to carry the reader past the forward "C11" tag; (3)
  `balance`'s demonstrative status is re-signposted at every later encounter (lines 127,
  203–205, 311). It is also not cuttable without loss — `balance` is load-bearing in the
  reference (exercises C11's per-field-writer discipline with a writer distinct from `ac`)
  and in C11 itself. Dense but justified, on-demand not linear, and load-bearing.

---

## Why A and not B

The target reader gets a result-first spine (Question → Notation → Answer → four instruments
→ index → why-three → v10.3 effect → alternatives → unrepresentable → testing → risk →
reference → one-sentence), every load-bearing term defined before use, tag-oriented condition
numbering that pre-empts the skip reflex, a self-documenting P3 law, a guarded (not
over-claimed) "unrepresentable," and an educational reference whose names match the prose
exactly. Nothing in my domain is cryptic, nothing forces a backtrack on a careful first pass,
and nothing is cuttable without loss. This clears my bar; I stake my lens on it.
