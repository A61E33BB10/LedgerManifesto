# Phase 1 — FORMALIS Arbitration of the Design Ruling Memo

**To:** MINSKY (author of record); R. Delloye (owner) after revision
**From:** FORMALIS — Leroy (chair), Coquand, Huet, Paulin-Mohring, de Moura, Avigad
**Re:** `phase1_design_ruling_memo.md` — formal soundness and arbitration of D1–D5
**Date:** 2026-07-11
**Authority:** One-way, against the Ledger Framework Constitution v1.0. This arbitration is final on the internal disputes; the constitution amendments remain the owner's to ratify.

---

## Overall verdict: NEEDS REVISION

The architecture is confirmed. The regime-keyed universal model (option C), the signed basis, the marker mechanics, the obligation treatment of sufficiency, and all five dispute resolutions survive formal scrutiny; no bench overruling is overturned. But the memo as drafted contains one violated claim (the securities-reuse "actuals"), one law stated in a form that contradicts the memo's own binding condition (the owned-plane conservation clause), one missing invariant that admits a phantom-encumbrance state the stated laws do not exclude, one non-total case analysis (D5), one amendment the memo wrongly declares unnecessary (§4's list sentence), and an incomplete micro-case. Every defect is local and cheaply repaired; none forces a return to the benches. The memo may go to the owner only after the eight revisions in section 9.

*Leroy:* "The design is a correct compiler with three wrong comments and one missing pass. Fix the comments; add the pass."

---

## 1. Item 1 — D3 conservation law: DEFECT (two), plus one law the memo fails to state

### 1.1 The law, stated precisely

Let W be the set of all wallets, including every virtual counterparty and issuer wallet (constitution §4: "Every counterparty outside the system is represented by a virtual wallet inside it, so the system is closed"). Let bal_c(w, u) be the signed balance of wallet w in unit u on coordinate c ∈ {owned, lent, posted}. The correct law is:

> **For every unit u, every coordinate c, and every log position n: Σ_{w ∈ W} bal_c(w, u) = 0.**

Proof by induction on the log. Base: at registration of u every plane is empty; each sum is 0. Step: by the memo's own binding condition (section 5, testcommittee: "No balance write except through a single-coordinate paired-leg move"), every balance write is a paired-leg move debiting −q and crediting +q on the same coordinate of the same unit; each sum is preserved. The per-unit summed law Σ_c Σ_w bal_c = 0 is a corollary, and the memo is right to make the per-coordinate form primitive: the summed law alone would license cross-coordinate rebookings.

### 1.2 DEFECT 1 (HIGH) — the memo's owned-plane clause is vacuous or contradictory

The memo (D3) states: "Σ owned(w, u) is invariant under every move and changes only at issuance and retirement."

Case analysis on what issuance is:

- **If issuance is a move** — and it must be, since §4 makes the atomic move "the sole operation that changes a balance" and the memo's own testcommittee condition makes moves the sole balance mutator — then issuance is a paired-leg move against the issuer's virtual wallet, Σ owned never changes, it is identically 0, and the clause "changes only at issuance and retirement" is **vacuous**: it names a change that cannot occur.
- **If issuance is not a move** — a mass injection taking Σ owned from 0 to N — then it violates the sole-mutator condition the memo binds itself to in section 5, and it breaks closure (§4): conservation reverts from definitional to checked, which is exactly what the memo's own D3 argument forbids.

Either horn is a defect. **Minimal fix:** replace the clause with the Σ = 0 form of §1.1; define issuance as the first paired-leg owned move from the issuing wallet and retirement as the log position after which every wallet's vector for u is zero. Under this form, "a unit retires only from the zero vector" acquires its precise meaning — each wallet at zero, the issuer included — and both stated disciplines survive unchanged.

On the question referred to us directly: the D2 title-transfer re-booking (owned: A −Q, B +Q) preserves Σ owned(·, u) trivially — the invariant is a sum over wallets, and the memo's parallel phrasing for the posted plane ("Σ over all wallets of posted(w, u) = 0") binds the quantifier clearly enough for the owned plane too. The quantifier is not the defect; the issuance clause is.

### 1.3 Verification through the named operations

Under the corrected law, all pass:

- **Loan initiation** (lent plane, pledge form): lender +Q / borrower −Q on lent; zero-sum; owned untouched. Holds. (See §1.5 for the title-transfer loan consequence.)
- **Pledge posting** (D3): poster +Q / taker −Q on posted; zero-sum; owned untouched. Holds.
- **Title-transfer re-booking** (D2): owned zero-sum between A and B; the claim-for-equivalent and obligation units are issued by paired-leg moves against the obligor's wallet, so each new unit's owned plane is born summing to 0. Holds.
- **Micro-case (c)**: every step is a paired-leg single-coordinate move or a moveless state change. Holds (but see item 5 for the sequence's incompleteness).
- **Retirement at the zero vector**: under the corrected law this is well-defined and non-vacuous; under the memo's phrasing it would require Σ owned to change at retirement, contradicting zero-sum moves.

### 1.4 DEFECT 2 (HIGH) — a move sequence the stated laws fail to exclude: phantom encumbrance

The task was to find a move sequence violating the stated laws. We found the converse and worse: a sequence violating **reality** while satisfying every stated law.

> Wallet W holds owned(bond) = 0, posted(bond) = 0, and has received nothing. Transaction: move posted(bond) 100, W → B, under agreement G (AgreementRef present).

Every stated law holds — the posted plane stays zero-sum, the agreement reference is mandatory and supplied, conservation is intact — yet W has encumbered 100 bonds it neither owns nor possesses. The stated laws are **too weak**: nothing bounds a wallet's posted mass by its possession. The constitution demands illegal states be unrepresentable wherever possible (§2, §11); the memo claims "no special case in the move-and-coordinate algebra" without stating the coverage invariant that makes the algebra honest.

**Minimal fix:** state the coverage predicate as a door-checked admission invariant, per (wallet, unit):

> owned(w, u) − Σ_G posted_G(w, u) ≥ 0  (net over agreements; the received ray enters with positive sign), and the analogue on the lent plane.

Verify: A owns 100, posts 100 → 100 − 100 = 0 ✓. B receives 100, re-posts 100 → 0 − (−100 + 100) = 0 ✓ (rehypothecation chains pass). W above → 0 − 100 < 0, refused ✓. Note the contrast the memo already draws for sufficiency applies in reverse here: **sufficiency is lawfully false intraday and is therefore an obligation; coverage is never lawfully false, because a transaction is atomic and possession is instantaneous within it — it is therefore an invariant, checked at the door.** State both classifications side by side.

### 1.5 CONSEQUENCE (MEDIUM) — the SBL corollary is entailed, not merely flagged

The memo flags (section 5) that the regime principle "moves the on-loan representation toward claim units" and defers to the SBL chapter. We record that the chapter has no freedom here: D2's own derivation — "owned must be the coordinate the move machinery can act on"; the taker of title-transfer collateral may lawfully sell — applies verbatim to the GMSLA loan leg, since the borrower's entire purpose is to sell (the short). A lent-plane marker with owned retained by the lender makes the short sale unrepresentable, or representable only by violating the coverage invariant of §1.4. The corollary is a theorem of the ruling, not an open question; the memo should say so, leaving the SBL chapter its mechanics but not the conclusion.

---

## 2. Item 2 — D2 overruling of the auditor: SOUND on the poster's side; DEFECT on the receiver's side

### 2.1 The overruling itself is formally coherent

The auditor's constraint — owned must track economic ownership — was overruled on the coordinate and satisfied on the report. We confirm the overruling. Keeping owned with the poster makes the taker's lawful outright sale a special constructor and the GMRA paragraph 5 manufactured payment unrepresentable; D2's shape makes both ordinary. The poster's economic position is preserved by the claim-for-equivalent priced identically to the referenced asset, so inception is value-neutral and PnL path-independence (§8) survives — verified in micro-case (b): A's coupon-date wealth change nets to zero exactly as a bondholder's does, B nets to nil.

### 2.2 Exact input set of the IFRS 7 §42D / FINREP F32.01 projection (poster side)

The projection must read, and needs nothing else:

1. the claim-for-equivalent balances (log);
2. the referenced-asset identifier in the claim unit's declared terms — **the memo must state explicitly that the claim's terms name the referenced asset**, since "priced identically to the asset it references" presupposes the reference is on the record (ProductTerms, log);
3. the agreement unit's declared regime and the presentation rule declared on it (log, as data);
4. the return/repurchase obligation balances (log);
5. prices — recorded observations (record).

Every input is on the record. One boundary condition must be stated rather than assumed: IFRS 7 §42D asks for **carrying amounts**, which equal fair value only because the Ledger's scope is trading-book positions held at fair value. Outside that scope the measurement basis is an accounting-policy fact, which the constitution places outside the record — and outside the project's scope. Within scope, the projection is complete; the memo should say "complete within the fair-value scope" so the claim is exact.

### 2.3 DEFECT 3 (CRITICAL as claimed; cheap to fix) — the receiver's side, and the falsity of "securities reuse keeps true actuals"

The memo's section 5 states: "Securities reuse keeps true actuals." As stated, this is false, and it contradicts the memo's own D1 rationale. Two legs:

- **Title-transfer received securities (the GMRA repo — the dominant form).** Under D2 they land on the receiver's owned plane, commingled with proprietary holdings of the same ISIN. The received ray of the posted plane — the memo's own mechanism for reuse actuals ("re-use is a posting of mass held only on the received ray") — covers pledge-form receipts only. For repo-received bonds, whether a later sale of that ISIN is reuse of collateral or sale of proprietary stock is exactly the unobservable attribution the memo calls "a stored fiction" for cash. The fungibility argument does not distinguish cash from fungible securities positions on the same coordinate. Consequently SFTR Art. 15 reuse, FINREP F32.02's reused/available split, and IFRS 7 §15 for title-transfer received collateral require the same declared-convention estimation as D1's Table 4 — or a source attribution (§2.3 second leg). The memo works only the poster's F32.01 and presents F32 as recovered; F32.02 is the receiver's template and is not yet recovered.
- **Pledge-form reuse with mixed mass.** Even on the marker plane the actual is not determined by coordinates alone. Counterexample: B holds owned(bond) = 50 proprietary and posted = −100 received under G1; B posts 60 to C under G2. The coordinates yield reused ∈ [10, 60]; no projection of the basis decides it. The claimed "per-(unit, agreement) actuals" are actual only when the taker holds no other mass of the unit.

**Minimal fix:** (i) require the re-pledge move to carry a **source-agreement reference** in addition to its governing AgreementRef — the source is an observable fact of the custody instruction, so this stores no fiction, and it restores true actuals for pledge-form reuse; (ii) for title-transfer received securities, either extend the same source tagging to the on-sale move or concede the declared-convention estimation exactly as for cash — symmetrically, and say so in section 5; (iii) correct the section 5 bullet to: "Pledge-form reuse keeps true actuals (given source attribution); title-transfer reuse projects by the same declared convention as cash."

With these, "no second store" survives: everything added is a declared datum on a move or an agreement, on the log.

---

## 3. Item 3 — D1 rejection of coll_recv(cash): SOUND, with one binding condition

The rejection is confirmed, and the reg-reporter's overruling with it. The per-dollar actual for commingled fungible cash is not an observable fact; a coordinate storing it would store an attribution fiction and diverge from the nostro intraday — the precise failure class the constitution abolishes. The finops fungibility argument is decisive.

**Determinism of the Table 4 projection.** The projection reads: the return-obligation units per agreement (amount, currency, declared rate — log), the reinvestment transactions (log), and the pro-rata convention declared once as data (log). Two readers applying a declared total convention to the same log compute the same figures — deterministic **by construction, conditionally**. The condition, which the memo gestures at ("declare the attribution convention as data") but does not pin:

> The declared convention must be a **total function of log state**: it must fix (i) the pool predicate — which wallets and which moves constitute "the firm's reinvestment book," a term the memo uses but never defines; (ii) the timestamp or period basis of the pro-rata ratio; (iii) the rounding rule, with remainders booked per §4's remainder discipline. Absent any of the three, two readers compute different Table 4 figures from the same log, which is a defect by this committee's standard.

**Fix (HIGH):** promote the condition to a binding Phase 2 obligation in section 5, alongside the TLA+ obligation, with "reinvestment book" defined as a declared wallet/move predicate. So conditioned, D1 stands.

*de Moura:* "A declared convention is a pure function shipped as data. Ship its whole domain."

---

## 4. Item 4 — Amendment texts: Amendment 1 DEFECTIVE in one clause; Amendment 2 sound but insufficient; "no further amendment is needed" FALSE

### 4.1 Amendment 1 against the rest of §8

The three-case replacement is sound in structure, and the retained sentence "A deposit therefore cannot move profit and loss" survives all three cases — **provided one fact is stated**: under case 2 the return-obligation unit must be a valued unit priced at the inflow amount (par plus accrued at the declared rate), else net owned value moves at receipt and the sentence fails. The memo assumes this; the amendment or the v15 text must state it (MEDIUM).

Two defects in the text itself:

- **DEFECT 4 (HIGH) — case 3's scope conflicts with D5 and with the auditor's own narrowing.** The text reads "collateral received under a security interest, including cash segregated without right of use, is this case." The word *including* makes segregation an example, not a boundary: security-interest cash **with** right of use — the New York–law CSA, the commonest US arrangement — falls into case 3 as drafted. But commingled right-of-use cash in the receiver's nostro reproduces the exact intraday divergence D1 abolishes, and D5's enumeration (STM → settlement; CTM and title-transfer CSA → financing; segregated security-interest → custody) never assigns it at all: **D5's case analysis is not total.** Fix both at once: adopt the auditor's boundary — case 3 for cash is "under a security interest **without right of use**" — and add to D5 the fourth arm: security-interest cash with right of use follows case 2 upon exercise of the right (for cash, receipt into the receiver's own accounts is the exercise), the regime declared on the agreement unit as ever.
- **DEFECT 5 (MEDIUM) — the closing sentence over-quantifies.** "Which case governs an inflow is declared once, on the agreement unit under which it moves" ranges over *every* inflow of value; a plain equity purchase moves under no agreement unit and needs none. Scope it: "Where an inflow moves under a margin or collateral agreement, which case governs it is declared once, on that agreement unit." Case 1 for ordinary exchanges needs no declaration.

### 4.2 Amendment 2 and §4's list sentence — a third amendment is required

Amendment 2's inserted sentence is sound and we endorse it. But the memo's conformance claim — "No further amendment is needed. §4's coordinate list survives as the projection vocabulary" — is **self-refuting**, by §4's own closing sentence:

> §4 (list): "…it generalises to a vector of coordinates: owned, lent out, borrowed, posted as collateral, received as collateral."
> §4 (closing): "Anything computable from the coordinates is a projection, computed when needed and never stored."

Under the memo's reading, borrowed and received-as-collateral are computable from the stored basis (they are lent⁻ and posted⁻). By §4's closing sentence they are therefore projections, "never stored" — yet §4's list sentence presents all five uniformly as *the coordinates of the balance vector*, i.e., as the stored state. The memo cannot hold both (i) the five names are the constitutional coordinates and (ii) two of the five are never-stored projections. The contradiction is in the reading, and only an amendment dissolves it. One clause suffices:

> **Amendment 3 — §4, list sentence.** Replace "…it generalises to a vector of coordinates: owned, lent out, borrowed, posted as collateral, received as collateral." with "…it generalises to a signed vector of coordinates — owned, lent, posted — whose named rays are: lent out and borrowed, the two signs of lent; posted as collateral and received as collateral, the two signs of posted."

This preserves the constitutional vocabulary (all five names remain, fixed, one name per component of the interface), makes the following sentence "Only the owned coordinate carries economic value" exact, and lets Amendment 2's "the remaining coordinates" refer cleanly to lent and posted. The memo's remaining conformance sentences (the physical-action test grounding D1/D3; §6 satisfied by obligations-as-units; §8 sharpened not replaced) are verified correct.

**Verdict on "no further amendment is needed": FALSE** — one further amendment (the above) is needed; with it and the case-3 correction, nothing else in the constitution is touched. We checked the remaining claims of section 6 sentence by sentence against §4 and §8 and confirm them.

---

## 5. Item 5 — Micro-case (c): mechanics SOUND; sequence INCOMPLETE; one phrasing error

- **Single-writer:** respected. O's contract is the sole writer of O's UnitStatus; G's contract is the sole writer of the margin-call obligation; the payout move and the marker return are distinct coordinates written by distinct causes. No shared fact has two writers.
- **Idempotence:** the duplicate touch finds UnitStatus = triggered and proposes nothing (matching §3 of the constitution); duplicates in flight before admission are caught by the cause-derived identifier. Sound.
- **The two disciplines:** the knock changes UnitStatus and price, never a coordinate (value not mass) — respected at every step; sufficiency is handled as an obligation. Sound.
- **Intraday under-collateralisation:** properly an obligation, not an invariant violation. Between steps 2 and 4 the shortfall is lawful, deadline-bearing, and discharged or compensated under §14 obligation liveness; the memo's honesty about the temporal race, and the TLA+ obligation covering it, are exactly right. Confirmed.
- **DEFECT 6 (HIGH) — the sequence never reaches the zero vector.** As worked, the sequence ends with posted cleared (step 4) but owned(O) = {A: +1, writer: −1} forever: the retirement the memo's own discipline requires ("a unit leaves the ledger only from the zero vector") is never enabled. A step 5 is missing: after the marker return, the extinguishment move owned(O) A → writer, taking every wallet to zero, then retirement. Note the ordering is forced by the coverage invariant of §1.4: extinguishing owned before the posted return would leave A with posted mass exceeding owned — the invariant correctly refuses it. Add step 5 and cite the ordering as the invariant at work, which strengthens the case rather than weakening it.
- **DEFECT 7 (MEDIUM) — step 1 phrasing.** "The knock lands in UnitStatus" at emission time is wrong by the constitution's own machine boundaries: the Monitor emits events and "cannot affect the correctness of ledger state" (§5); UnitStatus changes only when the Transaction Executor admits the transaction proposed in step 2. The knock is *on the record* at step 1 and *in UnitStatus* at step 2. Rephrase.
- **Observation, no defect:** a real security agreement typically attaches to proceeds; the memo's default (payout to A, then margin call) is one lawful shape, and an agreement declaring proceeds attachment would have G's contract post the cash instead — declared terms deciding, which is Q2 applied. Worth a sentence.

---

## 6. Item 6 — Internal contradictions in the memo

Beyond those already recorded (the reuse-actuals claim vs the D1 fungibility rationale, §2.3; the issuance clause vs the sole-mutator condition, §1.2; Amendment 1 case 3 vs D5's enumeration, §4.1), one more:

- **DEFECT 8 (MEDIUM) — the metamorphic property is stated without its side condition.** D3 claims: "insert a post-and-return anywhere in a history and every later valuation is identical." False as quantified. Counterexample: insert the pair spanning agreement G's declared valuation watch; G's contract observes the received mass, fires a margin-call obligation, and its discharge moves owned cash — later valuations of both wallets differ. The property is true of the **move algebra** (no contract firings between insertion points), or of insertions whose interval contains no valuation watch of the referenced agreement. State the side condition; as a property test, generate the pair within watch-free intervals, and let the TLA+ model own the watched case. The property is still the right oracle for the trap case; it merely needs its hypothesis.
- **Observation:** "priced identically to the asset it references" is a declared pricing rule, not a theorem — the claim bears the taker's credit. Within this architecture that is a pricing-layer concern (recorded observations; XVA outside scope), not a coordinate concern; a footnote suffices.

---

## 7. Final rulings on the disputes

- **D1 — CONFIRM MINSKY.** Received title-transfer cash writes owned plus a valued return-obligation unit; coll_recv(cash) is rejected. The reg-reporter's overruling is sound: the per-dollar actual is unobservable for commingled fungible cash, and the Table 4 projection is deterministic once the attribution convention is total (binding condition, §3).
- **D2 — CONFIRM MINSKY.** Title-transfer securities re-book owned to the taker, with claim-for-equivalent and obligation units. The auditor's overruling is sound: economic ownership is preserved by the claim, and IFRS 7 §42D / F32.01 project from the record within the fair-value scope. Conditions: the claim's terms must name the referenced asset; the receiver-side templates (F32.02, IFRS 7 §15, SFTR reuse) must be recovered per §2.3, and section 5's actuals claim corrected.
- **D3 — CONFIRM MINSKY.** Marker mechanics; owned never decremented by a pledge; v13.1's valuation switch deleted. Note the reg-reporter's substantive constraint (pledged financing collateral remains the poster's owned/encumbered) is *satisfied*, not overruled — marker mechanics keep owned with the poster, and Σ owned·P equals v13.1's Σ(own+coll_post)·P by construction. Conditions: restate the conservation law per §1.1–1.2; add the coverage invariant of §1.4; add the metamorphic side condition of §6.
- **D4 — CONFIRM MINSKY.** Line valuation as mandated default; package valuation admissible only as declared terms through the ordinary pricing layer; floors are projections, never stored valuations. No defect found; the ruling is exactly §6 faithfulness plus Q2, and the testcommittee's package-aware-minimiser condition is properly carried.
- **D5 — CONFIRM MINSKY, with the enumeration totalised.** The three-way split (settlement / financing / custody) is correct and each arm is correctly grounded in §8's three cases; but the case analysis must be total: security-interest cash with right of use must be assigned (case 2 on exercise of the right), and Amendment 1's case-3 wording narrowed to match (§4.1).

---

## 8. The FORMALIS test, applied

1. **Specification complete and unambiguous?** After revision — yes. Before it: D5 non-total; "reinvestment book" undefined; reuse actuals overclaimed.
2. **Types prevent invalid states?** Orphan collateral: yes (no agreement-free constructor). Phantom encumbrance: no — the coverage invariant must be added (§1.4).
3. **Invariants stated and preserved?** Conservation: preserved, but misstated (§1.2). Coverage: preserved by intent, unstated. Sufficiency: correctly an obligation, not an invariant.
4. **Totality?** D5's regime classifier is partial (§4.1); the D1 convention's domain is unpinned (§3).
5. **Determinism?** Yes throughout, conditional on the convention totality of §3 and the source attribution of §2.3.
6. **Composition?** Yes — the projection claims decompose into log-resident inputs, and we have named the complete input set for each.

---

## 9. Required revisions (all local; one drafting round; no bench re-consultation required)

1. **(R1, from Defect 1)** Restate the D3 conservation law: for every (unit, coordinate), Σ over all wallets = 0 at every log position; issuance and retirement are paired-leg moves against the issuing wallet; delete "changes only at issuance and retirement."
2. **(R2, Defect 2)** State the coverage invariant — owned(w,u) minus net posted (and the lent analogue) never negative — as a door-checked admission predicate, and state the invariant/obligation contrast with sufficiency explicitly.
3. **(R3, Defect 3)** Correct the reuse claims: source-agreement reference on re-pledge moves (restoring pledge-form actuals); title-transfer received securities project reuse by the same declared convention as cash; fix the section 5 bullet and recover F32.02 / IFRS 7 §15 receiver-side explicitly.
4. **(R4, Defects 4–5)** Narrow Amendment 1's case 3 to "under a security interest without right of use"; add the fourth arm to D5 (right-of-use security-interest cash → case 2 on exercise); scope Amendment 1's closing sentence to inflows moving under a margin or collateral agreement.
5. **(R5, §4.2)** Add Amendment 3 — the one-clause rewrite of §4's list sentence to the signed basis with the five names as rays — and strike "No further amendment is needed" in favour of "no amendment beyond these three."
6. **(R6, Defects 6–7)** Complete micro-case (c) with step 5 (owned extinguishment after the marker return, ordering forced by R2's invariant; then retirement at the zero vector); rephrase step 1 (the Monitor emits; UnitStatus changes only on admission).
7. **(R7, §3 and §4.1)** Bind the D1 convention's totality (pool predicate defining "reinvestment book," period basis, rounding) as a Phase 2 obligation in section 5; state that the case-2 return-obligation unit is valued at the inflow amount so §8's deposit-neutrality sentence holds.
8. **(R8, §1.5 and Defect 8)** Record the SBL corollary as entailed by D2's derivation, not merely flagged; add the side condition to the post-and-return metamorphic property (watch-free interval, or move-algebra scope with the watched case owned by the TLA+ model).

With R1–R8 applied, this committee will certify the memo READY FOR OWNER without further review of the unchanged sections.

*Huet:* "Every law the memo needed was already implied by its own commitments; our work was only to make it say them."

— End of arbitration —

---

## Certification — compliance check of the revised memo (rev. 2)

**Date:** 2026-07-11. **Scope:** verification that R1–R8 are discharged as specified and that the TALEB-driven additions introduce no new formal defect. This is a compliance check, not a re-arbitration.

**R1–R8: all discharged.** R1 (conservation as Σ = 0 per (unit, coordinate), issuance/retirement as paired-leg moves, induction stated) — section 3, verbatim as specified. R2 (coverage invariant with the invariant/obligation contrast) — section 3, but see the one residual defect below. R3 (source-agreement references; title-transfer reuse by declared convention; receiver-side F32.02 / IFRS 7 §15 recovered; section 5 bullet corrected) — discharged. R4 (Amendment 1 case 3 narrowed to "without right of use"; D5 totalised with the fourth arm; closing sentence scoped to agreement-governed inflows) — discharged. R5 (Amendment 3, verbatim as drafted; "no amendment beyond these three") — discharged. R6 (micro-case (c) completed to the zero vector with the ordering forced by coverage; Monitor phrasing corrected in step 1) — discharged. R7 (convention totality bound as a Phase 2 obligation with pool predicate, period, rounding; case-2 obligation valued at the inflow amount) — discharged. R8 (SBL corollary recorded as entailed; metamorphic side condition stated in D3) — discharged.

**TALEB additions: verified, no new defect.** (i) Micro-case (c) step 5, one transaction, two moves: owned(USD) is zero-sum (writer −1,000,000 / A +1,000,000), posted(USD) is zero-sum (A +150,000 / B −150,000); conservation holds per plane; coverage is checked on the atomic post-state, so intra-transaction ordering raises no issue, and A's post-state satisfies it (150,000 ≤ 1,000,000 plus prior owned). (ii) The determination/payment split is consistent with §8 deposit-neutrality and P10 path-independence: the conditional obligation is a valued receivable; its creation is price-carried PnL (the knock's gain, recognised at determination — correct economics, not a deposit), and its discharge is a §8 case-1 exchange of receivable against cash, so NAV is continuous across the split; the manufactured-payment and market-claim instances check the same way. (iii) Counterparty-state pricing of per-netting-set claims is ordinary state-parameterised valuation (§8); default decouples price, never mass — the value/mass discipline holds. (iv) The regime-misdeclaration repair (ProductTerms amendment plus compensating rebooking) is the constitution's own repair shape (§2, §13), and naming the error class §13-invisible is correct. (v) The supervised write-off path clears mass by paired-leg compensating moves and retires at the zero vector — conservation and the disciplines survive.

**One residual defect — DEFECT 9 (HIGH, one-line fix), in the coverage predicate's stated form.** As written — "owned(w, u) − Σ_G posted_G(w, u) ≥ 0, checked at the door on every admission, per (wallet, unit)" — the predicate is violated by every wallet whose owned is negative with nothing posted: the issuer wallet that the memo's own Σ = 0 conservation law creates at issuance (owned = −N, posted = 0 gives −N < 0), and the memo's own short-poster example (owned = −5,000) before any posting is attempted. As stated, the invariant refuses the issuance transaction itself and every transaction touching a negative-owned wallet. The committee notes the wording originated in our own R2 and corrects it: the predicate binds only the posting direction —

> **Σ_G posted_G(w, u) ≤ max(owned(w, u), 0)**, and the analogue on the lent plane.

This is equivalent to the stated form wherever net posted mass is positive, and vacuous elsewhere. Every example in the memo already conforms (A posts 100 of 100 owned: 100 ≤ 100; the rehypothecation chain: net −40, vacuous; the short poster posting 5,000: 5,000 ≤ 0, refused; the issuer wallet: 0 ≤ 0; micro-case (c) step 5: 150,000 ≤ 1,000,000⁺). No design consequence follows; only the sentence changes.

**VERDICT: CERTIFIED READY FOR OWNER, conditional on the one-line restatement of the coverage predicate above.** No re-review is required: the correction is textual, uniquely determined, and already the form the memo's own examples obey. With that sentence corrected, this committee's certification is unconditional.

— FORMALIS: Leroy (chair), Coquand, Huet, Paulin-Mohring, de Moura, Avigad —
