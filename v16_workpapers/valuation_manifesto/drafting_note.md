# Valuation Manifesto 1.0 — Drafting Note (THORP → FORMALIS)

Companion to `ValuationManifesto_1.0.tex` (7 compiled pp, hard cap 10, exit 0).
Records the article map, every clause-level cross-reference to the two parents,
what was compressed from the volumes (with line-refs), and what is left unsettled
for the rigor pass. Style matches the two siblings' preamble (`\vlabel` = the
MD manifesto's `\mlabel` with `vm-` targets; `\trace` identical). This child has
**two** parents (Constitution + Market Data Manifesto) — a first — and honours
both Auth.4 vocabularies.

## 1. Doctrine → article map

| Architect's doctrine | Article(s) | One-line intent |
|---|---|---|
| **D1** valuation = pure function of ledger state; coordinates | **VM-1, VM-2** | VM-1 fixes the two layers (leg = re-entered observation; NAV/chain = projection); VM-2 fixes the coordinate set and bit-for-bit reproducibility |
| **D2** valuation chain; PnL explain as proof of work | **VM-3, VM-4, VM-5, VM-6, VM-7** | chain (VM-3); the certificate + honest ex-ante/exact/residual (VM-4); attribution is convention-dependent (VM-5); "explained" = residual below declared bound (VM-6); unexplained = broken chain, forbidden (VM-7) |
| **D3** dispute-readiness | **VM-8** | extends MD-14's exhibit list with the chain + certificates |
| **D4** corporate-action valuation sandwich | **VM-9** | operator (MD-13) is the only admissible jump explanation; frame re-coordination is a zero-PnL identity; residual ≈0 (three tolerances) IS the proof |
| **D5** risk as valuation in simulated worlds | **VM-10** | same recipe on shifted market data; shifts compose; greek-vs-reval gap is computable and recorded |

The two-layer classification (GATHERAL T1) lands on page one (§1) ahead of any
article, as instructed; every downstream primitive follows from it.

## 2. Clause-level cross-references to the parents

Per-article `\trace` tags carry the load-bearing ones; the fuller inline set:

- **§1 (opening):** MD-1 (observation is a fact about what a source said); C-4.10 (owned coordinate bears value); C-8.2 (NAV = further fold); C-14.9/C-14.15 (ledger runs no model; outputs re-enter); MD-15 (bound by lineage); MD-8 (stale); MD-12 (leaves); C-1.4 (adds no store); C-Auth.4 (fixed names); C-4.8 (hash-chained log — reserves "chain"); C-9.2/MD-13 (the market data operator reserved); MD-11 (simulated path).
- **VM-1:** C-8.2, C-8.3, C-14.9, C-14.15, C-1.4, MD-6, MD-12, MD-15.
- **VM-2:** C-2.2, C-2.7, C-8.3, MD-4, MD-6, MD-8, MD-12, MD-13.
- **VM-3:** C-4.8, C-12.1, C-12.4, MD-6.
- **VM-4:** C-8.4 (PnL = ΔNAV, path-independent, no second copy), C-12.6 (reordering explain item — composition, not collision), MD-5 (explain line).
- **VM-5:** MD-6 (declared recorded term), MD-9 + MD-15 (model choice out of scope), MD-14 (replay localises).
- **VM-6:** C-2.4 (fail-closed/detectable), C-13.2 (economic correctness by recomputation), MD-9 (recorded diagnostic), MD-15 (residual re-enters, never a silent pass).
- **VM-7:** C-1.5 (two projections cannot disagree), C-12.4 (repair forward), C-14.9, MD-8, MD-10.
- **VM-8:** C-2.1, C-2.2, MD-14 (extends the exhibit list), MD-15.
- **VM-9:** C-9.2/C-9.3 (operator; derived recomputed from adjusted inputs), C-11.3 (consistency of reference — the phantom-valuation guard), C-4.6 (minor-unit rounding once at read), MD-13, MD-8/MD-10 (superseding event), MD-14 (localises).
- **VM-10:** C-2.8 ("we live in a simulation"), C-14.11 (reproducible from recorded inputs), MD-11 (real data under a different seed).
- **§4 (scope):** C-Scope.11, MD-9, MD-15, C-14.15, C-14.9, MD-13.
- **§5 (subordination):** C-Auth.4; subordinate to and rated against **both** parents.

Inherited **by citation, never restatement** (GATHERAL §1–2): MD-13 (operator +
algebra), MD-8/MD-10 (staleness), MD-14 (replay/exhibit), MD-15 (price-space
binding). VM-9 in particular cites MD-13 wholesale and does **not** re-coin a
"valuation operator" (Auth.4: one name).

## 3. What was compressed from the volumes (line-refs into `Valuation/`)

Principle-level compressions; the manifesto must never contradict these.

- **VM-4 ex-ante vs exact (the central honesty item).** Exact both-end identity: Vol I l.2580–2596 (Thm, "identity is exact; no remainder"), l.2653–2664 (multivariate). Ex-ante classical Δδ+½Γδ² = special case: l.2714–2733; ex-post exact: l.2750–2768; "partial greeks … not a smaller model; an inconsistent one" l.2877–2885. The manifesto states the estimate is ex-ante and never presents Δδ+½Γδ² as exact.
- **VM-4 residual behaviour.** R = O(‖h‖⁴) for C⁴: l.3324–3352; "doubling multiplies leading part by sixteen" l.3354–3355; R = O(1) at non-smooth payoffs l.3403–3407; calendar direction **not** covered by O(‖h‖⁴) l.2964–2984. Hence "never a universally bounded residual."
- **VM-4 gamma/theta balance + vega-by-bucket.** Breakeven P&L = ½Γ[(δS)²−(δS_BE)²], θ_d = θ/252, δS_BE = σS/√252: Vol I l.330–380 (esp. l.356, l.371). Vega/cross-greeks by kernel/bucket: Vol I l.1096–1190; Cega/vanna/volga: Vol II.
- **VM-5 convention-dependence + shadow greeks.** sticky-ρ / sticky-CVC, "same marks today, different P&L tomorrow": Vol II l.840–895. Shadow = (sticky-CVC − sticky-ρ), vanish under sticky-ρ: l.889–894, l.2637–2639. Under σ_ATM=const the spot-channel shadow is identically zero, "never quoted as a property of the market": l.2566–2573.
- **VM-6 "explained" = below a declared bound.** Certification |r_i|≤τ_i and WRMSE≤τ_agg, τ from the MCA: Vol I l.3714–3733; τ_vol = τ_price/vega l.3768–3779. Residual is a sensor (small ∧ mean-zero ∧ regime-independent) not a rounding error: l.3319–3395; cubic-toxic l.3381–3388.
- **VM-7 broken chain.** Toxic-product doctrine — honest attribution becomes a scenario, not a greek: Vol I l.3305–3555.
- **VM-9 CA sandwich ≈0 = three tolerances.** JACOBI §5 from MD-13 l.426–431 ("compose at full precision, minor-unit rounding once at read") + C-9.3 (derived recomputed from adjusted inputs). Zero-PnL frame identity: GATHERAL T3 + C-11.3.
- **VM-10 greek-vs-reval gap.** Two-viewpoints (compute both, report the difference): Vol I l.2887–2940; daily loop l.3264–3302; risk report = ex-ante projected gradient l.2942–2962; risk report at the anchor Vol II l.2497–2536.
- **§3 worked chain numbers.** Vol I Example 1.2, l.286–328: C(100)=5.9785, C(102)=7.0908, Δ=0.5299, Γ=0.0265, θ=−11.9347/yr, θ_d=−0.0474, delta P&L 1.0598, gamma P&L 0.0530, error 0.0006; breakeven δS_BE=$1.89 l.377–380. Digital "link that breaks": Vol I l.3409–3455.

## 4. FORMALIS rulings (light return, 2026-07-20 — all items now settled)

FORMALIS (`formalis_vm_review.md`) ran a decision-grade pass: every C-x.y / MD-n
token resolved against its parent; §3 numbers independently re-derived from
Black–Scholes; the exact/ex-ante identities checked against Vol I Thm and the
shadow claims against Vol II. Verdict: **RETURN (light)** — two surgical fixes +
one strengthening — then FORMALIS signs. All three carried; the three zero-cost
clarity notes taken. Status of the five drafting-note items:

1. **Shifted-world numbers — RE-DERIVED, results correct; one DEFECT.** FORMALIS confirmed C(120)=20.8913, full ΔV=+14.9127, gap=+0.9894≈+1.0, plus every other §3 number (base greeks, market-move link, carry, breakeven, 2:1-split zero-PnL identity). **DEFECT-1 fixed:** the printed estimate displayed/plugged Γ=0.027 (evaluates to 16.0); now Γ=0.0265 throughout §3 (base display, table, and the formula → 15.9), so a reader reconstructing any line reproduces the stated number.
2. **C-8.4 vs VM-4/VM-5 — RULING: RECONCILED BY CONSTRUCTION; park stays empty.** FORMALIS: the residual `R` is the *balancing term* (`R := ΔNAV − Σ attributed lines`), so `Σ lines + R ≡ ΔNAV` identically — the certificate is a projection *of the one number ΔNAV* and cannot compute a second, disagreeing realised PnL; VM-5's "same marks today, different attributed PnL tomorrow" is model-dependence across two convention *records*, not path-dependence within one. **STRENGTHEN-1 applied:** VM-4 now prints the supplied by-construction sentence, so the reconciliation is *shown*, not asserted. This is what earns the empty park ledger.
3. **Valuation chain vs C-14.9 — COMPLIANT (argument stated).** FORMALIS: the chain's *stored* content is re-entered observations (model runs outside the fold, output re-enters via the one door, C-14.15) — storing them **is** "records the outputs," which C-14.9 commands; the chain's *assembly* is a projection. Argument present across §1 + VM-1 + VM-3 + VM-7 (distributed, acceptable). Also cleared against C-4.11 ("computable … never stored"): model outputs are not ledger-computable, so stored as observations.
4. **MD-13 narrowing — FAITHFUL, no re-narrowing.** FORMALIS read MD-13 in full (MDM l.392–456): VM-9 keeps every at-risk clause — "recomputed from operator-adjusted inputs, never scalar-transported" (l.427/C-9.3), "acts on leaf observations" (l.422), resolved≠announced (l.413–418), C-11.3 phantom-valuation guard, three-tolerance ≈0. No "valuation operator" minted (Auth.4).
5. **Empty parking index — CONFIRMED a considered zero.** Every candidate (C-8.4, C-14.9, C-4.11, VM-9 zero-PnL) stress-tested and reconciled; no genuine Constitution/MDM conflict demands an open-problems entry. Item 2's printed mechanism is what earns it.

**Also fixed — DEFECT-2 (VM-10, phrasing seeded in VM-4).** The greek-approximation vs full-revaluation gap was mischaracterised as solely the benign deterministic-signed gamma-variation term `E`. Per JACOBI §6 the gap = **E + R**: gamma variation *plus* the residual — small for smooth books, `O(1)` at a discontinuity (digital/barrier). VM-10 now states both parts, so no uniform "deterministic, signed" promise is made for non-smooth books; the operational instruction ("compute both, record the difference") stands.

## 5. Round 1 review (KLEPPMANN + TALEB) — applied, 2026-07-20

Gate PASS, both NOT-CONVERGED narrowly; one round warranted; no park. Reviews:
`kleppmann_vm_r1.md`, `taleb_vm_r1.md` (TALEB's landed in `marketdata_manifesto/` by
mistake — moved to `valuation_manifesto/` as part of this revision). Now 8pp (cap 10).

**KLEPPMANN M1 — transitive forward repair (VM-7).** A mid-chain supersession (leaf
correction) now flags stale *every downstream link* whose certificate chained from it;
each re-proves **forward from the superseding predecessor** (never edited); as-known
branch survives (C-12.1), so the chain resolves into the two honest answers, not a
silent fork. Composes MD-6 lineage + MD-8 staleness — machinery was present, statement
was missing. Answer to "superseded or superseding predecessor": **superseding, forward.**

**KLEPPMANN M2 — late-resolved CA is a reordering, not a supersession (VM-9).** A
resolved CA reaching the door *after* valuations were chained across its ex-date is now
routed to the reordering refold (C-2.7/MD-5): intervening links flagged stale by the
*reordering* trigger (they never carried the CA in lineage, so VM-7's frame-supersession
path does not fire), a sandwich struck **retroactively** at the ex-date, and the spurious
market-move line — the 2:1 split reaching the door three days late reading as a ~50%
crash — reclassified as the zero-profit frame re-coordination, reordering carried in the
explain (C-12.6). The loss is never left standing. VM-9 trace gains MD-5.

**TALEB F1 (MATERIAL) — residual-bound named-assumption + anti-plug (VM-6).** Two clauses
added: (a) *anti-plug* — reconciliation to ΔNAV is automatic (residual is the plug) and
proves **nothing**; only the residual below its declared bound certifies. (b) *bound
governance* — the bound's adequacy is a governance assumption named as the parent named
grain and delivery-frame; a too-loose bound silently empties "unexplained PnL is
forbidden" (VM-7); the guard is the residual's recorded sign/regime behaviour (not level
alone) plus the bound's calibration being itself a recorded, reviewable, auditable event.

**Minor cluster applied.** Two-cuts distinction (VM-2, F-min-4: position as-at vs
market-data cut, distinct and independently selectable — "yesterday's book on today's
prices"); bit-for-bit read-back/re-derive qualifier (VM-2, F-min-3); VM-8
mark-vs-collateral-terms carve-out (F-min-5, C-Scope.11); "ex-ante" gloss (VM-4, F-min-1)
and "control variate" gloss (VM-6, F-min-1); "one-twelfth" pointer (VM-4, F-min-2: a
both-endpoint quadrature correction); VM-10 no-risk-vs-books-break payoff (F-min-6);
book-level roll-up bridging sentence (VM-6, F-min-7); multiple-chains-per-unit reconcile
through the one ΔNAV (VM-3, KLEPPMANN attack-3 minor); simulated valuation re-enters its
*own* path, never the real chain (VM-10, KLEPPMANN attack-5 minor). Jargon left as
audience-appropriate for the risk manager (shadow greek, spot/vol channel, Hessian): the
VM-4/5 *conclusions* are accessible; only the mechanism is dense, by design.

**No park.** Both material findings fixed within the two parents (transitive forward-repair
over the chain; route the late CA to the reordering refold). Parking index stays a
considered zero.

## 6. Vocabulary discipline applied

Coined (checked against both Auth.4 sets): *valuation record*, *valuation chain*
(always two words; bare "chain" only anaphoric or in the doctrinal "broken chain",
never a naming/introduction — the hash-chained log keeps "chain"), *profit-and-loss
explain certificate*, *corporate-action valuation sandwich*. Perturbation = **shift**,
never "shift operator" (operator reserved for the CA transform, C-9.2). Scenario =
a *simulated path* under a recorded shift (MD-11); no "derived world." "datum"
does not appear (CLAUDE.md §6 — "observation" throughout; MD-14's exhibit line
re-expressed as "the observation"). "data" used only as a mass noun.
