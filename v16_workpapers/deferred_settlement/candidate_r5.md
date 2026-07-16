# Deferred Settlement, v16-Native — Round 5 Candidate

**Cell:** deferred-settlement design cell. **Author:** TuringAward (first-principles lead).
**Supersedes:** `candidate_r4.md`. **Round-5 tally:** 1 APPROVE (jane-street, residual
folded in), 6 BREAK — each its reviewer's sole blocker, all adopted; all R4 items held.
**TA-scoping: ruled UMBRELLA, 7/7 unanimous** — instantiated in §8 with all three
mandated caveats. Per the convergence note, the six breaks land as five mechanism
changes: the penalty-regime completion (B1+B4), the settled-mass doctrine (B2 +
jane-street), the dispatch-intent re-keying (B3), the axis decoupling (B5), and the
terminal-return write-off (B6). Every item answered in §9. **Status:** Round 5
candidate. Not the final .tex. Not committed.

---

## 1. The problem (settled since Round 2; held)

Buy 100 XYZ at $50.00 Monday, T+2. Economics complete at T; custody moves Wednesday;
Tuesday's close at $52.00 makes +$200.00 real before anything moves. The bound between
the internal record and the custodian's — the binary reconciliation invariant over a
projection, with external assertions crossing the one door — is this candidate. v16.0
carries everything else.

## 2. Classification (delta from Round 4 only)

- **Safety.** Two remaining real-break paths close: the CSD's monthly net penalty cash
  now has a recorded counterpart before it hits the nostro (B1), and a terminally
  failed return now has a recorded owned-plane consequence (B6). One remaining
  race closes: live(ref) is keyed on a fact recorded **before** the send (B3), meeting
  the unrepresentable-not-unlikely standard the send/receipt gap failed.
- **Liveness/races.** A third cross-cutting rule joins the Spine and the Binding:
  **settled mass is terminal** (§3.0c) — it decides every race between settlement and
  repair in settlement's favour, uniformly (B2 + jane-street's residual).
- **Decidability.** The last judgement band dies: EXPECTED-DIFF is retired for three
  decidable checks over attested inputs under governed tolerances (B4).
- **Reporting.** The settlement-mechanism axis and the CDM/TR intent axis are
  orthogonal and now separately recorded (B5) — no TR lifecycle event is fabricated by
  a settlement-layer round trip.

## 3. The design

**Thesis (held).** v16.0 contains the deferred-settlement design; this candidate is the
bound. Three cross-cutting rules now carry the correctness architecture: **the Spine
pins the read; the Binding pins the write; Terminality pins the race.**

### 3.0a The Spine (held from Rounds 3–4)

Everything the identity reads folds in force at the statement's valid-time — balances,
in-flight legs, W(a), tolerances, keys; declared data amended forward-only; revocations
carry t_c. Delete-tests held.

### 3.0b The Binding (held from Round 4; one restatement for successors)

Every transaction that creates or changes a settlement-obligation unit's legs derives
legs and balance moves from one restated parameter set. **Restated for re-instruction
(R5-B2):** the successor's legs derive from the restated parameter **net of the mass
already settled under the cancelled reference**, both read from the record: successor
legs = restated total − settled mass; compensating `owned` moves = restated total −
previously booked total. Only non-settled legs retire; a settled leg is never touched.
Still one parameter — the Binding reads recorded settled mass, it does not take a
second free input.
*Delete-test (the netting clause):* delete it and R5-B2's numbers return — partial 30
settled, restated 90, literal successor legs 90: predicted depot 0 against statement
30, r = +30 and r = −$1,500.00, the settled mass double-counted by the very rule that
exists to make mismatches unconstructible.

### 3.0c Terminality — settled mass is terminal (new; R5-B2 + jane-street, one doctrine)

**Rule.** *Recorded settled mass is never retired, never re-instructed, never raced.*
Two corollaries, one doctrine:

- **Successors net it (R5-B2).** A re-instruction retires only non-settled legs and
  mints successor legs net of settled mass (§3.0b). Composition property, executable:
  over any partial-then-re-instruct history, settled mass + successor legs = restated
  total, and Δpredicted(a, u) = 0 at every intermediate instant. First-class lifecycle
  mechanisms are property-tested **in composition**, not singly — adopted as a standing
  test-regime rule.
- **Settlement beats cancel (jane-street).** A settlement confirmation arriving on a
  unit whose cancellation is pending resolves in settlement's favour — the unit walks
  `settled` (DS7: terminal); the pending repair re-routes to a post-settlement
  compensating adjustment (an ordinary new transaction), never a hung amendment waiting
  on a cancel confirmation that will never come. The identity stays sound throughout —
  the settled mass is on both sides — and the stall is M7-visible on the repair item.

*Delete-test:* delete the doctrine and the two races diverge case-by-case: one
implementation retires a settled leg (mass vanishes against a statement that shows it —
permanent break), another hangs the amendment on a dead cancel (M7 rot behind a green
identity). One sentence decides every such race the same way; that is what a doctrine
is for.

### 3.1 Existing v16 mechanisms (held; E1–E9 with delete-tests as in Rounds 3–4)

E1 trade-date booking · E2 the settlement-obligation unit · E3 moveless discharge ·
E4 the partial edge · E5 market claims / four quadrants · E6 registry, routing,
quarantine, capture · E7 the due-date watch · E8 bitemporal doctrine, forward repair ·
E9 witness-before-signal.

### 3.2 The mechanisms (deltas; N1, N5, N6, N7 touched)

**N1 — The custody-witness event kind (held; asserter classes enumerated).** The kind
family's three asserter classes are now explicit, as the umbrella ruling requires:
**balance statement** (custodian/CSD book), **penalty advice** (semt.044, the CSD's
penalty calculation), **emission receipt** (dispatch-intent, dispatch receipt,
cancellation confirmation — our own gateway and the CSD on our instructions). All cross
under the same discipline: typed fields, provenance, tip-only supersession, quarantine.
The emission receipts are flagged for what they are: **internal-egress witnesses** —
our gateway attesting our own send — whose detection is indirect (§8).

**N5 — The penalty regime, completed (R5-B1 + R5-B4; with R4's fold and identity held).**

- *The penalty cash leg (R5-B1).* The CSD collects penalties as one monthly net amount
  per participant, with no trade behind it. The reconciled penalty is therefore an
  obligation like any other and books as one: on reconciliation of the period's advices
  (below), one transaction — derived under the Binding from the reconciled net amount —
  books the charge on `owned`(USD) and mints a **penalty settlement-obligation unit**
  (cash-only directed leg, dueDate = the CSD's collection date, reference = the
  participant/period netting reference; per-root granularity stays in the
  reconciliation identity; the cash unit is the net, mirroring how the CSD actually
  debits). Trade-date-style booking of the liability; the in-flight leg carries the gap;
  the collection confirmation (camt.054) discharges the unit. Receivable side symmetric.
  The identity tracks by construction: before collection, LEAD-LAG named by the penalty
  unit; on collection, CLEAN. No excluded coordinate, no carve-out — the alternative
  form (a payable coordinate the identity ignores until settled) is rejected because an
  identity with an exclusion list is an identity with a hole an auditor must memorise.
  *Delete-test:* delete it and R5-B1's numbers stand: the $26,000.00 monthly collection
  hits camt.053 with predicted unchanged — r = −$26,000.00 BREAK, recurring every
  cycle, bidirectional — the exact "external cash movement with no recorded internal
  counterpart" defect this design exists to abolish, one regime over.
- *EXPECTED-DIFF retired (R5-B4).* The penalty-reconciliation classification loses its
  fuzzy middle class. Three decidable checks replace it: **(1) internal arithmetic** —
  the advice's own fields must satisfy quantity × its-reference-price × rate =
  its-amount, exact in integer minor units, else BREAK (the advice is internally
  inconsistent: R5-B4's $500.00 overcharge dies here, whatever any band says);
  **(2) attested reference price** — the CSD reference price crosses the door as data
  (N1 family) and must lie within a **governed de-minimis tolerance** (B2 discipline:
  named owner, audit trail) of our recorded close, else BREAK — the genuine $25.00
  convention difference lives inside a governed price tolerance, a named quantity with
  an owner, not an ungoverned amount band; **(3) quantity fold** — the advice's failing
  quantities must equal our dated-clip step function per root reference, exactly, else
  BREAK. All three pass ⟺ CLEAN. Two classes, all predicates decidable.
  *Delete-test:* delete the arithmetic check and an internally inconsistent advice is
  judged only against our expectation inside a band sized for convention noise — the
  $525.00 total difference sits inside any band wide enough for the honest $25.00, and
  a real overcharge is silently paid: B2's masked-loss backdoor, one regime over.

**N6 — Repair, on two orthogonal axes (R5-B3 + R5-B5; Binding and Terminality inside).**

- *The settlement axis, re-keyed (R5-B3).* The two settlement mechanisms are
  **in-place repair** (instruction not yet dispatched: compensating moves + leg
  amendment, one transaction) and **cancel-and-re-instruct** (dispatched: cancel, then
  on the recorded cancellation confirmation one atomic transaction — retiring
  non-settled legs, netting settled mass, minting the successor with a new root
  reference). The discriminator is live(ref) — now keyed on the **dispatch-intent**
  fact, recorded through the door **before** the send: the egress dual of
  witness-before-signal (E9), and the same record-not-hope reasoning that gates
  successor emission on the recorded cancel confirmation. live(ref) ⟺ recorded
  dispatch-intent ∧ no recorded cancellation confirmation. A send that fails after
  intent leaves live = true conservatively; the cancel round-trip returns
  "unknown reference", recorded as cancellation-equivalent, and the unit re-opens for
  in-place repair — the error costs a round-trip, never a break.
  *Delete-test:* delete intent-keying and R5-B3's interleaving stands — send at
  09:00:00.000, receipt recorded 09:00:00.400, correction at 09:00:00.200 reads
  live = false, amends in place to 90 while REF-001 is matched at the CSD for 100;
  Wednesday settles 100: r = +10 / −$500.00, permanent — R4-B2's exact break, back
  through a 400-millisecond window. "Rarely" is not "unrepresentable."
- *The intent axis, decoupled (R5-B5).* Which settlement mechanism runs says nothing
  about what the event **is**. The recorded repair event carries its economic intent as
  its registered kind — **booking-error correction** or **agreed economic amendment**
  (C-4.12: kinds declared before they cross) — and the CDM/TR projection reads intent
  alone: booking error → one `WorkflowStep.action = Correction` (whatever the
  settlement layer did about dispatch); agreed change → terminate + new BusinessEvent /
  QuantityChange. The cancel-confirmation maps to CDM action = Cancellation **of the
  instruction**, not of the trade. A booking error on a dispatched instruction is both
  things at once — a TR Correction and a settlement re-instruction — and the record
  says so without fabricating a lifecycle event or a phantom 100-share trade.
  *Delete-test:* delete the decoupling and R5-B5's counterexample stands: a booking
  error discovered post-dispatch files terminate + new BusinessEvent — two TR lifecycle
  events where the regime expects one Correction, and an audit record asserting a
  100-trade that never economically existed; the mirror mislabels a genuine
  pre-dispatch amendment as a Correction. The taxonomy error is a reporting breach, not
  a style point.

**N7 — The possession plane, completed (R5-B6; recall symmetry held from Round 4).**
The paired lent-coordinate recall, the possession leg serving both sides, and
micro-case A′ are held. The missing terminal edge is added:

- *Terminal failure of a return — the write-off is the close-out's recorded move.*
  When a recalled loan's return fails terminally and the loan closes against collateral
  (GMSLA 9.3 mini close-out), the return unit's terminal walk **routes into the
  certified §9 close-out** and the routing carries the one move Round 4 lacked: the
  lender's securities entitlement converts to a valued claim — `owned`(SIGMA) moves off
  the lender in the close-out transaction (supervised, §14.1 discipline), CLM-CO minted
  at the default valuation, collateral applied by the certified machinery. The identity
  then closes honestly: owned 0 = depot 0, CLEAN — the shares are gone and the record
  says what we hold instead: a claim, valued, collateral-backed. A subsequent buy-in to
  re-establish the position is an **ordinary new purchase** (new unit, own settlement
  window), booked after the write-off — owned goes 0 → 1,000,000 with its own in-flight
  leg, never 1,000,000 → 2,000,000.
  *Delete-test:* delete the write-off move and R5-B6's numbers stand: RU-1 extinguished,
  owned(SIGMA) = 1,000,000 against depot 0 — r = −1,000,000, a **permanent real break**
  the classification cannot excuse (no live unit names it); the buy-in variant books
  owned = 2,000,000 against depot 1,000,000 — a double-long mismark on top. Worked in
  §6 micro-case A″.
- *DS9, restated honestly (per the reviewer's own alternative, taken together):* the
  no-second-long guarantee is **trade-plane by N4, possession-plane by this edge** —
  the disposition in §7 says exactly that and no more. The Round-4 wording ("completed
  by N4") over-claimed; it is corrected, not narrowed-and-relabelled (CLAUDE.md §1).

### 3.3 DvP atomicity (held, affirmed four rounds running)

Ledger-level paired-leg atomicity at the door; external-CSD atomicity reconciled via
the identity, never enforced.

## 4. The fold (rows 4, 8, 14, 15 revised; row 16 new)

| # | Event (kind) | Folds into |
|---|---|---|
| 1 | Execution / instruction | Binding-derived paired re-book + unit at `instructed` (directed plane-tagged legs, dueDate, discharge predicate, positive inherited floor, root reference, per-unit channel). Atomic-finality venue (TA-TERMS): born `settled`, no timer. |
| 2 | Price close | Recorded observation; valuation/PnL are further folds. |
| 3 | Settlement confirmation | Moveless walk `instructed → settled`; in-flight → 0. **Racing a pending cancellation: settlement wins (Terminality); the repair re-routes post-settlement.** |
| 4 | **Repair event (kind carries intent: booking-error correction / agreed amendment)** | Settlement axis by live(ref): **in-place repair** (no recorded dispatch-intent) or **cancel-and-re-instruct** (intent recorded): on the recorded cancel confirmation, one atomic transaction — retire non-settled legs, **net settled mass**, mint successor (legs = restated − settled; new root reference). Δpredicted = 0 by shape. CDM/TR projection reads the intent axis only. |
| 5 | Partial confirmation, clip q | Recorded always (dated — penalty-fold input). ≥ floor: split (floor, root ref inherited). Below: accumulates on the one live residual. |
| 6 | Fail notice / due-date watch, cumulative < Q | Walk `instructed → failed` on the remainder; fails cascade. |
| 7 | Custody statement | Moveless observation; identity under the Spine; classification at read; LEAD-LAG lines join naming units' M7 status. |
| 8 | Recall / return (N7) | Paired lent-coordinate move + possession leg (Binding-derived). Return confirmation: `settled`. **Terminal return failure: routes to §9 close-out — owned write-off move, CLM-CO at default valuation, collateral applied; any buy-in afterwards is an ordinary new purchase.** |
| 9 | Scheduled-statement watch (calendar-aware) | Overdue open item for the account. |
| 10 | Buy-in delivery confirmation | Discharges the failed residual (trade plane, N4); buy-in date = penalty right endpoint. |
| 11 | Record-date watch inside the gap | Market-claim leg or mirror; claim units outside the identity's range. |
| 12 | Registry / tolerance / key amendment | Forward-only recorded amendment with valid-time; revocation carries t_c. |
| 13 | Restated statement / finality (tip-only supersedes) | Longer log; identity nets the tip; both views deterministic. |
| 14 | **Dispatch-intent → send → dispatch receipt; cancellation confirmation (N1, emission receipts)** | Intent recorded through the door **before** the send (egress dual of E9); live(ref) ⟺ intent ∧ ¬cancel-confirmation; "unknown reference" on cancel records as cancellation-equivalent. |
| 15 | **CSD penalty advice (semt.044)** | Moveless observation; reconciliation by three decidable checks — internal arithmetic, attested reference price under governed tolerance, quantity fold per root reference — **CLEAN / BREAK only** (EXPECTED-DIFF retired). |
| 16 | **Penalty reconciliation complete for a period (R5-B1)** | One Binding-derived transaction: `owned`(USD) books the net charge/receivable and the **penalty settlement-obligation unit** is minted (net per participant/period, dueDate = collection date); the collection's camt.054 discharges it. Identity: LEAD-LAG before collection, CLEAN after — never a recurring BREAK. |

State after the fold: the log; nodes in UnitStatus; `owned`, lent, possession
coordinates in PositionState. Everything else is a projection — including emission
status, penalty expectations and reconciliations, and both classifications.

## 5. Temporal mapping (deltas from Round 4)

Held: unit-workflows, activities, timers-carry-timing, log-position signals, Flags A/B,
no timer for atomic-finality units, R-02 wipe test. Two deltas:

- **Egress ordering is intent → send → receipt-capture (R5-B3):** the emit activity is
  preceded by the dispatch-intent write through the door — the egress dual of
  witness-before-signal. live(ref) re-derives from the log at every point in the
  sequence; the send/receipt gap carries no decision weight. Idempotence still rides
  (unit, node): a retried emit finds the intent recorded and does not double-send.
- **The settlement-beats-cancel race (Terminality)** needs no Temporal machinery: both
  facts arrive as recorded events; the unit's contract reads the node — if `settled`
  is recorded, the cancellation path re-routes the repair to a post-settlement
  adjustment. No compensation logic lives in the workflow (R-24 held).

## 6. The running example (core and micro-cases held; three additions)

Core (held): T LEAD-LAG/LEAD-LAG; **T+1 +$200.00 unrealised, custody untouched**; T+2
CLEAN/CLEAN. Fail, buy-in ($150.00 differential on the failing seller), cash-in-lieu,
partial 60/40 with sub-floor aggregation, amendment REF-001→REF-002 (§3.2 N6 numbers),
recall micro-case A′ both-sided, CA-on-in-flight micro-case B: all held.

**Addition 1 — partial × re-instruction composition (R5-B2, Terminality).** Buy 100 @
$50.00, REF-001. A 30-clip settles: SO-1s (30, `settled`), SO-1r (70, `instructed`).
Statements: depot 30, nostro 998,500.00; owned XYZ 100, USD 995,000.00; in-flight
in 70 / out 3,500.00. Predicted: depot 100 − 70 = 30 ✓; nostro 995,000 + 3,500 =
998,500 ✓ CLEAN/LEAD-LAG. Now the trade is restated to 90: live(REF-001) ⇒
cancel-and-re-instruct. On the recorded cancel confirmation, one atomic transaction:
compensating moves owned(XYZ) 10 → seller, owned(USD) 500.00 ← seller (restated 90 −
booked 100); retire **SO-1r only** (SO-1s untouched — settled mass is terminal); mint
SO-2 with legs **60 = 90 − 30** / $3,000.00, root REF-002. After: owned XYZ 90, USD
995,500.00; predicted depot = 90 − 60 = **30** = statement ✓; predicted nostro =
995,500 + 3,000 = **998,500** = statement ✓. Δpredicted = 0 through the composition.
(Literal Round-4 Binding would have minted 90: predicted depot 0 vs 30 — r = +30, the
double-count, now unconstructible.) Settlement of REF-002's 60 later: depot 90, nostro
995,500 — CLEAN/CLEAN.

**Addition 2 — the penalty cash cycle (R5-B1 + R5-B4).** During a fail, the CSD's
semt.044 advices for the period reconcile: each passes the arithmetic check (its own
qty × ref-price × rate = its amount, exact), its reference price sits within the
governed tolerance of our recorded close, and its failing quantities equal our
dated-clip fold — CLEAN. (The R5-B4 forgery — ref $52.00, amount $3,100.00 against its
own $2,600.00 arithmetic — dies at check 1, whatever our expectation was.) Period net:
we owe **$26,000.00**, collection date the 15th. Fold row 16 fires: owned(USD)
26,000.00 → CSD penalty counterparty; penalty unit P-2026-06 minted, leg 26,000.00,
due the 15th. Identity now: predicted nostro = (owned − 26,000) + 26,000 (in-flight
out) = unchanged = statement ✓ **LEAD-LAG named by P-2026-06**. On the 15th the CSD
debits: camt.053 down 26,000.00; the camt.054 discharges P-2026-06; predicted =
owned − 26,000 + 0 = statement ✓ **CLEAN**. Without row 16: r = −$26,000.00 BREAK on
the 15th, every month, forever.

**Addition 3 — micro-case A″: terminal return failure (R5-B6).** Continuing A′: RU-1
open, borrower defaults terminally; SIGMA marks $10.00. GMSLA 9.3 mini close-out —
one supervised §9 close-out transaction: **owned(SIGMA) 1,000,000 moves off w_L**
(securities entitlement converts to claim); CLM-CO minted at default valuation
1,000,000 × $10.00 = $10,000,000.00; cash collateral held $10,200,000.00 applied
10,000,000.00 to the claim, excess 200,000.00 returned to the estate — all by the
certified collateral/close-out machinery, every move paired, Σ = 0 per unit.
Identity after: predicted depot a_L = owned 0 − lent 0 + 0 − 0 = **0** = statement 0 ✓
**CLEAN** — where Round 4 left r = −1,000,000 permanent. Re-establishing the position
is a new buy of 1,000,000 SIGMA: owned 0 → 1,000,000 with its own unit and window —
never 2,000,000.

**Sample report line (fail variant, held):** r = 0 lines carry their naming units' M7
status — "SO-1 failed, overdue 1 bd" in print next to the green number.

## 7. DS1–DS19 disposition (Round-5 deltas; counts unchanged: 18 satisfied-or-closed · 1 routed · 0 rejected)

Held: DS1, DS2, DS4, DS5, DS6, DS7, DS8, DS10 (routed), DS11a, DS11b, DS12, DS15,
DS16, DS17, DS18, DS19.

| DS | Round-5 delta |
|----|---------------|
| DS3 | **Held closed; last real-break paths removed.** The penalty cash cycle (row 16) and the terminal-return write-off (N7) eliminate the two recurring/permanent BREAKs Round 4 still permitted; the intent-keyed live(ref) closes the last race that could manufacture one. |
| DS9 | **Restated honestly (R5-B6).** Buy-in/compensation closure is **trade-plane by N4** and **possession-plane by N7's terminal edge**, which routes to the certified §9 close-out and carries the recorded owned write-off move. The Round-4 wording "completed by N4" over-claimed and is corrected — not relabelled (CLAUDE.md §1). |
| DS14 | **Completed and hardened.** Expectation (dated clips), reconciliation (three decidable checks, attested reference price, governed tolerances — EXPECTED-DIFF retired), and now the **cash settlement** of the reconciled net (row 16). The full penalty regime is computable, reconciled, and booked. |

## 8. Boundary notes

**TA-CUSTODY — instantiated under the unanimous UMBRELLA ruling (7/7), with the three
mandated caveats in the text.**

*Proposition:* a recorded external assertion of this family faithfully renders its
asserter's book. The family's asserter classes are enumerated and closed: **(i) the
balance statement** — the custodian or CSD asserting account balances (camt.053, depot
statement); **(ii) the penalty advice** — the CSD asserting its penalty calculation
(semt.044); **(iii) the emission receipt** — the gateway or CSD asserting the lifecycle
of our own instructions (dispatch-intent, dispatch receipt, cancellation
confirmation). A new named trust assumption is earned by a different **proposition**,
never by a different publisher or message family — the panel's governing reason,
adopted as the registry's standing rule.
- **Owner:** data governance — tolerance schedules (balance and reference-price, both
  governed de-minimis), cadence contracts, key management, and the asserter-class
  registry are its named artifacts.
- **Violation:** an assertion misrenders the asserter's book; is forged or replayed;
  or ceases to arrive on cadence.
- **Detection, named per class — never collapsed into "same as custody":** for balance
  statements, the reconciliation identity classifying BREAK, plus signature/sequence
  verification and the cadence watch; for penalty advices, **the
  penalty-reconciliation identity — the three decidable checks — with appeal
  supersession riding the tip-only chain**; for emission receipts, detection is
  **indirect by construction**: the dispatch receipt is an **internal-egress witness**
  — our own gateway attesting our own send — so no independent party corroborates it,
  and a lie in it surfaces only downstream, when the settlement identity's statements
  contradict the emission story it told. This asymmetry is stated, owned, and priced
  in, not discovered in production.
- **Residual:** a misrender that coincidentally matches the internal book plus
  in-flight; and, for emission receipts, the window in which a false send-story has
  not yet met a contradicting statement.

The parked ch16 four→five spec-pass edit rides with this text. The Round-4
umbrella-vs-sixth-TA question is closed by the ruling; the caveats above are its
price, paid in full.

**CDM (R5-B5 adopted; rosetta's Round-4 naming superseded in part).** The settlement
mechanisms are **in-place repair** and **cancel-and-re-instruct** — settlement-layer
constructs, not CDM event classes. The CDM/TR image is driven by the recorded intent
axis alone: booking-error correction → `WorkflowStep.action = Correction` (one TR
event, both settlement mechanisms alike); agreed amendment → terminate + new
BusinessEvent / QuantityChange; instruction cancel-confirmation → action =
Cancellation **of the instruction**. The five gap rows and
moveless-observation ≠ CDM-Observation: held.

**Retired this round:** the EXPECTED-DIFF class (for two decidable classes); the
N6 form-names "Correction/Amendment" as settlement labels (for the two-axis
vocabulary); Round 4's DS9 wording.

## 9. Responses on the record (every Round-5 item)

- **UMBRELLA ruling — INSTANTIATED (§8):** four-part text carries all three caveats —
  asserter classes enumerated (correctness-architect); dispatch receipt flagged as an
  internal-egress witness with indirect detection (nazarov); semt.044's distinct
  detection named under the umbrella, appeal supersession included (sbl-specialist).
  The governing rule — a new TA is earned by a different proposition, never a
  different publisher — is adopted as a standing registry rule.
- **R5-B1 — ADOPTED (§3.2 N5; fold row 16; §6 addition 2):** the reconciled period net
  books as an owned charge plus a penalty settlement-obligation unit due on the
  collection date, discharged by the collection confirmation — LEAD-LAG then CLEAN,
  never a recurring BREAK; the excluded-coordinate alternative rejected as an identity
  carve-out.
- **R5-B2 — ADOPTED (§3.0b restated; §3.0c; §6 addition 1):** successor legs = restated
  total net of settled mass; only non-settled legs retire; composition property
  (settled + successor = restated; Δpredicted = 0 throughout) added to the executable
  set; the reviewer's 30/90 case worked to CLEAN where the literal Binding gave
  r = +30. Composition testing of first-class mechanisms adopted as a standing
  test-regime rule.
- **R5-B3 — ADOPTED (§3.2 N6; fold row 14; §5):** live(ref) keyed on the
  dispatch-intent fact recorded before the send — the egress dual of
  witness-before-signal; the 400 ms interleaving now reads live = true; failed-send
  edge resolves via cancellation-equivalent "unknown reference".
- **R5-B4 — ADOPTED (§3.2 N5; fold row 15):** EXPECTED-DIFF retired; three decidable
  checks — the advice's own arithmetic (kills the $500.00 overcharge outright), the
  attested reference price under a governed de-minimis tolerance with a named owner,
  the exact quantity fold — CLEAN/BREAK only.
- **R5-B5 — ADOPTED (§3.2 N6; §8):** emission status and CDM action decoupled into
  orthogonal recorded axes; settlement mechanisms relabelled in-place repair /
  cancel-and-re-instruct; intent carried on the repair event's registered kind; a
  booking error on a dispatched instruction is both a TR Correction and a
  re-instruction, and the record says so without a phantom trade.
- **R5-B6 — ADOPTED, both halves together (§3.2 N7; §6 addition 3; §7):** the terminal
  return routes to the certified §9 close-out **and** the routing specifies the
  owned-plane write-off move (owned → claim conversion, CLM-CO at default valuation,
  supervised); DS9 restated to its true scope — trade plane by N4, possession plane by
  this edge — corrected, not narrowed-and-relabelled.
- **jane-street residual — ADOPTED (§3.0c; fold row 3):** settlement beats cancel;
  the repair re-routes post-settlement; one doctrine with R5-B2 — settled mass is
  terminal — covering both races.
- **CONTESTED: none.** The one discretionary choice is argued in place: the penalty
  cash leg as a settlement-obligation unit rather than an identity-excluded payable
  coordinate (§3.2 N5) — an identity with an exclusion list is an identity with a
  memorised hole.

## 10. Residuals for Round 6 / the .tex

1. DS10 / Herstatt with the NS-02 currency workstream (interface only).
2. Executable-property additions this round: the partial×re-instruct composition
   property; the settlement-beats-cancel race (generated interleavings — the repair
   must always land post-settlement, never hang); intent-gap interleavings (no
   generated schedule may reach in-place repair after a recorded intent); the three
   penalty checks firing severally (each must catch its own forged advice); the
   terminal-return write-off (generated defaults leave r = 0 and exactly one CLM-CO).
   Zero firings is a defect.
3. The parked ch16 four→five edit rides with the .tex, its TA-CUSTODY text now final
   per the umbrella ruling.
4. Temporal conformance: Flags A/B; no-timer atomic-finality; intent → send →
   receipt-capture ordering; cancellation-equivalent handling of "unknown reference".

