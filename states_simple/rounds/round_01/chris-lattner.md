# chris-lattner — Round 1 — States.tex

**Verdict: NOT-YET**

The document is well-architected and reads cleanly: a question, a three-home
answer, a forced-step construction, and a correctness argument. The "why three /
no fourth" reasoning is minimal and the group/transfer foundation is elegant. But
the simple path has a visible seam that blocks self-evidence: the central
conserved quantity is built up as a first-class home and then disappears from the
assembled answer, and the correctness proof rests on a primitive that the
assembled type never touches.

## Residue

### 1. The held quantity (the "first home") is introduced, then dropped from the answer
The construction makes `Balances :: Map (WalletId, UnitId) Qty` the *first* home
(lines 121-129), invests a whole paragraph in the `holding` lookup and the
load-bearing `Nothing` (never held) vs `Just 0` (held-and-flat) distinction
(lines 131-135), then declares "A position carries **more than** a balance"
(line 173) — but `PositionState` (lines 178-182) contains only `psAc` and `psHwm`.
There is no quantity field. The final `Ledger` (lines 190-195) has three maps and
no `Balances`. The held quantity — the thing `transfer` moves and the thing the
conservation proof sums to zero — has no home in the assembled structure.

Either the balance is a field of `PositionState` (then show the `Qty` field and
say "the balance is one field, others elided"), or it is a fourth `(wallet,unit)`
map (then the "no fourth" claim must be scoped to *economic state beyond the
position*, and the map shown). As written, a careful reader watches the first home
get built and then vanish without a word — a primitive present in the simple path
that the answer abandons.

### 2. The conservation proof is wired to `Balances`/`apply`, not to `Ledger`
"Every event is a transfer" (line 202) and the conservation argument depend on
`transfer` (lines 144-149), which operates on `Balances`. But `Balances` is not in
`Ledger`, and `apply :: Event -> Ledger -> Maybe Ledger` — the function where a
transfer would actually meet the stored `PositionState` map — is referenced in
`replay` (line 213) but never shown. The proof therefore establishes conservation
of a structure (`Balances`) that the document does not store, and is silent on how
it transfers to the structure it does store. The bridge from "move is a transfer"
to "the assembled `Ledger` conserves" is the load-bearing step and it is missing.

Both facets are the same defect viewed twice: the quantity/transfer layer and the
position/Ledger layer are developed in parallel and never joined. Close that join
— show where the quantity lives and show `apply` (or state that the position map
*is* the balance map enriched) — and the document becomes self-evident.
