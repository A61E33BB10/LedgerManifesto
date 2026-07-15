# FORMALIS scorecard — Round 3 — `addendum_stateshome_v2.tex`

Lens: CORRECTNESS PRESERVATION (veto). Every invariant, determinism claim, totality
property, condition C1–C12, Pareto forcing reason, F1–F8 risk, and the 7-of-10
unreachable-invariants claim must survive, present and unweakened. Re-verified
item-by-item against `CORRECTNESS_CHECKLIST.md`, `_original_addendum.tex`, and the
reference `reference/StatesHome.hs`.

**Grade: A (93%). No regression from original; no weakening since Round 2. I stake my lens on it.**

## Verification table (checklist → v2 location)

| Checklist item | v2 location | Verdict |
|---|---|---|
| §1 three maps + totality/mutation disciplines | 155–159 | preserved |
| §1 WalletRegistry sidecar NOT state (KYC/perms/audit cursor) | 166–174 | preserved |
| §1 no WalletState / W-sector empty of economic state | 176–181 | preserved |
| §2 C1(a) None vs Some(flat), both load-bearing, never collapsed | 284–290 | preserved |
| §2 C1(b) monotone ⇒ literal fold, checkpoint-indep, single-pass conservation | 291–298 | preserved |
| §2 orthogonality, both required | 282, 297–298 | preserved |
| §3 conservation at handler not types; refinement types not free | 248–252 | preserved |
| §3 C2 2-leg/K-leg/VM-fan-out/vacuous + induction | 254–270 | preserved |
| §4 C1–C12, each as strong | see below | all 12 preserved |
| §5 three keys, home-of-each-datum (CCP=clearinghouse) | 184–201 | preserved |
| §6 Future: distinct units, first_touch NOT state, Σac=0, monotone retain | 218–303 | preserved |
| §6 Managed account: issuance −1/+1/Σ=0, relocation table, not-Dirac, multi-mandate | 318–372 | preserved |
| §6 QIS: 5 keyings no two same map, HWM at PS[w_C,u_QIS], atomic rebalance, wind-down | 374–450 | preserved |
| §6 Untraded: PT/US present, US total, PS None, C5/C7/C9/C10/C8, dividend/len bug | 452–519 | preserved |
| §7 Pareto A–F forcing reasons + B unique-optimum ≥7, dominates E | 619–660 | preserved |
| §8 three forcing constraints (i)–(iii), min-basis, fourth empty | 559–584 | preserved |
| §9 P1/P3/P5/P6/P7/P9/P10 + "no other exceeds 3" | 663–704 | preserved |
| §10 mutation 85–90 / 70–80 / ≥80 Feathers; TLC 10^5–10^6 depth-1; finite generator | 707–727 | preserved |
| §11 F1–F8 with mitigations; F2/F5/F6 external | 730–778 | preserved |
| §12 supersede line 1034 + 2287, additive-then-swap get_unit_state alias | 587–612 | preserved |
| §13 one-sentence answer | 819–831 | preserved |
| Ref note: Haskell, total, illegal states unrepresentable, 3 maps+C1/C2/C3/C6/C8/C10 | `StatesHome.hs` | verified present + consistent |

### C1–C12 spot-check (each stated once, full strength, indexed at 529–557)
C1 284–298; C2 254–266; C3 423–427; C4 441–444; C5 472–475; C6 510–513; C7 467–470;
C8 515–519; C9 482–487; C10 490–492; C11 305–316; C12 354–358. All present, none weakened.

### Reference (`StatesHome.hs`) — claims discharged, not asserted
- `Ledger` abstract, no PS deleter exported ⇒ monotone half C1(b) by absence (17, 51, 297).
- `position :: ... -> Maybe PositionState` ⇒ Option half C1(a) (387).
- `ValidDelta` abstract, sole constructor `validate` discharging a monoid identity ⇒ C2;
  empty fold = `mempty` ⇒ C9 with no special case (278–294).
- `ProductTerms` abstract over `NonEmpty`, only `register`/`appendVersion` ⇒ C6/C7 (107–118).
- `FieldWrite (h::Handler)` GADT = C11 field→writer table; wrong-handler write fails to
  typecheck at authorship (`_c11_ok_*`, commented `_c11_bad`); index erased via `SomeWrite` (S3) (196–219, 436–443).
- `applyDelta` returns whole ledger or `Left` ⇒ C3; `register` rejects re-registration with
  `ReRegistration` ⇒ C10; PT+US written together ⇒ PT⇔US registration invariant (325–366).
- `amend` two-track; Breaking never rewrites old terms ⇒ C8/P7 (413–434).
- Exact `Integer` minor units (not Float) ⇒ determinism/conservation as arithmetic facts.
- Signals S1–S4 present (448–484) and match every in-text reference in the .tex.

## Judgment calls examined (each cleared as a refinement, not a weakening)
1. **C3 reframed per-unit.** v2 defines `StateDelta` for a *single* unit (conservation
   Σ_w Δf(w,u)=0 is per-u and only checkable per-u), and composes multi-unit events
   (rebalance; breaking-amendment re-subscription) as a group of per-unit deltas applied
   all-or-nothing as one fold. Atomicity is explicitly preserved ("a reader must never
   observe one applied and another not", 420–421; 432–434, S1). The original's
   "one StateDelta spanning three maps across units" was imprecise; v2 removes a latent
   contradiction without dropping atomicity. Not a weakening.
2. **P1/P10 honesty caveat.** v2 states "unrepresentable" precisely: the smart-constructor
   pattern (`ValidDelta` abstract, only `validate`) makes the unconserved delta *unable to
   reach* `applyDelta`; conservation is a value-level check (S4), not a type fact — which is
   the original's own C2 admission. The 7-of-10 count and every per-invariant discharge
   (C2+C3, C1, C11, C6+C7, C10+C8, C4) are preserved verbatim. More accurate, not weaker.
3. **P3 as Kleisli law** `replay (xs<>ys) = replay xs >=> replay ys` in `Either LedgerError`
   (684–688) — accounts for failure the original `apply_all` concatenation ignored; matches
   `replay` in the reference. Plain-English checkpoint-independence retained.
4. **C11 field-writer vs event-class** distinction (305–316) is a clarification; the unique
   canonical writer per field is intact and now backed by the GADT.
5. **`balance`** added as a second conserved field (C11 balance→transfer) — an addition under
   the checklist C11 "…", consistent with the reference; nothing removed. Explicitly flagged
   as non-economic/demonstrative (203–205) so the §Answer datum inventory is unpolluted.

## Non-correctness drops (allowed; not checklist items)
Iteration log, 27-round count, and agent-name attributions are gone; the HWM tie-break
*resolution* (two strategies ⇒ two HWMs at PS[w_C,u_QIS]) survives in substance (408–412),
and provenance ("fixed point of adversarial multi-agent review") is retained (619, 836).

## Blocking issues
None.

## Clarity (my domain)
Notation fixed once up front; each condition stated once at its forcing instrument and
indexed; categorical vocabulary (monoid identity, group homomorphism, Kleisli fold) is each
paired with a plain-English consequence, so nothing is cryptic to a competent quant engineer.
Signals S1–S4 are referenced in-text and defined in the appendix. Nothing in the correctness
content is cuttable without loss.
