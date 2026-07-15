# MINSKY scorecard — Round 9

Lens: the Haskell reference as the load-bearing artifact — total functions,
exhaustive cases, types as theorems, no representable illegal state.

Grade: **A (91%)**

## The round-8 blocker is fixed, exactly as specified

In round 8 I staked B on one issue: the document's marquee type-level theorem
(C11 / P10, "mutation by any other handler is a type error") was demonstrated
only at a hypothetical authorship site absent from the file. The phantom
`h :: Handler` on `FieldWrite h` constrained nothing at any real call site —
every write was wrapped in `SomeWrite` inline, so the index was inert in
`StateDelta`, `validate`, `applyDelta`, and `main`. I wrote: "add one real typed
handler … and have `main` route its output … via `fmap (map SomeWrite)` … this
is the single change that would let me … award A."

Round 9 does precisely that:

- `settleHandler :: [(WalletId, Qty)] -> Map WalletId [FieldWrite 'Settle]`
  (StatesHome.hs:231–232) is a real handler whose **output type carries the
  phantom index**. Its body emits `[WAc q]`; a body that tried to bump hwm would
  have to emit `WHwm :: FieldWrite 'FeeCrystallise` and would fail to typecheck
  against the declared `'Settle` result. The theorem now lives at a concrete,
  exported signature.
- `erase :: Map WalletId [FieldWrite h] -> Map WalletId [SomeWrite]`
  (StatesHome.hs:238–239) is the S3 erasure boundary in code.
- `main` builds both `tradeSD` (line 539) and `closeSD` (line 562) as
  `erase (settleHandler [...])`, so the authorship→erasure pipeline runs on the
  **live path**, not only in the two `_c11_ok_*` aliases. Both are exported
  (lines 45–46).

I hand-traced the types (no GHC in env): `WAc q :: FieldWrite 'Settle` ⇒
`settleHandler` matches its signature; `fmap (map SomeWrite)` carries
`Map WalletId [FieldWrite h]` to `Map WalletId [SomeWrite]`; `erase (settleHandler
…) :: Map WalletId [SomeWrite]`, the exact type of `sdRows`. `SomeWrite`'s
existential pack and the `Map` functor instance are standard. I am confident it
compiles, and the C11 theorem is now exercised, not decorative. The tex matches:
§7 (lines 805–812) and signal S3 (lines 489–499) name `settleHandler`,
`erase = fmap (map SomeWrite)`, and the `erase . settleHandler` live path
verbatim; C11 itself (lines 305–317) now separates the field-writer axis from the
C2 event-class axis explicitly.

## What remains solid (re-verified this round)

- **Totality.** Every exported library function returns for every input.
  Partiality is confined to demo glue (`expect`/`error`, disclosed lines
  509–517). `currentTerms` is total via `NonEmpty`; no `head`/`fromJust`/NE
  misuse.
- **Exhaustiveness.** No case-discriminating wildcard in the library.
  `applyWrite` and `conserved` enumerate all five `FieldWrite` constructors;
  `amend` covers `Nothing`/`Just` × `Preserving`/`Breaking` plus the fresh-id
  collision guard. The only `_` patterns are argument-ignoring (the two example
  predicates; the non-conserved `conserved (WHwm _)`/`(WEntryNav _)`), none of
  which can hide a missing constructor.
- **Abstraction barriers do real work.** `ValidDelta`, `ProductTerms`, `Ledger`
  are exported abstract (constructors withheld, lines 31–60). "Applied an
  unconserved delta," "registered but versionless," and "deleted a PositionState
  row" are genuinely unconstructable from outside. Monotone carrier enforced by
  *absence* of a deleter — the correct mechanism.
- **PT↔US invariant by construction.** `register` writes both maps; `applyDelta`
  guards `sdUnit ∈ ledgerPT` before any US/PT touch; `amend` Breaking writes both
  for the fresh id. Every mutation path preserves "registered in PT ⇔ registered
  in US"; the `ghostSD` example exercises it.
- **Conservation as a monoid homomorphism into `PosDelta`** is correct; the
  vacuous C9 case falls out of `mempty` with no special-casing. The `>=>` replay
  law (P3) is the standard `foldM`/concat homomorphism, stated correctly.
- **Honesty about the value-level boundary.** S1–S4 and the §11 "unrepresentable
  in this precise sense" caveat correctly fence type facts (constructor barriers)
  from checked values (conservation via `validate`). No overclaim.

## Non-blocking observations (do not hold up the round)

1. `balance`/`WBalance`/`'Transfer` exist only to give C11 a *second* conserved
   field with a *distinct* writer, so the per-field-writer point is shown on two
   conserved fields rather than on `ac` alone. `WBalance`/`'Transfer` appear in
   no `_c11_ok_*` witness and in no live path; `PosDelta`'s `dBalance` component
   is always zero in the example. This is the one element a reader could argue is
   cuttable — but cutting it collapses `PosDelta` to one dimension and removes
   the demonstration that two different conserved fields have different canonical
   writers, which is the substance of C11. It is heavily disclosed (notation, the
   §answer inventory note, C11) and load-bearing for the headline theorem. Net:
   not cuttable without loss; acceptable for A.
2. `Handler (..)` is exported as a value type but used only at the type level
   (DataKinds promotion); its value constructors and `Eq`/`Show` are dead at the
   value level. Harmless noise.

## Verdict

The single issue I staked B on in round 8 is resolved exactly as I specified:
the C11 phantom index now constrains a live, exported call site whose output
flows into the runnable example, so "types as theorems" is exercised on the
running path, not asserted at a hypothetical site. Totality and exhaustiveness
remain airtight; the abstraction barriers make the headline illegal states
genuinely unconstructable; correctness is fully preserved; and the value-level
boundary is disclosed without overclaim. A competent Haskell-literate quant
engineer follows the GADT → `settleHandler` → `erase` → `applyDelta` pipeline in
one careful pass. On my lens this clears the bar. I award A and stake the lens on
it. Held at 91, not higher, only because the `balance`/`'Transfer` second field
remains unexercised in the live path — defensible and disclosed, but the last
residual in my domain.
