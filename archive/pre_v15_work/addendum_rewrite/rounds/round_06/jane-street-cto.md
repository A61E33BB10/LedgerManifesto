# Round 6 Scorecard — jane-street-cto

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
(+ embedded reference `/home/renaud/Ledger/addendum_rewrite/reference/StatesHome.hs`)

**Lens:** Readers over writers — clear in six months to someone new. For the Haskell:
correctness, simplicity, illegal states unrepresentable.

## Verdict: APPROVE — Grade A (91%)

The document clears my bar and I re-stake my lens on it. A competent quant engineer who has
not read the 27 review rounds can follow this in one careful pass:

- §1 poses the one question; §1 names the four instruments that constrain it.
- §2 (Notation) front-loads every symbol before first use, including the `Map`/`Option`/
  `NonEmptyList` vocabulary and the conserved-vs-non-conserved field distinction.
- §4 forces each condition at the instrument that demands it and states it once; §5 collects
  C1–C12 with a stable index pointing back to where each is established.
- §6 (why exactly three maps) gives the three independent forcing constraints; §9 disposes of
  the alternatives by a single forcing reason each, not by the ordinal table.
- §11 (invariants made unrepresentable) is precisely qualified — "unrepresentable" is the
  abstract-type / NonEmpty / GADT-tag mechanism, and conservation is explicitly called a
  value-level check (S4), not oversold.
- §13 embeds a Haskell reference that is total, deterministic, and makes a large class of
  illegal states unreachable through abstract types plus a GADT field-writer relation.

Nothing in my domain is cryptic. Correctness is preserved end-to-end. The cuts since the
Python original (Integer minor units over Float; the four EXPRESSIBILITY SIGNALS that name
what the encoding does *not* do) strengthen rather than weaken the claims.

GHC is not installed here (`which ghc runghc ghci stack cabal` → empty), so I could not
execute `runghc StatesHome.hs`. I re-checked the module by hand this round. CI must run it
once before "total and deterministic" is relied on in production — a standing release gate,
not a spec blocker.

## Correctness re-verification (fresh pass this round)

- **C2 gate.** `ValidDelta` exported abstract (export list, no `(..)`); `validate` is the
  sole constructor. `net = foldMap (foldMap (\(SomeWrite w) -> conserved w)) (sdRows sd)`
  folds only conserved-field contributions; `conserved (WHwm _) = mempty`,
  `conserved (WEntryNav _) = mempty`. Empty fold = `mempty`, so C9 (zero-holder) falls out
  with no special case. Correct.
- **Monotone carrier (C1b).** `Ledger` abstract, field accessors unexported; `applyRow` does
  `Map.insert` over `findWithDefault zeroP` — insert/update only; no deleter exists anywhere.
  Correct.
- **Option accessor (C1a).** `position :: Ledger -> WalletId -> UnitId -> Maybe PositionState`;
  `Nothing` (never held) and `Just zeroP` (held-and-flat) distinct. `zeroP` carries the
  retained non-conserved fields. Correct.
- **PT↔US invariant by construction.** `register` (sole introducer) writes both maps;
  `applyDelta` guards `u `Map.member` ledgerPT` and otherwise only replaces US / `Map.adjust`s
  PT for an already-registered unit; `amend` Breaking writes PT+US for the fresh id and
  rejects collision (`UnitAlreadyExists`). The `ghostSD` example validates vacuously then is
  rejected at apply with `UnknownUnit`, so US is never fabricated for an unregistered unit.
  Correct.
- **C8 two-track.** Preserving appends to the same unit; Breaking allocates a fresh unit,
  stamps `usSupersededBy`, never rewrites the old terms. Correct.
- **C11 field-writer GADT.** `FieldWrite (h :: Handler)` constructors are the field→writer
  table; `_c11_ok_*` typecheck, commented `_c11_bad` does not; index erased through
  `SomeWrite` (S3, authorship-site guarantee). Correct and honestly bounded.
- **P3 replay law.** `replay ds l0 = foldM (\l d -> applyDelta d l) l0 ds`; the Kleisli
  homomorphism `replay (xs <> ys) = replay xs >=> replay ys` holds in the
  `Either LedgerError` Kleisli category; monotone carrier keeps the key set stable across
  cuts. Correct.

## What is done well

- Abstract-type discipline is enforcement, not decoration; the export list (reference lines
  31–59) is the stated contract.
- Conservation as a monoid homomorphism into `PosDelta` makes the vacuous C9 case free and
  excludes the `dividend / len(holders)` division-by-zero bug class structurally.
- EXPRESSIBILITY SIGNALS S1–S4 are candid about the encoding's boundaries (cross-unit
  conservation via paired issuance; capability scoping at the boundary layer; row-level C11
  erasure; value-level conservation check). That candor carries the credibility.

## Non-blocking observations (carried from Round 5; hold at the A floor, do not block)

- **`balance` demonstrative field** (§2 lines 122–127, §3 lines 203–205, reference). Present
  only to exercise C11's per-field-writer discipline with a conserved-field writer (Transfer)
  distinct from `ac` (Settle/Trade). Defensible — without it C11 demonstrates a single
  conserved-field writer — and explained twice. It remains the single most cuttable element
  and the main thing between this and a high A under the strict "nothing cuttable" reading.
- **C2 "structurally, by event class" (tex lines 261–262)** sits in mild tension with S4's
  value-level framing; reconciled by "the proof obligation per class" plus §11 + S4. A reader
  must hold both phrasings together for one beat.
- **`WEntryNav` write-once / `WHwm` qmax silently no-op** a second/lower write (reference
  lines 218–219). Intended; mild tension with the fail-loud posture. A one-line "second write
  intentionally ignored, not an error" comment would close it.
- **§4 navigational note (lines 213–218)** ("the first met below is C2") is honest signposting
  but dense; costs the new reader a brief re-read. Substance correct.

None of these blocks understanding or compromises correctness, and nothing changed this round
to move the number. I re-stake my lens: **A, 91%.**
