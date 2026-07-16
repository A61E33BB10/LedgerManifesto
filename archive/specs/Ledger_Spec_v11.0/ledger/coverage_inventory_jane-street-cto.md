# Coverage Inventory — v10.3 → v11.0 (jane-street-cto lens)

Governing rule: **drop the path, keep the substance.** Every result, invariant, instrument,
law, and appendix of v10.3 that is still valid must land somewhere in v11.0 (kept, compressed,
or superseded), never silently dropped. Scope of folding: recent thread only (three-home
state model, corrected UnitStatus, futures lifecycle, managed-account workflow). Satellite
specs (valuation, market-data, deferred-settlement, data) keep v10.3's compressed treatment
plus a pointer; do not consolidate.

I read the v10.3 base in full coverage (all 27 sections), the folded-in `States.tex`,
`FutureLifeCycle.tex`, `managed_account_workflow.tex`, `addendum_stateshome_v2.tex`, and the
two Haskell references `StatesHome.hs` and `FutureLifeCycle.hs`.

---

## The UnitStatus correction (authoritative)

v10.3 repeatedly phrases unit state as a *mutable per-unit state dictionary* (line 1034:
"the state dictionary is per (wallet, unit) pair"; §7.3 "explicit state dictionary"; line 2287
`get_unit_state(w,u)`). The recent thread corrects this: **UnitStatus is a materialised
projection of the immutable event log — a read cache the log always rebuilds — not an
authoritative mutable store.** Every change is caused by a logged event; the stored cell is
overwritten in place only as a cache; replay rebuilds the exact value. This correction is
authoritative over any "mutable" phrasing in v10.3. It must be applied wherever v10.3 speaks
of unit state being set/mutated (notably §3 Unit Store `unit_state`, §7 Lifecycle, §8
substantiation, §14 obligation store). The addendum explicitly supersedes line 1034 and 2287.

---

## Per-section disposition (the 27 sections)

**§1 Introduction (54–110).** KEPT, compressed. The six by-construction properties
(atomicity, conservation, determinism, state-sufficiency, lifecycle value invariance with the
optionality qualification, time travel) are substantive and must survive verbatim in result-
first form. The roadmap paragraph (107) is pure path → REMOVE; regenerate from the v11 TOC.
The CDM-layers preview duplicates §11/App 24 → fold to one pointer.

**§2 The Closed Ledger System (111–299).** KEPT. Wallet, unit, move, transaction, conservation
law, System Closure theorem, virtual wallets, initialisation, books/reference wallets, Self-
Consistency principle, the three internal-break impossibilities, Herstatt note. This is the
spine. Haskell weave point: `Qty` monoid/group, `Move`, `applyMove`, conservation as
`negQty q <> q = mempty` (from `States.tex`/`StatesHome.hs`). The TikZ wallet-flow figure is
illustrative → keep one, drop duplicate prose.

**§3 The Unit Store (300–493).** KEPT, compressed. Unit Identity principle (fungibility),
OTC-vs-listed table, three-tier architecture, registration channels, two-stage validation,
four guarantees, CDM alignment. SUPERSEDE the `unit_state`/`lifecycle_stage` field of
`UnitEntry` (407–409) per the UnitStatus correction and the three-home model: the unit's
state is no longer a mutable dictionary on the registry row but (ProductTerms, UnitStatus,
PositionState). C7/C10 (registration-total, no re-registration) from the addendum land here.

**§4 Portfolio Valuation and PnL (494–603).** KEPT (satellite: valuation). Mark-to-market
definition, state-sufficiency, Path-Independent PnL theorem, PnL attribution + numerical
example. Per owner's scope this KEEPS v10.3's compressed treatment with a pointer to the
standalone valuation spec; do not expand. Quantity-vs-value conservation distinction is
load-bearing and stays.

**§5 Smart Contracts as Move Generators (604–805).** KEPT, compressed. Contract definition
(determinism, fixed-precision decimal), modular-vs-composite recommendation, equity/dividend/
corporate-action contracts, European put full move schedule, lot-size delivery, IRS move
schedule. The two full move-schedule worked examples are substantive (they show conservation
on concrete instruments) → keep, but trim duplicated prose. Decimal-arithmetic requirement is
superseded in the Haskell thread by exact `Integer` minor units (a correctness improvement,
note it).

**§6 Managed Accounts, Virtual Portfolios, and TRS (806–977).** SUPERSEDED by
`managed_account_workflow.tex`. v10.3 §6 is the informal version; the workflow note is the
derived, corrected, escalation-bearing version (mandate-as-unit, fee logic net of flows,
HWM ratchet, segregation as CONS∧LOC∧C4 theorem, TRS equivalence theorem, redemption,
account-level substantiation, conformance flags, escalations E1–E5). Carry the workflow note's
substance; keep v10.3 §6's CSA-margin-as-wallet-contract and mandate-guard material where the
note does not already subsume it. The "every wallet is a managed account" framing stays.

**§7 Lifecycle Management (978–1482).** KEPT but heavily reworked. Substantive and surviving:
motivation (generality beyond pricing, idempotence, time travel), lifecycle-as-transactions,
lifecycle-event-as-pure-function, the futures accumulated-cost method + full ALPHA/CH worked
example, QIS lifecycle, time-travel challenges (4 cases), clone/clone_at, the Executor (sole
mutator), purity principle, embedded defence, lifecycle risk-profile table. SUPERSEDED: §7.3
"Unit State as Explicit Object" (line 1034) by the three-home model and the UnitStatus
correction. The futures section here is the *informal* version of `FutureLifeCycle.tex` —
reconcile: keep one authoritative futures treatment (the corrected lifecycle with the
`Active (Maybe Settlement)`/`Expired Settlement` fuse, monotone absorbing stage, Close), weave
`FutureLifeCycle.hs`. The ALPHA/CH numerical example and the ES-FUT A/B/C example are both
substantive; prefer the A/B/C example (it runs through Close and tests intraday VM), keep the
ALPHA/CH direction-reversal point.

**§8 Balance Sheet Substantiation and Dual Valuation (1483–1600).** KEPT (satellite overlap).
Move-stream-as-source-of-truth balance formula, substantiation-as-projection, reconciliation
failure taxonomy (3 unreachable + 6 detectable), dual valuation framework, multi-exchange
futures example, FVA, internal trade flexibility, snapshots. Dual valuation is a valuation-
spec satellite → keep compressed with pointer. Apply UnitStatus correction to any "cached
state" phrasing (the substantiation argument is actually strengthened by it).

**§9 Implementation and Operations (1601–1684).** KEPT, compressed. Three-layer architecture
(move stream / aggregation / wallet state as cache), balance-update algorithm, PnL efficiency,
fault tolerance (late events, duplicates, contradictory external state, stale market data,
stream integrity, partial failures, corrections-as-events), ledger→settlement-instruction
projection, ISO 20022 interface. Corrections-as-events and dual-timestamp are substantive.
This section reinforces the UnitStatus correction (wallet state IS a rebuildable projection).

**§10 The Settlement Layer Interface (1685–1888).** KEPT, compressed. Settlement projection
(pure, deterministic, idempotent, total on SETTLEMENT), settlability classification, DvP
atomicity, netting at boundary, confirmation return path. Deferred-settlement is a satellite →
keep compressed with pointer to the standalone deferred-settlement spec.

**§11 ISDA CDM Integration (1889–2017).** KEPT, compressed. What the CDM is (5 components),
running AAPL-call example, why-CDM (products-as-units, event-model-as-state-graph, embedded
logic, mapping layer), synonym layer, the forgetful mapping F (what it preserves/forgets),
enums-as-generator-universe. Substantive; trim the duplicated AAPL narration shared with
App 24.

**§12 Invariants, Conservation Laws, and PBT (2018–2168).** KEPT — becomes the consolidation
hub. The ten core invariants P1–P10, conservation-as-test-oracle, invariants-as-specification,
the ten property-based tests, CDM-enum generator universe, EventIntentEnum/OptionTypeEnum
completeness, specification-first. v11.0 should make this the single home that also references
SBL P11–P20, obligation P21–P23, and the addendum conditions C1–C12 and the "invariants made
unrepresentable" mapping (P1,P3,P5,P6,P7,P9,P10 discharged by the type encoding). Weave
`validate`/`ValidDelta` (C2), `NonEmpty` (P6), monotone carrier (P3), `FieldWrite` GADT (P10).

**§13 Regulatory Obligations and the Direction of Travel (2169–2188).** KEPT, compressed. DRR
production metrics, CDM-as-industry-standard, convergence trajectory, framework alignment,
DORA/BCBS 239. Largely current-events prose → compress to the load-bearing alignment claims;
keep dated facts as a short note. The mandate-issuance reportability question is resolved in
the managed-account workflow (F5 discharged) → cross-reference.

**§14 Orchestration: Temporal.io (2189–3421).** LARGE; mostly path. COMPRESS hard, keep the
substance:
  - SUBSTANTIVE / KEEP: the four orchestration requirements (exactly-once, durable timers,
    deterministic replay, single-writer); executor-as-activity (idempotency contract); two
    audit trails (economic log vs orchestration history); the Due-Event Scheduler (resolves
    the liveness gap); Concurrency Model: single-writer by construction; **Obligation
    Liveness** subsystem in full — Obligation type/definition, taxonomy table, obligation
    store (a view over the log — consistent with UnitStatus correction), registration,
    workflow, **invariants P21 (liveness), P22 (conservation), P23 (idempotency)**, the
    five-lemma liveness proof, liveness–safety composition, the two worked examples (CSA VM
    call, SBL collateral substitution), relationship to SBL invariants, assumptions/limits.
  - PATH / REMOVE or reduce to a pointer: per-instrument workflow code listings (futures/bond/
    option/IRS/SBL), saga code, task-queue/worker architecture, retry/timeout policy tables,
    corporate-action fan-out code, deterministic-replay-alignment mechanics, idempotency-chain
    walkthrough, versioning/ContinueAsNew/history-management, CDM activity mapping table,
    "implementation team profiles." Temporal is one valid execution engine, not a result;
    state the requirements it satisfies and keep ~one illustrative workflow, drop the rest.
  This is the single biggest page saving in the document.

**§15 Generalised Positions and SBL (3422–4238).** KEPT, compressed. Substantive core:
scalar-model-breakage motivation, the six-coordinate position vector, Single-Coordinate Move
principle, available-inventory projection, graceful degeneration to scalar, named-wallet
lending resolution, conservation in the generalised model (five-term form), SBL smart contract
+ representability, SBL state machine, atomic moves per lifecycle event, title-transfer vs
security-interest, collateral/margin, short selling, external reconciliation, CDM/regulatory
alignment, cash-collateral reinvestment, on-lending chains, locates, cross-border treatment,
**invariants P11–P20**. The 20-day worked example (4171–4203) is substantive (verifies P13/
P18/SFTR step by step) → keep but tighten. Temporal-workflows-for-SBL subsection → fold its
substance into §14's compressed orchestration, drop the code.

**§16 Scope and Limitations (4239–4304).** KEPT, compressed. Ledger boundary, what the
framework does not do, theorems-vs-modelling-choices, architecture-vs-operational-reality.
Merge with §1's boundary paragraph to state the boundary once.

**§17 Conclusion (4305–4387).** KEPT, compressed. Summary, four design goals revisited, self-
consistency-as-standard, benefits, **Open Problems** (netting/close-out, concurrency
[resolved], liveness [resolved], correction algebra, multi-entity federation, XVA, bitemporal,
tax lots, impairment/ECL, GDPR, access control, repos, default management, pre-trade
validation, migration, tokenized securities). Open Problems list is substantive (the agenda)
→ keep as a tight list; drop celebratory prose. Note the managed-account escalations E1–E5 and
the Nazarov attestation finding belong on this agenda.

**§18 Frequently Asked Questions (4388–4516).** KEPT, compressed. Substantive Q&A on
settlement, knock-out events, DvP atomicity, physical delivery with lot size, scalar
sufficiency of cash, SBL companion-system rejection (5 reasons), reinvestment under title
transfer vs pledge. Keep the answers that carry a result; drop any that merely restate body
prose.

**App §19 CDM Type Mapping Tables (4520–4547).** KEPT. Reference tables; compact already.

**App §20 Property Test Catalogue (4548–4582).** KEPT — merge into §12 (consolidation hub) or
keep as the executable-spec appendix to §12. P1–P10 executable forms + SBL P11–P20 pointer.
Do not duplicate the prose statements that already live in §12.

**App §21 Reconciliation Failure Mode Taxonomy (4583–4620).** KEPT. The full break taxonomy
(3 unreachable, 6 detectable, operational residue). Overlaps §8's shorter taxonomy → keep the
full appendix table, make §8 point to it.

**App §22 Coordination Between Pricing, Contract State, Market Data (4621–4686).** KEPT
(satellite: market-data). Coupon/dividend double-count problem, atomic-lifecycle-event
solution, state-aware pricing. Per scope this is the market-data satellite → keep compressed
with pointer to the standalone market-data spec. The atomic-lifecycle argument reinforces C3.

**App §23 Glossary (4687–4739).** KEPT. Add terms introduced by the recent thread (ProductTerms,
UnitStatus, PositionState, StateDelta, ValidDelta, Obligation, the C1–C12 conditions, PosQty).

**App §24 The CDM Product Model — A Developer's Guide (4740–6231).** LARGE; developer guide.
COMPRESS hard. Substantive to keep: the 6-layer hierarchy (Observable → Payout → EconomicTerms
→ NonTransferableProduct → TradableProduct → Trade) with the "where unit identity crystallises"
result, the mapping table, and the framework-implications. The three-instrument parallel walk,
the structured-note Payout-composition example, the tokenized-NVDA model (double-counting
resolution, custodian-is-flat, 4 CDM gaps), and the date-handling taxonomy are each long
teaching expositions → compress to the load-bearing results (unit-identity crystallisation
point; structured-note tests Payout composition + TransferableProduct boundary; tokenized
double-counting + custodian-flat principle + the 4 gaps; date taxonomy + resolution chain +
gotchas). Drop the step-by-step Rune/CDM listings; keep one worked instance per concept. This
is the second-biggest page saving after §14.

**App §25 Available Inventory Identity: Eight-Scenario Verification (6232–6352).** KEPT,
compressed. Verifies P20 (avail = own − onloan + borr) across 8 scenarios. Since P20 is a
definition (avail never stored), this is a worked confirmation → keep a compact table of the
8 scenarios rather than full prose per scenario.

**App §26 European SBL Worked Example (GMSLA 2010) (6353–6860).** KEPT, compressed. Full
title-transfer lifecycle with non-cash collateral, rehypothecation, MTM, manufactured
dividend, partial recall, full return, conservation at each step. Substantive (it is the
correctness demonstration for §15 under GMSLA) → keep the move tables and conservation checks;
trim narrative. Compress by showing the six-coordinate vector deltas tabularly rather than in
prose.

**App §27 US SBL Worked Example (SEC 15c3-3) (6861–7314).** KEPT, compressed. US counterpart:
cash collateral, rebate mechanics, rehyp caps (140%), FINRA SLATE reporting, partial recall,
full close-out, cross-jurisdictional comparison table. Same treatment as §26: keep tables +
conservation, trim narrative. The cross-jurisdictional comparison table is a result → keep.

---

## Haskell weave plan (woven, not appended)

- **§2 Closed Ledger**: `Qty` semigroup/monoid/group, `negQty`, `Move`, `applyMove`,
  conservation as a monoid identity. (`States.tex`, `StatesHome.hs`.)
- **§4 (state-home) Where Unit State Lives** (new core): `ProductTerms` (`NonEmpty`, abstract,
  `appendVersion` — C6/C7), `UnitStatus`/`Lifecycle` with the projection-of-log discipline and
  `applyStatus` closed writer set (C5, UnitStatus correction), `PositionState`/`zeroP` +
  Option accessor + monotone carrier (C1), the sealed `Ledger`, `register`/`applyDelta`/
  `replay`, `StateDelta`/`ValidDelta`/`validate` (C2/C3), `FieldWrite` GADT (C11), `amend`
  two-track (C8). (`StatesHome.hs`, `addendum_stateshome_v2.tex`.)
- **§7/§8 Futures lifecycle**: `Qty`/`Cash`/`Price` three dimensions, `markValue` bridge, the
  `Stage = Registered | Active (Maybe Settlement) | Expired Settlement` fuse, `stageRank`/
  `isExpired` monotone-absorbing, `settlementFanout`, `closeDelta`, `PosQty` parse boundary,
  `handle`/`step`/`replay`. (`FutureLifeCycle.hs`.)
- **§9 Managed accounts**: the issuance-law move, fee-crystallise double-entry, HWM `qmax`
  ratchet (reuse `PositionState`/`FieldWrite 'FeeCrystallise`), TRS-as-same-primitive.
  (`managed_account_workflow.tex` + `StatesHome.hs` field writers.)
- **§ Invariants**: `validate`/`ValidDelta` (C2/P1), `NonEmpty` (P6), monotone carrier (P3),
  Kleisli `>=>` replay homomorphism (P3 determinism), `FieldWrite` (P10).
- Everywhere else (CDM, SBL, Temporal/obligations): no new Haskell; reference the types above.
  SBL six-coordinate vector could optionally be sketched as a record but is not required.

---

## Biggest compressions (page budget)

1. **§14 Temporal (≈1230 lines).** Strip ~70–80% of code/mechanics; keep requirements,
   executor-as-activity, due-event scheduler, single-writer, and the entire Obligation
   Liveness subsystem (P21–P23, proof, two worked examples). Largest single saving.
2. **App §24 CDM developer's guide (≈1490 lines).** Compress the 6-layer walk, structured-note,
   tokenized-NVDA, and date-handling to their results + one worked instance each; drop the
   listings. Second-largest saving.
3. **App §26/§27 SBL worked examples (≈1000 lines combined).** Tabular move/coordinate deltas
   + conservation checks; trim narrative.
4. **Cross-document dedup.** Reconciliation taxonomy (§8 vs §21), AAPL CDM narration (§11 vs
   §24), the futures example (§7 vs FutureLifeCycle), invariant statements (§12 vs §20),
   managed-account (§6 vs workflow note), boundary (§1 vs §16) — state once, point elsewhere.
5. **Path removal.** §1 roadmap, derivation history, "alternatives considered" (addendum §pareto
   — keep the *result* row that B dominates, drop the scoring narrative), iteration logs.

---

## Risks (where completeness vs budget is hardest)

- **§14 over-cut.** The obligation P21–P23 subsystem, the due-event scheduler, and the single-
  writer resolution are easy to lose if "drop Temporal mechanics" is applied bluntly. They are
  substance and must survive even as the Temporal code goes.
- **Two futures treatments must merge cleanly.** §7's ALPHA/CH example and FutureLifeCycle's
  A/B/C example overlap; merging risks dropping the direction-reversal case or the intraday-VM
  correctness point (the −100-not−300 result). Keep both results.
- **Satellite boundary discipline.** Valuation (§4), market-data (§22), deferred-settlement
  (§10), data — must be compressed-with-pointer, not expanded and not deleted. Easy to either
  over-trim (losing the load-bearing definitions like Path-Independent PnL) or over-keep.
- **UnitStatus correction must propagate.** Every "mutable state dictionary" site (§3 UnitEntry,
  §7.3, §8 cache phrasing, §14 obligation store) needs the projection-of-log wording, not just
  the new §4. Missing one reintroduces the contradiction the amendment fixes.
- **Invariant consolidation completeness.** P1–P10, P11–P20, P21–P23, and C1–C12 must all be
  present and cross-linked in one hub; the "made unrepresentable" mapping (which invariant each
  type discharges) is the highest-value content and the easiest to drop as "meta."
- **Addendum risk register / testing commitments / escalations.** F1–F8 risks, the mutation-
  score commitments, and managed-account escalations E1–E5 + Nazarov attestation finding are
  substantive open items; they belong in Open Problems / a risk appendix, not the cutting-room.
