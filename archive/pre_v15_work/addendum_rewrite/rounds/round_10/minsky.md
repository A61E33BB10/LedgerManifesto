# MINSKY scorecard — Round 10

Lens: the Haskell reference as the load-bearing artifact — total functions, exhaustive
cases, types as theorems, no representable illegal state. Bar for A (>=90): a competent
quant engineer who has not read the review rounds follows it in one careful pass; nothing
cryptic in my domain; correctness fully preserved; nothing cuttable without loss.

## Grade: A (91%)

I stake my lens on this round. No GHC in the environment, so I hand-checked compilation,
totality, and exhaustiveness line by line; the reference is sound.

## Compilation / type check (by hand)

- Extensions cover every advanced use: `DataKinds`+`KindSignatures` for
  `FieldWrite (h :: Handler)` and the promoted `'Settle` etc.; `GADTs` for `FieldWrite`
  and the existential `SomeWrite`; `StandaloneDeriving` for `deriving instance Show
  (FieldWrite h)`. All four are declared.
- Existential unpacking in `validate` (`\(SomeWrite w) -> conserved w`) and in
  `applyRow` (`\acc (SomeWrite fw) -> applyWrite fw acc`) is well-scoped: the rigid `h`
  never escapes (both `conserved` and `applyWrite` are rank-1 in `FieldWrite h` and land
  in monomorphic types). Typechecks.
- `Right l { ... }` parses as `Right (l { ... })` — record update binds tighter than
  application. Correct in both `register` and `applyDelta`.
- All `Map.*`, `NE.*`, `foldM`, `foldl'` are real members of the imported modules; all
  imports are used. The only partial code (`expect`/`error`) is the demo glue, explicitly
  fenced off.

## Totality and exhaustiveness — clean

- `applyWrite` and `conserved` each enumerate all five `FieldWrite` constructors
  explicitly. No constructor-level wildcard anywhere in the library; the `_` cases are on
  the `Qty` payload of a fully-named constructor, not a swallowed case.
- `amend` matches both `Fungibility` arms; `validate`, `applyDelta`, `register` use total
  guards; `currentTerms`/`allVersions` are total because `ProductTerms` wraps `NonEmpty`.
- Behavioural checks I confirmed: `WEntryNav` is genuinely write-once
  (`maybe (Just q) Just`), `WHwm` is genuinely monotone (`qmax`), `appendVersion` puts the
  new version last so `currentTerms = NE.last` is the in-force one, the Breaking track
  never rewrites the old unit's terms (P7), and `register`/`applyDelta`/`amend` all
  preserve the PT<=>US registration invariant by construction.

## Types as theorems — verified

- `replay (xs <> ys) = replay xs >=> replay ys` (spec P3) holds: it is exactly the
  standard `foldM` concatenation law in the `Either LedgerError` Kleisli category. The
  monotone carrier keeps the key set stable across cuts, so checkpoint-independence really
  is a corollary, not a test.
- Illegal states are unrepresentable where claimed: no PS row deleter is exported
  (monotone half of C1); `ValidDelta` is abstract with `validate` its only constructor, so
  an unconserved delta cannot reach `applyDelta`; `NonEmpty` makes a versionless
  `ProductTerms` untypable; the GADT phantom index makes a settle handler emitting `WHwm`
  a type error at its declared output type, exercised at the live `settleHandler` call
  site, then erased via `erase` at the row (S3). The C11 story binds at authorship, as the
  prose says.

## Honest disclosure where the guarantee is value-level — approved

P1 (conservation) and the lifecycle-ordering gap are exactly the places where a naive
"unrepresentable" claim would be false, and the document flags both: line ~668-676 defines
"unrepresentable" precisely and concedes conservation is a value-level check (S4); the
testing section concedes lifecycle transition ordering is enforced by tests, not types,
and is careful that P5 is *idempotency*, not ordering. This is the right posture: the
theorem stated is the theorem proved.

## Non-blocking observations (do not bar A; recorded for the record)

1. `balance`/`Transfer` is a demonstrative field with no economic meaning. It is the one
   candidate for "cuttable," and the reader is told three times (notation, answer
   inventory, C11) to ignore it economically. I judged it retained-with-loss-if-cut: it is
   the *only* second conserved field, so it is what shows `PosDelta` carries conservation
   per-field rather than as a single scalar, and what gives C11 a writer (`Transfer`)
   disjoint from settle/trade. `hwm`/`entryNav` cannot stand in — they are non-conserved.
   Borderline, but defensible; the `WBalance` constructor is never authored on the live
   `main` path, which is the weakest point of the demonstration.
2. P9 (capability scoping) is counted among the seven "made unrepresentable," but its
   mechanism lives in a capability layer that the reference deliberately does not implement
   (S2). The claim is a design-level claim about condition C4, honestly scoped out of the
   data reference. Asserted-with-disclosure rather than shown; consistent, not false.

Neither rises to a blocking issue under my lens. The reference is total, exhaustive,
type-correct, and makes the illegal states it claims to make unrepresentable, with the
value-level boundaries named rather than hidden.
