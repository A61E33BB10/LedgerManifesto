# Independent Read — Managed Account (§6 + Addendum A1)
**Lens: correctness-architect.** Derived from primitives; not asserted. Cited to v10.3 line numbers.

## 1. What it is (my model)
A managed account is not a new object. It is the pair *(a wallet partition `w_ref`, a mandate
unit `u_MA`)* observed by a deterministic smart contract. `u_MA` is issued by the manager and
held by the client (`w_mgr(u_MA)=−1, w_client(u_MA)=+1`, A1 §4), so it is a *real* conservation
partner, not the rejected Dirac sentinel. The contract is a pure function fired at reset times:
**Observe** `Perf = V_ref(t_k) − V_ref(t_{k−1})` (l.826) → **Crystallise** one net cash move
`w_ref_cash → w_UB_cash` (l.834) → **Reset** baseline (l.848). Per-client economic state
(`hwm`, `entry_nav`, accrued fees, breach flags, sub/redemption cursor, benchmark-NAV-at-inception)
lives at `PositionState[w_client, u_MA]` (A1 l.208–210); the W-sector is empty by C12. TRS and
periodic book-settlement are the *same* contract with the book playing the role of the virtual
ledger `ℒ_v` (l.958); the only varying parameters are UB identity, reset frequency, valuation basis.

## 2. What must hold (property ramp)
- **P1 / Conservation (structural).** Every reset move is `src −= q; dst += q`; quantity sum is
  zero by construction (l.33–36). Not a runtime check. **Holds.**
- **Telescoping / P10.** `Σ_k Perf_k == V_ref(t_n) − V_ref(t_0)` after adjusting for exogenous
  flows. This is the load-bearing invariant of the whole mechanism. *Conditional* — see §3(A).
- **Move legality.** Every emitted move has `q > 0` (Def 2.3, l.149). Direction encodes sign.
- **Read isolation / P7.** TRS *observes* `ℒ_v`; no observation handler may write to `ℒ_v`, and
  no move crosses `ℒ_v ↔ ℒ_r` (l.875, l.924). Multiple TRS readers must see one snapshot (P8).
- **Replay determinism / P3.** `Perf` is a pure fold over recorded state; `apply_all(events)` is
  checkpoint-independent (A1 P3). Requires `P_t` to be *recorded input*, not live-fetched.
- **Segregation.** ∀ move local to `partition(C)`, ∀ `w ∉ partition(C)`: `w(u)` unchanged.
  Holds for *quantity* by move locality (l.855). Value/risk is **not** segregated (shared `P_t`).

## 3. Where it breaks (derived, with the framework's own §4 against §6)

**(A) BLOCKER — `Perf = V_{t_k} − V_{t_{k−1}}` conflates performance with capital flows.**
§4 itself decomposes `PnL = PnL_price + PnL_flow` with `PnL_flow = Δw(USD) + Σ Δw(i)·P` (l.547–554),
and l.1366 confirms subscriptions/redemptions are flows that change the book. The §6 `Perf`
formula (l.826) is the *total* V-change = `PnL_price + PnL_flow`. Crystallising it as cash pays the
client's own subscribed capital out to the UB as if it were performance. The fix-data exists
(`subscription/redemption cursor` at `PositionState[w_client,u_MA]`, A1 l.209) but the §6 formula
never references it. **Must hold:** `Perf = (V_{t_k} − NetExternalFlows_[t_{k−1},t_k]) − V_{t_{k−1}}`.

**(B) BLOCKER — the crystallise/TRS pseudocode can emit an illegal `q<0` move.** l.842 writes
`quantity: Perf_ref_k` and l.915 writes `quantity: Payment_k`, but both can be negative. The
framework already established the correct pattern for the *futures* reset at l.787 ("emit `|Payment_k|`;
direction from sign"). §6 is internally inconsistent with l.787 and with Def 2.3. As written it
constructs a non-representable state. **Fix:** branch on sign, emit `|Perf|`, swap src/dst.

**(C) BLOCKER — conservation gives no settlement liveness; no solvency property.** Crystallising
unrealised MTM (positions stay in-book, l.944) drains `w_ref_cash` while gains sit in non-cash
position value. Conservation holds (quantity), yet `w_ref_cash` can go negative. Negative is a
*legal* short by the primitive (l.22), so nothing distinguishes a funded obligation from an
insolvent overdraft. There is no property guaranteeing the payer can fund the move. **Missing
property:** a funding precondition or an explicit `obligation` vs `overdraft` classification at the
crystallisation boundary.

**(D) SHOULD — the reset baseline has no documented home, and pre/post-payment NAV is ambiguous.**
"Reset baseline → state at `t_k`" (l.848) reads/writes a baseline-NAV field absent from the A1
`PositionState[w,u_MA]` table (l.208–210). Without an explicit field tagged to a canonical writer
(C11), the Observe step reads undocumented state, and it is unspecified whether `V_{t_k}` is taken
before or after the crystallisation cash leaves `w_ref`. Both are required for P3/P10.

**(E) SHOULD — `TR_k` is undefined at `V^v_{t_{k−1}} ∈ {0, <0}`.** `TR_k = (V^v_{t_k}−V^v_{t_{k−1}})/V^v_{t_{k−1}}`
(l.887): division by zero when the virtual book is flat/wound-down; sign-inversion when net short.
Edge case must be defined or rejected.

**(F) SHOULD — rounding residual breaks value-telescoping.** Bankers' rounding at instruction
generation (l.40) makes `Σ_k round(Perf_k) ≠ V_n − V_0` by accumulated pennies. **Fix:** carry the
residual forward so cumulative crystallised cash reconciles to cumulative performance within 1 ULP.

**(G) NICE — fee-crystallise vs performance-settle ordering is unfixed.** C11 gives them distinct
handlers (`hwm→fee_crystallise`, `ac→settle`) but not a relative order; they are non-commutative
(perf fee is a function of NAV). The transaction total-order tie-break (l.32) must pin it.

**(H) Determinism boundary.** Single non-deterministic input: the price oracle `P_t`. For replay
and for the TRS "price consistency" requirement (l.922) it must be injected as a recorded event,
shared bit-identically by `ℒ_v` valuation and `ℒ_r` settlement. Flag any live price read in a handler.

## 4. Concrete properties to instrument (Hypothesis)
```python
# (A) flow-adjusted telescoping — the headline invariant
@given(resets=reset_streams(with_flows=True))
def test_perf_telescopes_net_of_flows(resets):
    crystallised = sum(r.perf for r in resets)
    assert crystallised == V(resets[-1].t_k) - V(resets[0].t0) - sum(r.net_external_flow for r in resets)

# (B) every emitted move is legal regardless of sign
@given(perf=decimals(allow_negative=True))
def test_crystallise_move_quantity_positive(perf):
    m = crystallise(perf)
    assert m.quantity > 0 and m.src != m.dst
    assert (m.src, m.dst) == ((w_ref, w_ub) if perf >= 0 else (w_ub, w_ref))

# (C) funding precondition is explicit, not implied by conservation
@given(book=books())
def test_crystallisation_funding_classified(book):
    r = crystallise_on(book)
    assert r.funded or r.flagged_as_obligation  # never a silent negative cash balance

# (E) return fraction total at the degenerate denominator
@given(v_prev=decimals())
def test_tr_k_defined_at_zero_denominator(v_prev):
    assume(v_prev <= 0)
    with pytest.raises(UndefinedReturn):
        total_return(v_prev, v_next=anything())

# (H) replay determinism: prices are recorded, valuation is a pure fold
@given(stream=event_streams())
def test_valuation_is_pure_fold(stream):
    assert V_after(apply_all(stream)) == V_after(apply_all(stream[:k]) ++ stream[k:])
```

## 5. Build-on-A1 risks
F5 (mandate-as-unit → SFTR/EMIR surface) intersects (A): if `u_MA` issuance is reportable, the
flow-adjustment data (sub/redemption cursor) is also the reportable-event source — align them.
F6 (CDM `TradeState` vs `PositionState` unverified) is where (D)'s baseline-field home must land.

## 6. Verdict
Mechanism is sound *as quantity algebra*; conservation and isolation hold by construction. It is
**not yet correct as a performance engine**: (A) and (B) are provable defects against the
framework's own §4 and l.787, and (C) is a missing liveness property. These three block approval;
(D)–(H) are required before the mechanism is replayable and value-conserving end to end. None
require changing the framework — they are §6 corrections, not StatesHome reversals.
