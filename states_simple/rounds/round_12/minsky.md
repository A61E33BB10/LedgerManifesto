# minsky — Round 12 — States.tex / States.hs

## Verdict: OBVIOUS

## Lens

Do the types make the illegal states *visibly* impossible — a first-time reader
sees it in the shape, not on faith? And, where a fact is *not* carried by a type,
is it disclosed as a writer/seal discipline rather than disguised as a shape?

## What changed since R11, and whether it touches my lens

The files were edited after my R11 pass (States.hs 12:33, States.tex 12:42; the
round_12 dir predates both). The edits are prose/rationale refinements. The
*declarations* are byte-for-byte the same as the version I passed in R10/R11:
`Qty`, `Price`, `Lifecycle`, `UnitStatus`, `TermsVersion`, `ProductTerms`,
`PositionState`, `Ledger`, `Move`, `Event`. Same fields, same constructors. So
every type-carried guarantee I verified before still stands; I re-checked each
shape claim against the current prose for fresh overclaims and found none.

## Shape-enforced, visible without running anything

- `data Lifecycle = Listed | Active Price` (tex:205, hs:258): "active with no
  price" and "listed yet priced" are both unspellable — the price rides on the
  constructor, no two-field lockstep. The reader sees it in one line. ✓
- `newtype ProductTerms = ProductTerms (NonEmpty TermsVersion)` (tex:222,
  hs:333), constructor exported *without* `(..)` (export list hs:47):
  "registered but versionless" is unrepresentable by the `NonEmpty` shape, and
  the unexported constructor blocks a hand-built short history. ✓
- `Map UnitId (ProductTerms, UnitStatus)` (tex:266, hs:437): terms/status
  co-presence is the tuple — one entry carries both halves or neither, no "terms
  without status" value to police. ✓
- `(WalletId, UnitId)` key (tex:266, hs:438): two holders of one unit are two
  keys; the buyer's +1000 and seller's −1000 cannot collapse to one number. ✓
- `Move UnitId WalletId WalletId Qty` (tex:305, hs:512): one `Qty` field, so an
  unbalanced move (two independent quantities) is not a sentence the type lets
  you write. ✓
- `Price` as its own newtype with no `Monoid`/`Group` (tex:204, hs:249): a price
  can never be summed into a balance. ✓

## Seal re-audited (the load-bearing, file-checkable claim)

`Ledger` is exported without `(..)` and its selectors `ledgerUnit`/`ledgerPS`
are absent from the export list (hs:61). I confirmed both selectors occur only
in the module body. With the constructor and selectors hidden, no importer can
build a `Ledger` or record-update one, so the seal paragraph (tex:249-261;
hs:441-448) is auditable, not asserted. The exported fully-open types
(`PositionState(..)`, `UnitStatus(..)`, `Lifecycle(..)`, `Qty(..)`) are no leak:
a value of any of them can be built, but none can be *installed* into a `Ledger`
except through the sealed writers. `ProductTerms` is the one that must stay
sealed for append-only, and it is. ✓

## Facts not carried by a type — disclosed as such, never as shape

- Conservation: tex:348 states plainly "Conservation is an invariant of the
  writer, not the store type, which can hold a non-conserving assignment." The
  reachability argument (only `applyMove` writes `psBal`; it writes net deltas
  summing to `negQty q <> q = mempty`; `register`/`settle` never touch `psBal`;
  base case `emptyLedger`; seal makes the reach exhaustive) is sound and bounded.
  The "by construction" wording at tex:260 is reconciled by tex:348 on the very
  next page, so no reader is led to think a type enforces it. ✓
- Append-only terms history: disclosed as `register` refusing a present unit plus
  the seal, not as a type (tex:211-218, hs:343-350). ✓
- Registration gate (position ⟹ registered): the store type *can* represent a
  position for an unregistered unit; the document never claims otherwise and
  presents `applyMove`'s `Maybe` as guarding input (tex:320-326, hs:556-563). ✓
- No fourth home: rests on the reification that every wallet-economic fact is a
  position in some held unit, explicitly *conditional* and proved only for n=1
  (one mandate), assumed for the multi-instrument case (tex:98-99, 143-158;
  hs:420-434). It is argued as reasoning, never type-claimed. Under my lens this
  is not disguised faith — the conditional is stated before the conclusion. ✓

## Exhaustiveness / totality

`settlementPrice` (hs:294-296) and `apply` (hs:702-705, tex:370-373) match every
constructor with no swallowing wildcard — a new `Lifecycle`/`Event` case would
fail to compile. `currentTerms` is total by `NonEmpty`. All writers total in
`Maybe`. `replay = foldM` over a pure total step. Clean. ✓

## The R12 prose refinements introduce no overclaim

The Status/Position cells (tex:83-86) list facts the modeled types only partially
carry (settlement price, weights, benchmark level; held quantity, high-water
mark), but tex:91-93 explicitly says "the listings model a slice," with weights,
benchmark level, and entry NAV elided. So the broader category names are not
presented as type-guaranteed — the file says which fields it models and which it
elides. The authorship-axis rationale (tex:69-96) is domain reasoning for *where*
a fact sits, not a claim about what a type enforces. `psHwm` carries the honest
narrow statement: no zero-sum invariant, no aggregate claimed (tex:238-239,
hs:583-591). No "peak exposure"-style overclaim has reappeared.

## Why OBVIOUS

Every fact the document presents as carried by the types *is* carried by the
types, and the first-time reader sees each one in the shape: price-on-`Active`,
`NonEmpty` terms, the co-present pair, the dual key, the single-`Qty` move. Every
fact not carried by a type — conservation, append-only history, the registration
gate, no-fourth-home — is disclosed as a writer/seal discipline or a stated
assumption resting on a bounded, file-auditable argument over reachable ledgers,
never dressed as a shape. The seal is intact and checkable in the export list.
The R12 edits refined rationale without weakening a single type guarantee or
introducing a representable illegal state. From my lens, the solution is
obviously right.

## Residue

None.
