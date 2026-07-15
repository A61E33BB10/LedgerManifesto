# minsky — Round 9 — States.tex / States.hs

## Verdict: NOT-YET

## Lens

Do the types make the illegal states *visibly* impossible — the reader sees it,
not takes it on faith?

## What is genuinely airtight (and visible)

The five "carried by shape" claims hold and a competent reader sees each without
running anything:

1. **Priced iff active.** `data Lifecycle = Listed | Active Price`. `Listed`
   carries no price, `Active` carries exactly one. "Active-with-no-price" and
   "Listed-but-priced" are unspellable. Visible.
2. **No versionless terms.** `ProductTerms (NonEmpty TermsVersion)`, constructor
   unexported, `register` lays down `tv :| []`. ≥1 version by type. Visible.
3. **Terms/status co-present or both absent.** One `Map` entry holds the pair
   `(ProductTerms, UnitStatus)`; an entry carries both halves or neither. The
   invariant is the *shape*, not a policed promise. Visible.
4. **Balance keyed by (wallet, unit).** `Map (WalletId, UnitId) ...`. Two holders
   = two keys. Visible.
5. **A move is one quantity.** `Move UnitId WalletId WalletId Qty` admits a single
   `Qty`; the two legs are necessarily `negQty q`/`q` derived from it. An
   independent unbalanced pair is not expressible. Visible.

The three writer/seal facts (conservation, append-only history,
unregistered-unit gate) are honestly disclosed as *not* type-enforced, with a
bounded soundness argument resting on the hidden `Ledger` constructor +
unexported `ledgerPS`/`ledgerUnit` selectors. This is correct Minsky pragmatism
(P7): where a `Map` cannot cheaply carry "sums to zero," disclose the writer
invariant rather than fake it. The §10 / §why-right split between "shape
guarantees" and "writer guarantees" is exactly the discipline I want, and the
"only door that writes the balance writes it balanced" reach is auditable in one
file. None of this is taken on faith *unknowingly*.

So on every fact the document *names*, it is honest. The residue is in a case it
does **not** name.

## Residue 1 (primary, located, actionable) — the self-move conjures a phantom holder

`Move UnitId WalletId WalletId Qty` makes `from == to` representable, and
`applyMove` does not reject or net it. Trace `applyMove (Move u w w (Qty 1000))`
for a wallet `w` that never held `u` (u registered):

- `leg w (negQty q)`: `cur = zeroP`, writes `(w,u) -> psBal = 0 + (-1000) = -1000`.
- `leg w q` on that map: `cur` finds the `-1000` row, writes `(w,u) -> psBal = 0`.
- Result: `position l' w u = Just (PositionState{psBal=0})` — **held-and-flat**,
  conjured from **never-held**.

This directly defeats the never-held vs held-and-flat distinction the file
declares *load-bearing* (settlement entitlement, wash-sale lookback;
`States.hs` lines 521–525, 333–341 of `States.tex`). The file goes to great
length to stop the **twin** case — a `Qty 0` move — from conjuring exactly such a
phantom row (`leg`'s `d == mempty` guard, with a paragraph of justification). The
asymmetry is the bug: a zero move nets to `mempty` and is suppressed, but a
*self-move* also nets to `mempty` for `w` and is **not** suppressed, because the
two legs are applied sequentially rather than netted per wallet. The same
principle the authors invoke ("a delta of `mempty` conjures no row") is honored
for the literal-zero case and silently violated for the from==to case.

The file's stated definition "held = named in a nonzero move" makes this
*consistent with the definition* — but the definition is never tested against the
self-move, and for the economic intent behind the distinction (a real
acquisition/disposal) a self-transfer is not a holding. An unconsidered case in a
load-bearing distinction is precisely the wildcard my lens exists to catch.

- Location: `States.hs` `applyMove` / `data Move` (and `States.tex` §Construction,
  "A move on the ledger is a transfer, lifted", lines 306–331).
- Fix (any one, then state it): net the per-wallet delta before deciding to write
  a row (so a self-move, like a zero move, writes nothing); or reject `from == to`
  at admission; or, if self-moves are intended to mark a wallet held, say so and
  reconcile it with the zero-move treatment. As written the file claims to guard
  the distinction and does not.

## Residue 2 (secondary; flagged by the authors, but still a faith-item for the core claim)

The central structural answer — three homes, **no fourth**, two keys carry all
economic state — rests entirely on: "a relationship spanning several instruments
is itself a unit issued to its parties" (`States.tex` §The Answer, lines 60–64;
§Why Three managed-account, lines 166–172). The authors explicitly mark it
"assumed, not established here" and discharge it for *one* relationship (the
mandate). It is not type-enforceable in this file. The disclosure is honest, so
the reader does not take it on faith *unknowingly* — but the "no fourth home"
conclusion the whole answer turns on is conditional on an unproven universal, and
"obviously right" cannot rest on a universal proved for n=1.

- Location: `States.tex` §The Answer (lines 60–75) and §Why Three (lines 166–172).
- Actionable: either establish the reification covers every multi-instrument
  relationship, or state "no fourth home" as conditional in the answer's headline,
  not only in the body.

## Why not OBVIOUS

The shape-guarantees are flawless and the writer-guarantees are honestly
disclosed. But Residue 1 is a representable input the file did not consider,
producing a state its own load-bearing distinction calls illegal, while the file
loudly guards the identical-in-kind zero-move case — an inconsistency a reader
catches only by tracing `from == to`, not by reading the prose, which asserts the
distinction is protected. That is a fact the reader is asked to take on faith and
which fails. NOT-YET.
