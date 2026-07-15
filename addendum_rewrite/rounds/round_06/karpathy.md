# Round 6 — KARPATHY scorecard

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** The one-pass test. Can the target reader (a competent quant engineer who has NOT
read the 27 review rounds) read each section once, top to bottom, without backtracking?
Linear flow, self-documenting, nothing cryptic in my domain, nothing cuttable without loss.

**Grade: A (93%)**

I stake my lens on this. The document passes the one-pass test. The round-6 edit (the `.tex`
was touched after my round-5 card landed) preserves everything I verified and introduces no
new one-pass hazard on my axis.

---

## What I re-verified this round (fresh top-to-bottom pass, not a delta read)

I re-read the whole file rather than trusting the prior A, and re-ran the structural checks:

- **All cross-references resolve.** 12 distinct `\ref` targets, all backed by `\label`s; the
  build log shows zero undefined references and zero reference warnings. No dangling pointer
  was left behind by whatever was cut between round 5 and round 6 (the migration alias moved
  from line 615 to 613, i.e. ~2 lines removed above it, with no breakage).
- **Accessor name still single.** `grep` confirms `position_state(` appears nowhere; only
  `position(w,u)` survives (§4.1 line 287, §6 line 465, §9 line 613). The round-5 fix held.
- **Every load-bearing term defined before linear use.** `StateDelta`, `0_P`/`flat`,
  conserved field, registration-total, monotone carrier, append-only, Option/Some/None — all
  in the §2 table ahead of §3+. `StateDelta`, `ValidDelta`, signals S1–S4 are all glossed at
  or before first use.
- **No condition used before it is defined in reading order.** C1–C12 are all *defined* in §4
  at the forcing instrument; the §5 index is recall, and the §10 unrepresentability glosses
  are downstream. A top-to-bottom reader meets each condition before it is leaned on.

---

## My standing blockers — all still cleared

- **Out-of-order condition numbering** (§4 intro, lines 214–216). "stable tags, not a
  sequence … so the first met below is C2" pre-empts the "did I skip C1?" reflex. Signals
  S1–S4 are pre-announced as labelled notes in the reference, so each later `(signal Sn)` is
  read as "deferred to §13", not a stall.
- **P3 fold identity, `>=>` glossed** (lines 681–692). `f >=> g` named at first use as the
  error-returning composition that stops at the first error, then the law restated in plain
  words. `foldM`'s meaning is recovered adjacently; the precise Haskell stays in the
  reference. Correct prose/reference split.
- **C11 vs C2 two-axis disambiguation** (lines 311–317). Field-writers
  (settle/trade/transfer/fee_crystallise/subscribe) vs event classes
  (Trade/SettleVM/CorporateAction/QISRebalance/MandateAmend) named explicitly distinct,
  matching the reference `FieldWrite` GADT (`StatesHome.hs` 196–201). No conflation.
- **No type-vs-value over-claim.** §10 intro states "unrepresentable" in a precise sense and
  flags conservation as value-level (S4); consistent with the abstract, the P1 gloss, and
  reference signal S4. No blanket "cannot be expressed".
- **Single-unit `StateDelta` vs multi-unit event** (C3, §4.3, and the QIS rebalance / §6.4
  Breaking-amendment paragraphs). One `StateDelta` per unit, composing to event-level
  conservation, applied all-or-nothing; the cross-unit holder move is a *separate* paired
  issuance (S1). Reads in one pass; no contradiction with the §13 reference.

---

## Count and figure consistency (re-checked)

- Abstract "seven of the ten" (line 59) = §10 list {P1,P3,P5,P6,P7,P9,P10} = 7 = §10 closing
  "no other design makes more than three of the ten".
- "Twelve disciplines" (abstract) = C1–C12 index (§5) = 12.
- Pareto table framed as a named scorer's ordinal judgments; B(9,9,8) dominates the
  corr≥7 field {D(7,7,5), E(8,9,2)} and strictly dominates A/C/F. The per-design forcing
  reason, not the score, carries the argument — correctly signposted. No one-pass stall.

---

## Non-blocking observation (noted, not counted against the grade)

- **Notation conserved-field cell** (lines 122–127) remains the single densest passage: it
  defines `conserved field`, lists the conserved fields, justifies `balance` as a second
  conserved field by forward-reference to C11 (defined later, §4.1) and the §13 reference,
  and states what `balance` is *not* — all in one glossary entry. A strict linear reader
  meets "C11" here before C11 is defined. It does not block, for three reasons that still
  hold: (1) it lives in a glossary scanned on demand, not in linear argument prose; (2) the
  phrase "per-field-writer discipline" is self-glossing enough to carry the reader past the
  forward "C11" tag; (3) `balance`'s demonstrative status is re-signposted at every later
  encounter (lines 127, 203–205, 311), so the reader never has to reconstruct it. It is also
  **not cuttable without loss** — `balance` is load-bearing in the reference (it exercises
  C11's per-field-writer discipline with a writer distinct from `ac`) and in C11 itself; cut
  it and a reader meets `balance` at C11 with no anchor. So: dense but justified, on-demand
  not linear, and load-bearing.

---

## Why A and not B

The target reader gets a result-first spine (Question → Notation → Answer → four instruments
→ index → why-three → v10.3 effect → alternatives → unrepresentable → testing → risk →
reference → one-sentence), every load-bearing term defined before use, tag-oriented condition
numbering that pre-empts the skip reflex, a fully self-documenting P3 law, a guarded (not
over-claimed) "unrepresentable", and an educational reference whose names match the prose
exactly and whose comments teach the discipline they encode. Nothing in my domain is cryptic,
nothing forces a backtrack on a careful first pass, and nothing is cuttable without loss. This
clears my bar; I stake my lens on it.
