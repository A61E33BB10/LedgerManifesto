# FORMALIS scorecard — Round 9 — `addendum_stateshome_v2.tex`

Lens: CORRECTNESS PRESERVATION (veto). Every invariant, determinism claim, totality
property, condition C1–C12, Pareto forcing reason, F1–F8 risk, and the 7-unreachable claim
must be present and unweakened. Verified against `CORRECTNESS_CHECKLIST.md` and
`_original_addendum.tex`.

## Grade: A (92%)

No item is dropped. No claim is weakened. Several items are made *more* correct without loss
of strength. I stake my lens on this.

## Checklist verification (all 13 sections + reference note)

**§1 ruling / three maps + sidecar.** PASS. ProductTerms (immutable, append-only, versioned,
reg-total), UnitStatus (mutable, shared, reg-total), PositionState (per-(w,u), monotone,
Option) at L155–159. WalletRegistry NOT-state at L166–174. "No W-sector" at L176–181.

**§2 two orthogonal disciplines (C1).** PASS. None vs Some(flat) both load-bearing
(VM-settle, wash-sale, record-date), never collapsed; monotone carrier ⇒ literal fold ⇒
conservation single pass over stable key set; orthogonality stated (L284–298).

**§3 conservation at handler not storage (C2).** PASS. "No map layout enforces this by
types — a refinement type on a sum of decimals is not free" (L248–252); 2-leg, K-leg,
VM-fan-out, vacuous proofs (L254–266).

**§4 C1–C12.** PASS, each at full strength:
- C1 L284–298; C2 L254–266; C3 L424–428; C4 L442–445; C5 L473–476; C6 L511–514;
  C7 L468–471; C8 L516–520; C9 L483–488; C10 L491–493; C11 L305–317; C12 L355–359.
- C3: across all three maps for one unit; cross-unit atomicity handled by a validated
  per-unit delta group applied as a single all-or-nothing fold (L430–435). This is a
  *correctness strengthening*: per-unit conservation is now well-defined, and the old
  cross-unit "re-subscription StateDelta" (original L260, which silently violated per-unit
  zero-sum) is correctly recast as paired issuance (L501–504, signal S1). Atomic guarantee
  ("reader must never observe one applied and another not", L422) preserved.
- C11: "unique handler" → "canonical writer set". Not a weakening — the checklist's own
  example `ac→settle/trade` already names two writers, so "unique" was never literal; the
  set formulation is the accurate generalization. P10 "type error at authorship" preserved;
  S3 erasure caveat is honesty about where the guarantee binds, not a reduction of it.

**§5 home of each datum.** PASS. Three-key table L184–201 carries every field
(ProductTerms / UnitStatus / PositionState) verbatim in content (CCP = clearinghouse).

**§6 four test cases.** PASS.
- Future: distinct CME/ICE units, ac conserved by handler, first_touch_date NOT state
  (fold-inconsistency under back-dated correction), settled rows retained (L218–303).
- Managed account: mandate IS a unit, ±1 issuance conservation, full relocation table, "not
  the Dirac sentinel", two-mandate two-rows (L319–373).
- QIS: five keyings no-two-in-one-map, HWM at PositionState[w_C,u_QIS] (two strategies ⇒ two
  HWMs), atomic rebalance, wind-down rows retained flat (L375–451).
- Untraded: PT present (C7), US total with defaults (C5), PS None (C1), registry unaffected,
  LISTED→ACTIVE→EXPIRED with zero rows, vacuous Σ=0 (C9), dividend/len(holders) bug class
  excluded, two-track amendment with total predicate (C8) (L453–520).

**§7 Pareto A–F forcing reasons.** PASS. B unique optimum under gate ≥7, strictly dominates
A/C/D/F, dominates E (L659–661). A (two-discipline collapse), C (sentinel breaks Σ by fiat),
D (empty W-sector), E (equal correctness=9, no tooling, radically less simple), F (universe
wallet ⇒ runtime is_universe carve-out, Minsky trap; UnitStatus is the type-level expression
of F's wallet-id convention) all present (L639–657). E's reframing from "Grothendieck sheaf"
to "held set {(w,u): position=Some}" preserves the load-bearing fact (correctness = B) and
the forcing reason; not a correctness change.

**§8 why exactly three (i)(ii)(iii).** PASS. L568–585. Removing any breaks one; fourth is
economically empty; minimum basis, not compromise.

**§9 seven unreachable (P1,P3,P5,P6,P7,P9,P10).** PASS. All seven named with mechanism and
discharging conditions (L678–704); "no other candidate exceeds 3" (L706). The retitle
"structurally unreachable" → "unrepresentable" with the precise smart-constructor sense, and
the explicit honesty that conservation is value-level (P1/S4), capability-layer (P9/S2), and
authorship-then-erased (P10/S3), is NOT a weakening: the guarantee (an unconserved delta
cannot reach applyDelta; etc.) is identical, the count is identical, and the framing now
agrees with C2/§3 (which always said conservation is not a type fact) and with the
checklist's own reference note ("conservation-checked StateDelta", "value-level"). P3 is
strengthened with the actual fold-homomorphism law `replay (xs<>ys) = replay xs >=> replay
ys` (L683–690), with `>=>` glossed in plain words.

**§10 quantitative commitments.** PASS. 85–90% / 70–80% / ≥80% Feathers; |W|=3,|U|=2,depth≤6
⇒ 10^5–10^6 states TLC-tractable, violations caught at depth 1; generator universe finite
(L716–729).

**§11 F1–F8.** PASS. All eight with mitigations (L743–775); F2/F5/F6 require external
stakeholders (L779).

**§12 effect on v10.3.** PASS. Supersedes line 1034 and 2287; additive-then-swap
get_unit_state alias (L588–613).

**§13 one-sentence answer.** PASS. Substance preserved (L828–833).

**Reference note (Haskell).** PASS. `reference/StatesHome.hs` (598 lines): three maps with
accessors; C1 Option (`position :: Maybe`) + monotone (no deleter exported, applyDelta
insert/update only); C2/C3 abstract `ValidDelta` with sole constructor `validate`, atomic
`applyDelta`; C6/C8 abstract `ProductTerms` over `NonEmpty`, `amend` two-track; C10
`ReRegistration` hard Left; totality (only `expect*` demo glue is partial, fenced); exact
`Integer` minor units (deviation from Python float, a correctness improvement). Document §17
prose (L805–812) matches the file exactly (settleHandler, erase = fmap (map SomeWrite),
FieldWrite 'Settle, _c11_bad). Could not mechanically typecheck (GHC absent) but well-typed
by inspection.

## Non-blocking observations (do not affect grade)
- The demonstrative `balance` conserved field is an *addition* (not in original), but it is
  carefully fenced as non-economic / non-h(w,u) / not in the schema inventory (L122–127,
  203–205) and exists to exercise C11 with a writer distinct from `ac`. Defensible; no
  correctness item is touched.
- The S3 erasure caveat is stated three times (C11, P10, §17). Each serves a distinct role;
  acceptable, marginally above the "state once" convention.

## Verdict
Nothing dropped, nothing weakened; multiple honest strengthenings. Reaches the A bar for the
correctness lens. No veto.
