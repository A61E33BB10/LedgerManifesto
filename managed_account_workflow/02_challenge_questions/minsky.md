# Challenge Questions — MINSKY lens

The managed-account workflow attacked from the type lens: hidden assumptions, representable
illegal states, conservation breaks, determinism boundaries, accounting and conformance gaps.
Each question either has a concrete answer derivable from the primitives or exposes a genuine
framework flaw worth escalating.

1. **One wallet value, two HWMs.** A base + overlay wallet carries two rows
   `(w_cli, u_MA,base)` and `(w_cli, u_MA,overlay)`, each with its own HWM, yet performance is
   driven by a single per-wallet scalar `V^ref = Σ_u w(u)·P_t(u)`. What total, stream-deterministic
   function splits one wallet value into a base-`Perf` and an overlay-`Perf` whose codomains are
   disjoint and sum to `V^ref`? If none exists, the two-row schema forbids the collapsed-HWM state
   and then commingles the inputs that feed it — name the attribution primitive or concede that
   per-mandate `Perf` is non-deterministic w.r.t. the stream.

2. **`u_MA` inside `V_t`.** `u_MA` is a `Unit` and `V_t` ranges over all held units. If `P_t(u_MA)`
   is any non-zero number, the client's per-wallet NAV gains `+1·P_t(u_MA)` with no
   per-wallet cancellation (the manager's `−1` cancels only in the global sum), inflating the
   performance-fee base. Is `u_MA` structurally outside the domain of `V` (carries no price slot at
   all), or is correctness resting on an externally-supplied `P_t(u_MA)=0` that a careless feed can
   make non-zero? Show which.

3. **The monotone tag is unread.** `FIELD_SPEC["hwm"]` declares `monotone: True`, but `apply`
   enforces only `Σ=0` for conserved fields and writes non-conserved fields by blind overwrite
   `PositionState(**{**old, **diff})`. A handler emitting `hwm_new < hwm_old` type-checks and
   commits. Where is the type-level closure that makes a downward HWM write *unrepresentable*
   (a `max` combinator the carrier applies), rather than a discipline `apply` silently ignores?

4. **The default HWM is the illegal state.** `PositionState` defaults `hwm = 0.0`. A zero HWM means
   the first crystallisation charges a performance fee on the entire subscribed capital. The illegal
   initial state "HWM below entry capital" is not merely representable — it is the default. Why is
   pre-subscription `hwm` not `None` (unrepresentable-as-fee-eligible), set to `entry_nav` or hurdle
   at subscription?

5. **The unowned HWM transition.** C11 tags `hwm → fee_crystallise` and `entry_nav → subscribe`,
   but the *initial* HWM is established at subscription, not at any crystallisation. So either
   `subscribe` writes `hwm` (violating single-writer) or the initial-HWM transition has no canonical
   writer. Which is it, and where is that explicitly granted?

6. **Breaking amendment bypasses monotonicity.** A C8 fungibility-breaking amendment (benchmark
   swap, restructuring) allocates a fresh `u_MA,new` with a default `PositionState` (`hwm=0.0`).
   Monotonicity is per-`(w,u)` and does not span a `u`-transition. So a Breaking amendment silently
   resets the HWM, disguised as a restructuring, and the manager re-charges performance on recovered
   gains. What typed, audited transport carries `hwm`/`hwm_date` from `u_old` to `u_new`, and what
   makes its absence not type-check?

7. **Re-subscription into a retained zero row.** After full redemption the row is retained
   `Some(zero)` with the final HWM. A re-subscription must establish a new relationship; does it
   silently inherit the stale HWM, silently zero it, or force an explicit audited decision? The
   `None` vs `Some(zero)` distinction makes re-subscription *distinguishable* from first
   subscription — but distinguishability is not a decision. Where is the decision typed?

8. **`WalletMetadata` field creep.** The briefing tags `WalletRegistry` "NOT economic state," but
   that is a comment, not a type. If `WalletMetadata` is an open record, an implementer adds
   `hwm: Decimal` and the schema accepts it — reintroducing exactly the flat per-wallet scalar C12
   forbids, the dual of A1's own rejected "denormalisation trap." Is `WalletMetadata` a sealed type
   that admits no economic-typed field, or is C12 enforced only by convention on this map?

9. **Stored `balance` desyncs from the fold.** `PositionState` carries a `balance` field alongside
   the wallet balance `w_t(u)`, which §6.9 declares is a *projection* of the filtered move stream.
   A stored `balance` is a per-`(w,u)` scalar that can desync from the fold. Is it an authoritative
   record (then the move stream is no longer the single source of truth, contradicting §6.9) or a
   memoized projection (then it must be derivable and reconciled, not free-standing)? Pick one.

10. **The first_touch_date ruling applied honestly.** A1 ruled `first_touch_date` is NOT state — it
    is fold-derived, and caching it would desync under back-dated corrections. `hwm`, `entry_nav`,
    and `accrued_fee` are equally folds of the stream and desync identically under a back-dated
    price correction (corrected historical price → corrected historical NAV → corrected HWM path →
    every subsequent fee). By A1's own criterion these are NOT state, yet A1 homes them as mutable
    `PositionState` fields. Is the state/projection boundary drawn inconsistently, and if so, is this
    a framework escalation rather than a §6 patch?

11. **The capability-free accessor.** C4 forbids cross-`(w, u_MA)` overlay reads, but the reference
    accessor `position(self, w, u) -> Optional[PositionState]` takes no capability argument. Any
    handler reads any row, so `fee_crystallise` on the overlay can read the base row. C4 is asserted,
    not typed. What capability does the accessor take so that a cross-scope read does not type-check,
    rather than relying on handlers to behave?

12. **Signed move, four sites, one defect.** `Move` requires `q>0`, yet `Perf_k`, the §6.8
    settlement `Payment_k`, a CSA call, and the perf-settlement-to-UB are all signed and the §6
    listings hardcode `quantity: Perf_ref_k`. This is partial (non-representable for `Perf<0`) and
    illegal for `Perf=0`. Is the canonical fix `q=|x|`, direction from `sign(x)`, reject `0` — and
    is `Perf=0` a no-op transaction (empty move set) or a rejected one? The two are not the same.

13. **Segregation is a guard, not algebra.** §6 claims conservation makes cross-client commingling
    unrepresentable, but a move whose src and dst lie in different clients' partitions is perfectly
    conservative — `Move : Wallet × Wallet × Unit × q` is total over all wallet pairs. Conservation
    forbids creating/destroying quantity, not misrouting it. Where is the move-generation capability
    scoped to one partition (phantom-tag wallets by owning partition) so a cross-partition move does
    not compile, and absent it, on what basis is CASS-6 logical segregation claimed "by construction"?

14. **Reset baseline reads the pre-payout value.** §6.2 says "Reset: baseline → state at `t_k`,"
    read literally the *pre-payout* `V_{t_k}`. The next interval then measures performance from a
    baseline that still includes the gain just paid out, clawing it back (or, for the HWM, conflating
    the performance baseline with the HWM and lowering it after a loss). Is the baseline the
    post-settlement value `V_{t_k} − Perf_k`, and is that anywhere typed distinctly from the HWM so
    the two "baselines" cannot be conflated by a handler?

15. **Price consistency by prose, and `V^v ≤ 0`.** TRS settlement and `ℒ_v` valuation "must use the
    same price vector `P_t`" — but if each fetches `P_t` independently and the briefing only *checks*
    equality, an unexplained-PnL state is representable. Is one immutable `P_t` threaded into both, or
    are there two fetches and a comparison? Separately, `TR_k = (V^v_{t_k} − V^v_{t_{k-1}})/V^v_{t_{k-1}}`
    is partial at `V^v_{t_{k-1}} ≤ 0`; where is that precondition typed, and what is the total
    behaviour when a virtual book's prior value is zero or negative?
