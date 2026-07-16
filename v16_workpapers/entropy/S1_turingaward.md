# Ledger Entropy — S1 (TuringAward, independent formalization)

**Mode:** exploratory, non-normative. Negative result is the target. **Doctrine:** classify before you name (§2).

## 0. Classification (the verdict, up front)

**This is a linear-Gaussian estimation problem wearing an entropy costume.** Restrict every
event to `observed = true + Gaussian noise` and add the ledger's linear conservation equalities,
and the object you have is a **constrained Kalman / information filter over a Gaussian Markov
random field**: a true state vector `x`, sparse noisy linear observations of it, and a posterior
`p(x | history) = N(μ, Σ)` that is Gaussian at every step. There is no new object here. Every
candidate "entropy" is a classical scalarization of the posterior covariance `Σ`:
`log det Σ` (D-optimality = differential entropy), `tr Σ` (A-optimality), `λ_max(Σ)`
(E-optimality). "Ledger entropy" is the differential entropy of the *estimation posterior* —
D-optimality under Shannon's name. It is **not** source entropy: the immutable log is a record,
not a stationary source being compressed, so Shannon's `−Σ p log p` over the event alphabet
measures the *generator's* coding rate, never the *state's* uncertainty.

## 1. What is well-defined and what is not

For a Gaussian, `H = c(d) + ½ log det Σ`. Under a coordinate rescale `x → Dx`,
`log det Σ → log det Σ + 2 log|det D|`. So **absolute `H` is defined only up to a constant fixed
by an arbitrary choice of units per coordinate** — and ledger coordinates are incommensurable
(a USD notional, a share count, a vol point). You cannot threshold `H`; the number is not a number.
Two further fragilities of the *level*: conservation constraints pin `k` linear combinations to
exactly zero variance, so `Σ` is rank-deficient and naive `log det Σ = −∞` unless you correctly
quotient to the `d−k` free coordinates; and `H` is non-monotone — it *rises* benignly whenever a
position opens (fresh latent coordinate) or time passes under process noise, and falls only when
observations arrive. The "spikes" are dominated by position lifecycle, not by data quality.

**The one invariant object.** The *difference* along a fixed coordinate frame cancels the unit
constant. The relative entropy prior→posterior — the **information gain** of an event —
`ΔH = ½ log(|Σ_prior| / |Σ_post|)` — is unit-invariant, lives inside the free subspace (robust to
the conservation quotient), and equals the expected mutual information `I(x; y)` of the observation.
This is the functional that survives. It is exactly the Bayesian experimental-design criterion
(Lindley 1956) — not a novel "ledger entropy."

*Aside on `p_i`.* Read as a noise variance `R_i`, per-event accuracy is clean (high `p` = low `R`
= high `ΔH`). Read literally as "probability the event is accurate," it is a mixture (good Gaussian
w.p. `p_i`, garbage w.p. `1−p_i`): the posterior is no longer Gaussian, entropy loses its closed
form, and you are in robust filtering. Whether `p_i` is *learnable* from attestation agreement
rates is a PAC-style source-reliability question (Valiant), orthogonal to the entropy functional.

## 2. Related-work spine (11 entries — contribution / which part of THIS question)

1. **Shannon 1948** — entropy as the coding rate of a source. / Fixes what entropy is *not* here:
   the log is a record, not a source; `−Σp log p` scores the generator, not the state.
2. **Jaynes 1957 (max-ent)** — the least-committed distribution under moment constraints. / Says the
   *prior* the filter starts from is the max-ent one given the conservation moments.
3. **Kalman 1960** — recursive optimal estimator for linear-Gaussian state-space. / **The actual
   engine.** The ledger-under-restriction *is* a Kalman/information filter; `Σ` is its output.
4. **Kullback–Leibler 1951** — relative entropy between two laws. / The invariant object: prior→
   posterior KL = the information gain that survives when absolute entropy does not.
5. **Amari (info geometry / Fisher)** — Fisher information as the metric on statistical manifolds;
   `Σ⁻¹` is the Fisher information for a Gaussian. / Recasts "entropy budget" as a Fisher-information
   volume; D-optimality is a determinant on this metric.
6. **Baez–Fritz–Leinster 2011** — a characterization of entropy as information *loss* under
   measure-preserving maps. / Tests whether "ledger entropy" is a functor of the fold; it
   characterizes *loss*, and the ledger's fold is lossless replay, so the honest analogue is gain,
   not entropy.
7. **Fritz 2020 (Markov categories)** — a synthetic language for conditionals and Bayesian inversion.
   / The *second telling* only: it names the prior→posterior update the filter already performs; no
   proof here may rest on it (CLAUDE.md §4).
8. **Pearl (belief propagation)** — exact marginal inference on trees/sparse graphs. / The *feasible*
   computation: the Gaussian information form propagates on the coordinate-dependency graph; log det
   and marginals are BP / sparse Cholesky on that graph.
9. **Valiant (PAC)** — learnability with sample bounds. / Frames "probability an event is accurate"
   as a learnable source-reliability parameter, estimated from attestation outcomes — not a property
   of the entropy functional.
10. **Dempster–Shafer / imprecise probability** — belief without a single prior; sets of measures. /
    The layer the Gaussian restriction *deleted*. Under `true + Gaussian`, epistemic ambiguity
    collapses to one covariance; D–S is what you would need back if `p_i` were an interval, not a number.
11. **Lindley 1956 (Bayesian experimental design)** — choose the experiment maximizing expected
    information gain. / **The load-bearing entry for the keep reading**: attestation scheduling by
    max expected `ΔH` is D-optimal design, a named, principled policy.

*Audit-risk cite.* **None is canonical in an information-theoretic sense.** The AICPA audit-risk
model `AR = IR × CR × DR` (SAS No. 47, 1983; now ISA 200 / AU-C 200) is a heuristic product of
subjective probabilities, not an entropy or information functional. Report it as prior art for
"risk as a scalar," and flag that it has no derivation the ledger could reuse.

## 3. Engineering reality

**The global scalar is fantasy-to-marginal.** `Σ` is `d×d` with `d` = live coordinates ~ 10⁶–10⁷.
Dense `Σ` is 10¹²⁺ entries; a naive Kalman update is `O(d²)–O(d³)` — a non-starter. Structure is the
only hope: observations are sparse (an attestation touches a handful of positions), so track the
**information form** `Λ = Σ⁻¹` (a Gaussian graphical model), where each event is a small sparse
rank-update. Then `log det Σ = −log det Λ` via sparse Cholesky, cost governed by the **treewidth**
of the coordinate-dependency graph. Near-tree (bounded treewidth, which locality + conservation
plausibly give) → `O(d)`, feasible; expander-like → `O(d³)`, fantasy. **The verdict on the global
number hinges on a treewidth that must be measured, not assumed** — and even when cheap, the number
is unit-hollow (§1). Cost L4/L6; representation risk L9 (`log det` of a near-singular sparse SPD
matrix is a cancellation-prone, conditioning-sensitive computation).

**The actionable number is cheap and local.** The keep reading needs no global log det. The gain
from an observation touching coordinate set `S` is
`ΔH = ½ log det(I + R⁻¹ H Σ_S Hᵀ)`, requiring only the **marginal covariance `Σ_S` on the few
touched coordinates** — a selected inversion (Takahashi) off the sparse factor, `|S|×|S|`. Feasible
today.

**What the operator does with it.**
- **KEEP — attestation prioritization = maximal expected information gain.** A real scheduling
  policy: point the scarce attestation/re-observation budget at the observation whose expected `ΔH`
  (weighted by the coordinates that matter for reporting) is largest. This is D-optimal design
  (Lindley 1956; Kiefer). It is invariant, local, cheap, and it justifies the entire exercise.
- **DECORATION — alarm thresholds on absolute entropy spikes.** Unit-dependent, quotient-fragile,
  lifecycle-dominated, and expensive to compute globally. The genuine anomaly signal is the
  **innovation / NIS check** — Mahalanobis distance of `(observation − prediction)` against its
  predicted covariance, `χ²`-distributed — which is standard Kalman consistency and needs no entropy
  vocabulary. Dressing it as "entropy monitoring" adds a costume, not a detector.

## 4. Declaration

Lenses applied: **L10** (learning/inference — the estimation classification), **L4** (complexity —
treewidth/log det cost), **L6** (systems — global-vs-local), **L9** (numerical — `log det` near
singularity), **L2** (the immutable log as the filtration). Lenses dismissed: **L1/L7** (no
consensus or network surface in the functional itself); **L8** (attestation *authenticity* is real
but orthogonal to the entropy question). Confidence: **HIGH** on the classification and the
invariance argument; **MEDIUM** on global-feasibility — the single biggest unknown is the measured
**treewidth** of the coordinate-dependency graph, which decides feasible vs. fantasy for any global
scalar (and does not affect the local keep reading).
