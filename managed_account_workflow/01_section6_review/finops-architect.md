# §6 Review — `finops-architect` (LEAD: end-to-end move-level workflow)

Charge: the move-level workflow — mandate issuance, subscription, trading-under-mandate,
NAV, fee accrual & crystallisation against HWM, segregation, CSA margin, TRS, redemption,
settlement — with double-entry holding at every step. Derived from the primitives; cited to
v10.3 / A1 line numbers; not from market practice.

---

## 0. The finding that frames everything: §6 has no fee engine

The single most important fact for my charge, established by reading the source rather than the
briefing's condensation:

**§6 of v10.3 (l.806–977) specifies exactly one contract — Observe (`Perf = V^ref_{t_k} −
V^ref_{t_{k-1}}`) → Crystallise (one net cash move) → Reset — and contains the words "fee",
"HWM", "hurdle", "subscription", "redemption", "management fee", "performance fee" *zero*
times** (grep confirms: the only `crystallis` hits at l.834/937 are PnL crystallisation, not
fee crystallisation). The entire fee/HWM/subscription/redemption apparatus exists **only in
Addendum A1 as state placement** — `PositionState[w,u_MA]` gets fields `hwm`, `hwm_date`,
`accrued_{mgmt,perf}_fee`, `entry_nav`, `benchmark_nav_at_inception`, subscription/redemption
cursor (A1 l.111, 207–217), and C11 tags handler *names* `fee_crystallise` and `subscribe`
(A1 l.145). **There are no handler bodies, no accrual formula, no ratchet rule, no
hurdle, no flow-netting, no loss-carryforward anywhere in either document.**

So the briefing §4–5 narrative ("fee accrual & crystallisation against HWM") describes a
workflow the specification does not contain. §6 + A1 together are a **PnL-settlement engine
with empty fee slots**, not a managed-account workflow. My LEAD deliverable is therefore to
(a) derive the missing steps from the primitives, and (b) state precisely where the existing
§6 mechanism is *wrong* for a fee-bearing client account, not merely incomplete.

This is a §6 gap, not a framework defect (the three-map model holds the state correctly); it
does not require a StatesHome reversal. But it must be **escalated plainly** (per the briefing's
rule) rather than papered over: §6 cannot be called a managed-account workflow until the
`fee_crystallise` and `subscribe` handler bodies are specified and proved.

---

## 1. End-to-end workflow as atomic moves (derived, conservation verified)

I write every economic state change as moves `m=(w_s,w_d,u,q>0,…)` with `Σ_w Δw(u)=0` checked.
`u_MA` is the mandate unit; `u_X` an underlying; USD the reference unit. All amounts Decimal,
full precision internally, bankers'-rounded only at instruction cut (primitive: arithmetic).

### Step 1 — Mandate issuance (the only step §6/A1 actually nail)
```
τ_issue = { Move(w_manager, w_client, u_MA, q=1, source="mandate_issue") }
⇒ w_manager(u_MA) = −1,  w_client(u_MA) = +1,  Σ_w w(u_MA) = 0   ✓ (issuance law)
```
**Double-entry holds.** Two legs, conserved. State init (atomic StateDelta, C3): write
`ProductTerms[u_MA]` = {fee schedule, HWM/hurdle methodology, crystallisation frequency,
limits, benchmark identity}; init `PositionState[w_client,u_MA]` = {hwm=⊥, entry_nav=⊥,
accrued_*=0, breach_flags=∅, cursor=0}.
**Constraint (banking-auditor, endorsed):** `P_t(u_MA) ≡ 0` (non-valued memo unit). If `u_MA`
ever entered `V_t = Σ w·P` (l.510) it would double-count: the client's exposure *is* the
underlying positions in `w_ref`, not the wrapper. This is a hard precondition, not a default.

### Step 2 — Subscription (NOT in §6; derived)
Client funds the book. A subscription is a **flow**, not performance (proved by §4 l.547–554:
`PnL_flow = Δw(USD) + Σ Δw(i)·P`).
```
τ_sub = { Move(w_client_external, w_ref_cash, USD, q=C, source="subscribe") }
⇒ Σ_w Δw(USD) = 0   ✓
```
Atomic StateDelta sets `entry_nav := V^ref` *post-subscription*, advances the
subscription cursor (the `subscribe`-tagged C11 handler, A1 l.145). **The cursor exists for
exactly one purpose: to let the next Perf computation subtract this flow.** §6's Perf formula
never references it — Step 5 is where this bites.

### Step 3 — Trading under mandate (guarded move generation)
Each trade is a transaction; quantitative mandate limits are **preconditions** on
move-generation (§6.6, l.901): violate ⇒ emit ∅, state unchanged.
```
τ_trade = { Move(w_ref_cash, w_cpty, USD, q=N·P),  Move(w_cpty, w_ref, u_X, q=N) }
⇒ Σ_w Δw(USD)=0, Σ_w Δw(u_X)=0   ✓
```
**Caveat I log (with minsky/formalis):** guard determinism is *price-relative*. "Same wallet
state + same trade ⇒ same accept/reject" (l.901) is **false** for value limits (leverage,
concentration-by-value): hold positions, double a price ⇒ leverage breaches ⇒ the same trade
flips to reject. `P_t` must be a named guard input. And **passive breaches** (a held position
appreciating past a concentration cap with *no move*) escape a move-precondition entirely —
they need a periodic valuation sweep against `breach_flags`, not just an admission guard.

### Step 4 — NAV
`V^ref_t = Σ_u w_{ref,t}(u)·P_t(u)`, `P_t(USD)=1`, `P_t(u_MA)=0`. A projection of the move
stream (§8 l.1497), not a stored record. State-sufficient (l.508): snapshot + price vector, no
replay. **One non-deterministic input: `P_t`.** For replay/P10 it must be a recorded,
content-addressed snapshot, not a live fetch (concur nazarov B1, jane-street #1).

### Step 5 — Fee accrual & crystallisation against HWM (NOT in §6; the load-bearing gap)
This is my charge's centre and §6 is silent. Derived from primitives, the reset at `t_k` is
**not one move but a sequence of distinct, separately-conserved legs**:

**5a. Management fee** — on AUM/NAV, independent of performance, charged even in a loss period:
```
mgmt_fee_k = rate_mgmt · NAV_basis · Δt_k          (basis per ProductTerms)
Move(w_ref_cash, w_manager_cash, USD, q=mgmt_fee_k)      ⇒ Σ Δw(USD)=0  ✓
```

**5b. Performance, net of flows** — the §6 formula corrected:
```
Perf_k = (V^ref_{t_k} − NetExternalFlows_[t_{k-1},t_k]) − V^ref_{t_{k-1}}
       = PnL_price + PnL_flow − Flows   (the §4 decomposition with subscriptions removed)
```
The subscription/redemption cursor (Step 2) supplies `NetExternalFlows`. **§6's bare
`Perf = V_{t_k} − V_{t_{k-1}}` (l.826) pays a fee on the client's own contributed capital.**

**5c. Performance fee against HWM** — asymmetric, floored, ratcheting:
```
gain_above_hwm = max(0, NAV_net_k − max(HWM, NAV_net_k·hurdle_factor))
perf_fee_k     = rate_perf · gain_above_hwm
if perf_fee_k > 0:
    Move(w_ref_cash, w_manager_cash, USD, q=perf_fee_k)   ⇒ Σ Δw(USD)=0  ✓
HWM := max(HWM, NAV_net_k − perf_fee_k)   # ratchet, post-fee; one writer (fee_crystallise)
```
Below HWM: `perf_fee_k = 0`, **no clawback of prior fees**, loss carried forward in the HWM
gap. This asymmetry is the entire economic content of a performance fee and **§6 represents
none of it**: a single signed `Perf → UB` move would (i) pay the manager a fee on a loss
period when `Perf<0` reverses direction, and (ii) charge fees with no HWM memory.

**5d. PnL distribution / settlement (only where applicable)** — the desk-vs-Treasury case
(internal book swept to Treasury) is where §6's single move is *correct*: the whole flow-
adjusted Perf crosses. For a fee-bearing client account it does **not** crystallise — the gain
stays in `w_ref`, only fees leave. **Conflating 5d with 5a–5c is the §6 error that
mis-routes and mis-signs cash.**

All of 5a–5d at `t_k` are **one atomic StateDelta across all three maps (C3)** or none —
accrued_fee reset, HWM ratchet, cursor advance, and the cash moves commit together, else the
next interval double-counts (concur jane-street #3, banking-auditor 4).

### Step 6 — Redemption (NOT in §6; derived, inverse of Step 2)
```
redeem_amt = pro_rata·(NAV_net − accrued_fees_to_date)   # cut-off accrual if t ≠ t_k
τ_redeem = { Move(w_ref_cash, w_client_external, USD, q=redeem_amt) }  ⇒ Σ Δw(USD)=0  ✓
```
If the book must liquidate positions to fund cash, that is its own guarded `τ_trade` sequence
first. Full redemption leaves a **zero PositionState row, retained** (monotone carrier, A1
l.247) preserving final HWM for tax. Partial redemption must re-strike `entry_nav`/HWM basis
(equalisation) — undefined in §6, a fee-fairness defect if omitted.

### Step 7 — Segregation (algebraic claim is overstated)
Conservation makes a move touch only its two named wallets ⇒ one client's partition cannot be
*silently* perturbed. **But conservation does NOT forbid a move whose source and destination
lie in two different clients' partitions** — such a move is perfectly conservative. Logical
segregation (CASS 6 / MiFID 16(8)) therefore rests on an **authorization guard** (C4
capability scoping / `WalletRegistry` permissions), not on algebra (concur jane-street #2,
minsky T2). The briefing's "segregation by algebra" (l.855) is **necessary but not
sufficient**; the §6 claim must be re-stated as "conservation + C4 capability scoping."

### Step 8 — CSA margin (§6.4, sound)
Per-counterparty collateral wallet; wallet-level contract reads aggregate MTM across all
trades under the CSA, emits `Move(w_ref_cash ↔ w_collateral, USD, q=|required−posted|)`,
sign from the gap. Conserved. Portfolio-level netting is the right netting set but does **not
by itself** satisfy IAS 32.42 net-presentation (legal right + intent) — a separate
determination (concur banking-auditor).

### Step 9 — TRS / virtual ledger (§6.7, sound mechanism, one binding gap)
`ℒ_v` closed; no move crosses `ℒ_v↔ℒ_r` (P7). TRS in `ℒ_r` observes `ℒ_v` MTM, emits
`Payment_k = N_k·TR_k − N_k·r_k·Δt_k` as one real move. **Price consistency must be *bound*,
not asserted:** `ℒ_v` valuation and `ℒ_r` settlement must reference the same price-snapshot id,
verifiable by hash (concur nazarov B3, minsky B7), else unexplained PnL with **no internal
reconciliation path** — the one place the "no internal break" guarantee can be silently void.

### Step 10 — Balance-sheet substantiation (§6.9 / §8, sound)
Every balance is the projection `w_t(u) = w_0(u) + Σ ±m.q` (l.1497). No internal account
record to reconcile — the move stream is the evidence. The only reconciliation surface is the
**external boundary** (custodian, counterparty confirmations).

---

## 2. Findings (severity-ordered), justified from primitives

**F-LEAD (BLOCKER) — §6 has no fee/HWM/subscription/redemption engine.** §0 above. The
briefing's charge cannot be met from the spec as written; the workflow's fee half is *derived
here*, not specified. Escalate: `fee_crystallise` and `subscribe` need handler bodies + proofs.

**F1 (BLOCKER) — Perf conflates performance with capital flows.** §4's own decomposition
`PnL = PnL_price + PnL_flow` (l.547) plus l.1366 ("subscriptions and redemptions are lifecycle
events" that change the book) prove `Perf = V_{t_k}−V_{t_{k-1}}` (l.826) crystallises subscribed
capital as if it were performance. Fix data exists (cursor, A1 l.209); the §6 formula never
uses it. Must be flow-netted (Step 5b).

**F2 (BLOCKER) — crystallise move is a partial function presented as total.** l.842 hardcodes
`from:w_ref_cash, to:w_UB_cash, quantity:Perf_ref_k`; `Perf` is signed; `q>0` required (Def
2.3). For `Perf<0` this is non-representable; for `Perf=0` it is an illegal `q=0` move. **The
document is internally inconsistent**: the IRS contract at l.787 already does it correctly
("emit `|Payment_k|`; direction from sign"). Apply the l.787 pattern at all three sites (l.842
crystallise, l.915 TRS, l.937 periodic settlement). For a *performance fee* the floor is even
stricter — `perf_fee ≥ 0` always, direction never reverses (Step 5c).

**F3 (BLOCKER) — performance fee ≠ PnL settlement; the single §6 move conflates them.** Step
5. A managed account pays the manager a *fee fraction above HWM* while the gain stays in the
client book; §6's "whole Perf → UB" is the Treasury-sweep case only. Routing and sign both
wrong for the client case.

**F4 (HIGH) — no funding/solvency property; crystallising unrealised MTM.** Positions stay
in-book (l.944) while cash leaves; `w_ref_cash` can go negative. Negative = legal obligation
by the primitive (briefing l.24) — so **nothing distinguishes a funded obligation from an
insolvent overdraft**. For *client-money* wallets a non-negativity refinement is mandatory
(CASS); the type draws no such line (concur minsky B3). Need an explicit
`obligation` vs `overdraft` classification at the crystallisation boundary.

**F5 (HIGH) — reset baseline has no state home and pre/post-payment NAV is ambiguous.** The
Reset step (l.848) reads/writes a baseline NAV that A1's `PositionState[w,u_MA]` table does not
name (it has hwm, entry_nav, accrued fees, flags, cursor, benchmark_nav — no
`last_reset_value`). Add the field with its unique `fee_crystallise` writer (C11), and fix
whether `V_{t_k}` is pre- or post-crystallisation. Read literally, "baseline ← V^ref_{t_k}"
(pre-move high) **claws performance back** next period (formalis B2 is correct for the sweep
case).

**F6 (HIGH) — `float` in the A1 reference dataclass violates the arithmetic primitive.** A1
l.433: `ac: float = 0.0; balance: float = 0.0; hwm: float = 0.0`. The arithmetic primitive
mandates **fixed-precision decimal, not IEEE-754, bit-identical outputs**. Money and the HWM
ratchet in binary float silently lose pennies and break the to-the-penny reconciliation the
whole design rests on. Even as illustration this is an instant-reject pattern an implementer
will copy. Must be `Decimal`.

**F7 (HIGH) — rounding residual breaks settled-level telescoping.** Bankers' rounding at
instruction cut ⇒ `Σ_k round(Perf_k) ≠ V_n − V_0` by accumulated dust. The residual must
**remain in `w_ref` as a conserved un-crystallised remainder**, never dropped — it is the
reconciling item between economic Perf and moved cash. Drop it and double-entry fails to the
penny (concur minsky B4, correctness-architect F).

**F8 (HIGH) — multi-mandate attribution underdetermined.** base+overlay = two rows (A1 l.217)
each with its own HWM/fee, correctly making collapse unrepresentable. But `V^ref` is **one**
scalar; splitting it into base-Perf and overlay-Perf for two performance fees needs an
attribution rule **not given by the primitives** (B5/B3). Either disjoint sub-partitions, or a
total deterministic allocation function declared in `ProductTerms[u_MA]` and reconstructible
from the stream. Until then, per-mandate fee is non-deterministic w.r.t. the move stream.

**F9 (MEDIUM) — `TR_k` partial.** `TR_k = (V^v_{t_k}−V^v_{t_{k-1}})/V^v_{t_{k-1}}` (l.887):
division by zero at a flat/wound-down virtual book, sign-inversion when net short.
Precondition `V^v_{t_{k-1}} > 0` is unstated.

**F10 (MEDIUM) — settlement finality is outside the closed system.** The crystallise move is
instantaneous and final *inside* `ℒ`, but external cash settles T+1/T+2 and can **fail**. A
fail has no in-ledger representation except a **compensating reversing transaction**
(immutability ⇒ reverse, never edit; §8). The Trade→Affirmation→Confirmation→Netting→
Settlement→Reconciliation lifecycle lives at the boundary; §6's projection does not model it.

**F11 (MEDIUM) — accrued fee at a cut-off date.** When reporting date ≠ reset date, accrued
mgmt/perf fee must be **recomputed** from `ProductTerms` + `V_t`, not read stale. It is
re-derivable (a fold), so it is *not* an independent record that can break — provided the
accrual formula lives in `ProductTerms`, which §6 does not supply (this is where I diverge from
banking-auditor's framing; see Tensions).

**F12 (build-on, not re-derived) — F5/SFTR.** `u_MA` issuance is a real move
`w_manager=−1,w_client=+1`; whether it triggers SFTR/EMIR UTI/LEI is ungoverned. Needs a
`reportable` flag on `ProductTerms[u_MA]` + regulatory pre-flight — an external dependency, not
codeable away. I build on A1-F5; I do not re-derive it.

---

## 3. Verdict

The mandate-as-unit construction and the substantiation-by-projection design are
operationally excellent: structural double-entry, one immutable stream, no internal break
possible, the stream as audit evidence. But **§6 is a PnL-settlement engine, not a
managed-account workflow** — the fee/HWM/subscription/redemption half of my charge is
*unspecified* (F-LEAD), and the single mechanism that *is* specified is wrong for a
fee-bearing client account in four provable ways: flow-conflation (F1), a partial signed move
(F2), fee-vs-settlement conflation (F3), and an unhomed/clawing baseline (F5). F6 (float) and
F7 (residual) are penny-correctness defects a finops lens rejects on sight. None require a
framework change; all require *stating and proving* handler bodies §6 currently omits. I block
on F-LEAD, F1, F2, F3.
