# FORMALIS — Rigor Review of the Market Data Dynamics Amendment (MDM 1.3, MD-16)

Target: `MarketData/MarketDataManifesto_1.3.tex` — new MD-16 (after MD-11) + one MD-11
sentence + a 1.3 amendment record. Inputs: `memo_jacobi_distributions.md`,
`drafting_note_dyn.md`. Method: gate formalism re-derived; H1-H4 mapped against JACOBI;
corpus Θ_AF citation checked at source; C-4.11 storage line ruled against the PARK-1
precedent I set; 1.2 byte-stability verified by git.

**Byte-stability:** `git diff --stat` on `MarketDataManifesto_1.2.tex` is empty (unmodified
vs HEAD); 1.3 is a new untracked file. **1.2 is byte-stable — confirmed.**
**Corpus:** Vol I §2.6 exists as "The No-Arbitrage Admissibility Ladder" (`\label{sec:no-arb}`,
`\label{def:admissible}`, `𝒜` open) — the Θ_AF / admissibility-ladder citation grounds.

---

## (1) DYNAMIC-AS-OPERATOR — well-defined, BUT a reserved-name collision — DEFECT

**Well-formed as an object.** A dynamic is "declared, versioned, and attributable,
recorded like any derived object's recipe (MD-6)" — the three well-definedness
properties are stated. The family stratification is clean and cross-referenced, not
restated: dynamic = the member acting on a single datum, `𝒟` = on a whole surface, shift
= on a path; the VM-5 ≡ `𝒟` bridge is "stated once there and not restated here." Good.

**DEFECT (naming, MEDIUM) — the term "operator" is overloaded.** MD-16 calls the family
"one **operator** family," and twice calls the dynamic an operator: "a declared
**operator** built it" (Gate reconciliation) and "the **operator** applied" (Coherence,
lineage). But the MDM reserves "operator" for **the market data operator** — the
corporate-action frame transform (C-9.2, used as bare "operator" ~35× in MD-13). So
within one document "operator" now names two distinct components (the CA transform and
the dynamic/shift/𝒟 family), violating CLAUDE.md §1's non-negotiable "one component per
name, no synonym," and contradicting the Part A discipline that a shift is "never
'operator'." It produces a **concrete ambiguity**: in "a derived state carries full
lineage — the base coordinates it branched from and the **operator applied**," a span
that also crosses a corporate action has *two* operators (the dynamic and MD-13's market
data operator), and the reader cannot tell which is meant.

**Fix (naming only, no rigor change):** reserve "operator" for the market data operator;
rename the MD-16 uses. Genus "operator family" → e.g. "one family of declared **world-maps**"
(a datum's dynamic, a surface's `𝒟`, a path's shift); "a declared operator built it" → "a
declared **dynamic** built it"; "the operator applied" → "the **dynamic** applied." Three
edits.

## (2) GATE 1 — prevention "by construction" — SOUND, and grounds A5 without circularity

**Formally grounded as an existence condition, not a post-hoc test.** "The derived state
exists only if it lies in the arbitrage-free set, `m* ∈ Θ_AF`." This is an existence
condition on the *constructed* object — JACOBI's `m* ∈ Θ_AF` by construction — so "an
arbitrageable derived state is not produced, so no consumer ever meets one: prevention,
not detection." **Whose obligation / the boundary:** the gates are "decided at application
time," a failing image is "not produced" / "a broken state, forbidden by construction,"
and the refusal is recorded — the gate decision is "pass **or fail** … the recorded
outcome of that event." So a dynamic whose image leaves `Θ_AF` is refused, at
construction, and the refusal is captured. Sound.

**Grounds VM PE-1(A5) without circularity — direction verified.** "What VM PE-1(A5)
assumes, `Σ(·;S) ∈ 𝒜`, this gate guarantees at application." Direction: the child VM
*assumes* the hypothesis; the parent MDM *discharges* it. No circularity: Gate 1 rests on
the corpus `Θ_AF` (Vol I §2.6) and the decidable-predicate-on-a-projection argument —
none of which depends on any A5-conditioned VM result. And `Θ_AF` (full-state
arbitrage-freeness) entails the surface component in `𝒜`, so the guarantee is valid. The
reconciliation with MD-9 is stated: prevention where admissibility is a decidable
projection; detection "stands only where no-arbitrage cannot be tested without running a
model." Sound.

## (3) GATE 2 — H1-H4, decidability, realistic/conservative, joint — SOUND

**H1-H4 map 1-1 to JACOBI (GATHERAL's flag) — CONFIRMED.** MD-16's four conditions ↔
JACOBI's memo §5: (1) declared as-known history exists **and is sufficient** ↔ H1 (plus
THORP's sufficiency refinement folded in); (2) every functional computable from `m*` ↔ H2;
(3) conventions declared and recorded ↔ H3; (4) each historical state read at its own cut
↔ H4. One-to-one.

**Decidable-predicate footing follows from H1-H4.** Under H1 (finite, nonempty, sufficient
`H`), H2 (`v = Φ(m*)` exists), H3 (`𝔓, A` declared), H4 (`H` as-known/clean), the
predicate "`P(v; H, 𝔓) ∈ A`" is a finite deterministic computation plus a region
membership — decidable. Correct.

**Thin-history undecidability — typed as hypothesis-failure, not gate-pass — CORRECT.** When
H1's sufficiency fails, "Gate 2 then reports realism **undecidable**, a thin history being
a hypothesis failure honestly flagged, never silently waved through." This is the right
three-valued outcome (pass / fail / undecidable-because-a-decidability-hypothesis-failed);
critically it is **not** typed as a pass ("never silently waved through"). Rigorous.

**Realistic vs conservative — acceptance-region structure, no numeric threshold — SWEPT
CLEAN.** "Conservative … strictly smaller than the realistic one — tighter or one-sided."
Numeric sweep of MD-16 returns only cross-reference identifiers (MD-n / C-x.y / Vol I §);
**no percentile number, tolerance, or threshold is a manifesto constant** — every number
is a declared, versioned term. Matches JACOBI §3.

**Joint realism — valid as printed.** Marginals-insufficient argument: each coordinate can
sit in its own band while the vector lies in an empty region of the cloud (dependence is
discarded). The inverted-forward-variance counterexample — near FV above far, each leg
individually common but the inversion "essentially never co-occurred: both margins
central, the joint configuration unprecedented; the marginal gates pass it, the joint gate
does not" — is correct and matches JACOBI §4. "Depth against the joint cloud" = JACOBI's
`𝔓_joint`. Sound.

## (4) MD-9 BOUNDARY — prevention vs detection as DISJOINT DOMAINS — SOUND, no narrowing

The split is principled, riding the MD-6 projection/observation line, and MD-16 states it:
- **Detection (MD-9):** received observations (real, always captured — MD-2 — "however
  implausible"), and black-box fits where "no-arbitrage cannot be tested without running a
  model." A fitted surface is a re-entered observation (model run); MD-9 detects.
- **Prevention (MD-16):** a *constructed* derived state via a *declared* operator, whose
  "admissibility is a decidable predicate on a projection over the record (MD-6)." A
  declared-operator construction is a projection; MD-16 prevents.

These are disjoint: a received observation is never a declared-operator construction; a
model-dependent admissibility test is never a decidable projection. **No narrowing of
MD-9** — its "detection, not admission" was premised on no-arbitrage being untestable at a
door for a *fitted* object, and MD-16 explicitly leaves that standing ("MD-9's
detection-not-admission stands only where no-arbitrage cannot be tested without running a
model"); Gate 1 is prevention *at construction*, not door-prevention of a received
observation. **No narrowing of MD-2** — "a real observation, however implausible, is
always captured (MD-2)." The disjointness is sound; I find no conflict to park.

## (5) STORAGE THREADING — gate decision vs C-4.11 — RULING: SOUND

C-4.11's exact text: "Anything computable from the coordinates is a projection, computed
when needed and never stored." The gate decision **is** computable (the percentile of
`Φ(m*)` against `H` is arithmetic over the record), which is exactly why this needs a
ruling against my PARK-1 precedent (where I held `σ_prod²`, a standing projection,
must not be stored).

**The distinction MD-16 draws is genuine, and it is the deciding one.** `σ_prod²` is a
**standing diagnostic over the current record**: a corrected Greek *should* update it, so a
stored copy can drift — the C-1.2/1.3 failure — hence PARK-1. A gate decision is the
**outcome of a discrete application event** (MD-11: "the application of a dynamic is an
event … whose every output is captured"), decided against **versioned** declared terms and
an **as-known** history pinned to the application cut. MD-16 makes the load-bearing
argument, not a mere label: "It is **not** a projection of the base stream recomputed on
read (MD-8): … the number that stood at application is an **as-known fact** (MD-4),
re-derived only against the terms and history **as they then stood** — the read-back/
re-derive split of MD-6." Because it is pinned, a later correction does **not** change what
the gate decided at `t`; it is an immutable historical fact, not a drift-prone standing
projection. Recording it is therefore capturing an event outcome (like the single writer's
admit/refuse recorded with the transaction, and like a contract's booked economic values
checked by recomputation, C-13.2), **not** caching a live projection.

**No collision with C-4.11, and PARK-1 not reopened.** C-4.11 governs standing projections
over the (current) coordinates; a gate decision is an as-known event-outcome. The two cases
stay consistent with my PARK-1 ruling precisely because the gate decision has a genuine
event it is the outcome of and is pinned as-known (no drift), whereas `σ_prod²` is a
continuous diagnostic with no such event and tracks the mutable current state. MD-16 is
careful to keep them apart: it "carries the audit discipline the Valuation Manifesto gives
the product instantaneous volatility — auditable, dispute-ready," while noting the
held-vs-recomputed question is "that manifesto's parked question (PARK-1), which this
event-outcome recording neither reopens nor turns on." **SOUND.**

*One precision note (non-blocking):* the clause "'computed when needed, never stored'
governs a quantity read off **balance coordinates**" is textually right about C-4.11's
literal scope, but the load-bearing work is done by the *event-outcome / as-known* argument
above, not by that scope restriction — the broader "a projection stores nothing" principle
(C-1.4, MD-6) is answered by the pinned/immutable nature of the fact, and MD-16 does make
that argument, so the reading is not a narrowing. Leaving the scope clause as the *only*
defence would have been a narrowing; the as-known argument rescues it.

---

## VERDICT: RETURN (light — one naming fix)

The gate and storage **formalism is sound end to end**: Gate 1 is a construction-time
existence condition that grounds VM A5 without circularity and refuses+records at the
boundary (2); Gate 2's H1-H4 map 1-1 to JACOBI, decidability follows, thin history is
correctly typed as an honest hypothesis-failure, the acceptance regions carry no numeric
threshold, and joint realism is valid (3); prevention and detection are disjoint domains
that narrow neither MD-9 nor MD-2 (4); and the gate decision is a recorded as-known
event-outcome, genuinely distinct from `σ_prod²`, colliding with neither C-4.11 nor PARK-1
(5). 1.2 is byte-stable and the corpus citation grounds.

The **sole blocker is item (1):** the term "operator" is overloaded onto the MDM's reserved
"market data operator," a non-negotiable one-component-per-name breach (CLAUDE.md §1) with
a concrete lineage ambiguity. It is a three-edit naming fix, no rigor change. Apply it and
**FORMALIS signs.**

---

# FINAL CONFIRMATION & SIGNATURE (2026-07-21)

Re-read MD-16 after the naming fix. **Blocker resolved:** MD-16 has zero bare "operator"
occurrences; the genus is "family of world-maps"; the construction reads "a declared
dynamic built the state"; the lineage names the dynamic and any market data operator
separately (ambiguity gone); only the qualified reserved name "market data operator"
survives. Nothing else regressed — Gates 1/2, the H1-H4 decidability footing, the
MD-9/MD-2 disjointness, and the event-outcome storage ruling are unchanged and remain
sound; 1.2 stays byte-stable.

## FORMALIS SIGNATURE

I, **FORMALIS**, sign MD-16 (MDM 1.3), scope and assumptions as follows.

**Scope.** Gate 1 (no-arbitrage by construction — a construction-time existence condition
`m*∈Θ_AF` that grounds VM PE-1(A5) without circularity and refuses+records at the
boundary); Gate 2 (realism — H1-H4 mapping 1-1 to JACOBI, decidability following, thin
history typed as an honest hypothesis-failure never a pass, acceptance regions carrying no
numeric threshold, joint realism valid); the MD-9/MD-2 prevention-vs-detection
disjointness (no narrowing of either); and the storage threading (the gate decision is an
as-known event-outcome, not a standing projection — no C-4.11 collision, PARK-1 neither
reopened nor turned on); plus the naming fix.

**Assumptions named.** (1) The corpus Θ_AF / admissibility-ladder resolves to Vol I §2.6
(`sec:no-arb`, `def:admissible`, verified at source) and Ch. 4 Axiom A3 (trusted to
JACOBI's `.aux` resolution, same discipline as Part B). (2) JACOBI's `memo_jacobi_
distributions.md` functionals and H1-H4 are the binding definitions the prose specialises.
(3) The consistency of the event-outcome ruling with my PARK-1 ruling rests on the genuine
distinction between an as-known event-outcome (pinned, immutable) and a standing diagnostic
(`σ_prod²`, drift-prone).

**Disposition: SIGN** — MD-16, MDM 1.3, as in the in-force text.

**CONVERGED.** — FORMALIS, 2026-07-21.
