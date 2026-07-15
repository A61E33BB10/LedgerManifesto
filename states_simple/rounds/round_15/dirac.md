# DIRAC — Round 15 — States.tex

**Verdict: OBVIOUS**

## The bar

The three-home structure must read as inevitable from one rule — no unexplained
special case, no competing criteria. Reader: a competent engineer new to the problem.

## The rule, and why it is one rule

Each economic fact is located in a 2×2 lattice by two orthogonal observables:

- **Question 1 — key-scope.** Does the fact depend on the holder, or only on the
  unit? {per unit, per (holder, unit)}.
- **Question 2 — record-owner.** Does an outside authority own the record's history,
  or the ledger? {externally authored, ledger-authored}.

These are not competing criteria. Competing would mean two rules that can place one
fact in two seats. Orthogonal coordinates cannot conflict: every fact has a
determinate answer on each axis, and the pair names exactly one cell. The rule is
single — *locate the fact in the lattice* — and the count three is the basis (four)
minus one cell the rule predicts empty. That is the most beautiful classification
there is: a complete basis, not a list of cases.

## The deeper unification I checked this round

The 2×2 is not merely a taxonomy pinned over the storage — it *is* the storage, on
two levels, and this is what makes "three homes, two maps" inevitable rather than a
3→2 fudge:

- **Question 1 chooses the map.** Unit-keyed facts live in `ledgerUnit`;
  (holder, unit)-keyed facts live in `ledgerPS`. Two key-classes, two maps.
- **Question 2 shapes the value.** Within the unit key, authorship splits the value
  into two co-keyed homes, so the value is a pair `(ProductTerms, UnitStatus)`.
  Within the (holder, unit) key, authorship's external cell is empty, so the value is
  a single `PositionState`.

So the same two questions that classify the facts also generate the data layout:
first question → which map, second question → shape of the value. Three homes
(Terms, Status, Position) fall out as occupied cells; two maps fall out as the two
key-classes; the pair-value falls out because one key carries two authored homes.
Nothing is collapsed by hand — co-presence is "the shape of the map, not an invariant
to police." This reads as forced, and more cleanly than I credited in round 14.

## Failure modes, each closed

- **Authorship as a competing criterion (source vs owner).** The text fixes on
  ownership — "who owns the record's history, not who sources the number" — and
  discharges the trap: a settlement price sourced from the exchange is
  ledger-authored because the *record* is the ledger's settlement event. The
  benchmark splits into a ledger-authored level and an externally-authored identity,
  two facts each landing in one cell, "though both come from that provider." One
  criterion, binary, exhaustive by decomposition. PASS.

- **A hidden third key-scope (wallet-alone).** KYC, permissions, audit cursor are
  keyed by the wallet alone. The text excludes them by the definition of an economic
  fact — one that "enters conservation, valuation, or profit and loss" — naming them
  "identity, not economic state." The binary key-axis is thus a derived result of two
  reductions: holder-alone excluded as non-economic, wider keys excluded by the
  reification premise. Both stated. Within scope, the axis is binary by construction,
  not by fiat. PASS.

- **The empty cell as definition-into-emptiness.** The sharpest probe. Is the fourth
  cell genuinely *predicted*, or just emptied by relabelling every external
  per-holder number a "reconciliation input"? It is predicted, and for a structural
  reason: external authorities define *units* (an exchange owns the contract terms),
  but a holder's *relationship* to a unit is created by the ledger's own moves and
  valuation events — it is internal by nature. So external authorship is confined to
  the unit axis a priori; the (holder, unit) × external cell is empty because there is
  no authority of a relationship the ledger itself originates. The managed-account
  counterexample (HWM, accrued fee) is the right stress test and is discharged by
  reification: the mandate is a unit (−1/+1, summing to zero), so those are
  ledger-authored facts of a (client, mandate-unit) position. Predicted, then
  explained — the hole in the sea, not a deletion. PASS.

- **Each occupied cell forced by one concrete reason (§Why Three).** Position because
  two holders of one contract hold opposite quantities (+1000 / −1000) and a
  unit-keyed value would collapse them; Status because one value is read identically
  by every holder, so per-holder storage is drift, "a reconciliation break by
  construction"; Terms distinct from Status because co-mingling the authority's record
  with the ledger's is "the single-source-of-truth violation the system exists to
  prevent." Three crisp reasons, plus the predicted empty. The asymmetry between rows
  is a result, not an assumption.

- **Residual special cases, all explained.** Self-move and zero-move net to `mempty`
  and write no row (so *held* = "named in a move that nets nonzero"); `Maybe` on
  `position` distinguishes never-held / held / held-and-flat, motivated by settlement
  entitlement and wash-sale lookback; `psHwm` non-conserved with its writer declared
  out of scope; `Price` a newtype with no monoid so it can never be summed into a
  balance; the sealed constructor and withheld selectors leave conservation "no other
  door." No branch is arbitrary.

## The one load-bearing assumption — disclosed, not residue

The binary holder-axis, and so the count three, rests on the reification: every
economic relationship a wallet has is itself a unit it holds, so no fact needs a
wider key. Demonstrated for one mandate, **explicitly assumed, not proved**, for a
relationship spanning several instruments. The file flags this twice and names it as
the premise the count rests on. Against this bar it is not residue: not a competing
criterion, not a special case, not unexplained — a named, bounded proof obligation
the file defers to scope on purpose. Demanding its proof here would contradict the
file's own boundary. The structure is inevitable *given* a premise the document is
honest about; that honesty is the correct register and does not dent obviousness.

## The DIRAC test

1. Beautiful — a complete 2×2 basis, one predicted-empty cell, three homes, two maps;
   the two questions generate both the taxonomy and the layout. Inevitable.
2. Notation right — every newtype earns its place: `Qty`'s group forces the two legs
   to cancel; `Price` has no monoid, so it is unsummable into a balance.
3. Understood without solving — conservation and determinism are read off the
   structure: single writer of `psBal`, sealed constructor, total pure `apply`.
4. Unified — key-class → map, authorship → value-shape; both maps under one `Ledger`;
   all three events under one `apply`/`replay` fold.
5. Formalism trusted — the empty cell is investigated and explained, not clamped away.
6. Minimal — two maps, three events, no surplus.

No unexplained special case. No competing criteria. The three homes are inevitable.

**OBVIOUS.**
