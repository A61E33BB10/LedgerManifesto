# §6 Review — ISDA Board Advisor lens

Scope of my Step-2 charge: **TRS as synthetic managed account (§6.7, l.890–933)**, **CSA
margin as a wallet-level contract (§6.4, l.857–861)**, and **the CDM representation of the
mandate `u_MA` and of the TRS**. I derive from the primitives and from the spec's own CDM
section (§CDM, l.1889–1999) and Regulatory section (l.2169–2185); I invoke ISDA/CDM/DRR
positions only where the spec itself adopts CDM as the canonical vocabulary (l.1893). I do
not appeal to market practice except where the spec already does (l.859 "this is how
bilateral CSAs work in practice").

---

## A. The managed-account workflow, walked step by step (my charge's slice)

I take the nine-stage workflow as given by the briefing and the other eight reads, and I
audit only the stages where my lens is load-bearing: **TRS/synthetic settlement (§6.7)**,
**CSA margin (§6.4)**, and the **CDM faithfulness of `u_MA` issuance and of the TRS unit**.
The other stages (mandate issuance conservation, subscription, NAV, fee accrual/HWM,
segregation, redemption, balance-sheet substantiation) I accept as correctly derived by
correctness-architect, formalis and finops, and I build on their findings rather than
re-derive them.

### Stage: mandate issuance — the CDM home of `u_MA`

By the issuance law (briefing §1; A1 §4) `w_mgr(u_MA)=−1, w_client(u_MA)=+1`, `Σ_w w(u_MA)=0`.
Conservation holds. My question is the one the spec defers (A1-F5): **what is `u_MA` at the
CDM boundary?**

In my independent read I called this "no native CDM product type for an investment mandate"
(B1). On a full pass of §CDM I refine that to a **constructive** finding, derived from the
spec's own decomposition of CDM (l.1899–1907): the CDM offers *five* components, and the spec
in §6 has been reaching for the wrong one. A discretionary investment-management agreement is
**not** a `Trade`/`Product` (the product model, l.1902, describes *tradable contracts* with
quantity/price/payouts). It is a **legal agreement** — the same CDM stratum that carries the
ISDA Master Agreement and the CSA. CDM models legal agreements distinctly from products, and
ISDA Create is the production digitisation path for exactly this class of document.

This refinement matters because it **simultaneously discharges three of the open risks** the
other lenses logged:

1. **banking-auditor's "u_MA must be a zero-value memo unit, `P_t(u_MA)=0`, excluded from
   `V_t` and RWA"** — a CDM legal agreement carries *no valuation* by construction (it is not
   a payout). Mapping `u_MA` to the legal-agreement stratum makes its non-valuation a property
   of its type, not a hand-applied exclusion. This is the cleaner encoding of the auditor's
   requirement.
2. **A1-F5 / regulatory-reporter F5 "is `u_MA` issuance EMIR/SFTR-reportable?"** — a legal
   agreement is generally **not** an EMIR derivative or an SFTR SFT. The reportable surface is
   the *synthetic TRS exposure the mandate wraps*, never the mandate handle itself. So the
   default answer to F5 is "not reportable as a derivative," and it is *provable from the type*
   rather than asserted per firm.
3. **The hand-set `ProductTerms[u_MA].reportable` boolean (A1-F5 mitigation, l.362)** — I
   maintain my independent-read objection (B2): a hardcoded, firm-set reportability flag is
   precisely the human-interpreted regulatory logic that DRR exists to eliminate, and the kind
   of divergence that has cost the industry roughly \$300M in misreporting fines. Once `u_MA`
   is a CDM legal agreement, the flag's **value is derivable** by DRR-style eligibility logic
   running over the agreement's CDM representation, with a traceability link from the decision
   to the rule. Derive, do not assert. The flag stays as a *cache of a computation*, never as
   a primary input.

**Finding M1.** `u_MA` should be mapped to CDM's legal-agreement stratum (ISDA Create /
`LegalAgreement` family), not its product/`Trade` stratum. This is non-valued by type
(satisfies banking-auditor), non-reportable-as-derivative by default (resolves F5), and makes
the `reportable` flag a DRR-derived computation rather than a hand-set boolean (satisfies my
DRR conviction). None of this touches conservation; it is a boundary/interoperability fix.

### Stage: trading-under-mandate — quantitative guards as CDM validation (§6.5)

§6.5 (l.865) maps quantitative mandate constraints to "validation rules evaluated before a
`BusinessEvent` is admitted." This is the correct CDM mapping and DRR-ready: CDM validation
rules are exactly deterministic admit/reject predicates. I concur, with formalis's caveat
(their B6) that value-based limits (leverage, concentration-by-value) are **price-relative**:
"same wallet state + same trade ⇒ same decision" (l.865) is false when the price vector
moves. The CDM validation function must take `P_t` as an explicit input; otherwise the
determinism claim is unsound. Agreement with formalis, not tension.

### Stage: §6.4 — CSA margin as a wallet-level contract

The construction (l.857–861) is the **strongest-aligned** part of my charge. `CollateralProvisions`
attaching at Trade level to indicate *which* CSA governs, while the margin calculation runs at
the portfolio/wallet (per-counterparty collateral wallet) level, is a faithful rendering of
the CDM `Collateral` model — CDM declares collateral terms at the contract level and the
netting set at the CSA level. The spec is correct that "this is how bilateral CSAs work"
(l.859). Three findings, derived:

**Finding C1 (gap between §6.4 and §6.7 — which MTM does the CSA read for a *synthetic*
account?).** §6.4 says the CSA contract reads "the aggregate MTM of all trades governed by
that CSA." But for a synthetic managed account (§6.7) the economically-exposed trades live in
the **virtual ledger `ℒ_v`**, which holds no real assets and is connected to no custody
(l.872, l.875). P7 isolation forbids margining or reporting the simulated `ℒ_v` constituents.
The trade actually governed by the real CSA is the **single real `u_TRS` unit in `ℒ_r`**, and
its MTM is the accrued `N_k·TR_k` performance, not the sum of virtual constituent MTMs.
§6.4 and §6.7 are not wired together: the spec never states that the CSA margin contract
reads the real TRS unit's MTM, not the virtual book's. As written, a naive implementation
that "reads all trades under the CSA" could either (a) reach across the `ℒ_v↔ℒ_r` boundary
(violating P7) or (b) margin nothing (the real CSA sees only one TRS unit whose MTM source is
undefined here). This must be specified: **for synthetic accounts the CSA netting set is the
set of real `u_TRS`/cleared units in `ℒ_r`; the virtual book is never in the netting set.**

**Finding C2 (CSA margin is itself a daily EMIR-reportable surface; the report must derive
from a CDM collateral event, not the bare margin-call `Move`).** Bilateral margin under EMIR
Refit carries daily collateral reporting (MARU/collateral fields) and the §6.4 contract emits
"margin-call moves." A bare `Move` to/from the collateral wallet carries the *quantity* but
not the CDM collateral event (eligible-collateral type, haircut, threshold, MTA applied,
valuation). This is the same source-of-record problem I raise for the TRS (Finding T3 below):
the move stream has the economic substance; the *report* needs the CDM `BusinessEvent`/margin
event preserved by the forgetful map `F` (l.1978). The §6.4 listing must construct that event,
not just the cash move.

**Finding C3 (tokenised-collateral readiness — a genuine forward strength, derived from the
unit primitive).** The Unit primitive admits "anything that can be a wallet balance"
(briefing §1). Eligible collateral posted into the per-counterparty collateral wallet is just
a set of units. Nothing in §6.4 assumes those units are conventional cash or securities;
a tokenised MMF unit or a tokenised bank-liability unit is admissible at the same seam, with
the same conservation and the same CDM `Collateral` provisions. The wallet abstraction is
therefore **already structurally ready** for the tokenised-collateral direction of travel
(ISDA's tokenised-collateral model provisions for 2016 CSAs). This is the correct place to
note that readiness; no change is needed, but it should be stated as an explicit property of
the design rather than left implicit.

### Stage: §6.7 — TRS as synthetic managed account, and its CDM representation

The economic formula `Payment_k = N_k·TR_k − N_k·r_k·Δt_k` (l.906) is sound and **maps
cleanly to a CDM `TotalReturnSwap`**: the first term is the return/`PerformancePayout` leg,
the second is the financing/`InterestRatePayout` leg, netted to one settlement. The spec's
claim that "CDM's `TotalReturnSwap` product type maps directly" (l.933) is correct *for the
two-legged TRS*. Three findings:

**Finding T1 (the "structural identity" of TRS = periodic-reset = managed-account is an
economic analogy, not a CDM product identity — and the conflation is unsafe).** §6 asserts a
single mechanism: the managed-account reset (`Perf = V_tk − V_tk−1`, l.826, one move), the
periodic book settlement (l.951, same), and the TRS (`Payment_k = N_k·TR_k − N_k·r_k·Δt_k`,
l.906) are "identical" (l.851, l.958). At the *cash-conservation* layer they are the same:
one net move, `src−=q; dst+=q`. But at the **CDM product layer they are not the same object**:

- The TRS is a **two-legged product with a notional** `N_k` and a **financing leg**
  `N_k·r_k·Δt_k`.
- The managed-account/desk reset is **single-leg, no notional, no financing** — it is a raw
  performance crystallisation.

This matters for reporting and for code generation. EMIR requires the TRS's financing rate
and both legs; a managed-account reset has neither. A CDM `TotalReturnSwap` representation
applied to a desk-vs-Treasury reset would manufacture a phantom financing leg and a phantom
notional; conversely, generating the TRS settlement from the single-leg `Perf` formula drops
the financing leg from the report. The "one mechanism" claim is true as *cash algebra* and
false as *CDM product taxonomy*. The two must share the settlement primitive but carry
**distinct CDM product representations** — `TotalReturnSwap` for §6.7, no derivative product
(an internal allocation / `LegalAgreement`-governed transfer) for the desk reset.

**Finding T2 (the virtual-ledger basket underlier has no native UPI/ISIN — incomplete EMIR
underlier field).** P7 correctly prevents reporting the simulated `ℒ_v` constituent trades
(l.924, l.927) — that is right. But the reportable real TRS still needs its **underlier
identified**: CDM `TotalReturnSwap.underlier` requires a product/basket reference, and EMIR
needs a UPI/ISIN or a full basket-constituent list. A bespoke `ℒ_v` index (l.972 "custom
indices and baskets") may have **no ANNA-DSB UPI and no ISIN**. The design must require that
every `ℒ_v` basket backing a real TRS publishes a CDM basket-constituent description that the
report can consume. I concur with regulatory-reporter's break-4 and ground it in the CDM
underlier field.

**Finding T3 (the reset/TRS settlement emits a bare `Move`, not a CDM `Transfer`/`BusinessEvent`
— so the report source-of-record is missing for exactly the synthetic population).** The §6.7
listing (l.910–920) and the §6.8 listing (l.946–956) emit a `Move` with a free-string
`metadata: "TRS_NET_SETTLEMENT"`. The spec asserts "`Transfer` events correspond to periodic
settlement moves" (l.933), but a `Transfer` event is a CDM `BusinessEvent` primitive, **not**
a free-string-tagged `Move`. For *ingested* trades the forgetful map `F` (l.1978) preserves
the whole CDM event in the log payload, so reports derive from a real CDM artefact. But the
reset/TRS settlement move is **synthesised by the contract**, not ingested — there is no
upstream CDM event for `F` to preserve. Unless the reset/TRS handler *constructs* a CDM
`BusinessEvent` containing a `Reset` primitive (the `TR_k` observation) and a `Transfer`
primitive (the cash), the move stream carries the economic substance but no CDM event to
report from. This is the concrete cause behind A1-F6 ("CDM `TradeState`-per-`Trade` vs
`PositionState[w,u]` alignment asserted, not verified," l.364): the alignment cannot be
verified for contract-generated settlements until the contract is required to emit the CDM
event. **Recommendation: the crystallise/TRS/settlement handlers must emit a CDM
`BusinessEvent` (Reset + Transfer), and the F6 mitigation (rerun Rosetta NS1–7 against the
3-map schema, publish a delta, l.364) must precede any DRR adapter work. Until that delta
exists, "CDM-native" is asserted, not shown.**

**Finding T4 (price consistency is a CDM observation-source obligation, not a runtime
nicety).** §6.7's price-consistency clause (l.922) — `ℒ_v` valuation and `ℒ_r` settlement must
use the same `P_t`, or unexplained PnL — is correct and aligns with how CDM observation terms
work: the price source belongs on the `PerformancePayout`'s observation terms and is
*contractually specified*, not bilaterally chosen at runtime. I agree with nazarov and minsky
that this must additionally be *enforced* by binding both computations to one immutable
price-snapshot id (hash-verifiable), not merely asserted. CDM gives the *contractual* slot;
nazarov's content-addressed snapshot gives the *runtime attestation*. Both are needed and they
are complementary, not competing.

### Stage: §6.9 — balance-sheet substantiation

§6.9 (l.960–962) — each account balance is a deterministic projection of the filtered move
stream; no internal record to reconcile; external records require boundary reconciliation —
is sound and is the cleanest expression of the design's value. My only addition, consistent
with regulatory-reporter MH-4 (l.348) and banking-auditor: substantiation by projection
covers *quantity and economic value*; it does **not** discharge the EMIR daily VALU/collateral
reporting cadence, which is independent of the crystallisation schedule (`V_t` is
state-sufficient at any `t`, so arbitrary-`t` projection is available, but the reporting
trigger must be wired separately). Agreement, not tension.

---

## B. Net assessment

The TRS and CSA-margin constructions are **architecturally aligned with the CDM-native
direction of travel** and, for the CSA, already tokenised-collateral-ready (C3). Four seams in
my charge are misaligned and must be fixed before code ships:

- **M1** — map `u_MA` to CDM's legal-agreement stratum, not the product stratum; this
  discharges F5, the auditor's zero-value-memo requirement, and reduces the `reportable` flag
  to a DRR-derived computation.
- **C1** — wire §6.4 to §6.7: the synthetic CSA netting set is the real `u_TRS` units in
  `ℒ_r`, never the `ℒ_v` book (else P7 breach or under-margining).
- **T1** — split the "one mechanism" claim: shared *settlement primitive*, **distinct CDM
  product representations** (two-legged `TotalReturnSwap` for §6.7; no derivative product for
  the desk reset). Conflation drops the financing leg from TRS reports or invents one for desk
  resets.
- **T3 / C2 / F6** — the reset, TRS, and margin handlers must emit CDM `BusinessEvent`s
  (Reset + Transfer / collateral event), not bare free-string-tagged `Move`s, or DRR has no
  source-of-record for the contract-generated population. Close F6 with the Rosetta delta
  first.

None of these breaks conservation. All four are boundary/interoperability risks — which is
exactly where this framework meets the regulated world, and exactly where the \$300M of
avoidable misreporting fines were paid.

---

## C. Tensions logged (mine, with named lenses)

**T-jane-street-cto / T-correctness-architect — on "TRS = periodic reset = managed account
is the right refactor / same contract."** jane-street-cto calls the collapse "the right
refactor" and correctness-architect/finops/formalis accept the three as one mechanism. I
dissent at the **CDM product layer** (my Finding T1): a CDM `TotalReturnSwap` is two-legged
(return + financing) with a notional; the managed-account `Perf = V_tk − V_tk−1` is
single-leg, no notional, no financing. They are the same *cash primitive* but different *CDM
products*. Conflating them in one code path drops the TRS financing leg from EMIR reports or
fabricates a phantom notional on desk resets. Must be resolved: share the settlement
primitive, separate the product representation.

**T-regulatory-reporter — on whether the reportable CDM `BusinessEvent` actually exists for
contract-generated settlements (their MH-1).** regulatory-reporter's MH-1 assumes "report
source = the stored CDM event, which `F` keeps whole in the log." That holds for *ingested*
trades. It does **not** hold for the reset/TRS/margin settlement, which is *synthesised by the
contract* and emitted as a bare `Move` with free-string metadata (l.910–920, l.946–956) — `F`
has no upstream CDM event to preserve (my Finding T3). I claim the design currently cannot
satisfy MH-1 for exactly the synthetic/TRS/margin population; regulatory-reporter assumed it
could. Resolution: require the handlers to construct the CDM `Reset`+`Transfer` event.

**T-banking-auditor — on the scope of excluding `u_MA` from value and exposure.** banking-auditor
asserts `u_MA` is a zero-value memo unit to be excluded from `V_t` **and from RWA/exposure**.
I agree the *handle* is non-valued (and M1 makes that a property of its CDM type). But the
exclusion must **not** extend to the *synthetic exposure the mandate wraps*: under §6.4 the
CSA margin and under Basel the counterparty exposure of the real `u_TRS` are valued, margined,
and reportable. If "exclude `u_MA`" is read as "exclude the relationship's economic exposure,"
margin (C1) and RWA are understated. The boundary between the non-valued mandate handle and
the valued synthetic exposure it carries must be drawn explicitly; we agree on the handle,
we must not over-extend the exclusion.
