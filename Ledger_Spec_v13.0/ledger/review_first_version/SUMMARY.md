# First-Version Review — Outcome

Committee review of `ledger_v13_0.tex` to read as the first and only version of the
specification: excise document-history residue (R1–R5), simplify, preserve all mathematical
and economic meaning and all domain vocabulary. Six iterations (five + one repair), 21 agents.

## Result: CONVERGED
Final build clean — `latexmk` exit 0, **166 pages** (from 167; ~1 page of editorial excision,
no content cut), 7 parts, 0 fatal / 0 undefined refs / 0 missing glyphs / 0 overfull > 20 pt.
PDF metadata carries no version identity.

## What the committee changed
Mechanical pre-pass (deterministic, before the committee): removed the single-file assembly
scars — the `Version 13.0` date stamp, three header comments, and 82 `% >>>>> begin/end drafts`
inlining banners; `\date{July 2026}`.

Committee findings, all discharged:
- **R2 keystone** (§ state-basis): recast "State-sufficiency … survives with its third,
  previously silent dependency … the three illegal states … gain a fourth" — document-history
  voice *and* a stale ordinal (the valuation section now enumerates five illegal states) — into
  a first-version statement that hinges on no count.
- **Numbering scars from the state-basis section's insertion (§8), which shifted the futures
  lifecycle to §9:** `sec.8`→`sec.9` in two listing comments; deleted a duplicated `Section 7, §7`;
  fixed a raw `Sec.~ledger` markup leak inside a listing.
- **Dangling citation:** removed the `P24 / retro-insertion permutation oracle` reference to a
  non-existent Appendix B oracle (canonical numbering is P1–P23); the tip-weld claim now rests on
  its stated derivation (Principle reference), not a phantom oracle.
- **Merged-draft tag collision:** in-text `E1–E5` retagged to the register's `ME1–ME5` / `FE1–FE2`.
- **Persona/process residue:** "the Nazarov attestation finding" → "the attestation-envelope
  finding (ME2)"; "Owner: the performance/risk agent" → an organisational owner; six "FORMALIS
  clearance / verdict CLEARED" remarks reframed as declarative "Verification / discharged by
  construction" (discharge content preserved verbatim, per constraint 8).
- **One-word R2:** "next-version agenda" → "forward agenda"; "both witnesses are retained" →
  "each regime has its witness".
- **R5 source hygiene:** removed a `coverage_map.md` comment; corrected drifted `\label` names.
- **M3 — `StatusWrite` coherence:** §8 re-listed the closed status-writer set as "extended by ONE
  case" while silently retyping `SetLastSettle`. Now honestly declared "one new case, one refined
  settle mark," with the `applyStatus` propagation shown, so the listing is self-consistent.

Post-repair (not by the committee): removed a stray `.claude/agent-memory/` directory the
workflow wrote into the deliverable tree; fixed `\EUR` used in math mode (silently dropped the
€ glyph in three state-basis worked examples) by wrapping the macro in `\mbox`.

## Domain vocabulary confirmed protected (NOT touched)
All 30 `supersede*` hits (`supersedeTx`, `superseded_by`, `DanglingSupersede`, C8 breaking
amendments); `TermsVersion` / `appendVersion` versioned-by-design; "legacy systems" as bank
systems in a deployment migration; the two "no longer" sites (collateral eligibility; bond
ex-coupon); CDM v6.0.0 version coexistence. Misclassifying these was ruled a material error.

## Two flags for the owner (design/code, out of prose scope — constraint 8)
1. **Reference-code divergence.** §8 now states the settle mark is refined to
   `SetLastSettle (Price, BasisPoint)` (it names its basis). `reference/Ledger.hs` still carries
   `SetLastSettle Qty`, and §4's listing (verbatim from the reference) shows `Qty`. §8 is coherent
   as a declared discipline layer over §4, but full doc↔reference consistency needs `sec04` and the
   reference updated to carry the basis-refined settle mark. Design decision, not prose.
2. **Missing test witness.** The tip-weld basis-agreement claim now rests on its derivation alone.
   If a property-test oracle is wanted, one must be authored into Appendix B (it would extend the
   catalogue as P24).
