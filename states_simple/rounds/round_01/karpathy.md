# karpathy — States.tex, Round 1

**Verdict: NOT-YET**

The prose is clean and the first three "why" cases (Position, Status, Terms)
are genuinely self-evident — a buyer at +1000 and a seller at -1000 settle the
key question in one line. But the document does not survive a single pass:
the assembled answer drops the very structure its correctness proof is about,
and it leans on functions it never shows. A reader hits these and has to stop.

## Residue that blocks obviousness

### 1. The held quantity vanishes from the assembled `Ledger` (lines 125-126, 173-182, 190-206)
The construction builds `Balances = Map (WalletId, UnitId) Qty` (line 126) and
makes it the spine: `transfer` moves a `Qty`, conservation is proved as
"holdings sum to zero" (line 205). Then "A position carries more than a balance"
(line 173) promises `PositionState` *extends* the balance — but the record shown
is `{ psAc, psHwm }` (cost and high-water mark), with **no held-quantity field**,
and the final `data Ledger` (lines 191-194) has only `ledgerPT`, `ledgerUS`,
`ledgerPS`. `Balances` is nowhere in it. So the conservation argument
("holdings sum to zero") is about a map that the answer does not contain. The
reader must backtrack: where does the quantity actually live? Either fold the
balance into `PositionState` as an explicit field, or carry `Balances` in
`Ledger` — and make the "carries more than a balance" line literally true.

### 2. `Event` and `apply` are load-bearing but undefined; `apply` can fail while moves "cannot fail" (lines 137-142, 201-215)
The whole closing argument rests on "every event is a transfer" (line 202) and
on `replay = foldM (flip apply)` (line 214). Yet `Event` and `apply` are never
shown. Worse, `apply` returns `Maybe` (line 213, via `foldM`) — i.e. it can
fail — which sits in direct tension with the earlier, emphatic claim that an
unbalanced move "is not rejected; it cannot be written" (line 142). What is the
failure mode that justifies `Maybe`? Unregistered unit? Status on a missing
unit? Until `apply` is shown, the reader cannot verify "every event is a
transfer," and the unexplained `Maybe` reads as a contradiction of the
can't-fail thesis.

### 3. The "so" in deterministic replay is a non-sequitur (lines 208-210)
"A closed-out position keeps its row ... so the set of keys never shrinks.
Replay is then a plain left fold." Retaining rows does not entail being a fold —
a left fold can delete keys too. Determinism and the checkpoint-independence
that follows come from `apply` being a pure deterministic function, not from row
retention. Two separate properties are welded by a "so" that does not hold.
State the actual reason (purity/determinism of `apply`), and let row-retention
stand on its own (history/audit), rather than implying it is what makes replay a
fold.

### 4. "There is no fourth" is asserted universally from one example, with a real fourth map carved out by definition (lines 56-61, 91-98)
The universal "every per-wallet economic fact is a position in some unit" is
demonstrated by exactly one case (the mandate, lines 91-98) and then generalized
to "a managed account, a mandate, and a strategy are themselves units." That may
be true, but it is the crux of the whole claim and is asserted, not shown to be
exhaustive. Compounding the doubt: a genuinely wallet-keyed map (KYC/permissions)
*does* exist and is excluded as "identity, not economic state" (lines 59-61). So
the honest claim is "no fourth *economic-state* home," resting on a
classification (identity vs. economic) the reader is handed rather than shown.
This is the one place the design asks for a leap of faith.

Fix 1 and 2 and the document likely clears the bar; 3 and 4 are smaller but
still cost the reader a pause.
