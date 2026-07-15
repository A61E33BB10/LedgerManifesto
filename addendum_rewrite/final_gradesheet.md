# Final Gradesheet — StatesHome Rewrite

**Outcome: PASS.** Terminated at **round 10** — the earliest round at or after the ten-round floor at which every committee member graded **A (≥90%)**, with no FORMALIS correctness veto in any round. The floor was honored: the committee first reached unanimous A at round 4 but continued, and round 8 saw `minsky` fall back to B on a newly surfaced finer fault, confirming the bar was raised rather than the review rubber-stamped.

## Round 10 — terminal grades

| Member | Lens | Grade | % |
|---|---|---|---|
| `karpathy` | one-pass clarity | **A** | 93 |
| `chris-lattner` | progressive disclosure | **A** | 92 |
| `henri-cartan` | documentation architecture | **A** | 92 |
| `dirac` | minimal revealing notation | **A** | 91 |
| `jane-street-cto` | readers over writers | **A** | 91 |
| `formalis` | correctness preservation (veto) | **A** | 93 |
| `minsky` | Haskell: illegal states unrepresentable | **A** | 91 |
| `milewski` | Haskell expressibility | **A** | 95 |

## Grade trajectory (rounds 1–10)

| Rd | karp | chri | henr | dira | jane | form | mins | mile | unanimous A |
|---|---|---|---|---|---|---|---|---|---|
| 1 | B | B | B | B | B | B | B | B | no |
| 2 | A | A | B | A | A | A | A | B | no |
| 3 | A | A | A | A | A | A | A | B | no |
| 4 | A | A | A | A | A | A | A | A | **yes** (floor not yet reached) |
| 5 | A | A | A | A | A | A | A | A | **yes** (floor not yet reached) |
| 6 | A | A | A | A | A | A | A | A | **yes** (floor not yet reached) |
| 7 | A | A | A | A | A | A | A | A | **yes** (floor not yet reached) |
| 8 | A | A | A | A | A | A | B | A | no |
| 9 | A | A | A | A | A | A | A | A | **yes** (floor not yet reached) |
| 10 | A | A | A | A | A | A | A | A | **yes** ← terminate |

## Correctness
FORMALIS graded A in every round (rounds 1–10) and exercised no veto: every invariant, condition C1–C12, Pareto forcing reason, the seven-unreachable-invariants claim, and the F1–F8 risk register in `CORRECTNESS_CHECKLIST.md` remained present and unweakened through the rewrite.

## Expressibility signals (milewski, recorded not contorted)
The Haskell reference records signals S1–S4 in clearly-marked comment blocks, cross-referenced from the prose (e.g. §reference): conservation expressed as a handler-level law rather than a type-level refinement (S1); cross-unit conservation under a breaking amendment as a paired issuance event (S3 on C11). Each is acknowledged as the correct boundary of what types can cheaply enforce, not smoothed over.

## Artifacts
- `addendum_stateshome_v2.tex` / `.pdf` — the rewrite (25 pp., compiles clean).
- `reference/StatesHome.hs` — FORMALIS-cleared Haskell reference (replaces the Python listing).
- `stylus_diagnosis.md` — 55 cryptic instances catalogued.
- `rounds/round_01..10/<agent>.md` — 80 independent scorecards.
- `iteration_log.md` — per-round changes and grades.
- `CORRECTNESS_CHECKLIST.md` — the FORMALIS-owned fixed standard.
