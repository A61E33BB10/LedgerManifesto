# FORMALIS scorecard — Round 7

**Lens:** Correctness preservation (veto). Every invariant, determinism claim, totality
property, condition C1–C12, Pareto forcing reason, F1–F8 risk, and the 7-of-10
unreachable-invariants claim must be present and unweakened versus the checklist and the
original. Any drop or weakening ⇒ F.

**Verdict: A — 93%. No regression. Veto NOT triggered.**

I stake my lens on this: the rewrite preserves every correctness item at full strength, and
where it differs from the original it does so by *increasing* rigor, not by weakening a
claim.

---

## Checklist verification (item by item — all PRESENT, all UNWEAKENED)

### §1 The ruling
Three maps with disciplines (lines 155–159); WalletRegistry sidecar NOT state (166–174);
no W-sector (176–181). PASS.

### §2 Two orthogonal disciplines (C1)
Option accessor None vs Some(flat), both load-bearing in VM-settle / wash-sale / record-date,
never collapsed: C1(a) 284–290. Monotone carrier ⇒ fold/checkpoint-independence: C1(b)
291–294. Orthogonal, both required: 297–298. PASS.

### §3 Conservation at the handler (C2)
"No map layout enforces by types — refinement type on a sum of decimals is not free" (249–252).
Σ_w Δf(w,u)=0 structurally per event class, with the 2-leg, K-leg, VM-fan-out, and **vacuous
zero-holder** base cases, then induction over the stream: C2 254–266. All five handlers named
(Trade, SettleVM, CorporateAction, QISRebalance, MandateAmend). PASS.

### §4 C1–C12 — all twelve survive at full strength
- C1 284–298; C2 254–266; C3 424–428; C4 442–445; C5 473–476; C6 511–514; C7 468–471;
  C8 516–520; C9 483–488; C10 491–493; C11 305–317; C12 355–359. PASS.

### §5 Three keys (home of each datum)
ProductTerms inventory (188), UnitStatus inventory (191), PositionState inventory (196):
all fields from the checklist present (CCP = "clearinghouse"). PASS.

### §6 Four test cases
- Future: distinct CME/ICE units (227–231); UnitStatus settle fields (233); ac with handler
  zero-sum (237, 248–252); first_touch_date NOT state, fold-inconsistency under back-dating
  (272–276); settled rows retained (278–282). PASS.
- Managed account: mandate is a unit, −1/+1/Σ=0 by issuance (326–331); relocation table
  (336–353); not the Dirac u_∅ sentinel (361–366); two mandates two rows (368–373). PASS.
- QIS: five keyings, no two in one map (378–387); placement table (389–407); HWM at
  [w_C,u_QIS], two strategies ⇒ two HWMs (409–413); rebalance atomic (415–435); wind-down,
  rows retained flat (447–451). PASS.
- Untraded: PT present C7, US present+initialised C5 total, PS no rows None C1, WalletRegistry
  unaffected (458–466); lifecycle totality + vacuous Σ=0 + dividend/len(holders) bug class C9
  (478–488); two-track amendment with total testable predicate C8 (495–520). PASS.

### §7 Pareto A–F — every forcing reason preserved in substance
B unique optimum under gate ≥7, dominates A/C/D/F, dominates E (659–661). A weaker all axes,
no shared-observable sector (641–643). C sentinel breaks Σ by fiat (644–645). D fourth sector
economically empty (646–647). E equal correctness, lower testability (no implementation in
available tooling), radically lower simplicity (648–650, 660). F runtime is_universe carve-out,
UnitStatus is the type-level expression F hides (651–657). PASS.

### §8 Why three maps — three independent constraints
(i) distinct per-holder state (569–571); (ii) shared observables (572–575); (iii) two mutation
disciplines (576–579); fourth = empty sector; minimum basis not compromise (582–585). PASS.

### §9 Seven unreachable invariants
P1 (C2+C3), P3 (C1 fold identity), P5 (C11), P6 (C6+C7), P7 (C10+C8), P9 (C4), P10 (C11):
679–704. "No other candidate makes more than three": 706. PASS.

### §10 Quantitative commitments
85–90% / 70–80% / ≥80% Feathers (716–723); |W|=3,|U|=2,depth≤6 ⇒ 10^5–10^6 states,
violators caught at depth 1 (724–726); generator universe finite/enumerable (728–729). PASS.

### §11 Risk register F1–F8
All eight present with mitigations (743–775); F2/F5/F6 require external stakeholders
(779–780). PASS.

### §12 Effect on v10.3
Supersedes lines 1034 and 2287 (588–613); replacement text; additive-then-swap alias
get_unit_state(u) → (product_terms, unit_status), get_unit_state(w,u) → position(w,u). PASS.

### §13 One-sentence answer
825–830, substance intact. PASS.

### Reference note
Python listing replaced by Haskell `reference/StatesHome.hs` (mandated by the checklist).
File present (29.6 KB); verified to encode the three maps, ValidDelta-abstract+validate (C2),
applyDelta all-or-nothing (C3), register/ReRegistration (C10), appendVersion (C6), the
FieldWrite GADT with per-handler constructors WAc:Settle / WAcTrade:Trade / WBalance:Transfer
/ WHwm:FeeCrystallise / WEntryNav:Subscribe (C11), SomeWrite index-erasure (S3), conservation
as monoid identity with mempty empty fold (C2/C9), and documented signals S1–S4. PASS.

---

## Changes from the original that I scrutinised — each is a REFINEMENT, not a weakening

1. **C3 scoped to a single unit + per-unit composition (424–435).** The original spoke of a
   single "atomic StateDelta" spanning several units (rebalance) and a single re-subscription
   StateDelta moving (w,u_old)→(w,u_new) "preserving Σ_w" — which cannot satisfy *per-unit*
   conservation cleanly across two distinct units. v2 fixes this: one validated StateDelta per
   unit, grouped all-or-nothing as a single fold; breaking-amendment holder movement is a
   *separate paired-issuance* event (burn on u_old, mint on u_new, each conserving on its own
   unit). Atomicity across the three maps and across the multi-unit group is preserved
   (lines 422, 434). This strengthens C2/C3 coherence. Not a weakening.

2. **"Unrepresentable" given a precise definition (668–676) with signal S4.** The original
   blanket-called all seven "structurally unreachable" while P1's mechanism (handler check)
   is value-level. v2 keeps the count at 7 and the per-invariant discharge identical, but
   states honestly that conservation is a value-level smart-constructor check, not a pure type
   fact. The illegal state (an unconserved delta reaching applyDelta) remains unreachable.
   Candor improvement, claim intact.

3. **C11 "canonical writer set" + S3 erasure (305–317).** The original said "unique handler"
   yet its own example was "ac→settle/trade" (two writers). v2 resolves the contradiction with
   "closed set of field-writers", separates field-writers from event classes, and flags that
   the GADT index is erased at the stored row so the guarantee binds at authorship. P10 intact.

4. **`balance` second conserved field (notation 122–127; 203–205; C11).** An *addition*, not a
   removal: it exercises the per-field-writer discipline with a writer (transfer) distinct from
   ac's, and is explicitly fenced off as non-economic, non-h. It strengthens the C11/P10
   demonstration and weakens nothing.

5. Dropped *labels* only (no correctness content): "Dirac"/"Grothendieck"/"Minsky
   denormalisation trap"/"Karpathy substitution"/the tie-break attribution. In each case the
   underlying forcing argument is stated in plain words. Acceptable under the clarity mandate.

---

## Conclusion
Correctness is fully preserved and, in three places, made more rigorous. The conditions are
introduced where forced and indexed once; the type-vs-value boundary is stated honestly via
S1–S4; the reference backs every structural claim. A competent quant engineer who has not read
the review rounds can follow it in one careful pass, and nothing in my domain is cryptic or
cuttable without loss. **Grade A, 93%.**
