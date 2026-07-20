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
