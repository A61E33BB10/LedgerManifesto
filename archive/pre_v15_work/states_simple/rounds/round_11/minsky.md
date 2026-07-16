# minsky — Round 11 — States.tex / States.hs

## Verdict: OBVIOUS

## Lens

Do the types make the illegal states *visibly* impossible — the reader sees it,
not takes it on faith? And, where a fact is *not* carried by a type, is that
disclosed as a writer/seal discipline rather than disguised as a shape?

## The Round-10→11 restructure does not regress my lens

The placement justification changed substantially since Round 10: the old
"past-dated boundary read" test (the target of most of the Round-10 pooled
residue) is gone, replaced by an **authorship axis** — externally-authored vs
ledger-authored — crossed with holder-dependence to give the 2×2
(States.tex:55-91). This is a prose/rationale change. The *types* are unchanged
from the version I passed in Round 10: `Qty`, `Price`, `Lifecycle`,
`UnitStatus`, `TermsVersion`, `ProductTerms`, `PositionState`, `Ledger`, `Move`,
`Event` are the same declarations with the same fields. So the type-visibility
guarantees I verified last round still stand, and I re-checked each against the
new prose for fresh overclaims. None introduced.

## Shape-enforced, visible without running anything

- `data Lifecycle = Listed | Active Price` (tex:205, hs:258): "active with no
  price" and "listed yet priced" are unspellable — the correlation is the
  constructor, not a two-field lockstep. ✓
- `newtype ProductTerms = ProductTerms (NonEmpty TermsVersion)` with the
  constructor unexported (export list hs:47 lists `ProductTerms`, not
  `ProductTerms(..)`): "registered but versionless" is unrepresentable, and no
  importer can lay down a fresh short history. ✓
- `Map UnitId (ProductTerms, UnitStatus)` (tex:262): terms/status co-presence is
  the shape — one entry carries both halves or neither, no "in terms but not
  status" value to police. ✓
- `(WalletId, UnitId)` key (tex:263): two holders of one unit are two keys, can't
  collapse to one number. ✓
- `Move UnitId WalletId WalletId Qty` (tex:302): one quantity in, both legs
  derived from it as `negQty q`/`q`. ✓

## Writer/seal facts: auditable, and disclosed as such — not faith

- **Seal is real and finite to audit.** I confirmed `ledgerUnit`/`ledgerPS`
  appear only in the module body and are absent from the export list
  (hs:61-70); with the `Ledger` constructor also unexported, no importer can
  construct or record-update a `Ledger`. So "the only door that writes `psBal`
  writes it balanced, and the constructor leaves no other door" (tex:345-353) is
  checkable, not asserted.
- **Conservation is disclosed as a writer invariant, not a shape.** tex:345-346
  states plainly "Conservation is an invariant of the writer, not the store type,
  which can hold a non-conserving assignment." That is the candor I demanded in
  R8/R10, preserved. The argument (only `applyMove` touches `psBal`; it writes
  net deltas summing to `negQty q <> q = mempty`; `register`/`settle` never
  touch `psBal`; base case `emptyLedger`) is sound and auditable. The self-move /
  zero-move net-then-write path (hs:541-562) is unchanged from the version I
  traced in R10. ✓
- **The registration gate is disclosed as a guard, not a type.** The store type
  *can* represent a position for an unregistered unit; the document never claims
  otherwise — `applyMove`'s `Maybe` is presented as guarding input (tex:317-323),
  and nothing removes from `ledgerUnit`, so "position ⟹ registered" holds across
  reachable ledgers by writer discipline. Honest. ✓

## The newly-restructured empty fourth cell is argued, not type-claimed

The empty (externally-authored, per-(holder,unit)) cell now rests on a domain
argument — no external authority issues a per-holder position fact; a custodian
or PB report is a reconciliation *input*, not adopted authority (tex:87-91,
140-148) — plus the reification that every wallet-economic fact is a position in
some held unit. This is design rationale, presented as reasoning, and the
multi-instrument generalization is explicitly disclosed as assumed, not proved
(tex:62-67, 156-158; hs:428-442). Crucially, the document does **not** claim a
type makes the fourth home impossible. So under my lens there is no disguised
faith-claim: the conditional is visible before the conclusion.

## Round-10 residue I can confirm closed

The "high-water marks … total peak exposure" overclaim (henri-cartan / jane-
street-cto, R10 items 8/11) is gone from both files; `grep "peak exposure"`
returns nothing. The current text states the honest narrower fact: `psHwm`
carries no zero-sum invariant and "no aggregate over holders is claimed for it"
(tex:238-239; hs:587-599). That removes the one false justification sentence I
noted as out-of-lens last round.

## Exhaustiveness / totality

`settlementPrice` (hs:294-296) and `apply` (hs:710-713; tex:366-369) match every
constructor with no swallowing wildcard — a future `Lifecycle`/`Event` case fails
to compile, as it should. `currentTerms` is total by `NonEmpty`. All writers are
total in `Maybe`. `replay = foldM` over a pure total step. Clean.

## Why OBVIOUS

Every fact the document presents as carried by the types *is* carried by the
types, and a first-time reader sees each one in the shape. Every fact not carried
by a type — conservation, append-only history, the registration gate, the
no-fourth-home reification — is disclosed as a writer/seal discipline or a stated
assumption, each resting on a bounded, auditable argument over reachable ledgers,
never dressed as a shape. The two representable-input gaps I caught in earlier
rounds remain closed. The R10→R11 restructure swapped the rationale axis without
weakening any type guarantee or introducing a new representable illegal state.
From my lens, the solution is obviously right.
