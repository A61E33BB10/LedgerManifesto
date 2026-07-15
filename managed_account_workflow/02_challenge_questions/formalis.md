# formalis — challenge questions (Step 3)

*Lens: correctness is a mathematical property. Each question either has a concrete answer
derivable from the primitives, or exposes a genuine framework flaw to escalate. No straw men.*

1. **`u_MA` cardinality is representable-but-illegal.** `CONS(u_MA): Σ_w w(u_MA)=0` admits
   `(w_mgr:−5, w_client:+5)`, a three-way split `(−2,+1,+1)`, and fractional balances — all
   conservative, none a valid managed-account configuration. The mandate state at
   `PositionState[w_client,u_MA]` (`hwm`, `entry_nav`, `accrued_fee`) is well-defined only if
   exactly one holder carries exactly `+1`. State the predicate that forbids
   `w(u_MA) ∉ {−1,0,+1}` and `Σ_w 1[w(u_MA)≠0] ≠ 2`, and name the exact admission guard (which
   handler, which map) that rejects any move touching `u_MA` that would violate it. If none
   exists, the model admits a meaningless state — escalate or close.

2. **Is `P_t` total over held units, and what is `P_t(u_MA)`?** `V_t = Σ_u w_t(u)·P_t(u)` is
   presented with `P_t` total. If `P_t(u_MA)` is defined and nonzero, the client's mandate unit
   enters their own valuation and double-counts the underlying exposure already in `w_ref`/`ℒ_v`,
   contaminating `Perf = V_{t_k}−V_{t_{k-1}}`. If `P_t(u_MA)=None`, `V_t` is partial. Which is it?
   Where is the invariant `P_t(u_MA)=0 ∀t` stated, and is `u_MA` typed as a valuation-excluded
   memo unit (also excluded from RWA/exposure), or is this a silent gap?

3. **Segregation: name the theorem and its true premises.** §6.3 attributes logical segregation
   to conservation. Counterexample: `m=(w_A_cash, w_B_cash, USD, q)` satisfies `CONS` exactly
   (`−q+q=0`) yet moves cash from client A's partition to client B's. Hence `CONS ⇏ SEG`. The
   property that holds is `LOC` (move-locality) `∧` C4 (capability scoping). Will §6.3 be rewritten
   to delete the conservation attribution, or is there a derivation of `SEG` from conservation I
   have missed? If not, the CASS-6/MiFID-16(8) claim currently rests on a false premise.

4. **Fee crystallisation: what couples `q_fee` to `Δaccrued_fee`?** A crystallisation must
   atomically emit `m_fee=(w_client_cash, w_mgr_cash, USD, q_fee)` (conserved) and decrement the
   non-conserved scalar `accrued_fee` at `[w_client,u_MA]`. C2 checks only conserved fields, so a
   handler emitting `q_fee=q` while setting `Δaccrued_fee=−q'` with `q'≠q` satisfies C2 and the
   schema, yet the client pays `q` and is relieved of liability `q'`. State the per-event-class
   obligation `q_fee = −Δaccrued_fee` (or escalate that no invariant currently fires on the mismatch).

5. **§6.9 projection claim vs stored fee/HWM state.** §6.9 asserts every balance is a deterministic
   projection of the move stream with "no separate account-level record to reconcile." But
   `perf_fee = max(0, rate·(V_t − HWM))` depends on monotone stored `HWM` (ratcheting, path-dependent)
   and on the external price path `P_{t_{k-1}}…P_{t_k}`, neither determined by the move stream. So the
   performance fee is not recomputable from the stream. Is §6.9 false for fee state, and will it be
   explicitly carved out — or is the fee re-derivation banking-auditor prescribes impossible by
   construction?

6. **Crystallise handler totality across `sign(V_t − HWM)`.** On a loss (`V_t < HWM`) the perf fee
   is `0` (no clawback) and HWM is unchanged, while the management fee still accrues. The handler must
   be total over `sign(V_t−HWM)` and emit different legs (positive client→manager move, or no move).
   Is the handler defined for every branch, and does it ever attempt a `q≤0` move (illegal, q.6→7)?

7. **`q>0` vs signed settlement quantities.** `Move` requires `q>0`, but `Perf_k`, `Payment_k`, and
   any fee leg are signed and can be zero. The fixed-direction listings (crystallise, TRS, periodic
   settle) are non-representable for the loss case and illegal at `q=0`. Confirm the canonical
   encoding `q=|x|, direction=sign(x), reject x=0` is mandated at all four sites, and state what the
   reset/settlement does when `x=0` (emit nothing vs. emit an identity move).

8. **Guard determinism omits `P_t`.** §6.5 claims "same wallet state + same proposed trade ⇒ same
   accept/reject." Hold `State` and `Trade` fixed and double a constituent price: a value-based
   leverage/concentration cap flips `accept→reject`. The decision is a function of
   `g: State × Trade × P_t`, not `State × Trade`. Will the claim be re-quantified to include the price
   vector, and is `P_t` an explicit input to the move-generation function or an ambient read?

9. **Guard totality on missing price and `V_t ≤ 0`.** Value-based limits need `V_t=Σ w(u)·P_t(u)`.
   For a just-registered or illiquid unit `P_t(u)=None`, so `V_t` and `g` are undefined; and
   `leverage = exposure/equity` is undefined at `equity=V_t=0` and sign-inverts at `V_t<0`. What is
   the typed behavior — fail-closed reject, or typed error — for each? "Silent accept" is the one
   answer that is a correctness defect.

10. **Precondition ≠ portfolio invariant.** A move-generation precondition fires only when a trade is
    proposed; a limit breached by a held position *appreciating* (no move) is never evaluated. So `g`
    maintains `within_limits(State)` only over transitions caused by admitted trades — the global
    invariant "portfolio always within limits" is false under passive price-driven breach. Is the §6.5
    claim the precondition `¬worsens_breach(State, Trade)` or the global invariant? If the latter, what
    periodic valuation sweep enforces it, and where is that mechanism specified?

11. **Reset baseline `B_k` has no home and no writer.** Observe/Reset read and mutate a baseline
    (`V_{t_{k-1}}` carried forward) absent from the A1 `PositionState[w,u_MA]` field table and tagged
    by no C11 handler. Name the field, its unique writer, and fix whether it stores the **pre-** or
    **post-settlement** value (they differ by exactly `Perf_k`; only `B_k=V_{t_k}−Perf_k` avoids
    clawing performance back). Until this is a named field with a unique writer, the three-map model is
    incomplete for §6.

12. **`Perf` conflates performance with capital flows.** §4 decomposes `PnL=PnL_price+PnL_flow`, yet
    §6 uses `Perf=V_{t_k}−V_{t_{k-1}}` gross of flows. A subscription mid-period raises `V` as a flow;
    the manager would crystallise the client's own subscribed capital to the UB as performance. The fix
    data (`entry_nav`, subscription/redemption cursor) exists at `[w_client,u_MA]` but the §6 formula
    never references it. Is the required form `Perf=(V_{t_k}−NetExternalFlows)−V_{t_{k-1}}`, and what
    determines `NetExternalFlows` deterministically from the stream?

13. **Multi-mandate `Perf` is non-deterministic w.r.t. the stream.** Base+overlay are two rows on one
    wallet `w_client`, but the wallet has a *single* reference value `V^ref` yielding *one* scalar
    `Perf`. Splitting it into per-mandate performance for two independent HWM/fee streams is not a
    projection of the move stream — it needs an attribution rule the primitives do not supply. Must each
    co-resident mandate own a disjoint reference sub-partition, or must `ProductTerms[u_MA]` declare a
    total deterministic allocation function reconstructible from the stream? Without one, per-mandate
    `Perf` is ill-defined.

14. **Non-commuting fee/settlement order.** Crystallisation runs mgmt-fee, perf-fee, and performance
    settlement; the perf fee is a function of NAV, so whether it is computed gross or net of the
    management fee, and before or after the performance leg leaves `w_ref`, changes the result. The
    total order (tie-break for replay) operates on timestamps, not on intra-event step order. Where is
    the intra-crystallisation step sequence pinned, and is it part of the deterministic-replay
    guarantee or an unstated assumption?

15. **TRS/`ℒ_v` price-consistency binding.** §6 requires `ℒ_v` valuation and TRS settlement to use the
    same price vector `P_t`, else unexplained PnL. Conservation/locality give nothing here: `ℒ_v` and
    `ℒ_r` are isolated (P7, no move crosses), so the two ledgers can read two different price sources
    and still each be internally closed. What structurally binds both to one `P_t(u)` per `(u,t)` — a
    shared external price map keyed by `(u,t)`, or merely an assumption? If the latter, price-source
    divergence is a representable inconsistency with no invariant guarding it.

16. **Rounding residue and conservation of the fee leg.** Bankers' rounding is applied "only at
    instruction generation." A fee or settlement amount split/rounded to instruction precision may not
    sum back to the accrued scalar. Does the rounding residue stay in `accrued_fee` (never dropped), and
    is the cash leg `m_fee` guaranteed to conserve to the tick — or can a rounded crystallisation move
    `q_fee` that differs from `Δaccrued_fee` by a rounding unit, silently breaking the q.4 coupling?
