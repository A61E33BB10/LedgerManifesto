# MINSKY — Round 5 — States.tex / States.hs

## Verdict: OBVIOUS

My lens: the types must make the illegal states *visibly* impossible — the reader
*sees* it, rather than follows a proof to be persuaded of it. OBVIOUS stakes that
lens; I do not award it to be agreeable.

## The round-4 residue is closed

In round 4 I blocked on one thing: terms/status co-presence was left as a
sealed-constructor + enumerate-the-writers proof when the shape could carry it for
free, and the document's *own* rule ("prefer the shape that makes the illegal
state unspellable; disclose an invariant only when the shape cannot") demanded the
shape in exactly that case.

That is now fixed. The two unit-keyed maps are merged into one:

```haskell
ledgerUnit :: Map UnitId (ProductTerms, UnitStatus)   -- States.hs:427
```

Co-presence is now structural, not policed: one key carries both halves or
neither, so "in terms but not status" is no longer a spellable `Ledger` value. The
reader *sees* it in the type. `register` inserts the pair; `settle` does
`Map.adjust` over `snd` (States.hs:478), leaving the append-only `fst` untouched —
so the "third home, not third map" argument survives intact, the disciplines
living in the component types (`NonEmpty` vs single value), not in the outer map.
The round-4 secondary is closed too: the step-3/4 teaching scaffolding
(`Balances`, `holding`, `netOf`, `transfer`) is defined but absent from the export
list, with the omission documented (States.hs:26–31), so no second unsealed move
API is reachable.

## Every load-bearing invariant is now either seen-in-shape or honestly disclosed

I checked each claimed invariant against the test I have applied since round 1: it
must be either (a) visible in a single value's shape, or (b) disclosed with a
*bounded, exhibited* audit surface the reader can check by reading a named, finite
set of functions. (b) with the surface shown is *seeing*, not faith; faith is
unstated or unbounded reliance.

Seen in shape (a):
- **Priced-iff-active.** `data Lifecycle = Listed | Active Price` — "active with no
  price" and "listed yet priced" are unspellable; `settlementPrice` is total, two
  explicit arms, no wildcard.
- **Non-empty terms.** `ProductTerms (NonEmpty TermsVersion)`, constructor
  unexported — "registered but versionless" is unspellable; `currentTerms` total,
  no `Maybe`.
- **Terms/status co-presence.** Now the shape of the merged map (above).
- **Never-held vs held-and-flat.** `Maybe` on `position`: `Nothing` is no key,
  `Just zeroP` is a retained flat row — two distinct facts the type keeps apart.

Honestly disclosed with audit surface shown (b), and — crucially — only where a
value's shape *genuinely cannot* carry the property:
- **Conservation.** A `Map` cannot cheaply carry "sums to zero"; this is a writer
  invariant. The surface is exhibited and I re-verified it: `applyMove` is the
  *sole* writer of `psBal` (grep confirms — only States.hs:517), it writes
  `negQty q` and `q` together, so each move changes the holding sum by `mempty`;
  `register`/`settle` never touch `ledgerPS`; from `emptyLedger` (sum 0) every
  reachable ledger conserves, and the unexported constructor closes the reach. The
  document attributes this to the writer, never to "the shape" — the
  mis-attribution I caught in round 1 is gone.
- **Append-only terms history.** "No operation truncates" is a closure property
  over the abstract type's operations; no single immutable value's type can
  express it. The document discloses it correctly: `appendVersion`'s body visibly
  preserves the prior versions (`vs <> (tv :| [])`), and the three doors that
  touch `ProductTerms` are enumerated, with the constructor sealed so no shorter
  list can be fabricated.

The decisive point for my lens: the document's own "prefer the shape when it can
afford it" rule is now applied **consistently** — shape used everywhere it is
cheap (priced-iff-active, non-empty terms, co-presence), disclosure used only where
the shape genuinely cannot reach (conservation, append-only closure, the
registration-gating referential check). The inconsistency I flagged in rounds 1
and 4 — claiming shape where it rested on sealing, or disclosing where shape was
free — no longer exists.

## Totality and exhaustiveness

No case-arm wildcards anywhere. The only `_` uses are tuple-component discards
(`\(t, _) ->` in `settle`; `(_, u')` in the comprehensions) — exhaustive
destructures, not catch-alls that swallow constructors. `apply` matches all three
`Event` constructors explicitly, so adding an event forces a new arm. Every
accessor is total; every refusing writer makes failure explicit in `Maybe`, and
the document is careful that this `Maybe` answers "is this unit known?", never "did
the balance hold?". (I could not run `-Wall -Werror`: GHC is not installed in this
environment. The totality and exhaustiveness claims are verified by reading, which
is what the lens turns on; a CI compile with warnings-as-errors would mechanize
Level 1 and is worth wiring up, but nothing I can read suggests it would fail.)

## Conclusion

A reader who has never seen this problem can, by reading the types and a bounded
set of named writers, see that every illegal state the document cares about is
either unspellable or unreachable-by-an-exhibited-argument. Nothing load-bearing is
taken on faith. The bar is met.
