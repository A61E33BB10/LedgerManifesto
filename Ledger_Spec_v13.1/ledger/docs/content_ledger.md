# Content Ledger (v13.1 readability rewrite)

## FORMALIS — per-claim ledger

# CONTENT LEDGER — `ledger_v13_1.tex` (v13.1)

Gate for the readability rewrite. Every entry below must survive unchanged in substance (statement, formula, scope qualifier, and cross-reference identity). Locations are draft file + LaTeX label where one exists.

---

## A. Canonical Invariants P1–P25 (hub: `drafts/sec18.tex`, `\label{sec:invariants}`)

| ID | Assertion (one line) | Defined / proved at | Hub index |
|----|---|---|---|
| P1 | Conservation: Q(u)=Σ_w w_t(u)=0 for every unit u and time t; algebraic consequence of move semantics, never a runtime check. | sec03 `inv:P1` (Theorem System Closure, with induction proof) | sec18 |
| P2 | Atomic commitment: a transaction applies completely or not at all; no partial state observable. | sec03 `def:transaction`; sec05 C3 | sec18 `inv:P2` |
| P3 | Referential integrity: every move references existing wallets and an existing unit (executor consults Unit Store). | sec04 (Guarantees) | sec18 `inv:P3` |
| P4 | Log monotonicity: event stream append-only, hash-chained; tamper-*evidence* is the minimum, prevention is deployment. | sec13 (move-stream integrity) | sec18 `inv:P4` |
| P5 | Transaction idempotency: re-applying by `tx_id` has no incremental effect. | sec13 (duplicate events) | sec18 `inv:P5` |
| P6 | Lifecycle idempotency: same event on same unit state emits no additional moves; `SetBasis` is absolute replacement, so re-apply is identity. | sec08 `prin:idempotence`; sec05/sec09 | sec18 `inv:P6` |
| P7 | Virtual/real ledger isolation: no move has one endpoint in a virtual ledger and the other in the real ledger. | sec11 `sec:managed-trs` (realm tag) | sec18 `inv:P7` |
| P8 | Snapshot consistency: `clone_at(t)` reconstructs balances *and* unit state (incl. `usBasis`), identical to state at t, under retro-effective boundaries. | sec05 (replay fold homomorphism), sec08, sec09 `sec:basis-time-travel` | sec18 `inv:P8` |
| P9 | Lifecycle purity: fixed inputs give identical outputs, no effect beyond the return. | sec08 `prin:purity` | sec18 `inv:P9` |
| P10 | PnL path-independence: PnL = V_{t1} − V_{t0}, independent of intermediate transactions (telescoping proof). | sec06 `inv:P10` (theorem + proof) | sec18 |
| P11 | Paired legs: every SBL settlement carries securities + collateral legs (exceptions: uncollateralised, cash pool, triparty RQV). | sec17 `inv:P11` | sec18 |
| P12 | On-loan consistency: w^onloan_e(u) = Σ quantity of that entity's live loans of u. | sec17 | sec18 `inv:P12` |
| P13 | Collateral sufficiency: held collateral covers loan value; three formulations (per-loan cash, cash pool, non-cash bilateral). | sec17 | sec18 `inv:P13` |
| P14 | Locate before short: every short sale satisfies the locate precondition. | sec17 `sec:sbl-locates` | sec18 `inv:P14` |
| P15 | Partial-return monotonicity: loan quantity monotonically non-increasing. | sec17 | sec18 `inv:P15` |
| P16 | SFTR completeness: each reportable SBL event has exactly one SFTR report. | sec17 | sec18 `inv:P16` |
| P17 | Settlement-state monotonicity: settlement states advance monotonically. | sec17 | sec18 `inv:P17` |
| P18 | Lender ownership invariance: pure lender's `own` constant across lending ops under title transfer, buy-in excluded; by construction (lending writes `onloan`, never lender `own`). Scope restriction to pure lenders (borr=0) in sec17 `sec:sbl-onlending`. | sec17 `inv:P18` | sec18 |
| P19 | Rehypothecation regime compliance: validated against `legal_regime` (pre-condition; illegal state unreachable, not rolled back). | sec17; sec31 (140% cap logic) | sec18 `inv:P19` |
| P20 | Available-inventory identity: avail = own − onloan + borr; a definition computed on read, never stored, hence not violable. | sec17 `def:avail-projection`, `inv:P20` | sec18 `inv:P20-hub` |
| P21 | Obligation liveness: ∀t>t_d, o.state ∈ {Discharged, Compensated, Defaulted}; none persists live past deadline. | sec16 `inv:P21` + Theorem `thm:obligation-liveness` | sec18 |
| P22 | Obligation conservation: every discharge/compensation move set satisfies Q(u)=0; mechanism does not bypass the executor. | sec16 `inv:P22` | sec18 |
| P23 | Obligation idempotency: discharging twice by o.id has no incremental effect; composes with P5, P6. | sec16 `inv:P23` | sec18 |
| P24 | Basis tip agreement: at every accepted log prefix, booking-order status fold and effective-order chain projection agree on `usBasis` for every registered unit; no-regression is a corollary. | sec09 `prin:tip-weld` (property form); oracle in sec24 (`effTip`, `p24`) | sec18 `inv:P24` |
| P25 | Ingest-door soundness: on Right every stamped unit registered and every stamped basis id on the committed chain; on Left nothing admitted, payload retained (the Left IS the quarantine). | sec09 `sec:basis-contract` (executable `p25`) | sec18 `inv:P25` |

Global (unnumbered) oracles: **Totality** (every valid input → success or well-typed error, never unhandled exception) and **Valid transitions only** (any (product,state,event) triple absent from the transition table is rejected) — sec18 + sec24.

---

## B. Conditions C1–C13 (register: sec05 `sec:states-conditions`; index: sec18 `sec:invariants-conditions`; glossary: sec27)

| ID | Assertion | Forced at / defined in |
|----|---|---|
| C1 | Position accessor returns Option (never-held ≠ held-and-flat) AND the carrier is monotone (no row ever deleted); both halves. | sec05 `cond:C1` (PositionState) |
| C2 | Every Transaction carries conserved flow as edge moves whose signed per-unit sum is `mempty` by construction; vacuous (empty-list) base included; no validate gate. | sec05 `cond:C2` |
| C3 | One Transaction spans all three maps for one unit and applies in full or not at all; partial application unrepresentable. | sec05 `cond:C3` |
| C4 | Reads capability-scoped; cross-overlay reads forbidden; strategy exports flow only through UnitStatus. (Enforced at capability layer, not data reference — stated explicitly.) | sec05 `cond:C4`; escalation ME4 |
| C5 | UnitStatus registration-total: product-declared defaults (incl. basis origin `Origin u`) written at registration. | sec05 `cond:C5` |
| C6 | ProductTerms is a non-empty version list, append-only; no in-place mutation; append-only holds by absence of a setter. | sec05 `cond:C6` |
| C7 | ProductTerms registration-total: first version written at registration; `currentTerms` total (no Maybe). | sec04 `cond:C7` |
| C8 | Two-track amendment by a total fungibility predicate: Preserving appends a version; Breaking allocates fresh u and stamps `superseded_by`; successor introduced before predecessor stamped (no dangling pointer). | sec05 `cond:C8` |
| C9 | Move-less events fold to `mempty` — conserved vacuously; conservation sums edge legs, never divides by holder count. | sec05 `cond:C9` |
| C10 | Re-registering an existing unit id is a hard error, never a silent reset. | sec04 `cond:C10` |
| C11 | Each PositionState field has a canonical writer set (GADT `FieldWrite`); outside writer is a type error at authorship, erased at the delta row; balance field's sole writer is the Move edge. | sec05 `cond:C11` |
| C12 | All per-(wallet, mandate/strategy) economic state lives in PositionState[w, u_MA]; the W-sector is empty by schema (mandate is a unit). | sec05 `cond:C12`, `sec:states-three` |
| C13 | Basis edge: every consumed datum names its joint basis (Map UnitId→BasisId); consumption requires pointwise agreement over the stamp's whole domain with β_t, or a ledger-authored arrow; the data-plane sibling of P3. | sec09 `cond:C13`, `sec:basis-invariant` |

---

## C. Named Principles

| ID | Assertion | Location |
|----|---|---|
| PR-OWNERSHIP | Economic ownership *is* the wallet balance; no separate register of title. | sec03 (Principle Ownership) |
| PR-ATOMICITY | Every ledger change is a discrete time-stamped move; no implicit adjustments. | sec03 (Principle Atomicity) |
| PR-CONSERVATION | Conservation Law: per transaction, per unit, net change across all wallets is zero. | sec03 `cond:conservation` |
| PR-SELFCONS | Self-Consistency: internally inconsistent states structurally unreachable, not detectable after the fact; external boundary reconciliation remains. | sec03 (Principle Self-Consistency) |
| PR-UNITID | Unit Identity: same unit ⟺ fungible; OTC identity = full CDM Trade incl. Collateral; listed = contract spec (CCP novation). | sec04 `prin:unit-identity` |
| PR-STATESUFF | State-sufficiency: V_t depends only on current balances, unit state, prices — not history. | sec06 `prin:state-sufficiency` |
| PR-MODULAR | Modular contracts: one contract per payout/obligation type, not one composite per instrument. | sec07 (Principle Modular contracts) |
| PR-IDEMPOTENCE | Applying the same lifecycle event twice to the same state has no additional economic effect. | sec08 `prin:idempotence` |
| PR-SINGLEDOOR | `applyTx` is the only function permitted to change the ledger. | sec08 `prin:executor` |
| PR-PURITY | Fixed inputs ⇒ identical lifecycle outputs, independent of when/where run; requires deterministic market-data oracle + stored snapshots. | sec08 `prin:purity` |
| PR-TIPWELD | Tip weld: `applyTx` admits `SetBasis b` only as the post-insertion effective-order tip; “basis regressed by late notice” unrepresentable. | sec09 `prin:tip-weld` |
| PR-INVWELD | Invariance weld: basis-changing corporate action admitted only if moves + declaration jointly satisfy the invariance identity (quantity legs q·f up to cash-in-lieu, cash legs q·c). | sec09 `prin:invariance-weld` |
| PR-REDERIV | Re-derivation canon: primitive data transported by declared arrows; derived data re-derived from transported inputs; equivariance never assumed. | sec09 `prin:rederivation` |
| PR-STAMPAUTH | Stamping authority: the committed boundary chain is the single source of basis truth; no component outside the ledger authors, defaults, or adjusts a basis coordinate; projection is arithmetic-free. | sec09 `prin:stamping-authority` |
| PR-INTRADAY | Intraday-margin subtlety forces stored per-position `ac` with a single canonical writer (C11); price-derived VM gives wrong cash (−100 vs naive −300 witness). | sec10 (Principle in `sec:anchor`) |
| PR-NONVALUED | Mandate is non-valued: P_t(u_MA) undefined, not zero (pricing it double-counts client NAV). | sec11 `prin:nonvalued` |
| PR-BOUNDARY-SEP | Boundary Separation: Ledger provides *what* settles; settlement layer provides *how*; neither reads the other's internals. | sec14 `prin:settlement-boundary` |
| PR-CDM-SPLIT | Ledger carries economic substance; CDM carries business meaning; F's forgetfulness is forced and dropped detail is recoverable from payload. | sec15 (unnamed Principle) |
| PR-OBLCOMPLETE | Obligation completeness: a lifecycle function omitting a required obligation is incorrect regardless of move validity. | sec16 `princ:obligation-completeness` |
| PR-SINGLECOORD | Single-Coordinate Move: an atomic move modifies exactly one coordinate of one unit across the two entities it connects. | sec17 `princ:single-coord` |
| PR-SBL-REP | SBL representability: SBL is a smart contract over existing primitives (adds loan unit type, `legal_regime`, P11–P20); changes no primitive. | sec17 `princ:sbl-representable` |
| PR-TRADE-UNIT | Trade = Unit: the ledger unit is the full CDM Trade including Collateral; product identity ≠ unit identity (dual-CSA test). | sec28 (Principle Trade = Unit) |
| PR-CUSTFLAT | The custodian is flat: backing custodian's net exposure is zero by conservation (long underlying, short tokens equally). | sec28 (Principle, `sec:cdm-tokenized`) |

---

## D. Definitions

| ID | Content | Location |
|----|---|---|
| D-WALLET | Wallet: named account, w_t : U → ℝ; negative balance = short/obligation; logical partition, not a bank/custody account. | sec03 (Definition Wallet) |
| D-MOVE | Move: indivisible transfer of positive q of unit u, w_s −= q, w_d += q, timestamped, with source id and metadata. | sec03 (Definition Move) |
| D-TX | Transaction: the ONE atomic log event — ordered move list + non-balance state delta (rows, status writes, introduce/append/boundary); total order by sequence number within timestamp. | sec03 `def:transaction` |
| D-REALVIRT | Real vs virtual wallets: W_real (firm positions, affect PnL) vs W_virtual (external counterparties, reconciliation only). | sec03 (Definition Real vs Virtual) |
| D-PORTVAL | Portfolio value V_t(W)=Σ_{w∈W}Σ_u w_t(u)·P_t(u); whole-ledger sum ≡ 0 by closure, so valuation is always of a chosen scope; P_t external, reference currency P_t(USD)=1. | sec06 `def:portfolio-value` |
| D-CONTRACT | Smart contract: deterministic (Input, State, Conditions) → [Move]; sole output moves. | sec07 (Definition Smart Contract) |
| D-BOUNDARY-EV | Boundary event: logged event with unit, t_eff, declaration (partial map datum-kind → OpSpec), provenance; content-addressed (bid); two sources (CA lifecycle transactions, external basis notices). | sec09 `def:boundary-event` |
| D-BASISID | Basis id / chain / effective order / epoch: id = Origin u or Boundary bid; chain ordered lexicographically by (t_eff, prec, bid); epoch ordinal derived per view, never stored. | sec09 `def:basis-id` |
| D-USBASIS | Basis field: `usBasis :: BasisId`, total from registration (defaults to `Origin u`, C5), written only by `SetBasis` via `applyStatus`, absolute replacement (P6); invariant: equals the effective-order tip, welded not assumed. | sec09 `def:usbasis` |
| D-OPSPEC | Operator specification: Scale r (r≠0) / Shift / Subst u r (r≠0) / Recompose σ (invertible iff bijective) / AId (declared, never default) / Pending / Terminal; parameters from declared terms, never taxonomy; absence of a kind = no arrow (fail-closed); exact rational arithmetic, single rounding site `toPrice` (round-half-even, fixed in ProductTerms). | sec09 `def:opspec` |
| D-BASISCAT | Basis category: objects = basis ids; per-kind generating arrows from declared boundaries and Subst successions; inverses exactly where invertible; at most one arrow per kind between two ids. | sec09 `def:basis-category` |
| D-SETTLEPROJ | Settlement projection: SettlementTx → Maybe SettlementInstruction — pure, deterministic, stateless, idempotent, total; Just only for SETTLEMENT/COLLATERAL. | sec14 `def:settle-projection` |
| D-SETTLEINSTR | SettlementInstruction: plain data; settlement type ∈ {DVP,FOP,CASH} is a *projection* of which legs are present, never an independent field; no-legs unrepresentable. | sec14 `def:settlement-instruction` |
| D-OBLIGATION | Obligation o = (id, type, source, t_d, D, κ): D total discharge predicate on ledger state; κ total compensation, Nothing forces Defaulted. | sec16 `def:obligation` |
| D-OBLSTORE | Obligation store 𝒪: projection of the event log (filter to obligation-typed entries); each transition a logged state-only transaction; read cache, not a source of truth. | sec16 `def:obligation-store` |
| D-POSVEC | Position vector w⃗_e(u) ∈ ℝ⁶ = (own, onloan, borr, coll_post, coll_recv, coll_rehyp); each coordinate passes the physical-action test; own may be negative; coll_rehyp tracked for SFTR Art. 15. | sec17 `def:position-vector-gpm` |
| D-AVAIL | Available inventory avail(e,u) := own − onloan + borr, read-time projection, never stored. | sec17 `def:avail-projection` |
| D-PROJECTIONS | possess = avail + coll_recv; encumb = onloan + coll_post; AvailableToLend = avail − reserved; sell gate avail ≥ q. | sec17 `def:projections` |
| D-MGUARD | Mandate guard: precondition g on move generation; failure ⇒ no moves, unchanged state; deterministic only as pure fn of (ProductTerms, state, trade, pinned P_t); missing price fails closed; passive breach outside move-time guard domain. | sec11 (Definition Mandate guard) |
| D-DUALVAL | Dual valuation: P^MtMk (settlement/margin/external) and P^MtMd (risk/attribution) per unit; Δ_t(u) their differential; FVA adjustment for CRR Art. 105 prudent valuation. | sec12 (Definition Dual Valuation) |
| D-WORKEDFUT | Worked instrument: ES-FUT, mult 50, USD, expiry Day 3, CME-CH hub (not novating CCP — explicitly scoped). | sec10 (Definition The worked instrument) |
| D-GLOSSARY | Glossary entries (each canonical, ~45 terms incl. Accumulated cost, Basis stamp, Monotone carrier, PosQty, Registration, Transaction, UnitStatus). | sec27 `app:glossary` |

---

## E. Theorems & Propositions (statements AND proofs are load-bearing)

| ID | Assertion | Location |
|----|---|---|
| T-CLOSURE | System Closure: if every transaction conserves, Σ_w w_t(u) = 0 ∀u,t (induction from zero start). | sec03 `inv:P1` |
| T-LVI | Lifecycle Value Invariance (restricted): for deterministic cash-flow events total value invariant; qualification: under optionality holds for intrinsic value only (time value legitimately extinguished). | sec02 `prop:lifecycle-value-invariance` |
| T-TIMETRAVEL | Time Travel property: `clone_at(t)` reconstructs exact state; "as known at t" vs "restated" explicitly not conflated. | sec02 `prop:time-travel` |
| T-PNL | Path-independent PnL theorem + telescoping proof; qualifications: only recorded moves counted; economic not accounting PnL. | sec06 `inv:P10` |
| T-ATTRIB | PnL attribution: PnL = PnL_price + PnL_flow with formulas; worked example (157 = 100 + 57). | sec06 `prop:pnl-attribution` |
| T-LOTSPLIT | Lot-split conservation: underlying and cash net to zero; value transferred = (K−S_T)·N independent of lot split; N_deliver = ⌊N/L⌋·L. | sec07 (Proposition) |
| T-COMPLAW | Composition law: A_k(b→b′) = interp(g_n)∘…∘interp(g_1) in effective order; inverse iff all invertible; identity and composition laws; operators do not commute — order dissolved by data, not configured (49-vs-50 illustration). | sec09 `prop:composition-law` |
| T-BVI | Basis value invariance: (q·f)·(p−c)/f = q·p − q·c; weld makes hypotheses admission conditions; holds to the minor unit (cash-in-lieu are conserved flows). Proves T-LVI for basis boundaries. | sec09 `thm:basis-value-invariance` |
| T-CLOSEID | Closing identity: cumulative variation margin per wallet = economic PnL (A=+2100, B=−1700, C=−400, CH=0). | sec10 (Theorem) |
| T-SINGLETON | Mandate singleton support {(w_M,−1),(w_C,+1)} while live; pinned by four primitives (support restriction, Option accessor, lifecycle guard, C8) — conservation alone insufficient. | sec11 `inv:singleton` |
| T-FEEZERO | Fee zero-sum per crystallisation: Σ_w Δ_fee(USD) = 0 (proof by per-leg cancellation). | sec11 `thm:fee-zerosum` |
| T-SEG | Segregation: client isolation ⟺ CONS ∧ LOC ∧ C4; conservation alone does NOT forbid cross-client moves; supplies logical-segregation component of CASS 6 / MiFID II Art. 16(8); legal segregation out of scope. | sec11 `thm:seg` |
| T-TRSEQ | TRS ≡ funded managed account at the settlement primitive; difference is a CDM/reporting distinction (two-legged TotalReturnSwap reported from BusinessEvent, never the netted move); TR_k partial, requires V^v>0 as typed failure. | sec11 `thm:trs-equiv` |
| T-OBLLIVE | Obligation liveness theorem, proof via L1–L5 (registration completeness, workflow creation, timer durability, timer fires [cluster-availability prerequisite], handler totality). | sec16 `thm:obligation-liveness` |
| T-GPMCONS | GPM conservation: five-term sum over real entities + virtual wallets = 0; onloan cancels lender/virtual (lent shares counted once, as borrower's borr). | sec17 `prop:gpm-conservation` |

---

## F. Types & Listings (by name; verbatim-from-reference claims are load-bearing)

**Core algebra & three homes (sec03, sec05):** `Qty` (Integer minor units, Semigroup=+, Monoid mempty=0, `negQty`/`qneg`, `qmax`); `WalletId`, `UnitId`, `Timestamp`, `SourceId`; `Price` (Integer, deliberately NO Monoid); `BoundaryId` (abstract, content address), `BasisId = Origin | Boundary`; `Move` (illustrative Qty form sec03/sec07 vs reference `PosQty` form — distinction explicitly stated); `move` (sole ingest path, positivity guard); `moveDelta`; `Ledger` (sealed: constructor/selectors unexported; 4 fields `ledgerPT/ledgerUS/ledgerPS/ledgerBounds`, the last a derivable cache); `emptyLedger`; `LedgerError` (ReRegistration, UnitAlreadyExists, UnknownUnit, DanglingSupersede, BasisNotTip, InvarianceViolation, ForeignOrigin); `TermsVersion`; `ProductTerms` (abstract NonEmpty); `currentTerms` (total), `allVersions`, `appendVersion`; `Lifecycle = Registered|Active|Expired|Closed` (closed sum); `UnitStatus` (usLifecycle, usBasis, usLastSettle :: Maybe (Price,BasisId), usSupersededBy); `defaultStatus`; `StatusWrite` (SetLifecycle|SetBasis|SetLastSettle|SetSupersededBy — closed writer set); `applyStatus` (the ONLY status writer; absolute replacement writes); `PositionState` (psAc, psBalance, psHwm, psEntryNav); `zeroP`; `position` (Option accessor); `Transaction` (txUnit, txMoves, txRows, txStatus, txIntroduce, txAppend, txBoundary); `unitDelta`/`netDelta` (+ laws `== mempty`); `registerTx`, `appendTx`, `supersedeTx`; `Handler = Settle|Trade|Transfer|FeeCrystallise|Subscribe`; `FieldWrite (h::Handler)` GADT (WAc, WAcTrade, WHwm, WEntryNav — the C11 table; balance absent); `SomeWrite`; `applyWrite` (hwm by qmax monotone, entryNav write-once); `settleHandler`; `erase`; `register = applyTx . registerTx`; `applyTx` (single door: introduce/requireKnown/requireSupersedeTargets/requireBasisTip/requireInvariance/commit; origin weld `ForeignOrigin`); `applyMoveRow` (sole balance writer); `Fungibility = Preserving|Breaking`; `FungibilityPredicate`; `AmendResult`; `amend`; `replay = foldM applyTx` (fold-homomorphism law stated). Evaluation driver `main` with printed results (sec05 `sec:states-reference`).

**Valuation (sec06):** `Cash` (Monoid), `markValue`, `cashSub`, `PriceVec` (total function — held-unit-with-no-price unrepresentable), `Portfolio` (abstract, `mkPortfolio` rejects empty), `value` (scope-first, total, history-free), `Snapshot` (pairs one PriceVec with one Ledger), `pnl`. Five enumerated illegal states excluded by these types.

**Contracts (sec07):** `Contract i s c = (i,s,c) → [Move]`; `projectAmount :: Rational → Qty` (the SOLE rounding site, round-half-to-even, IEEE 754); European-put move schedule (premium, cash settlement (K−S_T)·N iff S_T<K, physical delivery, lot-split transaction); IRS Payment_k = N·(r_float,k − r_fixed)·δ_k, direction by sign, magnitude positive.

**Lifecycle (sec08):** `handle :: Event → Ledger → Either LedgerError Transaction` (proposes, never commits); `step = handle >=> applyTx`; `replay evs = foldM (flip step)`.

**Basis layer (sec09):** `OpSpec`; `ingest`/`ingestAt` (parse boundary; the published door factors `ingest l = ingestAt (basisView l)`); `StampedObs` (abstract, constructor unexported — no side door); `BasisView` (abstract, read-only, immutable, monotone under append, arithmetic-free); `basisView`, `viewAsOf`, `viewVersion`, `betaAt` (Nothing ⟺ unregistered), `chainAt`, `onChain`; `Convention = TracksChain|LagsBy k|PreAdjusts|DeclaredAt|NoClaim`; `RawDatum`; `IngestError = UnregisteredUnit|UndeterminedBasis|OffChainClaim` (+ `retained`); `chainPosAt`, `lagPosAt`. Tier-1 didactic types: `N`, `PriceAt (e::N)`, `BalAt`, `Adj m n` (constructors unexported; ledger fold sole author), `adjust`, `markValue` at equal index only, `_bad` type-error witness. Tier-2 seam: `Snapshot b` (skolem = whole basis assignment), `withSnapshot` (rank-2; one constructor of coherent read scopes), `snapBal`, `snapPrice` (fallible per unit), `markV`, `zipAt`, `Valuation = Priced|Unpriced|PricedStale`, `value :: Snapshot b → [WalletId] → (Cash,[Valuation])`, `transport` (sole cross-scope door). Role annotations `type role … nominal` are **normative** (coerce back-door defeated); language-fragment proviso (Safe Haskell; no GND/Generic/Data/Typeable/TH) bounds the parametricity claim.

**Futures kernel (sec10):** `Qty/Cash/Price/Day` local; `futMark` (only dimension crossing; VM = netq·S·mult + ac boxed identity); `PosQty`/`mkPosQty`/`unPosQty` (positivity a type guarantee, G5); `FutTerms` (six immutable fields); `Settlement`; `FutStage = FutRegistered | FutActive (Maybe Settlement) | FutExpired Settlement` (mark fused: (Registered, Just p) and (Expired, Nothing) unspellable); `settlement/settlementPrice/settlementDate` (projections); `stageRank`, `isExpired` (rank alone too weak — absorbing test required); `futRegisteredStatus`; `FutPos`, `futZeroP`; `Conserved` monoid; `FutRowDelta`; `FutStateDelta`; `futNetDelta`; `FutValidDelta` (abstract — `futValidate` sole constructor: kernel-local conservation discharge, projects onto core Transaction; explicitly *not* a second core); `activateTrade` (never wipes mark); `tradeDelta`; `settlementFanout` (ΔAc target reset; VM = −ΔAc); `closeDelta` (no stage write, no cash); `FutEvent = FTrade|FSettleVM|FExpire|FClose`; `futHandle` (guards G1 close-only-after-expiry, G2 EXPIRED absorbing, G3 self-trade reject, G4 settle/expire reject REGISTERED, G5 positivity parse); `FutLedger` (terms+status fused in one map — desync unrepresentable); `FutLedgerError` (9 constructors); `futRegister`, `futApplyDelta`, `futStep`, `futReplay` (Kleisli fold; stream assumed de-duplicated at boundary — duplicate FTrade not idempotent, stated); accessors `futProductTerms/futUnitStatus/futPosition/futCashOf/futHoldersOf`.

**Managed accounts (sec11):** abridged `Move`; `issueMandate`; `crystallise` (|x|, direction by sign, Nothing at 0); `FeeEvent`; `crystalliseFees` (two legs + `WHwm` ratchet, reused verbatim from three-home model).

**Substantiation (sec12):** `Balances` newtype (pointwise `unionWith (<>)` — explicitly NOT left-biased Map default; “the whole correctness content of this type”); `contribution`; `balances = foldMap contribution` (monoid homomorphism law `balances (xs++ys) = balances xs <> balances ys` — read three ways: order-stability, snapshot O(k) correctness, P1); `netBal`.

**Settlement (sec14):** `Asset = Security ISIN | CashCcy Currency`; `SettleMove`; `TxClass` (5 classes) + `settles`; `CdmPayload`; `SettlementTx` (boundary type, distinct from core Transaction); `SecuritiesLeg`, `CashLeg`; `SettlementLegs = DvP|FoP|CashOnly` (type and legs one value); `SettlementType`, `settlementType`; `SettlementInstruction`; `classify`; `legsOf` (Nothing for empty or non-decomposed multi-leg); `settleProjection`; `signedFor`, `reconciles` (gross-to-net algebraic identity). Status machine EXECUTED→INSTRUCTED→SETTLED / →FAILED (re-instruct, partial, cancel paths); status is a projection of logged events.

**CDM (sec15):** `Intent`, `LifecycleState`, `TradeState`, `PrimitiveInstruction` (PiTransfer|PiQtyChange|PiTerms|PiReset), `BusinessEvent`, `CdmTransaction` (boundary type; ctPayload keeps event verbatim, `ctPayload (forget e) == e`); `instructionMoves` (monoid homomorphism), `forget` (total, deterministic). F preserves: restricted composition (referentially independent events; cross-references resolved in causal order), conservation, sequencing, idempotency; F forgets intent/lineage/structure/classification (recoverable).

**Obligations (sec16):** `Obligation` record (obDischarge :: LedgerState→Bool total; obCompensate :: → Maybe [Move]); `Live = Pending|Attempted`; `Terminal = Discharged|Compensated|Defaulted` (no exit edge — terminal-escape unrepresentable); `ObState`; `Trigger`; `step` (total over Live×Trigger; DeadlineFired always Right = lemma L5).

**GPM (sec17):** `Position` (six fields), `zeroPos`, `avail` (total projection), `Coord` (six-constructor tag — two-coordinate move unrepresentable), `applyMove`; avail group-homomorphism law with δ_c per coordinate; non-negativity of operational coords is a **value-level precondition, not typed** (explicitly recorded); `SBLUnitState` field list; `available_to_lend` and `confirm_locate` pseudocode; SBL state machine table (total; terminals RETURNED/CANCELLED/DEFAULTED); SBL move schedules (initiation 4 moves, return 4, short sale 2, margin 2; LV = ⌈Q·P·M%·χ⌉_0.01, IBP-163).

**Oracles (sec24):** `Outcome = Accepted Ledger | Rejected TxError` (no third case — structural totality/P2); `Property i o`; `TxInput`, `Scope`; `registered`; `unitTotal`; `sameLedger` (observational equality); `p1, p2, p3, p7, idempotentTx`; `Hashed`, `chainOK` (P4); `p8`; `LifecycleFn`, `idempotentL` (P6); `validTransitionsOnly`; `p10`; `effTip` (recomputed from transactions' own BoundaryEvents, independent of ledgerBounds cache); `p24` (prefix-quantified; wrongful admission fails, wrongful rejection vacuous).

**Basis-boundary property/generator suite (sec09):** `p25`, `pDet`, `pMode`, `pPermN` (+ `permuteBoundariesBy`, `rebook`), `pPermO`, `pCrash`, `pRepro`, `pCloneStamp`, `pLag`, `pPartition`; `Seed`, `nextInt`, `splitSeed`, `genVendorBehaviour`/shrink, `genRawDatum`/shrink, `genStampedObs` (only via the door; never record syntax)/`shrinkStampedObs`, `genFeed`, `genPerm`, `genCrashPoint`, shrinkers, `genBoundaryEvent`/shrink, `genChain`/`shrinkChain` (prefix-closed), `genBoundaryStraddle`. Status caveat: authored and verified by inspection; **execution pending toolchain, not reported as passed**.

**Pricing coordination (sec26):** `Quote/Price/Cash`; `Distribution = Cum | Ex Cash` (“ex but amount unknown” unrepresentable); `Market` (mQuote, mQuoteEx); `priceOf` (three total equations; quote-only pricer inexpressible); `fibreOK` witness; scope = one-step f=1 fibre of the market-data contract, lag-only domain; quote-leading case handled by W3 fail-closed.

---

## G. Named guarantee sets, welds, workflows, obligations, faults

| Set | Content | Location |
|---|---|---|
| O1–O8 | Market-data obligation set: O1 raw observation minimum (value, t_obs, signed source, resolvable unit ref; t_obs never wall-clock-compared); O2 ledger attaches stamp from pinned projection + convention, replayable bit-identically; O3 no corporate-action awareness required of providers; O4 per-(unit,source) source basis convention, versioned, logged; O5 fail-closed (refuse + retain, never guess/default); O6 back-adjusted files stamped from declared adjusted-through convention; O7 signed feeds (gateway counter-sign otherwise); O8 corrections = new observations superseding by (source,unit,t_obs); re-coordination only via ledger re-stamp events. | sec09 `sec:basis-contract` |
| TA-BASIS | Named trust assumption: per-(unit,source) stamp true of source's dissemination; owner market-data ops; violation ⇒ mis-based valuation; detection W3 quarantine + daily reconciliation of vendor adjustment factors. | sec09 `sec:basis-ingest` |
| W1–W4 | Failure regimes: W1 Block (move-emitting consumption defers on BasisError, named unblock condition, queued under P21 — “real money never moves on an unwitnessed basis”; basis equality before staleness threshold); W2 per-unit quarantine ((Cash,[Unpriced…]), whole-book blocking rejected); W2′ flagged-stale carry (coherent-at-β⁻, never mixed; `PricedStale` must be pattern-matched); W3 partition quarantine (aggregate only within one stamp cell; no median across bases; innovation-without-boundary quarantines); W4 notice attestation (issuer/exchange signature or N_CA ≥ 2 content-hash agreement; same-t_eff weld requires declared mutual precedence else refusal + pending-transition, fail-closed). | sec09 `sec:basis-failure` |
| F1–F10 (faults) | Boundary fault catalogue with discharge per fault (late/duplicated/reordered/omitted notices; duplicated/reordered/omitted observations; clock skew — the only clock read is the W1 staleness check with threshold in ProductTerms and explicit clock argument; crash mid-ingestion; multi-vendor basis disagreement). | sec09 `sec:basis-contract` |
| G1–G5 | Futures guards: G1 close only after expiry; G2 EXPIRED absorbing; G3 self-trade rejected; G4 settle/expire reject REGISTERED (never silent promotion; chain REGISTERED→ACTIVE→EXPIRED with no skips); G5 positive-quantity parse boundary. | sec10 `futHandle` + Invariant (monotone, absorbing stage) |
| L1–L5 | Liveness lemmas (registration completeness; workflow creation w/ deterministic ID + duplicate-start rejection; timer durability; timer fires — engine-availability prerequisite; handler totality). | sec16 `sec:liveness-proof` |
| Futures invariants | Per-event conservation (three sums, futValidate); deterministic replay Kleisli fold (checkpoint independence a consequence; de-dup a boundary obligation); monotone absorbing stage (re-settle at same price is a no-op). | sec10 `sec:futures-invariants` |
| Single-basis consumption | Invariant B (i)–(iii): balances at β_t|_S; each datum pointwise-stamped over the stamp's *whole domain* (whether or not in S); multi-datum values under one β_t; well-definedness via stamp-closure; clause (iii) legislates legal inputs to a black box, never its interior. | sec09 `inv:basis` |
| First-touch rule | `first_touch_date` derived, never stored; general rule: what the fold determines is derived, only what the fold cannot reconstruct is state. | sec10 (After expiry) |

---

## H. Worked examples & numeric witnesses (figures are load-bearing)

| ID | Content | Location |
|---|---|---|
| WE-BUY | 500 AAPL @ $100: two moves, both unit deltas zero; balances 500/−500. | sec03 `fig:wallet-flow` |
| WE-PNLATTR | 157 = 100 (price) + 57 (flow) table. | sec06 |
| WE-IRS | 5Y USD IRS $10M fixed 3%: reset 3.5% ⇒ 12,500 coupon; CDM event mapping. | sec07 |
| WE-FUTLIFE | ES-FUT full life table: T1/Settle 102/T2 @103/Settle 101/T3/Expiry 105/Close; VM (+1000,−1000,0), (−100,+500,−400), (+1200,−1200,0); anchor: A's day-2 VM −100 not −300 (+200 intraday offset); direction-reversal remark (+5→−3 no special case); closing identity +2100/−1700/−400/0. | sec10 |
| WE-SPLIT | 2-for-1 split end-to-end: 1,000@100 → 2,000@50; both consumers €100,000; phantom €200,000 unrepresentable both tiers; attribution +10,000/0 (phantom ±45,000 gone); late-notice path via W3/W1/re-stamps. | sec09 `sec:basis-worked` + `sec:basis-contract` |
| WE-DIV | Shift 2, f=1: 102→100, cash 2/share, total €102,000; Cum/Ex recovered as one-step fibre. | sec09 |
| WE-DIVISOR | Index divisor: D=1.44 joint-stamped; post-split phantom 70.8 refused (pointwise check over full stamp domain {I,A,B}); legal paths (Recompose D′=1.02 / fresh observation / in-scope re-derivation). | sec09 |
| WE-MA | Managed account: subscribe 1,000,000; buy 5,000 AAPL@100; NAV 1,150,000; fees 5,750 + 28,850; HWM 1,115,400; wind-down; closing sum 34,600 − 150,000 + 115,400 = 0. HWM before subscription None, never 0. | sec11 `sec:managed-example` |
| WE-NKY | Nikkei multi-exchange: MtMd 35,500 vs SIMEX 35,480 / CME 35,490 / OSE 35,495. | sec12 |
| WE-CSA | CSA VM call: $2.3M MtM, threshold $500K, MTA $250K ⇒ $1.8M call; discharge/compensation paths; conservation check. | sec16 `sec:obligation-example-csa` |
| WE-SUBST | SBL collateral substitution: 4-move Bund-for-XYZ swap, per-unit conservation; deadline IBP-170; compensation escalation → GMSLA §10. | sec16 `sec:obligation-example-sbl` |
| WE-LEND | Alice lends 400 VOD: vectors (1000,400,0,…)/(0,0,400,…); virtual −400; conservation sum; three wrong scalar encodings (IFRS 9 §3.2.6 non-derecognition). | sec17 `sec:scalar-breaks`, `sec:named-wallets` |
| WE-CHAIN | On-lending chain Alice→Bob→Charlie table; intermediary identity onloan ≤ borr; cascade recall saga (buy-in GMSLA 9.3, IBP-328). | sec17 `sec:sbl-onlending` |
| WE-AVAIL8 | Eight-scenario avail verification A–H incl. on-lending defeat of own=avail+onloan and pledge PnL remark. | sec29 `app:avail-identity` |
| WE-EUSBL | EU GMSLA 2010 example: 500,000 TTE, 102%, Bund collateral 302,894 units; title-transfer poster writes `own` (defining regime distinction); rehyp; margin call 10,014; manufactured dividend 625,000; partial return with release split coll_recv 10,014 then coll_rehyp 116,741; fee €3,548.40; per-step conservation/P13/P15/P18/P19/SFTR(NEWT/VALU/MODI/ETRM) checks. | sec30 `app:eu-sbl-example` |
| WE-USSBL | US 15c3-3 example: 1M NVDA, $892.5M cash @102%; rebate FF−25bps; reinvestment (obligation persists at $892.5M while cash → MMF units); 140% cap validation pseudocode; margin +35.7M; SLATE mapping incl. deadlines (same-day 8pm ET / next-day) and Field #44; final rebates 956,250 + 651,666.67 = 1,607,917; cross-jurisdiction comparison table (only legal_regime, P19 pre-conditions, and PnL projection differ). | sec31 `app:us-sbl-example` |
| WE-NOTE | Structured note R = N·min(1, S_T/S_0): single capped PerformancePayout, not bond+put (3 reasons); redemption 800,000/200,000 value-invariance; three settlement paradigms spectrum. | sec28 `sec:cdm-structured-note` |
| WE-TOKEN | Tokenised NVDA double-counting table (custodian +1M/−1M net 0; system +1M); exposure = own(NVDA)+own(TOKEN) projection; shortfall = conservation violation. | sec28 `sec:cdm-tokenized` |
| WE-DATES | 5Y SOFR swap date resolution: 2026-10-03 Sat→Oct 5; 2027-10-03 Sun→Oct 4; δ = 182/360 ≈ 0.5056 and 91/360 ≈ 0.2528; day-count mismatch ≈ $11,111 on $50M @4%; six gotchas. | sec28 `sec:cdm-dates` |

---

## I. Architecture claims, uniqueness arguments, scope bounds, registers

| ID | Assertion | Location |
|---|---|---|
| A-SIXPROPS | Six by-construction properties: Atomicity, Conservation, Determinism, State-Sufficiency, Lifecycle Value Invariance (restricted), Time Travel. | sec02 |
| A-3BREAKS | Three internal breaks structurally unreachable *within scope*: trading/GL divergence, PnL/balance-sheet mismatch, inter-entity breaks; scoped to ledger-recorded activity during migration. | sec02, sec03, sec25 |
| A-BOUNDARY | Ledger boundary inside/outside lists (inside: positions, moves, lifecycle, PnL, time travel, internal reconciliation; outside: price formation, legal agreements, settlement infra, regulatory gateways, reference data, model governance, accounting policy) — stated once; every "within scope" refers here. | sec02 `sec:scope-overview` |
| A-2x2 | Placement rule: one home, one writer; two questions (holder-dependence; authority of record) give a 2×2 with three occupied cells; fourth cell empty (no authority issues facts about one holder's position); WalletRegistry carries identity, not economic state. | sec05 `sec:states-rule`, `sec:states-three` |
| A-USDISC | UnitStatus discipline stated once: convenience copy / read cache; catamorphism property; no out-of-band setStatus; external inputs enter only as logged observation events. (Echoed in sec04, 07, 08, 10, 12, 13, 15, 17, 21, 23, 24, 27 — all echoes must keep pointing at `sec:states-unitstatus`.) | sec05 `sec:states-unitstatus` |
| A-3MAPS | Why exactly three maps: (i) per-holder state ⇒ (w,u) map; (ii) shared observables ⇒ u-keyed map; (iii) two mutation disciplines ⇒ append-only third map; minimum basis, not compromise. | sec05 `sec:states-pareto-three` |
| A-UNIQUE | Design B unique Pareto-optimum; rejections of A (disciplines collapse), C (sentinel breaks conservation), D (empty W-sector), E (no tooling; shippability decides), F (universe wallet hides split as convention). | sec05 `sec:states-pareto` |
| A-UNREP | Unrepresentability table: P1←C2/C3, P8←C1(b), P6←C5, terms immutability←C6/C7 (underpins P4), identity immutability←C8/C10 (underpins P4), P7←C4 (capability layer, not type), handler canon←C11 (underpins P9); "no other candidate places more than three core invariants beyond reach." Precise meaning of "unrepresentable" (four mechanisms) stated. | sec05 `sec:states-unrep`; canonical map sec18 `sec:invariants-discharge` |
| A-VERBATIM | Verbatim claim: listings excerpted code-token-exact from `reference/Ledger.hs` with two marked elisions (basis-weld bodies; BoundaryEvent/Declaration decls); sec03/sec07/sec11/sec12 forms are *illustrative* (Qty magnitude) vs reference (PosQty) — the distinction itself is a claim. | sec05 remark + `sec:states-reference`; sec09 (Part M); sec24 (Part L) |
| A-QTY-INT | Quantities are exact Integer minor units, never floating point; conservation and deterministic replay are arithmetic facts floating point would forfeit; rounding once at instruction projection (round-half-to-even). | sec03, sec05, sec07, sec30 remark |
| A-KERNEL | Futures kernel is a boundary, not a core: `FutValidDelta` projects onto one core Transaction through `applyTx`; core keeps no validate gate. | sec10 |
| A-EXEC4 | Four execution-engine requirements (at-least-once delivery, durable timers, deterministic replay, single-threaded per instance); reference adoption of Temporal.io; at-least-once + idempotency = exactly-once. | sec16 `sec:exec-requirements` |
| A-RETRY | Non-retryable error classes: conservation violations, referential-integrity errors, idempotency rejections (logic errors, never transient). | sec16 `sec:executor-activity` |
| A-CH-HUB | CH is a settlement hub, not a novating CCP; firm's nonzero net VM is the boundary figure vs clearing-broker statement. | sec10 |
| A-INIT | Initialisation: no `set_balance` primitive; opening positions are conserving moves from virtual wallets; migration starts stream at t_init. | sec03 |
| A-SETTLE-TIMING | Atomic transaction records economic intent; legs settle asynchronously; Herstatt risk represented, not eliminated. | sec03 |
| A-FAILNOREV | Settlement failure does NOT reverse the economic position (exposure from trade date). | sec14 `sec:settlement-dvp` |
| A-CORRECT | Corrections are compensating transactions with `corrects` metadata chain; originals remain; amendment (TermsChangeEvent) ≠ cancellation; formal correction algebra open. | sec13 `sec:implementation-corrections` |
| A-3LAYER | Three layers (move stream / aggregation / projection); projection is a cache repaired by replay. | sec13 |
| A-ISO | ISO 20022 mapping is projection not translation; sese.023 field table; pacs.008/009; return path sese.025/camt.054; deterministic traceability chain. | sec13 `sec:implementation-iso`, sec14 |
| A-CDM-GAPS | Named CDM v6.0.0 gaps: no catalogue concept (sec04); Recall/Locate/Rehypothecation/tokenised-collateral-eligibility (sec17); CCP margin (sec28); four tokenisation gaps (identifier, custodial backing, DigitalAsset, on-chain settlement) (sec28); no CSDSettlement type (sec28); cascade recall has no CDM equivalent (sec17). CDM pinned to v6.0.0, FINOS-governed. | sec04/sec17/sec28; pin sec09 `sec:basis-cdm` + sec28 |
| A-LIMITS | Nine "does not" limitations; theorems-as-modelling-choices honesty clause; architecture ≠ operational system. | sec20 `sec:scope-limitations` |
| A-RESOLVED | Three resolved design problems: concurrency (single-writer), liveness (timers + P21–P23), state attachment (three homes). | sec22 |
| A-OPEN | Open problems list (14): netting/close-out, correction algebra, federation, XVA, bitemporal, tax-lot, impairment/ECL, GDPR Art. 17 vs append-only (crypto-shredding trade-off), access control/attribution, repos, default management, pre-trade validation, migration, tokenised securities. | sec22 |
| A-F1F8 | State-model adoption risk register F1–F8 with mitigations (F2/F5/F6 need external stakeholders; never merge below C1+C2+C3). | sec22 |
| A-ME | ME1–ME5 managed-account escalations (store-vs-derive; unattested observation surface/attestation envelope; LEI binding; C4 untyped; no solvency liveness). | sec11 + sec22 |
| A-FE | FE1 fan-out cost at scale (O(open positions), intrinsic, mitigations must preserve C2/C11); FE2 derived-consequence alternative declined. | sec10 + sec22 |
| A-TEST | Testing commitments: handlers 85–90% mutation; lifecycle guards 70–80%; core ≥80% (Feathers threshold); state machine |W|=3,|U|=2,depth ≤6, 10⁵–10⁶ states, TLC-tractable; conservation violations caught at depth 1. | sec22 (referenced from sec05) |
| A-RECON-TAX | Reconciliation taxonomy: 3 structurally unreachable / 6 easier-to-detect / SBL addressed by design; operational failures outside architecture remain. | sec25 `app:reconciliation` |
| A-FAQ | FAQ Q1–Q7 answers (move-less events must be accepted; DvP = atomicity ∧ contract correctness, conservation alone insufficient; lot-split boundary cases; SBL-native TOCTOU argument; own stored / avail projected; cash scalar sufficiency incl. 140% cap applies to securities not cash reinvestment; market-data contract summary). | sec21 |

---

## J. Regulatory & standards references (must survive by name/citation)

**Bibliography (master file):** ISLA Best Practice Handbook `\cite{isla-ibp}`; SEC Rule 15c3-3 (17 CFR §240.15c3-3) `\cite{sec15c33}`; Reg SHO Rule 203(b)(1) (17 CFR §242.203(b)(1)) `\cite{regsho}`; SEC Rule 10c-1a (adopted Jan 2024) `\cite{sec10c1a}`; FINRA Rule 6500 Series / SLATE (2024) `\cite{finra6500}`.

**Inline (by section):**
- sec02: IFRS 9 §§4.1.2, 4.1.4, 5.7.1–5.7.7; ASC 815, ASC 320/321, ASC 820; IFRS 13; EMIR, MiFIR, SFTR, Dodd-Frank, MiFID II RTS 25, CRR, FRTB (outside-boundary list); ISO 20022; ISDA CDM.
- sec06/sec11: IFRS 9 / US GAAP classification (FVTPL, FVOCI, amortised cost) out of scope.
- sec11: CASS 6 / MiFID II Art. 16(8) (segregation); IAS 32.42 / ASC 210-20 (net presentation); MiFID II Annex I §A(4) (mandate not reportable); SFTR/EMIR/CFTC dual-sided reporting; ISO 17442 LEI.
- sec12: IFRS 13 Level 1/2/3; IAS 1 ¶117–124; CRR Article 105 (prudent valuation / FVA).
- sec13/sec14: ISO 20022 sese.023 (+ identifier scheme footnote), sese.025, camt.054, pacs.008, pacs.009; LEI, BIC, MIC, EndToEndId.
- sec16: GMSLA 9.3 (buy-in), GMSLA §10 (default), ISDA Master Agreement close-out; IBP-170; SFTR/SLATE/EMIR reporting obligations as obligation types.
- sec17: IFRS 9 §3.2.6 (no derecognition — cited twice, load-bearing for the scalar-break argument and loan valuation); GMSLA 2000/2010/2018; US Rule 15c3-3 incl. 140% cap (b)(3); EU SSR Art. 12(1), 12(1)(a), 12(1)(c); ESMA 70-448-10; Reg SHO Rules 203(b)(1) and 204 (T+3); CSDR penalties; FINRA Rule 4320; SFTR Art. 15 (rehyp re-use); SFTR action codes NEWT/MODI/ETRM/COLU/VALU; ESMA UTI waterfall; MSLA, PBA; IBP-125, 129, 153/155, 163, 170, 177, 189, 191, 322, 323, 326, 328.
- sec19: EMIR Refit (EU 2024/1856, **203 fields**); MiFIR RTS 22 (**65 fields**); SFTR (EU 2015/2365, **155 fields**); CFTC Parts 43/45 (rewritten 2022–2024); ISDA DRR footnote (ISDA "DRR: 2025 Year in Review," Jan 2026 — 4 institutions live, >98% ack rates, figures pinned to publication); BCBS 239 Principles 6 and 11; DORA (EU 2022/2554) Art. 8 and Chapter IV.
- sec20: EU Settlement Finality Directive; IAS 39/IFRS 9 hedge accounting; CRR Art. 368; SR 11-7.
- sec28: CDM v6.0.0 pin; Rosetta/Rune schema; IFRS 9 SPPI-test parallel; ISO 8601; date enums (MODFOLLOWING etc.); ACT/360, 30/360 formulas.
- sec31: Rule 15c3-3(b)(3); Rule 10c-1a + FINRA 6500 deadlines (8:00pm ET same-day / next-day rule); SLATE Field #44; IRC §871(m); Fed Funds − 25bps rebate convention; Reserve Primary Fund 2008 / SEC Rule 2a-7 (sec17 reinvestment risk).

---

## K. Figures whose captions carry claims

| Figure | Claim | Location |
|---|---|---|
| `fig:overview` | Arrows are derivations, not synchronisations; nothing to reconcile within the boundary. | sec02 |
| `fig:conservation` | The beam weighs units, not money; value not conserved across optionality. | sec03 |
| `fig:wallet-flow` | Both moves atomic; per-unit totals conserved. | sec03 |
| `fig:threehome` | Fourth cell empty by construction; UnitStatus derived from log; valuation reads three homes + external P_t. | sec05 |
| `fig:lifecycle` | No single global machine; transitions determined by ProductTerms per unit-type; terminal states absorbing. | sec08 |

---

**Coverage note.** All 31 drafts read in full. The densest normative surfaces are sec05 (three-home construction, C1–C12), sec09 (basis discipline, C13, P24/P25, O1–O8, W1–W4, F1–F10, property suite), sec10 (futures kernel, G1–G5), sec17 (GPM, P11–P20), sec16 (P21–P23, L1–L5), and sec18/sec24 (canonical numbering + oracles). Any rewrite must preserve: (1) every P/C/O/W/G/L/F/ME/FE identifier and its exact scope qualifiers; (2) all "by construction vs value-level vs capability-layer" enforcement distinctions (the spec is explicit about which guarantees are type facts and which are not — e.g., C4 untyped/ME4, GPM non-negativity value-level, P4 tamper-evidence-only, generators verified-by-inspection-not-run); (3) all illustrative-vs-reference-form disclaimers; (4) every numeric witness; (5) every named regulatory citation and the CDM v6.0.0 pin.

## MINSKY — completeness cross-check

All 31 draft files read in full. Below is the COMPLETENESS cross-check: a section-by-section inventory of what each section ESTABLISHES. After any rewrite pass, every item listed under a section must still be findable there (or its move must be deliberate and re-linked).

# COMPLETENESS Cross-Check — Ledger Spec v13.1

**Target:** `/home/renaud/Ledger/Ledger_Spec_v13.1/ledger/ledger_v13_1.tex` + `/home/renaud/Ledger/Ledger_Spec_v13.1/ledger/drafts/sec01.tex` … `sec31.tex`
**Method:** per-section inventory of claims, types, labels, registers, tables, and worked numbers a reader must still find. Complements FORMALIS's per-claim ledger; focus here is on what is at risk of being dropped or merged away.

---

## 0. Document-level registers (single-statement-site discipline)

These are stated ONCE at a named site and referenced everywhere else. Losing the defining site breaks the whole document.

| Register | Members | Defining site | Indexed at |
|---|---|---|---|
| Invariants | P1–P10 core; P11–P20 SBL; P21–P23 obligation; P24–P25 basis | P1 sec03 (`inv:P1`), P10 sec06 (`inv:P10`), P11–P20 sec17 (`inv:P11`/`inv:P20`), P21–P23 sec16, P24/P25 sec18 prose + sec09 executable | Hub: sec18 (canonical numbering); oracles: sec24; P25+P-DET…P-LAG: sec09 |
| Conditions | C1–C13 | C1–C6, C8, C9, C11, C12 in sec05 (register table `sec:states-conditions`); **C7, C10 in sec04**; **C13 in sec09** (`cond:C13`) | sec18 index table; sec27 glossary restatement |
| Market-data obligations | O1–O8 | sec09 `sec:basis-contract` | sec21 Q7 |
| Failure regimes | W1, W2, W2′, W3, W4 | sec09 `sec:basis-failure` | referenced from sec09 tables, sec16, sec21 |
| Boundary faults | F1–F10 (fault catalogue) | sec09 `sec:basis-contract` (Boundary faults table) | — |
| Boundary properties | P25, P-DET, P-MODE, P-PERM-N, P-PERM-O, P-CRASH, P-REPRO, P-CLONE-STAMP, P-LAG, pPartition | sec09 (executable Haskell, "verbatim from reference Part M") | sec18 §Basis invariants; sec24 pointer |
| Adoption risks | F1–F8 (risk register — **name collision with sec09's F1–F10 faults**) | sec22 `Flagged Open-Items Register` | sec11, sec19 (F5, F6 cited) |
| Escalations | ME1–ME5 (managed), FE1–FE2 (futures) | Origin: sec11 / sec10; collected: sec22 | — |
| Futures guards | G1–G5 | sec10 (`futHandle` comments + prose) | — |
| Trust assumptions | TA-BASIS | sec09 `sec:basis-ingest` | O4, sec26 scope |
| Lemmas | L1–L5 (liveness proof) | sec16 `sec:liveness-proof` | — |
| Testing targets | mutation scores 85–90 % / 70–80 % / ≥80 %; TLC state bound | sec22 (referenced from sec05) | — |

⚠ **Collision watch:** "F1–F8" means adoption risks in sec22 but fault scenarios in sec09 (F1–F10). Both must survive; do not merge or renumber one into the other.

---

## Roadmap (sec01, unnumbered)
- Audience reading-path table (Regulator / Implementer / Quant / Market-data integrator / Risk manager), each with minimal path, then-if-needed, may-skip columns.
- Claim: scalar balance carries Parts I–IV; six-coordinate vector deferred to Part V.

## §1 Purpose, Scope, and Properties (sec02, `sec:intro`)
- Problem statement: multi-source-of-truth admits inconsistency by construction.
- The **six properties**: Atomicity; Conservation (∑w(u)=0, quantities not values); Determinism; State-Sufficiency; **Lifecycle Value Invariance** (`prop:lifecycle-value-invariance`, restricted form + optionality qualification: intrinsic value only, time value extinguished); **Time Travel** (`prop:time-travel`, clone_at(t); "as known at t" vs "restated" distinguished).
- **Three unreachable internal breaks** (named: trading/GL divergence, PnL/balance-sheet mismatch, inter-entity breaks) — mechanism deferred to §2.
- Architecture vocabulary (wallet/move/transaction/smart contract/move stream) + Figure `fig:overview` (one-way projections, ledger boundary dashed box, external authorities at edge).
- Scope: FVTPL trading books, IFRS 9/13, ASC 815/320/321/820 footnote; banking book out.
- CDM as canonical vocabulary (4 roles: unit universe, lifecycle transitions, PBT input bound, ISO 20022 mapping).
- **The Ledger Boundary** (`sec:scope-overview`): the inside list (6 items) and outside list (7 items: price formation, legal agreements, settlement infra, regulatory gateways, reference data, model governance, accounting policy). Sentence: every "within scope" qualifier refers to this list. *This is the sole boundary statement in the document; sec20, sec22 rely on it.*

## §2 The Closed Ledger System (sec03, `sec:ledger`)
- Definitions: **Wallet** (w_t : U→ℝ, negative = short), **Move** (positive q, semantics w_s−=q, w_d+=q), **Transaction** (`def:transaction`: moves + non-balance state delta; total order by sequence number within timestamp), **Real vs Virtual Wallets**.
- Principles: **Ownership** (ownership = balance), **Atomicity**, **Conservation Law** (`cond:conservation`), **Self-Consistency**.
- **Theorem System Closure** (`inv:P1`) with induction proof.
- Haskell (illustrative form, distinguished from reference PosQty form — the distinction itself is load-bearing): `Qty` group (Semigroup/Monoid/negQty), `WalletId/UnitId/Timestamp/SourceId`, `Move`, `move` (Maybe parse boundary), `moveDelta`, `Ledger` type synonym, `balance/adjust/applyMove`, `Transaction` record (7 fields incl. `txIntroduce/txAppend/txBoundary`), `unitDelta` with mempty law, `buyAAPL` worked transaction (500 AAPL @ $100).
- Conservation as monoid-law fact, not runtime check; foldMap = unique homomorphism; empty move list conserved for free.
- Figures: `fig:conservation` (balance beam), `fig:wallet-flow` (AAPL purchase).
- **Initialisation** paragraph: no set_balance primitive; migration at t_init.
- Books and reference wallets (reporting convention only).
- Three unreachable breaks itemised with mechanisms; migration scoping caveat; boundary failure modes remain; **Settlement timing** paragraph (Herstatt risk represented, not eliminated; CLS/FX).

## §3 The Unit Store (sec04, `sec:unit-store`)
- Local `condition` theorem environment (unnumbered starred) — **C7** (`cond:C7`, ProductTerms registration-total) and **C10** (`cond:C10`, no re-registration) are DEFINED here, not in sec05.
- **Principle Unit Identity** (`prin:unit-identity`, fungibility ⇔ same unit) + identity-key table (8 instrument classes; OTC = full CDM Trade incl. Collateral; dual-CSA point; tokenised = contract address + chain ID).
- Three-tier architecture (Reference Data / Product Registry / Unit Registry) + `UnitEntry` listing + deterministic injective unit_id derivation.
- Where evolving state lives → three-home forward reference; UnitStatus-is-projection restatement.
- Registration: three channels (cash pre-registered, listed via feed, OTC at execution); atomic; units never deleted; terminal-stage behaviour.
- Haskell: `ProductTerms` NonEmpty newtype, two-constructor `LedgerError` subset, `registerTx`, `register = applyTx ∘ registerTx` (register is not a second door), success/rejection evaluation pair.
- Registration is vacuously conserved (moveless).
- Two-stage validation: 4 registration checks + 3 transaction-time checks.
- **Four guarantees** (existence, identity/terms immutability, contract availability, CDM alignment) → discharges P3.
- CDM alignment table + honest gap statement (no catalogue concept in CDM).
- **Key Invariants and Consequences** recap box (P1, P2, P4, P5/P6, P8/P9, unreachable-breaks consequence) — closes Part I.

## §4 Three-Home State Model (sec05, `sec:states`) — the largest normative section
- Thesis: three homes, one map each; no wallet-keyed map; one home/one writer ⇒ no internal reconciliation failure.
- **Placement rule + 2×2** (`sec:states-rule`): two questions (holder-dependence; authorship), 2×2 table with empty fourth cell; WalletRegistry carve-out (KYC etc. is identity, not economic state); benchmark level vs benchmark identity sorting example. Figure `fig:threehome`.
- **Why three homes** (`sec:states-three`): four arguments (buyer/seller asymmetry; shared settle price; differing mutation disciplines; no authority issues per-position facts); **W-sector collapse (C12)** with mandate-issuance conservation display; two-mandates-one-wallet point; explicit exclusion of (holder, several-units) facts.
- **UnitStatus discipline stated once** (`sec:states-unitstatus`): convenience copy; catamorphism property; sole writer applyStatus inside applyTx; external inputs enter only as logged observation events. *Every other section's "UnitStatus is a projection" remark points here — the anchor must survive.*
- **The construction** (`sec:states-construction`), Haskell woven (claimed verbatim from `reference/Ledger.hs` core, with 2 marked elisions):
  - Scalars: `Qty` (+qneg, qmax), `WalletId/UnitId`, `Price` (no Monoid), `BoundaryId` (abstract content address), `BasisId = Origin | Boundary`.
  - `TermsVersion`, `ProductTerms` (abstract NonEmpty; `currentTerms` total; `appendVersion`; C6/C7).
  - `Lifecycle = Registered|Active|Expired|Closed`; `UnitStatus` record (usLifecycle, **usBasis**, usLastSettle (Price, BasisId), usSupersededBy); `defaultStatus` (Origin u — C5); closed `StatusWrite` (4 constructors); `applyStatus` (absolute replacement writes, P6).
  - `PositionState` (psAc, psBalance, psHwm, psEntryNav) + zeroP; C1 two halves (Option accessor; monotone carrier).
  - Sealed `Ledger` (ledgerPT/US/PS + **ledgerBounds** cache — explicitly not a fourth home); `emptyLedger`; full `LedgerError` (7 constructors incl. DanglingSupersede, BasisNotTip, InvarianceViolation, ForeignOrigin).
  - `Transaction` (reference form), `unitDelta`/`netDelta` laws, `registerTx`/`appendTx`/`supersedeTx`.
  - **C11 GADT**: `Handler`, `FieldWrite` (WAc/WAcTrade/WHwm/WEntryNav; balance deliberately absent — sole writer is the Move edge), `SomeWrite` erasure, `applyWrite` (qmax monotone HWM, write-once entryNav), `settleHandler`, `erase`, the `_c11_bad` type-error witness.
  - **`applyTx` single door**: introduce (C10 + ForeignOrigin origin-weld), requireKnown, requireSupersedeTargets, tip/invariance weld hooks (bodies elided → sec09), commit; `applyMoveRow`; `amend` (C8 two-track, Preserving/Breaking, `AmendResult`); successor-before-stamp ordering.
  - `replay` foldM + fold-homomorphism law; checkpoint soundness.
- Remark: projection generalisation (balances/UnitStatus/value all catamorphisms).
- **Conditions register C1–C13** (`sec:states-conditions`): longtable with hypertargets `cond:C1`…`cond:C12` (C7/C10/C13 cross-refs), "Forced at" column.
- **Why exactly three maps** (`sec:states-pareto-three`): three forcing constraints.
- **The unique design** (`sec:states-pareto`): rejected alternatives A, C, D, E, F with the one forcing failure each.
- **Invariants made unrepresentable** (`sec:states-unrep`): 7-row mechanism table (P1, P8, P6, terms-immutability→P4, identity-immutability→P4, P7/C4, handler canon→P9); precision paragraph on what "unrepresentable" claims (C4 explicitly NOT type-level); closing claim "no other candidate places more than three beyond reach."
- **Reference implementation** (`sec:states-reference`): reference file identity, 7-bullet checklist, executable `main` demo with printed results (Nothing/Just default/netDelta 0/Just 1000/flat-row/ReRegistration), verbatim-claim semantics ("code-level: tokens exact").
- Testing-commitment pointer to sec22/App properties.
- **Key Invariants and Consequences** recap (6 bullets).

## §5 Portfolio Valuation and PnL (sec06, `sec:valuation`)
- Quantity vs value distinction (FX witness).
- **Definition Portfolio value** (`def:portfolio-value`): V_t(W); whole-ledger sum = 0 by closure ⇒ valuation always scoped; P_t external; qualification (halts/illiquidity).
- Haskell: `Qty/Cash/Price` (Price no Monoid), `markValue/cashSub`, `PriceVec` (total function — "held unit with no price" unrepresentable), `Portfolio` abstract + `mkPortfolio` (empty scope unrepresentable), `value`, `Snapshot` (price vector bound to ledger — cross-pairing unrepresentable), `pnl`.
- The **five illegal states** paragraph (no-price, price-addition, path-dependence, empty scope, endpoint cross-pairing).
- **Principle State-sufficiency** (`prin:state-sufficiency`); O(n) vs O(m) claim.
- **Theorem Path-independent PnL** (`inv:P10`) + telescoping proof; qualification (unrecorded events); scope (economic vs accounting PnL).
- **Proposition PnL attribution** (`prop:pnl-attribution`) + worked AAPL table (157 = 100 + 57).
- Dual-valuation forward pointer to sec12.

## §6 Smart Contracts as Move Generators (sec07, `sec:contracts`)
- **Definition Smart Contract** (deterministic (Input, State, Conditions) → [Move]); contract=confirmation-transcription claim; CDM enums.
- Integer minor units doctrine; rounding ONCE at instruction projection (round-half-even); `projectAmount` sole rounding site with ghci evaluations (2.5→2, 3.5→4).
- Haskell: local `Qty` group, `Move` (7 fields incl. mMeta — noted illustrative vs reference), `Contract i s c` synonym; totality/determinism remark.
- **Principle Modular contracts** (per payout, not per instrument; CSA margin example; executor orchestrates).
- Equity/dividend/bond-accrual/corporate-action prose: dirty-price treatment; multi-date corporate-action mechanism (announcement/record/ex/payment); 2-for-1 split with corporate-action virtual wallet; UnitStatus-projection remark.
- **European put full schedule**: Moves 1–2 cash settlement; physical delivery pair; **lot-size constraint** N_deliver/N_residual formulas + 3-move atomic transaction; **Proposition Lot-split conservation** (value = (K−S_T)·N independent of split); generalisation claim (convertibles, warrants, forwards); sese.023 pointer.
- **IRS full schedule**: Payment_k formula; direction-carries-sign rule; worked 5Y USD IRS with 4 CDM lifecycle events (ExecutionEvent/ResetEvent/TransferEvent 12,500/TerminationEvent).

## §7 Lifecycle Management (sec08, `sec:lifecycle`)
- Lifecycle event = transaction identity; four consequences (uniformity, conservation, auditability, composability).
- Transition function f : (unit, state, market_data) → (moves, state′); `handle :: Event -> Ledger -> Either LedgerError Transaction` (proposes, never commits).
- **Principle Idempotence** (`prin:idempotence`) + Figure `fig:lifecycle` (state machine, absorbing terminals, no-global-machine caption).
- **Principle Single door** (`prin:executor`): applyTx sole mutator; conservation not checked at boundary (property of the type); product guards live in handle; OS-kernel analogy; `step`/`replay` listing; fold-homomorphism paragraph (checkpoint-independence is a law, not a test).
- **Principle Purity** (`prin:purity`): market-data oracle requirement; versioned snapshots; as-known vs restated; three test forms.
- **Time travel**: the four non-trivial situations (futures margin story; corporate actions/denominators; exercise/novation; basket redefinition); clone()/clone_at(t) definitions; backtesting reduction.
- State storage: no off-log UnitStatus writes; embedded-defence 3 consequences (valuation justification, client notification, traceability).
- **Lifecycle Risk Profile table** (`sec:risk-profile`): 6 function categories × purity guarantee × property coverage.
- **Strategy as unit** (QIS/leveraged ETF): state contents, rebalance lifecycle, subscription/redemption as lifecycle events, C12 pointer.

## §8 The State-Basis Discipline (sec09, `sec:basis`/`sec:state-basis`) — largest single file
- Motivation: 2-for-1 split phantom (2,000×100 = €200,000); defect = missing referential-integrity edge; "no internal reconciliation can catch it."
- Why observation time cannot be the coordinate (lag, per-venue ex dates, retro-effectivity); why no fourth home.
- **Definitions:** Boundary event (`def:boundary-event`: t_eff, declaration, provenance, content-addressed bid; two sources — lifecycle transactions and external basis notices); Basis id/chain/effective order/epoch (`def:basis-id`: lexicographic (t_eff, prec, bid); ordinals derived, never stored); the basis field (`def:usbasis`).
- **Principles:** **Tip weld** (`prin:tip-weld`: SetBasis admitted only as post-insertion effective tip; retro-effective ⇒ re-assert standing tip; "basis regressed by late notice" unrepresentable); **Invariance weld** (`prin:invariance-weld`: moves+declaration must satisfy the invariance identity); **Re-derivation canon** (`prin:rederivation`: primitives transported, derived re-derived; joint stamps); **Stamping authority** (`prin:stamping-authority`).
- **Operators:** `OpSpec` (Scale/Shift/Subst/Recompose/AId/Pending/Terminal; side conditions via smart constructors); absence-is-fail-closed; exact rational arithmetic, `toPrice` single rounding site.
- **Definition basis category** (`def:basis-category`) + **Proposition Composition law** (`prop:composition-law`, 4 equations); 49-vs-50 illustration (dividend Shift 2 then split Scale ½: 50 correct, 49 not an arrow).
- **Theorem value invariance** (`thm:basis-value-invariance`): (q·f)·(p−c)/f = qp − qc, with proof; cash-in-lieu to the minor unit; proves §1's restricted property for basis boundaries.
- Pending crystallisation paragraph (basis advances at effectiveness; parameter publishes later under C6).
- **Ingest door** (`sec:basis-ingest`): `ingest` signature, `StampedObs` abstract; per-(unit, source) stamping; **TA-BASIS** trust assumption (owner/content/violation/detection).
- **Market-data contract** (`sec:basis-contract`):
  - `BasisView` projection API: `basisView/viewAsOf/viewVersion/betaAt/chainAt/onChain`; three contract facts (immutable, monotone under append, arithmetic-free).
  - `Convention` (TracksChain/LagsBy/PreAdjusts/DeclaredAt/NoClaim), `RawDatum`, `IngestError` (UnregisteredUnit/UndeterminedBasis/OffChainClaim), `retained`, `ingestAt`, `ingest = ingestAt ∘ basisView`.
  - Direction of flow (exactly two arrows; pull-based).
  - **Obligation set O1–O8** (raw observation; the stamp; no CA-awareness; source basis convention; fail-closed; back-adjusted files; signature; corrections).
  - Primitive vs derived (authority tracks computation).
  - **Datum-class table** (spot/implied vol/index level/composition files/fixings/curves × stamp coverage × operators × fail-closed meaning).
  - One contract three modes (real-time = batch = historical; stamp pure function; mode not an argument).
  - Two-consumers worked example (09:29 b₃ €100,000 vs 09:31 b₄ €100,000; phantom formable in neither).
  - **Boundary fault catalogue F1–F10** with discharge column.
  - **Property forms**: P25, P-DET, P-MODE, P-PERM-N, P-PERM-O, P-CRASH, P-REPRO, P-CLONE-STAMP, P-LAG, pPartition — full executable Haskell, plus generator/shrinker suite (`Seed`, `genVendorBehaviour`, `genRawDatum`, `genStampedObs` door-only generation, `genFeed/genPerm/genCrashPoint`, `permuteBoundariesBy/rebook`, `genBoundaryEvent`, `genChain` prefix-closed shrinking, `genBoundaryStraddle`); honesty note "execution pending toolchain, not reported as passed."
- **Invariant Single-basis consumption** (`inv:basis`, clauses i–iii; stamp-closure well-definedness; black-box clause iii) + **C13** condition form (`cond:C13`, "data-plane sibling of P3").
- **Type-level enforcement** (`sec:basis-types`): Tier 1 didactic (`N`, `PriceAt/BalAt` with **nominal role annotations**, `Adj` GADT, `adjust`, `markValue`, `_bad` type error); Tier 2 normative (`Snapshot b` skolem, `withSnapshot` rank-2, `snapBal/snapPrice/markV/zipAt`, `Valuation = Priced|Unpriced|PricedStale`, `value` returning (Cash,[Valuation]), `transport`); **parametricity unreachability argument**; **language-fragment proviso** (Safe Haskell, nominal roles, no coerce/Generic/GND/TH — normative, not stylistic).
- **Time travel & late CAs** (`sec:basis-time-travel`): two orthogonal version axes (basis = effective order; knowledge = bitemporal); re-stamp derivation events with lineage; "reproducible AND right vs reproducibly wrong."
- **Failure workflow table W1/W2/W2′/W3/W4** (trigger/consequence/mandatory-for; W1 blocks real money; W2 total+enumerated exclusions; W2′ coherent-at-β⁻ with PricedStale; W3 partition quarantine = TA-BASIS detection; W4 attestation, N_CA≥2, same-t_eff weld, pending-transition); pending spin-off is the normal case.
- **2-for-1 split end to end** (`sec:basis-worked`): 7 steps incl. attempted bug (compile error + Left BasisMismatch), attribution (−45,000/+45,000 phantom pair gone), late-notice walk; dividend fibre (recovers App pricing-coordination's Cum/Ex exactly; quote-leading case = W3); **index divisor** worked case (70.8 phantom refused; three legal paths; D′=1.02).
- **CDM corporate-action mapping table** (`sec:basis-cdm`): 8 rows (splits→Scale, dividends→Shift, spin-off→Pending, merger→Subst via C8, cash merger→Terminal, index rebalance→Recompose/W4, election windows, plain TermsChange→no declaration); F extension rule (moves + declaration, keyed on terms never taxonomy).
- **Key Invariants** recap (8 bullets: C13; theorem-not-claim; no regression; fail-closed by expressibility; phantom unrepresentable; two arrows; time travel free; protected elements untouched) + closing line "the pairing is the invariant."

## §9 The Futures Lifecycle (sec10, `sec:futures`)
- Framing: futures kernel is a **boundary that projects onto core Transaction** (not a second core) — this disclaimer appears 3×, load-bearing.
- Field-placement table (terms/status/position); ac is a conserved field enforced at handler level (C2).
- Atomic delta (`FutStateDelta`), abstract witness `FutValidDelta` via `futValidate` — the futures engine's own conservation discharge.
- **Dimension bridge**: `Qty/Cash/Price/Day`; `futMark`; Price no Monoid; VM identity typechecks only in Cash; minor-unit scale note; `PosQty`/`mkPosQty`/`unPosQty` **parse boundary (G5)**; evaluations incl. the Price<>Price type error.
- **Definition worked instrument** (ES-FUT, m=50, expiry Day 3; wallets A/B/C/CH); CH is settlement hub, **not** novating CCP (explicit clearing-out-of-scope note); firm-not-flat boundary note (CH leg = net VM reconciled vs clearing broker).
- Two rules (trade: ac += −Δ·p·m; settlement: VM = net·S·m + ac then reset) + the full **life table** (Listing/T1/Settle d1/T2/Settle d2/T3/Expiry/Close with all net, ac, VM figures).
- Listing: fused stage `FutStage = FutRegistered | FutActive (Maybe Settlement) | FutExpired Settlement` — two unspellable states; `settlement/settlementPrice/settlementDate` projections; `stageRank`; `isExpired` (rank alone insufficient — the 2<2 argument); `futRegisteredStatus`; REGISTERED-is-not-exchange-admission clarification.
- First trade: PosQty positivity rationale (q=0 would forge Some-flat rows; q<0 swaps parties); `FutPos/futZeroP/Conserved` monoid/`FutRowDelta`/`FutStateDelta`/`futNetDelta`/`futValidate`/`activateTrade` (mark preserved)/`tradeDelta`.
- **Settlement mechanism**: boxed VM identity; VM zero-sum = ac conservation (same fact); resettable-forward property; `settlementFanout`; day-1 numbers (+1000/−1000).
- Intraday trade day 2 (numbers); **Principle: intraday-margin subtlety forces stored per-position ac (C11)** — the −100 vs naive −300 argument; the three settlement answers; **Remark: direction reversal no special case** (+5→−3 worked numbers).
- Close to flat: retained Some-flat row; C1(a)/(b) readings (tax, wash-sale, reconstruction).
- Expiry (+1200/−1200), Close (flatten, no stage write — the one event admissible on EXPIRED); **physical settlement variant** (DvP at final settlement price, double-count argument); **Theorem Closing identity** (cumulative VM = economic PnL: +2100/−1700/−400/0 both ways).
- After expiry: `first_touch_date` NOT stored — derived-vs-state rule stated generally.
- **Three named invariants**: Per-event conservation (C2); Deterministic replay as Kleisli fold (C1(b), P8 — incl. stream-uniqueness assumption: dup FSettleVM inert, dup FTrade not; dedup is boundary obligation); Monotone absorbing stage (G1–G5 chain REGISTERED→ACTIVE→EXPIRED, no skips; re-settle same price no-op).
- Full kernel listing: `FutEvent` (FTrade/FSettleVM/FExpire/FClose), `futEventUnit`, `futHandle` (all guards annotated G1–G5), `FutLedger` (fused terms+status map — desync unrepresentable), `FutLedgerError` (9 constructors), `futRegister/futApplyDelta/futStep/futReplay` + total accessors.
- **Escalations FE1** (fan-out cost at scale, owner named) and **FE2** (derived-consequence alternative declined, 3 reasons).
- **Key Invariants** recap (state-sufficiency, P10, value invariance, contracts-as-generators, P6, P9) — closes Part III valuation/lifecycle bundle.

## §10 Managed Accounts, Virtual Portfolios, TRS (sec11, `sec:managed`)
- Thesis: managed account = composition of four existing primitives; TRS = same composition, virtual realm.
- **Mandate is a unit**: issuance ±1 display; `issueMandate` listing; **Invariant singleton support** (`inv:singleton`) + the four primitives that pin it (conservation alone admits (−5,+5)); **Principle non-valued** (`prin:nonvalued`: P_t(u_MA) undefined, not zero — double-count argument).
- What-is-recorded-where table (terms/status/PositionState/benchmark in UnitStatus[u_bench]); ME1 store-vs-derive flag.
- Subscription: SUBSCRIPTION tag load-bearing; HWM before subscription = None never 0 (fee-on-capital argument); entry NAV.
- **Mandate guard definition**; guard determinism is price-relative (value-limit flip argument); fail-closed on missing price; passive-breach limitation; ME2.
- NAV formula (mandate excluded).
- **Fee logic**: Perf net of NetFlow (projection over tagged moves); fee-is-not-PnL-settlement; the three fee equations (mgmt, perf floored, HWM ratchet); crystallisation is double-entry; `crystallise` (Maybe at x=0), `FeeEvent`, `crystalliseFees` (reuses WHwm 'FeeCrystallise verbatim — one author by phantom type); Step-E evaluation numbers; **Theorem fee zero-sum** (`thm:fee-zerosum`) with proof; baseline B_k (post-settlement; clawback argument); rounding residual retained; ME5 (insolvent overdraft).
- **Theorem Segregation** (`thm:seg`): CONS ∧ LOC ∧ C4 (conservation alone insufficient); CASS 6/MiFID II 16(8) logical-segregation claim; legal segregation out of scope; ME4 (C4 asserted not typed).
- CSA margin: netting set = u_TRS only, never virtual constituents; ME2 (unattested observation).
- **TRS**: realm tag enforcing P7; Payment_k formula; TR_k partiality (typed failure); **Theorem TRS ≡ funded managed account** (`thm:trs-equiv`) + proof sketch + CDM two-legged caveat; price-consistency paragraph (the one silent-void spot; ME2).
- Redemption/wind-down 4-move listing; rows retained at zero.
- Substantiation: filter-only difference between statements; IAS 32.42/ASC 210-20 net-presentation caveat.
- **Worked example** (Steps A–F table; fee arithmetic 5,750/28,850/1,115,400; closing identity across all wallets summing to 0).
- **Conformance and flags**: CDM LegalAgreement stratum for mandate; two-legged TRS reporting; SFTR/EMIR non-reportability of u_MA (MiFID II Annex I A(4)); ME3; IFRS classification out; F6 TradeState alignment outstanding.

## §11 Balance Sheet Substantiation and Dual Valuation (sec12, `sec:substantiation`)
- Balance reconstruction formula; auditor-replay claim.
- Haskell: `Balances` newtype with **pointwise-union monoid** (explicit warning that Map's default left-biased union is wrong — "the whole correctness content of this type"), `contribution`, `balances = foldMap`, `netBal`.
- **Remark balance-as-fold**: one homomorphism law read three ways (order-stability, snapshot correctness, P1 as consequence).
- Substantiation scope: quantities/provenance by construction; IFRS 13 levels, IAS 1 §117–124, legal enforceability NOT substantiated.
- **Definition Dual Valuation** (MtMk/MtMd, Δ_t); **Nikkei 225 three-exchange example** (35,480/35,490/35,495 vs 35,500); FVA / CRR Art. 105 prudent-valuation; single-position-set claim.
- Snapshots: O(k) query; quiescence/MVCC condition; conservation + two valuation displays.

## §12 Implementation and Operations (sec13, `sec:implementation`)
- Three layers (move stream / aggregation GroupBy / projection-as-cache); corruption repaired by replay.
- 4-step balance-update algorithm (validate/aggregate/apply/snapshot).
- Constant-cost PnL (O(n) instruments).
- **Fault tolerance** — six named modes: late events (dual timestamps); duplicates (P5+P6, CDM qualification); contradictory external state (human resolution recorded as transaction); stale market data (gate-and-defer, never book-then-correct); move-stream integrity (hash chain + periodic verification; availability-risk concentration honesty); partial failures (WAL requirement).
- **Corrections as events** (`sec:implementation-corrections`): compensating transaction; `corrects` metadata field first-class; amendment ≠ cancellation (TermsChangeEvent); correction algebra flagged open. *Referenced by sec09 time-travel repair path.*
- Moves→settlement instructions: struct-to-struct claim.
- **ISO 20022 table** (sese.023 field ↔ CDM source, 6 rows); pacs.008/009; full traceability chain incl. return path (sese.025/camt.054).

## §13 The Settlement Layer Interface (sec14, `sec:settlement`)
- **Definition Settlement Projection** (`def:settle-projection`: pure/total/stateless/idempotent; Maybe); SettlementTx is a **boundary type**, not core Transaction (naming discipline restated).
- Three-item read-only input list; reads nothing else.
- Full Haskell: `Asset` (Security|CashCcy — naming note), `SettleMove`, `TxClass` 5-way + total `settles`, `CdmPayload`, `SettlementTx`, `SecuritiesLeg/CashLeg`, **`SettlementLegs` (type and legs one value — no-legs unrepresentable)**, `settlementType` projection, `SettlementInstruction` (plain data), `classify`, `legsOf` (Nothing on empty/multi-leg), `settleProjection`; behaviour table (DVP/FOP/CASH/Nothing×2).
- **Definition SettlementInstruction** (`def:settlement-instruction`).
- Multi-leg decomposition at source (repo = two DvPs).
- **Principle Boundary Separation** (`prin:settlement-boundary`): what vs how; projection-then-enrichment.
- Settlability table (5 classes; LIFECYCLE/CORRECTION "sometimes" by decomposition; physical exercise = SETTLEMENT + ACCOUNTING pair).
- Lifecycle-originated settlement (provenance is the only difference).
- **DvP two-level guarantee**; temporal gap (trade-date accounting); **settlement failure: economic position NOT reversed**; external regimes out.
- Remark: deferred-settlement satellite carve-out.
- **Gross-to-net reconciliation**: algebraic identity; `signedFor/reconciles` listing; fault localisation.
- **Confirmation return path**: EXECUTED→INSTRUCTED→SETTLED/FAILED status table; each transition a logged event; status is a projection (replay discipline restated).

## §14 ISDA CDM Integration (sec15, `sec:cdm`)
- CDM's five components; AAPL call chain (product→tradable→event→moves).
- Four derivation paragraphs (products as units; event model as state graph; embedded Rune logic as transition contracts; mapping layer as oracle interface).
- Synonym layer + ingestion pipeline; **CDM version coexistence** (per-event version id; migration; enum-addition consequence).
- **Forgetful map F**: full Haskell (`Intent/LifecycleState/TradeState`, `PrimitiveInstruction` 4-way, `BusinessEvent` with FORGOTTEN fields annotated, `CdmTransaction` boundary type distinct from core, `instructionMoves` monoid homomorphism, `forget`); move-less totality (`ctPayload (forget e) == e`).
- Worked AAPL exercise ($100×max(215−200,0) = 1,500; conservation; EXERCISED absorbing); UnitStatus-projection remark.
- **What F preserves** (composition restricted to referentially independent events — the caveat about cross-references/cascades and causal-order resolution; conservation; sequencing; idempotency) and **what F forgets** (intent, lineage, structure, regulatory classification — recoverable from payload).
- Principle: substance vs meaning separation forces forgetfulness.
- CDM enumerations as **closed finite generator universe** for PBT.

## §15 Orchestration and Obligation Liveness (sec16, `sec:temporal`)
- **Four execution-engine requirements** (at-least-once + idempotency = exactly-once; durable timers; deterministic replay; single-threaded per instance); Temporal.io named as reference adoption; engine guarantees enter proof as lemmas.
- Executor as retriable activity: retryable vs **non-retryable** error classes; idempotency key = transaction ID.
- Due-event scheduler (timers at registration; data-quality gate consumed not defined).
- Concurrency: single-writer per unit; parent workflows for cross-unit ops; per-unit not global serialisation (throughput claim).
- **Definition Obligation** (`def:obligation`: id/type/source/t_d/D/κ; D and κ total; κ Nothing forces Defaulted) + Haskell record.
- **Live/Terminal split**: `Live=Pending|Attempted`, `Terminal=Discharged|Compensated|Defaulted`, `ObState`, `Trigger`, total `step` (its DeadlineFired totality IS lemma L5); transition table (7 rows); restraint sentence ("anything further would remove neither a bug nor a line").
- **Taxonomy Table** `tab:obligation-types` (deterministic-date / event-triggered / regulatory; ~17 rows with triggers and compensations).
- **Definition Obligation store** (`def:obligation-store`) + projection discipline paragraph.
- Registration channels (unit registration from EconomicTerms; event processing atomically) + **Principle Obligation completeness** (`princ:obligation-completeness`).
- Workflow pattern (selector; deterministic workflow ID prevents double-spawn).
- **Invariants P21** (`inv:P21`/`inv:obligation-liveness`), **P22**, **P23**.
- **Theorem obligation liveness** (`thm:obligation-liveness`) with **lemmas L1–L5** and composition; guarantee-source summary table.
- Worked examples: **CSA VM call** (thresholds $500K/MTA $250K/$1.8M; discharge + close-out compensation; conservation display) and **SBL collateral substitution** (IBP-170 deadline; 4-move τ_subst; escalation path GMSLA §10).
- P21↔SBL relationship (underpins P13, P16, P18).
- Three PBT properties (registration completeness, discharge conservation, handler totality).
- **Four assumptions/limitations** (engine availability — eventual not instantaneous; executor availability; external cooperation; lifecycle-function correctness).

## §16 Generalised Positions and SBL (sec17, `sec:gpm`)
- **Where the scalar model breaks**: the three wrong encodings (transfer/don't/credit-both) with IFRS 9 §3.2.6 citation.
- **Principle Single-Coordinate Move** (`princ:single-coord`); scalar core as one-coordinate case.
- **Definition Position Vector** (`def:position-vector-gpm`): six coordinates each with physical-action test, modifier, sign constraints, SFTR Art. 15 for rehyp.
- **Definition Available Inventory** (`def:avail-projection`): avail = own − onloan + borr, never stored.
- Haskell: `Position` record, `zeroPos`, total `avail`, `Coord` 6-way, `applyMove` (exhaustive — two-coordinate move unrepresentable); **avail is a group homomorphism** (δ_c table); discharged-by-construction remark (**non-negativity NOT typed away** — value-level gate, honest); special-cases remark; **why own is a coordinate** (4 reasons).
- **Proposition GPM conservation** (`prop:gpm-conservation`): onloan cancellation; five-term sum.
- Valuation via own; **in-flight collateral** (IBP-177) + custodian-reconciliation identity.
- Graceful degeneration remark (non-lendables → scalar).
- Named wallets: Alice/Bob vectors; per-relationship virtual wallet; reclassification vs transfer distinction.
- **Definition Projections** (`def:projections`: avail/possess/encumb); sell gate; AvailableToLend.
- **Principle SBL Representability** (`princ:sbl-representable`: 3 additions, nothing changed) + **why native not companion** (TOCTOU double-lend + 4 further failures).
- `SBLUnitState` field listing; loan-state-is-projection remark.
- **SBL state machine table** (total; terminals RETURNED/CANCELLED/DEFAULTED; S_live; 14 transitions with moves-generated column).
- **Atomic moves per lifecycle event**: LV formula (IBP-163, ceiling to 0.01); τ_new (4 moves; cash-collateral own-vs-coll_post variant; P18 noted), τ_return (LV_new/C_release formulas), τ_sell short sale (borr untouched), τ_margin; other events (substitution IBP-170, manufactured dividend, buy-in GMSLA 9.3).
- **Title transfer vs security interest table** (TT/SI/US_15C3_3; rehyp treatment); regime affects only PnL projection; **pledge remark**: V^SI includes coll_post — own stays regime-independent, adjustment in valuation (dirty-price analogy).
- **Collateral/margin table** (6 methods with IBP refs 189/322/323/326).
- Short selling: worked vectors; negative own only; `available_to_lend` pseudo-code gate; Reg SHO 204 / CSDR.
- **Cash collateral reinvestment**: obligation vs reinvestment asset; break-the-buck risk (Reserve Primary 2008, Rule 2a-7); unwind; CDM mapping.
- **On-lending chains**: A/B/C table; **P18 scope refinement** (pure lenders only; intermediary identity onloan ≤ borr); **cascade recall as saga** with buy-in compensation (IBP-328); CDM gap for coordinated cascade.
- **Locates**: not a move; EU SSR 12(1)(c)/ESMA 70-448-10 + Reg SHO 203(b)(1); lifecycle; **TTL-unit modelling** (native record-keeping); `confirm_locate` over-location gate; P14 enforcement; CDM gap.
- **Cross-border**: dual SFTR+SLATE fields/deadlines (T+1 vs same-day 8pm ET); governing-agreement→legal_regime table; **venue-not-domicile** rule.
- External reconciliation table (4 participants); contract compare IBP-153/155; instruction branching by collateral type.
- **CDM alignment table** (SBL event ↔ CDM type ↔ SFTR action; gaps: Recall, Locate, Rehypothecation, + tokenised-collateral eligibility = 4th gap).
- **Invariant P11–P20** (`inv:P11`/`inv:P20`) full statements incl. P12 formula and P18 by-construction argument.
- **Key Invariants** recap (P1 generalisation, P20, P11–P19, P21–P23) — closes Part V.

## §17 Invariants Hub (sec18, `sec:invariants`)
- Role statement: canonical numbering P1–P25; spec = oracle duality.
- Conservation as universal oracle (constant-time check; "bug, never a financial event").
- **P1–P10 full prose** (with `inv:P2`…`inv:P9` labels; P4's tamper-evidence-vs-prevention honesty; P6/P8 basis extensions referencing sec09) + two unnumbered global oracles (totality; valid-transitions-only).
- **P11–P20 index** (labels `inv:P12`…`inv:P19`, `inv:P20-hub`); **P21–P23 index**; **P24/P25** (`inv:P24`/`inv:P25`) definitions.
- **C1–C13 index table** (defining-site attribution note: C7/C10 → sec04, C13 → sec09) + C13's three underlying claims itemised.
- **Discharge map** (guarantee × condition × mechanism, 10 rows incl. basis rows); precision vocabulary paragraph (abstract type / non-empty list / GADT tag / value-level check distinguished).
- **Five "types as theorems" anchors** (verbatim reference excerpts): (1) Move/unitDelta/netDelta; (2) NonEmpty ProductTerms; (3) Option accessor; (4) Kleisli replay; (5) FieldWrite GADT — each with its law comment.
- Invariants-as-spec-and-oracle (bond-coupon dual-role example).
- **PBT over CDM universe**: closed-enum coverage-as-checklist; `EventIntentEnum` mapping table (OPEN/EXERCISE/EXPIRE/ASSIGN/NOVATION covered; PARTIAL_TERMINATION n/a); new-enum-value surfacing claim; OptionTypeEnum.
- Specification-first development (falsifiability claim).

## §18 Regulatory Obligations (sec19, `sec:regulatory`)
- Regime field counts (EMIR Refit 203, MiFIR RTS 22 65, SFTR 155, CFTC 43/45); dual-sided burden.
- DRR production status with pinned footnote (ISDA Jan 2026; >98 % ack; "pinned…not restated as current").
- Framework alignment derived from primitives; **two bounding claims** (reference-data enrichment outside; substrate not organisational compliance).
- Conformance checkpoints: BCBS 239 P6/P11; DORA Art. 8/Ch. IV (with organisational carve-out).
- Mandate-issuance reporting: `reportable` predicate mechanism; F5 flagged pending sign-off.

## §19 Scope and Limitations (sec20, `sec:scope-limitations`)
- "Establishes no new result; bounds the claims."
- **The nine does-not items** (prices; legal ownership; settlement finality/SFD; accounting policy; external risks; model governance CRR 368/SR 11-7; boundary reconciliation; regulatory submission; reproducibility requires version-pinning).
- Theorems-as-modelling-choices honesty paragraph.
- Architecture vs operational reality (controls remain: four-eyes, exceptions, BCP).

## §20 FAQ (sec21, `sec:faq`)
Seven Q&As, each with a distinct establishment:
- **Q1** move-less events valid and mandatory (barrier knock-out with zero holders; IFRS 9 liability-drop rationale; executor must not reject) + UnitStatus remark.
- **Q2** DvP = atomicity ∧ contract-correctness conjunction (conservation alone insufficient — single-leg witness).
- **Q3** lot-size boundary cases (N<L, exact multiple, L=1).
- **Q4** SBL native (TOCTOU summary).
- **Q5** own stored vs avail projected.
- **Q6** scalar cash sufficiency (degeneration; only own + coll_recv engaged; 140 % cap constrains securities not cash).
- **Q7** market-data contract summary (five usual question-forms mapped to O1–O5, table, direction, modes).

## §21 Conclusion and Open Problems (sec22, `sec:conclusion`)
- Summary (five concepts, one invariant).
- **Three resolved problems** (concurrency, liveness, state attachment) — stated to close them.
- **Fourteen open problems** (netting/close-out; correction algebra; federation; XVA; bitemporal; tax lots incl. futures-ac interaction; impairment/ECL; GDPR/crypto-shredding trade-off; access control; repos; default management; pre-trade validation; migration; tokenised securities 5 sub-items).
- **Flagged register**: F1–F8 adoption risks with mitigations; testing commitments (mutation scores, TLC bound); ME1–ME5; FE1–FE2; closing scope sentence.

## Appendices
- **A (sec23, `app:cdm-mapping`)**: 10-row CDM-type→ledger-concept table; TradeState-is-projection note.
- **B (sec24, `app:properties`)**: P1–P10 precondition/postcondition table; **P8 remark** (usBasis covered; retro-effective generators required); totality + valid-transitions oracles; PnL-inputs note; SBL/obligation/basis extension paragraph; **typed oracle infrastructure** (`Outcome` — no crashed case, `Property i o`, `TxInput/Scope`, `registered/unitTotal/sameLedger`); executable `p1/p2/p3/p7/idempotentTx`; bespoke `chainOK/p8/LifecycleFn/idempotentL/validTransitionsOnly/p10`; **`effTip` + `p24`** (cache-independence note; in-module minting note); **P24 remark** (no-regression is corollary); restraint rule ("stop at the cheaper guarantee").
- **C (sec25, `app:reconciliation`)**: 9-row failure-mode taxonomy (3 structurally unreachable / 6 easier-to-detect / SBL by design); operational-failure carve-out.
- **D (sec26, `app:pricing-coordination`)**: coupon two-facts/two-corruptions; **state-aware pricer** `Distribution = Cum | Ex Cash` (Ex carries amount — totality fuse), `Market{mQuote, mQuoteEx}`, `priceOf` three-equation listing + ghci evaluations (102/100/100); ex-dividend lag; **scope paragraph**: this is the one-step f=1 fibre of sec09 (Cum/Ex = basis points, Shift d, mQuoteEx = degenerate stamp; quote-leading case outside — W3); `fibreOK` witness (unnumbered like `total`); discharged-by-construction remark.
- **E (sec27, `app:glossary`)**: ~45 defined terms (incl. basis-layer entries: Basis id, Basis projection, Basis stamp, Market-data contract, Source basis convention, Tip weld, Invariance weld, PosQty, Monotone carrier) + the full **C1–C13 restatement** with sites.
- **F (sec28, `app:cdm-walkthrough`)**: CDM v6.0.0 pin ("throughout"); six-layer table; **Principle Trade = Unit** + forgetful map U + dual-CSA test + listed/cleared novation + **CCP-margin CDM gap**; structured note **Results 1–3** (decomposition ≠ CDM model; TransferableProduct narrower than "transferable" + SPPI parallel; one unit three settlement paradigms, no CSDSettlement type); **tokenised**: two units, double-counting table, **Principle custodian-is-flat**, shortfall-as-conservation-violation claim, synthetic/native variants, **four CDM gaps** (identifiers, backing model, DigitalAsset, on-chain settlement) + on-chain DvP note; **date handling**: 11-type taxonomy table, MODFOLLOWING, ACT/360 + 30/360 formulas, 3-step resolution chain, SOFR-swap worked dates (δ = 182/360, 91/360), **six gotchas** (incl. the $11,111 day-count example).
- **G (sec29, `app:avail-identity`)**: eight scenarios A–H verifying P20 (outright, lend, borrow-and-sell partial/full, non-lendable, lend-then-borrower-sells, on-lending chain, pledge); two remarks (on-lending defeats naive own = avail+onl; pledge PnL via c_p).
- **H (sec30, `app:eu-sbl-example`)**: GMSLA 2010 title-transfer witness — participants (CalPERS/Goldman/Hedge Fund/Market/Counterparty C); terms (25 bps ACT/360, Bund 102 %); Steps 1–7 (initiation with Q_Bund = 302,894 rounding note; **title-transfer defining move: poster's own decreases, not coll_post**; locate SSR 12(1)(a); short-sale pass-through; rehyp with SFTR Art. 15 flag; MTM; manufactured dividend; partial recall; full return) — per-step vector tables, conservation checks, P18 checks, SFTR action codes (NEWT/…); rounding-boundary remark.
- **I (sec31, `app:us-sbl-example`)**: Rule 15c3-3 pledge/cash-collateral witness — Fidelity/Morgan Stanley/State Street; $875 NVDA, LV $875M, RCV $892.5M; rebate mechanics (5.25/5.00 %, daily spread $6,145.83, day-30 rebate $3,718,750); **reinvestment τ with obligation-vs-MMF-overlay convention note**; 140 % rehyp cap contrast; daily MTM; SLATE field list; partial recall; close-out; **cross-jurisdictional comparison** (`sec:sbl-comparison`).

---

## High-risk items for a rewrite pass (most likely to be silently dropped or merged away)

1. **Definitions living outside their "natural" section**: C7 and C10 are defined in sec04 (not the sec05 register); C13 in sec09; P24/P25 prose in sec18 but executables in sec09/sec24. A pass that "consolidates" the conditions register will orphan cross-refs `cond:C7`, `cond:C10`, `cond:C13`.
2. **The illustrative-vs-reference code duality**: sec03, sec07, sec11, sec12 each carry an explicit "illustrative Qty form; the reference Move carries PosQty" disclaimer. These disclaimers are the verbatim-claim discipline (sec05 remark: "tokens exact"); deleting any one breaks the code-level-claim chain.
3. **The boundary-type naming discipline**: three separate declarations that a kernel is a projection, not a second core — sec10 (Fut*), sec14 (SettlementTx), sec15 (CdmTransaction). Each is stated per-boundary; merging into one general statement loses the per-site anchor each section's reader needs.
4. **The recap boxes** ("Key Invariants and Consequences") at ends of sec04, sec05, sec09, sec10, sec17 — they are the part-level closure devices; a de-duplication pass could delete them as "redundant with sec18," losing the part structure.
5. **Honesty/limitation clauses embedded mid-claim**: P4 tamper-evidence-vs-prevention; C4 asserted-not-typed (sec05 + ME4); GPM non-negativity not typed away (sec17 remark); sec09 "execution pending the toolchain, not reported as passed"; sec09 language-fragment proviso (nominal roles normative); sec16 four proof assumptions; sec19 pinned-figures footnote. These qualify theorems — dropping any strengthens a claim beyond what is proved.
6. **Numeric worked witnesses** whose exact figures are the argument: futures life table (−100 vs −300 anchor; closing identity +2100/−1700/−400); managed-account Step E (5,750/28,850/1,115,400; closing sum 0); split walk (50 vs 49; €100,000 both sides; 70.8 divisor phantom); PnL attribution (100+57=157); EU/US SBL step tables; day-count $11,111.
7. **The F1–F8/F1–F10 naming collision** (sec22 risks vs sec09 faults) and **the two `\label{inv:P20}` targets** (sec17 `inv:P20`, sec18 `inv:P20-hub`) — any relabelling pass must preserve both resolution targets.
8. **Single-anchor discipline sentences**: "stated once" sites — the boundary lists (sec02 `sec:scope-overview`), the UnitStatus discipline (`sec:states-unitstatus`), the O1–O8 set, the W-regime table, the C register. Roughly 15 downstream sections reference each; the anchors and the "stated here, once" phrasing must both survive.
9. **The three-part `applyTx` elision contract**: sec05 elides the weld bodies and `BoundaryEvent`/`Declaration` declarations "specified in sec09 and carried in the reference." If either side of this hand-off is rewritten, the two elision markers and the sec09 specifications must stay paired.
10. **Environment counters**: theorem-like environments share one counter (`definition`); sec04 additionally declares a starred `condition` environment locally. Rewrites that move the C7/C10 conditions must move the `\newtheorem*` declaration too.