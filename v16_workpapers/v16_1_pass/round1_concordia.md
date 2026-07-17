# Round 1 — CONCORDIA (constitutional-adherence certifier)

Pass: v16.1, Round 1 of 5 (review only; CONCORDIA signs last at round 5).
Target: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex`.
Authority: `LedgerManifesto/ledger_manifesto_v1_4.tex` — amended C-2.7 (166-212), C-12.4/12.5/12.6 (845-874), ratified package incl. TA-EXECUTION-TIME (1109-1133).
Context: decision_log.md DL-01 (R-conform, 3-0), DL-02 (AGNOSTIC, 3-0).
Note: kleppmann named a standing reviewer by the brief but not an available agent type here; recorded, not silently substituted (per DL-01 note).

---

## C1 — C-12.6 exactness — VERDICT: CLEAN

Every element of C-12.6 is carried, in specifying prose, without drop, rename, or weakening. Primary site is the reordering step, `sec:totalorder` (lines 1212-1226):

| C-12.6 element | Spec site | Text |
|---|---|---|
| Insertion flagged | 1213 | event `e` carries a *reordered* mark "naming its execution time and insertion position" |
| Every changed state flagged | 1214-1215 | every state whose recomputed value differs from its as-known-at value carries a *restated* mark naming `e`; a state left identical carries none |
| Named PnL explain item | 1218-1219 | "published as a named profit-and-loss explain line" |
| Attributed to the reordering | 1219 | "to the reordering" |
| Attributed to the causing event | 1219-1220 | "to the causing event `e`" |
| Attributed to the lateness segment | 1220-1221 | "to the segment of its lateness" |
| World's segment = execution→monitor | 1221 | "the world's, execution to monitor" |
| Ours = monitor→door | 1221 | "and ours, monitor to door" |
| Settled money via C-12.4 only | 1222-1225 | "the delta stands as a visible open item and moves only as an authorised compensating transaction under C-12.4" |

"Every state whose recomputed value differs" (1214) is faithful to C-12.6's "every state the refold changes" — the added clause "a state the refold leaves identical carries none" clarifies, it does not narrow. Reinforced consistently at the figure (1315-1321), the covered-call trace (1330-1337), the change-log summary (6932-6935), and the executable property `prop_reorderFlagged` (6113-6114: `isReordered && restatedExactlyChangedStates && explainItemNamed`). No element is defended in prose alone. CLEAN.

---

## C2 — absorption vs TA-EXECUTION-TIME — VERDICT: FINDING (not PARK)

**The two clauses are reconcilable as worded; no amendment is needed — so this is a FINDING, not a PARK.** The reconciliation the spec's own primitives support: a genuine execution-time contest is a *correction event* under C-12.4 — a distinct recorded event that **names** the wrong one (`Correction { wrongEventId, reason }`, 5407-5423), carrying its own cause-derived identifier (`txid = H(causeEventId, contract, unit, seq)`, 1067-1087). Its cid therefore differs from the original, so it is **never** caught by absorption; TA-EXECUTION-TIME routes a wrong time through exactly this path — "corrected by a later event that names it (C-12.4), which re-inserts the event at its true execution position and refolds the tail, never a door edit" (6716-6727). A same-cid re-arrival is, by construction, a duplicate. Nothing legitimate is lost.

**The defect: that reconciliation is never stated in specifying prose.** The one place the spec addresses a same-cid arrival bearing a *different* execution time is a property-test comment and property inside an `lstlisting` (6111-6115):

```
-- C-12.6: ... a duplicate cid (same OR differing execTime) changes nothing.
prop_duplicateAbsorbed dup h = sameCid dup h ==> foldLedger (admit dup h) === foldLedger h
```

Per CLAUDE.md §5 code "illustrates; the prose specifies." The prose absorption sites — 1166-1168, 1198-1199, and the change-log restatement 6931 ("a duplicate under the cause-derived identifier is absorbed, never ordered") — are all silent on the differing-execution-time case. So the specifying text nowhere says that absorbing a same-cid/different-time arrival drops a duplicate and not a contest, nor that the contest path is the distinct-cid correction event. Per this lens, that silence on the exact seam loses the contest.

**Remedy (surgical prose addition, at `sec:totalorder` after line 1168):**

> Absorption is by identifier alone, whatever execution time the arrival asserts: the cause-derived identifier fixes the event, and its first admitted execution time is the recorded fact. A source that later asserts a different execution time does not correct by re-arrival — a genuine execution-time contest is a distinct correction event that names the wrong one (C-12.4, TA-EXECUTION-TIME), carrying its own cause-derived identifier, so it is never absorbed but re-inserted at its true execution position and refolds the tail. Absorption therefore drops a duplicate, never a contest.

(A one-clause echo may also be added to the TA-EXECUTION-TIME residual at 6725-6727.) No constitutional text changes; no PARK.

---

## C3 — W6 terminology sweep — VERDICT: CLEAN

Whole-file sweep for `valid time / valid-time / as-known-at / knowledge time / transaction time / transaction-time`, including identifiers, labels, listings:

- **`valid time`, `transaction time`** (the actually renamed bitemporal-DB terms): appear only at 6944-6945 — the change-log rename sentence, the explicitly allowed location ("*valid time* becomes *execution time*, the former single transaction time splits into *monitor time* and *door time*"). No residual anywhere else. No identifier forms (`validTime`, `txnTime`, etc.) exist.
- **`knowledge time`**: absent. The spec uses `knowledge horizon` / `KnowledgeHorizon` (368, 376, 378, 405) — a distinct, legitimate spec term for the execution-time axis of what is in force, not a renamed term.
- **`as-known-at`**: 17 uses, all the spec's single, internally consistent name for the "what the book said" bitemporal view (paired with `as-of`). It is **not** a W6-renamed term (the rename sentence does not touch it) and it aligns with amended C-2.7's "the as-known view" (manifesto 209). It is not a residual; not a finding.

Sub-threshold note (not a finding): spec "as-known-at" vs constitution "as-known view" is a spelling difference, not an internal synonym (the spec never mixes the two) and not a named-component violation under §1. Flagged only in case the supervisor intended strict "as-known" matching.

---

## C4 — DL-01 rethread, no quiet narrowing — VERDICT: CLEAN

Both required statements are made plainly, and neither direction is narrowed:

- **Order total over admitted events** (1157-1164): "The **total order** on admitted events is lexicographic on the triple (execution time, door time, event hash) … deterministic, total, and computable by any party from the record alone" — reproduces C-2.7's total-order sentence verbatim in substance, with duplicates excluded before ordering (1166-1168).
- **Door may refuse an ambiguous simultaneous non-commuting pair** (1116-1125): "the Executor refuses admission rather than guess … This refusal is constitutional, not a design preference: C-2.7 forbids reordering anything unless harmlessness is proved … the door-time tiebreak orders only pairs harmless to reorder or grounded in a declared precedence. The refusal is visible."

This is exactly the R-conform reading of DL-01: totality is a property of the **admitted** stream, refusal happens **before** admission, and the tiebreak orders only commuting or precedence-grounded pairs. The mitigation table reinforces it ("Fold in door order … contradicts C-2.7", 1272). The change log honestly carries DL-01 as "Under decision" with park-ready text should the Panel rule otherwise (6948-6953). No narrowing in either direction; no park.

---

## Also-checked

- **Version citations — CLEAN.** Every citation meaning the version in force says v1.4 (87, 227, 6881, 6924). Historical citations correctly name the version of adoption/closure (v1.1/v1.2/v1.3 at 401, 788, 2002, 2219-2221, 2521, 2875, 4864, 5089, 5160, 6166, 6581, 6891-6916) and the change log explicitly flags "(v1.3)" clause tags as historical (6946). No stale in-force reference.
- **Ratification-date honesty note — PRESENT, not papered over.** 6924-6925: "rated against Constitution v1.4, declared in force by the owner on 2026-07-16; the document's own ratification date awaits the owner and is not asserted here." Mirrors the manifesto's own "(ratification pending — owner's date)" (1109) and correctly scopes the pending date to the spec itself.
- Minor observation (not a finding): the spec asserts v1.4 "declared in force … on 2026-07-16" while the manifesto header still reads "ratification pending — owner's date" (1109). Defensible (owner's in-force declaration vs. an un-date-stamped manifesto header); noted for the certifier chain.

---

## Summary

| Lens | Verdict |
|---|---|
| C1 — C-12.6 exactness | CLEAN |
| C2 — absorption vs TA-EXECUTION-TIME | **FINDING** (reconciliation stated only in a §5 code comment, not prose; remedy supplied) |
| C3 — W6 terminology sweep | CLEAN |
| C4 — DL-01 no narrowing | CLEAN |
| Version citations / ratification honesty | CLEAN |

**Findings: 1 (C2). Parks declared: 0.**
