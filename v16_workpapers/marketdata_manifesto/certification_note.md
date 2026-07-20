# Market Data Manifesto 1.0 — CONCORDIA Certification Note

**Certifier:** CONCORDIA (constitutional-adherence certifier, signature-last, absolute veto).
**Date:** 2026-07-20. **Document:** `/home/renaud/Ledger/MarketData/MarketDataManifesto_1.0.tex` (7pp, 12 articles MD-1…MD-12, pdflatex ×2 clean).
**Authority:** `LedgerManifesto/ledger_manifesto_v1_4.tex` — the Architectural Constitution, v1.4, in force. The document is rated against the Constitution; the Constitution is rated against nothing.

---

## Committee roster
- **GATHERAL** — drafting lead.
- **FORMALIS** — in-cell rigor (D1–D6; RETURN → revision). Caught the sole relabel trap (D1).
- **KLEPPMANN** — review seat *[chartered seat — no dedicated agent in this environment; recorded, not silently substituted]*. Workpapers `kleppmann_r1.md`, `kleppmann_r2.md`; **CONVERGED** round 3.
- **TALEB** — review (comprehensibility / fragility). Workpapers `taleb_r1.md`, `taleb_r2.md`; **CONVERGED** round 3.
- **CONCORDIA** — constitutional-adherence certification, signing last.

## Rounds run
FORMALIS rigor cell (return-then-revision, D1–D6) → Review Round 1 (rev-2, KLEPPMANN M1/M2 + TALEB M1–M6) → Round 2 (rev-3, KLEPPMANN F1 + TALEB F1/F2) → **Round 3 convergence check (rev-3): both reviewers CONVERGED, no material item open.** Handoff `handoff_note.md` records 7 source-calibration conflicts, all resolved Ledger-first.

## Page count vs cap
**7 pages against the 6–7pp target / 8pp cap — MET, under cap.** No page exception.

---

## Certification checks

### (1) SUBORDINATION — CLEAN
Every one of the **26 distinct constitutional citations** was verified verbatim against v1.4 (C-1.4, C-1.5, C-2.1–2.8 commitments, C-3.2, C-4.4, C-4.8, C-4.11, C-4.12, C-5.1, C-5.4, C-5.8, C-7.2, C-9.2, C-9.3, C-10.1, C-11.5, C-12.1, C-12.3, C-12.4, C-12.6, C-13.2, C-13.3, C-14.3, C-14.9, C-14.11, C-14.15, C-Auth.4, C-Scope.11). Each **cites and specialises**; none extends, weakens, or narrows. The six-of-eight commitments map correctly (auditability C-2.1, reproducibility C-2.2, time travel C-2.3, correctness C-2.4, order C-2.7, simulability C-2.8). The three relabel-trap hotspots, swept explicitly:
- **Projection / re-entered-observation split vs C-14.9 ("the ledger never runs models"): CLEAN.** The document reserves *projection* for its fixed C-3.2 referent (record-computed, reproducible from the record alone, C-2.2/C-14.11) and routes model outputs to *re-entered observation* (C-14.9/C-14.15: read-back unconditional, re-derivation needs the retained model). C-14.9 is faithfully **applied**, never narrowed — a re-entered observation cannot auto-refold precisely *because* the ledger runs no model; it is flagged stale (MD-5/8/10). The one draft that broadened "projection" was caught by FORMALIS (D1) as "the §1 relabel trap in the reproducibility direction" and fixed; I confirmed the two-name split is **applied in the final text** across MD-6/7/8/9, §1 (line 119, not "a posterior is a projection"), Abstract (60–62), Conclusion, and the worked example.
- **Identifier-grain trust language vs the TA set: CLEAN (most-scrutinised point).** MD-1 **names** grain-correctness as "a trust assumption, named beside TA-ARRIVAL," honestly discloses the residual *silent* over-coarse-loss case, and catches it at the perimeter by arrival-count reconciliation. It **does not mint a constitutional TA** — no constitution clause is invented, no constitutional-TA status claimed; it places a domain working assumption alongside the spec-level TA-ARRIVAL. This is honest disclosure of a mechanism residual (the opposite of narrowing), consistent with the ledger spec's own cause-derived-identifier treatment. On the right side of the line.
- **Capture-everything vs TA-ARRIVAL's arrival bound: CLEAN.** MD-2 bounds the guarantee to run *from arrival* (C-4.12), names capacity as TA-ARRIVAL's concern, and forbids using capacity as a licence to drop silently; what never reaches the boundary is the perimeter's concern, "never a fact the record can claim." No over-claim of capture before arrival.

### (2) VOCABULARY — CLEAN
One name per component (C-Auth.4). **The market data operator** is used only for the C-9.2 corporate-action transform, explicitly *"never used for a source"* — the key discipline. The calibration dialect is mapped once in §1 and never leaks: *Oracle* appears only to be rejected (§1, MD-3 — no oracle primitive), *attestation*/*knowledge time* only in the §1 map, *MCA* excluded entirely, *posterior/prior* only where MD-7 places them as term/derived object. Fixed names (observation, projection, the one door, execution/monitor/door time) used correctly throughout.

### (3) INTERNAL CONSISTENCY — CLEAN
The 12 articles are mutually consistent; the projection/re-entered-observation split is honoured identically across MD-5, MD-6, MD-8, MD-9, MD-10, MD-12, with no article treating a model output as auto-refoldable. Absorption (MD-1) and correction (MD-10) compose correctly (duplicate absorbed by cause-derived identifier; correction is a distinct later observation naming the wrong one). The **worked example (§3)** is consistent with every article it touches (MD-1/3/4/5/6/8/10/11) and correctly distinguishes the two subtle cases — a *correction* (shares execution time, differs in door time, names the original) from a *late arrival* (execution time precedes folded data, projections refold, fitted surface flagged stale).

### (4) CONFLICT LEDGER — CLEAN (zero parks, a considered none)
The 7 source conflicts (C-1 posterior-as-state; C-2 gating-as-rejection; C-3 Oracle vocabulary; C-4 two-time vs three-time; C-5 no-arb as record property; C-6 martingale/latent-price model claims; C-7 calibration-as-projection vs C-14.9) are each resolved **Ledger-first by specialising an existing clause**, none by amending the Constitution. No genuine constitutional conflict was absorbed: C-6 correctly **refuses** to assert model/world claims; C-7's owner-mission framing ("calibration is a projection") is **corrected**, not relabelled, to fit C-14.9. The park mechanism was **exercised**: FORMALIS examined the two overreaches nearest the narrowing trap (D1 projection, D2 abstract) and ruled them mandatory fixes — not parks, since they require no amendment — with zero-parks standing **only after D1/D2 applied**, which they are. The empty parking index is therefore legitimate, not an unexercised mechanism.

---

## Parked items
**None — a considered none.** Every calibration/Ledger tension resolves within the Constitution by specialising an existing clause; a specialisation is not an amendment. The mechanism was available and exercised (the closest-to-narrowing overreaches were examined and closed as fixes, not parks). The Constitution's parking-index *history* remains non-empty from prior passes.

---

## SIGNATURE

**CONCORDIA certifies the Market Data Manifesto 1.0 consistent with, and properly subordinate to, the Architectural Constitution (v1.4).** Every constitutional citation is correct; the document cites and specialises, never extends, weakens, or narrows any clause; the one relabel trap that arose was caught and fixed; vocabulary is one-name-per-component with the calibration dialect mapped once and never leaking; the 12 articles and the worked example are mutually consistent; the 7 conflicts are each resolved Ledger-first with zero parks, a considered none. **Page cap met (7pp ≤ 8pp).**

**Veto: not exercised.**

— CONCORDIA, constitutional-adherence certifier, 2026-07-20. **SIGNED (last).**
