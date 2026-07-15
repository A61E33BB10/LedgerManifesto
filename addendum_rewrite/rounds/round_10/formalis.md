# FORMALIS scorecard — Round 10

**Lens:** Correctness preservation (veto). Every invariant, determinism claim, totality
property, condition C1–C12, Pareto forcing reason, F1–F8 risk, and the
7-of-10-unreachable-invariants claim in `CORRECTNESS_CHECKLIST.md` must remain present and
unweakened in `addendum_stateshome_v2.tex`. Any drop or weakening ⇒ F.

**Grade: A (93%).** No regressions. Every checklist item is present and at least as strong.
The deltas from the original are principled *strengthenings*, not weakenings; I stake the
correctness veto on it.

---

## Line-by-line verification of the checklist

### §1 The ruling
Three maps with disciplines (v2 156–158): ProductTerms immutable/append-only/versioned/reg-total;
UnitStatus mutable/shared/reg-total; PositionState per-(holder,unit)/monotone/Option. ✓
WalletRegistry sidecar NOT state (169–174). ✓ No W-sector (176–181). ✓

### §2 C1 — two orthogonal disciplines
Option accessor: None vs Some(flat) never collapsed, both load-bearing (VM-settle, wash-sale,
record-date) (284–290). ✓ Monotone carrier ⇒ fold identity, stable key set (291–294). ✓
Explicitly orthogonal, both required (297–298). ✓

### §3 / C2 — conservation at the handler
"No map layout enforces by types … refinement type on a sum of decimals is not free"
(250–252). ✓ Per-class structural zero-sum over Trade/SettleVM/CorporateAction/QISRebalance/
MandateAmend, with the 2-leg, K-leg, VM-fan-out, and **vacuous zero-holder** proof cases, then
induction over the stream (254–266). ✓

### §4 C1–C12 — all twelve, each as strong
- C1 (284–295) ✓  C2 (254–266) ✓  C3 (424–428) ✓  C4 (442–445) ✓
- C5 (473–476) ✓  C6 (511–514) ✓  C7 (468–471) ✓  C8 (516–520) ✓
- C9 (483–488), incl. the `dividend/len(holders)` bug class excluded ✓
- C10 (491–493) ✓  C11 (305–317) ✓  C12 (355–359) ✓

C11 note: the original's loose "the unique handler" (already a *set*, since ac→settle/trade)
is sharpened to "canonical writer set … the closed set of field-writers," with the
field-writer axis explicitly distinguished from the C2 event-class axis. The guarantee
("a write by any field-writer outside the set is a type error at authorship") is preserved
and made precise. Strengthening, not weakening.

### §5 Three keys — home of each datum
ProductTerms / UnitStatus / PositionState inventories (184–201) match the checklist field-for-
field. `balance` is an *added* demonstrative conserved field, explicitly fenced off as "neither
the framework holding nor an economic datum of the inventory" (124–127, 203–205) — no economic
field added or moved. ✓

### §6 Four instruments — all resolutions preserved
- **Future**: CME vs ICE distinct units (230); UnitStatus settle fields (233); ac→PositionState
  with handler zero-sum (248–252); `first_touch_date` NOT state, fold-inconsistency under
  back-dating (272–276); settled rows retained (278–282). ✓
- **Managed account**: mandate is a unit, −1/+1/Σ=0 by issuance (327–331); full relocation
  table incl. sub/redemption cursor and benchmark-NAV-at-inception (336–353); not the Dirac
  sentinel, real issuer/holder/partner (361–366); two mandates ⇒ two rows (368–373). ✓
- **QIS**: five keyings, no two in one map (381–387); terms/state/futures/per-client/overlay
  homes (389–407); HWM at PositionState[w_C,u_QIS], tie "two strategies ⇒ two HWMs" (409–413);
  rebalance atomic (415–435); wind-down CLOSED propagates, rows retained flat (447–451). ✓
- **Untraded**: PT present C7; US present+initialised C5, total; PS None until first touch C1;
  WalletRegistry unaffected (458–476); LISTED→ACTIVE→EXPIRED via UnitStatus with zero rows,
  vacuous Σ=0 C9 (478–488); C10 (491–493); two-track C8 with the total predicate (495–520). ✓

### §7 Pareto A–F — every forcing reason preserved
B unique Pareto-optimum under gate ≥7, strictly dominates A/C/D/F, dominates E (659–661). ✓
A weaker-on-all + the mutation-discipline-collapse reason (642–643). ✓
C sentinel: no issuer/no partner, breaks Σ by fiat (644–645). ✓
D fourth sector economically empty, collapses to (w,u_MA) (646–647). ✓
E equal correctness, no tooling, radically less simple (648–650, scores 8/9/2 preserved). ✓
F universe wallet ⇒ runtime `is_universe` predicate, conservation carve-out not a rule,
UnitStatus is the type-level expression F hides (651–657). ✓
The "Dirac/Minsky/Grothendieck" *labels* are dropped; every *correctness forcing reason*
they carried is preserved verbatim in substance. Label loss is not a correctness loss.
Reframing E as "state indexed only over the held set {(w,u):position=Some}" is a faithful
rendering of "sheaf on H_t ⊆ W×U" — clearer, same scores, same forcing reason.

### §8 Why exactly three maps — three forcing constraints
(i) distinct per-holder state ⇒ PositionState; (ii) shared observables ⇒ UnitStatus;
(iii) two mutation disciplines ⇒ ProductTerms; remove any breaks one, a fourth is empty;
minimum basis not compromise (568–585). ✓

### §9 Seven of ten invariants unreachable
Same set, same count: P1, P3, P5, P6, P7, P9, P10 (678–710). ✓ "No other candidate design
makes more than three" (712). ✓
The reframe "structurally unreachable" → "unrepresentable, in this precise sense" with the
explicit caveat that conservation is a **value-level** check (signal S4) is *honesty about a
mechanism that was always value-level* (C2 was always a handler check). The unreachability of
"applied an unconserved delta" is still delivered structurally (ValidDelta abstract; only
constructor `validate`). The claim is intact; the overclaim is removed. P3 is stated as the
Kleisli/fold homomorphism `replay (xs<>ys) = replay xs >=> replay ys` — the same determinism
claim, proved rather than asserted. Strengthening.

### §10 Quantitative commitments
85–90% / 70–80% / ≥80% Feathers (722–729); |W|=3,|U|=2,depth≤6 ⇒ 10^5–10^6 states,
conservation violations at depth 1 (730–731); generator universe finite/enumerable (734–735). ✓

### §11 Risk register F1–F8
All eight present with mitigations (749–783); F2/F5/F6 require external stakeholders before
code ships (785). ✓

### §12 Effect on v10.3
Supersedes line 1034 and 2287 (abstract 60–61; §588); replacement text (601–609);
additive-then-swap, get_unit_state alias to the (product_terms,unit_status) pair, and
get_unit_state(w,u)→position(w,u) (611–613). ✓

### §13 One-sentence answer
Preserved in substance (834–839). ✓

### Reference note (Haskell)
`reference/StatesHome.hs` present, included verbatim, and faithful to every v2 claim:
abstract `Ledger`/`ValidDelta`/`ProductTerms`; `validate` the sole `ValidDelta` constructor
(C2/P1); monotone-by-absence-of-deleter (C1b); `position` returns Maybe (C1a); NonEmpty terms
(C6/C7); `register` rejects re-registration (C10) and writes PT+US together (PT⇔US invariant);
two-track `amend` (C8); `FieldWrite h` GADT + `settleHandler`/`erase` live authorship→erasure
(C11/S3); exact `Integer` minor units (determinism/conservation arithmetic). Signals S1–S4
record the per-unit conservation / paired-issuance / capability / value-level-check boundaries.
Could not compile (no GHC in env), but the source is internally consistent and total by
inspection.

---

## On the one model refinement (C3 / rebalance / re-subscription)

The original spoke of "one atomic StateDelta over UnitStatus + PositionState" for a rebalance
and "an atomic re-subscription StateDelta that moves (w,u_old)→(w,u_new)". v2 fixes a latent
imprecision: conservation Σ_w Δf is inherently **per unit**, and a rebalance / re-subscription
spans *different* units (u_QIS vs u_ES/NQ/YM; u_old vs u_new). v2 therefore makes a StateDelta
single-unit (still atomic across all three maps — C3 unchanged), and renders cross-unit events
as a *group* of per-unit deltas "applied together, all-or-nothing as a single fold" (432–435,
501–504; Haskell S1, foldM semantics discard the threaded intermediate on Left). The atomicity
and conservation guarantees are fully preserved; the conservation law is now correctly stated
per unit. This is the *more* correct formulation, and is precisely the kind of made-explicit
reasoning the lens rewards. Not a regression.

## Verdict
Correctness fully preserved and, in three places (per-unit conservation, value-level-check
honesty, Kleisli replay law), made more rigorous. Nothing dropped, nothing weakened. Clear to
a competent quant engineer in one pass within my domain. **A, 93%. Veto not triggered.**
