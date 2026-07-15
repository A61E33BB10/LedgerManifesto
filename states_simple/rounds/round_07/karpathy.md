# karpathy — States, Round 7

**Verdict: NOT-YET**

My bar: a competent engineer new to this problem sees the answer and why it must
hold in one pass — no leap of faith, no backtracking.

## What is already obvious (and I checked)

- The *answer* is stated cleanly: two axes (key ∈ {unit, (holder,unit)}, discipline
  ∈ {definition, observation}), a 2×2, three occupied cells (Terms, Status, Position),
  one empty. The axes are orthogonal and the cell assignments are tabulated.
- The *why-it-holds* for the two named properties is obvious and correct.
  Conservation: `applyMove` is the sole `psBal` writer and writes
  `negQty q <> q = mempty`; `register`/`settle` never touch `psBal`; base case
  `emptyLedger` sums to zero; sealed constructor leaves no other door. I checked the
  `from == to` self-move — inner leg writes `-q`, outer reads the updated row and adds
  `q`, nets zero, still conserves.
- Determinism: `apply` is pure and total; `replay = foldM (flip apply)` types and
  folds correctly; checkpoint-splitting is the standard monadic left-fold law, valid
  in `Maybe`. `netBal` filters and `foldMap`s correctly with no shadowing.

The engineering is right. The block is in the *derivation of the three cells*.

## Residue (located, actionable)

### 1. The terms-vs-status placement criterion is not single-pass reproducible — the benchmark example exposes the gap (PRIMARY)

Location: §The Answer, lines 68–69 ("a list is materialized only to audit an
external authority's restatements against the in-force version") and lines 84–86
("the same index provider's benchmark identity is terms, its benchmark level
status"); reinforced at §Why Three, lines 148–149 ("the recoverable and unaudited
is never versioned").

The doc gives the reader a criterion for the version-list (definition) discipline:
*materialize a list only to audit an external authority's restatements.* Then it
hands the reader a worked split where one external provider's two outputs land in
different cells: benchmark **identity** → terms, benchmark **level** → status.

Apply the stated criterion as written. Benchmark level is externally sourced and is
restated by its provider (index levels are corrected in practice). By the stated
criterion, "external authority whose restatements a version list would audit," it
should get a version list — i.e., terms. But the doc places it in status (overwrite,
prior recovered by replay only). The reader hits an apparent contradiction at the
exact example meant to settle the distinction, and must take the split on faith.

The intended resolution is presumably "identity is a *definition* used to compute
entitlements against the version in force on a past date; level is an *observation*
whose current reading is all that is consumed, history being replay-only." But that
is the very axis being defined — saying "identity is terms because it is a
definition" is circular unless an independent test is given, and the
restatement-audit criterion offered does not separate identity from level (both are
external, both restatable).

Fix: state the independent test that splits an externally-sourced *definition* from
an externally-sourced *observation*, and show both benchmark facts follow from it.
A candidate that would close it: "a fact whose value-in-force-on-a-past-date drives
a boundary computation (an entitlement) carries a version list; a fact for which
only the current reading is consumed, any history being replay-only, is
overwritten." Then identity → terms and level → status each fall out, and "who
authored the number" genuinely stops mattering.

### 2. `replay` is load-bearing before it is defined (MINOR, but breaks single-pass reading)

Location: §The Answer, lines 64–72 — "any prior recovered by replay,"
"Both are replay-recoverable" — carry the whole terms/status separation. `replay` is
defined only in §Why It Is Right, lines 361–372.

The central distinction in §The Answer rests on an operation the document does not
define until its last section. A reader going top-to-bottom must hold an undefined
term as a placeholder to follow the cell argument. §The Question names "deterministic
replay" as a goal but never says what replay *is*.

Fix: a one-clause definition at first use — replay is re-folding the immutable event
stream from `emptyLedger` — or an explicit forward pointer to §Why It Is Right.

## Why not OBVIOUS

The construction and both correctness proofs pass my bar. The classification — which
is the actual thesis ("where a unit's state lives") — does not: the reader cannot
reproduce the terms/status assignment from the stated criterion, and the one worked
external-source example contradicts that criterion on its face. That is a leap of
faith at the load-bearing step, so: NOT-YET.
