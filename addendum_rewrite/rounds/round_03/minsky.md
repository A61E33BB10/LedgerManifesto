# MINSKY scorecard — StatesHome rewrite, Round 3

Lens: the Haskell reference as the load-bearing artefact — total functions,
exhaustive cases, types as theorems, no representable illegal state. The prose is
judged by whether the types it claims actually deliver the theorems it asserts.
Read this round as a fresh competent quant engineer who has NOT seen the prior
rounds.

## Grade: A (92%)

No GHC/cabal/runghc in the environment, so `reference/StatesHome.hs` was
type-checked by hand again. It is clean on every axis of my lens, the Round-1
blockers remain discharged, one of the two Round-2 cosmetic nits is now fixed,
and no regression was introduced. I stake my lens on the following.

### Totality — full marks
Every exported library function is total. `currentTerms` is total via `NonEmpty`
(no `Maybe`); `validate` / `applyDelta` / `replay` / `amend` / `register` return
`Either`; `productTerms` / `unitStatus` / `position` return `Maybe`. The only
partial code is the `expect*` demo glue (lines 493–494), correctly fenced and
labelled as the file's sole partiality.

### Exhaustiveness — full marks
No wildcards in the library. `applyWrite` (215–219) and `conserved` (252–256)
each cover all five `FieldWrite` constructors. `amend` (419–434) covers
`Maybe` (lookup) × `Fungibility` × the Breaking fresh-id collision guard, with
`otherwise` closing the guard set — exhaustive, no catch-all. `validate`,
`register`, `applyDelta` use complete `| cond / | otherwise` guard pairs. Adding
a constructor breaks the build, which is the point.

### Illegal states — sound
`Ledger`, `ValidDelta`, `ProductTerms` are exported abstract with no
setter/deleter, so the monotone carrier (C1b), append-only terms (C6), and
"an unconserved delta cannot reach `applyDelta`" (C2) hold by absence. `register`
is the sole unit introducer and writes PT and US together; `applyDelta` rejects
an unregistered `sdUnit` (`UnknownUnit`); `amend` Breaking writes PT+US for the
fresh id and guards id collision — so "registered in PT ⇔ registered in US"
holds by construction, as the prose claims (§13). The one representable illegal
class — out-of-order lifecycle transitions on the flat `Lifecycle` enum with
unconditional `Map.insert` — is honestly disclosed (§10: "enforced by these
tests, not by types — distinct from P5, whose idempotency is structural"), not
claimed away. P5 in §9 is correctly scoped to per-key idempotency only.

### Types-as-theorems claims verified
- P1 / S4: conservation is a value-level smart-constructor check; the §9 intro
  and the P1 gloss state "unrepresentable" in the precise "unchecked delta cannot
  reach `applyDelta`" sense. Stated theorem = shipped proof.
- P3: `replay (xs <> ys) = replay xs >=> replay ys`. This holds for `foldM` over
  list concatenation (Kleisli composition in `Either LedgerError`). The Round-2
  "(anti)homomorphism" wart is fixed — line 369 now reads "Kleisli homomorphism
  law." Correct.
- C2 monoid construction: `validate` folds `conserved` into `PosDelta` and
  demands `mempty`; the empty fold gives the vacuous/zero-holder base case (C9)
  for free, no special case. Both `dAc` and `dBalance` must net to zero, i.e.
  each conserved field independently — correct reading of per-field conservation.
- C3 / S1: single-unit `StateDelta`; multi-unit atomic events are one
  `ValidDelta` per unit applied together as a fold. Prose (C3 + the paragraph
  after it + S1) no longer lets the `ac`-only example read as a complete
  two-unit trade. Correct.
- C11 / S3: the `FieldWrite h` GADT is the field→writer relation; the index is
  erased at `SomeWrite`, so the guarantee binds at authorship, not at the stored
  row. Prose carries the S3 caveat. Honest.

The S1–S4 expressibility signals remain exemplary intellectual honesty: they name
what the encoding does not prove (cross-unit conservation, capability scoping,
row-level field canon, value-level conservation) and point at the correct layer.
They should stay verbatim.

## Non-blocking observations (do NOT gate the A)

- **"Unique field-writer" vs two writers for `ac` (tex 306, 699).** C11's body
  says "the unique field-writer permitted to mutate it: ac→settle/trade …" and
  P10 repeats "the unique field-writer per field," yet the shipped type gives
  `ac` two authorised writers (`WAc :: FieldWrite 'Settle`,
  `WAcTrade :: FieldWrite 'Trade`). The condition *title* ("per-field **canonical**
  writer") and the notation table (tex 125, "a canonical writer") are already
  correct; the body's word "unique" is the lone slip. It self-resolves inside the
  same sentence — the enumeration immediately exhibits two writers for `ac` and
  the code confirms a legitimate two-element writer-set — so a careful reader is
  not derailed. Recommended one-word fix: "unique field-writer" → "canonical
  field-writer (one writer-set)" at both sites, to make the stated theorem match
  the type exactly. Flagged, not gating.
- **Demo-comment Show forms (StatesHome.hs ~511, 526, 511).** The `main`
  comments abbreviate derived record `Show` output (`PosDelta 1000 0` rather than
  `PosDelta {dAc = 1000, dBalance = 0}`; same for `UnitStatus`). Illustrative
  comments in fenced demo glue; not load-bearing.
- **P5 gloss "single (w,u)-keyed row" (tex 689)** still reads slightly off for the
  `lifecycle_stage` datum, which lives in the u-keyed `UnitStatus`; the claim
  (single home + overwrite dedup) holds regardless. Cosmetic, unchanged from R2.

## Verdict
Totality and exhaustiveness are at full marks; the abstract-type disciplines,
`NonEmpty` terms, empty-fold C9 base case, PT⇔US-by-construction, two-track
`amend`, and the homomorphism/replay law are all correctly typed and faithfully
mirror their conditions. Every theorem the prose states is either delivered by
the types or honestly downgraded to a disclosed value-level check. The one
residual word-choice imprecision is sub-blocking. This round clears my bar.
