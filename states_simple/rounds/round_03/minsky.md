# minsky — States, Round 3

**Verdict: NOT-YET**

My lens: the types must make the illegal states *visibly* impossible — the reader
sees it in the shape, not takes it on faith. The bar is the document's own thesis:
"illegal states are not representable."

## What now clears the bar (Round 2 residues closed)

- **`register` no longer shortens history.** `States.hs:395-401` /
  `States.tex:250-255`: `register :: ... -> Maybe Ledger`, returning `Nothing`
  when `Map.member u (ledgerPT l)`. It is now genuinely the
  write-where-there-was-nothing door; combined with the hidden `ProductTerms`
  constructor and `appendVersion` as the only growth door, the append-only
  discipline holds by construction. Round-2 residue #1 resolved.
- **Lifecycle dead constructors gone.** `Lifecycle = Listed | Active`
  (`States.hs:247`). Both stages are produced by a writer (`Listed` by
  `defaultStatus`, `Active` by `settle`); no uninhabited case remains. Round-2
  residue #2 / the milewski/cto unearned-stage findings resolved.
- **Conservation remains an honestly-flagged writer invariant.** `applyMove` is
  the only writer of `psBal`; `register`/`settle` touch only `ledgerPT`/`ledgerUS`;
  the `Ledger` constructor and selectors are unexported, so reachability is
  exhaustive. The document does not overclaim: it states plainly that the store
  type can hold a non-conserving map and that the guarantee rests on
  writer-plus-sealed-constructor (`States.tex:291-302`, `States.hs:459-472`).
  Because a `Map` cannot cheaply express "sums to zero," accepting this as a
  contained, audited writer invariant is the pragmatic call, and it is disclosed.
  Acceptable.
- **Exhaustiveness / totality.** `apply` matches all three `Event` constructors,
  no wildcards (`States.hs:574-577`). `currentTerms` is total via `NonEmpty`. Good.

## Residue (located, actionable) — blocks OBVIOUS

### UnitStatus represents illegal states, and unlike conservation this is cheaply expressible and is **not** flagged.

`States.hs:249-257` / `States.tex:187-190`:

```haskell
data UnitStatus = UnitStatus
  { usLifecycle  :: Lifecycle
  , usLastSettle :: Maybe Price }
defaultStatus = UnitStatus Listed Nothing
```

`settle` (`States.hs:409-414`) writes both fields together:
`us { usLifecycle = Active, usLastSettle = Just px }`.

So the only *reachable* values are `(Listed, Nothing)` and `(Active, Just px)`.
But the *type* admits two more:

- `(Active, Nothing)` — active, yet no settlement price. Illegal.
- `(Listed, Just px)` — not yet active, yet already carrying a settle price.
  Illegal.

The invariant "active iff settled, and settled implies a price is present" is held
solely by `settle` writing the two fields in lockstep — a **writer invariant taken
on faith**, exactly what the lens forbids. A reader inspecting `UnitStatus` sees a
product of `Lifecycle × Maybe Price` whose four inhabitants include two that the
status home is never meant to hold, with nothing in the type to forbid them. The
two fields redundantly encode the same "has it settled?" bit, and the gap between
those two encodings is precisely where the illegal states live.

Why this blocks, given the document's own standard:

1. **The file applies the missing-state rigor everywhere else.** It uses
   `NonEmpty` so "registered but versionless" is unrepresentable
   (`States.tex:192-199`); it hides constructors so a non-conserving map cannot be
   laid down by hand. The same discipline is simply absent on status.
2. **It is honest about conservation as a writer invariant but silent here.** The
   document carefully flags conservation as not-type-enforced and explains *why the
   type cannot express it*. For `UnitStatus` no such flag appears — the reader is
   led to believe status is clean by construction when it is not.
3. **Unlike conservation, the type *can* express this, trivially and cheaply.**
   This is the canonical "make illegal states unrepresentable" move (the RWO
   connection-state example): fold the price into the stage and delete the
   redundant field.

   ```haskell
   data Lifecycle = Listed | Active Price
   newtype UnitStatus = UnitStatus { usLifecycle :: Lifecycle }
   defaultStatus = UnitStatus Listed
   -- settle: overwrite _ = UnitStatus (Active px)
   ```

   Now `(Active, Nothing)` and `(Listed, Just px)` are unspellable, the redundant
   bit is gone (a Minimalism win), and `usLastSettle` is read off the stage
   totally. The fix scales to the full lifecycle the prose mentions
   (`States.hs:245`): later post-listing stages carry the price too
   (`Active Price`, `Expired Price`, ...), so each is settled-by-construction.

**Fix:** carry the settlement price inside the `Active` constructor and drop the
separate `usLastSettle` field; or, if the field must stay, add the same explicit
"this correlation is a writer invariant, not type-enforced" disclosure the
document gives conservation, and justify why (it cannot here — the type expresses
it for free).

## Bottom line

The append-only and conservation stories now clear the bar; the reader sees them
in the shape, and where a guarantee rests on the writer it is disclosed. The
status home does not: `UnitStatus` represents `(Active, Nothing)` and
`(Listed, Just px)`, two illegal states the type permits, the invariant ruling
them out lives only in `settle`, and — unlike conservation — the type can forbid
them at no cost and the document does not flag the gap. That is a representable
illegal state, unacknowledged, against the file's own thesis. NOT-YET until the
price is folded into the lifecycle stage (or the writer-invariant status of the
correlation is disclosed as conservation's is).
