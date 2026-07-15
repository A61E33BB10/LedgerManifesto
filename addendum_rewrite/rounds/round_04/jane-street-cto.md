# Round 4 Scorecard — jane-street-cto

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
(+ embedded reference `/home/renaud/Ledger/addendum_rewrite/reference/StatesHome.hs`)

**Lens:** Readers over writers — clear in six months to someone new. For the Haskell:
correctness, simplicity, illegal states unrepresentable.

## Verdict: APPROVE — Grade A (91%)

The document clears my bar and I re-stake my lens on it. Comparing against my Round 3
review line-by-line, the text is materially unchanged and nothing regressed. A competent
quant engineer who has not read the review rounds can follow this in one careful pass:
§4 forces each condition at the instrument that demands it, §5 collects them, §2 front-loads
every symbol before use, and the Haskell reference is total, deterministic, and makes a large
class of illegal states unreachable via abstract types plus a GADT field-writer relation. The
"unrepresentable" headline (§11) is precisely qualified (S4: conservation is a value-level
check), not oversold.

GHC is not installed in this environment, so I could not execute `runghc StatesHome.hs`. I
re-checked the module by hand. CI must run it once before the "total and deterministic" claim
is relied on in production.

## Correctness re-verification (this round)

- **C2 gate.** `ValidDelta` exported abstract (line 49, no `(..)`); `validate` is the sole
  constructor. `net = foldMap (foldMap (\(SomeWrite w) -> conserved w)) (sdRows sd)` folds only
  conserved fields; `conserved (WHwm _) = mempty`, `conserved (WEntryNav _) = mempty`. Empty
  fold = `mempty`, so C9 (zero-holder) falls out with no special case. Correct.
- **Monotone carrier.** `Ledger` abstract, field accessors unexported; `applyRow` does
  `Map.insert` over `findWithDefault zeroP`, insert/update only; no deleter anywhere. Correct.
- **PT↔US invariant by construction.** `register` (sole introducer) writes both maps;
  `applyDelta` guards `u `Map.member` ledgerPT` and otherwise only replaces US / adjusts PT for
  an already-registered unit; `amend` Breaking writes PT+US for the fresh id and rejects
  collision (`UnitAlreadyExists`). The `ghostSD` example exhibits the guard. Correct.
- **C8 two-track.** Preserving appends to same unit; Breaking allocates fresh unit, stamps
  `usSupersededBy`, never rewrites old terms. Correct.
- **P3 replay law.** `replay ds l0 = foldM (\l d -> applyDelta d l) l0 ds`; the Kleisli
  homomorphism `replay (xs <> ys) = replay xs >=> replay ys` holds in the `Either LedgerError`
  Kleisli category. Verified by the foldM split. Correct.

## Round 1 blockers — confirmed still resolved

- **B1 (label order):** signposted at head of §4 (213–216) + §5 index. Load-bearing
  cross-references; renumber correctly declined.
- **B2 (P1 "unrepresentable" overstated):** §11 intro (667–675) names three mechanisms and
  states conservation is value-level (S4). Matches C2 and the reference.
- **B3 (two "handler" vocabularies):** C11 (305–316) states field-writers vs C2 event classes
  are different axes, names not meant to coincide.
- **B4 (C11 asserted not shown):** softened to S3 — guarantee binds at authorship, erased once
  writes share a delta row. Consistent with exported `SomeWrite` and `_c11_ok_*` /
  commented `_c11_bad`.

## What is done well

- Abstract-type discipline is enforcement, not decoration; the export list (31–59) is the
  stated contract.
- Integer minor units over `Float`, flagged as the single deliberate deviation — correct call
  for determinism and conservation.
- Conservation as a monoid homomorphism into `PosDelta` makes C9 free with no
  `dividend / len(holders)` division-by-zero path.
- EXPRESSIBILITY SIGNALS S1–S4 are candid about what the encoding does not do (cross-unit
  conservation, capability scoping, row-level C11). That candor carries the credibility.

## Non-blocking observations (carried from prior rounds; keep off a 95+, do not block A)

- **C2 "structurally, by event class" (lines 261–262)** sits in mild tension with S4's
  value-level framing; reconciled by "the proof obligation per class" and §11+S4. Optional:
  "by a per-class proof obligation."
- **P3 gloss (683–688)** says the monotone carrier "makes replay a fold homomorphism." The
  Kleisli law holds for any `foldM` regardless of monotonicity; what the monotone carrier
  actually buys is a stable key set across cuts (reference comment 368–375 states this
  precisely). Substance (checkpoint-independence) is correct; the tex slightly conflates the
  two. Optional tightening.
- **`WEntryNav` write-once / `WHwm` qmax silently no-op** a second/lower write (reference
  218–219). Intended; mild tension with fail-loud posture. A one-line "second write
  intentionally ignored, not an error" comment would close it.
- **`balance` demonstrative field (§2 122–127, §3 203–205)** is purely there to exercise the
  C11 per-field-writer discipline with a distinct writer. Defensible and explained twice, but
  the most cuttable element in the document; the only thing standing between this and a higher A.
- **Design E "no implementation in available tooling" (line 648)** is asserted; the structural
  reason is content-authority, outside my lens, framed honestly.

These are nuances that hold the document at the A floor rather than a high A. None blocks
understanding or compromises correctness. I re-stake my lens: A, 91%.
