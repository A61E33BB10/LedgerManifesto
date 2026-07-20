# FORMALIS — Rigor Review of Valuation Manifesto 1.0, PART B (PE-1..PE-6)

Target: `/home/renaud/Ledger/Valuation/ValuationManifesto_1.0.tex`, Part B (pp 9-13).
Reviewer: FORMALIS. Inputs: JACOBI `partB_notes.md`, GATHERAL `gatheral_partB_check.md`,
`drafting_note.md` §6. Method: every PE derivation re-derived independently; the
single-name total-gamma chain re-derived term-by-term against Vol I (2.19)-(2.21)
read at source (l.1150-1170); the multi-name raw-footing and Vol II Prop 2.27
hypothesis read at source (Vol II l.2015-2065); Part A DEFECT-1 confirmed fixed
(base gamma now 0.0265, shifted formula now `½×0.0265×20²`).

---

## RULINGS ON THE TWO DEFERRED QUESTIONS

### (a) σ_prod² (sign-carrying variance) vs σ_prod as PE-6's canonical stored object — RULING: **σ_prod² is canonical.**

`σ_prod²` is the first-class stored/monitored object; `σ_prod` is its nonnegative
square root **where it exists**, a derived human-facing view. Four reasons, and the
fourth is an *internal inconsistency in PE-6 as drafted*, not a preference:

1. **Totality (the deciding principle).** `σ_prod² = N/M` is real wherever
   `Γ_hyb ≠ 0` — total off the single pole. `σ_prod` is *undefined on the entire
   region `N/M < 0`* (PE-3's second failure mode). A monitored diagnostic must be
   as total as the mathematics allows; storing the partial object leaves holes
   exactly where the structure is richest.
2. **The sign is the diagnostic.** `σ_prod² < 0` is the recordable fact "no real
   volatility restores the Feynman-Kac form here" — precisely the vanna-crossing /
   `Γ_hyb` sign-flip that PE-3(iii) and PE-5 emphasize. `σ_prod` (nonneg) throws
   that sign away; `σ_prod²` preserves it.
3. **It is already the primary mathematical object.** The boxed defining equation
   (`pe:sprod`, l.781-782) solves for `σ_prod²`; `σ_prod` is the subsequent root.
4. **PE-6 is internally inconsistent without this.** PE-6 (l.987) claims "its
   regularity — the poles and **sign changes** of PE-3 — are thereby auditable."
   But `σ_prod` is nonnegative and *has no sign changes*; only `σ_prod²` (or
   `Γ_hyb`) does. As drafted PE-6 stores an object that cannot exhibit the very
   thing it says it makes auditable. Storing `σ_prod²` removes the contradiction.

**Fix (DEFECT-B3).** In PE-6, make the stored/re-entered object `σ_prod²` — "the
product instantaneous variance, the sign-carrying effective variance of (pe:sprod)"
— with `σ_prod = √(σ_prod²)` named as its nonnegative root where `σ_prod² ≥ 0`. Add
one clause to PE-3's Definition making `σ_prod²` the first-class object and `σ_prod`
its partial root, so the naming is fixed before PE-6 uses it. (Vocabulary: "product
instantaneous variance" is a clean coinage, no Auth.4 collision; "product
instantaneous volatility" is retained for `σ_prod`.)

### (b) Gâteaux `D_ΣP` kept scalar, functional/integral form as a remark — RULING: **scalar is sufficient rigor; the functional form need NOT be primary — conditional on one grounding clause.** JACOBI's recommendation ratified.

The manifesto never needs a Fréchet derivative on a Banach space of surfaces. Every
use of `D_ΣP` is a **directional derivative evaluated along the declared C² curve**
`S ↦ Σ(·;S)` of (A5): `Δ_hyb = g'(S)`, `Γ_hyb = g''(S)` are ordinary derivatives of
the scalar `g(S) := P(S,Σ(·;S))`, and the four-term split of `Γ_hyb` is the chain
rule for that composition. Its validity rests on `g ∈ C²` **plus** `P` twice
differentiable in the surface argument along the curve — realized concretely and
without any function-space machinery by the smooth Black-Scholes dependence in PE-5
(`C(S,σ(S))`, a scalar `σ`). The full Fréchet-on-`𝒜` setting is the rigorous home of
`D_ΣP` as a standalone object and **belongs in a volume, not a manifesto** (CLAUDE.md
§5: code/formalism illustrates; it does not carry weight the prose has not earned).

**Condition (STRENGTHEN-B).** Add, at first use in PE-2, one clause grounding the
notation:

> *These directional (Gâteaux) derivatives are taken along the declared C² curve
> `S ↦ Σ(·;S)` of (A5); their existence is the standing hypothesis that `P` is twice
> differentiable in the surface argument there — realized concretely by the smooth
> Black-Scholes dependence of PE-5 — not a claim of Fréchet differentiability on
> surface space, which the manifesto neither needs nor asserts. Coordinatized by
> strike, `δ_Δ = ∫ (∂P/∂σ(K))(∂σ(K)/∂S)\,dK` is the same object.*

Without it, `D_ΣP` and the second-order `D_{ΣΣ}P`, `D_Σ(∂_SP)` read as un-grounded
functional-derivative symbols; with it, the scalar reduction is airtight and the
integral form is a remark, exactly as JACOBI proposed. (This also supplies the
missing hypothesis for the term-by-term `Γ_hyb` split, which needs `P` C² in the
surface argument, a hair stronger than A5's stated `g ∈ C²`.)

### (c) Part A Conclusion before Part B — no ruling (style seat), as instructed.

---

## PART A LINKAGE (VM-4 / VM-6) vs the earlier C-8.4-by-construction ruling — CONSISTENT, and strengthened.

The linkage does **not** contradict the in-cell ruling; it sharpens it.
- **VM-4 (l.258-261):** "That balance closes at exactly one volatility — the product
  instantaneous volatility (PE-4) — so the carry line must *declare which volatility
  reconciles it*." This is a certificate **field** (which vol was used), not a second
  running total. Residual mechanics unchanged: a wrong-vol carry line lands the
  Feynman-Kac discrepancy `L_hyb·dt` in `R`, the balancing plug; the total still
  equals ΔNAV **by construction** (l.290-295, the sentence I supplied in-cell, now
  integrated verbatim). No second copy of realised PnL; C-8.4 intact.
- **VM-6 anti-plug (l.348-353):** "that the certificate reconciles to ΔNAV proves
  *nothing* — the residual is the balancing term, so the parts sum to ΔNAV whether
  the move is explained or not; only the residual below its declared bound
  certifies." This is the correct and necessary complement to by-construction
  reconciliation: it forecloses the misreading "reconciled ⇒ correct." It is fully
  consistent with — indeed completes — the C-8.4 ruling. **Excellent addition.**
- **VM-6 (l.337-342)** names the wrong vol precisely as "the model's, rather than the
  product instantaneous volatility," which *does* leave exactly `L_hyb` — correct
  (contrast the PE-4 over-generalization below).

The linkage is SOUND. The carry-line declaration is a field; the residual mechanics
are unchanged; the anti-plug guards the plug. No park, no contradiction.

---

## PER-ARTICLE

- **PE-1 — SOUND.** Objects well-defined before use (A1-A5 precede all claims). Every
  hypothesis does real work — none vacuous: A1 carries the FK drift/discount; A2
  gives the unique strong solution and FK ellipticity; A3's `C^{2,1}` is the FK
  regularity, its failure locus tied to Part A's O(1) residual; A4 fixes the base
  surface and the scalar `σ`; A5 makes `g` twice differentiable and the moved surface
  priceable. GATHERAL's two fixes present: the corpus dynamic named as (2.1) *held
  fixed under `F(S)`* (coordinate system, not dynamic), and `Σ(·;S) ∈ 𝒜` (open, Def
  2.20). FK claim (pe:fk) is the correct BS-type PDE for the (A2) diffusion, exact
  under A2 — verified. *Minor:* A5 states `g ∈ C²`; the term-by-term `Γ_hyb` split
  additionally needs `P` C² in the surface argument — folds into STRENGTHEN-B.

- **PE-2 — core derivation SOUND (verified exact); DEFECT-B1 in the closing "iff".**
  The identity `L_hyb = ½σ_mod²S²δ_Γ + (r−q)Sδ_Δ` is re-derived independently and is
  exact: add-and-subtract the model partials, the FK bracket vanishes, the two
  surface-response terms remain. The four-term `δ_Γ` (factor 2 = binomial coefficient
  of `d²/dS²`, not a double count) is correct.
  **DEFECT-B1 (l.747-751).** "L_hyb = 0 if and only if either `D_ΣP = 0` or the rule
  holds the surface still (`∂_SΣ = 0`)" is wrong twice. (i) `δ_Γ` does **not** carry
  `∂_SΣ` as a factor throughout: its third term `D_ΣP[∂_{SS}Σ]` carries `∂_{SS}Σ`, so
  `∂_SΣ = 0` with `∂_{SS}Σ ≠ 0` leaves `L_hyb = ½σ²S² D_ΣP[∂_{SS}Σ] ≠ 0` — the
  disjunct is not sufficient. (ii) It is not an "iff": `L_hyb = 0 ⟺ δ_Γ,δ_Δ combine
  to zero`, which can occur without either disjunct. **Fix:** "`L_hyb = 0` when the
  surface-response corrections vanish; sufficient are a surface-insensitive product
  (`D_ΣP = 0`, e.g. a forward) or a rule that holds the surface still *to second
  order* (`∂_SΣ = ∂_{SS}Σ = 0`). The exact condition is that `𝒟` reproduce the
  model's endogenous surface dynamics (Remark)." The Remark (l.757-762) already
  states the correct iff, so this only aligns the derivation's closing line with it.

- **PE-3 — SOUND.** `σ_prod² = −2[Θ+(r−q)SΔ_hyb−rP]/(S²Γ_hyb)` is the correct
  inversion. Well-posedness honestly treated: all three failure modes stated — pole
  at `M = S²Γ_hyb = 0` (division-by-`Γ_hyb`-undefined **explicitly stated**, l.791),
  `N/M < 0` no real root, and GATHERAL's third (surface leaves `𝒜` ⇒ price undefined
  ⇒ `σ_prod` inherits the gap, l.793-795). The why-no-smoothness argument is
  **valid**: `σ_prod²` is a quotient of two independently constructed fields solving
  no differential equation that would impose regularity, so it inherits only quotient
  regularity — poles/sign-flips from `M`, kinks from a piecewise-in-moneyness `𝒟` —
  genuinely distinct from Dupire `σ_loc`, a smooth functional of a smooth surface
  (fitted vs modelled). Correct. (Ruling (a) makes `σ_prod²` the primary object here.)

- **PE-4 — SOUND on both derivations; DEFECT-B2 in one over-general clause.** Claim 1
  (theta invariant to `𝒟`) verified: `Θ = ∂_tP` is the model partial at fixed spot;
  `𝒟` enters only through `∂_SΣ` in `S`-derivatives, absent from the calendar
  partial — with the load-bearing honest caveat that A5's *spot-dynamic* restriction
  is what buys it (an autonomous `∂_tΣ` would break it). Claim 2 (breakeven)
  verified: `δS_BE = σ_prod S√dt`, same form as the corpus `σS/√252` with `σ_prod`
  for `σ`.
  **DEFECT-B2 (l.866-868, echoed l.873-876).** "any other volatility leaves in
  (pe:carry-identity) a residual equal to `L_hyb`" over-generalizes: a volatility `σ`
  leaves `½(σ²−σ_prod²)S²Γ_hyb`, which equals `L_hyb` **only at `σ = σ_mod`**. It is
  exact in PE-5's constant-vol-at-implied setting (there `σ_mod = σ`), and VM-6/VM-4
  state it correctly by naming "the model's" vol — but PE-4 is written generally and
  the local-vol case is admitted. **Fix:** "any volatility other than `σ_prod` leaves
  a nonzero residual; the model's own `σ_mod` leaves exactly `L_hyb`" (and in the
  linkage paragraph, drop "or the raw implied σ" or qualify it to the `σ_mod = σ`
  case). *Minor:* the breakeven presumes the real, long-gamma regime (`σ_prod² > 0`);
  PE-3 already flags where it is not — one back-reference would seal it.

- **PE-5 — SOUND (independently re-derived).** `dσ/dS = (volslope−s)/S` and `d²σ/dS²`
  match Vol I (2.19)-(2.20) read at source. `Γ_hyb = Γ_adj = Γ + 2Vanna·(dσ/dS) +
  Volga·(dσ/dS)² + vega·(d²σ/dS²)` re-derived as `d²/dS²[C(S,σ(S))]` and matched
  term-for-term to Vol I (2.21) at l.1162-1166 — the factor 2 is the cross-partial
  binomial coefficient, **no double count**. `σ_prod² = −2Θ/(S²Γ_adj) = σ²Γ/Γ_adj`
  with `Θ = −½σ²S²Γ` — verified; `σ_prod = σ√(Γ/Γ_adj)`. "Vanilla included" genuinely
  carried (a vanilla has vega, vanna, volga ⇒ `Γ_adj ≠ Γ` under any nontrivial
  dynamic) — not asserted through the general formula. Local-vol caveat present and
  honest (the √-ratio collapse does not survive). **Multi-name:** the draft enters the
  **raw footing `Γ^sh`** (Vol II (2.21)), *not* `ShadowGamma` (2.23), into `Γ_hyb` —
  which is exactly what Vol II mandates (l.2025-2028: "Adding ShadowGamma to Γ_adj
  without this conversion mixes normalisers and is a booking error"). **No double
  count.** The equal-vol / locally-constant-volslope hypothesis of **Prop 2.27** is
  named when importing (2.23). Faithful.

- **PE-6 — DEFECT-B3 (ruling a); mandate structurally correct.** Precisely one
  prescriptive sentence (compute per product/valuation, re-enter as observation, bind
  lineage to model and `𝒟`, place on chain, monitor); the rest is "thereby"
  consequence and a closing "prescribes nothing further." Good. The defect is the
  stored object: store `σ_prod²` per ruling (a), which also repairs the "sign changes
  auditable" inconsistency.

---

## VERDICT: **RETURN** (light — three MEDIUM defects + two grounding/wording clauses)

Part B is mathematically sound and its citations are faithful (single-name gamma
chain re-derived against the volumes; multi-name raw-footing and Prop 2.27 verified
at source; no filler; objects defined before use; the C-8.4 linkage consistent and
strengthened). Five surgical items land before FORMALIS signs:

1. **DEFECT-B1 (PE-2)** — correct the `L_hyb = 0` "iff": `∂_SΣ = 0` is insufficient
   (`∂_{SS}Σ` survives); state the second-order condition, or defer to the Remark's
   exact characterization.
2. **DEFECT-B2 (PE-4)** — "any other volatility leaves `L_hyb`" holds only for
   `σ = σ_mod`; name `σ_mod` / give the general `½(σ²−σ_prod²)S²Γ_hyb`.
3. **DEFECT-B3 + RULING (a) (PE-6/PE-3)** — make `σ_prod²` (sign-carrying variance)
   the canonical stored object; `σ_prod` its nonnegative root where real. Repairs the
   "sign changes auditable" inconsistency and honours totality.
4. **STRENGTHEN-B + RULING (b) (PE-2)** — add the grounding clause tying `D_ΣP` to the
   A5 curve and disclaiming a Fréchet-on-surface-space assertion; scalar reduction
   then sufficient, functional form stays a remark.
5. **Minor** — PE-4 breakeven back-reference to PE-3's real regime; PE-2 "the Greeks a
   book hedges with" → "read off the reprice map" (STYLUS, non-blocking).

With 1-4 applied, FORMALIS signs.

---

# ROUND 2 — CONVERGENCE CHECK (2026-07-20)

Re-read the changed passages against the four Round-1 items, re-derived the new m5
number independently, and checked ruling-consistency. One new item surfaced.

## The four Round-1 items

- **B1 (PE-2 iff) — RESOLVED.** l.767-775 now reads: "`L_hyb = 0` exactly when
  `δ_Δ,δ_Γ` combine to zero. Sufficient are a surface-insensitive product (`D_ΣP=0`)
  or a rule that holds the surface still *to second order* (`∂_SΣ=∂_{SS}Σ=0`) — note
  `δ_Γ` retains `D_ΣP[∂_{SS}Σ]`, so `∂_SΣ=0` alone does not suffice. The exact
  condition is that `𝒟` reproduce the model's own endogenous surface dynamics." This
  is precisely the fix requested — the false disjunct corrected, the operator-level
  iff and the Remark's exact iff both stated. Correct.
- **B2 (PE-4 residual) — RESOLVED.** l.895-900: "a volatility `σ` leaves … the
  residual `½(σ²−σ_prod²)S²Γ_hyb`, nonzero for every `σ≠σ_prod` and equal to `L_hyb` …
  exactly at the model's own `σ_mod`." The linkage (l.906-909) now distinguishes
  `σ_mod` (leaves `L_hyb·dt`) from a general `σ` (leaves `½(σ²−σ_prod²)S²Γ_hyb·dt`).
  Exactly the fix. The breakeven now also carries its real-regime caveat (l.892-894,
  `σ_prod²>0`; no real breakeven where PE-3 gives `σ_prod²≤0`) — the Round-1 minor is
  closed too.
- **B3 / ruling (a) — RESOLVED on the object choice.** PE-3 Definition (l.797-811)
  recast: `σ_prod²` is "the first-class object here — real and total wherever
  `Γ_hyb≠0`, its sign a recorded diagnostic; the product instantaneous volatility
  `σ_prod=√(σ_prod²)` is its nonnegative root where `σ_prod²≥0`." PE-6 retitled and
  built on `σ_prod²`. The object is now total off the pole with the sign as diagnostic,
  as ruling (a) required. *(But the recast introduced B4 — below.)*
- **Ruling (b) grounding clause — RESOLVED.** PE-2 l.731-738 now states the directional
  (Gâteaux) derivatives are taken along the declared C² curve of (A5), their existence
  the standing hypothesis that `P` is twice differentiable in the surface argument
  there — "not a claim of Fréchet differentiability on surface space, which the
  manifesto neither needs nor asserts" — with the strike-coordinatized integral form
  as the same object. Exactly the clause requested; the scalar reduction is now
  grounded and the functional form is a remark.

## m5 arithmetic — VERDICT: CORRECT (no fix)

Independent Black-Scholes re-derivation (S=100, K=100, σ=30%, T=0.25, r=q=0):
`Γ=0.02652` (draft 0.0265 ✓); `vega=19.89`, per vol point `0.1989≈0.20` ✓;
`vanna = −φ(d1)d2/σ = 0.09946` — matches THORP's 0.0995 and the draft's "≈0.10" ✓;
`dσ/dS=−0.01` (one vol point per 1% up-move) ✓; `2·vanna·(dσ/dS)=−0.00199≈−0.002` ✓;
`Γ_adj=0.02453≈0.0245` ✓ (dropping the volga term `−3.7e-5` and a curvature-free
`vega·d²σ/dS²` is legitimate at leading order — the vanna term dominates);
`σ_prod=σ√(Γ/Γ_adj)=0.30·√(0.02652/0.02453)=0.3119=31.19%` — matches THORP's 31.2%
and the draft's "about 31%, … a vol point of carry the implied number never showed."
Every figure reproduces. The illustration is sound.

## Ruling-consistency — the certificate field (three named vols): CONSISTENT

VM-4 (l.260-262) now names three: "the model's, the raw implied-surface, or the
product instantaneous volatility," as "a declared, recorded term … a governance lever
— it decides whether the Feynman-Kac discrepancy (PE-2) sits in the carry line or
lands in the residual." This is fully consistent with the C-8.4-by-construction ruling:
the reconciling-vol term is a certificate **field** (a declared attribution term), not
a running total; changing it *redistributes* the FK discrepancy between the carry line
and `R`, and the total stays ΔNAV **by construction** because `R` is the plug — exactly
the VM-4/VM-5 doctrine (total path-independent; decomposition convention-dependent).
And consistent with the content-in-the-bound (anti-plug) ruling: a vol choice that
dumps the discrepancy into `R` is caught if `R` breaches its bound (VM-6/VM-7), and the
term's change is an auditable governance event like the bound calibration. No second
copy of realised PnL; no contradiction. **Confirmed.**

## NEW — DEFECT-B4 (PE-6): the "projection" classification contradicts the "storage mandate" (C-4.11)

The Round-2 recast correctly reclassifies `σ_prod²` as "**a projection of the recorded
Greeks** … the deterministic algebraic function (pe:sprod) of `Θ,Δ_hyb,Γ_hyb,P` …
reproduces **unconditionally** from the record with no model re-run — stronger than a
mark" (l.1026-1030). That insight is right and valuable: unlike a mark (needs the
retained model, C-14.15), `σ_prod²` is ledger-computable from the already-recorded
Greeks. **But a projection is, by the parents, "computed when needed and never stored"
(C-4.11), "stores nothing and rebuilds from the record" (MD-6), and "a stale
projection cannot arise" (MD-8, VM-7).** PE-6 then mandates the opposite: "the
**storage mandate materialises** `σ_prod²` on the chain … the **stored** `σ_prod²`
series … a Greek forward-repaired … **flags the stored `σ_prod²` series stale**"
(l.1031-1038). Storing a quantity computable from the record, and giving it a staleness
flag, is the re-entered-observation discipline (MD-8) misapplied to a projection — and
it reintroduces the very same-fact-in-two-places pattern the framework exists to remove
(C-1.2): a stored `σ_prod²` that can drift from its recomputation over the Greeks. The
two-layer split the manifesto itself champions (VM-1) is exactly the resolution: the
Greeks are re-entered observations (stored because the ledger cannot recompute them,
C-14.15); `σ_prod²` is a projection over them (never stored, C-4.11).

**Fix (net-minimal, preserves ruling (a) and every good insight):** PE-6 mandates that
`σ_prod²` be **computed on demand and monitored** per product/valuation as a projection
over the recorded Greeks; being a projection it stores nothing and a stale `σ_prod²`
cannot arise — a corrected Greek flows through on the next read (MD-8, VM-7); its
lineage is the recipe (the Greeks it reads), not a stored copy. Drop "storage
mandate / materialises / the stored `σ_prod²` series / flags the stored series stale."
The poles and sign flips remain recorded facts of the projection's value, monitored at
each link. (This is consistent with — indeed required by — the C-8.4/two-layer rulings:
`σ_prod²` is a diagnostic projection, not a second store.)

## ROUND-2 VERDICT

- B1 RESOLVED · B2 RESOLVED · B3/ruling(a) RESOLVED (object choice) · ruling(b) RESOLVED.
- m5 arithmetic: **CORRECT.**
- Three-named-vol certificate field: **CONSISTENT** with C-8.4-by-construction and
  content-in-the-bound.
- **NEW DEFECT-B4** (PE-6 projection-vs-storage, C-4.11): the recast's correct
  "projection" classification is contradicted by its "storage mandate."

**RETURN** (very light — one rewording). **NOT YET CONVERGED**: everything asked is
resolved and the arithmetic is right, but a Constitution-level classification
inconsistency (B4) remains, cleanly fixable by mandating on-demand projection instead
of storage. One pass from sign-off — apply B4 and FORMALIS signs.

---

# ROUND 2 — B4 ADJUDICATION (2026-07-20): PARK

I am handed two binding constraints — KLEPPMANN's ruling blessing the stored,
flagged-stale, recomputable form, and the architect's B6 mandate ("`σ_prod` computed
**AND STORED** per product per valuation on the chain"), which a reviewer may not
delete. The channel offered is (i) ACCEPT the certificate-field reconciliation and
reword, or (ii) PARK with exact amendment text. **I choose (ii) PARK.** I do not accept
the reconciliation, for the reason below; and because the architect's word is binding, I
do not rewrite it — I escalate the constitutional question, with exact text, to the
owner, and the work continues around it.

## C-4.11's exact words (Constitution l.468)

> "Anything computable from the coordinates is a projection, computed when needed and
> **never stored**."

And its more specific echo, **MD-6** (the parent clause directly governing derived
objects): where a recipe "computes **over the record** … the object is a **projection**:
it **stores nothing** and rebuilds from the record alone."

## Why the certificate-field reconciliation fails to dissolve the conflict

The reconciliation's engine is the analogy: *the certificate already stores computable
quantities — the greeks, the price, the attributed lines — as recorded fields, and
FORMALIS certified that; `σ_prod²` is one more such field.* **The analogy is false on
inspection, and the difference is exactly the one C-4.11 turns on:**

1. **The greeks and price are NOT computable from the record — they are model outputs.**
   The ledger runs no model (C-14.9); a greek re-enters as an **observation** and is
   stored under a *different clause*, C-14.15. C-4.11 governs quantities the ledger *can*
   recompute; the greeks are not among them, so storing them is not a C-4.11 case at all.
   The clause that authorises storing greeks (C-14.15, model outputs) **does not reach**
   `σ_prod²`, which is not a model output.
2. **`σ_prod²` IS computable from the record.** It is a deterministic *algebraic*
   function of the recorded greeks — `−2[Θ+(r−q)SΔ_hyb−rP]/(S²Γ_hyb)` — requiring no
   model run. PE-6 itself says so: it "reproduces **unconditionally** from the record
   with no model re-run." By MD-6 that is the definition of a **projection**, and a
   projection "**stores nothing**." So the parents place `σ_prod²` squarely on the
   never-stored side.
3. **The attributed lines and the vol-choice field are not counter-examples.** The
   attributed lines are a *projection* under my own C-8.4 ruling (the residual is the
   plug; the split is recomputed, not a stored second total). The reconciling-vol field
   (three named vols) is a *declared input term* (a choice), not a computed output —
   recorded like the attribution convention (VM-5), fine. **Nothing in the certified
   architecture is a stored ledger-computable output.** `σ_prod²` would be the first.

So the reconciliation must re-read C-4.11's "never stored" as "never a *silent* second
source," and defend the stored `σ_prod²` as *not really a second store because
recomputation is authoritative*. That is precisely the move CLAUDE.md §1 names the
**worse failure**: "quietly narrows a constitutional guarantee and then relabels the
residue so the guarantee still reads as true … If you find yourself writing '…which is
not really a … second store,' stop: you are narrowing." Relabelling the stored
projection a "recorded field" does not change that MD-6 classifies it as a projection
that stores nothing.

## What I concede, and why it is still a PARK

KLEPPMANN is **right on the engineering**: a recomputable, lineage-bearing,
flagged-stale field cannot silently diverge — the C-1.2/1.3 failure mode is closed. I do
not dispute the *safety*. But **safety is not textual permission.** C-4.11's rule is
categorical ("never stored") because the architecture's principle is one canonical
record with everything else projected on demand (C-1.4). Adopting a materialised-
projection category is a *sound design that the current Constitution forbids* — and
amending the Constitution "is the owner's alone" (CLAUDE.md §1). A reviewer cannot bless
it, KLEPPMANN cannot bless it, the architect cannot bless it by mandate; the protocol
routes it to a PARK. This is the mechanism working, not a veto of anyone's judgement:
the park **carries KLEPPMANN's rationale** as the justification for the amendment.

## PARK ENTRY (for the open-problems index)

- **Conflict.** B6's mandate to **store** `σ_prod²` on the chain conflicts with C-4.11
  ("computed when needed and never stored") and MD-6 (a projection "stores nothing"),
  because `σ_prod²` is a projection — an algebraic recomputation over recorded greeks,
  no model run (PE-6's own words).
- **Exact clause replaced.** C-4.11, final sentence: *"Anything computable from the
  coordinates is a projection, computed when needed and never stored."*
- **Exact proposed amendment text** (generalises KLEPPMANN's flagged-stale-cache):
  > "Anything computable from the coordinates is a projection, computed when needed;
  > recomputation from the record is always authoritative. A projection's value MAY be
  > recorded as a verifiable field of a re-entered observation or a certificate — a
  > **materialised projection** — only where (i) recomputation from the record remains
  > authoritative and always available, (ii) the recorded value carries complete lineage
  > to the inputs it was computed from, and (iii) any correction to those inputs flags
  > the recorded value stale. So recorded, it is never a second source that can silently
  > diverge, and recomputation is the standing check. Absent all three, a projection is
  > never stored."
  Mirror in **MD-6** ("stores nothing → stores nothing, save as a materialised
  projection under C-4.11's three conditions").
- **Alternative resolution** (if the owner prefers to keep C-4.11 literal): B6's "stored"
  becomes "computed on demand and monitored"; `σ_prod²` is a projection, never stored.
- **Interim disposition of the draft.** Pending the owner's ruling, PE-6 must present
  `σ_prod²`'s storage **honestly as parked** — "stored per B6, parked against C-4.11/MD-6
  (open-problems index)" — and must **not** carry the "materialises / stored series /
  projection-cache" relabelling as though the conflict were resolved. The classification
  insight PE-6 already prints ("a projection … reproduces unconditionally … stronger than
  a mark") is correct and stays; it is exactly what makes the storage a C-4.11 question.

## Ruling-consistency (as asked)

- **Three-named-vol certificate field: CONSISTENT** with C-8.4-by-construction and
  content-in-the-bound — it is a declared *input* term that redistributes the FK
  discrepancy between the carry line and `R` while the total stays ΔNAV by construction;
  no second PnL total. (Confirmed above and in the Round-2 body.)
- **`σ_prod²`-with-enumerated-lineage: CONSISTENT on the C-8.4 and content-in-bound axes**
  (it is a diagnostic, not a PnL total; lineage is MD-6 discipline) — but its **storage**
  is the C-4.11 conflict now parked. The enumerated lineage does not cure it; it is the
  staleness half of a materialised-projection pattern the Constitution has not yet
  admitted.

## ROUND-2 FINAL VERDICT

- B1 RESOLVED · B2 RESOLVED · B3/ruling(a) RESOLVED (object choice: `σ_prod²`) ·
  ruling(b) RESOLVED · m5 arithmetic **CORRECT** · three-vol field **CONSISTENT**.
- **B4: PARKED** — C-4.11/MD-6 vs B6's "stored"; exact amendment text supplied above;
  escalated to the owner; KLEPPMANN's engineering rationale carried as its justification.
- **RETURN** (PE-6 must record the park honestly, not relabel it away). **NOT CONVERGED**
  — a constitutional park is open; per protocol that *is* the terminus of this question,
  and the work proceeds around it. The mission's open-problems index gains its first
  entry, by considered judgement, not oversight.

---

# FINAL CONFIRMATION & SIGNATURE (2026-07-20)

Re-read PE-6 (in-force) and the "Open Problems (Parked Items)" section (pp 14-15) of
`ValuationManifesto_1.0.tex`. The B4 treatment matches my ruling with no deviation:

- **PE-6 in-force runs the conforming reading.** Retitled "computed on demand per
  product and per valuation." `σ_prod²` is stated a "projection … computed when needed
  and never stored (C-4.11, MD-6)," monitored "by recomputation over the chain's
  recorded Greeks, which is authoritative, so it cannot drift (VM-8)." The
  cache/materialises/stale-series vocabulary is gone (verified). The correct
  classification ("a projection … reproduces unconditionally … stronger than a mark")
  is kept; only the storage half is flagged parked, and "nothing above depends on
  storage."
- **PARK-1 is complete and faithful.** It states the conflict (`σ_prod²` a projection;
  the first stored ledger-computable output), quotes the exact C-4.11 final sentence
  verbatim, carries my exact amendment text (the materialised-projection three
  conditions) with the MD-6 mirror, records KLEPPMANN's safety rationale with the
  "safety is not textual permission" boundary, gives the literal alternative, and
  reserves the decision to the owner.

## FORMALIS SIGNATURE

I, **FORMALIS**, sign the following, having re-derived every load-bearing claim and
verified every citation at source rather than certifying on the author's word.

**Scope of signature.**
- **Part B, PE-1..PE-6.** Objects well-defined before use; A1-A5 each load-bearing;
  the Feynman-Kac claim exact under A2; the `L_hyb` identity re-derived and exact, its
  vanishing condition now correct (`∂_SΣ=∂_{SS}Σ=0`, not `∂_SΣ=0`); `σ_prod²` well-posed
  with all three failure modes stated and the sign a recorded diagnostic; theta-
  invariance and the breakeven derived, with the real-regime caveat; the residual at a
  general `σ` correctly `½(σ²−σ_prod²)S²Γ_hyb`, equal to `L_hyb` only at `σ_mod`; PE-5's
  single-name `Γ_adj` re-derived term-by-term against Vol I (2.19)-(2.21), the multi-name
  path entering the raw-footing `Γ^sh` (not `ShadowGamma`) with Prop 2.27 named — no
  double count; the m5 number independently reproduced (`Γ=0.02652`, `vanna=0.09946`,
  `Γ_adj=0.02453`, `σ_prod=31.19%`).
- **The Part A linkage (VM-4 gamma-theta / three-vol field; VM-6 anti-plug).** The
  reconciling-vol field is a declared input term that redistributes the FK discrepancy
  between the carry line and `R` while the total stays ΔNAV **by construction** — my
  C-8.4 ruling intact — and the anti-plug ("reconciliation is automatic; only R-below-
  bound certifies") is its correct completion.
- **PARK-1.** The C-4.11/MD-6-versus-B6 conflict is genuine and is parked, not fudged;
  the amendment text and clause are exact; the disposition is the owner's.

**Assumptions named (the signature rests on these; none re-verified by me beyond the
stated checks).**
1. The equation-number resolutions to Vol I/II (`.aux`-resolved by JACOBI/THORP) are
   current; I verified the single-name chain (2.19)-(2.21), (1.13) and the raw-footing
   (2.21)/(2.23) at source, and trust the remaining printed numbers to their `\label`s.
2. GATHERAL's term-by-term Vol II (2.23) ShadowGamma check stands (his charter); I
   verified only its structure and the raw-footing entry.
3. Model-side inputs (the greeks `Θ,Δ_hyb,Γ_hyb,P`, the surface, the dynamic `𝒟`) are
   recorded per VM-1/A5; `σ_prod²`'s status as a projection rests on their being on the
   record.
4. Numerical BS values assume `r=q=0`, `T=0.25`, `σ=0.30` as the draft's stated
   coordinates.

**Disposition: SIGN** — Part B PE-1..PE-6, the Part A linkage, and PARK-1, as drafted
in the in-force text, subject to the assumptions above. The one open constitutional
question (PARK-1) is correctly escalated to the owner and blocks nothing else.

**CONVERGED** (with PARK-1 open by design). — FORMALIS, 2026-07-20.
