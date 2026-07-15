# Round 5 — MILEWSKI (Expressibility lens)

**Grade: A (91%)** — staked on my lens. Both cosmetic items recorded in round 4 are
resolved; no expressibility defect remains, and no categorical claim in my domain is
mislabelled. A competent quant engineer who has not read the review history maps every
concept to the Haskell reference in one careful pass.

## Verdict

Every concept maps cleanly and faithfully to `reference/StatesHome.hs`. The categorical
claims in my exact domain are correct and genuinely earned by the code:

- **Conservation (C2) as a group homomorphism** `Map WalletId [SomeWrite] -> PosDelta`,
  "conserving" = image is `mempty`. Stated in words first, name last (lines 221–242 of the
  reference; tex C2 lines 256–268). The vacuous zero-holder case (C9) falls out of the
  empty `foldMap` with no special case — kills the `dividend/len(holders)` bug class.
- **Replay as a Kleisli fold homomorphism** (P3, lines 685–692): the law
  `replay (xs <> ys) = replay xs >=> replay ys` in the `Either LedgerError` Kleisli
  category is correctly a *homomorphism* (not antihomomorphism), genuinely satisfied by
  `foldM applyDelta`. The `>=>` gloss for the reader is accurate.
- **C1 two halves** (Option accessor / monotone carrier) map exactly to `Maybe` +
  no-deleter-exported. never-held (`Nothing`) vs held-and-flat (`Just zeroP`) is
  load-bearing and stated as such.
- **ProductTerms = `NonEmpty TermsVersion`** makes "registered but versionless" untypable
  (C6/C7); abstract, only growers `register`/`appendVersion`.
- **C11 prose is honest about what the encoding delivers**: "type error at authorship,
  erased once writes share a delta row (S3)" — it does not over-claim the structural
  unrepresentability that P1/P6 legitimately can. The round-1/2 over-claim pattern stays
  fixed.
- **S1–S4 expressibility signals** correctly point each awkward requirement at the design
  layer (cross-unit conservation = paired issuance; C4 read-scoping = capability/Reader at
  the boundary; C11 authorship-erasure tradeoff; conservation as a value-level check). This
  is exactly the restraint discipline my lens asks for — name the awkwardness, do not
  contort the data type around it.

## Resolved since round 4

1. **`position_state(w,u)` phantom identifier — FIXED.** Migration line 615 now reads
   "`get_unit_state(w,u)` of line 2287 maps to `position(w,u)`", matching the reference
   export `position` (StatesHome.hs:387) and every other occurrence in the tex. The token
   that matched neither the export nor the doc's own convention is gone.

2. **"unique / one canonical field-writer" overstatement — FIXED.** C11 (lines 307–319)
   now reads "the canonical writer **set** --- the closed set of field-writers permitted to
   mutate it: `ac`->settle/trade; ...". The "unique"/"one canonical" adjective that
   conflicted with `ac`'s two writers (`WAc :: FieldWrite 'Settle`,
   `WAcTrade :: FieldWrite 'Trade`) is gone; the wording now matches the GADT exactly.

## Recorded, non-blocking

- The paragraph header "One writer per field." (line 302) still reads "One writer" while
  `ac` has two; the body's first sentence ("written only by settle and trade handlers")
  corrects it in place, so a reader self-corrects within the same paragraph. Header label
  only — does not block one-pass comprehension and is not cuttable-with-loss. Recorded for
  polish; I do not hold A off on it.

## Why A (91%) and not held at B, and not inflated higher

Round 4 reached A (90%) with two recorded cosmetic items. Both are now closed, with no
regression and no new expressibility defect: categorical names correct, every
prose-as-Haskell token type-correct, every concept faithfully realised in a total,
deterministic reference. That earns a single point over round 4. I do not push higher: the
C11 mapping remains the weakest in the document (authorship-only, erased at the row) — it is
honestly labelled, not structurally unrepresentable, and the prose says exactly that, which
is the most this mechanism can buy. Nothing in my domain is cryptic; nothing is cuttable
without loss; correctness is fully preserved. I stake my lens on A.
