# Coverage Inventory — Ledger v10.3 → v11.0 (MINSKY lens)

Scope: recent-thread fold-in only. Fold in the resolved three-home state model
(StatesHome), the corrected UnitStatus characterisation, the futures lifecycle, and the
managed-account workflow. Satellite specs (valuation, market-data, deferred-settlement,
data) stay as v10.3's compressed treatment with a pointer; not consolidated here.

Governing rule: DROP THE PATH, KEEP THE SUBSTANCE. Every result, invariant, instrument,
law, and appendix of v10.3 still valid MUST appear in v11.0 (kept, compressed, or
superseded). My lens: make illegal states unrepresentable, types over runtime checks. I
flag any removal that would re-admit an illegal state.

---

## A. The authoritative correction (binds the whole document)

UnitStatus is a MATERIALISED PROJECTION of the immutable event log — a read cache the log
always rebuilds — NOT an authoritative mutable store. Canonical wording lives in
`/home/renaud/Ledger/unitstatus_amendment/CHANGELOG.md` (FULL prose, COMPRESSED cell form,
and the materialisation-soundness principle). The amendment supersedes:

- v10.3 line 1034 ("Unit state is per-unit for most instrument types… per (wallet, unit)
  pair") — replaced by the three-home schema (addendum §11, lines 615–642).
- v10.3 line 2287 (`get_unit_state(w,u)`) — maps to `position(w,u)`.
- Every "mutable [shared] UnitStatus" label across the corpus — replaced by the canonical
  wording, which carries the foreclosing clause "every change caused by a logged event".

The correction is already applied in the four folded-in `.tex` files and in
`reference/StatesHome.hs` (single writer `applyStatus`; sealed `Ledger`; no exported
`setStatus`; UnitStatus deliberately NOT versioned — the log holds history). Any v10.3
phrasing implying an off-log UnitStatus writer is SUPERSEDED on sight.

This is a correctness fact, not cosmetics: if UnitStatus were an authoritative mutable
store, the cache could drift from the log and internal-reconciliation failure — the one
thing the system exists to forbid — would be representable again. The correction restores
"every view is a projection of the stream" as a load-bearing invariant.

---

## B. Section-by-section disposition (v10.3, 27 sections, 7314 lines)

### §1 Introduction (54–110) — COMPRESS, KEEP substance
The six by-construction properties (atomicity, conservation, determinism,
state-sufficiency, lifecycle value invariance + optionality qualification, time travel) are
SUBSTANCE — they are the contract of the whole system. The ledger-boundary paragraph and
CDM-role paragraph are substance. The verbose roadmap paragraph (107) is PATH — cut to a
one-line pointer list. The abstract's SBL summary duplicates §15 — compress to a sentence.

### §2 The Closed Ledger System (111–299) — KEEP, light compress
Wallet, ownership-as-balance, atomic move, transaction, Conservation Law, System Closure
theorem, virtual wallets, initialisation/opening balances, books/reference wallets,
Self-Consistency Principle, Herstatt note. All SUBSTANCE. This is the natural HASKELL ANCHOR
(`Qty` group, `Move`, conservation as a monoid sum). The TikZ wallet-flow figure is
keepable but optional. Trim the three restatements of "src -= q; dst += q".

### §3 The Unit Store (300–493) — KEEP, light compress
Unit identity (OTC vs listed fungibility), three-tier architecture (reference / product /
unit registry), `UnitEntry` schema, registration channels, two-stage correctness
enforcement, four guarantees, CDM alignment, CDM gaps. SUBSTANCE. NOTE: the `UnitEntry`
field `unit_state : ProductSpecificState` and `lifecycle_stage` are SUPERSEDED in their
storage model by the three-home schema (§4 v11) — keep the registry concept, retarget the
state fields to ProductTerms/UnitStatus. C5/C7 registration-totality lands here.

### §4 Portfolio Valuation and PnL (494–603) — KEEP, compress; pointer to valuation spec
Portfolio value, quantity-vs-value conservation, State-Sufficiency principle,
Path-Independent PnL theorem (+ proof), PnL decomposition (price/flow) with the numerical
example. SUBSTANCE. The worked decomposition table can shrink. Add pointer to the standalone
valuation satellite spec (out of scope to consolidate).

### §5 Smart Contracts as Move Generators (604–805) — KEEP, compress
Contract definition (deterministic fixed-precision arithmetic, bankers' rounding), modular
vs composite recommendation, equity contracts (trade/dividend/bond-accrued/corporate
action), European put full move schedule (cash + physical + lot-size), IRS full move
schedule + CDM worked lifecycle. SUBSTANCE (these are the instrument move-schedules). The
prose around modularity (627–639) can tighten. Lot-size logic is load-bearing (referenced
by FAQ Q7 and settlement) — keep.

### §6 Managed Accounts, Virtual Portfolios, and TRS (806–977) — SUPERSEDED/MERGED by workflow doc
Wallets-as-managed-accounts, reference-wallet performance, managed-account smart contract
(Observe/Crystallise/Reset), segregation-as-algebra, CSA margin, mandate guards, virtual
ledgers, TRS structure, periodic reset, account-level substantiation, applications. The
folded-in `managed_account_workflow.tex` is the corrected, derived treatment and SUPERSEDES
the §6 prose where they overlap. CRITICAL CORRECTION carried by the workflow doc:
"conservation enforces segregation by algebra" (§6 line 855) is WRONG as stated — segregation
is a theorem only under CONS ∧ LOC ∧ C4 (capability scoping). v11 must adopt the workflow
doc's corrected Segregation theorem, not §6's phrasing. Keep §6's "every wallet is a managed
account" framing and the virtual-ledger/TRS isolation (P7).

### §7 Lifecycle Management (978–1482) — KEEP core, SUPERSEDE state-home + futures example
- KEEP: lifecycle-as-transaction (uniformity/conservation/auditability/composability),
  lifecycle event as pure function `f:(unit,state,market)→(moves,new_state)`, idempotence,
  time-travel challenges (futures margin, splits, exercise/novation, basket), cloning,
  Purity principle, the Executor (sole mutator), composition of pure functions, embedded
  defence, lifecycle risk-profile table. SUBSTANCE.
- SUPERSEDED: §7.3 "Unit State as Explicit Object" line 1034 (per-unit / per-(w,u)) by the
  three-home model. The per-wallet vs per-contract futures state split (1141–1169) is
  SUPERSEDED by the three-home homing in the futures section.
- SUPERSEDED: the futures canonical example (1111–1352, accumulated-cost method, ALPHA/CH
  walkthrough, EOD settle, direction reversals, CDM alignment, properties) by the dedicated
  futures-lifecycle section (folded-in `FutureLifeCycle.tex`), which is the corrected,
  Haskell-backed treatment. Do NOT drop the substance — the new section carries it (and more:
  the intraday-trade VM subtlety, the close-out, physical vs cash settlement). Keep the
  QIS/leveraged-ETF lifecycle subsection (1353–1369) — it grounds C12/QIS in §4 v11.

### §8 Balance Sheet Substantiation and Dual Valuation (1483–1600) — KEEP, compress
Immutable move stream as source of truth (balance reconstruction formula), substantiation
as design goal (quantities substantiated; disclosures/valuations/legal need external
evidence), reconciliation failure taxonomy (3 unreachable + 6 detectable), Dual Valuation
(MtMk/MtMd, differential, multi-exchange futures example), FVA, internal trade flexibility,
snapshots. SUBSTANCE. The taxonomy here duplicates appendix §21 — state once, cross-ref.

### §9 Implementation and Operations (1601–1684) — KEEP, compress
Three-layer architecture (move stream / aggregation / wallet state), balance update
algorithm, PnL efficiency O(n), fault tolerance (late events, duplicates, contradictory
external state, stale market data, stream integrity, partial failures, corrections as
events), ledger→settlement projection intro, ISO 20022 interface + sese.023 mapping table.
SUBSTANCE but prose-heavy — compress fault-tolerance bullets, keep corrections-as-events
(event sourcing) and the dual-timestamp (economic vs booking) rule.

### §10 The Settlement Layer Interface (1685–1888) — KEEP, compress; pointer to deferred-settlement spec
Settlement projection (pure/stateless/idempotent/total for SETTLEMENT), SettlementInstruction
struct, transaction settlability types, lifecycle-originated settlement, DvP atomicity (ledger
vs settlement level, temporal gap, settlement failure), netting (gross→net algebraic
identity), confirmation return path (EXECUTED→INSTRUCTED→SETTLED/FAILED). SUBSTANCE. The
pseudocode `settle_projection` can be replaced by a typed Haskell signature (weave point).
Pointer to deferred-settlement satellite spec.

### §11 ISDA CDM Integration (1889–2017) — KEEP, compress
What CDM is (5 components), AAPL-call running example, why-CDM-natural (products as units,
event model as state graph, embedded logic as transition contracts, mapping layer as oracle),
synonym layer, the forgetful mapping F (preserves: composition-restricted, conservation,
sequencing, idempotency; forgets: intent, lineage, structure, regulatory class), CDM enums as
generator universe. SUBSTANCE. Merge with appendix §19 mapping table. The AAPL walkthrough can
share an example with §24.

### §12 Invariants, Conservation Laws, and PBT (2018–2168) — KEEP (anchor), compress wrapper prose
The TEN CORE INVARIANTS (P1 conservation, P2 atomic commitment, P3 referential integrity,
P4 log monotonicity, P5 transaction idempotency, P6 lifecycle idempotency, P7 virtual/real
isolation, P8 snapshot consistency, P9 lifecycle purity, P10 PnL path-independence) are the
acceptance criteria — SUBSTANCE, KEEP VERBATIM. The ten core PBT properties, CDM-enum
generator universe, EventIntentEnum/OptionTypeEnum completeness, specification-first
development. NOTE numbering hazard: the addendum re-labels invariants P1/P3/P5/P6/P7/P9/P10
to its own list and shows 7 of 10 made "unrepresentable" — v11 must reconcile ONE invariant
numbering. The addendum's "invariants made unrepresentable" mapping (which condition C1–C12
discharges which P) is SUBSTANCE and lands here.

### §13 Regulatory Obligations and Direction of Travel (2169–2188) — KEEP, compress
DRR production status, CDM as industry standard (LSEG TradeAgent), convergence trajectory,
framework alignment (BCBS 239, DORA). SUBSTANCE but light — compress the citation prose.

### §14 Orchestration: Temporal.io (2189–3421) — SPLIT: extract substance, drop the tutorial
LARGE (1233 lines), mostly PATH/implementation tutorial. Disposition:
- EXTRACT AS SUBSTANCE (own v11 section, "Obligation Liveness"): the Obligation type
  (3026–3071), obligation taxonomy (3072–3113), obligation store/registration (3114–3145),
  obligation workflow (3146–3189), LIVENESS INVARIANTS P21–P23 (3190–3213), proof of liveness
  (3214–3266), liveness–safety composition revised (3267–3289), worked examples (CSA VM call
  3290–3330; SBL collateral substitution 3331–3384), PBT for obligations, assumptions/limits.
  These resolve the framework's liveness gap and are cross-referenced from §12 and §17 — MUST
  survive.
- KEEP COMPRESSED: single-writer-by-construction concurrency model (resolves the concurrency
  open problem), due-event scheduler (deterministic-date liveness), the idempotency chain (3
  layers), deterministic-replay alignment. These are load-bearing safety/liveness claims.
- DROP AS PATH: "Why Temporal", executor-as-activity retry config, two-audit-trails, the
  per-instrument orchestration workflow listings (futures/bond/option/IRS/CSA/SBL saga code),
  settlement orchestration saga code, task-queue/worker architecture, retry/timeout policy
  tables, corporate-action fan-out code, versioning/CDM-coexistence, history/ContinueAsNew,
  CDM activity mapping table (Temporal-specific), implementation-team profiles. These are
  vendor-specific implementation detail, not specification substance. Replace with a short
  "execution engine requirements" statement (durable timers, single-writer, exactly-once via
  idempotency) that any orchestrator must meet.

### §15 Generalised Positions and SBL (3422–4238) — KEEP, compress
Six-coordinate position vector (own/onloan/borr/coll_post/coll_recv/coll_rehyp),
physical-action test, Single-Coordinate Move Principle, available-inventory projection
`avail = own − onloan + borr`, graceful degeneration to scalar, named-wallet lending
resolution, encumbrance projections, SBL smart contract + representability, SBL state machine,
atomic moves per lifecycle event, title-transfer vs security-interest, collateral/margin,
short selling, external reconciliation, CDM/regulatory alignment, cash collateral
reinvestment, on-lending chains + cascade recall, locates + over-location prevention,
cross-border (SFTR/SLATE), full 20-day worked example, INVARIANTS P11–P20. All SUBSTANCE —
this is core base, not a satellite. The Temporal-workflow subsection (3903–3917) is PATH —
drop. Compress prose; keep the position-vector definition, SCMP, projections, P11–P20 verbatim
(P20 available-inventory identity is a definition-not-check — illegal state unrepresentable).
HASKELL weave: position vector as a 6-field record; `avail` as a total projection function.

### §16 Scope and Limitations (4239–4304) — KEEP, light compress
Ledger boundary (inside/outside lists), 9 explicit "does not do" limitations,
theorems-vs-modelling-choices, architecture-vs-operational-reality. SUBSTANCE — this guards
against over-claiming and is referenced by §1. Keep.

### §17 Conclusion (4305–4387) — KEEP, compress; prune resolved open problems
Summary, four design goals, self-consistency standard, benefits (operational/computational/
design), key advantages, OPEN PROBLEMS list. SUBSTANCE but: concurrency and liveness are now
RESOLVED (mark so), and the state-attachment question (unit vs wallet) is RESOLVED by the
three-home model — remove it from open problems. Remaining open problems (netting/close-out,
correction algebra, multi-entity federation, XVA, bitemporal, tax lots, impairment/ECL, GDPR,
access control, repos, default management, pre-trade validation, migration, tokenized) stay.

### §18 FAQ (4388–4516) — KEEP, compress
Q1 knock-out (state-only transaction), Q2 FIX→settlement chain, Q3 DvP atomicity, Q4 who
generates instruction, Q5 settlement failures, Q6 move-less lifecycle events, Q7 lot-size
delivery, Q8 why SBL in-ledger, Q9 why own stored / avail projection, Q10 scalar cash
sufficiency for collateral. SUBSTANCE (each answers a real correctness question). Q6/Q9/Q10
are load-bearing on the never-held/held-flat and projection-not-stored disciplines — keep.
Compress the validation footnotes.

### Appendix §19 CDM Type Mapping Tables (4520–4547) — KEEP, merge into §12 v11
F mapping table (Product→Unit, TradeState→unit state, BusinessEvent→Transaction, etc.).
SUBSTANCE. Merge with §11.

### Appendix §20 Property Test Catalogue (4548–4582) — KEEP
The ten core properties as executable pre/postcondition specs. SUBSTANCE — these are the
test oracle. Keep as appendix.

### Appendix §21 Reconciliation Failure Mode Taxonomy (4583–4620) — KEEP
9-row taxonomy (3 structurally unreachable, 6 detectable, SBL addressed-by-design).
SUBSTANCE. State once (dedupe with §8).

### Appendix §22 Coordination: Pricing / Contract State / Market Data (4621–4686) — KEEP; pointer to market-data spec
Core problem (coupon double-count / vanish), atomic lifecycle events solution, equity
ex-dividend state-aware pricing, conclusion. SUBSTANCE — it proves valuation/cash coherence
by construction. Pointer to market-data satellite spec.

### Appendix §23 Glossary (4687–4739) — KEEP, update
Keep; add the three-home terms (ProductTerms, UnitStatus-as-projection, PositionState,
StateDelta, ValidDelta, conserved field, monotone carrier, Option accessor never-held vs
held-flat), futures terms (variation margin, accumulated cost), obligation terms.

### Appendix §24 CDM Product Model — Developer's Guide (4740–6231) — COMPRESS HARD, keep skeleton
LARGE (1491 lines), developer tutorial. The six-layer hierarchy (Observable → Payout →
EconomicTerms → NonTransferableProduct → TradableProduct → Trade) and "where unit identity
crystallises" is SUBSTANCE (referenced by §1, §3 unit identity). The three sub-walkthroughs —
structured note with embedded derivative (4992–5361), tokenized securities/NVDA (5362–5737),
date handling taxonomy + worked examples (5738–6231) — are largely PATH/illustration: keep the
RESULTS (Payout composition + TransferableProduct boundary; double-counting resolution +
custodian-is-flat principle + 4 CDM gaps; the date-type taxonomy + resolution chain), drop the
exhaustive code listings and parallel-instrument tables. This is the single largest page-saving
opportunity after §14.

### Appendix §25 Available Inventory Identity: Eight-Scenario Verification (6232–6352) — KEEP, compress
Scenarios A–H verifying `avail = own − onloan + borr` (outright, lend, borrow+sell,
non-lendable, sell-all-borrowed, lend+borrower-sells, rehyp chain, pledge). SUBSTANCE — it is
the property-test evidence for P20. Compress to a single table.

### Appendix §26 European SBL Worked Example, GMSLA 2010 (6353–6860) — KEEP, compress
7-step title-transfer lifecycle with rehypothecation, MtM, manufactured dividend, partial
recall, full return; six-coordinate vectors + conservation at each step. SUBSTANCE — it is the
correctness witness for title-transfer SBL. Compress prose; keep the step vectors.

### Appendix §27 US SBL Worked Example, SEC 15c3-3 (6861–7314) — KEEP, compress
7-step pledge/cash-collateral lifecycle: rebate mechanics, cash reinvestment, rehyp caps
(140%), daily MtM, FINRA SLATE reporting, partial recall, close-out, cross-jurisdictional
comparison. SUBSTANCE — it is the pledge-regime counterpart and the SLATE/15c3-3 witness; both
§26 and §27 are needed (title transfer vs pledge are economically distinct). Compress prose,
keep the step vectors and the comparison table.

---

## C. Folded-in recent work (becomes new/expanded v11 sections)

### States.tex + addendum_stateshome_v2.tex → "The Three-Home State Model" (new §4 v11)
The resolved answer to §7's open state-attachment question. Three homes in two maps:
ProductTerms (immutable, versioned NonEmpty, append-only, registration-total), UnitStatus
(shared, registration-total, PROJECTION of the log — corrected), PositionState ((w,u)-keyed,
monotone carrier, Option accessor never-held ≠ held-flat). The 2×2 derivation (per-unit vs
per-(holder,unit) × ledger-authored vs externally-authored; fourth cell empty). The twelve
conditions C1–C12. Why-exactly-three. W-sector collapse (C12), mandate-as-unit. Invariants
made unrepresentable (which C discharges which P). Pareto table of 6 rejected designs (KEEP
the one forcing-reason per rejected design; DROP the ordinal score table as path). Risk
register F1–F8 (KEEP — migration/governance). Testing commitments (mutation scores).
HASKELL ANCHOR: full StatesHome.hs (Qty group, ProductTerms NonEmpty, UnitStatus + StatusWrite
single-writer applyStatus, PositionState fields + C11 FieldWrite GADT, sealed Ledger,
register/settle/applyMove/applyDelta, ValidDelta/validate, position accessor, Event/apply/
replay foldM, amend two-track C8). This is where the UnitStatus correction is stated once and
reused.

### FutureLifeCycle.tex + FutureLifeCycle.hs → "The Futures Lifecycle" (new §8 v11)
Supersedes §7's accumulated-cost futures example. One cash-settled future, mult 50, wallets
A/B/C, full life: Listing → trades → daily VM settlement (the centrepiece fan-out identity
VM(w)=net·S·mult+ac) → intraday-trade subtlety (why ac must be stored per-position, C11) →
close-to-flat (never-held vs held-flat) → expiry/final settle → Close (physical vs cash
variant) → closing identity (cumulative VM = economic PnL). Conservation shown per event
(ΔnetQty, Δac, VM each sum to 0). Invariants C1(b)/C2/C9/C11, monotone/absorbing stage
transitions (REGISTERED<ACTIVE<EXPIRED). Escalations E1 (fan-out cost at scale), E2 (derived-
consequence alternative declined). HASKELL ANCHOR: FutureLifeCycle.hs (Qty/Cash/Price distinct
types — Price has no Monoid; markValue; Stage with embedded Settlement making illegal states
unspellable; StateDelta; validate/ValidDelta; settlementFanout; closeDelta; handle/step/replay).

### managed_account_workflow.tex → expands "Managed Accounts, …, TRS" (§9 v11, supersedes §6)
Managed account = composition of four primitives (wallet partition; mandate unit u_MA issued
manager→client conserving; deterministic reset contract; three-map model). Establishment
(mandate as unit, what-recorded-where table, mandate-non-valued principle), subscription
(tagged flows, HWM=None not 0), trading under mandate (price-relative guard determinism, fail-
closed), NAV, fee logic (mgmt + perf with HWM ratchet; performance net of capital flows;
crystallisation is double-entry; fee ≠ PnL settlement), SEGREGATION theorem (CONS ∧ LOC ∧ C4 —
corrects §6), CSA margin, TRS-as-synthetic-managed-account + equivalence theorem (P7
isolation), redemption/wind-down, account-level substantiation, conformance/flags, ESCALATIONS
E1–E5 (store-vs-derive scalars; unattested observation surface / Nazarov; counterparty legal
identity / LEI; C4 asserted-not-typed; no in-ledger solvency liveness). Worked example
(subscribe → trade → NAV → fee crystallisation → wind-down, closes to the penny). Escalations
are SUBSTANCE (the agenda for the next version) — keep, but as flagged-open, distinct from the
sound quantity algebra.

---

## D. Haskell weave plan (thread throughout)

- §2 Closed Ledger: `Qty` newtype, Semigroup/Monoid/group (`negQty`), `Move`, conservation as
  `foldMap` to `mempty`.
- §4 Three-Home State Model: full StatesHome.hs (the anchor).
- §8 Futures Lifecycle: full FutureLifeCycle.hs (Cash/Price/Stage/StateDelta/validate/
  settlementFanout/replay).
- §5 Smart contracts: contract type signature `(Input,State,Conditions)→[Move]`.
- §6 Valuation: `value :: PriceVec → Ledger → Cash` total signature.
- §10 Settlement: `settleProjection :: Transaction → Maybe SettlementInstruction` typed (replaces
  pseudocode).
- §12 Invariants: types-as-theorems framing; `ValidDelta`/`validate` as the value-level
  conservation gate; abstract types for the unrepresentable ones.
- §14 Obligation Liveness: `Obligation` type + discharge predicate as a total function.
- §15 SBL: 6-field position record; `avail` total projection.
Light type signatures elsewhere; never code for code's sake (clarity over boilerplate).

---

## E. Risks to completeness under the page budget

1. §14 is the temptation: dropping the Temporal tutorial is right, but the obligation-liveness
   model (P21–P23, proof, CSA/SBL worked examples, due-event scheduler, single-writer,
   idempotency chain) MUST be preserved or §12/§17 cross-refs dangle and the liveness guarantee
   is lost. Highest risk of accidental substance loss.
2. §24 hard-compression risks losing the unit-identity-crystallisation point (referenced by §3)
   and the tokenized double-counting/custodian-is-flat result. Keep the results, drop the code.
3. §26 vs §27: both worked examples are needed (title transfer ≠ pledge). Pressure to keep only
   one would drop a regulatory regime's correctness witness — resist.
4. Invariant numbering collision: §12's P-list vs the addendum's re-labelled P-list and the
   C1–C12 list. One reconciled numbering, or readers cannot follow "which condition discharges
   which invariant". A correctness-of-exposition risk.
5. Segregation correction: §6 says conservation alone enforces segregation; the workflow doc
   proves it needs CONS ∧ LOC ∧ C4. If v11 keeps §6's phrasing it re-asserts a false theorem —
   an illegal state (cross-client move) slips back in. Must adopt the corrected statement.
6. The escalations (managed-account E1–E5; futures E1–E2; addendum risk register) are SUBSTANCE
   as honest open-items. Compressing them to nothing would overclaim. Keep as a flagged register.
