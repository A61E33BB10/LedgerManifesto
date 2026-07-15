# MINSKY scorecard — Round 8

Lens: the Haskell reference as the load-bearing artifact — total functions,
exhaustive cases, types as theorems, no representable illegal state.

Grade: **B (88%)**

## What is solid (verified by manual type-check; no GHC in env)

- **Totality of the library.** Every exported function returns for every input.
  Partiality is confined to the demo glue (`expect`, `error`) and is disclosed
  as such (lines 489–494). No partial `head`/`fromJust`/`NE` misuse;
  `currentTerms` is total because `ProductTerms` wraps `NonEmpty`.
- **Exhaustiveness.** No case-discriminating wildcard anywhere in the library.
  `applyWrite`, `conserved` enumerate all five `FieldWrite` constructors
  explicitly; `amend` covers `Nothing`/`Just` × `Preserving`/`Breaking` with the
  fresh-id collision guard. The only `_` patterns are argument-ignoring in the
  two example predicates and in the non-conserved `conserved (WHwm _)` /
  `(WEntryNav _)` — none can hide a missing constructor.
- **Abstraction barriers do real work.** `ValidDelta`, `ProductTerms`, `Ledger`
  are exported abstract (constructors withheld in the export list, lines 47–54),
  so "applied an unconserved delta," "registered but versionless," and "deleted a
  PositionState row" are genuinely unconstructable from outside the module. The
  monotone carrier is enforced by *absence* of a deleter — the right way.
- **PT↔US invariant by construction.** `register` writes both maps; `applyDelta`
  guards `sdUnit ∈ ledgerPT` before any US/PT touch; `amend` Breaking writes both
  for the fresh id. I checked every mutation path preserves "registered in PT ⇔
  registered in US." The `ghostSD` example exercises it.
- **Conservation as a monoid homomorphism into `PosDelta`** is correct, and the
  vacuous (C9) case genuinely falls out of `mempty` with no special-casing. The
  `>=>` replay-homomorphism law (P3) is the standard `foldM`/list-concat law and
  is stated correctly.
- **Honesty about the value-level boundary.** S1–S4 and the §11 "unrepresentable
  is used in this precise sense" caveat correctly fence off what is a type fact
  (constructor barriers) from what is a checked value (conservation via
  `validate`). No overclaim: the tex's P10 gloss itself says "binds at
  authorship, erased at the row." The artifact matches the claim.

Type-check trace found no error: GADT + DataKinds + StandaloneDeriving usage is
standard; `foldMap . foldMap` over `Map WalletId [SomeWrite]` lands in
`PosDelta`; `Map.foldrWithKey applyRow` and `Map.adjust (appendVersion tv)` are
well-typed. I am confident it compiles.

## Blocking issue (the one thing between B and A in my lens)

1. **The flagship type-level theorem (C11/P10) is never exercised in the live
   path; its phantom index is inert in the actual data flow.**
   Location: `reference/StatesHome.hs` lines 196–219 (the `FieldWrite h` GADT and
   `SomeWrite`), the `_c11_ok_*`/commented `_c11_bad` at lines 437–443, and the
   whole `main` flow lines 513–541 which builds `SomeWrite (WAc ...)` *inline*.
   The phantom `h :: Handler` is the document's marquee "make illegal states
   unrepresentable" mechanism (C11, P10, signal S3). But in the reference it
   constrains *nothing* at any real call site: every write is wrapped in
   `SomeWrite` immediately, so the index never discriminates in `StateDelta`,
   `validate`, `applyDelta`, or the runnable example. Its only witnesses are two
   eta-expanded constructor aliases and a comment. S3's prose says the index "is
   checked where each handler declares its output type
   (`Map WalletId (FieldWrite 'Settle)` etc.)" — but **no such handler exists in
   the file.** A phantom parameter that never constrains a live call site is, in
   the artifact, decoration rather than a theorem.
   Actionable fix: add one real typed handler, e.g.
   `settleHandler :: ... -> Map WalletId (FieldWrite 'Settle)`, and have `main`
   route its output into the `tradeSD`/`closeSD` rows via
   `fmap (map SomeWrite)`. Then the authorship→erasure pipeline that C11/S3
   describe actually appears in the running code, and the `_c11_bad` rejection is
   anchored to a site that exists. This is the single change that would let me
   stake the lens on "types as theorems" and award A.

## Non-blocking observations (would not hold up the round)

- `balance`/`WBalance`/`'Transfer` exist only to give C11 a second conserved
  field with a distinct writer (`PosDelta` second component, lines 199, 244).
  It is defensible — without it `PosDelta` collapses to one dimension and the
  per-field-writer point is shown on `ac` alone — but it is the one thing a
  reader could argue is cuttable, and the tex spends three separate passages
  (notation, the §answer inventory note, C11) defending why it is "not an
  economic datum." Heavily disclosed; net acceptable. No Transfer event appears
  in the example, so `WBalance` is also unexercised in the live path.
- `Handler (..)` is exported as a value type but used only at the type level;
  its value constructors are dead at the value level. Harmless noise.

## Verdict

Correctness is fully preserved; totality and exhaustiveness are airtight; the
abstraction barriers make the headline illegal states genuinely unconstructable;
and the value-level boundary is disclosed without overclaim. This is A-grade work
on every axis except one: the type-theorem the document leans on hardest (C11) is
demonstrated only at a hypothetical authorship site absent from the file, leaving
its phantom index inert in the live path. Honest disclosure keeps it from being a
correctness defect, but for *my* lens — types as theorems, exercised — that gap
is the difference between B and A. Fix issue 1 and I award A.
