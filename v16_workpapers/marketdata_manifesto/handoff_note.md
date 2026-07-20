# Market Data Manifesto 1.0 — Handoff Note

**From:** GATHERAL (drafting lead)
**To:** FORMALIS (rigor-check, next), then KLEPPMANN + TALEB (review), CONCORDIA (certify last)
**Deliverable:** `/home/renaud/Ledger/MarketData/MarketDataManifesto_1.0.tex` (+ `.pdf`)
**Status:** revision 3 — carries FORMALIS D1–D6 (`formalis_cell_review.md`), Review Round 1
(KLEPPMANN M1/M2 + m1/m2 `kleppmann_r1.md`; TALEB M1–M6 + minors `taleb_r1.md`), and Review
Round 2 (KLEPPMANN F1 + m1'/m2' `kleppmann_r2.md`; TALEB F1 + F2 `taleb_r2.md`). Both round-2
reviewers reported all round-1 findings RESOLVED and stated convergence once the fresh items are
fixed. Compiles clean (pdflatex ×2, exit 0), 7 pages, 12 articles (MD-1…MD-12), no over/underfull
boxes, no undefined refs.

**Rev-3 fixes (Review Round 2 — five surgical clauses, no re-architecture):**
- **KLEPPMANN F1** (failure-as-fact re-merged the split): MD-6's failed-derivation clause now
  carries the split — a **projection** failure (bootstrap with too few quotes) is itself a
  projection, legible by recomputation, **never stored**, and non-monotone (a late arrival can
  flip it to success, MD-5); only a **model-run** failure re-enters as a stored observation with
  diagnostics + lineage; the MD-2 analogy is narrowed to the **input side** (a failed capture is
  an arrival, not a derivation). This closes the last stored-derived-state-drift regression.
- **TALEB F1** (exactly-once rests on correct grain; over-coarse grain = silent loss): MD-1 gives
  identifier-grain the TA-ARRIVAL honest-assumption treatment — names grain-correctness as a
  trust assumption, distinguishes the *loud* double-count (too fine) from the *silent* loss (too
  coarse, and feeds with no distinguishing field where no grain exists), and states it is caught
  at the perimeter by reconciling arrival counts against recorded observations.
- **KLEPPMANN m1'** (absorption trace): MD-1 — an absorbed redelivery records no new value but
  retains its arrival provenance + monitor time, so a healthy absorb is distinguishable from a
  dead feed.
- **KLEPPMANN m2'** (canonical read path): MD-8 — a consumer reads a re-entered observation
  through a projection ("the current fit for X", carrying the staleness flag), never the raw
  stored value, so staleness is caught at read, not merely auditable.
- **TALEB F2** (gloss): "cause-derived identifier" glossed in plain words at first use (§1).

**Rev-2 blocks (Review Round 1):** BLOCK 1 (the seam) — the projection / re-entered-observation
split is now honoured through the whole cascade: MD-5/MD-8/MD-10/MD-12 restrict "recomputes /
refolds" to **projections**; a re-entered observation is frozen (C-14.9), read back always,
re-derived only with the retained model + numerical environment; the calibration manifesto's
**INV-05** (complete lineage) and **INV-07** (staleness signal) are restored as principles (MD-6,
MD-8, MD-10); MD-8 retitled "A broken state cannot hide" (unrepresentable for projections;
detectable-not-silent for model outputs). BLOCK 2 (mechanics) — MD-1 states the **absorption**
discipline (redelivery absorbed / correction / new print, C-2.7/C-12.3/C-14.3); MD-6 records a
**failed derivation** as a fact; §1 assembles **data-kind registration**. BLOCK 3 (practitioner)
— fold/home/cut glossed at first use; capture-everything given its honest capacity boundary
(TA-ARRIVAL); the worked example carries one number (AAPL 150.20 → 150.50) showing
as-published-then vs as-recomputed-now with the selecting cut, plus a late-arrival walk.

**Rev-2 blocks (Review Round 1):** BLOCK 1 (the seam) — the projection / re-entered-observation
split is now honoured through the whole cascade: MD-5/MD-8/MD-10/MD-12 restrict "recomputes /
refolds" to **projections**; a re-entered observation is frozen (C-14.9), read back always,
re-derived only with the retained model + numerical environment; the calibration manifesto's
**INV-05** (complete lineage) and **INV-07** (staleness signal) are restored as principles (MD-6,
MD-8, MD-10); MD-8 retitled "A broken state cannot hide" (unrepresentable for projections;
detectable-not-silent for model outputs). BLOCK 2 (mechanics) — MD-1 states the **absorption**
discipline (redelivery absorbed / correction / new print, C-2.7/C-12.3/C-14.3); MD-6 records a
**failed derivation** as a fact; §1 assembles **data-kind registration**. BLOCK 3 (practitioner)
— fold/home/cut glossed at first use; capture-everything given its honest capacity boundary
(TA-ARRIVAL); the worked example carries one number (AAPL 150.20 → 150.50) showing
as-published-then vs as-recomputed-now with the selecting cut, plus a late-arrival walk.

The document states 12 numbered articles (MD-1 … MD-12), each derived from six of the eight
governing commitments and resting on a named Constitution clause. Sources read in full:
`calibration_manifesto.tex` (prior art), `ledger_manifesto_v1_4.tex` (Constitution in force),
`README.md`. Below: (1) every extraction, (2) every conflict + resolution, (3) exclusions,
(4) items left for FORMALIS.

---

## 1. Extractions — which calibration-manifesto element became which article

| Calibration source | Principle kept | Where it landed |
|---|---|---|
| **A1** (observations are noisy samples; latent true price `p_i`) | Observations are recorded facts attributed to a source, **not** truth; any "true price" is a modelling posit that lives in a model. | Section 1 (opening) + **MD-1**. The metaphysical latent-price claim is dropped (see Conflict C-6). |
| **A2** (finite-dimensional parameter space + pricing map) | A derived object is a deterministic function of recorded inputs — a **projection** where its recipe computes over the record, a **re-entered observation** (C-14.15) where it runs a model. | **MD-6**. The modelling commitment itself (that instruments *are* finite-dim) is excluded as model choice. |
| **A3** (arbitrage-free + smooth; admissible region Θ_AF) | No-arbitrage / smoothness is **constraint discipline that lives in the derived object**, declared and recorded, with satisfaction as a recorded diagnostic. | **MD-9**. Specific conditions (SVI/SSVI/discount monotonicity/put-call parity) excluded — model choice, out of scope. |
| **A4** (price-space primacy; WRMSE; certification) | Certification is a **recorded classification** carried with the derived object (accept / diagnostic), not a gate that refuses to record. Quality is a recorded diagnostic. | **MD-2** (capture-then-classify) + **MD-9** (diagnostics recorded). WRMSE/tolerances/thresholds excluded as methodology. |
| **A5** (posterior mean is a martingale) | Only the **governance residue** survives: a derived object changes only when the record changes; any dynamics (incl. martingale) is a *declared recorded term*, never a framework axiom. | **MD-7**. The martingale assertion itself is **not** made (see Conflict C-1 / C-6). |
| **A6** (reproducible, auditable, traceable) | Direct, strongest extraction: reproducibility = deterministic function of recorded inputs (observations + recipe + seed); provenance chain. | **MD-6**, and threads MD-1, MD-3, MD-11. |
| **A7** (attestations can be wrong) | Direct: observations can be wrong; the record captures them anyway; accept/down-weight/reject is a derived object's classification, never a refusal to record. | **MD-2**. |
| Observation / attestation **framing** | An "attestation from an Oracle" = an **observation** recorded by an **observation-recording transaction** (C-4.8). | Section 1 vocabulary map + **MD-1**, **MD-3**. |
| **Knowledge vs event time** | Mapped onto the Constitution's three times (see Conflict C-4). | **MD-4**. |
| **MCA** (Model Configuration Attestation) | The recorded, versioned **terms** of a derived object — held the way a unit holds its terms (C-4.4, C-7.2). Not adopted as a named primitive. | **MD-6**, **MD-7**. |
| **Broken states** (θ_sys ≠ θ*; spread-option / async example) | **Refined (rev 2):** for a *projection*, unrepresentable (nothing stored). For a *re-entered observation* (a model run — which the flagship joint vol+corr fit is), the value **is** stored, but cannot drift in place (a new fit is a new observation, forward) and cannot fall stale silently (staleness is a flagged open item). The pathology is defeated as *cannot-hide*, not *cannot-exist*. | **MD-8** (retitled "A broken state cannot hide"). |
| No-arb-as-constraint-discipline | Constraints belong to the derived object, not the record; the record may hold mutually inconsistent observations. | **MD-9**. |
| **INV-08** (calibration-on-derived, e.g. volatility on yield curves) | Determinism and reproducibility **compose**: a derived object consumed by a further derivation enters it as recorded input, pinned to version + cut; the "mid-update input" cannot arise (MD-8). | **MD-12** (added in rev 1 on FORMALIS item 5). |
| **INV-05** (complete provenance chain back to *all* inputs + the MCA) | Restored in full (rev 2, KLEPPMANN M1a): a derived object carries a **complete lineage** — resolved input cut (every observation + derived object, each pinned to version and cut) and, for a model output, the model version — reaching to the leaf observations. "Sufficient provenance to reproduce" (C-14.15) is weaker than "enough to know when an input changed under me"; the strong form is what detects staleness. | **MD-6** (lineage), feeding **MD-8**/**MD-10** (staleness). |
| **INV-07** (staleness signalled when an object *or its inputs* age/change) | Restored (rev 2, KLEPPMANN M1b): a re-entered observation cannot auto-recompute (C-14.9), so when an input in its recorded cut is corrected or superseded, its staleness is a **recorded, flagged open item** awaiting re-derivation; supersession is a new fit, forward, never an edit. | **MD-8**, **MD-10**, **MD-5**. |
| **Absorption / idempotence** (implicit in A-machinery; INV-06 grain) | "Exactly once" is a mechanism, not a claim: redelivery identical under the cause-derived identifier is absorbed (its arrival provenance retained, so absorb ≠ dead feed); a correction is a distinct later observation; a new print is a new observation. Identifier **grain** is a registered property of the data kind — and grain-correctness is itself a **trust assumption** (rev 3, TALEB F1): over-coarse grain is the residual *silent*-loss case, caught at the perimeter by arrival-count reconciliation. | **MD-1** (C-2.7/C-12.3/C-14.3, TA-ARRIVAL), §1 (registration). |
| **A6 numerical environment** (INV-04: "code version and numerical environment … up to declared tolerance") | Re-deriving a model output needs the retained model **and** the numerical environment it ran in; a re-entered observation is a **leaf** for reconstruction (read-back), not a reconstructible node. | **MD-6**, **MD-12**. |
| **Failure-is-a-fact** (A7/INV ethos applied one level up) | A failed derivation is not an absence — but its treatment **follows the split** (rev 3, KLEPPMANN F1): a *projection* failure is legible by recomputation and **never stored** (non-monotone — a late arrival can flip it to success); only a *model-run* failure re-enters as a stored observation with diagnostics + lineage. A failed *capture* is stored as an input-side arrival, not an output-side derivation. | **MD-6** (TALEB M5, KLEPPMANN F1). |

The six governing commitments are cited by name in every article's traceability tag and map
one-to-one onto Constitution commitments C-2.1 (auditability), C-2.2 (reproducibility),
C-2.3 (time travel), C-2.4 (correctness), C-2.7 (order), C-2.8 (simulability).

---

## 2. Conflicts with Ledger principles + resolutions

Each recorded here, never absorbed silently. The Constitution prevails in every case.

**C-1. Posterior-as-mutable-state vs fold determinism.**
Calibration treats the posterior `P_n` as evolving state updated in place ("the posterior at
epoch n is the prior at epoch n+1"; broken states = θ_sys ≠ θ*). The Constitution has no
mutable state — everything is a fold of the immutable log (C-2.8, C-4.11 "computed when needed
and never stored"). *Resolution:* the posterior is a **derived object** — a deterministic
function of (prior-as-declared-term, recorded observations, recorded seed), recomputed from the
record, never stored beside it. Per the D1 split (below), it is a *projection* when its recipe
computes over the record and a *re-entered observation* (C-14.15) when a filter/sampler runs a
model; either way it is not mutable state. "Today's posterior is tomorrow's prior" names a
recomputation, not a variable. → **MD-7**, and the pathology dissolves in **MD-8**.

**C-2. Gating-as-rejection vs capture-then-classify.**
Calibration A7 / INV-06 phrase rejection as "not used to update the posterior," which risks
reading as *discarded*. Constitution C-4.12 guarantees capture: every arrival is recorded,
never lost. *Resolution:* gating never refuses to record. The observation is recorded once
(C-4.8); accept / down-weight / reject is a **derived object's classification** of a recorded
observation, itself recorded/recomputable, reversible by a later derivation. Deferral of
economic judgement to after-the-fact recomputation is grounded in C-13.2/C-13.3 (D4 fix);
C-4.12 quarantine covers only the *unprocessable* sub-case. "Rejected" = zero weight, not
absent. → **MD-2**.

**C-3. Oracle vocabulary vs the market data operator / observation.**
Calibration's "Oracle" is a *source of market truth*. The Constitution's "market data
operator" is a *different thing* — the corporate-action transform (C-9.2), NOT a source —
and its vocabulary is fixed (C-Auth.4). *Resolution:* drop "oracle"; the framework has **no
oracle primitive** and introduces none. A source is external machinery outside the trust
boundary whose delivery is a trust assumption (C-4.12, C-5.8); its attestation becomes a
recorded observation. "The market data operator" is used **only** for the corporate-action
transform, never for a source. → Section 1 vocabulary map, **MD-3**, **MD-10**.

**C-4. Two-time model vs the Constitution's three times.**
Calibration distinguishes event time / knowledge time, and states "calibration updates follow
knowledge-time order, not event-time order." The Constitution has **three** times
(execution / monitor / door, C-2.7) and says the *authoritative fold* is **execution**-ordered,
with tail refold on late arrival (C-2.7) — the opposite ordering for the corrected view.
*Resolution:* event time = execution time (as-of); knowledge time splits into monitor time +
door time (as-at). Calibration's "knowledge-time order" describes only the **as-known** view;
the Constitution additionally guarantees the execution-ordered corrected view, and the two are
the two honest answers of C-12.1. → **MD-4**, **MD-5**.

**C-5. No-arbitrage as a record property vs a derived-object property.**
Calibration A3 places arbitrage-freedom on the parameter set generally. In the Ledger the
record may hold mutually inconsistent observations (a stale and a fresh quote may cross); it
must, since capture precedes judgement (C-2). *Resolution:* no-arbitrage is a constraint the
**derived object** imposes on its **output**, declared in its recipe and recorded as a
diagnostic — not a property the record is required to have. → **MD-9**.

**C-6. Modelling claims a record-governance document cannot assert (A5 martingale; A1 latent
true price).**
A5 asserts `E[θ_{n+1} | I_n] = θ_n`; A1 asserts a latent true price exists. Both are claims
about *models / the world*, not about *records*. A governance document for a system of record
has no standing to assert either. *Resolution:* neither is asserted as a framework axiom. The
martingale (and any dynamics) is admissible **only** as a declared, recorded prior-term
(MD-7); the "true price" is admissible **only** as a modelling posit inside a projection's
noise model (Section 1, MD-1). The framework mandates recording and reproducibility, not
dynamics or ontology. → **MD-7**, **MD-9**, Section 1.

**C-7. "Calibration is a projection" vs "the ledger never runs models" (C-14.9).**
The owner's mission frames calibration as "a deterministic projection," but C-14.9 says the
ledger **records model outputs and never runs a model**, and C-14.15 re-admits model outputs
as observations with provenance. *Rev-0 resolution (broadened "projection") was REJECTED by
FORMALIS (D1):* a single broadened "projection = deterministic function of recorded inputs"
silently attaches the C-2.2 full-reproducibility guarantee to model outputs that are **not**
reproducible from the record alone — the §1 relabel trap in the reproducibility direction, and
a collision with the fixed vocabulary (C-Auth.4). *Rev-1 resolution — the two-name split, both
names already in the Constitution:* a derived object is a deterministic function of recorded
inputs of **two** kinds — a **projection** when its recipe computes over the record
(reproducible from the record alone, C-3.2/C-14.11), and a **re-entered observation** when its
recipe runs a model (ledger does not run it, C-14.9; output re-enters as an observation with
provenance, C-14.15; reproduction additionally needs the retained model, governance/out of
scope). "Projection" is thereby reserved for its fixed C-3.2/C-4.8 referent, and no object
carries a reproducibility guarantee it cannot meet. Applied across MD-6, MD-7, MD-8, MD-9,
Section 1, Abstract, Conclusion, and the worked example. → resolves §4 item 1.

None of these required parking a constitutional conflict: every resolution lives **within**
the Constitution. The manifesto adds no clause the Constitution lacks; it specialises existing
clauses to market data.

---

## 3. Principled content deliberately excluded

| Excluded | Why |
|---|---|
| State-space / Kalman / particle-filter machinery (§"linear-Gaussian", §robustness) | A filter is model evaluation → a re-entered observation (C-14.9/C-14.15), not a projection; and the specific filter is model choice. Principle kept as MD-6/MD-7. |
| Specific no-arb conditions: SVI/SSVI sufficient conditions, discount monotonicity, put-call parity, FX triangular, div/repo bounds | Model machinery; correctness of a *chosen* condition is out of scope (C-Scope.11). Principle kept as MD-9. |
| Innovation gating algorithm: Mahalanobis `D²`, χ² thresholds, z-scores | Implementation of the classification of MD-2; not a record-governance principle. |
| WRMSE, per-instrument/aggregate tolerances, certification thresholds, failure/fallback protocol | Calibration methodology; principle "diagnostics recorded with the object" kept as MD-9. |
| Reference-products list + smoothness/ratio monitoring (whole §"Reference Products") | Operational monitoring practice, not record governance; would also breach the page budget. Reproducibility of any such reference product already follows from MD-6. |
| Structural-break detection, forgetting, process-noise tuning | Model dynamics; admissible only as declared terms (MD-7), mechanics excluded. |
| "MCA" as a named primitive | Renamed to "the recorded, versioned terms of a derived object" (C-4.4, C-7.2); introducing "MCA" would violate one-name-per-component (C-2.6, C-Auth.4). |
| INV-01…INV-10 as a separate catalogue | The *substance* is folded into the articles, not a parallel list. **Correction (rev 2):** rev-1 over-claimed here — KLEPPMANN M1 showed **INV-05** (complete lineage) and **INV-07** (staleness) were *weakened/dropped* for the re-entered-observation class, exactly where they are still needed. Both are now restored as principles (see §1 table). The remaining INVs (01/02/03/04/06/08/09/10) are genuinely carried by MD-1/6/9/12 and the two-name split; no separate catalogue is introduced. |

---

## 4. Rev-0 items — now resolved (was: left for FORMALIS)

All five rev-0 items are now **resolved** by FORMALIS's ruling and the rev-1 fixes; recorded
here for the trail, with nothing left open for FORMALIS on these points.

1. **Dual use of "projection"** (item 1 / Conflict C-7). **RESOLVED (D1).** FORMALIS ruled the
   broadened reading a defect; rev-1 adopts the two-name split (projection = record-computed
   view; model output = re-entered observation, C-14.15), applied across MD-6/7/8/9, Section 1,
   Abstract, Conclusion, worked example. No object now carries a reproducibility guarantee it
   cannot meet.
2. **Page count** (item 2). **RESOLVED.** Now 6 pages — the growth is **MD-12** (derivation
   composes), added for completeness on FORMALIS item 5, not padding. Within the 6–7 target,
   8 cap.
3. **As-of / as-at ↔ execution / door mapping** (item 3). **RESOLVED-AS-DRAFTED** by FORMALIS
   (item 2 of its Part A): the 2-of-3 mapping is faithful to C-2.7 verbatim, monitor time kept
   in its provenance role. One wording nit folded in as **D5** (MD-4 now states execution time
   as *asserted and contestable*, not bare fact).
4. **TA-ARRIVAL / TA-EXECUTION-TIME** (item 4). **RESOLVED.** FORMALIS confirmed no article
   *extends* a trust assumption; the only risk (MD-4 reading execution time as fact) is fixed by
   D5. MD-3 restates TA-ARRIVAL, MD-5/MD-10 rely on execution-time ordering exactly as C-2.7
   grants it.
5. **No parked constitutional conflict** (item 5). **RESOLVED — zero parks confirmed correct**
   by FORMALIS (Part A item 4), contingent on D1/D2 — both now applied. Every calibration/Ledger
   tension resolves by *specialising* an existing clause, not amending one; a specialisation is
   not an amendment, so the empty parking index is legitimate, not an unexercised mechanism.

**Open for KLEPPMANN + TALEB (next reviewers), nothing blocking:** none of the six defects
required re-architecture; the eleven-then-twelve-article structure stands. Rev-1 carries D1–D6
+ MD-12 + all LOW notes (six/eight commitments; MD-3 C-5.1; MD-8 C-11.5; MD-9 "non-negotiable"
softened to detection-not-prevention; worked-example monitor time + MD-5/MD-10 conflation). No
new conflict surfaced; no new park.
