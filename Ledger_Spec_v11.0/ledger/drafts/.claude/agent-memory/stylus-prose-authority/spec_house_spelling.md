---
name: spec-house-spelling
description: Ledger v11.0 house spelling/identifier conventions and known deviations
metadata:
  type: project
---

House spelling is **British -ise/-isation**, applied consistently: crystallise, materialise, amortise, derecognise, collateralise, recognise, modelling, modelled, behaviour, defence, catalogue, centre/centres (prose). `center`/`color`/`centering` in the source are LaTeX/TikZ commands, not prose — never "correct" them.

**P&L identifier:** canonical form is `PnL` (glossary defines it). ROUND 2 (2026-06-28): appF.tex:55 now reads "the PnL realisation" — RESOLVED. No `P\&L` remains anywhere.

**Tokenized spelling (US) vs house British — ROUND 2 (2026-06-28) narrowed:** appF prose is now fully British (`tokenised`); its only z-hit is the LABEL `\label{sec:cdm-tokenized}`. sec16:511 z-hit is the `\ref{sec:cdm-tokenized}` LABEL too; its prose is British. ROUND 3 (2026-06-28): ALL US prose deviations RESOLVED. sec03:39/44 fixed to British before R3; sec19:57 fixed by STYLUS in R3 ("Tokenised securities", "tokenised-equity model", "tokenised-collateral eligibility"). Only remaining `tokeniz` z-hits are the LABEL `\label{sec:cdm-tokenized}` (appF:83) and its `\ref` (sec16:511) — KEEP as-is (changing a label breaks refs). Code `NVDA\_TOKEN` stays. No US prose spelling remains anywhere.

**GMSLA + year spacing:** tilde non-breaking `GMSLA~2010` / `GMSLA~2018`. ROUND 3 (2026-06-28): all plain-space `GMSLA 2010` RESOLVED. ROUND 8 (2026-06-28): the `GMSLA 2018` and `GMSLA 2000/2010` variants had been MISSED (R3 only normalised the literal "2010") — STYLUS fixed sec16:311 (`GMSLA~2000/2010`), sec16:312 and sec16:456 (`GMSLA~2018`). Verify with `grep -rnoE 'GMSLA (2000|2010|2018)' *.tex` → expect zero plain-space hits. `GMSLA~9.3`/`GMSLA~\S10` (clause refs) are correct.
