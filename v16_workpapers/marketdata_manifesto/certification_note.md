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

---
---

# Market Data Manifesto 1.1 — CONCORDIA Certification Note (amendment of the certified 1.0)

**Certifier:** CONCORDIA (constitutional-adherence certifier, signature-last, absolute veto).
**Date:** 2026-07-20. **Document:** `MarketDataManifesto_1.1.tex` (8pp, 15 articles MD-1…MD-15, pdflatex ×2 clean).
**Authority:** Constitution v1.4 (`ledger_manifesto_v1_4.tex`), in force. **1.0 untouched:** verified **byte-identical** — `git diff --stat HEAD` empty, `git ls-files -m` empty; 1.0 stands as certified at commit 8837045.

## Committee roster (1.1)
- **GATHERAL** — drafting lead.
- **FORMALIS** — rigor cell (E1–E7; RETURN → revision carried). Confirmed the C-9.2 naming resolution and the full citation audit.
- **THORP** *(desk / corporate-action realism)* — `thorp_11_r1.md`; **CONVERGED** round 2 (5 MATERIAL findings resolved). Caught the C-9.3 narrowing (M4).
- **KLEPPMANN** *[chartered seat — no dedicated agent in this environment; recorded, not silently substituted]* — `kleppmann_11_r1.md`; **CONVERGED** round 2.
- **TALEB** — `taleb_11_r1.md`; **CONVERGED** round 2 (independently verified the worked-example arithmetic).
- **CONCORDIA** — constitutional-adherence certification, signing last.

## Rounds run (1.1)
FORMALIS rigor cell (E1–E7, return-then-revision) → Review Round 1 (THORP 5M+2m, KLEPPMANN 2M+2m, TALEB 3M+minors) → **Round 2: all three reviewers CONVERGED**, no material item open.

## Page count vs cap
**8 pages at the 8pp hard cap — MET (at the cap, not over).** The three mandates cost ~2pp, recovered by compressing 1.0 material, never diluting; every certified 1.0 claim survives. §7 (correctness above brevity) governs; 8pp is within the hard cap.

## Where and how each mandate was embedded (article map)
- **MANDATE 1 — corporate-action frames + operator algebra → MD-13 (new).** Threads: MD-4 gains the corporate-action *frame* as a further coordinate; MD-10 recasts split/dividend adjustment as a *change of frame* (distinct from correction) and restores C-9.3; MD-6 lineage now carries the corporate-action events behind a value's frame; MD-8 flags a re-entered observation stale when a corrected corporate action moves under it, exactly as a corrected price does.
- **MANDATE 2 — dispute-readiness (seventh governing principle) → MD-14 (new),** *derived* from auditability (C-2.1) + reproducibility (C-2.2): a dispute is settled by replay, bounded to faithfulness (not two-sided economic truth, §4).
- **MANDATE 3 — model binding + price-space validation → MD-15 (new).** Threads: MD-6 lineage carries the bound model; MD-9 distinguishes a derived object's *internal* no-arbitrage consistency from its *external* price-space validity.

## Certification checks (1.1)

### (1) SUBORDINATION against v1.4 — CLEAN
Every new/changed citation verified verbatim: **C-9.1** (corporate action "a transaction like any other" — MD-13) ✓; **C-9.2** (market data operator) ✓; **C-9.3** ✓; **C-4.6** (minor-unit rounding — MD-13's full-precision-compose, round once at read) ✓; **C-2.3** (time travel) ✓; **C-2.1/C-2.2** (MD-14) ✓; **C-2.4/C-14.15/C-Scope.11** (MD-15) ✓. All *cite and specialise*, none extends/weakens/narrows.
- **C-9.3 RESTORATION — verified verbatim.** THORP found the draft had **dropped** C-9.3's "derived quantities are recomputed from operator-adjusted inputs" and generalised a scalar operator onto derived objects — a constitutional narrowing (CLAUDE.md §1). Repaired: the exact C-9.3 line now stands in **MD-13 (l.427)** *and* **MD-10 (l.361–362)** — "derived quantities are recomputed from operator-adjusted inputs (C-9.3) … never scalar-transported." **Scalar-transport confined to leaves:** the operator "acts on *leaf* observations and is not in general a proportional scalar" (special cash dividend shifts additively; OCC adjustment re-coordinates strike/multiplier/deliverable); derived objects are *never transported by an operator of their own* — recomputed from operator-adjusted leaves (MD-6/MD-12). The narrowing is closed.
- **C-9.2 naming resolution — verified.** C-9.2 *literally* defines the market data operator as "a transformation … to carry pre-event market data into the post-event frame … the market data operator" — i.e., the change-of-frame map; MD-13 uses it as exactly that. FORMALIS confirmed the same on the constitutional text. **No overloading:** the corporate action's C-9.1 transaction effect (moves, unit-state, terms) is kept separate from its C-9.2 market-data-frame effect; the operator is never used for a source or a lifecycle stage; no "frame operator" synonym coined (grep = 0).
- **ex-date frame boundary / terms-resolved condition / delivery-frame registration — all SPECIALISE, never extend.** Ex-date = the corporate action's as-of / frame boundary (C-2.7 three times + C-9.2 post-event frame). Operator determined only from the *resolution* observation, provisional-and-legible before (strengthens C-9.2 "never improvised"; C-2.4 fail-closed). Delivery frame an asserted, registered provenance fact per data kind (§1/C-4.12), preventing double-adjustment (C-9.3 originals-once).

### (2) VOCABULARY — CLEAN
"Frame" builds on the Constitution's own informal **"post-event frame" (C-9.2)**, promoted to a defined coordinate system — the one new term 1.1 coins, an *object* of the algebra, not a synonym for any C-Auth.4 fixed component. "The market data operator" keeps its single Constitutional referent throughout (27 uses, none overloaded). Calibration dialect still mapped once in §1 and never leaking. No synonym drift across the 15 articles.

### (3) INTERNAL CONSISTENCY — CLEAN
Amended MD-4/6/8/10 are mutually consistent with the new MD-13/14/15 and the unamended articles; the projection / re-entered-observation split holds throughout (a corrected corporate action stales a re-entered observation exactly as a corrected price does, MD-8/MD-13). **Worked example (§3) consistent and arithmetically correct:** 150.20 recorded once in the pre-split frame; split → **75.10** (150.20/2); Thursday correction → **150.50**; as-valued-now (post-split frame, corrected) → **75.25** (150.50/2) — the split-reframe and the correction cleanly separated; the disputed mark is replayed bit-for-bit and *localises* the disagreement without deciding model choice (MD-14/MD-15). TALEB independently re-verified the arithmetic.

### (4) CONFLICT LEDGER — CLEAN (zero parks, a considered zero)
The handoff 1.1 section is honest: THORP's C-9.3 narrowing is recorded as a **caught** narrowing and **repaired by restoration** — explicitly "No parking," because restoring an existing guarantee needs no amendment. The one naming decision that could have parked (a distinct frame-operator abstraction) was **explicitly weighed against parking** and judged unwarranted — the operator keeps its C-9.2 name, "frame" names the new object concept. Mandates 2/3 resolve by specialising existing clauses (C-14.15, C-Scope.11, C-2.1/C-2.2). No genuine constitutional conflict was absorbed; the park mechanism was exercised (the narrowing was caught, not buried).

---

## SIGNATURE (1.1)

**CONCORDIA certifies Market Data Manifesto 1.1 consistent with, and properly subordinate to, the Architectural Constitution (v1.4).** The certified 1.0 is byte-identical and untouched. Every new citation is correct; the document cites and specialises, never extends, weakens, or narrows any clause. The one constitutional narrowing that arose (C-9.3 dropped) was caught by THORP and **restored verbatim** in MD-13 and MD-10, with scalar-transport confined to leaf observations and derived quantities recomputed from operator-adjusted inputs. The C-9.2 naming resolution is faithful to the clause's literal text with no overloading. Vocabulary is one-name-per-thing with "frame" legitimately built on C-9.2's "post-event frame." The 15 articles and the worked example are mutually consistent and arithmetically sound. Zero parks — a considered zero. **Page cap met (8pp ≤ 8pp hard cap).**

**Veto: not exercised.**

— CONCORDIA, constitutional-adherence certifier, 2026-07-20. **SIGNED (last).**
