# Deferred Settlement, v16-Native — Round 8 Candidate

**Cell:** deferred-settlement design cell. **Author:** TuringAward (first-principles lead).
**Supersedes:** `candidate_r7.md`. **Round-8 tally:** 3 APPROVE (rosetta, jane-street,
sbl), 4 BREAK reducing to three surfaces, all completions of R6/R7 machinery: R8-B1
restores N5's own one-root-ref-one-instruction rule at the minting step; R8-B2+B3 are
one selector-plus-witness fix on cross-check (b); R8-B4 is one datum, one declared
term, the two-case boundary rule, and a rework of §6's penalty lines — which Round 7
got internally inconsistent, corrected here in print. jane-street's affirmation is
carried: per-coordinate Terminality introduces **no** new race (atomic Spine-read plus
the log's total order) and removes the leg-inconsistent-settled-mass hazard a joint
split would force. Every item answered in §9. **Status:** Round 8 candidate. Not the
final .tex. Not committed.

---

## 1. The problem (settled since Round 2; held)

Buy 100 XYZ at $50.00 Monday, T+2; Tuesday's $52.00 close makes +$200.00 real before
any custody movement. The bound between the internal record and the external
assertions — the binary reconciliation invariant, everything crossing the one door —
is this candidate. v16.0 carries everything else.

## 2. Classification (delta from Round 7 only)

- **Unit identity.** A settlement-obligation unit is one external instruction — one
  root reference, one node. Round 7's mixed-case successor bundled two instructions
  (an FoP securities receipt and a cash refund) into one unit, so one node had to
  speak for two external events: unrepresentable state returned as a transient false
  break. The minting rule now enforces what N5 already said: **one root reference =
  one CSD instruction = one unit.**
- **Witness discipline, one level deeper.** A cross-check must confront the timestamp
  of **the fact being reconciled**. Lateness at the CSD is a property of the matched
  instruction's *arrival*, so check (b) confronts the matched instruction's
  send-completion (dispatch receipt, or CSD acknowledgment where available) — never
  the intent (which timestamps our commitment, not the arrival) and never the
  earliest dispatch (which may be a different, unmatchable instruction).
- **The regime's own clock.** The LMFP/SEFP boundary turns on the matching
  **timestamp against the CSD's settlement cut-off** on the matching day, not on the
  matched date alone; the cut-off is a venue/calendar declared term. Endpoints are
  pinned: ISD inclusive, actual settlement (and buy-in) date exclusive, accrual on
  business days unsettled at end-of-day.

## 3. The design

**Thesis (held).** Three cross-cutting rules: the Spine pins the read; the Binding
pins the write; Terminality pins the race. This round pins the unit-minting rule and
the penalty clock.

### 3.0a The Spine (held)

All identity inputs fold in force at the statement's valid-time; declared data
forward-only; revocations carry t_c.

### 3.0b The Binding (held; minting rule completed — R8-B1)

Held: one restated parameter set derives all legs and moves; the case-split is per
coordinate; settled mass nets per coordinate at amounts actually moved. Completed —
**how the resulting legs mint into units**: the correction's derived legs partition
by external instruction, under N5's own rule, **one root reference = one CSD
instruction = one unit**:

- a forward-forward result (both coordinates forward) is one DvP instruction — one
  unit, two opposite-directed legs (Round 5's case, unchanged);
- a return-return result (the bust) is one DvP instruction the other way — one unit
  (R6-B1's SO-R, unchanged: deliver back against refund);
- a **mixed result is two instructions, so it mints two units**: a forward
  securities receipt (FoP, its own root reference, walking `settled` on the
  delivery) and a cash return obligation (its own root reference, exactly SO-R's
  shape). Each unit has one node speaking for one external event.

*Delete-test (two-unit minting):* delete it and R8-B1's numbers stand: the bundled
SO-2 = {70 XYZ in, $500.00 in} is (i) unconstructible on N5's own terms — a root
reference names one CSD matching instruction, and an FoP receipt plus a refund are
two — and (ii) wrong in the window: the 70-share delivery lands first, the bundle's
single node cannot say "securities settled, cash open", so the still-`instructed`
unit keeps 70 in-flight against a depot statement of 100 — a transient false
**r = +70** (or −$500.00 on the other walk order). jane-street's mixed-emission flag
is the same defect seen from egress; the two-unit fix discharges it.

### 3.0c Terminality (held; race-freedom affirmed)

Settled mass is terminal, coordinate by coordinate. jane-street's Round-8 red-team is
carried as an affirmation: the per-coordinate split runs under one atomic Spine-read
in the log's total order, so it introduces no new race — and it *removes* the
leg-inconsistent-settled-mass hazard a joint split would force.

### 3.1 Existing v16 mechanisms (held; E1–E9)

E1 trade-date booking · E2 the settlement-obligation unit · E3 moveless discharge ·
E4 the partial edge · E5 market claims · E6 registry/quarantine/capture · E7 the
due-date watch · E8 bitemporal doctrine · E9 witness-before-signal.

### 3.2 The mechanisms (deltas; N1, N5 touched; N2, N3, N4, N6, N7 held)

**N1 — The custody-witness event kind (held; one field added).** The
match-confirmation witness gains the **matching timestamp** (equivalently a
before/after-cut-off flag): the datum the LMFP/SEFP boundary turns on (R8-B4). The
CSD's **settlement cut-off** enters as a venue/calendar declared term — the same
declared calendar surface the cadence contract already reads. Single-source honesty
(R7-B2) held: the timestamp is CSD-asserted like the date it refines; the residual
in §8 covers it.

**N5 — The penalty regime: the boundary clock and the honest witness (R8-B2+B3 +
R8-B4, one surface with two fixes).**

- *Cross-check (b), re-witnessed and re-selected (R8-B2+B3, one joint fix).* When we
  are the asserted late-matching side, the charge is confronted with **the
  send-completion of the instruction bearing the matched reference**: its dispatch
  receipt, or the CSD's receipt-acknowledgment where the venue provides one — the
  witness that timestamps the fact being reconciled (arrival at the CSD), selected
  by **matched reference, never earliest**. BREAK iff that instruction's own
  dispatch was timely. Two false cases die at once: the stalled send (timely
  *intent*, genuinely late CSD entry — a **correct** charge no longer BREAKs) and
  the re-dispatch (a timely-but-unmatchable first instruction — wrong BIC Wednesday,
  re-dispatched Friday — no longer exonerates a **valid** charge). The residual
  send→CSD-entry gap (receipt timely, CSD entry late) folds into the named
  TA-CUSTODY residual. The dispatch-intent keeps its one job: keying live(ref) for
  the repair discriminator — commitment and arrival are different facts with
  different witnesses, and each check now reads its own.
  *Delete-test (witness):* keep the intent as (b)'s witness and the stalled send
  across the ISD boundary false-BREAKs a correct $10,400.00 LMFP — the
  false-positive that mutes the detector. *Delete-test (selector):* keep
  earliest-pick and the wrong-BIC Wednesday dispatch exonerates us from a valid
  $10,400.00 charge on the Friday instruction that actually matched — a false
  refusal this time; only matched-reference selection kills both.
- *The two-case boundary and the endpoint pin (R8-B4).* R7-B3's core holds
  (sequential, never sharing a business day, SEFP from later-of — verified against
  RTS 2018/1229 / CDR 2017/389 as operationalised by the ECSDA framework). The
  boundary on matching day M turns on the **matching timestamp against the CSD's
  settlement cut-off on M**: matched **before** cut-off ⇒ LMFP = [ISD, M), M
  excluded — M can itself become an SEFP day if the instruction then fails; matched
  **after** cut-off ⇒ LMFP = [ISD, M], M included — SEFP starts M+1. Endpoints
  pinned: accrual per business day unsettled at end-of-day, **ISD inclusive, actual
  settlement date exclusive, buy-in date likewise exclusive**. Round 7's §6 penalty
  lines were internally inconsistent — LMFP "Thursday and Friday" beside SEFP
  "Friday→Monday" double-counts Friday, and the before-cut-off LMFP days are
  **Wednesday and Thursday** — retracted and reworked in §6 with both cases.
  *Delete-test:* delete the timestamp rule and matching day M is charged under both
  regimes or neither, depending on implementation whim; either way check 3 disagrees
  with a correct advice on every late-matched fail whose matching lands near the
  cut-off — the mute-the-detector failure again, now at the boundary R7 left
  date-granular.

**N7 (held; carry 1 noted).** A″'s CLM-CO prices the securities value against
collateral; the accrued rebate/fee/manufactured-payment income leg (GMSLA para 11)
**composes with** it and is routed as an interface to the queued billing/income
workstream — the DS10→NS-02 pattern — and the CLM-CO is never read as the complete
close-out amount (§8).

### 3.3 DvP atomicity (held, affirmed seven rounds running)

Ledger-level paired-leg atomicity at the door; external-CSD atomicity reconciled,
never enforced.

## 4. The fold (rows 4, 14, 15 revised)

| # | Event (kind) | Folds into |
|---|---|---|
| 1 | Execution / instruction | Binding-derived paired re-book + unit at `instructed`; atomic-finality venue: born `settled`, no timer. |
| 2 | Price close | Recorded observation; valuation/PnL are further folds. |
| 3 | Settlement confirmation | Moveless walk to `settled`; racing a pending cancel: settlement wins. |
| 4 | Repair event (intent on the kind) | live(ref) picks the mechanism; per-coordinate case-split; **derived legs partition into units by external instruction — one root reference = one CSD instruction = one unit**: forward-forward → one DvP unit; return-return → one reverse-DvP unit; mixed → **two units** (FoP securities receipt + cash return obligation), each with its own root reference and node. Δpredicted = 0 by shape throughout. |
| 5 | Partial confirmation, clip q | Recorded always; ≥ floor: split; below: aggregates on the one live residual. |
| 6 | Fail notice / due-date watch | Walk to `failed` on the remainder; fails cascade. |
| 7 | Custody statement | Identity under the Spine; classification at read; LEAD-LAG lines carry M7 status. |
| 8 | Recall / return; terminal return failure | Paired lent-coordinate move + possession leg; terminal: §9 close-out, owned paired w_L → w_B, CLM-CO (composes with the routed income leg), collateral applied. |
| 9 | Scheduled-statement watch (calendar-aware) | Overdue open item. |
| 10 | Buy-in delivery confirmation | Discharges the failed residual; buy-in date = SEFP right endpoint (exclusive). |
| 11 | Record-date watch inside the gap | Market-claim leg or mirror; claim units outside the identity's range. |
| 12 | Registry / tolerance / key amendment | Forward-only, valid-timed; revocations carry t_c; **the CSD settlement cut-off rides the venue/calendar declared terms**. |
| 13 | Restated statement / finality | Tip-only supersession; identity nets the tip. |
| 14 | Emission receipts: dispatch-intent → send → dispatch receipt (or CSD acknowledgment); match confirmation **(+ matching timestamp / cut-off flag)**; cancellation confirmation | Intent keys live(ref) (commitment); the **receipt/acknowledgment timestamps arrival** and is cross-check (b)'s witness, selected by matched reference; the match confirmation fixes the LMFP boundary case and the charged side. |
| 15 | CSD penalty advice (semt.044) | Decidable checks over the partitioned windows with the two-case boundary — matched before cut-off: LMFP [ISD, M), M an SEFP day if it then fails; after: LMFP [ISD, M], SEFP from M+1 — ISD inclusive, settlement/buy-in exclusive; cross-checks (a) matched ≤ settled, (b) matched-reference send-completion timely ⇒ BREAK; reference price against the SECR-designated-source close; CLEAN / BREAK only. |
| 16 | Penalty reconciliation complete for a period | Binding-derived booking of the period net across both penalty kinds + the penalty settlement-obligation unit, discharged by the collection's camt.054. |

## 5. Temporal mapping (delta from Round 7: none structural)

Held in full. The two-unit mixed case is two ordinary signal-with-starts from one
door transaction (Flag A verbatim — the parent correction transaction completes, each
unit runs its own workflow); the boundary timestamp and cut-off are projection inputs,
not orchestration; check (b)'s witness change reads facts already captured on the
egress path (intent → send → receipt), no new activity.

## 6. The running example (held; mixed case re-worked two-unit; penalty lines corrected)

Core, fail/buy-in/cash-in-lieu, partial with sub-floor aggregation, amendment
REF-001→REF-002, quantity-and-price composition, the bust, penalty cash cycle, A′,
A″ both-sided, CA-on-in-flight: all held.

**The mixed case, re-worked as two units (R8-B1).** Booked 100 XYZ @ $50.00; 30
settled at old terms (depot 30, nostro 998,500.00; settled cash $1,500.00); price
corrected to $10.00, quantity unchanged (restated 100 / $1,000.00). One atomic
correction transaction on the recorded cancel confirmation: owned(USD) 4,000.00
seller → w_us (owned now XYZ 100 / USD 999,000.00); retire SO-1r; per-coordinate
split mints **two units**: **SO-2a** — forward FoP securities receipt, 70 XYZ
seller → w_us, root REF-002a; **SO-2b** — cash return obligation, $500.00
seller → w_us, root REF-002b. Identity during the window: predicted depot =
100 − 70 = 30 = statement ✓; predicted nostro = 999,000.00 − 500.00 = 998,500.00 =
statement ✓; both LEAD-LAG, each named by its own unit.
*The sequence that broke Round 7:* the 70-share delivery lands **first**. SO-2a walks
`settled`; its in-flight closes. Predicted depot = 100 − 0 = **100** = statement
100 ✓ **CLEAN** — no transient r = +70, because the securities unit's node speaks
only for the securities event. Cash still open: predicted nostro = 999,000.00 −
500.00 = 998,500.00 = statement ✓ **LEAD-LAG named by SO-2b alone**, aging under its
own M7 deadline. The refund settles: nostro 999,000.00, predicted 999,000.00 ✓
CLEAN/CLEAN. External total paid: 1,500.00 − 500.00 = 1,000.00 = restated ✓.

**The two penalties, corrected and worked both ways (R8-B4; replaces Round 7's
inconsistent lines, retracted).** 1,000,000 shares; ISD Wednesday; matched Friday,
our side late; settled Monday; reference $52.00; 1.0 bp/day ⇒ $5,200.00 per accrual
day. Endpoints: ISD inclusive, settlement exclusive; accrual on business days
unsettled (or unmatched) at end-of-day.

- *Matched before Friday's settlement cut-off:* LMFP = [ISD, M) = **Wednesday,
  Thursday** = 2 days = **$10,400.00** (instruction quantity, charged to the
  late-matcher — us). Friday is then an SEFP day if the matched instruction fails
  at end-of-day — it does: SEFP = [Friday, Monday) = **Friday** = 1 business day =
  **$5,200.00** (unsettled quantity, charged to the fail-cause party). Total
  $15,600.00.
- *Matched after Friday's cut-off:* LMFP = [ISD, M] = **Wednesday, Thursday,
  Friday** = 3 days = **$15,600.00**; SEFP starts Monday = [Monday, Monday) =
  **$0.00**. Total $15,600.00.

Same total, different lines — and the flipped Friday **moves between parties**: LMFP
charges the late-matcher, SEFP charges the fail-cause; when those differ, the
before/after-cut-off flag decides who pays $5,200.00. That is why the timestamp is a
typed witness field and the cut-off a declared term, not a footnote. Cross-checks on
the same numbers: matched Friday ≤ settled Monday ✓ (a); we are the charged side, so
(b) confronts **REF-001's own dispatch receipt** — if the matched instruction's send
completed Wednesday morning, BREAK (charge refused on our recorded arrival-side
fact); if our send stalled to Friday, the charge reconciles CLEAN — correctly, where
Round 7's intent-witness would have false-BROKEN it; and if a wrong-BIC Wednesday
dispatch never matched while the Friday re-dispatch did, (b) reads the **Friday**
instruction — matched-reference selection — and the valid charge stands.

## 7. DS1–DS19 disposition (Round-8 deltas; counts unchanged: 18 satisfied-or-closed · 1 routed · 0 rejected)

Held: DS1, DS2, DS4, DS5, DS6, DS7, DS8, DS9, DS10 (routed), DS11a, DS11b, DS12,
DS15, DS16, DS17, DS18, DS19.

| DS | Round-8 delta |
|----|---------------|
| DS3 | **Held closed; the last transient false break removed** — the two-unit mixed case gives every external event its own node, so the identity never reads a bundle's single node against half-arrived facts. |
| DS14 | **Endpoint-complete.** Round 7's one open penalty item (the day convention) is pinned: two-case boundary at the cut-off timestamp, ISD inclusive, settlement/buy-in exclusive; check (b) re-witnessed (send-completion) and re-selected (matched reference) so correct charges reconcile CLEAN and false charges BREAK — in both directions. No open items remain in the penalty regime. |

## 8. Boundary notes (deltas)

**TA-CUSTODY (held; residual membership extended — R8-B2).** The named residual
gains its second member: *the send→CSD-entry gap* — a dispatch receipt showing
timely send-completion while the instruction genuinely entered the CSD late (gateway
transit). Beside the matched-date inflation inside a genuinely-late window, both
members share the same shape: single-source facts our own record can bound but not
verify. Named, owned, priced in. The matching timestamp is CSD-asserted like the
matched date it refines and sits under the same residual.

**Declared terms (R8-B4).** The CSD settlement cut-off joins the venue/calendar
declared terms — the same surface the calendar-aware cadence already reads; one
declared calendar per venue carries business days, holidays, and now the cut-off.

**CLM-CO composition (carry 1).** A″'s CLM-CO prices securities value against
collateral; the accrued rebate/fee/manufactured-payment income leg (GMSLA para 11)
composes with it and routes to the queued billing/income workstream — the
DS10→NS-02 pattern. Stated so the CLM-CO is never read as the complete close-out
amount.

**CDM (held).** Six nothing-rows and the two corrections stand; the two-unit mixed
case adds no row — each unit is row-2 territory (the settlement-obligation unit
gap), and the FoP receipt maps as a one-legged Transfer like any delivery.

## 9. Responses on the record (every Round-8 item)

- **R8-B1 — ADOPTED (§3.0b minting rule; fold row 4; §6):** the mixed case mints two
  units — FoP securities receipt and cash return obligation, each with its own root
  reference and node — restoring N5's one-root-ref-one-instruction rule at the
  minting step; forward-forward and return-return stay single DvP units; the
  delivery-first sequence re-worked in print to CLEAN + LEAD-LAG with no transient
  r = +70. jane-street's mixed-emission flag discharged by the same fix, as the
  review notes.
- **R8-B2 + R8-B3 — ADOPTED as the one joint fix (§3.2 N5; fold row 14; §6):**
  cross-check (b) confronts the **matched instruction's send-completion** — dispatch
  receipt or CSD acknowledgment, selected by **matched reference, never earliest**;
  BREAK iff that instruction's own dispatch was timely. The stalled-send false BREAK
  and the re-dispatch false exoneration both die; nazarov's original protection
  survives; the send→CSD-entry gap folds into the named TA-CUSTODY residual; intent
  keeps its one job (live(ref)) — commitment and arrival are different facts with
  different witnesses.
- **R8-B4 — ADOPTED (§3.2 N1 + N5; fold rows 12, 14, 15; §6):** the matching
  timestamp (or cut-off flag) rides the match-confirmation witness; the CSD
  settlement cut-off is a venue/calendar declared term; the two-case boundary
  applied — before cut-off LMFP [ISD, M) with M a possible SEFP day, after cut-off
  LMFP [ISD, M] with SEFP from M+1; endpoints pinned ISD-inclusive /
  settlement-and-buy-in-exclusive. Round 7's §6 inconsistency (the double-counted
  Friday; Thu+Fri instead of Wed+Thu) is **owned and corrected in print**, both
  cases worked to the same $15,600.00 total with the flipped day moving between
  payable and receivable.
- **Carry 1 (CLM-CO composition) — ADOPTED (§3.2 N7; §8):** the income leg composes
  and routes to the queued billing/income workstream; the CLM-CO is never the
  complete close-out amount.
- **Carry 2 (mixed-emission flag) — DISCHARGED by R8-B1**, per the review's own
  note.
- **Affirmation carried (jane-street):** per-coordinate Terminality introduces no
  new race and removes the joint-split hazard — cited in §3.0c.
- **CONTESTED: none.** Round 8 falsified one Round-7 construction (the bundled
  successor), one Round-7 witness choice (intent in check (b)), and one Round-7
  worked example (the penalty day lines); all three corrections are in print with
  the numbers that forced them.

## 10. Residuals for Round 9 / the .tex

1. DS10 / Herstatt with the NS-02 currency workstream (interface only); the CLM-CO
   income-leg composition rides the same routing pattern to the billing/income
   workstream.
2. Executable-property additions this round: the minting-rule property (no
   constructible unit whose legs span two external instructions; mixed corrections
   always yield two units); the delivery-first interleaving over generated mixed
   corrections (no transient false break may appear — the r = +70 mutant must
   fire); check (b) under generated stalled sends and re-dispatch chains (correct
   charges CLEAN, false charges BREAK, wrong-selector and wrong-witness mutants both
   fire); the two-case boundary over generated matching timestamps straddling the
   cut-off (totals conserve; the flipped day lands on the right party; the
   date-granular mutant fires). Zero firings is a defect.
3. The parked ch16 four→five spec-pass edit rides with the .tex (TA-CUSTODY text
   final, residual now two-membered).
4. Temporal conformance: held set; the two-unit mixed case inherits Flag A verbatim.

