# minsky — States, Round 7

**Verdict: OBVIOUS**

My lens: do the types make the illegal states visibly impossible — does the reader
see it, not take it on faith?

## What I checked, and what holds visibly

I enumerated the illegal states this design names, and confirmed each is closed by a
mechanism the reader can verify from the presented declarations — never by assertion.

1. **Active-without-price / Listed-with-price** — closed by the *shape of the
   constructor*. `data Lifecycle = Listed | Active Price` carries the price *on*
   `Active`. `Active` cannot be built without a `Price`; `Listed` has no field to
   hold one. Unrepresentable, not policed. Exporting `Lifecycle(..)` does not weaken
   this — the invariant lives in the constructor arities, so even a hand-built value
   conforms. This is the textbook case and it is done correctly (States.hs:257,
   States.tex:213).

2. **Registered-but-versionless terms** — `newtype ProductTerms = ProductTerms
   (NonEmpty TermsVersion)`, constructor unexported (export list States.hs:45-48,
   the `ProductTerms` without `(..)`). `NonEmpty` cannot be empty even inside the
   module; no door lays down a fresh value (`register` writes `tv :| []` only for an
   absent unit, refusing a present one — States.hs:455-460). Append-only by
   construction, total `currentTerms` via `NE.last`. Visible.

3. **A unit with terms but no status (incoherent entry)** — closed by *the shape of
   the map value*: `Map UnitId (ProductTerms, UnitStatus)` (States.hs:427). One key
   carries both halves or neither; `productTerms` and `unitStatus` project `fst`/`snd`
   of one lookup, so they return `Nothing` together. Co-presence is the type, not a
   writer promise. Visible.

4. **Conflating never-held with held-and-flat** — `Maybe PositionState`: `Nothing` is
   no key, `Just (psBal 0)` is a retained flat row (`applyMove` first-touches via
   `findWithDefault zeroP`, never deletes — States.hs:516). The distinction is the
   `Maybe`. Visible.

## The one invariant that is *not* type-enforced — and why that is right, not a gap

Conservation (sum of `psBal` over holders of a unit = `mempty`) is **not** made
unrepresentable by the types: the store type `Map (WalletId, UnitId) PositionState`
can hold a non-conserving map. A non-conserving `Ledger` is therefore *representable*
but *unreachable*.

I scrutinized this hardest, because for a ledger conservation is the defining
property, and "representable but unreachable" is weaker than "unrepresentable." Three
findings made me accept it rather than flag it:

- The document **discloses it explicitly** and does not claim otherwise
  (States.tex:343-355, States.hs:519-549). It never asks for faith on this point — it
  states the gap and proves closure.
- Closure is by a **bounded, self-contained survey, not faith**: `applyMove` is the
  only writer of `psBal` and writes `negQty q` and `q` together from one quantity
  (cancel by construction); `register`/`settle` touch only `ledgerUnit`; `emptyLedger`
  is empty; the `Ledger` constructor and both field selectors are unexported (export
  list States.hs:52-69 omits the constructor and `ledgerUnit`/`ledgerPS`). The set of
  writers is finite and shown, so "only `applyMove` writes the balance" is checkable,
  not trusted.
- The choice is **correctly justified**: a `Map` cannot cheaply carry "sums to zero,"
  so the honest move is to disclose a writer invariant rather than fake a type
  guarantee. The document draws exactly this contrast against the price case, where
  the type *can* carry the correlation for free and so it does (States.hs:281-286).
  This is the judgment I would make. Making conservation structural would require not
  materializing `psBal` at all (project balances from a balanced move log) — a
  redesign the projection/replay framing gestures at but which trades away the
  materialized read the ledger wants. Declining it with this reasoning is sound.

So the document never substitutes assertion for proof: where a type suffices it uses
the type; where a type cannot cheaply carry the invariant it discloses the invariant
and proves unreachability from the seal. That is the opposite of faith.

## Totality and exhaustiveness (my non-negotiables)

- No partial functions: `NE.last` is total on `NonEmpty`; all `Map` ops total; no
  `head`/`fromJust`/`error`. Every claimed-total accessor is total.
- No wildcard patterns anywhere. `apply` matches all three `Event` constructors
  explicitly (States.hs:642-645); `settlementPrice` matches both `Lifecycle` cases
  (States.hs:293-295). Adding an event/stage forces a compiler complaint rather than
  silent fallthrough.
- `Maybe` returns mean exactly what the prose says: `applyMove`/`settle`/`register`
  return `Nothing` only for malformed input (unknown or already-present unit), never
  for a failed balance — verified against the guards.

## Claims vs. code

I spot-checked the load-bearing claims against the demo and the definitions:
self-transfer (`from == to`) still nets zero; `netBal` is zero on every reachable
ledger; replay rebuilds terms/status/positions from `emptyLedger`; the `foldM`
checkpoint law holds. All consistent. No false claim found.

One note for the record, not a blocker: the seal — the lynchpin of both conservation
and append-only — is verifiable only from the **module export list in States.hs**; the
States.tex listings reproduce declarations but not the export list, asserting
"constructor not exported" in comments (States.tex:230, 267). The .tex explicitly
defers to States.hs ("The Haskell is States.hs"), and the .hs makes the seal fully
checkable, so under the instruction to read both files the seal is seen, not trusted.

## Conclusion

Every illegal state the design names is either made unrepresentable by a type the
reader can see, or — for the single invariant a `Map` cannot cheaply carry —
disclosed honestly and proved unreachable by a bounded survey of a sealed writer set.
Nothing is taken on faith. OBVIOUS.
