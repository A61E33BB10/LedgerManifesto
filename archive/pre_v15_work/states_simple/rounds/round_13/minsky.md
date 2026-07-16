# minsky — Round 13 — States.tex / States.hs

## Verdict: OBVIOUS

## Lens

Do the types make each illegal state *visibly* impossible — a first-time reader
sees it in the shape, not on faith? And where a fact is *not* carried by a type,
is it disclosed as a writer/seal discipline rather than disguised as a shape?

## What I re-checked this round

`States.tex` was edited at 12:57 (after my R12 pass at 12:48); `States.hs` is
unchanged since 12:33. So the live question for R13 is whether the post-R12 prose
edit to the .tex introduced any overclaim — a writer-invariant dressed as a
type-shape, or a representable illegal state asserted impossible. I re-read the
whole .tex against the .hs and re-audited the seal in the export list.

## Type-carried claims — each visible in the shape, verified against .hs

- `data Lifecycle = Listed | Active Price` (tex:209, hs:258): "active with no
  price" and "listed yet priced" are both unspellable; the price rides on the
  constructor. One line, no two-field lockstep. ✓
- `newtype ProductTerms = ProductTerms (NonEmpty TermsVersion)` (tex:227,
  hs:333), constructor unexported (hs export list lacks `(..)`, line 47):
  "registered but versionless" is unrepresentable; no importer can lay a fresh
  short history. ✓
- `Map UnitId (ProductTerms, UnitStatus)` (tex:269, hs:437): terms/status
  co-presence is the tuple — one entry carries both halves or neither. ✓
- `(WalletId, UnitId)` key (tex:270, hs:438): buyer +1000 and seller −1000 are
  two keys, cannot collapse. ✓
- `Move UnitId WalletId WalletId Qty` (tex:307, hs:512): one `Qty`, so a
  two-independent-quantity unbalanced move is not a sentence the type admits. ✓
- `Price` newtype with no `Monoid`/`Group` (tex:208, hs:249): never summed into a
  balance. ✓

The .tex listings are faithful slices of the .hs declarations (deriving and
record-field sugar elided, as tex:170 states); same constructors, same arity,
same single `Qty` on `Move`. No declaration diverges.

## Seal re-audited (the load-bearing, file-checkable fact)

`Ledger` exported bare (hs:42); selectors `ledgerUnit`/`ledgerPS` absent from the
export list and confirmed present *only* in the module body (hs:437,438,467,469,
470,486–488,499,502,505,521,522,598). With constructor and selectors hidden, no
importer can build or record-update a `Ledger`, so the record-update bypass the
.tex names (`l { ledgerPS = ... }`, tex:262) is genuinely closed — that update
needs the field selector in scope, and it is not. Accurate, not asserted. The
fully-open exported types (`PositionState(..)`, `UnitStatus(..)`,
`Lifecycle(..)`, `Qty(..)`) are no leak: a value can be built but none can be
*installed* into a `Ledger` except through the sealed writers. ✓

## Facts not carried by a type — disclosed as discipline, not shape

- Conservation: tex:350 states plainly "Conservation is an invariant of the
  writer, not the store type, which can hold a non-conserving assignment." The
  reachability argument is sound and bounded: `applyMove` is the only writer of
  `psBal`; it nets per wallet and writes deltas summing to `negQty q <> q =
  mempty` (the `writeNet` skip of `mempty` removes only zero entries, so the sum
  is undisturbed); `register`/`settle` never touch `psBal`; base case
  `emptyLedger`; the seal makes the reach exhaustive. I traced `netDeltas` +
  `writeNet` (hs:533–554) for from≠to, from==to, and q=0 — all conserve and the
  zero/self-move cases write no phantom row, matching tex:322–328. The intro's
  "hold by construction" (tex:48) and the seal paragraph's "keep conservation
  true by construction" (tex:263) are both disambiguated by sec:right on the
  facing page, so no reader is left thinking a type enforces it. ✓
- Append-only terms history: disclosed as the unexported constructor + `register`
  refusing a present unit (tex:215–222), not as a type. ✓
- Registration gate (a position can exist only for a registered unit): the store
  type *can* represent a position for an unregistered unit; the .tex never claims
  otherwise and presents `applyMove`'s `Maybe` as guarding input only (tex:322–
  328). ✓
- Never-held vs held-and-flat (tex:330–343): a consequence of the writer never
  deleting a row, presented descriptively; the `Map` type permits deletion and
  the doc does not claim it forbids it. ✓
- No fourth home: explicitly *conditional* on the reification (every
  wallet-economic fact is a position in some held unit), proved for n=1 (one
  mandate) and assumed for the multi-instrument case (tex:66–67, 100–101, 144–
  161). Argued as reasoning, the conditional stated before the conclusion, never
  type-claimed. ✓

## Overclaim check on the post-R12 prose edit

The 2×2 table (tex:82–91) names broader categories than the modeled types carry
(Status: weights, benchmark level; Position: high-water mark), but tex:93–98
explicitly says "the listings model a slice," names exactly what is modeled
(lifecycle stage carrying settlement price) and what is elided (weights,
benchmark level), and the authorship-axis discussion (tex:71–98) is domain
reasoning for *where* a fact sits, not a claim about what a type enforces.
`psHwm` keeps its honest narrow statement — no zero-sum invariant, no aggregate
claimed (tex:240–243, hs:583–591). No "peak exposure"-style overclaim reappears.

## Exhaustiveness / totality

`apply` (tex:373–375, hs:702–705) and `settlementPrice` (hs:294–296) match every
constructor with no swallowing wildcard — a new `Lifecycle`/`Event` case fails to
compile. `currentTerms` total by `NonEmpty`. All writers total in `Maybe`;
`replay = foldM` over a pure total step. ✓

## Why OBVIOUS

Every fact the .tex presents as carried by the types is carried by the types, and
a first-time reader sees each in the shape: price-on-`Active`, `NonEmpty` terms,
the co-present pair, the dual key, the single-`Qty` move, `Price` without a group.
Every fact not carried by a type — conservation, append-only history, the
registration gate, never-held/held-and-flat, no-fourth-home — is disclosed as a
writer/seal discipline or a stated, bounded assumption, never dressed as a shape.
The seal is intact and checkable in the export list. The post-R12 .tex edit
refined rationale without weakening one type guarantee or making one illegal
state representable. Obviously right.

## Residue

None.
