# Ledger v11.0 — Coverage Map (Completeness Contract)

**Status: SIGNED by minsky and jane-street-cto as the Phase-0 baseline.**
This is the completeness contract for the v10.3 → v11.0 fold. Every substantive v10.3
element has exactly one row below with a disposition (KEPT / COMPRESSED / SUPERSEDED-by /
REMOVED-because). Nothing is removed without an entry. The governing rule is **DROP THE
PATH, KEEP THE SUBSTANCE.**

## Scope decision (owner): RECENT-THREAD-ONLY

v11.0 folds in, as corrected and authoritative, only the recent thread:
- the three-home state model (`States.tex` + `addendum_stateshome_v2.tex` + `StatesHome.hs`),
- the corrected **UnitStatus** characterisation (see below),
- the futures lifecycle (`FutureLifeCycle.tex` + `FutureLifeCycle.hs`),
- the managed-account workflow (`managed_account_workflow.tex`).

The **satellite specs are OUT of scope**: valuation, market-data, deferred-settlement, and
data each KEEP v10.3's existing (already compressed) treatment **with a pointer to the
standalone spec**. v11.0 does NOT consolidate or re-expand them. The pointer sites are:
valuation → §5 and §10; deferred-settlement → §12; market-data → App. D; data → §11/§16.

## Budget posture (owner): SUBSTANCE WINS

Target **under 100 pp, 120 max — but advisory.** If completeness plus clearly woven
Haskell cannot fit under 120, the page count lands where it must. No substantive element is
cut to hit a number. Compression is by removing **path** only: derivation history, rejected
alternatives, iteration logs, vendor tutorials, restated prose, duplicate statements.
Honest realistic landing (both gatekeepers, independently): body ~95–105 pp, appendices
~28–31 pp, total **~125–150 pp** with full Haskell + both SBL examples; aggressive prose
compression targets the low end. **This exceeds the 120 soft cap; the owner has authorised
it rather than cutting substance.**

## The UnitStatus correction (authoritative over any "mutable" phrasing in v10.3)

UnitStatus is a **MATERIALISED PROJECTION of the immutable event log** — a read cache the
log always rebuilds — NOT an authoritative mutable store. Canonical wording
(`/home/renaud/Ledger/unitstatus_amendment/CHANGELOG.md`), used verbatim everywhere:

> UnitStatus holds one value per unit, shared — read identically by every holder. Its value
> changes over time, but UnitStatus is not a separate source of truth: the immutable event
> log is. Every change is caused by a logged event; the stored value is overwritten in place
> only as a read cache. Replaying the events up to any point rebuilds the exact value that
> held then, so nothing is lost by overwriting and there is no other way to change the value.
> A value exists from registration onward.

**Cross-cutting completeness requirement (both gatekeepers).** The correction must
propagate to EVERY mutable-state-dictionary site, not only the new §4: §3 (`UnitEntry`
state fields), §4, §7.3 (line 1034/2287), §8/§10 ("cached state" phrasing), §9, §11/§12
(operations cache), §14 (the obligation store, which is a view over the log). Missing one
re-admits the cache/log drift the amendment fixes. Each affected row below carries the tag.

---

## Reconciliation method

Two independent gatekeeper inventories (minsky, jane-street-cto) are reconciled here. Where
they agree, the agreed disposition is adopted. Where they differ, the **more
substance-preserving (more conservative) call** is taken and the divergence is noted. The
recorded divergences are organisational only — **no substantive element differs in
disposition between the two inventories.**

### Noted divergences (all organisational; substance identical)

1. **Balance sheet vs operations.** minsky merges v10.3 §8+§9 into one section; jane-street
   splits them. **Resolved: split** (v11.0 §10 Balance Sheet & Dual Valuation, §11
   Implementation & Operations) — two homes protect two distinct bodies of substance.
2. **Obligation liveness vs orchestration.** minsky gives Obligation Liveness its own
   section (to shield it from the Temporal cut); jane-street merges into one "Orchestration
   and Liveness." **Resolved: one section (§14 Orchestration and Obligation Liveness) with
   the liveness subsystem enumerated element-by-element as KEPT below** — the coverage-map
   enumeration gives the same protection as a dedicated section without an orphan, and the
   #1 shared risk (sweeping liveness away with Temporal) is pinned by the row list.
3. **CDM mapping table.** minsky folds App §19 into the CDM section; jane-street keeps it as
   App. A. **Resolved: keep App. A** (standalone compact table is cheap and unambiguously
   preserved; CDM section references it).
4. **Escalation/risk-register placement.** minsky routes E1–E5/F1–F8 to §9 + a flagged
   register in the conclusion; jane-street to §19 Open Problems / risk appendix. **Resolved:
   consolidated flagged register in §19 (Conclusion and Open Problems), with each escalation
   also cited at its home section (futures E1–E2 in §8, managed E1–E5 in §9).**

---

## Coverage, grouped by proposed v11.0 section

Legend: K=KEPT, C=COMPRESSED, S=SUPERSEDED-by, R=REMOVED-because. "→" = lands in.

### §1 Purpose, Scope, and Properties  ← v10.3 §1 (54–110), §16 boundary (4243–4269)
- **C** §1 Introduction (54–110). Keep the six by-construction properties result-first; the
  Document Roadmap (105–107) is pure path — regenerate from the TOC; the CDM-layers preview
  (103) duplicates §13/App. F — fold to a pointer.
- **K** Property 5, Lifecycle Value Invariance + optionality carve-out (71–73). Load-bearing:
  ties quantity conservation to value invariance for deterministic events, intrinsic-value
  only for optionality. Removing it overclaims value conservation.
- **K** The six properties, the three unreachable internal breaks (77), the ledger boundary
  paragraph (80). Boundary stated **once** here (merging the §16 list, see §18).

### §2 The Closed Ledger System  ← v10.3 §2 (111–299) + States primitives
- **K** §2 The Closed Ledger System (111–299). Wallet/unit/move/transaction, conservation,
  closure, virtual wallets, initialisation, books, self-consistency. The spine. **hs anchor.**
- **K** Conservation Law + System Closure theorem (193–206) = P1. Verbatim; encode as
  `negQty q <> q = mempty` and conservation as `foldMap`→`mempty`.
- **K** Self-Consistency Principle + 3 unreachable failures (276–294): trading/GL,
  PnL/BS, inter-entity breaks structurally impossible.
- **C** Only trim the repeated `src -= q; dst += q` restatement (stated once) and one
  duplicate of the wallet-flow figure prose.

### §3 The Unit Store  ← v10.3 §3 (300–493); C7/C10 from addendum
- **C** §3 The Unit Store (300–493). Keep three-tier registry, OTC/listed fungibility
  identity, registration channels, two-stage validation, four guarantees, CDM alignment.
- **S** `UnitEntry.unit_state` / `lifecycle_stage` fields (407–409) → §4. Mutable per-row
  state dictionary replaced by the three-home model + UnitStatus correction. **[UnitStatus tag]**
- **K** Unit Identity (fungibility) principle, OTC-vs-listed table. Referenced by §13/App. F.
  C7 (registration-total) / C10 (no re-registration) land here as the registration disciplines.

### §4 Where Unit State Lives: The Three-Home State Model  ← FOLD-IN States.tex + addendum_stateshome_v2.tex + StatesHome.hs; supersedes §7.3 (1034, 2287)
- **K** FOLD-IN States.tex + addendum. ProductTerms / UnitStatus / PositionState; the 2×2
  derivation (per-unit vs per-(holder,unit) × ledger- vs externally-authored); why three /
  fourth cell empty; W-sector collapse (C12). **Primary Haskell anchor (full StatesHome.hs).**
- **K** UnitStatus correction (canonical wording). Authoritative; without it cache/log drift
  re-admits internal-reconciliation failure. **[UnitStatus tag — canonical site]**
- **K** Twelve conditions C1–C12 (addendum §5). Each renders an illegal state unrepresentable:
  C1 Option-accessor+monotone-carrier, C2 handler conservation, C3 atomic StateDelta, C4
  capability reads, C5/C7 registration-total, C6 append-only terms, C8 two-track amendment,
  C9 vacuous conservation, C10 no re-registration, C11 per-field canonical writer, C12
  W-sector collapse. Cross-linked to the §15 hub.
- **K** "Invariants made unrepresentable" map (addendum §11): which C discharges which
  property, and by which mechanism (abstract type / NonEmpty / GADT tag / value-level check).
  (In the final §4 table this discharges P1, P8, P6, P4, P7, P9, reconciled to the §15/App.~B
  canonical hub numbering as the spec states.) **Highest-value content; cross-link to §15.**
- **S** §7.3 "Unit State as Explicit Object" (1032–1057; line 1034, line 2287). Mutable
  state-dictionary phrasing replaced by ProductTerms/UnitStatus/PositionState;
  `get_unit_state(u)` → `(product_terms,unit_status)`; `get_unit_state(w,u)` → `position(w,u)`.
- **C** Addendum "Alternatives Considered" Pareto A–F. Keep only the **result** (design B —
  three maps + C1–C12 — is the unique Pareto-optimum under correctness gate ≥7, with the one
  forcing reason per rejected design). Drop the ordinal score table and iteration narrative (path).
- **K** Addendum testing commitments (mutation scores 85–90% handlers, etc.) → cited here,
  routed to §19/App. B as the testing agenda.

### §5 Portfolio Valuation and PnL  ← v10.3 §4 (494–603); pointer to valuation satellite
- **C** §4 Portfolio Valuation and PnL (494–603). Keep state-sufficiency, path-independent
  PnL theorem+proof, price/flow decomposition, quantity-vs-value distinction. Shrink the
  numerical attribution table. **Pointer to the standalone valuation spec — do not expand.**
- **K** Path-Independent PnL theorem (521–537): PnL = V(t₁)−V(t₀); telescoping proof. = P10.
- **C** Dual valuation cross-reference: the MtMk/MtMd treatment is fully developed in §10;
  here only the definition + pointer.

### §6 Smart Contracts as Move Generators  ← v10.3 §5 (604–805)
- **C** §5 Smart Contracts as Move Generators (604–805). Keep contract definition,
  modular-vs-composite recommendation, equity/dividend/corporate-action contracts.
- **K** European put + IRS full move schedules; lot-size delivery (653–804). Concrete
  conservation witnesses; lot-size logic referenced by FAQ Q7 and settlement. Compress prose.
- **C** §5 decimal-arithmetic requirement is **superseded-in-improvement** by exact-Integer
  minor units from the Haskell thread (a correctness upgrade); note it. **hs: Move/Qty.**

### §7 Lifecycle Management  ← v10.3 §7 core (978–1031, 1093–1110, 1370–1481) minus §7.3
- **K** §7 Lifecycle Management core. Lifecycle-as-transaction, pure-function transition,
  idempotence, 4 time-travel challenges, clone/clone_at, the Executor (sole mutator),
  purity, embedded defence, risk-profile table. **hs: lifecycle pure fn + Executor as sole `applyDelta`.**
- **K** QIS / Leveraged-ETF lifecycle (1353–1369). Grounds strategy-as-unit (u_QIS) and C12;
  referenced by §4. Keep compressed.
- **S** §7.3 unit-state dictionary → §4 (see §4 rows). **[UnitStatus tag]**
- **S** §7 futures accumulated-cost ALPHA/CH worked example (1111–1352) → §8. Carried with
  same substance plus intraday-VM subtlety, close-out, physical/cash variants. **Merge: keep
  one authoritative futures treatment; preserve the direction-reversal result (−100 not −300).**

### §8 The Futures Lifecycle  ← FOLD-IN FutureLifeCycle.tex + FutureLifeCycle.hs; supersedes §7 futures example
- **K** FOLD-IN FutureLifeCycle. Full life: register → trade → daily VM settle → intraday
  trade → close-to-flat → expiry → Close. VM fan-out identity VM = net·S·mult + ac; the
  intraday-trade subtlety forcing per-position stored `ac` (C11); never-held/held-flat at
  close (C1); expiry/Close, physical vs cash settlement; closing identity cumulative-VM =
  economic-PnL. **Haskell anchor: distinct Qty/Cash/Price (Price no Monoid), markValue,
  Stage = Registered | Active (Maybe Settlement) | Expired Settlement, monotone-absorbing
  stage, settlementFanout, closeDelta, PosQty parse boundary, handle/step/replay.**
- **K** Settlement-price-as-observation: enters only as the `SettleVM` logged event; replay
  rebuilds the mark; fold stays pure at the boundary. **[UnitStatus tag]**
- **K** Futures escalations E1 (fan-out cost at scale) and E2 (derived-consequence declined)
  → cited here, consolidated in §19.

### §9 Managed Accounts, Virtual Portfolios, and TRS  ← FOLD-IN managed_account_workflow.tex; supersedes §6 (806–977)
- **S** §6 Managed Accounts, Virtual Portfolios, and TRS (806–977). Informal version
  superseded by the derived, corrected workflow note. Retain v10.3's "every wallet is a
  managed account" framing, CSA-margin-as-wallet-contract, mandate-guard, virtual-ledger/TRS
  isolation where not subsumed.
- **S** §6 "conservation alone enforces segregation by algebra" (853–855). **False theorem.**
  Superseded by the workflow Segregation theorem: segregation = CONS ∧ LOC ∧ C4. Adopting
  §6's phrasing re-admits a cross-client move (an illegal state). **Correctness-critical.**
- **K** FOLD-IN workflow note. Managed account = composition of four primitives;
  mandate-as-unit (issuance law); fee logic (mgmt + perf, HWM ratchet, perf net of flows,
  double-entry crystallisation); Segregation theorem; TRS equivalence theorem (= P7 isolation);
  CSA margin; redemption/wind-down; account-level substantiation; worked example to the penny;
  conformance flags (CDM LegalAgreement, F5 SFTR discharge). **hs: issuance-law Move,
  fee-crystallise double-entry, HWM qmax ratchet via FieldWrite 'FeeCrystallise.** **[UnitStatus tag]**
- **K** Managed-account escalations E1–E5 + Nazarov attestation finding → cited here,
  consolidated in §19 as flagged open items (store-vs-derive scalars; unattested observation
  surface; counterparty LEI; C4 asserted-not-typed; no in-ledger solvency liveness).

### §10 Balance Sheet Substantiation and Dual Valuation  ← v10.3 §8 (1483–1600)
- **C** §8 Balance Sheet Substantiation & Dual Valuation. Keep balance-reconstruction formula,
  substantiation-as-projection, dual valuation (MtMk/MtMd, multi-exchange futures), FVA,
  snapshots. **hs: `netBal` as `foldMap` projection.** **[UnitStatus tag — "cached state" phrasing]**
- **C** Embedded reconciliation taxonomy dedupes with App. C — state once in App. C, point here.

### §11 Implementation and Operations  ← v10.3 §9 (1601–1684)
- **C** §9 Implementation and Operations. Keep three-layer architecture (stream/aggregation/
  cache), balance-update algorithm, O(n) PnL, fault tolerance (late/duplicate events,
  contradictory external state, stale data, integrity, partial failures), corrections-as-events
  (event sourcing), dual timestamps, ISO 20022 sese.023 mapping. Compress fault-tolerance bullets.
  **[UnitStatus tag — reinforces wallet state = rebuildable projection]**

### §12 The Settlement Layer Interface  ← v10.3 §10 (1685–1888); pointer to deferred-settlement satellite
- **C** §10 The Settlement Layer Interface. Keep settlement projection (pure/deterministic/
  idempotent/total), settlability classification, SettlementInstruction, DvP two-level
  guarantee, gross→net algebraic identity, confirmation return path. Replace pseudocode with
  a typed Haskell signature. **Pointer to the standalone deferred-settlement spec.**
  **hs: `settleProjection :: Transaction -> Maybe SettlementInstruction`.**

### §13 ISDA CDM Integration  ← v10.3 §11 (1889–2017) + App §19 mapping
- **C** §11 ISDA CDM Integration. Keep what-CDM-is, why-CDM (products-as-units,
  event-model-as-state-graph, embedded logic, mapping layer), synonym layer, enums-as-generator
  universe. Trim the AAPL narration shared with App. F. **hs: forgetful `F :: BusinessEvent -> Transaction`.**
- **K** Forgetful mapping F properties (1980–1999): preserves composition(restricted)/
  conservation/sequencing/idempotency; forgets intent/lineage/structure/regulatory class.
- **K** App §19 CDM Type Mapping referenced from here, kept standalone as App. A (divergence 3).

### §14 Orchestration and Obligation Liveness  ← v10.3 §14 substance (2189–3421); Temporal tutorial REMOVED
- **R** §14 Temporal.io tutorial bulk (2189–3012, the vendor-specific portions). REMOVED-because
  it is implementation path, not specification: why-Temporal, retry/timeout config and tables,
  per-instrument workflow code, saga code, task-queue/worker architecture, corporate-action
  fan-out code, deterministic-replay mechanics, idempotency-chain walkthrough, versioning/
  ContinueAsNew/history management, team profiles, CDM activity-map listing. **~20–25 pp saving.**
  Replaced by a ~3 pp execution-engine-requirements statement (one engine, not a result).
- **K** Four orchestration requirements + executor-as-activity + due-event scheduler +
  single-writer concurrency (2619–2922). Load-bearing safety/liveness: exactly-once / durable
  timers / deterministic replay / single-writer; the scheduler resolves the event-triggered
  liveness gap; concurrency resolved by single-writer. **Survives even as the Temporal code goes.**
- **K** Obligation Liveness subsystem (3013–3189): first-class `Obligation`(id,type,source,t_d,
  D,κ), state machine, taxonomy table, obligation store (a **view over the log** — consistent
  with the UnitStatus correction), registration-completeness principle, obligation workflow.
  Drop only the code listing. **[UnitStatus tag — obligation store]**
- **K** Liveness invariants P21–P23 + five-lemma proof of liveness (3190–3289). Cross-referenced
  from §15 and §19 ("open problems now resolved"); dropping them dangles those refs and loses
  the liveness guarantee. **Protected — must survive the §14 cut.**
- **C** Worked examples: CSA VM call; SBL collateral substitution (3290–3384). Correctness
  witnesses (discharge + compensation paths, conservation verified). Keep, compress prose.
- **hs (optional):** `Obligation` record + `discharge` predicate as a total function.

### §15 Invariants, Conservation Laws, and Property-Based Testing  ← v10.3 §12 (2018–2168) + App §20; THE consolidation hub
- **K** §12 Invariants section. The hub: conservation-as-oracle, invariants-as-spec,
  specification-first. **Cross-links P1–P10, P11–P20, P21–P23, C1–C12, and the
  made-unrepresentable map into one place** (the single hardest exposition risk, see Risks).
- **K** Ten core invariants P1–P10 (2038–2051). Verbatim acceptance criteria.
- **K** Ten core PBT properties (2065–2148) + CDM-enum generator universe + EventIntentEnum/
  OptionTypeEnum completeness-by-enumeration argument. Compress wrapper prose.
- **hs: types-as-theorems** — `validate`/`ValidDelta` (C2/P1, value-level gate), `NonEmpty`
  (P6), monotone carrier (P3/C1b), Kleisli `>=>` replay homomorphism (P3), `FieldWrite` GADT (P10).

### §16 Generalised Positions and Securities Borrowing/Lending  ← v10.3 §15 (3422–4238); cross-ref App. G/H/I
- **C** §15 Generalised Positions and SBL. Core base, not a satellite. Keep six-coordinate
  vector, Single-Coordinate Move Principle, available-inventory projection, graceful
  degeneration, named-wallet resolution, five-term generalised conservation, SBL contract +
  representability, SBL state machine, atomic moves per event, title-transfer vs
  security-interest, collateral/margin, short selling, cash-collateral reinvestment, on-lending
  + cascade recall, locates + over-location prevention, cross-border, external recon, CDM/reg
  alignment. **Drop the Temporal-for-SBL subsection (3903–3917) — path; fold any substance into §14.**
- **K** Position vector + physical-action test + Single-Coordinate Move Principle + avail
  projection (3451–3539): avail = own − onloan + borr computed on read, cannot drift.
  **hs: six-field position record + total `avail` projection.**
- **K** SBL invariants P11–P20 (4204–4235). Verbatim; P20 (avail identity) and P18 (lender
  ownership invariance) are by-construction. Cross-link to §15 hub.

### §17 Regulatory Obligations and the Direction of Travel  ← v10.3 §13 (2169–2188)
- **C** §13 Regulatory Obligations. Keep CDM-native reporting from the move stream,
  reference-data enrichment gap, BCBS239/DORA alignment, DRR production status. Compress
  current-events prose (DRR metrics, LSEG/JPM) to a dated note. Cross-reference F5 resolution.

### §18 Scope and Limitations  ← v10.3 §16 (4239–4304)
- **K** §16 Scope and Limitations. Boundary inside/outside lists, 9 "does not do" limits,
  theorems-vs-modelling-choices, architecture-vs-operational-reality. Guards against
  overclaiming; referenced by §1. The boundary list is stated **once** (merged with §1's
  boundary paragraph; this section carries the full inside/outside lists).

### §19 Conclusion and Open Problems  ← v10.3 §17 (4305–4387) + addendum F1–F8 + escalations
- **C** §17 Conclusion. Keep summary, four design goals, self-consistency standard. Prune
  celebratory prose.
- **C** Open Problems list (4346–4384). Keep the agenda (netting/close-out, correction algebra,
  federation, XVA, bitemporal, tax lots, ECL, GDPR, access control, repos, default mgmt,
  pre-trade validation, migration, tokenized). **Mark concurrency, liveness, and the
  unit-vs-wallet state-attachment question RESOLVED** (by §14 and §4).
- **K** Consolidated flagged register (the next-version agenda, kept distinct from the proven
  quantity algebra): addendum risks F1–F8; managed-account escalations E1–E5 + Nazarov
  attestation finding; futures escalations E1–E2; addendum mutation-score commitments. Honest
  open items — compressing to nothing would overclaim soundness.

### §20 Frequently Asked Questions  ← v10.3 §18 (4388–4516)
- **C** §18 FAQ. Keep result-bearing Q&A; Q6 (move-less events), Q9 (own stored / avail
  projection), Q10 (scalar cash collateral), DvP atomicity, physical delivery + lot size, SBL
  companion-system rejection (5 reasons), reinvestment title-transfer vs pledge are load-bearing.
  Drop answers that merely restate body prose. **[UnitStatus tag — projection-not-stored discipline]**

### Appendices

- **K** App. A — CDM Type Mapping Tables ← §19 (4520–4547). Compact reference; kept as-is.
- **C** App. B — Property Test Catalogue ← §20 (4548–4582). Executable forms of P1–P10 (+ SBL
  P11–P20 pointer); attach to / merge with the §15 hub to avoid duplicating prose statements.
  **hs: property pre/postconditions as typed predicates.**
- **K** App. C — Reconciliation Failure Mode Taxonomy ← §21 (4583–4620). 9-row taxonomy (3
  unreachable, 6 detectable, SBL by design). Kept; **stated once** (§10 points here).
- **C** App. D — Pricing/Contract-State/Market-Data Coordination ← §22 (4621–4686). Keep the
  result (coupon double-count/vanish, ex-dividend state-aware pricing — reinforces C3).
  **Pointer to the standalone market-data spec. hs: state-aware price P_t(u)=P(u,state,market).**
- **C** App. E — Glossary ← §23 (4687–4739). Keep; add recent-thread terms (UnitStatus-as-
  projection, ProductTerms, PositionState, StateDelta, ValidDelta, Obligation, conserved field,
  monotone carrier, Option accessor, PosQty, C1–C12).
- **C** App. F — CDM Product Model Developer's Guide ← §24 (4740–6231). **~12–15 pp saving.**
  Keep the six-layer hierarchy + unit-identity-crystallisation (referenced by §1/§3/§13) and
  the three sub-walkthrough RESULTS: (i) Payout composition + TransferableProduct boundary;
  (ii) tokenized-NVDA double-counting resolution + custodian-is-flat + 4 CDM gaps; (iii)
  date-type taxonomy + resolution chain + gotchas. **Drop the exhaustive Rune/CDM code
  listings and parallel-instrument tables; one worked instance per concept.**
- **C** App. G — Available-Inventory Eight-Scenario Verification ← §25 (6232–6352). Property-
  test evidence for P20; compress to a single 8-row table, **keep all eight** (each exercises
  a distinct coordinate combination).
- **C** App. H — European SBL Worked Example, GMSLA 2010 ← §26 (6353–6860). Title-transfer
  correctness witness (rehyp, MtM, manufactured dividend, partial recall, return). Compress
  prose, **keep the per-step six-coordinate vectors + conservation lines.**
- **C** App. I — US SBL Worked Example, SEC 15c3-3 ← §27 (6861–7314). Pledge/cash-collateral
  counterpart (rebate, reinvestment, 140% rehyp cap, SLATE, close-out, cross-jurisdiction
  table). **Both H and I are kept — title transfer ≠ pledge are distinct regulatory
  correctness witnesses.** Compress prose, keep step vectors + comparison table.

---

## Proposed v11.0 section list (deductive order, page estimates, Haskell weave)

| # | Section | est. pp | Haskell weave |
|---|---------|---------|---------------|
| 1 | Purpose, Scope, and Properties | 4 | none |
| 2 | The Closed Ledger System | 6 | Qty group (Semigroup/Monoid, negQty), Move, applyMove, conservation as `negQty q <> q = mempty` / `foldMap`→`mempty` |
| 3 | The Unit Store | 5 | register (singleton ProductTerms, C7), re-registration as Left (C10) |
| 4 | Where Unit State Lives: The Three-Home State Model | 11–12 | **FULL StatesHome.hs**: ProductTerms (NonEmpty, abstract, appendVersion C6/C7); UnitStatus + applyStatus single-writer (projection-of-log, C5); PositionState/zeroP + Option accessor + monotone carrier (C1); sealed Ledger; StateDelta/ValidDelta/validate (C2/C3); FieldWrite GADT (C11); amend two-track (C8); register/applyDelta/replay (foldM) |
| 5 | Portfolio Valuation and PnL | 4 | value :: PriceVec → Ledger → Cash signature; pointer to valuation satellite |
| 6 | Smart Contracts as Move Generators | 6 | Move/Qty; exact-Integer minor units supersede decimal float |
| 7 | Lifecycle Management | 7 | lifecycle pure fn (Event,State)→(moves,State'); Executor as sole applyDelta |
| 8 | The Futures Lifecycle | 9 | **FULL FutureLifeCycle.hs**: distinct Qty/Cash/Price (Price no Monoid), markValue, Stage = Registered｜Active (Maybe Settlement)｜Expired Settlement, monotone-absorbing stage, StateDelta/validate, settlementFanout, closeDelta, PosQty boundary, handle/step/replay |
| 9 | Managed Accounts, Virtual Portfolios, and TRS | 9 | issuance-law Move; fee-crystallise double-entry; HWM ratchet via FieldWrite 'FeeCrystallise; Crystallise(magnitude,from,to) signature |
| 10 | Balance Sheet Substantiation and Dual Valuation | 5 | netBal as foldMap projection of the move stream |
| 11 | Implementation and Operations | 4 | none |
| 12 | The Settlement Layer Interface | 6 | settleProjection :: Transaction → Maybe SettlementInstruction (pure/total); pointer to deferred-settlement satellite |
| 13 | ISDA CDM Integration | 6 | F :: BusinessEvent → Transaction (forgetful) signature; App §19 table → App. A |
| 14 | Orchestration and Obligation Liveness | 9 | Obligation record + discharge predicate as a total function (optional) |
| 15 | Invariants, Conservation Laws, and PBT | 8 | validate/ValidDelta (C2/P1), NonEmpty (P6), monotone carrier (P3), Kleisli >=> replay homomorphism, FieldWrite GADT (P10); types-as-theorems |
| 16 | Generalised Positions and SBL | 11–12 | six-field position record; avail :: Position → Qty total projection; applyMove single-coordinate |
| 17 | Regulatory Obligations and the Direction of Travel | 2 | none |
| 18 | Scope and Limitations | 4 | none |
| 19 | Conclusion and Open Problems | 4 | none |
| 20 | Frequently Asked Questions | 4 | none |
| A | CDM Type Mapping Tables | 1 | none |
| B | Property Test Catalogue | 2 | property pre/postconditions as typed predicates |
| C | Reconciliation Failure Mode Taxonomy | 1 | none |
| D | Pricing/Contract-State/Market-Data Coordination | 2 | state-aware price P_t(u)=P(u,state,market); pointer to market-data satellite |
| E | Glossary | 2 | none |
| F | CDM Product Model Developer's Guide | 9 | none |
| G | Available-Inventory Eight-Scenario Verification | 2 | none |
| H | European SBL Worked Example (GMSLA 2010) | 6 | none |
| I | US SBL Worked Example (SEC 15c3-3) | 6 | none |

**Estimated total: body ~119, appendices ~31 → ~150 pp worst case; with disciplined prose
compression (state-once dedup, path removal) realistic landing ~120–135 pp.** Exceeds the
120 soft cap under full Haskell + both SBL examples; owner-authorised (substance wins).

## Big compression sources (largest page savings, in order)

1. **§14 Temporal.io (1233 lines, ~30 pp) → ~9 pp.** REMOVE the vendor tutorial (why-Temporal,
   retry/timeout config and tables, per-instrument workflow code, saga code, task-queue
   architecture, fan-out code, replay mechanics, idempotency-chain walkthrough, versioning/
   ContinueAsNew, team profiles, CDM activity map) as path. KEEP the four execution-engine
   requirements + executor-as-activity + due-event scheduler + single-writer, and the **entire
   Obligation Liveness subsystem** (P21–P23, proof, CSA-VM + SBL-substitution examples).
   **Net ~20 pp.** This is also the #1 accidental-loss risk (see Risks).
2. **App. F / §24 CDM Developer's Guide (1491 lines, ~35 pp) → ~9 pp.** Keep the six-layer
   hierarchy, unit-identity-crystallisation, and the three sub-walkthrough RESULTS; drop the
   exhaustive Rune/CDM listings, parallel-instrument tables, and date worked-example bulk.
   **~12–15 pp.**
3. **App. H + App. I / §26–27 SBL examples (~960 lines, ~22 pp) → ~12 pp.** Keep both regimes
   (title transfer vs pledge are distinct correctness witnesses); compress prose to per-step
   coordinate-delta vectors + conservation lines + the comparison table. **~8 pp.**
4. **Superseded-duplication folds.** §7 futures example → §8; §6 managed-account/TRS → §9;
   §7.3 (line 1034) state model → §4. Removes pages of now-superseded prose while the substance
   moves to the corrected treatment.
5. **Pervasive state-once dedup.** Conservation `src-=q;dst+=q` (~6×), "every view is a
   projection" (many ×), reconciliation taxonomy (§8 + App. C), AAPL CDM narration (§11 + §24),
   invariant statements (§12 + App. 20), boundary (§1 + §16) — each stated once.

## Completeness risks (where completeness vs budget is hardest)

1. **§14 over-cut (#1, both gatekeepers).** A blunt "drop Temporal" sweeps away the Obligation
   Liveness subsystem (P21–P23, due-event scheduler, single-writer resolution) — substance,
   not path. If lost, §15's P21–P23 and §19's "liveness resolved" claim dangle. The coverage
   map pins every liveness element as KEPT; they MUST survive even as the code goes.
2. **Invariant-consolidation completeness.** P1–P10, P11–P20, P21–P23, and C1–C12 must all
   appear and be cross-linked in the one §15 hub, and the "which type/condition discharges
   which invariant" map (highest-value content) is the easiest to drop as "meta." One
   reconciled numbering scheme is required or the discharge mapping becomes unreadable — a
   correctness-of-exposition risk.
3. **Segregation correction.** §6's "conservation alone enforces segregation" is a false
   theorem; v11.0 MUST adopt CONS ∧ LOC ∧ C4, else a cross-client move (an illegal state) is
   re-admitted by assertion.
4. **UnitStatus correction propagation.** The correction must reach every mutable-dictionary
   site (§3, §4, §7.3, §8/§10, §9, §11, §14 obligation store), not only §4 — missing one
   reintroduces the cache/log-drift contradiction the amendment fixes.
5. **Two futures treatments must merge cleanly.** §7 ALPHA/CH and FutureLifeCycle A/B/C must
   fuse into one §8 without losing the direction-reversal case or the intraday-VM result
   (−100, not −300).
6. **§24 forward references.** App. F hard-compression must retain unit-identity-crystallisation
   (referenced by §3) and the tokenized double-counting / custodian-is-flat result; losing them
   breaks a forward reference and a correctness claim.
7. **Both SBL regimes.** Budget pressure to keep only one drops a regulatory regime's
   correctness witness; resist — keep both H and I, compressed.
8. **Satellite boundary discipline.** Valuation, market-data, deferred-settlement, data must be
   compressed-with-pointer — easy to over-trim (losing load-bearing definitions like
   Path-Independent PnL or the coupon double-count argument) or over-keep (re-expanding a
   satellite out of scope).
9. **Open-items honesty.** Addendum F1–F8, mutation-score commitments, managed-account E1–E5 +
   Nazarov finding, futures E1–E2 must land in §19 as a flagged register, clearly separated from
   the proven quantity algebra; compressing them to nothing would overclaim soundness.
10. **Budget.** With the three fold-ins (futures ~9, three-home ~12, managed ~9) added and
    §14/§24 cut hard, the realistic landing is ~120–150 pp. The only remaining give without
    losing substance is the SBL examples and the CDM guide; the count may land above 120, which
    the owner has authorised rather than cutting a substantive element.

---

## Sign-off

This coverage map is the **Phase-0 baseline, SIGNED by minsky and jane-street-cto.** The two
independent inventories agree on every substantive disposition; the four recorded divergences
are organisational only and are resolved above in favour of the more substance-preserving
structure. **No unresolved substantive divergence remains.**
