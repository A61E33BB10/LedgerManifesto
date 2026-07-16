# Deferred Settlement, v16-Native — Round 6 Candidate

**Cell:** deferred-settlement design cell. **Author:** TuringAward (first-principles lead).
**Supersedes:** `candidate_r5.md`. **Round-6 tally:** 3 APPROVE (rosetta, nazarov,
jane-street — fresh surfaces red-teamed, nothing breaking), 4 BREAK collapsing to three
mechanisms (correctness-architect and sbl found R6-B3 independently, same numbers). All
R5 items held. All three breaks are **completions of adopted machinery, not redesigns**:
R6-B1 completes the Binding below settled mass; R6-B2 completes the penalty regime's
second window; R6-B3 applies A′'s both-sidedness rule to A″. The three non-blocking
carries are folded in. Every item answered in §9. **Status:** Round 6 candidate. Not
the final .tex. Not committed.

---

## 1. The problem (settled since Round 2; held)

Buy 100 XYZ at $50.00 Monday, T+2; Tuesday's $52.00 close makes +$200.00 real before
any custody movement. The bound between the internal record and the external
assertions — the binary reconciliation invariant, everything crossing the one door —
is this candidate. v16.0 carries everything else.

## 2. Classification (delta from Round 5 only)

- **Totality.** The Binding's successor formula was partial: it went ill-typed when a
  correction landed below settled mass. It is now total by case-split (§3.0b) — and
  the dangerous case was one where the identity *accidentally* read r = 0 while the
  state was wrong: a masked defect, worse than a loud one, caught because leg
  direction — not the residual — drives the fails cascade, the penalty fold, and the
  buy-in binding.
- **Completeness of the penalty model.** CSDR levies two daily penalties, not one;
  the fold now computes both (SEFP and LMFP), which requires one more recorded
  lifecycle fact: the CSD match confirmation (§3.2 N5).
- **Conservation, per (unit, coordinate), no alchemy.** Round 5's terminal write-off
  moved securities "off" the lender — unpaired, so the door itself would have refused
  it. Securities conserve as securities: the defaulter keeps what it failed to return,
  the lender keeps a cash claim, and both custody accounts reconcile (§3.2 N7).

## 3. The design

**Thesis (held).** Three cross-cutting rules: the Spine pins the read; the Binding
pins the write; Terminality pins the race. This round makes the Binding total and
Terminality's unwind constructive.

### 3.0a The Spine (held)

All identity inputs fold in force at the statement's valid-time; declared data amended
forward-only; revocations carry t_c.

### 3.0b The Binding (completed below settled mass — R6-B1)

Held: every leg-touching transaction derives legs and balance moves from one restated
parameter set; successors net recorded settled mass **per coordinate — quantity and
cash alike** (a restatement at a new price nets the *settled cash actually moved*, not
residual-quantity × new-price; §6 addition 1 shows why). New: the derivation is now
**total by case-split** on restated versus settled mass:

- **restated ≥ settled:** forward successor, legs = restated − settled (the Round-5
  formula, unchanged).
- **restated < settled** (trade bust after a partial, a routine case): no successor
  forward leg exists. The same transaction mints an **opposite-direction return
  obligation** of (settled − restated): a new settlement-obligation unit, positively
  directed the other way — we redeliver the over-received mass, the counterparty
  returns the corresponding cash — with its own new root reference and its own window.
  Settled mass stays terminal: it is never retired, never negated; it is **unwound
  forward by a new positive-directed obligation**, exactly as Terminality demands. A
  negative leg is unrepresentable (T3 types legs positive-directed), and stays so.

*Delete-test (the case-split):* delete it and R6-B1's bust stands: buy 100 @ $50.00,
30 settles, bust ⇒ restated 0 ⇒ successor leg −30 — ill-typed, and worse, the identity
*accidentally* reads r = 0 (predicted depot 0 − (−30) = 30 = statement) while the true
state — we own nothing and owe 30 shares back — is masked, and every mechanism keyed
on leg direction (fails cascade, penalty fold, buy-in binding) mis-routes. A defect
the invariant cannot see is exactly what the type discipline exists to refuse.

### 3.0c Terminality (held; the case-split is its constructive form)

Settled mass is terminal: successors net it (≥ case), busts unwind it forward
(< case), settlement beats cancel, repairs re-route post-settlement. One doctrine,
now total.

### 3.1 Existing v16 mechanisms (held; E1–E9)

E1 trade-date booking · E2 the settlement-obligation unit · E3 moveless discharge ·
E4 the partial edge · E5 market claims · E6 registry/quarantine/capture · E7 the
due-date watch · E8 bitemporal doctrine · E9 witness-before-signal.

### 3.2 The mechanisms (deltas; N1, N5, N7 touched; N2, N3, N4, N6 held)

**N1 — The custody-witness event kind (held; one witness added to class (iii)).** The
emission-receipt asserter class gains the **match confirmation**: the CSD asserting
that the instruction matched, carrying the **matched date** and the **late-matching
side** — the sibling of the dispatch receipt, same discipline (typed fields,
provenance, tip-only supersession). Unlike the dispatch receipt it is not an
internal-egress witness: the CSD asserts it, and it is corroborated downstream by
settlement itself.
*Delete-test:* delete it and the lifecycle has no recorded *matched* milestone — the
LMFP window [ISD, matching] is uncomputable, so every late-matched instruction
false-BREAKs the penalty reconciliation (its semt.044 LMFP line has no fold
counterpart) and row 16 under-books the collection: R6-B2's $10,400.00, missing every
time matching is late.

**N5 — The penalty regime, completed to both CSDR penalties (R6-B2; carries 1+2).**
Held: dated-clip fold by root reference; three decidable checks; the penalty cash
unit (row 16). Completed:

- *Two windows, one fold.* The fold now computes **both** daily penalties: **SEFP**
  (RTS 2018/1229 Art.17) on the unsettled quantity over [ISD, settlement] — the
  Round-4/5 fold, unchanged — and **LMFP** (Art.16) on the **instruction quantity**
  over [ISD, matching date], charged to the recorded late-matching side. Worked:
  1,000,000 shares, ISD Wednesday, matched Friday (2 bd late), reference $52.00 at
  1.0 bp/day: LMFP = 1,000,000 × 52.00 × 0.0001 × 2 = **$10,400.00** — now in the
  fold, previously missing. The three decidable checks extend to LMFP advice lines
  (same arithmetic form: quantity × reference price × rate × days = amount); row 16
  books the period net of **both** penalty kinds.
- *The reference-price check, pinned at source (carries 1+2, one surface).* Check 2
  compares the advice's reference price against **our recorded close from the
  SECR-designated most-relevant-market source** — the same source the regulation
  itself names (RTS Art.17). Pinning the source eliminates genuine multi-venue
  dispersion *before* the comparison, so the governed tolerance stays truly
  de-minimis (rounding and timestamp noise only) and is never widened into a band
  that would re-admit R5-B4's masked overcharge. Source pin and tolerance sizing are
  one decision with one owner, resolved together, as the reviewers required.

*Delete-test (the second window):* delete LMFP and DS14's "full regime" claim is
false — the fold reconciles only fails, the CSD bills for late matching too, and
every late-matched instruction ends in a false BREAK or a hand-waved payment.

**N7 — The possession plane (completed both-sided — R6-B3; recall symmetry and
terminal routing held).** The terminal close-out of a failed return is now **paired
on the SIGMA coordinate**, as every move must be:

- *The defaulter keeps the securities it failed to return.* The mini close-out's one
  transaction books **owned(SIGMA) 1,000,000, w_L → w_B** — lender written off,
  borrower recognised as owner of what it physically holds and will never redeliver —
  paired, Σ = 0 on the SIGMA coordinate; CLM-CO (cash claim at default valuation)
  minted against the estate; collateral applied by the certified machinery. Securities
  conserve as securities; value conserves as the claim; no cross-coordinate alchemy —
  conservation is per (unit, coordinate), and a cash claim cannot be the conservation
  counterparty of a share.
- Both custody accounts reconcile, worked in §6 (A″ rewritten both-sided like A′).

*Delete-test:* delete the borrower-side booking and both R5 defects stand: the
lender's −1,000,000 write-off is an unpaired move the door must refuse (or sinks
mass wrongly if forced), and the borrower's depot statement shows 1,000,000 SIGMA
against a predicted 0 — **r = +1,000,000 BREAK on the borrower, permanent** — found
independently by two reviewers with the same numbers, which is the review process
telling us the defect was structural, not stylistic.

### 3.3 DvP atomicity (held, affirmed five rounds running)

Ledger-level paired-leg atomicity at the door; external-CSD atomicity reconciled,
never enforced.

## 4. The fold (rows 4, 8, 14, 15, 16 revised)

| # | Event (kind) | Folds into |
|---|---|---|
| 1 | Execution / instruction | Binding-derived paired re-book + unit at `instructed`; atomic-finality venue: born `settled`, no timer. |
| 2 | Price close | Recorded observation; valuation/PnL are further folds. |
| 3 | Settlement confirmation | Moveless walk to `settled`; racing a pending cancel: settlement wins. |
| 4 | Repair event (intent on the kind) | live(ref) picks the settlement mechanism. Cancel-and-re-instruct now **case-splits**: restated ≥ settled → successor legs = restated − settled (per coordinate, cash netted at settled amounts); restated < settled → **opposite-direction return obligation** of the excess, new unit, new root reference, positive legs. Δpredicted = 0 by shape in every branch. |
| 5 | Partial confirmation, clip q | Recorded always; ≥ floor: split; below: aggregates on the one live residual. |
| 6 | Fail notice / due-date watch | Walk to `failed` on the remainder; fails cascade. |
| 7 | Custody statement | Identity under the Spine; classification at read; LEAD-LAG lines carry M7 status. |
| 8 | Recall / return; terminal return failure | Paired lent-coordinate move + possession leg. Terminal: §9 close-out — **owned(SIGMA) paired w_L → w_B** (defaulter keeps what it cannot return), CLM-CO minted, collateral applied; both accounts reconcile. |
| 9 | Scheduled-statement watch (calendar-aware) | Overdue open item. |
| 10 | Buy-in delivery confirmation | Discharges the failed residual (trade plane); buy-in date = SEFP right endpoint. |
| 11 | Record-date watch inside the gap | Market-claim leg or mirror; claim units outside the identity's range. |
| 12 | Registry / tolerance / key amendment | Forward-only, valid-timed; revocations carry t_c. |
| 13 | Restated statement / finality | Tip-only supersession; identity nets the tip. |
| 14 | Emission receipts: dispatch-intent → send → dispatch receipt; **match confirmation (matched date, late-matching side)**; cancellation confirmation | Intent recorded before send keys live(ref); the match confirmation fixes the LMFP window's right endpoint and the charged side. |
| 15 | CSD penalty advice (semt.044) | Three decidable checks per line, **SEFP and LMFP alike**; reference price compared against the recorded SECR-designated-source close under the governed de-minimis tolerance; CLEAN / BREAK only. |
| 16 | Penalty reconciliation complete for a period | Binding-derived booking of the period net **across both penalty kinds** + the penalty settlement-obligation unit, discharged by the collection's camt.054. LEAD-LAG then CLEAN, never a recurring BREAK. |

## 5. Temporal mapping (delta from Round 5: none structural)

Held in full: unit-workflows; intent → send → receipt-capture egress ordering;
settlement-beats-cancel needs no workflow machinery; Flags A/B; no-timer
atomic-finality; R-02 wipe test. The match confirmation and the return obligation are
ordinary observations and units — existing machinery, no new timer family, no new
signal kind. The bust branch mints a unit exactly as the partial edge does: parent
completes, successor signal-with-starts (Flag A applies unchanged).

## 6. The running example (held; three additions revised/added)

Core, fail/buy-in/cash-in-lieu, partial with sub-floor aggregation, amendment
REF-001→REF-002, penalty cash cycle at $26,000.00, recall micro-case A′ both-sided,
CA-on-in-flight micro-case B: all held.

**Addition 1 (revised) — composition, now including price change and the bust.**
*Quantity + price restatement over settled mass (carry 3):* booked 100 @ $50.00;
30 settle ($1,500.00 cash moved); restate to **90 @ $49.00** (restated cash total
$4,410.00). Successor legs: delivery 90 − 30 = 60; payment **4,410.00 − 1,500.00 =
2,910.00** — settled cash netted at what actually moved, *not* 60 × 49.00 = 2,940.00.
Compensating moves: owned(XYZ) −10 → 90; owned(USD) +590.00 → 995,590.00. Predicted
depot = 90 − 60 = 30 = statement ✓; predicted nostro = 995,590.00 + 2,910.00 =
998,500.00 = statement ✓. The $30.00 overpaid on the settled 30 at the old price
comes back through the successor's netted payment leg; price it fresh instead and
r = −$30.00 — the case the composition generator must produce.
*The bust (R6-B1):* same start, 30 settled, then restated = 0. One atomic transaction
on the recorded cancel confirmation: compensating moves owned(XYZ) 100 → seller,
owned(USD) 5,000.00 ← seller (owned now 0 / 1,000,000.00 — we own nothing; the trade
is void); retire SO-1r (70/3,500.00 → 0); settled 30 > restated 0 ⇒ mint the
**return obligation SO-R**, positively directed the other way: delivery 30 XYZ
w_us → seller, payment 1,500.00 seller → w_us, new root reference. Identity during
the return window: predicted depot = 0 + 30 (out) − 0 = **30** = statement ✓
**LEAD-LAG named by SO-R** — the 30 shares sit in our depot *possessed, owed back,
not owned*, and the record says exactly that; predicted nostro = 1,000,000.00 − 1,500.00
(in) = **998,500.00** = statement ✓ LEAD-LAG. SO-R settles: depot 0, nostro
1,000,000.00 — CLEAN/CLEAN. No negative leg existed at any instant.

**Addition 2 (extended) — the two penalties.** The fail runs Wednesday→Friday and the
instruction also matched late (ISD Wednesday, matched Friday, our side late,
1,000,000 shares, reference $52.00, 1.0 bp/day): the fold now shows **two** lines per
day where both apply — SEFP on the unsettled quantity over [ISD, settlement], LMFP =
**$10,400.00** on the instruction quantity over [ISD, matching], charged to the
recorded late-matching side. Each semt.044 line passes its own arithmetic check; the
reference price is compared against our recorded SECR-designated-source close; the
period net across both kinds books through row 16 and discharges on collection —
LEAD-LAG, then CLEAN.

**Addition 3 (rewritten) — micro-case A″, both-sided (R6-B3).** Continuing A′: RU-1
open (possession leg w_B → w_L, 1,000,000 SIGMA); borrower defaults terminally; SIGMA
marks $10.00. Opening identities: a_L predicted = owned 1,000,000 − lent 0… — as at
A′'s recall state: a_L LEAD-LAG (RU-1), a_B LEAD-LAG (RU-1), both r = 0. One
supervised §9 close-out transaction: **owned(SIGMA) 1,000,000, w_L → w_B** (paired;
Σ SIGMA = −1,000,000 + 1,000,000 = 0 ✓); RU-1 extinguished; CLM-CO minted at
1,000,000 × $10.00 = $10,000,000.00 against the estate; cash collateral
$10,200,000.00 applied 10,000,000.00, excess 200,000.00 returned — certified
machinery, every move paired.
Identities after: **a_L**: predicted = owned 0 + 0 − 0 = **0** = statement 0 ✓
**CLEAN**. **a_B**: predicted = owned 1,000,000 = **1,000,000** = statement
1,000,000 ✓ **CLEAN** — where Round 5 left r = +1,000,000 permanent on the borrower.
The defaulter keeps the shares it holds and cannot return; the lender holds a valued,
collateral-backed claim; both books say so; Σ = 0 on every coordinate. Re-establishing
the lender's position is an ordinary new purchase, as before.

## 7. DS1–DS19 disposition (Round-6 deltas; counts unchanged: 18 satisfied-or-closed · 1 routed · 0 rejected)

Held: DS1, DS2, DS4, DS5, DS6, DS7, DS8, DS10 (routed), DS11a, DS11b, DS12, DS15,
DS16, DS17, DS18, DS19.

| DS | Round-6 delta |
|----|---------------|
| DS3 | **Held closed; two masked-defect paths removed.** The bust case no longer produces an accidental r = 0 over a wrong state (§3.0b), and the terminal close-out no longer leaves a permanent borrower-side BREAK (§3.2 N7). |
| DS9 | **Held as restated in Round 5; the possession-plane half is now conservation-honest** — the write-off is a paired move, so the door admits it rather than refusing it. |
| DS14 | **Now claims the full regime, truthfully.** Both CSDR daily penalties (SEFP + LMFP) computed, reconciled by decidable checks against source-pinned reference prices, and booked/discharged through the penalty cash cycle. Round 5's claim covered one of two penalties; the gap is closed, not relabelled. |

## 8. Boundary notes (deltas)

**TA-CUSTODY (held; class (iii) enumeration extended).** The emission-receipt asserter
class now reads: dispatch-intent, dispatch receipt, **match confirmation**,
cancellation confirmation. The match confirmation is CSD-asserted (not an
internal-egress witness) and is corroborated downstream by settlement itself;
detection for it rides the penalty-reconciliation identity (an inconsistent matched
date surfaces as an LMFP check failure). The dispatch receipt's indirect-detection
flag: held verbatim.

**Reference-price governance (carries 1+2 landed).** The check-2 comparison source is
pinned to the SECR-designated most-relevant market; the governed tolerance is sized
for convention noise only, with source pin and tolerance as one governed decision,
one owner, one audit trail. A tolerance widened to absorb venue dispersion is the
banned backdoor by construction, because dispersion is eliminated at the source pin.

**CDM (held).** Five gap rows; two-axis repair vocabulary; the return obligation
(bust branch) needs no new row — it is a settlement-obligation unit, already row 2's
gap. rosetta: APPROVE on file.

## 9. Responses on the record (every Round-6 item)

- **R6-B1 — ADOPTED (§3.0b case-split; §6 addition 1; fold row 4):** restated ≥
  settled → forward successor; restated < settled → opposite-direction return
  obligation of (settled − restated), new unit, new root reference, positive legs
  only; the bust worked to LEAD-LAG/LEAD-LAG then CLEAN/CLEAN with owned honest at
  0/1,000,000.00; negative legs stay unrepresentable; the masked-r=0 hazard named in
  the delete-test.
- **R6-B2 — ADOPTED (§3.2 N1 + N5; fold rows 14–16; §6 addition 2):** the match
  confirmation recorded as an emission-receipt-class witness (matched date,
  late-matching side); the fold, the three checks, and row 16 extended to both SEFP
  [ISD, settlement] and LMFP [ISD, matching]; the reviewer's $10,400.00 now computed
  in print; DS14 claims the full regime only now that it is true.
- **R6-B3 — ADOPTED (§3.2 N7; §6 addition 3):** the mini close-out books
  owned(SIGMA) w_L → w_B paired with the lender write-off — the defaulter keeps the
  securities it failed to return; a_B reconciles CLEAN; Σ = 0 on the SIGMA
  coordinate; A″ shown both-sided like A′. Round 5's single-sided form is owned as a
  structural error: its unpaired move would have been refused by the door the design
  itself specifies.
- **Carry 1 (SECR source pin) + Carry 2 (tolerance sizing) — ADOPTED together
  (§3.2 N5; §8):** one surface, one owner; the de-minimis tolerance never absorbs
  venue dispersion because the source pin removes it first.
- **Carry 3 (composition generator) — ADOPTED (§6 addition 1; §10):** the property
  generates price-change-on-settled-mass (90 @ $49.00 over 30 settled @ $50.00);
  settled cash nets at amounts actually moved, and the fresh-pricing mistake
  (r = −$30.00) is the firing counterexample the generator must produce.
- **CONTESTED: none.** Round 6 falsified one Round-5 construction (the single-sided
  write-off) and one Round-5 completeness claim (DS14); both are corrected in print.

## 10. Residuals for Round 7 / the .tex

1. DS10 / Herstatt with the NS-02 currency workstream (interface only).
2. Executable-property additions this round: the Binding case-split generator (busts
   after partials — no negative leg constructible, return obligation always minted);
   the price-change-on-settled-mass composition case (r = −$30.00 counterexample must
   fire on the fresh-pricing mutant); the LMFP window (late-matched instructions
   reconcile CLEAN; the missing-milestone mutant false-BREAKs); the both-sided
   close-out (generated defaults leave r = 0 on **both** accounts and Σ = 0 per
   coordinate). Zero firings is a defect.
3. The parked ch16 four→five spec-pass edit rides with the .tex (TA-CUSTODY text
   final, class (iii) as extended this round).
4. Temporal conformance: held set, unchanged — the bust branch inherits Flag A
   verbatim.

