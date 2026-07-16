# S1 — NOETHER: what the event algebra forces on a ledger entropy

*Ledger Entropy seminar, Session 1. Exploratory, non-normative. A negative result is a success.*

**Restriction (shared).** Uncertainty enters only through observation events that record an
observed value = true value + Gaussian noise. Fix one triple (unit `u`, coordinate `c`,
agreement `G`). Wallets are `w = 1..W`. The unknown true balances form a vector
`x = (x_1,…,x_W)`. Each observation event records `y_i = a_i·x + ε_i`, `ε_i ~ N(0, σ_i²)`.
The posterior over `x` is therefore Gaussian.

## The one hard fact

Conservation holds **by construction**: every admitted move is paired-leg, so at every log
position `Σ_w x_w = 0` — exactly, with no noise. Write `n = (1,…,1)`. The true state lives on
the hyperplane `H = { x : n·x = 0 }` **before any observation is read**. The posterior is a
Gaussian supported on `H`: degenerate in the ambient `R^W`, with covariance `Σ` obeying
`nᵀΣn = var(n·x) = 0`, hence `Σn = 0`. The constraint normal `n` is a null direction of `Σ`.
`rank Σ ≤ W − 1`.

## (1) Symmetry ↔ conserved quantity of the distribution

A paired-leg move acts on the state by `x ↦ x + m(e_a − e_b)`. The generators `e_a − e_b` span
`H`. So **the event algebra's admissible state-changes are exactly the translations along `H`**,
and admissibility does not depend on where in `H` you stand — translation invariance along the
conservation-preserving directions. Noether: the invariant of this translation group is the
linear functional it fixes, `n·x = Σ_w x_w`. That is the conserved current; `d/d(position) (n·x)
= 0` is the conservation law, per `(u,c,G)`. In the distribution this reads as a conserved
**transverse marginal**: the posterior mass along `n` is a Dirac `δ(n·x)`, and the genuine
(non-degenerate) uncertainty is the marginal on `H`. Symmetry along `H` ⇒ deterministic marginal
across `H` ⇒ `Σn = 0`.

## (2) The quotient and the pseudo-determinant

An admissible entropy cannot be the ambient differential entropy of `p` on `R^W`: the Dirac
factor makes it `−∞`. It must be the entropy of the non-degenerate part, defined **on the
constraint leaf `H` with its induced `(W−1)`-dimensional volume** (equivalently, on the quotient
`R^W / span(n)` carried onto `H`). With `k = dim H = W − (number of triples)`:

```
h_H(p) = (k/2)·log(2πe) + (1/2)·log det⁺Σ ,
```

where `det⁺Σ` is the **pseudo-determinant** — the product of the non-zero eigenvalues, i.e. the
ordinary determinant of `Σ` restricted to its support `H`. The pseudo-determinant is precisely
the object that "forgets" the conserved direction. It is what conservation forces the volume term
to be.

## (3) Invariance under symmetries the ledger declares meaningless

- **Wallet relabeling** (`x ↦ Px`, `P` a permutation): `Σ ↦ PΣPᵀ`, spectrum fixed, `|det P| = 1`.
  Entropy **invariant**. Good — a declared-meaningless symmetry is respected.
- **Minor-unit rescaling** (`x ↦ Dx`, `D` diagonal per unit): `Σ ↦ DΣDᵀ`, so
  `det⁺Σ ↦ det⁺Σ · (det D|_H)²` and `h_H ↦ h_H + log|det D|_H|`. Entropy **NOT invariant** — it
  shifts by a constant under a change the ledger says carries no information. Absolute entropy is
  not a ledger quantity.
- **Reordering disjoint-footprint events**: these commute, the fold gives the same ledger, so the
  posterior and any *state*-entropy are invariant automatically. But an **"entropy of the log"** —
  a functional of the ordered sequence — would assign different values to logs that fold to the
  identical ledger. That is a violation. So entropy must be an **entropy of the state (the fold),
  never of the log**. The Order principle sharpens this: overlapping-footprint events do *not*
  commute, different orders give different ledgers, different `Σ`, different entropy — there the
  order is physical and the functional legitimately depends on it. The admissible functional may
  therefore see exactly the log's partial order (its reordering-class), no more, no less.

## (4) The Noether dictionary

| Symmetry (event algebra) | Conserved quantity | Constraint on `Σ` | Consequence for the functional |
|---|---|---|---|
| Paired-leg translations along `H` | Total `n·x = Σ_w x_w = 0` (the current) | `Σn = 0`; `rank Σ ≤ W−1` | ambient entropy `= −∞`; must use `det⁺Σ` on leaf `H` |
| Wallet relabeling (permutation) | Structural (label-free) balance | `Σ ↦ PΣPᵀ`, spectrum fixed | invariant — OK |
| Minor-unit rescaling (`D`) | Real value (scale-covariant) | `Σ ↦ DΣDᵀ` | absolute `h` shifts by `log|det D|` — **fails** |
| Reorder disjoint-footprint events | The folded ledger (and its posterior) | `Σ` unchanged | must be a **state** functional, not a log functional |
| Reorder overlapping-footprint events | (not a symmetry) | `Σ` changes | order is physical; dependence is legitimate |

## Forced conclusion

The rescaling row is fatal to "entropy" and productive of the answer. Because the ledger declares
the minor unit (and, with relabeling, the whole choice of coordinates) meaningless, only a
functional invariant under `x ↦ Dx` may bear a ledger name — and absolute differential entropy is
not. The quantity whose Jacobians cancel is a **relative entropy**: `D(posterior ‖ reference)` on
the leaf `H`, i.e. **information gain against a declared reference measure** (the prior, or a
reference-unit measure). This is the Noether reading of a gauge symmetry: when the choice of
units/labels/coordinates has no physical content, only *differences* are observable — here,
**bits gained, not absolute entropy**. Information gain is additive over disjoint footprints (a
conservation-like additivity: the information current adds across independent regions) and merely
sub-additive where footprints overlap — the same disjoint/overlapping split the Order principle
already draws. The ledger admits an **information-gain current on `H`**, defined against a
reference; it does not admit an absolute ledger entropy.
