# S1 — FORMALIS rigor pass on "Ledger Entropy"

**Role.** Rigor veto. Nothing ships labelled *Theorem/Proposition* unless a complete proof
fits a 5-page note. Unproven ⇒ *Conjecture* or *Heuristic*, explicitly. Exploratory,
non-normative. A negative result is a success.

**Model under review.** True state `x ∈ ℝ^d`. Attestations record observed values
`y_i = H_i x + v_i`, `v_i ~ N(0, R_i)`, `R_i ≻ 0`. Fold is deterministic given the log.
Conservation is *exact* (paired legs): a linear law `C x = c`, `rank C = r`. A discrete layer
carries uncertainty over which of finitely many candidate logs is true (per-event accuracies
`p_i`). "Ledger entropy" is a functional of the state posterior and/or the discrete layer.

---

## 1. Claims the seminar will want, with hypotheses and verdict

**(a) Attestation reduces differential entropy.** *Hyp:* prior `N(μ, Σ)` proper on the free
subspace (`Σ ≻ 0` there), linear `H`, `R ≻ 0`. *Claim:* posterior Gaussian, and
`Σ' = Σ − ΣHᵀ(HΣHᵀ+R)⁻¹HΣ ⪯ Σ`, hence `h' ≤ h`.
**PROVABLE — Proposition.** Info form `Σ'⁻¹ = Σ⁻¹ + HᵀR⁻¹H`; `Σ−Σ' = ΣHᵀ(HΣHᵀ+R)⁻¹HΣ ⪰ 0`
(form `MᵀAM`, `A ≻ 0`); `det` monotone under Loewner order on PD matrices. *Strictness* `h' < h`
**iff** `HᵀR⁻¹H ≠ 0` on the free subspace, i.e. `H` loads on at least one non-degenerate
direction: `det(I + Σ_S H_Sᵀ R⁻¹ H_S) > 1 ⟺ H_S ≠ 0`. Fits 1 page.
Trap: attestation of an already-pinned or degenerate direction gives **equality**, not strict
decrease — the "attestation always informs" reading is false without the strictness hypothesis.

**(b) Conservation ⟹ ambient entropy undefined; well-defined only on the constraint subspace.**
*Claim:* exact `Cx=c` ⟹ support is the affine subspace `S = {Cx=c}` (Lebesgue-null in `ℝ^d`),
so `CΣ = 0`, `det Σ = 0`, ambient `h = ½log((2πe)^d det Σ) = −∞`; restricting to `S` with its
own `(d−r)`-Lebesgue measure gives finite `h_S = ½log((2πe)^{d−r} det Σ_S)`.
**PROVABLE — Proposition (elementary).** Caveat: `h_S` depends on the chosen measure/basis of
`ker C` — "well-defined" means *up to a declared reference*, not absolutely (see (c)).

**(c) Differential entropy is not reparameterization-invariant.** For invertible `y=g(x)`,
`h(Y) = h(X) + E[log|det J_g|]`; linear `y=Ax` gives `+log|det A|`.
**PROVABLE — Proposition (standard; cite Cover–Thomas ch. 8, one-line change-of-variables).**
Consequence: an *absolute* "ledger entropy" number changes with units (dollars↔cents:
`+d·log 100`) and with the `ker C` basis. Only differences, `KL`, and mutual information are
invariant. This kills any claim that a single scalar `h` measures "ledger disorder" per se.

**(d) A "second law" (entropy non-decreasing between attestations).**
**DIES AS STATED.** With deterministic fold and no stochastic dynamics, the posterior does not
diffuse: affine moves push forward measure-preservingly on `S` (conservation-preserving
transfers have `|det| = 1`), so `h` is **constant**; a rescaling move shifts `h` by a
*deterministic* `log|det|` of either sign — not a law. The only monotone move is the *decrease*
at attestations (a). A genuine non-decrease requires an injected process-noise/diffusion prior
`Q ⪰ 0` (`Σ ↦ FΣFᵀ + Q`), which is a **modeling choice**, not forced by the framework.
Verdict: **Heuristic**, and only *conditional on a declared `Q`*. Honest picture is a sawtooth
(predict-up if `Q`, update-down), degenerating to flat-then-down under pure determinism.

**(e) Discrete–continuous chain rule.** With `K` = discrete config, `X` = state,
`H(K,X) = H(K) + Σ_k P(k) h(X|K=k)`.
**PROVABLE AS AN IDENTITY** (direct expansion against counting×Lebesgue reference). **But the
interpretation is unit-inconsistent and is the sharpest obstruction:** `H(K)` is dimensionless
Shannon (bits, ≥0, invariant); `h(X|K=k)` is differential (units, sign-indefinite, non-invariant).
Their *sum* inherits the reparameterization dependence of the continuous part — adding bits to
"nats-with-units." Fix: (i) fix a quantization scale `δ` and use `H_δ(X) ≈ h(X) − d log δ`
throughout (all discrete, additive, consistent); or (ii) keep the **pair** `(H(K), h(X|K))` and
never sum; or (iii) go relative (`KL`) on both. Ships only with one of these declared.

**(f) Entropy of the marginal (mixture) posterior has no closed form.** Marginalizing `K` gives
a Gaussian mixture `Σ_k P(k) N(μ_k, Σ_k)`; its differential entropy has no closed form.
**TRUE — cite** (Huber et al. 2008); only bounds/approximations. So the single marginal scalar
is not even computable in closed form — reinforcing use of the decomposition (e) or bounds.

## 2. Traps (where the committee will over-claim) → fix

1. **"Entropy of the log" vs "of the state."** The realized log is *known data* — zero entropy.
   Uncertainty lives in (i) which candidate log is true (discrete `p_i`) and (ii) state given a
   log (Gaussian noise). *Fix:* name which object; never conflate `H(log)`, `h(state|log)`,
   `H(K,X)`. Deterministic fold creates no entropy.
2. **Invariance.** Absolute `h` is not a physical quantity. *Fix:* report only invariants —
   `KL`, mutual information, entropy *differences*.
3. **Second law.** See (d): flat/decreasing under determinism. *Fix:* label Heuristic, declare `Q`.
4. **Bits + nats.** See (e). *Fix:* quantize (`δ`), or keep the pair, or go relative.
5. **`det Σ = 0` ≠ "infinite information."** It means the ambient measure is wrong (b), not that
   uncertainty vanished. *Fix:* compute on `S`, dimension `d−r`.
6. **Clean functional exists.** Information gained per attestation
   `½ log det(I + Σ_S H_Sᵀ R⁻¹ H_S) ≥ 0` is invariant, non-negative, closed-form, and *is* the
   mutual information `I(X;Y)`. This — not absolute `h` — is the well-posed "ledger entropy."

## 3. Well-posedness criteria FORMALIS will enforce on any candidate definition

(W1) **Reference declared** — every differential quantity names its measure (units, `ker C` basis).
(W2) **Invariance or convention** — report an invariant (`KL`, `I`, difference), or fix and state
a canonical convention.
(W3) **Correct support/dimension** — on `S`, dimension `d−r`, not ambient `d`.
(W4) **No unit-mixing** — never sum Shannon bits and differential nats without a declared `δ`.
(W5) **One named object** — of-the-log / of-the-state-given-log / of-the-config / joint.
(W6) **Dynamics carried** — any increase/second-law claim names the stochastic prior producing it.
(W7) **Existence** — mixture-marginal entropy invoked only with a bound or a "no closed form" note.
