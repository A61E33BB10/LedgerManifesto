# MINSKY scorecard — StatesHome rewrite, Round 1

Lens: the Haskell reference as the load-bearing artefact — total functions,
exhaustive cases, types as theorems, no representable illegal state. I judge the
prose by whether the types it claims actually deliver the theorems it asserts.

## Grade: B (84%)

No GHC/cabal/stack in the environment, so `StatesHome.hs` was type-checked by
hand. It is clean: every exported function is total, every pattern match is
exhaustive (GADT matches in `applyWrite`/`conserved` cover all five
constructors; `amend` covers `Maybe` × `Fungibility` with no wildcard), the
underscore-prefixed `_c11_*` bindings dodge `-Wunused`, and `NonEmpty` makes
`currentTerms` total without a `Maybe`. The conservation-as-monoid construction
(`validate` → `ValidDelta`, empty fold = `mempty` = C9) is genuinely elegant and
the abstract `Ledger`/`ProductTerms`/`ValidDelta` exports do enforce the
monotone-carrier (C1b), append-only (C6), and unconserved-delta-unreachable (C2)
disciplines by absence of setters. The S1–S4 expressibility signals are honest
engineering: they name what the encoding does *not* prove and point at the right
layer. This is well above C. It is not an A: three claims in the prose state
theorems the program does not deliver at the level it operates.

## Blocking issues

### 1. C11 "type error" is overstated relative to what the code enforces
`addendum_stateshome_v2.tex` §future, condition C11 (lines 280–285) and the
§reference bullet (lines 282–284 region) assert "a write to a field by any other
handler is a type error." But `StateDelta.sdRows :: Map WalletId [SomeWrite]`
(StatesHome.hs line 273) stores `SomeWrite`, which *erases* the `Handler` index
(line 208–209). Nothing stops a settle-event StateDelta from carrying
`SomeWrite (WHwm q)`; `applyWrite`/`applyDelta` accept it. The guarantee holds
only at the *authorship site* of a handler that declares
`Map WalletId (FieldWrite 'Settle)` — and no such handler exists in the
reference; only the `_c11_ok_*` examples (lines 437–443) demonstrate it. S3
(lines 469–476) admits this erasure, but C11's own statement in the body does
not carry the caveat S3 makes. Action: weaken C11's wording to "a type error at
the point a handler authors its writes; erased to a value once heterogeneous
writes share a row (see S3)", so the theorem stated matches the proof shipped.

### 2. Illegal lifecycle transitions are representable; P5 is oversold
`Lifecycle` (StatesHome.hs line 130) is a flat enum with no order and no
transition relation, and `applyDelta` installs `sdStatus` by unconditional
`Map.insert` (lines 353–355). Therefore `Expired → Listed`, `Closed → Active`,
or any skip is a fully representable state — there is no guard. The addendum
nonetheless lists P5 "idempotency of lifecycle events" among the seven invariants
made *unrepresentable* (§unreachable, lines 632–634) and prices "lifecycle
guards (LISTED→ACTIVE→EXPIRED)" at a 70–80% mutation score (§testing, lines
657–659) — i.e. test-covered, not type-enforced. The two statements contradict:
an invariant cannot be both "unrepresentable" and "needs targeted boundary tests
because `>` vs `>=` mutants survive." Action: either encode the transition
relation in the type (a `step :: Lifecycle -> Event -> Maybe Lifecycle` total
function, or a phantom-indexed status) and keep P5 in §unreachable, or move
lifecycle ordering out of the "unrepresentable" list and state plainly that it is
guarded by tested handlers, not by construction.

### 3. `StateDelta` is single-unit, so the multi-unit trade the prose describes
is not atomically expressible
`StateDelta` carries one `sdUnit` (StatesHome.hs lines 271–276) and `applyRow`
keys every row as `(w, sdUnit)` (lines 362–366). This is what makes per-unit
conservation structural — good — but it means a genuine trade (future against
cash: two units, two conservation laws) cannot be one `StateDelta`, and C3's
"atomic StateDelta" (§qis, lines 389–393) cannot span two units. The §future
worked legs (lines 243–245) and the `main` example (lines 513–521) sidestep this
by conserving `ac` *within one unit*, which reads as a full trade but is not.
S1 (lines 448–460) handles exactly this shape for the breaking-amendment
re-subscription via paired issuance, but does not generalise the point to
ordinary two-unit trades. Action: state in C3 (or extend S1) that a multi-unit
atomic event is composed of one `ValidDelta` per unit applied together
(`replay [legA, legB]`), and note that single-unit cross-wallet conservation is
all `validate` discharges — so the reader does not mistake the `ac`-only example
for a complete trade model.

## Non-blocking nits (worth a pass, not gating)

- StatesHome.hs line 369: "Kleisli (anti)homomorphism law" — `replay (xs <> ys)
  = replay xs >=> replay ys` is order-preserving, i.e. a homomorphism from the
  list monoid into Kleisli composition. The "(anti)" is misleading; drop it.
- StatesHome.hs line 219: `psEntryNav = maybe (Just q) Just (psEntryNav p)` is
  the write-once idiom but reads cryptically. `maybe (Just q) Just` = "keep the
  old value if present, else set q." A one-word inline comment or
  `case psEntryNav p of Nothing -> Just q; existing -> existing` would read
  straight.
- The reference models conservation of `psAc`/`psBalance` but the framework
  holding `h(w,u)` of the notation table (tex lines 105–107) has no field in
  `PositionState`. Consistent (h is framework-level), but a one-line note that
  the reference exercises the *extension* of conservation to `ac`, not `h`
  itself, would close the gap a careful reader opens.

## What is solid (so the next revision does not over-correct)
Totality and exhaustiveness: full marks. The monotone carrier (no PS deleter),
the `NonEmpty` terms, the abstract `ValidDelta` smart constructor, the empty-fold
C9 base case, the PT⇔US-by-construction argument in `register`/`applyDelta`
(lines 317–359), and the two-track `amend` are all correctly typed and
faithfully reflect their conditions. S1–S4 are exemplary intellectual honesty and
should stay verbatim.
