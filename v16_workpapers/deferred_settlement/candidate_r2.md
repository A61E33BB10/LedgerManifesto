# Deferred Settlement, v16-Native — Round 2 Candidate

**Cell:** deferred-settlement design cell. **Author:** TuringAward (first-principles lead).
**Supersedes:** `candidate_r1.md`. **Adopts:** panel ruling DL-01 (unanimous 3-0); breaks B1–B9;
simplifications S1–S2; carry items T1–T6 from `reviews_r2.md`. Every item is answered on the
record in §9. **Status:** Round 2 candidate. Not the final .tex. Not committed.

Simplicity remains a gate: every mechanism — kept, new, or retired — carries a delete-test
answered with a concrete scenario. One Round-1 delete-test was wrong and is re-derived
honestly in §3.2 (N3): the reviewers' correction is adopted, not absorbed silently.

---

## 1. The problem

Equity markets settle on a delay. On Monday at 14:32:11 UTC we buy 100 XYZ at $50.00 —
$5,000.00 of cash against 100 shares, T+2, so the intended settlement date t_d is
Wednesday. The economic fact is complete on Monday: exposure, the cash owed, the dividend
entitlement. The custody fact happens on Wednesday: only then does the depository move the
shares into our depot and the cash agent debit our nostro. Between the two lies the **open
settlement window [T, t_d]**; its duration is a parameter — T+1 US, T+2 EU/UK, T+0 atomic
venues, T+5+ on a cross-border fail — never a doctrine.

The window makes a number real before anything moves. XYZ closes at $52.00 on Tuesday. The
book must show **+$200.00 of unrealised profit at Tuesday's close** — recognised,
capital-bearing, reported — while the custodian still shows $1,000,000.00 and zero XYZ,
exactly as on Monday morning. Both records are right; they describe different facts on
different calendars, attested by different authorities.

Collapse the two facts and the system fails one way or the other (the v11 strawmen): debit
the nostro at T and the daily statement breaks by $5,000 for two days with nothing to apply
Wednesday's real debit to; recognise nothing until t_d and Tuesday's $200 does not exist —
PnL, risk, and capital misstated. The design keeps both facts, separately observable and
separately attested, bound by an identity **computable inside the system** — a bound that
lives in prose is checked in a spreadsheet, and the spreadsheet is the second store of
truth this ledger exists to abolish.

v16.0 carries most of the answer already. NS-01 records what it does not carry: the custody
reconciliation identity, present in v11 as DS3 and as the SBL custodian check, absent from
the certified spec — "reconcile against the custodian" named at the boundary, never made
computable. The panel has now ruled (DL-01): the custodian statement **crosses the one
door** as a registered witness event kind, and the trust assumption this names,
**TA-CUSTODY**, is the fifth named assumption. This candidate closes exactly that gap, and
almost nothing else.

## 2. Classification (the seven questions, compact)

1. **Safety.** (i) The position recognised at T is never rewritten by any settlement event
   — no discharge, fail, partial, or buy-in touches `owned` (§11: "settlement failure is a
   recorded event, never a reversal"); the buy-in *binding* (B6) makes the replacement
   delivery discharge the failed residual rather than book a second long. (ii) Conservation
   per (unit, coordinate) at the one door, no carve-out. (iii) No node-walk without a
   recorded trigger; no recorded confirmation is ever dropped — there is no cap at which
   one could be (B5). (iv) **New:** the reconciliation residual r is zero within declared
   tolerance at every recorded statement — a binary invariant (S1). (v) No settlement fact
   lives outside the log: not in Temporal, not in a mirror wallet, not in a stored status
   or stored break.
2. **Liveness.** Every settlement-obligation unit reaches a terminal disposition by its
   deadline chain (M7); the due-date watch fires at t_d (M1); **and the statement stream
   itself is watched** (B3): a custodian that goes dark mints an overdue item on the
   declared cadence — silence is never a stale CLEAN.
3. **Failure model.** Machines: crash-recovery under durable execution; wipe the substrate
   and everything re-derives from the log (R-02). External parties: untrusted and
   reconciled — assertions cross only as recorded observations; faithfulness is TA-CUSTODY,
   now with an origin-authenticity clause (B8), so the adversary who forges or replays a
   statement is inside the model, not outside it. Loss and duplication: M2 at-least-once
   plus cause-derived idempotence; restatements are made deterministic by an explicit
   supersedes chain (B9).
4. **Consistency.** One writer, one total order (C-2.7). Internal vs external is eventually
   consistent by construction across the window; the identity quantifies the lag exactly,
   and the report projection names it EXPECTED-LEAD-LAG by a decidable predicate (B1) —
   never by judgement.
5. **Abstraction boundaries.** The one door admits; the settlement interface reads and
   emits; the statement is an observation on our log, never a mirror balance (the v11
   `csd_virtual` mirrors stay retired). W(a) — which wallets a custody account carries —
   is a total, disjoint, covering function per coordinate class (T1), so no mass is
   double-counted or orphaned across accounts. Temporal owns no fact (M4, M6, R-02).
6. **Cost.** The identity is a fold over `owned`, the lending/borrow projections, and the
   open settlement-obligation units: bounded by wallet count and open-unit count, never by
   transaction count. Exactly one residual leg is live per instruction at any instant
   (minsky's fact, B5), so the live-unit population is bounded by the instruction count.
7. **Representation risk.** Integer minor units throughout; comparison within a per-
   (account, currency) tolerance owned by TA-CUSTODY governance with a de-minimis floor far
   below single-wire materiality (B2) — the tolerance is a governed artifact, not an
   engineering constant, because it is otherwise the un-audited backdoor that reclassifies
   a $50,000 mis-debit as CLEAN. Witness identity is the cause-derived identifier; origin
   authenticity is cryptographic (B8), not conventional.

## 3. The design

**Thesis (unchanged from Round 1, sharpened by review).** v16.0 already contains the
deferred-settlement design; it is missing a *bound*, not a mechanism. The gap [T, t_d] is
carried by trade-date booking plus the settlement-obligation unit. What is new is small:
**(N1)** the custody statement crosses the one door as a registered witness event kind —
now panel-ruled (DL-01) — with typed fields, a freshness contract, origin authenticity,
and a supersedes chain; **(N2)** a **binary** reconciliation invariant over a projection,
with the three-way classification demoted to a report projection under decidable
predicates; **(N3)** the partial-split bound as a **min-partial-fill-size** declared term
with aggregation on the one live residual — the Round-1 depth cap is deleted as wrong.
Plus the buy-in binding (B6) and one honest sentence about DvP. No state outside the log.

### 3.1 Existing mechanisms that carry the load (cite; delete-tests held from R1)

The nine load-bearers stand as certified, each with its Round-1 delete-test unchallenged
in review; they are restated in one line each, delete-scenario in parentheses.

- **E1 — Trade-date booking (D3, §9 Timing).** `owned` re-books at instruction; the
  booking moment is a declared term. (Delete: strawman 2 — Tuesday's $200 unreportable;
  PnL, risk, capital misstated.)
- **E2 — The settlement-obligation unit (§11).** The gap lives as a unit; node
  `instructed → settled | failed` in UnitStatus; one product graph; one writer. (Delete:
  the gap has nowhere on the record to live — strawman 1's daily unexplained break, or
  free-floating state outside the three homes.)
- **E3 — Moveless discharge.** Settlement events walk the node and move nothing; `owned`
  already moved at T. (Delete: double-booked position, or reverse-and-reapply — history
  rewritten, against C-12.4.)
- **E4 — The partial edge (§11).** Split into settled leg q_s and residual q_r,
  q_s + q_r = Q, parent retired from the zero vector, routing leg-wise. (Delete: 60-of-100
  is one overloaded node — 40 phantom-settled or 60 falsely failed.)
- **E5 — Market claims, four quadrants (§11).** (Delete: a cum buy unsettled at the record
  date pays the deliverer with no recorded reconciling claim.)
- **E6 — Event-kind registry, routing, quarantine, capture (C-4.12, §8, M8).** (Delete:
  ad-hoc feed handlers silently drop the unrecognised statement; the first evidence is an
  unexplained break weeks later with no captured original.)
- **E7 — The due-date watch (M1, M4, M7).** Fires at t_d; reads cumulative confirmed
  quantity against Q; the contract proposes the walk. (Delete: a silent CSD leaves the
  unit `instructed` forever; the fail surfaces weeks late through aging identity
  mismatches.)
- **E8 — Bitemporal doctrine, forward repair (C-12.1, C-12.4, ch14).** (Delete: a restated
  camt.053 forces edit-in-place or a permanent false break.) B9 completes it for
  statements: determinism of *which* reading governs needs the supersedes chain — see N1.
- **E9 — Witness-before-signal (R-12, M8).** Facts through the door first; signals carry
  log position only. (Delete: Temporal becomes a second store; the R-02 wipe test fails on
  the first partial fill.)

### 3.2 What is genuinely new

**N1 — The custody-witness event kind (panel-ruled: it crosses the door).**
The custodian's and depository's account statements — camt.053, the depot statement — are
registered event kinds (B2 of ch16), carrying provenance (B1 of ch16), admitted through
the one door as moveless observation-recording transactions (M8), quarantined when
malformed (C-4.12). Never a mirror balance: an observation on the log that a projection
reads. Four review items harden the kind:

- *Typed fields (T2):* `{account, coordinate, balance (integer minor units), as-of,
  statement-id, supersedes-ref}`. The `account` must resolve in the account registry; an
  unresolvable account is not guessed at — it takes the W4 unresolvable-reference
  quarantine path (nazarov GAP-4), standing as a visible open item.
- *Freshness (B3):* every registered account declares an expected statement cadence; a
  scheduled-statement due-date watch (M1) mints an overdue open item when a statement does
  not arrive on cadence. A custodian that goes dark can never leave a stale CLEAN
  standing; this is the honest completion of TA-ARRIVAL for this kind.
  *Delete-test:* delete the freshness watch and the custodian stops sending on Tuesday;
  Monday's CLEAN classification stands silently for weeks — the identity holds vacuously
  against a statement that no longer describes the world.
- *Origin authenticity (B8):* the statement is authenticated under an identified key at
  source or gateway; key management is owned under TA-CUSTODY; detection is signature
  verification plus statement-sequence reconciliation. This is TA-CUSTODY's Detection
  companion clause — integrity is cryptographic, not a column convention.
  *Delete-test:* delete it and a forged camt.053 manufactures a false BREAK (operational
  denial-of-service on the recon desk) or, worse, a replayed stale statement masks a real
  one as false CLEAN.
- *Supersedes chain (B9):* a restatement carries an explicit `supersedes-ref` naming the
  statement it replaces; the identity nets only the superseding observation for a given
  (account, as-of). Both bitemporal views stay deterministic — no tie between two
  same-valid-time readings.
  *Delete-test:* delete it and two statements for the same as-of leave the corrected view
  underdetermined; two readers of one log disagree — internal reconciliation failure
  reintroduced through the repair path.

*Delete-test (the kind itself, unchanged in substance from R1 and now panel-affirmed):*
delete N1 and the identity's external side is never on the record; DS3 is not computable
inside the system — NS-01's exact state — and the check moves to an operations
spreadsheet: a second derivation of truth with no capture discipline, undecidable against
the ledger from the record alone.

**N2 — The reconciliation invariant (binary), and the classification (a report).**

*The projections.* For a real wallet w, unit u, over w's settlement-obligation units whose
node is not `settled` — each leg typed **directed** (payer→payee, coordinate, quantity)
(T3), so the signs below are total by construction, not by convention:

```
inflight_out(w, u) = Σ quantity of u on directed legs where w is payer/deliverer
inflight_in(w, u)  = Σ quantity of u on directed legs where w is payee/receiver
```

*The account map (T1).* W(a) — the wallets whose mass a custody account a carries — is a
**total function** wallet → account per coordinate class, disjoint and covering: every
wallet's mass in the class maps to exactly one account. (Sub-custody is already a wallet
partition in v16 §7; T1 types it.) Whether **lent** mass has left account a — title
transfer moves it, agency-internal lending keeps it — is a **declared term of the lending
agreement** governing W(a) membership (B4). Each account also declares its settlement
channel (internal vs CSD) and its CSD-of-reference (T4) — the fields CSDR Art.9
internalised-settlement reporting needs, read from registration, computed from nothing.

*The identity.* For every account a, unit u, at every recorded statement with as-of t,
define the predicted external balance and the residual:

```
predicted(a, u, t) = Σ_{w ∈ W(a)} [ owned(w,u) − lent_out(w,u) + borrowed(w,u)
                                    + inflight_out(w,u) − inflight_in(w,u) ]
r(a, u, t)         = statement_balance(a, u, t) − predicted(a, u, t)
F(a, u, t)         = Σ_{w ∈ W(a)} [ inflight_out(w,u) − inflight_in(w,u) ]   (the named lag)
```

(For cash, `lent_out` and `borrowed` are zero and the formula is the R1 cash identity;
for securities the −lent_out term is B4's correction, and the borrowed term folds in the
v11 SBL custodian check. Under v16 title-transfer financing lent mass re-books off `owned`
and contributes zero twice; under an agency programme whose declared terms keep the mass
internal, lent_out ≠ 0 carries it.)

**Invariant (binary, S1).** *At every recorded custody statement, r(a, u, t) = 0 within
the tolerance declared for (a, currency-or-unit-class).* That is the whole invariant:
every residual is either zero in tolerance or the statement disagrees with the book in a
way no live open unit names. Nothing three-valued is asserted at the invariant level.

**Tolerance (B2).** Per (custody account, currency), owned by TA-CUSTODY governance, with
a declared de-minimis floor far below single-wire materiality. It is a governed artifact
with an owner and an audit trail, because an engineering constant here is the un-audited
backdoor: a $60,000 tolerance silently reclassifies the $50,000 mis-debit as CLEAN.

**Classification (a §12 report projection, B1's decidable predicates).** Computed at
read, never stored:

```
CLEAN              ⟺  r ≈ 0  ∧  F = 0
EXPECTED-LEAD-LAG  ⟺  r ≈ 0  ∧  F ≠ 0      (age = first statement with this F ≠ 0)
BREAK              ⟺  r ≠ 0
```

Each predicate is decidable from the record alone; CLEAN and EXPECTED-LEAD-LAG are no
longer both "identity holds" (the R1 defect B1 named). Lead-lag runs in either direction
— the statement may lag the book or, when the register moves before the confirmation
message arrives, lead it; both give r ≈ 0 with F ≠ 0. **"Ripening" is deleted as
machinery (S1):** there is no classifier state that ages; the lag is named by live open
units, each of which already carries its own deadline under obligation liveness (M7) —
when the unit's deadline passes, *that* is the overdue item, and a residual no live unit
names is simply r ≠ 0: a BREAK now. A BREAK's identity for aging and resolution timelines
is (account, coordinate, residual sign) (T5); its age is the date of the first statement
showing that identity; it is recomputed from the log every time, never stored, and its
repair is forward-only under C-12.4.

*Delete-test (identity):* unchanged from R1 and affirmed by review — the custodian
mis-debits our nostro $50,000 for another client's wire; no internal event exists;
without N2 the ledger is wrong about the world with no mechanism that can ever notice;
with N2 the next statement shows r = −50,000: BREAK, same day (given B2's floor — the
detection holds only because the tolerance is governed).
*Delete-test (classification as a report):* delete the classification and every open
window flags daily — the standard buy alone shows a $5,000 residual explained by F on
Monday and Tuesday; tens of thousands of false alarms mute the report and the real break
sails through muted.
*Delete-test (binary invariant vs three-way invariant):* make the classification itself
the invariant and the invariant inherits three-valued edge disputes (is an aged lag a
break yet?) that no generator can decide; the binary form is what a property test can
falsify crisply — r ≠ 0 on any generated history with no injected external fault is a
firing counterexample.

**N3 — The partial-split bound: min-partial-fill-size + aggregation (B5/S2; replaces the
deleted Round-1 depth cap).**

*The Round-1 error, owned.* R1 proposed `splitDepthMax` (v11's D_max=2) with a delete-test
claiming an M7 liveness-queue flood of up to 10^6 live units. The count was wrong
(minsky): at each split the parent retires and the settled leg is terminal, so **exactly
one residual leg is live per instruction at any instant**. There is no flood of live
units; the real costs of unbounded splitting are fragmentation (units ever minted = clip
count; one paired-leg split transaction per clip; a fragment tree the penalty fold must
walk) — and the depth cap was not merely unnecessary but *harmful*: under T2S
auto-partial, one million shares can settle in ~10,000 clips; a depth cap of 2 would
declare a false 980,000-share CSDR fail, and its at-cap "fail whole" would ignore a
recorded 7-of-10 confirmation — dropping a witnessed fact, a DS4 violation. The cap is
deleted.

*The mechanism.* Two declared terms on the settlement-obligation unit, mirroring the
venue's own settlement discipline:

- **min-partial-fill-size** (the venue's minimum settlement quantity, e.g. T2S MSQ): a
  confirmation clip at or above the floor walks the split edge as certified — settled leg
  minted, one residual continues.
- **aggregate-remaining-fills**: a clip below the floor is recorded (every confirmation
  is a recorded observation — none is ever dropped) and **accumulates as cumulative
  confirmed quantity on the one live residual**; the split edge fires when the
  accumulated unsplit quantity reaches the floor, or at the unit's deadline, whichever
  first — at the deadline the residual walks with its cumulative confirmed quantity
  split out as settled mass and only the genuinely unconfirmed remainder failing.

Termination and bounds, by construction: cumulative confirmed quantity is monotone
non-decreasing and bounded by Q; live residuals per instruction = 1; splits ≤
Q / floor; fragmentation is proportional to log length only. NS-04 closes via this,
not via v11's D_max.

*Delete-test (the floor + aggregation):* delete them and the T2S clip storm mints a
settled leg and a fresh residual per clip — ~10,000 split transactions and a
10,000-deep fragment tree for one instruction, bloating the log and the Art.7 penalty
fold (B7) for zero informational gain, since the clips are already recorded as
observations. Reinstate the depth cap instead and the false 980k fail plus the dropped
7-of-10 confirmation return. The floor is a declared term, not machinery: venues differ
(T2S's MSQ is the venue's own number), exactly as the booking moment differs by
agreement.

**N4 — The buy-in binding (B6).** A buy-in executed against a failed residual is not an
independent purchase: its delivery confirmation **discharges the failed residual** — the
unit walks to `settled` on its compensation path (settled-by-buy-in), and no second
`owned` long is booked. The price differential is borne by the failing party through the
compensating transaction (worked with numbers in §6).
*Delete-test:* delete the binding and the buy-in books +100 `owned` while the original
residual still stands: the book shows 200 against an economic 100 — and the identity is
**blind to it**, because the bought-in 100 arrives at the depot while the residual's 100
stays in-flight: both sides inflate equally and r stays 0. This is the one defect in this
design's neighbourhood that N2 cannot catch, which is exactly why it must be a binding —
a recorded discharge predicate linking the buy-in to the residual — and not a detection.

**N5 — The root settlement-instruction reference (B7).** The unit's declared terms carry
the external root reference — the CSD matching reference and the intended settlement date
— **invariant across every recursive split**: every settled leg and every residual
inherits it verbatim. The CSDR Art.7 penalty projection is then a fold over the fragment
tree grouped by root reference, reconstructing the daily failing-quantity step function
the penalty regime bills against.
*Delete-test:* delete it and after three partial splits the fragments carry only internal
cause-derived identities; the CSD's penalty advice references the original instruction,
and nothing on the record joins them — the penalty is checked by hand against a
reconstruction, which is the spreadsheet again, one regime over.

### 3.3 DvP atomicity, stated honestly (affirmed by all reviewers; unchanged)

**What the ledger guarantees:** its own transaction atomicity. Delivery and payment are
one admitted paired-leg transaction — both `owned` legs re-book atomically at
instruction, and every node-walk is one transaction, conserving per (unit, coordinate) at
the single door.

**What it cannot guarantee:** the external CSD's own DvP atomicity. That is reconciled,
never enforced. A leg-inconsistent external fill — stock delivered, cash not — surfaces
through N2 as r ≈ 0 with F ≠ 0 on one side that the other side's statements never match,
until the unit's M7 deadline passes and the unmatched residual stands as r ≠ 0: a BREAK,
while the fails cascade carries the open leg. The door secures ledger-level atomicity;
the identity detects violations of settlement-level atomicity.
*Delete-test:* delete the statement and the first real leg-inconsistent fill is triaged
as "impossible" instead of read off the report.

## 4. The fold

Deferred settlement is a list of recorded events and their fold. No other state exists.

| # | Event (kind) | Folds into |
|---|---|---|
| 1 | Execution / instruction (existing kind) | One transaction: paired-leg `owned` re-book **and** the moveless minting of the settlement-obligation unit at `instructed` — declared terms: directed legs (T3), dueDate = t_d, discharge predicate, min-partial-fill-size (N3), root settlement-instruction reference (N5). |
| 2 | Price close (existing kind) | A recorded observation; valuation and PnL are further folds; nothing stored. |
| 3 | Settlement confirmation — sese.025 / camt.054 (registered kinds) | Moveless observation; routing names the unit's contract; the contract proposes the moveless node-walk `instructed → settled`. In-flight reads zero thereafter. |
| 4 | Partial confirmation, clip q (same kinds) | The recorded observation, always. If accumulated unsplit confirmed ≥ floor: the split transaction (settled leg; one continuing residual; Σ conserved; root reference inherited). Below floor: accumulates on the one live residual — no split, nothing dropped. |
| 5 | Fail notice, or due-date watch firing with cumulative confirmed < Q | Moveless node-walk `instructed → failed` on the unconfirmed remainder (confirmed mass splits out settled first); fails cascade carries the residual (M7). |
| 6 | **Custody statement — camt.053 / depot statement (N1)** | Moveless observation with typed fields {account, coordinate, balance, as-of, statement-id, supersedes-ref}; unresolvable account → W4 quarantine. Folds into no balance; read by the N2 projection; classification computed at read. |
| 7 | Scheduled-statement watch firing on a missed cadence (B3) | An overdue open item for the account — recorded, visible, aging; the statement stream is itself watched. |
| 8 | Buy-in delivery confirmation (B6) | Discharges the failed residual: the unit walks to `settled` on its compensation path; the compensating cash transaction routes the price differential to the failing party. No second long. |
| 9 | Record-date watch firing inside the gap (existing) | The market-claim leg or its mirror (certified, cited). |
| 10 | Restated statement or restated finality (same kinds, `supersedes-ref` set) | A longer log; the identity nets only the superseding observation per (account, as-of); both bitemporal views recompute deterministically (C-12.1, B9); monetary repair forward-only (C-12.4). |

State after the fold: the log; each unit's node in UnitStatus; `owned` in PositionState.
Everything else — balances, V_t, in-flight, r and F and the classification, the
instructions the interface emits, the Art.7 penalty step function (N5) — is a projection.

## 5. Temporal mapping (compact; the two Round-1 flags now binding)

- **Workflow = the settlement-obligation unit's own unit-workflow** (R-03/R-14), born
  `instructed` by signal-with-start on the recorded instruction; record-first backstop
  (R-27); cadence sweep re-starts missing workflows (R-09).
- **Activities:** capture-through-the-door (R-12 — before any signal), evaluate-contract
  (version-pinned, R-06/R-26), propose-to-the-door (the single idempotent write,
  R-01/M6), emit-instruction (egress only, writes nothing, R-24). Workflow code holds
  timers, signal-waits, selectors (R-05).
- **The timer at t_d** is the due-date watch's liveness half, carrying no data (M4): it
  wakes the unit; an activity reads cumulative confirmed against Q; the contract — never
  Temporal — proposes settled / split / failed. **A second timer family (B3):** the
  scheduled-statement watch per registered custody account, same M1 machinery, minting
  the overdue item on a missed cadence.
- **A witness signal carries the log position of an already-recorded fact** (R-11/R-12);
  a lost signal costs latency, never the record — the timer backstop reaches the same
  node later, identically. Sub-floor clips (N3) need no signal at all beyond capture:
  they change no node; the aggregate is read when the edge next evaluates.
- **The window [T, t_d] is the workflow's quiet wait**; the cycle is the timer duration
  read from dueDate; T+0 is a zero-length timer, no special path (affirmed).
- **Binding Flag A:** the partial split is **not** ContinueAsNew — the parent workflow
  completes and each leg starts by signal-with-start (R-14/DL-02); with N3 the split
  fires only at ≥ floor, so workflow turnover is bounded by Q/floor, not by clip count.
  (The plain `instructed → failed` walk is the same unit — same workflow, R-15 boundary;
  the market-claim branch is a branch — same workflow.)
- **Binding Flag B:** per-unit egress idempotence rides **(unit, node)**, never a
  Temporal run or attempt id — the same dedup discipline as §11's settle projection and
  the door's cause-derived txid (R-07).
- **Acceptance (R-02):** wipe Temporal and everything re-derives — nodes from UnitStatus,
  timers from dueDate and the account cadence registry, in-flight and r and F by
  projection. Temporal owns no quantity, no witness, no identity input.

## 6. The running example, computed in print

Buy 100 XYZ at $50.00. T = Monday 2026-04-30, 14:32:11 UTC; T+2, t_d = Wednesday
2026-05-04. Buyer wallet `w_us`, custody accounts a_cash (nostro) and a_dep (depot),
W(a) = {w_us} for both (T1: total, disjoint, covering). XYZ closes $50.00 / $52.00 /
$51.50. Trade-date booking. Here lent_out = borrowed = 0 throughout, so
predicted = owned + inflight_out − inflight_in per account.

**Pre-trade.** owned(USD) = 1,000,000.00; owned(XYZ) = 0. Statements: nostro
1,000,000.00; depot 0. V_pre = 1,000,000.00.
Identity — cash: predicted = 1,000,000 + 0 − 0 = 1,000,000; **r = 0, F = 0 → CLEAN**.
Depot: predicted = 0; **r = 0, F = 0 → CLEAN**.

**Monday, T — instruction.** One paired-leg DvP transaction TX1: move owned(XYZ) 100,
seller → w_us; move owned(USD) 5,000.00, w_us → seller; moveless mint of SO-1 at
`instructed` (directed legs: delivery 100 XYZ seller→w_us, payment 5,000.00 USD
w_us→seller; dueDate 2026-05-04; min-fill floor 10; root reference CSD-REF-001/ISD
2026-05-04).

*Conservation at T:* ΣXYZ = +100 − 100 = **0** ✓; ΣUSD = −5,000.00 + 5,000.00 = **0** ✓.

Balances: owned(XYZ) = 100; owned(USD) = 995,000.00. In-flight (directed, T3):
inflight_out(USD) = 5,000.00; inflight_in(XYZ) = 100. External unchanged.

V_T = 995,000.00 + 100 × 50.00 = **1,000,000.00** = V_pre — a fair exchange, zero PnL at
the trade instant.

Identity — cash: predicted = 995,000 + 5,000 − 0 = 1,000,000; statement 1,000,000 →
**r = 0, F = +5,000 ≠ 0 → EXPECTED-LEAD-LAG** (named by SO-1's payment leg).
Depot: predicted = 100 + 0 − 100 = 0; statement 0 → **r = 0, F = −100 ≠ 0 →
EXPECTED-LEAD-LAG** (SO-1's delivery leg).

**Tuesday, T+1 close $52.00 — the headline.** No moves; conservation vacuous.
V_{T+1} = 995,000.00 + 100 × 52.00 = **1,000,200.00**.

**PnL = +$200.00 unrealised — zero cash movement, zero custody movement.** The custodian
still reports 1,000,000.00 and 0; both classifications still EXPECTED-LEAD-LAG with
r = 0 ✓. The $200 is real, the custody silence is real, the record carries both.

**Wednesday, T+2 — confirmation.** sese.025 and camt.054 cross the door (moveless,
typed, authenticated per B8). SO-1 walks `instructed → settled` — moveless, conservation
vacuous ✓. `owned` untouched (DS1/DS7). In-flight → 0. Statements: depot 100, nostro
995,000.00.
Identity — cash: predicted = 995,000 + 0 − 0 = 995,000; **r = 0, F = 0 → CLEAN**.
Depot: predicted = 100; **r = 0, F = 0 → CLEAN**.
V_{T+2} = 995,000.00 + 100 × 51.50 = **1,000,150.00**; cumulative PnL +$150.00.
Settlement contributed zero to V at every step — PnL is a function of the marks alone.

**Fail-and-recover variant (with the B6 binding).** Monday and Tuesday identical; the
+$200.00 stands. Wednesday: no confirmation; the due-date watch fires; cumulative
confirmed 0 < 100; SO-1 walks `instructed → failed` on the full 100. `owned` untouched
(DS7): XYZ 100, USD 995,000.00. Statements unchanged (nostro 1,000,000, depot 0); the
legs remain in-flight under the still-unsettled unit, so **r = 0, F ≠ 0 →
EXPECTED-LEAD-LAG — not a false BREAK**; the overdue item is SO-1's own M7 deadline,
already visible (S1: no classifier aging).

*Recovery (a) — late confirmation:* walks SO-1 to `settled`; as the clean path above.

*Recovery (b) — buy-in, numbers conserved.* A buy-in executes Thursday at the 51.50
mark: 100 XYZ delivered by the buy-in counterparty. Under the binding (B6), this
delivery confirmation **discharges SO-1** — settled-by-buy-in — and books **no** new
`owned` long: owned(XYZ) stays 100. One compensating cash transaction, three paired
moves, all through the door:

| Move | USD | From → To |
|---|---|---|
| unearned trade-date payment returns | 5,000.00 | seller → w_us |
| buy-in price differential (CSDR: failing party bears it) | 150.00 | seller → w_us |
| buy-in consideration | 5,150.00 | w_us → buy-in cpty |

Σ per pair = 0; Σ over the transaction = (+5,000 + 150 − 5,150) on w_us = **0** ✓ —
owned(USD) stays 995,000.00: w_us has paid exactly $5,000.00 for its 100 shares, and the
$150 excess landed on the failing seller. External once settled: depot 100 (from the
buy-in counterparty), nostro 995,000.00 (−5,150 out, +5,150 in). Identity: **r = 0,
F = 0 → CLEAN** on both accounts. Without the binding: owned(XYZ) = 200 against an
economic 100, and r still 0 — the identity is blind to it (both sides inflate), which is
why B6 is a binding, not a detection.

*Recovery (c) — cash-in-lieu:* the compensating transaction unwinds at the 51.50 mark:
move owned(XYZ) 100 w_us → seller; move owned(USD) 5,150.00 seller → w_us. Σ per unit =
0 ✓. w_us: XYZ 0, USD 1,000,150.00; V = **1,000,150.00** — the +$150.00 crystallises as
realised PnL. SO-1 discharged by compensation; identity CLEAN once external catches up.

*Recovery (d) — declared defaulted:* the certified close-out path (§9), supervised
write-off fallback. Never a silent reversal; every step a recorded event.

**Partial variant (with N3; floor = 10).** Wednesday brings a clip of 60 (≥ 10): the
split edge fires — SO-s (60, `settled`), SO-r (40, `instructed`, root reference
inherited); **60 + 40 = 100**, parent retires from the zero vector ✓ (DS11a). Exactly one
residual is live. Statements: depot 60; nostro 997,000 (3,000 settled pro-rata).
Identity — depot: predicted = 100 + 0 − 40 = 60 → **r = 0, F = −40 → LEAD-LAG** on
exactly the residual; cash: predicted = 995,000 + 2,000 − 0 = 997,000 → **r = 0 →
LEAD-LAG** ✓.
Thursday, a T2S-style storm of sub-floor clips on SO-r: 7, then 7 again. Each is a
recorded observation (never dropped — DS4); each accumulates on the one live residual;
at 14 ≥ 10 the edge fires once — SO-s2 (14, `settled`), SO-r2 (26). Conservation:
14 + 26 = 40 ✓. At SO-r2's deadline with 0 further confirmed, it walks `failed` on 26
only; the cascade and any Art.7 penalty (fold over the fragment tree by root reference,
N5) run on 26 — never on quantity a recorded confirmation already covered.

## 7. DS1–DS19 disposition (updated for Round 2)

**Counts: 18 satisfied-or-closed (including DS3 and DS11b, closed by this candidate) ·
1 routed (DS10, to NS-02) · 0 rejected.** No DS *property* is rejected; the v11
*mechanism* stays retired.

| DS | Invariant | Disposition |
|----|-----------|-------------|
| DS1 | Economic-Exposure-at-T | **Satisfied** — `owned` re-books at instruction; no settlement event moves it (§9, §11). |
| DS2 | Conservation | **Satisfied** — by construction at the one door, per (unit, coordinate) (§4/§14). |
| DS3 | Reconciliation Identity | **Closed by this candidate under panel ruling DL-01** — N1 (statement crosses the door) + N2 (binary invariant r = 0; report classification). No longer parked. |
| DS4 | No Discharge Without Witness | **Satisfied — strengthened by B5's fix**: with the depth cap deleted there is no bound at which a recorded confirmation could be dropped; every clip is a recorded observation honoured by the edge or the deadline walk. |
| DS5 | Replay determinism | **Satisfied** (M5) — and extended to statements by the B9 supersedes chain: one deterministic reading per (account, as-of). |
| DS6 | Idempotency of finality messages | **Satisfied** — cause-derived identity at the door (M2/M8). |
| DS7 | Failure Non-Reversal | **Satisfied** — never a reversal; unwind only by compensating transaction (§11); worked in §6 recovery (c). |
| DS8 | Status monotonicity | **Satisfied** — product-graph property (§11, §14); cumulative confirmed quantity monotone under N3. |
| DS9 | Buy-In Compensation Closure | **Satisfied — completed by N4 (B6)**: the buy-in delivery discharges the failed residual (settled-by-buy-in); no unbound buy-in exists. |
| DS10 | Cross-Currency Herstatt Visibility | **Routed to the NS-02 currency workstream** — not silently absorbed; interface noted for Round 3. |
| DS11a | Partial Per-Step Conservation | **Satisfied** — certified partial edge; q_s + q_r = Q at every split, including aggregated sub-floor splits (§6). |
| DS11b | Partial Monotonicity + bound | **Closed via N3 (B5/S2)** — min-partial-fill-size + aggregation on the one live residual; monotone cumulative confirmed bounded by Q; splits ≤ Q/floor; live residuals = 1. NS-04 closes here, not via v11's D_max. |
| DS12 | Variant Degeneration T+0..T+5+ | **Satisfied** — declared terms; T+0 a zero-length timer (affirmed by review). |
| DS14 | CSDR penalty schema determinism | **Satisfied — made computable by N5 (B7)**: the root settlement-instruction reference is invariant across splits; the penalty is a fold over the fragment tree reconstructing the daily failing-quantity step function. |
| DS15 | Counterparty default close-out | **Satisfied** — certified close-out; the cascade routes into it (§9). |
| DS16 | Bitemporal restatement | **Satisfied** — longer log, never an edit; statement restatements deterministic via B9. |
| DS17 | Capability scoping on status writes | **Satisfied** — one writer, the unit's own contract (§11/§14). |
| DS18 | DvP Ledger-Level Atomicity | **Satisfied — ledger-level only, stated honestly (§3.3, affirmed)**; external-CSD atomicity reconciled via N2, never guaranteed. |
| DS19 | Witness-Identity Determinism | **Satisfied** — cause-derived identifier (M2/M8); origin authenticity for statements added by B8. |

## 8. Boundary notes, TA-CUSTODY, retired machinery, CDM gaps

**Closed in v16.0 — cited, not redesigned:** the partial edge (§11); the right-of-use
gate (§14; §9 case 3; §12 re-use projection; order-forced delivery of
bought-not-yet-settled positions); close-out netting (§9, one CLM-CO per master,
supervised write-off fallback).

**TA-CUSTODY (panel-ruled DL-01; jane-street's four-part structure).**
*Proposition:* a recorded custody statement faithfully renders the custodian's book —
the balances it asserts per account and coordinate are those the custodian's own record
shows at the statement's as-of time.
- **Owner:** data governance — the per-account tolerance schedule (B2), the cadence
  contract (B3), and origin key management (B8) are its named artifacts.
- **Violation:** the statement misrenders the custodian's book; is forged or replayed;
  or ceases to arrive on its declared cadence.
- **Detection:** the N2 invariant classifying BREAK (r ≠ 0); signature verification plus
  statement-sequence reconciliation (B8); the scheduled-statement watch minting the
  overdue item on non-arrival (B3).
- **Residual:** a misrender that coincidentally matches the internal book plus in-flight
  — undetectable by construction; the exact sibling of TA-KIND's residual.

TA-CUSTODY is a different proposition from TA-KIND (statement content-veracity versus
declaration-convention fidelity) with a different detection (the identity versus the
invariance witness) — the panel's ground for naming it fifth. **Parked spec-pass edit,
exact text:** ch16's "The boundary rests on four named trust assumptions and no other:
TA-KIND, … TA-TERMS, … TA-EXDATE, … TA-ARRIVAL …" becomes "…five named trust assumptions
and no other: TA-KIND, TA-TERMS, TA-EXDATE, TA-ARRIVAL, TA-CUSTODY", with the four-part
clause above appended to the enumeration. A spec-pass proposal, not a constitutional
amendment — the constitution names the trust-assumption pattern (C-4.12) and fixes no
count.

**Retired machinery (v11, plus one of ours).** `cpty_virtual` contras → the unit's
directed legs, in-flight computed never stored; `csd_virtual` mirrors → the statement as
observation (keeping the mirrors would store our own copy of the custodian's book — a
second store needing reconciliation against the statements that feed it, the disease
reintroduced as the cure); the L15 row and 8-state FSM → the unit's node; quorum tables →
not re-derived — **affirmed by nazarov: a statement is not a price; a W3-style quorum
over one custodian's own account would be theatre** — single registered custodian per
account, authenticity by B8, veracity by TA-CUSTODY; the stored BreakRegister and
materialised tx_status → projections. **And retired from Round 1: `splitDepthMax`** —
deleted per B5/S2; its delete-test miscounted live units (exactly one residual is live;
minsky) and its at-cap disposition dropped witnessed confirmations (DS4).

**Also affirmed by review, kept with the attack cited:** the $50k mis-debit detection
(reg-reporter — conditional on B2's governed floor); DvP honesty (all); T+0 degeneration
(jane-street); re-projection-not-storage (minsky, reg-reporter).

**CDM alignment (T6, rosetta — binding).** Four gap rows for the ch13-discipline
cross-walk in the .tex, and one correction adopted: the ledger's moveless
observation-recording transaction is **not** a CDM `Observation` (a CDM Observation is a
market observable feeding a payout calculation; ours is an admitted boundary fact).
Gap rows: (1) *settlement fail* — CDM carries transfer/settlement status as an
enumeration, not a first-class recorded fail event with a fails-cascade obligation: GAP;
(2) *partial settlement split* — CDM quantity-change lineage does not mint two successor
obligations with a conserved fragment tree: GAP; (3) *custody statement* — no CDM object
admits a custodian account statement as a recorded observation: GAP; (4) *the
reconciliation identity* — CDM treats portfolio reconciliation as process, not as a
computable invariant object: GAP. Rosetta refines the row wording in the .tex pass.

## 9. Responses on the record (every Round-2 item; one line each)

- **DL-01 — ADOPTED.** Statement crosses the door (N1); TA-CUSTODY named fifth with the
  full Owner/Violation/Detection/Residual structure, Detection = the identity, Residual =
  the coincidental misrender (§8); ch16 four→five edit parked with exact text.
- **B1 — ADOPTED.** Decidable predicates: BREAK ⟺ r ≠ 0; LEAD-LAG ⟺ r ≈ 0 ∧ F ≠ 0
  (age = first statement with F ≠ 0); CLEAN ⟺ r ≈ 0 ∧ F = 0 — in the §12 report
  projection (§3.2 N2).
- **B2 — ADOPTED.** Tolerance per (account, currency), owned by TA-CUSTODY governance,
  de-minimis floor far below single-wire materiality; named as the un-audited backdoor it
  otherwise is (§3.2).
- **B3 — ADOPTED.** Declared cadence per account + scheduled-statement due-date watch
  (M1) minting an overdue item on non-arrival; carried into N1, the fold (row 7), and the
  Temporal mapping (§5).
- **B4 — ADOPTED.** Identity gains −lent_out; whether lent mass leaves the account
  (title transfer vs agency-internal) is a declared term of the lending agreement
  governing W(a) (§3.2 N2).
- **B5 — ADOPTED, with the Round-1 error owned in print.** splitDepthMax deleted; the
  bound is min-partial-fill-size + aggregate-remaining-fills on the one live residual;
  the delete-test re-derived honestly (one live residual — no M7 flood; the real harms
  are fragmentation and at-cap misdisposition) (§3.2 N3; §6 partial variant).
- **B6 — ADOPTED.** The buy-in delivery discharges the failed residual
  (settled-by-buy-in); no second long; worked with conserved numbers, and the
  identity-blindness of the unbound case stated as the reason it must be a binding, not a
  detection (§3.2 N4; §6 recovery b).
- **B7 — ADOPTED.** Root settlement-instruction reference (CSD matching ref + ISD) a
  declared term invariant across every split; Art.7 penalty = fold over the fragment tree
  reconstructing the daily failing-quantity step function (§3.2 N5; DS14).
- **B8 — ADOPTED.** Origin authenticity as TA-CUSTODY's Detection companion: identified
  key at source or gateway, key management owned, signature-verify + sequence
  reconciliation (§3.2 N1; §8).
- **B9 — ADOPTED.** Explicit supersedes-ref chain; the identity nets only the superseding
  observation per (account, as-of); restatement determinism restored (§3.2 N1; fold row
  10; DS5/DS16).
- **S1 — ADOPTED.** The invariant is binary (r = 0 in tolerance); the classification is a
  §12 report projection; "ripening" deleted — aging is M7's, keyed on the open unit's
  deadline (§3.2 N2).
- **S2 — ADOPTED.** No depth term survives; one live residual carries cumulative fills
  (§3.2 N3).
- **T1 — ADOPTED.** W(a) a total function wallet → account per coordinate class, disjoint
  and covering (§3.2 N2).
- **T2 — ADOPTED.** Witness kind fields enumerated {account, coordinate, balance in
  integer minor units, as-of, statement-id, supersedes-ref}; unregistered account → W4
  unresolvable-reference quarantine (nazarov GAP-4) (§3.2 N1; fold row 6).
- **T3 — ADOPTED.** Legs typed directed (payer→payee, coordinate, quantity); in-flight
  signs total by construction (§3.2 N2; fold row 1).
- **T4 — ADOPTED.** Settlement-channel flag + CSD-of-reference on the account
  registration; CSDR Art.9 internalised-settlement reporting computable from registration
  (§3.2 N2).
- **T5 — ADOPTED.** Break identity = (account, coordinate, residual sign); age from the
  first statement showing that identity; recomputed, never stored (§3.2 N2).
- **T6 / rosetta's binding correction — ADOPTED.** Four CDM gap rows drafted per ch13
  discipline, and the correction carried: the moveless observation is not a CDM
  Observation (§8).
- **CONTESTED: none.** The one Round-1 position the reviews overturned (the depth cap)
  was overturned correctly; it is deleted, and the erroneous delete-test is re-derived
  rather than quietly dropped.

## 10. Residuals for Round 3

1. DS10 / Herstatt — with the NS-02 currency workstream; the cross-currency settlement
   obligation as two legs whose open state projects as exposure; interface only, from
   here.
2. The executable-property set for the .tex: the binary invariant over generated
   settlement histories — buys, sells, partial chains with sub-floor storms, fails,
   buy-ins (bound and unbound as mutation), forged and missed and restated statements,
   leg-inconsistent external fills — with every predicate shown to *fire*; zero firings
   is a defect, not a green test.
3. The parked ch16 four→five spec-pass edit rides with the .tex draft for CONCORDIA.
4. Temporal Flags A and B become implementation-conformance checks in the property set.

