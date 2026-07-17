# v16.1 Round 3 — Correctness review (correctness-architect)

Target: `ledger_v16_1.tex` sec:totalorder (step c, lem:closure, snapshot key) + ch15.
Co-adjudicating A1/SF-1 with FORMALIS (supervisor recused — authored the original ⊥ call).
R2 fixes verified landed: single forward pass (1241-1249), H-FWD, producer split,
prop_firingSynthesized_fires (6177-6186), ⊥ door keys (1232, 1339). Fixes below are net-zero.

---

## A1 (HEADLINE, co-adjudicated) — the ⊥ within-instant position is inverted — VERDICT: DEFECT

**Ruling: ⊥ must sort AFTER every real door time of its execution instant (a top element),
not before. The printed "before" (1234) is wrong.** I concur with SF-1 and supply the walk.

**The knock-in walk under the printed ⊥-before (1234).** Late arrival is a corrected close
$O$ that breaches an 80 barrier: $O=(t_O,\ \mathrm{door}_O,\ \mathrm{hash}_O)$, door **real**
(it crossed the arrival door). The forward pass folds $O$, evaluates the barrier predicate
against the state that now includes $O$ → newly satisfied → synthesises knock-in $F$. Per
1229/1244, $F$'s execution time is the tipping observation's instant $=t_O$; per 1232, $F$'s
door is $\bot$. So $F=(t_O,\ \bot,\ \mathrm{hash}_F)$. Under **⊥-before**, $\bot<\mathrm{door}_O$,
so $F<O$: **$F$ sorts before the very observation it is derived from.**

Three landed sites then contradict each other:
- 1234 (key): $F$ before $O$.
- 1300 (lemma existence): "a data emission **at the tipping observation just folded**" — $F$
  after $O$.
- 1241-1247 (forward pass): fold $O$, *then* "fold any newly synthesised emission **in the
  same pass**" — $F$ after $O$.

And the lemma's existence proof is **internally false** under ⊥-before: 1298-1302 argues "an
emission at $p$ depends only on the fold **strictly below** $p$ … the dependency strictly
decreases in the well-order $<$." Under ⊥-before, $F$'s position $(t_O,\bot,\cdot)$ is strictly
*below* $O$'s $(t_O,\mathrm{door}_O,\cdot)$, yet $F$ depends on $O$ — the dependency does **not**
decrease; it points *upward*. The well-founded recursion the whole lemma rests on breaks.

**Operationally** the pass reaches $F$'s slot before $O$ is folded → either the barrier is not
yet breached and $F$ is **lost**, or $F$ must be **re-inserted behind the cursor** — killing
"one forward pass, no position revisited, $O(|\text{tail}'|)$" (1241-1247, 1332-1336). Wrong
fold state or a hidden re-pass. This is a MAJOR correctness defect.

**The fix (net-zero, coordinated).** Define $\bot$ as **top in the door coordinate**
($\bot > $ every real door time), i.e. within one execution instant order is: real-door
arrivals ascending, then all ⊥-door synthesised firings, tie-broken by hash. Then $F>O$, the
pass folds $O$ then $F$, "just folded" (1300) and "strictly below $p$" (1298-1302) both hold,
and the single pass stands. Record-derivability is untouched — $\bot$ is a fixed sentinel, its
sort rule fixed for every party. Edits:
- **1234:** "sorting **before** every real door time of its execution instant" →
  "sorting **after** every real door time of its execution instant (a top element within the
  instant), so a synthesised firing follows the observation that triggers it."
- **1298 / 1305-1308 (lemma):** state the within-instant order explicitly — real door times
  first (ascending), then ⊥-door firings by hash; this is what puts the tipping observation
  *strictly below* a same-instant data emission and makes the well-founded recursion sound.
  (The other three sites already assume ⊥-after; only 1234 must flip.)
- **1339 (snapshot key):** name the ⊥ direction where the triple is used (see A3).

Note for FORMALIS (F2): two same-instant synthesised firings both carry $\bot$, so their tie
falls to **hash**, and a *non-commuting* such pair must take declared precedence or refusal
(1305-1307, DL-01), never a hash coin-flip — the ⊥→top flip does not disturb that; it concerns
$\bot$ vs *real* door, not $\bot$ vs $\bot$.

## A3 — snapshot rule end-to-end under ⊥ keys — VERDICT: SOUND under the A1 ruling

Take a snapshot $S$ whose last folded event is a real-door arrival at instant $t$:
$T_{\text{last}}=(t,\mathrm{door}_S,\mathrm{hash}_S)$. A refold synthesises $F=(t,\bot,\cdot)$ in
the **same instant**. Under the ⊥-**after** ruling $T_F>T_{\text{last}}$, so $F$ folds after
$S$'s last event and $S$'s prefix is unchanged — $S$ correctly **survives** ($T_{\text{last}}<
T_F$, not invalidated). Conversely a *new real arrival* $e'=(t,\mathrm{door}',\cdot)$ at instant
$t$ sorts **before** a ⊥-firing, so a snapshot ending on that firing is correctly **invalidated**
($T_{\text{last}}=(t,\bot,\cdot)\ge T_{e'}$). Both directions decidable from the record; the key
space $(\text{exec},\ \text{door}\cup\{\bot=\top\},\ \text{hash})$ is a strict total order, so
"$T_{\text{last}}\ge T_e$ invalidates, nearest survivor is greatest $<T_e$" (1340-1341) stays
well-defined and monotone. And a synthesised firing invalidates only a **subset** of what the
triggering arrival already invalidated ($T_F\ge T_e$), so it adds no new invalidation — the
primary insertion drives it. **Under the printed ⊥-before** the *formula* still fires but
invalidates a snapshot the same pass just took and forces its re-fold — the same single-pass
break A1 identifies, seen from the snapshot side. **Recommend:** print the ⊥ direction at 1339
("its door slot $\bot$, ordered after real door times of the instant") so the strict order is
unambiguous at the point the invalidation comparison is made.

## A2 — category-3 lemma-restating cuts — VERDICT: INCONCLUSIVE (manifest unavailable)

The six cut sites cannot be diffed: `Ledger_Spec_v16.1/` is **untracked** (`git status` → `??`),
so there is no baseline, and the workpapers hold no manifest of the removed asides
(round2_stylus.md critiques the cuts but does not list pre-cut text). I will not issue
KEEP-CUT/RESTORE verdicts on text I cannot see. **What a restatement-cut must NOT have dropped
— the load-bearing content of lem:closure / thm:refold, as the reviewable checklist:**
1. The four hypotheses **H-FIN, H-WF, H-FWD, H-INERT** are *named obligations, property-tested,
   not axioms* (1320-1322) — a cut that removed a hypothesis label or its "not an axiom"
   scoping is load-bearing loss.
2. The operator is **not monotone** and uniqueness is by **stratification on execution time,
   not a Knaster-Tarski least fixpoint** (1303-1305) — a cut that dropped the anti-monotone
   caveat would let a reader mis-apply KT.
3. thm:refold is **over fold state alone**, not settled money / external effects / fired
   notifications (1325-1330) — a cut of this scope limit over-claims the theorem.
4. Within-instant **non-commuting pairs → declared precedence or refusal (C-2.7/DL-01)**, not a
   door/hash tiebreak (1305-1307).
5. H-INERT: a superseded firing **re-runs to a fold-state no-op** (1317-1319) — the mechanism
   by which retention does not corrupt state.

**Action:** request the coordinator/STYLUS supply the six cut sites (pre-cut text); I will then
diff each against 1-5 above. Until then A2 is open, not clean.

---

## RED-TEAM

### Scenario 1 — a late arrival admitted WHILE an earlier refold is still folding — GAP (missing discipline)

The printed text does **not** state the single writer's re-entrancy rule. "Detection and the
refold are the single writer's work" (1379-1380) implies serialisation but never says a refold
runs to completion as the writer's unit of work, nor whether a **partial** refolded tail can be
committed and observed (e.g. by the settlement projection) mid-refold. What *is* sound: the
**quiescent** final state is deterministic — the total order is a function of recorded
$(\text{exec},\text{door},\text{hash})$ triples, independent of admission order, and the refold
is idempotent (1269-1275, prop_refoldIdempotent) — and **replay is deterministic** because door
times are recorded facts. The gap is the *transient*: nothing forbids a permanently-interrupted
refold leaving an inconsistent tail. **Missing sentences:** (i) the single writer serialises
admission-and-refold, or refolds compose to the same quiescent closure and each triggered
refold **must complete its full tail** (a liveness obligation, backstopped by the overdue-watch
sweep 1386); (ii) only the quiescent closure is the specified state — partial-refold states are
not committed/observable.

### Scenario 2 — two interleaved late arrivals ($B$ earlier-in-execution than $A$, arriving during $A$'s refold) — DETERMINISTIC (for distinct/commuting execs); one residual

By thm:refold the final state is $\mathrm{fold}$ over $\mathrm{sort}_<$ of the closure of all
external arrivals — a pure function of the arrival **set** and their triples, not the admission
order. $B.\mathrm{exec}<A.\mathrm{exec}$ fixes $B$ before $A$ regardless of interleaving; $B$'s
refold re-folds from $B$'s (earlier) insertion point forward, **subsuming** $A$'s tail
(recomputing any firing $A$ synthesised, voiding any $B$ now suppresses), and $A$'s refold — if
still running or re-run — is **idempotent** over an already-correct tail. So the quiescent state
is order-independent. **The only non-determinism** is two **same-execution-instant
non-commuting** late arrivals, whose relative order would otherwise be set by arrival-assigned
door times: this is exactly **DL-01** — resolved by *declared precedence or fail-closed
refusal*, and an arrival-order door tiebreak there is the Goodhart outcome DL-01 refuses.
**Missing sentence:** an interleaving-convergence note — because the total order is
arrival-independent and the refold idempotent, any interleaving of multiple late arrivals
reaches one quiescent closure; the only residual is DL-01's same-instant non-commuting pair.
This note *depends on* Scenario-1's completion obligation, so land them together.

---

## Blockers
1. **A1** — flip ⊥ to top-of-instant (1234), echo in lemma ordering (1298/1305-1308) and
   snapshot key (1339). One coordinated net-zero edit; ⊥-before is a live correctness defect
   (lost firing or hidden re-pass). Co-signed with FORMALIS.
2. **Red-team 1+2** — add the single-writer refold-completion / interleaving-convergence
   paragraph; without it transient states and multi-arrival convergence are unspecified.

## Open (not clean)
3. **A2** — needs the six cut sites from STYLUS to diff against the lem:closure checklist above.

## Sound
4. **A3** — snapshot invalidation is well-defined and monotone under the A1 ruling; print the
   ⊥ direction at 1339 for clarity.
