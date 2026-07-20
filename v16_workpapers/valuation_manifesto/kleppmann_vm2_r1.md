# KLEPPMANN — Review of the two-part Valuation Manifesto (Part A + Part B "The Pricing Engine"), Round 1

**Charter:** event-sourcing / data semantics. Chain and certificate integrity; no derived quantity
may silently diverge from what recomputation over the record gives (the MDM sin). **Scope:** the
three coordinator vectors — the Part-A linkage edit (VM-4/VM-6), Part B's on-chain σ_prod (PE-6),
and the PE-6 monitoring claim — read against Part A (converged) and the two parents.

**Read:** `ValuationManifesto_1.0.tex` (Part A VM-1..VM-10 + Part B PE-1..PE-6 in full);
`drafting_note.md`; confirmed the converged Part-A passages verbatim.

**Headline.** Part B is a clean, honestly-derived mathematical appendix (the Feynman–Kac
discrepancy, σ_prod, the non-smoothness caveats are all stated, not waved), and the linkage edit
leaves everything I converged on intact. But the one *record-governance* act in Part B — PE-6's
mandate to store σ_prod on the chain — misclassifies σ_prod against the manifesto's own two-layer
taxonomy and gives it an incomplete lineage, reopening the exact silent-divergence sin Part A
closed. And the new carry-line *declaration* field is not given the declared-recorded-term
discipline its siblings (the convention, the bound) both carry.

---

## Attack (1a): the linkage edit does not disturb the converged content — CONFIRMED

Verified verbatim in the current file:
- **VM-7 transitive forward repair** — "Staleness propagates forward along the chain ... each
  re-proves *forward from the superseding predecessor* ... a mark that no longer heads its segment
  (MD-6, MD-8). The as-known branch survives (C-12.1)." Intact.
- **VM-9 reordering route** — "A third timing case is a resolved action that reaches the door
  *late* ... a reordering, not a lineage supersession ... flagged stale by the reordering trigger
  (C-2.7, MD-5) ... sandwich is struck *retroactively* ... the spurious market-move line ...
  reclassified ... (C-12.6). The loss is never left standing." Intact.
- **VM-6 content-in-the-bound / anti-plug** — "reconciles to the change in net asset value proves
  *nothing* ... only the residual *below its declared bound* certifies. Reconciliation is
  automatic; explanation is earned." Intact.

The VM-4 edit ("the carry line must *declare which volatility reconciles it*: the model's, or the
product's") and the VM-6 edit (naming the FK discrepancy as a structural residual source) are
*additions*, not disturbances. The converged spine stands.

## Attack (1b): the new "which volatility reconciles the carry line" declaration does not inherit the declared-recorded-term discipline — MATERIAL

VM-4 now requires the certificate to "declare which volatility reconciles" the carry line — σ_prod
or the model's σ. PE-4 proves the balance closes at **exactly one** volatility (σ_prod); declaring
the model's σ instead leaves the FK discrepancy `L_hyb·dt` in the residual `R` (VM-6/PE-4). So this
declaration is a **governance lever on certification**: it controls whether the FK discrepancy is
"explained" (in the carry line at σ_prod) or lands in `R` — and whether `R` then breaches its bound
and breaks the chain (VM-7). This is *exactly* the kind of lever VM-6 already guards for the bound
("the bound's calibration is itself a recorded, reviewable event, so a loosened bound is an
auditable change, never a silent one") and VM-5 for the convention ("a declared, recorded term of
the valuation (MD-6)"). **VM-4 gives the reconciling-volatility declaration no such statement.**

> **Scenario.** A book's certificates declare σ_prod and reconcile cleanly (small `R`). A desk
> quietly switches the declared reconciling volatility to the model's σ. Now `L_hyb·dt` lands in
> `R`. If the bound is generous the moves still read "explained"; the FK discrepancy has been moved
> out of the carry line and buried in a within-bound residual — a re-attribution that changes what
> the certificate asserts, with no reviewable-convention-change event marking it. The change is on
> the (append-only) record, but nothing flags it as a governance change the way VM-5/VM-6 changes
> are flagged.

**Fix (one clause, parity):** state that the reconciling-volatility choice is a declared, recorded
term of the valuation (MD-6), and a change to it is an auditable, reviewable event — exactly as the
attribution convention (VM-5) and the certification bound (VM-6) already are.

## Attack (2): PE-6 misclassifies σ_prod and gives it an incomplete lineage — the MDM divergence sin is reopened, not closed — MATERIAL

σ_prod is, by its own construction (PE-3(i): "defined by algebraically inverting (pe:sprod-pde)
given `(Θ, Δ_hyb, Γ_hyb)`"; PE-3(iii): "the ratio `N/M` of two independently constructed fields"),
a **deterministic algebraic function of the recorded greeks** `Θ, Δ_hyb, Γ_hyb, P` and market data
`S, r, q`. Every input is already on the record (VM-1: the model price "together with the
sensitivities computed with it" re-enters; VM-3: the certificate "carries measured sensitivities at
both ends"). Recomputing σ_prod needs **no model re-run** — only the algebra over recorded values.
By VM-1's own taxonomy that makes it a **projection** — "a value computed over the record ...
consuming the model-priced legs as leaves," exactly as NAV consumes model prices — and by C-4.11
"anything computable from the coordinates is a projection, computed when needed and never stored."

PE-6 instead (a) classifies σ_prod as a **re-entered observation** ("re-enters as a recorded
observation (VM-1)"), (b) **mandates storing it** on the chain ("computed and *stored* per product
per valuation"), and (c) states its lineage as "the pricing model and the declared surface-move map
`D` it was fitted under" — **not the greeks it is computed from.** These three choices together
reopen the divergence sin:

> **Scenario.** A valuation records `Θ, Δ_hyb, Γ_hyb, P` (re-entered observations) and, per PE-6,
> stores σ_prod = −2[Θ+(r−q)S·Δ_hyb−rP]/(S²·Γ_hyb) on the chain, lineage = "model + D." A market
> observation feeding Γ_hyb is corrected (MD-10); by VM-7 the greek Γ_hyb is flagged stale and
> re-derived forward as Γ_hyb′ — **same model, same D**, only the input moved. The stored σ_prod
> was computed from the old Γ_hyb and is now stale. But its stated lineage is "model + D," neither
> of which changed, so σ_prod's lineage **shows no input moved** → it is **not flagged stale** →
> PE-6's monitored "evolution and regularity" series reads the stale value, silently diverging from
> what recomputation (with Γ_hyb′) gives. This is precisely the MDM sin, and precisely the
> lineage-enumeration gap I raised for CA events in the Market Data Manifesto.

**Fix.** Classify σ_prod as a **projection** of the recorded greeks — recomputed on read, never
stored — so it *cannot* drift (VM-8: a projection "stores nothing and cannot drift"); "on the
chain" should mean "computable on demand from the chain's recorded greeks," not "materialised as a
frozen re-entered observation." If a stored series is genuinely wanted for monitoring σ_prod's
evolution, its lineage **must enumerate the greek observations** `Θ, Δ_hyb, Γ_hyb, P` it consumed,
so a corrected greek flags it stale (VM-7/MD-8). Either fix closes it; the projection classification
closes it structurally and also honours C-4.11 / VM-1 ("No valuation adds a store to the ledger").

*No circularity:* the coordinator flagged "the certificate's own quantities." I checked — the
dependency is linear (greeks → σ_prod → carry line), not circular: σ_prod is computed from the
greeks and is *upstream* of the carry line that consumes it. Fine.

## Attack (3): the monitoring adjectives — genuine, but two are contingent on the fix and one over-imports — MINOR

PE-6: σ_prod's "evolution ... and regularity ... are thereby *auditable, reproducible, and
dispute-ready* on the same terms as any mark (VM-8)." None is pure decoration, but:
- **Reproducible — carried, in fact under-claimed.** σ_prod reproduces *unconditionally* from the
  recorded greeks (a projection needs no model), which is *stronger* than "the same terms as any
  mark" (a mark's number needs the model, C-14.15). The phrasing under-states it — a consequence of
  the attack-(2) misclassification.
- **Auditable — carried only if the lineage reaches the greeks.** As stated, the lineage is "model
  + D," so an audit of σ_prod cannot trace it to the specific greeks it was computed from. Contingent
  on the attack-(2) lineage fix.
- **Dispute-ready — a mild category stretch.** VM-8's dispute-readiness settles a *counterparty*
  dispute over a *mark*; σ_prod is an internal diagnostic, not a counterparty-facing mark. It is
  dispute-ready only *transitively*, as an input to the certificate of a mark that is. "On the same
  terms as any mark" over-imports VM-8; the honest claim is "reproducible under challenge, as an
  input to a dispute-ready mark's certificate."

These are precision issues on the monitoring claim, MINOR, and the first two dissolve once
attack (2) is fixed.

---

## Verdict

- **Attack (1a): CONFIRMED** — the converged VM-6/VM-7/VM-9 spine stands verbatim; the linkage
  edits are non-disturbing additions.
- **Attack (1b): MATERIAL** — the reconciling-volatility declaration is a governance lever on
  certification but is not made a declared-recorded-term whose change is auditable, unlike its
  siblings VM-5 (convention) and VM-6 (bound). One-clause parity fix.
- **Attack (2): MATERIAL** — PE-6 misclassifies σ_prod (a projection of recorded greeks) as a
  stored re-entered observation and gives it a lineage ("model + D") that omits the greeks it is
  computed from; a corrected greek does not flag the stored/monitored series stale → silent
  divergence from recomputation, the MDM sin. Fix: classify as a projection (never stored, cannot
  drift), or enumerate the greeks in the lineage.
- **Attack (3): MINOR** — the three adjectives are genuine but two are contingent on the attack-(2)
  fix and "dispute-ready" mildly over-imports VM-8; "reproducible" under-claims.

Both material findings are fixable **within** the framework (a parity clause; the projection
classification / lineage completion) — no park. Because both would materially improve the
semantics, this is **NOT CONVERGED**; one round on (1b) and (2) is warranted.

---

# Round 2 — Convergence check (14pp)

**Read:** the two changed passages — VM-4 (the which-volatility field) and PE-6 (σ_prod² on the
chain).

**M1b — RESOLVED, semantically exact.** VM-4 now: "The carry line therefore carries a declared,
recorded term naming *which* of the volatilities in play it was reconciled against --- the
model's, the raw implied-surface, or the product instantaneous volatility. That term is a
governance lever --- it decides whether the Feynman--Kac discrepancy (PE-2) sits in the carry line
or lands in the residual --- so a change to it is an auditable, reviewable event, exactly as the
attribution convention (VM-5) and the certification bound (VM-6) are." Declared-recorded-term
discipline (MD-6), auditable-change parity with VM-5/VM-6, and all three volatilities named. The
governance lever I flagged is now guarded exactly as its siblings.

**M2 — RESOLVED, and the forward-repair scenario now fires.** PE-6 now classifies the object
correctly and completes the lineage:
- *Classification:* "It is a *projection* of the recorded Greeks: the deterministic algebraic
  function of Θ, Δ_hyb, Γ_hyb, P and the market state, so it reproduces *unconditionally* from the
  record with no model re-run --- stronger than a mark ... and read on demand it cannot drift
  (VM-8)." Projection, not re-entered observation; and this also fixes my minor-3 reproducibility
  under-claim (now "stronger than a mark").
- *Lineage:* "its lineage *enumerates the Greeks it is computed from* --- Θ, Δ_hyb, Γ_hyb, P ---
  beside the pricing model and the declared dynamic 𝒟 ... never model-and-𝒟 alone, so a Greek
  forward-repaired under a corrected input (VM-7) flags the stored σ_prod² series stale and it can
  never silently diverge from recomputation over the corrected Greeks (MD-8)." My round-1 scenario
  (Γ_hyb corrected under the same model and 𝒟) now flags the stored series stale — the greek is in
  the lineage, its supersession fires MD-8. Closed.
- *Pole/sign as diagnostic:* switching the canonical stored object to σ_prod² (sign-carrying, real
  wherever Γ_hyb≠0) is a clean refinement; "at a pole (Γ_hyb=0) σ_prod² is undefined and the
  recorded fact is the pole itself; where σ_prod²<0 ... the sign is the diagnostic, not an error to
  be smoothed." Correct.
- *Minor 3 (adjectives):* "auditable and reproducible under challenge, an internal diagnostic
  feeding the certificate of a dispute-ready mark (VM-8), not itself a counterparty mark." The
  over-import of VM-8 is removed; the adjectives are now exactly what the machinery carries.

**The projection-classified-yet-stored combination does not open a divergence path — no extra
clause is needed, and the requested one would be a category error.** I checked this directly, since
a materialised projection is a cache and a cache can drift. It cannot drift silently here, for two
composed reasons: (i) the stored σ_prod²'s lineage enumerates the greeks, so a corrected greek
flags the cache stale (MD-8); (ii) that staleness flag is *itself a projection* over the lineage
and the record, hence always fresh on read — a reader cannot obtain the stored value without the
current flag. The truth is then one recomputation away (σ_prod² reproduces unconditionally). So the
cache is flagged-and-recomputable, never a silent second source of truth.

On the coordinator's explicit question — whether the doc needs "one more clause saying a stale
stored σ_prod² is superseded forward like any re-entered quantity": **no, and it should not add
one.** Supersede-forward is the staleness mechanism for a *re-entered observation*, which cannot be
recomputed (it needs the retained model), so a fresh value must be materialised forward. σ_prod² is
a *projection*: its correct staleness mechanism is flag-stale + recompute-on-read, which PE-6 now
states ("flags the stored series stale ... can never silently diverge from recomputation"). Adding
"superseded forward like any re-entered quantity" would re-import the very misclassification M2
removed — treating a projection as a re-entered observation. The document is category-correct as
written.

*(The residual C-4.11 tension — a projection is "computed when needed and never stored," yet the
mandate stores it — is not a divergence on my charter: PE-6 is explicit that the stored series is a
monitoring materialisation kept honest by lineage + staleness, with the recompute-on-read the
canonical truth, not a second source of truth. The store is a flagged cache, not a drifting copy.)*

**Fresh-material hunt — nothing.** The σ_prod²-vs-σ_prod refinement, the "degenerate carry"
framing (pole = carry-line analogue of VM-4's O(1) residual at a digital), and the added VM-7/MD-8
citations all compose cleanly with Part A. Part A's converged spine (attack 1a) remains verbatim.

## Round-2 verdict

- **M1b RESOLVED** (declared recorded term; auditable-change parity with VM-5/VM-6; three vols named).
- **M2 RESOLVED** (σ_prod² classified as a projection; lineage enumerates the greeks; forward-repair
  now flags the stored series stale; pole/sign recorded; adjectives tempered).
- **Projection-yet-stored: no divergence path, no extra clause needed** (flag-stale + recompute-on-read
  is the category-correct mechanism for a projection).
- **No fresh material finding.**
- **CONVERGED** on my charter. Part B's one record-governance act — σ_prod² on the chain — is now
  classified, lineaged, and staleness-guarded correctly, and the linkage field is a governed
  declared term. A further round would produce no material improvement.

---

**Re-confirmation (post-PARK-1, pp14–15):** in-force PE-6 now runs σ_prod² as a pure on-demand projection — "computed when needed and never stored (C-4.11), monitored by recomputation over the chain's recorded Greeks, which is authoritative" — so divergence is trivially impossible (nothing stored ⇒ no second copy to drift; the staleness question is moot). PARK-1 is honest: it records the genuine C-4.11/MD-6 conflict with the exact replaced clause, exact amendment text (the "materialised projection" three conditions), and my engineering-safety rationale as justification, while the in-force text runs the conforming (never-stored) reading and nothing depends on storage. **CONVERGED-CONFIRMED.**
