---
name: spec-labels-xrefs
description: Ledger v11.0 LaTeX label naming scheme and the broken semantic cross-ref aliases
metadata:
  type: project
---

Sections/appendices label themselves canonically as `\label{sec:secNN}` (e.g. sec:sec01..sec:sec20) and `\label{sec:appA}`..`\label{sec:appI}`. Files live in `/home/renaud/Ledger/Ledger_Spec_v11.0/ledger/drafts/<id>.tex`.

**Why:** Many `\ref`/`\hyperref` call sites use *semantic* target names that were never defined as labels, so they render "??".

**Round 5 status: RESOLVED at source by STYLUS.** All 6 broken targets aliased with a second `\label` at the canonical section head: `sec:valuation`→sec05, `sec:substantiation`→sec10, `sec:cdm`→sec13, `sec:sec8`→sec08, `app:reconciliation`→appC, `app:cdm-mapping`→appA. Each now has exactly 1 def; whole-doc duplicate-label check clean. `sec:intro` already resolved since R2. RECOMPILE PENDING: `ledger_v11_0.pdf` (built Jun 28 00:03) still renders 21 "??"; rebuild from the patched fragments clears them. Was the one outstanding clarity BLOCKER; no longer.

**Round 3 status (historical, PDF-VERIFIED): 6 of 7 were broken** — 0 defs in `*.tex`, 0 `newlabel` in `ledger_v11_0.aux`; ground truth `pdftotext ledger_v11_0.pdf | grep '??'` → 21 rendered "Section ??/Appendix ??/§??".
NOTE: `ledger_v11_0.log` is unreliable for missing-ref detection — it contains ZERO "LaTeX Warning"/"undefined"/"Overfull" lines (warnings appear stripped). Use the PDF text (`pdftotext`) or compare `\ref{}` sites against `aux` `newlabel`, never the log.

**How to apply:** When checking cross-refs, these 7 targets are undefined and must be aliased (add a second `\label` at the section head) or retargeted to the canonical name:
- `sec:valuation` → `sec:sec05` (used in sec01,02,04,15,16)
- `sec:cdm` → `sec:sec13` (used in 9 files: appA,appF,appB,sec01,06,12,15,16,17)
- `sec:substantiation` → `sec:sec10` (sec02)
- `sec:sec8` → `sec:sec08` (sec13)
- `app:reconciliation` → `sec:appC` (sec10,sec19)
- `app:cdm-mapping` → `sec:appA` (sec13)
- `sec:intro` → `sec:sec01` (appF,sec12,sec18)

Note: §14 also defines aliases `\label{sec:sec14}\label{sec:temporal}` and `\label{sec:obligation-liveness}` — these resolve. Verify any new ref against `grep -rhoE "\\label\{[^}]*\}" *.tex`.

**RESOLVED (round 2):** the duplicate `\label{sec:invariants}` collision is fixed. sec15.tex:3 is the canonical invariant hub; sec08.tex's local "Invariants threaded through the life" subsection now labels itself `\label{sec:futures-invariants}` (was `sec:invariants`). All `\ref{sec:invariants}` sites (incl. sec08:506) intentionally point at the hub and were left unchanged; nothing referenced the §8 subsection.
