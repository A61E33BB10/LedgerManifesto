# Ledger Entropy — Session 1, JACOBI (analysis)

*Exploratory, non-normative. A negative result is a success.*

## 0. Setup: what is random, and where it lives

Fix a valuation time. Let the **true ledger state** be a vector $x \in \mathbb{R}^n$: one real coordinate per (unit, wallet-coordinate) whose value the log claims to know. The state itself is not random — it is a fixed unknown. What is random is our *belief* about it, given a log of noisy observations. So the object of study is a **posterior distribution** $p(x \mid \text{log})$ over $\mathbb{R}^n$, and any "ledger entropy" is a functional of that posterior, not of the ledger.

**Assumptions (stated, and flagged where they can fail).**
- (A1) *Linear observations.* Each observation event records $y = Hx + \varepsilon$, with $H \in \mathbb{R}^{m\times n}$ a known matrix (which linear combinations of true values are seen) and $\varepsilon \sim \mathcal{N}(0,R)$, $R \succ 0$. Fails for non-linear valuations (options); there the posterior is only *locally* Gaussian and everything below holds to second order.
- (A2) *Gaussian prior.* $x \sim \mathcal{N}(\mu_0,\Sigma_0)$. With (A1) this is conjugate: the posterior stays Gaussian and the fold propagates $(\mu,\Sigma)$ exactly.
- (A3) *Exact conservation.* Wallet sums vanish identically: $Cx = b$ for a known $C\in\mathbb{R}^{k\times n}$, $\operatorname{rank} C = k$. This is structural, **not** observed with noise. Write $d := n-k$ for the free dimension, $V_0 := \ker C$, $V := \{x: Cx=b\}$.

## 1. Gaussian propagation through the fold (Kalman form)

**Claim.** Under (A1)–(A2), one observation maps $\mathcal N(\mu_0,\Sigma_0)\mapsto\mathcal N(\mu_1,\Sigma_1)$ with, in information form,
$$\Lambda_1 = \Lambda_0 + H^{\!\top}R^{-1}H,\qquad \Lambda_1\mu_1 = \Lambda_0\mu_0 + H^{\!\top}R^{-1}y,\qquad \Lambda:=\Sigma^{-1}.$$
Covariance (Kalman) form: $K=\Sigma_0H^{\!\top}(H\Sigma_0H^{\!\top}+R)^{-1}$, $\ \mu_1=\mu_0+K(y-H\mu_0)$, $\ \Sigma_1=(I-KH)\Sigma_0$.

**Entropy change.** With $h(\mathcal N(\cdot,\Sigma))=\tfrac12\log\det(2\pi e\,\Sigma)$,
$$\Delta h = \tfrac12\log\frac{\det\Sigma_1}{\det\Sigma_0} = -\tfrac12\log\det\!\big(I+\Sigma_0H^{\!\top}R^{-1}H\big)\le 0 .$$
*Derivation.* $\Lambda_1=\Lambda_0(I+\Sigma_0H^{\!\top}R^{-1}H)$, so $\det\Sigma_1/\det\Sigma_0=\det\Lambda_0/\det\Lambda_1=\det(I+\Sigma_0H^{\!\top}R^{-1}H)^{-1}$. The quantity $-\Delta h=\tfrac12\log\det(\cdot)\ge0$ is exactly the mutual information $I(x;y)$ — the nats the observation buys. *Remark: an observation never raises entropy; equality iff $H=0$.*

**Attestation.** An attestation confirms an earlier observation: a second reading $y'=Hx+\varepsilon'$, $\varepsilon'\sim\mathcal N(0,R')$, of the **same** functional $H$. It is one more information update $\Lambda\mapsto\Lambda+H^{\!\top}R'^{-1}H$. In the hard limit $R'\to0$ (perfect confirmation), $Hx$ becomes known exactly: the posterior collapses onto $\{x:Hx=y'\}$, $\Sigma$ drops rank in those directions, and $h\to-\infty$. *This limit already exhibits obstruction 3 — a certain observation is a deterministic constraint, and it kills the ambient determinant.*

## 2. Obstruction I — reparameterization (units)

Differential entropy is **not** a property of the posterior; it is a property of the posterior *plus a chart and a base measure*. Under a smooth invertible change of value-coordinates $x=\phi(z)$,
$$h(Z)=h(X)+\mathbb E\big[\log|\det J_\phi|\big];\qquad\text{for }x\mapsto Ax:\quad h(AX)=h(X)+\log|\det A|.$$
Cents vs dollars over $d$ live coordinates ($A=100\,I$) shifts $h$ by $d\log 100$ — the value, and even its **sign**, is a unit artifact. Root cause: $h(X)=-D(p\,\|\,\text{Leb})$, relative entropy to Lebesgue measure, and **Lebesgue is not canonical** under reparameterization.

*What this kills:* every absolute statement — "$H$ nats of ledger uncertainty," any threshold, any cross-ledger comparison at differing scale. *What survives* (Jacobians cancel because the reference is itself a density): **relative entropy** $D(p\|q)$; **mutual information** $I=D(p_{XY}\|p_Xp_Y)$ — so the gain $\tfrac12\log\det(I+\Sigma_0H^{\!\top}R^{-1}H)$ of §1 is invariant, even though $h$ is not; and the **Fisher metric** $g_{ij}=\mathbb E[\partial_i\log p\,\partial_j\log p]$, which transforms as a $(0,2)$-tensor and gives the invariant volume $\sqrt{\det g}$. For the Gaussian mean-family, $g=\Sigma^{-1}=\Lambda$, and $D(p_\theta\|p_{\theta+d\theta})=\tfrac12 g_{ij}\,d\theta^i d\theta^j+O(d\theta^3)$: the Fisher metric is the infinitesimal form of KL.

## 3. Obstruction II — degeneracy (conservation)

By (A3) the posterior is supported on the affine subspace $V$ of dimension $d<n$. A Gaussian on a proper subspace has **no density** against $n$-dimensional Lebesgue measure: $\Sigma$ is singular, $\det\Sigma=0$, and the naïve $\tfrac12\log\det(2\pi e\,\Sigma)=-\infty$. The functional dies for *every* conserved state.

**Fix — intrinsic entropy on the constraint manifold.** Take $B\in\mathbb R^{n\times d}$ with orthonormal columns spanning $V_0$, coordinates $x=x_p+Bz$. Then
$$\boxed{\,h_V(X)=\tfrac12\log\det\!\big(2\pi e\,B^{\!\top}\Sigma B\big)=\tfrac12\log\!\big[(2\pi e)^d\,{\det}_{+}\Sigma\big]\,}\qquad d=\operatorname{rank}\Sigma,$$
where ${\det}_+$ is the pseudo-determinant (product of nonzero eigenvalues), and the second equality holds because $B$ spans exactly $\operatorname{range}\Sigma$. This is finite.

*Change-of-variables caveat.* $h_V$ depends on the reference metric on $V_0$: under $B\mapsto BM$, $\ B^{\!\top}\Sigma B\mapsto M^{\!\top}(B^{\!\top}\Sigma B)M$ and $h_V\mapsto h_V+\log|\det M|$. So the pseudo-determinant cures the degeneracy but **reintroduces obstruction I on the subspace**: under a unit rescale $x\mapsto sx$, $h_V\mapsto h_V+d\log s$. The two obstructions are independent; fixing the degeneracy does not fix the units.

## 4. Verdict candidate

The ambient differential entropy is *doubly* ill-posed: $-\infty$ by degeneracy, and chart-dependent by units. The pseudo-determinant repairs the first only. Differential entropy of the value space carries no reparameterization-invariant scalar. The invariant content is exhausted by **(a) relative entropy $D(p\|q)$ to a reference** and **(b) the Fisher metric**, which is its infinitesimal form. The framework supplies the missing reference *canonically*: the **attested state** (or the `init` prior). Absolute entropy pretends to a reference-free number the geometry forbids; the honest object measures the *current noisy posterior against the attested reference*, and is unit-invariant and degeneracy-safe by construction.

**Proposition (candidate).** *Under (A1)–(A3) the ledger posterior is Gaussian on $V$, $\dim V=d=n-\operatorname{rank}C$. Then (i) $\tfrac12\log\det(2\pi e\,\Sigma)=-\infty$ for every such posterior; (ii) the intrinsic entropy $\tfrac12\log\det(2\pi e\,B^{\!\top}\Sigma B)$ is finite but satisfies $h_V\mapsto h_V+d\log s$ under $x\mapsto sx$ — no chart-independent value exists. Hence no reparameterization-invariant scalar entropy of a ledger state exists. The invariant quantities are the relative entropy $D(p\|q)$ to a reference $q$ (finite iff $p\ll q$, automatic when both live on $V$), and the total information gain*
$$I \;=\; \tfrac12\log\det\!\big(I_d+\Sigma_{r,0}\,H_r^{\!\top}R^{-1}H_r\big)\quad(\text{subspace coordinates}),$$
*which is finite, non-negative, and invariant under $x\mapsto Ax$ (the argument undergoes a similarity transform, preserving $\det(I+\cdot)$).*

**Self-checks.** Zero-noise attestation $R'\to0$: ambient $h\to-\infty$, gain $I\to+\infty$ — consistent, and the reason to abandon $h$. Zero information $H=0$: $\Delta h=0$, $I=0$. Units $x\mapsto sx$: $h_V$ shifts by $d\log s$ (non-invariant), $I$ and $D$ unchanged (invariant). Every symbol above is defined at first use.
