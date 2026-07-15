# Iteration Log — StatesHome rewrite (`addendum_stateshome_v2.tex`)

## Round 10 (STYLUS) — closing the sole Round-9 blocking issue (P5 mechanism mis-cited)

Document compiles (pdflatex, exit 0; 25 pages, no error/halt). No checklist item dropped or
weakened. One blocking issue was open; it is resolved by a single targeted edit to the P5 gloss
in §sec:unreachable.

- **[milewski] P5 mechanism mis-cited (lines 691–692).** P5 (idempotency of lifecycle events)
  attributed the guarantee to "a single (w,u)-keyed row and a per-field canonical writer (C11)".
  Wrong axis: unit-level lifecycle lives in *UnitStatus*[u] (u-keyed), idempotent by
  replacement; C11 governs *PositionState* field-writers, and §sec:untraded states lifecycle
  moves LISTED→ACTIVE→EXPIRED entirely through *UnitStatus*, creating no *PositionState* row —
  so the canonical path touches neither a (w,u) row nor a C11 field. Claim true, mechanism
  wrong. Fixed: P5 now attributes idempotency to *UnitStatus*[u] u-keyed write-by-replacement
  (EXPIRED over EXPIRED is EXPIRED), cites §sec:untraded for the no-PositionState-row path,
  carries the same-algebra contrast for the non-conserved *PositionState* fields (hwm by max,
  entry_nav write-once), and states the additive conserved fields (accumulated_cost, balance)
  draw replay-safety from P1, not replacement. The (w,u)+C11 attribution is dropped. Consistent
  with line 722, which already calls P5's idempotency structural.

## Round 9 (STYLUS) — closing the sole Round-8 blocking issue (C11/P10 not exercised on the live path)

Document compiles (pdflatex, two passes, exit 0; no undefined references, no rerun, no
error/warning). No checklist item dropped or weakened; all tokens re-verified present after
editing (C1–C12, P1/P3/P5/P6/P7/P9/P10, SFTR, EMIR, UTI, LEI, Rosetta, Feathers, TLC, vacuous,
monotone carrier, canonical writer set, unique Pareto, balance). One blocking issue was open; it
is resolved by editing the reference `reference/StatesHome.hs` (included verbatim by the `.tex`
via `\lstinputlisting`) and the one `.tex` prose bullet that describes it. The scope exception
to the standing ".hs is owner-only" decision is deliberate: this round's blocking issue *is* a
defect in the reference's flagship theorem, and the prompt directs that it be fixed.

- **[minsky] C11/P10 type-level theorem never exercised in the live path (`StatesHome.hs`
  GADT 196–219, `_c11_ok`/`_c11_bad` 437–443, `main` 513–541; `.tex` §13 reference bullet,
  signal S3).** The phantom index `h :: Handler` constrained nothing at any real call site:
  every `main` write was wrapped in `SomeWrite` inline, so the index was erased before it
  bound anything. S3 claimed the index "is checked where each handler declares its output type
  (`Map WalletId (FieldWrite 'Settle)`)" while no such handler existed; the mechanism was
  witnessed only by two eta-expanded constructor aliases and a comment. Fix, exactly as
  prescribed:
  - Added `settleHandler :: [(WalletId, Qty)] -> Map WalletId [FieldWrite 'Settle]` — a real
    handler whose declared `'Settle` output type IS the C11 checkpoint (a body emitting `WHwm
    :: FieldWrite 'FeeCrystallise` would not typecheck against it).
  - Added `erase :: Map WalletId [FieldWrite h] -> Map WalletId [SomeWrite]`,
    `erase = fmap (map SomeWrite)` — the S3 erasure boundary, in code.
  - Rebuilt `main`'s `tradeSD` and `closeSD` as `erase . settleHandler [...]`, so the
    authorship -> erasure pipeline runs on the live path. The numeric legs (buyer +1000 /
    seller −1000; close −1000 / +1000) are unchanged, so the worked conservation and
    monotone-carrier assertions in `main` are identical.
  - Exported `settleHandler`, `erase`; updated the C11 section comment and signal S3 to point
    at the live handler and the `erase` boundary (and to drop the dangling `_c11_typeError`
    reference, which named nothing; the real witnesses are `settleHandler` live and
    `_c11_ok_*` / commented `_c11_bad` static).
  - Updated the `.tex` §13 bullet to state that `settleHandler`'s `Map WalletId [FieldWrite
    'Settle]` output type is the live call site and that `main` builds the deltas as
    `erase . settleHandler`, erasing through `erase = fmap (map SomeWrite)` into `sdRows`.
  No claim broadened, no condition weakened: C11/P10 deliver the same guarantee (cross-handler
  write = type error at authorship, erased at the row, S3); it is now exercised rather than
  asserted. Carried the standing `.hs` comment nit while in the file: `unique-writer` ->
  `canonical-writer(-set)` at the C11 export comment and section header, aligning the reference
  with the `.tex`'s settled "canonical writer set" vocabulary (R5).

### Verification note (no GHC in this environment)

`ghc`/`runghc` are not installed here, so the reference was type-checked by hand, not compiled.
The added code is standard: `settleHandler` builds `Map WalletId [FieldWrite 'Settle]` via
`Map.fromList`; `erase = fmap (map SomeWrite)` is `Map.map` over the values with
`SomeWrite :: FieldWrite h -> SomeWrite` per element; `'Settle` is the DataKinds-promoted
`Handler` constructor (extension already enabled). No name clash (`erase` is not in Prelude,
`Data.List`, or the qualified `Data.Map.Strict` import). **CONSULT (milewski/formalis): run
`runghc StatesHome.hs` once in a GHC environment to confirm the artifact still compiles and
`main` runs; STYLUS verified types by hand only.**

### False positives

- None. The Round-8 issue is correct: the index genuinely bound nothing on the live path, and
  S3 referenced a handler that did not exist. Both are now fixed.

## Round 8 (STYLUS) — no within-mandate blocking issue open; verification only

The Round-7 open-issues list handed to STYLUS was empty: all eight Round-7 reviewers staked
grade A with **no blocking issue**, the third consecutive round at that state (R5, R6, R7).
No edit made. Manufacturing a change against a document stable at A for three rounds is a
regression risk, not a simplification, and is declined under the mandate.

Verification performed:

- **Compiles clean.** `pdflatex -interaction=nonstopmode -halt-on-error`, two passes, exit 0
  both passes; no undefined references, no rerun warnings (the only `rerun` grep hit is the
  `rerunfilecheck.sty` filename in the load path, not a message).
- **All checklist tokens present** after re-grep: C1–C12 (each at least once), P1/P3/P5/P6/P7/
  P9/P10, SFTR, EMIR, UTI, LEI, Rosetta, Feathers, TLC, vacuous, monotone carrier, canonical
  writer set, unique Pareto, balance. The Round-7 P5 fix is in place (§10 P5, "structural at a
  single key, not cross-map coordination"), consistent with §12 testing ("idempotency is
  structural").
- **Full read against the standing discipline and the checklist** for any surviving
  within-mandate defect (term-before-definition, statement-made-twice, register breaks,
  deductive-order breaks). None found that is actionable without weakening a hard-gated token
  or overturning a settled owner-scope decision.

### Items deliberately not changed (returned to owners — standing CONSULT gaps, unchanged)

- *`unique-writer` in `StatesHome.hs` (hs 44, hs 177); `.hs` Show/no-op comments* — reference
  is milewski-authored, FORMALIS-cleared; STYLUS scoped to the `.tex`. **milewski/formalis.**
- *P2, P4, P8 (merely-tested invariants) never named* — canonical statements live in v10.3 §11,
  the parent document; STYLUS cannot source them. **formalis.**
- *Feathers ≥80% authority; SFTR/EMIR/UTI/LEI citations; Rosetta NS1–7 / CDM `TradeState`
  version; design-E "no tooling" structural reason* — enforceable-source/derivation gaps STYLUS
  cannot fill. **testcommittee / institutional-brake / rosetta-cdm-engineer / correctness-architect.**
- *`balance` cuttability; C2 "structurally per event class" wording; "refinement type" gloss* —
  content/minimalism calls held by owners across R5–R7 (karpathy/henri-cartan: `balance` not
  cuttable; checklist §3 owns the C2 token). Left intact.

### False positives

- The empty Round-7 issue list is not a false positive: it correctly reflects three rounds of
  unanimous A with no blocking issue. Round 8 has no mandatory edit, and none was fabricated.

## Round 7 (STYLUS) — targeted edit closing the sole within-mandate Round-6 non-blocking item

Document compiles (pdflatex, two passes, exit 0, no undefined references). No checklist item
dropped or weakened; all tokens re-verified present after editing (C1–C12, P1/P3/P5/P6/P7/P9/P10,
SFTR, EMIR, UTI, LEI, Rosetta, Feathers, TLC, vacuous, monotone carrier, canonical writer set,
unique Pareto, balance). All eight Round-6 reviewers (chris-lattner, dirac, formalis,
henri-cartan, jane-street-cto, karpathy, milewski, minsky) graded A and recorded **no blocking
issue**. Round 7 closes the one carried non-blocking item that is both inside STYLUS's
form/precision mandate and scoped to the `.tex`; substance unchanged.

- **[milewski] P5 gloss "per-key dedup" (§10 P5, line ~692) contradicts the testing line's
  "idempotency is structural" (line ~722).** milewski's sole carried item and the only fog he
  reports in his domain: the P5 gloss called idempotency "a per-key dedup", while the testing
  section calls the same invariant "structural". The two pull opposite ways — "dedup" implies a
  runtime mechanism that "structural" denies; for lifecycle (replacement-semantics) events,
  re-application overwrites with the same value, so idempotency holds by construction, not by a
  dedup pass. This is a one-statement-two-places inconsistency (STYLUS mandate). Resolved toward
  the document's own settled term: line 692 now reads "make idempotency **structural at a single
  key**, not cross-map coordination", matching line 722 ("idempotency is structural") and §10's
  "structurally unreachable" framing. The CORRECTNESS_CHECKLIST §9 attribution is kept verbatim
  ("a single $(w,u)$-keyed row and a per-field canonical writer (C11)"); only the consequence
  clause's outlier word "dedup" is replaced. No new content decided, no claim broadened: P5's
  scope (lifecycle events) and its C11/single-key attribution are unchanged; the stronger,
  already-present word is kept and the looser one struck.

### False positives / items deliberately not changed (returned to owners)

- No Round-6 issue was a false positive in the sense of being wrong; **no reviewer raised a
  blocking issue** (all eight staked A). Items left unchanged, with reason:
  - *`unique-writer` survives in `StatesHome.hs` comments (hs 44, hs 177)* (minsky, milewski):
    a one-word `.hs` comment fix; `StatesHome.hs` is the milewski-authored, FORMALIS-cleared
    reference and the prompt scopes STYLUS to `addendum_stateshome_v2.tex`. Standing decision
    (R5, R6). **Return to milewski/formalis.**
  - *`StateDelta` `Show` abbreviation in demo comments (hs ~526); `WEntryNav`/`WHwm` second-write
    no-op lacks an explanatory comment* (minsky, jane-street-cto): `.hs` comment matters, not
    load-bearing, reference owner's call. **Return to milewski/formalis.**
  - *C2 "structurally, by event class" in mild tension with S4's value-level framing*
    (jane-street-cto): "structurally per event class" is a CORRECTNESS_CHECKLIST §3 token;
    rewording risks the checklist attribution for no comprehension gain. Held at A floor, not a
    blocker. Left as-is.
  - *demonstrative `balance` is the most cuttable element* (chris-lattner, dirac, jane-street-cto):
    karpathy and henri-cartan judge it **not cuttable without loss** (load-bearing for C11 and the
    reference, which needs a conserved field with a writer distinct from `ac`'s). A
    content/minimalism decision for milewski/formalis, not a STYLUS simplification. Left intact.
  - *P2, P4, P8 (the three merely-tested invariants) never named* (henri-cartan): canonical
    statements live in v10.3 §11, the parent document; STYLUS cannot source them. Standing
    CONSULT gap. **Return to formalis.**
  - *"refinement type" unglossed (§4.1, line ~251)* (henri-cartan): self-glossed by its own
    sentence ("a refinement type on a sum of decimals is not free in any production language");
    henri-cartan marks it acceptable, no other reviewer flags it. A gloss would add bloat for no
    comprehension gain. Left as-is.

## Round 6 (STYLUS) — targeted edits closing the residual cross-reviewer non-blocking nits

Document compiles (pdflatex, two passes, exit 0, no undefined references). No checklist item
dropped or weakened; all tokens re-verified present after editing (C1–C12, P1/P3/P5/P6/P7/P9/P10,
SFTR, EMIR, UTI, LEI, Rosetta, Feathers, TLC, vacuous, monotone carrier, canonical writer set,
unique Pareto, balance). All eight Round-5 reviewers (chris-lattner, dirac, formalis,
henri-cartan, jane-street-cto, karpathy, milewski, minsky) graded A and recorded **no blocking
issue**. Round 6 therefore closes the two actionable cross-reviewer non-blocking items that fall
inside STYLUS's form/precision mandate; substance unchanged.

- **[milewski] paragraph header "One writer per field." contradicts `ac`'s two writers (§4.1,
  line ~302).** milewski's sole carried non-blocking item: the header read "One writer" while
  `ac` has two authorised writers (`WAc :: FieldWrite 'Settle`, `WAcTrade :: FieldWrite 'Trade`),
  the body self-correcting two lines down. This is the lead-in analogue of the R5 C11 "unique" →
  "canonical writer set" correction left lingering in the header. Header changed to "A canonical
  writer set per field.", matching the C11 condition title and the body example `ac`→settle/trade;
  the trailing "each field's writer" → "each field's writers" for internal precision. The C11
  condition block (canonical writer set; outside-set write = type error at authorship, erased at
  the row, S3) is untouched; this is a fidelity fix toward C11, not a weakening.
- **[jane-street-cto, dirac, chris-lattner] §4 orientation note dense / costs a re-read (lines
  ~212–218).** The out-of-appearance-order disclaimer stated the same idea three times
  ("follow that index, not order of first appearance" / "a number met here may exceed one met
  later" / "read as tags, not as a sequence"). Landau collapse: kept the rule once ("stable tags,
  not a sequence: they follow the §5 index rather than order of first appearance"), the concrete
  anchor once ("the first met below is C2"), the load-bearing note (§9, §12), and the S1–S4 gloss;
  cut only the redundant "a number met here may exceed one met later" clause (jane-street's specific
  density complaint), which is fully implied by "not a sequence". The standing-discipline-required
  orientation sentence (C-numbers are stable labels indexed in §5) is preserved.

### False positives / items deliberately not changed (returned to owners)

- No Round-5 issue was a false positive in the sense of being wrong; **no reviewer raised a
  blocking issue** (all eight staked A). Items left unchanged, with reason:
  - *`unique-writer` survives in the reference comments `StatesHome.hs` lines 44 and 177*
    (minsky, jane-street-cto): a one-word comment fix ("unique-writer" → "canonical-writer")
    that would bring the reference into line with the R5/.tex correction, but `StatesHome.hs` is
    the milewski-authored, FORMALIS-cleared reference and the prompt scopes STYLUS to
    `addendum_stateshome_v2.tex`. Consistent with the standing decision (R5) that `.hs` comment
    edits belong to the reference owner. **Return to milewski/formalis.**
  - *C2 "structurally, by event class" in mild tension with S4's value-level framing*
    (jane-street-cto): "structurally per event class" is a CORRECTNESS_CHECKLIST §3 token;
    rewording it risks the checklist attribution for no comprehension gain (jane-street holds it
    at the A floor, does not block). Left as-is.
  - *`balance` notation cell densest / "most cuttable"* (chris-lattner, dirac, jane-street-cto):
    karpathy and henri-cartan judge it **not cuttable without loss** (load-bearing for C11 and the
    reference). Cutting or shrinking its substance is a content/minimalism decision for
    milewski/formalis, not a STYLUS simplification (standing decision, R5). Left intact.
  - *P2, P4, P8 (the three merely-tested invariants) never named* (henri-cartan): their canonical
    statements live in v10.3 §11, the parent document; STYLUS cannot source them. Standing CONSULT
    gap. **Return to formalis.**
  - *`WEntryNav` write-once / `WHwm` qmax silently no-op a second write* (jane-street-cto): a
    one-line comment in `StatesHome.hs`; reference owner's call. Left for milewski/formalis.

## Round 5 (STYLUS) — targeted edits closing the recurring non-blocking items

Document compiles (pdflatex, two passes, exit 0, no undefined references). No checklist item
dropped or weakened; all tokens re-verified present after editing (C1–C12, P1/P3/P5/P6/P7/P9/P10,
SFTR, EMIR, UTI, LEI, Rosetta, Feathers, TLC, vacuous, monotone carrier). Every Round-4
reviewer (chris-lattner, dirac, formalis, henri-cartan, jane-street-cto, karpathy, milewski,
minsky) graded A and recorded **no blocking issue**. Round 5 therefore closes the
non-blocking items raised by two or more reviewers, all within STYLUS's form/precision
mandate; substance unchanged.

- **[milewski] phantom identifier `position_state(w,u)` (§ effect-on-v10.3, line ~612).**
  The migration sentence mapped `get_unit_state(w,u)` to `position_state(w,u)`, a token that
  matches neither the reference export (`position`, `StatesHome.hs:387`) nor the document's
  own prose convention (`position(w,u)` at the C1 accessor and the untraded-instrument case).
  Replaced with `position(w,u)`. Substance of checklist §12 preserved: the deprecated
  `get_unit_state(w,u)` maps to the PositionState accessor; only the accessor's spelling is
  brought into line with the reference and the rest of the prose.
- **[milewski, minsky] "unique field-writer" self-contradicts `ac→settle/trade` (C11 body,
  C11 index, P10).** C11 delivers a *closed* writer set per field (the `FieldWrite h` GADT:
  `WAc :: FieldWrite 'Settle` and `WAcTrade :: FieldWrite 'Trade` are both authorised for
  `ac`), so "the unique field-writer" overstated the set's cardinality and contradicted the
  example listed in the same clause. Replaced with the condition's own title vocabulary:
  C11 body now reads "tagged with its canonical writer set --- the closed set of
  field-writers permitted to mutate it … a write by any field-writer **outside that set** is
  a type error at the writer's authorship site"; the §5 index row reads "a canonical writer
  set; a writer outside it is a type error at authorship"; P10 reads "the canonical writer
  set per field … a write by a field-writer outside it". The delivered guarantee
  (undeclared writer = type error at authorship, erased at the stored row, S3) is preserved
  verbatim; this is a fidelity correction toward the reference, not a weakening. The
  condition title ("per-field canonical writer") and notation ("a canonical writer") already
  used this vocabulary and were left intact.
- **[jane-street-cto] P3 attributed the fold homomorphism to the monotone carrier (§
  invariants, P3).** The homomorphism `replay (xs <> ys) = replay xs >=> replay ys` follows
  from `replay` being the `foldM` of the stream, for any carrier; what the monotone carrier
  (C1(b)) buys is a key set that is stable across checkpoint cuts. Re-attributed to match the
  reference's own comment (`StatesHome.hs:368–375`): replay is the `foldM`, *hence* a fold
  homomorphism; the monotone carrier keeps the key set stable across any cut, so
  checkpoint-independence is a consequence of the law. C1(b) still cited; the law, the `>=>`
  gloss, and checkpoint-independence are unchanged.
- **[henri-cartan, dirac, karpathy] "signal S1–S4" used before glossed.** Added one
  orientation sentence at the head of §4 (where the first signal reference occurs, in C11):
  parenthetical references to signals S1–S4 point to the labelled expressibility notes in the
  reference. Defines the term once, before first use; no per-site clutter added.

### False positives / notes

- No Round-4 issue was a false positive in the sense of being wrong; rather, **no reviewer
  raised a blocking issue at all** (all eight graded A). The four items above are the
  cross-reviewer non-blocking nits; they were actionable form/precision fixes, so closed.
- Items deliberately **not** changed, with reason:
  - *Prose snake_case vs reference camelCase accessor drift* (dirac): intentional convention
    — prose names accessors `product_terms`/`unit_status`/`position`, the reference exports
    `productTerms`/`unitStatus`/`position`. Conceptual vs Haskell spelling; not a defect.
  - *P5 gloss "single (w,u)-keyed row" reads slightly off for `lifecycle_stage`* (minsky):
    minsky judged it cosmetic and the claim holds regardless; the checklist attributes P5 to
    "single (w,u) lattice + C11". Changing it risks re-opening the checklist attribution for
    no comprehension gain. Left as-is.
  - *`WHwm` qmax / `WEntryNav` write-once silently no-op a second write* (jane-street-cto):
    a possible one-line comment in `StatesHome.hs`, which is the milewski-authored,
    FORMALIS-cleared reference — not STYLUS's to edit. Left for the reference owner.
  - *`balance` is the most cuttable element* (jane-street-cto, dirac, karpathy): it is a
    checklist/reference item (demonstrative second conserved field exercising C11); cutting
    it is a content decision for milewski/formalis, not a STYLUS simplification. Left intact.

## Round 4 (STYLUS) — targeted edit resolving the sole Round-3 blocking issue

Document compiles (pdflatex, two passes, exit 0, no undefined references). No checklist item
dropped or weakened; the edit is a one-operand notation fix, nothing else touched.

- **[milewski] §9 (line ~611) migration alias type-incorrect `++`.** The deprecated
  `get_unit_state(u)` alias was written `product_terms(u) ++ unit_status(u)`. In the Haskell
  reference the accessors are `productTerms l u :: Maybe ProductTerms` and
  `unitStatus l u :: Maybe UnitStatus` (`StatesHome.hs` lines 381–385) — two distinct record
  types in `Maybe`, not lists, so `++` (list concatenation) does not type. Replaced with the
  pair `(product_terms(u), unit_status(u)) :: (Maybe ProductTerms, Maybe UnitStatus)`, which
  is type-correct and expresses the same "old single unit-state now split across two maps"
  intent. No semantic change; the split into ProductTerms and UnitStatus is unchanged.

### False positives / notes

- The issue is correct, not a false positive; `++` over two `Maybe`-wrapped record types is a
  genuine type error against the anchored reference.

## Round 3 (STYLUS) — targeted edits resolving Round-2 blocking issues

Document compiles (pdflatex, two passes, exit 0, no undefined references). Checklist tokens
re-verified present (C1–C12, P3/P10, balance, monotone carrier, vacuous, SFTR, Rosetta,
Feathers, TLC). No item dropped or weakened.

- **[henri-cartan] §10 P3 dangling `>=>` / Kleisli notation.** Replaced the undefined
  "Kleisli fold … in the `Either LedgerError` Kleisli category" with a glossed form: `f >=> g`
  is named at first use as the composition that runs the error-returning step `f`, feeds its
  result to `g`, and stops at the first error; the law is also restated in plain words
  ("replaying a concatenated log equals replaying each part and composing the two"). The
  formal line `replay (xs <> ys) = replay xs >=> replay ys` is retained; the bare term
  "Kleisli category" is removed.
- **[milewski B5] `balance` meaning unpinned + absent from §3.** Notation conserved-field
  entry now pins `balance`: a second conserved PositionState field, transfer-moved, carried
  **only by the reference** to exercise the C11 per-field-writer discipline with a writer
  distinct from `accumulated_cost`'s; explicitly **not** the framework holding `h(w,u)` and
  **not** an economic datum of the §3 inventory (resolves milewski's three-way ambiguity to
  option (c), demonstrative second conserved field, distinct from `h(w,u)`). §3 home-of-each-
  datum table now carries a note stating `balance` is absent by intent (demonstrative, not a
  schema datum), aligning §3 with the notation, C11, and the reference.
- **[milewski B6] `.hs` line 369 mislabel.** Deleted `(anti)` from "Kleisli (anti)homomorphism
  law" in the `replay` comment; the law is order-preserving (lists under `++` → Kleisli arrows
  under `>=>`), a monoid homomorphism. Now matches the correct §10 P3 statement.

### False positives / notes

- None of the four issues judged a false positive. One **CONSULT flag** raised by the B5
  resolution: I pinned `balance` as demonstrative (reference-only) because the settled
  materials jointly establish it — the reference comments mark the PositionState fields as
  "demonstrating C11", `psBalance` exists to be a second conserved field with a `Transfer`
  writer, and neither the §3 inventory nor CORRECTNESS_CHECKLIST §5 lists `balance` as an
  economic datum. **If the owner intends `balance` to be a real economic datum (e.g. a cash
  settlement balance), milewski / formalis must add it to the §3 inventory and the checklist;
  as the materials stand it is demonstrative.** STYLUS did not invent semantics for it.

## Round 2 (STYLUS) — targeted edits resolving pooled Round-1 blocking issues

Document compiles (pdflatex, two passes, exit 0, all references resolved). All
`CORRECTNESS_CHECKLIST.md` tokens verified present after editing (C1–C12, P1/P3/P5/P6/P7/P9/P10,
SFTR, EMIR, UTI, LEI, Rosetta NS1–7, Feathers threshold, TLC, CDM enum, vacuous base case,
monotone carrier). No item dropped or weakened; expansions only.

Per-issue changes (pooled-issue numbers):

- **1, 12 (P3 fold identity).** Replaced the type-incoherent
  `apply_all(events[:k]) ++ events[k:] ≡ apply_all(events)` in §11 P3 with the Kleisli law of
  the reference: `replay (xs <> ys) = replay xs >=> replay ys` in the `Either LedgerError`
  Kleisli category; checkpoint-independence stated as a consequence of the law.
- **2, 4, 9, 16 (condition numbering / orientation).** Per the standing discipline (keep the
  load-bearing labels; do not renumber), added one orientation paragraph at the head of §4:
  conditions are introduced where forced, C1–C12 are stable labels indexed in §5 (not
  appearance order), the first met is C2, and labels are read as tags. Numbers left intact
  (referenced by §11, §7, and the checklist's C-by-C mapping).
- **3 (cryptic conservation shorthand).** §4.1 "Conservation of ac": replaced
  `∑_w h-style conservation extends to it` with `conservation as defined for h extends to it`,
  cross-referencing the notation.
- **5, 13 (0_P vs flat).** Notation now defines `conserved field`, `flat` (conserved fields
  zero), and `0_P` (every field zero = `zeroP`); states a first-touch row is `0_P` but a flat
  row need not be. C1(a) now reads `Some(p)` with `p` flat for held-and-flat; C1(b) close-out
  "leaves a flat row" (not `0_P`). Wind-down's "final HWM retained on a flat row" is now
  consistent.
- **6 ("(w,u) lattice").** §11 P5: "single (w,u) lattice" → "single (w,u)-keyed row".
- **7 (StateDelta forward reference).** Added a `StateDelta` entry to the §2 notation table
  (change one event proposes, for a single unit, across the three maps; conservation-checked
  and atomic, C2/C3).
- **8, 13, 30 (conserved-field set; psBalance/Transfer ungrounded).** Notation enumerates the
  conserved fields (accumulated_cost, balance — the latter moved by a transfer) and the
  non-conserved (hwm, entry_nav). C11 now lists `balance→transfer` alongside the other
  field-writers, grounding the reference's psBalance/Transfer in the prose.
- **10 (0_P forward refs in notation).** The notation `0_P` entry no longer leans on
  undefined "first-touch row"/"held-and-flat"; it defines `flat` locally and points `zeroP`
  to the reference.
- **11 (Pareto scores, no scorer).** §8 intro now names the scorer (the adversarial
  multi-agent review, per the closing note) and frames the 0–10 figures as its ordinal,
  relative judgments, not measured quantities, with correctness as the gate axis; states the
  per-design forcing reason, not the score, carries the argument. Numbers and the "≥7 gate"
  preserved.
- **14 (UnitStatus/PositionState double meaning).** Added a sentence after "The Answer"
  listing: each map's value type carries its sector name by intent; the reference names the
  maps `ledgerUS`/`ledgerPS` to keep them apart.
- **15 (sheaf label).** Struck "sheaf" from design E in the table and the forcing-reason
  bullet; replaced with "state indexed only over the held set". Forcing reason ("no
  implementation in available tooling") preserved verbatim.
- **17, 24, 28 (P1/C11/P10 over-claimed as type-level).** §11 intro rewritten: drops the
  blanket "the illegal state cannot be expressed"; names three mechanisms (smart-constructor
  unreachable-through-API for P1; NonEmptyList untypable for P6; type-checked-at-authorship-
  then-erased for P10) and states "unrepresentable" is used in that precise sense, with
  conservation explicitly a value-level check (S4). P1 entry now states the validate
  smart-constructor / "unconserved delta cannot reach applyDelta" / value-level (S4). P10
  entry now carries authorship-then-erased (S3).
- **18, 29 (handler vocabularies collide).** C11 now states the field-writers (settle, trade,
  transfer, fee_crystallise, subscribe) are a different axis from the C2 event classes
  (Trade, SettleVM, CorporateAction, QISRebalance, MandateAmend), one class driving one or
  more field-writers, names not meant to coincide.
- **19 (C11 not shown biting; soften §7 bullet).** §7 reference bullet now states the
  typecheck failure binds at the handler's authorship site and the index is erased into
  `sdRows` via `SomeWrite`, so the guarantee binds at authorship, not at the delta row (S3).
- **20 (generator universe).** Restored "(CDM enum × product-type)" on the §11 testing line.
- **21 (F5).** Restored "SFTR / EMIR reporting surface" and "UTI / LEI pair".
- **22 (F6).** Restored "Rosetta NS1–7"; "trade-state" → `TradeState`.
- **23 (Feathers, TLC).** Restored "(Feathers threshold)" on the ≥80% line and "TLC-tractable"
  (was "model-checker-tractable").
- **25 (lifecycle ordering vs P5 contradiction).** Added to the lifecycle-guards testing line:
  the lifecycle is a flat enumeration, so transition ordering (no EXPIRED→LISTED) is
  test-enforced, not type-enforced — distinct from P5's structural idempotency.
- **26 (single-sdUnit StateDelta vs multi-unit event).** C3 now reads "carries, for a single
  unit, ..."; the QIS rebalance paragraph reframed as one StateDelta per unit (ES/NQ/YM rows
  are different units) applied together; added a note that validate discharges single-unit
  cross-wallet conservation and a multi-unit event is one ValidDelta per unit composing to
  event-level conservation, applied all-or-nothing (S1).
- **27 (Breaking-track re-subscription folded into amend).** §4.4 Breaking track now states
  the holder move is a *separate* paired-issuance event (burn on u_old, mint on u_new), not
  part of the amendment, citing S1; a single-unit StateDelta cannot span the two units.

### Standing CONSULT gaps surfaced (content STYLUS cannot source — return to owners)

- **Feathers threshold (≥80%)** — restored per checklist, but the source/authority for the
  80% gate is still unpinned. testcommittee: pin to a citable source or declare project-chosen.
- **SFTR / EMIR / UTI / LEI** — restored per checklist; not yet pinned to identifier + named
  version. institutional-brake: supply enforceable citations.
- **Rosetta NS1–7 / CDM `TradeState`** — restored per checklist; CDM artefact + version
  unpinned. rosetta-cdm-engineer: supply versioned reference.
- **Design E "no implementation in available tooling"** — kept as existing content; the
  structural reason this construction lacks tooling is unestablished. correctness-architect:
  give the structural reason or strike.
- **v10.3 §11 P1–P10 invariant statements** — the gloss names each but the canonical
  statements live in v10.3 §11; formalis owns the exact wording and the canonical quantity
  symbol.
