# minsky — Round 20 — States.tex / States.hs

## Verdict: OBVIOUS

## Bar

Does each illegal state the design relies on excluding become *visibly* impossible in the
shape a first-time reader reads — sees it, does not take it on faith? Where a property is
not type-carried, is it disclosed as such with a complete, total argument over the reachable
states, so the reader follows a short proof rather than trusts a writer?

## What changed since Round 19

`States.hs` is byte-for-byte the file I cleared in R17–R19 (mtime 13:37, unchanged). I re-read
it in full; every type-carried guarantee and every disclosed writer/seal invariant stands
exactly as in R19.

`States.tex` was edited after my R19 review (mtime 14:15 vs my 14:09). Two edits, both prose
promotion/ordering with no change to any declared type or shape:

1. **The one rule is named, and the two axes are derived as its two failure modes**
   (tex:61–68, with single-source-of-truth added to the intro goal list at tex:47–50). This is
   exactly dirac's R19 ask. "Each economic fact has exactly one home and one writer ... A fact
   fails the rule in only two ways: keyed wrong ... authored wrong ..." The holder-question and
   authority-question now read as the two ways one truth can split, so "exactly two axes, three
   homes" is *argued* (there is no third way for one fact to be unfaithful) rather than observed.
   I checked the dichotomy is honestly a design-completeness argument, not dressed as a type
   guarantee — it is meta-reasoning about the basis, and the doc presents it as such.

2. **The psHwm footnote is cut and compressed into the body line** (tex:232–240), exactly
   chris-lattner's R19 fix. The psHwm rationale now rides as a single clause ("keeps the full
   `Qty` type rather than a stripped newtype like `Price` because its operation is not settled
   here — no aggregate over holders is claimed"), consistent with hs:580–593. The `Price`
   group-stripping rationale, which is load-bearing, stays (tex:204).

Neither edit reopens a seam. I re-checked the HWM account, the conservation framing, the
shape/writer split, and tex/hs consistency: none regressed.

## Type-carried and visible — the illegal state cannot be written

The reader sees these in the *shape*, re-verified this round against the unchanged hs:

- **Price present exactly when active.** `data Lifecycle = Listed | Active Price`
  (tex:208 / hs:258); `settlementPrice` exhaustive over the two reachable constructors, no
  swallowing wildcard (hs:293–295).
- **Terms never versionless.** `ProductTerms (NonEmpty TermsVersion)`, constructor withheld
  (tex:225 / hs:333, exported bare hs:47); `currentTerms = NE.last` total, no `Maybe`.
- **Terms/status co-present or both absent.** One entry is the pair
  `Map UnitId (ProductTerms, UnitStatus)` (tex:265 / hs:437); "in terms but not status"
  excluded by the entry shape.
- **Two holders of one unit are two keys.** `Map (WalletId, UnitId) PositionState`
  (tex:266 / hs:438).
- **A move is two cancelling legs from one quantity.** `Move` carries one `Qty` (tex:303 /
  hs:512); legs `negQty q` / `q` built inside `applyMove`, netted per wallet, `writeNet`'s
  `d == mempty` guard skips self-moves and zero moves (hs:533–554). No phantom row; conservation
  intact in every branch (`from /= to`, `from == to`, `q == 0`).
- **Exhaustive dispatch.** `apply` covers all three `Event` constructors (tex:367–370 /
  hs:704–707), no wildcard.

## Disclosed as writer/seal invariants — argued, not dressed as shape

Candidly named as not type-carried (tex:346 / hs:806–822), each with a bounded total argument
over the reachable ledgers:

- **Conservation.** `applyMove` is the only door to `psBal`, writes two inverse legs;
  `register`/`settle` touch only `ledgerUnit`; sealed constructor + withheld selectors leave no
  other door; from `emptyLedger` (sum zero) every reachable ledger conserves (tex:346–360 /
  hs:565–600). The seal is real and exported bare (hs:61–67).
- **Append-only terms history.** `register` refuses a present unit; withheld constructor admits
  no hand-built short history (tex:214–221 / hs:343–350, 465–470).
- **Unregistered-unit gate.** `applyMove` and `settle` refuse a unit the stream never
  introduced (tex:318–324 / hs:556–563).

The new "one rule" framing (tex:61–68) is consistent with this split: it names the faithfulness
rule the writers/seal enforce, and does not claim conservation is type-carried.

## Standing flags — not residue under my bar (held R11–R20)

- **`psHwm :: Qty` lets `foldMap psHwm` typecheck.** A should-strengthen, not residue: the
  design relies on excluding no cross-holder HWM sum, makes "no aggregate claim at all," and
  `netBal` folds `psBal` alone. The compressed body clause (tex:232–240) now states the choice
  inline; the reader sees the reasoning rather than taking the `Qty` typing on faith.
- **Multi-instrument reification ("three homes, no fourth").** Explicitly conditional, shown for
  n=1, "assumed, not proved" for the multi-instrument case (tex:156–160 / hs:419–434). A
  basis-completeness claim marked conditional, not an illegal-state-representability claim.

## Non-blocking (clarity nits for STYLUS, not defects)

`Move`/`TermsVersion` shown positional in tex (tex:224, 303) but record-syntax in hs; a handful
of accessors appear only in hs. The tex declares its listings a slice with elisions (tex:98–99,
169–170); no meaning diverges.

## Residue

None.
