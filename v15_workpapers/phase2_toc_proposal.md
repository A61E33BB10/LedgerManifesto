# Phase 2 Proposal — v15 Table of Contents, Page Budgets, and the Six-Thread Map

**To:** R. Delloye, project owner — for ratification
**From:** KLEPPMANN, lead author, core architecture chapters
**Date:** 2026-07-11
**Authority:** Ordered by the arc of the Ledger Framework Constitution v1.1 (with the three
collateral amendments). Every named Phase 2 deliverable of the ratified Phase 1 Design
Ruling has a home below. v15 is a first-version document: its text cites the constitution
only, never a predecessor; each chapter opens by naming the constitution sections it
discharges. Hard cap 100 pages; the chapter budgets below sum to exactly 90, leaving the
10-page reserve intact for Phase 4.

Conventions adopted throughout this proposal:

- **Threads, not sections.** The six running examples recur inside chapters as *episodes*.
  Every episode keeps one fixed five-part shape (adapted from the worked-product form that
  proved itself): the trigger; the contract that catches it; the transaction it produces,
  as numbered rows with exact quantities; what the door checks; the design point it
  substantiates. Instruments and numbers are fixed once, in section 3, and never vary.
- **Haskell policy.** Typed signatures and law statements only, ≤ 10 lines per snippet, no
  function bodies beyond one-liners. No chapter below promises code-heavy treatment; the
  reference implementation is out of the specification's page budget entirely.
- **GROTHENDIECK** holds no chapter. He contributes marked, non-normative *second-telling*
  boxes (the map/fold as catamorphism; operator composition as a functor law; conservation
  as a homomorphism) inside Chapters 2, 8, and 14, within those chapters' budgets.
  Deleting every box leaves the specification complete.

---

## 1. The Table of Contents

### Ch. 1 — The Objective and the Commitments — **4 pp** — KLEPPMANN
Discharges constitution **§1, §2**. Threads: none (the cast is introduced in Ch. 2).

States the problem (the same fact stored more than once), the removal of its cause (one
canonical record; every other number a projection), and the six commitments, each with the
one sentence of consequence it forces on the rest of the document. Closes by stating the
document's own discipline: chapters open by naming the constitution sections they
discharge, and six running examples recur with fixed instruments and fixed numbers.

### Ch. 2 — The Picture: Map, Then Fold — **6 pp** — KLEPPMANN
Discharges **§3**. Threads visiting: **one-touch** (full pipeline walkthrough, now with
the fixed numbers), **future** (watch declaration, one line).

The whole architecture in one picture: E = [e] → T = [tx] → Ledger; data, functions,
machines; the typed arrows; the clock as the single off-record input; proposal versus
authority; the contrast with event sourcing. Introduces the six-thread cast in a half-page
table (instrument, owner, fixed numbers) so every later episode is recognisable on sight.
The one-touch walks the three arrows end to end, exactly as the constitution walks it,
with the payout now 1,000,000 USD.

### Ch. 3 — The Objects — **7 pp** — KLEPPMANN
Discharges **§4 as amended** (including Amendments 2 and 3). Threads visiting: **future**
(unit, terms, declared watches), **variance swap** (252 declared fixing watches at
registration), **TRS** (non-valued strategy unit; the TRS as an ordinary unit), **split**
(terms change as a transaction component).

Units (valued and non-valued), terms/state/contracts, watches; wallets, manager and
beneficial owner; the atomic move; the transaction as the four-kind bundle; the immutable
log and the log/ledger/record vocabulary; closure by virtual wallets. Defines the signed
coordinate vector **(owned, lent, posted)** with the five constitutional names as its
rays, and the mass-never-value sentence — definition only; agreement semantics, the two
guards, and the regime key are Ch. 9's. Budget note: this chapter defines every object
*and* works four short thread episodes; 7 pages is the floor, not a comfort.

### Ch. 4 — The Machines — **5 pp** — KLEPPMANN
Discharges **§5**. Threads visiting: **one-touch** (one event, three machines, one write;
duplicate emission harmless), **dividend** (the watch handshake: declared → armed → fired).

Event Monitor, Events Executor, Transaction Executor; three roles, one writer; the trust
boundary; integrity owes the untrusted machines nothing, liveness is conditional on them;
refusal over guessed order for non-commuting simultaneous events.

### Ch. 5 — Smart Contracts — **6 pp** — KARPATHY
Discharges **§6**. Threads visiting: **dividend** (three firings, three transactions, one
stateless contract — the chapter's spine), **future** (daily settlement-print firing;
expiry unwind), **one-touch** (the touch contract reads terms and holder, returns one
transaction), **variance swap** (firing *k* finds fixings 1..k−1 on the record — a
contract never waits and never remembers).

Contracts as pure, stateless, machine-readable transcriptions of legal terms; everything a
contract consumes is on the record; every right and obligation the legal contract creates
is a unit; idempotence via the cause-derived identifier.

### Ch. 6 — State: The Three Homes — **5 pp** — KLEPPMANN
Discharges **§7**. Threads visiting: **future** (settlement price in UnitStatus, applied
margin in PositionState, multiplier in ProductTerms — one event, one home), **variance
swap** (the *three-homes sufficiency requirement*: the accrued fixing statistic is a
UnitStatus fact written by each fixing's firing, so firing 127 finds its entire context on
the record), **dividend** (recorded entitlement in PositionState), **split** (a new
ProductTerms version).

ProductTerms, UnitStatus, PositionState; one home per fact, one legal writer per fact; all
three rebuildable by replay; the homes plus balances carry everything the contracts need.

### Ch. 7 — Valuation and Profit and Loss — **6 pp** — GATHERAL
Discharges **§8 as amended** (Amendment 1). Threads visiting: **future** (cumulative VM =
PnL; path independence), **one-touch** (state-parameterised price: 400,000 before the
touch, 0 after — value collapses, mass does not), **variance swap** (mid-life value from
the accrued statistic plus remaining implied variance, both from the record), **TRS**
(the reference leg is a NAV projection).

NAV operationally then formally; PnL as NAV variation, path-independent, no second copy of
realised PnL; state-parameterised pricing; the three inflow cases keyed to the declared
legal regime of the governing agreement, with the fact deposit-neutrality depends on: the
case-2 return obligation is a valued unit priced at the inflow amount. Derives the
pricing-stack requirements that Ch. 16 restates as minima.

### Ch. 8 — Ingestion, Corporate Actions, and the Market Data Operator — **6 pp** — NAZAROV
Discharges **§9**. Threads visiting: **split** (the chapter's spine: the operator menu —
spot scales, cash-per-share dividend figures scale, proportional figures stand; originals
never overwritten, adjustment computed at read), **dividend** (announcement captured at
the boundary; the declared 1.50 forecast scales to 0.75 under the split — one operator,
one invariant, visible), **TRS** (the stamped NAV observation enters as an observation
with provenance; the bridge between ledgers is an observation, never a move), **variance
swap** (fixing source: the recorded official closes, deterministic and replayable at the
data boundary).

Corporate actions as ordinary transactions; the operator intrinsic to the (data-kind,
event-kind) pair, declared once, never improvised at read; ledger authoritative, pricing
data layer applies. Declares the *slot* for boundary conventions stated once as data —
the attribution convention consumed by Ch. 12 lives in this slot.

### Ch. 9 — Collateral, Margin, and Lending — **10 pp** — MINSKY
Discharges the amended clauses of **§4 and §8**, and **§6** for agreement units.
Implements the ratified Phase 1 ruling in full. Threads visiting: **one-touch** (the
chapter's centrepiece: micro-case (c) worked start to zero-vector retirement — knock on
the record, determination from the owned plane, conditional payment obligation with the
agreement's trapping terms, 1,000,000 discharged as 850,000 free plus 150,000 posted,
marker return before extinguishment), **future** (D5: settled-to-market as §8 case 1; the
CTM contrast is one declared term and one obligation unit of difference, not a different
machine), **dividend** (determination/payment split in the unencumbered case: the
conditional obligation's predicate is vacuous and discharges at once — the condition
vanishes, never the leg).

The regime key (D1–D5): title transfer writes owned plus claim and obligation units,
re-booked at instruction; pledge writes marker mass, owned untouched; the four cash-margin
cases, total; per-netting-set claim units priced by the taker's state; line valuation as
the default. Sufficiency is an obligation, coverage is an invariant — the contrast is
*used* here and *catalogued* in Ch. 14. Named ruling obligations homed here: the
**supervised write-off path** (issuer-default lifecycle event permitting marker-plane
clearing against explicit loss recognition); the regime bit as §13-invisible,
boundary-detected, repaired by terms amendment plus compensating rebooking; the SBL
corollary (the lent plane by the same derivation). Budget note: 10 pages is realistic only
because the guards' formal statements live in Ch. 14 and the temporal race in Ch. 15.

### Ch. 10 — Virtual Ledgers, Strategies, and the Total Return Swap — **5 pp** — KARPATHY
Discharges **§10**. Threads visiting: **TRS** (the chapter's spine: the strategy rulebook
as a non-valued unit's terms; W-QIS rebalances inside virtual ledger V-1; the level is a
NAV projection; the TRS contract reads the stamped observation at each reset and emits the
reset and financing moves — 300,000 against 100,000, net 200,000).

A virtual ledger as a complete instance of the same machine, subject to the same six
commitments; the two disciplines (bridge = observation, wall level by level); real
execution, benchmark wallet, slippage as the difference of two folds.

### Ch. 11 — The Settlement Interface — **5 pp** — KLEPPMANN
Discharges the Scope bullet "the settlement-projection layer" and cites **§3** (projection)
and **§4** (the record). Threads visiting: **dividend** (the 15,000 payment projects to a
cash instruction), **future** (daily VM cash to instruction; the expiry unwind), **split**
(moveless — projects to nothing, by construction).

The projection of committed activity into settlement: pure, total, deterministic,
idempotent; the ledger says *what* settles, the settlement layer *how*; settlement failure
is a recorded event, never a reversal. Homes the ruling's **settlement-state and
market-claim machinery**: owned re-books at instruction; where a record date falls in the
instruction-to-settlement gap, the market claim is a first-class recorded obligation unit
— settlement-state is load-bearing for entitlement routing, a correctness requirement,
not a reporting axis. (Content per the ratified ruling, D2; see open question 1 on
authorship.)

### Ch. 12 — Presentation and Reporting Projections — **4 pp** — MINSKY
Discharges **§1/§3** (reports as projections) and **§2** (auditability, reproducibility).
Threads visiting: **one-touch** (the pledged unit in the encumbrance projection before the
knock; mass visible, value collapsed after).

The named ruling deliverable: every reporting figure reads coordinates, units, and declared
terms alone — no second store. The presentation projection (transferred-asset/associated-
liability from claims and regimes; encumbrance from posted rays and financing claims;
receiver-side actuals from source-tagged re-pledge references). Homes the
**attribution-convention totality** obligation: the convention is a total function of log
state — pool predicate, ratio basis, rounding rule with explicit remainders — declared
once as data in Ch. 8's slot and consumed here; the genuinely reconciled surface (net-
exposure collateralisation sourced from the governing agreement) named beside it. Property
tests over the projections; auditor sign-off before freeze is a Phase 4 gate, recorded
here.

### Ch. 13 — Alignment with the Common Domain Model — **3 pp** — MATTHIAS
Discharges **§6** (machine-readable legal terms) and the **§2 Clarity** commitment;
alignment shown, never adopted as authority. Threads visiting: **variance swap** (payout
and fixing-observation representation), **TRS** (two-legged representation; reset as a
recorded business event).

The declared-data vocabulary mapped to the CDM's product and event models; eligibility-as-
declared-data as the collateral model restated; the closed enumerations as a generator
universe for Ch. 15. Gaps stated as gaps.

### Ch. 14 — The Invariant Catalogue — **6 pp** — NOETHER
Discharges **§11 and §12**. Threads visiting: **future** (VM zero-sum *is* per-(unit,
coordinate) conservation), **split** (consistency of reference: 20,000 × the stale 100.00
is a phantom 2,000,000 against a true 1,000,000 — refused), **one-touch** (coverage on the
discharge transaction: owned cash 1,000,000 ≥ posted 150,000; lifecycle extinguishes value,
never mass; retirement only from the zero vector).

Every invariant stated once, as an executable property: conservation per (unit,
coordinate), with issuance and retirement as paired-leg moves and the proof by induction on
the log; atomicity; consistency of reference; writer discipline; append-only and
hash-chained; determinism of every arrow; idempotence under the cause-derived identifier;
time travel and replay (§12) as theorems of the fold. Canonical home of the **coverage
invariant and the two-guard contrast**: possession coverage is never lawfully false and is
an invariant checked at the door; value sufficiency is lawfully false intraday and is an
obligation with deadline, discharge predicate, and close-out as compensation. The
post-and-return metamorphic property with its watch-free side condition.

### Ch. 15 — Testability and the Executable-Check Regime — **6 pp** — WILSON
Discharges **§13** and the **§2 Testability** commitment. Threads visiting: **one-touch**
(the **TLA+ obligation**: the knock–revalue–call–discharge interleaving carries a
safety/liveness model — the temporal residual the move algebra does not own), **variance
swap** (replay determinism: regenerate firing 127 from recorded fixings and compare),
**future** (duplicate settle event inert; late firing produces the identical transaction).

The two layers of correctness: structural by construction at the door; economic by
recomputation — re-run the map on the recorded event and compare, defects repaired by
compensating transaction through the same door. One generator universe over the closed
enumerations; properties, oracles, and the invariants of Ch. 14 as the test surface; the
binding conditions (moves as sole balance mutator; the TLA+ model; deterministic barrier
observation) stated as executable gates, not intentions.

### Ch. 16 — Minimum Requirements — **4 pp** — NAZAROV
Discharges **§14.1 and §14.2**. Threads visiting: none (requirements chapters cite thread
episodes; they do not re-run them).

The Event Monitor and Events Executor minima: durable watches and timers, at-least-once
emission, acknowledged watches, triggers carry timing not data, replayable orchestration,
no privilege, obligation liveness. The pricing stack and pricing data layer minima:
records outputs and never runs a model; state-dependent valuation from the ledger;
reproducibility from recorded inputs; no mixing across an event; originals preserved,
adjusted computed, derived recomputed; estimates apart from entitlements; provenance on
re-entry. The valuation-semantic requirements restate Ch. 7's derivations as minima; the
data-boundary requirements restate Ch. 8's.

### Ch. 17 — Scope — **2 pp** — KLEPPMANN
Discharges the constitution's **Scope** section. Threads visiting: none.

What the specification covers, component by component, and the explicit out-of-scope list
— external authorities reconciled at the boundary, never functions the ledger performs.
One closing paragraph: the direction of authority is one-way; this specification is rated
against the constitution and against nothing else.

---

## 2. The Budget Table

| Ch. | Title | Author | Pages |
|----:|-------|--------|------:|
| 1 | The Objective and the Commitments | KLEPPMANN | 4 |
| 2 | The Picture: Map, Then Fold | KLEPPMANN | 6 |
| 3 | The Objects | KLEPPMANN | 7 |
| 4 | The Machines | KLEPPMANN | 5 |
| 5 | Smart Contracts | KARPATHY | 6 |
| 6 | State: The Three Homes | KLEPPMANN | 5 |
| 7 | Valuation and Profit and Loss | GATHERAL | 6 |
| 8 | Ingestion, Corporate Actions, and the Market Data Operator | NAZAROV | 6 |
| 9 | Collateral, Margin, and Lending | MINSKY | 10 |
| 10 | Virtual Ledgers, Strategies, and the Total Return Swap | KARPATHY | 5 |
| 11 | The Settlement Interface | KLEPPMANN | 5 |
| 12 | Presentation and Reporting Projections | MINSKY | 4 |
| 13 | Alignment with the Common Domain Model | MATTHIAS | 3 |
| 14 | The Invariant Catalogue | NOETHER | 6 |
| 15 | Testability and the Executable-Check Regime | WILSON | 6 |
| 16 | Minimum Requirements | NAZAROV | 4 |
| 17 | Scope | KLEPPMANN | 2 |
| | **Sum** | | **90** |

Sum = 90 ≤ 90. Reserve of 10 pages held for Phase 4 release only. Hard cap 100.

Named-deliverable audit (every ratified Phase 2 deliverable has exactly one home):
coverage invariant and two-guard contrast → Ch. 14 (exercised in Ch. 9);
presentation/reporting projections → Ch. 12; settlement-state and market-claim machinery
→ Ch. 11; supervised write-off path → Ch. 9; TLA+ obligation for the
knock–revalue–call race → Ch. 15; attribution-convention totality → Ch. 12 (declared
in Ch. 8's data slot).

---

## 3. The Thread Map

All quantities are exact integers in minor units (USD amounts stated in whole dollars are
exact in cents). Numbers already fixed by the ratified ruling are kept verbatim. Two
deliberate couplings, chosen for consistency: the dividend and the split share the issuer
ACME (the operator's scaling of the dividend figure is then visible, not asserted), and
the variance swap fixes on the same recorded index closes the future settles against.

### T1 — Lifecycle of a future. Owner: KARPATHY
**Instrument (fixed).** FUT-IDX: cash-settled listed future on index IDX, multiplier 10,
USD, settled-to-market (declared on the CCP agreement unit). Wallet W-ALPHA buys 1
contract at 995 on day 0 against the CCP wallet. Settlement prints: day 1 = 1,000
(VM +50 to W-ALPHA), day 2 = 990 (VM −100 — the ruling's micro-case (a), verbatim),
day 3 = final settlement 1,005 (VM +150, position unwound). Cumulative VM = (1,005 −
995) × 10 = **100** = total PnL.
**Visits.** Ch. 2: watch declaration named in the picture. Ch. 3: the unit's terms declare
its watches (each print, the expiry). Ch. 5: one firing per print; expiry unwind in one
atomic transaction. Ch. 6: print in UnitStatus, applied margin in PositionState,
multiplier in ProductTerms. Ch. 7: cumulative VM equals PnL, path-independent. Ch. 9: D5 —
the same 100 move under CTM gains one return-obligation unit, nothing else. Ch. 11: VM
cash projects to an instruction. Ch. 14: VM zero-sum is conservation, not a check. Ch. 15:
duplicate settle event inert; late firing identical.

### T2 — Lifecycle of a one-touch. Owner: MINSKY
**Instrument (fixed).** OT-1: one-touch on stock OMEGA (spot 95.00 at inception), barrier
80.00 touch-at-or-below, payout **1,000,000** USD; written by W-BANK, held by W-ALPHA,
premium 350,000 at inception; marked **400,000** pre-knock. Pledged security-interest to
counterparty B under agreement G at **50%** valuation percentage: collateral value 200,000
against exposure **150,000**. Knock print: OMEGA official close 79.00. (All ruling
micro-case (c) numbers verbatim.)
**Visits.** Ch. 2: the full pipeline walkthrough — watch, contract, apply. Ch. 4: one
event, three machines, one write; duplicate emission finds *triggered* and proposes
nothing. Ch. 5: the touch contract. Ch. 7: state-parameterised price 400,000 → 0. Ch. 9:
micro-case (c) start to finish — determination from owned, trapping predicate, 850,000
free + 150,000 posted, marker return, zero-vector retirement. Ch. 12: the pledged unit in
the encumbrance projection. Ch. 14: coverage on the discharge transaction; value
extinguished, mass intact. Ch. 15: the TLA+ knock–revalue–call–discharge model.

### T3 — A dividend payment. Owner: KARPATHY
**Instrument (fixed).** Stock ACME, price 100.00; W-ALPHA holds **10,000** shares. Issuer
declares a cash dividend of **1.50** per share: announcement day A, record day R, payment
day P (all before the split of T4). Entitlement = 10,000 × 1.50 = **15,000** USD.
**Visits.** Ch. 4: the watch handshake — the announcement firing registers the record-date
and payment-date watches, visibly declared then armed. Ch. 5: three firings, three
transactions, one stateless contract (register watches; record entitlements movelessly;
pay against recorded entitlements). Ch. 6: the recorded entitlement lives in
PositionState. Ch. 8: the announcement captured at the boundary; the declared 1.50
forward figure scales to 0.75 under T4's split. Ch. 9: determination reads owned; payment
routes through the conditional obligation whose predicate, unencumbered, is vacuous and
discharges at once. Ch. 11: the 15,000 payment projects to a cash instruction.

### T4 — A stock split. Owner: NAZAROV
**Instrument (fixed).** ACME splits **2-for-1** after T3's payment date: W-ALPHA's 10,000
shares become **20,000**; the recorded price frame moves from 100.00 to **50.00**; one
transaction carries the moves and the new ProductTerms version. Operator declarations:
spot scales by ½; cash-per-share dividend figures scale (1.50 → **0.75**); proportional
figures stand.
**Visits.** Ch. 3: the terms change as one of the four transaction components. Ch. 6: the
split lands in ProductTerms — one event, one home. Ch. 8: the operator menu worked in
full; originals preserved, adjusted values computed at read, until fresh post-event data.
Ch. 11: moveless corporate-action components project to no instruction. Ch. 13: the
corporate-action event representation. Ch. 14: consistency of reference — 20,000 × stale
100.00 = phantom 2,000,000 against true 1,000,000, refused.

### T5 — An OTC variance swap. Owner: GATHERAL
**Instrument (fixed).** VS-1: one-year OTC variance swap on index IDX, **252** scheduled
fixings against the recorded official closes (the same observation source T1 settles on),
variance strike **400** variance points (20 vol), variance notional **1,000** USD per
point, no cap. Mid-life checkpoint at fixing **126**: the accrued sum-of-squared-returns
statistic is a recorded UnitStatus integer (scale 10⁻⁸), value fixed by GATHERAL in
Phase 3 consistently with the endpoint. Final realised variance **441** points; settlement
= 1,000 × (441 − 400) = **41,000** USD to the realised-variance receiver.
**Visits.** Ch. 3: 252 watches declared exhaustively at registration. Ch. 5: firing *k*
finds fixings 1..k−1 on the record — a contract never remembers. Ch. 6: the *three-homes
sufficiency requirement*, exercised: past fixings accrue in UnitStatus, written by each
firing for the next. Ch. 7: mid-life valuation from the accrued statistic plus remaining
implied variance, all from the record. Ch. 11: the final 41,000 projects to one cash
instruction. Ch. 13: payout and observation representation. Ch. 15: regenerate firing 127
from the recorded fixings and compare — economic verification by recomputation.

### T6 — A total return swap. Owner: KARPATHY
**Instrument (fixed).** TRS-1: notional **10,000,000** USD; reference leg = NAV of wallet
**W-QIS** in virtual ledger **V-1**, managed by the declared rulebook of non-valued
strategy unit S-QIS; financing leg fixed **4%** p.a., quarterly (Δt = 0.25 →
**100,000** per quarter). Inception NAV observation 10,000,000. First reset: stamped NAV
**10,300,000** → total-return leg **300,000**, financing **100,000**, one net move of
**200,000** payer → receiver; reference resets to 10,300,000.
**Visits.** Ch. 3: the non-valued strategy unit (price undefined, not zero); the TRS an
ordinary unit of the true ledger. Ch. 7: the reference leg is a NAV projection — the same
fold as any other. Ch. 8: the stamped NAV enters as an observation with provenance; the
bridge is an observation, never a move. Ch. 10: the full episode — rebalancings as
recorded transactions in V-1, the level replayable by any party, reset and financing moves
emitted by the TRS contract. Ch. 13: two-legged representation, reset as a recorded event.

---

## 4. Open Questions for the Owner (2)

1. **Authorship of Ch. 11 (Settlement Interface).** Proposed: KLEPPMANN, because the
   settlement projection is a typed arrow off the log (his remit). But the chapter's
   hardest content — settlement-state as load-bearing for entitlement routing, market
   claims as first-class obligation units — is MINSKY's ruling (D2). Alternative: assign
   Ch. 11 to MINSKY (bringing him to three chapters, 19 pages). Ratify one.

2. **The two deliberate thread couplings.** The dividend and the split share ACME, and the
   variance swap fixes on the future's index closes. This buys visible cross-chapter
   consistency (the operator scaling a live dividend figure; one observation source, two
   consumers) at the price of number-coordination among KARPATHY, NAZAROV, and GATHERAL.
   If the owner prefers fully decoupled threads, T4 moves to a separate issuer and T5 to a
   separate index, with no page-budget effect. Ratify coupled or decoupled.

— End of proposal —
