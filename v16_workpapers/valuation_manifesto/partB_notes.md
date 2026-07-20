# Part B (The Pricing Engine) — drafting notes

Author: JACOBI. Fragment: `partB_draft.tex` (articles PE-1..PE-6). Compiles
self-contained, 5 pages, no undefined macros, no errors (pdflatex ×2, minimal
wrapper). Integrates after Part A (VM-1..VM-10) of `ValuationManifesto_1.0.tex`.

## 1. Exact volume references used in B5 (PE-5), verified against compiled .aux

All equation/section numbers below were resolved by compiling
`Valuation/volume_I.tex` and `volume_II.tex` and reading the generated
`.aux`. The **`\label` name is the stable anchor**; the printed number is what
that label currently renders to. If the volumes are renumbered before
integration, re-resolve the number from the label — do not trust the printed
number blindly.

| Used in PE-5 | `\label` | Printed | Section | volume_I/II line |
|---|---|---|---|---|
| ATM/smile decomposition `σ = σ_ATM(ℓ_F,T)+σ_smile(m,T)` | `eq:decomp` | (2.1) | §2.1.1 `sec:decomposition` | I l.506–509 |
| routed `dσ/dS = (volslope − s)/S` | `eq:dsig-dS` | (2.19) | §2.4.2 `sec:total-greeks` | I l.1150–1153 |
| routed `d²σ/dS²` | `eq:d2sig-dS2` | (2.20) | §2.4.2 | I l.1154–1157 |
| **total gamma `Γ_adj`** (the B5 spine) | `eq:Gadj` | (2.21) | §2.4.2 | I l.1162–1166 |
| total greeks inside the P&L identity | `eq:ch3:unified` | (3.34) | §3.6 `sec:ch3:composition` | I l.2861–2869 |
| `Γ_adj` sign flip / vanna crossing zero (non-smoothness of σ_prod) | `sec:ch3:signflip` | §3.9.3 | (prose) | I l.3495–3503 |
| breakeven `δS_BE = σS/√252` | `eq:breakeven-closed` | (1.13) | §1.4 `sec:theta-gamma` | I l.367–375 |
| Dupire local vol (smoothness contrast) | `sec:localvol` / `eq:local-vol` | §2.5 / (2.28) | §2.5 | I l.1191–1269 |
| **shadow gamma (full)** multi-name instance | `eq:sh2:shadow-gamma-full` | (2.23) | §2.5 `sec:sh2:shadow-gamma` | II l.2057–2065 |
| shadow gamma raw footing `Γ^sh` (additive to `Γ_adj`) | `eq:sh2:shadow-gamma-raw` | (2.21) | §2.5 | II l.2019–2022 |
| shadow vega/delta section | `sec:sh2:shadow` | §2.4 | §2.4 | II l.1701 |
| sticky-ρ vs sticky-CVC | `sec:vol2-sticky` | §1.6 | §1.6 | II l.840 |

Corpus `\label` names cited elsewhere in the fragment: PE-2 def and trace use
`eq:Gadj`(2.21) and `eq:ch3:unified`(3.34); PE-4 uses `eq:breakeven-closed`(1.13).

## 2. Hypotheses ledger (which assumption each result rests on)

- **FK PDE (PE-1, Eq. pe:fk)** rests on A1 (constant r,q), A2 (model diffusion
  `σ_mod` = constant σ, or `σ_loc` locally Lipschitz, uniformly elliptic
  `0<σ_min≤σ_loc≤σ_max<∞`), A3 (`P ∈ C^{2,1}` on `O=(0,∞)×[0,T)`). Standard
  Feynman–Kac (Friedman 1975; Karatzas–Shreve §5.7). **Fails** on the
  discontinuity/kink locus of digitals/barriers/autocallables — flagged in A3,
  ties to Part A VM-4's O(1) residual.
- **Discrepancy (PE-2, Eq. pe:residual-operator)** rests on A5 (D declared as a
  C² spot-dynamic so `Δ_hyb, Γ_hyb` exist) and on `D_Σ P ≠ 0` (product carries
  surface sensitivity) and `∂_S Σ ≠ 0` (rule moves surface with spot). It is an
  *identity*, exact, no remainder — the two surviving terms are algebraic.
- **σ_prod (PE-3, Eq. pe:sprod)** well-posed only where `Γ_hyb ≠ 0`; real and
  nonnegative only where numerator and `S²Γ_hyb` share sign. Poles at
  `Γ_hyb=0`, no real root where the ratio is negative. These are stated, not
  smoothed.
- **Theta invariance (PE-4, Claim 1)** rests critically on A5's *spot-dynamic*
  restriction: D prescribes `∂_S Σ` only, never an autonomous `∂_t Σ`. This
  assumption is load-bearing and stated in the honest-caveat paragraph.
- **σ_prod = σ√(Γ/Γ_adj) (PE-5, Eq. pe:sprod-vanilla)** is specific to the
  *constant-vol* model priced at implied σ, using `Θ = −½σ²S²Γ`. For a genuine
  local-vol model the general form (Eq. pe:sprod) holds but the clean √-ratio
  does not (Θ carries `σ_loc`, and `Γ` is the local-vol price's own second
  partial). Flagged below for FORMALIS.

## 3. The Part A linkage sentence THORP must thread (into VM-4, the carry line)

> The carry line reconciles the model-determined theta against the hybrid gamma
> the book actually carries, and that reconciliation holds at exactly one
> volatility — the product instantaneous volatility σ_prod (PE-3, PE-4); a carry
> line that books model theta against a gamma priced at any other volatility
> carries a residual equal to the Feynman–Kac discrepancy L_hyb·dt (PE-2), which
> is precisely the silent unexplained profit-and-loss VM-6 forbids — so the
> certificate must declare which volatility reconciles its carry.

Placement: VM-4 already names "the gamma-and-theta balance, the core of the daily
explain" (Part A l.225–227). The thread adds: *that balance closes only against
σ_prod, and the certificate declares it.* No change to VM-4's structure — one
clause and a pointer to PE-3/PE-4.

## 4. Unsettled / for FORMALIS

1. **Functional-derivative rigor.** `D_Σ P[·]` (Gâteaux derivative in the
   surface argument) is used at the level of a declared C² spot-parametrization
   (A5); the honest general object for a multi-strike product is
   `δ_Δ = ∫ (∂P/∂σ(K)) (∂σ(K)/∂S) dK`. The fragment presents the scalar
   (single-implied-vol, vanilla) realization as primary (concrete-first, house
   §6) and the functional form as the general statement. Decision needed:
   formalize the function-space setting (Fréchet on an admissible surface
   Banach space) or keep the scalar reduction with the integral remark. I
   recommend the latter for a manifesto; the former belongs in a volume.
2. **σ_prod² vs σ_prod as the primary object.** Because the RHS of (pe:sprod)
   can be negative or singular, σ_prod is not globally real. I recommend the
   manifesto treat **σ_prod² (an effective, sign-carrying variance)** as the
   first-class stored quantity, with σ_prod its (partial) square root — this
   keeps PE-6's stored object total and auditable through the sign changes.
   Currently PE-3 defines σ_prod (nonneg, where it exists) and carries σ_prod²
   in the boxed formula; FORMALIS to confirm which is canonical.
3. **Local-vol realization of PE-5.** Confirm the note in §2 above: the √(Γ/Γ_adj)
   form is constant-vol-specific; the general σ_prod for local vol is (pe:sprod)
   with `Θ = −½σ_loc²S²∂_SS P`. Worth one explicit sentence if reviewers want
   the local-vol case shown, at the cost of ~0.3 page (within the 8-page ceiling).
4. **Equation-number drift.** All (n.m) numbers are resolved against the volumes
   as they compile today. The `\label` names in §1 are the durable anchors; ask
   THORP to re-resolve at integration if the volumes moved.

## 5. Bans compliance (for CONCORDIA)

- No proposed solutions; no recommendations beyond PE-6's monitoring mandate.
- No "desks do X" practice-talk. The hedging rule enters only as the declared
  map D (A5); every mention of sticky-strike/-delta/-CVC is a *named
  mathematical instance of D*, never narrated behaviour.
- Every object defined before use (A1–A5 precede all claims); every claim
  derived or flagged as an assumption; hypotheses stated per equation; no
  "clearly". Budget: 5 compiled pages (ceiling 8) — no overrun to justify.
