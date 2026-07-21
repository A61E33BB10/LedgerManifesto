# FORMALIS — Referee feedback, Round 3 (Temporal Committee, Part II)

Remit: certify that the five R2-open items are resolved soundly AND consistently across the
assembly (active design files TEMPORAL-1 + TEMPORAL-4; reviewers T-2/T-3/T-5), or flag exactly
what still fails. Round 3 of ≥10 — I do not declare consensus (reserved for ≥round 10 after
red-team); I say plainly whether the correctness content is settled. A flag without a counterexample
or named missing case is discarded.

---

## Checklist verdict, items 1–5

**1. Fork A′ → FLAG. RESOLVED.**
T-1 §2.2 (l.68-79) and T-4 D15 (l.115, header l.10-16) both now say FLAG; T-4's D15 REFUSE is
explicitly flipped ("D15 flips REFUSE → FLAG", l.10). Refuse-mode is reserved to exactly the two
loci in all five: "Refuse is reserved for a gate fail/undecidable verdict (gate decides) or an
unresolvable structural reference (door decides) — never a fresher tip" (T-1 l.77-78; verbatim in
T-4 l.83-84, T-2 l.29-31, T-5 l.107-109). Livelock stated everywhere (90 s model / 45 s
corrections: T-1 l.78-79, T-4 D15, T-3 l.34-37, T-5 l.111). Reviewers concur: T-2 §1 explicit FLAG,
T-3 §1 retracts R2 §2b REFUSE, T-5 A′ section FLAG. Doctrine-consistent with the kind-3 definition.

**2. Scope boundary one-voice. RESOLVED.**
T-5 Fix 1 (l.26-37) explicitly retracts the r2 "admission-time contract" ("Retracted") and states
the one-voice line: "Bit-reproducibility is never a door/admission precondition (out-of-scope
numerics, C-Scope.11) … governance-optional Tier-2 … never gated at the door." Same voice in T-1
§3 (l.139-143), T-4 D14 (l.114), T-3 §3 (l.66-71), T-2 §2 (l.44-51). Nothing reintroduces it as an
admission gate — see the one wording snag under residuals (T-1 "requires").

**3. Determinism actor boundary. RESOLVED.**
Compute/emit split is PRIMARY and the race is "structurally REMOVED, not reduced" (T-4 D14 l.114,
T-1 l.132-137, T-5 l.11-13). Env-pin is Tier-2 (T-1 l.142, T-4 D14, T-3 §5). T-4's content-hash is
now positioned as "an OPTIONAL diagnostic — meaningful only for a buggy worker that violated the
split by fusing eval with propose — and it never changes which value is canonical (still
first-admitted)" (D14 l.114): no longer stranded/dead-under-M1 (my R2 defect), because M1 is now the
chosen mechanism and the hash is a labelled defence-in-depth guard, not a claimed-firing invariant.
Substrate-never-compare / door-may-hash reconciled by actor in T-2 §2, T-3 §4, T-5 l.91-98. Consistent.

**4. Value-level bound (my sharpest-open). MECHANISM DISCHARGES / ASSEMBLY STILL-OPEN ON LOCUS.**
The mechanism is sound and is a genuine discharge, not a relabel (judgment below). BUT the two
active files place the bound-check where it is ill-defined: T-1 l.151 and T-4 D16 l.116 have **the
door** compare `β ≤ "the consuming unit's declared VM-6 tolerance"` at admission; T-5 l.72-82 splits
it — door = **presence only**, `β ≤ VM-6` at **consumption** as a VM-7 broken chain. A shared derived
observation has no single consuming unit at admission (counterexample below), so the door-locus of
T-1/T-4/T-3 is under-specified and T-5's consumption-locus is the correct one. This is unconverged at
the load-bearing point. Fold T-5's two-point split into T-1/T-4.

**5. Three record kinds throughout. RESOLVED.**
T-5 Fix 2 (l.39-42) corrects "two → three" (projection / re-entered observation /
recorded-decision-pinned-as-known). Three kinds stated in T-1 l.3-12, T-4 l.24-29, referenced by
T-2 l.31-33 and T-3 l.23-25. No live "two record kinds" remains.

---

## Judgment on item 4 — discharge or relabel? (my finding, as charged)

**It discharges — to the framework's own perimeter standard — and is not a mere relabel.** The
obligation was: tie the admissible re-entry-value spread to VM-6 via a predicate the door can check
without model knowledge. The mechanism converts an *unstated, unbounded* `|Pᵢ−Pⱼ|` into a
*declared, recorded, versioned* bound `β`, structurally checked against VM-6 (two recorded numbers,
no numerics), with a **non-silent** failure mode ("never a silent trivially-dispute-ready pass",
T-1 l.155-156; "never silently passed", T-4 D16) and a **defined detection path** (false attestation
→ detection-at-audit by re-derivation, T-1 l.156-157; named **TA-REPRO**, T-4 Q3 l.134-139). That is
the exact epistemic status of every other perimeter-reconciled quantity in the design, **including
the VM-6 tolerance itself**, which is also a declared term of trusted-at-boundary / audited adequacy.
Demanding more — that the door *verify* the actual spread — would require model knowledge and a
re-run, which C-Scope.11 forbids and no member will do. So the mechanism is the right one, and it
genuinely bounds the spread whenever the attestation is truthful; the residual (attestation truth) is
correctly named and parked, not swept away. The relabel charge would stick only if the spread stayed
unbounded-in-fact while claimed bounded — it does not. **Discharged.**

**But the discharge as written is not yet correct, because of the locus split (below).** The
mechanism is sound; the two design files state it in a form that fails for the shared-observation case.

---

## Residual rigor defects

**R-1 (item 4, blocking the assembly). Enforcement locus is a 3-1 split at the load-bearing point.**
Counterexample: one fitted vol surface S (a re-entered observation) is admitted **once** with attested
bound `β = 3 bp`, then consumed by unit U₁ (VM-6 tolerance 5 bp) and unit U₂ (VM-6 tolerance 1 bp).
S is dispute-ready for U₁ (`β ≤ 5`) and NOT for U₂ (`β > 1`). At S's admission the door has no single
"the consuming unit's VM-6 tolerance" to compare against — U₁ and U₂ are not yet determined. So T-1
l.151 / T-4 D16 l.116 ("the door … `β ≤` the consuming unit's declared VM-6 tolerance") is
ill-defined for any shared/multi-consumer derived object, which is the normal case. T-5's split is the
correct decomposition: **door checks presence** (consumer-agnostic, model-free), and **each consumer's
valuation projection** raises a VM-7 broken chain when `β >` *that* unit's tolerance (l.79-82). Fold
T-5's two-point split into T-1/T-4; drop the single-door-tolerance phrasing.

**R-2 (item 4). Door behaviour on a MISSING attestation is unconverged.** T-5 l.73-76: absent field →
door "refused/quarantined, W4" (a presence/completeness refusal). T-1 l.153-156 and T-4 D16: "no
attestation ⇒ admitted (canonical-by-first) but flagged." These are different door behaviours at the
boundary. Reconcilable — require the *field's presence* (refuse if structurally absent; that is an
"unresolvable structural reference", inside the item-1 reserved refuse class) while a *present-but-
UNBOUNDED* class is admitted-and-flagged — but the committee has not written this; pin it.

**R-3 (item 4, §1-narrowing wording). T-1's "Admission as a dispute-ready mark **requires** … `ε_repro
≤ VM-6`" (l.150-151)** reads as an admission precondition, brushing item-2's own guard
("dispute-readiness must not quietly become an admission gate"). Substance is fine — the very next
clause admits the mark either way and only flags it — but the verb "requires" should be replaced by
"is-attributed / is-flagged", so the sharp item-2 line is not blurred in the assembled artifact.

**R-4 (one-name rule, CLAUDE.md §1). One quantity, four symbols:** `ε_repro` (T-1), `β` (T-4), `τ`
(T-5), `ε` (T-3). Expected pre-merge, but the two active files (T-1, T-4) must pick ONE symbol before
assembly; "no synonyms, ever" is strict here.

**R-5 (minor). Idempotence-key tuple differs.** T-1 l.38-39: `(input-cut, model/recipe-version, seed,
numerical-environment-version)`; T-2 §4 l.83-84: `(input-cut, model/recipe/dynamic-version,
numerical-environment-version)`; T-4 D10 l.110: `(input-cut, model/recipe-version)`. All agree it is
cause-derived over recorded inputs, never a Temporal id — but the exact tuple must be pinned once.

**R-6 (housekeeping, non-blocking). Stale directive in T-2 §1 (l.36-37):** "T-4 D15 and T-3 §2b invoke
it as a stale-cut refusal … must flip to FLAG" describes the r2 state; both have already flipped in
r3. Harmless, but the merged artifact should not carry a directive to flip what is flipped.

**Fixed since R2, confirmed:** T-1's "MD-1 absorption" over-claim is gone — first-wins is now stated
as "a declared rule, not MD-1 absorption … a fiat, stated as one" (l.139-142). The compute/emit +
attested-class composition is clean and correct: split removes the intra-run door race (Tier-1),
class bounds the inter-derivation spread (Tier-2) — neither alone suffices, together they cover both
(T-3 l.89-91). The crash-before-record window yields one recorded value, not a door race (T-1 l.135-137).

---

## Readiness call

**Yes** — the design is rigorously sound enough to enter red-team hardening, conditional on folding
T-5's door-presence + consumption-VM-7 split for the value-level bound into T-1/T-4 (R-1) and pinning
R-2/R-4/R-5; these are statement/placement reconciliations of an already-correct mechanism, not open
correctness questions, so red-team can proceed in parallel.

**Correctness content: settled** (not consensus — that is reserved for ≥round 10 after red-team). The
hard determinism gap is closed two-tier and consistently (compute/emit removes the door race; the
attested reproducibility class bounds the value spread against VM-6); A′=FLAG is unanimous and
doctrine-consistent; the scope boundary is one voice; three record kinds throughout. The only
unconverged point is *where* the value-bound check lives — and the correct answer (T-5's) is already
on the table, needing folding, not discovery.
