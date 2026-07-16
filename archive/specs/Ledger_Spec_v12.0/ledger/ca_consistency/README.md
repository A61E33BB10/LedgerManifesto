# Corporate-Action Consistency of Consumed Data — Review Record

Three-phase adversarial review (17 agents). Canonical deliverable is the spec section
`../drafts/sec_basis.tex` (STYLUS-authored, FORMALIS-certified, not yet `\input`).

## Outcome
- **Architectural answer: option (i)/synthesis — extend the data, retain the three-home model.**
  A single `usBasis` field is added to home 2 (`UnitStatus`); the observation store is named a
  projection. Enforcement points: `applyTx` with three admission "welds" (tip / invariance /
  same-`t_eff`) and `withSnapshot` at the read seam.
- Mixed-basis valuation made unreachable via a phantom/GADT basis index (`Snapshot b`), with
  `type role ... nominal` on every basis-indexed carrier to close a `coerce` forgery hole found
  in verification. Unreachability argued by parametricity for `F :: forall b. Snapshot b -> r`.
- Failure modes (a) split, (b) dividend, (c) index divisor each structurally excluded with
  worked numbers (100,000 / 102,000 / divisor D').
- Composition order-sensitivity dissolved by a total effective order `(t_eff, prec, bid)`; the
  49-vs-50 split+dividend pair shown to be a non-arrow; undeclared equal-`t_eff` collisions
  fail closed.
- Late-CA notification handled as workflow W1–W4 (pending-transition).
- CDM CA events mapped, pinned to CDM v6.0.0.

## Verification history
Phase-3 verification returned pass=FALSE (NOETHER + FORMALIS): retro-effective boundary could
regress the basis coordinate; `coerce` could forge the phantom crossing; scope-closure of the
joint-basis carrier was ill-defined. A repair pass discharged all three; FORMALIS then CERTIFIED
(all 9 success criteria). See `certification.json`, `verification.json`.

## Page budget
Current document = 155pp; section adds ~12pp -> ~167pp, against the prompt's named sub-100pp
aspiration. FLAGGED as owner's call, not resolved.

## Files
- problem_{thorp,nazarov,noether}.md   — Phase 1 memos
- design_{thorp,nazarov,noether,milewski}.md — Phase 2 designs (isolated)
- objections.md         — Phase 3 adversarial objections (material/stylistic)
- synthesis_design.md   — FORMALIS first synthesis (pre-repair)
- verification.json     — NOETHER + FORMALIS verdicts (pass=false, the 3 findings)
- final_design.md       — repaired converged design (the certified one)
- certification.json    — FORMALIS final certification
- prose_summary.md      — STYLUS's own summary of the drafted section
- ../drafts/sec_basis.tex — THE DELIVERABLE (spec section)
