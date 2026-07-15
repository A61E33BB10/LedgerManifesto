# Round 3 Scorecard — jane-street-cto

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
(+ embedded reference `/home/renaud/Ledger/addendum_rewrite/reference/StatesHome.hs`)

**Lens:** Readers over writers — clear in six months to someone new. For the Haskell:
correctness, simplicity, illegal states unrepresentable.

## Verdict: APPROVE — Grade A (91%)

This still clears my bar, and I re-stake my lens on it. The Round 1 blockers stayed fixed,
nothing regressed, and a fresh hand-check of the reference turned up no correctness defects.
A competent quant engineer who has not read the review rounds can follow this in one careful
pass: the "force each condition at the instrument that demands it, collect them in §5"
structure is good pedagogy; the notation table (§2) front-loads every symbol before use
(`0_P`, `StateDelta`, conserved/flat all defined before they appear); and the Haskell reference
is total, deterministic, and makes a large class of illegal states unreachable through abstract
types plus a GADT field-writer relation. The "unrepresentable" headline (§11) is precisely
qualified, not oversold.

GHC is not installed here, so I could not run `runghc StatesHome.hs`. I re-checked the module
by hand (export-list abstraction boundaries, GADT/existential syntax, `foldMap`/`foldM`/
`Map.foldrWithKey` shapes, the `Semigroup`/`Monoid` instances, `validate`'s conserved fold,
and the `amend` Breaking branch). No errors. CI should still execute it once before the
"total and deterministic" claim is relied on in production.

## Correctness re-verification (this round)

- **C2 gate is real.** `ValidDelta` is exported abstract (line 49, no `(..)`); `validate` is
  the only constructor. `net = foldMap (foldMap (\(SomeWrite w) -> conserved w)) (sdRows sd)`
  sums only the conserved fields (ac, balance); `conserved (WHwm _) = mempty`,
  `conserved (WEntryNav _) = mempty`. Empty fold = `mempty`, so C9 falls out with no special
  case. Correct.
- **Monotone carrier is real.** `Ledger` is abstract and its field accessors
  (`ledgerPT/US/PS`) are not exported; `applyDelta`'s `applyRow` does `Map.insert` over
  `findWithDefault zeroP`, insert/update only, no deleter anywhere. Correct.
- **PT<->US invariant by construction.** `register` (the only introducer) writes both maps;
  `applyDelta` guards `u `Map.member` ledgerPT` and otherwise only *replaces* US / *adjusts*
  PT for an already-registered unit; `amend` Breaking writes PT and US for the fresh id
  together and rejects an id collision (`UnitAlreadyExists`). The `ghostSD` example exhibits
  the guard (validates vacuously, then `applyDelta` rejects `UnknownUnit`, US never
  fabricated). Correct.
- **C8 two-track.** Preserving appends to the same unit; Breaking allocates a fresh unit,
  stamps `usSupersededBy`, never rewrites old terms. Correct.

## Round 1 blockers — confirmed still resolved

- **B1 (label order).** Signposted convention at the head of §4 (lines 213–216) plus the §5
  index. Labels are load-bearing cross-references (§7, §11 P→C map); renumber was correctly
  declined. Acceptable for A.
- **B2 (P1 "unrepresentable" overstated).** §11 intro (667–675) names three distinct
  mechanisms and states conservation is a value-level check (S4); the P1 gloss says so
  explicitly. Matches C2 and the reference.
- **B3 (two "handler" vocabularies).** C11 (305–316) states the field-writers and the C2
  event classes are different axes, names not meant to coincide.
- **B4 (C11 guarantee asserted not shown).** Body softened to S3: the guarantee binds at the
  writer's authorship site and is erased once writes share a delta row. Honest and consistent
  with the exported `SomeWrite` and the `_c11_ok_*` / commented `_c11_bad` evidence.

## What is done well

- Abstract-type discipline is enforcement, not decoration, and the export list (31–59) is the
  stated contract.
- Integer minor units over `Float`, flagged as the single deliberate deviation from the prior
  Python — the correct call for determinism and conservation.
- Conservation as a monoid homomorphism into `PosDelta` makes the zero-holder case (C9) free,
  with no `dividend / len(holders)` division-by-zero path.
- The EXPRESSIBILITY SIGNALS block (S1–S4) is candid about what the encoding does not do
  (cross-unit conservation, capability scoping, row-level C11). That candor carries the
  document's credibility.
- §8 Pareto arithmetic checks out: B=(9,9,8) strictly dominates A/C/D/F, weakly dominates E;
  unique Pareto-optimum under correctness gate ≥7. Framed as ordinal judgments with the scorer
  named.

## Non-blocking observations (unchanged from Round 2; keep off a 95+, do not block A)

- **C2 "structurally, by event class" (line 259)** sits in mild tension with S4's value-level
  framing. The rest of the sentence ("the proof obligation per class") and §11+S4 reconcile
  it. Optional: replace "structurally" with "by a per-class proof obligation."
- **P3 "the monotone carrier (C1(b)) makes replay a fold homomorphism" (683–688).** The
  Kleisli law `replay (xs <> ys) = replay xs >=> replay ys` holds for any `foldM` regardless
  of monotonicity; what the monotone carrier actually buys is a stable key set across cuts
  (the reference comment 368–375 states this precisely). The tex gloss slightly conflates the
  two; the substance (checkpoint-independence) is correct. Optional tightening.
- **`WEntryNav` write-once / `WHwm` qmax silently no-op** a second/lower write (reference
  218–219). Intended, but mild tension with a fail-loud posture; a one-line "second write
  intentionally ignored, not an error" comment would close it. Acceptable as-is.
- **Design E "no implementation in available tooling" (line 648)** is asserted; the structural
  reason is content-authority, outside my lens, and framed honestly. Noted, not blocking.

These are nuances that keep the document at the A floor rather than a high A. None blocks
understanding or compromises correctness. I re-stake my lens: A, 91%.
