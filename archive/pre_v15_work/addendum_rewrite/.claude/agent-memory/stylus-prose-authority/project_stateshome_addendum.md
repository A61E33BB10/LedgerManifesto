---
name: project-stateshome-addendum
description: StatesHome addendum (addendum_stateshome_v2.tex) — structure, settled facts, and recurring resolutions for STYLUS rewrites
metadata:
  type: project
---

StatesHome = Addendum A1 to Ledger v10.3, file `addendum_rewrite/addendum_stateshome_v2.tex`,
reference `addendum_rewrite/reference/StatesHome.hs` (Haskell, milewski-authored, FORMALIS-cleared).
Worked round-by-round via adversarial agent review; STYLUS does targeted edits only, never wholesale.

**Why:** unit-state homing question from v10.3 §7. Answer: state lives in three maps —
ProductTerms[u] (immutable/versioned/append-only), UnitStatus[u] (mutable/shared), PositionState[w,u]
(monotone carrier + Option accessor). No W-sector. Conditions C1–C12; invariants P1/P3/P5/P6/P7/P9/P10.

**How to apply:**
- CORRECTNESS_CHECKLIST.md is FORMALIS-owned and hard-gated: never drop/weaken any item to read
  smoother (grade-F regression). Re-verify tokens after every edit (C1–C12, P-numbers, SFTR, EMIR,
  Rosetta NS1–7, Feathers, TLC, vacuous, monotone carrier).
- Condition labels C1–C12 are STABLE references indexed in §5; do NOT renumber to match appearance
  order. §4 intro explains they are read as tags, first met is C2.
- Framework primitives (wallet, unit, holding h(w,u), move, transaction, conservation) are v10.3's;
  notation §2 fixes h(w,u) for this doc.
- `balance` is a reference-ONLY demonstrative second conserved PositionState field (transfer-moved),
  pinned in notation §2 + noted absent from §3 inventory by intent. It is NOT h(w,u) and NOT a schema
  economic datum. If an agent later makes balance a real datum (cash balance), it must be added to §3
  and the checklist — flag, don't invent. [[feedback-balance-demonstrative]]
- Reference replay law is a monoid HOMOMORPHISM (not anti-): `replay (xs<>ys) = replay xs >=> replay ys`.
  `>=>` must be glossed in prose at first use (run f, feed result to g, stop at first error).
- Standing CONSULT gaps (content STYLUS cannot source): Feathers 80% authority, SFTR/EMIR/UTI/LEI
  citations, Rosetta NS1–7 / CDM TradeState version, design-E "no tooling" structural reason,
  v10.3 §11 canonical P1–P10 wording. Owners: testcommittee, institutional-brake, rosetta-cdm-engineer,
  correctness-architect, formalis.
- Compile check: `pdflatex -interaction=nonstopmode -halt-on-error` twice; confirm exit 0 + no
  undefined refs.
- C11/P10 wording: each PositionState field has a CLOSED/CANONICAL WRITER SET, not a "unique"
  writer (`ac` has two: WAc 'Settle + WAcTrade 'Trade). Never write "unique field-writer" — it
  self-contradicts `ac→settle/trade`. Use "canonical writer set"; guarantee = a writer OUTSIDE
  the set is a type error at authorship (erased at the row, signal S3). Title is "per-field
  canonical writer"; notation "a canonical writer".
- P3 attribution: the fold homomorphism `replay (xs<>ys)=replay xs >=> replay ys` comes from
  replay being `foldM` (any carrier), NOT from the monotone carrier. The monotone carrier
  (C1(b)) buys a stable key set across checkpoint cuts ⇒ checkpoint-independence. Keep both
  attributions distinct (matches StatesHome.hs:368–375). Don't say "monotone carrier makes
  replay a homomorphism".
- Accessor spelling: prose uses snake_case `product_terms(u)`/`unit_status(u)`/`position(w,u)`;
  reference exports camelCase `productTerms`/`unitStatus`/`position`. The conceptual accessor for
  PositionState is `position(w,u)` — NOT `position_state(w,u)` (that was a one-off phantom, fixed
  R5). Checklist §12 writes `position_state` conceptually but the prose/reference accessor is
  `position`.
- Signals S1–S4 are the labelled expressibility notes in the reference (`StatesHome.hs`); glossed
  once at head of §4 (first cite is in C11). Use "(\S\ref{sec:reference}, signal Sx)" at sites.
- Round 5 (2026-06-27): all 8 reviewers graded A, no blocking issues; R5 closed cross-reviewer
  non-blocking nits only (canonical-writer-set, position(w,u), P3 attribution, S1–S4 gloss).
  `balance` cuttability and `.hs` no-op comments deliberately left to milewski/formalis.
- P5 wording: idempotency of lifecycle events is **structural** (replacement-semantics: status
  insert / hwm max / entry_nav write-once overwrite with the same value at a single key). Do NOT
  call it "dedup" — that implies a runtime mechanism the design doesn't use, and additive fields
  (ac, balance) are NOT idempotent (they'd need event-id dedup, out of P5 scope). §10 P5 gloss
  and testing line (§ testing) must both say "structural". Checklist §9 attribution = single
  (w,u) lattice + per-field canonical handler C11 (no "dedup"/"structural" token — either is a
  STYLUS framing choice; pick "structural" to match §10 "structurally unreachable").
- Round 8 (2026-06-27): Round-7 open-issues list handed to STYLUS was EMPTY (3rd consecutive
  round at unanimous A, zero blocking). No edit made — fabricating a change against a 3-round-
  stable doc is a regression risk, declined. Verified only: compiles clean (exit 0 x2, no undef
  refs), all checklist tokens present, P5 fix from R7 in place. Same CONSULT gaps returned to
  owners (unchanged). Pattern is now firmly: doc is converged; absent a real new blocking issue,
  STYLUS verifies and declines to invent edits.
- Round 7 (2026-06-27): all 8 R6 reviewers staked A, zero blocking. R7 closed one within-mandate
  nit: §10 P5 gloss "per-key dedup" → "structural at a single key" (milewski; aligns L692 with
  L722 "idempotency is structural"). Returned to owners (do NOT edit): `unique-writer` in
  StatesHome.hs L44/L177, .hs Show/no-op comments (milewski/formalis — .hs is theirs); P2/P4/P8
  naming (formalis, v10.3 §11 CONSULT gap). Left as-is with reason: C2 "structurally by event
  class" (checklist §3 token), `balance` cuttability (owners' call; karpathy/henri-cartan say not
  cuttable), "refinement type" gloss (self-glossed, henri-cartan accepts).
- Round 9 (2026-06-27): ONE blocking issue (minsky) — C11/P10 type-level theorem never
  EXERCISED on the live path: every `main` write was `SomeWrite`-wrapped inline, so the phantom
  index `h :: Handler` bound nothing; S3 referenced a `Map WalletId (FieldWrite 'Settle)` handler
  that did not exist; mechanism witnessed only by eta-expanded aliases + comment. Fixed IN THE
  `.hs` (scope exception to the standing ".hs is owner-only" rule: the blocking issue is the
  reference's flagship theorem, and the prompt directed the fix). Added `settleHandler ::
  [(WalletId,Qty)] -> Map WalletId [FieldWrite 'Settle]` (the live C11 checkpoint) and
  `erase = fmap (map SomeWrite)` (the S3 erasure boundary); rebuilt `main` tradeSD/closeSD as
  `erase . settleHandler [...]` (same numeric legs, so conservation/monotone assertions
  unchanged); exported both; updated C11 section comment + S3 signal to cite the live handler;
  updated `.tex` §13 bullet. Carried the standing `unique-writer`→`canonical-writer` .hs comment
  nit while in the file. NO GHC in env — types verified by hand only; CONSULT milewski/formalis
  to `runghc` once. Precedent: when a blocking issue IS a defect in StatesHome.hs, STYLUS may edit
  the .hs (not just return to owners); the prior "return .hs to owners" decisions were for
  cosmetic comment nits, not blocking theorem defects.
- Round 6 (2026-06-27): all 8 R5 reviewers staked A, again zero blocking. R6 closed two
  STYLUS-mandate nits: (1) §4.1 header "One writer per field." → "A canonical writer set per
  field." (milewski; matches C11, removes the last "one/unique" residue in the .tex — verify with
  `grep -i 'one writer\|unique' .tex`, only legit hit is "unique Pareto-optimum" L662); (2) §4
  orientation note de-duplicated (cut redundant "a number met here may exceed one met later",
  jane-street/dirac/chris-lattner density). Returned to owners (do NOT edit): `unique-writer` in
  StatesHome.hs L44/L177 (milewski/formalis — .hs is theirs); P2/P4/P8 naming (formalis, v10.3 §11
  CONSULT gap). `balance` shrink: karpathy/henri-cartan say NOT cuttable — owners' call only.
