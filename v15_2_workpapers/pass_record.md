# v15.2 Conformance Pass — Record

Object: produce Specification v15.2 from certified v15.1, discharging the Constitution v1.2
changes (ratified and adopted by the owner 2026-07-13). Authority one-way:
`LedgerManifesto/ledger_manifesto_v1_2.tex`. Page cap below 100 — final build **99pp**, exit 0,
datum=0, boxes=4, stale v1.1 citations=0.

## Repository trail (one commit per step, clause-named)
- `9238fef` constitution: adopt v1.2 (pushed BEFORE any drafting — the committed authority)
- `2557358` v15.2: scaffold + W1 counts and citations (C-2.7, C-2.8 named)
- `8b80dc9` v15.2: W2 Order conformance (C-2.7)
- `200ab31` v15.2: W4 PARK-3 closure (C-4.10 three tests)
- `c8e6ae1` v15.2: ch10 simulated ledger (C-2.8)
- `5ff22c9` v15.2: W5 PARK-2 closure, forward repair, authorised fork (C-12.1, C-12.4, C-12.5)
- `09e79b1` v15.2: W6 housekeeping traceability note (content in 5ff22c9)
- `7120b25` v15.2: page-cap compression (de-pedantry), 102pp → 99pp, no claim cut

## Work items
- **W1** eight commitments everywhere; ch01 §1.2 Order + Simulability paragraphs
  (one-forced-consequence pattern); all citations v1.2. DONE.
- **W2** batch telling killed (ch02 ×3); ch04 precedence refusal anchored to C-2.7;
  ch14 Proposition (Independent commutation) + proof; ch15 witnessed swap pair. DONE.
- **W3** ch10 §The simulated ledger (branch point, generator outside the fold, recorded seed,
  no simulation-only variant, results as provenance-carrying observations, one-engine-two-measures
  identity both ways); Simulation Companion E76; 3 open problems. DONE.
- **W4** PARK-3 closed: (coordinate, agreement) = the specification's declared schema,
  demonstrated compliant with C-4.10's three admission tests (ch03 §3.7 demo; Thm 14.1 = test
  three; headers recast). DONE.
- **W5** PARK-2 closed as discharge (two-axis machinery = the spec's indexing of C-12.1;
  BITEMP stands); C-12.4 forward repair (correction event, open item, views-automatic /
  money-gated, prop_noRepairWithoutAuth, phase-0 rule); 13 repair sites routed through the
  authorisation gate, 5 reviewed and left with reasons; C-12.5 authorised fork (ch14 subsection,
  Invariant Lineage append-only, shared branch-point primitive with ch10). DONE.
- **W6** Prop 7.3 recast as discharge of adopted C-8.7; ch17 register closes ALL five entries
  (PARK-1/2/3/4 + C-4.8) each with its resolution — the emptied index evidenced, not suspicious. DONE.

## Compression (page cap)
STYLUS pass: ch15's anti-vacuity boilerplate stated once as a standing gate, dropped from 15
property tails; pre/post duplicated defect stories collapsed; new-text trims (ch10/ch12/ch14/
ch15/ch17). Printed ToC depth → sections (subsections in PDF bookmarks). 102pp → 99pp; no
lstlisting/theorem/proposition/invariant touched; every number and oracle-independence note kept.

## Certification
| Phase | Certifier | Scope | Verdict |
|---|---|---|---|
| 2(a–d) | adversarial hunter | batch telling · auto-firing money · simulation-only path · stale citations/counts | **CLEAN ×4** — transaction list is fold output everywhere; all 8 money-repair sites gated, 2 ungated sites verified out of C-12.4's reach (view-class / lifecycle unwind); no test-only door; citations v1.2 with only historical v1.1; counts=eight; retired rendering named only as retired |
| 2(e) | conflict hunter | new conflicts with v1.2 (7 sites) | **NO PARKABLE CONFLICTS** — all 7 sites clean (schema demo satisfies C-4.10 as worded; fork invariant admissible; simulated ledger's eight-commitments claim mandated by C-10.1; "five decided by the owner" reconciles exactly against the v1.2 amendment record). 1 conform-fix APPLIED: C-12.4's dual condition (counterparty agreement + person) stated at both ch14 cross-ref sites; ch15 `Authorisation` gains `counterpartyAssent`, `prop_noRepairWithoutAuth` witnesses both conjuncts. RoU gap re-confirmed as openly-flagged, pre-existing, not v1.2-created. |
| 3 | FORMALIS | Prop independent-commutation soundness (coverage-fibre attack), swap pair, noRepairWithoutAuth, timetravel/replay intact | **2 VETO → DISCHARGED; 3 CERTIFIED.** VETO-1a (critical, valid counterexample): footprint enumeration dropped the coverage read-fibre — repaired with FORMALIS's own fibre-grain reads∪writes definition; genDisjointPair comment corrected. VETO-1b: proposition scoped to folded state (hash chain position-dependent). VETO-3: isCompensating defined, property recast as door-refusal of adversarial constructor-bypassing repair + genUnauthorisedRepair + refusal witness. Certified: swap pair (generator's wallet+unit disjointness = whole-fibre, sound independently of the flawed prose), timetravel/replay unweakened by compression, ch02 fold telling type-correct. Repairs committed bcdcdb9, 99pp. |
| 4 | CONCORDIA (absolute veto, signs last) | full clause-discharge audit C-1.1…C-Auth.4 incl. C-2.7/2.8/12.4/12.5 + global self-consistency | **SIGNED** — 104 clauses, two-way audit COMPLETE after one veto (C-6.6 orphan) repaired at ch17:8; four new clauses verified discharging; FORMALIS repairs confirmed landed; full sweep clean. See `concordia_signoff.md`. |

## Deliverables
- v15.2 clean: `Ledger_Spec_v15.2/ledger/ledger_v15_2.pdf` (99pp)
- Redline: `v15_2_workpapers/redline_v15_1_to_v15_2.diff` (unified diff, 1,330 lines; latexdiff
  unavailable on this machine — the git history is the structured redline, one commit per work item)
- Updated ch17 registers (parking closed ×5 with resolutions; open problems +3; companions ×5→E76)
- Updated test surface (ch15: +prop_independentSwapInvariant, +prop_dependentSwapDiffers,
  +prop_noRepairWithoutAuth; standing anti-vacuity gate)
- CONCORDIA sign-off/veto memo: to be committed beside this record.

## Freeze status: **SIGNED — CONCORDIA certified the pass 2026-07-13.**
Three vetoes issued and discharged across the pass (FORMALIS 1a/1b coverage-fibre + folded-state
scope, FORMALIS 3 vacuous auth property, CONCORDIA C-6.6 orphan); hunts a-e clean; final build 99pp
(<100), exit 0. The Event Universe pass (Phase A findings memo, owner-gated) begins from this
certified base.
