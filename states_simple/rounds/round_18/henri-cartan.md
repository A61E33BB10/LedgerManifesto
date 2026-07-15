# Round 18 — henri-cartan on States.tex

**Verdict: NOT-YET**

Reader assumed: a competent engineer who has never seen this problem.

## What is obvious (and rightly so)

The formal core stands on its own and needs no further proof.

- **Conservation (§5).** `applyMove` is the sole writer of `psBal`; `netDeltas`
  builds the two legs `negQty q` and `q` from one quantity, which sum to `mempty`
  in the abelian group `Qty`; `writeNet` skipping a `mempty` delta leaves the sum
  untouched; `register`/`settle` never touch `psBal`; the sealed constructor and
  withheld field selectors close every other door. The per-unit holding sum is
  invariant from `emptyLedger`. This follows directly from the listings.
- **Deterministic replay (§5).** `apply` is pure and total (no partial matches,
  `NE.last` total, all branches return `Maybe`); `replay = foldM (flip apply)`.
  Determinism and the `Nothing`-on-first-refusal behaviour follow at sight. The
  checkpoint split via the monadic left-fold law is a standard identity for
  `foldM` and is acceptable invoked by name.
- **The 2×2 mechanics (§2).** Given the premise, the two binary questions yield
  four cells; the three occupied cells map cleanly to Status, Terms, Position, and
  the §3 reasons (different holders → holder in key; one value per unit → unit
  key; different authority of record → distinct home) each force their cell.
- **The construction (§4).** The `Active Price` correlation by type, the
  non-empty version list with unexported constructor, the pair-valued `ledgerUnit`
  making co-presence the map shape, and the seal argument are each forced by the
  step before. No notation dangles; no symbol collides.

## The residue (located, load-bearing)

The document titles §2 **"The Answer"** and the answer is a *count*: **three
homes, two maps** — explicitly *not* a fourth home or a third
`Map (holder, several-units) _`. That count is correct only if every economic
relationship reduces to a single `(holder, unit)` row. The document proves this
reduction for exactly one case and **assumes** it for the case that would break
the count.

- **Location.** §2 (lines 55–59): "demonstrated for one relationship in §why,
  assumed for one spanning several instruments." §3, final paragraph
  (lines 147–150): "that a relationship spanning several instruments is likewise a
  single unit — a single (holder, unit) row, not a (holder, several-units) home
  that would be a fourth home and a third map — is assumed here, not proved."

- **Why it is missed.** The proved case (the managed-account mandate) works
  precisely because the mandate has a single issuer and a zero-sum issuance
  (`-1` manager, `+1` client). The generalisation needed for the count is that an
  *arbitrary* multi-instrument relationship — e.g. a portfolio-margin or netting
  set whose margin/peak is a fact of the set, not of any constituent — is itself a
  zero-sum issued unit. That does not follow from the single-issuer case: it is
  not obvious such a set has an issuer at all, and if it does not, the set's fact
  is a genuine `(holder, several-units)` fact occupying the very fourth home /
  third map the answer denies. The reader cannot conclude the central count is
  right without this proof; hence the omitted proof is missed.

- **Actionable.** Either (a) prove that any in-scope multi-instrument economic
  relationship reifies as a single zero-sum issued unit (exhibit the issuer and
  the cancelling legs, as done for the mandate), or (b) bound the scope so the
  answer reads "three homes for relationships that so reify," and state the
  closure condition that keeps non-reifying relationships out of scope.

This is the document's own flagged gap, not invented residue. Flagging an
unsettled item satisfies the writing convention, but a flag does not make the
load-bearing claim it guards obvious: the count that §2 presents as the answer
remains conditional on an unproved premise.
