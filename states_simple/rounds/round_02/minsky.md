# minsky — States, Round 2

**Verdict: NOT-YET**

My lens: the types must make the illegal states *visibly* impossible — the reader
sees it, not takes it on faith. The conservation story passes that bar; the
append-only story does not, because a second writer defeats it.

## What passes

- **Conservation is honestly a writer invariant, and the reachability proof
  holds.** `applyMove` is in fact the only function that writes `psBal` (verified:
  `register` writes `ledgerPT`/`ledgerUS` only, `settle` writes `ledgerUS` only).
  Its two legs are `negQty q` and `q` from one quantity, cancelling to `mempty`.
  The `Ledger` constructor and `ledgerPS` selector are unexported, so no outside
  code lays down a non-conserving map. `PositionState(..)` is exported, but only
  for read/destructure — there is no door to write it back. The document does not
  overclaim here: it states plainly that the store type does not forbid the bad
  value and that conservation rests on writer-plus-sealed-constructor. Acceptable.
- **Terms/status coherence (PT-key iff US-key) is maintained by every writer.**
  `settle` uses `Map.adjust`, which cannot add a key; `applyMove` touches neither
  map. Coherence survives.
- **Non-empty version list makes "registered but versionless" unrepresentable.**
  `currentTerms` is total. Correct.

## Residue (located, actionable)

### 1. `register` defeats the append-only guarantee it is meant to uphold — the central Level-2 claim of §6 is false as written.

`States.hs:378-382`:

```haskell
register :: UnitId -> TermsVersion -> Ledger -> Ledger
register u tv l = l
  { ledgerPT = Map.insert u (ProductTerms (tv :| [])) (ledgerPT l)
  , ledgerUS = Map.insert u defaultStatus             (ledgerUS l) }
```

`register` is **exported** (`States.hs:54`), returns `Ledger` (not `Maybe`), and
guards nothing. Calling it on an **already-registered** unit does two destructive
things via unconditional `Map.insert`:

1. Replaces the unit's `ProductTerms` with a **fresh single-version value**,
   discarding the entire prior version history.
2. Resets `UnitStatus` to `defaultStatus` (`Listed`, `Nothing`), discarding the
   lifecycle stage and the last settlement price.

This directly contradicts the load-bearing claim of step 6 / §6:

- `States.hs:290-295`: "no importer can build a fresh one-version value either.
  The append-only discipline is therefore enforced by construction ... the only
  two doors into `ProductTerms` are `currentTerms` (read) and `appendVersion`
  (grow), and neither can shorten the history."
- `States.tex:175-181`: "the constructor is not exported, so no importer can lay
  down a fresh one-version value and discard history: the append-only discipline
  holds by construction, not by convention."

But `register` *is* a third door into `ProductTerms`: it constructs a fresh
one-version value with the in-module constructor and `Map.insert`s it over any
existing history. Hiding the `ProductTerms` constructor from importers does not
help, because `register` — the function importers are told to use — does the
shortening for them. The append-only discipline therefore rests on the
convention "never call `register` twice on the same unit," which is exactly what
§6 claims to have eliminated. A reader who reads `register`'s body sees
`Map.insert` clobbering live state; the illegal state §6 says is unrepresentable
is one ordinary call away.

The document's own reachability method should have caught this: the proof that
terms grow only by appending must quantify over *every* writer of `ledgerPT`, and
`register` is one. The conservation proof did that quantification correctly
(enumerated all writers of `psBal`); the terms proof did not.

**Fix (either):** (a) make `register` total over the duplicate case by refusing
it — `register :: UnitId -> TermsVersion -> Ledger -> Maybe Ledger`, `Nothing`
when `Map.member u (ledgerPT l)`, mirroring `settle`/`applyMove`; or (b) have
`register` append a version (and leave status untouched) when the unit already
exists. Until one is done, the "by construction, not by convention" sentence must
be withdrawn.

### 2. (Secondary) Lifecycle is a four-state type with no transitions; `settle` forces `Active` unconditionally.

`States.hs:241` defines `Lifecycle = Listed | Active | Expired | Closed`, but no
exported writer ever produces `Expired` or `Closed` — `register` sets `Listed`,
`settle` (`States.hs:395`) sets `Active` and nothing else. So:

- Two of the four constructors are unreachable dead values. A reader looking for
  "illegal states impossible" instead finds states that are representable but
  never produced, with no transition function to give them meaning.
- `settle` is non-monotonic: it sets `usLifecycle = Active` regardless of the
  current stage. Were a unit ever `Closed`/`Expired`, a settle would silently
  revive it to `Active`. The lifecycle invariant (whatever it is) is neither
  encoded nor exercised.

The prose (`States.tex:64`, "lifecycle stage") presents lifecycle as carried
state, but its correctness is taken on faith. **Fix:** either drop the
unreachable constructors until transitions exist, or model the transitions and
have `settle` respect a closed/expired unit rather than reviving it.

## Bottom line

Conservation and replay clear the bar; the reader sees them in the shape. The
append-only terms guarantee — the entire reason §6 claims a third home rather
than a second — does not, because `register` is an unguarded, exported door that
overwrites version history and resets status. That is a representable illegal
state reachable by convention-violation, which is precisely what the lens
forbids. NOT-YET until `register` is closed.
