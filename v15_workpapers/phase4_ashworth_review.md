# Phase 4 Review — ASHWORTH (production reality, Team B)

**Subject:** Ledger Specification v15.0, chapters 01–17 (`Ledger_Spec_v15.0/ledger/drafts/`)
**Rated against:** Ledger Framework Constitution v1.1; Phase 1 collateral ruling; Exclusions Register.
**Standpoint:** where the spec's claims would not survive contact with a live book — confined to
defects that are *internal* to the specification's correctness against its own constitution.
Out-of-scope operational wishes (buy-ins, SSI, CSD connectivity, SBL ops lifecycle, legal
mastering, tax policy) are named in the register and are **not** reported as gaps.

I write specifications' obituaries for a living. The design here is unusually honest — it names
more of its own residuals than most shipped systems ever admit. The findings below are the places
where it is still telling itself a story that a production book will not corroborate.

---

## Assumptions being made that need to be validated

- **A1.** That the coverage invariant, "never lawfully false because a transaction is atomic and
  possession is instantaneous within it" (Ch.9 §The two guards; Ch.14 Inv. *Possession coverage*),
  covers every way `owned` can change. It reasons only about the *posting* transaction. It says
  nothing about a *later* transaction that **reduces** owned while posted/lent mass stands.
- **A2.** That the agreement unit's declared terms — regime bit, eligibility schedule, per-line
  valuation percentages, thresholds, trapping predicate (Ch.9) — are ground truth. They are a
  **bilateral** legal document transcribed **once, from one side**, and admitted as a boundary
  observation with no attestation, no multi-source rule, and no failure catalogue. Only the single
  regime bit gets a named boundary detector and repair path.
- **A3.** That reinvestment-pool membership is expressible as "a declared wallet and move predicate"
  that is a **total function of log state** (Ch.12 Prin. *Attribution totality*; Ch.8 §slot). Real
  reinvestment-book membership is often an operational tagging decision, not a predicate over
  recorded moves.
- **A4.** That the one genuinely two-sided reported figure (SFTR 2.73, collateralisation of net
  exposure) can be "sourced from the governing agreement unit's declared terms … consistently with
  the counterparty" (Ch.12 §reconciled surface). This is the *same* single-sided transcription of A2.
- **A5.** That a trade's settlement is binary — `SettlementState = Instructed | Settled | Failed`
  (Ch.11). Partial, tranched, and CSDR auto-partial settlement have no representation.
- **A6.** That "the reference-data join … can never alter a quantity" (Ch.12 §projection principle),
  while collateral **eligibility** — a door admission gate on posted mass (Ch.9) — is in practice
  driven by reference-data classifications (rating, asset class, issuer domicile).
- **A7.** That a manufactured payment is fully described by a **trapping condition** on the gross
  determined entitlement (Ch.9 §Entitlements; episodes b, securities-loan dividend). Real GMSLA/CSA
  manufactured payments are **amount transformations** (withholding tax, manufactured-dividend rate),
  not merely release/withhold conditions.

---

## Ranked findings

### F1 — HIGH — Ch.9 / Ch.11 / Ch.14: the coverage invariant has no defined behaviour when an involuntary transaction reduces `owned` beneath standing posted/lent mass.

**The defect.** Coverage is stated as a state invariant checked at the door on every admission:
`Σ_G posted_G(w,u) ≤ max(owned(w,u), 0)`, and declared "never lawfully false, because a transaction
is atomic and possession is instantaneous within it" (Ch.14 Inv. *Possession coverage*; Ch.9). That
justification is about the act of *posting*. D2 (Ch.9 §Timing) books `owned` **at instruction** —
trade-date — and Ch.11 makes the buyer's owned plane show the shares the instant the trade is
instructed, before settlement. Under coverage, the buyer may then lawfully post or lend that
instructed-owned mass. Ch.11 then states: **"settlement failure is a recorded event, never a
reversal"** — a failed trade is unwound by a **compensating transaction that reduces owned**.

Nothing in the spec says what the door does when that owned-reducing correction would leave standing
posted/lent mass in violation of coverage. Two outcomes, both unhandled:
  - the door **admits** the correction → the state now has `posted > max(owned,0)`; the invariant
    the whole collateral design rests on is false in a *reachable committed state*; or
  - the door **refuses** the correction → the system cannot record a settlement failure it has
    already recognised as a fact. A correction that cannot be admitted is a system that cannot
    correct itself — the opposite of the auditability commitment.

**The concrete failure case.** W-BETA buys 10,000 ACME from W-ALPHA; owned re-books to W-BETA at
instruction (2026-05-14, settlement 2026-05-16). On 2026-05-15 W-BETA pledges 6,000 of them to
counterparty C under agreement G — admitted, coverage holds (posted 6,000 ≤ owned 10,000). On
2026-05-16 the purchase **fails** (W-ALPHA never delivers). The recorded settlement-failure
correction must remove 10,000 from W-BETA's owned. But 6,000 are pledged to C under G, which W-BETA
**cannot unilaterally clear** — recall of that collateral requires C's cooperation, a substitution,
or a call. The "coverage forces the order" trick that saves the knock case (Ch.9 §knock, step 6;
Ch.14 episode T2) does **not** apply: there, one party controls both the marker and the owned
extinguishment inside one voluntary transaction; here the downstream encumbrance is under a
different counterparty's agreement and outside W-BETA's control. The correction is stuck — it
cannot be admitted (coverage fails) and cannot be deferred (the failure is a recorded fact).

This is the securities-fails cascade every settlement team knows. The register defers the
*operational* resolution (buy-in) to the SBL Operations Companion (E73), and rightly so — but the
**invariant behaviour** under involuntary owned-reduction is core Ch.14 content, not operations, and
it is unaddressed.

**Suggested fix (directional; the spec team should design it, not adopt this).** Two families exist,
and the spec currently commits to neither: (a) admit that an owned-reducing correction may leave
coverage transiently violated, and convert the shortfall into a *sufficiency-style obligation* —
deadline-bearing, discharged by recall/substitution/close-out — i.e. reclassify the stranded
encumbrance from an invariant breach into the same obligation machinery already carried for
sufficiency; or (b) distinguish *instructed-owned* from *settled-owned* and forbid re-use of the
former — which would gut D2's central claim that owned is what the move machinery can act on at
instruction. Either is a real design decision. The current text skips it.

---

### F2 — HIGH — Ch.9 (against Ch.8's standard): the collateral-agreement's declared terms are an un-cataloged boundary input; W1–W4 / TA-KIND / multi-source discipline is not held.

**The defect.** Ch.8 holds every market-data observation to a rigorous boundary discipline:
provenance on every datum (obs door), a datum-kind registry with an immutable dimension declaration,
adjustment-schedule totality, the invariance witness, the **named trust assumption TA-KIND**, and a
**four-mode failure catalogue W1–W4** (missing / late / contradictory-sources / unmappable) each
with a determined replayable disposition. This is exactly the standard a zero-trust data boundary
must meet.

Ch.9's collateral, margin, and lending machinery rests entirely on the **agreement unit's declared
terms** — the regime (settlement/financing/custody), the eligibility schedule, the per-line
valuation percentages, the thresholds and deadlines, and the trapping predicate. Every one of these
is a boundary input: a bilateral legal document, transcribed once, from one side. Ch.9 holds them to
**none** of Ch.8's discipline. It handles exactly one class — the regime bit — for which it names a
§13-invisible detector (boundary reconciliation against the counterparty/CCP statement) and a repair
path (terms amendment + compensating rebooking). That is precisely a W-regime for one field. The
eligibility schedule, the valuation percentages, the thresholds, and the trapping conditions get no
analogue: no "late/amended terms" mode (backdated CSA amendments and side letters are routine), no
"contradictory sources" mode (our transcription vs the counterparty's copy of the same paragraph),
no TA-style named trust assumption owning the transcription's fidelity.

The task asked directly whether other chapters hold Ch.8's standard. Ch.9 does not, and Ch.9 is where
the "largest balance-sheet consequence in the design" (its own words) is decided.

**The concrete failure case.** A CSA is amended on 2026-06-30, backdated effective 2026-06-01, raising
a valuation percentage from 95% to 98% and adding an eligible asset class. Our desk transcribes it on
2026-07-05; the counterparty transcribed it on 2026-07-01 with a different reading of the eligibility
wording. For the intervening month the ledger's coverage and sufficiency checks, the line valuation,
and the presentation projection all ran on stale/divergent declared terms — with no bitemporal "as
known at t / corrected through t'" machinery (which Ch.8's W2 *does* provide for data) and no
"aggregation failed" flag (Ch.8's W3). Nothing internal detects it; there is no named boundary duty
to reconcile the *terms* the way Ch.9 names one to reconcile the regime bit's margin consequence.

**Suggested fix (directional).** Either extend Ch.8's boundary discipline explicitly to the agreement
unit's declared terms (a terms-kind registry entry, a bitemporal amendment mode, a named trust
assumption "TA-TERMS" owned by legal/onboarding, a contradictory-source flag against the
counterparty's copy), or state in Ch.9 that the full terms set — not merely the regime bit — is a
boundary input carrying the same §13-invisible / boundary-detected / repair-by-amendment discipline.
Today only one field of many carries it, and the asymmetry is silent.

---

### F3 — MEDIUM — Ch.12 / Ch.8: attribution-convention "totality" assumes reinvestment-pool membership is a pure predicate over log state; if it needs operational tagging, totality is hollow and a manual step re-enters.

**The defect.** Ch.12 (Prin. *Attribution totality*) and Ch.8 (§slot) make the commingled-cash
re-use attribution a "total function of log state" whose first component is a **pool predicate** — "a
declared wallet and move predicate defining the pool over which received value is attributed." The
totality argument, and the "two readers of one log compute identical figures" claim, both rest on the
assumption that reinvestment-book membership is expressible as a predicate over recorded (wallet,
move) data.

In production, which reinvested cash belongs to which pool is frequently an operational/treasury
tagging decision — driven by desk intent, funding-book assignment, or facts that are not on the
ledger's move record at all. If pool membership cannot be reduced to a predicate over recorded moves,
then "the convention is a total function of log state" is a fiction: the real attribution requires an
input that is not on the record, and a **manual step re-enters** precisely where Ch.12 claims none
exists ("no reporting store … no manual step"). The spec asserts the pool *is* a predicate; it does
not establish that it *can* be, for the reinvestment case it is built to serve.

**The concrete failure case.** Two SFTR Table 4 reinvestment figures are computed from one log because
two operators tagged the reinvestment book differently — not because the convention was incomplete
(all three components were declared), but because "the reinvestment book" is not determinable from
recorded moves and each declared a different pool predicate encoding a different operational judgment.
The spec's safety argument (single-sidedness — no counterparty to break against) still holds, so no
*external* break; but the internal claim "two readers of one log compute identical reports" fails, and
the reason is a manual judgment the totality principle assumed away.

**Suggested fix (directional).** State explicitly the load-bearing precondition — that the pool
predicate is decidable from recorded (wallet, move) state alone — and require it as a checkable
property of any declared convention, so a convention whose pool depends on off-record operational
tags is *refused* (the same fail-closed posture Ch.12 already takes for a missing component). If pool
membership genuinely cannot be made log-decidable for reinvestment, that is a named residual, not a
totality theorem.

---

### F4 — MEDIUM — Ch.12: the one two-sided figure (SFTR 2.73) is excluded from the "no second store / identical reports" claim without the exclusion being made load-bearing.

**The defect.** Ch.12's spine is "every reporting figure is a projection … no reporting store … two
readers of one log compute identical reports." The chapter then concedes, in §reconciled surface, that
exactly one figure — collateralisation of net exposure (SFTR 2.73) — is "genuinely two-sided," and
that its correctness standard is **agreement with a second party**, sourced "from the governing
agreement unit's declared terms … consistently with the counterparty."

Two problems compound. First, the source it points to — the agreement unit's declared terms — is the
same single-sided transcription flagged in F2; "consistently with the counterparty" is not something
the projection can deliver, it is an external reconciliation outcome the ledger cannot guarantee.
Second, this is the one figure that is the *very reconciliation the framework claims to abolish*, and
the headline claims of the chapter ("no second store," "identical reports," "reconciliation failure
reintroduced through a report is a defect") are asserted in full generality and only quietly walked
back for it. A reader who trusts the headline will over-claim to a regulator.

**The concrete failure case.** The firm reports 2.73 = "collateralised"; the counterparty reports
"partially collateralised" because their transcription of the threshold and netting-set scope differs.
Both computed a "projection of the record"; the records differ because the bilateral agreement was
transcribed twice. This is a real EMIR/SFTR pairing break, and the chapter's framing invites the
reader to believe the architecture has removed it. It has removed it *inside* the boundary; the figure
that matters most for supervisory pairing sits *on* the boundary.

**Suggested fix (directional).** Make the two-sided/one-sided split a first-class, load-bearing
statement at the top of the chapter, not a late concession: the projection totality claim is total
over single-sided figures and *silent* on the two-sided one, whose correctness is an external pairing
outcome dependent on the agreement-terms transcription of F2. Say it once, up front, so the headline
is not read as covering the figure it does not cover.

---

### F5 — MEDIUM — Ch.11: `SettlementState = Instructed | Settled | Failed` cannot represent partial, tranched, or CSDR auto-partial settlement.

**The defect.** Settlement in size is routinely partial: partial delivery, CSDR mandatory auto-partial
and hold-and-release, FoP deliveries in tranches. Ch.11 models settlement state as a single per-trade
enum with three total values and mints the market claim "valued at par" for the **full** quantity with
a **binary** discharge predicate ("the deliverer's receipt of the distribution"). A 10,000 sale that
settles 6,000 and fails 4,000 is neither `Settled` nor `Failed`, and the record-date market claim has
no partial-discharge form. Settlement *mechanics* are out of scope; the ledger's *representation of a
partially-settled position and its market claim* is in scope (Ch.11 is a scope chapter item), and it
is incomplete.

**The concrete failure case.** Record date falls in the gap on a 10,000 sale that auto-partials to
6,000 settled / 4,000 failing across the record date. The paying agent credits the record holder for
the whole 10,000; the ledger's market claim, minted at par for 10,000 with a single receipt predicate,
cannot represent that 6,000 of the entitlement should now route to the settled buyer and 4,000 remains
the deliverer's to remit. The routing proposition (Ch.11 Prop. *Entitlement routing*) is stated as a
total function of "the recorded settlement state" — but the state space it ranges over cannot express
the actual state.

**Suggested fix (directional).** Either make settlement state quantity-bearing (settled quantity vs
instructed quantity, so partial is a first-class recorded fact) or decompose an instruction into
per-tranche settlement facts, and give the market claim a partial-discharge predicate. Note the scope
boundary carefully in doing so — the *mechanism* of partialling stays external; the *recorded state*
must be able to hold it.

---

### F6 — MEDIUM — Ch.9 / Ch.12: reference-data-driven eligibility gates admission, contradicting Ch.12's "the reference-data join can never alter a quantity."

**The defect.** Ch.12 §projection principle: reference data "attaches labels and groupings; it can
never alter a quantity … A figure carrying a wrong identifier is a labelling defect … never a ledger
defect." But Ch.9 makes **eligibility** a door admission check — "an ineligible posting is refused at
the door" — and real eligibility schedules are expressed against classifications (rating, asset class,
currency, issuer domicile) that are external **reference data**, per Ch.12's own boundary statement. A
reference-data reclassification (a downgrade below the eligibility floor) therefore changes an
admission decision, hence the posted mass that may lawfully exist — it *alters a quantity-gating
decision*. The two chapters are in tension: Ch.12 says reference data never touches quantities; Ch.9's
door check is, in the realistic case, partly a reference-data decision.

**The concrete failure case.** A pledged bond is downgraded below the CSA's eligibility floor. If
eligibility is resolved against reference-data rating (the common case), the posting that was
admissible yesterday is ineligible today — a quantity consequence driven by a reference-data change,
which Ch.12 says cannot happen. If instead the spec intends eligibility to be a self-contained ISIN
enumeration in the agreement terms (no reference-data resolution), that should be stated, because it
is not how CSAs are written, and it makes eligibility a static list that cannot track downgrades.

**Suggested fix (directional).** Decide and state whether the eligibility schedule is (a) a
self-contained enumeration in declared terms — clean but unrealistic — or (b) a predicate over
reference-data classifications — realistic but then reference data *does* gate admission, and its
staleness/divergence is an unstated door dependency that needs the F2 treatment. The chapters cannot
both stand as written.

---

### F7 — LOW/CLARIFY — Ch.9: the manufactured payment is modelled as a trapping *condition* on the gross entitlement, not as an *amount transformation*.

**The defect.** §6 faithfulness binds the ledger to what the agreements declare. The determination
reads owned and produces the gross entitlement; the payment routes through a conditional obligation
whose discharge predicate carries "trapping terms" — a **release/withhold condition**. Real GMSLA/CSA
manufactured payments are frequently **amount** transformations: a manufactured dividend net of, or
grossed-up for, withholding tax, or a contractually reduced manufactured rate, where the two
counterparties may sit in different tax jurisdictions. A conditional obligation that discharges the
*gross* determined entitlement (Ch.9 episode b; securities-loan dividend episode routes the full
2,000 / 12,500) is unfaithful to an agreement that declares a manufactured amount differing from the
issuer's distribution.

**The concrete failure case.** A US borrower manufactures a dividend to a non-US lender under a GMSLA
that specifies a manufactured rate net of 30% US withholding. The ledger routes the full gross
dividend through the obligation, overstating the lender's manufactured receipt by the withholding.

**Suggested fix (directional / clarify).** State whether the obligation's *amount* is itself a declared
function of the agreement (permitting net/grossed manufactured payments) or whether the design
deliberately routes gross and treats tax as an out-of-scope accounting-policy matter. If the latter,
say so — tax is not in the constitution's out-of-scope list, so the omission is currently silent.

---

### F8 — LOW — Ch.5 / Ch.8 / Ch.9: amended corporate-action notices are not clearly placed between Ch.8's bitemporal data-correction mode (W2) and the event-driven dividend handling.

**The defect.** Ch.8's W2 makes the *data* boundary bitemporal — a late or amended datum is placed at
its own observation time and derived folds are recomputed. But a corporate action is not only data; it
is an *event* that fires a contract (Ch.5, Ch.9) and may have already recorded entitlements or paid.
An amended dividend rate (1.50 → 1.60 after announcement, before or after record date) is a routine
production event that is neither cleanly a W2 data correction nor cleanly a fresh corporate action.
The spec's general answer is "compensating transaction," which is correct but underspecified: the spec
does not say whether an amended notice supersedes the prior one via the `corrects` chain at the event
level, nor how the cause-derived idempotence key behaves when the *cause* (the notice) is itself
amended rather than duplicated.

**Suggested fix (directional / clarify).** Place amended corporate-action notices explicitly:
either as a bitemporal event correction (a `corrects`-chained superseding event) with a stated
interaction with the cause-derived key, or as a named case in Ch.8/Ch.9. Today it falls between two
disciplines.

---

## Items deliberately NOT reported as defects (correctly scoped or honestly named)

- **Close-out / netting algebra undesigned.** Named in Ch.17 open-problems index; the design commits
  per-netting-set claim units (registry growth accepted) on the strength of an algebra that does not
  yet exist. **Accept-with-note:** honestly named, but it is a commitment made ahead of the algebra
  that justifies it — worth the owner's eye at the gate.
- **Supervised write-off path (Ch.9).** The one acknowledged human-authorised step in an otherwise
  by-construction system; it is where stranded/dead marker mass accumulates until supervision acts (and
  is the natural home for F1's stranded encumbrance). **Accept-with-note:** correctly named as
  "supervised," but it is a standing liveness dependency on a human, in a framework whose ethos is
  fail-closed and by-construction.
- **Buy-ins, CSDR settlement discipline, SBL operational lifecycle, SSI/CSD connectivity, per-regime
  field inventories, tax policy, legal mastering.** Out of scope per the Exclusions Register and the
  constitution's scope section. Not reported.

---

## Questions that must be answered before this specification is considered sound

1. **(F1)** When a recorded settlement-failure reversal, a recall, or any correction reduces `owned`
   beneath standing posted/lent mass under a *third party's* agreement, does the door admit the
   correction (coverage false in a committed state) or refuse it (the system cannot record a fact it
   has recognised)? Which, and where is it written?
2. **(F2)** Why is the collateral-agreement's full declared-terms set (eligibility, valuation %,
   thresholds, trapping predicate) held to *none* of Ch.8's boundary discipline, when the single
   regime bit is? What is the failure catalogue and repair path for late, amended, or
   counterparty-divergent agreement terms?
3. **(F3)** Is reinvestment-pool membership decidable from recorded (wallet, move) state alone? If
   not, in what sense is the attribution convention "total," and where does the operational tagging
   step live?
4. **(F4)** Should the two-sided/single-sided split be stated up front as load-bearing, so the
   chapter's "no second store / identical reports" headline is not read as covering SFTR 2.73, the one
   figure it cannot cover?
5. **(F5)** How does the ledger represent a partially-settled position and its record-date market
   claim? What is `SettlementState` when 6,000 of 10,000 settle?
6. **(F6)** Is the eligibility schedule a self-contained enumeration in declared terms, or a predicate
   over reference-data classifications? If the latter, reference data gates admission — contradicting
   Ch.12 — and its staleness is an unstated door dependency.
7. **(F7)** Is the manufactured-payment *amount* a declared function of the agreement (net/grossed for
   tax and manufactured rate), or is gross-routing deliberate with tax declared out of scope?
8. **(F1/write-off)** Given F1, is the supervised write-off path the intended sink for encumbrance
   stranded by an involuntary owned-reduction — and if so, what bounds how long the obligation-liveness
   queue carries it before a human must act?

— End of ASHWORTH Phase 4 review —
