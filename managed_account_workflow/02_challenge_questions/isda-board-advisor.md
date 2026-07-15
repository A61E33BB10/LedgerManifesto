# Challenge Questions — ISDA Board Advisor lens

Fifteen questions attacking the managed-account workflow from the CDM/DRR/reporting/
tokenisation-conformance lens. Each is derived from the primitives and the spec's own CDM
(l.1889–2018) and Regulatory (l.2169–2189) sections, not from market practice.

1. **The mandate unit has no CDM anchor (conformance gap).** Unit identity is defined as "OTC
   unit identity = full CDM `Trade` incl. `Collateral`" (briefing §1). `u_MA` is admitted as a
   unit but a discretionary mandate is not a CDM `Trade`/`Product`. Does `u_MA` therefore
   escape the unit-identity discipline entirely, or is there a defined CDM anchor (the
   legal-agreement stratum) that supplies its identity? If none, two non-fungible mandates
   could collide on one `UnitId`.

2. **Phantom financing leg is representable (representable illegal state).** Nothing in the
   schema prevents a desk-vs-Treasury single-leg reset (`Perf = V_tk − V_tk−1`, no notional,
   no financing) from being serialised as a CDM `TotalReturnSwap` with a fabricated notional
   and `InterestRatePayout`, or conversely a real §6.7 TRS settlement from being emitted via
   the single-leg `Perf` formula that drops the financing leg from the EMIR report. What
   construct makes the phantom-leg / dropped-leg state *unrepresentable*, rather than merely
   discouraged by the "one mechanism" prose (l.851, l.958)?

3. **Which MTM does the synthetic CSA read (determinism boundary / P7 isolation).** §6.4 says
   the CSA contract reads "the aggregate MTM of all trades governed by that CSA," but for a
   synthetic account the constituents live in `ℒ_v` (no custody, l.872). What in the type
   system forces the netting set to be the real `u_TRS` units in `ℒ_r` and *prevents* the
   handler from reaching across the `ℒ_v↔ℒ_r` boundary (P7) to sum virtual constituent MTMs —
   the choice between which is the difference between a P7 breach and silent under-margining?

4. **The virtual counterparty has no LEI or paired UTI (conformance gap).** The conservation
   law models external counterparties as virtual wallets inside the closed system (briefing
   §1). EMIR/CFTC dual-sided reporting requires a counterparty LEI and a paired UTI on the
   real `u_TRS`. How does a virtual-wallet counterparty acquire the LEI and the UTI the report
   demands, and what reconciles the ledger's "no outside within scope" with the regulator's
   requirement that a real legal entity sit on the other side?

5. **No CDM event for `F` to preserve at synthesis (accounting / source-of-record gap).** For
   ingested trades the forgetful map `F` (l.1978) keeps the whole CDM `BusinessEvent` in the
   log. The reset/TRS/margin settlement is *synthesised* by the contract and emitted as a
   `Move` with free-string `metadata: "TRS_NET_SETTLEMENT"` (l.910–920). Can the handler
   deterministically *reconstruct* a CDM `Reset`+`Transfer` event from ledger state alone, or
   is reportable substance (observation source, leg breakdown, reset rate) irrecoverably lost
   at the moment of synthesis?

6. **Firm-coded reportability is the divergence DRR exists to kill (hidden assumption).** The
   `reportable` flag (A1-F5) and the §6.5 quantitative mandate guards are firm-coded
   smart-contract predicates — precisely the human-interpreted regulatory logic that has cost
   the industry ~$300M in misreporting fines. What guarantees two firms running this ledger
   emit *identical* reportability and admit/reject decisions for the same mandate and trade,
   rather than each encoding its own interpretation? Is there a DRR-golden-source binding, or
   is the predicate primary firm input?

7. **Mandate amendment vs conservation (edge case / fungibility governance).** Under C8 a
   mid-life fee-schedule change is either Preserving (append `TermsVersion`) or Breaking
   (allocate fresh `u` + `SupersededBy`). F2 logs that ownership of the predicate is
   ungoverned. If a fee change is judged Breaking, the client's `+1` in old `u_MA` must move to
   new `u_MA'`; how is that reallocation performed without a phantom move that breaks
   `Σ_w w(u_MA)=0` on the superseded unit, and who decides Breaking vs Preserving
   deterministically?

8. **Value-based guards are price-relative (determinism boundary).** §6.5 claims "same wallet
   state + same trade ⇒ same decision" (l.865), but leverage and concentration limits are
   functions of `P_t`. Does the CDM validation function take `P_t` as an explicit,
   snapshot-pinned input so the admit/reject is replayable bit-identically, or can the same
   trade against the same balances be admitted at one price and rejected at another — making
   the determinism and audit claims unsound?

9. **Bespoke basket underlier has no UPI/ISIN (conformance gap).** A custom `ℒ_v` basket
   (l.972) backing a real TRS may have no ANNA-DSB UPI and no ISIN, yet
   `TotalReturnSwap.underlier` and the EMIR underlier field require identification. What
   *requires* every `ℒ_v` basket backing a real TRS to publish a CDM basket-constituent
   description, and what *rejects* a TRS whose underlier cannot be identified — rather than
   letting an unreportable trade reach `ℒ_r`?

10. **Collateral reuse double-count (conservation break).** The Unit primitive admits tokenised
    collateral, and the CSA contract moves it into a per-counterparty collateral wallet (C3).
    If a posted collateral unit is rehypothecated into a second counterparty's wallet, does
    `Σ_w w(u)=0` still hold, or does reuse create a representable double-count of the same
    unit? And how is SFTR collateral-reuse reporting derived from a move stream that, by
    conservation, cannot distinguish title transfer from reuse?

11. **Contract-generated reset idempotency (P6 determinism).** A TRS reset at `t_k` is
    synthesised, not ingested, so there is no upstream CDM event hash to deduplicate against.
    What makes re-running the reset handler at `t_k` idempotent under P6 — i.e., what prevents
    a second settlement `Move` — given P5/P6 idempotency was framed around replaying *ingested*
    events with stable identifiers?

12. **Reporting cadence vs crystallisation schedule (accounting cadence gap).** Balance-sheet
    substantiation is on-demand projection (§6.9), but EMIR daily VALU and collateral
    reporting cadence is independent of the reset schedule. What wires the daily reporting
    trigger, and does state-sufficiency of `V_t` at arbitrary `t` guarantee that the valuation
    in the daily report uses the *same* price snapshot as the margin call, or can the report
    and the margin diverge on price?

13. **Over-extended `u_MA` exclusion understates exposure (representable illegal state).**
    Excluding `u_MA` from `V_t` and RWA as a zero-value memo unit is correct for the *handle*.
    What prevents that exclusion from over-extending to the valued synthetic exposure the
    mandate wraps — the real `u_TRS` whose MTM drives margin (C1) and counterparty RWA? Where
    is the boundary between non-valued handle and valued wrapped exposure drawn in the schema,
    rather than left to interpretation?

14. **Tokenised-collateral eligibility and haircut (eligibility conformance).** The CSA
    contract computes required collateral using eligible-collateral type and haircut. When a
    tokenised MMF or tokenised bank-liability unit is posted, where does the eligibility and
    haircut predicate live (`ProductTerms[u_CSA]`?), and does it incorporate the Basel
    crypto-asset exposure treatment — or is tokenised-collateral eligibility hand-asserted per
    firm, reintroducing the divergence the design otherwise eliminates?

15. **Dual state machines unverified (F6 conformance gap).** A resetting TRS mutates both CDM
    `TradeState` (a `Reset` event) and `PositionState[w,u_TRS]` (`entry_nav`/baseline). F6
    logs that `TradeState`-per-`Trade` vs `PositionState[w,u]` alignment is *asserted, not
    verified*. What keeps the two state machines consistent on replay, and has the Rosetta
    NS1–7 conformance delta against the three-map schema actually been produced — or is
    "CDM-native" still an assertion that no published artefact supports?
