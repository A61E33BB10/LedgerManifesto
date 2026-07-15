# FORMALIS scorecard — Round 6 — `addendum_stateshome_v2.tex`

Lens: **CORRECTNESS PRESERVATION (veto).** Every invariant, determinism claim, totality
property, C1–C12, Pareto forcing reason, F1–F8 risk, and the 7-of-10-unreachable claim must
survive present and unweakened. Verdict: **no regression. Veto NOT triggered.**

## Grade: A (92%)

## Method
Walked all 13 sections of `CORRECTNESS_CHECKLIST.md` against v2, and cross-checked every claim
v2 makes about `reference/StatesHome.hs` against the actual source (the file exists, 574 lines,
and backs each cited guarantee).

## Item-by-item (checklist → v2 location, status)

**§1 Ruling / three maps + sidecar.** PT immutable/append-only/versioned/reg-total (L156),
UnitStatus mutable/shared/reg-total (L157), PositionState per-(w,u)/monotone/Option (L158),
WalletRegistry NOT state (L169), W-sector empty and not built (L176–181). PRESENT.

**§2 Two orthogonal disciplines (C1).** Option None vs Some(zero) both load-bearing and
non-collapsible (L284–290); monotone carrier (L291–294); orthogonal, both required (L297–298).
PRESENT.

**§3 Conservation at the handler (C2).** No type-level layout (L250–252); per-event-class
zero-sum with 2-leg, K-leg, VM-fan-out, and vacuous base cases + induction (L254–266). PRESENT.

**§4 C1–C12.** All twelve present and each as strong:
C1 L284, C2 L254, C3 L424, C4 L442, C5 L473, C6 L511, C7 L468, C8 L516, C9 L483, C10 L491,
C11 L305, C12 L355. PRESENT.

**§5 Three keys / home of each datum.** ProductTerms inventory L188–189 (CCP = clearinghouse),
UnitStatus L191–194, PositionState L196–199. PRESENT.

**§6 Four test cases.** Future (distinct CME/ICE units, ac conserved, first_touch_date NOT
state with fold-inconsistency argument, settled rows retained) L218–317; Managed account
(mandate-as-unit issuance −1/+1, relocation table, not-the-Dirac-hack, two mandates two rows)
L319–373; QIS (five keyings no-shared-map, HWM at PS[w_C,u_QIS] with two-strategies-two-HWMs
tie-break, rebalance atomic, wind-down rows retained) L375–451; Untraded (PT/US present, US
total, PS None, lifecycle via US, vacuous C9, dividend/len bug class, C8 total testable
predicate) L453–520. PRESENT.

**§7 Pareto A–F forcing reasons.** B unique optimum under gate ≥7, dominates A/C/D/F, dominates
E (L659–661); per-design forcing reasons stated in words (L641–657). PRESENT.

**§8 Why exactly three.** (i)/(ii)/(iii) forcing constraints + fourth-map-empty + minimum-basis
(L568–585). PRESENT.

**§9 Seven unreachable invariants.** P1 (C2+C3), P3 (C1 fold identity), P5 (C11), P6 (C6+C7),
P7 (C10+C8), P9 (C4), P10 (C11), and "no other candidate exceeds 3" (L678–706). PRESENT.

**§10 Quantitative commitments.** 85–90% / 70–80% / ≥80% Feathers; |W|=3,|U|=2,depth≤6 →
10^5–10^6 TLC-tractable, violations at depth 1; finite enumerable generator universe
(L716–729). NUMBERS UNCHANGED.

**§11 Risk register F1–F8.** All eight with mitigations (L743–775); F2/F5/F6 gated on external
stakeholders (L779). PRESENT.

**§12 Effect on v10.3.** Supersedes lines 1034 and 2287; replacement text; additive-then-swap
get_unit_state deprecation (L588–613). PRESENT.

**§13 One-sentence answer.** Substance preserved (L825–830). PRESENT.

**Reference note (Haskell).** `reference/StatesHome.hs` present; encodes three maps with
accessors, C1 (Maybe + no deleter), C2/C3 (abstract ValidDelta + atomic applyDelta), C6/C7
(NonEmpty + register/appendVersion), C8 (amend two-track), C10 (ReRegistration), C11
(FieldWrite GADT + _c11 ok/bad), C9 (empty fold = mempty). Every guarantee the .tex attributes
to it (L794–816) is borne out by the source.

## Three places v2 is MORE correct than the original (not weaker)
1. **Multi-unit rebalance / breaking-amendment move.** The original claimed a *single* atomic
   StateDelta spanning UnitStatus + PositionState rows on *different* units — internally
   inconsistent with C3 ("single unit"). v2 resolves it as one StateDelta per unit applied as
   an all-or-nothing group fold (L420–435, L499–504, reference signal S1). Atomicity and
   conservation are preserved; the inconsistency is removed. Correctness improvement.
2. **Exact arithmetic.** Reference uses `Integer` minor units, not `float` (original Python).
   Determinism and conservation become arithmetic facts. Strengthening.
3. **C11 enforcement.** Original Python carried a runtime `FIELD_SPEC` string tag; v2's GADT
   makes the wrong-writer case a genuine type error at authorship (L305–317, reference
   `_c11_bad`). The "erased at the row (S3)" qualifier is honest scoping, not a weakening — the
   "type error" claim of P10 survives and is in fact realized more strongly than before.

The "unrepresentable vs structurally-unreachable" reframing (L668–676) keeps the count at 7 and
every per-invariant condition attribution; it adds the honest note that P1's conservation is a
value-level smart-constructor check (signal S4). The unreachability claim ("an unconserved delta
cannot reach applyDelta") is preserved. This is increased rigor, endorsed by the checklist's own
"record/escalate awkwardness" note — not a regression.

## Non-blocking observations (do not affect grade)
- The F forcing reason drops the literal label "Minsky denormalisation trap" (L651–657) but
  keeps its full substance ("a carve-out, not a rule"). The forcing reason is the carve-out, not
  the name; substance preserved.
- The demonstrative `balance` conserved field adds some cognitive load (must be tracked as
  NOT-economic-state in notation L122–127, answer L203–205, C11 L307); it is carefully fenced
  and justified (a second *conserved* field with a distinct canonical writer to exercise C11).
  Defensible; near the edge of "cuttable without loss" but not a correctness matter.
- C11's "erased once writes share one delta row" phrasing (L311) is slightly cryptic for a
  reader new to type erasure, but is cross-referenced to signal S3 which explains it fully.

## Conclusion
Every correctness obligation on the checklist is present and unweakened; several are tightened.
No invariant, determinism claim, totality property, condition, forcing reason, risk, or the
7/10 claim was dropped or softened. I stake my lens: the FORMALIS veto is not triggered. A (92%).
