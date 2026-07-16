# Deferred Settlement, v16-Native — Round 4 Candidate

**Cell:** deferred-settlement design cell. **Author:** TuringAward (first-principles lead).
**Supersedes:** `candidate_r3.md`. **Round-4 tally:** 2 APPROVE (rosetta, jane-street;
residuals folded in), 5 BREAK (R4-B1..B5) — all adopted; the convergence note is taken
whole: B1 + B2 + rosetta's naming compose into one N6 redesign; B4 is B1's analogue on the
possession plane; B3-secondary rides the redesign; B5 scopes the revocation. Every item
answered in §9. **Status:** Round 4 candidate. Not the final .tex. Not committed.

---

## 1. The problem (settled since Round 2; held)

Buy 100 XYZ at $50.00 Monday 14:32:11 UTC, T+2. Economically complete at T; custody moves
Wednesday. Tuesday closes $52.00: the book must show +$200.00 unrealised while the
custodian shows $1,000,000.00 and zero XYZ. Both records are right; the open window
[T, t_d] is a parameter, never a doctrine. The bound between the two records — the
reconciliation identity over a projection, with the custodian statement crossing the one
door (panel ruling DL-01) — is what this candidate specifies. v16.0 carries everything
else.

## 2. Classification (delta from Round 3 only)

- **Safety, sharpened by R4-B1/B4.** Round 3 *asserted* Δpredicted = 0 and possession-
  plane balance; Round 4 *constructs* them: every transaction that touches a
  settlement-obligation unit's legs derives legs and balance moves from one restated
  parameter (the Binding, §3.0b), so a mismatched correction or a one-sided recall is
  unrepresentable — the standard N3 set for T+0 now governs every leg-touching shape.
- **Consistency, completed by R4-B5.** The key-revocation flip-set is now a recorded
  coordinate (compromise-effective time t_c), so the re-quarantine scope is a
  deterministic projection — no judgement call survives into replay.
- **Abstraction boundary, one addition (R4-B3).** The CSD's penalty advice is an
  external assertion like any statement: it crosses the door as a registered kind and is
  reconciled by an identity — expectation vs assertion — never in a spreadsheet.

## 3. The design

**Thesis (held).** v16.0 contains the deferred-settlement design; this candidate adds
the bound. Two cross-cutting rules now carry the correctness architecture — **the Spine
pins the read; the Binding pins the write** — and the mechanisms N1–N7 hang off them.

### 3.0a The Spine — the as-of read-set rule (held from Round 3; one refinement)

Everything the identity reads — balances, in-flight legs, W(a), tolerance, key — folds
in force at the statement's valid-time. Registry facts, tolerances, and keys are
recorded declared data with valid-time, amended forward-only. Closes R3-B1/B5/G1; the
delete-test (three regressions, one sentence) stands.

*Refinement (R4-B5).* A key-revocation event **must carry a compromise-effective
transaction-time t_c**, recorded on the discovery event by its authoriser (data
governance; where genuinely unknown, the conservative default t_c = the key's activation
time — still recorded, still deterministic). The re-quarantine scope is then a
projection: **statements admitted in [t_c, discovery] and verified under the revoked
key**. Pre-t_c CLEANs are preserved; a forged statement planted after t_c loses its
classification; the flip-set is a recorded coordinate, not a judgement.
*Delete-test:* delete t_c and the scope is either "everything under the key" — ~10 weeks
of legitimate CLEANs nuked, their as-of dates unclassifiable, a manufactured hole in the
statement stream — or "post-discovery only" — the planted statement's classification
stands. Either way the flip-set differs by reviewer and by replay: non-determinism in
the one place (repair) determinism is the point.

### 3.0b The Binding — the one-parameter construction rule (new; R4-B1, closing R4-B4's root)

**Rule.** *Every transaction that creates or changes a settlement-obligation unit's
legs derives the legs and the balance moves from one restated parameter set.* At mint,
the trade's (Q, P) derives both the paired `owned` re-book and the unit's directed legs;
at correction, the restated (Q′, P′) derives both the compensating `owned` moves and the
leg amendment; at re-instruction, it derives the retiring unit's leg zeroing and the new
unit's legs; at recall, the recalled quantity derives both the **paired lent-coordinate
move** and the possession leg. The leg is never a free declared term standing beside a
move: a unit whose leg magnitude disagrees with its balance re-book **cannot be
constructed**.

Δpredicted(a, u) = 0 thereby stops being a hand-checked identity (Round 3's form —
R4-B1's finding) and becomes **a theorem of the transaction shape**, at instruction,
correction, re-instruction, and recall alike — the "unrepresentable, not merely
unlikely" standard N3 set for T+0, now uniform.

*Delete-test:* delete the Binding and R4-B1's malformed correction is door-admissible —
`owned` re-booked −10 while the leg is amended −8; conservation at the door holds (the
move pair sums to zero; the leg amendment is outside door conservation), yet r = −2
spuriously from the next statement, permanent, never self-healing: the exact failure N6
exists to abolish, reintroduced through N6's own door. The same deletion re-opens the
one-sided recall (R4-B4) and the latent base-mint gap (a mint whose leg says 100 while
its moves say 90 — a unit born lying about itself).

### 3.1 Existing v16 mechanisms carrying the load (held; one line each)

E1 trade-date booking. E2 the settlement-obligation unit. E3 moveless discharge (the
*discharge* walk moves nothing — see N7 for what was wrongly called moveless). E4 the
partial edge. E5 market claims / four quadrants. E6 registry, routing, quarantine,
capture. E7 the due-date watch. E8 bitemporal doctrine, forward repair. E9
witness-before-signal. Delete-tests as in Round 3.

### 3.2 The mechanisms (N1–N7; N6 redesigned, N7 rebuilt, N5 completed)

**N1 — The custody-witness event kind (held; one addition).** Typed fields, tip-only
supersession, W4 re-admission on reference resolution, calendar-aware cadence, origin
authenticity — all held. Addition (R4-B3): the kind family gains two registered
siblings, both under the same discipline (provenance, typed fields, tip-only
supersedes): the **CSD penalty advice** (semt.044 — reference price, SECR rate class,
amount, direction, period, advice-id, supersedes-ref for the appeal/amendment cycle) and
the **dispatch/cancellation receipts** for emitted instructions (the gateway's send
receipt; the CSD's cancellation confirmation), which make emission status a recorded
fact (used by N6's discriminator).

**N2 — The reconciliation invariant (held; one addition).** Binary invariant under the
Spine; decidable report classification; channel per-unit; claim units outside the
identity's range — all held. Addition (jane-street (a)): **each EXPECTED-LEAD-LAG line
in the §12 report carries the M7 status of its naming units** — on-time, or overdue N
days — a projection join from the same log. The binary invariant is untouched; the
green-dashboard-over-a-rotting-fail blind spot is closed: a lead-lag named by a unit
three days past its deadline reads as what it is.
*Delete-test:* delete the join and a failed unit ages invisibly behind r = 0 — the
report is green while the fail rots; the desk learns of it from the CSD's penalty
advice, which is the spreadsheet's cousin: detection after the fact.

**N3 — The partial-fill floor and the T+0 pin (held; one citation).** Floor positive
and inherited; atomic-finality units born `settled` in the instruction transaction, no
timer armed. Addition (jane-street (c)): the venue's atomic-finality declaration is a
declared term reconciled at the boundary under **TA-TERMS** (ch16 B7) — a misdeclared
venue is a perimeter matter with a named owner, not a silent assumption.

**N4 — The buy-in binding (held).** The buy-in delivery discharges the failed residual;
no second long; identity-blind if unbound, hence a binding. Now also constructed, not
asserted: the discharge derives from the buy-in's recorded parameter under the Binding.

**N5 — The penalty fold, completed both ways (R4-B3).** Held: the fold runs over dated
confirmation clips keyed by the root settlement-instruction reference; buy-in date is
the right endpoint. Two additions:
- *The advice crosses (R4-B3).* The semt.044 advice is a recorded observation (N1
  family). The **penalty-reconciliation identity** — per root reference and period, the
  internal dated-clip expectation against the advice's asserted amount — classifies
  **CLEAN / EXPECTED-DIFF (reference-price convention within declared tolerance) /
  BREAK**, the N2 pattern re-instantiated. DS14 stays fully closed: both the expectation
  and the reconciliation are computable inside the system.
  *Delete-test:* delete it and the fold computes an expectation nothing ever meets: the
  CSD's actual charge arrives on a statement line with no recorded counterpart, and the
  expectation-vs-charge join lives in a spreadsheet — the candidate's own N1 delete-test
  conceded this in Round 3; leaving it open would have been the same defect one regime
  over.
- *Re-instruction mints a new root reference (R4-B3-secondary).* A re-instructed unit
  carries a **new** CSD matching reference, never the retired unit's: the CSD treats the
  two instructions as distinct and penalises them separately, so the fold must too. The
  root reference is inherited across *splits* (same instruction) and fresh across
  *re-instructions* (new instruction) — two different lineages, now stated.

**N6 — Correction and Amendment (redesigned; R4-B1 + R4-B2 + rosetta, one mechanism).**
Round 3's N6 had an under-specified discriminator ("changes what the CSD will settle"
fires on every quantity change — so its own worked examples were re-instructions by its
own predicate) and permitted a real break. Redesign, three parts:

- **The discriminator is emission status, decidable from the record.** live(ref) ⟺ a
  recorded dispatch receipt exists for the unit's root reference and no recorded
  cancellation confirmation does (both are N1-family observations). Not a judgement
  about economics; a lookup.
- **Correction (no live ref).** CDM image: `WorkflowStep.action = Correction`. One door
  transaction: compensating `owned` moves and in-place leg amendment, both derived from
  the restated parameter (the Binding). Δpredicted = 0 by shape. The projection later
  emits the corrected instruction; the CSD only ever sees the corrected terms.
- **Amendment (live ref): mandatory re-instruction.** CDM image: terminate + new
  BusinessEvent. Cancellation of the live reference is emitted; upon the **recorded
  cancellation confirmation**, one atomic door transaction retires the old unit by
  compensation (legs zeroed via the Binding), applies the compensating `owned` moves,
  and mints the successor unit at `instructed` with a **new root reference** (N5); its
  emission is gated on the recorded cancel confirmation — an ordering read from the
  record, not from hope. **It conserves only because it is one atomic transaction**
  (jane-street (b)): split it and an intermediate state has owned moved with no unit
  carrying the gap.
- **Executable property:** no in-place leg amendment is admissible on a unit whose
  instruction has been emitted — the unit's one writer refuses the proposal; decidable
  from the record; property-tested over generated correction histories.

*R4-B2's numbers, re-run under the redesign:* buy 100 @ $50.00 emitted Monday as
CSD-REF-001; Tuesday the trade is really 90. live(REF-001) ⇒ amendment: cancel REF-001
(confirmation recorded Tuesday); one transaction — move owned(XYZ) 10 w_us → seller,
move owned(USD) 500.00 seller → w_us, retire SO-1 (legs 100/5,000 → 0), mint SO-2
(legs 90/4,500, root CSD-REF-002). After it: owned XYZ 90, USD 995,500.00; predicted
depot = 90 − 90 = 0 = statement ✓; predicted nostro = 995,500 + 4,500 = 1,000,000 =
statement ✓. Wednesday the CSD settles REF-002 at 90/$4,500: depot 90, nostro
995,500 — **CLEAN/CLEAN**. Round 3's in-place form would have left REF-001 matched at
100/$5,000 and settling Wednesday against a book predicting 90/$4,500: r = +10 and
r = −$500.00 — a real break, permitted by the old predicate, unrepresentable under the
new one.
*Delete-test (discriminator):* delete emission status and either every change is a
re-instruction (Round 3's own examples become unnecessary CSD round-trips — cost, no
safety) or in-place amendment reaches emitted instructions and R4-B2's break returns.

**N7 — Recall and the possession plane (rebuilt; R4-B4).** Round 3 called the recall
re-book "moveless" — wrong under the certified schema, where `lent` is a balance
coordinate and every balance change is a paired move per (unit, coordinate, agreement);
an in-flight leg is a projection and cannot be a conservation counterparty. Rebuilt:

- **The recall is a paired lent-coordinate move**, lender's `lent_out` against the
  borrower's `borrowed` (or the agreement's virtual contra where the borrower is
  outside the ledger), both derived with the return unit's possession leg from the one
  recalled quantity (the Binding). Σ over the lent coordinate is 0 at every instant —
  the word "moveless" is dropped for this transaction (it remains true of *discharge*
  walks, E3).
- **The return unit's one directed possession leg serves both sides:** the borrower is
  deliverer (inflight_out), the lender receiver (inflight_in) — one recorded leg, two
  identity readings.
- Both sides worked in §6 micro-case A′, including the borrower's +1M depot lead-lag
  that Round 3's single-sided story never showed.

*Delete-test:* delete the pairing and Σ_w over the lent coordinate is −1,000,000 for
the whole return window (R4-B4's arithmetic) — conservation broken on a certified
coordinate; keep "moveless" instead and lent_out cannot change at recall at all, so the
Round-3 false BREAK of the full loan size returns. The two horns close only as a paired
move.

### 3.3 DvP atomicity (held, affirmed three rounds running)

Ledger-level paired-leg atomicity at the door; external-CSD atomicity reconciled via
the identity, never enforced.

## 4. The fold (rows 1, 4, 8 rewritten; rows 14–15 new)

| # | Event (kind) | Folds into |
|---|---|---|
| 1 | Execution / instruction | One transaction, **all derived from the trade's (Q, P) under the Binding**: paired `owned` re-book + the unit at `instructed` with directed plane-tagged legs, dueDate, discharge predicate, positive inherited floor, root reference, per-unit channel. Atomic-finality venue (TA-TERMS): born `settled`, no timer. |
| 2 | Price close | Recorded observation; valuation/PnL are further folds. |
| 3 | Settlement confirmation | Moveless walk `instructed → settled`; in-flight → 0. |
| 4 | **Correction / Amendment (N6)** | live(ref)? **No — Correction:** one transaction, compensating `owned` moves + in-place leg amendment, both from (Q′, P′). **Yes — Amendment:** cancel emitted; on recorded cancel confirmation, one atomic transaction retires the old unit (legs → 0), applies compensating moves, mints the successor with a **new root reference**; emission gated on the recorded confirmation. Δpredicted = 0 by shape in both. |
| 5 | Partial confirmation, clip q | Recorded always (dated — penalty-fold input). ≥ floor: split (floor and root ref inherited). Below: accumulates on the one live residual. |
| 6 | Fail notice / due-date watch, cumulative < Q | Walk `instructed → failed` on the remainder; fails cascade. |
| 7 | Custody statement | Moveless observation; identity under the Spine; classification at read, **each LEAD-LAG line joined to its naming units' M7 status**. |
| 8 | **Recall / return (N7)** | Recall: **paired lent-coordinate move** (lender lent_out ↔ borrower borrowed / virtual contra) + the return unit's possession leg, all from the recalled quantity. Return confirmation: unit walks `settled`; possession in-flight → 0. UTI carried. |
| 9 | Scheduled-statement watch (calendar-aware) | Overdue open item for the account. |
| 10 | Buy-in delivery confirmation | Discharges the failed residual (settled-by-buy-in, Binding-derived); buy-in date = penalty right endpoint. |
| 11 | Record-date watch inside the gap | Market-claim leg or mirror; claim units outside the identity's range. |
| 12 | Registry / tolerance / key amendment | Recorded forward-only amendment with valid-time; **revocation carries t_c**; re-quarantine scope = admitted in [t_c, discovery] ∧ verified under the revoked key. |
| 13 | Restated statement / finality (tip-only supersedes) | Longer log; identity nets the tip; both views deterministic. |
| 14 | **Dispatch receipt / cancellation confirmation (N1 family)** | Moveless observations making emission status a recorded fact: live(ref) ⟺ receipt ∧ ¬cancel-confirmation — N6's discriminator, decidable from the record. |
| 15 | **CSD penalty advice — semt.044 (N1 family)** | Moveless observation (typed; tip-only supersedes for appeals); read by the **penalty-reconciliation identity**: dated-clip expectation vs asserted amount per root reference — CLEAN / EXPECTED-DIFF / BREAK. |

State after the fold: the log; nodes in UnitStatus; `owned` and the lent/possession
coordinates in PositionState. Everything else is a projection — including emission
status, the penalty expectation, and both reconciliation classifications.

## 5. Temporal mapping (deltas from Round 3)

Held: unit-workflow per R-03/R-14; capture/evaluate/propose/emit activities; timers
carry timing not data; witness signals carry log position; Flags A and B binding; no
timer for atomic-finality units; R-02 wipe test. Three deltas:

- **Egress is now witnessed:** the emit activity is paired with capture of its dispatch
  receipt through the door (R-12 discipline applied to our own gateway) — egress still
  writes no balance; the receipt is an observation like any inbound fact. Emission
  status thereby survives the wipe test: live(ref) re-derives from the log, never from
  Temporal history.
- **Amendment sequencing reads the record:** the successor unit's emission is gated on
  the recorded cancellation confirmation — a discharge-predicate-style condition
  evaluated from the log, not a cross-boundary ordering hope (the same reasoning that
  chose the T+0 pin).
- **Nothing else changes:** corrections, recalls, and penalty advices are ordinary door
  transactions and observations; the workflows re-read their units' declared legs on
  next evaluation.

## 6. The running example (core held; micro-case A rebuilt both-sided; N6 numbers in §3.2)

Core (held, re-verified): pre-trade CLEAN/CLEAN → T: paired re-book, Σ = 0 per unit,
LEAD-LAG/LEAD-LAG → **T+1: V = 1,000,200.00, +$200.00 unrealised, custody untouched** →
T+2: moveless walk, CLEAN/CLEAN, V = 1,000,150.00. Fail variant: LEAD-LAG never false
BREAK; recoveries (late / buy-in netting w_us to exactly $5,000.00 with $150.00 on the
failing seller / cash-in-lieu crystallising +$150.00 / default). Partial variant:
60/40, sub-floor 7+7 aggregating then splitting at 14, penalty fold on dated clips
(Thursday failing quantity 26, not 40). The N6 amendment case is worked with numbers in
§3.2 (REF-001 → REF-002; CLEAN/CLEAN where Round 3 permitted r = +10 / −$500.00).

**Sample report lines (N2 + jane-street (a)) — fail variant, Thursday morning:**

```
account  unit  r      F         class              naming units (M7 status)
a_dep    XYZ   0      -100      EXPECTED-LEAD-LAG  SO-1 failed, overdue 1 bd
a_cash   USD   0      +5,000.00 EXPECTED-LEAD-LAG  SO-1 failed, overdue 1 bd
```

r = 0 and still nobody mistakes this for health: the lag's naming unit is a fail, one
business day overdue, in print on the same line.

**Micro-case A′ — recall mid-loan, both sides (N7 rebuilt).** Agency programme;
1,000,000 SIGMA on loan; lender wallet w_L (account a_L), borrower wallet w_B (account
a_B), both in-ledger. Opening state: lender owned 1,000,000, lent_out 1,000,000, depot
statement a_L = 0; borrower owned 0, borrowed 1,000,000, depot statement a_B =
1,000,000.
Lent-coordinate conservation: +1,000,000 (lender lent_out) − 1,000,000 (borrower
borrowed) = **0** ✓.
Identities — a_L: predicted = 1,000,000 − 1,000,000 + 0 = 0 = statement ✓ CLEAN.
a_B: predicted = 0 + 1,000,000 = 1,000,000 = statement ✓ CLEAN.

*Recall instructed (day R).* One transaction, all derived from the recalled quantity
1,000,000 (the Binding): the **paired lent-coordinate move** — lender lent_out
1,000,000 → 0, borrower borrowed 1,000,000 → 0, Σ over the lent coordinate 0 → 0,
conserved at the instant of the move ✓ — and the return unit RU-1 at `instructed` with
**one** possession leg, w_B → w_L, 1,000,000 SIGMA (UTI carried).
Identities during the return window:
a_L: predicted = 1,000,000 − 0 + 0 + 0 − 1,000,000 (inflight_in) = **0** = statement ✓
r = 0, F ≠ 0 → **LEAD-LAG** (naming unit RU-1, on-time).
a_B: predicted = 0 − 0 + 0 + 1,000,000 (inflight_out) − 0 = **1,000,000** = statement
1,000,000 ✓ r = 0, F ≠ 0 → **LEAD-LAG** — the borrower still physically holds; the
+1,000,000 depot lead-lag Round 3's single-sided story never showed, in print.

*Return delivered (day R+2).* Confirmation crosses; RU-1 walks `settled`; the
possession leg closes. Statements: a_L = 1,000,000, a_B = 0.
a_L: predicted = 1,000,000 ✓ CLEAN. a_B: predicted = 0 ✓ CLEAN.
Every step conserves on every coordinate; no `owned` move existed anywhere; both sides
of one recorded leg carried both identities.

**Micro-case B (C5, CA-on-in-flight) — held from Round 3** (claim-unit form; both
accounts r = 0 at record date, settlement, payment date, receipt).

## 7. DS1–DS19 disposition (Round-4 deltas; counts unchanged: 18 satisfied-or-closed · 1 routed · 0 rejected)

Held: DS1, DS2, DS4, DS6, DS7, DS8, DS9 (N4), DS10 (routed to NS-02), DS11a, DS11b
(floor), DS12 (T+0 pin, now TA-TERMS-cited), DS15, DS17, DS18, DS19.

| DS | Round-4 delta |
|----|---------------|
| DS3 | **Closed; now constructed.** The two false-r paths Round 3 patched by assertion are unrepresentable by the Binding (corrections, recalls, mints); the last permitted real break (in-place amendment of an emitted instruction) is refused by N6's discriminator. |
| DS5 | **Completed.** The revocation flip-set is a recorded coordinate (t_c): every repair projection deterministic on replay. |
| DS14 | **Closed both ways.** Internal expectation (dated clips, buy-in endpoint) *and* CSD reconciliation (semt.044 through the door; penalty-reconciliation identity CLEAN / EXPECTED-DIFF / BREAK). The "internal fold computable; CSD reconciliation parked" downgrade is not taken — the fix reuses N1+N2 machinery whole. |
| DS16 | **Held-strengthened.** Appeals/amendments of penalty advices ride the same tip-only supersession. |

## 8. Boundary notes (deltas)

**TA-CUSTODY (held; scope statement added).** The semt.044 penalty advice and the
dispatch/cancellation receipts cross under the **same four-part discipline as the
custody statement** — the CSD and the gateway as publishers of record-rendering
assertions; Detection for the advice = the penalty-reconciliation identity. **Stated,
not silent: this candidate treats them as instances under TA-CUSTODY's umbrella, not as
a sixth trust assumption** — the proposition ("the recorded assertion faithfully
renders the asserter's book") is the same; only the asserted book differs. If Round 5
judges the penalty advice's proposition distinct enough to name, the four-part text is
ready to instantiate; the cell's position is that multiplying named assumptions per
message family is taxonomy, not safety.

**CDM (rosetta residual adopted).** N6's two forms are named to their distinct CDM
images: Correction → `WorkflowStep.action = Correction`; Amendment → terminate + new
BusinessEvent. The five gap rows stand (settlement fail, partial split, custody
statement, the identity, the buy-in binding); moveless-observation ≠ CDM-Observation
held. rosetta: APPROVE on file.

**Retired list (held; one addition).** Round 3's "moveless recall re-book" is retired
as a description — the recall is a paired move; "moveless" remains true only of
discharge walks and observation recordings.

## 9. Responses on the record (every Round-4 item)

- **R4-B1 — ADOPTED (§3.0b, the Binding):** legs and balance moves derive from one
  restated parameter at mint, correction, re-instruction, and recall; Δpredicted = 0 is
  a theorem of the shape; the −10/−8 malformed correction, the one-sided recall, and
  the lying mint are unconstructible.
- **R4-B2 — ADOPTED (§3.2 N6, redesigned):** discriminator = emission status, live(ref)
  ⟺ recorded dispatch receipt ∧ no recorded cancellation confirmation (fold row 14);
  no live ref ⇒ Correction in place; live ref ⇒ mandatory re-instruction; the
  reviewer's 100→90 break re-run CLEAN/CLEAN under the redesign; executable property:
  no in-place leg amendment on an emitted instruction.
- **R4-B3 — ADOPTED (§3.2 N5; fold row 15):** semt.044 registered under N1 discipline
  (typed fields, provenance, tip-only supersedes for appeals); penalty-reconciliation
  identity CLEAN / EXPECTED-DIFF / BREAK per root reference; DS14 not downgraded.
  **Secondary — ADOPTED:** re-instruction mints a new root reference; inheritance
  across splits, freshness across re-instructions, both stated (N5).
- **R4-B4 — ADOPTED (§3.2 N7, rebuilt):** the recall is a paired lent-coordinate move
  (lender lent_out ↔ borrower borrowed / virtual contra), "moveless" dropped; the
  Binding derives pair and possession leg from one quantity; borrower side worked in
  micro-case A′ including the +1,000,000 depot LEAD-LAG; Σ over the lent coordinate 0
  at every instant.
- **R4-B5 — ADOPTED (§3.0a refinement; fold row 12):** the revocation event carries
  compromise-effective t_c (conservative default: key activation, still recorded);
  re-quarantine scope = admitted in [t_c, discovery] ∧ verified under the revoked key —
  a deterministic projection; pre-t_c CLEANs preserved.
- **rosetta residual — ADOPTED (§3.2 N6; §8):** the two forms named Correction vs
  Amendment with their distinct CDM images, exactly aligned with the emission-status
  discriminator.
- **jane-street (a) — ADOPTED (§3.2 N2; §6 sample lines):** every LEAD-LAG report line
  joins its naming units' M7 status (on-time / overdue N days); binary invariant
  untouched.
- **jane-street (b) — ADOPTED (§3.2 N6):** stated in place — the re-instruction
  conserves only because it is one atomic door transaction; split it and an
  intermediate state has owned moved with no unit carrying the gap.
- **jane-street (c) — ADOPTED (§3.2 N3):** the atomic-finality declaration cited to
  TA-TERMS (ch16 B7) — a named perimeter owner for a misdeclared venue.
- **CONTESTED: none.** One scoping decision is flagged rather than silently absorbed:
  semt.044 and the receipts ride under TA-CUSTODY's umbrella rather than minting a
  sixth named trust assumption (§8) — reasoned in place, ready to instantiate if Round
  5 rules otherwise.

## 10. Residuals for Round 5 / the .tex

1. DS10 / Herstatt with the NS-02 currency workstream (interface only).
2. The executable-property set now additionally includes: the Binding as a
   constructibility property (no admissible transaction with leg/move mismatch — a
   generator that *tries* must be refused); the emission-status property (no in-place
   amendment on emitted instructions); paired lent-coordinate conservation over recall
   histories; t_c-scoped re-quarantine determinism (same log, same flip-set); the
   penalty-reconciliation identity firing on generated semt.044 streams including
   appeal supersessions. Zero firings is a defect.
3. The parked ch16 four→five spec-pass edit rides with the .tex (TA-CUSTODY text
   final); the umbrella-vs-sixth-TA scoping of §8 is on the Round-5 docket.
4. Temporal conformance checks: Flags A/B; no-timer for atomic-finality units; egress
   paired with dispatch-receipt capture; amendment emission gated on recorded cancel
   confirmation.

