# Challenge Questions — NAZAROV (data-layer boundary)

The boundary I hold: the surface where NAV price inputs, the benchmark level, the
financing rate, intraday observations, and externally-sourced moves cross into §6's
closed system and pay out as irreversible cash. Conservation is silent about every
value these questions attack.

1. **The mutable-source replay break.** NAV prices
   (`UnitStatus[u].last_settlement_price`) and the benchmark level (`UnitStatus[u_bench]`)
   live in the `UnitStatus` map, which A1 defines as *mutable, shared, overwritten in
   place, unversioned*. The spec's own determinism clause (L1418) requires "replays use
   the stored snapshot, not a live feed." When a performance fee crystallised at `t_k`
   is replayed after `UnitStatus[u_bench]` has been overwritten at `t_{k+1}`, what value
   does the replay read — and if the answer is "the new one," in what sense is the fee
   reproducible? Either the consumed value is captured into the immutable crystallisation
   `StateDelta`, or §6 contradicts L1418. Which is it, and where is the capture specified?

2. **The discharge gap on the move-generation function.** L1642 mandates that
   value-dependent settlements be gated on staleness and cross-source validation and
   *deferred* when price quality is insufficient; L2644 wires that gate into *lifecycle*
   workflows. The §6 managed-account contract (Observe/Crystallise/Reset, L829–848), the
   TRS contract (L904–920), and the periodic-settlement move (L946–956) contain no gate,
   no threshold, no fallback, no deferral state. By what mechanism does a clock-triggered
   reset at a fixed `t_k` *not* fire on a stale or absent price — and if there is none,
   isn't that a silent fallback that moves real client cash?

3. **`source` as a free string.** A subscription credit, a trade-capture confirmation,
   and a redemption settlement all enter as externally-originated moves whose `source`
   field is an unverified free string (L843, L917, L953). What in the schema prevents a
   gateway or operator from minting a perfectly conserved move (`Σ_w Δ(u)=0`) carrying a
   fabricated `source` and timestamp? If nothing does, then P1 is providing false comfort:
   conservation faithfully moves cash on a forged provenance. Is `source` a trust
   assumption with a named owner, or an unauthenticated admission path?

4. **The benchmark level has weaker discipline than `P_t`.** The fault-tolerance and
   determinism clauses (L1642, L1418) speak of "price feeds" and "market data." The
   benchmark level directly sets the performance-fee *hurdle* — client money — yet it gets
   no staleness rule, no fallback chain, no cross-source check, and is homed in mutable
   `UnitStatus[u_bench]`. Why is the one oracle that gates the performance fee treated as a
   passive shared scalar rather than a first-class, attested NAV input?

5. **`None` price and partial NAV.** For an unsettled or illiquid unit,
   `UnitStatus[u].last_settlement_price` is `None` (A1 ~L253). The NAV projection
   `V^ref_t = Σ_u w_ref(u)·P_t(u)` then has no defined summand for that unit. Does the
   reset compute over `None` (undefined), skip the unit (silently understating NAV), or
   refuse to fire? If the schema permits `None` to flow into a `Σ` that mints cash, that is
   a representable illegal state on the settlement path — where is it excluded?

6. **The financing rate `r_k` is an unflagged oracle.** The TRS settlement
   `Payment_k = N_k·TR_k − N_k·r_k·Δt_k` (L906) consumes an external interest-rate fixing
   `r_k`. No data-quality, snapshot, or attestation language in the spec mentions it. It is
   on the same consequence class as `P_t` — it directly sizes a real cash move. Why is
   `r_k` not subject to the same freshness gate, snapshot binding, and attestation as the
   price vector, and where is it captured into the immutable record?

7. **Cross-ledger price consistency is asserted, not bound.** L922 *warns* that the `ℒ_v`
   valuation and the `ℒ_r` TRS `Payment_k` must use "the same price vector … or unexplained
   PnL," but specifies no enforcement. Two dereferences of mutable `UnitStatus` at nominally
   the same `t_k` can return different values if an overwrite interleaves. What structurally
   guarantees both computations read one identical, content-addressed snapshot — rather than
   reconciling divergence after the cash has already crossed in `ℒ_r`?

8. **Path observations vs state-sufficiency.** State-sufficiency (L516) says `V_t` depends
   only on *current* state. But `triggered_barrier`, `nav_index`, `vol_realised`
   (A1 ~L236) drive QIS rebalance and wind-down (real trade moves), and an intra-period
   barrier *touch* is path-dependent — not reconstructible from reset-time `V_t`. When a
   barrier breach between `t_{k-1}` and `t_k` is written to `UnitStatus[u_QIS]` by an
   external observer, what attests that observation, and how is it replayed if the only
   stored state is the reset-time snapshot? Is the path observation in the immutable record
   at all?

9. **Corrections after a settled crystallisation.** L1648 gives a correction algebra and
   flags it an open problem; L1807 notes a `CORRECTION` may require settlement reversal if
   the original already settled. §6 never states what happens when a vendor restates `P` or
   the index restates a level *after* `Perf_k` or a fee has crystallised and the cash has
   moved. Is the correction a new snapshot version plus a compensating, linked transaction —
   or an `UnitStatus` overwrite that silently re-bases history and breaks "as known at `t`"
   vs "with corrections through `t'`"? The framework has no answer here; is this an
   escalation?

10. **Behaviour at exactly the staleness threshold.** Resets are clock-triggered at a fixed
    schedule `{t_k}`. Suppose at `t_k` the freshest attested price is exactly at the
    staleness limit, or multi-source aggregation returns a *flagged disagreement* rather than
    a value. The clock says "fire"; the data says "do not trust." Which wins, what cash (if
    any) moves, and is the resulting deferral a recorded first-class event or an implicit
    skip? An undefined boundary here is a determinism hole.

11. **Multi-mandate composition and snapshot sharing.** A base + overlay on one wallet is
    two rows `(w_client, u_MA,base)` and `(w_client, u_MA,overlay)`, each crystallising on
    `P_t`. If both reset at the same `t_k`, must they consume one identical content-addressed
    snapshot, or can the base fee and the overlay fee be computed off two different reads of
    mutable `UnitStatus`? If the latter is representable, two fees on the same wallet at the
    same instant can disagree on the price — where is that excluded?

12. **VALU substantiation from the CDM event.** The forgetful map `F` keeps wallet-level
    valuation arithmetic *out* of the CDM payload (L1999), and the price snapshot is not
    hash-bound to the `BusinessEvent`. The EMIR daily VALU field is computed from the price
    oracle. How is a reported VALU number substantiated from the stored CDM event alone, when
    the event does not carry — and is not cryptographically bound to — the price snapshot it
    was computed from? Doesn't this leave the reporting boundary and the valuation boundary
    needing the same snapshot object that §6 never produces?

13. **P8 snapshot consistency excludes the price vector.** Invariant P8 (snapshot
    consistency, L2046) covers balances and unit-state but not the external price vector.
    §6.9 balance-sheet substantiation is a deterministic projection of the move stream —
    *in quantity*. But the *valued* balance sheet at a reporting date depends on the price
    snapshot, which is not hash-bound to the move stream. Does "snapshot consistency" give
    false comfort by appearing to cover a valued statement it does not? Replay of the printed
    number is only as reproducible as the mutable `UnitStatus` price it used — confirm or
    refute.

14. **Key management for any attestation claim.** Every requirement that a NAV/benchmark/rate
    datum "arrive with a verifiable signature from an identified provider" presupposes a key
    lifecycle the spec never addresses. If a provider key is rotated or *revoked* mid-period,
    are snapshots signed under the old key before revocation still valid at replay — and what
    distinguishes "signed before legitimate rotation" from "signed by a compromised key"?
    Without generation/rotation/revocation/recovery rules, attestation is decorative. Who
    owns this key lifecycle, and what is the violation consequence of a silent compromise?

15. **CSA margin reference data is also an oracle.** The CSA margin contract (L859) reads
    aggregate MTM (`P_t` again) but also consumes eligible-collateral haircuts, thresholds,
    and MTA — and a haircut is itself a market-risk parameter that can be an external input.
    A wrong haircut mis-calls margin and moves real collateral. Are these reference-data and
    risk-parameter inputs attested, version-pinned, and snapshot-bound like `P_t`, or are
    they an unguarded second class of oracle on the margin path?

16. **Untyped trust at every boundary row.** Every trust assumption the §6 settlement path
    relies on — TA-PRICE, TA-BENCH-LEVEL, TA-BENCH-ID, TA-RATE, TA-SOURCE, TA-OBS,
    TA-CUSTODY — currently has owner "TBD." Untyped trust (no named owner, no violation
    consequence, no detection signal) is forbidden at a boundary that pays out irreversible
    cash. Is the governance gap that leaves these owners unassigned an A1-style framework risk
    (cf. F2's ungoverned C8 predicate ownership) that should be escalated rather than papered
    over?
