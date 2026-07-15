# FORMALIS — Round 1 verdict on `States.tex`

**Verdict: NOT-YET**

The document reads cleanly and keeps most KEEP items: three homes and no fourth
(§The Answer), the three forcing reasons by example (§Why Three), the
never-held / held-and-flat distinction (lines 131–135), the mandate-as-unit
grounding (lines 91–98). Replay's checkpoint-independence (lines 208–221) is
sound: `foldM` distributes over concatenation, and retained zero rows keep the
key set monotone, so the fold argument is visible and correct.

The veto is on **visible conservation**. Simplicity was bought by dropping the
conserved object out of the assembled structure.

## Residue 1 — the conserved object vanishes from the final `Ledger` (BLOCKING)

The conservation proof is built on `Balances = Map (WalletId,UnitId) Qty`
(lines 125–149): `transfer` writes `negQty q` and `q` together, exact inverses,
so an unbalanced move cannot be written. That is the one place conservation is
*visible*.

Then line 173 ("A position carries more than a balance") replaces `Balances`
with `PositionState = {psAc, psHwm}` (lines 178–182), and the assembled `Ledger`
(lines 190–195) holds `ledgerPS :: Map (WalletId,UnitId) PositionState` — with
**no `Balances` map and no quantity field anywhere in `PositionState`**.

Consequences:
- The holding quantity `Qty` — the thing the conservation paragraph says "sum to
  zero" (line 206) — has no home in the final structure. A position that
  "carries more than a balance" is shown carrying *less*: the balance was dropped,
  not absorbed.
- `transfer` produces `Qty`, but the Ledger stores `PositionState`. The document
  never shows the conserved field of `PositionState` (`psAc`) being updated through
  the inverse-leg discipline. The reader sees conservation on an object
  (`Balances`/`transfer`) that does not appear in the assembled `Ledger`, and must
  take on faith that `ledgerPS` inherits it.

This is a load-bearing fact (essence KEEP 5: "each event moves quantity between
named holders, so every event's net change is zero") rendered non-visible.
Conservation is no longer an evident consequence of the *structure* shown.

**Actionable:** either give `PositionState` an explicit conserved quantity field
and show `transfer`/`apply` writing the two inverse legs *into `ledgerPS`*, or keep
`Balances` as a fourth-... (it is not a fourth economic home; it is the conserved
core of the position home) component visibly inside `Ledger` so the
negate-and-pair argument applies to the assembled object the reader is handed.

## Residue 2 — "Every event is a transfer" is an overclaim; `Event`/`apply` undefined

Line 202 states "Every event is a transfer." But the document itself describes
non-transfer events: status is "overwritten on every settlement" (line 88) and
terms "append a version" (line 86). Settlement and versioning events are not
transfers and move no quantity between holders. With `Event` and `apply` never
shown (only `replay = foldM (flip apply)`, line 214), the conservation premise is
literally false as stated and the reader cannot verify the intended weaker claim.

**Actionable:** restate as "every *transfer* event conserves; settlement and
versioning events touch status/terms and leave holdings unchanged," so the net-zero
step is true and visibly covers all event kinds. This costs one clause, not the
path.

## Standard not yet met
A competent reader reaching the conservation paragraph cannot see the conserved
field inside the object the Ledger stores, and meets a literally false premise.
The dropped proofs *are* missed here, because the structure as assembled does not
force conservation on its own face.
