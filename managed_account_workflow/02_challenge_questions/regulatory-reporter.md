# Challenge Questions — `regulatory-reporter` lens

Fifteen questions attacking the managed-account workflow (§6 + Addendum A1) from the
regulatory-reporting boundary. Each either has a concrete answer derivable from the primitives
or exposes a genuine framework flaw worth escalating. None re-state a finding; each pushes past it.

1. **UTI determinism under replay.** The CPMI-IOSCO UTI waterfall assigns a *generating party*
   from the counterparty-LEI pair and an agreed tie-break — an external negotiation, not a function
   of the move stream. A UTI therefore cannot be recomputed on replay; it must be *persisted*. But
   a UTI is reference data, not economic state, so it lives in none of the three economic maps
   (`ProductTerms` is product-level and shared; `PositionState` is per-`(w,u)` economic). Where is
   the assigned UTI stored such that a deterministic, bit-identical replay reproduces the *same*
   report, and what guarantees it is read back rather than regenerated?

2. **Reference-data-only correction is not a representable event.** A reportable EMIR `MODI`/`CORR`
   or `EROR` that fixes a wrong reported LEI, UTI, or UPI corresponds to **no economic move** — the
   trade economics are unchanged. C2 requires every event handler to emit a `StateDelta` with
   `Σ_w Δf(w,u) = 0`; a pure reference-data correction has a zero delta on every key. Such a
   reportable lifecycle event is thus not expressible as an event in the stream. How is a
   reference-data-only correction recorded, replayed, and evidenced as a distinct regulatory action?

3. **Daily VALU has no triggering event on a quiet day.** EMIR requires daily `VALU` (and `MARU`)
   for every open derivative, yet valuation is a pure read `V_t = Σ w·P` that emits no move (step 4).
   On a day with no trades the event-sourced, append-only stream records nothing. What event drives
   the daily VALU report, and how does a move stream that is silent on quiet days *evidence* that the
   daily obligation was discharged — i.e. distinguish "valued, unchanged" from "not valued"?

4. **SFTR reuse reporting demands the cross-wallet read C4 forbids.** SFTR collateral-reuse
   reporting (Art 4; estimated reuse) requires aggregating a single security's reuse across the
   entire firm — exactly the cross-`(w, u)` overlay read that C4 declares *forbidden*, with strategy
   exports flowing only through `UnitStatus`. Can reuse be computed at all without breaching the
   capability-scoped read discipline, and if it must route through `UnitStatus`, what conservation
   or determinism cost does that impose?

5. **Is the `τ` timestamp the regulatory execution timestamp?** EMIR field 2.42 (and RTS 22) require
   an execution timestamp in UTC at mandated granularity. A transaction `τ` carries one shared
   timestamp, with an arbitrary total order breaking ties. If two economically distinct trades share
   one `τ` timestamp, their reports carry identical execution times while the counterparty timestamps
   them distinctly — a guaranteed pairing/matching break at the TR. Is `τ.t` the regulatory execution
   timestamp or a booking time, and where does the true execution instant live?

6. **The discretionary decision-maker is absent from the trade's move.** RTS 22 requires both the
   buyer/seller (the client) *and* the investment-decision-within-firm identifier (the manager,
   field 57). A trade under mandate is a move between custody/CCP and the *client* wallet; the
   *manager* wallet is not a party to it. The decision-maker LEI is therefore nowhere in the trade's
   move algebra. From which primitive is the decision-maker LEI sourced, and how is the mandate link
   (`u_MA` holder → decision-maker) carried onto the trade report?

7. **Timeliness is unverifiable from the immutable stream.** EMIR T+1 (one working day) and CFTC
   Part 43 "as soon as technologically practicable" are wall-clock obligations. Deterministic replay
   reconstructs economic state but not *submission* times. The timeliness obligation cannot be checked
   from the conservation-closed stream alone. Where is the submission timestamp recorded — inside the
   closed system (and if so, as what, since it is not an economic fact and breaks state-sufficiency)
   or outside it (and if so, what binds it to the immutable event it reports)?

8. **A basket rebalance inside `ℒ_v` silently staleness the EMIR underlier.** A custom-basket TRS
   rebalances *inside* `ℒ_v`; P7 forbids any `ℒ_v↔ℒ_r` crossing, and the reported underlier must come
   from `ProductTerms[u_TRS]`. If a rebalance is purely an `ℒ_v` move with no `ℒ_r` event, no `MODI`
   fires and the reported underlier/notional goes stale — under-reporting. If instead a rebalance must
   author a Preserving `TermsVersion` on `u_TRS` to trigger a `MODI`, what couples an `ℒ_v` move to a
   `ProductTerms` amendment *without* crossing the isolation boundary the same invariant protects?

9. **Reportable derivative with no populable UPI is a representable illegal state.** A bespoke-index
   TRS may have no ISIN and no DSB UPI/underlier mapping, yet the EMIR UPI/underlier field is
   mandatory. The model can represent such a `u_TRS` and emit its real settlement move while the
   report cannot be completed. Is "admitted, reportable derivative with no representable UPI" a
   representable-but-illegal state, and what rejects it at `BusinessEvent` admission rather than at
   TR rejection downstream?

10. **The move algebra cannot tell intragroup from external.** Desk↔Treasury is treated as
    non-reportable on intragroup/internal grounds, but the EMIR Art 3 intragroup exemption requires
    same-group entities *and*, in cases, a notified-and-non-objected NCA exemption. Conservation makes
    an internal wallet and an external virtual wallet algebraically identical (`−1/+1`, `Σ=0`). What
    attribute marks a counterparty wallet as intragroup, where is the NCA-notification/exemption status
    stored, and what stops a mis-tagged internal wallet from suppressing a genuinely reportable trade?

11. **Trade-level reporting vs position-level state under compression.** EMIR requires OTC
    derivatives reported at *trade* level (position-level only where permitted, e.g. ETDs); the model
    keys economic state at `PositionState[w,u]` (position level), and F6 asserts but does not verify
    `TradeState`-per-`Trade` ↔ `PositionState[w,u]` alignment. When compression collapses many trades
    into one position row, where are the individual trade UTIs preserved so each can be `TERM`-reported
    and so a later `EROR` can reference exactly one of the compressed trades?

12. **Reporting-responsibility allocation lives nowhere in the move algebra.** EMIR Refit makes the FC
    the reporting counterparty for an NFC− (mandatory responsibility allocation), and managers
    routinely report on behalf of clients. "Who reports" and "who is legally responsible" are legal
    allocations absent from moves. Where is the RC / mandatory-delegation / voluntary-delegation
    allocation stored, does it travel with the trade (unit) or with the relationship (`u_MA` row), and
    what keeps it consistent when one wallet's classification (FC↔NFC±) changes mid-life?

13. **The closed system cannot represent a counterparty disagreement.** Conservation guarantees
    *internal* consistency, but EMIR/SFTR are dual-sided: the counterparty independently reports its
    own UTI, notional, and valuation, and pairing/matching happens at the TR. A pairing or
    reconciliation break is a fact originating *outside* both ledgers — the abstraction "external
    counterparties are virtual wallets, the ledger has no outside" denies it exists. How is an inbound
    TR pairing/reconciliation break represented and remediated without mutating the append-only,
    hash-chained stream that is supposed to be the sole source of truth?

14. **LEI temporality vs `WalletRegistry` mutability.** `WalletRegistry` binds wallets to LEIs and is
    explicitly *not* economic state. An LEI can lapse, be transferred under M&A, or change over the
    life of a multi-year TRS. A historical execution report must carry the LEI valid *at execution*; a
    current outstanding-position report must carry the *current* LEI. Is the `WalletRegistry` LEI
    binding versioned/temporal, or a mutable single value whose update would retroactively corrupt
    every historical report on replay — and if versioned, why is that not economic state?

15. **One move shape, two regulatory characters.** A managed-account crystallisation `w_cli_cash →
    w_mgr_cash` (or `w_payer → w_receiver`) is, in one configuration, a non-reportable IMA performance
    fee, and in another, a reportable TRS financing leg `N·r·Δt` — the *same* move shape, same sign,
    same mechanism. MH-1 forbids deriving the report from the net move at all; it must come from the
    gross CDM event. What attribute on the admitted `BusinessEvent` deterministically distinguishes a
    non-reportable fee from a reportable TRS cashflow, and is that attribute guaranteed present *before*
    the move is emitted, or inferred afterward (and thus a representable mis-classification)?
