# Ledger Entropy — Session 1, MILEWSKI (categorical probability)

*Exploratory, non-normative. A negative result is a success. This note is charter-exempt from
the category-theory-second-telling rule, but obeys it in spirit: one concrete miniature first,
the abstraction second.*

## 0. One concrete move, before any category

One transaction: wallet A pays wallet B a quantity `q` of a unit, marked at a price. The
**quantity** legs are `+q` and `-q`; they sum to zero by construction, no matter what anyone
observed. The **price** is a true-but-unknown number `θ`. The log does not record `θ`; it
records a noisy reading `y = θ + ε`, `ε ~ N(0, σ²)`. Prior belief `θ ~ N(μ₀, τ₀²)`.

Three things happen, and they are three different arrows:

- **Apply** (the fold step). Given the recorded `y`, the state advances *deterministically*:
  balances move by `±q`, valuation posts at `y`. Same input, same output. No randomness here.
- **Observe** (the channel). `θ ⇝ y` is a Gaussian kernel. This is the *only* place noise
  enters. Posterior `θ | y ~ N(μ₁, τ₁²)` with `1/τ₁² = 1/τ₀² + 1/σ²`.
- **Attest.** A custodian independently reports `y' = θ + ε'`, `ε' ~ N(0, σ'²)`,
  `ε' ⟂ ε | θ`. Precision *adds*: `1/τ₂² = 1/τ₀² + 1/σ² + 1/σ'²`. The posterior *sharpens*.

The separation to hold onto: **the conserved quantity carries no uncertainty; the uncertainty
lives entirely on the valuation channel.** Conservation is noiseless because it is a group
identity (`+q` and `−q` cancel deterministically), not an observation.

## 1. The category — where the question becomes well-posed

Work in **Stoch**, the Kleisli category of the Giry monad `𝒢` (equivalently `BorelStoch`):

- **objects** = measurable spaces (state spaces, value spaces `Θ`, reading spaces `Y`);
- **morphisms** `X → Y` = Markov kernels (stochastic maps);
- **deterministic** morphisms = those factoring through Dirac `δ`; by Fritz's theorem these
  are exactly the maps that commute with `copy`. `Stoch` is a symmetric monoidal (Markov)
  category with `copy` and `delete`.

The noisy log is a **composite kernel**. For events `e₁,…,eₙ` with true values
`θ = (θ₁,…,θₙ)`:

```
        c_σ₁ ⊗ ⋯ ⊗ c_σₙ                 fold  =  step_eₙ ∘ ⋯ ∘ step_e₁
  Θ  ───────────────────────►  Y   ─────────────────────────────────────►  S
       Gaussian channels           deterministic (Dirac) — the fold
```

`c_σ : Θ → Y`, `θ ↦ N(θ, σ²)` is the observation channel (stochastic). `fold : Y → S` is a
*deterministic* kernel: the map-then-apply fold, composed in event order. The whole log is one
arrow `Θ → S` in `Stoch`.

**Order lives in the composition.** `fold` is a sequential composite; composition in a category
is non-commutative in general, which is precisely the ledger's Order. Disjoint-footprint events
act on independent tensor factors, and the interchange law
`(f ⊗ id) ∘ (id ⊗ g) = (id ⊗ g) ∘ (f ⊗ id)` makes exactly those commute — no more, no less.

**Posterior = Bayesian inversion.** Given prior `p` on `Θ` and channel `c`, the posterior is the
Markov-category Bayesian inverse `c†ₚ : Y → Θ` (Cho–Jacobs), the arrow that makes the joint
factor both ways. For Gaussian prior + Gaussian channel it is the conjugate Gaussian of §0.
Attestation is post-composition of a *second* channel; its inverse sharpens the posterior. So
"posterior" and "attestation sharpens it" are not add-ons — they are inversion and composition.

## 2. Where information loss actually lives (Baez–Fritz–Leinster)

BFL characterize entropy as **information loss along a morphism**: functorial, additive under
composition, continuous, homogeneous — and those force it up to a scalar. Ask where, in the
composite `Θ →(observe)→ Y →(fold)→ S`, information is actually lost. Three loci, three verdicts:

1. **Apply / fold, `Y → S`.** Deterministic. But deterministic is *not* injective: many logs
   fold to the same state (a balance is a sum; different move orders give the same total). So the
   fold loses **combinatorial** information — `H(log) − H(state) ≥ 0`, the BFL Shannon
   information loss of a measure-preserving map. This is nothing to do with noise. It is the
   ledger's own thesis restated: *the state is a lossy projection of the log.* The log is
   primary; the state discards.

2. **Observe, `Θ → Y`.** This is where **noise** lives. The channel loses information about `θ`;
   the residual is the posterior. The functional here is `I(θ; y)` (nats bought) or the residual
   posterior spread. Not Shannon-of-a-state — a property of the *channel*.

3. **Attest.** A second channel; *negative* loss about `θ` — information *gain*. Chain rule (§3).

So: on the **apply arrow**, stochastic information loss is zero (deterministic) but combinatorial
projection loss is positive; on the **observe arrow**, the noise loss is positive; conservation
(the `±q` identity) sits inside apply and loses nothing.

## 3. Compositionality — the one structural claim I would defend

**Information loss is a monoid homomorphism.** BFL functoriality says loss is additive under
composition: `F(g ∘ f) = F(g) + F(f)`, i.e. a functor into the one-object category
`(ℝ≥0, +)`. Restricted to the fold, this is precisely a **monoid homomorphism from the free
monoid of events `([Event], ++)` into `(ℝ≥0, +)`** — the same `foldMap`-into-a-monoid shape that
already carries deterministic replay in this codebase. Three consequences fall out *for free*,
not as tests:

- **Checkpoint-independence.** A checkpoint just factors the fold `L = L₂ ++ L₁`; additivity
  gives `F(L) = F(L₂) + F(L₁)`. The total loss cannot depend on where you cut.
- **Order-insensitivity of the total.** `(ℝ≥0, +)` is *commutative*. So reordering
  disjoint-footprint events — which the interchange law already permits — leaves the total loss
  unchanged. The functional respects Order automatically because it lands in a commutative monoid.
- **Independent noise adds; correlated evidence chains.** For independent truths/observations,
  `H(p ⊗ q) = H(p) + H(q)` — tensor additivity. For repeated readings of the *same* `θ`
  (attestations), the relative-entropy chain rule
  `D(p(x,y) ‖ q(x,y)) = D(p(x)‖q(x)) + 𝔼ₚ D(p(y|x)‖q(y|x))` under `ε ⟂ ε' | θ` gives
  `I(θ; y, y') = I(θ; y) + I(θ; y' | y)`, each term `≥ 0` and **monotone** — every attestation
  reduces posterior entropy — but with **diminishing marginal returns** (Gaussian precision grows
  like `n/σ²`, so posterior entropy falls only like `−½ log n`).

## 4. Verdict — the natural object is the arrow, not the state

**"Ledger entropy" as a single scalar attached to a ledger state is not the natural object.**
Two reasons, one categorical, one measure-theoretic:

- *Categorical.* The ledger makes the **log** primary and the **state** a projection. The entropy
  that respects that architecture is a functional of the **arrow** (BFL information loss), which
  is functorial = additive under the fold, hence checkpoint-independent and Order-insensitive by
  construction (§3). A state-scalar has none of this for free.
- *Measure-theoretic.* An absolute entropy-of-state is differential entropy `h`, and `h` is not
  coordinate-free: `h(AX) = h(X) + log|det A|`, so cents-vs-dollars changes its value and even its
  sign; and under exact conservation the posterior lives on a proper subspace, where `det Σ = 0`
  and `h = −∞`. (This is JACOBI's impossibility from the object side; I reach the same wall from
  the arrow side — an independent convergence, not a borrowed result.)

**So entropy-of-state is derived, not primitive.** What is primitive and invariant is a *pair of
arrow-functionals*, and they should not be fused into one number:

1. **Projection loss** `F_proj = H(log) − H(state)` — BFL functor, additive, noiseless; measures
   how lossy the state-projection is.
2. **Evidence gain** `F_gain = D(posterior ‖ reference)` / `I(θ; readings)` — relative entropy of
   the noisy posterior against a canonical reference (the attested state, or the `init` prior),
   built by Bayesian inversion and sharpened by attestation via the chain rule.

Both are functionals of *arrows* (fold, and observation channel). Both are unit-invariant and
degeneracy-safe (relative entropy needs only `p ≪ q`, automatic when both live on the same
constraint subspace). The tempting single "ledger entropy" is either the non-invariant `h` (reject)
or a conflation of two different arrows (reject). Keep them apart.

**Candidate to defend.** *In `Stoch`, the noisy log is `fold ∘ (⊗ c_σᵢ) : Θ → S`. Information loss
is the unique (up to scale) functor from this composite into `(ℝ≥0, +)`; on the fold it is a monoid
homomorphism `([Event],++) → (ℝ≥0,+)`, whence checkpoint-independence and Order-insensitivity of the
total. No reparameterization-invariant scalar entropy of a state exists (units + conservation-degeneracy).
The invariant objects are the projection loss `H(log)−H(state)` and the relative entropy of the
posterior to the attested reference; entropy-of-state is derived from these, never primitive.*

**Self-checks.** No observation (`σ → ∞`): channel is deletion, `F_gain = 0`, posterior = prior. ✓
Zero-noise attestation (`σ' → 0`): posterior collapses onto `{θ : θ = y'}`, `F_gain → ∞`, ambient
`h → −∞` — the two diverge together, which is exactly why `h` is abandoned and `F_gain`/`D` kept. ✓
Reorder two disjoint moves: interchange law holds, `F_proj` unchanged (commutative codomain). ✓
Concatenate logs at any checkpoint: `F` splits additively. ✓
