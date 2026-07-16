# Phase 4 — Committee Sign-off (Ledger Specification v15, freeze record)

**Status: READY FOR FREEZE.** All Definition-of-Done conditions met. The finished
specification is `Ledger_Spec_v15.0/ledger/ledger_v15_0.tex` (+ `drafts/ch01–ch17`),
compiling clean to **73 pages** (three `pdflatex` passes, exit 0, no `!` errors, no
undefined references, no overfull boxes, table of contents included).

## Definition of Done (owner note, 2026-07-11) — checklist

| Condition | Status |
|---|---|
| Finished v15 ≤ 100 pp compiled | ✅ 73 pp (ToC included), 27 pp under cap |
| Conformance matrix total | ✅ FORMALIS: total both directions |
| Exclusions Register complete | ✅ E1–E74; new residuals in Ch.17 open-problems index |
| Six threads unbroken | ✅ CARTAN: zero number forks, pre and post fix |
| STYLUS + PROCRUSTES sign-offs | ✅ both below |
| Team B converged under PARETO | ✅ all three adversaries CONVERGED |
| Committed and pushed w/ full committee record | ✅ this commit |

## Structural sign-offs

- **FORMALIS (conformance + seam).** Conformance matrix TOTAL in both directions — every
  constitution section (§1–§14.2, Scope, Authority/Amendment, amendment record) discharged
  by ≥1 chapter; every chapter grounded in ≥1 section. All three v1.1 amendments faithfully
  realised. Coverage invariant `Σ_G posted_G(w,u) ≤ max(owned(w,u),0)` in DEFECT-9-corrected
  form throughout (Ch.9/12/14/15). Ch.9 implements the ratified ruling in full.
  Post-fix re-verification: the **collateral–settlement seam is CERTIFIED** — FIX-1
  (ex-date-keyed entitlement) COMPLETES ruling D2 with the ledger's own cum/ex machinery
  (discharging D2's former external appeal), the §5 single-writer / MC-1 write-seam holds,
  and the FIX-2 coverage softening ("never false in a committed state") is exact. No
  constitutional conflict; matrix stays total. (`phase4_formalis_conformance.md`)
- **CARTAN (thread continuity).** Six threads certified unbroken; zero number forks; the two
  couplings (ACME calendar; IDX close series) share identical figures; stale 2026-05-29
  absent everywhere. Re-verified post-fix: no frozen number moved; the new Ch.11 varswap
  settlement episode (41,000) and the barrier rewording are numerically clean.
  (`phase4_cartan_continuity.md`)

## Form / budget sign-offs

- **STYLUS (prose).** v15's prose is CONFORMANT and READY FOR FREEZE. Phase-4 inserts judged
  result-first, declarative, seated cleanly; one surgical hedge-fix (Ch.11). CT protocol
  holds (every categorical term quarantined in a `secondtelling` box after its plain
  telling). Cross-chapter wording consistent (barrier Ch.2/3/4/5/7; closed enumerations
  Ch.13↔15; observation-index ordering Ch.5/6/15). No number/label/technical content altered.
- **PROCRUSTES (page ledger).** Compiled 73 pp against a 95 pp working budget and 100 pp hard
  cap — the full reserve is intact (+22 pp headroom under the working budget). No chapter
  overran to force a reserve draw; the ToC (+1 pp) and Phase-4 additions (+4 pp over the
  69 pp Phase-3 baseline) absorbed within budget. SIGN-OFF granted.

## Team B convergence (PARETO) — one round, find → disposition → fix → re-verify → converge

Five reviews (`phase4_{formalis_conformance,cartan_continuity,taleb_review,ashworth_review,
lexmandatum_review}.md`) → consolidated dispositions (`phase4_dispositions.md`) → six
parallel per-file fix agents + two orchestrator edits → FORMALIS/CARTAN re-verification →
STYLUS form pass → adversary convergence check → one final cleanup pass.

- **TALEB — CONVERGED.** All 14 findings resolved (verified against drafts): coverage
  over-claim softened (T-1), one-touch barrier close-monitored (T-3), accumulators ordered
  by observation index (T-4), close-out elevated to top open risk (T-2), + four MED
  clarifications. No new must-fix.
- **ASHWORTH — CONVERGED.** Both HIGH resolved: A-1 (coverage under instructed ownership,
  fails cascade order-forced → obligation → supervised write-off) and A-2 (declared agreement
  terms catalogued as boundary data; Ch.16 B7). Residual **R1 named** (below) per its
  condition.
- **LEX MANDATUM — CONVERGED.** All 5 resolved: ex-date entitlement (L-1, "a strong fix, not
  a patch"), Payout characterization (L-2), Collateral type / identity (L-3/L-4), eligibility
  reads state (L-5). No new legal/regulatory must-fix.

## Open-problems index (Ch.17) — design residuals, ZERO constitutional conflicts

- **P-1** managed-account fee accrual / NAV attribution — §6 consequence the constitution
  defers to the detailed specification; named, not worked.
- **P-2** close-out / netting algebra — the **top open risk**; the per-netting-set
  claim/obligation apparatus exists for it, the algebra is deferred.
- **R1** fails-cascade obligation full valuation and lifecycle (mint by the settlement-fail
  contract, valuation as a unit, resolution or supervised write-off, DvP-leg accounting) —
  named as a design residual; NAV-neutrality across a failed purchase is stated in Ch.9.
- **Accepted non-blocking (no edit):** LEX-1 (cum/ex determination edge a well-formed ex-date
  convention prevents); optional CTM contrast expansion (one sentence retained); partial /
  tranched settlement (the settlement layer's "how", out of scope, CSDR-consistent).

The constitutional-parking register remains empty: no author, reviewer, or fix filed any
genuine conflict with Constitution v1.1. Constitutional amendments remain the owner's alone.

## Companion documents (out of scope, named in EXCLUSIONS.md)
Worked-Examples Volume (E71/E72), SBL Operations Companion (E73), Track B graphs-interpreter
companion (E74).

— Orchestrator, for the full committee (FORMALIS · CARTAN · STYLUS · PROCRUSTES · PARETO ·
Team B: TALEB / ASHWORTH / LEX MANDATUM; authors KLEPPMANN · KARPATHY · GATHERAL · NAZAROV ·
MINSKY · MATTHIAS · NOETHER · WILSON; GROTHENDIECK second-tellings)
