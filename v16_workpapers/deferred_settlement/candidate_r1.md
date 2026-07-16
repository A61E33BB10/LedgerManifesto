# Deferred Settlement, v16-Native — Round 1 Candidate

**Cell:** deferred-settlement design cell. **Author:** TuringAward (first-principles lead).
**Integrates:** `cell_finops_memo.md` (DS dispositions, identity, DvP honesty, worked numbers) and `cell_temporal_memo.md` (substrate mapping, two precision flags) — both carried below, verbatim where load-bearing.
**Problem authority (no design authority):** `Ledger_Spec_v11.0/deferredSettlement.tex`.
**Binding:** constitution v1.3 (C-2.7 Order, C-2.8 Simulability, C-4.12 event universe, §12 bitemporal doctrine); certified `ledger_v16_0.tex` (§9 Timing, §11 Settlement Interface, §8 boundary, §14 invariants, §16 M1–M8/B1–B7/TA-*); `temporalv16.tex` (R-register).
**Status:** Round 1 candidate. Not the final .tex. Not committed.

Simplicity is a gate in this document: every mechanism — kept, new, or retired — carries a
delete-test answered with a concrete scenario. A mechanism with no failing scenario under
deletion is deleted.

---

## 1. The problem

Equity markets settle on a delay. On Monday at 14:32:11 UTC we buy 100 XYZ at $50.00 —
$5,000.00 of cash against 100 shares, T+2, so the intended settlement date t_d is
Wednesday. The economic fact is complete on Monday: we hold the price exposure, we owe the
cash, we are entitled to any dividend declared from that instant. The custody fact happens
on Wednesday: only then does the depository move the shares into our depot and the cash
agent debit our nostro. Between the two lies the **open settlement window [T, t_d]**, and
its duration is a parameter — T+1 for US equities, T+2 for EU/UK, T+0 for atomic venues,
T+5 or more on a cross-border fail — never a doctrine.

The window makes a number real before anything moves. XYZ closes at $52.00 on Tuesday.
Our book must show **+$200.00 of unrealised profit at Tuesday's close** — recognised,
capital-bearing, reported — while the custodian's statement still shows $1,000,000.00 of
cash and zero XYZ, exactly as on Monday morning. Both records are right. They describe
different facts on different calendars, attested by different authorities.

A system that collapses the two facts fails one way or the other (the v11 strawmen):
debit the nostro at T and the daily custodian statement breaks by $5,000 for two days
with nothing to apply Wednesday's real debit to; recognise nothing until t_d and
Tuesday's $200 does not exist, misstating PnL, risk, and regulatory capital. The design
must keep both facts, separately observable, separately attested, and bound to each other
by an identity that is **computable inside the system** — because a bound that lives in
prose is checked in a spreadsheet, and the spreadsheet is the second store of truth this
ledger exists to abolish.

v16.0 already carries most of the answer. What it does not carry is the bound: NS-01
records that the custody reconciliation identity — present in v11 as invariant DS3 and
independently as the SBL custodian check — is absent from the certified spec. "Reconcile
against the custodian" is named at the boundary and never made computable. This candidate
closes exactly that, and almost nothing else.

## 2. Classification (the seven questions, compact)

1. **Safety.** (i) The economic position recognised at T is never rewritten by any
   settlement event — no discharge, fail, partial, or buy-in touches `owned` (v16 §11:
   "settlement failure is a recorded event, never a reversal"). (ii) Conservation per
   (unit, coordinate) at the one door, no carve-out. (iii) No node-walk without a recorded
   trigger — a witnessed external event or the due-date watch reading recorded quantity;
   never a clock, never silence. (iv) **New:** internal–external drift is detectable — the
   reconciliation identity holds per (custody account, unit) at every statement, with any
   violation classified and visible. (v) No settlement fact lives outside the log: not in
   Temporal, not in a mirror wallet, not in a stored status.
2. **Liveness.** Every settlement-obligation unit reaches a terminal disposition by its
   deadline chain (M7 obligation liveness); the due-date watch fires at t_d (M1); every
   recorded custody statement is classified; a BREAK ages visibly until repaired forward.
3. **Failure model.** Machines: crash-recovery under durable execution — wipe the
   substrate and everything re-derives from the log (temporalv16 R-02). External parties
   (custodian, CSD, counterparty): not modelled Byzantine; modelled **untrusted and
   reconciled** — their assertions cross the boundary only as recorded observations, and
   their faithfulness is a named trust assumption (§8 below). Message loss and duplication:
   M2 at-least-once emission plus cause-derived idempotence.
4. **Consistency.** One writer, one total order (C-2.7): the log is the serialization.
   Internal vs external is **eventually consistent by construction** across the open
   window — that is not an anomaly to suppress but a state to name: the identity quantifies
   the lag exactly, and the classification calls it EXPECTED LEAD-LAG, not a break.
5. **Abstraction boundaries.** The one door admits; the settlement interface reads and
   emits, never writes; the custodian's statement is an observation on our log, never a
   mirror balance in our wallet universe (the v11 `csd_virtual` mirrors leaked the external
   book's representation across the boundary — retired, §8). Temporal orchestrates and owns
   no fact (R-02, M4, M6).
6. **Cost.** The identity is a fold over `owned` and the open settlement-obligation
   units: time bounded by wallet count and open-unit count, never by transaction count.
   No new home, no new coordinate, no new primitive class.
7. **Representation risk.** Money is an integer count in minor units; quantities are
   integers; the identity is compared within the per-currency tolerance declared in the
   unit's terms; no floats anywhere on the reconciliation path. Witness identity is the
   cause-derived identifier — a duplicate statement or confirmation is the same fact, not
   a second one.

## 3. The design

**Thesis.** v16.0 already contains the deferred-settlement design; it is not missing a
mechanism, it is missing a *bound*. The gap [T, t_d] is carried by trade-date booking
plus the settlement-obligation unit. What is genuinely new is small: **(N1)** the custody
statement crosses the one door as a registered witness event kind; **(N2)** the
reconciliation identity is a numbered invariant over a projection, with a three-way
classification; **(N3)** the recursive partial split gets a declared fragment bound.
Plus one honest sentence about DvP (§3.3). Nothing else. No state outside the log.

### 3.1 Existing mechanisms that carry the load (cite; each with its delete-test)

**E1 — Trade-date booking (D3, §9 Timing).** `owned` re-books at instruction; the booking
moment is a declared term of the governing agreement, not a constant of the ledger; the
instruction-to-settlement gap "is carried explicitly, never elided."
*Delete-test:* delete it and the ledger is strawman 2 — on Tuesday close the book shows
zero XYZ and $1,000,000, PnL zero; the real +$200 is unreportable, and trade-date
recognition (mandatory for a fair-value trading book) is misstated in capital and risk.
Certified; carried.

**E2 — The settlement-obligation unit (§11).** An instructed-but-unsettled trade is a
delivery-versus-payment obligation, so it is a unit; its lifecycle node —
`instructed → settled | failed` — lives in UnitStatus like any other unit fact; one
product graph carries the spine, the fails cascade, and the market-claim branches; the
node has exactly one writer, the unit's own smart contract.
*Delete-test:* delete it and the gap has nowhere on the record to live. Either the trade
pretends to be settled at T (strawman 1: a $5,000 unexplained break against the custodian
every day of the window, and Wednesday's real debit has nothing to discharge) or
settlement state floats free of the three homes and sufficiency fails. Certified; carried.

**E3 — Moveless discharge.** Settlement events walk the node and move nothing, because
`owned` already moved at T. The confirmation is a moveless observation; the node-walk is
a moveless transaction; conservation over them is vacuous.
*Delete-test:* make settlement move balances and either the position doubles (confirmation
credits 100 XYZ onto an `owned` that already holds them: book shows 200 against a depot
of 100) or discharge must first reverse the T booking and re-apply it — a rewrite of
history, forbidden by C-12.4 and by "failure is never a reversal."

**E4 — The partial edge (§11, certified).** A partial confirmation 0 < q_s < Q splits the
unit: a settled leg (q_s) and a failed-residual leg (q_r = Q − q_s), one paired-leg
transaction, parent retired from the zero vector, q_s + q_r = Q, four-quadrant routing
applying leg-wise.
*Delete-test:* delete it and a 60-of-100 fill is one overloaded node — either the whole
trade reads settled (40 shares the depot never received) or the whole trade reads failed
(the fails cascade fires on 60 shares that did arrive). Certified; cited, not redesigned.
The one addition is N3 below.

**E5 — Market claims and the four quadrants (§11).** A record date inside the gap routes
the distribution by two recorded binary facts (cum/ex, settled/unsettled); the two
divergent quadrants raise the market-claim leg or its mirror on the settlement-obligation
unit itself.
*Delete-test:* delete it and a cum buy unsettled at the record date pays the deliverer
with no recorded reconciling claim — the distribution surfaces as exactly the
reconciliation break the ledger exists to abolish. Certified; cited.

**E6 — The event-kind registry, routing, quarantine, and capture (C-4.12; §8; M8).**
Event kinds are finite, closed, declared before they cross; registration names the
routing; an unprocessable arrival is captured through the door as a moveless fact with
provenance and stands as a visible open item; no captured event is lost.
*Delete-test:* delete it and external settlement messages enter by ad-hoc feed handlers —
an unrecognised statement format is silently dropped, and the first evidence of the drop
is an unexplained break weeks later with no captured original to investigate.

**E7 — The due-date watch (M1 durable timers, M4 triggers carry timing not data, M7
obligation liveness).** At t_d the watch fires; an activity reads the record — cumulative
confirmed quantity against instructed Q — and the unit's contract proposes
`settled`, the partial split, or `failed`. The trigger reads quantity, not mere presence.
*Delete-test:* delete it and a silent CSD — no confirmation, no fail notice — leaves the
unit `instructed` forever; the fail is discovered only when the aging identity mismatch
ripens into a break, weeks late, instead of at t_d; obligation liveness (M7) is lost.

**E8 — Bitemporal doctrine and forward repair (C-12.1, C-12.4; v16 ch14).** Both honest
answers are always computable — what the book said then, and what the numbers are with a
correction in force; a wrong recorded fact is repaired forward by a new recorded event,
never edited.
*Delete-test:* delete it and a restated custodian statement (Tuesday's camt.053 reissued
Wednesday with a corrected balance) forces a choice between editing the recorded original
(history rewritten) and carrying a permanent false break (the stale statement contradicts
the book forever). With the doctrine, the restatement is a longer log: the as-known-then
view keeps Tuesday's statement, the corrected view reads the reissue, and the
classification recomputes under each.

**E9 — Witness-before-signal (temporalv16 R-12; M8).** Every external settlement fact —
confirmation, fail notice, statement — is recorded through the one door **before** any
orchestration signal exists; the signal carries the log position, never the payload.
*Delete-test:* delete it (signal carries the quantity directly) and the substrate becomes
a second store: wipe Temporal and the confirmed quantity is gone — the R-02 acceptance
test ("wipe Temporal and re-derive everything from the ledger") fails on the first
partial fill.

### 3.2 What is genuinely new

**N1 — The custody-witness event kind.** The custodian's and depository's periodic
account statements — the camt.053 nostro statement, the depot statement — are registered
event kinds (B2), carrying provenance (B1), admitted through the one door as moveless
observation-recording transactions under the capture discipline (M8), quarantined when
malformed (C-4.12). A statement asserts, per external account and unit, a balance at an
as-of time. It is **never** stored as a mirror balance in the wallet universe: it is an
observation on the log that a projection reads. This is not new machinery — it is one
more registration in the existing registry; what is new is the decision that this data
kind crosses at all, and the trust assumption that decision names (§8, PANEL-PENDING).

*Delete-test:* delete N1 and the external side of the identity is not on the record, so
DS3 is not computable inside the system — precisely v16's current state, flagged as
NS-01. The check then lives where it lives today in every firm with this gap: an
operations spreadsheet joining a ledger extract to a custodian portal download. That
spreadsheet is a second derivation of truth with its own bugs, its own timing, and no
capture discipline; when it disagrees with the ledger nobody can say which artefact is
wrong from the record alone. The one-source-of-truth commitment fails at exactly the
boundary the constitution keeps in scope.

**N2 — The reconciliation identity, as a numbered invariant over a projection.**
Two named projections over the open settlement-obligation units, then one identity, then
a three-way classification. No new state anywhere: every term is a fold.

For a real wallet w and unit u, over w's settlement-obligation units whose node is not
`settled` (i.e. `instructed` or `failed` — the unit is unsettled either way):

```
inflight_out(w, u) = Σ leg quantity of u that w owes  (payment legs where w pays;
                                                        delivery legs where w delivers)
inflight_in(w, u)  = Σ leg quantity of u owed to w    (payment legs where w is paid;
                                                        delivery legs where w receives)
```

**The identity (cash).** For every custody account a, currency ccy, wallet set W(a) the
registry's sub-custody partition maps to a, at every statement as-of time t:

```
nostro_ext(a, ccy, t) = Σ_{w∈W(a)} [ owned(w, ccy) + inflight_out(w, ccy) − inflight_in(w, ccy) ]
```

**The identity (securities).** For depot account a and security s:

```
depot_ext(a, s, t) = Σ_{w∈W(a)} [ owned(w, s) + borrowed(w, s) + inflight_out(w, s) − inflight_in(w, s) ]
```

The `borrowed` term folds in the v11 SBL custodian check (own + borrowed + inflight =
depot); under v16's title-transfer financing it contributes zero (title re-books to
`owned`), and for a segregated collateral account the internal side is the posted-plane
marker mass — the one-for-one reconciliation §9 case 3 already asserts in prose. The
identity makes those prose sentences, and the per-venue sub-custody reconciliation of
§7, executable. Both sides are integers in minor units; comparison is within the
declared per-currency tolerance.

**The classification.** Per (account, unit), each recorded statement classifies as:

- **CLEAN** — the identity holds within tolerance;
- **EXPECTED LEAD-LAG** — the violation equals exactly the in-flight quantity of named
  open units (the ordinary open-window state, in either direction: the statement may lag
  the book, or — when the register moves before the confirmation message arrives — lead
  it); a lead-lag that outlives its unit's deadline chain ripens into a break;
- **BREAK** — an unexplained residual: mass on one record and not the other with no open
  unit to name. The highest-severity operational signal the design emits. It is not
  stored: the projection recomputes it from the same log every time, its age is the date
  of the first statement that showed it (also on the log), and its repair is forward-only
  under C-12.4 — a recorded, agreed, authorised compensating event, never an edit.

*Delete-test (identity):* delete N2 and the statement sits on the log bound to nothing; a
drifted book and a clean book render the same green report. Concrete scenario: the
custodian mis-debits our nostro $50,000 for another client's wire. No internal event
exists — the door admitted nothing, conservation holds, every projection is internally
consistent — and the ledger is now wrong about the world with no mechanism that can ever
notice. With N2, the next statement classifies BREAK for $50,000 the same day.
*Delete-test (classification):* delete the three-way classify and every open window
flags daily — the standard buy alone shows a $5,000 nostro mismatch on Monday and Tuesday.
At production scale that is tens of thousands of false alarms a day; operations mutes the
report within a week, and the real $50,000 break above sails through muted. The
classification is what makes the invariant *hold* across the window rather than merely
fire across it.

**N3 — The fragment bound, as a declared term (NS-04; DS11b(iii)).** The certified
partial edge re-splits the failed-residual leg "again by the same edge, recursively,"
bounded today only by integer quantity. Add one declared term to the settlement-obligation
unit — `splitDepthMax` (venue- or agreement-declared, v11 carried 2) — read by the edge's
action: at depth `splitDepthMax`, a further partial confirmation does not re-split; the
residual walks `failed` whole and the fails cascade carries it to discharge, compensation,
or default. Termination is then provable by a variant: the residual strictly decreases at
every split and the depth strictly increases toward a declared cap.
*Delete-test (the bound):* delete it and a 1,000,000-share instruction confirmed a share
at a time lawfully mints up to 10^6 live failed-residual units, each with its own
workflow, watches, and liveness deadline — the obligation-liveness queue (M7) floods and
the per-obligation deadline discipline degrades to noise. The v11 bound existed to cap
exactly this.
*Delete-test (term, not machinery):* make it a ledger constant instead and venues with
different partial-settlement conventions cannot be onboarded without a spec change —
the same argument that made the booking moment itself a declared term (§9 Timing). It
survives as a term; it would not survive as machinery.

### 3.3 DvP atomicity, stated honestly (carried from finops, verbatim in substance)

**What the ledger guarantees:** its own transaction atomicity. Delivery and payment are
one admitted paired-leg transaction — at instruction both `owned` legs re-book atomically
(both apply or neither), and every node-walk is one transaction, conserving per
(unit, coordinate) at the single door.

**What it cannot guarantee:** the external CSD's own DvP atomicity — that the real depot
and real nostro actually move together at settlement. That is a trust assumption,
**reconciled, not enforced**. If the CSD delivers stock but not cash (a real DvP break),
it surfaces through N2: one side of the identity shows a lead-lag the other side never
matches, the lead-lag outlives the unit's deadline, and it ripens into a BREAK while the
fails cascade carries the open leg. Ledger-level atomicity is not settlement-level
atomicity at the CSD; the door secures the first, and the identity detects violations of
the second.

*Delete-test:* delete the statement and a reader of the spec assumes the stronger
guarantee; the leg-inconsistent external fill has no specified surface, so the first real
one is triaged as "impossible" instead of read off the recon report as a ripening break.
One paragraph of honesty is the cheapest mechanism in this design.

## 4. The fold

Deferred settlement is a list of recorded events and their fold. No other state exists.

| # | Event (kind) | Folds into |
|---|---|---|
| 1 | Execution / instruction (existing kind) | One transaction: paired-leg `owned` re-book (buy: security seller→buyer, cash buyer→seller) **and** the moveless minting of the settlement-obligation unit at `instructed`, its declared terms carrying the legs, dueDate = t_d, discharge predicate, splitDepthMax. |
| 2 | Price close (existing kind) | A recorded observation. Valuation and PnL are further folds over it; no transaction, nothing stored. |
| 3 | Settlement confirmation — sese.025 / camt.054 (registered kinds) | A moveless observation-recording transaction; routing names the unit's contract; the contract proposes the moveless node-walk `instructed → settled`. In-flight projections read zero thereafter as a consequence of the node. |
| 4 | Partial confirmation, q_s (same kinds, quantity-bearing) | The recorded observation, then the split transaction: parent retires from the zero vector; settled leg (q_s) and failed-residual leg (q_r) minted; q_s + q_r = Q conserved; at splitDepthMax the residual walks `failed` instead. |
| 5 | Fail notice (registered kind), or the due-date watch firing and finding cumulative confirmed < Q | The moveless node-walk `instructed → failed`; the fails cascade (certified) carries the residual as a recorded, deadline-bearing obligation. |
| 6 | **Custody statement — camt.053 / depot statement (N1, new kind)** | A moveless observation-recording transaction. Folds into no balance. Read by the N2 projection; the classification (CLEAN / EXPECTED LEAD-LAG / BREAK) is computed at read, never stored. |
| 7 | Record-date watch firing inside the gap (existing) | The market-claim leg or its mirror on the settlement-obligation unit (certified, cited). |
| 8 | Restated statement or restated finality (same kinds, later arrival) | A longer log. Both bitemporal views recompute (C-12.1); any repair with monetary effect is forward-only, agreed, authorised (C-12.4). |

State after the fold: the log itself; each unit's node in UnitStatus; `owned` in
PositionState. Everything else — balances, V_t, in-flight, the identity and its
classification, the settlement instructions the interface emits — is a projection.
The settle projection stays pure, total, deterministic, idempotent (§11); it reads the
committed record and writes nothing.

## 5. Temporal mapping (compact; integrates the temporal-engineer memo)

- **Workflow = the settlement-obligation unit's own unit-workflow** (R-03/R-14), born
  `instructed` by signal-with-start on the recorded instruction event; record-first is the
  backstop (R-27) and the cadence sweep re-starts any unit whose workflow is missing
  (R-09). Nothing else here is a workflow.
- **Activities** are the four side-effecting steps: capture the witness through the door
  (R-12 — before any signal exists), evaluate the unit's contract on a firing
  (version-pinned, R-06/R-26), propose to the door (the single idempotent write, R-01/M6),
  and emit the instruction at the boundary — egress only, writes nothing (R-24). Workflow
  code holds only timers, signal-waits, selectors (R-05).
- **The timer firing at t_d is the due-date watch's liveness half and carries no data**
  (M4): it wakes the unit; an activity reads cumulative confirmed quantity against Q from
  the record, and the contract — never Temporal — proposes settled, split, or failed.
- **A witness signal carries the log position of an already-recorded fact only**
  (R-11/R-12): it is a latency optimisation over the t_d backstop. A lost signal costs
  latency, never the record — the timer wakes the unit, reads the same recorded quantity,
  reaches the same terminal node, later, identically.
- **The window [T, t_d] is the workflow's quiet wait**; the cycle length T+0..T+5 is just
  the timer duration read from the declared dueDate. T+0 means a zero-length timer — no
  special path; the substrate never branches on the cycle.
- **Flag A (carried, binding on Round 2): the partial split is not ContinueAsNew.** The
  split legs are new units (R-14/DL-02): the parent workflow **completes** and each leg
  starts its own workflow by signal-with-start. ContinueAsNew would smuggle two new units
  into the parent's identity and lose the per-leg cause-derived txid separation the fails
  cascade depends on. (The plain `instructed → failed` walk, by contrast, is the same unit
  at a later node — same workflow, ContinueAsNew boundary per R-15; and the market-claim
  branch is a branch of the same graph — same workflow.)
- **Flag B (carried, binding on Round 2): per-unit egress idempotence rides
  (unit, node), never a Temporal run or attempt id.** §11's settle projection dedupes on
  the recorded settlement node; an emit activity placed inside the unit-workflow is
  faithful only if it dedupes identically — the same discipline as the door's
  cause-derived txid (R-07).
- **Acceptance test (R-02):** wipe Temporal and the entire settlement-obligation
  unit-workflow population re-derives from the ledger — nodes re-read from UnitStatus,
  timers re-armed from dueDate, in-flight recomputed by projection. If losing Temporal
  loses a settlement fact, the design is wrong. Under this candidate nothing is lost:
  Temporal owns no quantity, no witness, no identity input.

## 6. The running example, computed in print

Buy 100 XYZ at $50.00. T = Monday 2026-04-30, 14:32:11 UTC; T+2, so t_d = Wednesday
2026-05-04. Buyer wallet `w_us`; counterparty the seller. XYZ closes $50.00 Monday,
$52.00 Tuesday, $51.50 Wednesday. Trade-date booking (§9 default). All cash in integer
minor units; shown in dollars.

**Pre-trade.** owned(USD) = 1,000,000.00; owned(XYZ) = 0. External: nostro 1,000,000.00,
depot 0. V_pre = 1,000,000.00 + 0 × 50.00 = **1,000,000.00**.
Identity — nostro: 1,000,000.00 = 1,000,000.00 + 0 − 0 ✓ CLEAN. Depot: 0 = 0 + 0 + 0 − 0
✓ CLEAN.

**Monday, T — instruction.** One paired-leg DvP transaction TX1:
move owned(XYZ) 100, seller → w_us; move owned(USD) 5,000.00, w_us → seller; and,
moveless in the same transaction, settlement-obligation unit SO-1 minted at `instructed`
(deliveryLeg: 100 XYZ to w_us; paymentLeg: 5,000.00 USD from w_us; dueDate 2026-05-04).

*Conservation at T:* ΣXYZ = +100 (w_us) − 100 (seller) = **0** ✓;
ΣUSD = −5,000.00 (w_us) + 5,000.00 (seller) = **0** ✓.

Balances: owned(XYZ) = 100; owned(USD) = 995,000.00. External unchanged: nostro
1,000,000.00, depot 0. In-flight for w_us: inflight_out(USD) = 5,000.00;
inflight_in(XYZ) = 100.

V_T = 995,000.00 + 100 × 50.00 = **1,000,000.00** = V_pre: a fair exchange at the
prevailing price; zero PnL at the trade instant.

Identity — nostro: 1,000,000.00 = 995,000.00 + 5,000.00 − 0 ✓ **EXPECTED LEAD-LAG**
(explained exactly by SO-1's payment leg). Depot: 0 = 100 + 0 + 0 − 100 ✓ **EXPECTED
LEAD-LAG** (SO-1's delivery leg).

**Tuesday, T+1 close $52.00 — the headline.** No moves; conservation vacuous.
V_{T+1} = 995,000.00 + 100 × 52.00 = **1,000,200.00**.

**PnL = V_{T+1} − V_T = +$200.00 unrealised — with zero cash movement and zero custody
movement.** The mark is a projection over `owned` against the recorded close (one
composition, both price vectors projections over it — V5); the custodian still reports
nostro 1,000,000.00 and depot 0, and the identity still balances through SO-1's
in-flight, both sides, same as Monday ✓. The $200 is real, the custody silence is real,
and the record carries both without contradiction. This is the number strawman 2 cannot
produce and the break strawman 1 cannot avoid.

**Wednesday, T+2 — confirmation.** sese.025 and camt.054 cross the door as moveless
observation-recording transactions (kinds registered, provenance carried, cause-derived
identity — a duplicate is the same fact). SO-1's contract proposes the moveless node-walk
`instructed → settled`. Zero moves; conservation vacuous ✓. `owned` untouched (DS1, DS7).
In-flight now reads 0. External register catches up: depot 100, nostro 995,000.00.

Identity — nostro: 995,000.00 = 995,000.00 + 0 − 0 ✓ **CLEAN**. Depot: 100 = 100 + 0 +
0 − 0 ✓ **CLEAN**.

V_{T+2} = 995,000.00 + 100 × 51.50 = **1,000,150.00**; cumulative PnL +$150.00, Wednesday
day PnL −$50.00. Settlement contributed exactly zero to V at every step — PnL is a
function of the marks alone, path-independent across the window.

**Fail variant.** Monday and Tuesday identical — the +$200.00 stands. Wednesday: no
confirmation by the deadline; the due-date watch fires; cumulative confirmed 0 <
instructed 100; SO-1's contract walks it `instructed → failed` on the full 100. The
Monday booking is not undone: owned(XYZ) = 100, owned(USD) = 995,000.00 (DS7). External
still nostro 1,000,000.00, depot 0; the 100 and 5,000.00 remain in-flight under the
now-`failed` (still unsettled) unit, so the identity classifies **EXPECTED LEAD-LAG,
not a false BREAK** — an aging one, carried by the fails cascade as a recorded,
deadline-bearing obligation (M7). By that deadline the obligation is (a) **discharged** —
a late confirmation walks it to `settled`, in-flight → 0; or (b) **compensated** — a
buy-in delivers a replacement 100 XYZ (recorded confirmation → settled), or cash-in-lieu
at fair value (100 × 51.50 = $5,150.00) with the 5,000.00 payment leg netting and any
claim decoupling to recovery on default; or (c) **declared defaulted** — the certified
close-out path, supervised write-off as fallback. Never a silent reversal; every step a
recorded event.

**Partial variant.** Wednesday brings confirmation of 60 of 100. SO-1 walks the partial
edge and splits: settled leg SO-s (60, at `settled`), failed-residual leg SO-r (40, at
`instructed`); **60 + 40 = 100** and the parent retires from the zero vector —
per-step conservation ✓ (DS11a). The cascade later fires on the 40 alone (DS11b i–ii).
Identity: depot 60 = 100 + 0 + 0 − 40 ✓ LEAD-LAG on exactly the residual;
nostro 1,000,000 − 3,000 = 997,000 = 995,000 + 2,000 − 0 ✓ (payment pro-rated across the
legs: 3,000 settled with SO-s, 2,000 in flight under SO-r). A further partial on SO-r
re-splits by the same edge — up to `splitDepthMax` (N3), beyond which the residual fails
whole into the cascade.

## 7. DS1–DS19 disposition (carried from finops-architect, integrated)

**Counts: 16 satisfied · 3 needs-the-new-design (DS3, DS10, DS11b) · 0 rejected.**
No DS *property* is rejected; the v11 *mechanism* (mirror wallets + L15 FSM) is
superseded, not the guarantee (§8).

| DS | Invariant | Disposition |
|----|-----------|-------------|
| DS1 | Economic-Exposure-at-T | **Satisfied** — `owned` re-books at instruction and no settlement event moves it; the gap lives in the unit (§9, §11). |
| DS2 | Conservation | **Satisfied** — by construction, per (unit, coordinate), at the one door; no carve-out (§4/§14). |
| DS3 | Reconciliation Identity | **Needs-the-new-design (CORE)** — closed by N1 + N2; this is NS-01, the reason the cell exists. |
| DS4 | No Discharge Without Witness | **Satisfied** — a node walks only on a recorded trigger: a witnessed external event, or the due-date watch reading recorded confirmed quantity; never clock, never silence (§11; M2/M8). |
| DS5 | Replay determinism | **Satisfied** — deterministic replayable orchestration; a late firing reproduces the identical transaction (M5). |
| DS6 | Idempotency of finality messages | **Satisfied** — cause-derived identity at the door; a duplicate finds the node already walked (M2/M8). |
| DS7 | Failure Non-Reversal | **Satisfied** — "settlement failure is a recorded event, never a reversal"; unwind only by compensating transaction (§11). |
| DS8 | Status monotonicity | **Satisfied** — property of the unit's product graph (graph-consistency invariant, §14). |
| DS9 | Buy-In Compensation Closure | **Satisfied (structural)** — obligation liveness forces discharge / compensation / declared-default by deadline (M7; fails cascade; close-out). CSDR window and penalty mechanics are declared terms, downstream. |
| DS10 | Cross-Currency Herstatt Visibility | **Needs-the-new-design — routed to the NS-02 currency workstream.** v16 assumes one implicit currency; the FX leg and Herstatt projection belong there and are not silently absorbed into settlement here. |
| DS11a | Partial Per-Step Conservation | **Satisfied** — the certified partial edge: q_s + q_r = Q, parent from the zero vector (§11). |
| DS11b | Partial Monotonicity + bound | **Needs-the-new-design** — (i, ii) hold; the D_max fragmentation bound (iii) is reinstated as N3, a declared term on the edge (NS-04). |
| DS12 | Variant Degeneration T+0..T+5+ | **Satisfied** — booking moment and cycle are declared terms; T+0 is a zero-length timer; only durations change (§9; §5 above). |
| DS14 | CSDR penalty schema determinism | **Satisfied** — any declared penalty schedule is a deterministic projection over declared terms (§12; B7). |
| DS15 | Counterparty default close-out | **Satisfied** — certified close-out and netting algebra; the fails cascade routes into exactly it on default (§9). |
| DS16 | Bitemporal restatement | **Satisfied** — time travel is a theorem of the fold; restatement is a longer log, never an edit (C-12; ch14). |
| DS17 | Capability scoping on status writes | **Satisfied** — the node has exactly one legal writer, the unit's own contract (one-writer invariant, §11/§14). |
| DS18 | DvP Ledger-Level Atomicity | **Satisfied — ledger-level only, stated honestly (§3.3)** — one paired-leg transaction, both legs or neither; external-CSD atomicity is reconciled via N2, never guaranteed. |
| DS19 | Witness-Identity Determinism | **Satisfied** — the cause-derived identifier makes intake idempotent and witness identity deterministic (M2/M8; §4). |

## 8. Boundary notes, retired machinery, and the parked fork

**Closed in v16.0 — cited, not redesigned.**
- *Quantity-aware splitting:* the partial edge, §11 (settled leg + failed-residual leg,
  paired-leg mass movement, parent from the zero vector, leg-wise four-quadrant routing).
- *Right-of-use gate:* §14 (received collateral without right of use contributes zero to
  the coverage net; re-post of segregated mass refused at the door; §9 case 3; the §12
  re-use projection reports only what the gate admitted). Delivery of a
  bought-not-yet-settled position composes unchanged: order-forced at the door, an
  `owned` reduction below posted mass refused (§9).
- *Close-out netting:* §9 (one CLM-CO per master, coverage-ordered collateral clearing,
  recovery decoupling, supervised write-off fallback; itself deadline-bearing).

**v11 machinery retired (no authority carried; each superseded, none of its guarantees
dropped).**
- `cpty_virtual` contra wallets → the settlement-obligation unit's legs; the contra
  *quantity* is the in-flight projection, computed, never stored.
- `csd_virtual` mirror wallets → the custody statement as a recorded observation (N1);
  the external book is never mirrored into the wallet universe. *Delete-test of the
  retirement itself:* keep the mirrors and the ledger stores its own copy of the
  custodian's book — a second store that itself needs reconciling against the statements
  that feed it — the disease reintroduced as the cure.
- The L15 obligation row and its 8-state FSM → the unit's node in UnitStatus, one
  product graph (three certified nodes plus certified branches).
- Multi-source quorum tables → not re-derived; nothing in this design needs a quorum.
  A single registered custodian is the named authority per account; corroboration
  policies, if ever wanted, are a data-governance matter behind the same event kind.
- The stored `L18.BreakRegister` and the materialised `tx_status` view → projections
  (C: anything computable from the record is computed when needed and never stored).

**PANEL-PENDING — the one fork this cell refuses to fudge (finops's conflict, carried
verbatim in substance).** DS3 must be *computable*, and computability requires the
custodian statement to cross the one door as a registered witness event kind. The trust
assumption that registration names is new: **TA-CUSTODY** — *a recorded custody statement
faithfully renders the custodian's book: the balances it asserts for an account are the
balances the custodian's own record shows at the statement's as-of time; owned by data
governance; arrival remains TA-ARRIVAL's matter; a violation is a perimeter
reconciliation matter, the exact sibling of TA-KIND's residual.* This is a **spec-pass
proposal, not a constitutional amendment** — the constitution names the
trust-assumption pattern (C-4.12) and fixes no count; the edit lands on ch16's sentence
"the boundary rests on four named trust assumptions and no other," which becomes five.
The alternative branch — reading the statement as one more data kind already covered by
TA-KIND — costs no ch16 edit but conflates two different assumptions: TA-KIND warrants
that a *kind declaration* faithfully renders the publisher's convention; TA-CUSTODY
warrants that the *publisher's book* is what the statement says it is. The cell
recommends the named fifth assumption, because an unnamed trust surface is the one kind
this specification never tolerates. **The Decision Panel rules this fork; it is parked
here with exact text, and the work continues around it.** And the refusal stands as
finops wrote it: if the ruling is that the custodian statement stays purely at the
perimeter and never crosses the door, then DS3 cannot be made computable inside the
ledger and is **parked with this exact design as the proposed text — not relabelled
satisfied** — because a prose-only DS3 re-admits the exact reconciliation drift the
framework exists to abolish.

**Open residuals for Round 2.** (1) The panel fork above. (2) DS10/Herstatt handed to
the NS-02 currency workstream — the cross-currency settlement obligation as two legs
whose open state projects as Herstatt exposure; interface only, from here. (3) Temporal
Flags A and B (§5) — binding implementation seams, to be carried into the executable
property set. (4) The executable properties themselves: the N2 identity as a
property over generated settlement histories (buy, sell, partial chains, fails,
restatements), with the classification shown to *fire* on each class — zero firings is
a defect, not a green test.
