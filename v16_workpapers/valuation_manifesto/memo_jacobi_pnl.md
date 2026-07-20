# JACOBI — The Calculus of the PnL Decomposition (principle-level, for THORP)

Distil the corpus's PnL-explain so the Valuation Manifesto states it at principle level
without contradicting Vol I/II or the Market Data Manifesto (MD). Notation, fixed once:
`V` = value of one unit under the pricing map. A **mark** is a point `x = (t, market,
state)` in the declared risk factors (calendar time, spots, vols by name/bucket, rates,
correlations; the payoff state is a coordinate too). Two marks `x0` (initial), `x1`
(final); move `h = x1 − x0`. `Δ_x := ∇V(x)` (theta, delta, vega, rho, cega, ...),
`Γ_x := ∇²V(x)` (gamma, vanna, volga, cross-gammas) — the **routed totals**, not frozen
partials (§4).

## 1. THE DECOMPOSITION — what is exact, and where it stops being exact
**Claim.** Between two marks of one unit the value difference splits into attributable
orders plus one explicit residual; the honest exact statement uses greeks at **both**
ends:
`  V(x1) − V(x0) = ½(Δ_x0 + Δ_x1)·h − (1/12)·hᵀ(Γ_x1 − Γ_x0)·h + R(x0,x1).`   (†)
**Derivation.** Restrict `V` to the segment `t ↦ V(x0 + t·h)` on [0,1]. For a cubic, (†)
holds with `R ≡ 0` — Vol I Fundamental P&L identity (l.2580–2596) and its multivariate
corollary (l.2653–2664); I re-derived it symbolically (residual exactly 0 for any cubic).
`Δ_x0·h` is carry/theta + delta·Δunderlier + vega·Δvol + rho + cega on **initial** greeks;
`½(Δ_x1−Δ_x0)·h` is the endpoint gamma/vanna/volga term; the `−1/12` piece corrects for
gamma itself having moved. Lifecycle/state-change and cross terms are just further
coordinates of the same `h` and `Γ`.

**The desk-familiar form is a special case, not the exact one.** Transporting the gradient
under locally-constant gamma, `Δ̃_x1 = Δ_x0 + Γ_x0·h`, collapses (†) to the classical
Taylor explain on **initial** greeks, `V(x1)−V(x0) ≈ Δ_x0·h + ½·hᵀΓ_x0 h` (ex ante, Vol I
l.2726–2733) — the `½Γ·ΔS²` term the task names. Its gap to the exact reprice is
`E = (1/6)·hᵀ(Γ_x1−Γ_x0)h` (l.2785–2793, verified): *pure gamma variation over the move*,
a **deterministic, signed** number, distinct from R. Ex-ante and exact coincide **only at
constant gamma** (l.2612–2629). The manifesto must not present `Δ_x0·h + ½Γ_x0·h²` as exact.

**What makes R small — and what breaks it.** For `V ∈ C⁴` near `x0`, `R = O(‖h‖⁴)` (Vol I
Prop, l.3324–3352). Two flags the manifesto must carry: (a) *the exponent, not a bound, is
the message* — "doubling the move multiplies its leading part by sixteen" (l.3354–3355); R
is smallest where nothing happens and largest in the tail, so never promise a *bounded*
residual. (b) *Smoothness + step size are the hypotheses, and they fail concretely*:
non-smooth payoffs (digitals, barriers, autocallables, range accruals) are not `C⁴`, often
not `C¹`, so `R = O(1)` — the size of the discontinuity — once a move straddles the feature
(l.3403–3407); convexity finer than the move (pin risk) is invisible to a two-point stencil
(l.3457–3470); and the calendar direction is **not** covered by `O(‖h‖⁴)` — a one-day step
in `t` is a *fixed finite* component of `h`, so near expiry theta lands "in R at full size"
(l.2964–2984).

## 2. CONVENTION-DEPENDENCE — attribution is not unique; it is declared and recorded
**The deep point.** When a risk factor is not a market map of the driver — implied
correlation `ρ` of a basket is canonical — how a spot/vol move splits across the greeks
depends on a **declared re-marking convention**: which quantity the desk holds invariant.
Two conventions reproduce today's marks and differ only in dynamics — "same marks today,
different P&L tomorrow" (Vol II l.846–848, 893–894):
- **sticky-ρ**: `dρ = 0` (Def, l.850–866); the correlation channel carries nothing.
- **sticky-CVC**: `dξ = 0`, spread `ξ = ½(σ₁+σ₂) − σ_B` fixed, so `ρ = ρ(σ₁,σ₂,ξ)` is
  determined by the vols (l.868–885) — a **convention-completed route** (Vol I l.2411–2424):
  the invariant closes the system by the implicit-function theorem, appending `ρ` as a link.

**Shadow greeks are exactly the convention difference.** `ShadowVega := (1/100)·(∂V/∂ρ)·
(dρ/dσ)|_ξ`, `ShadowDelta := 100·volslope·ShadowVega` (Vol I l.2471–2476; Vol II
l.1765–1770) — the value routed through `ρ` that fixed-ρ greeks omit; they **vanish
identically under sticky-ρ** (Vol II l.889–894, 2637–2639). The single-name analogue is the
*sticky rule* mapping a spot move to a vol move (`σ = σ_ATM(ℓ_F,T) + σ_smile(m,T)`, slope
`volslope`): the split between the spot/gamma bucket and the vega bucket depends on it
(Vol I l.1134–1188; Breach C, l.3472–3493).

**Principle for the manifesto.** The convention is a **declared, recorded term** (MD-6
recipe; MD-13 declared adjustment convention). Hence: (1) *same convention ⇒ same
attribution, bit for bit* — a deterministic function of the record once pinned (MD-6,
MD-14); (2) *a dispute about attribution is a dispute about convention*, **locatable on the
record** — replay "localises the disagreement" to the differing input/frame/model (MD-14
l.472–479) but does not adjudicate which convention is right (model choice; MD-9, MD-15). Do
**not** speak of "the" attribution as unique, nor of shadow greeks as market properties: any
spot-channel shadow number is identically zero under the `σ_ATM = const` engine default and
must be flagged as such, "never quoted as a property of the market" (Vol II l.2566–2573).

## 3. THE RESIDUAL AS CERTIFICATE — "explained" means R below a *declared* bound
A move is **explained** when R sits inside a declared tolerance. The bound is a **declared
term, not a universal constant**: Vol I certifies only if `|r_i| ≤ τ_i` and `WRMSE ≤ τ_agg`,
"specified in the Model Configuration Attestation" (Ax A4, l.3714–3733); price-space maps to
vol space through vega, `τ_vol = τ_price/vega` (l.3768–3779). MD-15 makes the repricing
residual "a re-entered observation — a recorded diagnostic ... never a silent pass"
(l.500–506). A **breached bound is a recorded fact, never absorbed**: R is a *sensor*, not a
rounding error (Vol I l.3319–3395). The domain where the bookkeeping is a control variate,
not a story, is where R is **small**, **mean-zero**, and **regime-independent**
(l.3370–3379); an R structurally large, sign-biased, or waking up in stress marks a
*cubic-toxic* product (l.3381–3388) whose honest attribution is **a scenario, not a greek**,
and whose remedy is re-mark / model review — "a bookkeeping that announces when to stop
believing it is worth more than one that is merely elegant while it lasts" (l.3546–3554).
MD-5 books the difference as "a named explain item — a line in the P&L explain" (l.229–231).

## 4. GREEKS AT BOTH ENDS — why the certificate carries `x0` and `x1` greeks
The exact identity (†) *needs* `Δ,Γ` at **both** marks; only the ex-ante estimate uses `x0`
alone. (1) *Validated from both ends*: with **measured** endpoint greeks the first two orders
are exact and Hessian-coverage gaps are squeezed into the third-order term and R (ex post,
Vol I l.2750–2768), not smeared through delta/vega; the greeks populating (†) are the routed
totals `dV/dS`, `Γ_adj`, each evaluated *at its own state* (Thm, l.2859–2875), and "using
partial Greeks ... is not a smaller model; it is an inconsistent one" (l.2877–2885). (2)
*Final greeks seed the next link*: today's `x1` greeks are tomorrow's `x0` greeks, so the
explain is a **chain** of links each certified from both ends, and the gap `E` (§1) is
monitorable day-on-day (daily loop, l.3264–3302) — the discrete form of MD-5's refolding
explain.

## 5. THE CA JUMP — the corporate-action operator is the admissible explanation
Across a corporate action the state and the coordinate frame change **discontinuously**, so
(†) does not apply — there is no smooth segment. The decomposition across the sandwich is
instead: `value in pre-frame → operator-transported value → value in post-frame`.
**Principle (MD-13, l.392–405).** A corporate action *is a change of frame*: a value "is not
a bare number but lives in a frame" fixed by the CA terms **and** the declared adjustment
convention; the operator transports "from the declared delivery frame". The **only
admissible explanation of the jump is the market-data operator** (C-9.2). Its algebra:
operators **compose** (associative), the action-free operator is the **identity**, and —
decisively — "**derived quantities are recomputed from operator-adjusted inputs**", never
scalar-transported (l.426–431); the operator "is not in general a proportional scalar"
(special cash dividend shifts the forward additively; an OCC adjustment re-coordinates
strike, multiplier, deliverable, l.422–425).
**"Residual ≈ 0" is the proof the CA went well — and `≈` means exactly three declared
tolerances, no more:** (i) *minor-unit rounding applied **once** at read* — operators "compose
at full precision, the minor-unit rounding (C-4.6) applied once at read", so the composite is
grouping-independent (l.428–431); rounding *between* operators would enlarge it; (ii) the
declared convention's own rounding rule (part of the frame, l.397–399); (iii) the calibration
`τ` of any re-derived derived object — surfaces/curves are recomputed from operator-adjusted
inputs (§3; MD-15), carrying their A4/MD-15 price-space `τ`, not zero. A residual materially
above these is not noise: it says the operator or delivery frame was mis-declared (raw vs
back-adjusted; split on strike vs multiplier), which MD-14 replay localises (l.476–479) and
MD-10/MD-8 handle as a superseding event demanding re-derivation. The operator exists only
once terms are **resolved**, not merely announced; before that the frame is provisional and
legible as such (l.413–418).

## 6. DERIVED WORLDS — the same machinery runs between hypothetical markets
A shifted-market valuation (spot +20%, vol down) is a second mark `x1` reached by a *declared*
shift rather than a day's passage; the **same** (†) applies between base `x0` and shifted `x1`.
A **risk report is the first-order term read off the base greeks** — the ex-ante
projected-gradient estimate `Δ_x0·h + ½Γ_x0·h²` of §1 (Vol I l.2942–2962; risk report at the
anchor, Vol II l.2497–2536). The **exactness gap between full revaluation and the greek
approximation is itself a computable, recordable fact** — it is `E + R` of §1, and a sound
system "computes both" the granular reval and the greek explain and reports their difference
(two-viewpoints, l.2887–2940; daily loop l.3264–3302). A stress world is not a separate
system: **"simulated market data is real market data under a different seed"** (MD-11,
l.365–376), so the shifted world is a derived object with full lineage and its greek-vs-reval
gap is a recorded diagnostic on the same terms as a production day.

## MUST NOT CONTRADICT — verbatim, with line refs
- Vol I l.233–236: `P&L = Δ·δS + ½Γ(δS)²` "with error `O((δS)³)`" — single-option, fixed-σ,
  **initial-greek** form; not exact, not the multivariate identity.
- Vol I l.356: delta-hedged daily `P&L = ½Γ[(δS)² − (δS_BE)²]`; theta sign `θ < 0` long
  (l.183, 192), `θ_d = θ/252` (l.334–335).
- Vol I l.2583–2590: "The identity is exact; no remainder term exists" — cubics only.
- Vol I l.2690–2695: `R` = quartic-and-above content; l.3324–3352: `R = O(‖h‖⁴)` for `C⁴`;
  l.3403–3407: `R = O(1)` for non-smooth payoffs.
- Vol I l.2877–2879: partial greeks in the identity are "not a smaller model; it is an
  inconsistent one." l.2964–2984: `O(‖h‖⁴)` "does not cover the time direction."
- Vol I l.3370–3388: R must be small **and** mean-zero **and** regime-independent, else the
  product is cubic-toxic. l.3727–3733: certification `|r_i| ≤ τ_i`, `WRMSE ≤ τ_agg`, τ from MCA.
- Vol II l.889–894, 2637–2639: shadow greeks = (sticky-CVC − sticky-ρ), vanish under sticky-ρ;
  the choice is "the model risk ... same marks today, different P&L tomorrow."
- Vol II l.2566–2573: shadow numbers under `σ_ATM = const` are identically zero, "never quoted
  as a property of the market."
- MD-13 l.426–431: "derived quantities are recomputed from operator-adjusted inputs"; "compose
  at full precision, the minor-unit rounding (C-4.6) applied once at read." l.452–454: "a quote
  is meaningful only given a time coordinate and a frame."
- MD-5 l.229–231 / MD-14 l.472–479 / MD-15 l.500–506: the explain difference is a named
  P&L-explain line; replay localises, does not adjudicate; the residual is a recorded
  diagnostic, never a silent pass.
