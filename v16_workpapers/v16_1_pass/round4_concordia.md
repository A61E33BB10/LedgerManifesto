# Round 4 — CONCORDIA (constitutional-adherence certifier)

Pass: v16.1, Round 4 of 5. Target: `ledger_v16_1.tex`. Authority: `ledger_manifesto_v1_4.tex`; `decision_log.md`.
Named-but-unavailable: kleppmann (SF-4). Standing item: file 113pp / 1-over is DEFERRED-TO-OWNER (SF-2) — not a reviewer lever.

---

## C1 — clause anchor of the new serialization paragraph (1445-1452) — VERDICT: CLEAN (traces to C-2.7; gate GREEN; NOT a PARK)

**The paragraph traces to existing clauses — no untraceable guarantee, so no PARK.** Tracing each sentence:
- *"The single writer serialises admission and refold … the sole residual is a same-instant non-commuting pair, ordered by declared precedence or refused (C-2.7, DL-01), never by an arrival-order door tiebreak"* — **C-2.7** (constitution 166-175: "forces the single writer, the single total order, and the refusal to reorder anything unless harmlessness is proved"). Cited in the paragraph itself. This is the paragraph's normative spine.
- *"only the quiescent closure is the specified, committed, observable state; a partial refold is never committed and never observed"* — a **single-writer consequence** (a serialised writer's committed state is its last completed write; observers read the committed log), reinforced by **C-11.2 Atomicity** (constitution 808: "A transaction is applied in full or not at all"). Not a new constraint on projections — projections remain functions of the committed log.
- *"a liveness obligation backstopped by the overdue-watch sweep (Chapter ch:requirements)"* — traces to **ch:requirements** (C-14.x, the overdue-watch sweep).
- *"Because the total order is arrival-independent and the refold idempotent (§sec:totalorder) …"* — **cites** sec:totalorder's determinism (which discharges C-2.7's total order); it uses, not re-establishes, that result.

**Gate check.** The paragraph's cited anchor is **C-2.7**, and the traceability table row 6847 already lists **"2.7 also ch:machines"** — so the paragraph's home (ch:machines / sec:substrate) is a listed co-discharge chapter for its clause. The coordinator's condition ("if it discharges a clause it must appear in the table's row for that chapter") is **satisfied as-is**. **No new row required; gate stays GREEN.**

**Observation (optional polish, not a finding).** The atomicity sentence rests on **C-11.2** (primary ch:invariants, table row 6858, no *also*). Since it is a single-writer consequence (C-2.7, already anchored to ch:machines) and adds no property test in ch:machines, it is not an independent C-11.2 discharge that the table must track. If the certifier chain wants the refold-atomicity discharge made maximally explicit, an *"also ch:machines"* on the C-11 row would do it — but this is discretionary rigor, not a gate defect. **No PARK: every guarantee is clause-traceable.**

---

## C2 — DL-03 GREEN gate survives the Round-3 diffs — VERDICT: GREEN preserved

Re-checked only the affected rows/sites:

1. **C-4.12 stub mirrors landed (my R3 finding closed).** All three stubs now carry C-4.12:
   - ch:machines (907): `C-5.1--5.8, C-2.7, C-4.12, C-12.6` ✓
   - ch:testability (5417): `C-13.1--13.3, C-2.5, C-4.12` ✓
   - ch:requirements (6617): `C-14.1--14.15, C-4.12` ✓
   Each now mirrors table row 6850 (`C-4.12 → ch:marketdata; also ch:machines, ch:testability, ch:requirements`). Stub↔table consistency restored.

2. **Caption precision did not alter the partition.** New caption (6832-6837): *"each listed once in the left column against its primary discharging chapter (clause-to-chapter total, no gap); an italic* also *note adds a chapter that co-discharges … Every one of the seventeen chapters appears in the right column."* This documents the primary-vs-*also* semantics (the exactly-once partition is the primary column; *also* is a co-discharge read-instruction, no double-count) **without changing any row**. All 18 rows unchanged; re-summed to **116**; all 17 chapters present. Two-way partition intact.

3. **DL-01 de-jargon preserved accuracy.** Current (7005-7007): *"Ruled (DL-01). The door's fail-closed refusal of two simultaneous non-commuting events with no declared precedence survives; the door-time tiebreak orders only pairs harmless to reorder or grounded in a declared precedence (ch:machines). No amendment, no parking."* The term-of-art "R-conform" and "Decision Panel ruled unanimously" were struck; the **ruling substance** — refusal survives, tiebreak scope, no amendment/parking — is fully preserved and matches `decision_log.md` DL-01. The 3–0 tally lives in the decision log, not required in the change-log. Accuracy preserved.

**Gate: GREEN.**

---

## RT-E — duplicate arriving after its original was superseded by a contest — VERDICT: CLEAN (stale assertion inert in writing)

**Scenario constructed.** Original `O` admitted (cid `X`, asserted execution time `T_old`). A C-12.4 correction `C` (distinct cid) contests `O`'s time, names `O`, re-inserts at the true `T_new`, and refolds — the in-force tip is now `T_new`. **Then a duplicate of `O` arrives: same cid `X`, bearing the now-superseded `T_old`.** Nastiest angle: if `T_old`'s re-assertion re-opened the contest, the correction would silently revert.

**Every path that could revert the tip is refused in writing:**
- *Re-insertion path:* refused — the duplicate matches `O`'s cid, so it is "absorbed once, **before ordering**" (1160-1162), and "an **absorbed duplicate is never detected** here" (1213); it cannot enter the total order or trigger a refold.
- *Overwrite path:* refused — "Absorption is **by identifier alone, whatever execution time the arrival asserts** … its first admitted execution time is the recorded fact" (1172-1173); executably, `prop_duplicateAbsorbed`: `sameCid dup h ⟹ foldLedger(admit dup h) === foldLedger h` (6165). The duplicate's `T_old` changes nothing.
- *Re-open-the-contest path:* refused — "Absorption therefore drops a **duplicate, never a contest**" (1177-1178). The duplicate shares `O`'s cid, so it **is** a duplicate; a genuine contest is a **distinct-cid** correction (1174-1176), which the duplicate is not. It cannot touch or undo `C`.
- *Correction untouched:* `C` is a distinct event on the log, in force via its own re-insertion (1176-1177); the duplicate's absorption never reaches it. `T_new` stays the tip; `O`'s original `T_old` survives only as as-known-at provenance (W2, 2894-2905), not as an in-force reversion.

**Mechanism note:** the inertness is **emergent from the universal absorption rule** ("changes nothing," holding regardless of any subsequent correction) composing with the distinct-cid correction channel — no special-cased "tip-supersession" statement is needed, and none is missing. The tip-supersession chain is airtight in the printed text. No wrong path exists.

---

## Summary

| Item | Verdict |
|---|---|
| C1 — serialization paragraph clause anchor | CLEAN (traces to C-2.7; gate GREEN; not a PARK) |
| C2 — GREEN gate survives Round-3 diffs | GREEN preserved (C-4.12 mirrors landed; caption precision & DL-01 de-jargon harmless) |
| RT-E — duplicate after supersession-by-contest | CLEAN (stale assertion inert in writing) |

**Findings: 0. Parks: 0.** R3 finding (C-4.12 stubs) confirmed closed. One optional-polish observation (C-11.2 *also* ch:machines) recorded, not required. Feeds round-5 certifier signature (ii): firing-derivation + serialization discipline are globally consistent and clause-anchored.
