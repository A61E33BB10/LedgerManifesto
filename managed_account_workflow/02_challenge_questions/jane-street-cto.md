# §6 Managed-Account Workflow — Challenge Questions by `jane-street-cto`

Lens: the simplicity gate, correctness first. Make illegal states unrepresentable; derive
state, do not store it; thread `P_t` explicitly; every cut must be simpler *and* more correct.

1. The Move primitive makes `q>0` a type invariant, yet the crystallisation listings write
   `quantity: Perf_k` with `Perf_k` signed (l.842). If `Move.q` is a refinement type that
   rejects non-positive values, a loss-direction crystallisation cannot be *constructed* — so
   what exactly does the current code do at the type boundary: silently take `abs`, throw, or is
   `q>0` merely a runtime assert and therefore not a type invariant at all? Show me the
   constructor signature that makes the illegal state unrepresentable.

2. My B-1 says derive `hwm`/`entry_nav`/`accrued_fee` from the log rather than store them. But a
   back-dated **price** correction at `t_{k-2}` changes the fold, hence changes the perf fee that
   was *already crystallised as a real, settled cash move* at `t_{k-1}`. The settled cash cannot
   be un-moved. So the recomputed fee and the paid fee now disagree. What reconciles them — a
   compensating correction move in the current period, and if so, is that move conservative and
   idempotent under repeated replay? If nothing reconciles them, my "delete the cache" position is
   wrong and the framework has no answer to back-dated corrections of settled value.

3. The whole derive-don't-store argument (B-1) and replay reproducibility (P3/P10) rest on `P_t`
   being a **recorded, content-addressed snapshot event in the move stream**. Is it? Point to the
   primitive. If `P_t` is read from an external oracle at reset time and only the *resulting* cash
   move is logged, then the baseline `V_{t_{k-1}}` is not derivable from the log and replay is not
   bit-reproducible — directly contradicting state-sufficiency (briefing §2). Which is it?

4. The single generator (B-3) rejects `net=0`. But a zero-performance reset is a legitimate
   business event that must still ratchet the HWM date and reset the baseline. If `net=0` emits no
   move, what records that the reset *happened*? And conversely, under P5/P6 idempotency, if the
   reset event is replayed, does the baseline reset twice and the fee crystallise twice? Show the
   idempotency key that makes a replayed reset a no-op.

5. `TR_k = (V^v_{t_k}−V^v_{t_{k-1}})/V^v_{t_{k-1}}` is partial at `V^v_{t_{k-1}} ≤ 0`
   (flat/wound-down/net-short virtual book). What is the typed failure value, who is the handler,
   and what does the TRS settlement move become in that period — zero, undefined, or a rejected
   transaction that leaves the contract unable to ever reset again because the baseline is stuck?

6. A1 l.217 places base+overlay as two `PositionState` rows on **one** wallet. One wallet yields
   **one** `V^ref`. Splitting it into base-`Perf` and overlay-`Perf` requires an attribution rule
   the primitives do not supply. Where does that rule live, is it **total** over all position sets
   the two mandates can jointly hold, and what happens to attribution when a position is
   simultaneously in-scope for both mandates? If the answer is "give each mandate a disjoint
   sub-wallet," then the two-rows-on-one-wallet model in A1 is the wrong primitive and should be
   deleted.

7. B-2 replaces the second `ℒ_v` instance with `realm ∈ {real, virtual}` on the wallet, with
   P7 = "a move's source and destination share a realm." With a flat wallet-id namespace, what
   makes a cross-realm move **ill-typed at construction** rather than caught by a runtime guard?
   If P7 is enforced by a runtime check on every move, it is not structurally unreachable and the
   A1 claim that P7 is "structurally unreachable as a violation" is false. Exhibit the type that
   makes `Move(real_wallet, virtual_wallet, …)` not compile.

8. §6 (l.916–922) requires `ℒ_v` valuation and TRS settlement to use "the same price vector
   `P_t`." Under the second-instance model there are two unit registries and two price objects.
   What enforces byte-identical `P_t` across them at the *same* reset timestamp, given clock skew
   and independent snapshot ordering? If the answer is "share one `P_t`," that is my B-2 — so what
   correctness property does keeping two instances buy that a single realm-tagged space loses?

9. `Perf = V_{t_k} − V_{t_{k-1}}` counts a mid-period subscription as performance, so the manager
   earns a performance fee on the **client's own deposited capital**. Is `Perf` flow-adjusted
   anywhere in §6, or is this a live accounting break that overpays the manager on every funding
   event? If flow-adjusted, the net-flow filter reads tagged SUBSCRIPTION/REDEMPTION moves — is
   that a projection over the stream or the stored "subscription/redemption cursor" of A1 l.209,
   and if stored, it inherits the same fold-inconsistency as B-1.

10. `u_MA` conserves by `w_mgr(u_MA)=−1, w_client(u_MA)=+1`. If `P_t(u_MA)` is defined (nonzero),
    the manager's `−1` holding enters the manager's `V_t` as a liability and the client's `+1` as
    an asset — double-counting the underlying positions that *already* drive `V^ref`. If
    `P_t(u_MA)` is undefined, then `V_t = Σ_u w(u)·P_t(u)` has an undefined term for any wallet
    holding `u_MA`. Which is it, and how does the valuation sum stay total over a unit that must
    not be valued?

11. l.855 credits conservation with segregation (CASS 6 / MiFID 16(8)). Conservation does **not**
    forbid a move whose source is client A's wallet and destination is client B's wallet — that
    move is perfectly conservative. So segregation rests on the C4 capability guard /
    `WalletRegistry` permissions, which is *not* a structural invariant. Does the spec state this
    precisely, or does it leave a 3am responder believing the conservation law enforces an
    authorization boundary it cannot enforce? This is a conformance miscredit, not a property.

12. At a crystallisation the contract must: compute the fee, ratchet the HWM, and reset the
    baseline. These are order-sensitive — ratchet before fee-compute and you compute against the
    new HWM; reset baseline before fee-compute and you lose `V_{t_{k-1}}`. The transaction is
    "applied atomically" but atomicity is not ordering. What total order over these sub-steps is
    fixed, where is it specified, and is it the same order under replay? An unspecified order is a
    determinism boundary that produces different fees on different runs.

13. C11 tags each `PositionState` field with a **unique** handler, yet l.85 of the briefing tags
    `ac` with both `settle` and `trade`. Two writers on one field contradicts "the unique handler
    allowed to mutate it." Either the single-writer discipline is violated (and concurrent
    settle/trade can interleave-corrupt `ac`), or `ac` is not one field. Which, and what serialises
    the two writers?

14. Redemption "crystallises outstanding fees first." The fee is computed on a NAV that still
    includes the redeeming capital, but the HWM and baseline must reset to the *post*-redemption
    state. In-kind redemption additionally moves **position units** out of `w_ref`, changing
    `V^ref` by a flow, not performance. Walk the exact sequence: is the fee computed pre- or
    post-redemption-flow, does the HWM ratchet on a NAV that no longer exists after redemption, and
    does the flow filter (Q9) correctly exclude the in-kind units?

15. §6 says the CSA margin contract "reads aggregate MTM across **all** trades under the CSA"
    (l.871), i.e. a read across many `(w, u)` cells. C4 forbids "cross-`(w, u_MA)` overlay reads."
    Is the CSA aggregate read a permitted capability-scoped read or a C4 violation? If permitted,
    state the capability that authorizes a portfolio-wide read while C4 forbids a two-cell overlay
    read — the boundary between "allowed aggregate" and "forbidden overlay" must be a typed
    capability, not a prose distinction, or it cannot be enforced.
