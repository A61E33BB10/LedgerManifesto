# Round 4 — FORMALIS findings (v16.1 pass)

Reviewer: FORMALIS (Leroy chair; Coquand, Huet, Paulin-Mohring, de Moura, Avigad).
Target: `ledger_v16_1.tex` — lem:closure derivation-order (1313–1318), serialization paragraph (1445–1452), contest machinery (1173–1178).
Record: `round4_record.md`. Prior: rounds 1–3, `memo_w2_proofs.md`.

---

## F1 — drift check on the printed derivation-order text — **VERDICT: DEFECT (drift, minor but theorem-critical)**

The ruling's content survives (the canonical characterisation *is* present at 1315–1316, "each emission strictly above every event … its predicate reads"), so no VETO. But two drifts:

1. **Procedural framing leads (1314).** "the causal order **the forward pass builds**" reads the order as *defined by* the traversal. Party-invariance requires the order to be a **function of the record**, which the pass merely *computes*. The canonical characterisation is buried as the third appositive behind the procedural lead. Reword so the pass **computes**, does not **build/define**, the order.

2. **Party-invariance is grounded in the wrong lemma (1315).** "reproducible by any party **(determinism, P2)**." P2 is same-*sequence* fold determinism — it guarantees one pass on one input repeats, **not** that the derivation *order* is a function of the record independent of the traversal strategy. Two deterministic passes that check armed predicates in different orders both satisfy P2 yet could emit a causally-independent pair in different orders. What actually makes the order party-invariant is that **the reads/writes-relation is recorded** (canonical partial order) **and the residual hash tiebreak is canonical** — not P2. The miscitation lets a traversal artifact pass as a record function. Re-ground it in the record-derived relation (see F2's combined rewrite).

---

## F2 (the seam) — independence does NOT imply commutation — **VERDICT: DEFECT (refuted)**

**Claim to test:** within one instant, two synthesised emissions, neither reading what the other writes, always commute — so the hash never silently decides a non-commuting pair.

**Refutation.** Read-independence gives only that each emission produces the **same transaction** in either order (it does not read the other's writes, so its `contract` sees the same inputs). Commutation of the two resulting *transactions* additionally needs **write-independence**: `apply(t_G, apply(t_F, L)) = apply(t_F, apply(t_G, L))` fails when `t_F` and `t_G` write the **same non-additive home field** to different values. Balance moves are additive and commute (`a+b=b+a`); the three homes (ProductTerms, UnitStatus, PositionState) as absolute fields do **not**. The spec itself admits "several watches, even several on one unit, synthesise firings" (1243): two firings on one unit's status, neither reading the other, can write-conflict — **non-commuting, yet read-independent.**

**Why this breaches DL-01.** The printed derivation order (1315) orders "each emission strictly above every event **its predicate reads**" — a **reads**-relation. It therefore classifies a read-independent, write-conflicting pair as *unordered* → "commuting" → **hash** (1316). But that pair is genuinely non-commuting, and DL-01 (1310–1312) mandates non-commuting same-instant pairs go to **declared precedence or refusal, never a silent tiebreak.** The reads-relation is the wrong boundary; the hash silently decides a non-commuting pair — the exact DL-01 breach.

**Fix (combined F1 + F2 rewrite of 1313–1318):**
```latex
Among synthesised emissions of one instant the order is the \emph{derivation order}: each
emission sits strictly above every event, real or synthesised, whose writes its predicate
reads \emph{and} every event with which it write-conflicts --- both setting one non-additive
home field. This relation is a function of the record --- what each emission reads and writes
is recorded --- so the order is identical for every party; the forward pass \emph{computes}
it and does not define it. A pair unordered by this relation --- disjoint in reads and in
non-additive writes, balance-moves excepted as additive --- genuinely \emph{commutes}, reaches
one fold state in either order, and falls wholly to the event hash, definite because the hash
admits no collision on the finite domain of well-formed events (H-CR, \S above). A pair that
write-conflicts with no reads-dependency to force its order is \emph{non-commuting} --- two
firings setting one unit's status --- and is ordered by declared precedence or refused
(C-2.7, DL-01), never by the hash.
```
(Alternatively, if product-graph well-formedness structurally guarantees synthesised emissions of one instant have **disjoint non-additive writes**, cite that guarantee and read-independence then suffices — but that guarantee is stronger than "one home per fact" and is not currently stated. Absent it, the seam is open.)

---

## F3 — serialization paragraph overclaims P1 — **VERDICT: DEFECT**

**"the total order is arrival-independent" (1448–1449) is false and promises more than P1/P2/P3 prove.** The total-order key is `(execTime, doorTime, hash)`, and **door time is assigned at admission** (1173, 1181–1182) — so the order **depends on arrival sequence** wherever execTimes tie. P1 proves the order is **party-invariant** (same record ⇒ same order, computable by any party), which is **not** arrival-independence (different admission orders can assign different door times ⇒ different order). The paragraph conflates the two.

**What is actually true (and what the conclusion needs):** the **fold state** is arrival-independent, because (i) where execTimes differ the order is record-fixed, and (ii) where they tie the door-decided order is among **commuting** events (state-invariant) or is the **same-instant non-commuting pair** the residual clause already routes to DL-01. The paragraph's own residual clause (1450–1452, "never by an arrival-order door tiebreak") shows the author knows door must not decide a non-commuting pair — so the premise should read **state**, not **order**:
```latex
Because the fold state is a function of the arrival set (Theorem~\ref{thm:refold}) --- door
time decides only commuting ties, a non-commuting pair never falling to it --- and the refold
is idempotent (\S\ref{sec:totalorder}), any interleaving of late arrivals reaches one quiescent
closure; the sole residual is a same-instant non-commuting pair, ordered by declared precedence
or refused (C-2.7, DL-01), never by an arrival-order door tiebreak.
```

**Secondary (1445–1447):** "each triggered refold **runs to completion** … backstopped by the overdue-watch sweep." Completion is **termination**, which rests on **H-FIN/H-WF** (structural, "a violated finiteness hangs the closure", 1331–1333). The overdue-watch sweep is a **scheduling-liveness** backstop (it catches a *lost/dropped* refold), not a termination guarantee — it cannot rescue a non-terminating closure. Distinguish the two: termination is H-FIN/H-WF; the sweep backstops a lost signal.

---

## RT-A (red-team) — two conflicting corrections to one event's execution time, either order — **CONFLUENCE HOLDS generically; RESIDUAL = same-instant conflict**

Setup: distinct corrections `C1`, `C2` (each a distinct-cid contest, 1175–1177) assert execTimes `t1 ≠ t2` for event `E`.

- **Distinct correction execTimes (generic case): confluent.** `C1`, `C2` are ordered in the total order by **their own** execTimes — record-fixed, admission-independent (P1). The authoritative execTime of `E` is the **tip** (latest correction in force), a function of the record, identical in either admission order ⇒ identical refold ⇒ identical state (thm:refold). ✓ Order irrelevant.
- **Same correction-instant (residual): NOT confluent under door alone.** If `C1`, `C2` share an execution instant, the total order between them falls to **door time = admission order**: admit `C1` then `C2` ⇒ tip `C2` ⇒ `E.exec = t2`; reverse ⇒ `E.exec = t1`. **Different state.** This is precisely a **same-instant non-commuting pair** (two contradictory tips), and it is the residual the serialization clause (1450–1452) routes to **declared precedence or refusal, never a door tiebreak.** RT-A therefore *confirms* that clause is load-bearing — **but the clause's DL-01 example is a product firing (knock-out/coupon); conflicting corrections must be named as an instance**, or a reader concludes door (admission order) resolves them (which the paragraph's own false "arrival-independent order" premise, F3, invites). Fix: with F3's correction in place, add "including two conflicting execution-time corrections of one instant" to the residual.

---

## RT-C (red-team) — nested lateness: a late correction of a late arrival — **PASSES**

A correction `C` contesting an execution time is itself late (its execTime precedes folded events), so admitting it triggers a second reordering step whose tail includes the first late arrival `L1`'s refold.

- **The reordering step iterates; it does not recurse.** Each admission adds one element to the arrival set and runs **one** forward pass over the current set (step c, 1246–1247). Admitting `L1` then `C` yields the fold of `sort_<(A ∪ {L1, C})` — a function of the **set** (thm:refold), whatever `C`'s insertion point relative to `L1`. There is no nested recursion of the step, only a larger finite `A`.
- **lem:closure covers each pass; thm:refold + P4 cover the iteration.** The firing-derivation fixpoint is re-computed over the grown set `A ∪ {C}` — unique and terminating by lem:closure applied to the larger finite `A`; `L1`'s synthesised firings are re-derived, some superseded (H-INERT, retained-voided), all kept injective by their cause-derived ids `H(·, watch, occasion)`. Idempotence (P4) holds: re-running the step on the quiescent closure finds every event at position and re-derives the same fixpoint. ✓
- **Confluence:** admitting `{L1, C}` in either order reaches one state (RT-A generic case). The **only** residual is again a same-instant non-commuting conflict between the two corrections (shared with RT-A). Cost is `O(Σ|tail'|)` across the iterated arrivals, each pass `O(|tail'|)` (1343–1346) — accurate, not understated.

---

## Summary of required edits (all net-positive, protected under SF-2: correctness over the 1-over cap)
1313–1318 combined F1+F2 rewrite (canonical order + write-conflict discipline); 1448–1449 "total order" → "fold state" (F3) plus the conflicting-correction instance (RT-A); 1445–1447 termination-vs-liveness distinction (F3 secondary).
