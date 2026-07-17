# v16.1 Round 4 — Correctness review (correctness-architect)

PRIMARY: close A2 against `cut_manifest_r2.md`. THEN red-team RT-D (duplicate of a voided
firing) and RT-B (self-undermining chain) — per the coordinator's direct message, which
reassigns these two to me, overriding round4_record §2.

---

## A2 — the six category-(b) cuts: ALL KEEP-CUT (both supervisor priors disproven on the record)

I re-derived each carrier from the printed text rather than trusting the manifest. Verdicts:

| cut | verdict | carrier verified |
|---|---|---|
| b1 | KEEP-CUT | `lem:closure` clauses Existence-uniqueness/Termination/Confluence (1305-1325) carry "exists / unique / finitely many / discovery-order-independent"; "record-derived" survives in the new remark (1286). |
| b2 | KEEP-CUT | two-guard table **Kind** column types sufficiency "obligation: deadline, discharge predicate, close-out as compensation" (5343) vs coverage "invariant, checked at the door" (5342); pre-table "a deadline, not an invariant" (5335); prose "not a broken state" (5348-5350). The load-bearing **non-claim** (sufficiency is *not* a standing invariant — a false theorem if asserted) is carried three times over. |
| b3 | KEEP-CUT | checkability IS carried — 3034-3040: "seven things … each **mechanically checkable over generated data and histories**: … an operator is declared for every (registered kind, event kind) pair, and an undeclared pairing is refused (`prin:sched-total`)", plus W4's tested disposition (3044-3046). |
| b4 | KEEP-CUT | each "rides X" one-liner is a CDM Gaps-table "Lineage convention carried" cell; surviving connective at 4875. (Verified the connective + manifest cell quotes; did not re-read each cell.) |
| b5 | KEEP-CUT | "one writer per fact" → `inv:writer` (5137-5142); **"one home per fact / no rival home"** → **`prin:one-home` (1949-1953): "No fact is kept in two homes, so no two homes can disagree about it"**; "not a second store" survives (5146). |
| b6 | KEEP-CUT | conclusion carried by `prin:rebuildable` (2074-2078) + restated one-writer/one-home/pure-fold (2082-2084); the deleted "why a second copy is dangerous" is motivation whose home is ch1 (reconciliation-failure premise). |

**Both supervisor priors are wrong on the evidence, and I record the disagreement:**
- **(b5) prior "one home per fact may be uncarried" — DISPROVEN.** It is carried verbatim by
  `prin:one-home` (1949-1953). The manifest **mis-cited** the carrier as `inv:writer` (which
  carries only *one writer*); the true carrier is `prin:one-home`. State-once is satisfied, and
  the ch14 argument (5144-5152) is logically complete without the local restatement (it derives
  divergence-freedom from projection+one-writer, not from one-home). Fix the manifest citation;
  keep the cut.
- **(b3) prior "checkability lost" — DISPROVEN.** Carried at 3034-3040, more strongly than the
  deleted sentence (one of seven *mechanically-checkable* acceptance conditions, citing
  `prin:sched-total`), and the executable side is W4's tested disposition (3044-3046).

**Appendix proof-touching spot-checks — none removed a proof step:**
- #16 (C-12.1/PARK-2 discharge compression) — KEEP-CUT: the discharge survives (397-403) and is
  executed by BITEMP-1/BITEMP-2 in ch15.
- #10 (ch:virtual no-second-store recap) — KEEP-CUT: established in `prin:rebuildable` + ch12
  (3249); recap redundant.
- #22 (M/V/B requirement recap) — KEEP-CUT: the requirements themselves survive at their home
  (6735-6749); only the recap went.

**A2 CLOSES: 6/6 KEEP-CUT + 3/3 appendix clean, with one manifest-citation correction (b5 →
`prin:one-home`).** No RESTORE.

---

## RED-TEAM

### RT-D — a duplicate of a firing arriving AFTER a refold voided that firing — VERDICT: SOUND

A firing F voided by a refold is **retained** (C-12.5, never deleted; consequence voided by
H-INERT, 1327-1329 — its contract re-runs to the empty transaction against the refolded state).
A duplicate of F (same cause-derived id) is **absorbed** by identifier before ordering (1161-1163,
1278-1279: "absorbed under its cause-derived identifier … occupies no position and triggers no
refold"). **Nothing is resurrected**, two independent defences (mirroring 1145-1150):
1. absorption drops the duplicate — it never takes a position, never triggers a refold;
2. even were F's contract re-run, H-INERT makes it propose the empty transaction.

The **retain-not-delete** rule is load-bearing here: it keeps F's cid on the log, so the
duplicate matches and absorbs. Had the void *deleted* F, the duplicate's cid would be absent →
admitted as new → the consequence **resurrects**. So C-12.5 retention is exactly what closes the
resurrection path — the voided state wins. The record shows F once (retained, voided, `restated`
flag), the duplicate committing zero further times ("constant under retry", 1148-1150). Auditable.

*One clarification to print (net +½ sentence):* make explicit that absorption's duplicate check
ranges over the **full retained log including superseded/voided firings**, not only in-force
emissions. The text implies it (C-12.3 idempotence = "cid already on the log"; voided firings are
on the log), but a reader could wrongly narrow absorption to in-force events, which *would*
reopen resurrection. Say it once.

### RT-B — self-undermining chain — VERDICT: does NOT oscillate; but a real H-WF discharge gap

**Sub-case 1 (a single firing whose consequence falsifies its own trigger predicate) — SOUND by
construction.** The well-founded recursion evaluates an emission's predicate against **the fold
strictly below its position** (1298-1307: "an emission at p depends only on the fold strictly
below p … the dependency strictly decreases in the well-order <"). F's consequence is folded *at*
F's position, never below it, so it **cannot alter the prefix F's own predicate reads**. F is
synthesised once and is **not self-voided**; a downstream watch reading the post-F state (predicate
now false) is a *different* emission at a later position and simply does not fire (or an existing
firing there is voided normally). Stratification on execution time **is** the anti-oscillation
mechanism — no cycle, no coin-flip.

**Sub-case 2 (a genuine cross-unit re-arming cycle: U's firing arms a watch on V, V's firing
arms a watch back on U) — DEFECT: H-WF is claimed discharged where no discharging check exists.**
This is the real "arms a further watch" cycle. The lemma's defence is H-WF (1321-1322), and the
honesty label says H-WF is "**discharged by product-graph well-formedness (Chapter ch:objects)**"
(1332). **It is not.** The product-graph well-formedness ch:objects actually prints is:
- inception dating — "a scheduled watch is dated at or after the unit's inception … (product-graph
  well-formedness)" (838-840) — that is **H-FWD**, not H-WF;
- a **closed finite node set per unit** (865, 883) — bounds one unit's states, says nothing about
  a **cross-unit** arming cascade;
- `inv:graph-consistency` (i)-(iv) (887-896) — consistency of the three interpreters, **not**
  acyclicity of the arming relation.

A firing arming a further watch is a first-class mechanism (the dividend announcement fires to
*register* watches, 1499-1512; cross-unit reference edges, 850-854), so a cross-unit arming cycle
is **structurally possible and nothing printed forbids it**. Such a product passes every printed
well-formedness check and, under a refold (or even the timely fold), **hangs the closure**
(non-termination). The lemma is honest that a violation *hangs* ("does not fail a test", 1332-1333;
property block 6168), and the hang is at least **visible** — an unfinished refold surfaces as an
overdue item (overdue-watch sweep), never a wrong committed state, never a silent tiebreak. **But
the discharge is asserted, not real:** H-WF is delegated to a ch:objects condition that does not
exist, so a malformed product is admitted at registration and hangs only later, at refold time.

**What the record shows on an H-WF violation:** no quiescent closure is committed → the arrival's
admission never reaches a committed state → visible as an overdue/unfinished refold. Safety
(no wrong committed state) holds; **liveness detection is the gap** — the defect is undetected at
registration.

**Fix (two alternatives):**
(a) **Preferred** — add an explicit, executable product-graph well-formedness condition in
   ch:objects: the cross-unit "arms a further watch" relation is well-founded (acyclic), checked
   at registration and property-tested (`prop_armingWellFounded` over generated multi-unit
   product graphs). Then H-WF is genuinely discharged, and a cyclic product is refused at the
   door, not hung at refold. Constitution §3 (executable guarantees) demands this.
(b) If cross-unit arming cannot be statically bounded in general, **relabel H-WF honestly** as an
   *unchecked liveness assumption* (drop "discharged by product-graph well-formedness"), whose
   violation hangs the closure, backstopped visibly by the overdue sweep — an honest downgrade,
   not a false discharge.

---

## Blockers / Findings
1. **RT-B sub-case 2 (DEFECT)** — `lem:closure` (1332) claims H-WF is discharged by ch:objects
   product-graph well-formedness; ch:objects carries only H-FWD (inception) + per-unit finiteness,
   no cross-unit arming-acyclicity condition. Add the executable check (a) or relabel (b).
   Co-owned with FORMALIS F3 (hypothesis honesty) / RT-C; surfaced here via RT-B.
2. **RT-D (SOUND)** — add one clause pinning absorption's duplicate-check to the *full retained
   log including voided firings* (closes the reader's resurrection doubt).
3. **A2 (CLOSED)** — 6/6 KEEP-CUT, 3/3 appendix clean; correct the manifest's b5 carrier citation
   to `prin:one-home`. No RESTORE. Both supervisor priors disproven on the record.
