# Deferred Settlement, v16-Native — Round 7 Candidate

**Cell:** deferred-settlement design cell. **Author:** TuringAward (first-principles lead).
**Supersedes:** `candidate_r6.md`. **Round-7 tally:** 4 APPROVE (sbl,
regulatory-reporter, rosetta, jane-street — fresh surfaces red-teamed, nothing
breaking), 3 BREAK, each its reviewer's sole blocker, all completions of R6-introduced
machinery: R7-B1 completes the case-split per coordinate (as R6-B1 completed R5-B2);
R7-B2 + R7-B3 complete the penalty machinery on one surface (honest trust-typing;
sequential windows) and are fixed together. The three .tex carries are folded in.
Every item answered in §9. **Status:** Round 7 candidate. Not the final .tex. Not
committed.

---

## 1. The problem (settled since Round 2; held)

Buy 100 XYZ at $50.00 Monday, T+2; Tuesday's $52.00 close makes +$200.00 real before
any custody movement. The bound between the internal record and the external
assertions — the binary reconciliation invariant, everything crossing the one door —
is this candidate. v16.0 carries everything else.

## 2. Classification (delta from Round 6 only)

- **Totality, again, one level down.** R6 made the case-split total in the quantity;
  R7-B1 shows netting is **per coordinate** and the two coordinates of one correction
  can land on opposite sides of settled mass. The split is now taken independently per
  coordinate — the same completion R6-B1 was to R5-B2, applied to the dimension the
  single decision flattened.
- **Honesty of detection claims.** The matched date is single-source: the CSD asserts
  the very number its own charge depends on. Reconciliation against it is
  self-consistency, not verification — §8 now says so, the two cross-checks that ARE
  possible from our own record are stated, and what survives them is a **named**
  residual (CLAUDE.md §1: no guarantee narrowed by relabelling; no detection
  over-claimed).
- **Faithfulness to the charging regime.** CSDR's two penalties are sequential, split
  at the matching date — not parallel. R6's overlapping windows would false-BREAK a
  correct advice: the false-positive that mutes the detector, the failure mode this
  design retired EXPECTED-DIFF to avoid. The fold now partitions.

## 3. The design

**Thesis (held).** Three cross-cutting rules: the Spine pins the read; the Binding
pins the write; Terminality pins the race. This round makes the Binding total per
coordinate and the penalty machinery honest and sequential.

### 3.0a The Spine (held)

All identity inputs fold in force at the statement's valid-time; declared data
forward-only; revocations carry t_c.

### 3.0b The Binding (case-split now per coordinate — R7-B1)

Held: one restated parameter set derives all legs and balance moves; successors net
recorded settled mass per coordinate; settled cash nets at amounts actually moved.
Completed: the forward-versus-return decision is taken **independently for each
coordinate**. For each coordinate c of the corrected unit:

- **restated_c ≥ settled_c:** forward successor leg of (restated_c − settled_c), in
  the coordinate's original direction;
- **restated_c < settled_c:** return leg of (settled_c − restated_c), in the
  **opposite** direction — the counterparty hands back the excess.

All legs positive; both branches may appear **in the same correction**, one per
coordinate; the successor unit carries whatever legs result, under one new root
reference. R6's bust is the special case where both coordinates land in the return
branch; Round 5's forward case is where both land forward; R7-B1's mixed case — a
price correction over a partially settled trade — is one of each, worked in §6.

*Delete-test (per-coordinate independence):* delete it and R7-B1's numbers stand: buy
100 @ $50.00, 30 settled ($1,500.00 cash moved), price corrected to $10.00 with
quantity unchanged — the quantity branch (100 ≥ 30, forward) drags the cash through
the forward formula: 1,000.00 − 1,500.00 = **−$500.00**, a negative payment leg — the
exact T3 violation R6-B1 eliminated, resurrected one coordinate over. The $500.00 is
economically real (we paid 1,500.00 against a 1,000.00 restated total, and they still
owe us 70 shares); only a per-coordinate split can say both things with positive legs.

### 3.0c Terminality (held; now per coordinate by inheritance)

Settled mass is terminal **coordinate by coordinate**: netted forward where the
restatement exceeds it, unwound forward by a return obligation where it exceeds the
restatement, never negated, never raced.

### 3.1 Existing v16 mechanisms (held; E1–E9)

E1 trade-date booking · E2 the settlement-obligation unit · E3 moveless discharge ·
E4 the partial edge · E5 market claims · E6 registry/quarantine/capture · E7 the
due-date watch · E8 bitemporal doctrine · E9 witness-before-signal.

### 3.2 The mechanisms (deltas; N1, N5, N7 touched; N2, N3, N4, N6 held)

**N1 — The custody-witness event kind (held; match-confirmation trust-typing
corrected — R7-B2 fix 1).** The match confirmation stays in asserter class (iii) with
its typed fields (matched date, late-matching side). What changes is the honesty of
its description: it is **single-source** — the CSD asserts the very date its own LMFP
charge depends on. Round 6 claimed it "corroborated downstream by settlement" and
that "an inconsistent matched date surfaces as an LMFP check failure"; both were
over-claims and are **retracted**: settlement only bounds it (matched ≤ settled), and
the LMFP check compares a CSD number with a CSD number — self-consistency, not
verification. The residual is named in §8. (This subsumes regulatory-reporter's
honesty-sentence carry — discharged together, as directed.)

**N5 — The penalty regime: sequential windows and honest cross-checks (R7-B2 fix 2 +
R7-B3, one surface).**

- *The windows partition at the matching date (R7-B3).* RTS 2018/1229 runs the two
  penalties **sequentially**: **LMFP** on the instruction quantity over
  **[ISD, matching]**, charged to the late-matching side; **SEFP** on the unsettled
  quantity over **[max(ISD, matching), settlement]** — from the *later* of ISD and
  matching (Art.17). The windows never overlap. Round 6 ran SEFP from ISD regardless
  and its §6 text asserted "two lines per day where both apply" — both **retracted**:
  on ISD Wednesday / matched Friday / settled Monday, the R6 fold accrued an extra
  $5,200.00 × 2 = $10,400.00 of SEFP over Thursday–Friday that the CSD never charges,
  so check 3 BREAKs against a **correct** advice. The exact endpoint convention
  (inclusive/exclusive day boundaries) is regulatory-reporter's pin for Round 8; the
  partition itself is not open.
  *Delete-test:* delete the partition and every late-matched fail reconciles BREAK
  against a correct semt.044, permanently — the desk learns to ignore penalty BREAKs,
  and the one advice that is genuinely wrong sails through the muted detector: the
  failure mode EXPECTED-DIFF was retired to prevent, rebuilt in the fold itself.
- *Two cross-checks from our own record (R7-B2 fix 2).* The matched date cannot be
  verified, but it can be **bounded and confronted** with facts we hold: **(a)**
  asserted matched date ≤ recorded settlement date, else BREAK (an advice asserting
  matching after settlement is internally impossible); **(b)** when **we** are the
  asserted late-matching side, the assertion is reconciled against **our recorded
  dispatch-intent timestamp** (fold row 14): if our instruction entered timely on our
  own record, BREAK — we do not accept a lateness charge our own log contradicts.
  What survives both checks is the **named residual** of §8: a CSD inflating the
  matched date *inside* our genuinely-late window. Honest, minimal, named.
  *Delete-test:* delete cross-check (b) and R7-B2's false charge stands silently:
  reality matched Wednesday (zero days late), the advice asserts Friday and us-late,
  every check reads CLEAN, and $10,400.00 is paid that should be $0.00 — against a
  fact (our timely intent) sitting on our own log the whole time.

**N7 — The possession plane (held; "virtual contra" pinned — carry 2).** The paired
lent-coordinate move, both-sided close-out, and micro-cases A′/A″ are held. The
phrase **"virtual contra"** (the external-borrower case) is pinned so it cannot read
as a resurrected mirror wallet: it names **the loan unit's own directed leg** —
recorded on the unit, not a balance in the wallet universe — and the external case
follows the ordinary external-delivery pattern: the borrower outside the ledger
appears exactly as any external counterparty does, through witnessed deliveries and,
on default, the CLM-CO claim. No wallet mirrors the external borrower's book; the
retired `csd_virtual` class stays retired.

### 3.3 DvP atomicity (held, affirmed six rounds running)

Ledger-level paired-leg atomicity at the door; external-CSD atomicity reconciled,
never enforced.

## 4. The fold (rows 4, 14, 15 revised)

| # | Event (kind) | Folds into |
|---|---|---|
| 1 | Execution / instruction | Binding-derived paired re-book + unit at `instructed`; atomic-finality venue: born `settled`, no timer. |
| 2 | Price close | Recorded observation; valuation/PnL are further folds. |
| 3 | Settlement confirmation | Moveless walk to `settled`; racing a pending cancel: settlement wins. |
| 4 | Repair event (intent on the kind) | live(ref) picks the mechanism. Cancel-and-re-instruct **case-splits per coordinate**: restated_c ≥ settled_c → forward leg (restated_c − settled_c, original direction); restated_c < settled_c → return leg (settled_c − restated_c, opposite direction); mixed corrections carry one of each under one new root reference. All legs positive; Δpredicted = 0 by shape in every branch. |
| 5 | Partial confirmation, clip q | Recorded always; ≥ floor: split; below: aggregates on the one live residual. |
| 6 | Fail notice / due-date watch | Walk to `failed` on the remainder; fails cascade. |
| 7 | Custody statement | Identity under the Spine; classification at read; LEAD-LAG lines carry M7 status. |
| 8 | Recall / return; terminal return failure | Paired lent-coordinate move + possession leg; terminal: §9 close-out, owned paired w_L → w_B, CLM-CO, collateral applied. |
| 9 | Scheduled-statement watch (calendar-aware) | Overdue open item. |
| 10 | Buy-in delivery confirmation | Discharges the failed residual; buy-in date = SEFP right endpoint. |
| 11 | Record-date watch inside the gap | Market-claim leg or mirror; claim units outside the identity's range. |
| 12 | Registry / tolerance / key amendment | Forward-only, valid-timed; revocations carry t_c. |
| 13 | Restated statement / finality | Tip-only supersession; identity nets the tip. |
| 14 | Emission receipts: dispatch-intent → send → dispatch receipt; match confirmation; cancellation confirmation | Intent keys live(ref) **and is the recorded timestamp cross-check (b) confronts a lateness charge with**; the match confirmation fixes the LMFP right endpoint and the charged side — single-source, self-consistency-checked, bounded by matched ≤ settled. |
| 15 | CSD penalty advice (semt.044) | Decidable checks per line over the **partitioned** windows — LMFP [ISD, matching], SEFP [max(ISD, matching), settlement] — plus cross-checks (a) matched ≤ settled and (b) charged-side vs our dispatch-intent timestamp; reference price against the SECR-designated-source close; CLEAN / BREAK only. |
| 16 | Penalty reconciliation complete for a period | Binding-derived booking of the period net across both penalty kinds + the penalty settlement-obligation unit, discharged by the collection's camt.054. |

## 5. Temporal mapping (delta from Round 6: none)

Held in full. The per-coordinate split changes what the correction transaction
contains, not how it is orchestrated (Flag A applies to whatever units it mints); the
window partition and cross-checks are projection logic over recorded facts — no new
timer, signal, or activity.

## 6. The running example (held; one addition, one recomputation)

Core, fail/buy-in/cash-in-lieu, partial with sub-floor aggregation, amendment
REF-001→REF-002, quantity-and-price composition (90 @ $49.00), the bust, penalty cash
cycle, A′, A″ both-sided, CA-on-in-flight: all held.

**Addition — the mixed case (R7-B1): price correction over a partial.** Booked
100 XYZ @ $50.00 (owned XYZ 100, USD 995,000.00); 30 settle at the old terms (depot
30, nostro 998,500.00; settled cash $1,500.00). The price is corrected to **$10.00**,
quantity unchanged: restated totals 100 XYZ / **$1,000.00**. live(ref) ⇒
cancel-and-re-instruct; on the recorded cancel confirmation, one atomic transaction:

- compensating `owned` moves: quantity unchanged → no XYZ move; cash booked 5,000.00
  vs restated 1,000.00 → owned(USD) 4,000.00 seller → w_us (owned now XYZ 100 /
  USD 999,000.00);
- retire SO-1r (70 / 3,500.00 → 0);
- per-coordinate split: **XYZ:** 100 ≥ 30 → forward leg, seller delivers
  100 − 30 = **70** (in). **USD:** 1,000.00 < 1,500.00 → **return leg**, seller
  returns 1,500.00 − 1,000.00 = **$500.00** (in). Successor SO-2 carries both legs,
  both positive, both toward us, new root reference.

Identity during the window: predicted depot = 100 + 0 − 70 = **30** = statement ✓
LEAD-LAG; predicted nostro = 999,000.00 + 0 − 500.00 = **998,500.00** = statement ✓
LEAD-LAG. SO-2 settles (70 delivered, 500.00 returned): depot 100, nostro
999,000.00 — predicted 100 / 999,000.00 ✓ **CLEAN/CLEAN**. Total external cash paid:
1,500.00 − 500.00 = **1,000.00 = the restated total** ✓. Under the single split the
same facts forced a −$500.00 leg; under the per-coordinate split every leg is
positive and every number lands.

**Recomputation — the two penalties, sequential (R7-B3; replaces R6's "two lines per
day where both apply", retracted).** 1,000,000 shares, ISD Wednesday, matched Friday
(our side asserted late, 2 bd), settled Monday, reference $52.00, 1.0 bp/day:
**LMFP** = 1,000,000 × 52.00 × 0.0001 × 2 = **$10,400.00** over [ISD, matching] —
Thursday and Friday, on the instruction quantity; **SEFP** accrues only from
**max(ISD, matched) = Friday** to Monday's settlement, on the unsettled quantity,
under the endpoint convention to be pinned in Round 8. No day carries both penalties.
The R6 fold's extra $10,400.00 of Thursday–Friday SEFP — which the CSD never
charges — is gone, and a correct advice reconciles CLEAN. Cross-checks on the same
example: the asserted Friday ≤ Monday ✓ (check a); if our dispatch-intent timestamp
shows entry Wednesday morning, the us-late assertion **BREAKs** (check b) — R7-B2's
false $10,400.00 charge is refused on our own recorded fact rather than paid.

## 7. DS1–DS19 disposition (Round-7 deltas; counts unchanged: 18 satisfied-or-closed · 1 routed · 0 rejected)

Held: DS1, DS2, DS4, DS5, DS6, DS7, DS8, DS9, DS10 (routed), DS11a, DS11b, DS12,
DS15, DS16, DS17, DS18, DS19.

| DS | Round-7 delta |
|----|---------------|
| DS3 | **Held closed; one masked-negative-leg path removed** (the mixed correction now constructs positively per coordinate) **and one false-BREAK source removed** (the window partition — a correct advice no longer BREAKs, so real BREAKs stay audible). |
| DS14 | **Claim made honest.** The fold matches the sequential charging regime (LMFP then SEFP, split at matching); reconciliation of the matched date is stated as self-consistency plus two log-grounded cross-checks, with the un-closable residual **named** — the regime is fully computed, and what cannot be verified is declared, not implied verified. Endpoint day-convention: Round-8 pin (regulatory-reporter). |

## 8. Boundary notes (deltas)

**TA-CUSTODY (held; one residual added, one over-claim retracted).** Class (iii)
enumeration held (dispatch-intent, dispatch receipt, match confirmation, cancellation
confirmation). The match confirmation's description is corrected: **single-source,
self-consistency-checked, not verified** — its two log-grounded confrontations are
matched ≤ settled and the charged-side-vs-dispatch-intent check. The **Residual**
clause gains its named member: *a CSD asserting a matched date later than reality but
inside our genuinely-late window, charging LMFP for days we cannot dispute from our
own record* — undetectable by construction, named, owned by the same governance that
owns the advice tolerance. Round 6's "corroborated downstream by settlement" is
retracted as an over-claim (settlement only bounds it above). This is the CLAUDE.md
§1 discipline: the guarantee is not narrowed and relabelled — the limit is stated as
a limit.

**CDM (carry 1 landed).** Two dispositions added to the cross-walk: the **match
milestone** is CDM-uncarried (TransferStatusEnum has no Matched member) — a sixth
nothing-row; the **bust** maps as `action = Cancellation` on the instruction plus the
settlement-layer return obligation, which is itself row-2 territory (the
settlement-obligation unit gap). Five prior gap rows and both prior corrections:
held. rosetta: APPROVE on file.

**"Virtual contra" pinned (carry 2; §3.2 N7).** The phrase names the loan unit's own
directed leg, never a wallet; the external-borrower case follows the ordinary
external-delivery + CLM-CO pattern. The retired mirror-wallet class stays retired,
and no reading of N7 resurrects it.

## 9. Responses on the record (every Round-7 item)

- **R7-B1 — ADOPTED (§3.0b; fold row 4; §6 addition):** the case-split is taken
  independently per coordinate — forward where restated ≥ settled, return where
  restated < settled, mixed corrections carry one of each under one new root
  reference; the price-down-after-partial case worked in print (deliver 70 forward +
  $500.00 cash return, all legs positive, CLEAN/CLEAN at completion, external total =
  restated total); the −$500.00 negative leg is unconstructible again.
- **R7-B2 — ADOPTED, both parts (§3.2 N1 + N5; §8):** (1) honesty — the matched date
  is CSD-asserted and single-source; the identity self-consistency-checks it and does
  not verify it; Round 6's two over-claims retracted; the erroneous-late-side case is
  a **named TA-CUSTODY residual**; (2) the two cross-checks from our own log —
  matched ≤ settled, and charged-side vs our recorded dispatch-intent timestamp
  (refusing R7-B2's false $10,400.00 on our own recorded fact). The
  regulatory-reporter honesty carry is subsumed and discharged with fix (1), as the
  convergence note directs.
- **R7-B3 — ADOPTED (§3.2 N5; fold row 15; §6 recomputation):** the windows partition
  at the matching date — LMFP [ISD, matching] on instruction quantity, SEFP
  [max(ISD, matching), settlement] on unsettled quantity, never overlapping (RTS
  Art.17's later-of rule); R6's overlap and its "two lines per day" sentence
  retracted; a correct advice reconciles CLEAN; the endpoint day convention is
  Round 8's pin per regulatory-reporter's lane. Fixed jointly with R7-B2 as one
  surface, as the convergence note directs.
- **Carry 1 (CDM dispositions) — ADOPTED (§8):** match milestone as a
  CDM-nothing row; bust = instruction Cancellation + return obligation.
- **Carry 2 (virtual-contra pin) — ADOPTED (§3.2 N7; §8):** the phrase names the loan
  unit's directed leg; the external case follows external-delivery + CLM-CO; no
  mirror wallet, stated so it cannot be misread.
- **Carry 3 (honesty sentence) — DISCHARGED with R7-B2 fix (1)**, per the review's
  own subsumption.
- **CONTESTED: none.** Round 7 falsified two Round-6 claims — the
  settlement-corroboration of the matched date and the parallel penalty windows —
  and both retractions are in print with the numbers that forced them.

## 10. Residuals for Round 8 / the .tex

1. **The endpoint day convention** for the partitioned penalty windows
   (inclusive/exclusive at ISD, matching, settlement, buy-in) — regulatory-reporter's
   pin, the one open item this round leaves in the penalty regime.
2. DS10 / Herstatt with the NS-02 currency workstream (interface only).
3. Executable-property additions this round: the per-coordinate split generator
   (corrections landing the two coordinates on opposite sides — the mixed case must
   construct, the negative leg must not); the window-partition property (correct
   advices under generated match/settle timings reconcile CLEAN; the overlap mutant
   false-BREAKs and must fire); cross-check (b) firing on generated false-late
   charges against recorded timely intents. Zero firings is a defect.
4. The parked ch16 four→five spec-pass edit rides with the .tex (TA-CUSTODY text
   final, including the named matched-date residual).

