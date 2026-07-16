# DIGEST: Ledger Specification v13.1, sec10.tex–sec31.tex

(Produced by the Phase 0 reader agent; persisted by the orchestrator. Feeds CARTAN's
Exclusions Register in Phase 2. Archaeology only: carries no authority over v15.)

Correct file↔title map: sec16 = Orchestration/Obligation Liveness; sec17 = Generalised Positions & SBL; sec18 = Invariants/PBT.

---

## SEC10 — The Futures Lifecycle
**Summary.** Uses a listed cash-settled future to stress every primitive across a full lifecycle (listing, trade, daily variation-margin settlement, intraday trade, close-to-flat, expiry/final settlement, Close). Establishes the futures engine as a boundary kernel that *projects onto* the core `Transaction`, never a second core.

**Decisions/definitions/invariants:**
- Field homing: `ProductTerms[u]`=multiplier,currency,expiry,clearinghouse,exchange,product_id (immutable); `UnitStatus[u]`=lifecycle_stage,last_settlement_price/date (shared, one per contract); `PositionState[w,u]`=accumulated_cost `ac` (per-wallet, conserved Σ_w ac=0, enforced at handler C2).
- `FutStateDelta`/`FutValidDelta`: kernel-local boundary types; local `futValidate` discharges conservation before projecting onto one core Transaction via `applyTx`; core keeps no separate validate gate.
- Three type-distinct dimensions: `Qty`,`Cash` (additive Monoids), `Price` (deliberately NO Monoid — never summed/moved). Single bridge: `futMark(netq,S,mult)=netq·S·mult : Cash`. Load-bearing identity VM=netq·S·mult+ac typechecks only because both are Cash.
- `PosQty`/`mkPosQty` positive-quantity parse boundary (G5); q≤0 → NonPositiveQty.
- `FutStage = FutRegistered | FutActive (Maybe Settlement) | FutExpired Settlement` — fuses mark onto stage, making (Registered,Just p) and (Expired,Nothing) unrepresentable; last_settlement_price/date are projections of the carried Settlement.
- Coarse rank REGISTERED<ACTIVE<EXPIRED, monotone, never regresses (StageRegression); EXPIRED absorbing via explicit `isExpired`; FClose is the one event admissible on EXPIRED.
- Re-registration = hard error (C10); zero-holder settlement conserves vacuously (C9).
- Settlement math: target=−netq·S·mult; Δac=target−ac; **VM(w)=−Δac(w)=netq·S·mult+ac**; VM zero-sum IS ac conservation (same fact). Reset discards entry prices (resettable-forward).
- **Principle (C11):** intraday-margin subtlety forces stored per-position ac — a price-derived model gives wrong VM for an intraday trader; single canonical writer.
- Close-to-flat: row retained Some-flat, never deleted/None (monotone carrier C1); None=never held vs Some-flat=held-and-flat both load-bearing (tax/wash-sale/reconstruction, C1(a)).
- Physical settlement variant: DvP struck at final settlement price S, atomic; pricing at any other figure double-counts VM.
- `first_touch_date` derived, never stored (else replay disagrees under back-dated correction).
- Invariants: C2 per-event conservation (incl. VM), C1(b)/P8 deterministic replay as Kleisli fold (stream assumed deduplicated at ingestion — duplicate FSettleVM inert, duplicate FTrade accumulates), monotone absorbing stage.
- Escalations **FE1** (fan-out cost O(open positions)/day at scale) and **FE2** (derived-consequence alternative declined — doesn't save dominant per-wallet cash cost, breaks C11).
- Closing key-invariants list: state-sufficiency, P10 PnL path-independence, lifecycle value invariance, contracts-as-move-generators, P6 lifecycle idempotency, P9 lifecycle purity.

**Worked example (numeric):** ES-FUT, mult=50, USD, expiry Day 3, CME, wallets A/B/C + CH (settlement hub, not novating CCP). Listing→T1(A buys 10 from B@100)→Settle d1(S1=102; A VM +1000, B −1000)→T2(C buys 4 from A@103)→Settle d2(S2=101; A VM −100 not naive −300, B +500, C −400)→T3(B buys 4 from C@101, C flat)→Expiry(S=105; A +1200, B −1200)→Close. Closing identity theorem: cumulative VM=economic PnL (A=+2100, B=−1700, C=−400, CH=0). Direction-reversal remark: netq=+5,ac=−500, sell 8@105 → netq=−3,ac=+340, value 25.

**Haskell (~350 lines):** Qty/Cash/Price, futMark, PosQty/mkPosQty, FutTerms, Settlement/FutStage/FutStatus+projections+stageRank/isExpired, FutPos/Conserved monoid, FutStateDelta/FutValidDelta/futValidate, activateTrade/tradeDelta, settlementFanout, closeDelta, FutEvent, futHandle dispatcher (guards G1–G5), FutLedger(abstract)/FutLedgerError, futRegister, futApplyDelta, futStep, futReplay, total accessors.

**Implementation-detail topics:** fan-out cost/write amplification at scale; batching/snapshotting mitigations.

---

## SEC11 — Managed Accounts, Virtual Portfolios, and TRS
**Summary.** Derives managed accounts and total return swaps as compositions of four existing primitives (wallet partition, mandate unit, deterministic reset/crystallisation contract, three-home state model); shows TRS and funded managed accounts are one settlement primitive.

**Decisions/definitions/invariants:**
- Mandate unit u_MA issued w_M→w_C (real transfer q=1); conservation by issuance law.
- **Invariant (singleton bilateral):** support = {(w_M,−1),(w_C,+1)} while live; enforced by four primitives (Option None vs Some(zero), UnitStatus lifecycle guard, singleton support, C8 re-mandate to fresh u'_MA + SetSupersededBy).
- **Principle (mandate non-valued):** P_t(u_MA) undefined not zero (else double-counts).
- Data homing table (mandate text/fees/benchmark/limits→ProductTerms; stage/superseded_by→UnitStatus; HWM/entry NAV/accrued fees/breach flags/cursor/inception benchmark→PositionState[w_C,u_MA]; benchmark level→UnitStatus[u_bench]).
- Subscription: cash w_ext→w_C tagged SUBSCRIPTION, cursor-indexed; entry NAV+initial HWM=subscribed capital; HWM before=None not 0.
- Mandate guard: precondition g; determinism price-relative → requires pinned snapshot P_t as explicit input; missing price→fail closed; passive breach needs periodic valuation sweep (ME2).
- NAV_t=Σ_{u≠u_MA} w_{C,t}(u)·P_t(u).
- Perf_k=(NAV change)−NetFlow (NetFlow=projection over tagged cursor moves). Mgmt fee accrues on AUM any sign; perf fee floored at 0, no clawback; HWM_k=max(HWM_{k-1}, NAV^net−f^p) monotone ratchet via WHwm::FieldWrite 'FeeCrystallise (phantom-type single author).
- Crystallisation double-entry; signed x → at most one conserved move (Maybe; x=0↦Nothing).
- **Theorem (fee zero-sum):** Σ_w Δ_fee(USD)=0. Reset baseline B_k=NAV−(f^m+f^p)+NetFlow (post-settlement). Rounding residual retained in w_C.
- **Theorem (Segregation):** isolation ⟺ conservation ∧ locality ∧ C4 (conservation alone insufficient). Logical-segregation component of CASS 6/MiFID II Art 16(8); legal segregation out of scope. C4-in-prose-not-typed = ME4.
- CSA margin contract; synthetic-account netting set = single real u_TRS (realm-scoped C4 reads); observation unattested = ME2.
- P7 isolation realized as realm tag {real,virtual}; TRS one real move/reset tagged TRS_NET_SETTLEMENT, Payment_k=N_k·TR_k−N_k·r_k·Δt_k; TR_k requires V^v>0 (typed partial).
- **Theorem (TRS equivalence):** TRS settlement and funded-account settlement are one ledger operation (Crystallise). CDM distinction only.
- Price consistency: one price vector; P7 forbids cross-ledger move so divergence→unreconciled PnL (ME2).
- Redemption/wind-down 4-move retire; all rows retained at zero (C1).
- Substantiation: no separate account-level quantity record; net presentation needs external set-off right (IAS 32.42/ASC 210-20).
- CDM flags: u_MA→LegalAgreement (not Trade); TRS→two-legged, report=retained BusinessEvent; u_MA issuance not SFTR/EMIR reportable (MiFID II Annex I §A(4)); IFRS classification out of scope; TradeState/PositionState alignment asserted (F6). Reportability governance=ME3.
- Escalations ME1–ME5.

**Worked example (numeric):** w_C/u_MA/w_M/w_mkt/w_ext, USD, mgmt 2%/yr, perf 20% over HWM no hurdle, Δt=0.25. A issuance; B subscribe 1,000,000; C buy 5,000 AAPL@100; D Q1 NAV AAPL→130 NAV=1,150,000; E fees mgmt 5,750 + perf 28,850, NAV after=1,115,400, HWM=1,115,400, B_1=1,115,400; F wind-down. Fee zero-sum −34,600/+34,600. Closing identity: w_M=+34,600, w_mkt=−150,000, w_ext=+115,400, sum 0.

**Haskell (~40 lines):** Move(abridged)/moveDelta/issueMandate; crystallise; FeeEvent; crystalliseFees (emits WHwm).

**Implementation-detail topics:** ME1 store-vs-derive; ME2 attestation envelope; ME3 LEI binding; ME4 C4 typing; ME5 solvency liveness.

---

## SEC12 — Balance Sheet Substantiation and Dual Valuation
**Summary.** Balance sheet is a projection of the move stream (not a separate record) so substantiation = replay; settlement and risk require two price vectors over one position set.

**Decisions/definitions:**
- Reconstruction w_t(u)=w_0(u)+Σ signed moves≤t. `balances`=foldMap over pointwise-addition monoid `Balances` (explicitly NOT Map's left-biased union).
- **Remark (balance-as-fold):** monoid homomorphism balances(xs++ys)=balances xs<>balances ys — order-stability, O(k) snapshot correctness, conservation P1 as three readings of one law.
- Scope: quantities/provenance substantiated by construction; valuation/disclosure (IFRS 13 L1/2/3, IAS 1 ¶117–124) need external evidence.
- **Definition (Dual Valuation):** P^MtMk (settlement/margin/reporting/custodian recon) and P^MtMd (risk/optimisation/attribution); Δ_t=MtMd−MtMk.
- FVA: P^MtMd,adj=P^MtMd+FVA (CRR Art 105 prudent valuation).
- Single position set: divergence of *position* impossible; only two money figures diverge.
- Snapshot: quiescence point or MVCC; O(k) vs O(n).
- Quantity/price separation: conservation on quantities independent of price.

**Worked example:** Nikkei 225 futures on 3 exchanges (SIMEX 35,480 / CME 35,490 / OSE 35,495 MtMk vs one MtMd 35,500) — margin needs exchange-specific MtMk, risk uses shared MtMd.

**Haskell (~45 lines):** Qty monoid, Move, Balances monoid, contribution, balances, netBal.

**Implementation-detail topics:** none — pure architecture.

---

## SEC13 — Implementation and Operations
**Summary.** Design-level architecture: three layers, balance-update algorithm, constant-cost PnL, fault tolerance, corrections-as-events, settlement/ISO 20022 interface. No implementation language assumed.

**Decisions/definitions:**
- Three layers: move stream (persistence, immutable append-only), aggregation engine (pure GroupBy, parallelisable), projection (state cache — corruption repaired by replay, P4).
- Balance-update: Validate→Aggregate→Apply(atomic rollback P2)→Snapshot.
- Constant-cost PnL: O(instruments) not O(moves), state-sufficiency P10.
- Fault tolerance: late events (economic+booking timestamps, append-only); duplicate events (P5+P6, CDM event-qualification); contradictory external state (virtual-wallet comparison, surfaced not auto-resolved, resolution=a transaction); stale market data (conservation independent of prices; value-dependent settlements gated, deferred not booked stale); move-stream integrity (hash chaining P4); partial failures (all-or-nothing P2, needs WAL).
- Corrections as events: compensating transaction; `corrects` metadata field forms correction chain; amendment=CDM TermsChangeEvent (distinct from cancellation); formal correction algebra = open problem.
- Settlement instruction = struct-to-struct projection (CDM→ISO 20022).
- ISO 20022 sese.023 field-mapping table; traceability chain contract→move→instruction→confirmation→status.

**Worked examples:** none numeric. **Haskell:** none.

**Implementation-detail topics:** essentially the entire section — layer mechanics, WAL/crash-recovery, replication/backup/DR, ISO 20022 generation.

---

## SEC14 — The Settlement Layer Interface
**Summary.** Boundary between Ledger and external settlement is one pure/total/deterministic/idempotent projection `settleProjection : SettlementTx → Maybe SettlementInstruction`.

**Decisions/definitions:**
- **Definition (Settlement Projection):** reads only the committed transaction; total, returns Just for SETTLEMENT/COLLATERAL, Nothing otherwise.
- SettlementTx boundary type (not core Transaction); moves resolved to Asset = Security ISIN | CashCcy Currency.
- Type and legs are one value: SettlementLegs = DvP | FoP | CashOnly — no-legs instruction unrepresentable; settlementType is a projection.
- TxClass = SETTLEMENT|COLLATERAL|LIFECYCLE|ACCOUNTING|CORRECTION; `settles` total (only first two).
- **Principle (Boundary Separation):** Ledger=*what* settles; settlement layer=*how* (SSIs, custodian ids, CSD, ISO 20022, exceptions). Neither reads the other's internals.
- Multi-leg structures decompose at source (repo emits 2 DvP transactions).
- Lifecycle-originated settlement treated identically; sole difference is provenance.
- DvP two-level: Ledger-level (atomic transaction, structural) + Settlement-level (external CSD/CCP); temporal gap normal under trade-date accounting; settlement failure records event, does NOT reverse economic position.
- Gross-to-net reconciliation: gross authoritative, never modified by netting; algebraic identity, not heuristic; localises fault.
- Confirmation return: EXECUTED→INSTRUCTED→SETTLED, INSTRUCTED→FAILED alternate terminal; status = projection of logged events.

**Worked examples:** behaviour bullets only. **Haskell (~110 lines):** Asset, SettleMove, TxClass/settles, CdmPayload, SettlementTx, SecuritiesLeg/CashLeg, SettlementLegs/SettlementType, SettlementInstruction, classify, legsOf, settleProjection, signedFor, reconciles.

**Implementation-detail topics:** SSI enrichment, CSD participant ids, settlement priority, ISO 20022 generation.

---

## SEC15 — ISDA CDM Integration
**Summary.** Adopts ISDA CDM as canonical product/event vocabulary derived from the framework's own primitives; defines the forgetful map F from CDM BusinessEvents to ledger moves.

**Decisions/definitions:**
- CDM's five components (product/event/process-workflow/reference-data/mapping-synonym models).
- Chain: product→tradable product→business event→ledger moves.
- Derivation: products→units; event model→state graph (TradeState nodes, primitive operators edges); embedded Rune logic→transition contracts; mapping layer→oracle interface.
- Ingestion pipeline: raw message→synonym mapping→CDM object→lifecycle function→moves/state; version coexistence (each event carries CDM version id).
- **Forgetful map F:** BusinessEvent→CdmTransaction (ctMoves + ctPayload verbatim). instructionMoves = monoid homomorphism (concatMap); move-less events (PiTerms,PiReset)→[]. Preserves: composition (restricted to referentially-independent events), conservation, sequencing, idempotency (absorbing guard). Forgets: intent, lineage, structure, regulatory classification (all recoverable from payload).
- **Principle:** ledger=economic substance, CDM=business meaning.
- CDM enumerations = closed/finite generator universe for property-based tests.

**Worked example (numeric):** European call AAPL, strike $200, expiry 2026-06-20, 100 contracts, cash-settled USD. Exercise S_T=215: cash transfer 100×max(215−200,0)=$1,500 seller→buyer; option→EXERCISED.

**Haskell (~55 lines):** Intent/LifecycleState/TradeState, PrimitiveInstruction, BusinessEvent, CdmTransaction, instructionMoves, forget.

**Implementation-detail topics:** bespoke transport-layer code; CDM enumeration-addition process.

---

## SEC16 — Orchestration and Obligation Liveness
**Summary.** Fixes execution-engine requirements, processor contract, due-event scheduler, concurrency model; introduces the **obligation** as a first-class object with liveness theorem (P21–P23).

**Decisions/definitions/invariants:**
- Four engine requirements: at-least-once delivery (+idempotent activities→exactly-once); durable timers surviving restarts; deterministic replay (workflow history); single-threaded per instance. Reference adopts **Temporal.io**.
- Processor contract (four conditions): closed inputs; prefix-determinism (canonicalTx); idempotence keys (obligation id, or txCause+target unit); proposed-never-authoritative.
- **Principle (Admission and recomputation):** structural at the door; economic by recomputation (recomputeOK, P27); nonzero diff = producer defect, compensating path.
- Executor as retriable engine activity; idempotency key = tx ID; conservation/referential/idempotency violations non-retryable.
- Due-event scheduler: deterministic-date obligations→durable timers at registration; data-quality gate; durable deferral.
- Concurrency: one workflow per unit (per wallet for futures ac); cross-unit via parent workflow; serialisation per unit not global.
- **Definition (Obligation):** o=(id,type,source,t_d,D,κ); D and κ total functions of state; κ Just moves or Nothing (forces Defaulted).
- State machine: Live={Pending,Attempted}, Terminal={Discharged,Compensated,Defaulted} (no exit edge, type-enforced); `step` total.
- Taxonomy table: deterministic-date / event-triggered (SBL recall, manuf dividend, collateral subst, CSA VM+IM, SBL top-up, close-out netting) / regulatory (SFTR/SLATE/EMIR/settlement instruction).
- **Definition (Obligation store):** projection of event log; atomic creation with triggering event.
- **Principle (Obligation completeness):** lifecycle function must include obligation in output; property-testable over CDM event-type enum.
- **P21 Liveness / P22 Conservation / P23 Idempotency.** Theorem via L1–L5 (registration completeness, workflow creation, timer durability, timer fires [assumes cluster availability], handler totality).
- Assumptions: engine availability, executor availability, external cooperation, lifecycle-function correctness.

**Worked examples (numeric):** (1) CSA VM call Alice/Bob, threshold $500K, MTA $250K, MtM $2.3M → call $1.8M, deadline T+1; discharge vs ISDA close-out compensation. (2) SBL collateral substitution: XYZ ineligible, four-move Bund substitution, GMSLA §10 escalation.

**Haskell (~35 lines):** Obligation record; Live/Terminal/ObState/Trigger; `step`.

**Implementation-detail topics:** Temporal.io pick; cluster availability; workflow spawning mechanics.

---

## SEC17 — Generalised Positions and Securities Borrowing and Lending (KEY SECTION)
**Summary.** Generalises the scalar balance to a six-coordinate position vector; derives SBL as a smart contract over the primitive plus invariants P11–P20, locates (P26), and EU/US treatments.

### Coordinate vector
- Scalar failure: Alice owns 1,000 VOD, lends 400 — transfer (wrong PnL, IFRS 9 §3.2.6), don't transfer (unrecorded possession), credit both (conservation violated).
- Physical-action test: coordinate = stored quantity a distinct physical action modifies and only it; else projection (read-time, never stored).
- **Principle (Single-Coordinate Move):** one move = one coordinate, one unit, source+destination.
- **Definition (Position Vector):** (own, onloan, borr, coll_post, coll_recv, coll_rehyp).
- **Definition (Available Inventory) P20:** avail=own−onloan+borr, read-time projection.
- Why own is a coordinate: PnL direct lookup; scalar collapse; not derivable from operational coords; buy/sell distinct action.
- avail is a group homomorphism: δ_Own=δ_Borr=q, δ_OnLoan=−q, δ_coll=0.
- Non-negativity of operational coords NOT typed (value-level precondition avail≥Q).
- **Proposition (Conservation):** per unit, lender's +onloan and virtual wallet's −onloan cancel → Σ_e(own+borr+coll_post+coll_recv+coll_rehyp)=0.
- Graceful degeneration to scalar for non-lendable units.
- Projections: avail; possess=avail+coll_recv; encumb=onloan+coll_post; store-projection reserved(e,u,t) over put-on-hold locates.
- AvailableToLend=max(0, avail−reserved−regulatory_hold).
- In-flight collateral: virtual-wallet entry (IBP-177); custodian recon own+borr+inflight=depot.

### Named-wallets resolution
- Alice lends 400 VOD: Alice (1000,400,0,…), Bob (0,0,400,…); per-relationship virtual wallet −400; full conservation incl. custodian −1000.
- Reclassification vs transfer: reclassification = two-move within one entity (rehyp coll_recv↓/coll_rehyp↑); transfer = between entities.
- On-lending chains: each loan its own unit. **P18 scope:** pure lenders only; intermediary identity onloan≤borr.
- Cascade recall: saga with buy-in compensation (GMSLA 9.3, IBP-328); no CDM equivalent (gap).

### Collateral and margin
- Methods: cash rebate; non-cash bilateral (haircut); non-cash triparty (RQV, IBP-189); cash pool standard/EU (IBP-322/323); uncollateralised (IBP-326).
- LV=⌈Q×P_close×M%×χ⌉_0.01 (IBP-163).
- Margin calls: borrower coll_post (or own for cash) ↔ lender coll_recv.
- Rehypothecation = reclassification, regime-gated (P19; US cap 140% Rule 15c3-3(b)(3)).
- Cash collateral reinvestment (Rule 15c3-3): collateral obligation (fixed, loan-unit state, lender coll_recv) vs reinvestment asset (MMF in lender own); 2008 Reserve Primary Fund risk.

### Title transfer vs security interest
- Three regimes: TITLE_TRANSFER (GMSLA 2000/2010 — receiver owns, rehyp default); SECURITY_INTEREST (GMSLA 2018 — pledged, poster retains, rehyp needs consent); US_15C3_3 (possession/control, 140% cap).
- Wallet structure + avail identical under every regime; regime affects only PnL projection; legal_regime immutable at inception.
- **Remark (Pledge and own):** V^SI=Σ(own+coll_post)·P vs V^TT=Σ own·P; framework keeps own regime-independent, pledge adjustment explicit in valuation function.

### Locates
- Pre-trade confirmation, NOT a move; conversion to borrow engages conservation.
- EU SSR Art 12(1)(c) (Impl Reg 827/2012 Art 6: standard/same-day/easy-to-borrow/put-on-hold); US Reg SHO 203(b)(1).
- Modelled as TTL unit in Unit Store; activity = timestamp predicate; scheduler sweep hygiene not authority.
- **Principle (Locate-capacity weld) + Invariant P26:** admission-position-indexed, never a standing invariant.
- P14 drawdown structural; attested external locates ungated. No CDM equivalent (gap).

### Other SBL content
- **Principle (SBL Representability):** SBL = smart contract adding loan unit type, legal_regime, P11–P20; changes no primitive.
- Native not companion: TOCTOU double-lending; unprovable cross-boundary conservation; invisible collateral; two-system exposure join.
- SBLUnitState field list; loan-unit valuation (bond analogy; fee accrual as price); IFRS 9 §3.2.6 lent securities stay in own.
- SBL state machine (PENDING→ACTIVE→…; terminals RETURNED/CANCELLED/DEFAULTED); per-event move schedules (init 4, return 4, short sale 2, MTM 2, substitution 4, manuf dividend 1/entity, buy-in).
- Short selling: negative own defining; borr unchanged on sell.
- External reconciliation four-participant table. CDM alignment: gaps Recall/Locate/Rehypothecation/tokenised-collateral eligibility.
- **P11–P20** full statements. Cross-border SFTR+SLATE dual firing; regime by agreement, locate by venue, discipline by settlement venue.

**Haskell/pseudocode (~150+ lines):** Position record, avail, Coord+applyMove, locActive/locReserved/p26 oracle; available_to_lend, confirm_locate.

---

## SEC18 — Invariants, Conservation Laws, and Property-Based Testing
**Summary.** States all correctness claims once as testable invariants P1–P31 (+P32–P34) and conditions C1–C14, with the discharge map.

**Decisions/definitions:**
- Conservation Q(u)=0 central invariant/universal oracle.
- **P1–P10:** conservation, atomic commitment, referential integrity, log monotonicity (hash-chained tamper-evidence), tx idempotency, lifecycle idempotency, virtual/real isolation, snapshot consistency, lifecycle purity, PnL path-independence. Global oracles: Totality, Valid-transitions-only.
- **P11–P20 (SBL); P21–P23 (obligation); P24 basis tip; P25 ingest soundness; P26 locate admission; P27 producer agreement (recomputeOK); P28 cause committed; P29 schedule totality; P30 dimension invariance; P31 kind totality; P32–P34 conformance-tier (confirmation gate, elective aggregate invariance, basket joint consumption).**
- **C1–C14 register** and discharge map (condition→guarantee→mechanism).
- "Types as theorems" five Haskell anchors.
- PBT over CDM generator universe: closed enums → checklist coverage; EventIntentEnum transition table.
- Specification-first development.

**Haskell:** ~60 lines of anchor excerpts (executables in sec24).

---

## SEC19 — Regulatory Obligations and the Direction of Travel
**Summary.** Post-trade reporting alignment derives from primitives, not a standard's mandate.
- Regimes: EMIR Refit (203 fields), MiFIR RTS 22 (65), SFTR (155), CFTC 43/45; dual-sided reconciliation structural.
- CDM + ISDA DRR in production (pinned to ISDA "DRR 2025 Year in Review," Jan 2026).
- Reports = projections of the move stream; reference-data enrichment (UTI/LEI/classification) supplied at the boundary.
- BCBS 239 Principles 6/11; DORA Art 8 + Ch IV: substrate provided, organisational conformance external.
- Mandate issuance reporting: `reportable` predicate on ProductTerms (flag F5).

---

## SEC20 — Scope and Limitations
Nine limitations (no executable prices; no legal documentation; no settlement finality; no accounting policy; no external risk elimination; no model governance; boundary reconciliation remains; no submission infrastructure; reproducibility needs dependency versioning). Theorems as modelling choices. Architecture vs operational reality (four-eyes, exceptions, BCP).

---

## SEC21 — Frequently Asked Questions
Seven Q&A: move-less lifecycle events valid (barrier knock on zero position); DvP internal = atomicity ∧ contract correctness; lot-split physical delivery; SBL native (TOCTOU); own stored/avail projected; scalar sufficient for cash incl. cash collateral; market-data providers owe value/time/source/unit only (O1–O5, basis stamped at ingest door).

---

## SEC22 — Conclusion and Open Problems
- Resolved: concurrency (single-writer workflows), liveness (durable timers + obligation object), state attachment (three homes).
- Open problems: netting/close-out algebra (esp. multilateral CCP); correction algebra; multi-entity federation/eliminations; XVA; bitemporal semantics; tax lots (interaction with futures ac unresolved); impairment/ECL; GDPR Art 17 vs append-only (crypto-shredding vs time travel); access control/actor attribution; repos (GMRA, incremental); default management (waterfall governance); pre-trade validation (credit/position limits); legacy migration; tokenised securities (cross-chain, proof-of-reserves, classification, tokenised-collateral eligibility, on-chain governance).
- Registers: F1–F8 (state-model adoption); mutation-score targets (handlers 85–90%, guards 70–80%, core ≥80%, TLC-tractable state-machine model); ME1–ME5; FE1–FE2.

---

## SEC23 — CDM Type Mapping Tables (Appendix)
Product→Unit type; TradeState→Unit state; BusinessEvent→Transaction; PrimitiveEvent/Transfer/QuantityChange→Move; Party/Account→Wallet; WorkflowStep/Lineage→Transaction metadata.

---

## SEC24 — Property Test Catalogue (Appendix)
P1–P10 + P24 as executable oracles; `Outcome=Accepted|Rejected` (no crashed case = Totality/P2 structural); `Property i o`; `sameLedger` observational equality. ~150 lines Haskell (p1/p2/p3/p7, idempotentTx, chainOK, p8, idempotentL, validTransitionsOnly, p10, effTip/p24).

---

## SEC25 — Reconciliation Failure Mode Taxonomy (Appendix)
Unreachable: trading/GL, PnL/BS, inter-entity. Detectable: custodian/depot, nostro/vostro, corporate-action, collateral disputes (UMR eligibility deferred), FX. By design: SBL breaks. Remaining operational: incomplete booking, duplicate external booking, stale-data ingestion.

---

## SEC26 — Coordination Between Pricing, Contract State, and Market Data (Appendix)
State-aware pricing P_t(u)=P(u,state,quote); Cum/Ex d state slice ("ex but amount unknown" unrepresentable); mQuoteEx one-bit lag flag; pricer total over (u,q,d); f=1 fibre of the market-data contract; statePrice/fibreOK.

---

## SEC27 — Glossary (Appendix)
~60 terms + C1–C14 index. Load-bearing note: many entries (Basis id, CAClass, Confirmation gate, Datum-kind registry, Dimension declaration, Invariance weld, Market-data contract, Tip weld, Two planes, …) belong to the State-Basis Discipline whose home is sec09.

---

## SEC28 — The CDM Product Model: A Developer's Guide (Appendix)
Six-layer hierarchy (Observable/Payout/EconomicTerms/NonTransferableProduct/TradableProduct/Trade=unit); **Trade=Unit incl. Collateral** (dual-CSA test → different units); CCP margin a CDM gap; structured note (economic ≠ CDM decomposition; TransferableProduct narrower than transferable; three settlement paradigms); tokenised: two units, **custodian is flat by conservation**, four CDM v6.0.0 gaps (no blockchain identifier, no custodial backing model, DigitalAsset underspecified, no on-chain settlement type); date-handling taxonomy + six gotchas.
**Numeric examples:** structured note EUR 1,000,000, index −20% → EUR 800,000 redemption; tokenised NVDA 1M shares + 1M tokens, custodian nets 0; 5Y SOFR swap MODFOLLOWING/USNY date rolls, 30/360 vs ACT/360 ≈ $11,111 difference on EUR/USD 50M@4%.

---

## SEC29 — Available Inventory Identity: Eight-Scenario Verification (Appendix)
avail=own−onloan+borr across eight scenarios (A outright; B lend; C borrow+sell; D non-lendable IRS; E sell all borrowed; F borrower sells part; G on-lending chain defeating naive identity own=avail+onloan; H pledge: coll_post 200/coll_recv 200, PnL = coll_post×P not own×P).

---

## SEC30 — European SBL Worked Example: GMSLA 2010 Title Transfer with Rehypothecation (Appendix)
CALPERS_EU lends 500,000 TTE to GOLDMAN (fee 25bps ACT/360), German Bund collateral 102%. Day 0: TTE €58.50/Bund €98.50; LV €29,250,000; RCV €29,835,000; 302,894 Bunds (4-move init; TT collateral leg writes poster's own). Day 0: onward delivery + hedge-fund short €29,250,000. Day 1: rehyp 302,894 (coll_recv→coll_rehyp; Goldman doubly-short Bunds −605,788). Day 3: MTM margin call 10,014 Bunds. Day 7: manufactured dividend €1.25×500,000=€625,000. Days 10–12: partial recall 200,000; release 126,755 Bunds (coll_recv first, then coll_rehyp — forcing Goldman recall from Counterparty C). Day 20: full return; fee €3,548.40. Move-less RECALL transaction; SFTR NEWT/VALU/MODI/ETRM tagging; P13/P15/P18/P19 verified at each step.

---

## SEC31 — US SBL Worked Example: SEC Rule 15c3-3 with Cash Collateral (Appendix)
FIDELITY lends 1,000,000 NVDA to MORGAN_STANLEY; cash collateral USD 102%; rebate Fed Funds 5.25%−25bps=5.00%. Day 0: NVDA $875; LV $875M; RCV $892.5M (4-move; pledge cash leg writes poster's own + receiver's coll_recv). Reinvestment into MMF (4-move; obligation persists at $892.5M in loan-unit state); daily spread $6,145.83; Day-30 rebate $3,718,750. P19 cap validation (140% customer debit, pre-condition, unreachable-not-rolled-back). Day 5: NVDA $910 → ΔC $35.7M call. SLATE table (8pm ET; Unsettled Loan Flag #44 from settlement status). Day 15: recall 500,000, release $459M, pro-rated rebate $956,250. Day 25: full return; final rebate $651,666.67. **Cross-Jurisdictional Comparison table:** EU/US examples differ ONLY in legal_regime, P19 pre-conditions, and PnL projection formula (own·P vs (own+coll_post)·P); coordinate vector, Single-Coordinate Move, conservation identical across regimes.

---

## Cross-cutting observations for the Exclusions Register
1. **State-Basis Discipline** (home sec09) heavily cross-referenced from sec10–31: BasisId/BasisView, ingest door (O1–O5), tip weld, invariance weld, adjustment schedule (C14), CAClass, dimension declarations, datum-kind registry, W3/W4, TA-BASIS/TA-KIND — underlies P24/P25/P29–P34, C13/C14.
2. **Escalation registers** consolidated in sec22: F1–F8, ME1–ME5, FE1–FE2, F5.
3. **Explicit CDM gaps:** SBL Recall/Locate/Rehypothecation, tokenised-collateral eligibility, CCP margin, four tokenisation gaps, coordinated cascade recall.
4. **sec30/sec31 paired correctness witnesses**; sec31's comparison table = definitive statement that the six-coordinate model + conservation are regime-invariant; legal_regime, P19 pre-conditions, PnL projection are the only regime-dependent elements.
5. **Resolved vs open** (sec22): concurrency/liveness/state-attachment resolved; the Open Problems list is explicitly un-designed at architecture level.
