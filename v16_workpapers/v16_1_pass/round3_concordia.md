# Round 3 — CONCORDIA (constitutional-adherence certifier) — MANDATORY GATE (DL-03 binding condition)

Pass: v16.1, Round 3 of 5. Target: `ledger_v16_1.tex`. Table: `sec:traceability` (6805-6841, normative per 6807). Authority: `ledger_manifesto_v1_4.tex`; `decision_log.md`.

---

## TASK 1 — two-way 116-clause audit against the table — VERDICT: GATE **GREEN**, with one stub-consistency FINDING

**Constitution clause set (authoritative `\clabel` grep): exactly 116** = 101 numeric (C-1…C-14) + 4 C-Auth + 11 C-Scope. Per-chapter numbering is **contiguous 1..N, no gaps, no extras** (verified: C-1 1-5, C-2 1-8, C-3 1-11, C-4 1-12, C-5 1-8, C-6 1-6, C-7 1-5, C-8 1-9, C-9 1-3, C-10 1-5, C-11 1-5, C-12 1-6, C-13 1-3, C-14 1-15, Auth 1-4, Scope 1-11), so the table's range notation faithfully denotes the real clauses.

**Clause → chapter (partition, no gap / no double-count): GREEN.** Summing the 18 table rows' primary assignments = **116**, each clause appearing **exactly once** as a primary discharge. Every constitution chapter's clause count equals the table's range for it. No clause orphaned by opener removal — all 116 remain in the table.

**Chapter → clause (totality): GREEN.** All **17** chapters appear as a discharging chapter. Four appear only as secondary ("also") sites — ch:collateral, ch:reporting, ch:cdm, ch:settlement — which is expected (16 clause-groups, 17 chapters); each still discharges ≥1 clause jointly, so no dead chapter.

**Spot-verifications (all correct rows):**
- **C-12.6 → ch:machines (row 6834): CORRECT.** The build-surfaced fill; prose 6812-6814 records it as the opener-omitted clause now discharged in `sec:totalorder`; substantively present there (verified R1/R2). Fill is honest and accurate.
- **C-4.12 → ch:marketdata primary (row 6825): CORRECT** (the event-kind registry lives in ch:marketdata, 2595). "also ch:machines, ch:testability, ch:requirements" are all genuine — C-4.12 is cited in each body (1231 machines, 6505 testability, 6650/6772 requirements).
- **C-2.8 → ch:objective primary (row 6822, C-2.1-2.8 block): CORRECT.** C-2.8 (Simulability) is a foundational C-2.x commitment, uniformly homed in ch:objective like C-2.1-2.7; substantively exercised in ch:virtual (3887) and ch:marketdata (2606).
- **C-6.6 → ch:scope (row 6828): CORRECT.** Managed-account clause delegated to the Managed-Account Companion (E75); scope opener 6851 and 6893 both name the C-6.6→E75 delegation. Consistent.

**FINDING (stub ↔ table inconsistency, minor, non-orphaning).** The table (row 6825) commits C-4.12 as "also" discharged in **ch:machines, ch:testability, ch:requirements**, and the body genuinely exercises it in each (1231, 6505, 6650/6772). But those chapters' "Governed by" stubs omit it:
- ch:machines stub (**907**): lists `C-5.1--5.8, C-2.7, C-12.6` — omits C-4.12 (yet lists its *other* also-clause C-2.7).
- ch:testability stub (**5398**): lists `C-13.1--13.3, C-2.5` — omits C-4.12 (yet lists its other also-clause C-2.5).
- ch:requirements stub (**6590**): lists `C-14.1--14.15` — omits C-4.12 (softened by its "§traceability maps every clause" deferral, but still short of the table).
**Exact remedy:** add `C-4.12` to the clause list of stubs 907, 5398, 6590 (net ≈ 0, three tokens), so each stub mirrors its table row. All other 14 stubs match the table exactly.

**Observation (not a finding):** C-2.8 is cited in-body in ch:virtual (3887) and ch:marketdata (2606) but the table row 6822 annotates no "also" for 2.8 — table and stubs *agree* (both omit), and the table does not claim exhaustive secondary annotation, so no inconsistency; a consistency-polish optionally adds "2.8 also ch:virtual".

**Gate result:** the table is a valid, complete, two-way partition of all 116 clauses — **DL-03 binding condition GREEN.** The stub omission is a mirror defect, not a partition failure.

---

## TASK 2 — change-log DL-01 paragraph vs `decision_log.md` — VERDICT: CLEAN

Change-log 6983-6986: *"Ruled (DL-01). The pass's Decision Panel ruled unanimously, R-conform: the door's fail-closed refusal of two simultaneous non-commuting events with no declared precedence survives, and the door-time tiebreak orders only pairs harmless to reorder or grounded in a declared precedence (ch:machines). No amendment, no parking."*

Every element matches `decision_log.md` DL-01: **R-conform, unanimous** (log: "R-conform, unanimous 3–0"; "unanimously" = the 3 panelists, faithful); **refusal survives**; **tiebreak orders only commuting/precedence-grounded pairs**; **no parking, no amendment**; scope = "two simultaneous non-commuting events with no declared precedence." Correctly converted from R1's "Under decision" to the settled ruling. Body (ch:machines door paragraph) states the same R-conform reading. CLEAN.

---

## TASK 3 — red-team scenario 4: duplicate with a DIFFERENT asserted execution time — VERDICT: CLEAN (every wrong path refused in writing)

**Nastiest instance constructed.** Covered call: exercise-notice arrival (cid `X`, asserted execution time **Thursday**, after Wednesday's record date) is folded — holder held shares on the record date, dividend entitlement stands. A second arrival bears the **same cid `X`** but asserts execution time **Tuesday** (before the record date). If believed as an ordering fact, Tuesday's exercise moves the shares away pre-record-date and **voids `100×D` of entitlement** — a bare re-transmission (or malicious back-dated replay) silently moving economic entitlement across a record date.

**The printed text refuses every wrong path, by sentence:**
- *Reorder path* ("Tuesday re-inserts the event, refolds, voids the dividend"): refused — "an arrival identical under the cause-derived identifier is **absorbed once, before ordering**" (1160-1162); "an **absorbed duplicate is never detected** here" (1213), so it cannot reach the late-arrival/reorder step; "Absorption is **by identifier alone, whatever execution time the arrival asserts**" (1172-1173).
- *Silent-overwrite path* ("Tuesday overwrites the recorded Thursday"): refused — "its **first admitted execution time is the recorded fact**" (1173); executably, `prop_duplicateAbsorbed`: `sameCid dup h ⟹ foldLedger(admit dup h) === foldLedger h` (**6165**) — differing execTime provably changes nothing.
- *Ordering-fact path* ("treat the differing time as an ordering fact"): refused — the differing time "does **not correct by re-arrival**"; a genuine contest "is a **distinct correction event that names the wrong one (C-12.4, TA-EXECUTION-TIME), carrying its own cause-derived identifier**, so it is **never absorbed** but re-inserted at its true execution position and refolds the tail" (1174-1177).
- *Silent-drop path* ("a real correction is lost"): refused — "Absorption therefore drops a **duplicate, never a contest**" (1177-1178); the legitimate channel (a distinct-cid C-12.4 correction, phase-0 human-authorised) is named and, being distinct-cid, is not absorbable.

An adversary cannot move entitlement across the record date via any same-cid re-arrival; the only channel that moves execution time is the named, authorised C-12.4 correction event. No residual wrong path in the printed machinery. CLEAN.

---

## Summary

| Task | Verdict |
|---|---|
| 1 — 116-clause two-way table audit (DL-03 gate) | **GATE GREEN**; 1 FINDING (C-4.12 missing from stubs 907/5398/6590) |
| 2 — change-log DL-01 accuracy | CLEAN |
| 3 — red-team scenario 4 (duplicate, differing execution time) | CLEAN |

**Findings: 1 (stub↔table, C-4.12; net-neutral three-token remedy). Parks: 0. DL-03 binding condition: satisfied (table is a complete two-way partition of all 116 clauses).**
