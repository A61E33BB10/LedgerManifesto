# minsky — Round 19 — States.tex / States.hs

## Verdict: OBVIOUS

## Bar

Does each illegal state the design relies on excluding become *visibly* impossible in the
shape a first-time reader reads — sees it, does not take it on faith? Where a property is
not type-carried, is it disclosed as such with a complete, total argument over the reachable
states, so the reader follows a short proof rather than trusts a writer?

## What changed since Round 18

`States.hs` is byte-for-byte the file I cleared in R17/R18 (mtime 13:37, unchanged).
`States.tex` was edited after my R18 review (mtime 14:05 vs 13:59). The edit reworked the
Position paragraph and added a footnote (tex:229–234) explaining *why* `psHwm` keeps the
`Qty` group while `Price` strips it. I re-read both files in full and re-checked every seam
an edit could reopen: the HWM deferral (my standing R11–R16 concern), conservation framing,
and the shape/writer split. None reopened; the edit strengthens the HWM account rather than
weakening it.

The new footnote (tex:229–234) is consistent with `States.hs` (hs:580–593): both say `psHwm`
is `Qty` to match its source, the file leans on *none* of `Qty`'s group structure for it, and
the file "claims no aggregate over holders for it." No committing aggregate language survives
in either artifact. The two files state one design.

## Type-carried and visible — the illegal state cannot be written

The reader sees these in the *shape*, not on a writer's word:

- **Price present exactly when active.** `data Lifecycle = Listed | Active Price`
  (tex:200 / hs:258). "active-but-unpriced" and "listed-but-priced" are unspellable;
  `settlementPrice` (hs:293–295) is exhaustive over exactly the two reachable constructors,
  no swallowing wildcard.
- **Terms never versionless.** `newtype ProductTerms = ProductTerms (NonEmpty TermsVersion)`,
  constructor withheld (tex:216 / hs:333, exported bare hs:47). "registered but versionless"
  is unrepresentable; `currentTerms = NE.last` is total — no `Maybe`.
- **Terms/status co-present or both absent.** One entry is the pair
  `Map UnitId (ProductTerms, UnitStatus)` (tex:259 / hs:437). "in terms but not status" is
  excluded by the shape of the entry, not a policed invariant (tex:244–256 / hs:407–418).
- **Two holders of one unit are two keys.** `Map (WalletId, UnitId) PositionState`
  (tex:260 / hs:438), derived from the buyer/seller divergence (tex:111–114 / hs:142–144).
- **A move is two cancelling legs from one quantity.** `Move` carries a single `Qty`
  (tex:297 / hs:512); the legs `negQty q` / `q` are built inside `applyMove` and net to
  `mempty` per wallet (hs:533–554). I re-verified the netting by hand: `from /= to` gives
  `{from: -q, to: +q}` summing to zero; `from == to` collapses to `{from: 0}` and is skipped
  by `writeNet`'s `d == mempty` guard; `q == 0` skips both. No phantom row, conservation
  intact in every branch.
- **Exhaustive dispatch.** `apply` covers all three `Event` constructors (tex:361–364 /
  hs:704–707), no wildcard — a future event class fails to compile rather than fall through.

## Disclosed as writer/seal invariants — argued, not dressed as shape

The design is candid that three properties are *not* type-carried, and the `.tex` (tex:340)
and `.hs` (hs:806–822) both name which is which. Each carries a bounded, total argument over
the reachable ledgers:

- **Conservation.** tex:340 opens "an invariant of the writer, not the store type, which can
  hold a non-conserving assignment." `applyMove` is the only door to `psBal` and writes two
  inverse legs; `register`/`settle` touch only `ledgerUnit`; the sealed constructor + withheld
  selectors leave no other door; from `emptyLedger` (sum zero) every reachable ledger conserves
  (tex:340–349 / hs:565–593).
- **Append-only terms history.** `register` refuses a present unit; the withheld constructor
  admits no hand-built short history (tex:206–213 / hs:343–350, 465–470).
- **Unregistered-unit gate.** `applyMove` and `settle` refuse a unit the stream never
  introduced (tex:312–318 / hs:556–563).

The seal these rest on is real and visible: `Ledger`, `ledgerUnit`, `ledgerPS` exported
without constructor or selectors (hs:61–67); tex:250–254 spells out that record update through
a selector would otherwise install a non-conserving map without naming the constructor. The
reader verifies three concrete things — the export list seals the type, the sole balance-writer
writes inverse legs, `emptyLedger` starts at zero — and composes them by a short total
argument. That is a sealed-abstract-type "by construction" guarantee, the standard mechanism;
it is not faith. The bar cannot demand "sums to zero" be expressed in a `Map` type — it is not
expressible in Haskell — and the design uses the strongest mechanism that is, then discloses
the residual argument honestly (hs:806–822).

## The two standing flags are not residue under my bar (held R11–R19)

- **`psHwm :: Qty` lets `foldMap psHwm` typecheck (jane-street-cto / milewski).** A
  should-strengthen, not residue: the design relies on excluding no cross-holder HWM sum, makes
  "no aggregate claim at all," and `netBal` folds `psBal` alone (hs:599–600 / tex:352–353).
  An invariant the design does not rely on is not an illegal state it must exclude. The new
  footnote (tex:229–234) now *explains* the choice — `psHwm`'s algebra is the out-of-scope
  writer's to fix, so stripping the group would prejudge it — so the reader sees the reasoning
  rather than taking the `Qty` typing on faith. This improves on R18.
- **Multi-instrument reification ("three homes, no fourth").** Explicitly conditional: shown
  for one mandate (n=1), "assumed here, not proved" for the multi-instrument case
  (tex:148–152 / hs:419–434). A basis-completeness claim marked conditional, not an
  illegal-state-representability claim. Not my residue.

## Non-blocking (clarity nits for STYLUS, not illegal-state defects)

`Move` and `TermsVersion` shown positional in `.tex` (tex:216, 297) but record-syntax in
`.hs` (hs:329, 512); `settlementPrice`/`productTerms`/`unitStatus`/`netOf`/`transfer` appear
only in `.hs`. Same types either way; the `.tex` declares its listings a slice with elisions
(tex:90–95, 161–162). No meaning diverges, so a reader handed both does not backtrack on a
contradiction.

## Residue

None.
