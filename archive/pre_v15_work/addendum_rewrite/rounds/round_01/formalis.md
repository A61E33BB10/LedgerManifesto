# FORMALIS — Round 1 scorecard

**Document under review:** `addendum_stateshome_v2.tex`
**Against:** `CORRECTNESS_CHECKLIST.md`, `_original_addendum.tex`
**Lens:** correctness preservation (veto). Every invariant, determinism/totality claim,
condition C1–C12, Pareto forcing reason, F1–F8 risk, and the 7-unreachable-invariants claim
must survive **present and unweakened**.

**Grade: B (86%).** The hard correctness machinery is preserved in full and, in several
places, sharpened. The veto does **not** fire: no invariant, condition, determinism/totality
property, conservation law, Pareto forcing reason, or unreachable-invariant claim is dropped
or weakened. What pulls it below A is a cluster of *enumerated-specificity* losses in the
risk register and the quantitative-commitments section — items the checklist names verbatim
that the rewrite genericized. Each is mechanically restorable and none compromises
correctness, so this is friction, not compromise.

---

## Item-by-item verification (checklist §1–§13)

**§1 Ruling** — PASS. Three maps with full disciplines (§3 lines 145–149); WalletRegistry
sidecar marked NOT state (151–159); no W-sector (161–166).

**§2 C1 two orthogonal disciplines** — PASS. C1(a) None vs Some(0_P) load-bearing across
VM-settle, wash-sale, record-date, never collapsed (259–265); C1(b) monotone carrier, fold
replay, single-pass conservation (266–269); orthogonality + both-required stated (272–273).

**§3 C2 conservation at handler** — PASS. "No map layout enforces by types" (223–227); all
five handlers named; 2-leg, K-leg, VM-fan-out, **and vacuous** base cases; induction over
stream (229–245).

**§4 C1–C12** — PASS, each as strong:
C1 (259–270), C2 (229–241), C3 atomic across all three maps + partial unrepresentable
(389–393), C4 capability-scoped + cross-(w,u_MA) forbidden + exports via UnitStatus
(400–403), C5 (431–434), C6 (467–470), C7 (426–429), C8 total predicate two-track (472–476),
C9 vacuous + dividend/len(holders) bug class (441–446), C10 hard error never silent reset
(449–451), C11 per-field canonical writer + wrong writer = type error (280–285), C12 W-sector
collapse by schema (323–327). Index table (486–514) consistent.

**§5 Three keys** — PASS. Home-of-each-datum table (168–186) carries every field; "CCP"
rendered "clearinghouse" (synonym, no loss).

**§6 Four test cases** — PASS:
- Future: CME/ICE distinct units + replaces line 1168 (202–206); ac→PositionState with
  Σ=0 (223–227); first_touch_date NOT state, fold-inconsistency under back-dated correction
  (247–251); settled rows persist (253–257).
- Managed account: mandate-as-unit, −1/+1/Σ=0 issuance (294–299); full relocation table
  (304–321); not the Dirac/sentinel hack (329–334); two mandates → two rows (336–341).
- QIS: five keyings, no two share a map (346–375); HWM at PositionState[w_C,u_QIS], two
  strategies⇒two HWMs (377–381); rebalance one atomic StateDelta over UnitStatus+PositionState
  (383–393); wind-down CLOSED propagates, rows retained at 0 (405–409).
- Untraded: PT present (C7), US present+default-initialised+total (C5), PS None until first
  touch (C1), WalletRegistry unaffected (416–424); LISTED→ACTIVE→EXPIRED with zero rows,
  vacuous Σ=0 (C9) + dividend/len bug class (436–446); C8 total testable predicate (453–476).

**§7 Pareto A–F + forcing reasons** — PASS. Scores match original exactly
(A 4/5/4, B 9/9/8, C 7/3/7, D 7/7/5, E 8/9/2, F 5/6/6; lines 583–588). Every forcing reason
preserved in words (592–610): A two-discipline collapse; C sentinel breaks Σ=0 by fiat;
D empty fourth sector; E no tooling/low simplicity; F is_universe runtime carve-out =
Minsky denormalisation trap, UnitStatus as type-level expression. B unique Pareto-optimum
under correctness gate ≥7, strictly dominates A/C/D/F, dominates E (612–614).

**§8 Why exactly three maps** — PASS. Three independent constraints (i)/(ii)/(iii) (524–535);
fourth map economically empty; "minimum basis, not a compromise" (538–541).

**§9 Seven unreachable invariants** — PASS. P1, P3, P5, P6, P7, P9, P10 each with the same
discharging conditions; "No other candidate makes more than three unrepresentable" (645).

**§10 Quantitative commitments** — PARTIAL. Numbers preserved (85–90%, 70–80%, ≥80%,
10^5–10^6 at |W|=3,|U|=2,depth≤6, depth-1 catch; lines 654–663). **But** three enumerated
qualifiers were dropped: "(CDM enum × product-type)" from the generator-universe claim,
"Feathers threshold" from the ≥80% line, and "TLC" generalized to "model-checker". See
blocking issues B1, B4.

**§11 F1–F8 risk register** — PARTIAL. All eight risks present with mitigations and the
"F2/F5/F6 need external stakeholders before code ships" gate (716). **But** F5 and F6 had
checklist-named specifics genericized — see blocking issues B2, B3. The *risks themselves*
remain binding and unweakened in scope; what is lost is the enumerated regime/tool naming.

**§12 Effect on v10.3** — PASS. Supersedes line 1034 and 2287; replacement text; additive-
then-swap get_unit_state alias to product_terms ++ unit_status; get_unit_state(w,u) →
position_state(w,u) (543–569).

**§13 One-sentence answer** — PASS (756–768). Substance intact.

**Reference note** — PASS. `reference/StatesHome.hs` exists (573 lines) and backs the prose:
abstract `ValidDelta`/`validate` (C2), `mempty` vacuous fold (C9), `appendVersion` no setter
(C6), `register` ReRegistration (C10), `FieldWrite` GADT (C11), `usSupersededBy` two-track
(C8). Haskell now replaces the original Python listing per the checklist note.

---

## Blocking issues (must be fixed for A)

**B1 — Generator universe lost its enumerated composition.**
Location: §11 Testing Commitments, line 665. Checklist §10 requires "Generator universe
(CDM enum × product-type) is finite and enumerable." The rewrite states only "The generator
universe is finite and enumerable." Restore "(CDM enum × product-type)" so the finiteness
claim is grounded, not asserted.

**B2 — F5 regulatory regimes genericized.**
Location: §13 Risk Register, lines 697–700. Checklist §11 names "F5 mandate-as-unit
SFTR/EMIR reporting surface"; the rewrite says "regulatory reporting surface", and the
mitigation's "UTI / LEI pair" became "a trade and entity identifier pair." Restore SFTR/EMIR
and UTI/LEI — these are the load-bearing, actionable specifics that tell the Regulatory team
which regimes and identifiers to pre-flight.

**B3 — F6 lost the named CDM mapping.**
Location: §13 Risk Register, lines 702–705. Checklist §11 / §6 ties F6 to the concrete
"Rosetta NS1–7" mapping; the rewrite says "Re-run the CDM mapping." Restore the NS1–7
reference so the mitigation names what to re-run.

**B4 — Quantitative qualifiers thinned.**
Location: §11 Testing Commitments, lines 660–662. "Feathers threshold" (the source of the
≥80% gate) and "TLC" (the specific model checker, now "model-checker") were dropped.
Restore both; the checklist enumerates them.

## Non-blocking note
- HWM tie-break attribution ("by correctness-architect + formalis") dropped at §4.3 (377–381).
  Pure provenance, not a correctness claim; substance (two strategies ⇒ two HWMs) is intact.
  No action required on the correctness axis.

---

**Verdict:** correctness fully preserved; veto withheld. Four enumerated-specificity
regressions (B1–B4), all in the risk register / quantitative sections, keep it at B.
Restoring the named regimes, identifiers, tools, and the generator-universe composition
lifts it to A on this lens.
