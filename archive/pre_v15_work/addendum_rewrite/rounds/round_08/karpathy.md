# Round 8 — KARPATHY scorecard

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** The one-pass test. Can the target reader (a competent quant engineer who has NOT
read the review rounds) read each section once, top to bottom, without backtracking? Linear
flow, self-documenting, nothing cryptic in my domain, correctness preserved, nothing
cuttable without loss.

**Grade: A (93%)**

I stake my lens on this. The document clears the one-pass test on my axis. I re-read the
whole file fresh and re-ran the structural checks; the state is consistent with what I
verified at round 7 and introduces no new one-pass hazard.

---

## Fresh verification this round (full top-to-bottom pass + structural greps)

- **Label/ref integrity.** No duplicate `\label`. Every `\ref` target resolves to a backing
  `\label` (zero MISSING). No dangling pointer anywhere in the spine.
- **Accessor name is single.** `position(w,u)` is the only accessor name, at exactly three
  sites: C1(a) (line 285), §4.4 (line 463), §7 (line 613). The reader meets one name for one
  operation. `position_state(` appears nowhere.
- **Count claims hold.** Exactly 12 `condition` blocks = C1–C12 index in §5 = abstract's
  "twelve disciplines." §10 makes {P1,P3,P5,P6,P7,P9,P10} = seven invariants unrepresentable,
  matching "seven of the ten" in the abstract and the §10 closing "no other design makes more
  than three of the ten."
- **Signals pre-announced, then cited.** §4 intro (lines 215–216) declares S1–S4 as labelled
  notes in the reference; downstream citations resolve cleanly: S1 (×2), S2 (×1), S3 (×3),
  S4 (×2). Each reads as "deferred to §13," never a stall.
- **Prose names match the reference exactly.** `ledgerUS`, `ledgerPS`, `zeroP`,
  `appendVersion`, `usSupersededBy`, `SomeWrite`, `sdRows`, `_c11_ok_*` / `_c11_bad` all appear
  in `reference/StatesHome.hs` as named in the prose. A reader crossing from §3/§4 prose into
  the §13 listing meets no renamed entity.
- **Every load-bearing term defined before linear use.** `StateDelta`, `0_P`/`flat`,
  conserved field, registration-total, monotone carrier, append-only, Option/Some/None — all
  in the §2 table ahead of §3+. `ValidDelta`, `>=>`, S1–S4 glossed at or before first use.

---

## Standing blockers — all still cleared

- **Out-of-order condition numbering** (§4 intro). "stable tags, not a sequence … so the
  first met below is C2" pre-empts the "did I skip C1?" reflex before it fires.
- **P3 fold identity with `>=>`** (lines 681–692). `f >=> g` named at first use as the
  error-returning composition that stops at the first error, then the law restated in plain
  words; precise Haskell stays in the reference. Correct prose/reference split.
- **C11 vs C2 two-axis disambiguation** (lines 311–317). Field-writers vs event classes named
  explicitly distinct, matching the reference `FieldWrite` GADT. No conflation.
- **No type-vs-value over-claim.** §10 intro defines "unrepresentable" precisely and flags
  conservation as value-level (S4); consistent with the abstract, the P1 gloss, and S4.
- **Single-unit `StateDelta` vs multi-unit event** (C3, §4.3, §4.4). One `StateDelta` per
  unit composing to event-level conservation, applied all-or-nothing; the cross-unit holder
  move is a separate paired issuance (S1). Reads in one pass.

---

## Non-blocking observation (noted, not counted against the grade)

- **Notation conserved-field cell** (lines 122–127) remains the single densest passage: it
  defines `conserved field`, lists them, justifies `balance` as a demonstrative second
  conserved field by forward-reference to C11 (defined later in §4.1) and §13, and states what
  `balance` is *not* — all in one glossary entry. A strict linear reader meets "C11" here
  before C11 is defined. It does not block: (1) it lives in a glossary scanned on demand, not
  in linear argument prose; (2) "per-field-writer discipline" self-glosses enough to carry the
  reader past the forward tag; (3) `balance`'s demonstrative status is re-signposted at every
  later encounter (lines 127, 203–205, 311). Not cuttable without loss — `balance` is
  load-bearing in the reference (exercises C11 with a writer distinct from `ac`) and in C11.

---

## Why A and not B

The target reader gets a result-first spine, every load-bearing term defined before use,
tag-oriented condition numbering that disarms the skip reflex, a self-documenting P3 law, a
guarded (not over-claimed) "unrepresentable," and an educational reference whose names match
the prose exactly. Nothing in my domain is cryptic, nothing forces a backtrack on a careful
first pass, and nothing is cuttable without loss. This clears my bar; I stake my lens on it.
