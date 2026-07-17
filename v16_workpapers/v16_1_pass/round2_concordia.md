# Round 2 — CONCORDIA (constitutional-adherence certifier)

Pass: v16.1, Round 2 of 5 (findings mode; CONCORDIA signs last at round 5).
Target: `ledger_v16_1.tex` (6962 lines). Fix-A home: ch04 `sec:totalorder`, step (c) (1226-1232), Interactions (1308-1315), theorem + remark (1257-1279).
Chapter map (coordinator no. → label → lines): ch05→`ch:valuation` (2030-2420); ch08→`ch:marketdata` (2421-2991); ch09→`ch:collateral` (2992-3634); ch11→`ch:settlement` (3897-4353).
Named-but-unavailable: kleppmann (SF-4) — recorded, not substituted.
Page constraint (SF-5) honoured: both remedies below are one clause each, net ≤ 0, banked trivially.

---

## C1 (CENTRAL) — does firing-derivation compose everywhere watches appear? — VERDICT: CLEAN

Sweep of ch05/ch08/ch09/ch11 for text that **contradicts** firing-as-derivation (firing stated as the *only* origin / a firing described as un-recomputable / routing that assumes every folded event crossed the boundary). **No contradiction found.** Every firing description is one of two acceptable forms:

**(a) Actively consistent with re-derivation** — reinforces Fix-A, not in tension:
- 2514-2517 (ch05): "firing 127 **recomputes the same statistic any party would**" — the clock-free re-derivation doctrine, verbatim.
- 2289-2291 (ch05): "Each firing writes the running [accrual]… firing $k$ finds fixings $1,\dots,k-1$ already on the record" — the ordered per-unit fold that ch04 (1188-1189) names as the special case of the global refold.
- 4274-4276 (ch11): the due-date watch firing "reads the cumulative confirmed settled quantity short of the instructed quantity by the deadline… reads **quantity, not mere presence**" — a record-derived predicate, re-derivable clock-free. The due-date/fails firing is NOT a bare wall-clock timeout, so it composes.

**(b) Timely-path narration, silent on refold** — acceptable NON-MENTION (§1 one-name-one-place; ch04 governs). Sites carry no back-reference and none is required: 2118, 2153 (ch05); 2553-2559 routing, "Fires the responsible contract… a declared fact" (ch08); 3357, 3385-3388, 3536 (ch09); 3958, 4223-4224, 4250, 4271-4272 (ch11).

**One near-collision, resolved (not a finding).** ch11 4242-4243: "MC-1 exists because the record-date firing **wrote it, not because the projection did**" vs ch04 1314-1315: "which firings are **in force** is a **projection** of the ordered prefix." Different referents: ch11 says the firing's *consequence* (the MC-1 move) is a recorded transaction, not a read-only view; ch04 says the firing's *in-force status* is re-derived from the prefix. Both hold under Fix-A (consequences are recorded and retained as provenance; validity is re-derived). No contradiction; the word "projection" is reused across two meanings but the sentences do not conflict.

**Composition of every swept watch class checked:** barrier/threshold (data-predicate on recorded prints), record-date / payment-date / due-date (record-derived scheduled instants), margin/collateral (exposure = projection of recorded positions and prices). All predicates read the record, not the clock, so all compose with clock-free re-derivation. CLEAN.

---

## C2 — a synthesized firing under C-4.12 total routing / event-kind registry — VERDICT: FINDING (statement/seam; net-neutral pointer)

**Not a real registry gap.** A synthesized firing is the firing of an **already-declared watch**. A watch cannot arm unless its firing kind is registered with a router ("a kind cannot register without a router", ch08 2552-2554; "acknowledged watches… declared, then armed, then fired or expired", 1443, 6557-6559). So the synthesized firing carries **the watch's already-registered event kind**, routes to **its declared contract**, and — being routable by construction — **cannot be quarantined** (quarantine, W4, is for *undeclared* kinds / unresolvable references). Monitor-time-null is already stated (1314). C-4.12 is satisfied in substance.

**The defect: the seam is never stated, and Fix-A is now a load-bearing model commitment (SF-2).** ch04's synthesis text (1226-1232, 1312-1315) gives the synthesized firing a cause and a null monitor time but never says it carries a **registered kind** or **routes through the C-4.12 registry** like any emitted firing. ch08's registry language is arrival-centric — "registered… before any event of it **crosses**" (2551), "before any **data** of that kind **crosses**" (2541) — and never explicitly embraces a firing the refold produces that never arrived from outside. A strong-undergraduate reader (§6) cannot answer "what kind does this new folded item carry, and can it be quarantined?" from the printed text. On a commitment the round-5 signatures must cover, that inference gap should be closed.

**Remedy (one clause, net ≤ 0; fold into 1313-1314 after "its monitor time null"):**

> — it carries the watch's registered event kind, declared with its router when the watch armed (C-4.12, Chapter~\ref{ch:marketdata}), and routes through that router as any emitted firing does, so it is routable by construction and never quarantined —

(Optionally a three-word back-pointer at ch08 2559; not required if the ch04 clause lands.)

---

## C3 — cause-derived identifier of a synthesized firing: injective over a one-correction fan-out? — VERDICT: FINDING

**The printed text pins the cause but not the discriminator.** The synthesized firing's identity is stated only as "its cause **the correction**" (1313) / "its cause the arrival that reordered the prefix" (1228). The cause-derived-identifier injectivity that IS proved — `txid = H(causeEventId, contractId, unitId, seq)`, injective over a cascade (1062-1090; 5951-5983; ch08 2555-2559 "one firing per referencing **unit** — separated by the cause-derived identifier") — separates **one cause across many units** by `(contract, unit, seq)`, and `seq` "distinguishes the several **legs one firing** may propose on a single unit" (1073) — i.e. legs *within one* firing.

**The uncovered case:** one correction that **newly satisfies several distinct watches on the *same* unit** — realistic (an autocall barrier and a coupon barrier on one unit keyed to one observation date; a knock-out watch and a fixing watch on one unit). These are **distinct synthesized firing events**, all sharing `(cause = correction, contract, unit)`, and `seq` (a within-one-firing leg index) does not separate distinct firings. The Round-1 injectivity proof does not reach them. So two synthesized firing events can collide on one cause-derived identifier → one is absorbed as a duplicate (1166-1168) and a **real firing is silently dropped**. The text does not rule this out; the coordinator's proposed key `(correction event, watch, predicate instance)` is nowhere printed.

**Remedy (one clause, net ≤ 0; fold into 1226-1229 / 1313):** pin the synthesized firing's cause-derived identifier to key on the reordering arrival **and the watch**, e.g.:

> …synthesised at its execution position, its cause the correction **and the watch it fires** — the watch playing, for the firing event, the discriminating role `(contract, unit, seq)` plays for the transaction cascade (\S\ref{sec:txexec}) — so one correction newly satisfying several watches, even several on one unit, synthesises firings that stay injective and none is absorbed as a duplicate.

Reconcilable by adding the discriminator; no constitutional amendment. FINDING, not PARK.

---

## Summary

| Lens | Verdict |
|---|---|
| C1 — global composition of firing-derivation (ch05/ch08/ch09/ch11) | CLEAN (non-mention only; no contradiction) |
| C2 — synthesized firing's kind / routing / quarantine under C-4.12 | **FINDING** (unstated seam; net-neutral pointer remedy) |
| C3 — injectivity of synthesized firing identifiers over a one-correction fan-out | **FINDING** (same-unit multi-watch collision; discriminator remedy) |

**Findings: 2 (C2, C3). Parks declared: 0.** Both remedies are single clauses, net ≤ 0 (SF-5 satisfied). Both bear on SF-2 (the firing-derivation commitment the round-5 certifier signatures must cover).
