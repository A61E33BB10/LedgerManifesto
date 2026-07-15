# Correctness-Preservation Checklist — StatesHome rewrite (FORMALIS-owned)

The rewrite (`addendum_stateshome_v2.tex`) changes only *how* the addendum is expressed. Every
item below is present in the original `_original_addendum.tex` and must remain present and
**exactly as strong** in the rewrite. Dropping an item, weakening a claim, removing a necessary
qualification, or omitting a case to read more smoothly is a **regression**, and triggers the
FORMALIS veto (grade F) regardless of clarity. FORMALIS verifies this list every round.

## 1. The ruling (the answer)
- State attaches to **three** maps, each with its own totality/mutation discipline:
  - `ProductTerms : Map[UnitId, NonEmptyList[TermsVersion]]` — immutable, append-only, **versioned**, **registration-total** on registered `u`.
  - `UnitStatus : Map[UnitId, UnitStatus]` — **mutable**, **shared across all holders**, registration-total.
  - `PositionState : Map[(WalletId, UnitId), PositionState]` — per-`(holder,unit)`, **monotone carrier**, **Option accessor**.
- Plus a **non-state, non-financial** sidecar `WalletRegistry : Map[WalletId, WalletMetadata]` (KYC, permissions, audit cursor) — explicitly **NOT state**.
- **There is no `WalletState` sector.** Every economic per-wallet fact is `(w, u_mandate)`-keyed and collapses into `PositionState`. The W-sector is empty of economic state.

## 2. The two orthogonal disciplines on PositionState (both required — C1)
- **Option accessor**: `None` = "this wallet has never held this unit"; `Some(zero)` = "held once, currently flat". Both readings are load-bearing (VM-settle, wash-sale lookback, record-date entitlements); `None` vs `Some(zero)` **cannot be collapsed**.
- **Monotone carrier**: once created, a row is never garbage-collected; close-out leaves a `zero` row. Makes replay a literal fold (`apply_all(events)` identical regardless of checkpoint boundaries) and conservation a single pass over a stable key set.
- These two are **orthogonal** (one type discipline, one storage discipline); **both required**.

## 3. Conservation lives at the event handler, not the storage shape (C2)
- No map layout enforces `Σ_w accumulated_cost(w,u)=0` by types alone (refinement types on decimal sums are not free in production languages).
- Every event handler (`Trade`, `SettleVM`, `CorporateAction`, `QISRebalance`, `MandateAmend`) emits a `StateDelta` satisfying `Σ_w Δf(w,u)=0` **structurally per event class**, with explicit proofs for the 2-leg, K-leg, VM-fan-out, and **vacuous (zero-holder)** base cases. Induction over the event stream gives the global invariant.

## 4. The twelve conditions C1–C12 (all must survive, each as strong)
- **C1** Option accessor + monotone carrier, both.
- **C2** Handler-level conservation, per event class, with vacuous base case.
- **C3** Atomic `StateDelta` across ProductTerms/UnitStatus/PositionState; partial application rejected.
- **C4** Capability-scoped reads; cross-`(w, u_MA)` overlay reads forbidden; strategy exports flow only through UnitStatus.
- **C5** UnitStatus registration-total; product-declared defaults applied at Unit Store registration.
- **C6** ProductTerms versioned append-only; no in-place mutation.
- **C7** ProductTerms registration-total; first write at registration.
- **C8** Amendment two-track: a product-declared fungibility predicate decides **Preserving** (append TermsVersion) vs **Breaking** (allocate fresh `u` + SupersededBy).
- **C9** Handlers on zero-holder units discharge `Σ=0` vacuously; per-class proof obligation includes the empty case.
- **C10** Re-registration of a `u_id` is a hard error — never a silent reset.
- **C11** Each PositionState field tagged with the unique handler allowed to mutate it (`ac`→settle/trade; `hwm`→fee_crystallise; `entry_nav`→subscribe; …).
- **C12** All per-`(w, mandate/strategy)` economic state lives at `PositionState[w, u_MA]`/`[w, u_QIS]` — no flat per-wallet scalars; W-sector collapse enforced by schema.

## 5. The three keys (home of each datum)
- `u` immutable → ProductTerms (multiplier, currency, expiry, CCP, strike, ISIN, fee schedule, mandate text, benchmark identity, index methodology).
- `u` mutable shared → UnitStatus (`lifecycle_stage`, `last_settlement_price`, `last_settlement_date`, `current_weights`, `nav_index`, `triggered_barrier`, `superseded_by`).
- `(w,u)` → PositionState (`accumulated_cost`, `ccp_binding`, per-position OTC lifecycle, `entry_nav`, `hwm`, `accrued_{mgmt,perf}_fee`, `benchmark_nav_at_inception`, `mandate_breach_flags`).

## 6. The four test cases — resolutions must all be preserved
- **Future**: immutable terms→ProductTerms (CME-ES and ICE-ES are **distinct units**); `lifecycle_stage`/`last_settlement_price`→UnitStatus; `accumulated_cost`→PositionState with `Σ_w ac=0` by handler zero-sum. `first_touch_date` is **NOT state** (derived; caching it creates fold-inconsistency under back-dated corrections). Settled positions retain rows (monotone).
- **Managed account**: the mandate **is a unit** `u_MA`; `w_manager(u_MA)=−1`, `w_client(u_MA)=+1`, `Σ_w w(u_MA)=0` by issuance. Field relocation table (terms→ProductTerms; HWM value/hwm_date/accrued fee/breach flags/cursor/benchmark NAV at inception→PositionState; current benchmark level→UnitStatus[u_bench]). NOT the Dirac `u_∅` hack (real issuer/holder/conservation partner). Multi-mandate = two `(w,u_MA,*)` rows.
- **QIS strategy**: five distinct keyings coexist, no two in the same map (`u_QIS`, `u_ES/u_NQ`, `u_MA_C`, `w_QIS`, `w_C`). Strategy terms→ProductTerms; strategy state→UnitStatus (shared); strategy's futures positions→PositionState[w_QIS,·]; per-client sub state→PositionState[w_C,u_QIS]. HWM lives at PositionState[w_C,u_QIS] (tie broken by correctness-architect+formalis: two strategies ⇒ two HWMs). Rebalance = one atomic StateDelta over UnitStatus + PositionState (C3). Wind-down: UnitStatus→CLOSED propagates; PositionState rows retained at 0.
- **Untraded instrument**: ProductTerms present (C7); UnitStatus present & fully initialised with defaults (C5), `view.unit_status(u)` **total**; PositionState **no rows** (`None` until first touch, C1); WalletRegistry unaffected. Lifecycle totality (LISTED→ACTIVE→EXPIRED via UnitStatus, zero PositionState rows); handlers fire on empty holder set, discharge `Σ=0` vacuously (C9); the `dividend/len(holders)` bug class caught by C9. Amendment discipline (C8) with the total, testable predicate `is_fungibility_preserving : ProductTerms × TermsAmendment → {Preserving, Breaking}`.

## 7. Pareto frontier — designs A–F and the **forcing reason** each loses (must be preserved, stated in words)
- B (3 maps + C1–C12) is the **unique Pareto-optimum under any correctness gate ≥ 7**; strictly dominates A, C, D, F; dominates E.
- A (v10.3 current): weaker on all axes.
- C (Dirac `u_∅` sentinel): fails day-one correctness — `u_∅` has no issuer, no conservation partner; breaks `Σ_w w(u)=0` by fiat.
- D (Minsky 4-map with explicit WalletState): the fourth sector's economic content is empty (every candidate collapses to `(w,u_MA)`).
- E (Grothendieck sheaf on `H_t ⊆ W×U`): equal correctness, lower testability (sheaf generators need non-existent libraries), radically lower simplicity.
- F (2-map with universe wallet `w_*`): re-introduces the per-unit/per-`(w,u)` split as a **runtime predicate** `is_universe(w)`; conservation must exclude `w_*` as a carve-out, not a rule (the Minsky denormalisation trap). UnitStatus is the type-level expression of what F hides as a wallet-id convention.

## 8. Why exactly three maps — three independent forcing constraints
- (i) Two wallets holding the "same" contract need distinct lifecycle state ⇒ PositionState[w,u] required.
- (ii) Shared observables (`last_settlement_price`, index values, strategy weights) are one-per-contract, dereferenced by every holder ⇒ a `u`-keyed map distinct from per-holder state required.
- (iii) Append-only versioned terms vs mutable per-`u` status are two different mutation disciplines ⇒ a third map required.
- Removing any breaks one of (i)–(iii); adding a fourth introduces an economically empty sector. Three is the **minimum basis**, not a compromise.

## 9. Invariants made structurally unreachable (7 of 10) — claim must be preserved
- P1 conservation (C2+C3); P3 determinism of replay (monotone carrier C1 ⇒ fold identity); P5 idempotency of lifecycle events (single `(w,u)` lattice + per-field canonical handler C11); P6 immutability of terms (NonEmptyList append-only C6 + C7); P7 no in-place mutation of identity (C10 + C8); P9 capability scoping (C4); P10 handler-field canon (C11). **No other candidate exceeds 3.**

## 10. Quantitative commitments (preserve the numbers)
- Mutation scores: event handlers 85–90%; lifecycle guards 70–80%; overall core ≥ 80% (Feathers threshold).
- State-machine spec at `|W|=3, |U|=2, depth≤6`: 10^5–10^6 reachable states (TLC-tractable); conservation-violating handlers caught at depth 1.
- Generator universe (CDM enum × product-type) is finite and enumerable.

## 11. Risk register F1–F8 (all eight must survive, with their mitigations)
- F1 migration scope; F2 ungoverned C8 predicate ownership; F3 monotone-carrier key-space growth at scale; F4 C1–C12 is a multi-sprint programme; **F5 mandate-as-unit SFTR/EMIR reporting surface**; F6 CDM TradeState-vs-PositionState alignment asserted not verified; F7 onboarding cost; F8 forward migration irreversibility. F2, F5, F6 require external stakeholders before code ships.

## 12. Effect on v10.3 (must survive)
- Supersedes the phrasing at v10.3 line 1034 and line 2287; the replacement text and the additive-then-swap deprecation of `get_unit_state` (alias to `product_terms ++ unit_status`; `get_unit_state(w,u)` → `position_state(w,u)`).

## 13. The one-sentence answer (must survive in substance)
- Unit state lives in three places — immutable `ProductTerms[u]`, shared mutable `UnitStatus[u]`, per-position `PositionState[w,u]` — with no separate wallet-keyed state sector, because every economic per-wallet fact is naturally keyed by a mandate/strategy unit and collapses into `PositionState[w,u_MA]`. Pareto-optimal on testability, correctness, simplicity; the minimum basis, not a compromise.

---
**Reference implementation note (Haskell, milewski-authored, FORMALIS-cleared):** the Haskell in
`reference/StatesHome.hs` replaces the original Python listing. It must make illegal states
unrepresentable and be total; it must encode (at least) the three maps with their accessors, the
Option-vs-monotone distinction (C1), the atomic conservation-checked StateDelta (C2/C3), the
versioned append-only ProductTerms with the two-track amendment (C6/C8), and re-registration as a
hard error (C10). Any concept awkward to express cleanly is a **signal** to record/escalate, not
to contort around.
