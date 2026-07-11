# EXCLUSIONS REGISTER — Ledger Specification v15

**Custodian:** CARTAN (completeness auditor). **Phase:** 2. **Date:** 2026-07-11.
**Inputs:** v13.1 digests (`v15_workpapers/v13_1_digest_sec01-09.md`, `v13_1_digest_sec10-31.md`);
Constitution v1.1 (`LedgerManifesto/leddeger_manifesto.md`); Phase 1 Design Ruling
(`v15_workpapers/phase1_design_ruling_memo.md`); v14 topic list (orchestrator).

## The rule

v13.1 is ~171 pages and v14 is ~40; v15 is capped at 100. Material will be dropped, and
every drop is deliberate and auditable, never silent. **Every v13.1/v14 topic not carried
into v15 appears in this register**, one line per topic, with a disposition drawn from
exactly five reasons:

| Code | Disposition |
|---|---|
| **CONST** | Superseded by the constitution (v1.1) |
| **RULING** | Superseded by the Phase 1 ruling (collateral generalisation, D1–D5) |
| **COMP** | Deferred to a companion document (named per line) |
| **IMPL** | Implementation detail — below the specification's altitude |
| **OOS** | Out of scope per the constitution's scope section |

Where the constitution or the ruling speaks, the disposition is binding and unmarked.
Where neither speaks, the line is a **recommendation**, marked **(R)**, and the owner
decides at the gate. A topic "carried in condensed form" is not an exclusion; where only
an artifact of a carried topic is dropped (a code listing, a table), the artifact is the
line. Restated-not-deleted items (invariants that survive in a new form) are listed with
their successor named.

**Companion documents referenced** (none yet exists; naming them here creates the
obligation): *Reference Implementation* (`reference/Ledger.hs` + executable test
catalogue); *CDM Alignment Dossier*; *Worked-Examples Volume*; *Design-Rationale Annex*;
*Test Plan* (coverage/mutation commitments); *Open-Problems & Escalation Register*;
*Valuation Satellite* (already named as deferred in v13.1 itself).

---

## The register

### A. Global exclusion (applies across all sections)

| # | Topic (source) | Disp. | Reason |
|---|---|---|---|
| E1 | All verbatim Haskell listings (~2,000+ lines across sec03–06, 09–12, 14–18, 24) | COMP | Deferred to *Reference Implementation*; v15 keeps only the type signatures and anchors a stated claim depends on — preserving v14's "executable claims" stop without carrying the code **(R** on the anchors-only policy**)**. |

### B. sec01 — Roadmap and reading guidance

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E2 | Persona reading-path table and per-persona routing map | IMPL | Navigation apparatus for a 171-page text; v15's structure is KLEPPMANN's ToC **(R)**. |
| E3 | Parts I–V organisation (scalar carries Parts I–IV; vector enters Part V) | RULING | One universal representation from the first page; the scalar is the degenerate case, so staged introduction is superseded. |
| E4 | "Mental model" non-normative box convention | IMPL | Presentation convention; whether v15 keeps it is KLEPPMANN's call **(R)**. |

### C. sec02 — Purpose, scope, and properties *(core carried)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E5 | Scalar-first framing of the six properties (vector deferred) | RULING | Properties restate on the per-(unit, coordinate) conservation law from the outset. |

### D. sec03 — The closed ledger system *(core carried)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E6 | Concrete `Map`/`foldMap` storage mechanics | IMPL | Representation choice, not architecture (also E1). |
| E7 | Per-unit summed conservation as the primitive statement | RULING | Restated: per-(unit, coordinate) conservation is primitive; the summed law is a corollary (ruling §3). |

### E. sec04 — The unit store *(core carried)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E8 | `UnitEntry` field layout and `unit_id` hash derivation | IMPL | Schema/encoding detail; the guarantees (existence, immutability, injectivity) are carried. |
| E9 | CDM tier-mapping table and CDM documentation-gap notes | COMP | *CDM Alignment Dossier* **(R)**. |

### F. sec05 — Three-home state model *(core carried)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E10 | A–F alternative-design Pareto-uniqueness comparison | COMP | *Design-Rationale Annex*; justification narrative, not normative content **(R)**. |
| E11 | GADT/`FieldWrite` encodings, sealed-`Ledger` constructor mechanics | IMPL | Enforcement encoding; the writer-discipline condition (C11) is carried, its encoding is not. |
| E12 | Mutation-score commitments (handlers 85–90%, guards 70–80%, core ≥80%, TLC model) — also sec22 | COMP | *Test Plan*; QA process targets, not specification content **(R)**. |

### G. sec06 — Valuation and PnL *(core carried)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E13 | Pricing methodology, reference-currency/FX construction | COMP | *Valuation Satellite* — v13.1's own deferral, maintained; also OOS (price discovery) at the boundary. |

### H. sec07 — Smart contracts as move generators *(core carried)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E14 | European put lot-split worked schedule (whole-lots DvP + cash residual) | COMP | *Worked-Examples Volume*; the remainder discipline itself is constitutional (§4) and carried **(R,** cap-driven; not in v14's tour**)**. |
| E15 | IRS CDM-lifecycle worked example (5-yr SOFR swap) | COMP | *Worked-Examples Volume*; v14's product-tour selection governs the v15 tour **(R,** cap-driven**)**. |
| E16 | `sese.023` settlement-message projection details | OOS | Report formatting and CSD connectivity are outside the boundary; the projection *principle* is carried (sec14). |

### I. sec08 — Lifecycle management *(core carried)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E17 | Lifecycle risk-profile table and test-oracle/test-form mapping | COMP | *Test Plan*; QA-process detail **(R)**. |
| E18 | Strategy-as-unit inside the true ledger (weights/config/rebalance state on a true-ledger strategy unit) | CONST | §10: the strategy's portfolio is a wallet in a **virtual ledger**; the level enters the true ledger only as a stamped observation; an index restatement is a compensating entry. |

### J. sec09 — State-basis discipline *(core carried: boundary events, basis chain, tip/invariance welds, operators, dimensions, adjustment schedule C14, datum-kind registry, ingest door, single-basis consumption C13, CAClass, W1–W4)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E19 | Tier-1/Tier-2 type-level enforcement (phantom indices, `Adj` GADT, `withSnapshot` seam) and the Safe-Haskell/`type role`/no-GND language proviso | IMPL | Enforcement encoding in one language fragment; the invariant it enforces (single-basis consumption) is carried. |
| E20 | Generator/shrinker suites | COMP | *Reference Implementation* test catalogue. |
| E21 | Nine executable property oracles as code (P25, P-DET, P-MODE, P-PERM-N/O, P-CRASH, P-REPRO, P-CLONE-STAMP, P-LAG, pPartition) | COMP | Executable test catalogue; the property *statements* stay in the v15 invariant catalogue. |
| E22 | `mQuoteEx` ex-transition one-bit lag mechanism | CONST | Subsumed special case of the declared `Convention`/market-data-operator machinery (v13.1's own note; constitution §9). |
| E23 | Declared-override rule-language grammar (closed first-order form) | COMP | *Design-Rationale Annex*; v15 states that overrides are declared closed-form data, not the grammar **(R)**. |
| E24 | ISO 15022/20022 CA message classes (MT564/565/566, seev.031/033/036) as attested-source instances | OOS | Gateway message formats; the attestation requirement (W4) is carried **(R)**. |
| E25 | F1–F10 boundary-fault table as a catalogue | COMP | Verification catalogue; W1–W4 failure *regimes* recommended carried as normative refusal behaviour **(R — flagged, see flag 2)**. |

### K. sec10 — Futures lifecycle *(carried via the v14 product tour)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E26 | FE1/FE2 escalations (settlement fan-out cost, derived-consequence alternative) | IMPL | Write-amplification engineering; the C11 conclusion (stored per-position `ac`) is carried. |
| E27 | Batching/snapshotting mitigations | IMPL | Engineering mitigation, named to the *Open-Problems & Escalation Register* index. |

### L. sec11 — Managed accounts, virtual portfolios, TRS *(core carried, recast per constitution §10)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E28 | Subscription booked as tagged cash move against a wholly non-valued mandate unit (entry NAV/HWM only in PositionState; no claim unit) | CONST | §6: a subscription is an **exchange** — cash against a **valued redemption-claim unit** — never a transfer for nothing; the mandate's rulebook stays non-valued; fee accrual/NAV attribution re-derived accordingly. |
| E29 | ME1–ME5 escalations (store-vs-derive, attestation envelope, LEI binding, C4 typing, solvency liveness) | COMP | *Open-Problems & Escalation Register*; ME4 additionally IMPL (typing of C4 is encoding). Items overtaken by the ruling's named obligations are RULING. |
| E30 | CDM reportability-flag analysis for u_MA/TRS (F5/F6, MiFID II Annex I §A(4) reasoning) | OOS | Regulatory-classification detail at the submission gateway; the reports-as-projection principle is carried **(R)**. |
| E31 | Legal-segregation discussion beyond the logical-segregation theorem (CASS 6 / MiFID II Art 16(8) mapping) | OOS | Legal agreements are outside the boundary; the segregation theorem itself is carried. |

### M. sec12 — Balance-sheet substantiation and dual valuation *(substantiation-as-replay carried)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E32 | FVA / CRR Art 105 prudent-valuation adjustment | OOS | Model governance and accounting policy; the dual-valuation *structure* is a carry recommendation (see flag 1). |
| E33 | MVCC/quiescence snapshot mechanics | IMPL | The O(k) snapshot-correctness property is carried; the mechanism is not. |

### N. sec13 — Implementation and operations

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E34 | Three-layer runtime architecture, balance-update algorithm, WAL/crash recovery, replication/backup/DR | IMPL | Engineering below the specification's altitude; the properties they must preserve (P2, P4, P8) are carried in the invariant catalogue. |
| E35 | ISO 20022 sese.023 field-mapping table | OOS | Report formatting; traceability-chain *requirement* carried with the settlement projection. |
| E36 | Fault-tolerance playbook detail (late/duplicate/contradictory/stale event handling narratives) | IMPL | Each reduces to a carried invariant (P5/P6, bitemporal stamps, fail-closed gating); the narratives are operational guidance **(R)**. |

### O. sec14 — Settlement layer interface *(core carried — constitutional scope item)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E37 | SSI enrichment, custodian/CSD participant identifiers, settlement priority | OOS | Constitution scope: settlement finality, payment-system access, and CSD connectivity are outside the boundary. |

### P. sec15 — ISDA CDM integration *(forgetful map F and vocabulary role carried, condensed)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E38 | Ingestion pipeline mechanics (synonym mapping, raw-message transport, CDM version coexistence) | IMPL | Boundary engineering; determinism and provenance requirements carried in §14-style minimum requirements. |
| E39 | CDM enumeration-addition/governance process | COMP | *CDM Alignment Dossier* **(R)**. |

### Q. sec16 — Orchestration and obligation liveness *(obligation object, P21–P23, processor contract, scheduler requirements carried — constitution §14.1)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E40 | **Temporal.io adoption** as the named engine | IMPL | The constitution fixes minimum requirements only; CLAUDE.md reserves implementation choices to the owner; the pick moves to the *Reference Implementation* as a reference choice, never a normative one. |
| E41 | Workflow-spawning and per-unit sharding mechanics (one workflow per unit, parent-workflow cross-unit) | IMPL | The serialisation requirement itself is carried via the single writer and refusal-on-no-precedence (constitution §5). |
| E42 | Cluster-availability assumption discussion (L4) | IMPL | Liveness-conditionality is carried in one constitutional sentence ("integrity owes them nothing; liveness is conditional on them"). |

### R. sec17 — Generalised positions and SBL *(THE ruled section — largest supersession block)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E43 | **Six-coordinate stored position vector** (own, onloan, borr, coll_post, coll_recv, coll_rehyp) | RULING | Replaced by the signed three-basis (owned, lent, posted); the five constitutional names are its rays. |
| E44 | **coll_rehyp as a stored coordinate** | RULING | Re-use is a posting of mass held on the received ray, with a mandatory source-agreement reference; re-used/available is a projection. |
| E45 | **`legal_regime` as stored valuation switch** (V^SI = Σ(own+coll_post)·P vs V^TT = Σ own·P) | RULING | D3: PnL is Σ owned·P with no regime branch; the regime is a declared agreement term deciding *transaction shape* (D1–D5), never valuation. |
| E46 | **Cash collateral on receiver's own without a paired return-obligation unit** (return obligation held only in loan-unit state; Rule 15c3-3 reinvestment pattern) | RULING | D1/D5: title-transfer cash writes owned **plus** a return-obligation unit valued at the inflow amount (par plus accrued at the declared rate). |
| E47 | Lent securities retained on lender's own with an onloan marker (IFRS 9 §3.2.6 reading); "wallet structure identical under every regime" | RULING | SBL corollary of D2 (entailed, not open): under title transfer, owned re-books to the taker at instruction; the lender holds a per-netting-set claim-for-equivalent plus the redelivery obligation; regimes differ in transaction shape. |
| E48 | P14 (locate drawdown) and P19 (140% rehyp cap) as standalone structural guards | RULING | Restated: both return inside the single **coverage invariant** (Σ posted ≤ max(owned,0), per (wallet, unit), net over agreements) plus obligation-form sufficiency. Successors live in the v15 invariant catalogue. |
| E49 | P20 avail identity and derived projections *as stated on six coordinates* | RULING | Restated on the signed basis; avail/possess/encumb/re-used remain read-time projections (constitution §4), re-derived by the SBL chapter. |
| E50 | Sec17's manufactured-dividend leg as unconditional issuer pass-through / "leg absent when owner and beneficiary coincide" | RULING | Determination reads owned; payment routes through a conditional obligation unit whose *condition* may be vacuous — the leg never is. |
| E51 | On-lending cascade-recall saga mechanics (buy-in compensation detail) | COMP | *Worked-Examples Volume*; the obligation-with-compensation pattern is carried via sec16's obligation object **(R,** cap-driven**)**. |
| E52 | SBL CDM-gap inventory (Recall/Locate/Rehypothecation/tokenised-collateral eligibility) | COMP | *CDM Alignment Dossier* **(R)**. |

### S. sec18 — Invariants and PBT *(catalogue carried — constitutional scope item; P11–P20 restated per E48–E49; ruling adds coverage invariant, post-and-return metamorphic property with its watch-free side condition, TLA+ obligation)*

*No standalone exclusions beyond E1 (anchor code) and the restatements above.*

### T. sec19 — Regulatory obligations *(reports-as-projections carried — v14 framework stop)*

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E53 | Per-regime field inventories (EMIR Refit 203 / MiFIR RTS 22 65 / SFTR 155 / CFTC 43-45 field detail) | OOS | Submission gateways and report formatting are outside the boundary; carried instead: the projection principle, boundary enrichment, and the ruling's named reconciled surfaces (SFTR 2.73; Table 4 convention totality). |
| E54 | DRR production-status citation ("DRR 2025 Year in Review") | COMP | *CDM Alignment Dossier*; time-bound market fact, not specification content **(R)**. |
| E55 | BCBS 239 / DORA conformance mapping detail | OOS | Organisational conformance is external; the one-sentence substrate claim is carried **(R)**. |

### U. sec20 — Scope and limitations

*Carried in full (condensed): v14's "scope limits" stop; the constitution's scope section is the governing text.*

### V. sec21 — FAQ (appendix)

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E56 | The FAQ as an artifact (seven Q&A) | COMP | Each answer is now a consequence of constitutional text or a carried chapter (move-less events → §4; DvP → atomicity+§13; SBL-native → sec17-as-ruled; own-stored/avail-projected → §4; market-data duties → ingest door). Standalone FAQ to *Worked-Examples Volume* **(R)**. Note: "scalar sufficient for cash incl. cash collateral" is additionally RULING-superseded (D1/D5). |

### W. sec22 — Conclusion, open problems, and registers

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E57 | **Open-problems list** (netting/close-out algebra, correction algebra, federation/eliminations, XVA, bitemporal semantics, tax lots, impairment/ECL, GDPR Art 17, access control, repos, default management, pre-trade limits, migration, tokenised securities) | COMP | *Open-Problems & Escalation Register*, with a **one-page named index carried in v15** — the constitution requires implementation questions "named and left" **(R — flagged, see flag 3)**. Note: the ruling *moves* three items — close-out netting becomes load-bearing (per-netting-set claim units), issuer-default write-off becomes a named v15 obligation, settlement-state entitlement routing is now ruled, not open. |
| E58 | **Escalation registers F1–F8, ME1–ME5, FE1–FE2** (and F5) | COMP | *Open-Problems & Escalation Register*; collateral-touching items are RULING (replaced by the ruling's own named-obligations list, §5); FE1/FE2 are IMPL (E26). One register in v15 — the ruling's — not three inherited ones. |
| E59 | Mutation-score commitments (restated here) | COMP | See E12 — *Test Plan* **(R)**. |

### X. sec23–sec31 — Appendices

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E60 | sec23 — CDM type-mapping tables (Product→Unit, TradeState→state, BusinessEvent→Transaction, …) | COMP | *CDM Alignment Dossier*; v15 keeps the map's existence and the forgetful-map statement. |
| E61 | sec24 — Property-test catalogue (executable Haskell oracles for P1–P10, P24) | COMP | Executable test catalogue in the *Reference Implementation*; property statements stay in the v15 invariant catalogue. |
| E62 | sec25 — Reconciliation failure-mode taxonomy (full discussion) | COMP | The one-table summary (unreachable / detectable / by-design / remaining-operational) is a carry recommendation inside the thesis chapter; the extended discussion defers **(R)**. |
| E63 | sec26 — Cum/ex coordination code (`statePrice`/`fibreOK`) and mQuoteEx | IMPL / CONST | Code per E1; mQuoteEx per E22. The design content — state-aware pricing, "ex but amount unknown" unrepresentable — is a carry recommendation under the market-data-operator chapter (§14.2: estimates and entitlements kept apart) **(R — flagged, see flag 4)**. |
| E64 | sec27 — Glossary (~60 terms + C-index) | CONST | Vocabulary is fixed by the constitution ("one name per component, one component per name"); whether v15 carries its own index apparatus is KLEPPMANN's call **(R)**. |
| E65 | sec28 — CDM Product Model developer's guide (six-layer hierarchy, structured-note decomposition, tokenised units, date-handling gotchas) | COMP | *CDM Alignment Dossier*; the two load-bearing facts — Trade-including-Collateral = unit identity; tokenised custodian flat by conservation — are carried in the unit store and product-tour chapters. |
| E66 | sec29 — Eight-scenario avail-identity verification | RULING + COMP | The identities verify a superseded coordinate basis; scenarios A–H must be re-derived on the signed basis (scenario H's pledge PnL = coll_post×P is now *wrong* under D3) and land in the executable test catalogue. |
| E67 | sec30 — EU SBL worked example (GMSLA 2010, rehypothecation) *as written* | RULING + COMP | Mechanics superseded (coll_rehyp coordinate, own-retained lending, regime-switch PnL); a re-derived SBL example is carried in the v15 product tour (v14 stop); the full-length narrative defers to the *Worked-Examples Volume* after re-derivation. |
| E68 | sec31 — US SBL worked example (Rule 15c3-3, cash collateral) *as written*, incl. the cross-jurisdictional comparison table | RULING + COMP | Same as E67, plus E46; the comparison table's claim that regimes differ only in `legal_regime`/P19/PnL-projection is superseded — regimes differ in **transaction shape** (D1–D5) and PnL never branches. |

### Y. v14 — topics not carried as stated

| # | Topic | Disp. | Reason |
|---|---|---|---|
| E69 | v14's split collateral model (cash collateral on own via loan-unit state; securities on collateral coordinates; regime valuation switch) — option A of the ruling, present in v14's SBL stop and cash-flow treatments | RULING | The regime-keyed universal model (option C) replaces it; v14's trade-date booking (re-book at instruction) is the one element expressly *ratified* and carried (D2 timing). |
| E70 | v14's six-coordinate vocabulary wherever it appears | RULING | Signed three-basis with the five constitutional ray names (Amendment 3). |

*All other v14 stops are carried: orchestrator thesis; door/log; declared data (dimensions, adjustment schedule, datum-kind registry, operators); contracts and triggers; the product tour (equity+split, dividend forecast, futures, structured note, special dividend, spin-off, elective merger, SBL — the last re-derived per the ruling); regulatory reporting as projection; CDM alignment; executable claims; execution engine/liveness; scope limits.*

---

## CARRIED FORWARD (the register's complement — topic names only; chapters are KLEPPMANN's)

Keyed to the constitution's sections; v13.1/v14 origin in parentheses.

- **§1–2 Objective and commitments** — problem statement, six commitments, three unreachable internal breaks (sec02; v14 thesis).
- **§3 Map-then-fold architecture** — watch/contract/apply typed picture; events-as-inputs vs transactions-as-authority; trade/lifecycle identity (sec08; v14 door/log).
- **§4 Objects** — unit/wallet/move/transaction/log; valued vs non-valued; watches; virtual wallets and closure; per-(unit, coordinate) conservation; the **signed vector (owned, lent, posted)** and its five ray names; projections never stored (sec03, sec17-as-ruled; ruling §3).
- **§5 Machines** — Event Monitor, Events Executor, Transaction Executor; single writer; trust boundary; refusal on no-precedence (sec05 door, sec16 requirements).
- **§6 Smart contracts** — purity, statelessness, faithfulness; rounding/remainder discipline; every right and obligation a unit; subscription as exchange against a **valued redemption claim**; managed accounts/fees recast accordingly (sec07, sec11-as-amended).
- **§7 Three homes** — ProductTerms/UnitStatus/PositionState; placement rule; conditions C1–C14 restated; unit store, identity-by-fungibility, registration, two-stage validation (sec04, sec05).
- **§8 Valuation and PnL** — NAV, path-independent PnL, price/flow attribution, deposit neutrality via the three inflow cases; the ruling in full: **D1–D5, coverage invariant, determination/payment split, conditional obligation units, claim-for-equivalent per netting set, market claims at instruction, line valuation, regime-repair path, supervised write-off, lifecycle extinguishes value never mass**; balance-sheet substantiation as replay (sec06, sec12, ruling).
- **§9 Corporate actions and the market data operator** — the State-Basis core: boundary events, basis chain, tip and invariance welds, operator menu, dimension declarations, adjustment schedule (C14), datum-kind registry, ingest/stamping door, single-basis consumption (C13), CAClass, failure regimes W1–W4 **(R)**, cum/ex state-aware pricing **(R)** (sec09, sec26; v14 declared data).
- **§10 Strategies, virtual ledgers, TRS** — virtual-ledger mechanism, observation-not-move bridge, slippage-as-difference-of-folds, TRS as reset contract over stamped NAV (sec08/sec11 recast per constitution).
- **§11 Invariant catalogue** — P1–P10; P21–P23; P24–P34; coverage invariant and post-and-return metamorphic property (with watch-free side condition) as successors to P11–P20; PBT over the closed CDM generator universe; the TLA+ obligation for the knock–revalue–call–discharge race (sec18; ruling §5; v14 executable claims).
- **§12 Time travel and idempotence** — clone_at, bitemporal axes, corrections-as-events with `corrects` chains (sec08, sec13-principles).
- **§13 Two layers of correctness** — structural at the door; economic by recomputation; processor contract; the regime bit named as §13-invisible with its boundary detector and repair path (sec16; ruling D5).
- **§14 Minimum requirements** — Monitor/Executor requirements incl. obligation liveness and acknowledged watches; pricing-stack requirements; settlement projection (sec14); regulatory reporting as projection with the ruling's named surfaces (sec19-as-ruled); CDM alignment and the forgetful map (sec15); scope and limitations (sec20).
- **Product tour** (v14 stops, ~as v14): equity+split, dividend forecast, futures (sec10), structured note, special dividend, spin-off, elective merger, SBL re-derived on the ruling; the ruling's three micro-cases (STM margin; pledged coupon both regimes; one-touch knocked while pledged) as normative worked cases.
- **Ruling's named Phase 2 obligations** (carried as v15 obligations, not exclusions): cash-reinvestment convention totality; presentation projection (IFRS 7 §42D / FINREP) built and audited; SFTR 2.73 sourcing; encumbrance/intraday join; supervised write-off; per-netting-set registry growth accepted.
- **Recommendation carries** (neither constitution nor ruling speaks; CARTAN recommends carrying condensed): dual valuation MtMk/MtMd (sec12); reconciliation-taxonomy summary table (sec25); locate machinery P26 + EU SSR/Reg SHO inside the SBL chapter (sec17); one-page open-problems index (sec22); TA-BASIS/TA-KIND trust assumptions (sec09).

---

## GENUINELY CONTENTIOUS CUTS — for the owner at the gate (max 5)

1. **Dual valuation (MtMk vs MtMd), sec12.** No constitutional sentence and no v14 stop covers it, yet margin/settlement vs risk pricing over one position set is load-bearing (the Nikkei three-venue case) and the "single position set, two money figures" claim is the substantiation chapter's sharpest tooth. If the cap forces it out entirely, it has no home. *Recommendation: carry as one page in the valuation chapter.*
2. **Failure regimes W1–W4 and the F1–F10 fault catalogue, sec09.** The constitution says "defaults fail closed" in one sentence; W1–W4 (block / quarantine / flagged-stale carry / notice attestation with the two-source rule) are the only normative statement of *what* fail-closed means at the data boundary. Pushing all of it to a companion leaves refusal behaviour underspecified. *Recommendation: carry W1–W4 normatively; defer F1–F10 as catalogue.*
3. **The open-problems list, sec22.** Cutting it silently would violate the constitution's own promise that implementation questions are "named and left." Moreover the ruling has made **close-out/netting algebra** load-bearing (per-netting-set claim units exist to get close-out right) while its algebra remains undesigned — that item can no longer sit in an unshipped companion without a named pointer. *Recommendation: one-page named index in v15; full register in companion.*
4. **Cum/ex state-aware pricing, sec26.** "Ex but amount unknown is unrepresentable" and the pricer-total-over-(u,q,d) fibre condition are correctness content only partially implied by §14.2's "estimates and entitlements are kept apart." If dropped with the appendix, the dividend-forecast tour stop loses its formal footing. *Recommendation: fold into the market-data-operator chapter.*
5. **Locate machinery (P26, admission-position-indexed weld; EU SSR / Reg SHO), sec17.** Neither the constitution nor the ruling mentions locates; the ruling's coverage invariant subsumes the *drawdown* guard (P14) but not the pre-trade locate object, its TTL-unit model, or the venue-keyed regulatory taxonomy. If the SBL chapter drops it under the cap, short-selling admissibility has no home. *Recommendation: carry condensed in the SBL chapter.*

— End of register —
