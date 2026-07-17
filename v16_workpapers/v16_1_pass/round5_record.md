# v16.1 Review — Round 5 Record (CERTIFICATION ROUND)

**Supervisor:** TuringAward. **Date:** 2026-07-17. **Draft:** `ledger_v16_1.tex`, **113pp
(p113 = 39 lines), pdflatex ×2 clean.** **Standing reviewers:** FORMALIS, CONCORDIA,
correctness-architect, STYLUS. **Named but unavailable across all five rounds:** kleppmann
(recorded every round, never silently substituted — SF-4).

This is the certification round: **verification of applications + signatures only, no new
design.** The pen applied all Round-4 items and reports zero deviation. I verified that claim
independently before opening the round; the reviewers below verify their own domains and sign.

---

## 0. Final supervision verdict

**Independent verification of the Round-4 application (I did not take "zero deviation" on
trust).** I checked each ruled item against the printed text:

| Item | Ruled | Landed | Site |
|---|---|---|---|
| H-WF made a real discharge | ch:objects acyclicity condition + `prop_armingWellFounded` + lemma label | ✓ | 840–844; 6231–6236 (cyclic firing witness); label 1343–1348 |
| H-WF label honest | H-WF now property-tested; **only** H-FIN-finiteness structural | ✓ | 1343–1348 ("Only H-FIN's finiteness clause is structural … a violated finiteness hangs the closure, it does not fail a test") |
| F1+F2 lemma rewrite | commutation = disjoint reads AND disjoint non-additive writes; write-conflict → DL-01, never hash; pass *computes* not defines | ✓ verbatim | 1320–1331 |
| Serialization rewrite | fold **state** arrival-independent; termination (H-FIN/H-WF) vs liveness (sweep backstops a *lost* refold); conflicting corrections named | ✓ | 1460–1467 |
| RT-D clause | absorption ranges over the full retained log incl. voided firings | ✓ | 1182–1184 |
| refold/re-folding | one name; hyphenated "re-folding" gone | ✓ | 0 hyphenated remain; only the deliberate "re-fold, never a rewrite" pun (1231) |
| W6 residual | 0 outside change-log/history | ✓ | only the licensed rename sentence (7025) |
| ⊤ (from Round 3) | no stray ⊥ | ✓ | every `\bottomrule` is a table rule; lemma key `(exec, door or ⊤, hash)` (1310) |

**Verdict.** The content is, on my independent read, **certifiable**: the one veto-grade thread
of this pass — the firing-closure and its four hypotheses — now stands with a genuine
existence/uniqueness/termination argument, honest hypothesis labels (three property-tested, one
structural, and the previously-false H-WF "discharge" made real by a decidable registration
check), and the ⊤/derivation-order/write-conflict tiebreak that closes the DL-01 seam. Nothing
labelled Theorem or Lemma stands unproven; nothing property-tested overclaims; the one item that
cannot be firing-tested (H-FIN finiteness — a hang, not a failure) is labelled as structural,
not dressed up. **The single open item is not content — it is the page cap** (§3 below):
113 vs 112, which no agent may resolve by cutting normative content.

**This verdict is mine as supervisor; it is not a certification.** Certification is the two
certifiers' signatures. I do not sign — I supervise, and I record the page situation honestly
for the owner.

---

## 1. Verification + signature tasks (each reviewer: verify your domain, then sign or veto)

### correctness-architect — verify items 1/2/4, re-run RT-B/RT-D on the printed text
1. **Item 1 (H-WF real discharge), character-by-character:**
   - ch:objects 840–844: the acyclicity condition is stated as a **decidable static check at
     registration** that **refuses** a cyclic product, and it names H-WF.
   - ch15 6231–6236: `prop_armingWellFounded` generates multi-unit arming graphs, asserts
     registration refuses the cyclic branch and admits the acyclic, and **fires on the cyclic
     branch** (`cover 1.0 (cyclic …)` — §3 firing witness, not a vacuous green).
   - lemma label 1343–1348: H-WF is now property-tested via the acyclicity condition; **only**
     H-FIN-finiteness remains structural. Confirm the label matches what ch:objects/ch15
     actually carry (no residual false "discharged by product-graph well-formedness" for H-WF).
2. **Item 2 (F1+F2 rewrite) 1320–1331:** the commutation test is disjoint reads **and** disjoint
   non-additive writes; a write-conflicting no-reads-dependency pair is non-commuting → declared
   precedence or refusal, **never the hash**; the pass **computes** the record-derived order.
   Re-run RT-B (cross-unit arming cycle now refused at registration) and the write-conflict
   argument on this exact text.
3. **Item 4 (RT-D) 1182–1184:** absorption ranges over the **full retained log including voided
   firings**; a duplicate of a voided firing absorbs rather than resurrects. Re-run RT-D on the
   printed clause.
4. Report any regression; then confirm the correctness surface is intact (no sign is required
   of you — you are advisory; FORMALIS and CONCORDIA carry the vetoes).

### FORMALIS — verify items 2/3, confirm H-WF discharge is real, discharge the proof obligations, then SIGN or veto
1. **Item 2 (F1+F2)** and **item 3 (serialization)** landed exactly as ruled (1320–1331;
   1460–1467). In the serialization paragraph confirm the corrected claim is **fold state**
   arrival-independent (not total order), and that termination (H-FIN/H-WF) is distinguished
   from the sweep's scheduling-liveness.
2. **H-WF discharge is now REAL:** the lemma's claim (1343–1346) matches what ch:objects (840–844)
   and ch15 (6231–6236) actually carry — a checked, decidable, property-tested acyclicity
   condition, not an asserted assumption. This is the item that would have held the veto in
   Round 4; confirm it is closed.
3. **Every W2/W3 proof obligation discharged or honestly labelled:** P1–P5 (memo_w2), `lem:closure`
   (existence/uniqueness/termination/confluence + the ⊤/derivation-order/write-conflict tiebreak),
   `thm:refold` (fold-state scope, non-claim on settled money/external effects), and the five
   hypotheses' labels (H-FIN at-most-once / H-FWD / H-INERT property-tested; H-WF property-tested
   via the registration check; H-FIN-finiteness structural, hang-not-fail). No labelled result
   stands unproven; no "property-tested" overclaims.
4. **SIGN** the formal-correctness certification, or **veto** with the exact unproven step.

### CONCORDIA — re-run the GREEN gate, sweep W6, verify citations, confirm the page record, then SIGN LAST or veto
1. **116-clause two-way GREEN gate over the FINAL text:** re-run after the Round-4/5 edits (the
   new ch:objects acyclicity condition, the serialization rewrite). Confirm ch:objects's clause
   range still covers the new condition (no new row needed), the C-4.12 stub mirrors persist,
   and the table remains a complete two-way partition of all 116 clauses.
2. **W6 terminology residual — final sweep:** must be **0** outside the change-log/history. I see
   only the licensed rename sentence at 7025; confirm no other "valid time"/"knowledge time" and
   no synonym drift (incl. the new "arms a further watch"/"acyclicity" vocabulary is one-name).
3. **Every constitutional citation** in the new/edited text resolves to a real v1.4 clause
   (C-2.7, C-12.5, C-12.6, C-4.12, DL-01, H-WF's home clause for the ch:objects condition).
4. **Certification record honesty:** confirm §3 below carries the page situation truthfully —
   content certified vs cap-not-met, DEFERRED-TO-OWNER, STYLUS's sentence on record.
5. **SIGN LAST** the constitutional-adherence certification, or **veto** with the exact clause.

### STYLUS — verify the minors landed and the final style
1. occasion comma (1239); refold/re-folding unified to one name (0 hyphenated "re-folding");
   the serialization dedup (negative restatement dropped, positive form carries it, 1463);
   the F1/F2 and serialization rewrites read as one result per sentence.
2. Confirm the certification sentence stands verbatim on the record (§3).
3. No new dedup is required; if any *clarity-safe, non-protected* line remains that would recover
   page, report it — but do not cut a witness, a normative sentence, or a proof step.

---

## 2. Pass statistics (rounds 1–5)

- **Rounds:** 5 (4 findings rounds + 1 certification round). Findings mode rounds 1–4; red-team
  mode engaged rounds 3–4 (nine scenarios total, four from the brief + five supervisor-invented).
- **Findings actioned:** 56 (R1 14, R2 15, R3 15, R4 12). **Rejected/superseded:** 7 (R1 2,
  R2 2, R3 0, R4 3). **Held then closed:** 1 (A2, held R3 → closed R4 6/6 KEEP-CUT, no RESTORE).
  Numerous additional CLEAN/SOUND/PASS verdicts (not defects) across all four reviewers.
- **Parks: 0** throughout — a *considered* zero, not an unexercised mechanism: the park index
  *history* is non-empty (six closed), and the two places a park could have arisen this pass
  (Fix-A as a model commitment, R1; the ⊤-door key vs C-2.7, R3) were each examined explicitly
  and found constitutionally licensed. Non-negotiable held: reordering was never weakened; every
  weakening proposal (Fix-B, tolerance windows, finality cutoffs) was rejected, never adopted.
- **Decisions:** DL-01 (door fail-closed refusal survives the tiebreak; R-conform, 3–0, settled;
  change-log de-jargoned); DL-02 (orchestration substrate product-agnostic; AGNOSTIC, 3–0;
  Temporal-noun leak fixed); DL-03 (17 per-chapter openers → one 116-clause traceability table;
  GREEN gate passed R3, re-verified R4, final re-run this round — the check itself surfaced and
  filled a real gap: C-12.6 had no opener anywhere).
- **Two supervisor self-corrections, both on the record (§4 anti-bias — the mechanism working,
  not noise buried):** (1) **⊥-before → ⊤** — I ruled ⊥ sorts before real door times (R2);
  FORMALIS + correctness-architect unanimously overturned it to ⊤ (R3), I recused myself as the
  author of the ⊥ call and ruled only on their finding. (2) **A2 priors disproven** — I flagged
  (b5) "one home per fact" and (b3) checkability as possibly lost cuts (R4); both were shown
  carried on the record ((b5) by `prin:one-home`, the manifest having mis-cited `inv:writer`;
  (b3) at 3034–3040). Suspicions tested and failed — the adversarial gate doing its job on the
  supervisor as on anyone.
- **kleppmann:** named a standing reviewer by the brief; **not an available agent type in this
  environment**; recorded as unavailable in every round (1–5), never silently substituted. His
  ch2/ch4 global-total-order lens was the ground the ⊤/within-instant/tiebreak work stressed;
  FORMALIS + correctness-architect jointly covered it; the residual is logged, not papered over.

---

## 3. PAGE VERDICT — for the certification record

The file is **113pp against a 112pp hard cap** — **1 physical page over.** Per the brief,
**over the cap is not certified** on the page criterion. The honest certification statement is
therefore two-part, and must be recorded as such:

> **Content: certified** (pending the FORMALIS and CONCORDIA signatures of this round).
> **Page cap: NOT met** — 113pp vs 112. The residual is **DEFERRED-TO-OWNER.**

The 1-over is the pen's honest floor: every remaining tail item is a witness, a normative
sentence, or a proof step, and Round-4's §3-irreducible additions (the H-WF registration check
+ `prop_armingWellFounded`) grew the overflow rather than shrank it — correctly, because §7
ranks correctness above the cap and no agent may cut protected content to fit. STYLUS's
certification stands verbatim on the record:

> **"112 is unreachable without cutting normative content."**

The cap is the **owner's** to resolve, and only the owner's — he has moved it twice before. The
owner's three options are recorded neutrally: **accept 113**, **name a specific cut**, or **move
the cap to 113**. No agent takes any of these; the supervisor records the choice as the owner's.

---

## 4. Certification status (supervisor's close)

- **Verification:** all Round-4 items independently confirmed landed with zero deviation (§0).
- **Awaiting:** FORMALIS signature (formal correctness) and CONCORDIA signature-last
  (constitutional adherence). Convergence among the four reviewers is necessary and **not
  sufficient** — the signatures decide.
- **If both sign:** the specification is **content-certified for v16.1**, with the page cap
  recorded as **NOT met (113 vs 112), DEFERRED-TO-OWNER**. The record is then complete and goes
  to the owner with the page decision the only open item.
- **If either vetoes:** the veto reopens the work with the exact unproven step or unmet clause;
  no escalation to the owner mid-run except the parked page item.

Supervisor does not sign. Supervisor records, and hands the two certifiers a verified draft and
a truthful page ledger.
