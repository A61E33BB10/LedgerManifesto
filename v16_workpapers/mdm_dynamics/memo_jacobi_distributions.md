# JACOBI — Distributional objects for the realism gate (MDM dynamics amendment)

Support to GATHERAL. Defines at principle level the functionals, their historical
distributions, the percentile, and the joint objects Gate 2 (realism) tests — every
object deterministic given the state and the declared terms. No estimator, no
threshold, no numerics.

**Setup.** A **market-data state** `m` is a calibrated, arbitrage-free configuration
for one underlying `u`: an implied-vol surface `σ(m; m̆,ℓ_F,T)` (`m̆=ln(K/F)`, Vol I
§2.1.1 Eq. (2.1)), a rate/discount curve, a dividend/repo curve, a correlation block.
`m_u(t)` is `u`'s state **as known at cut `t`**. A **functional** is a deterministic
map `Φ: m ↦ Φ(m) ∈ ℝ` (or `ℝ^k`, §4), defined before use.

## (1) The functionals

Let `w(T;m) := K_var(T;m)·T` be the state's variance-swap **total variance** to tenor
`T`, `K_var` the varswap fair strike in annualised variance units (Vol I §4
*Reference Products*; realized-variance economics — a long option is long realized
variance vs implied — Vol I §1.5, Prop. 1.10, Eq. (1.15)).

- **Forward variance swap** on `[T1,T2]`, `T1<T2` (the strip between two tenors):
  `FV(T1,T2;m) := [w(T2;m) − w(T1;m)]/(T2−T1)`; `≥ 0` and well-defined when the state
  is calendar-arbitrage-free (`w` nondecreasing in `T`, Vol I §2.6).
- **Forward dividend yield** on `[T1,T2]`: with `F(T;m)=S·exp(∫₀ᵀ(r−q))`,
  `q_fwd(T1,T2;m) := r_fwd(T1,T2;m) − [ln F(T2;m) − ln F(T1;m)]/(T2−T1)` — the yield
  the state's forward and rate curves imply over the window.
- **1m–1y implied-vol spread**: with `σ_ATM(T;m)=σ(m;0,·,T)`,
  `ATMspread(m) := σ_ATM(1y;m) − σ_ATM(1m;m)`.
- **Total expected dividend** to horizon `H`: `Dtot(m;H) := Σ_{t_i ≤ H} d_i(m)`
  (undiscounted, or discounted per a declared convention; Vol I §4 *Dividend/repo*).

## (2) The historical distribution of a functional

For `Φ`, underlying `u`, and declared history terms — window `W`, cadence `δ`,
regime-boundary treatment `ϱ` — the historical distribution is the sequence
`H[Φ,u] := ( Φ(m_u(t_j)) )` over `t_j ∈ grid(W,δ)`, each `m_u(t_j)` read **at its own
cut** `t_j` (as-known: as-of/as-at, MD-4; the backtesting amendment's served-history).
So `H[Φ,u]` is the as-known empirical distribution of `Φ` over `u`'s **own** past
states, never restated with later corrections. `W, δ, ϱ` are governance parameters —
recorded, versioned, attestable, never manifesto constants; `ϱ` fixes whether the grid
is segmented or truncated across declared structural breaks.

## (3) The percentile; realistic vs conservative

For a candidate derived state `m*` with `v = Φ(m*)`, the **percentile**
`P(v; H[Φ,u], 𝔓) ∈ [0,1]` is deterministic given the value, the declared history, and
a declared **percentile-estimator convention** `𝔓` (rank rule, interpolation, tail
handling) — a recorded term shared by comparing parties, same discipline as the VM
dispersion rule `D` and the attribution convention (VM-5).

The gate is a declared **acceptance region** `A ⊆ [0,1]` in percentile space, per
functional, per underlying: **realistic** = the standard region (two-sided central
band, or one-sided where the functional has a single danger direction);
**conservative** = a strictly smaller region `A_c ⊂ A` (tighter and/or one-sided —
the value must lie well inside, not merely within, historical support). One- vs
two-sided/tighter is a declared property of the gate — structure only, no numbers.

## (4) The joint objects (the essential part)

Let `Φ_vec(m) := (Φ⁽¹⁾(m),…,Φ⁽ᵏ⁾(m))` be a **vector-valued** functional: forward
variance swaps across the declared tenor set `(FV(T₀,T₁),…,FV(T_{k−1},T_k))`, or ATM
vols at declared tenors `(σ_ATM(T₁),…,σ_ATM(T_k))`. Its **joint historical
distribution** is the history of the vector `H[Φ_vec,u] := ( Φ_vec(m_u(t_j)) ) ⊂ ℝ^k`,
a point cloud under the same declared `W, δ, ϱ`, as-known. **Joint realism** is the
plausibility of `Φ_vec(m*)` against that cloud, per a declared **joint-plausibility
convention** `𝔓_joint` (a multivariate depth / region rule — structure, not estimator).

**Why marginals are insufficient.** Each coordinate `Φ⁽ⁱ⁾(m*)` can sit inside its own
percentile band while the vector lies outside the cloud — marginals discard the
historical dependence among coordinates. **Counterexample (two tenors):** an inverted
forward-variance term structure `FV(T₀,T₁) > FV(T₁,T₂)`, each leg an individually
common level but whose inversion essentially never co-occurred historically, sits in an
empty region of the joint cloud though both margins are central. Declared for joint
realism: the functional vector (coordinates + tenor set) and `𝔓_joint` (structure),
plus the shared `W, δ, ϱ`.

## (5) Hypotheses — for the gates to be decidable at application time

- **H1 (history exists).** A finite, nonempty declared history of as-known states
  `m_u(t_j)` is on the record for `u` over `W` at cadence `δ`; else Gate 2 has no
  distribution and is undefined.
- **H2 (computability).** Every functional, and every coordinate of `Φ_vec`, is
  computable from `m*` — `m*` carries the surfaces/curves each reads to the required
  tenors; else `v` does not exist.
- **H3 (conventions declared).** `W, δ, ϱ, 𝔓, A/A_c, 𝔓_joint` are declared, recorded,
  versioned, per functional per underlying, shared by any two parties (dispute-
  readiness; discipline of VM-5).
- **H4 (as-known integrity).** Each historical state is read at its own cut (MD-4), so
  `H` holds as-known values, never look-ahead-restated ones.

Under H1–H4: **Gate 1** (no-arbitrage) is decidable because `m* ∈ Θ_AF` by
construction (Vol I §2.6 admissibility ladder; Ch. 4 Axiom A3); **Gate 2** (realism) is
decidable because the percentile — or joint depth — of `Φ(m*)` against `H` is a
deterministic computation.

**Declared-terms list** (all recorded, versioned, attestable; no manifesto constants):
window `W` · cadence `δ` · regime-boundary treatment `ϱ` · percentile-estimator
convention `𝔓` · acceptance region `A` (realistic)/`A_c` (conservative), one- vs
two-sided, per functional · functional vector (coordinates + tenor set) ·
joint-plausibility convention `𝔓_joint`.
