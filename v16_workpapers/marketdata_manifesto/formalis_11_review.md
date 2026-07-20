# FORMALIS Cell Review — Market Data Manifesto 1.1

**Reviewer:** FORMALIS (in-cell rigor, drafting cell)
**Target:** `/home/renaud/Ledger/MarketData/MarketDataManifesto_1.1.tex` (8pp, MD-1..MD-15; 1.0 certified, untouched)
**Constitution in force:** `ledger_manifesto_v1_4.tex` (esp. C-9.1/C-9.2/C-9.3, C-4.6, C-14.9/C-14.15, C-2.1/C-2.2)
**Scope:** the three embedded mandates — MD-13 (frames + operator algebra), MD-14 (dispute-readiness),
MD-15 (model binding + price-space validation) — plus the changed/renumbered articles and the repurposed
worked example.

**Headline.** Every hard rigor defect from the 1.0 review is confirmed fixed in 1.1: the two-name
projection/re-entered-observation split (D1/D2) is applied cleanly through the cascade; the reproducibility
overreach is gone from Abstract, MD-6, Conclusion; MD-8 carries the joint-recipe result (D6) and now cites
C-11.5 (not bare C-11); MD-4 states execution time as *asserted and contestable* (D5); the worked example
names all three times and cleanly separates correction from frame-change (the 1.0 conflation). The new
material is largely sound. The defects below are concentrated in **one place — MD-13's treatment of the
inverse — and one garbled example line.** They are surgical, but real, and one is a mathematical error in
the flagship example, so the verdict is RETURN, not sign.

---

## AGENDA ITEM 1 — The naming resolution — **RESOLVED-AS-DRAFTED** (two MINOR notes)

GATHERAL's claim is **correct on the constitutional text.** C-9.2 defines the market data operator as
*exactly* the change-of-frame map: *"To carry pre-event market data into the post-event frame, a
transformation must be applied. The framework gives it a name: the market data operator."* So the operator's
constitutional definition **genuinely covers transport across corporate-action frames** — this is not a
stretch, it is the clause's literal content. Coining no new operator name, and reusing the fixed C-9.2 term
for its own referent, is the right call under C-Auth.4 (which forbids both synonyms *and* overloading — and
there is no overloading here, because the referent is identical).

I checked the other half of the agenda's test — whether 1.1 stretches the operator **"through lifecycle
stages"** as well as corporate-action frames. It does **not.** MD-13, MD-10, and MD-4 confine the operator
throughout to corporate actions ("for each corporate action and kind of data," "a split rescaling a price,"
"the corporate-action frame"). No article routes lifecycle/unit-state transitions through the operator, and
MD-13 keeps the corporate action's C-9.1 transaction effect (unit-state, terms) separate from its C-9.2
market-data-frame effect. **No overloading onto lifecycle stages.** The one-name discipline holds in both
directions (the operator "is never used for a source," guarding the calibration-"Oracle" overload too).

"Frame" as the one new object term is legitimate: it is not in the C-Auth.4 fixed list, and the algebra's
*objects* (frames) are genuinely new while its *morphism* (the operator) is the Constitution's.

- **MINOR (a).** Section 1 claims frame is *"a coordinate system the Constitution does not name."* The
  Constitution **does** use the word — *"the post-event frame"* (C-9.2). The manifesto is *formalising* a
  word the Constitution already uses informally, which is stronger ground, not weaker. Reword to
  *"building on the Constitution's own 'post-event frame' (C-9.2), which this manifesto promotes to a defined
  coordinate system"* — do not claim novelty the source contradicts.
- **MINOR (b).** Section 1: *"the market data operators that adjust it across events (C-9.2)."* The operator's
  domain per C-9.2 is **corporate actions**, not events at large. Change *"across events"* → *"across
  corporate actions"* to avoid implying the operator adjusts data across trades/fixings/breaches.

---

## AGENDA ITEM 2 — The operator algebra (MD-13) — **DEFECT** (invertibility + commutation justification)

**Composition and identity — essentially sound.** Associativity is asserted (*"the chaining is
associative"*); it is in fact automatic — operator composition is function composition, which is
associative — so state it *as* that ("associative because it is function composition") rather than as a bare
claim, per the no-assertion standard. Identity is stated, but the *example* is mis-chosen: *"over any span
with no action the operator does nothing --- a proportional figure simply stands (C-9.2)."* C-9.2's
"proportional figures stand" is the identity of the **(percentage-data, split) pairing** — an action whose
operator happens to be identity — **not** the no-action-span identity the sentence claims. Both identities
are real, but the citation illustrates a different one than the sentence states. **Fix:** for the no-action
identity, say "over any span with no corporate action the operator is the identity"; keep "proportional
figures stand (C-9.2)" as a separate example of an action whose operator is identity for that data kind.

**The inverse — DEFECT (this is the core finding).** The *principle* is honest — *"where the transform
destroys information no inverse exists, and the manifesto claims none"* — so at the principle level item 3 is
satisfied. But the **illustration overstates**, and in the Ledger's own arithmetic:

1. *"a split by ratio r scales by r, its inverse by 1/r --- the operator runs backward from adjusted to
   unadjusted, and traversal is reversible."* Adjusted values are exact integers in minor units (C-4.6), so
   the operator **rounds**: a 3-for-2 on 150.25 gives 100.166… → 100.17, and ×3/2 → 150.255 → 150.26 ≠
   150.25. Under rounding the operator is **not injective and has no exact inverse** — including for splits.
   The clean split is the *exceptional* invertible case, presented as the rule. (Direction nit too: for a
   **price**, a 2-for-1 scales by 1/2, not by r=2; "scales by r" is backwards unless r is defined as the
   price factor.)
2. The honest resolution is **missing**: the architecture **never needs an inverse.** The original is never
   overwritten (C-9.3), so any frame is reached by composing operators **forward** from the execution-time
   frame; one never inverts to recover an original one already holds. Inversion is not a load-bearing
   property of the algebra — forward composition from preserved originals is. Stating this removes the
   temptation to overclaim invertibility entirely.

   **Fix (MD-13, replace the inverse sentence):** *"An inverse exists only where the transform preserves
   information. Because adjusted values are rounded to the minor unit (C-4.6), most operators are not
   injective and have no exact inverse; the manifesto claims none — and needs none. The original is never
   overwritten (C-9.3), so any frame is reached by composing operators forward from the execution-time frame,
   never by inverting. Where an operator is information-preserving — a clean-ratio split — running it backward
   recovers the original exactly, but the architecture rests on forward composition from preserved originals,
   not on inversion."*

**The commutation claim — correct, but justified by an asserted word.** The claim (frame-adjustment commutes
with as-of selection **given a fixed as-at cut**) is **true**, and the conditionalisation is **necessary**:

- *Necessity (counterexample).* Fix nothing and let the as-at cut move from C₁ to C₂. A corporate action with
  door time in (C₁, C₂] is unknown at C₁ and known at C₂, so the composite operator itself **differs** between
  the two cuts; "adjust then select" under one operator and "select then adjust" under another need not agree.
  Fixing the as-at cut is what makes the operator determinate. MD-13 **concedes this honestly** — *"a
  corporate action recorded late, or corrected… moves the frame only in a later as-at cut, never silently"* —
  and §3 **illustrates it** (moving the as-at cut from Tue 18:30 to today brings the split into force,
  carrying Tuesday's value from 150.20 to 75.25). So agenda item 2(c) — *is the frame map itself
  as-at-dependent, and does MD-13 say so?* — **yes, it says so.** Good. I would still add the counterexample
  in one clause, since necessity is currently only implied.
- *Sufficiency (why the two paths agree).* MD-13 leans on *"frame is a coordinate orthogonal to the two
  times."* That word is doing unearned work: the operator is **parameterised by** as-of (which actions apply
  depends on the observation's execution time), so it is not literally orthogonal to as-of. The precise reason
  it commutes is that **the operator changes a value's frame and leaves its as-of and as-at coordinates
  untouched** — so selecting by as-of before or after adjusting picks the same observations and returns the
  same adjusted values. **Fix:** replace "orthogonal to the two times" with "acts on the value's frame and
  leaves its as-of and as-at unchanged," and add "— which is why selection by as-of commutes with it."

---

## AGENDA ITEM 3 — Inverse honesty sweep — **DEFECT** (two illustrations overstate; principle is honest)

Every reversibility claim swept. The **governing principle is honest**: MD-13 claims an inverse *only where
one exists* and explicitly none where information is destroyed; MD-8/MD-10 are explicitly **forward**
(supersede, repair forward — no inverse claimed); MD-11 is replay, not inversion. The two defects are both
**illustrations that claim an inverse where information is in fact destroyed:**

1. **MD-13 split example** — presented as cleanly invertible, false under minor-unit rounding (C-4.6). Fixed
   by the item-2 rewrite above.
2. **§3, bullet 3 — a mathematical error.** *"A second split composes the operators; halving inverts the
   first."* The first operator on the price **is** the halving (150.20 → 75.10, ×½); its inverse is
   **doubling** (×2), not halving. A *second* halving does not invert the first — it composes to ×¼. As
   written the sentence is simply wrong, and it sits in the flagship worked example. **Fix:** drop the inverse
   illustration and state composition + forward-recovery instead, e.g. *"A later corporate action composes its
   operator with the split's, in execution order; because the original 150.20 is never overwritten, any frame
   is reached forward from it (MD-13, MD-10)."* If an inverse illustration is wanted, it must be a **1-for-2
   reverse split (doubling the price)**, and only "exactly, absent rounding."

---

## AGENDA ITEM 4 — Mandate 2/3 derivations — **RESOLVED-AS-DRAFTED** (two MINOR tightenings)

**MD-14 (dispute-readiness) — genuinely derived, not asserted.** The article *derives* the principle:
auditability exhibits the chain that produced the number (C-2.1), reproducibility recomputes it bit-for-bit
(C-2.2), therefore a dispute is settled by replay — *"asks nothing new of the record… dispute-readiness is
what those principles already are, once an adversary insists."* Crucially it **bounds its own reach**:
*"replay reaches exactly as far as reproduction, never wider"* — a model's own number needs the model
(C-14.15). This is the right derivation and it does not overreach what a record-governance document can
assert. Labelling it a *"seventh governing principle… derived not constitutional"* is legitimate: it is a
consequence of two commitments, not a claimed ninth commitment, and it is marked as such.
- **MINOR.** The opening *"any valuation or collateral dispute is settled by replay"* is briefly broader than
  the later bound (a dispute about *which model is right* is model choice, out of scope, and is **not** settled
  by replay). Tighten to *"any dispute about a recorded value is settled by replay,"* consistent with "to
  contest a mark is to contest a number" and the reproduction bound.

**MD-15 (model binding + price-space validation) — the split, the A5/A1 exclusion, and the identity all
hold.** Checked against all three risks:
- *Does it undo the projection/re-entered split?* No — *"Both are derived objects over recorded inputs and the
  declared model term (MD-6), so model-binding never undoes the split, and the repricing residual is a
  recorded diagnostic (MD-9)."* Binding never re-classifies a raw observation as a model output. ✓
- *Does it undo the A5/A1 exclusion (C-6)?* No — *"The binding is not a claim that the model is true… a
  dynamics such as the martingale, or a latent 'true price', is admissible only as a declared, recorded term,
  never an axiom."* Binding = **recorded lineage** (which model, which version), not a truth-claim. ✓
- *Is "calibration and validation are one act" oversold?* No — it is scoped to **in-sample** repricing
  (*"reprices the instruments it was drawn from"*), where calibration and validation share the same
  price-space residual r_i(θ)=π_i(θ)−v_i, one minimising it and the other reading it. Stated as *"one act seen
  from opposite directions"* — a definitional identity given the setup, not a claim that validation is free or
  that out-of-sample validity follows. Honest. ✓
- **MINOR.** Title *"Every datum is bound to a model"* overstates the body (*"a datum with no recorded model is
  merely a number"*; MD-6 correctly scopes it to *"any datum used in valuation"*). Retitle *"Every datum used
  in valuation is bound to a model,"* or *"A datum becomes a valuation fact when bound to a model."*

---

## AGENDA ITEM 5 — Changed/renumbered articles + worked example — **SOUND** (one DEFECT already counted)

**Citation audit (new/changed content): all correct.** MD-13 → C-9.1, C-9.2, C-9.3, C-2.3 ✓. MD-14 → C-2.1,
C-2.2, C-2.3, C-14.15 ✓. MD-15 → C-2.4, C-13.2, C-14.15, C-Scope.11 ✓. MD-5 correctly adds C-14.9 for the
"re-entered observation cannot re-fold itself" clause ✓. MD-6 adds C-3.2 for "projection = view computed from
the record" ✓. MD-8 correctly cites C-11.5 ✓. MD-10 cleanly separates change-of-frame (C-9.2/C-9.3, the
operator) from correction (C-12.4, a new naming observation) — the 1.0 conflation is repaired. No fabricated
or mis-numbered citation anywhere.

**Definition well-formedness.** "Frame" (unadjusted/adjusted coordinate system fixed by the corporate-action
terms in force) is well-defined. The three-coordinate meaning of a quote — (as-of, as-at, frame) — is
consistent: frame is genuinely independent of the two times (given an as-at cut that bounds which frames are
reachable, the target frame is still a free choice), so it is not double-counting as-at. MD-4's "one
coordinate more than these times" agrees.

**Worked example — consistent, arithmetic verified, one error.** 150.20/2 = 75.10 ✓; corrected 150.50/2 =
75.25 ✓ (the agenda's "→ 75.25" checks out). The two-answers bullet correctly holds as-of Tuesday fixed while
moving as-at (Tue 18:30 → today) to bring in **both** the correction (150.20→150.50) and the split frame
(→75.25) — a clean demonstration of MD-4 + MD-10 + MD-13, and incidentally the commutation-necessity
counterexample. All five bullets trace to the articles they cite. The **one error** is bullet 3's *"halving
inverts the first"* (Item 3, defect 2) — fix as above.

---

## DEFECT REGISTER

| # | Sev | Locus | Property | Fix |
|---|-----|-------|----------|-----|
| E1 | HIGH | MD-13 (inverse) | Invertibility overstated; false under minor-unit rounding (C-4.6); honest "never needs an inverse, composes forward from preserved originals (C-9.3)" missing | Replace inverse sentence (text supplied, Item 2) |
| E2 | HIGH | §3 bullet 3 | Mathematical error: "halving inverts the first" — the halving *is* the operator; its inverse is doubling | Replace with forward-composition wording (text supplied, Item 3) |
| E3 | MED | MD-13 (commutation) | Sufficiency justified by an unearned "orthogonal"; the operator is parameterised by as-of | "acts on frame, leaves as-of/as-at unchanged — which is why selection commutes"; add one-clause necessity counterexample |
| E4 | MED | MD-13 (identity/assoc.) | Associativity asserted (it is function composition); identity example (C-9.2 "proportional stands") illustrates a different identity than the sentence claims | Note associativity = function composition; split the two identities |
| E5 | LOW | §1 | "coordinate system the Constitution does not name" contradicts C-9.2 "post-event frame"; "across events" should be "across corporate actions" | Reword both |
| E6 | LOW | MD-14 / MD-15 | MD-14 opening broader than its own reach bound; MD-15 title broader than body | Tighten opening to "dispute about a recorded value"; retitle MD-15 to "datum used in valuation" |
| E7 | LOW | MD-13 | "a split by ratio r scales by r" — direction wrong for a price (scales by 1/r) | Define r as the price factor or correct the direction |

**7 findings: 2 HIGH (both in the MD-13 inverse / its worked-example line), 2 MED, 3 LOW. Zero parks — correct,
and confirmed: MD-13/14/15 each specialise or derive from existing clauses (C-9.1-9.3, C-2.1/2.2, C-2.4/C-13.2);
none amends the Constitution, none narrows a guarantee. No modeling claim is asserted as record fact (MD-15
explicitly refuses truth-claims; MD-13's operator is a projection over recorded terms).**

---

## VERDICT — **RETURN** (surgical; no re-architecture)

The three mandates are well embedded, the naming resolution is right, dispute-readiness is genuinely derived,
price-space validation preserves every prior guarantee, and all 1.0 defects are fixed. But an operator
**algebra** is exactly where rigor must be exact, and MD-13's inverse treatment overstates invertibility in
the Ledger's own integer regime while omitting the honest reason none is needed (E1) — and that overstatement
has already produced a **mathematically wrong line in the flagship worked example** (E2). Both are one-clause
fixes with text supplied. Apply E1-E4 (and the LOW notes), and I will sign. I do **not** sign as drafted; I
sign the revision that carries E1-E4.
