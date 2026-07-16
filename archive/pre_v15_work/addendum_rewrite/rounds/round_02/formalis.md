# FORMALIS scorecard — Round 2 — `addendum_stateshome_v2.tex`

Lens: CORRECTNESS PRESERVATION (veto). Every invariant, determinism claim, totality
property, condition C1–C12, Pareto forcing reason, F1–F8 risk, and the 7-of-10
unreachable-invariants claim must survive, present and unweakened. Verified item-by-item
against `CORRECTNESS_CHECKLIST.md` and `_original_addendum.tex`.

**Grade: A (93%). No regression. Several items strengthened without weakening any.**
I stake my lens on this.

## Verification table (checklist → v2 location)

| Checklist item | v2 location | Verdict |
|---|---|---|
| §1 three maps + disciplines | 152–156 | preserved |
| §1 WalletRegistry sidecar NOT state (KYC/perms/audit cursor) | 163–171 | preserved |
| §1 no WalletState / W-sector empty | 172–178 | preserved |
| §2 C1(a) None vs Some(flat), both load-bearing, never collapsed | 277–283 | preserved |
| §2 C1(b) monotone carrier ⇒ fold, checkpoint-indep, single-pass conservation | 284–288 | preserved |
| §2 orthogonal, both required | 290–291 | preserved |
| §3 conservation at handler, not types; refinement not free | 242–245 | preserved |
| §3 C2 2-leg/K-leg/VM-fan-out/vacuous + induction | 247–263 | preserved |
| §4 C1–C12, each as strong | see below | all 12 preserved |
| §5 three keys, home-of-each-datum | 180–198 | preserved |
| §6 Future (4 sub-facts incl. first_touch NOT state, monotone retain) | 211–296 | preserved |
| §6 Managed account (issuance, relocation table, not-Dirac, multi-mandate) | 311–365 | preserved |
| §6 QIS (5 keyings, HWM placement, atomic rebalance, wind-down) | 367–443 | preserved |
| §6 Untraded (PT/US present, PS None, C5/C7/C9/C8/C10) | 445–512 | preserved |
| §7 Pareto A–F forcing reasons + B unique-optimum ≥7 | 607–653 | preserved |
| §8 three forcing constraints (i)–(iii), min-basis | 552–577 | preserved |
| §9 P1/P3/P5/P6/P7/P9/P10 + "no other exceeds 3" | 655–694 | preserved |
| §10 mutation 85–90/70–80/≥80, TLC 10^5–10^6 depth-1, finite generator | 700–717 | preserved |
| §11 F1–F8 with mitigations; F2/F5/F6 external | 720–768 | preserved |
| §12 supersede line 1034 + 2287, additive-then-swap alias | 580–605 | preserved |
| §13 one-sentence answer | 813–818 | preserved |
| Ref note: Haskell, total, illegal states unrepresentable | `reference/StatesHome.hs` | verified present + consistent |

### C1–C12 spot-check
- C1 277–288; C2 247–259; C3 416–420; C4 434–437; C5 465–468; C6 503–506; C7 460–463;
  C8 508–512; C9 475–480; C10 483–485; C11 298–309; C12 347–351. All present, each at full
  strength, indexed in the conditions table 522–550.

### Reference (`StatesHome.hs`) — claims discharged, not asserted
- `Ledger` abstract, no PS deleter exported ⇒ monotone half of C1(b) by absence (51, 297–306).
- `position :: ... -> Maybe PositionState` ⇒ Option half of C1(a) (387–388).
- `ValidDelta` abstract, sole constructor `validate` discharging a monoid identity ⇒ C2;
  empty fold = `mempty` ⇒ C9 with no special case (278–294).
- `ProductTerms` abstract over `NonEmpty`, only `register`/`appendVersion` ⇒ C6/C7 (107–118).
- `FieldWrite (h :: Handler)` GADT = C11 field→writer table; wrong-handler write is a type
  error at authorship; index erased via `SomeWrite` (S3) (196–219, 436–443).
- `applyDelta` returns whole ledger or `Left` ⇒ C3; `register` rejects re-registration with
  `ReRegistration` ⇒ C10; PT and US written together ⇒ PT⇔US registration invariant (325–366).
- `amend` two-track, Breaking never rewrites old terms ⇒ C8/P7 (413–434).
- Exact `Integer` minor units (not Float) — determinism/conservation as arithmetic facts.
- Signals S1–S4 present and match the document's in-text references.

## Strengthenings (correctness improved, nothing weakened)
1. **P1 honesty.** v2 (660–668, 674) states "unrepresentable" precisely and flags that
   conservation is a *value-level* check (S4), not a type fact. The original over-claimed
   "the system cannot express the illegal state." The count (7 of 10) is preserved; the
   mechanism is now accurate. FORMALIS endorses this.
2. **P3 determinism.** Restated as the Kleisli law `replay (xs<>ys) = replay xs >=> replay ys`
   in the `Either LedgerError` Kleisli category (675–678), which correctly accounts for
   failure; the original `apply_all` concatenation identity ignored the error monad. Matches
   `replay` in the reference. Plain-English consequence retained alongside.
3. **Breaking-amendment mechanism.** Original described "an atomic re-subscription StateDelta
   that moves (w,u_old)→(w,u_new)" — which contradicts C3's single-unit StateDelta scope. v2
   reframes as a separate paired-issuance event (burn on u_old, mint on u_new, each conserving
   on its own unit, applied together) (491–496, S1). This removes a latent contradiction;
   conservation is preserved per unit and atomicity preserved across the pair.
4. **Rebalance atomicity** likewise reframed as one StateDelta per unit composed all-or-nothing
   (407–427) — consistent with single-unit C3, atomicity preserved ("a reader must never
   observe one applied and another not").
5. **Forcing reason for A** now stated explicitly (633–635); the original gave A only a score.

## Non-issues examined and cleared
- C1 "Some(zero)" → "Some(p), p flat" with the note that a flat row may retain a
  non-conserved field (hwm/entry_nav): a precision fix consistent with the reference
  ("held-and-flat means psAc=psBalance=0"); the None-vs-Some distinction is intact. Not a
  weakening.
- Design E reframed from "Grothendieck sheaf on H_t" to "state indexed only over the held
  set {(w,u):position=Some}" — same object, plainer words; all three sub-claims of the forcing
  reason survive (equal correctness, lower testability / no tooling, radically lower
  simplicity; domination line 652). Forcing reason preserved in substance.
- `balance` added as a second conserved field (C11 balance→transfer) — an addition under the
  checklist's "…", consistent with the reference FIELD table; nothing removed.
- Iteration log / 27-round count / agent-name attributions dropped: none is a checklist
  correctness item. The HWM tie-break *resolution* (two strategies ⇒ two HWMs, HWM at
  PositionState[w_C,u_QIS]) survives in substance (401–405); only the attribution is gone.
  Provenance ("fixed point of adversarial multi-agent review") retained (612, 826–827).
  Removing the log improves clarity for the stated target reader.

## Blocking issues
None.

## Clarity (my domain)
Notation fixed once up front (§Notation); each condition stated once at its forcing
instrument and indexed; the categorical vocabulary (monoid identity, group homomorphism,
Kleisli fold) is standard in the verification domain and is each time paired with a
plain-English consequence, so it is not cryptic. Nothing in the correctness content is
cuttable without loss.
