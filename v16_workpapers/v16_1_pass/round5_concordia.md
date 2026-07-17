# Round 5 — CONCORDIA constitutional-adherence certification signature (v16.1 pass)

Certifier: **CONCORDIA** (constitutional-adherence certifier, standing reviewer, signature-last).
Date: **2026-07-17**. Draft: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex` (7042 lines / 113pp, pdflatex ×2 clean).
Authority: `LedgerManifesto/ledger_manifesto_v1_4.tex` (Constitution v1.4, in force 2026-07-16). Decisions: `decision_log.md` DL-01/02/03.
Prior signatures this round: FORMALIS **SIGNED** (conditional on named assumptions; one non-blocking H-FWD-label transparency note; no veto); correctness-architect **ATTESTED** (no deviation); STYLUS **CONFORMS**.

---

## Verification of the five certification duties (checked against the printed final text, not taken on trust)

**(1) 116-clause two-way GREEN gate — PASSES on the final text.**
- Constitution `\clabel` set = exactly **116** (101 numeric + 4 Auth + 11 Scope), contiguous per chapter (re-confirmed).
- Traceability table (18 rows) unchanged: primary assignments sum to **116**, each clause **exactly once**; all **17** chapters appear (chapter-to-clause total). All **17** stubs present (107…6900), each mirroring its table row; the C-4.12 stub mirrors persist (ch:machines **911**, ch:testability **5434**, ch:requirements **6641**).
- **New ch:objects acyclicity condition (840-844)** — "the declared *arms a further watch* relation … required acyclic; a product whose declared arming graph contains a cycle is refused at registration, a decidable static check … discharges hypothesis H-WF of the firing closure (ch:machines)." Clause anchor: a **product-graph well-formedness / registration constraint = C-4.x**, home ch:objects (row `C-4.1--4.11 → ch:objects`), supporting the C-2.7/C-12.6 firing closure discharged in ch:machines. It falls inside ch:objects's existing clause range — **no new row, no stub change; the ch:objects stub (526) is unchanged and correct.** No row/stub broke. **Gate GREEN.**

**(2) W6 terminology residual = 0.** "valid time"/"transaction time" appear only in the licensed change-log rename sentence (**7025-7026**); "knowledge time" appears nowhere; "as-known-at" is the retained, consistent term for the bitemporal view (aligned to C-2.7's "as-known view"), not a renamed residual. New vocabulary is one-name, no synonym drift: *arms a further watch* (840, 1335, 1345), *arming graph* (842), *arming cascade* (843), *acyclicity condition* (1344), *product-graph well-formedness* (840) — each a distinct concept consistently named. Matches STYLUS's CONFORMS.

**(3) Constitutional citations correct.** Every in-force citation says **v1.4** (88, 228, 6861, 6962, 7005); the honesty note stands (7005-7006: "rated against Constitution v1.4, declared in force by the owner on 2026-07-16; the document's own ratification date awaits the owner and is not asserted here"). All v1.1/v1.2/v1.3 references are historical register entries — park closures, clause-adoption versions, and `% Discharges Constitution v1.3 §N` **LaTeX authoring comments** (2500, 5431, 6636, 6894) — with the change log flagging "(v1.3) clause tags are historical" (7027). New/edited-text citations (C-2.7, C-12.5, C-12.6, C-4.12, DL-01, TA-EXECUTION-TIME) all resolve to real v1.4 clauses. No stale in-force claim.

**(4) Certification record honesty (round5_record.md §3) — truthful, no steering.** Carries: "113pp against a 112pp hard cap — 1 physical page over"; the two-part statement "**Content: certified** … **Page cap: NOT met** — 113pp vs 112 … **DEFERRED-TO-OWNER**"; STYLUS's sentence **verbatim** ("112 is unreachable without cutting normative content" — matches round5_stylus.md exactly); and the owner's three options stated neutrally — "**accept 113**, **name a specific cut**, or **move the cap to 113**. No agent takes any of these." Honestly recorded as the owner's decision.

**(5) Full-document adherence sweep — no narrowing anywhere.**
- **C-2.7 / C-12.6 / TA-EXECUTION-TIME discharged as adopted.** C-2.7 (stub 911; table *also* ch:machines; sec:totalorder). C-12.6 (stub 911; table row 6883; step-(c)/flagging/workflow at 1253/1262/1352/1391/1440/1480; property 6196). TA-EXECUTION-TIME (definition 1013; theorem hypothesis 1355; requirements 6834; change log 7017). Each present and unnarrowed.
- **The NON-NEGOTIABLE design fact is INTACT.** Refold on late arrival is pervasive (117 refold/reorder/late-arrival mentions); "unbounded lateness gives an unbounded tail, intrinsic to honouring execution order and **never capped**" (1362-1363); tolerance windows and finality cutoffs are the **only** such mention and are marked **non-conforming** in the mitigation table — "Refuse late arrivals (tolerance window or finality cutoff) — no — drops a court-enforceable execution time; the book stays knowingly wrong — the covered-call failure" (1380). The reordering commitment is nowhere weakened; it is actively defended.
- **Parks: 0 — a considered zero.** The two park-candidates of this pass (Fix-A as a model commitment, R1; the ⊤/door-key vs C-2.7, R3) were each examined explicitly and found constitutionally licensed; DL-01 settled R-conform without park; the park-index *history* is non-empty (six closed). The mechanism was exercised, not idle.

**FORMALIS's non-blocking H-FWD-label note** is a formal-correctness labelling refinement in FORMALIS's domain; it does not bear on constitutional adherence and does not gate this signature. Recorded, not papered over.

My five prior-round findings (R1 C2 absorption-vs-contest seam; R2 C2 synthesized-firing kind/routing; R2 C3 firing-identifier injectivity; R3 C-4.12 stub mirrors) are all confirmed **landed** in the final text; R4 and R5 returned clean.

---

## SIGNATURE

**CONCORDIA certifies the constitutional adherence of the v16.1 specification against Constitution v1.4.**

- **Scope:** whole-document adherence to the Constitution — the 116-clause two-way traceability gate, W6 terminology, constitutional citations, the C-2.7 / C-12.6 / TA-EXECUTION-TIME adoption, the non-negotiable reordering commitment (refold on late arrival; no tolerance windows; no finality cutoffs; lateness never capped), and no narrowing of any constitutional guarantee anywhere in the text.
- **Gate result:** the traceability table is a **complete, two-way, GREEN partition of all 116 clauses**; no clause orphaned; all 17 chapters discharge; every stub mirrors its row.
- **Page exception:** the file is **113pp against a 112pp cap — 1 page over. This is not a constitutional-adherence defect; it is the owner's cap decision (DEFERRED-TO-OWNER),** recorded truthfully with STYLUS's sentence on record and the owner's three options stated without steering. No agent may cut a witness, a normative sentence, or a proof step to fit (§7: correctness outranks the cap).
- **Veto:** **not exercised.**

**Content-certified for v16.1**, with the page cap recorded as **NOT met (113 vs 112), the owner's to resolve.**

— CONCORDIA, constitutional-adherence certifier, 2026-07-17. **SIGNED (last).**
