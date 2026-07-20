# FORMALIS Cell Review — Market Data Manifesto 1.0

**Reviewer:** FORMALIS (in-cell rigor, drafting cell)
**Target:** `/home/renaud/Ledger/MarketData/MarketDataManifesto_1.0.tex` (v1.0, MD-1..MD-11)
**Constitution in force:** `ledger_manifesto_v1_4.tex`
**Prior art spot-checked:** `calibration_manifesto.tex`
**Duty:** every defined term well-formed; every derivation from the six commitments valid; every
constitutional citation correct; no claim that overreaches what a record-governance document can assert.

I read all four documents in full and verified every clause the draft cites against the Constitution's
own text. The draft is strong: the vocabulary map is disciplined, the corporate-action-operator term is
used only for its fixed referent, and the martingale/latent-price overreaches of the prior art are
correctly refused. The findings below are real and, in two cases, load-bearing.

---

## PART A — GATHERAL's §4 unsettled items (ruled first)

### Item 1 — Dual use of "projection" vs C-14.9 — **DEFECT (D1)**

The *resolution as a pipeline* is sound and consistent with the Constitution: a pricing model is
evaluated **outside** the fold (C-14.9); its output **re-enters as a recorded observation** (C-14.15);
downstream deterministic computation over recorded observations is a projection. MD-6 states each of
these three steps honestly and does not hide the boundary.

The **word** is not sound. The Constitution fixes "projection" as *"any view computed from the record"*
(C-3.2, C-4.8), and a projection is by definition reproducible **from the record alone** (C-1.5, C-2.2,
C-14.11). MD-6's headline — *"Every derived object is a projection of recorded inputs"* — and MD-7's
*"the posterior is a projection"* apply that fixed term to model-based calibrations. But MD-6 itself
concedes, correctly, that *"reproducing a model's own number requires the model."* An object that is
**not** reproducible from the record alone **cannot** be a projection in the Constitution's sense; the
Constitution already has a name for it — an **observation** (C-14.15). So the draft's "projection" is
doing two jobs: (i) the Constitution's *view computed from the record*, and (ii) *any deterministic
function of recorded inputs, including a model evaluation whose output re-enters as an observation.*
Job (ii) collides with the fixed vocabulary (C-Auth.4: one name per component, no synonym) and, worse,
attaches the C-2.2 **full-reproducibility guarantee** to objects that do not satisfy it. That is the §1
relabel trap running in the reproducibility direction: a model output is made to *read as* a
record-reproducible projection.

The agenda's test — *one definition covering both, or two names* — resolves cleanly against one
definition. A single broadened "projection = deterministic function of recorded inputs" **cannot** cover
both, because the broadened set contains model outputs that are not reproducible from the record alone,
which silently weakens the guarantee the word carries. **Two names is the only sound option, and the
Constitution already supplies both.**

**Fix (D1).** Reserve "projection" for the Constitution's sense: a derived object whose recipe is a
deterministic computation **over the record**, reproducible from the record alone. For a derived object
whose recipe **requires model evaluation**, say so in the Constitution's own terms: the ledger does not
run it (C-14.9), the output re-enters as a **recorded observation** (C-14.15), and its reproduction
additionally needs the retained model (governance, out of scope). Restate MD-6's headline, e.g.:
*"Every derived object is a deterministic function of recorded inputs — a projection where its recipe
computes over the record, a re-entered observation where its recipe runs a model."* Propagate to MD-7
(posterior), MD-9 ("constraints live in the projection"), Section 1 ("a posterior… is a projection"),
Abstract, Conclusion, and the worked example. This preserves GATHERAL's reproducibility discipline while
keeping "projection" and "observation" each doing one job.

### Item 2 — as-of/as-at ↔ execution/door mapping — **RESOLVED-AS-DRAFTED**

MD-4 maps *as-of* (the world-moment a value concerns) → **execution time**, *as-at* (when the record
came to hold it) → **door time**, and keeps **monitor time** as *"the further provenance that splits an
observation's lateness into the world's delay and ours."* This is the standard valid-time /
transaction-time correspondence and it is faithful to C-2.7 verbatim: *"the monitor's clock orders
nothing: it is provenance… splits into the world's delay, execution to monitor, and ours, monitor to
door."* The two honest answers of C-12.1 are correctly attached. **Monitor time is not lost** — it is
named in its correct role and excluded from the ordering key, exactly as C-2.7 requires. The 2-of-3
mapping is complete because the third time is accounted for as provenance rather than dropped. Sound.
(One wording nit in MD-4 belongs to item 3, not here.)

### Item 3 — TA-ARRIVAL / TA-EXECUTION-TIME strengthening — **one DEFECT (D5); no extension of a TA**

No article **extends** a trust assumption. MD-3 restates TA-ARRIVAL faithfully: *"that an observation
reaches the boundary at all is named as a trust assumption and reconciled against external authorities…
never a fact the fold may assume (C-4.12)"* — a restatement, not a strengthening. MD-5/MD-10 rely on
execution-time ordering exactly as C-2.7 grants it.

The one place that risks strengthening is **MD-4**: *"an execution time — the world-moment it happened,
the time a court would enforce."* C-2.7 is deliberately weaker — execution time is *"asserted by its
source, contestable only in the world and corrected only by a later event."* TA-EXECUTION-TIME (v1.4
amendment record) trusts *"asserted execution times as legally enforceable, contestable facts."* MD-4's
flat *"the world-moment it happened"* states as **fact** what the Constitution states as **asserted and
contestable**. The contestability is present elsewhere (MD-5 refold, MD-10 correction), so the manifesto
as a whole does not strengthen the TA — but MD-4's sentence, read alone, does.

**Fix (D5).** *"…an execution time — the world-moment its source asserts it happened, the time a court
would enforce, contestable only in the world and corrected only by a later event (C-2.7)…"*

### Item 4 — No-park claim — **RESOLVED-AS-DRAFTED (zero parks correct), contingent on the D1/D2 fixes**

I searched for a genuine constitutional conflict — a place where required market-data content contradicts
a clause and cannot be reconciled within it. **There is none.** Every tension the handoff records
resolves by *specialising* an existing clause, not by amending one: posterior-as-mutable-state dissolves
under C-4.11/MD-8; gating-as-rejection routes to C-13/C-4.8; "Oracle" drops under C-Auth.4; two-time vs
three-time reconciles under C-2.7; no-arb-as-record-property routes to C-13.2. The manifesto adds no
clause the Constitution lacks. GATHERAL's zero-parks conclusion is **correct**, and the empty parking
index is legitimate here because a *specialisation* is not an *amendment* — the mechanism is simply not
triggered.

**But the conclusion is contingent.** The overreaches D1 (projection) and D2 (Abstract/Conclusion
reproducibility) are the closest the draft comes to the §1 narrowing trap — they let a model output read
as a record-reproducible projection. They are **not** parks (they require no Constitution amendment; the
remedy is within-Constitution wording that invokes C-14.9/C-14.15, which already carve the boundary out).
They are, however, **mandatory** fixes, not optional polish. Zero parks stands **only after D1/D2 are
applied**; left as drafted, they are a quiet narrowing of C-2.2 by relabeling.

### Item 5 — MD-12 (dependency ordering / derived-on-derived) — **REQUIRED for completeness**

Required — and not for page count. MD-6 grounds reproducibility on exactly *"those three — the
observations it consumes, the recipe that defines it, and… a recorded seed"* and asserts *"Given those
three, any party reconstructs the object bit-for-bit."* That enumeration is **incomplete for a derived
object that consumes another derived object.** A calibration-on-curve (calibration manifesto INV-08:
*"volatility on yield curves"*) consumes a **curve**, which is neither an observation, nor the recipe
text, nor a seed. "Those three" therefore **do not determine** the composite unless the dependency —
*which* derived object, evaluated at *which* cut/version — is itself a recorded part of the recipe.
Compositionality is a first-principles obligation for a manifesto of principles (can correctness of the
whole be established from the parts?), and MD-6 leaves it implicit precisely where the prior art made it
a first-class invariant.

The pathology INV-08 guards against (a "mid-update" input) *does* dissolve in the Ledger the same way
MD-8 dissolves the broken state — there is no stored intermediate to be half-updated; both objects are
functions of the record at one cut. That dissolution is a **positive result worth stating**, not a reason
to omit the article. What must be stated:

> **MD-12 (proposed).** *A derived object may consume another derived object. When it does, the
> dependency — which object, evaluated at which cut — is part of the recorded recipe, so the composite is
> itself a deterministic function of the record: determinism and reproducibility compose. Because each
> input is recomputed from the record at the object's own cut, never read from a mutable store, the
> "mid-update input" cannot arise (MD-8); a curve feeding a calibration is consistent with that
> calibration by construction, not by scheduling. Trace: Reproducibility, Correctness; C-2.2, C-14.11.*

This also repairs D3 (the MD-6 "those three" enumeration). Add MD-12 **and** widen MD-6's enumeration to
name derived inputs. This lands the document at ~6 pages for the right reason — completeness — not padding.

---

## PART B — Full article sweep

**Abstract — DEFECT (D2).** *"every curve, surface, correlation, and calibration is a deterministic
function of recorded observations, reconstructible by any party and at any past date."* Unconditional
reconstructibility is **false for model outputs** (C-14.15) and is **internally inconsistent** with MD-6's
own concession that a model's number needs the retained model. This is the manifesto's strongest sentence
and it overreaches what a record-governance document can assert. **Fix:** *"…a deterministic function of
recorded inputs; reconstruction from recorded prices is unconditional, while reconstruction of a model's
own output additionally requires the retained model (C-14.15)."* Also (LOW): *"the six governing
commitments"* should read *"six of the Constitution's eight commitments"* — testability (C-2.5) and
clarity (C-2.6) bind the document too, as its one-name vocabulary map shows.

**Section 1 (framing) — SOUND**, inherits D1 at *"a posterior over parameters is a projection."* The
vocabulary map is exact and disciplined: Oracle→source (no oracle primitive introduced), attestation→
observation (C-4.8), event time→execution time, knowledge time→monitor+door (C-2.7), model configuration→
recorded versioned terms (C-4.4, C-7.2). "The market data operator" is correctly quarantined to the C-9.2
corporate-action transform. Citations C-5.4, C-4.8, C-9.2 all verified correct.

**MD-1 — SOUND.** C-1.4, C-4.8 verified. "Recorded exactly once… every price computed from it, never
stored beside it" is the C-1.4/C-1.5 no-second-copy discipline, correctly specialised.

**MD-2 — DEFECT (D4, citation/grounding).** The principle (capture, then classify by a later projection)
is right, but its grounding is misplaced. A *stale / fat-fingered / off-consensus* quote is **well-formed
and processable**; it enters through the normal door as an observation-recording transaction (**C-4.8**),
and judgement is deferred because **economic correctness is not gated at admission — it is detected after
the fact (C-13.2, C-13.3)**. C-4.12 is the **quarantine path for *unprocessable* arrivals** (undeclared
kind, unresolvable reference, failed payload); it applies only to the "corrupted" sub-case, not to a valid
stale quote. As drafted, MD-2 leans the whole principle on C-4.12 and never cites C-13, which is its actual
ground. **Fix:** add C-13.2/C-13.3 to body and trace as the deferral ground; keep C-4.8 as the recording
ground; restrict C-4.12 to the corrupted/unprocessable case.

**MD-3 — SOUND** (LOW note). C-5.4, C-4.12 verified; TA-ARRIVAL restated, not extended. Minor: *"machinery
outside the trust boundary (C-5.8)"* — C-5.8 fixes the trust levels of the three internal **machines**; an
exchange/broker sits beyond even those. The cleaner grounds for the external source's untrustedness are the
C-5.1 trust-boundary picture ("external events" outside the dotted line) and C-4.12. Cite C-5.1 alongside
C-5.8.

**MD-4 — DEFECT (D5)**, see item 3. Otherwise the three-times/bitemporal content is sound (item 2). C-2.7,
C-12.1 verified.

**MD-5 — SOUND.** C-2.7 (execution-ordered fold, tail refold), C-12.6 (refold never silent, named explain
item) verified verbatim against the covered-call clause. "As-known view survives unrewritten beside the
corrected one" is exact.

**MD-6 — DEFECT (D1 headline; D3 enumeration).** See items 1 and 5. Clause citations themselves are all
correct: C-2.2, C-14.9 (verbatim), C-14.11, C-14.15, C-4.4, C-7.2. The recipe-as-recorded-term analogy
("held the way a unit holds its terms") is apt. The defects are the overloaded term and the incomplete
input enumeration, not a false citation.

**MD-7 — DEFECT (D1, inherited).** Substantively strong and important: it correctly **refuses** to assert
the martingale — *"a random walk, a martingale, a mean reversion are modelling choices a recipe may
declare, never axioms the framework asserts"* — which is exactly the no-overreach discipline (C-6
resolution). "Today's posterior is tomorrow's prior names a fold, not a mutable variable" is the right
dissolution of the prior art's mutable-state framing (C-4.11, C-2.8 verified). Only *"the posterior is a
projection"* needs the D1 split (a filter is model evaluation → observation).

**MD-8 — DEFECT (D6, precision) + LOW citation.** The core dissolution (no stored θ_sys ⇒ θ_sys ≠ θ*
unrepresentable) is **valid** and well-aimed. But *"the surface for one index and the surface for another
are two reads of one record, each a function of **exactly the observations recorded for it**"* silently
assumes **per-index separability** and thereby dodges the case the calibration example was built on — a
**joint** SPX/SX5E model, which MD-7 explicitly permits. Under a joint recipe, SX5E's surface is a function
of SPX's observations too (via the correlation), and on-demand recomputation yields the **correct joint
conditional expectation** — a *stronger* no-broken-state result, not a lost one. **Fix:** *"each a function
of the observations its recipe consumes — for a joint recipe, of both legs' observations, so an on-demand
read is the correct joint conditional expectation and no divergence can be stored."* LOW: cite **C-11.5**
(*"what cannot be represented cannot break,"* which MD-8 quotes) rather than the bare section "C-11."

**MD-9 — SOUND** (LOW note). C-13.2, C-Scope.11 verified. Correctly routes constraint-satisfaction to
economic correctness (recorded diagnostic, detected not prevented — C-13.3), consistent with the record
holding mutually inconsistent observations. LOW: *"non-negotiable"* reads briefly like an admission-time
prevention guarantee; the article's own gloss (*"the claim and its test are both on the record"*) keeps it
honest — consider softening to avoid the misread. Inherits the D1 term ("live in the projection").

**MD-10 — SOUND.** C-9.2, C-9.3 (operator intrinsic to the data/event pairing, originals never overwritten,
adjusted computed at each read), C-12.4 (repair forward, authorised compensating transaction) all verified
verbatim. "The market data operator" used only for its fixed C-9.2 referent — clean.

**MD-11 — SOUND.** C-2.8 near-verbatim (initial state + fold; seed the single non-record input, recorded so
every path replays; production the one real path), C-10.1 (same machine, virtual ledger) verified. No
C-14.9 issue: generated observations are inputs, not fold-run model outputs.

**Worked example (Section 3) — SOUND** (two LOW notes). Consistent with MD-1/3/4/5/6/8/10/11. (i) It names
only two of the three times (execution, door); since MD-4 stresses *three*, name monitor time as the
provenance for completeness. (ii) The Thursday restatement is described in reordering language (*"its
execution time places it back among Tuesday's data"*), but original and restatement share Tuesday's
execution time and separate only by door-time tie-break — it is an MD-10 **correction** (C-12.4), not an
MD-5 **late-arrival reorder** (C-2.7). Both yield a refold + explain item, so the outcome is right; the
causal wording lightly conflates the two mechanisms.

**Conclusion — DEFECT (D1, D2).** *"every curve, surface, and calibration is a deterministic projection of
observations"* repeats both the overloaded term and the unconditional-reproducibility overreach. Apply the
D1/D2 fixes.

---

## PART C — Citation audit summary

Every clause the draft cites **exists** and is quoted or paraphrased **correctly** — no fabricated or
mis-numbered citation anywhere. C-2.7 is cited three times (Section 1, MD-4, MD-5), each correct. C-2.8,
C-9.2, C-9.3, C-12.4, C-12.6, C-14.9, C-14.15, C-Scope.11 all verified against source text. The only
citation defects are two **grounding/precision** issues, not wrong references:
- **MD-2:** C-4.12 over-applied; the actual ground (C-13.2/C-13.3) is uncited. (D4)
- **MD-3:** C-5.8 (internal machines' trust levels) stretched to cover an external source; add C-5.1. (LOW)

Extraction fidelity from `calibration_manifesto.tex` spot-checked and confirmed: A1 latent price and A5
martingale correctly **refused as framework axioms**; A7 → MD-2; A3 → MD-9; A4 "certification" recast as a
**recorded diagnostic** (dissolving the prior art's stored "fall back to last certified," a stored-state
pattern MD-8 forbids); Oracle dropped. INV-08 is the one extraction deferred — and it is exactly the MD-12
gap (item 5).

---

## PART D — Defect register (severities per FORMALIS classification)

| # | Sev | Locus | Property violated | Fix |
|---|-----|-------|-------------------|-----|
| D1 | HIGH | MD-6, MD-7, MD-9, §1, Abstract, Conclusion, example | C-Auth.4 fixed vocabulary; C-2.2 guarantee attached to non-reproducible objects | Reserve "projection" for record-computed views; call model outputs "observations" (C-14.15) |
| D2 | HIGH | Abstract, Conclusion | Overreach: unconditional reconstructibility false for model outputs (C-14.15); internally inconsistent with MD-6 | Qualify: record-alone reconstruction unconditional; model output needs retained model |
| D3 | HIGH | MD-6 | Reproducibility under-determined for derived-on-derived; compositionality not established | Widen enumeration to include derived inputs (each pinned to recipe + cut); add MD-12 |
| D4 | MED | MD-2 | Grounding: C-4.12 (quarantine) mis-applied; C-13.2/C-13.3 (deferred economic judgement) uncited | Add C-13.2/C-13.3; keep C-4.8; restrict C-4.12 to corrupted case |
| D5 | MED | MD-4 | Execution time stated as fact, not asserted/contestable (C-2.7); reads as strengthening TA-EXECUTION-TIME | Insert "asserted by its source, contestable only in the world" |
| D6 | MED | MD-8 | Joint-recipe case dodged; dissolution understated | Restate for joint recipes (on-demand read = correct joint conditional expectation) |

LOW (not counted): §1/Abstract "six" vs eight commitments; MD-3 add C-5.1; MD-8 cite C-11.5; MD-9
"non-negotiable" wording; worked example monitor-time omission and MD-5/MD-10 conflation.

**6 distinct defects across 7 loci. MD-12 REQUIRED.**

---

## OVERALL VERDICT — **RETURN FOR REVISION (defects fixable in-cell; no re-architecture)**

The manifesto's architecture is right: eleven articles, each genuinely derived from the commitments and
resting on a correctly cited clause; the prior art's two illegitimate axioms are correctly refused; the
fixed vocabulary is respected everywhere **except** the one overloaded term. All six defects are
wording/grounding/completeness repairs within the existing structure — **none requires a Constitution
amendment, and none requires a park.** The two HIGH defects (D1, D2) are mandatory because, left as
drafted, they let a model output read as a record-reproducible projection — the §1 narrowing trap in the
reproducibility direction. Fix D1–D6 and add MD-12, and the document is sound, complete, and ready for
KLEPPMANN/TALEB. I do not sign it as drafted; I will sign the revision that carries these fixes.
