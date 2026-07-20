# GATHERAL — surface-dynamics fidelity check on Part B (PE-1..PE-6)

Charter: the volatility surface. Verified `partB_draft.tex` term-by-term against
`Valuation/volume_I.tex` and `volume_II.tex` (cited by `\label`, per `partB_notes.md`).

## 0. Citation verification (each cited object read at source; content matches claim)

| Cited in | Object | Source line | Verdict |
|---|---|---|---|
| PE-1(A5), PE-5 | (2.1) `σ = σ_ATM(ℓ_F,T)+σ_smile(m,T)`, `σ_smile(0)=0` | I l.505–509 | FAITHFUL |
| PE-5 | (2.19) `dσ/dS = (volslope−s)/S` | I l.1150–1153 | FAITHFUL |
| PE-5 | (2.20) `d²σ/dS² = [(∂²_{ℓF}σ_ATM−volslope)+(c+s)]/S²` | I l.1154–1157 | FAITHFUL |
| PE-2/PE-5 | (2.21) `Γ_adj = Γ + 2 Vanna σ' + Volga σ'² + vega σ''` | I l.1162–1166 | FAITHFUL (term-for-term) |
| PE-2/PE-5 | (3.34) unified attribution; `Γ_adj` is the object in the P&L identity | I l.2856–2869 | FAITHFUL |
| PE-4 | (1.13) `δS_BE = σS/√252` | I l.372–375 | FAITHFUL |
| PE-3(iii)/PE-5 | §3.9.3 `Γ_adj` runs +3.2%→−3.5% as vanna crosses zero | I l.3499–3503 | FAITHFUL (fragment cites the fact, not the toxic/benign doctrine — correct) |
| PE-3(iii) | §2.5 Dupire `σ_loc` a smooth functional of a smooth surface | I l.1191–1269 | FAITHFUL |
| PE-5 | Vol II (2.23) full ShadowGamma | II l.2049–2065 | FAITHFUL (all four channel terms + cross terms match; `R=dρ/dσ|_ξ`) |
| PE-5 | Vol II (2.21) raw footing `Γ^sh` additive to `Γ_adj` | II l.2019–2028 | FAITHFUL — **and the fragment correctly enters `Γ^sh`, not `ShadowGamma`, into `Γ_hyb`** (Vol II warns the direct add is a booking error; the fragment respects it) |
| PE-5 | Vol II §1.6 sticky-ρ (`dρ=0`) / sticky-CVC (`dξ=0`) | II l.840–880 | FAITHFUL; "vanishing under sticky-ρ" confirmed (`R=0` when `dρ=0`) |

No citation misstates its source.

---

## Point 1 — the surface-move rule as a mathematical object: FAITHFUL (one clarity fix)

The core result carries the **whole declared family**, not one member. PE-2 derives the
discrepancy `L_hyb = ½σ²S²δ_Γ + (r−q)S δ_Δ` with `δ_Δ, δ_Γ` generic in the surface response
`∂_S Σ` (Gâteaux `D_Σ P`), so it holds for any `D`. PE-5 then exhibits **named instances**
(single-name corpus dynamic; multi-name sticky-CVC vs sticky-ρ) — the volumes' actual routes.
The families the volumes use (Vol I C4 `σ_ATM=const` collapse vs full `volslope`;
Vol II sticky-ρ/sticky-CVC) are all reachable. Not silently one member.

DEFECT (clarity, net-minimal): PE-1(A5) lists "the corpus's `σ=σ_ATM+σ_smile` decomposition
… are instances, each a different `D`." The decomposition (2.1) is a **coordinate system**, not
a dynamic; the dynamic is that decomposition **held fixed under the forward map `F(S)`**, which
is what (2.19)–(2.20) encode. Fix: replace "the … decomposition … is an instance" with
"the corpus dynamic — the decomposition (2.1) held fixed as `F=F(S)` floats, Eqs (2.19)–(2.20)."
(Also: Vol II (2.23) rests on the equal-vol parallel / `volslope` locally-constant hypothesis of
`prop:sh2:shadow-gamma`; PE-5 imports it unstated — name it in one clause when citing.)

## Point 2 — arbitrage discipline: DEFECT (a load-bearing HYPOTHESIS is missing) — integration-relevant

PE-1(A4) declares the **base** surface arbitrage-free; PE-1(A5) constrains the **moved** surface
`Σ(·;S)` only to be `C²` in `S`. Nothing requires `Σ(·;S)` to stay in the admissible set `𝒜`
(Vol I `def:admissible`: A1 positivity, A2 butterfly `D>0`, A3 calendar `N>0`; `prop:no-arb`:
`b∉𝒜 ⇒ static arbitrage`). This is load-bearing: for a **surface-dependent** product (A2 admits
local vol; products include barriers/autocallables), the model price `P(S,Σ(·;S))` — and hence
`D_ΣP` and `σ_prod` — is only defined where the moved surface is priceable, i.e. `D>0`. A bumped
surface can leave `𝒜`, and then the object is undefined, not merely non-smooth.

Fix (a HYPOTHESIS + a structural fact, **not** a re-admissibilisation — B1-safe), net-minimal:
- A5, add: "`Σ(·;S) ∈ 𝒜` (Vol I `sec:no-arb`) for `S` in the neighbourhood; since `𝒜` is open
  (`def:admissible`), this holds automatically when the base surface is interior to `𝒜` and `D`
  is continuous into surface space."
- PE-3 well-posedness, add a **third** structural failure mode beside `M=0` and `N/M<0`:
  "where `D` carries `Σ(·;S)` out of `𝒜`, the model price of a surface-dependent product is
  undefined and `σ_prod` inherits that gap — recorded, not repaired."
(For a single vanilla priced by BS at its own scalar `σ(S)>0` the hypothesis is not needed — BS
prices any `σ>0`; that is why PE-5's vanilla stands regardless. The hypothesis binds the local-vol/
surface-dependent case that A2/A3 explicitly admit.)

## Point 3 — the Γ_adj chain, and the √(Γ/Γ_adj)-vs-local-vol ruling: FAITHFUL (one scope sentence)

`Γ_adj` verified against (2.21) and against (3.34) term by term: `Γ` (model), `2 Vanna·dσ/dS`
(mixed — the factor 2 is the binomial coefficient of `d²/dS²` of `C(S,σ(S))`, confirmed by the
volume via commuting mixed partials, **not** a double count), `Volga·(dσ/dS)²` (vomma = volga,
single term), `vega·d²σ/dS²` (surface acceleration). Every cross term present, none doubled.
`σ_prod² = −2Θ/(S²Γ_adj)` with the constant-vol theta `Θ=−½σ²S²Γ` gives `σ_prod=σ√(Γ/Γ_adj)`;
numerator uses the model's own `Γ`, denominator the hybrid `Γ_adj` — correct.

RULING (JACOBI unsettled item 3): the **general form is primary in print** — `pe:sprod`
(`σ_prod² = −2[Θ+(r−q)SΔ_hyb−rP]/(S²Γ_hyb)`) stays the boxed canonical definition in PE-3, model-
agnostic. `σ=σ√(Γ/Γ_adj)` is a **constant-vol corollary**, correctly localised to PE-5 ("the
constant-vol model priced at the option's implied volatility"). Add one sentence to PE-5 so no
reader universalises the ratio: "For a local-vol model the clean ratio fails: `σ_prod` is the
general `pe:sprod` with `Θ=−½σ_loc²S²∂_{SS}P` and `Γ` the local-vol price's own second partial."
Net-minimal; concrete-first order (house §6) preserved.

## Point 4 — vanillas included: FAITHFUL

Genuinely carried, not asserted through the general formula. PE-5 does the concrete constant-vol
computation for a single vanilla (`Θ=−½σ²S²Γ`, the four-term `Γ_adj`, `σ_prod=σ√(Γ/Γ_adj)`) and
shows `Γ/Γ_adj ≠ 1` because a vanilla carries vega, vanna, and volga once the surface moves —
`pe:sprod-vanilla` is literally the normative "vanilla options included." Independently, PE-2's
general argument guarantees it: a vanilla has `D_Σ P ≠ 0` (via vega), so `L_hyb ≠ 0` for any
`∂_S Σ ≠ 0`. Double-covered. (Micro-note: "departs from 1 … once volslope≠0 or s(m)≠0" is
generically true — if `σ'=0` at a point the `vega·σ''` term still survives; the conclusion holds.)

## Point 5 — ban sweep (practice narration): PASS

No sentence narrates practice. No "desks/traders do X"; every convention (sticky-strike/-delta/
-moneyness/-ρ/-CVC) enters strictly as a named instance of the declared map `D`. References to
"a book"/"the hedger" are the **referents of a mathematically defined Greek** (`Γ_hyb` is the
total derivative of the reprice map; the breakeven is defined by an equation), not accounts of
behaviour; the fragment self-declares this in the intro and PE-1(A5). Soft note for CONCORDIA/
STYLUS only (non-blocking): "the Greeks a book hedges with" (PE-2) could read as
"the Greeks used to hedge, read off the reprice map" to remove even the gloss. Not a defect.
Zero-rate `F=S` flagging is applied at each use (A1 discipline honoured).
