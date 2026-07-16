# FORMALIS scorecard — Round 5

**Lens:** correctness preservation (veto). Every invariant, determinism claim, totality
property, condition C1–C12, Pareto forcing reason, F1–F8 risk, and the 7-of-10
unreachable-invariants claim must remain present and unweakened in
`addendum_stateshome_v2.tex` versus `_original_addendum.tex` and
`CORRECTNESS_CHECKLIST.md`.

**Grade: A (92%). No correctness regression. Lens staked.**

## Item-by-item verification against the checklist

**§1 The ruling** — three maps with their disciplines (PT immutable/append-only/versioned/reg-total;
US mutable/shared/reg-total; PS per-(holder,unit)/monotone/Option) present verbatim
(v2 L155–159). WalletRegistry sidecar flagged NOT state (L166–174). "No W-sector; every
economic per-wallet fact (w,u_MA)-keyed, collapses into PS; W-sector empty" (L176–181). ✓

**§2 Two orthogonal disciplines (C1)** — Option accessor (None vs Some(zero), both
load-bearing: VM-settle, wash-sale lookback, record-date; never collapsed) and monotone
carrier (never GC, close-out leaves flat row, replay literal fold, conservation single
pass) both present, explicitly called orthogonal and both required (C1 L286–300). ✓

**§3 Conservation at the handler (C2)** — "no map layout enforces by types" + per-event-class
structural zero-sum with 2-leg/K-leg/VM-fan-out/vacuous proofs + induction (L252–268). All
five handler classes named. ✓

**§4 C1–C12** — all twelve present, each as strong:
- C1 ✓ C2 ✓
- C3 atomic across PT/US/PS, partial application unrepresentable (L426–430) ✓
- C4 capability-scoped, cross-(w,u_MA) forbidden, exports via US (L444–447) ✓
- C5 US reg-total, defaults at registration (L475–478) ✓
- C6 PT versioned append-only, no in-place mutation (L513–516) ✓
- C7 PT reg-total, first write at registration (L470–473) ✓
- C8 two-track by total fungibility predicate (L518–522) ✓
- C9 zero-holder vacuous Σ=0, empty case in proof obligation (L485–490) ✓
- C10 re-registration hard error, never silent reset (L493–495) ✓
- C11 per-field canonical writer set; outside-set write is a type error at authorship
  (L307–319). Reworded "unique handler" → "canonical writer set" — NOT a weakening: the
  original example `ac→settle/trade` already named a *set*, and v2 keeps the type-error-at-
  authorship guarantee. The S3 erasure caveat ("binds at authorship, not at stored row") is
  honesty about the Haskell reference, consistent with P10; the guarantee is unchanged. ✓
- C12 all per-(w,mandate/strategy) economic state at PS[w,u_MA]/[w,u_QIS], no flat scalars,
  W-sector empty by schema (L357–361) ✓

**§5 Three keys / home of each datum** — table L184–201 matches (CCP rendered as
"clearinghouse", same datum). PS inventory complete. ✓

**§6 Four test cases** — all resolutions preserved:
- Future: distinct CME/ICE units, US split, ac with Σ=0, first_touch_date NOT state
  (fold-inconsistency under back-dating), settled rows retained (L220–305). ✓
- Managed account: mandate-is-unit issuance law, full relocation table, not-a-sentinel
  argument, two-mandate-two-rows (L321–375). ✓
- QIS: five keyings no two in one map, terms/state/futures/sub split, HWM at PS[w_C,u_QIS]
  (two strategies⇒two HWMs), rebalance atomic, wind-down rows retained (L377–453). ✓
- Untraded: PT present (C7), US present+defaulted total (C5), PS no rows None-until-touch
  (C1), WalletRegistry unaffected, lifecycle totality, vacuous handlers (C9), dividend/
  len(holders) bug class caught, two-track amendment with the total testable predicate
  (L455–522). ✓

**§7 Pareto A–F forcing reasons** — B unique Pareto-optimum under any gate ≥7, strictly
dominates A/C/D/F, dominates E (L661–663). Each per-design forcing reason stated in words
(L641–659): A collapses the two mutation disciplines; C sentinel breaks Σ by fiat; D fourth
sector economically empty; E equal correctness but no tooling and radically less simple; F
re-introduces the split as runtime is_universe(w), conservation must exclude w_* as a
carve-out not a rule, US is the type-level expression of F's wallet-id convention. ✓

**§8 Why exactly three maps** — three independent constraints (i)/(ii)/(iii), removing any
breaks one, a fourth is economically empty, "minimum basis not a compromise" (L562–587). ✓

**§9 Seven unreachable invariants** — P1, P3, P5, P6, P7, P9, P10 all present with mechanism
and discharging conditions (L665–708); "no other candidate exceeds 3" preserved (L708). The
new preamble (L670–678) and the P1 gloss make explicit that conservation is a *value-level*
check via the abstract `ValidDelta`/`validate` smart constructor (signal S4), with
"unreachable" used in the precise smart-constructor sense. This is a rigor *gain*, not a
weakening — the count of 7 and every mechanism are intact, and the value-level honesty was
already latent in the original C2. FORMALIS-appropriate. ✓

**§10 Quantitative commitments** — 85–90% / 70–80% / ≥80% Feathers; |W|=3,|U|=2,depth≤6 →
10^5–10^6 states TLC-tractable, violations caught at depth 1; generator universe finite and
enumerable (L710–731). ✓

**§11 Risk register F1–F8** — all eight present with mitigations; "F2, F5, F6 require
external stakeholders before code ships" preserved (L733–782). ✓

**§12 Effect on v10.3** — supersedes line 1034 and 2287; replacement text; additive-then-swap
deprecation of get_unit_state (alias to (product_terms,unit_status); (w,u)→position)
(L589–615). ✓

**§13 One-sentence answer** — substance preserved (L822–832). ✓

## Refinements examined and cleared (not regressions)

1. **Per-unit StateDelta.** v2 makes a StateDelta single-unit and composes multi-unit events
   (rebalance; breaking-amendment re-subscription) as a group applied all-or-nothing "as a
   single fold" (L417–437, L497–506, signal S1). The original conflated single-unit
   conservation (Σ over w for fixed u) with a multi-unit rebalance. The refinement *corrects*
   this: per-unit conservation is the well-defined granularity, atomicity is preserved
   ("applied together / all-or-nothing / a reader must never observe one applied and another
   not"). Correctness-improving. Reference confirms via `sdUnit` (single-unit delta) and the
   labelled signal S1.

2. **Reference is Haskell, total, illegal-states-unrepresentable.** `reference/StatesHome.hs`
   (verified) backs every cited claim: abstract `Ledger` with no row deleter (C1b) + `Maybe`
   accessor (C1a); abstract `ValidDelta`/`validate` discharging conservation as a monoid
   identity with `mempty` empty fold (C2/C9); abstract `ProductTerms` over `NonEmpty` with
   only `register`/`appendVersion` (C6/C7); `FieldWrite h` GADT as the C11 writer table with
   a type-error-at-authorship `_c11` example; `applyDelta` whole-or-Left (C3); `register`
   rejecting `ReRegistration` (C10); two-track `amend` (C8); `replay = foldM` with the
   Kleisli homomorphism law `replay (xs<>ys) = replay xs >=> replay ys` (P3); signals S1–S4
   labelled. The P3 prose (L685–692) matches the code.

3. **`balance` second conserved field.** An *addition* for the reference to exercise C11 with
   a writer (`transfer`) distinct from `ac`'s. Carefully fenced as non-economic, not the
   framework holding, absent from the §answer inventory (L121–127, L203–205). Does not
   weaken C12 (explicitly non-economic). No correctness contradiction.

## Single nominal deviation (non-blocking)

The F bullet (L653–658) preserves the forcing reason in words — "a runtime predicate
is_universe(w)", "a carve-out, not a rule", "US is the type-level expression of what F hides
as a wallet-id convention" — but drops the *label* "the Minsky denormalisation trap" that the
checklist parenthesises under §7-F. The substantive denormalisation-trap content (a
hand-maintained exception inside another relation, vs a structural rule) is fully present in
words; only the named cross-reference to design D's argument is gone. This is a cosmetic
label omission, not a correctness property, invariant, totality/determinism claim, or a
forcing reason stated in words. It does not trigger the veto.

## Verdict

Correctness fully preserved; two refinements strengthen rigor; the reference discharges the
structural claims. Reasoning in my domain is rigorous and legible to a competent quant
engineer in one careful pass (per-unit composition, value-level conservation, foldM
homomorphism, and the S1–S4 signals are each stated where they bind). Nothing in the
correctness surface is cuttable without loss. **A, 92%.** Lens staked.
