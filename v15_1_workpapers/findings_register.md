# v15.1 Findings Register

Run: adversarial hardening of Ledger Spec v15.0 (73pp) against Constitution v1.1.
Terminates only on unanimous certification incl. CONCORDIA (absolute veto). Owner adjudicates nothing.
Status legend: PENDING · DRAFTED · CRITIQUED · REPAIRED · CERTIFIED · PARKED.

| F | Severity | Chapters | Constitutional impact | Owner | Certifiers | Status |
|---|---|---|---|---|---|---|
| F1 | BLOCKING | ch03§8, ch05, ch08§6, ch14, ch15 | none (restores Const §7) | NOETHER/KARPATHY | JACOBI,ASHWORTH,TALEB,CONCORDIA | CERTIFIED |
| F2 | BLOCKING | ch02, ch05§5, ch06, ch08§8, ch14, ch15§4 | AMEND Const §12 — PARK | KLEPPMANN | CONCORDIA,TALEB | CERTIFIED |
| F3 | BLOCKING | ch06, ch09§3, ch11, ch17§3 | none (Const §6 applied) | KLEPPMANN/KARPATHY | CONCORDIA,ASHWORTH,MATTHIAS-β | CERTIFIED |
| F4 | MAJOR | ch09§2, ch09§4, ch14§6 | none | NOETHER | CONCORDIA,JACOBI,CARTAN | CERTIFIED |
| F5 | MAJOR | ch07§2, ch03§1 | none | KARPATHY | CONCORDIA | CERTIFIED |
| F6 | MAJOR | ch06§1, ch05§1, ch05§3 | none | NOETHER/KARPATHY | CONCORDIA,ASHWORTH | CERTIFIED |
| F7 | MAJOR | ch04§3, ch13§5, ch14, ch15 | none (note Const §5 thinness) | KLEPPMANN | CONCORDIA,MATTHIAS-β,TALEB | CERTIFIED |
| F8 | MAJOR | ch11§3, ch08, ch16§3 | new TA-EXDATE | CARTAN-attack/KARPATHY | CARTAN,ASHWORTH,LEX MANDATUM | CERTIFIED |
| F9 | MAJOR | ch07 Def7.1/§3, ch15§4 | none | NOETHER/KARPATHY | CONCORDIA,JACOBI,ASHWORTH | CERTIFIED |
| F10 | MAJOR | ch03§7, ch09§2, ch14§1, ch12 | AMEND Const §4 — PARK | NOETHER | CONCORDIA,CARTAN | CERTIFIED |
| F11 | MAJOR | Constitution(all), every ch opener, ch17§3 | structural editorial — PARK (proposed) | CONCORDIA/KARPATHY | CONCORDIA | CERTIFIED |
| F12 | MAJOR | Const §8, ch07 Prop7.3, ch17§3 | real conflict — PARK | KARPATHY | CONCORDIA,LEX MANDATUM | CERTIFIED |
| F13 | MAJOR | ch02§8 (+Const §3 note) | none | KARPATHY | CONCORDIA | CERTIFIED |
| F14 | DE-PEDANTRY | ch02§7,ch04§4,ch05§4,ch07§3,ch09§8,ch12§5,ch14§6,ch15§4 | none | KARPATHY | STYLUS,JACOBI | CERTIFIED |
| F15 | DE-PEDANTRY | ch01, ch02 | none | KARPATHY | STYLUS,CONCORDIA | CERTIFIED |
| F16 | MAJOR(method) | ch15§4 | none | WILSON | TALEB,FORMALIS | CERTIFIED |

## Standing constraints (each a blocking defect; named certifier)
- C1 one-way authority — CONCORDIA/LEX MANDATUM. C2 category subordinate, ≤4 boxes, deletable — GROTHENDIECK.
- C3 surgical addition — KARPATHY. C4 de-pedantry — STYLUS. C5 page cap 100 (never cut a claim for a page).
- C6 every guarantee an executable check that FIRES (≥1% histories) — TALEB anti-vacuity.

## Expected parks (empty parking index ⇒ run FAILED): F2 (§12), F10 (§4), F11 (editorial), F12 (§8).

## Notes
- Chapter map: ch01 objective, ch02 picture, ch03 objects, ch04 machines, ch05 contracts, ch06 homes,
  ch07 valuation, ch08 marketdata, ch09 collateral, ch10 virtual, ch11 settlement, ch12 reporting,
  ch13 cdm, ch14 invariants, ch15 testability, ch16 requirements, ch17 scope.
- Four existing second-telling boxes (ch02§8, ch03§8, ch08§4, ch14§1) = the ceiling; net must stay ≤4.
- Subagents: spawn with model=opus (Fable pool exhausted).
- VERBATIM repair specs for all 16 findings recovered from transcript → findings_specs_verbatim.txt
  (authoritative source for briefing every author; use it, not memory). Phase 2+ file-collision note:
  F1↔F6 (ch05), F6↔F3 (ch06), F3↔F4 (ch09), F4↔F1 (ch14) form a cycle ⇒ Phase 2 runs SEQUENTIAL.
- F11 done (110 clauses C-1.1..Authority.4; discharge_matrix.md written; constitution_v1_2_proposed.tex
  builds standalone, cited by nothing but parking index). Both builds exit 0; spec 73pp.
- DISCHARGE-MATRIX GAP RESOLVED (OBL-B): C-6.6 managed-account fee accrual & NAV attribution → relocated to
  named Exclusions-Register companion E75 (Managed-Account Companion) per CONCORDIA ruling. NO NAMED GAP remains.
- RUN FROZEN 2026-07-12 on unanimous certification (G1–G9). All 16 findings CERTIFIED; parking index NON-EMPTY
  (PARK-1/2/3/4). See certification_record.md for the full signature + veto trail.
