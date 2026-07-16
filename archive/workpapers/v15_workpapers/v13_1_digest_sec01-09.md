# Ledger Specification v13.1 — Digest of sec01.tex–sec09.tex

(Produced by the Phase 0 reader agent; persisted by the orchestrator. Feeds CARTAN's
Exclusions Register in Phase 2. Archaeology only: carries no authority over v15.)

File→title map (from `\section{}`): sec01 = Roadmap (unnumbered front matter); sec02 = Purpose, Scope, and Properties; sec03 = The Closed Ledger System; sec04 = The Unit Store; sec05 = Where Unit State Lives: The Three-Home State Model; sec06 = Portfolio Valuation and PnL; sec07 = Smart Contracts as Move Generators; sec08 = Lifecycle Management; sec09 = The State-Basis Discipline.

---

## sec01.tex — Roadmap and Reading Guidance (unnumbered front matter)

**Summary.** Audience-indexed reading-path table (Regulator, Implementer, Quant, Market-data integrator, Risk manager) giving each a minimal path, a "then if needed" extension, and skippable sections. States that the scalar wallet balance carries Parts I–IV; the six-coordinate position vector and securities lending enter only in Part V. Introduces the non-normative "Mental model" convention.

**Decisions/conventions fixed:**
- Document is organized into Parts I–V; Part V introduces the generalized position vector and securities lending.
- "Mental model" boxes are explicitly non-normative: no definition/proof/condition depends on them; deleting all of them leaves the spec complete.
- Per-persona cross-reference routing map.

**Worked examples:** None. **Haskell:** None.
**Implementation-detail topics:** Whole section is document navigation/meta, not technical architecture.

---

## sec02.tex — Purpose, Scope, and Properties (`sec:intro`)

**Summary.** States the problem (many sources of truth → reconciliation cost) and the solution (single primitive: atomic move of quantity between wallets; all other views are projections of one immutable move stream). Establishes six by-construction properties, three unreachable internal breaks, the high-level architecture, the IFRS/US-GAAP fair-value scope, and the explicit ledger boundary (inside vs outside).

**Design decisions/definitions/properties fixed:**
- Six properties: (1) Atomicity; (2) Conservation Σ_w w(u)=0 (governs quantities per unit, not market value); (3) Determinism; (4) State-Sufficiency; (5) Lifecycle Value Invariance (restricted form, `prop:lifecycle-value-invariance`) with qualification that under optionality only intrinsic value is invariant (time value/embedded option value extinguished on exercise/expiry/barrier/call); (6) Time Travel (`prop:time-travel`) via `clone_at(t)`, distinguishing "as known at t" from "t with corrected data."
- Core vocabulary defined: wallet, unit, move, transaction, smart contract, unit state, immutable move stream; all other views are one-way projections.
- Three unreachable internal breaks: trading-system/GL divergence; PnL/balance-sheet mismatch; inter-entity breaks.
- Scope: fair-value-through-P&L trading books under IFRS 9 (§§4.1.2/4.1.4/5.7.1–5.7.7) and US GAAP (ASC 815, 320/321, 820); banking-book (amortised cost, HTC, structural hedge accounting) out of scope.
- CDM (ISDA Common Domain Model) is canonical vocabulary: defines the unit universe, drives lifecycle transitions, bounds property-test input space, maps to ISO 20022.
- Ledger Boundary (`sec:scope-overview`): Inside list (positions/conservation law, moves, lifecycle events, PnL V_t=Σ_w w_t(u)P_t(u), time travel, internal reconciliation); Outside list (price formation, legal agreements — ISDA/GMSLA/GMRA/CSA/custody, settlement infrastructure — CSD/DTC/Euroclear/Clearstream/CLS/TARGET2, regulatory gateways — EMIR/MiFIR/SFTR/Dodd-Frank/MiFID II RTS 25/CRR/FRTB, reference-data authority, model governance, accounting policy).
- Figure `fig:overview`: contracts → move stream → one-way projections; external authorities reconciled only at the boundary.

**Worked examples:** None numeric (FX-trade illustration only). **Haskell:** None.
**Implementation-detail topics:** Accounting-standard citations are regulatory reference; the section is otherwise pure architecture/scope.

---

## sec03.tex — The Closed Ledger System (`sec:ledger`)

**Summary.** Establishes the four primitives (wallet, unit, move, transaction), the conservation law, the System Closure theorem, virtual wallets, books/reference wallets, and the Self-Consistency Principle making three internal-break classes structurally unreachable. First Haskell listings (illustrative form).

**Design decisions/definitions/invariants fixed:**
- **Definition (Wallet):** w_t: U → R; negative = short/obligation; logical partition, not a bank/custody account or legal entity.
- **Principle (Ownership):** economic ownership = wallet balance; divergence cases deferred to GPM.
- **Definition (Move):** indivisible transfer of positive q of u from w_s to w_d at t, tagged source s + metadata; w_s(u)−=q, w_d(u)+=q.
- **Principle (Atomicity):** every change is a discrete time-stamped move; no implicit/retrospective adjustments.
- `Qty` = additive abelian group; exact `Integer` minor units, never float.
- **Definition (Transaction, `def:transaction`):** ordered move list + non-balance state delta (accumulated cost, high-water mark, entry NAV, shared unit-status writes, product-terms introduce/append); sequence-number total order on tied timestamps.
- **Principle (Conservation Law, `cond:conservation`):** per transaction and unit, net quantity change is zero — algebraic consequence of group structure, not a runtime check.
- **Theorem (System Closure, P1, `inv:P1`):** Σ_w w_t(u)=0 ∀u,t; proof by induction.
- **Definition (Real vs Virtual Wallets):** W_real (own portfolio, affects PnL) vs W_virtual (external counterparties, reconciliation only, no portfolio-value effect).
- Virtual wallet's three purposes; external world is thus "inside" the ledger.
- Initialisation: no `set_balance`; opening positions are conservation-preserving moves from virtual wallets; migration captures state at t_init.
- Books = reporting convention grouped around a reference wallet; all logic operates at wallet level.
- **Principle (Self-Consistency):** internally inconsistent states unreachable, not merely detectable; balance sheet *is* the ledger through an accounting lens.
- Three unreachable breaks with mechanism (trade+entry are one object; PnL is a theorem; inter-entity move recorded once). Guarantee scoped to ledger-recorded activity during migration.
- Settlement-timing note: atomic transaction records economic intent; async legs; unsettled residual = receivable in counterparty virtual wallet (Herstatt risk recorded, not eliminated).

**Worked examples:**
- Share purchase: 500 AAPL @ $100 via broker → one transaction, two moves (50,000 USD portfolio→broker-virtual; 500 AAPL broker-virtual→portfolio). Portfolio pre-state USD 10,000/AAPL 0; broker-virtual ends AAPL −500; conservation ΔUSD=0, ΔAAPL=0.

**Haskell:** `Qty` + Semigroup/Monoid + `negQty`; `WalletId`/`UnitId`/`Timestamp`/`SourceId`; `Move` + `move` smart constructor; `moveDelta`; `Ledger = Map WalletId (Map UnitId Qty)`; `balance`/`adjust`/`applyMove`; `Transaction` record; `unitDelta`; `buyAAPL`. ~130 lines, illustrative (reference form uses `PosQty`, introduced in sec05).
**Implementation-detail topics:** Concrete `Map` representation and `foldMap` mechanics are implementation; settlement-timing/Herstatt discussion foreshadows the (external) settlement layer.

---

## sec04.tex — The Unit Store (`sec:unit-store`)

**Summary.** Makes the unit universe concrete: unit identity by fungibility, three-tier architecture, registration channels/mechanics, two-stage validation, four downstream guarantees. Introduces conditions C7 and C10.

**Design decisions/definitions/conditions fixed:**
- **Principle (Unit Identity, `prin:unit-identity`):** same unit iff fungible.
- Identity-key table: Cash→currency code; Listed equity→ISIN; Listed derivative→contract spec (exchange, underlier, type, strike, expiry) fungible via CCP novation; OTC derivative→full CDM `Trade` incl. `Collateral` (non-fungible); Bond→ISIN; Structured note→ISIN+terms; Tokenised equity→contract address+chain ID.
- OTC identity includes `Collateral` (different CSA ⇒ different unit); tokenised security distinct from underlying.
- Three tiers: Tier 1 Reference Data (consumed, CDM `TransferableProduct`/`NonTransferableProduct`); Tier 2 Product Registry (one template per product *type*, CDM `ProductQualification`+`EconomicTerms`, auto-created, immutable); Tier 3 Unit Registry (elements of the unit universe; `UnitEntry` schema; `unit_id` deterministic/injective from CDM object).
- Evolving state not stored on entry → three-home model (sec05).
- Registration channels: (1) Cash pre-registered (permanent, ACTIVE, identity contract); (2) Listed via reference-data feed (administrative, pre-position); (3) OTC via trade execution (the CDM `Trade` is the unit).
- Registration atomic; units never deleted; terminal stages retained; non-ACTIVE units reject new moves except to settle obligations.
- **C7 (ProductTerms registration-total):** first version at registration.
- **C10 (no re-registration):** hard error, never silent reset.
- Two-stage validation: at registration (uniqueness C10; smart-contract binding; CDM qualification; term consistency — future expiry, positive multiplier, valid currency); at transaction time (unit exists; stage compatible; contract invokable).
- Four Guarantees: Existence; Immutability of identity/terms; Smart-contract availability; CDM alignment → ground referential integrity P3.
- CDM gaps noted (no catalogue concept, no listed-contract-spec type, no reference-feed model) — documentation gaps.
- Key-invariants recap: P1, P2, P4 (log monotonicity, append-only/hash-chained), P5/P6 (idempotency), P8/P9 (determinism/time travel).

**Worked examples:**
- Registration succeeds `== Right l0`; duplicate `== Left (ReRegistration uES)`.

**Haskell:** `UnitEntry` schema (typed field list); `ProductTerms = ProductTerms (NonEmpty TermsVersion)`; partial `LedgerError`; `registerTx`; `register = applyTx (registerTx ...)`. ~90 lines.
**Implementation-detail topics:** `UnitEntry` field layout, `unit_id` hash derivation, CDM tier-mapping table.

---

## sec05.tex — Where Unit State Lives: The Three-Home State Model (`sec:states`)

**Summary.** Establishes that all unit-related economic state lives in exactly three maps — `ProductTerms[u]` (immutable), `UnitStatus[u]` (shared cache), `PositionState[w,u]` (per-position) — via one placement rule and a 2×2 grid whose fourth cell (externally-authored per-position) is provably empty. Builds the reference Haskell bottom-up, states conditions C1–C12 (and forward-declares C13/C14), proves the design is the unique Pareto optimum among six alternatives A–F, and tabulates which invariants each condition discharges.

**Design decisions/definitions/conditions fixed:**
- Placement rule: each economic fact has exactly one home and one writer; two failure modes (keyed-wrong / authored-wrong); two classifying questions.
- 2×2 grid: per-unit/ledger-authored→UnitStatus; per-unit/externally-authored→ProductTerms; per-(holder,unit)/ledger-authored→PositionState; per-(holder,unit)/externally-authored→empty.
- **C12 (W-sector collapse):** managed-account state is not wallet-keyed; manager issues mandate unit u_MA conserving as h(w_mgr,u_MA)=−1, h(w_client,u_MA)=+1; all per-wallet-looking fields are `PositionState[w_client,u_MA]`.
- UnitStatus discipline: a read cache / catamorphism of the immutable log; written only via `applyStatus` inside `applyTx`; no out-of-band `setStatus`.
- **C6** (ProductTerms append-only, non-empty version list, no in-place mutation); **C7** (registration-total); **C5** (UnitStatus registration-total, product-declared defaults incl. basis origin); **C1** (Option accessor distinguishing never-held vs held-and-flat + monotone carrier, no row deletion); **C2** (edge-conserved flow, vacuous base included); **C3** (all-or-nothing across all three maps); **C4** (capability-scoped reads, cross-overlay forbidden, strategy exports only via UnitStatus); **C8** (two-track amendment via total fungibility predicate); **C9** (move-less events conserved vacuously); **C10** (no re-registration); **C11** (per-field canonical writer set, type error at authorship); **C13/C14** forward-declared to sec09.
- Lifecycle closed sum: `Registered → Active → Expired → Closed`.
- Closed `StatusWrite` set (4 constructors) with `applyStatus` sole total writer (last-write-wins, idempotent ⇒ P6).
- `PositionState` fields: `psAc`/`psBalance` (conserved), `psHwm` (monotone via `qmax`), `psEntryNav` (write-once).
- Sealed `Ledger` (ledgerPT/US/PS + derived `ledgerBounds` cache, not a fourth home); constructor/selectors unexported.
- `applyTx` single door with `introduce`/`requireKnown`/`requireSupersedeTargets`/`requireBasisTip`/`requireInvariance`/`commit`; origin weld (`ForeignOrigin`), `DanglingSupersede` refusal.
- `amend`: Preserving (append) vs Breaking (introduce successor, then `SetSupersededBy`), successor-first ordering.
- `replay = foldM applyTx`; fold-homomorphism law ⇒ checkpoint independence (P8).
- Full conditions register C1–C14 (table); invariants-made-unrepresentable table (P1, P8, P6, P4 via terms/identity immutability, P7 read-scoping, P9 via handler-field canon).
- Pareto uniqueness: adopted design B vs rejected A/C/D/E/F, each failing one forcing point; "why exactly three maps."
- `FieldWrite (h::Handler)` GADT is the C11 field→writer table; `Handler = Settle|Trade|Transfer|FeeCrystallise|Subscribe`.
- `LedgerError` full sum incl. `BasisNotTip`, `InvarianceViolation`, `ForeignOrigin`, `ScheduleIncomplete` (C14), `CauseNotCommitted`.
- Testing commitments referenced (deferred): handler mutation 85–90%, lifecycle-guard 70–80%, core ≥80%, bounded state-machine model.

**Worked examples:**
- Buyer/seller future quantities +1000/−1000 (why Position is holder-keyed).
- Runnable `main`: register CME-ES (mult 50); trade 1000 seller→buyer; check `netDelta`=0, `psBalance`=1000, `psAc`=1000; close-out back to flat `psBalance`=0 (retained, not Nothing); duplicate register `== Left (ReRegistration ...)`.

**Haskell:** The largest reference-core listing set (~500+ lines): `Qty`/`Price`/`BasisId`, `ProductTerms`, `UnitStatus`/`StatusWrite`/`applyStatus`, `PositionState`, `Ledger`/`LedgerError`, `Transaction`, `FieldWrite` GADT, `applyTx`, `amend`, `replay`, demo `main`. Stated as verbatim `reference/Ledger.hs` excerpts with two marked elisions (basis-weld bodies; `BoundaryEvent`/`Declaration`, deferred to sec09).
**Implementation-detail topics:** GADT encodings, `Map` storage, exact reference listings, the A–F alternative-design comparison (justification narrative), test-coverage commitments.

---

## sec06.tex — Portfolio Valuation and PnL (`sec:valuation`)

**Summary.** Derives valuation/PnL from wallet+conservation primitives: mark-to-market portfolio value, state-sufficiency principle, path-independent-PnL theorem, price/flow decomposition with a numeric example, dual valuation preview.

**Design decisions/definitions/theorems fixed:**
- Conservation ⇒ quantity balance, not value balance; value moves with external prices.
- **Definition (Portfolio value, `def:portfolio-value`):** V_t(W)=Σ_{w∈W}Σ_u w_t(u)P_t(u); reference currency P_t(USD)=1; portfolio = non-empty set of real wallets; whole-ledger sum = 0 (real+virtual cancel). Pricing methodology + reference-currency/FX deferred to valuation satellite.
- Qualification: P_t(u) presumes orderly/liquid markets.
- Five type-excluded illegal states: held-unit-no-price; adding two prices; path-dependence; empty scope; cross-paired endpoints.
- **Principle (State-sufficiency, `prin:state-sufficiency`):** value at t depends only on current balances/unit-state/prices; PnL is O(n) instruments; needs one basis-coherent snapshot (forward ref `inv:basis`).
- **Theorem (Path-independent PnL, P10, `inv:P10`):** PnL=V_{t1}−V_{t0}, proof by telescoping. Qualifications: only move-recorded activity counts; economic (not accounting) PnL.
- **Proposition (PnL attribution, `prop:pnl-attribution`):** PnL=PnL_price+PnL_flow; PnL_price=Σ_i w_{t0}(i)[P_{t1}(i)−P_{t0}(i)]; PnL_flow=Δw(USD)+Σ_i Δw(i)P_{t1}(i).
- Dual valuation (mark-to-market vs mark-to-mid) previewed; full treatment deferred to substantiation section.

**Worked examples:**
- USD ref, one unit AAPL: t0 USD 1000, AAPL 10 @100 ⇒ V_t0=2000; Buy 5@100 (−500,+5), Dividend +20, Fees −5, Financing −8; t1 USD 507, AAPL 15 @110 ⇒ V_t1=2157; PnL=157, price=10×10=100, flow=−493+550=57, 100+57=157.

**Haskell:** `Qty`/`Cash`/`Price` newtypes; `markValue`/`cashSub`; `PriceVec`; `Portfolio`+`mkPortfolio`; `value`; `Snapshot`; `pnl`. ~40 lines.
**Implementation-detail topics:** Pricing methodology, reference-currency/FX, dual-valuation mechanics all deferred to satellite/substantiation; the type-abstraction encodings.

---

## sec07.tex — Smart Contracts as Move Generators (`sec:contracts`)

**Summary.** Formal definition of a smart contract as a deterministic move-generating function; exact-integer arithmetic with a single rounding site; modular-contracts principle; move schedules for equity/dividend/corporate action, European put (cash + physical + lot split), and interest-rate swap with a CDM-lifecycle worked example.

**Design decisions/definitions/propositions fixed:**
- **Definition (Smart Contract):** Contract: (Input, State, Conditions) → [Move]; deterministic, effects are ledger entries; new product = new contract.
- Smart contract = executable transcription of the ISDA/CDM legal confirmation.
- Quantity = exact integer minor units (cents/satoshis/bp-notional).
- Rounding rule: round-half-to-even (IEEE 754), applied once at instruction projection (`projectAmount`), never in balance/payment arithmetic.
- **Principle (Modular contracts):** one contract per payout/obligation type, not composite per instrument.
- Equity/dividend/corporate-action patterns: trade = two moves; dividend = issuer-virtual→holders pro rata (recorded in UnitStatus for idempotency); bond accrued interest = dirty price from price function, clean = reporting convention; corporate actions = date-anchored transitions (governance deferred to sec09).
- European put schedule: Move 1 premium P·N (unconditional); Move 2 cash settlement (K−S_T)·N if S_T<K; physical-delivery variant.
- **Lot-size formula:** N_deliver=⌊N/L⌋·L, N_residual=N−N_deliver; whole lots DvP at strike, residual cash at intrinsic value, one atomic transaction.
- **Proposition (Lot-split conservation):** underlying and cash net to zero; value = put payoff regardless of split.
- Settlement projection: `sese.023` securities delivery + cash payment.
- IRS: Payment_k=N(r_float,k−r_fixed)δ_k; direction encodes sign.

**Worked examples:**
- European put (symbolic K,T,S,N,P).
- **IRS (CDM lifecycle):** 5-yr USD IRS, notional $10M, fixed 3%, quarterly resets. Inception (`ExecutionEvent`/OPEN): no cash, counter 0. Reset t1 (`ResetEvent`): SOFR 3.5%. Coupon t1 (`TransferEvent`): 10M×(3.5%−3%)×0.25=12,500 fixed→floating. Maturity (`TerminationEvent`/TERMINATE): final coupon, → TERMINATED.
- `projectAmount` GHCi transcript: 2.5→2, 3.5→4 (banker's rounding).

**Haskell:** `Qty` group; `Move` (with `mMeta`); `Contract i s c` synonym; `projectAmount`. ~55 lines.
**Implementation-detail topics:** `sese.023` message code, lot-size arithmetic; corporate-action date/price mechanics deferred to sec09.

---

## sec08.tex — Lifecycle Management (`sec:lifecycle`)

**Summary.** Trades and lifecycle events are the same primitive (a transaction). Formalizes the pure transition function, idempotence and purity principles, `applyTx` single door, time travel with four reconstruction scenarios, state-storage/embedded-defence, a lifecycle risk-profile mapping to P1–P10, and strategy-as-unit (QIS/leveraged ETFs).

**Design decisions/definitions/principles fixed:**
- Four consequences of trade/lifecycle identity: Uniformity, Conservation, Auditability, Composability.
- Transition function f: (unit, state_t(u), market_data) → (moves, state'); in code `handle :: Event -> Ledger -> Either LedgerError Transaction` (proposes, commits nothing).
- **Principle (Idempotence, `prin:idempotence`):** same event twice = no additional effect; grounded in state, not a "seen" list.
- **Principle (Single door, `prin:executor`):** `applyTx` is the only mutator; conservation is a Transaction-type property; product guards (balance sufficiency, stage legality) live in `handle`. Kernel analogy.
- `step` = `handle` then `applyTx`; `replay = foldM (flip step)`; fold-homomorphism ⇒ P8.
- **Principle (Purity, `prin:purity`):** fixed inputs → fixed outputs; requires deterministic market-data oracle (source/snapshot-time/fallback); replays read stored snapshots; corrections are separate versions. Testing reduces to unit/property/regression forms.
- Four time-travel reconstruction scenarios: (1) futures/margin PnL (VM call sequence + prices); (2) corporate actions/share denominators (2-for-1 split); (3) exercise/novation; (4) basket composition changes.
- Cloning: `clone()` and `clone_at(t)`.
- State lives in three-home model; `UnitStatus` never written off-log.
- Embedded-defence consequences: valuation justification, client notification, traceability.
- Lifecycle risk profile: Contract evaluation (pure, P1+totality oracle); State transition (pure, P5+P6+valid-transitions oracle); `applyTx` commit (sole mutator, P1+P2); Views/snapshots (read-only, P8); PnL projection (pure, P10); Balance computation (pure projection, P1+P3).
- Strategy-as-unit: state carries last-rebalance timestamp, weights/holdings, configuration (target leverage, rebalance frequency, reset rules), path-dependent flags; subscriptions/redemptions are lifecycle events; governed by C12.

**Worked examples:**
- 2-for-1 split (100 pre-split shares @ price → 200 post-split @ ~half; value preserved).
- Basket 40% A / 30% B / 30% C → B acquired, substitute D at merger ratio. (No fully numeric settlement example.)

**Haskell:** `handle` signature (commented, no body); `step`; `replay`. ~35 lines, mostly signatures.
**Implementation-detail topics:** Lifecycle-risk-profile test-oracle mapping and the unit/property/regression test-form breakdown are QA-process detail.

---

## sec09.tex — The State-Basis Discipline (`sec:basis`, `sec:state-basis`)

**Summary.** Prevents multiplying a quantity and a price measured in different corporate-action frames (bases) of the same instrument — the phantom-PnL error (stale pre-split price × post-split share count). Introduces a `BasisId`/chain coordinate stored in `UnitStatus`, a closed conversion-operator menu, a product adjustment schedule, a stamping ingest door, a typed read seam (`Snapshot b`) making cross-basis combination a type error, and one formal invariant (single-basis consumption). Heavily worked with split, dividend, index divisor, delisting, spin-off, elective merger; closes with a CDM corporate-action taxonomy.

**Design decisions/definitions/invariants/conditions fixed:**
- **Definition (Boundary event, `def:boundary-event`):** logged event on u with t_eff, declaration (datum-kind→operator map), provenance; content-addressed `bid`. Sources: corporate-action lifecycle transactions and external basis notices.
- **Definition (Basis id, chain, effective order, epoch, `def:basis-id`):** effective order = lexicographic on (t_eff, prec, bid); epoch ordinal derived/per-view, never stored.
- **Definition (basis field, `def:usbasis`):** `usBasis::BasisId` in UnitStatus, total from registration, written only by `SetBasis`, idempotent (P6).
- **Principle (Tip weld, `prin:tip-weld`):** `SetBasis b` admitted only if b is post-insertion effective tip → "basis regressed by late notice" unrepresentable.
- **Principle (Two planes, `prin:two-planes`):** entitlement plane (per-holder moves) vs quotation plane (one declaration per boundary).
- **Principle (Invariance weld, `prin:invariance-weld`):** basis-change transaction admitted only if moves+declaration satisfy the invariance identity; uniform case per-holder, elective case aggregate; refinements cash-in-lieu and withholding.
- **Theorem (Lifecycle value invariance across boundaries, `thm:basis-value-invariance`):** (qf)(p−c)/f = qp − qc.
- **Definition (Operator specification, `def:opspec`):** closed menu `OpSpec = Scale|Shift|Subst|Recompose|AId|Pending|Terminal`; parameters from declared terms; `AId` declared never assumed; partial map = fail-closed.
- **Definition (Basis conversions & composition, `def:basis-category`); Proposition (Composition law, `prop:composition-law`):** composite = composition in effective order; reverse iff invertible; identity/transitivity.
- **Principle (One declaration, two consumers, `prin:one-decl-two-uses`):** processor at t_eff, read seam thereafter; `txCause` = provenance only.
- **Definition (Dimension declaration, `def:dimension-declaration`):** four dimensions (quantity-of-u, price-in-basis, cash, dimensionless); per-dimension action table; dimension = constructor.
- **Theorem (Dimension invariance, `thm:dimension-invariance`):** identity holds field-by-field, proven over four dimensions once.
- **Principle (Re-derivation canon, `prin:rederivation`):** primitives transported, derived data re-derived.
- Adjustment schedule (three entry sources): class default (with derived `CADividendOrdinary` exception), declared override (closed first-order rule language), designated discretion; **Principle (Schedule authority, `prin:schedule-authority`)**; **C14 (adjustment-schedule totality)** — refusal `ScheduleIncomplete`.
- Ingest door (`ingest`/`ingestAt`): sole door; `Convention` (TracksChain/LagsBy/PreAdjusts/DeclaredAt/NoClaim); stamp per (unit,source); never defaulted from prevailing state; **TA-BASIS** trust assumption.
- **Principle (Stamping authority, `prin:stamping-authority`):** committed chain is single source of basis truth; four-layer architecture, exactly two boundary flows.
- Obligation set **O1–O8**.
- Datum-kind registry (§basis-kinds): per-component dimension declaration; absolute-strike vs moneyness vol as two kinds; mandatory invariance witness; **TA-KIND**.
- Market-data integrator: pin/transcribe/present/keep-refusals.
- Boundary faults **F1–F10**; property forms **P25, P-DET, P-MODE, P-PERM-N, P-PERM-O, P-CRASH, P-REPRO, P-CLONE-STAMP, P-LAG** (+ `pPartition`), each an executable oracle.
- **Invariant (Single-basis consumption, `inv:basis`):** (i) balances at β_t|_S; (ii) datum stamps agree over whole domain; (iii) multi-datum values under one β_t; stamp-closure well-definedness. **C13 (basis edge)** — data-plane counterpart of P3.
- Type-level enforcement: Tier-1 phantom-indexed `PriceAt (e::N)`/`BalAt (e::N)` + `Adj m n` GADT + `type role ... nominal`; Tier-2 `withSnapshot :: ... -> (forall b. Snapshot b -> r) -> r`, `transport` sole cross-scope door; parametricity/unreachability argument under a stated language-fragment proviso (Safe Haskell, nominal roles, unexported constructors, no Generic/Data/Typeable, no GeneralizedNewtypeDeriving, no Template Haskell).
- Time travel: `clone_at(t)` rebuilds `usBasis`; two axes (basis/effective order + knowledge/bitemporal); re-stamp derivation events with lineage.
- Failure regimes **W1 (Block), W2 (Per-unit quarantine), W2′ (Flagged-stale carry / `PricedStale`), W3 (Partition quarantine), W4 (Notice attestation)** — W4 requires signature or ≥2-source agreement, same-t_eff mutual-precedence rule.
- CDM mapping: closed 8-class taxonomy `CAClass` (CASplit, CADividendOrdinary, CADividendSpecial, CASpinOff, CAMergerStock, CAMergerElective, CATermination, CARebalance); confirmation gate; CDM `BusinessEvent`→transaction map F lands in (moves, SetBasis+declaration); mapping table.

**Worked examples (numeric):**
1. Opening: 1,000 sh @€100 → €100,000; 2-for-1 → 2,000 @€50; stale €100 × 2,000 = phantom €200,000 (refused).
2. June-1 timeline: May €2 dividend (`Shift −2`); 09:59 print 100 @b1; 10:00 split; read → 100/2=50; history print 102 across both → (102−2)/2=50; reversed 102/2−2=49 shown invalid.
3. Index divisor: A=60, B=84, level (60+84)/D=100⇒D=1.44; B splits, A=60 B=42; stale (60+42)/1.44≈70.83 (−29.2% phantom) refused; repair `Recompose` D′=1.02 → 100.
4. 2-for-1 split end-to-end (8 steps): EX1 publishes 100.00 @b3; transaction (+1,000→2,000, `SetBasis` b4, `Scale 2`); mark 2,000×50=€100,000; attribution with true post-split spot 55: price PnL 2,000×5=+10,000, flow 0; naive wrong split −45,000/+55,000; late-notice reconciliation.
5. Dividend: 1,000 @102, €2 div `Shift −2` f=1 → 100; cash 1,000×2=€2,000; total €102,000 unchanged.
6. Delisting: 1,000 sh, last print €12.00; `CATermination`/`Terminal`; €12,000 stale carry refused (Unpriced).
7. Spin-off: 1,000 A @€100; children A1/A2 1:1:1; `Recompose` basket {A1↦1,A2↦1}; pair value €100,000; naive double-count €120,000 vs true €100,000; component pricing refused until fresh stamps (later 1,000×80+1,000×20=€100,000).
8. Elective merger: 1,000 T @€100; €102 cash or 2.04 Q per share, 50% cap; A (500) cash →€51,000, B (500) stock →1,020 Q; blend `Subst(Q,1.02)∘Shift(−51)`; transport 100→(100−51)/1.02=2450/51; after value 1,020×2450/51+51,000=49,000+51,000=€100,000; per-holder ±€1,000 offset.
9. Dividend forecast: 1,000 sh @€100; €3 cash/share (price) + 1% (dimensionless); `Scale 2` → €1.50 cash (invariant 2,000×1.50=€3,000), 1% stands (1%×50×2,000=€1,000); misdeclared-as-price → 0.5% → €500 (wrong).
10. Vanilla call strike €100→€50; performance option S0 €100→€50, ratio invariant; special-dividend override €100 strike→€98.50 (vs default €98).
11. `CADividendOrdinary` exception: €100-strike call, €2 ordinary dividend — wrong shift →€98 (double-pays €2), correct leaves €100.

**Haskell:** Largest code section (~700+ lines): `OpSpec`; `BoundaryId`/`BasisId`; `Dim`/`TermsValue`/`transportField`; full ingest API (`ingest`/`ingestAt`, `StampedObs`, `Convention`, `RawDatum`, `IngestError`, `retained`); market-data contract API (`BasisView`, `basisView`, `viewAsOf`, `viewVersion`, `betaAt`, `chainAt`, `onChain`, `kindAt`); nine executable property oracles (`p25`, `pDet`, `pMode`, `pPermN`, `pPermO`, `pCrash`, `pRepro`, `pCloneStamp`, `pLag`, `pPartition`); generator/shrinker suite; Tier-1 type-level law (`N`, `PriceAt`, `BalAt`, `Adj`, `adjust`, `markValue`, `_bad`); Tier-2 seam (`Snapshot b`, `BalAt'`/`PriceAt'`/`At`, `withSnapshot`, `snapBal`, `snapPrice`, `markV`, `zipAt`, `Valuation`, `value`, `transport`); `CAClass`. Stated verbatim from `reference/Ledger.hs` Part M; execution pending toolchain.
**Implementation-detail topics:** `type role`/Coercible/Safe-Haskell fragment proviso; generator/shrinker machinery; ISO 15022/20022 message classes (MT564/565/566, seev.031/033/036) named only as attested-source instances; the ex-transition-lag `mQuoteEx` one-bit legacy mechanism (subsumed special case); F1–F10 fault table and the nine property-form oracles (verification catalogue); the declared-override rule-language grammar; TA-BASIS/TA-KIND governance statements.
