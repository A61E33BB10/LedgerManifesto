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

## 6. Two-part restructure + Part B integration, 2026-07-20

The architect reissued the mission as a two-part document; same file
`Valuation/ValuationManifesto_1.0.tex`. Now **13 pp total** (cap 15); **Part B =
5 pp** (pages 9–13, JACOBI est. 5); exit 0, no overfull/undefined.

**Restructure.** Abstract gains one sentence announcing two parts. Two centered
dividers: **PART A — Valuation Doctrine** (before §1) and **PART B — The Pricing
Engine** (after Part A's Conclusion, on a `\clearpage` so Part B opens its own
page — the architect's "deliberately distinct" demarcation, and a clean 5-page
Part B). Part A substance is **untouched but for the one linkage** below. Part B
carries JACOBI's PE-1..PE-6, GATHERAL-checked, prefaced by the mandated
demarcation paragraph (Part A governs the record and its chain; Part B states one
mathematical fact about the pricing function the chain stores).

**The one Part A change — the linkage (VM-4 + VM-6).** VM-4's gamma-and-theta
balance now states the balance closes at exactly one volatility — the *product
instantaneous volatility* (PE-4) — and the carry line must *declare which
volatility reconciles it*, the model's or the product's. VM-6 names it as a
structural source of residual: booking model theta against a gamma priced at the
wrong volatility leaves the Feynman–Kac discrepancy (PE-2) in R; silently mixing
the two worlds is exactly the unexplained PnL the article forbids. No other Part
A prose changed.

**GATHERAL's three fixes (from `gatheral_partB_check.md`), applied in Part B.**
(1) Admissibility hypothesis: A5 adds `Σ(·;S) ∈ 𝒜` (arbitrage-free set, Vol I
§2.6; open, Def 2.20), and PE-3 well-posedness gains a **third** structural
failure mode (surface leaves 𝒜 ⇒ price undefined ⇒ σ_prod inherits the gap) —
hypothesis + structural fact, not a re-admissibilisation. (2) The general
`pe:sprod` stays the **primary/boxed** definition; `σ√(Γ/Γ_adj)` is the
constant-vol **corollary** in PE-5, now with a one-sentence local-vol caveat (the
√-ratio collapse does not survive; use the general form with `Θ=−½σ_loc²S²∂_{SS}P`).
(3) Clarity: A5 now names the corpus dynamic as the decomposition (2.1) *held
fixed under F=F(S)* (a coordinate system, not a dynamic; the dynamic is
(2.19)–(2.20)); PE-5 names the equal-vol/locally-constant-volslope hypothesis of
Vol II **Prop 2.27** when importing (2.23).

**PE-6 citations.** Now cites VM-6 (chain machinery = VM-3 chain + VM-6
recorded-diagnostic discipline) alongside VM-1/VM-3/VM-8; monitored "as the
recorded diagnostic VM-6 already makes of every residual."

**Equation-number resolution (JACOBI unsettled item 4 — CLOSED).** Compiled both
volumes today and resolved every cited `\label` from the `.aux`. All of JACOBI's
printed numbers match as-is: (2.1),(2.19),(2.20),(2.21),(3.34),(1.13),(2.28);
§3.9.3, §2.5; Vol II (2.21),(2.23),§2.5,§1.6. New citations resolve to Vol I §2.6
(`sec:no-arb`), Def 2.20 (`def:admissible`), and Vol II Prop 2.27
(`prop:sh2:shadow-gamma`). No number edits were needed.

**Hygiene.** One preamble: added `amssymb` (for `\mathbb`, `\mathfrak`, `\square`);
moved Part B's math macros (`\dd,\Vanna,\Volga,\Gadj,\smod,\sprod,\Dhyb,\Ghyb,
\satm,\ssm,\lF,\Fref,\volslope`) into the house preamble; defined `\pelabel` there
styled **identically to `\vlabel`** (gray marginpar, `pe-` targets). Dropped the
fragment's standalone `\providecommand` scaffolding. Certificate/chain vocabulary
untouched; no desk-talk introduced (GATHERAL ban-sweep already PASS).

**Unsettled for the review round.** (a) JACOBI item 2: σ_prod² (sign-carrying
effective variance) vs σ_prod as the first-class *stored* object — PE-3 defines
σ_prod (nonneg, where it exists) and boxes σ_prod²; FORMALIS to confirm which is
canonical for PE-6's stored quantity through the sign changes. (b) JACOBI item 1:
the Gâteaux `D_Σ P[·]` is kept at the scalar (single-implied-vol) level with the
integral form as the general remark — recommended for a manifesto, not a volume;
FORMALIS to ratify. (c) Part A's Conclusion sits before Part B by design (it
concludes the doctrine; Part B is the deliberately-distinct engine) — flag if the
board wants a joint closing instead.

## 7. Review round 1 — Part B (FORMALIS RETURN + KLEPPMANN 2M + TALEB 1M), 2026-07-20

Gate PASS; FORMALIS RETURN(light) with two rulings; KLEPPMANN + TALEB NOT-CONVERGED
narrowly; no park. Reviews: `formalis_partB_review.md`, `kleppmann_vm2_r1.md`,
`taleb_vm2_r1.md`. Applied as three loci + singles. Now **14 pp total** (cap 15),
**Part B = 6 pp** (pages 9–14; the additions are clauses, within the coordinator's
anticipated 13–14). Exit 0, no overfull/undefined.

**LOCUS 1 — PE-6 rewrite (FORMALIS ruling (a) + KLEPPMANN M2 + TALEB m3/m4 + KLEPPMANN
minor 3).** Canonical stored object is now **σ_prod²** (product instantaneous variance,
sign-carrying; total off the pole — the sign IS the diagnostic), σ_prod its nonneg root
where real; fixes PE-6's self-contradiction ("sign changes auditable" on a nonneg object).
PE-3 Definition also recast so σ_prod² is first-class before PE-6 uses it. Classification:
σ_prod² is a **projection** of the recorded greeks (reproduces UNCONDITIONALLY, no model
re-run — stronger than a mark), and per the architect's B6 storage mandate it is
materialised on the link with **lineage that ENUMERATES the greeks Θ,Δ_hyb,Γ_hyb,P** (+
model + 𝒟), never "model+𝒟" alone — so a forward-repaired greek (VM-7) flags the stored
series stale (MD-8), closing the silent-divergence gap. At a pole (Γ_hyb=0) the recorded
fact is the pole itself; where σ_prod²<0, that no real vol restores FK. Adjectives tempered:
internal diagnostic feeding a dispute-ready mark's certificate, not itself a counterparty
mark. Purpose stated: a pole/sign-flip marks **degenerate carry** (the carry-line analogue
of VM-4's O(1) residual at a digital).

**LOCUS 2 — the certificate field (KLEPPMANN M1b + TALEB m2), in VM-4.** The
which-volatility declaration is now a **declared, recorded term** with change-is-auditable
**parity to the convention (VM-5) and the bound (VM-6)** — a governance lever deciding
whether the FK discrepancy sits in the carry line or lands in R. It names **which of the
three** volatilities in play (model, raw implied-surface, σ_prod) reconciled the line — not
a binary.

**LOCUS 3 — the vocabulary bridge (TALEB M1), in PE-1(A5).** One sentence: 𝒟 is **not a new
coordinate** — it is the surface-dynamics content of the VM-5 re-marking convention, one
declared term read in two roles (attribution split in Part A; hybrid greeks / σ_prod² in
Part B). Naming collision fixed: PE-5's **shadow gamma** is the second-order **instance** of
VM-5's shadow greek, not a separate object.

**SINGLES.** B1 (PE-2 "iff"): ∂_SΣ=0 is insufficient (δ_Γ retains D_ΣP[∂_SSΣ]); stated the
second-order sufficient condition, exact condition deferred to the Remark. B2 (PE-4
overclaim): a general σ leaves ½(σ²−σ_prod²)S²Γ_hyb — only σ_mod leaves exactly L_hyb; fixed
in Claim 2 and the linkage paragraph (raw-implied σ no longer said to leave L_hyb), + a
breakeven back-reference to PE-3's real regime (σ_prod²>0). Grounding clause (STRENGTHEN-B)
added at first use of D_ΣP: directional derivative along the A5 C² curve, Fréchet-on-surface
disclaimed to the volumes, integral form as the same object. TALEB minors: m1 softened VM-6's
"the wrong volatility" → "a volatility other than σ_prod" (removes the advice-read; the model
vol is a declared choice with a surfaced residual, not an error); m5 one number through σ_prod
using Part A's base call (σ=30%, Γ=0.0265, downward skew dσ/dS≈−0.01 ⇒ Γ_adj≈0.0245 ⇒
σ_prod≈31%, "a vol point of carry the implied never showed"); m6 plain handle on Feynman–Kac
at first use ("the model's own pricing equation…").

**Unsettled for next round.** m5's number is my hand computation (vanna≈0.10, Γ_adj≈0.0245,
σ_prod≈31%) — FORMALIS to re-verify the arithmetic as it did DEFECT-1. The classification
"projection materialised on the chain with greek-enumerating lineage" reconciles B6 storage
with KLEPPMANN's projection argument; confirm this is the intended reading of B6.

## 8. PARK-1 (B4) — the first genuine park of the document family, 2026-07-20

FORMALIS adjudicated B4 (`formalis_partB_review.md`, ROUND 2): **PARK**. The architect's
B6 mandate that σ_prod² be **stored** per valuation collides with C-4.11 ("computable from
the coordinates ⇒ a projection, computed when needed and **never stored**") and MD-6 ("a
projection stores nothing"). The certificate-field reconciliation **fails**: the certificate's
greeks/price are stored as *model outputs* under C-14.15 (not ledger-computable), whereas
σ_prod² **is** ledger-computable (pure algebra over recorded greeks, no model run) — it would
be the architecture's **first stored ledger-computable output**. Relabelling it a "materialised
projection / recorded field" to keep C-4.11 reading true is the CLAUDE.md §1 narrowing (the
worse failure). Amending C-4.11 is the owner's alone → park, work continues around it.

**Applied to the document (this is the terminus of the B4 question):**
1. **Conforming reading now in force in PE-6** — σ_prod² is a projection **computed on demand**,
   its value/sign/poles/regularity monitored by **recomputation over the chain's recorded
   greeks** (authoritative, cannot drift); nothing stored. The monitoring mandate survives
   fully. Kept the classification insight ("a projection … reproduces unconditionally … stronger
   than a mark") — it is exactly what makes storage a C-4.11 question. **Dropped** all
   materialises/stored-series/flags-stale-cache vocabulary from the in-force text (verified:
   zero occurrences in PE-6 body). PE-3 vocab softened ("its sign a *recorded* diagnostic" →
   "a diagnostic in its own right"). PE-6 trace now cites C-4.11 + C-14.15; drops VM-7/MD-8
   (the stale-cache half, which lives only in the park).
2. **Park recorded verbatim in the document** — new final section **"Open Problems (Parked
   Items)"** (the house open-problems index; PARK-1 is its first entry). Carries: the conflict;
   the **exact clause replaced** (C-4.11 final sentence, verbatim); FORMALIS's **exact proposed
   amendment text** (the "materialised projection" three-conditions clause, verbatim) + its MD-6
   mirror; **KLEPPMANN's engineering-safety rationale** as the amendment's justification (a
   recomputable, lineage-bearing, flagged-stale field cannot silently diverge — C-1.2/1.3 stays
   closed, but safety ≠ textual permission); and the **alternative resolution** (keep C-4.11
   literal: "stored" → "computed on demand and monitored" = the conforming reading, no amendment
   needed). Decision the owner's alone. No relabel, no absorption.

Everything else byte-stable. Now **15 pp** (at cap 15); Part B (PE-1..PE-6) pages 9–14; the
park section pages 14–15. Round-2 status: B1/B2/B3/ruling(a)/ruling(b)/m5 RESOLVED; three-vol
field CONSISTENT; **B4 PARKED** (open, escalated). Per protocol a constitutional park is the
terminus — the work proceeds around it.

## 9. Vocabulary discipline applied

Coined (checked against both Auth.4 sets): *valuation record*, *valuation chain*
(always two words; bare "chain" only anaphoric or in the doctrinal "broken chain",
never a naming/introduction — the hash-chained log keeps "chain"), *profit-and-loss
explain certificate*, *corporate-action valuation sandwich*. Perturbation = **shift**,
never "shift operator" (operator reserved for the CA transform, C-9.2). Scenario =
a *simulated path* under a recorded shift (MD-11); no "derived world." "datum"
does not appear (CLAUDE.md §6 — "observation" throughout; MD-14's exhibit line
re-expressed as "the observation"). "data" used only as a mass noun.
