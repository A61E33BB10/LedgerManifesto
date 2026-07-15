# MINSKY scorecard — StatesHome rewrite, Round 2

Lens: the Haskell reference as the load-bearing artefact — total functions,
exhaustive cases, types as theorems, no representable illegal state. The prose is
judged by whether the types it claims actually deliver the theorems it asserts.

## Grade: A (91%)

No GHC/cabal in the environment, so `StatesHome.hs` was type-checked by hand. It
is clean on every axis of my lens, and — decisively for this round — the three
blocking issues I raised in Round 1 are resolved at the level they operate, not
papered over. I stake my lens on the following:

- **Totality.** Every exported library function is total. `currentTerms` is total
  via `NonEmpty` (no `Maybe`); `validate`/`applyDelta`/`replay`/`amend` return
  `Either`; accessors return `Maybe`. The only partial code is the `expect*` demo
  glue, correctly fenced and labelled as such (lines 488–494).
- **Exhaustiveness.** No wildcards in the library. `applyWrite` and `conserved`
  each cover all five `FieldWrite` constructors; `amend` covers `Maybe` ×
  `Fungibility` explicitly. Refactors that add a constructor will break the build,
  which is the point.
- **Illegal states.** `Ledger`, `ValidDelta`, `ProductTerms` are exported abstract
  with no setter/deleter, so the monotone carrier (C1b), append-only terms (C6),
  and "an unconserved delta cannot reach `applyDelta`" (C2) hold by absence. The
  PT⇔US-by-construction argument in `register`/`applyDelta` is sound: `register`
  is the sole introducer and writes both maps; `applyDelta` rejects an
  unregistered `sdUnit`; `amend` Breaking writes both for the fresh id. The one
  class of state that *is* representable — illegal lifecycle transitions — is now
  honestly disclosed (see below), not claimed away.

### Round-1 blockers, all discharged

1. **C11 "type error" overstatement.** C11 now reads "a type error at the writer's
   authorship site; the tag is erased once writes share one delta row, so the
   guarantee binds at authorship, not at the stored row (§reference, signal S3)."
   This matches exactly what `FieldWrite h` + `SomeWrite` deliver. The stated
   theorem now equals the shipped proof.

2. **Lifecycle ordering vs P5.** The contradiction (P5 "unrepresentable" yet
   priced at a 70–80% mutation score) is gone. P5's gloss is now scoped strictly
   to idempotency ("a per-key dedup, not cross-map coordination"); §11 states
   plainly that transition ordering "is enforced by these tests, not by types —
   distinct from P5, whose idempotency is structural." The flat `Lifecycle` enum
   with unconditional `Map.insert` is therefore consistent with the prose: illegal
   transitions are representable and are owned by tests, openly.

3. **Single-unit StateDelta vs multi-unit trade.** C3 is now followed by the
   explicit composition rule: "An event touching several units … is one validated
   `StateDelta` per unit; per-unit conservation composes to event-level
   conservation, and the group applies all-or-nothing as a single fold (S1)." The
   future-against-cash case is named in §4.1. A reader can no longer mistake the
   `ac`-only example for a complete two-unit trade.

### Pooled type-claim blockers, also discharged

- P1 "unrepresentable" is qualified by the §9 intro and the P1 gloss to a
  value-level smart-constructor check (S4) — the precise "unchecked delta cannot
  reach `applyDelta`" framing (parse, don't validate). Correct.
- The two `handler` vocabularies (C2 event classes vs C11 field-writers) are now
  explicitly declared a different axis in C11, with "not meant to coincide."
- The amend Breaking track no longer folds in re-subscription; it is a "separate
  paired-issuance event," matching `amend` and S1.
- `balance`/transfer is now named in the §2 notation table, grounding `psBalance`.

## Non-blocking nits (cosmetic; do not gate)

- C11 body and the P10 gloss say "the unique field-writer" while listing
  `ac→settle/trade` (two writers). The enumeration in the same clause
  disambiguates instantly, and the condition title ("per-field *canonical*
  writer") plus the code (`WAc :: 'Settle`, `WAcTrade :: 'Trade`) make the intent
  unambiguous — `ac` legitimately has two authorised writers. "Unique" is one word
  too strong; prefer "the fixed writer-set" or "canonical writer(s)."
- `StatesHome.hs` line 369: "Kleisli (anti)homomorphism law." The law
  `replay (xs <> ys) = replay xs >=> replay ys` is order-preserving — a plain
  monoid homomorphism into Kleisli composition. Drop "(anti)".
- The P5 gloss cites "a single (w,u)-keyed row" though `lifecycle_stage` lives in
  the u-keyed `UnitStatus`; the claim still holds (single home + overwrite/dedup),
  but the phrasing reads slightly off for the status-side datum.

## What is solid (so the next revision does not over-correct)
Totality and exhaustiveness: full marks, unchanged from Round 1. The monotone
carrier, `NonEmpty` terms, abstract `ValidDelta` smart constructor, empty-fold C9
base case, PT⇔US-by-construction, and two-track `amend` are all correctly typed
and faithfully reflect their conditions. The S1–S4 expressibility signals remain
exemplary intellectual honesty and should stay verbatim. This round meets my bar.
