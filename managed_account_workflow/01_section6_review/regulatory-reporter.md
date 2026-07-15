# §6 Managed-Account Workflow — Regulatory-Reporting Conformance Appendix
**Lens:** `regulatory-reporter`. **Charge (Step 2):** the reportable surface that mandate-as-unit
creates — whether `u_MA` issuance is reportable under SFTR/EMIR, and the UTI/UPI/LEI consequences.
**Status:** advisory. This is a *conformance appendix*, not workflow logic. It changes no move
algebra; it states which economic events in the §6 derivation become regulatory reports, on which
unit, and what reference data the closed system must surface at its boundary for those reports to
be *produced and paired*.

Every finding is derived from the primitives (Wallet, Unit, Move, Conservation, issuance law,
the three-map model, the forgetful CDM map `F`) and the enforceable regime text, not from practice.

---

## A. The crux: is `u_MA` issuance reportable?

`u_MA` is issued `w_mgr(u_MA) = −1`, `w_cli(u_MA) = +1`, `Σ_w w(u_MA) = 0`. This is a real move in
a real stream (jane-street-cto #4; I build on it, I do not re-derive). The question F5 leaves open
is whether *that issuance move* is a reportable regulatory event.

**Determination: a pure discretionary investment-management mandate is NOT reportable.** Derived
from the regime scope, not from convention:

- **EMIR** (Reg (EU) 648/2012, Art 9) reports *derivatives*. "Derivative" per Art 2(5) is a MiFID II
  Annex I Section C(4)–(10) instrument. A discretionary IMA is the *service* of portfolio management
  (MiFID II Annex I **Section A(4)**), not a Section C **instrument**. `u_MA` is therefore outside
  EMIR scope. No UTI, no UPI, no derivative report for the issuance move.
- **SFTR** (Reg (EU) 2015/2365, Art 4) reports SFTs. "SFT" is exhaustively defined in Art 3(11):
  repo / reverse repo, securities-or-commodities lending and borrowing, buy-sell-back / sell-buy-back,
  and **margin lending**. A bare mandate is none of these. Outside SFTR scope.
- **MiFIR transaction reporting** (Reg (EU) 600/2014, Art 26; RTS 22 / CDR 2017/590) reports
  *transactions in financial instruments*. Granting a mandate is not such a transaction. Outside RTS 22.

So the issuance move of `u_MA` is, by construction, an **internal contract-identity event, not a
reportable lifecycle event** — *for the IMA case*. This is correct and should be recorded as
`ProductTerms[u_MA].reportable = false` **with the legal basis cited**, not as a bare boolean.

**But the §6 "structural identity" deliberately runs four economically distinct relationships through
the *same* mandate-as-unit / managed-account mechanism.** This is the reporting hazard, and it cuts
both ways:

1. **Internal desk ↔ Treasury** (l.806, l.864): internal reallocation, virtual/intragroup counterparty
   — **not reportable**.
2. **PB / synthetic prime-brokerage swap**: the manager grants *synthetic* exposure — this is a
   derivative (CFD / equity swap, MiFID II C(9)/C(4)) — **EMIR-reportable**, and the spec itself names
   the TRS "a **synthetic managed account**" (l.940).
3. **PB margin lending / collateral on-lending**: **SFTR-reportable** (Art 3(11)(d); plus collateral
   reuse reporting).
4. **QIS investor via TRS**: an OTC total-return swap — **EMIR / CFTC-reportable**.

Reportability is therefore a property of the **economic substance of the relationship the unit wraps**,
not of the "mandate-unit" wrapper. The unit-*type* is too coarse a key. Two failure modes follow:

- **False positive** — the architecture, seeing `u_MA` emit a real `−1/+1` issuance move into the same
  stream as real trades, mis-reports an IMA as an issued instrument unless explicitly flagged out.
  (This is exactly jane-street-cto #4 and the reason the flag exists.)
- **False negative** — a blanket "all `u_MA` non-reportable" flag misses the case where the mandate is
  *in substance* a synthetic PB swap, suppressing a real reportable derivative.

**Resolution of the determination:** the reportable derivative is **never `u_MA`**. Even in cases 2–4
the reportable artefact is a *distinct unit* — the underlying book trade, or the TRS unit `u_TRS`
observed by the TRS contract — each with its own reportability, UTI, UPI and LEIs. The mandate
(authority to manage) and the swap (the exposure) are different units in `𝒰`. `u_MA` issuance is
non-reportable in all four cases; the reporting obligation attaches to the constituent/observed units.
The danger is purely that the unified mechanism *blurs* which unit carries the obligation.

---

## B. Conformance appendix — §6 step by step

Each step: the atomic move(s) and conservation check; reportable Y/N; regime and action type; the
UTI/UPI/LEI consequence. The **report source of record is the stored CDM `BusinessEvent`** (the
forgetful map `F` retains it whole in the log payload, l.2000), **never the net move** (MH-1).

| # | §6 step | Move(s) / conservation | Reportable? | Regime / action | UTI / UPI / LEI |
|---|---|---|---|---|---|
| 1 | **Mandate issuance** (l.806/A1 §5.2) | `w_mgr(u_MA)−1, w_cli(u_MA)+1`; `Σ=0` by issuance law | **No** (IMA = service, not C-instrument / not SFT) | none; record `reportable=false` w/ legal basis | none for `u_MA`; **but** client & manager LEI must already exist in `WalletRegistry` — they populate buyer/seller (Art 26(3)) and *investment-decision-within-firm* (RTS 22 field 57) on the **underlying** trades |
| 2 | **Subscription** | cash → `w_cli`; `entry_nav`, sub-cursor set in `PositionState[w_cli,u_MA]` | **No** (capital flow, not a transaction in an instrument) | none | client LEI only. **Note:** sub-cursor / `entry_nav` is *also* the flow-adjustment datum (correctness-architect blocker A); the F5 reportable-event source and the flow-netting source are the same field — align them |
| 3 | **Trading-under-mandate** | each trade = `τ` of atomic moves, captured as CDM `BusinessEvent`; `Σ=0` per move | **Yes — primary population** | EMIR NEWT/MODI/TERM (if deriv); RTS 22 (if MiFID instr); SFTR (if SFT) | per-trade **UTI** (waterfall, §C); **UPI** (DSB); both **LEIs**. Quantitative mandate guards = CDM validation before `BusinessEvent` admitted ⇒ rejected trade emits **no move ⇒ no report** (correct by construction) |
| 4 | **NAV / valuation** | none (pure read `V_t=Σ w·P`); state-sufficient at any `t` (P10) | **Yes (derivatives)** | EMIR **VALU** daily — fields 2.21 valuation amount, 2.23 timestamp, 2.24 method | no new UTI; **MH-4: valuation cadence ⟂ reset cadence** — a monthly-reset account still owes *daily* VALU. Trigger must be wired independent of crystallisation. **MH-5:** the `P_t` reported as MTM must equal the `ℒ_v`/settlement `P_t` (§E tension w/ nazarov) |
| 5 | **Fee accrual & crystallisation vs HWM** | `w_cli_cash → w_mgr_cash` (fee); `hwm`, accruals in `PositionState[w_cli,u_MA]`; `Σ=0` | **No** (IMA service fee, not an instrument transaction) | none — **must not** emit a derivative report | none. **Caveat:** where the wrapper is a TRS, the financing leg `N·r·Δt` is **not** a "fee" — it is a **reportable TRS cashflow** reported under the TRS lifecycle, not a separate fee report. The mechanism blurs these; the distinction is a reportability boundary, not an accounting one |
| 6 | **Segregation** | none (algebraic property of conservation) | n/a to EMIR/SFTR | CASS RMAR/CMAR, MiFID 16(8) — *different regime* | none. **MH-6 reporting asset:** per-`(w,u)` `PositionState` is a non-collapsing key ⇒ each client relationship reports independently; base+overlay = two rows = two reportable populations. A flat per-wallet scalar would have *fused* two reportable relationships — architecture correct by construction |
| 7 | **CSA margin** | CSA contract reads aggregate MTM, emits margin moves to per-CP collateral wallet; `Σ=0` | **Yes** | EMIR **collateral/MARU** daily (collateral section 3.x, portfolio code, IM/VM posted/received); **SFTR reuse** if collateral on-lent/re-hypothecated | portfolio-level CSA → EMIR **collateral portfolio code** (matches the netting-set model — good alignment). Counterparty **LEI** required. Reuse detection is **not in the move stream** — needs reference-data enrichment (§D) |
| 8 | **TRS / synthetic managed account** | TRS contract in `ℒ_r` *observes* `ℒ_v` MTM; one real move `w_payer→w_receiver = Payment_k`; `Σ=0`; no `ℒ_v↔ℒ_r` crossing (P7) | **Yes — headline derivative** | EMIR NEWT + daily VALU + MARU + Transfer settlements + TERM; CFTC Part 43 real-time + Part 45 SDR; MiFIR RTS 2 + RTS 22 if EU venue/SI | **UTI** on `u_TRS` (waterfall); **UPI** = DSB equity-total-return template; both **LEIs** from `WalletRegistry`. **Reportable artefact = the CDM `TotalReturnSwap` + its lifecycle, NOT `Payment_k`** (MH-1). **Custom basket:** underlier must be identified from the **TRS `ProductTerms`** (contractual reference), **not** from `ℒ_v` moves (P7 forbids the crossing) — a bespoke index may have no ISIN / no DSB underlier ⇒ incomplete EMIR underlier field |
| 9 | **Redemption** | NAV-strike; cash → `w_cli`; `PositionState[w_cli,u_MA]` row **retained at zero** (monotone carrier); `Σ=0` | **No** for IMA; **Yes** if wrapper is a TRS | IMA: none. TRS: EMIR **TERM** + final Transfer; CFTC termination | none for IMA. **Reporting asset:** the retained zero "ghost" row preserves lineage for EMIR Art 9(2) / RTS 22 record-retention (duration + 5y) and SFTR retention. Redemption cursor = same flow-adjustment datum as #2 |
| 10 | **Balance-sheet substantiation (§6.9)** | none — projection of move stream under wallet filter | derivative population only | EMIR outstanding-position, COREP LE, FINREP — all same stream, different filter | **Strong alignment:** one immutable hash-chained stream = BCBS 239 P6 (accuracy/integrity) + P11 (distribution) + DORA traceability substrate. **But** the stream is *necessary not sufficient*: it carries economic substance, **not** UTI/UPI/LEI/classification — the enrichment boundary (§D) must be documented, not assumed away |

**Conservation holds at every reportable step** by the `src−=q; dst+=q` pattern. No reporting finding
disturbs the move algebra; every finding is at the boundary the closed system abstracts away.

---

## C. UTI / UPI / LEI structural consequences of the closed-system abstraction

The deepest reporting tension is structural, not per-step: **"external counterparties are virtual
wallets; the ledger has no outside within scope"** is exactly the abstraction that dual-sided
reporting refuses. Reporting *is* the boundary with a separate legal/reporting entity.

- **LEI (ISO 17442).** Every EMIR/SFTR counterparty, beneficiary, and submitting entity, and every
  RTS 22 buyer/seller/decision-maker, must be LEI-identified. The virtual wallet has **no LEI by
  construction**. `WalletRegistry` is the *only* home for legal-entity identity (it is explicitly
  *not* economic state). **MH-2 / framework-level finding:** `WalletRegistry` must bind every
  counterparty / UB / payer / receiver virtual wallet to a **validated LEI** and a **reporting-
  counterparty (RC) + FC/NFC(+/−) (and, for CFTC, SD/MSP) determination**, or no paired report can
  be built or reconciled. This is not resolvable inside the move algebra.

- **UTI** (CPMI-IOSCO UTI Technical Guidance, Feb 2017; EU: Art 7 of CDR (EU) 2022/1860). One UTI per
  reportable derivative, with a generation *waterfall* assigning the generating party (CCP → cleared
  flow → SD/FC by sorted-LEI tie-break → bilateral agreement). The waterfall **requires two real
  LEIs and an agreed generating party** — precisely what the virtual-wallet abstraction erases.
  Consequence: `u_MA` needs no UTI (non-reportable); `u_TRS` and each underlying trade need a UTI that
  **cannot be generated from the move stream alone** — it needs the counterparty-LEI pair from
  `WalletRegistry` and the waterfall logic. The UTI/LEI pairing surface is *absent natively* and must
  be added at the boundary.

- **UPI** (ANNA-DSB; EMIR Refit field 2.7; mandatory in EU from go-live 29 Apr 2024). Identifies the
  *product*. There is **no DSB UPI template for an investment mandate** (corollary of isda-board-advisor
  B1: no native CDM product type for an IMA) — confirming `u_MA` carries no UPI. The TRS does carry a
  UPI; a **custom-basket** TRS underlier may have no ISIN and no clean DSB underlier mapping ⇒ an
  incomplete EMIR underlier/UPI field. P7 (`ℒ_v/ℒ_r` isolation) **correctly** prevents reporting the
  simulated constituent trades — but it also means the reportable underlier must come from the TRS
  `ProductTerms`, never from a projection of `ℒ_v` moves.

---

## D. Verdicts by obligation area

- **`u_MA` issuance reportability** — ✅ **COMPLIANT (with mandated condition).** Non-reportable for the
  IMA case by EMIR Art 2(5) / SFTR Art 3(11) / RTS 22 scope. Condition: `ProductTerms[u_MA].reportable`
  must be set by a **legal characterisation cited to the regime**, not a hand-set firm boolean, and the
  obligation must be re-located onto the wrapped/observed unit in cases 2–4.
- **Report source = CDM event, not net move (MH-1)** — ✅ **COMPLIANT by design.** `F` retains the full
  `BusinessEvent` in the log payload; reports derive from it. Load-bearing: any pipeline that reports
  from `Payment_k`/the net move violates CFTC Part 43 / MiFIR post-trade transparency.
- **Daily VALU / MARU independent of reset cadence (MH-4)** — ⚠️ **REQUIRES ATTENTION.** Architecturally
  available (`V_t` state-sufficient at any `t`), but the reporting trigger must be wired **independently**
  of crystallisation, which §6 does not state.
- **Price consistency = reported-MTM consistency (MH-5)** — ⚠️ **REQUIRES ATTENTION.** §6's TRS rule
  (same `P_t` for `ℒ_v` and settlement) *is* the EMIR mark-to-market/valuation-timestamp consistency
  requirement; divergence ⇒ reported VALU ≠ settled cash ⇒ EMIR pairing/reconciliation break. Must be
  *bound* (one shared snapshot), not asserted. See §E (nazarov, formalis).
- **Counterparty LEI / RC / FC-NFC classification (MH-2)** — ❌ **NON-COMPLIANT until `WalletRegistry`
  closes the gap.** Virtual-wallet abstraction erases the legal entity that reporting requires.
  Framework-level; **escalate** (F5).
- **Reference-data enrichment boundary** — ⚠️ **REQUIRES ATTENTION.** Move stream is *necessary not
  sufficient*: UTI generation, UPI, LEI validation, FC/NFC± classification, collateral-reuse detail are
  not in the stream. The architecture removes the *trade-data* pipeline, not the *reference-data* one
  (consistent with the spec's own §Regulatory caveat, l.2186). Document the boundary; do not assume it away.

---

## E. Tensions logged (named, per charge)

1. **vs `nazarov-data-architect` — price-consistency detection is external, not internal.** Nazarov
   scopes the price oracle as internal trust assumptions (TA-PRICE-CONSISTENCY) with an internal
   detection signal (snapshot-hash mismatch). I agree the *mechanism* is one shared snapshot, but the
   *authoritative* detection for reporting is an **EMIR reconciliation break at the trade repository**,
   observable only after the counterparty also reports — outside both ledgers. Further: a hash-consistent
   but **contractually-wrong** price (not the EMIR-mandated valuation source) replays cleanly and still
   produces a reportable-but-wrong VALU. His attestation certifies internal consistency; it cannot
   certify the *regulatorily-correct* valuation source. The price must be the **contractually-specified**
   source, and the binding test is cross-counterparty TR pairing.

2. **vs `isda-board-advisor` — DRR cannot derive `u_MA` reportability.** We agree the hand-set firm
   boolean is bad (his B2). We disagree on the remedy *for `u_MA` itself*: DRR eligibility logic runs
   over a CDM **product** representation, and by his own B1 there is **no native CDM product type for an
   IMA** — so DRR has nothing to consume for the mandate wrapper. DRR can derive reportability for the
   underlying trades and the TRS (which *do* have CDM representations), but the reportability of `u_MA`
   issuance is necessarily a **legal characterisation** (IMA service vs synthetic derivative), upstream
   of DRR. Replacing the flag with DRR logic is right for the underlying/TRS populations and a category
   error for `u_MA`.

3. **vs `banking-auditor` — scope the "zero-value memo unit" recommendation.** I agree `u_MA` must carry
   `P_t(u_MA)=0` and be excluded from `V_t`/RWA (prevents double-count, and reinforces non-reportability
   of the issuance move). Tension: a "zero-value memo unit, excluded from everything" framing must **not**
   bleed into "the managed-account relationship is non-reportable." The reporting obligations attach to
   the underlying/observed units, which are **not** memo units. Scope his recommendation explicitly:
   zero-value for valuation/RWA only; the indexed relationship retains full reporting obligations on its
   constituents.

4. **vs `minsky` / `correctness-architect` / `formalis` — the signed-move defect is also a reportable-
   field defect, and the net move is not the report.** Their B1 (crystallise/`Payment_k` can emit an
   illegal `q<0` / mis-signed move) is, at the boundary, a **reportable-data-quality defect**: the move
   direction populates the EMIR/CFTC payer↔receiver and the sign of the reported cashflow. A silent
   mis-sign ⇒ a reportable EROR/correction and a potential CFTC Part 43 real-time misreport. Extension
   *and* tension: fixing the sign of the **net** move is necessary for cash correctness, but the report
   must **not** be derived from that net move at all (MH-1) — it must come from the gross CDM event. So
   their fix is necessary for settlement but insufficient for reporting; the two artefacts diverge.

5. **vs `finops-architect` — root cause is missing classification, not "papered-over controls."** We
   agree the §6 structural identity hides differing regimes (his point). Tension on root cause: he frames
   it as differing *control* regimes the unification papers over (operational); I locate the root in a
   **missing per-relationship reportability + counterparty-classification attribute** (FC/NFC(±),
   SD/MSP, RC determination) that the move algebra does not encode and cannot infer from the mechanism.
   The control-regime difference is *downstream* of a classification that must live in
   `WalletRegistry`/`ProductTerms`, not be read off the mechanism.

---

## F. Escalation (build on A1, do not re-derive)

**F5 stands and is sharpened.** `u_MA` issuance is non-reportable for the IMA case; the reporting
obligation never attaches to `u_MA` but to the underlying/observed units. The two genuine hazards both
sit at the boundary the closed system abstracts away and **require an external Regulatory/Legal
stakeholder before code ships** — they are not resolvable inside the move algebra:

- **(F5-a) Reportability is a per-relationship legal characterisation, not a unit-type boolean.** Record
  it cited to the regime; re-locate the obligation onto the wrapped/observed unit; never blanket-flag.
- **(F5-b) `WalletRegistry` must resolve every counterparty/UB virtual wallet to a validated LEI + RC +
  FC/NFC(±)/(SD/MSP) determination**, or dual-sided EMIR/SFTR reports cannot be produced or paired.

Ownership of (F5-a) intersects the ungoverned C8 fungibility-predicate ownership (F2): both are
"who decides the legal characterisation of a unit" questions. They should be governed together.
