# Round 5 — FORMALIS certification signature (v16.1 pass)

Certifier: **FORMALIS** (Leroy chair; Coquand, Huet, Paulin-Mohring, de Moura, Avigad).
Date: **2026-07-17**. Draft: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex` (113pp, pdflatex ×2 clean).
Certification scope: **formal correctness of the global total order, the refold, and the firing closure** — sec:totalorder, `thm:refold`, `lem:closure`, the ch15 refold/firing property regime, and the P1–P5 obligations of `memo_w2_proofs.md`. Other labelled results (ch06 conservation, ch14 time-travel/replay, prop:independent-commute) are relied on where cited and were certified in their own passes.

---

## Verification of the Round-4 applications (checked against the printed text, not taken on trust)

- **Item 2 — F1+F2 lemma rewrite (1320–1331): landed verbatim.** Commutation test is disjoint reads **and** disjoint non-additive writes (balance-moves excepted as additive); a write-conflicting no-reads-dependency pair is **non-commuting → declared precedence or refused (C-2.7, DL-01), never the hash**; the forward pass **computes** the record-fixed order and **does not define** it; party-invariance grounded in "a function of the record," not the P2 miscitation I struck in R4. STYLUS removed only my one duplicated tail clause — no content change. **Consistent with prop:independent-commute (5001), which independently requires disjoint read- and write-sets** — the lemma's rule is that law specialised to synthesised emissions, not a new claim.
- **Item 3 — serialization rewrite (1460–1469): correct.** The premise is now **fold state** is a function of the arrival set (thm:refold), not the false "total order is arrival-independent"; **termination rests on H-FIN/H-WF**, distinguished from the overdue-watch sweep, which "backstops a *lost* refold, not a non-terminating one"; and **two conflicting execution-time corrections of one instant** are named as the same-instant non-commuting residual (my RT-A finding), routed to DL-01, never a door tiebreak.
- **H-WF discharge is now REAL (the Round-4 veto-grade thread, closed).** ch:objects (838–844) states a **decidable static acyclicity check on the declared "arms a further watch" relation, refusing a cyclic product at registration**; `prop_armingWellFounded` (6234–6237) asserts `registers g === (cyclic ? Refused : Admitted)` with `cover 1.0 (cyclic …)` **forcing the cyclic branch** — a genuine firing witness, no zero-firing gap. The lemma label (1343–1348) is honest: H-FIN-at-most-once / H-FWD / H-INERT / **H-WF property-tested**; **only H-FIN's finiteness clause structural** ("a violated finiteness hangs the closure, it does not fail a test"). H-INERT now carries its own witness `prop_supersededFiringInert` (6226–6230, `cover 1.0`, covered-call generator), the property I asked for in R3.

## Discharge of the certification obligations

1. **P1–P5 stand as printed.** P1 strict total order under ASSUMPTION-CR over the single-lineage post-absorption carrier (1165–1171); P2 replay determinism under H1–H4; P3 = `thm:refold` strong form; P4 idempotence extended over the closure (1274–1279); P5 the two non-theorems labelled (TA-EXECUTION-TIME trust assumption; door-time monotonicity implementation obligation).
2. **`lem:closure` sound.** Existence/uniqueness by **well-founded stratification** on execution time — the operator is correctly stated **non-monotone** (Knaster–Tarski rejected), the ⊤/derivation-order/write-conflict tiebreak well-defined; termination under H-FIN+H-WF; confluence by P2. Four hypotheses named, not axioms, honestly split property-tested vs structural.
3. **`thm:refold` strong form proved, non-claims exact.** Fold state of the refold equals the timely fold of the same external arrivals with firings re-derived, via lem:closure's unique fixpoint + P2; the R1 world-counterfactual equivocation is gone. Non-claims exact (1351–1353): settled money, external effects, fired notifications are **not** rewound — C-12.6 residue. Hypothesis: per-event purity + execution-time stability.
4. **Firing floors real.** Every refold/firing property carries a non-vacuous `cover 1.0`: `hasExecTie`, `insertsBeforeHead`+synthesis, `refoldChangesState`, cross-unit, `newlySatisfies`, superseded-no-op, cyclic-arming. No precondition witnesses nothing.
5. **Nothing labelled Theorem/Lemma/Proposition stands unproven in scope; no "clearly/obviously/it follows that."** (The lone "trivially" at 4648 is a correct vacuous-case statement — no moves ⇒ conservation holds — outside scope.)

## One non-blocking transparency note (not a veto)

The label calls **H-FWD "property-tested"** (1343). Its **data-emission** case is genuinely firing-tested (`prop_firingSynthesized_fires` asserts `execTime = tippingObs`); its **scheduled-emission** case ("dated at or after inception") rests on **structural** product-graph well-formedness (ch:objects 838–840), like H-FIN-finiteness. The claim is not false — the operative refold case is tested and H-FWD as a whole is discharged — but a future pass may tighten the label to mirror the honest H-FIN split (data-case tested; scheduled-case structural). This does not affect soundness and does not gate certification.

---

## SIGNATURE

**FORMALIS certifies the formal correctness of the v16.1 total-order / refold / firing-closure work.** `thm:refold` and `lem:closure` are proved; P1–P5 stand; the four closure hypotheses are honestly labelled; the firing floors are real; no labelled result stands unproven.

**Assumptions named (the certification is conditional on exactly these, all labelled in-text as such):**
- **ASSUMPTION-CR / H-CR** — collision-resistance of the event hash on the finite domain of well-formed events (P1 totality; the ⊤–⊤ hash tiebreak).
- **TA-EXECUTION-TIME** — trust assumption: asserted execution times are enforceable, corrected only by a later event, never edited at the door.
- **H1–H4 (C-2.8)** — contract purity, apply determinism, clock confinement, recorded seed (P2, thm:refold).
- **lem:closure hypotheses** — H-FIN (at-most-once property-tested; finiteness structural, hang-not-fail), H-WF (property-tested via the registration acyclicity check), H-FWD (data-case property-tested; scheduled-case structural), H-INERT (property-tested).
- **(DM) door-time monotonicity** — implementation obligation, property-tested (`prop_doorTimeMonotonic`); **not** load-bearing for totality (proved from CR).
- **Single authoritative lineage** carrier for the total order (inv:lineage).

**Scope note:** this signature certifies formal correctness only. The 113-vs-112 page cap is not a correctness question and is outside this signature — recorded as DEFERRED-TO-OWNER. Constitutional adherence is CONCORDIA's signature-last.

— FORMALIS, Xavier Leroy (Chair), 2026-07-17. **SIGNED.**
