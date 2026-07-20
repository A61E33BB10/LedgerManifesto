# Valuation Manifesto 1.0 — CONCORDIA Certification Note

**Certifier:** CONCORDIA (constitutional-adherence certifier, signature-last, absolute veto).
**Date:** 2026-07-20. **Document:** `Valuation/ValuationManifesto_1.0.tex` (8pp, 10 articles VM-1…VM-10, pdflatex-clean).
**Three parents:** (1) Architectural Constitution v1.4 (`ledger_manifesto_v1_4.tex`); (2) its fixed vocabulary (C-Auth.4) as carried by the certified spec; (3) **Market Data Manifesto 1.1** (`MarketDataManifesto_1.1.tex`). Siblings verified **byte-identical/untouched** via git (MDM 1.0 and 1.1 not modified; only the new VM file is untracked).

## Committee roster
- **THORP** — drafting lead (desk realism).
- **FORMALIS** — rigor cell; light **RETURN** carried; **ruled C-8.4 reconciled-by-construction**; signs once its three fixes applied (all applied).
- **JACOBI** — binding support memo (the PnL calculus: the both-endpoint identity and the residual-as-certificate).
- **GATHERAL** — binding support memo (the inheritance interface: cite-not-restate from MD-13/8/10/14/15).
- **KLEPPMANN** *[chartered seat — no dedicated agent in this environment; recorded, not silently substituted]* — `kleppmann_vm_r1.md`; **CONVERGED** round 2.
- **TALEB** — `taleb_vm_r1.md`; **CONVERGED** round 2 (verified the worked-chain readability).
- **CONCORDIA** — constitutional-adherence certification, signing last.

## Rounds run
FORMALIS rigor cell (light RETURN: C-8.4 strengthening + VM-10 gap = E+R + gamma display) → Review Round 1 (KLEPPMANN, TALEB) → **Round 2: both reviewers CONVERGED**, no material item open.

## Page count vs cap
**8 pages against a 10pp cap — MET, with margin.**

## Certification checks

### (1) SUBORDINATION (three parents) — CLEAN
Every C-x.y citation verified verbatim against v1.4; every MD-n citation verified against MDM 1.1. All *cite and specialise*, none extends/weakens/narrows. Critical probes:
- **(a) C-8.4 reconciliation — VERIFIED.** C-8.4 (l.707–710): "the profit and loss of any wallet is exactly the variation in its NAV … no second copy of 'realised PnL' or 'book cost' is ever maintained." VM-4 carries the mechanism (l.256–260, the FORMALIS-supplied sentence, printed): *"Because the residual is the balancing term … the certificate reconciles to the change in net asset value by construction … it is a projection of that one number, and no split it prints can make it disagree with the fold."* The per-link certificate is a **projection OF ΔNAV** — the residual `R` is the balancing plug, so the parts sum to ΔNAV on every path and no second realised-PnL total exists to disagree. C-8.4's text supports the reading exactly; FORMALIS ruled RECONCILED-BY-CONSTRUCTION, no park.
- **(b) C-14.9 — VERIFIED stated.** §1/VM-1: "the ledger does not run the model (C-14.9); the model runs outside the fold and its output re-enters through the one door as a recorded observation (C-14.15)." The stored chain is recorded model outputs re-entering as observations.
- **(c) two-layer classification vs MD-15/C-14.15 — no relabel.** Model-priced **legs** = re-entered observations (C-14.15/MD-15); the **assembly** (NAV/PnL/valuation chain) = a **projection** (C-8.2/C-14.11) consuming the legs as leaves (MD-12). "Projection" is never attached to a model output; the split of MDM 1.1 (MD-6) is inherited faithfully.
- **(d) VM-9 sandwich does not narrow MD-13.** The operator's algebra is **cited** (MD-13, "acting on leaf observations … derived objects recomputed from operator-adjusted inputs, never scalar-transported" — the C-9.3 line), not restated; terms-resolved/provisional-frame cited to MD-13. The **late-CA reordering** route cites C-2.7/MD-5 faithfully (execution-time insertion at ex-date, intervening links flagged stale by the reordering trigger, the spurious market-move line reclassified as the zero-profit frame re-coordination, carried as a C-12.6 line).
- **(e) VM-10 simulation — no extension.** Cites C-2.8 verbatim ("we live in a simulation: production is simply the one path whose events happened to be real") and MD-11. **"shift"** coined cleanly (explicitly *"never a 'shift operator'"*, the market data operator naming one thing only); **"simulated path"** reused from MD-11; no reserved-name collision (`shift operator`/`derived world` appear only as explicit rejections).

### (2) VOCABULARY (across three documents) — CLEAN
One name per thing. The four coinages (valuation record, valuation chain, profit-and-loss explain certificate, corporate-action valuation sandwich) plus **shift** each checked against the fixed set. **"valuation chain"** used at every naming point; the hash-chained log is never called "chain" bare (it is "hash-chained"/"the immutable log"), so no collision — anaphoric "the chain" is unambiguous. **"the market data operator"** used only for the C-9.2 transform. The **PnL explain COMPOSES with C-12.6's explain item**: VM-4 states there is *one* profit-and-loss explain, with the reordering-refold line (C-12.6) and the market-factor lines as **disjoint kinds under one roof, each attributed to exactly one cause** — the certificate extends the taxonomy, does not re-coin the term. No collision.

### (3) INTERNAL CONSISTENCY — CLEAN (arithmetic independently re-verified)
The two-layer split holds across all 10 articles. Black-Scholes worked chain re-computed (r=0, σ=0.30, τ=0.25): value **5.98**, delta **0.53**, **gamma 0.0265** (corrected — no stray 0.027 remains), theta/day **−0.047**; **breakeven $1.89** (√(2·0.047/0.0265)=1.890); market-move **C(102)=7.09**; **split homogeneity exact** (2·C(51,50)=7.0908=C(102,100) — the zero-profit frame re-coordination, C-11.3); shifted world **C(120)=20.89** (20.8913), greek estimate +15.9 vs full reval +14.9, gap **+1.0 ≈ 1/15** of the move; the digital "link that breaks" residual O(1) breaches its bound and flags the chain broken (VM-6/VM-7). Every figure checks. JACOBI's both-endpoint identity ½(Δ₀+Δ₁)·h − (1/12)hᵀ(Γ₁−Γ₀)h + R matches VM-4.

### (4) CONFLICT LEDGER — CLEAN (empty parking index, a considered zero)
The one place a genuine constitutional tension arose — VM-4's per-link PnL certificate vs C-8.4's "no second copy of realised PnL" — was **examined explicitly** and ruled by FORMALIS reconciled-by-construction (the certificate is a projection OF ΔNAV; the residual is the balancing plug; disagreement is impossible by construction; no second store exists). No amendment needed; no tension absorbed. FORMALIS confirms the empty parking index "a considered zero, not an omission." The inheritance from MDM 1.1 is by citation, never restatement (MD-13 cited wholesale; VM-9 does not re-coin the operator).

## Cross-references established to the parents (clause-level)

**To the Constitution (v1.4):** C-1.4 (§1, VM-1); C-1.5 (VM-7); C-2.1/C-2.2 (VM-8), C-2.2 (VM-2), C-2.4 (VM-6); C-2.7 (VM-2, VM-9); C-2.8 (VM-10); C-4.6 (VM-9); C-4.8 (§1, VM-3); C-4.10 (§1); **C-8.2** (§1, VM-1); **C-8.3** (VM-1, VM-2); **C-8.4** (VM-4 — the central reconciliation); C-9.2/C-9.3 (VM-9); C-11.3 (VM-9); C-12.1 (VM-3, VM-7); C-12.4 (VM-3, VM-7); C-12.6 (VM-4, VM-9); C-13.2 (VM-6); C-14.9 (§1, VM-1, VM-7); C-14.11 (VM-1, VM-10); C-14.15 (§1, VM-1, VM-2); C-Auth.4 (§1); C-Scope.11 (VM-8, §4).

**To Market Data Manifesto 1.1:** MD-1 (§1); MD-4 (VM-2); MD-5 (VM-4, VM-6, VM-9); MD-6 (VM-1, VM-2, VM-3, VM-5, VM-6); MD-8 (VM-2, VM-7); MD-9 (VM-5, VM-6); MD-10 (VM-7, VM-9); MD-11 (§1, VM-10); MD-12 (VM-1, VM-2); MD-13 (VM-2, VM-9); MD-14 (VM-5, VM-8); MD-15 (VM-1, VM-5, VM-6, VM-8).

## Parked items
**None — a considered zero.** Evidence: FORMALIS's C-8.4 ruling (`formalis_vm_review.md` §1, "RECONCILED-AS-DRAFTED, correct by construction … No park"; §5, "EMPTY PARKING INDEX — CONFIRMED a considered zero, not an omission"). The park mechanism was exercised on the one load-bearing tension and found resolvable within the parents by specialisation, not amendment.

---

## SIGNATURE

**CONCORDIA certifies Valuation Manifesto 1.0 consistent with, and properly subordinate to, all three parents — the Architectural Constitution (v1.4), its fixed vocabulary (C-Auth.4), and Market Data Manifesto 1.1.** Every C-x.y and MD-n citation is correct; the document cites and specialises, never extends, weakens, or narrows any parent guarantee. The load-bearing C-8.4 reconciliation is *shown* (the certificate a projection of ΔNAV, the residual its balancing plug), C-14.9 is honoured, the two-layer split carries no relabel, VM-9 cites MD-13's algebra without narrowing it, and VM-10's simulation cites C-2.8/MD-11 without extension. Vocabulary is one-name-per-thing across the three documents; the PnL explain composes with C-12.6's explain item without collision. The 10 articles and the worked chain are mutually consistent and arithmetically sound (Γ=0.0265, C(120)=20.89, breakeven $1.89, split homogeneity exact). Zero parks — a considered zero. **Page cap met (8pp ≤ 10pp).**

**Veto: not exercised.**

— CONCORDIA, constitutional-adherence certifier, 2026-07-20. **SIGNED (last).**

---
---

# Valuation Manifesto 1.0 — CLOSING CERTIFICATION (two-part: Part A doctrine + Part B "The Pricing Engine" + PARK-1)

**Certifier:** CONCORDIA (signature-last, absolute veto). **Date:** 2026-07-20.
**Document:** `Valuation/ValuationManifesto_1.0.tex` — **15pp (cap 15)**, VM-1…VM-10 (Part A) + PE-1…PE-6 (Part B, pp 9–14) + **PARK-1** (Open Problems, pp 14–15), pdflatex-clean.
**Three parents:** Constitution v1.4; its fixed vocabulary (C-Auth.4); Market Data Manifesto 1.1 — all verified untouched.

## Two-part roster
- **Part A (certified above):** THORP (lead), FORMALIS (rigor — C-8.4 reconciled-by-construction), JACOBI + GATHERAL (memos), KLEPPMANN + TALEB (converged). One linkage added (VM-4/VM-6 → PE-4), FORMALIS-ruled *"does not contradict; it sharpens"* the C-8.4 ruling.
- **Part B ("The Pricing Engine"):** **JACOBI** (led the PE-1…PE-6 derivation) with **GATHERAL** (surface-check) and **THORP** (integration); **FORMALIS** (rigor — rulings (a) σ_prod² canonical and (b) scalar Gâteaux + grounding clause; defects B1–B3 fixed; **B4 adjudicated → PARK**; SIGNED); **KLEPPMANN** (CONVERGED-CONFIRMED); **TALEB** (PASS-CONFIRMED). **KLEPPMANN** *[chartered seat — no dedicated agent in this environment; recorded]*.
- **CONCORDIA** — closing certification, signing last.

## Rounds run
Part A: converged prior pass. Part B: FORMALIS rigor cell (rulings a/b, defects B1–B3 fixed, B4→PARK) → Review Round 1 (KLEPPMANN, TALEB) → Round 2 CONVERGED → post-PARK-1 re-confirmation (KLEPPMANN CONVERGED-CONFIRMED, TALEB PASS-CONFIRMED).

## Page counts vs cap
**Total 15pp = cap 15 (MET, at the cap).** Part A ≈ 8pp; **Part B proper 6pp** (budget 3–5, lawful ≤ 8 only if earned by mathematical content); PARK-1 ≈ 1pp (pp 14–15).

## Closing certification checks

### (1) THE B1 BAN — PASS (sentence-by-sentence sweep of Part B)
Part B is descriptive/mathematical throughout — definitions, claims, derivations, proofs, and one worked number. No proposed model, surface, re-marking rule, remedy, or practice commentary; the sweep for `desks do/use/should · we recommend · best practice · in practice · one should · we suggest` returns **empty**. The three `prescrib*` occurrences are all admissible: two describe the *mathematical object* 𝒟 ("𝒟 … prescribes the surface response ∂_SΣ"), and one is the self-limiting *"it prescribes nothing further."* **The only prescription is PE-6's single monitoring mandate** — *"for every product and every valuation its value, its sign, its poles, and its regularity are monitored by recomputation over the chain's recorded Greeks, which is authoritative, so it cannot drift"* — exactly one prescriptive sentence, in the conforming **on-demand** form. Part B's own preamble states the ban: *"It proposes no model, no surface, no re-marking rule, and no remedy beyond the single monitoring mandate of PE-6 … never as an account of anyone's practice."*

### (2) PART B PAGE BUDGET — OVERRUN JUSTIFIED (6pp lawful)
The extension from the 3–5 budget to 6pp is **earned by mathematical content**, not exposition. The sixth (final) page of Part B carries load-bearing definitions/derivations/proofs required by FORMALIS's rigor review: the **corrected vanishing condition** (PE-2 — *"∂_SΣ = 0 alone does not suffice … the exact condition is that 𝒟 reproduce the model's own endogenous surface dynamics,"* since δ_Γ retains D_ΣP[∂_SSΣ]); the **well-posedness / pole semantics** (PE-3 — where M=0 a pole, where N/M<0 no real σ_prod); the **admissibility hypothesis** (PE-1 A5 / PE-3 — 𝒜 open, σ_prod inherits the out-of-𝒜 gap); the **grounding clause** (PE-2 — directional Gâteaux existence along the declared C² curve, no Fréchet claim); and the **enumerated projection→lineage treatment** (PE-6 — σ_prod² a projection of recorded Greeks, reproducing unconditionally with no model re-run). Every item is a theorem, definition, or well-posedness statement. **The overrun is lawful and explicitly justified.**

### (3) PARK-1 HONESTY — PASS (the document's first genuine park)
PARK-1 carries all five required elements: **the exact C-4.11 clause it would replace** (verbatim: *"Anything computable from the coordinates is a projection, computed when needed and never stored."*); **FORMALIS's exact amendment text** (the "materialised projection" with its three conditions — recomputation authoritative, complete lineage, correction flags stale) **and the MD-6 mirror** (*"stores nothing" → "stores nothing, save as a materialised projection under C-4.11's three conditions"*); **the justification** (a recomputable, lineage-bearing, flagged-stale field cannot silently diverge — but *"Safety is not textual permission: C-4.11 is categorical, and amending it is the owner's alone"*); **the literal alternative** (keep C-4.11 literal, σ_prod² computed on demand — the reading PE-6 already runs); and the statement that **the in-force text runs the conforming reading with nothing depending on storage**.
- **Relabel check — PASS.** The in-force PE-3/PE-6 text contains **zero storage assertion** for σ_prod²: the sweep finds only *"never stored"* (the conforming reading), the explicitly *"Parked:"*-tagged storage mandate, and mathematical false-positives (*"restores"*). `materialise / cache / persist` appear **only inside PARK-1's amendment text**. Nothing in-force stores, materialises, or depends on storing σ_prod².
- **The architect's B6 storage mandate is recorded faithfully in the park** — *"Part B mandates that σ_prod² (PE-6) be stored per product and per valuation on the chain"* — never silently dropped.

### (4) THREE-PARENT SUBORDINATION (all new text) — CLEAN
New citations verbatim-correct: **C-4.11** (exact), **C-14.15** (*"stronger than a mark, whose number needs its retained model"*), **C-4.8/MD-6/MD-15** (declared recorded term; price-space surface), **C-2.8** (risk-neutral pricing measure underlying replay). The **three-vol certificate field** (VM-4 linkage — the carry line names which of the model / raw-implied / product-instantaneous volatility it reconciled against, a governance lever deciding whether the FK discrepancy sits in the carry line or the residual) is FORMALIS-confirmed **CONSISTENT** with the C-8.4-by-construction ruling (it sharpens it; the residual remains the balancing plug, the total still exactly ΔNAV). The **𝒟 ≡ convention bridge** (PE-1 A5) identifies the surface-move map with VM-5's re-marking convention as *one declared recorded term (MD-6)*, coining no new coordinate — consistent with MDM 1.1. **Part A's certified spine is untouched:** VM-7/VM-9 stand verbatim (KLEPPMANN attack-1a CONFIRMED; VM-9's C-9.3 leaf/derived-recomputed line, C-11.3 phantom-valuation guard, and C-2.7/MD-5 late-CA reordering all intact).

### (5) INTERNAL CONSISTENCY — CLEAN (numbers independently re-verified)
**σ_prod ≈ 31.2%:** Γ_adj = Γ + 2·Vanna·(dσ/dS) = 0.0265 + 2(0.10)(−0.01) = 0.0245; σ_prod = 30%·√(0.0265/0.0245) = 30%·1.0400 = **31.2%** ✓. **L_hyb substitution exact:** L_hyb = [∂_tP + ½σ²S²∂_SSP + (r−q)S∂_SP − rP] + ½σ²S²δ_Γ + (r−q)Sδ_Δ; the bracket vanishes by Feynman–Kac, leaving ½σ²S²δ_Γ + (r−q)Sδ_Δ ✓ (matches eq. residual-operator). σ_prod² = −2Θ/(S²Γ_adj) = σ²Γ/Γ_adj ✓ (Θ = −½σ²S²Γ). One-name discipline holds across 15pp: σ_prod² (variance, sign-carrying) and σ_prod (its nonnegative root) consistently distinguished; "materialised projection" coined only in the PARK amendment. TALEB independently re-verified the number (31.2%, vanna ≈ 0.10, sign correct).

## Cross-references established

**To siblings:** all Part-A clause-level cross-references to the Constitution and MDM 1.1 stand (recorded above); new Part-B links add C-4.11, C-14.15 and MD-6/MD-15 at PE-6/PE-1.
**To the Quantitative Volatility Corpus (Vol I & II — the total-gamma illustration, PE-5):** decomposition σ = σ_ATM + σ_smile (Vol I §2.1.1, Eq. 2.1); routed dσ/dS (§2.4.2, Eq. 2.19) and d²σ/dS² (Eq. 2.20); **total gamma Γ_adj** (§2.4.2, Eq. 2.21); total greeks in the P&L identity (§3.6, Eq. 3.34); Γ_adj sign-flip / vanna-crossing (§3.9.3); breakeven δS_BE = σS/√252 (§1.4, Eq. 1.13); Dupire local-vol smoothness contrast (§2.5); **shadow gamma** multi-name instance (Vol II §2.5, Eqs. 2.21 & 2.23, Prop. 2.27).

## Parked item — PARK-1 (stated prominently)

**PARK-1 — storing the product instantaneous variance σ_prod² versus C-4.11.** This is the document's **first genuine constitutional park** — the mechanism exercised, not asserted empty. The architect's B6 mandate to **store** σ_prod² per product and per valuation on the chain conflicts with C-4.11 (and MD-6): σ_prod² is a *projection*, and *"a projection … is computed when needed and never stored."* **The owner must decide** between (i) amending C-4.11 to permit a lineage-bearing, flagged-stale **"materialised projection"** (FORMALIS's exact text + MD-6 mirror, recorded in the park), or (ii) keeping C-4.11 literal — σ_prod² computed on demand, the conforming reading the **in-force PE-6 already runs, with nothing depending on storage.** No agent may decide it; the in-force document is fully conforming under reading (ii).

---

## SIGNATURE (closing, two-part)

**CONCORDIA certifies the two-part Valuation Manifesto 1.0 consistent with, and properly subordinate to, all three parents (Constitution v1.4, its fixed vocabulary, MDM 1.1).** Part A's certified spine is untouched; the one added linkage sharpens, and does not contradict, the C-8.4 reconciliation. Part B is descriptive mathematics with a single conforming monitoring mandate (**B1 ban honoured**); its 6pp is earned by load-bearing definitions, derivations, and well-posedness proofs (**overrun justified**). Every new C-x.y and MD-n citation is verbatim-correct; the three-vol certificate field and the 𝒟 ≡ convention bridge are consistent with the parents; the worked numbers (σ_prod ≈ 31.2%, the L_hyb substitution, σ_prod² = σ²Γ/Γ_adj) are exact. **PARK-1 is honestly formed** — exact replaced clause, exact amendment text, MD-6 mirror, justification, literal alternative, the in-force conforming reading with nothing depending on storage, and the architect's B6 mandate recorded — and the in-force text contains **zero storage vocabulary** for σ_prod². **Page cap met (15pp = 15).**

**Veto: not exercised.** The first genuine park stands for the owner's decision; it does not gate certification of the in-force (conforming) document.

— CONCORDIA, constitutional-adherence certifier, 2026-07-20. **SIGNED (last).**

---
---

# Cross-Manifesto BACKTESTING Amendment — CONCORDIA Certification (spans MDM 1.2 + VM 1.0/VM-11)

**Certifier:** CONCORDIA (signature-last, absolute veto). **Date:** 2026-07-20. Fourth signing in this family.
**Two documents:** `MarketData/MarketDataManifesto_1.2.tex` (**NEW successor to certified 1.1; 1.1 byte-stable — git diff empty**) — the *data side*; and `Valuation/ValuationManifesto_1.0.tex` (**amended in place; 17pp**) — the *backtest object*. **Four parents now govern:** Constitution v1.4, its fixed vocabulary, MDM (now 1.2), and the certified spec's terms.

## Committee roster
- **THORP + KLEPPMANN** — backtesting co-leads. KLEPPMANN's strategy-unit split design **verified as-built: SPLIT-CONFORMS** ("the split held to the sentence", semantic level).
- **GATHERAL** (data side / MDM 1.2), **JACOBI** (functionals memo), **FORMALIS** (rigor — **SIGNED** all five duties; ruled the backtest functionals *illustration* per §5; citations checked at source).
- **TALEB** — gate **PASS** both documents + **CONVERGED** (the survivorship-bias material resolved: look-ahead structural, survivorship named as a declaration-side residual).
- **KLEPPMANN** *[chartered seat — no dedicated agent in this environment; recorded]*. **CONCORDIA** — closing certification, signing last.

## Page counts and grant consumption (per document)
- **MDM: 8 → 9pp** (+1 of the +2 grant; **1pp spare**). Diff vs certified 1.1 is **append-only in meaning**: the only certified line touched is MD-4's `\trace` (extended to add C-14.15); **zero certified body sentence removed**.
- **VM: 15 → 17pp** (+2 of +2; grant fully consumed). Diff vs HEAD is **two hunks only** (abstract touch; VM-10 generalisation + VM-11); **Part B and PARK-1 are byte-stable** (no hunk touches old lines 611–1096).

**Grant audit: every added line is backtesting doctrine or its integration — nothing else expanded.**

## Where the doctrine is placed (article map)
- **MDM 1.2 (data side):** MD-4 gains the **served history** (two coordinates ranged over a recorded interval, read as-known; look-ahead structurally impossible; completeness by read-back, C-14.15); MD-11 gains the **stressed history** (a simulated path branched from a historical cut, the shift its seed); MD-13 gains the **horizon-agnostic operator algebra** (frame boundary, delivery-frame, terms-resolved all hold through the horizon); §4 gains **one sentence** placing the backtest object in the VM; a **1.2 amendment record**. Each extension sits in its own article (verified: served@MD-4, stressed@MD-11, operator@MD-13).
- **VM (object side):** abstract touch (+"backtest"); **VM-10 generalisation** (risk report / scenario / backtest are one doctrine — the backtest is the identity-shift over a past cut, C-12.1); **VM-11** (a backtest is a strategy unit run through a trajectory; its output is an ordinary valuation chain; two numbers — absolute performance and PnL volatility; valid comparison only at identical coordinates; survivorship named).

## Certification checks

### (1) CROSS-MANIFESTO COHERENCE — one doctrine, no duplication, no divergence
Cross-reference pairs verified: **VM-11 → (MD-4, MD-11, MD-13) consolidated** (the trajectory is "replayable, gap-free, and frame-correct through the horizon"); **MDM §4 → VM backtest-object** ("The backtest itself … is a valuation object, governed by the Valuation Manifesto"); **MD-13 → VM sandwich** ("that sandwich is the Valuation Manifesto's, **stated once there**"). **No normative sentence is duplicated** — MDM grants the data side and defers the object; "valuation chain" appears in MDM only in the deferring §4 sentence; "strategy unit", "absolute performance", "PnL volatility", "two numbers" are **VM-only**. The three D-risk homes are cleanly separated: **chain-separation VM-only** (VM-11: the backtest chain lives in its own path's record; MDM defers); **single-non-record-input one referent each** (MDM "the shift is its seed"; VM "the shift is recorded, exactly as a seed is"); **"the model as it was" MD-4-only** (its single home, MDM l.231; VM references the bound model only as a coordinate).

### (2) GRANT CONSUMPTION — PASS (diff-level)
As above: MDM append-only (+1pp, 1 spare), VM two-hunk (+2pp). The MDM diff removes only metadata + the MD-4 trace; the VM diff leaves Part B/PARK-1 byte-identical. No non-backtesting expansion anywhere.

### (3) THREE-PARENT SUBORDINATION (all new text) — CLEAN
New citations verbatim-correct against v1.4: **C-10.2** (*"a deterministic strategy is a smart contract whose rulebook is the terms of a (non-valued) strategy unit … a wallet in a virtual ledger, each rebalancing a recorded transaction triggered by stamped … observations"* — VM-11 reproduces C-10.2's own text and states *"This article specialises that, restating none of it"*: **strategy-as-unit SPECIALISES C-10.2, it does not extend it** — strategy-as-unit is C-10.2's own motivating case); **C-6.1** (instruments are active contracts triggered by events); **C-6.4** (a smart contract is a pure deterministic function of declared terms, recorded observations, and visible state); **C-2.6** (behaviour as declared data, not hidden code); **C-7.2** (ProductTerms); **C-2.8 / C-12.1 / C-2.2 / C-8.4** (as previously certified). **The VM-10 generalisation does not narrow C-2.8** — the backtest is the identity-shift special case of the one simulation recipe over a past cut (C-12.1), broadening the application while leaving the recipe unchanged. **The MDM extensions do not narrow MD-4/MD-11/MD-13** — the 1.1→1.2 diff is append-only in meaning (zero certified sentence removed; MD-4's three times, MD-11's simulated-path, and MD-13's operator algebra stand verbatim). The backtest **functionals** A(C) and Σ are **illustration per §5** (FORMALIS ruling), not new normative primitives.

### (4) PLACEMENT DECISION — recorded as the coordinator's call, flagged for the architect
The mission named "MarketDataManifesto_1.0", but the amendment correctly landed in a **1.2 successor to certified 1.1**, not in 1.0. Reasoning (the coordinator's placement call): **(a)** 1.0 is superseded by certified 1.1; **(b)** the backtesting mandates depend on **1.1-only machinery — corporate-action frames (MD-13) and the operator algebra** — which 1.0 does not carry; **(c)** amending 1.0 would have created the very cross-document divergence the mission forbids. So 1.1 stays byte-stable (MDM precedent: *certified versions get successors*) and the extension lands in 1.2; the VM was amended **in place** per *its* precedent (the Part B amendment). **Flagged for the architect:** the two families now follow different amendment conventions (MDM = successor files; VM = in place) — a normalisation the architect may wish to rule on. This is a placement decision, not a constitutional conflict.

### (5) VOCABULARY (four documents) — CLEAN
"backtest", "trajectory", "served history", "stressed history" each carry one meaning across MDM 1.2 and VM; "**strategy unit**" is C-10.2's term, not a coinage; "**shift**" is the VM's term, reused in MDM 1.2 **with explicit attribution** ("the Valuation Manifesto's term"); "absolute performance" and "profit-and-loss volatility over the life" are VM-only. No synonym drift, no reserved-name collision across the four documents.

## Parked items
**None new.** **PARK-1 is unchanged** (Part B and the Open-Problems section are byte-stable in the VM per the diff). The framework's first genuine park still stands for the owner's C-4.11 decision; the backtesting amendment adds no park.

---

## SIGNATURE (backtesting cross-manifesto amendment)

**CONCORDIA certifies the cross-manifesto backtesting amendment — MarketDataManifesto 1.2 and the Valuation Manifesto's VM-11/VM-10 generalisation — consistent with, and properly subordinate to, all four parents.** The two amendments read as **one doctrine**: MDM grants the data side (served/stressed history, horizon-agnostic operators) and defers the object; the VM governs the backtest object (chain, two numbers, comparison) — with **no normative sentence duplicated** and the three D-risk homes cleanly separated. Every new citation is verbatim-correct; **strategy-as-unit specialises C-10.2 without extending it**; the VM-10 generalisation does not narrow C-2.8; **the MDM 1.1→1.2 diff is append-only in meaning** and **1.1 is byte-stable**; **VM Part B and PARK-1 are byte-stable**. Grant consumption is within budget (MDM +1 of 2, VM +2 of 2), every added line backtesting doctrine. The 1.2-successor placement is recorded as the coordinator's call and flagged for the architect. **No new park; PARK-1 unchanged.**

**Veto: not exercised.**

— CONCORDIA, constitutional-adherence certifier, 2026-07-20. **SIGNED (last).**
