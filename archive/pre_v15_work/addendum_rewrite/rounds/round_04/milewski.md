# Round 4 — MILEWSKI (Expressibility lens)

**Grade: A (90%)** — staked on my lens. The one hard expressibility blocker from
round 3 is resolved; what remains are two cosmetic items that do not block a careful
reader's one-pass understanding.

## Verdict

Every concept in the addendum maps cleanly and faithfully to the Haskell reference.
The categorical claims in my exact domain are correct and genuinely earned by the code:

- **Conservation (C2) as a group homomorphism** `Map WalletId [SomeWrite] -> PosDelta`,
  "conserving" = image is `mempty`. The vacuous zero-holder case (C9) falls out of the
  empty `foldMap` with no special case, and the prose (lines 254–266, 482–487) names the
  structure last, not first. Faithful to `validate` / `conserved` in the reference.
- **Replay as a Kleisli fold homomorphism** (P3, lines 683–688): the law
  `replay (xs <> ys) = replay xs >=> replay ys` in the `Either LedgerError` Kleisli
  category is correctly stated as a *homomorphism* (not antihomomorphism), and is
  genuinely satisfied by `foldM applyDelta`. The `>=>` gloss for the reader is accurate.
- **C1 two halves** (Option accessor / monotone carrier) map exactly to `Maybe` +
  no-deleter-exported. The never-held vs held-and-flat distinction (`Nothing` vs
  `Just zeroP`) is load-bearing and stated as such.
- **ProductTerms = `NonEmpty TermsVersion`** makes "registered but versionless" untypable
  (C6/C7); abstract type, only growers `register`/`appendVersion`. Faithful.
- **C11 prose is honest about what the encoding delivers**: "type error at authorship,
  erased once writes share a delta row (S3)" — it does not over-claim structural
  unrepresentability the way P1/P6 legitimately can. This was the recurring round-1/2
  over-claim pattern and it stays fixed.

## Resolved since round 3

- **`++` type error (round-3 sole blocker) — FIXED.** Migration line 611 previously
  aliased `get_unit_state(u)` to `product_terms(u) ++ unit_status(u)`, which is Haskell
  list concatenation applied to `Maybe ProductTerms` / `Maybe UnitStatus` — type-incorrect
  in a Haskell-anchored document. It now reads "a deprecated alias for the **pair**
  `(product_terms(u), unit_status(u))`." Correct and unambiguous.

## Remaining (non-blocking, recorded for polish)

1. **`position_state(w,u)` phantom identifier — line 612.** The migration sentence maps
   v10.3's `get_unit_state(w,u)` to `position_state(w,u)`. The reference exports the
   accessor as `position` (StatesHome.hs:387), and every other occurrence in the tex uses
   `position(w,u)` (lines 285, 462). `position_state` appears exactly once and matches
   neither the export nor the doc's own convention. A reader infers it is the position
   accessor within the same sentence, so it does not block comprehension — but the token
   should read `position(w,u)`. Trivial fix; recommended for the next pass.

2. **"unique / one canonical field-writer" wording vs `ac`'s two writers.** C11 (lines
   306, 551, 699) says each field has "the unique field-writer" / "one canonical
   field-writer," yet the same condition immediately lists `ac -> settle/trade` (two
   writers; `WAc :: FieldWrite 'Settle` and `WAcTrade :: FieldWrite 'Trade` in the
   reference). What C11 actually delivers is "only the declared *set* of writers per field;
   any undeclared writer is a type error at authorship." The over-claim is transparent —
   the counter-example sits in the same sentence, so the reader self-corrects — but "unique
   / one canonical" is loose for the central mechanism. Prefer "declared writer(s)" or
   "closed writer set." Non-blocking because it does not mislead in context.

## Why A and not held at B

The round-3 grade (B 89%) rested on a single genuine type error in prose-as-Haskell. That
defect is gone. The two remaining items are a one-token naming inconsistency and one loose
adjective — neither makes anything cryptic, neither breaks correctness, neither is
cuttable-with-loss. A competent quant engineer who has not read the review history maps
every concept to the Haskell in one careful pass. That meets the A bar. I record the two
nits so they can be closed, but I do not hold A off on them.
