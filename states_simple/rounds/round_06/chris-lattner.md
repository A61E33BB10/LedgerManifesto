# Round 6 — chris-lattner

## Verdict: OBVIOUS

Lens: the simple path is the whole document; nothing present that does not serve
the answer. Reader: a competent engineer who has never seen this problem.

## What I checked

The document answers "where does a unit's state live" and — per its own Section 1
— commits to making conservation and deterministic replay hold *by construction*.
So the move/event machinery is in scope, not decoration: it is what discharges the
commitment.

**Everything present serves the answer.** I enumerated each declaration and each
paragraph:

- `Qty` monoid/group → conservation by cancellation (`negQty q <> q = mempty`).
- `Lifecycle = Listed | Active Price` → makes "active without a price" and "priced
  while listed" unrepresentable; the correlation holds by type, not by a trusted
  writer. Illegal states gone.
- `ProductTerms (NonEmpty TermsVersion)`, constructor not exported, `appendVersion`
  → *is* the answer's correction discipline (append, keep prior). Not speculative
  generality: the terms/status distinction collapses without it.
- `PositionState { psBal, psHwm }`, `psHwm` zero in-file → carries the per-field
  conservation point (one home, a conserved field beside a non-conserved one), and
  grounds the managed-account rebuttal. Defended where it appears.
- `Ledger` (two maps), constructor not exported → three homes, two maps; co-presence
  of terms+status is the shape of the map, not a policed invariant.
- `register`/`settle`/`applyMove` → one writer per concern; `applyMove` the sole
  writer of `psBal`.
- `position`'s `Maybe` → the never-held / held / held-and-flat distinction, a real
  property of a retain-rows home.
- `netBal`, `Event`/`apply`/`replay` → discharge conservation and replay.

I could not find an element that fails to serve.

**The code is correct, pure, total.** Conservation: only `applyMove` touches
`psBal`, writes both legs from one quantity; `register`/`settle` leave `psBal`
alone; base case zero. Holds, self-transfer included. Replay: `apply` pure/total,
`foldM`; checkpoint-splitting is the monadic left-fold law. The `Maybe` is
disambiguated to mean exactly one thing — "unknown unit," never "balance failed"
(304–307). That is "errors are UI" done right.

**The subtle arguments close on careful reading.** I pushed hardest on the empty
fourth cell (132–146), where "correctable definition" is re-characterised as a
*received* artifact audited at the boundary — a different criterion than the
correction-discipline definition in §The Answer. This looked like a definitional
shift that a fresh reader would stall on. It is not a gap: the document closes
*both* routes to a (holder, unit) definition. The received route is closed —
external per-pair figures are reconciliation inputs, not adopted definitions. The
owned route is closed — owned facts are folded from the move stream, their priors
recovered by replay, so they are never stored as versions (entry NAV folded from
the opening event; high-water mark keeps only its peak). Versioning is needed
exactly where a prior cannot be reconstructed by replay and must be shown
as-received to an external auditor — which is only the unit key. The cell is empty
by construction, and the construction is stated.

The multi-unit closure ("a relationship is itself a unit") and the wallet-keyed
closure are both argued abstractly in §The Answer and then carried by the worked
managed-account example (issued mandate, −1/+1 summing to zero). Concrete enough.

## Architectural read

Sealed constructors enforce single-writer discipline at the module boundary;
illegal states are unrepresentable by type; conservation is a property of the
writer not the store; replay is deterministic by purity and totality. The two
in-file-unexercised capabilities (`appendVersion`, `psHwm`) are not over-reach —
they are the thesis (terms *is* append-only; position *does* hold non-conserved
state), and each is defended at the point of use. Removing either would destroy
the answer, not simplify it.

Dense, but density is not the bar; "everything serves" and "obviously right" are,
and both hold. No residue.
