# Round 2 Scorecard — jane-street-cto

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
(+ embedded reference `/home/renaud/Ledger/addendum_rewrite/reference/StatesHome.hs`)

**Lens:** Readers over writers — clear in six months to someone new. For the Haskell:
correctness, simplicity, illegal states unrepresentable.

## Verdict: APPROVE — Grade A (91%)

This clears my bar. A competent quant engineer who has not read the review rounds can follow
this in one careful pass: the "force each condition at the instrument that demands it, collect
them later" structure is sound pedagogy, the notation table is complete and front-loaded (no
symbol is used before it is defined — `0_P`, `StateDelta`, conserved/flat are all in §2), and
the Haskell reference is total, deterministic, and makes a large class of illegal states
unreachable through abstract types and a GADT field-writer relation. Correctness of claim is
preserved throughout, and the "unrepresentable" headline is now precisely qualified rather
than oversold.

I stake my lens on this grade.

Note: GHC is not installed in this environment, so I could not execute `runghc StatesHome.hs`.
I hand-checked the module again (kinds, GADT/existential syntax, `foldMap`/`foldM` shapes,
record updates, `Monoid`/`Semigroup` instances, the Kleisli-fold law for `replay`) and found
no errors. CI should still run it once before relying on the "it is total and deterministic"
claim.

## Round 1 blockers — all resolved

- **B1 (condition labels out of introduction order).** Resolved by signpost, not renumber.
  The orientation paragraph at the head of §4 (lines 205–209) declares C1–C12 as stable tags
  indexed in §5, states the first met is C2, and tells the reader to read them as tags, not a
  sequence. Renumbering was correctly declined: the labels are load-bearing cross-references
  from §11 (P→C mapping), §7, and the index. Since each condition is fully defined inline
  where introduced, the only residual lookup is back-references from §11, for which §5 is the
  exact table. Friction reduced to a signposted convention. Acceptable for A.
- **B2 (P1/conservation "unrepresentable" overstated).** Resolved. §11 intro (660–668) drops
  the blanket "cannot be expressed," names the three distinct mechanisms (smart-constructor
  unreachable-through-API for P1; `NonEmpty` untypable for P6; typed-at-authorship-then-erased
  for P10), and states conservation is explicitly a value-level check (S4). The P1 gloss
  (671–674) now says "The check is value-level (signal S4), not a type fact." Matches C2 and
  the reference.
- **B3 (two "handler" vocabularies collide).** Resolved. C11 (305–308) states the
  field-writers (settle, trade, transfer, fee_crystallise, subscribe) are a different axis
  from the C2 event classes (Trade, SettleVM, CorporateAction, QISRebalance, MandateAmend),
  one class driving one or more field-writers, names not meant to coincide.
- **B4 (C11 type-level guarantee asserted but never shown biting).** Resolved by softening to
  match S3, which I had explicitly offered as an acceptable fix. tex C11 (298–309) and the
  §reference bullet (793–797) now state the guarantee binds at the writer's authorship site
  and is erased once writes share a delta row — the honest claim, consistent with the exported
  `SomeWrite` and the `_c11_ok_*` / commented `_c11_bad` evidence.

## What is done well

- Abstract-type discipline is real enforcement, not decoration: no PS row deleter exported
  (monotone half of C1), `ValidDelta` has only `validate` as constructor (C2 cannot be
  bypassed at the API), `ProductTerms` has no setter (C6). The export list is the contract and
  the comments say so.
- `register` writes PT and US together and `applyDelta` guards on PT-membership, so
  "registered in PT iff registered in US" holds by construction; the `ghostSD` example
  exhibits it (validates vacuously, then `applyDelta` rejects with `UnknownUnit`, US never
  fabricated).
- Integer minor units over `Float` is the correct call and flagged as the single deliberate
  deviation from the prior Python.
- Conservation as a monoid homomorphism into `PosDelta` makes the zero-holder (C9) case fall
  out for free (empty fold = `mempty`), with no division-by-holder-count path to a bug.
- The §pareto dominance arithmetic checks out: B=(9,9,8) strictly dominates A/C/D/F and weakly
  dominates E; unique Pareto-optimum under correctness gate ≥7. The intro now names the scorer
  and frames the figures as ordinal judgments.
- The "EXPRESSIBILITY SIGNALS" block (S1–S4) is honest about what the encoding does not do
  (cross-unit conservation, capability scoping, row-level C11). That candor carries the
  document's credibility.

## Non-blocking observations (do not block A; fix only if cheap)

- **C2 wording "structurally, by event class" (line 250)** sits in mild tension with S4's
  "value-level check." The rest of the sentence ("the proof obligation per class") clarifies
  that "structurally" means the per-class proof method, not type enforcement, and §11 + S4
  reconcile it. A maximally careful reader notices the momentary friction. Optional: replace
  "structurally" with "by a per-class proof obligation."
- **P3 phrasing "the monotone carrier (C1(b)) makes replay a Kleisli fold" (675–677).** The
  `foldM`/Kleisli-fold law holds for any `foldM` regardless of monotonicity; what the monotone
  carrier actually buys is checkpoint-independence of the key set and conservation pass (so
  deletion-then-recreation across a checkpoint cut cannot perturb results). The substance is
  correct and the reference comment (368–375) states it precisely; the tex sentence slightly
  conflates the two. Optional tightening.
- **`WEntryNav` write-once / `WHwm` qmax silently no-op** a second/lower write (reference
  218–219). Intended, but sits in mild tension with a fail-loud posture. A one-line comment
  "second write intentionally ignored, not an error" would close it. Acceptable as-is.
- **Design E "no implementation in available tooling" (line 642)** is asserted; the structural
  reason is unestablished (flagged in the iteration log as a CONSULT gap for
  correctness-architect). Outside my lens (content authority, not reader clarity), and framed
  honestly. Noted, not blocking.

These are nuances that keep the document off a 95+, not defects that block understanding or
compromise correctness.
