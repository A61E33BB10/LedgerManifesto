# MINSKY — Round 6 — States.tex / States.hs

## Verdict: OBVIOUS

My lens: the types must make the illegal states *visibly* impossible — the reader
*sees* it, not takes it on faith. OBVIOUS stakes that lens; I do not award it to be
agreeable.

## Fresh pass, independent of round 5

I re-derived every claim from the two files rather than trusting my prior round.
The artifact is unchanged from what I cleared in round 5 (the load-bearing lines
match: the merged unit map at States.hs:427, `settle`'s `Map.adjust` over `snd` at
:478, the sole `psBal` writer `leg` at :517), and a clean re-read found no
regression and, importantly, no overclaim. The document's rhetorical discipline —
"prefer the shape that makes the illegal state unspellable; disclose an invariant
only when the shape cannot carry it" — is applied consistently.

## Illegal states the document cares about — each is seen, not asserted

Seen in a single value's shape (the strongest form):
- **Priced-iff-active.** `data Lifecycle = Listed | Active Price` (States.hs:257):
  "active with no price" and "listed yet priced" are unspellable. `settlementPrice`
  is total over two explicit arms, no wildcard.
- **Non-empty terms.** `ProductTerms (NonEmpty TermsVersion)` (States.hs:330),
  constructor unexported: "registered but versionless" is unspellable.
  `currentTerms` is total — no `Maybe`, because `NE.last` always answers.
- **Terms/status co-presence.** `Map UnitId (ProductTerms, UnitStatus)`
  (States.hs:427): one entry carries both halves or neither, so "in terms but not
  status" is not a spellable `Ledger`. The reader sees co-presence in the type, not
  in a writer it must trust.
- **Never-held vs held-and-flat.** `Maybe` on `position`: `Nothing` is no key,
  `Just` (psBal 0) is a retained flat row. Two distinct facts, never collapsed.

Honestly disclosed as a *writer* invariant — and only where a value's shape
genuinely cannot carry the property, with the audit surface exhibited and finite:
- **Conservation.** A `Map` cannot cheaply carry "sums to zero," and the document
  says so plainly (States.hs:528–540, States.tex §"Why It Is Right"): it attributes
  the property to the writer, never to the shape. The surface is bounded and I
  re-checked it — `applyMove` is the only function touching `psBal`, writing
  `negQty q` and `q` together so each move shifts the holding sum by `mempty`;
  `register`/`settle` never touch `ledgerPS`; from `emptyLedger` (sum 0) the
  sealed constructor makes the reach exhaustive. This is *seeing by a finite read*,
  not faith.
- **Append-only terms history.** A closure property over operations, not expressible
  in one immutable value's type; disclosed correctly. The seal is real: the .hs
  export list (lines 19–76) exports `Ledger` and `ProductTerms` *without* `(..)`,
  and omits the field selectors, so no outside code fabricates a shortened history
  or a non-conserving map. The .tex states the seal in-listing; the .hs delivers it.

## Totality and exhaustiveness

No case-arm wildcards. The `_` uses are tuple-component discards (`\(t, _) ->` in
`settle`; `(_, u')` in comprehensions) — exhaustive destructures, not catch-alls.
`apply` matches all three `Event` constructors, so a new event forces a new arm.
Every accessor is total; every refusing writer makes failure explicit in `Maybe`,
and the document is careful that this `Maybe` answers "is this unit known?", never
"did the balance hold?".

## What I checked and could not mechanize

GHC is not installed in this environment, so I could not run `-Wall -Werror` or the
GHCi milestones. The totality/exhaustiveness/seal claims are verified by reading,
which is what the lens turns on. Wiring a warnings-as-errors compile into CI would
mechanize Level 1; nothing I can read suggests it would fail. I do not treat this as
residue, because the verdict is about type-visibility, which reading settles.

## Two non-blockers I considered and discharged

- **Orphan position** (a `(w,u)` in `ledgerPS` whose `u` is absent from
  `ledgerUnit`). The store type permits it; `applyMove`'s `Map.member` gate plus the
  seal plus the absence of any `Map.delete` make it unreachable, and the gate is
  visible in the listing (States.hs:511). It is also not load-bearing — `position`
  and `netBal` read `ledgerPS` without needing registration — so it is a fact that
  happens to hold, not a relied-upon invariant left undisclosed.
- **The empty fourth cell** (a (holder, unit) correctable definition). Its absence
  is a minimality/completeness argument in prose (§"Why Three"), not a type
  invariant — and rightly so: one cannot type-enforce the absence of a map one did
  not build. This is justification, not an illegal-state claim, so the lens does not
  bind it.

## Conclusion

A reader new to the problem can, from the types plus a bounded set of named
writers, see that every illegal state the document cares about is either unspellable
or unreachable-by-an-exhibited-argument. Nothing load-bearing is taken on faith.
The bar is met.
