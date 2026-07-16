# Deferred Settlement, v16-Native — Round 3 Candidate

**Cell:** deferred-settlement design cell. **Author:** TuringAward (first-principles lead).
**Supersedes:** `candidate_r2.md`. **Adopts:** the unifying Spine (one rule closing
R3-B1 + R3-B5 + G1); R3-B2..B7; T4 (resolved as a per-unit fact); carries C1–C5 from
`reviews_r3.md`. rosetta: APPROVE on file. Every item answered on the record in §9.
**Status:** Round 3 candidate. Not the final .tex. Not committed.

Simplicity remains a gate: every mechanism carries a delete-test with a concrete scenario.

---

## 1. The problem (settled; held from Round 2)

On Monday at 14:32:11 UTC we buy 100 XYZ at $50.00, T+2: economically complete at T,
custody moves at t_d = Wednesday. XYZ closes $52.00 Tuesday: the book must show
**+$200.00 unrealised at Tuesday's close** while the custodian still shows $1,000,000.00
and zero XYZ. Both records are right; they describe different facts on different
calendars. The open window [T, t_d] is a parameter (T+0..T+5+), never a doctrine. The
design keeps both facts separately observable and separately attested, bound by an
identity **computable inside the system** — a bound living in prose is checked in a
spreadsheet, and the spreadsheet is the second store this ledger exists to abolish.
v16.0 carries everything but the bound (NS-01); the panel has ruled the custodian
statement crosses the one door (DL-01, Round 2). This candidate is that bound, hardened.

## 2. Classification (delta from Round 2 only)

The seven-question classification of Round 2 stands; three answers sharpen:

- **Consistency.** The identity is now bitemporally pinned by one rule — the Spine
  (§3.0): every input folds in force at the statement's valid-time. Same log, same
  classification at every historical statement, on every replay (ch14 Thm 14.4(a)); the
  as-known-then view is never rewritten by later tolerance amendments, partition changes,
  or key revocations (C-12.1).
- **Failure model.** The adversary now includes the compromised statement-signing key:
  keys live in a bitemporally versioned key-in-force registry (G1); a revocation is a
  recorded discovery that re-quarantines affected statements by forward repair — the
  as-known-then view keeps them verified, the corrected view does not.
- **Safety.** Two false-theorem paths found in Round 3 are closed by construction: a
  lawful mid-window correction now walks the obligation legs atomically with `owned`
  (Δpredicted = 0, §3.2 N6), and the T+0 race is unrepresentable — an atomic-finality
  venue's unit is born `settled` inside the instruction transaction (§3.2 N3).

## 3. The design

**Thesis (held).** v16.0 contains the deferred-settlement design; this candidate adds
the bound: the custody statement through the door (N1), the binary reconciliation
invariant under one bitemporal read rule (§3.0 + N2), the partial-fill floor (N3), the
buy-in binding (N4), the penalty fold (N5), the correction rule (N6), and the
possession-plane symmetry (N7). No state outside the log.

### 3.0 The Spine — the as-of read-set rule (one rule, three closures)

**Rule.** *Everything the identity reads, it reads in force at the statement's
valid-time.* For a statement with as-of time t, the residual r(a, u, t) is computed
under the ch14 as-of fold at valid-time t over the **whole read-set**:

- the balances — `owned`, `lent_out`, `borrowed` — as of t;
- the in-flight legs — the settlement-obligation units and their nodes as of t;
- the W(a) partition and account-registry membership as of t;
- the tolerance schedule in force at t;
- the signing key in force at t.

Registry facts, tolerance schedules, and keys are therefore **recorded declared data
with valid-time**, amended forward-only by recorded, authorised amendments (B7 duty;
C-12.4) — never edited. Both bitemporal views stay computable (C-12.1): the
as-known-then classification of any past statement is fixed forever; a correction in
force changes only the corrected view, through a recorded repair.

One rule closes three findings:
- **R3-B1 (tolerance):** a widening admitted in June cannot silently turn January's
  recorded BREAK into CLEAN — January's statement recomputes under January's tolerance;
  the widening is itself a recorded amendment with an owner and an audit trail.
- **R3-B5 (internal-side coordinate):** an early-arriving FoP receipt or a mid-history
  W(a) re-mapping can no longer yield two classifications for one statement across
  replays — the read-set is pinned at t, so Thm 14.4(a) holds for the classification as
  it holds for every other projection.
- **G1 (keys):** verification uses the key in force at the statement's as-of;
  rotation is an amendment; revocation is a recorded discovery whose forward repair
  re-quarantines every statement verified under the compromised key — visible open
  items, never silent deletions.

*Delete-test:* delete the Spine and three concrete failures return: a March W(a)
re-mapping recomputes January's statements against March's partition — one recorded
statement, two classifications, replay determinism broken; a June tolerance widening
rewrites January's BREAK to CLEAN in place — C-12.1's "never rewritten by later
arrivals" violated with no recorded repair; a key revoked in May silently un-verifies
nothing, or everything, depending on when you replay. Three patches would close these
severally; the Spine closes them as one sentence, and any future read-set member (a new
balance coordinate, a new registry fact) is covered the day it is added.

### 3.1 Existing v16 mechanisms carrying the load (held from Round 2, one line each)

E1 trade-date booking (§9 Timing; delete → strawman 2, the $200 unreportable).
E2 the settlement-obligation unit (§11; delete → the gap has nowhere to live).
E3 moveless discharge (delete → double-booking or reverse-and-reapply).
E4 the partial edge (§11; delete → 60-of-100 is one overloaded node).
E5 market claims, four quadrants (§11; delete → the dividend pays the wrong holder,
unreconciled).
E6 event-kind registry, routing, quarantine, capture (C-4.12, M8; delete → the
unrecognised statement is silently dropped).
E7 the due-date watch (M1/M4/M7; delete → a silent CSD leaves the unit instructed
forever). E8 bitemporal doctrine, forward repair (C-12; delete → restatements force
edit-in-place or permanent false breaks). E9 witness-before-signal (R-12/M8; delete →
Temporal becomes a second store; the R-02 wipe test fails).

### 3.2 The new mechanisms (N1–N7)

**N1 — The custody-witness event kind** (panel-ruled; held from Round 2, three
hardenings). Statements cross the one door as moveless observations with typed fields
{account, coordinate, balance in integer minor units, as-of, statement-id,
supersedes-ref}; unresolvable account → W4 quarantine; declared cadence with a
scheduled-statement watch; origin authenticity under an identified key. Round 3 adds:

- *Tip-only supersession (R3-B2).* A restatement may supersede only the **current tip**
  of the (account, as-of) chain; a supersedes-ref naming a non-tip statement quarantines
  W4. The chain is provably linear — and acyclic for free, since a reference may name
  only an earlier-admitted statement.
  *Delete-test:* delete tip-only and two restatements both superseding S0 leave two
  tips; "nets only the superseding observation" is undefined; two readers pick
  different tips — internal reconciliation failure through the repair path, the exact
  defect B9 was adopted to close.
- *Re-admission on reference resolution (R3-B5, second part).* A W4-quarantined
  statement re-admits when its **unresolved reference resolves** — the account
  registered later — not only when a kind is registered. The open item closes on the
  event that actually cures it.
  *Delete-test:* delete it and a statement for an account registered a day late stays
  quarantined forever despite every fact needed to admit it being on the record — a
  permanent false open item, and a hole in the identity's statement stream.
- *Calendar-aware cadence (C2).* The cadence contract reads the account's declared
  business-day calendar; a statement not due on a holiday is not overdue.
  *Delete-test:* delete it and every market holiday mints a false overdue item per
  account — alarm fatigue by calendar, the recon desk mutes the watch, and the real
  dark custodian hides behind Easter.

The key-in-force registry (G1) governs N1's verification and is read under the Spine.

**N2 — The reconciliation invariant** (held from Round 2; read under the Spine; two
refinements). Directed legs (T3), total W(a) per coordinate class (T1), lent/borrowed
terms (B4), governed tolerance (B2), decidable report classification (B1/S1: BREAK ⟺
r ≠ 0; LEAD-LAG ⟺ r ≈ 0 ∧ F ≠ 0; CLEAN ⟺ r ≈ 0 ∧ F = 0), break identity
(account, coordinate, residual sign) (T5). All inputs fold as of the statement's
valid-time (§3.0). Refinements:

- *The settlement channel is a per-unit fact (T4, resolved).* Derived at instruction
  from both legs' wallet resolution: **internalised iff both legs settle on the
  internaliser's books**; the CSD-of-reference stays on the account registration. One
  omnibus account lawfully carries both internalised and CSD-settled units, so the
  channel cannot be an account attribute — CSDR Art.9 internalised-settlement reporting
  folds over units by channel, within any account.
  *Delete-test:* delete the per-unit derivation and the omnibus account must be either
  wholly internalised or wholly CSD-routed — the Art.9 report either over-counts every
  CSD-settled unit in the account or misses every internalised one.
- *Claim units are outside the identity's range.* The identity ranges over the
  coordinate classes custody accounts carry (cash, securities, possession markers). A
  market claim or claim-for-equivalent maps to no custody account — no external book
  asserts a balance in it — so it contributes no identity term. (Worked in §6, C5.)

**N3 — The partial-fill floor and the T+0 pin.** Held from Round 2:
min-partial-fill-size + aggregate-remaining-fills on the one live residual (B5/S2 of
Round 2); NS-04 closes here. Round 3 adds:

- *Floor typed positive and inherited (C1).* The floor is typed strictly positive and
  is an **inherited invariant across splits** — every residual leg carries the parent's
  floor verbatim, exactly as it carries the root reference (N5).
  *Delete-test:* delete positivity and a zero floor makes every one-share clip walk the
  split edge — the clip-storm fragmentation returns through a typo; delete inheritance
  and the second-generation residual splits under no floor at all — the bound quietly
  evaporates after the first partial.
- *The T+0 pin (R3-B3): atomic venues settle the unit within the instruction
  transaction.* Chosen form, defended: where the venue's declared terms state **atomic
  finality** — the execution witness is also the settlement-finality witness — the
  instruction transaction mints the settlement-obligation unit **at `settled`**. The
  unconfirmed window has zero width by construction: no due-date timer is armed, so the
  race the review found — a zero-length timer firing on cumulative = 0 before the
  confirmation crosses, stamping a spurious permanent `failed` — is unrepresentable,
  not merely unlikely. The rejected form ("confirmation-before-timer is a guarantee at
  T+0") asserts an ordering between an external message and an internal timer that the
  ledger cannot enforce over a channel it does not control — a determinism property
  resting on a latency hope, which is how consensus bugs are written. A same-day but
  non-atomic venue is not this case: its cycle is end-of-day, the ordinary construction.
  Round 2's "T+0 is a zero-length timer" is **superseded** by this pin.
  *Delete-test:* delete the pin and the T+0 unit walks `failed` whenever the timer wins
  the race; DS7 forbids reversal, so every atomic settlement that loses the race needs a
  four-eyes correction — an operations queue manufactured by the spec.

**N4 — The buy-in binding (held).** The buy-in delivery discharges the failed residual
(settled-by-buy-in); no second `owned` long; the unbound case is identity-blind (both
sides inflate, r stays 0), which is why it is a binding, not a detection. Round 3 adds
C3: buy-in is the **fifth CDM-nothing row** in §8.

**N5 — The penalty fold, restated over dated clips (R3-B7).** The Art.7 penalty
projection folds over the **dated confirmation clips** keyed by the root
settlement-instruction reference: cumulative-confirmed(d) as a step function of date,
daily failing quantity = Q − cumulative-confirmed(d), accruing from the intended
settlement date to the explicit right endpoint — the settlement date or the **buy-in
date** (N4), whichever first. It never folds over the split-unit tree: sub-floor clips
are recorded on arrival but mint no unit until floor or deadline, so tree dates lag clip
dates and would over-accrue daily penalties against quantity already confirmed.
*Delete-test:* delete the clip basis and the T2S storm (§6) accrues Thursday's penalty
on 40 shares although 14 were confirmed Thursday in sub-floor clips — the CSD's
semt.044 advice disagrees with our fold by construction, and the desk reconciles
penalties by hand: the spreadsheet, one regime over. Delete the buy-in endpoint and the
penalty accrues past the day the failing party's exposure lawfully ended.

**N6 — Correction walks the legs (R3-B4).** A lawful C-12.4 mid-window trade correction
— wrong quantity, wrong price — is one transaction that carries **both** the
compensating `owned` moves **and** the amendment of the settlement-obligation unit's
in-flight legs, atomically, through the one door. New fold row (§4, row 4). The
conservation property ties them: for every account and unit,

```
Δpredicted(a, u) = Δowned + Δinflight_out − Δinflight_in = 0
```

under any mid-window correction. Numerically: quantity 100→90 on the buy — Δowned(XYZ)
= −10, Δinflight_in(XYZ) = −10, Δpredicted = −10 − (−10) = 0 ✓; price $50.00→$49.00 —
Δowned(USD) = +100.00, Δinflight_out(USD) = −100.00, Δpredicted = +100 − 100 = 0 ✓. The
external statement saw neither the error nor the repair, and r stays 0. Where the
correction changes what the CSD will actually settle, that is a **re-instruction**: the
old unit retires by compensation with its legs zeroed and a new unit is minted — the
property holds at every intermediate instant.
*Delete-test:* delete it and the review's false theorem returns as fact: the repair
moves `owned`, the unit's mint-term legs stand, r ≠ 0 spuriously from the next
statement, it never self-heals, and the BREAK criterion — the invariant's whole point —
is poisoned by a lawful act the constitution requires the ledger to support.

**N7 — Possession-plane legs and recall symmetry (R3-B6, with C4).** Where lending
moves custody mass without moving `owned` (the agency programme of B4: owned kept,
lent_out carries the departed mass), the **recall re-books the possession plane at
instruction** — the recall instruction decrements `lent_out`, mirroring trade-date
`owned` booking — and the return's in-flight leg is typed a **possession leg**: it
predicts depot movement and touches no `owned` coordinate. Booking symmetry: every
plane the identity reads re-books at instruction, with the in-flight leg carrying the
gap to the external event. Recall-return units carry the SFT UTI (C4) — an SBL
interface fact, carried, not absorbed. Worked with numbers in §6.
*Delete-test:* delete the symmetry and the mid-loan recall double-counts: lent_out
still standing at 1,000,000 while the return's inflight_in adds another 1,000,000 —
predicted = owned − 1,000,000 − 1,000,000 = −1,000,000 against a depot of 0: a false
BREAK of the full loan size for the whole return window, on every recall, in the one
business (agency lending) whose custodian check the identity exists to fold in.

### 3.3 DvP atomicity, stated honestly (held, affirmed twice)

The ledger guarantees its own paired-leg atomicity at the door; it cannot guarantee the
external CSD's DvP atomicity — that is reconciled (a leg-inconsistent fill surfaces as
one side's lead-lag the other side never matches, a BREAK once the deadline passes),
never enforced.

## 4. The fold (updated; new rows 4, 8, 12 — correction, recall, amendment)

| # | Event (kind) | Folds into |
|---|---|---|
| 1 | Execution / instruction | Paired-leg `owned` re-book + moveless mint of the settlement-obligation unit at `instructed` — declared terms: directed legs with plane tag (T3/N7), dueDate, discharge predicate, positive inherited floor (C1), root reference (N5), channel derived per-unit (T4). **Atomic-finality venue: the unit is minted at `settled` in this same transaction; no timer is armed (N3).** |
| 2 | Price close | Recorded observation; valuation and PnL are further folds; nothing stored. |
| 3 | Settlement confirmation (sese.025 / camt.054) | Moveless observation → the unit's contract proposes the moveless walk `instructed → settled`; in-flight reads zero thereafter. |
| 4 | **Trade correction mid-window (N6)** | One transaction: compensating `owned` moves **and** the unit's leg amendment, atomically; Δpredicted(a,u) = 0 per account and unit; a correction changing what the CSD settles is a re-instruction (old unit retires by compensation, new unit minted). |
| 5 | Partial confirmation, clip q | Recorded always (dated — the penalty fold's input, N5). ≥ floor: the split (settled leg + one residual; Σ conserved; floor and root ref inherited). Below floor: accumulates on the one live residual; nothing dropped. |
| 6 | Fail notice, or due-date watch with cumulative < Q | Moveless walk `instructed → failed` on the unconfirmed remainder; fails cascade (M7). |
| 7 | Custody statement (N1) | Moveless observation, typed fields; unresolvable account → W4, **re-admitted on reference resolution**; supersession tip-only. Read by the identity under the Spine; classification computed at read. |
| 8 | **Recall instruction / return delivery (N7)** | Recall: moveless possession re-book — `lent_out` decrements — and the return unit's possession leg opens in-flight. Return confirmation: the unit walks `settled`; possession in-flight → 0. SFT UTI carried (C4). |
| 9 | Scheduled-statement watch on missed cadence (calendar-aware, C2) | Overdue open item for the account. |
| 10 | Buy-in delivery confirmation (N4) | Discharges the failed residual (settled-by-buy-in); compensating cash routes the differential; **buy-in date = the penalty fold's right endpoint (N5)**. |
| 11 | Record-date watch inside the gap | Market-claim leg or mirror (certified); the claim unit maps to no custody account — no identity term (N2; worked in §6 C5). |
| 12 | **Registry / tolerance / key amendment (Spine)** | A recorded forward-only authorised amendment with valid-time; past statements keep their as-known-then classification; key revocation re-quarantines by forward repair (G1). |
| 13 | Restated statement / finality (supersedes-ref, tip-only) | Longer log; the identity nets the tip per (account, as-of); both bitemporal views deterministic. |

State after the fold: the log; nodes in UnitStatus; `owned` (and the possession plane)
in PositionState. Everything else — balances, V_t, in-flight, r/F and the
classification, instructions, the dated-clip penalty step function — is a projection.

## 5. Temporal mapping (delta from Round 2)

Held: workflow = the unit's own unit-workflow (R-03/R-14, signal-with-start,
record-first backstop R-27, cadence sweep R-09); activities = capture / evaluate /
propose / emit (R-05/R-06/R-12/R-24); timers carry timing, not data (M4); witness
signals carry log position only (R-11/R-12); Flag A (split ≠ ContinueAsNew — parent
completes, legs signal-with-start) and Flag B (egress idempotence rides (unit, node))
binding. Three deltas:

- **T+0 (supersedes Round 2's zero-length timer):** an atomic-finality unit is born
  `settled` — **no workflow timer is ever armed for it**; the workflow, if started at
  all, completes immediately from the recorded node. The race cannot be scheduled,
  which is stronger than winning it.
- **Correction (N6):** the leg amendment is a door transaction like any other; the
  workflow re-reads its unit's declared legs on next evaluation — no Temporal-side
  state to migrate (R-02 holds: wipe and re-derive).
- **Amendment watches (Spine, row 12):** none needed — amendments are ordinary recorded
  events; the identity is a projection, so nothing in Temporal caches a tolerance, a
  partition, or a key. The only new timer family remains B3's calendar-aware
  scheduled-statement watch (C2).

## 6. The running example (core held from Round 2; two new micro-cases)

Core, unchanged and re-verified: pre-trade CLEAN/CLEAN; T — TX1 paired re-book
(ΣXYZ = 0, ΣUSD = 0), owned XYZ 100 / USD 995,000.00, both accounts r = 0, F ≠ 0 →
EXPECTED-LEAD-LAG; **T+1 close $52.00 → V = 1,000,200.00, +$200.00 unrealised, zero
custody movement, identity unchanged**; T+2 confirmations cross the door, moveless walk
to `settled`, statements depot 100 / nostro 995,000.00, r = 0, F = 0 → CLEAN/CLEAN;
V_{T+2} = 1,000,150.00. Fail variant: due-date walk to `failed` on 100, `owned`
untouched, r = 0, F ≠ 0 — LEAD-LAG, never a false BREAK; recoveries (late
confirmation / buy-in with the three-move compensation netting w_us to exactly $5,000
paid and the $150 differential on the failing seller / cash-in-lieu at 51.50
crystallising +$150 / declared default). Partial variant: 60/40 split (60 + 40 = 100,
parent from the zero vector), Thursday sub-floor clips 7 + 7 aggregate on the one live
residual, split at 14 ≥ floor 10, SO-s2 14 + SO-r2 26 = 40 ✓; the penalty fold reads
the **dated clips** — Thursday's failing quantity is 40 − 14 = 26, not 40 (N5).

**Micro-case A — recall mid-loan (N7; numbers conserve at each step).**
Agency programme per B4's declared terms: beneficial `owned` kept by the lender wallet
w_L; the lent mass has left the depot. Loan of 1,000,000 SIGMA outstanding:
owned(SIGMA) = 1,000,000; lent_out(SIGMA) = 1,000,000; depot statement 0.
Identity: predicted = 1,000,000 − 1,000,000 + 0 + 0 − 0 = **0** = statement ✓ **r = 0,
F = 0 → CLEAN.**
*Recall instructed (day R).* One transaction: moveless possession re-book —
lent_out 1,000,000 → 0 — and the return unit RU-1 opens at `instructed` with a
**possession leg** in-flight_in(SIGMA) = 1,000,000 (UTI carried, C4). `owned`
untouched. Conservation: the possession plane moves 1,000,000 from lent_out into the
open leg — nothing created, nothing destroyed; ΣSIGMA across owned-plane moves = 0
(there are none).
Identity during the return window: predicted = 1,000,000 − 0 + 0 + 0 − 1,000,000 =
**0** = statement 0 ✓ **r = 0, F = −1,000,000 ≠ 0 → EXPECTED-LEAD-LAG**, named by
RU-1. (Without N7: predicted = 1,000,000 − 1,000,000 − 1,000,000 = −1,000,000 → false
BREAK of the whole loan for the whole window.)
*Return delivered (day R+2).* Confirmation crosses the door; RU-1 walks `settled`;
in-flight → 0; depot statement 1,000,000.
Identity: predicted = 1,000,000 − 0 + 0 + 0 − 0 = **1,000,000** = statement ✓
**r = 0, F = 0 → CLEAN.** Every step conserves; no owned move existed anywhere.

**Micro-case B — corporate action on the in-flight trade (C5; both accounts).**
The standard buy is cum; a $1.00/share dividend has record date Tuesday — inside the
window — and payment date Friday. Quadrant (i): cum, unsettled.
*Booking form, stated:* **claim-unit (in-flight-only on cash)** — `owned`(USD) does not
anticipate the dividend; the record-date firing raises the market-claim leg MC-1 at par
($100.00 = 100 × $1.00), buyer +, seller −, on the claim coordinate. The rejected form
(re-book owned(USD) +100 at record date with a receivable leg) also keeps r = 0
(Δowned = +100, Δinflight_in = +100 cancel in predicted) — the identity cannot
discriminate; v16 doctrine does: entitlements are kept apart from `owned` until the
recorded receipt event (V6-style), and `owned` re-books on witnessed events, not
expectations. MC-1 maps to no custody account, so it contributes **no identity term**
(N2).
*Tuesday (record date):* depot — predicted = 100 + 0 − 100 = 0 = statement ✓
LEAD-LAG (the trade's own leg; the CA adds nothing). Nostro — predicted = 995,000 +
5,000 − 0 = 1,000,000 = statement ✓ LEAD-LAG. **The CA changes neither account's
classification.**
*Wednesday:* the trade settles; both accounts CLEAN as in the core example. MC-1
stands, deadline-bearing.
*Friday (payment date), before receipt:* the paying agent credits the record holder —
the seller's nostro, an account the identity never ranges over for us. Our accounts:
nostro predicted = 995,000 + 0 − 0 = 995,000 = statement ✓ **CLEAN, F = 0**; MC-1
still open, visible, aging under its own deadline — not an identity term, so no false
anything.
*Receipt (Friday or later):* the seller's remittance is witnessed (camt.054 credit);
the discharge transaction fires on that recorded receipt: owned(USD) 100.00
seller → w_us; MC-1 retires at the zero vector. ΣUSD = +100 − 100 = 0 ✓. Statement
995,100.00; predicted = 995,100 + 0 − 0 = **995,100** ✓ **CLEAN.** Both accounts show
r = 0 at every step; the CA on an in-flight trade never touches the identity except
through the cash that actually arrives.

## 7. DS1–DS19 disposition (Round-3 deltas marked; counts unchanged)

**Counts: 18 satisfied-or-closed · 1 routed (DS10 → NS-02) · 0 rejected.**

Held unchanged from Round 2: DS1, DS2, DS4, DS6, DS7, DS8, DS9 (completed by N4),
DS10 (routed), DS11a, DS15, DS17, DS18 (ledger-level, honest), DS19.

| DS | Round-3 delta |
|----|---------------|
| DS3 | **Closed; hardened.** The identity now reads its whole input set under the Spine — the classification is itself a deterministic replayable projection (Thm 14.4(a)), which Round 2 asserted and Round 3 makes true (R3-B1/B5/G1). N6 removes the last false-positive path (lawful corrections); N7 the last false-BREAK path (recalls). |
| DS5 | **Strengthened.** Replay determinism now covers statements end-to-end: tip-only supersession (R3-B2) makes the superseding tip unique; the Spine pins the read-set. |
| DS11b | **Held closed via the floor; floor now typed positive and inherited across splits (C1).** |
| DS12 | **Sharpened.** T+0 degenerates by construction, not by a zero timer: the atomic-finality unit is born `settled` inside the instruction transaction (N3); no race is representable. |
| DS14 | **Made faithful.** The penalty fold runs over dated confirmation clips keyed by root reference, with the buy-in date as the explicit right endpoint (N5/R3-B7) — never over the split tree. |
| DS16 | **Strengthened.** Bitemporal restatement of statements is deterministic (tip-only) and the whole identity read-set is bitemporally pinned (Spine). |

## 8. Boundary notes (deltas; Round-2 §8 otherwise held)

**TA-CUSTODY (four-part structure held; two artifact additions).** The Owner's named
artifacts now include the **bitemporally versioned key-in-force registry** (G1) beside
the tolerance schedule (B2, now recorded declared data with valid-time per R3-B1) and
the calendar-aware cadence contract (C2). Detection gains the sequence/tip check
(R3-B2). Residual unchanged: the coincidental misrender. The parked ch16 four→five
spec-pass edit rides unchanged.

**CDM alignment — fifth gap row (C3).** (5) *the buy-in binding* — CDM has no construct
tying a buy-in execution to the discharge of the original failed obligation; the
binding is the ledger's own. Rows 1–4 (settlement fail, partial split, custody
statement, the identity) and the moveless-observation ≠ CDM-Observation correction:
held. rosetta: APPROVE on file.

**T4, resolved.** Settlement channel: a per-unit fact derived at instruction
(internalised iff both legs settle on the internaliser's books); CSD-of-reference stays
on the account; one omnibus account carries both kinds of unit (§3.2 N2).

**Retired list held** (mirror wallets, L15 FSM, quorum tables, stored break register,
materialised tx_status, Round-1 splitDepthMax). Nothing new is stored anywhere in
Round 3: the Spine pins reads, it stores nothing; N6 and N7 are transaction shapes, not
state.

## 9. Responses on the record (every Round-3 item)

- **SPINE — ADOPTED as one named rule (§3.0):** the identity's whole read-set —
  balances, in-flight legs, W(a), tolerance, key — folds in force at the statement's
  valid-time; closes R3-B1 + R3-B5 + G1 in one mechanism, with one delete-test covering
  all three regressions.
- **R3-B1 — ADOPTED** (via the Spine): the tolerance schedule is recorded declared data
  with valid-time; widening is a recorded forward-only authorised amendment (B7 duty);
  each statement recomputes under the tolerance in force at its as-of — a past BREAK
  can never silently become CLEAN (C-12.1).
- **R3-B2 — ADOPTED:** supersession targets only the current tip per (account, as-of);
  non-tip refs quarantine W4; the chain is provably linear, cycles impossible by
  earlier-admitted-only references (§3.2 N1; fold row 13).
- **R3-B3 — ADOPTED, form chosen and defended (§3.2 N3):** atomic-finality venues
  settle the unit within the instruction transaction — the unit is born `settled`, no
  timer is armed, the race is unrepresentable; the rejected form
  (confirmation-before-timer) rests on a cross-boundary ordering the ledger cannot
  enforce. Round 2's zero-length-timer wording superseded (§5).
- **R3-B4 — ADOPTED (§3.2 N6):** the forward correction walks the obligation legs
  atomically with `owned`; new fold row 4; conservation property Δpredicted(a,u) = 0,
  checked numerically both ways (quantity and price corrections); re-instruction case
  stated.
- **R3-B5 — ADOPTED** (via the Spine, plus the second part in N1): the internal-side
  bitemporal coordinate is the statement's as-of for the whole read-set; W4 re-admission
  fires on reference resolution, not only kind registration.
- **R3-B6 — ADOPTED (§3.2 N7):** booking symmetry on the possession plane — the recall
  decrements lent_out at instruction; the return's leg is a possession leg; worked at
  1,000,000 SIGMA in §6 micro-case A with r = 0 throughout.
- **R3-B7 — ADOPTED (§3.2 N5):** the penalty fold runs over dated confirmation clips
  keyed by root reference (cumulative-confirmed as a date step function), buy-in date
  as the explicit right endpoint; never over the split tree; §6 partial variant shows
  Thursday's failing quantity 26, not 40.
- **G1 — ADOPTED** (via the Spine + §8): bitemporally versioned key-in-force registry;
  rotation as amendment; revocation as recorded discovery re-quarantining affected
  statements by forward repair.
- **T4 — ADOPTED as ruled:** channel is a per-unit fact derived at instruction from
  both legs' wallet resolution; CSD-of-reference stays on the account; omnibus accounts
  carry both (§3.2 N2; §8).
- **C1 — ADOPTED:** floor typed positive, inherited-invariant across splits, like the
  root reference (§3.2 N3; fold rows 1, 5).
- **C2 — ADOPTED:** cadence contract calendar-aware; no false overdue on holidays
  (§3.2 N1; fold row 9).
- **C3 — ADOPTED:** buy-in as the fifth CDM-nothing row (§8).
- **C4 — ADOPTED:** SFT UTI carried on recall-return units; an SBL interface fact,
  carried, not absorbed (§3.2 N7; fold row 8).
- **C5 — ADOPTED, worked with numbers (§6 micro-case B):** claim-unit booking form
  chosen and defended (the identity cannot discriminate the two forms — both keep
  r = 0; doctrine does: entitlements apart from `owned`, re-book on witnessed receipt);
  both accounts shown r = 0 / LEAD-LAG / CLEAN at record date, settlement, payment
  date, and receipt.
- **CONTESTED: none.** Round 3 falsified two Round-2 statements — the zero-length T+0
  timer and the tree-based penalty fold — and both are corrected in print, not
  absorbed.

## 10. Residuals for Round 4 / the .tex

1. DS10 / Herstatt with the NS-02 currency workstream (interface only from here).
2. The executable-property set: the binary invariant under the Spine over generated
   histories — corrections mid-window (N6's Δpredicted = 0 as a property), recalls
   (N7), sub-floor storms and the dated-clip penalty fold (N5), tip-only restatement
   chains and forks (must quarantine), key rotation/revocation replays (G1), tolerance
   amendments (as-known-then stability), atomic-finality instructions (no failed node
   ever generated) — every predicate shown to fire; zero firings is a defect.
3. The parked ch16 four→five spec-pass edit rides with the .tex for CONCORDIA.
4. Temporal Flags A/B as implementation-conformance checks; plus the no-timer-armed
   check for atomic-finality units (§5).

