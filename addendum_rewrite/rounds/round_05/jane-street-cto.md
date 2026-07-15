# Round 5 Scorecard — jane-street-cto

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
(+ embedded reference `/home/renaud/Ledger/addendum_rewrite/reference/StatesHome.hs`)

**Lens:** Readers over writers — clear in six months to someone new. For the Haskell:
correctness, simplicity, illegal states unrepresentable.

## Verdict: APPROVE — Grade A (91%)

The document clears my bar and I re-stake my lens on it. Against my Round 4 line-by-line
review, both the tex and the reference are materially unchanged — nothing regressed and no
new defect appeared. A competent quant engineer who has not read the review rounds can
follow this in one careful pass: §4 forces each condition at the instrument that demands it,
§5 collects them with a stable index, §2 front-loads every symbol before use, and the
Haskell reference is total, deterministic, and makes a large class of illegal states
unreachable via abstract types plus a GADT field-writer relation. The "unrepresentable"
headline (§11) is precisely qualified (S4: conservation is a value-level check), not
oversold.

GHC is not installed in this environment (`which ghc runghc ghci stack cabal` → empty), so I
could not execute `runghc StatesHome.hs`. I re-checked the module by hand. CI must run it
once before the "total and deterministic" claim is relied on in production — this is a
standing release gate, not a blocker on the spec.

## Correctness re-verification (this round, fresh pass)

- **C2 gate.** `ValidDelta` exported abstract (export list, no `(..)`); `validate` is the
  sole constructor. `net = foldMap (foldMap (\(SomeWrite w) -> conserved w)) (sdRows sd)`
  folds only conserved fields; `conserved (WHwm _) = mempty`, `conserved (WEntryNav _) =
  mempty`. Empty fold = `mempty`, so C9 (zero-holder) falls out with no special case.
  Correct.
- **Monotone carrier.** `Ledger` abstract, field accessors unexported; `applyRow` does
  `Map.insert` over `findWithDefault zeroP` — insert/update only; no deleter exists. Correct.
- **PT↔US invariant by construction.** `register` (sole introducer) writes both maps;
  `applyDelta` guards `u `Map.member` ledgerPT` and otherwise only replaces US / `Map.adjust`s
  PT for an already-registered unit; `amend` Breaking writes PT+US for the fresh id and
  rejects collision (`UnitAlreadyExists`). `ghostSD` validates vacuously then is rejected at
  apply with `UnknownUnit`, so US is never fabricated for an unregistered unit. Correct.
- **C8 two-track.** Preserving appends to same unit; Breaking allocates fresh unit, stamps
  `usSupersededBy`, never rewrites old terms. Correct.
- **P3 replay law.** `replay ds l0 = foldM (\l d -> applyDelta d l) l0 ds`; the Kleisli
  homomorphism `replay (xs <> ys) = replay xs >=> replay ys` holds in the
  `Either LedgerError` Kleisli category; monotone carrier keeps the key set stable across
  cuts. Correct.

## Round 1 blockers — confirmed still resolved

- **B1 (label order):** signposted at head of §4 (lines 213–218) + §5 index. Load-bearing
  cross-references; renumber correctly declined.
- **B2 (P1 "unrepresentable" overstated):** §11 intro (lines 670–678) names the mechanisms
  and states conservation is value-level (S4). Matches C2 and the reference.
- **B3 (two "handler" vocabularies):** C11 (lines 307–319) states field-writers vs C2 event
  classes are different axes, names not meant to coincide.
- **B4 (C11 asserted not shown):** softened to S3 — guarantee binds at authorship, erased
  once writes share a delta row. Consistent with exported `SomeWrite` and `_c11_ok_*` /
  commented `_c11_bad`.

## What is done well

- Abstract-type discipline is enforcement, not decoration; the export list (lines 31–59) is
  the stated contract.
- Integer minor units over `Float`, flagged as the single deliberate deviation — correct
  call for determinism and conservation.
- Conservation as a monoid homomorphism into `PosDelta` makes C9 free, with no
  `dividend / len(holders)` division-by-zero path.
- EXPRESSIBILITY SIGNALS S1–S4 are candid about what the encoding does not do (cross-unit
  conservation, capability scoping, row-level C11, value-level check). That candor carries
  the credibility.

## Non-blocking observations (carried; hold it at the A floor, do not block A, do not raise)

- **C2 "structurally, by event class" (tex lines 261–262)** sits in mild tension with S4's
  value-level framing; reconciled by "the proof obligation per class" and §11+S4. A reader
  must hold both phrasings in mind. Optional: "by a per-class proof obligation."
- **`balance` demonstrative field (§2 lines 122–127, §3 lines 203–205).** Present only to
  exercise the C11 per-field-writer discipline with a writer distinct from `ac`. Defensible
  (without it, C11 demonstrates a single conserved-field writer) and explained twice, but it
  is the most cuttable element in the document and the main thing standing between this and a
  high A under the strict "nothing cuttable without loss" reading.
- **`WEntryNav` write-once / `WHwm` qmax silently no-op** a second/lower write (reference
  lines 218–219). Intended; mild tension with the fail-loud posture. A one-line "second
  write intentionally ignored, not an error" comment would close it.
- **§4 navigational note (lines 213–218)** ("the first condition met below is C2 and a
  number met here may exceed one met later") is honest signposting but dense; it costs the
  new reader a re-read. Substance correct.

These are nuances that hold the document at the A floor rather than a high A. None blocks
understanding or compromises correctness, and nothing changed this round to move the number
either way. I re-stake my lens: A, 91%.
