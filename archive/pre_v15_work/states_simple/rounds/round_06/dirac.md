# DIRAC — Round 6 — States.tex

**Verdict: OBVIOUS**

The three-home structure reads as inevitable. The decomposition is a 2×2 of two
binary, exhaustive axes, with three cells forced and one empty by construction —
no unexplained special case survives scrutiny.

## Why the structure is inevitable

**Axis 1 (key) is forced by scope.** One unit's state → only the unit and a
holder are in view → the key is `unit` or `(holder, unit)`. Multi-unit
relationships collapse (a netting set is itself a unit); holder-alone economic
state is closed (every wallet economic fact is a relationship to some unit).
Binary, exhaustive, derived — not chosen.

**Axis 2 (correction discipline) is forced and exhaustive.** A correction keeps
the prior or discards it. Keep → non-empty version list; discard → single value,
prior recoverable by replay. There is no third option.

**The home-induction criterion is supplied, not assumed.** A home is an occupied
cell. Correction discipline matters because it is the axis that forces *distinct
storage shapes*: terms (NonEmpty list) and status (single value) "cannot inhabit
one value." The document proves this is the right axis by contrast — `psBal` and
`psHwm` share one home precisely because they share a shape ("not the type but the
writer"). So conservation (a within-home, per-field property) does not split a
home, while correction discipline does. That contrast is in the text.

**The empty cell is unified, not patched.** A "definition" is defined as a
received, externally-audited versioned artifact. The `(holder, unit)` key is the
ledger's own record folded from its own move stream — owned, not received — so
there is no received artifact to version. `definition ∩ (holder, unit) = ∅`
follows by construction. Because "definition = received artifact," the
empty-cell argument and the terms/status separator are one principle, not two;
the "does not reopen authorship" caveat is consistent rather than a repair.

**Counterexamples are pre-empted.** Managed account → an issued mandate unit
(`-1`/`+1`, sums to zero), state becomes `(client, mandate-unit)`. Custodian /
prime-broker per-holder figures → reconciliation inputs, never adopted
definitions (adoption would create a second source of truth for holder-unit
state, forbidden by the single-source purpose). Benchmark identity vs level →
separated by correction discipline, not by who authored the number.

**Three homes, two maps** collapses cleanly: terms and status share the unit key
and ride as one pair value, so co-presence is the map's shape, not a policed
invariant.

## Residue hunt

None rises to an unexplained special case. The one pedagogical inclusion —
`psHwm` "stays zero here" — is explicitly justified (it exhibits a non-conserved
field beside the conserved balance, grounding the per-field conservation claim),
so it is an explained inclusion. The empty-cell paragraph is the densest passage
but is explained and unified.

The structure feels inevitable: two exhaustive binary axes, three forced
occupations each with a concrete one-line reason, one cross-axis emptiness by the
owned/received asymmetry, two unit-keyed homes collapsing to one map because they
share a key and differ only in shape. It has the mathematical beauty the bar asks
for.
