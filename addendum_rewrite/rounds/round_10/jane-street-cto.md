# Round 10 Scorecard — jane-street-cto

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
(+ embedded reference `/home/renaud/Ledger/addendum_rewrite/reference/StatesHome.hs`)

**Lens:** Readers over writers — clear in six months to someone new. For the Haskell:
correctness, simplicity, illegal states unrepresentable.

## Verdict: APPROVE — Grade A (91%)

The tex was touched since my Round 9 sign-off (tex mtime 02:15 vs my card 02:12); the
reference is unchanged (hs mtime 02:09). I re-read both fresh and re-verified the correctness
chain by hand rather than carry the grade forward on trust. No regression. The document still
clears my bar and I re-stake my lens; the residual friction is unchanged, so the number holds
at 91%.

A competent quant engineer who has not read the 27 review rounds can follow it in one careful
pass:

- §1 poses the single question and names the four constraining instruments.
- §2 front-loads every symbol before first use (`Map`/`Option`/`NonEmptyList`, the
  conserved-vs-non-conserved field split, `0_P`).
- §4 forces each condition at the instrument that demands it, states it once; §5 indexes
  C1–C12 back to where each is established.
- §6 gives the three independent forcing constraints; §9 disposes of each rejected
  alternative by one forcing reason, the ordinal table honestly flagged as ordinal.
- §11 qualifies "unrepresentable" precisely and calls conservation a value-level check (S4) —
  not oversold (7 of 10: P1,P3,P5,P6,P7,P9,P10).
- §13 embeds a total, deterministic Haskell reference making a large illegal-state class
  unreachable via abstract types plus a GADT field-writer relation.

Nothing in my domain is cryptic. Correctness is preserved end to end.

## Correctness re-verification (fresh pass)

- **C2 gate.** `ValidDelta` exported abstract; `validate` is the sole constructor.
  `net = foldMap (foldMap (\(SomeWrite w) -> conserved w)) (sdRows sd)` folds only
  conserved-field contributions; `conserved (WHwm _) = mempty`, `conserved (WEntryNav _) =
  mempty`. Empty fold = `mempty`, so C9 (zero-holder) falls out with no special case.
- **Monotone carrier (C1b).** `Ledger` abstract, no row deleter exported; `applyRow` does
  `Map.insert` over `findWithDefault zeroP` — insert/update only.
- **Option accessor (C1a).** `position :: ... -> Maybe PositionState`; `Nothing` (never held)
  and `Just zeroP` (held-and-flat) distinct; `zeroP` retains non-conserved fields.
- **PT↔US invariant by construction.** `register` (sole introducer) writes both maps;
  `applyDelta` guards `u ∈ ledgerPT` else `UnknownUnit`; `amend` Breaking writes PT+US for the
  fresh id and rejects collision (`UnitAlreadyExists`). `ghostSD` validates vacuously then is
  rejected at apply with `UnknownUnit`; US is never fabricated for an unregistered unit
  (confirmed in `main`'s ghost case).
- **C8 two-track.** Preserving appends to the same unit; Breaking allocates a fresh unit,
  stamps `usSupersededBy`, never rewrites old terms.
- **C11 field-writer GADT.** `FieldWrite (h :: Handler)` constructors are the field→writer
  table; `_c11_ok_settle`/`_c11_ok_fee` typecheck, commented `_c11_bad` does not; index erased
  through `SomeWrite` (S3, authorship-site guarantee). `main` builds `tradeSD`/`closeSD` as
  `erase . settleHandler`, so the authorship→erasure pipeline runs on the live path. Honestly
  bounded.
- **P3 replay law.** `replay ds l0 = foldM (\l d -> applyDelta d l) l0 ds`; Kleisli
  homomorphism `replay (xs <> ys) = replay xs >=> replay ys` in `Either LedgerError`; monotone
  carrier keeps the key set stable across cuts.

GHC is not installed here (`which ghc runghc ghci` → empty), so I could not execute the module;
I re-checked by hand. CI must run `runghc StatesHome.hs` once before "total and deterministic"
is relied on in production — a standing release gate, not a spec blocker.

## Non-blocking observations (carried; hold at the A floor, do not block)

- **`balance` demonstrative field** (§2 L122–127, §3 L203–205, reference `psBalance` /
  `WBalance`). The single most cuttable element and the one thing keeping this at the A floor
  rather than above it under the strict "nothing cuttable without loss" reading. By the
  author's own framing it carries no economic datum and exists only to give C11 a second
  *conserved*-field writer (Transfer) distinct from `ac` (Settle/Trade). Note `hwm`/`entryNav`
  already exercise distinct writers on *non*-conserved fields, so what `balance` uniquely adds
  is a second *conserved*-field writer. Also note Transfer is never exercised on `main`'s live
  path (no `_c11_ok_transfer` witness; the guarantee rests on the `WBalance` constructor
  existing) — fine, since the GADT constructor *is* the relation. Defensible and explained
  twice; I accept the author's call. This is what keeps the grade at the bar, not above it.
- **`is_fungibility_preserving` argument naming** (§4 L507 types the second argument
  `\mathit{TermsAmendment}`; reference L426 `FungibilityPredicate = ProductTerms -> TermsVersion
  -> Fungibility`, and the reference comment, and surrounding tex L497/L518, all say
  `TermsVersion`). A reader cross-referencing tex to code meets two names for one argument.
  Cosmetic — the amendment is a new terms version — and a one-token edit (`TermsAmendment` →
  `TermsVersion` at L507) closes it. Flagged in Rounds 8 and 9; still present. Not a
  correctness gap and not cryptic, so non-blocking, but trivially fixable and overdue.
- **`WEntryNav` write-once / `WHwm` qmax silently no-op** a second/lower write (reference
  L222–223). Intended; mild tension with fail-loud. A one-line "second write intentionally
  ignored, not an error" comment would close it.
- **C2 "structurally, by event class" (§4 L261–262)** vs S4's value-level framing: reader must
  hold both phrasings for one beat; reconciled by §11 + S4.

None of these blocks understanding or compromises correctness. I re-stake my lens: **A, 91%.**
