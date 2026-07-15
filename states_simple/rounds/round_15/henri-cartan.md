# henri-cartan — States.tex, Round 15

**Verdict: OBVIOUS**

Bar applied: the answer follows from its definitions so directly that the omitted
proof is not missed. Reader = a competent engineer who has never seen this problem.

## What I checked

I read `States.tex` end to end, cross-checked every listing against the actual
`States.hs`, and confirmed the module seal on which the central proof rests.

### 1. The placement argument (§Answer, §Why)

The 2×2 — (per unit / per (holder,unit)) × (ledger-authored / externally authored) —
is argued from concrete cases, not asserted:

- Position keyed by (holder,unit): buyer +1000, seller −1000 of one future would
  collapse under a unit-only key. Direct.
- Status keyed by unit alone: one settlement price read identically by all holders;
  per-holder storage is drift, i.e. a reconciliation break by construction. Direct.
- Terms ≠ Status: different authorities of record; co-mingling is the
  single-source-of-truth violation the system exists to prevent. Direct.
- Fourth cell empty: a custodian/PB statement is a reconciliation *input*, not an
  adopted record; the managed-account apparent counterexample is reified into a
  (client, mandate-unit) position. The reification is shown in full for one mandate.

The one load-bearing premise that is *not* proved — that a relationship spanning
several instruments is likewise a single unit, hence a single row — is explicitly
and repeatedly flagged as assumed (§Answer "assumed for one spanning several
instruments"; §Why "assumed here, not proved"; and the `States.hs` header). This is
an announced scope boundary, not an omitted proof the reader would silently miss.
There is no mismatch between what is claimed proved and what is proved.

### 2. Conservation (§Why It Is Right)

Verified the induction:
- Base: `emptyLedger` has empty maps, so every unit's `netBal` = `mempty`.
- `register`/`settle` touch only `ledgerUnit`, never `psBal` — sums unchanged.
- `applyMove` is the sole `psBal` writer; the per-unit delta is the sum of
  `netDeltas`, which is `negQty q <> q = mempty` (distinct wallets) or a single
  `mempty` entry (self-move). Either way the per-unit holding sum is preserved.
- "No other door": confirmed in `States.hs` — the `Ledger` constructor and field
  selectors are unexported, and the superseded step-3/4 balance API (`transfer`,
  `Balances`) is deliberately not exported. The induction therefore ranges over the
  complete writer set. The `.tex` asserts the seal only in comments, but the
  assertion is true.

`psHwm` is correctly excluded from the invariant: same type `Qty` (so summable,
unlike `Price`), but no paired writer, hence no zero-sum claim. Out-of-scope writer,
stays zero — stated.

### 3. Determinism (§Why It Is Right)

`apply` dispatches over all three `Event` constructors (total dispatch); each writer
is pure and total (only `Map`/`NonEmpty` total operations; partiality is reflected
in `Maybe`, never an exception). `replay = foldM (flip apply)` threads failure;
`Nothing` arises exactly for repeated registration or move/settle on an unregistered
unit. Checkpointing rests on the standard `foldlM`/`foldM` concatenation law, a
cited fact a competent engineer can accept.

### 4. Edge cases in `applyMove` / `position`

- Self-move (`from = to`): `netDeltas` collapses to one `mempty` entry; `writeNet`
  skips it. No row. Matches text.
- Zero-quantity move: both legs `mempty`; no rows. Matches text.
- never-held vs held-and-flat: `applyMove` only ever `Map.insert`s, never deletes;
  first touch creates a row, close-out leaves `psBal = 0` retained. So `Nothing` =
  never held, `Just (psBal 0)` = held and flat. The distinction the text claims is
  exactly what the code produces.

All listings match `States.hs` line for line (deriving clauses aside). GHC is not
installed in this environment, so the type-check is by inspection rather than by
compiler; nothing in the shown code is partial.

## Residue

None that trips the bar. The single unproved premise (multi-instrument relationship
= one unit) is disclosed as an assumption in three places; it is a declared scope
edge, not a silent gap. Everything the document presents as established follows
directly from its definitions, and the omitted proofs (amendment events, the `psHwm`
valuation writer, entry NAV) are each named and scoped out rather than glossed.
