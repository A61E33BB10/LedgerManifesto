# S1 — DIRAC. Ledger Entropy: the object, the functional, the verdict

*Seminar on Ledger Entropy, Session 1. Independent formalization. Exploratory, non-normative. A negative result is a result.*

## The one object

A log of `n` events. Each event `i` carries an accuracy `p_i` — the chance it is admitted as recorded. Which events are true is a latent bit-string `s ∈ {0,1}^n`; there are `2^n` candidate logs. Fix `s`; then the observed state `x = init + fold(moves)` is Gaussian, `x | s ~ N(μ_s, Σ_s)`. Conservation (wallet sums vanish) forces `x` onto the affine subspace `ker C` of the constraint map `C`; hence every `Σ_s` is singular, its null space the constraint normals — **the same null space for every `s`**.

One object holds both layers — the discrete mixing and the continuous noise:

    π  =  Σ_{s ∈ 2^n}  w_s · N(μ_s, Σ_s),      w_s = ∏_i p_i^{s_i} (1−p_i)^{1−s_i}

a finite Gaussian mixture over candidate logs. Attestation multiplies `w_s` by a likelihood and renormalizes — it *sharpens* `w`. Two corners fall out with **no case analysis**:

- **all `p_i = 1`**: `w → δ_{s*}`, so `π → N(μ, Σ)` — the pure-continuous corner.
- **`Σ_s → 0`**: `N_s → δ_{μ_s}`, so `π → Σ_s w_s δ_{μ_s}` — the pure-discrete corner.

## The chain-rule identity

Let `S` be the configuration, `X` the state. The joint entropy is *always* exact:

    H(S, X)  =  H(S) + Σ_s w_s H(N_s)  =  H(w) + Σ_s w_s · ½ ln[(2πe)^k det*Σ_s]

(discrete entropy plus expected Gaussian entropy; `det*` the pseudo-determinant on rank `k = rank Σ_s`). But the entropy of the *observable* mixture is the marginal `H(X) = H(π)`, and it differs from the joint by the equivocation `H(S|X)`:

    H(π)  =  H(X)  =  H(S,X) − H(S|X)  =  H(w) + Σ_s w_s H(N_s) − H(S|X),     0 ≤ H(S|X) ≤ H(w).

**The mixture-overlap correction is exactly the equivocation** `H(S|X) = H(w) − I(S;X)`. It interpolates with nothing put in by hand:
- **separated components** (`μ_s` far apart): `X` reveals `S`, `H(S|X)=0`, both terms survive — full chain rule.
- **coincident components** (equal `μ_s, Σ_s`): `X` says nothing about `S`, `H(S|X)=H(w)`, the discrete term *cancels*, `H(π) = H(N)` — one Gaussian's worth of entropy.

## Beauty verdict

**Differential entropy `H(π)` is the wrong functional.** It is not invariant under reparametrization; it has no closed form for a mixture; it **diverges to −∞ at the discrete corner** (a hand-switch to Shannon is needed to recover `H(w)`); and the conservation degeneracy sends `det Σ → 0`, forcing `det*` — **an epicycle**: you must manually restrict to the row space. Three defects, all of them cured by a single change.

**Relative entropy is the right functional:**

    D  =  KL(π ‖ π_ref).

It is dimensionless and coordinate-free. Both corners fall out with **no case analysis**: discrete → `Σ_s w_s ln(w_s / w_s^ref)` (finite Shannon-KL); continuous → the closed Gaussian form. The conservation degeneracy **vanishes on its own**, because `π` and `π_ref` share the same constraint subspace `ker C`: the singular directions cancel in the density ratio, so `D` is automatically computed on the quotient `ℝ^d / ker C` — **no pseudo-determinant, no epicycle, natural on the quotient**. Shannon entropy re-enters as the corner of `D` against the uniform prior: `KL(w ‖ unif) = n ln 2 − H(w)`. Attestation is monotone: `D` to the attested reference decreases — "attestations sharpen" *is* `D↓`. The Fisher metric `g` is its infinitesimal shadow, `D(π_θ ‖ π_{θ+dθ}) = ½ dθᵀ g dθ`, degenerate along the *same* normals, hence a metric on the *same* quotient — the same story at second order.

**Conclusion.** Ledger *entropy* as an absolute number does not make sense — it is not invariant, it diverges at the discrete corner, and it needs an epicycle at the conservation degeneracy. Ledger *surprisal against a reference* does make sense. The functional is `D = KL(π ‖ π_ref)`.

## Minimal symbol table (≤10)

| symbol | meaning |
|---|---|
| `n` | number of events |
| `s ∈ 2^n` | candidate-log configuration (which events admitted) |
| `w_s` | configuration weight, from accuracies `p_i`; sharpened by attestation |
| `μ_s, Σ_s` | state law given `s` (`Σ_s` singular on conservation normals `ker C`) |
| `N` | Gaussian |
| `π = Σ_s w_s N(μ_s, Σ_s)` | **the ledger posterior** — the one object |
| `π_ref` | reference (prior, or attested truth) |
| `H` | entropy (Shannon on the discrete layer, differential on the continuous) |
| `D = KL(π ‖ π_ref)` | **the functional** — ledger surprisal |
| `g` | Fisher metric `= ½ Hess D` |
