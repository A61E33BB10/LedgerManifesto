# jane-street-cto — Round 19 — States.tex

**Verdict: OBVIOUS**

## What I checked

- Read `/home/renaud/Ledger/states_simple/States.tex` in full.
- Verified every listing against `/home/renaud/Ledger/states_simple/States.hs`
  function-by-function (`applyMove`, `netDeltas`, `writeNet`, `register`, `settle`,
  `position`, `netBal`, `apply`, `replay`, the `Ledger`/`PositionState`/`Move`/`Event`
  declarations, the `Qty` group, `ProductTerms` NonEmpty). The prose listings are a
  faithful slice of the source; nothing is misquoted.

## Correctness — sound

- **2×2 placement.** Two axes (holder-dependence; authority of record) are each binary,
  so the table is exhaustive once the axes are accepted, and both axes are motivated from
  scope + single-source-of-truth rather than asserted. Three occupied cells, one empty,
  consistent throughout.
- **Empty cell.** Argued concretely (no authority issues a fact about one holder's
  position) and the obvious counterexample (managed account) is dismantled correctly by
  reducing it to a (client, mandate-unit) position. Multi-instrument relationships are
  excluded by explicit scope, not hand-waved.
- **Conservation.** `applyMove` is the sole `psBal` writer (confirmed by grep over the
  source); it lays down `negQty q <> q = mempty`; `register`/`settle` touch only
  `ledgerUnit`. Induction from `emptyLedger` is valid. The self-move / zero-move cases
  net to `mempty` and write no row — verified through `netDeltas`/`writeNet`. The seal
  argument is precise: the document correctly notes conservation is a *writer* invariant
  the store type cannot enforce, and that an exported selector would reopen the door via
  record update. No overclaim of type-level enforcement.
- **Replay.** `apply` is total (every writer returns `Maybe`, no partiality) and pure;
  determinism and the `foldM` short-circuit/checkpoint-split claim are standard and
  correct for the `Maybe` monad.
- **Maybe semantics.** The held / never-held / held-and-flat trichotomy is exact, and the
  "`Nothing` answers *is this unit known?*, never *did the balance hold?*" distinction is
  load-bearing and stated clearly.

## Overclaim check — clean

- `psHwm` is explicitly disclaimed: no aggregate over holders is claimed; the footnote
  justifies `Qty` (matching source) over a `Price`-style newtype because its operation is
  not settled in scope. Honest.
- "Illegal states unrepresentable" is backed by real instances (`Active Price` makes
  "active without price" unspellable; `NonEmpty` makes "versionless" unspellable; the
  pair makes "terms without status" unwritable). Conservation is *not* claimed as a type
  property — the document says so outright.

## Minor friction (non-blocking)

- "reifies / reification" is introduced in §The Answer as the central premise and its
  explanation is deferred to §Why Three. The deferral is signposted with explicit
  forward references and §Why Three delivers it (the mandate example). A reader carries
  the term two sections; they do not have to supply their own explanation. Acceptable
  under the house "result-first" order; noted, not a blocker.
- A few domain terms (high-water mark, entry NAV) appear undefined, appropriate for a
  post-trade ledger audience.

## 3am test

The spec names the same functions as the source, locates the conservation invariant at a
single writer, and pins the `Maybe` semantics exactly. A competent engineer unfamiliar
with the codebase could debug from it. It is obvious; no commentary required to follow it.
