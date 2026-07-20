# FORMALIS — Rigor Review of Valuation Manifesto 1.0

Target: `/home/renaud/Ledger/Valuation/ValuationManifesto_1.0.tex` (VM-1..VM-10).
Reviewer: FORMALIS. Inputs: THORP drafting note §4; JACOBI PnL memo; GATHERAL
interface memo; parents `ledger_manifesto_v1_4.tex` (Constitution) and
`MarketDataManifesto_1.1.tex` (MDM); source `volume_I.tex`, `volume_II.tex`.

Method: every C-x.y and MD-n citation token was resolved against the named parent
(all present exactly once — no dangling or misnumbered reference); every number in
§3 was re-derived from Black–Scholes independently (script, r=0, σ=0.30, T=0.25);
the exact/ex-ante identities were checked against Vol I Thm (l.2580–2596) and the
shadow claims against Vol II (l.2560–2573, l.885–896).

---

## PART A — THORP's unsettled items (decision-grade)

### (1) THE C-8.4 QUESTION — RULING: RECONCILED-AS-DRAFTED, correct **by construction**; STRENGTHEN with supplied text. Parking index stays empty.

**C-8.4 verbatim** (Constitution l.707–710): *"the profit and loss of any wallet is
exactly the variation in its NAV. PnL between two dates is path-independent, and no
second copy of 'realised PnL' or 'book cost' is ever maintained alongside the
position record."*

The sharp question: does storing a valuation chain of per-link PnL-explain
certificates create a *second copy of realised PnL* that could **disagree** with the
fold's ΔNAV?

**Answer: no, and the reason is arithmetic, not stylistic.** The residual `R` in the
certificate is the *balancing term*: by the Fundamental P&L identity (Vol I Thm
l.2580–2596, exact for cubics, `R` its defined remainder otherwise),
`V(x1)−V(x0) = ½(Δ0+Δ1)h − (1/12)(Γ1−Γ0)h² + R`, so `R := [value change] − [every
attributed line]`. Summed quantity-weighted over the book, the left side **is** ΔNAV.
Hence `Σ(attributed lines) + R ≡ ΔNAV` *identically* — the certificate is a
**projection of the one number ΔNAV**, and `R` absorbs whatever the greeks do not
name. To compute `R` you must already hold ΔNAV (the fold); the certificate never
computes an independent "realised PnL" that could drift. "Explained" (VM-6) then
tests only whether that plug is small. No second store exists; disagreement is
impossible by construction. **C-8.4 is honoured.**

Cross-check — does the draft anywhere make *total* PnL path-dependent? No. VM-4 is
explicit: "The total the certificate explains is path-independent… the identity that
the parts sum to ΔNAV holds on every path; the split into parts does not." VM-5's
"same marks today, different profit-and-loss tomorrow" (from Vol II l.893) is
**model**-dependence across two convention *records*, not path-dependence within one
record; C-8.4 governs one record and is not touched. (Minor wording note in Part C.)

**Why STRENGTHEN and not sign-as-drafted.** The draft *asserts* the identity ("the
parts sum to ΔNAV holds on every path") and *denies* a second store, but never prints
the one line that makes it airtight — that `R` is the plug, so the total equals the
ledger-state difference **by construction** and attribution only decomposes it. For a
committee whose rule is "a claim is proved, not asserted," the load-bearing C-8.4
reconciliation should exhibit its mechanism. Supplied text, to append in VM-4 after
"…to disagree with it (C-8.4)":

> *Because the residual is the balancing term — the value change less every attributed
> line — the certificate reconciles to the change in net asset value by construction,
> not by coincidence: it is a projection of that one number, and no split it prints can
> make it disagree with the fold. Attribution decomposes ΔNAV; it never recomputes it.*

This is the item that decides the park ledger: with the mechanism printed, the tension
is not merely *assessed* reconcilable but *shown* so. **No park.**

### (2) C-14.9 COMPLIANCE — COMPLIANT; argument STATED (not merely assessed).

**C-14.9 verbatim** (l.941): *"The ledger records the outputs of pricing models and
never runs one."* **C-14.15** (l.954): model outputs re-enter only as new observations.

The mandated stored chain does not over-reach. The chain's **stored** content is
valuation records = re-entered observations: the model runs *outside* the fold, its
output re-enters through the one door (VM-1: "the ledger does not run the model
(C-14.9); the model runs outside the fold and its output… re-enters through the one
door as a recorded observation (C-14.15)"). Storing a sequence of such outputs **is**
"recording outputs," which C-14.9 explicitly commands. The chain's **assembly** and
the certificates are projections/folds over those stored records (§1: "the valuation
chain that assembles them are… a projection that computes over the record… storing
nothing"). VM-7 seals it: a stored valuation record "cannot re-run itself (C-14.9)."
The argument is present across §1 + VM-1 + VM-3 + VM-7. **Stated. Compliant.** (It is
distributed rather than gathered in one place — acceptable, not required to change.)

### (3) THE SHIFTED-WORLD NUMBERS — RE-DERIVED. Results correct; **one DEFECT** in the printed formula.

Independent BS (r=0): C(120)=**20.8913** (d1=1.2905, d2=1.1405, N(d1)=0.9016,
N(d2)=0.8730); full reval = 20.8913−5.9785 = **+14.9127** ≈ +14.9; mark → **20.89**;
gap (unrounded greeks) = 15.9021 − 14.9127 = **0.9894** ≈ +1.0. **All stated results
correct.** Base greeks confirmed: C=5.9785, Δ=0.5299, Γ=0.02652, θ_day=−0.04736.
Market-move link (C102=7.0908, Δ-PnL 1.0598, Γ-PnL 0.0530, residual −0.0006≈−0.001),
carry (−0.047→5.93), breakeven (σS/√252 = 1.8898 ≈ 1.89; ½Γδ_BE² = 0.04736 = |θ_day|),
and the 2:1-split zero-PnL identity (at S=102: 1×C(102,100)=7.0908 → 2×C(51,50)=7.091)
**all verified**.

**DEFECT-1 (§3, .tex l.429).** The printed estimate `0.53×20 + ½×0.027×20²` evaluates
to **16.0**, not the stated "≈ +15.9"; its gap to reval would then be 1.09, not "+1.0".
Root cause: gamma is *displayed and plugged* as 0.027 here, while the rest of the
worked example (and Vol I Example 1.2) uses Γ=0.0265 — the market-move Γ-PnL 0.053 and
the breakeven 0.047 are already computed with 0.0265. Only 15.9 is right
(0.5299·20 + ½·0.02652·400 = 15.90). **Fix:** write the formula with 0.0265
(`0.53×20 + ½×0.0265×20² ≈ +15.9`); for display/compute consistency, show the base
gamma as 0.0265 (matching Vol I) rather than 0.027, so a reader who reconstructs any
line reproduces the stated number.

### (4) MD-13 NARROWING WATCH (VM-9) — FAITHFUL. No narrowing re-crept.

Read MD-13 in full (MDM l.392–456). VM-9 cites it wholesale and **keeps every clause
the 1.1 review flagged as at-risk**:
- "derived objects recomputed from operator-adjusted inputs, never scalar-transported"
  — matches MD-13 l.427 ("derived quantities are recomputed from operator-adjusted
  inputs") and C-9.3 l.755. **Not dropped.**
- "acts on leaf observations" — MD-13 l.422. Faithful; the operator is not re-coined
  ("valuation operator" is *not* minted — Auth.4 respected).
- "operator exists only once the action's terms are **resolved**, not merely announced;
  before resolution the frame is provisional" — MD-13 l.413–418, resolved ≠ announced
  (elective/fixing/proration/election). **Kept.**
- The zero-profit frame identity cites C-11.3 (l.810–814, the 2000×50 vs stale-100
  phantom) exactly; genuine economics (special dividend) is separated as its own line.
- `≈0` = exactly three tolerances — minor-unit rounding **once at read** (C-4.6 via
  MD-13 l.428–429), the convention's own rounding, and the calibration τ of any
  re-derived surface/curve (VM-6). Matches JACOBI §5. The zero-PnL identity and the
  three-tolerance ≈0 are stated as JACOBI required. **No narrowing.**

### (5) EMPTY PARKING INDEX — CONFIRMED a considered zero, not an omission.

Every candidate conflict was stress-tested and each reconciles:
- C-8.4 vs VM-4/VM-5 (chain/certificate as second copy): reconciled **by construction**
  — item (1). The residual-is-the-plug argument makes disagreement arithmetically
  impossible; no open-problem is needed.
- C-14.9 vs mandated stored chain: compliant — item (2). "Records outputs" covers it.
- C-4.11 ("anything computable… never stored") vs the chain: no conflict — model
  outputs are **not** computable by the ledger, so they are stored as observations
  (C-14.15), while the computable assembly is projected and stored nothing.
- VM-9 zero-PnL identity vs C-8.4/C-9: no conflict — re-coordination is value-preserving,
  economics is separate PnL.

No genuine Constitution/MDM conflict demands an open-problems entry. The empty index is
a **decision**, and item (1)'s printed mechanism is what earns it.

---

## PART B — Article-by-article sweep

Definition well-formedness, derivation from the named principles, citation
correctness. Every C/MD token resolved to its parent; no "clearly/obviously/it
follows"; no "datum"; "chain" only compound ("valuation chain"), doctrinal ("broken
chain"), or anaphoric — vocabulary discipline holds.

- **§1 (two layers) — SOUND.** The leg=re-entered-observation / NAV+chain=projection
  split (GATHERAL T1) is stated cleanly and every downstream article rests on it.
  Citations C-4.10, C-8.2, C-14.9, C-14.15, MD-1, MD-12, MD-15, C-1.4, C-4.8, MD-13,
  MD-11, C-Auth.4 all verified. *Minor clarity (Part C-b).*
- **VM-1 — SOUND.** Two layers as first article; NAV = replay × price vector, stores
  nothing (C-8.2/8.3). Faithful.
- **VM-2 — SOUND.** Coordinate set (position/state/frame/cut/models) and bit-for-bit
  reproducibility. No overclaim: "any party recomputes the identical valuation" is the
  **projection** over stored observations (unconditional, C-2.2/C-14.11); model
  *re-derivation* is correctly deferred to §4 as conditional on the retained model
  (C-14.15). The ex-ante/exact and read-back/re-derive distinctions are not blurred here.
- **VM-3 — SOUND.** Chain = ordered valuation records, each proven from the last; both-
  end measured greeks (JACOBI §4) correctly motivated (keep orders 1–2 exact, squeeze
  Hessian gaps into 3rd-order+R). C-4.8/12.1/12.4/MD-6 verified.
- **VM-4 — SOUND on the identity; STRENGTHEN (item 1); contributes to DEFECT-2.** The
  exact both-end identity ("average of entry/exit deltas, less one-twelfth of the gamma
  that moved, plus R; R=0 only for cubics") matches Vol I Thm exactly. Ex-ante special
  case (Δδ+½Γδ²) correctly labelled an estimate. Residual regimes (O(‖h‖⁴) for C⁴;
  O(1) at digital/barrier/autocall; calendar direction never bounded) match JACOBI §1.
  Composition with C-12.6 reordering explain is faithful (GATHERAL T2). *See DEFECT-2
  for the "gap to the reprice equal to the variation of gamma" phrasing.*
- **VM-5 — SOUND.** Convention-dependence (sticky-ρ / sticky-CVC), shadow greek not a
  market property, spot-channel shadow ≡0 under σ_ATM=const — all match Vol II
  l.885–896 and l.2560–2573 verbatim in substance. *Minor wording (Part C-a).*
- **VM-6 — SOUND.** "Explained" = residual below a *declared* bound (τ from the model
  config; τ_vol=τ_price/vega); residual as sensor (small ∧ mean-zero ∧
  regime-independent) vs cubic-toxic. Matches JACOBI §3. C-2.4/C-13.2/MD-9/MD-15 verified.
- **VM-7 — SOUND.** Broken chain forbidden; projection self-heals, re-entered record
  flagged stale (never overwritten), read through a staleness-carrying projection.
  Matches MD-8/MD-10; C-14.9/C-1.5/C-12.4 verified.
- **VM-8 — SOUND.** Extends MD-14's exhibit list with chain + certificates (one replay,
  not a second doctrine); bound exact and inherited; localises but does not adjudicate a
  two-sided economic dispute. Faithful to MD-14.
- **VM-9 — SOUND.** See item (4). CA sandwich, operator as the only admissible jump
  explanation, zero-PnL identity, three-tolerance ≈0, resolved≠announced — all faithful,
  no MD-13 narrowing.
- **VM-10 — DEFECT-2.** Recipe-on-shifted-data, shifts compose, seed/shift recorded,
  stress path is a derived object with full lineage — all sound and match MD-11/C-2.8.
  **But** the greek-vs-reval gap is mischaracterised (below).

**DEFECT-2 (VM-10; phrasing seeded in VM-4).** VM-10 calls the gap between the greek
approximation and full revaluation "the ex-ante estimate of VM-4 against the reprice,
**the same deterministic, signed quantity**." That equates the whole gap with the
gamma-variation term `E`. By JACOBI §6 the gap = **E + R**: `E` (deterministic, signed,
gamma variation) *plus* the residual `R`. For the smooth §3 example this is fine
(E≈−1.02, R≈+0.03, gap −0.99). But VM-10 is a *general* principle, and for the very
non-smooth books the manifesto elsewhere emphasises (digital/barrier — VM-7, §3), `R`
is **O(1)** and is exactly the un-signed toxic residual, not a benign deterministic
gamma term. Promising a uniformly "deterministic, signed" risk-report error is a
promise the mathematics cannot keep for those books, and it blurs the ex-ante/exact
distinction the manifesto rests on. **Fix:** state the gap as the gamma-variation term
(deterministic, signed) **plus** the residual R of VM-4/VM-6 — small for smooth books,
O(1) at a discontinuity — matching JACOBI §6. The operational instruction ("compute
both and record their difference") is correct and stays.

- **§3 worked chain — DEFECT-1 only** (item 3). Every other number verified.
- **§4 (scope), §5 (subordination), Conclusion — SOUND.** Scope exclusions cite
  C-Scope.11/MD-9/MD-15/C-14.9/C-14.15 correctly; the read-back-unconditional vs
  re-derive-with-model distinction is stated. Subordination to both parents and the
  park-with-exact-text discipline are correctly restated.

---

## PART C — Minor clarity (non-blocking; author discretion)

- **(a) VM-5 "different profit-and-loss tomorrow."** Governed by "differ in tomorrow's
  attribution," so it reads as attribution — but the bare phrase, lifted from Vol II,
  can be misread at the *total* level given C-8.4 sensitivity. Consider "different
  **attributed** profit-and-loss tomorrow" to foreclose the misreading. Not a defect.
- **(b) Chain "stores nothing" vs "append-only… new link."** §1 says the chain-as-
  projection stores nothing; VM-3 says a re-mark is a new appended link. Both are true
  at their layers (the appended link is a new valuation *record*=observation; the
  assembly is a projection), and §1's two-layer framing already resolves it — but a
  one-clause reminder in VM-3 that the "new link" is a re-entered observation would
  remove the last friction.
- **(c) Base gamma display.** Showing 0.027 while computing 0.0265 (see DEFECT-1) is the
  root of the §3 arithmetic slip; display 0.0265 throughout.

---

## VERDICT: **RETURN** (light — two surgical fixes + one recommended strengthening)

The architecture is sound and the inheritance is faithful: the two-layer doctrine is
clean, every citation resolves, MD-13 is carried without narrowing, the C-8.4 tension
is reconcilable **by construction**, and the empty parking index is justified. Three
things land before FORMALIS signs:

1. **DEFECT-1** — §3 l.429 printed formula evaluates to 16.0, not the stated 15.9; use
   Γ=0.0265 (and display the base gamma consistently). *Hard arithmetic.*
2. **DEFECT-2** — VM-10 (and the VM-4 phrasing feeding it): the greek-vs-reval gap is
   **E + R**, not solely the benign deterministic-signed gamma-variation; name both
   parts so no promise is made that the mathematics cannot keep for non-smooth books.
3. **STRENGTHEN-1** — VM-4: print the by-construction sentence (supplied) so the C-8.4
   reconciliation is *shown*, not asserted; this is what earns the empty park ledger.

With these three applied, FORMALIS signs.
