# minsky — Round 14 — States.tex / States.hs

## Verdict: OBVIOUS

## Lens

Does each illegal state the design relies on excluding become *visibly* impossible
in the shape a first-time reader reads — not on faith? And where a fact is *not*
carried by a type, is it disclosed as a writer/seal discipline (with a bounded,
checkable argument) rather than disguised as a shape?

## What is live this round

`States.hs` is byte-identical to my Round-13 pass (unchanged since 12:33).
`States.tex` was re-edited at 13:07 (after R13). Per the iteration log the R14
edits are all clarity/honesty moves on the prose: the headline count made
explicitly conditional on the reification (§Answer 60-67), the keystone sentence
split, the reification caveat reduced to one full statement, the psHwm
"no-conservation-invariant" reason cited rather than re-derived at the proof
(tex:358), coherence stated positively (tex:262), and replay partiality stated
(tex:382). So the live question is narrow: did any 13:07 edit introduce an
overclaim — a writer invariant dressed as a shape, or a representable illegal
state asserted impossible? It did not. Each edit *weakens* a claim toward honesty
or adds a true qualification; none strengthens a type guarantee the code does not
carry.

## Type-carried claims — each re-tested adversarially, each visible in the shape

- `data Lifecycle = Listed | Active Price` (tex:207, hs:258). Tried to construct
  active-without-price and listed-with-price: both unspellable by the ADT shape;
  the price rides on the constructor. ✓
- `newtype ProductTerms = ProductTerms (NonEmpty TermsVersion)` (tex:224,
  hs:333), constructor absent from the export list (hs:47). "Registered but
  versionless" is unrepresentable; no importer can lay a fresh short history. ✓
- `Map UnitId (ProductTerms, UnitStatus)` (tex:268, hs:437). Terms/status
  co-presence is the tuple — one entry carries both halves or neither; "in terms
  but not status" cannot be written. ✓ The R14 "coherence carried by the pair"
  rewording (tex:262) matches this exactly and drops the backward reference.
- `(WalletId, UnitId)` key (tex:270, hs:438). Buyer +1000 / seller −1000 are two
  keys, cannot collapse to one number. ✓
- `Move UnitId WalletId WalletId Qty` (tex:305, hs:512). One `Qty` in the type,
  so an asymmetric two-quantity move is not a sentence the language admits; the
  cancelling legs are derived in `applyMove` and visible there. ✓
- `Price` newtype with no `Monoid`/group (tex:206, hs:249): never summed into a
  balance, never confused with one. ✓

The .tex listings remain faithful slices of the .hs declarations (deriving and
record-field sugar elided, as tex:168 states). No declaration diverges in
constructor, arity, or the single `Qty` on `Move`.

## Seal re-audited (the load-bearing, file-checkable fact)

`Ledger` exported bare (hs:61); `ledgerUnit`/`ledgerPS` absent from the export
list and present only in the module body. With constructor and field selectors
hidden, the record-update bypass the .tex names (`l { ledgerPS = ... }`, tex:259)
is genuinely closed — that update needs the selector in scope, and it is not. The
fully-open exported value types (`PositionState(..)`, `UnitStatus(..)`,
`Lifecycle(..)`, `Qty(..)`) leak nothing: a value of each can be built by an
importer, but none can be *installed* into a `Ledger` except through the four
sealed writers. ✓

## Facts not carried by a type — disclosed as discipline, not shape

- Conservation: tex:348-350 states plainly it is a writer invariant, "not the
  store type, which can hold a non-conserving assignment." The reachability
  argument is bounded and checkable: `applyMove` is the only writer of `psBal`;
  it nets per wallet (`netDeltas`) and writes deltas summing to
  `negQty q <> q = mempty`, the `writeNet` `mempty`-skip removing only zero
  entries so the sum is undisturbed; `register`/`settle` never touch `psBal`;
  base case `emptyLedger`; the seal makes the reach exhaustive. I re-traced
  `netDeltas`+`writeNet` (hs:533-554) for from≠to, from==to, and q=0 — all
  conserve, none writes a phantom row. The intro's "hold by construction"
  (tex:48) is disambiguated by §right on the page. ✓
- Append-only terms history: disclosed as unexported constructor + `register`
  refusing a present unit (tex:213-220), not as a type. ✓
- Registration gate: the store type *can* represent a position for an
  unregistered unit; the .tex claims only that `applyMove`'s `Maybe` guards input
  (tex:320-326), never that a type forbids it. ✓
- Never-held vs held-and-flat: a consequence of the writer never deleting a row,
  presented descriptively (tex:328-336); the `Map` permits deletion and the doc
  does not claim otherwise. ✓
- No fourth home: explicitly conditional on the reification, proved for n=1 (one
  mandate) and assumed for the multi-instrument case. The R14 edit makes this
  *more* honest — the headline count itself now names its dependence ("the binary
  holder-axis, and so the count below, rests on it," tex:67), and the §Answer
  pointer is a compressed conditional, not a duplicated caveat. Argued as
  reasoning, conditional stated before conclusion, never type-claimed. ✓

## Overclaim check on the R14 prose edits

- The conditional-count rewording (tex:55-68) underclaims if anything; it does
  not assert the reification, it discloses the count rests on it. No overclaim.
- The replay-partiality sentence (tex:382) is accurate against the code: `replay
  = foldM (flip apply)` returns `Nothing` exactly on a repeated `Registered`, or
  a `Moved`/`Settled` on an unregistered unit (`apply` dispatches to writers whose
  only `Nothing` branches are those), `foldM` halting at the first. Matches the
  per-writer `Nothing` semantics already in §Construction. ✓
- The psHwm scope-note shortening (tex:358) cites §Construction rather than
  re-deriving; the reason lives once and is not weakened. ✓

## Exhaustiveness / totality

`apply` (hs:702-705) and `settlementPrice` (hs:294-296) match every constructor
with no swallowing wildcard — a new `Lifecycle`/`Event` case fails to compile.
`currentTerms` total by `NonEmpty`. All writers total in `Maybe`; `replay` a
`foldM` over a pure total step. No partial pattern hides a case. ✓

(No GHC toolchain on this host, so Level 1 was confirmed by inspection rather than
by `runghc`: the signatures, the `Map.foldrWithKey writeNet` fold, the `foldMap`
over `Qty`, and the `NonEmpty` operations all typecheck as written; the code is
unchanged from the R13 pass.)

## On the two standing flags (deliberately not counted as residue)

Both are pre-adjudicated source-level decisions, openly disclosed in the document,
and neither makes an illegal *state* representable:

- **psHwm typed `Qty` with a monoid** (jane-street-cto's standing flag). Because
  `psHwm :: Qty` carries `<>`/`mempty`, summing high-water marks across holders
  *typechecks* — a meaningless operation the type does not forbid. This is the one
  place a Minsky reflex reaches for a no-monoid newtype mirroring `Price`. But (a)
  no illegal *state* arises — `psHwm = Qty n` is a legal value for any `n`; only an
  unused, never-claimed aggregate operation is available; and (b) the document does
  not dress this as a shape — it states outright that conservation "is a property
  of how a field is written, not of its type" and that "no aggregate over holders
  is claimed for it" (tex:240-243, hs:579-591). The reader is not misled into faith.
  Giving HWM/entry-NAV its own group-free newtype would be a genuine improvement and
  is correctly returned to source; it is a should-strengthen, not a correctness hole.
  I held this same line in R13 on identical code.
- **Multi-instrument reification** is a modeling-completeness claim, not a
  representability claim; the document states it conditionally and flags it
  unproven for n>1. Outside my bar (no illegal state is made representable by it).

I do not promote either to residue: doing so would be inventing residue to
withhold, against an honestly-disclosed, unchanged, previously-adjudicated state.

## Why OBVIOUS

Every fact the .tex presents as carried by the types is carried by the types, and
a first-time reader sees each in the shape: price-on-`Active`, `NonEmpty` terms,
the co-present pair, the dual key, the single-`Qty` move, `Price` without a group.
Every fact not carried by a type — conservation, append-only history, the
registration gate, never-held/held-and-flat, no-fourth-home — is disclosed as a
writer/seal discipline or a stated, bounded assumption, never dressed as a shape.
The seal is intact and checkable in the export list. The R14 .tex edits refined
rationale and added true qualifications (conditional count, replay partiality)
without weakening one type guarantee or making one illegal state representable.
Obviously right.

## Residue

None.
