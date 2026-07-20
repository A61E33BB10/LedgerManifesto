# JACOBI — The two comparison functionals (backtesting amendment, principle level)

For the Valuation Manifesto. The two functionals a backtest reports, as pure
functions of the chain and its declared terms. No estimator fixed; no numerics.

## Setup and notation (every symbol fixed before use)

A **backtest chain** `C = (ℓ_0, …, ℓ_N)` is the valuation chain (VM-3) of one
strategy unit along a trajectory with steps `t_0 < … < t_N`; the step set
`π = {t_0,…,t_N}` is the **partition**. Each link `ℓ_k` (k = 1..N) carries: `V_k`,
the valuation (mark) of the strategy's holdings at `t_k` (`V_0` the base); a
**profit-and-loss explain certificate** `K_k` — attributed lines
`a_k = (a_k^{(1)}, a_k^{(2)}, …)` and one residual `R_k` (VM-4); and `F_k`, the net
external flow booked at step k on the certificate's flow lines (dividends/coupons
received positive, financing/borrow paid negative; VM-9).

**Conservation (VM-4, C-8.4).** The certificate reconciles to the change in net
asset value across the link, by construction and independent of the split:
```
    Σ_j a_k^{(j)} + R_k  =  ΔNAV_k  :=  (V_k − V_{k−1}) + F_k  =:  ΔV_k .
```
`ΔV_k` is the **per-step P&L increment** — the one quantity both functionals read.

## (1) Absolute performance — the terminal functional

```
    A(C)  :=  (V_N − V_0)  +  Σ_{k=1}^N F_k   =   Σ_{k=1}^N ΔV_k .
```
**Well-defined, reads off only endpoints + flow lines.** By conservation the two
forms are equal: telescoping `Σ(V_k − V_{k−1})` leaves `V_N − V_0`, the flow terms
are the recorded flow lines `Σ F_k`, nothing else enters. `A` never touches the
attribution split `a_k`, so it is **convention-independent** — the path-independent
total the certificate exists to reconcile to (VM-4).

## (2) P&L volatility over the life — a functional of the increment sequence

Let `ΔC := (ΔV_1, …, ΔV_N)` be the recorded increment sequence. The volatility
functional is the **realized dispersion of the increments**, under declared terms:
```
    Σ(C; π, D, ν)  :=  ν · D(ΔV_1, …, ΔV_N) .
```
Here `D` is a declared **dispersion rule** — a functional measuring the spread of a
finite sequence about its centre; *no specific estimator is fixed* (sample standard
deviation, MAD, downside variants are all admissible `D`) — and `ν` a declared
**normalisation/annualisation** scalar (per-step vs annualised).

**At principle level `Σ` is deterministic given the chain and the declared terms** —
not a statistical estimate of an unknown parameter but a value read off the record
once `(π, D, ν)` are pinned. `D` and `ν` are **declared, recorded terms**, exactly
like the attribution convention (VM-5): two parties comparing must share them. The
partition `π` is a coordinate, not a free choice — resampling to a coarser or finer
step set changes the increments `ΔV_k`, hence `Σ`; the backtest's own steps fix it.

**Declared terms `Σ` requires (all recorded, all shared by comparing parties):**
`π` (the trajectory's steps) · `D` (dispersion rule) · `ν` (normalisation).

## (3) Comparability

Both `A` and `Σ` are pure functions of `(chain, declared terms)`. Two strategies
`s, s′` compare **validly** iff their chains' coordinates (VM-2: position
as-of/as-at cuts, unit states, corporate-action frames, the market-data cut
sequence, bound models) **and** their declared terms `(π, D, ν, attribution
convention)` are **bit-identical except the strategy unit under test**. Then
`A(C_s) − A(C_{s′})` and `Σ(C_s)` vs `Σ(C_{s′})` compare like with like; otherwise
the strategies are measured across different worlds and the comparison is void.

**Dispute-readiness inherited (VM-8).** A contested comparison is settled by
exhibiting both chains with the shared coordinates and declared terms and replaying:
replay reproduces each `A`, `Σ` bit for bit and **localises** any divergence to a
differing coordinate or term; it never adjudicates which strategy is "better".

## Honest caveats — out-of-scope declarations, not gaps

- **Tail asymmetry.** `Σ` is a symmetric dispersion of `ΔC`; the skew of the
  increments and the shape of the loss tail are separate functionals of the same
  recorded increments, declared out of scope here — not omissions of `Σ`.
- **Path-dependence of funding.** `A` and `Σ` read the recorded flow lines `F_k`;
  funding/financing whose dependence on the realized path is not booked as a
  recorded flow lies outside both functionals — a declared boundary, not a gap.
  (Any risk-adjusted ratio is a composition of `A` and `Σ`, not a third functional.)
