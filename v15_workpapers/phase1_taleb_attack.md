# Phase 1 — TALEB Attack on the Collateral Ruling

**To:** v15 committee; MINSKY (roster author)
**From:** TALEB, risk challenger
**Date:** 2026-07-11
**Mandate:** Break the recommendation before ratification. Every attack is an instrument, a sequence, a number. I am not here to be fair.

---

## 0. One-paragraph verdict

The ruling's *coordinate algebra* is sound and I could not break it structurally — per-(unit, coordinate) conservation, mandatory AgreementRef, entitlements-follow-owned, and "sufficiency is an obligation not an invariant" all survive the trap case. But the memo has bought its internal elegance by pushing four hard problems just over the horizon and calling them Phase 2, and two of them are not Phase 2 — they are load-bearing for *correctness of the numbers the desk sees on day one*. The three that must be answered before ratification: (1) the memo's "entitlement always follows owned, no special case" is **factually wrong** — real agreements trap collateral income and the CSD pays the record holder, not the ledger owner; (2) the **claim-for-equivalent unit is mispriced by construction** on counterparty distress — the exact scenario where its price matters; (3) there is **no invariant preventing you from posting collateral you do not possess**, because D3 decoupled posting from owning on purpose. Everything else is a genuine Phase 2/3 obligation, but these three are holes in the hull, not the fittings.

I take the eight attack surfaces in turn. Each: scenario, run against the design, verdict.

---

## 1. The pledged-knock race — is the payout window the design's fault?

**Scenario.** Micro-case (c), made adversarial. A owns one-touch O (pays 1,000,000 on touch, priced 400,000), pledged security-interest to B under agreement G at 50% valuation percentage. B's collateral value 200,000 against exposure 150,000. Sequence, worst interleaving:

- T+0: low print recorded, Monitor emits touch (UnitStatus → triggered).
- T+ε: O's contract reads owned, finds A, moves owned(cash) 1,000,000 writer → A. A's cash is now free and unencumbered.
- T+2ε: A moves owned(cash) 1,000,000 A → external (a wholly legal owned move — A owns it). **The cash leaves the book.**
- T+δ (end of day): G's valuation watch fires, prices triggered-and-paid O at 0, computes shortfall 150,000, fires a margin-call obligation with a deadline.
- A has absconded. Close-out liquidates O worth 0. **B is unsecured on 150,000.**

**Run.** The memo says this is "honestly temporal, not structural," covered because sufficiency is an obligation. Fine — but I need to test two things it does *not* say.

First, the comparison the brief demands: does this design create a window the "decrement-owned-on-posting" design would not? **No — the opposite.** Under the literal-§8 model (option B), posting decrements A's owned(O) to zero and parks the mass on B's coll_recv. When O knocks, the contract reads the owned plane and finds *nobody* owns O — or worse, routes the 1,000,000 to B, who holds it as custody but does not own it. That is a *legally wrong* payout to B. The ruling's entitlements-follow-owned routes correctly to A, who under a pledge *does* still own O. So on this axis the ruling **SURVIVES and beats the alternative.**

Second — and here the memo is silent — **real security-interest agreements trap that payout, and the design releases it.** I verified this against the clauses (SBL bench, ISDA CSA):

- **NY-law CSA Para 6(d)(i) "Distributions":** the Secured Party transfers Distributions to the Pledgor *only if* no Event of Default / Potential Event of Default / Specified Condition exists **and** *only to the extent a Delivery Amount would not be created or increased*. A one-touch that just paid out and collapsed to zero collateral value creates a 150,000 Delivery Amount. Under the actual agreement, the 1,000,000 payout is **retained as additional credit support, not paid to A.**
- **English-law CSA Para 5(c):** same two triggers (sufficiency + Section 2(a)(iii) default suspension).

The memo's "one rule — entitlement always follows owned" books the payout straight to A's free owned cash, unconditionally. The real CSA would have trapped it exactly to cover the shortfall the knock just created. **The design leaks 1,000,000 of value to a distressed poster that the agreement it claims to faithfully represent (§6) would have withheld.** This is not a race the deadline covers — it is a missing conditioning clause.

Now the fair question — is the trapping *expressible* in the memo's own machinery, or a hidden special case? The answer separates the two regimes and is the finding:

- **Title-transfer (repo/English CSA):** there *is* a manufactured-payment obligation object (micro-case (b): "B owes A 12,500"). The memo's obligation framework — deadline, discharge predicate — is expressive enough to carry a sufficiency-and-EOD condition on that predicate. So under title transfer the trapping is *expressible as declared terms of the obligation unit*, and the fix is small: gate the discharge predicate on "no Delivery Amount outstanding and no EOD w.r.t. poster." The memo simply hasn't done it — its "one rule" states unconditional pass-through.
- **Pledge (NY CSA, security interest — the actual trap case (c)):** here is the hole. The memo says of the pledge variant, verbatim, "the manufactured leg is simply absent, because the owner and the beneficiary coincide" — income moves issuer → owned directly, with **no obligation object in between.** But NY CSA Para 6(d)(i) traps distributions the pledgor is *otherwise* entitled to, precisely when a Delivery Amount or EOD exists. With no obligation leg, **there is nowhere to hang the condition.** The memo eliminated the very object a discharge predicate would live on, by asserting owner and beneficiary coincide — which is true for *value* but false for *control*: under a pledge the secured party controls whether the distribution is released. So for the pledge case the conditional trap is **not expressible in the shape the memo chose**, and that is the hidden special case.

**Verdict: SURVIVES-WITH-OBLIGATION.** The coordinate algebra is right; the entitlement *rule* is wrong, and unevenly so. v15 must carry a property: **distributions on posted collateral route through a conditional return/trap obligation gated on a sufficiency-and-default predicate — under pledge as well as title transfer — never as an unconditional issuer → owned pass-through.** Concretely: delete the memo's "the manufactured leg is simply absent" for the pledge; even when owner and beneficiary coincide in value, the release is conditional and needs an obligation object to carry the condition. This is a §6 faithfulness failure, not a timing nicety.

Secondary flag (Phase 2/3): a static 50% haircut cannot cover a digital/one-touch's jump-to-zero-as-collateral. The ruling makes such instruments *representable* as collateral (Q2, "eligibility is declared data") but the ledger will not catch an eligibility schedule that accepts jump-risk collateral at a diffusion-calibrated haircut. The memo should state plainly that under Q2 the eligibility schedule becomes **load-bearing for solvency** and the ledger does not police it.

---

## 2. Ex-date in the settlement gap — "entitlement follows owned" breaks on the calendar

**Scenario.** A sells a bond to B under GMRA (title transfer, D2). Instruction booked; CSD settlement is T+2. The coupon **record date falls at T+1** — inside the gap. 10,000 bonds × 1.25 = 12,500.

**Run.** D2 re-books A's owned(bond) to B *in the inception transaction* — i.e. at instruction time. So on record date the ledger shows **B owns**. The bond's contract reads owned, finds B, moves owned(cash) 12,500 issuer → B. Clean, says the memo.

But in reality settlement has not happened. I verified the mechanics (SBL bench): **the issuer's paying agent pays the CSD record holder at record date, which is still A** (A has not delivered). The ledger credited B; the outside world pays A. The ledger's projection into settlement now disagrees with the custodian about who holds 12,500 of cash — **precisely the internal-vs-external reconciliation break the constitution exists to abolish**, arising because owned re-books on *instruction* while the entitlement in the real world follows the *record holder*, which changes only on *settlement*.

The market's fix is a **market claim** (T2S / ECSDA / CAJWG corporate-action standards): the CSD raises a separate compensating instruction reallocating the coupon from A to B, detected from **record date + 1**, within a **20-business-day** window, settling on/after the issuer pay date. So the economic end-state does reach B — but *days later, via a distinct instrument*, not instantaneously via "the contract reads owned and finds B."

The memo's micro-case (b) asserts "the entitlement always follows owned … no special case." That sentence is only true if **owned re-books at settlement, not instruction** — and the memo never says which. This is the unspecified crack:

- If owned re-books at **instruction** (as D2's "in the same transaction" reads): the ledger pays B, the CSD pays A, and the memo's model has *no representation of the market claim* that reconciles them. The break is real and unbooked.
- If owned re-books at **settlement**: then across the gap A still owns in the ledger, the coupon correctly routes to A (matching the CSD) — but now the claim-for-equivalent unit and the whole D2 shape do not exist until T+2, and the memo's inception-time re-booking narrative is wrong.

Either way, "no special case" is false: the settlement gap **is** the special case, and it needs settlement-state to resolve. The memo defers "the settlement-state join" to Phase 2 as a *finops/encumbrance* axis. That understates it: settlement-state is not a reporting nicety here, it is **required to route entitlements correctly**. Without it, entitlements-follow-owned produces wrong payees for every distribution whose record date lands in a settlement gap — which, on a large repo book rolling daily, is a routine event, not a tail.

**Verdict: SURVIVES-WITH-OBLIGATION, and the obligation is mis-classified in the memo.** v15 must: (i) define *when* owned re-books relative to settlement, and (ii) model the market-claim / manufactured-payment leg as a first-class reconciling instrument over the instruction-to-settlement window. This is a correctness requirement, not a Phase 2 finops projection. Must be answered before "entitlement always follows owned" can be printed as an invariant.

---

## 3. Cascading title-transfer chain — the claim-for-equivalent is mispriced exactly when it matters

**Scenario.** A repos bond X to B (D2: A holds claim-for-equivalent +10,000, priced off X; B owns). B repos X onward to C (B holds claim-for-equivalent; C owns). C sells X outright to market M. The actual bond is now with M. Then **B defaults.**

**Run.** The memo states the claim-for-equivalent is "valued, priced by the ordinary pricing layer identically to the asset it references." So A's claim is priced at **the bond price** — say par, 100. But X's issuer is perfectly healthy; the bond price has not moved. What has moved is **B's solvency**, and A's real recoverable value is no longer "the bond" — A never gets X back (C sold it to M). A gets the repurchase price *if B pays*, and on B's default A has a claim on B's estate for X's value, recovering cents on the dollar. A's exposure was always **B's credit collateralised by X**, not X itself.

The pricing layer, told the claim "references X," returns X's price = 100. On B's default it still returns 100, because X is fine. **The ledger marks A fully long the bond at par at the exact moment A's claim has collapsed to counterparty recovery.** That is not a small error — it is the difference between 100 and, say, 40. On a large repo book this is the whole point of the position, mismarked in the wrong direction, and it mismarks *worst* precisely in the default scenario the number exists to survive.

The memo leans on economic-correctness recompute (§13) as the backstop, but §13 recomputes the transaction *from recorded inputs* — and the recorded input is "claim references X, price X." Recompute reproduces 100. §13 does not catch this, because the defect is in the *pricing rule for the claim unit*, not in a contract mis-executing correct terms.

Compare against the old design: v13.1 kept the bond on the poster's own/coll_post and valued V = Σ(own+coll_post)·P under security interest. That design *also* would not have automatically applied counterparty credit — but it did not manufacture a new "claim priced identically to the asset" object that actively *asserts* the poster is still long the bond. D2's claim unit is a new surface that bakes in the wrong pricing assumption as a stated rule.

**Verdict: BREAKS the pricing claim as written** ("priced identically to the asset it references"). The claim-for-equivalent's value is **not** the asset's price; it is the accrued repurchase price discounted for the counterparty's credit — economically, bond price minus a counterparty-credit / repo-haircut adjustment, parameterised by the *taker's* state. v15 must rule that the claim-for-equivalent is priced through the pricing layer **parameterised by counterparty state** (as §8 valuation is already "state-dependent"), and that on counterparty default the claim decouples from the referenced asset and becomes a recovery claim. Until it does, D2 hands the pricing layer an object it will systematically misprice on the one day it counts. This is the sharpest structural finding and must be answered.

---

## 4. The fungible-claim trap — where does the claim's netting-set identity live?

**Scenario.** A does 50 overnight repos with B on bond X over a quarter, each a different repurchase price and rate. Under D2 each creates a claim-for-equivalent and a repurchase obligation. B defaults; close-out nets under the one GMRA master.

**Run.** Two questions the memo does not answer.

*Fungible or per-agreement claims?* The repurchase **obligation** units cannot be fungible — each carries its own repurchase price, rate, and date. So obligations are per-transaction. Fine. But the **claim-for-equivalent** the memo describes as "priced identically to the asset" — 10,000 of X is 10,000 of X — reads as *fungible*. If claims are fungible across agreements/counterparties, you cannot attribute the right claim quantity to the right netting set; and close-out netting is **per-master-agreement** (cross-master netting is not permitted, may cross jurisdictions). Fungible-across-agreement claims **break netting-set attribution**. If instead claims are per-agreement (really per-transaction), the position count and unit registry **explode** — every overnight repo mints a new registered unit.

*And here is the structural pin:* the memo's mandatory-AgreementRef discipline applies only to **non-owned moves** ("A move whose coordinate is not owned carries a mandatory reference"). But the claim-for-equivalent is a **valued unit held on owned** (D2: the poster "gains a claim-for-equivalent unit," valued, drives no PnL at inception per §8). **Owned moves carry no AgreementRef.** So the claim unit's netting-set identity *cannot* live on the move — it must live in the unit's own identity. That forces per-agreement (per-transaction) claim units, which contradicts the "priced identically to the asset / fungible" reading. The memo has it both ways and rules neither.

**Verdict: SURVIVES-WITH-OBLIGATION, and the obligation exposes a seam.** v15 must rule claims **per-agreement (per-netting-set) units**, accept the position-count growth, and explain how an owned-held claim unit carries its agreement identity given owned moves are AgreementRef-free. Note the tension with Attack 3: once you accept per-counterparty claim identity, pricing-by-counterparty-state (Attack 3's fix) becomes natural — the claim *is* a per-counterparty object. Rule both together or neither is coherent.

---

## 5. STM/CTM misdeclaration — the whole ruling rests on one unverifiable declared bit

**Scenario.** A CSA is declared **STM** (settled-to-market) on the agreement unit. The counterparty / CCP actually operates **CTM** — or, as CME and LCH did in **January 2017**, the CCP changes its rulebook from CTM to STM *mid-life*. The declared datum is now wrong or stale.

**Run.** D5 makes the regime the sole discriminator: STM → settlement (owned move, **no** return obligation, exposure extinguished); CTM → financing (owned move **plus** a return-obligation unit accruing the CSA rate, exposure *not* extinguished). The two produce entirely different balance sheets and entirely different close-out.

Declare STM when it is really CTM: the ledger creates **no return-obligation units**. It believes the day's margin settled and is gone. Legally the variation margin is returnable collateral accruing Price Alignment Interest. On a large cleared book this **omits the entire returnable-margin liability and its PAI accrual** — potentially the largest single liability on the book — and on default the netting set is computed with nothing to return where there should be a large returnable balance. Reverse the error and you book phantom returnable assets and phantom PAI.

How is it detected? **It is not — not by the ledger's own machinery.** §13 economic-correctness recompute reproduces from recorded inputs; the recorded input *is* the wrong regime, so recompute faithfully reproduces the wrong answer. This class of error — a wrong *declared term*, not a contract mis-executing a correct term — is **invisible to the entire self-checking apparatus the constitution relies on.** It surfaces only at boundary reconciliation against the counterparty's or CCP's own margin statement.

That is the deep point. The ruling's elegance ("regime lives in declared data, not in a stored valuation switch") converts a modelling problem into a **data-quality problem on a single bit that (a) the ledger cannot verify, (b) CCPs demonstrably flip mid-life, and (c) carries the largest balance-sheet consequence in the design.** The memo treats regime as reliable input. It is the least reliable input in the whole scheme.

Repair path, which the memo does not discuss: a mid-life regime change is a **ProductTerms amendment** (append a new terms version flipping the regime) **plus** a **compensating transaction** retroactively creating/retiring the obligation units and accruals for the mis-booked interval. Both, not one.

**Verdict: SURVIVES-WITH-OBLIGATION — but this is the obligation the memo most needs to name and least does.** v15 must (i) treat regime as append-only versioned terms with a defined mid-life-amendment path (CCP rulebook change → new terms version → compensating rebooking of the affected stream), and (ii) state explicitly that **regime-misdeclaration is a class of error §13 recompute cannot catch**, whose sole detection is boundary reconciliation against counterparty/CCP statements. Must be answered: the entire D5 split is only as good as this one unverifiable bit.

---

## 6. The pro-rata reinvestment convention — right answer, wrong reason, real exposure elsewhere

**Scenario.** A receives cash collateral under title transfer (D1), commingles and reinvests it. SFTR Table 4 reinvestment figures are projected via a **declared pro-rata attribution**, not per-dollar tracking. The counterparty tracks per-dollar. Do their reports diverge and break dual-sided TR reconciliation?

**Run.** I verified against SFTR (reg-reporter bench, ITS (EU) 2019/363). The memo's *conclusion* — no reconciliation break — is **true**, but its stated *reason* ("ESMA's own guidance prescribes estimation") is **not load-bearing and is partly false:**

- ESMA prescribes a specific estimation *formula* for **securities reuse** (field 4.4), **not** for commingled **cash** — for cash the guidance (ESMA70-151-2838) only permits a "best-efforts" estimate and concedes the blended rate is "meaningless." So two firms *can* legitimately compute different cash-reinvestment figures. If the field were reconciled, the memo's defense would fail.
- The actual protection is structural: **Table 4 reinvestment fields (4.11–4.14) are single-sided, reported at entity/currency-aggregate level, carry no UTI, and are excluded from inter-TR reconciliation.** The cash provider reports no competing figure. There is **no second side to break against.** No attribution convention — pro-rata, FIFO, per-dollar — can cause a Table 4 pairing break, because nothing is paired.

So the memo reaches a safe harbour by luck, resting its weight on a beam (ESMA prescribes estimation) that would snap if leaned on. Worse, it **misses the one place attribution genuinely touches reconciliation:** SFTR Table 2 **field 2.73 "Collateralisation of net exposure"** (Boolean, net-exposure vs transaction-level). *That* is a matching field — if A reports net-exposure basis and the counterparty reports transaction-level, that is a real TR break, driven by which governing agreement applies. The memo says nothing about 2.73.

**Verdict: SURVIVES, but replace the reasoning.** The pro-rata convention is fine — not because ESMA blesses estimation, but because the field is single-sided and unreconciled. v15 must (i) restate the rationale on the correct ground (single-sided, entity-aggregate, non-reconciled), and (ii) add the genuine obligation the memo missed: **field 2.73 must be sourced from the governing agreement consistently with the counterparty**, because collateralisation-basis *is* reconciled. One caveat that reinforces D1: the single-sidedness removes *reconciliation* risk, not *completeness* risk — the aggregate reinvested-cash figure must still be derivable, which is exactly why cash must not vanish into an undifferentiated owned pool. That part D1 gets right.

---

## 7. Negative owned + collateral — no invariant stops you posting what you don't have

**Scenario.** A is short bond U: owned(A, U) = −Q (say −5,000). A posts +Q of U as collateral under agreement G: posted⁺(A, U) = +5,000. Signed planes, as the prompt frames: owned −Q, posted +Q.

**Run.** D3 is explicit: a pledge posting is one move on the posted plane, "owned is never decremented." Conservation is stated **per (unit, coordinate)**: the posted plane sums to zero, the owned plane is invariant. Nothing in per-coordinate conservation constrains the *relationship between* owned and posted. So the ledger cheerfully admits owned(A,U) = −5,000 **and** posted⁺(A,U) = +5,000 simultaneously — they live on independent planes and the posting "never writes owned."

Now run the projections. possess = owned + received; encumbered = posted⁺ (+ lent⁺). A's encumbered(U) = +5,000 while A's owned(U) = −5,000. "Available" = owned − encumbered = **−10,000**. A is short 5,000 of U but has *delivered* 5,000 of U it never possessed. Under a delivered/triparty arrangement the taker B's custody account will not contain the 5,000 (A had nothing to send) — the posted-plane marker says the collateral moved; the custodian says it did not. **Reconciliation break at the boundary, again.** On A's default, B liquidates collateral that was never there; B is unsecured; and A's −5,000 short still needs covering. A nonsensical state — possess = −10,000 — exists with **no invariant tripping.**

The memo actively boasts that per-coordinate conservation is *stronger* than the summed law and makes paired-legs definitional. True — but paired-legs is *intra*-coordinate. It says nothing about *inter*-coordinate sufficiency: you cannot post (deliver) more than you possess. The old design carried exactly this guard — v13.1's avail-identity and locate-drawdown invariants (P14, P19). **D3's "owned is never decremented," adopted precisely to keep the pledge legally clean, has as a side effect the deletion of the possession-sufficiency guard.** The memo's "collateral sufficiency is an obligation" is about *value* sufficiency (collateral ≥ exposure) — a completely different thing from *possession* sufficiency (you hold the units you posted). The memo conflates them by using the same word.

**Verdict: BREAKS — a required invariant is missing.** v15 must carry a possession-sufficiency invariant for *delivered* collateral: for units that physically move on posting (title transfer, triparty, delivered pledge), posted⁺ ≤ possess, or equivalently the posting must be paired with an owned/possess drawdown. Security-interest markers that genuinely leave the asset in the pledgor's box are the only exemption, and even there you cannot grant a security interest over units you do not own. Right now the design makes "deliver collateral you do not have" *representable*, which the constitution's own thesis (illegal states unrepresentable) forbids. Must be answered.

---

## 8. Zero-vector retirement — dead units that no one will bury

**Scenario.** Bond U's issuer defaults; U is worthless. But marker mass sits on posted planes across dozens of live agreements: A posted⁺(U) = +Q under G1…Gn, each taker holding posted⁻(U) = −Q. The memo: "a unit retires only from the zero vector, the agreement's own machinery — margin call, substitution, return — clearing the marker planes first."

**Run.** Follow the incentives. U is worthless. The taker B, holding worthless received-collateral marker, does not want U *returned* — B wants A to **substitute good collateral**, which A does via a *separate* posting of a *different* unit. Once B is made whole with the substitute, **no one has any incentive to run the return move on the dead U.** It is worthless; the effort of clearing it buys nobody anything. So the marker mass on U lingers on the posted plane forever: A posted⁺(U) = +Q, B posted⁻(U) = −Q, in balance (plane sums zero), never cleared. U never reaches the zero vector; **U never retires.**

Now the second-order damage the memo's own disciplines cause:

- **State grows monotonically with defaults.** Every defaulted issuer leaves un-retireable dead units with lingering marker mass. Over a decade the active unit universe accumulates thousands of corpses — the "page-count of state" balloons without bound. The generator universe (the testability win the memo celebrates) inherits them all.
- **Reporting pollution.** Encumbrance projections (FINREP F32, SFTR) iterate the posted planes, which now include dead units — you either report Q of a defaulted ISIN as encumbered collateral at zero value / non-zero quantity, or you bolt on a "dead" flag, which is a *stored fact* the architecture was trying to avoid.
- **Obligation-liveness noise.** The undischarged return obligation on each dead U is, by §14, "a visible, overdue item, never silence." So the overdue-obligation queue fills with permanently un-actionable dead-unit returns — and *that noise can mask a genuine overdue obligation.* The constitution's proudest liveness feature becomes a spam channel.

The two disciplines the memo pairs — "lifecycle events extinguish value, never mass" and "retire only from the zero vector" — combine into the trap: value goes to zero, but **nothing extinguishes mass except a voluntary clearing that no rational party will perform for a worthless unit.**

**Verdict: SURVIVES-WITH-OBLIGATION (Phase 2/3, but must be acknowledged).** v15 needs a **supervised write-off retirement path**: an issuer-default lifecycle event that permits retiring a unit by a compensating clearing move zeroing the marker planes against explicit loss recognition — *without* requiring the voluntary agreement machinery. Otherwise the "extinguish value never mass" discipline guarantees a monotonically growing graveyard of un-retireable units that pollutes reporting and drowns the liveness queue. Not a day-one blocker, but the memo should stop presenting zero-vector retirement as complete; it has no exit for the dead.

---

## 9. Overall assessment

**The algebra holds; the economics around its edges do not yet.** The signed three-basis, per-coordinate conservation, mandatory AgreementRef on non-owned moves, and the trap-case handling are genuinely good and I could not break them on their own terms. The ruling deserves credit for beating both strawmen (A and B) on the pledged-knock routing (Attack 1) and for refusing to store the cash-reinvestment fiction (Attack 6 conclusion is right). But the memo systematically understates how much correctness it has deferred, and it prints two invariants ("entitlement always follows owned," "sufficiency is an obligation") that are false or incomplete as stated.

**Must be answered before ratification (correctness, day one):**

1. **Attack 3 — claim-for-equivalent mispricing.** "Priced identically to the asset it references" is wrong on counterparty default — the one scenario the mark exists for. Rule that the claim is priced parameterised by counterparty state and decouples to a recovery claim on default. *Sharpest structural hole.*
2. **Attack 1 + 2 — "entitlement always follows owned" is factually wrong.** Collateral income is trapped by CSA Para 5(c)/6(d)(i) on a Delivery Amount or default (Attack 1), and the CSD pays the record holder, not the ledger owner, over the settlement gap, corrected only by a later market claim (Attack 2). Under title transfer the trap is expressible on the manufactured-payment obligation's discharge predicate — the memo just omits it; **under pledge the memo deleted the obligation object ("the manufactured leg is simply absent"), leaving nowhere to hang the condition — the genuine hidden special case.** The distribution leg is *conditional* and the settlement gap *is* the special case. Both need settlement-state, which the memo mis-files as a Phase 2 finops projection.
3. **Attack 7 — no possession-sufficiency invariant.** D3's "owned never decremented" deleted the guard against posting/delivering collateral you do not hold. Restore posted⁺ ≤ possess for delivered collateral, or the design makes an illegal state representable.
4. **Attack 5 — regime is an unverifiable, mid-life-mutable single bit.** Name the mid-life amendment path and state openly that §13 recompute cannot catch a mis-declared regime; boundary reconciliation is the only detector. The whole D5 split rests on this.

**Genuine Phase 2/3 obligations (name them, don't pretend they're closed):**

5. **Attack 4 — claim netting-set identity.** Rule claims per-agreement units; reconcile with owned-moves-carry-no-AgreementRef. Couples to fix #1.
6. **Attack 6 — restate the SFTR rationale** on single-sided/non-reconciled grounds, and add field 2.73 (collateralisation-of-net-exposure) as the real reconciled surface.
7. **Attack 8 — supervised write-off retirement** for dead units; zero-vector retirement has no exit for a defaulted issuer's marker mass.

**One line for the owner:** ratify the coordinate algebra; do not ratify the two invariant sentences ("entitlement always follows owned," and the implied "sufficiency is the only obligation") until #1–#4 are answered. The design is elegant where it is visible and fragile where it went quiet — and it went quiet exactly at default, at settlement lag, and at the one declared bit no one can verify.

— TALEB
