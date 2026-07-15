# MINSKY — Round 4 — States.tex / States.hs

## Verdict: NOT-YET

My lens: the types must make the illegal states *visibly* impossible — the reader
sees it, not follows a proof to be persuaded of it.

## What is genuinely obvious (and excellent)

The document is exemplary on most of my axes, and I want that on record so the
NOT-YET is not mistaken for a global complaint:

- **Priced-iff-active is unrepresentable by shape.** `data Lifecycle = Listed |
  Active Price` makes "active with no price" and "listed yet priced" unspellable.
  The reader *sees* it; `settlementPrice` is total with two explicit cases, no
  wildcard. This is the gold standard the rest of the file is measured against.
- **Versionlessness is unrepresentable.** `NonEmpty TermsVersion` makes
  "registered but versionless" unspellable; `currentTerms` is total, no `Maybe`.
- **Exhaustiveness / totality.** No wildcard patterns anywhere. `apply` matches
  all three `Event` constructors explicitly; every accessor is total; every
  refusing writer makes failure explicit in `Maybe`. Refactoring is fearless.
- **Conservation is correctly *disclosed*, not faked.** I checked the proof and
  it is airtight: `applyMove` is the sole writer of `psBal` in a sealed `Ledger`
  (grep confirms — `register`/`settle` never touch `ledgerPS`), it writes
  `negQty q` and `q` together, so each move changes the holding sum by `mempty`;
  from `emptyLedger` (sum 0) every reachable ledger conserves, and the hidden
  constructor closes the reach. A `Map` cannot cheaply carry "sums to zero," so
  disclosing this as a writer invariant rather than a type guarantee is the right
  pragmatic call (my principle #7). I do not fault it.

## The residue (located, actionable)

**Terms/status coherence is left as a sealed-constructor proof when the shape can
carry it for free — by the document's own stated rule.**

The document commits to a sharp rule (States.hs lines 276–280): *prefer the shape
that makes the illegal state unrepresentable whenever the shape can afford it;
disclose a writer invariant only when it cannot.* It applies that rule correctly
to priced-iff-active (shape affords it → unrepresentable) and to conservation
(shape cannot → disclosed). It then does **not** apply it to coherence, where the
shape *can* afford it.

The invariant "a unit is in the terms map exactly when it is in the status map"
(States.hs lines 404–410; States.tex lines 77–80, 238–244) is currently enforced
by: constructor hidden + enumerate the four writers + check each preserves
PT-keys == US-keys. That is a proof the reader must *follow across the export list
and four function bodies*, not an impossibility the reader *sees*. "In terms but
not status" (and vice versa) is a perfectly spellable `Ledger` value; only the
sealed boundary keeps it out of reach.

This is avoidable cheaply, and the document half-admits it: it says terms and
status are "two homes, not two keys ... separated by authorship, not by what they
key on" (States.tex lines 75–76) — i.e. they *share the unit key*. Collapse the
two unit-keyed maps into one:

```haskell
ledgerUnit :: Map UnitId (ProductTerms, UnitStatus)   -- replaces ledgerPT + ledgerUS
```

Now "in terms but not status" is structurally unspellable: one key, both
components or neither. `register` inserts the pair; `settle` does `Map.adjust`
over the `snd`. The append-vs-overwrite *disciplines* stay intact — they live in
the component value types (`NonEmpty` vs single value), not in the outer map — so
this does not weaken the "third home, not second" argument of §Why Three; it only
moves coherence from a proof you follow to a shape you see. After the merge the
coherence invariant becomes a tautology (one key set), and the existing
membership guards in `register`/`settle`/`applyMove` no longer rely on an
unstated cross-map equality.

**Location:** `States.hs` lines 399–401 (two separate unit-keyed maps) and the
coherence argument at lines 404–410; mirrored in `States.tex` lines 239–244 and
77–80.

**Why it bites my lens specifically:** for this invariant the reader takes
correctness on faith in a (correct) enumeration-of-writers proof, where a free
shape would let them see it — and the document's own rule says to prefer the shape
in exactly this case.

## Secondary (not the basis of the verdict, worth a line)

The step-4 teaching API `Balances` (transparent type synonym), `transfer`, and
`netOf` are exported (States.hs lines 26–29) and fully open, disconnected from the
sealed `Ledger`. A reader could mistake `transfer` for the real move API and build
a non-conserving `Balances` with it. These are pedagogical scaffolding superseded
by `applyMove`; consider not exporting them, or marking them as the disconnected
teaching artifacts they are. This is a clarity smell, not a correctness gap.

## To flip to OBVIOUS

Merge `ledgerPT` and `ledgerUS` into one unit-keyed map so terms/status
co-presence is structural, applying the file's own "prefer the shape when it can
afford it" rule. After that, every invariant in the file is either seen directly
in the type (priced-iff-active, non-empty terms, coherence) or honestly disclosed
as the one writer invariant a `Map` genuinely cannot carry (conservation) — and
the reader takes nothing load-bearing on faith.
