# Memo W2 — Proofs: total order, replay, reordering, idempotence

FORMALIS (Leroy chair; Coquand, Huet, Paulin-Mohring, de Moura, Avigad).
W2 proof author, v16.1 pass (Constitution v1.4). This memo *proves*; it does not edit the
spec. STYLUS threads the settled results. Anything unproved is labelled Assumption / trust
assumption / implementation obligation, never Theorem.

Basis: C-2.7 (amended: Order, three times, total order, duplicate absorption), C-2.8
(contract purity, clock confinement, recorded seed), C-12.3/4/5/6, TA-EXECUTION-TIME.
Spec anchors (v16.0): fold / map-then-fold one-at-a-time (lines 316–422); cause-derived
identifier + idempotence (1032–1082, 4807); single-writer strict monotonicity (1086);
determinism of every arrow (4801); clock confinement (410, 428); replay/time-travel
(4902–4960); authorised fork (4977–5001); property regime + firing floor (5286–5300, 5892).

## 0. Model (used throughout)

**Three times (C-2.7).** Each event `e` records: `execTime e` — the world's time, asserted
by the source, enforceable in court, never edited at the door (TA-EXECUTION-TIME, P5);
`monitorTime e` — provenance only, *orders nothing*, in no proof here; `doorTime e` — the
position at which the single writer admitted `e`. Each event also carries a content hash
`hash e` (immutable-log hash, line 698).

**Domain fixed by absorption.** `cid e` is the cause-derived identifier. C-2.7: "An arrival
identical under the cause-derived identifier is a duplicate to be absorbed, never a neighbour
to be ordered." Let `S` = the admitted events after absorption — one representative per
distinct `cid`. `S` is a *set* keyed by `cid`, not a multiset; every proof about the order
and the fold ranges over `S`, which never contains two copies of one cause.

**Fold (lines 402–414).** With `contract:(Event,Ledger)->Transaction`,
`apply:(Transaction,Ledger)->Ledger`:
```
step (L,e)    = apply (contract (e,L), L)     -- map one event, then fold it
foldFrom L0 σ = foldl step L0 σ               -- σ an event sequence, L0 the fixed initial ledger
```
"Ledger state" means the tuple `(balances, ProductTerms, UnitStatus, PositionState)` — the
balances and the three homes (ch06); nothing off the record.

## P1. The total order

**Definition.** For `e1,e2 ∈ S`: `key e = (execTime e, doorTime e, hash e)` and
`e1 < e2 :≡ key e1 <_lex key e2`, lexicographic — compare `execTime`; on a tie `doorTime`;
on a tie `hash`. Each component set carries its own strict total order (`execTime`,
`doorTime` by timestamp/position; `hash` by its fixed-width bytes). We prove `<` is a strict
total order on `S`: irreflexive, transitive, trichotomous. Antisymmetry is trichotomy's
contrapositive, proved with it.

**Lemma 1 (key injectivity).** `e ↦ key e` is injective on `S` if *either* (DM) `doorTime`
is injective on `S`, *or* (CR) `hash` is injective on `S`.
*Proof.* If `e1≠e2` yet `key e1=key e2`, all three components agree. Under (DM) equal
`doorTime` on distinct events contradicts injectivity; under (CR) equal `hash` does. Either
alone refutes the supposition. ∎

- **(DM) — door time.** The single writer "presents to the log a strictly monotonic sequence
  of committed transactions" (1086), so `doorTime` is strictly increasing in admission order,
  hence injective. This is the ordinary case, but it is an **implementation obligation**
  (tested as `prop_doorTimeMonotonic`, P5), not a typed guarantee: a coarse clock or writer
  bug could stamp two admissions equally. So totality is **not** rested on (DM).
- **(CR) — hash.** `hash` is a fixed collision-resistant hash of event content; on the finite
  domain of distinct well-formed events it is assumed injective — **ASSUMPTION-CR**, the same
  collision-resistance the cause-derived identifier already assumes (1070–1073). It holds
  independently of the writer.

We prove totality from **(CR)**; (DM) re-enters below to answer the ties.

**Lemma 2 (lex of strict total orders is a strict total order).** If each component order is
strict-total and `key` is injective, `<` is a strict total order on `S`.
*Proof.* *Irreflexive:* `key e` vs itself compares equal componentwise, so no component is
strictly less; `e<e` false. *Transitive:* let `e1<e2`, `e2<e3`; let `i,j` be the first
differing coordinates of the two pairs, `m=min(i,j)`. Coordinates before `m` agree across all
three. At `m`: if `m=i<j` then `key e2=key e3` at `m` and `key e1[m]<key e2[m]=key e3[m]`; if
`m=j<i`, symmetric; if `m=i=j` then `key e1[m]<key e2[m]<key e3[m]`, transitive in the
component. So the first difference of `(1,3)` puts `e1` below `e3`: `e1<e3`. *Trichotomy:* for
distinct `e1,e2`, Lemma 1 (via CR) gives `key e1≠key e2`, so a first differing coordinate `i`
exists; its component order is total, deciding exactly one of `key e1[i]<key e2[i]`,
`key e2[i]<key e1[i]`, hence exactly one of `e1<e2`, `e2<e1` (a lex comparison settles at the
first difference). Antisymmetry follows: not both. ∎

**Theorem P1.** Under ASSUMPTION-CR, `<` is a deterministic strict total order on `S`,
computable by any party from the record alone.
*Proof.* Lemma 2, with `key` injective by Lemma 1 from (CR). Every component of `key` is
recorded and `<_lex` is a fixed function of them, so two parties reading one record compute
one order. ∎

**The three ties, honestly.**
- **(i) Equal `execTime` — real.** Two legs of one package trade share a world-instant; this
  is *why* level two exists. `doorTime` breaks it: the legs were admitted at distinct
  positions.
- **(ii) Equal `execTime` and `doorTime` — impossible for distinct events under (DM).**
  Door time is strictly monotonic per admission, so distinct events never share it.
  **Door time therefore already breaks every tie among distinct events; `(execTime,doorTime)`
  is injective on `S`.**
- **(iii) The hash level — reachability, stated plainly.** By (ii), under (DM) the lex
  comparison of distinct events is *always* decided at or before level two: **level three is
  never consulted — provably unreachable for distinct events whenever door-time monotonicity
  holds.** So the mandated third level is **redundant-but-harmless under (DM)**. It is not
  ornament, because it does two things (DM) cannot:
  - **(a) Unconditional totality (load-bearing).** (DM) is only tested. If violated — a coarse
    door clock stamps two admissions equally — then `(execTime,doorTime)` ties for distinct
    events and, without level three, the order degenerates to a preorder: the two become
    incomparable, the fold order between them undefined and non-deterministic. Under
    ASSUMPTION-CR the triple stays injective (Lemma 1 via CR) regardless of the writer, so the
    order stays total. This is why P1 is proved from (CR), not (DM): totality must not rest on
    a merely-tested obligation. (DM) makes the hash *unreachable in practice*; the hash makes
    the order *total in principle*. Complementary, not redundant.
  - **(b) Content-addressable stability under rebuild (C-12.5).** An authorised fork "replays
    to a chosen point and rebuilds forward on a new lineage" (4977–4995), re-admitting events
    with **fresh door times**: `doorTime` is writer-assigned and lineage-variant, while
    `execTime` (world-asserted) and `hash` (content-derived) are lineage-invariant. A party
    wanting an order recomputable from event content alone must break every residual tie by the
    content hash — the only level surviving door-time reassignment.

  A distinct-event collision at level three needs `execTime`, `doorTime`, *and* `hash` all
  equal — a hash collision, excluded by ASSUMPTION-CR (named, not waved: same as line 1070). A
  triple-collision requires *both* (DM) and ASSUMPTION-CR to fail at once: defence in depth.

**Verdict P1: PROVED-UNDER-ASSUMPTION(ASSUMPTION-CR).** Hash tiebreak: redundant-but-harmless
for distinct events under door-time monotonicity (provably unreachable there); its
non-redundant work is unconditional totality (a) and rebuild stability (b).

## P2. Replay determinism

**Theorem P2.** Let `σ=[e_1,…,e_n]` be `S` in the order `<`. Two runs of `foldFrom L0 σ`
(same `L0`, same `σ`) give the same ledger state at every prefix `k∈{0,…,n}`.

**Hypotheses (cited, not new).** **H1 contract purity** — `contract` is a pure function of its
two recorded arguments, reading no wall clock and no off-record store (C-2.8; lines 4801,
410). **H2 apply determinism** — `apply` is pure in its two arguments (4801; atomic 4786).
**H3 clock confinement** — the clock is read only by `watch`, whose output is itself recorded
(428–433); no arrow *inside the fold* reads it. **H4 recorded seed** — the one non-record
input is the recorded seed (C-2.8), so any contract randomness is a pure function of recorded
data, covered by H1.

**Proof (induction over `<`).** Let `L_k,L'_k` be the prefix states of the two runs. *Base*
`k=0`: `L_0=L'_0=L0`. *Step*: assume `L_{k-1}=L'_{k-1}`; both process the same `e_k`. Then
`L_k=apply(contract(e_k,L_{k-1}),L_{k-1})` and `L'_k=apply(contract(e_k,L'_{k-1}),L'_{k-1})`.
By IH the ledgers are equal; by H1 (with H3,H4 removing hidden inputs) the two `contract`
calls return one transaction; by H2 `apply` of equal transactions to equal ledgers gives
equal ledgers. So `L_k=L'_k`; by induction, agreement at every `k`. ∎

**Remark.** Spec `thm:replay` (4945) re-folds committed transactions without re-firing
contracts; P2 is stronger — it re-fires the contracts (full map-then-fold) and still lands
deterministically, because H1–H4 make the map itself pure. The transaction-only fold is the
special case with `contract` skipped.

**Verdict P2: PROVED-UNDER-ASSUMPTION(H1–H4 = C-2.8 machinery).** Nothing beyond the spec's
own stated properties.

## P3. Reordering correctness

**Setup.** After a late arrival `L` (small `execTime`, large `doorTime`) is absorbed into `S`,
the C-2.7 reordering step inserts `L` at its `<`-position and refolds the tail. Write
`reorder(S) = foldFrom L0 (sort_< S)`, with `sort_< S` listing `S` in the order `<`.

**Theorem P3.** The ledger state after reordering equals `foldFrom L0 (sort_< S)` — the state
of folding *all* of `S` in `<`-position from the start. Equivalently: **the fold state is a
function of the set `S` and the order `<` alone, independent of arrival order at the door.**
*State quantified over:* balances and the three homes (§0).
*NOT claimed* (C-2.7/C-12.6 residue): emitted external effects, already-settled money, and
already-fired notifications are **not** rewound. Where the refold changes a settled quantity,
C-12.6 governs — the insertion is flagged, every changed state is flagged, the difference is a
named explain item, and money moves back only as an authorised compensating transaction under
C-12.4. P3 is a theorem about the *fold state*; the world outside the fold is C-12.6's
flags/explains/open items and lies outside it.

**Hypothesis (crux).** *Per-event purity of `step`* (H1–H4): `step(L,e)` reads only its two
arguments — the current folded ledger and the one event — nothing else (not arrival order, not
the clock, not any other event). This is "map one event, fold it, only then map the next"
(C-2.7; lines 322–333).

**Proof.**
1. *The fold is a pure function of its input sequence* — P2's induction with both runs on one
   sequence: equal sequences give equal states.
2. *Reordering yields `sort_< S`.* It re-places `L` at rank `r=|{e∈S : e<L}|` and refolds from
   `r` onward; the prefix below `r` is untouched (those events are `<`-below `L`, relative
   order unchanged) and equals the prefix of `sort_< S`, the refolded suffix reproduces the
   suffix of `sort_< S`. The output sequence is `S` arranged by `<`.
3. *Why the tail is re-*mapped*, not re-read.* Each tail event's `contract(e,L_e)` runs
   against the folded state `L_e` of all `<`-earlier events, which now includes `L` — the
   covered-call case: with Tuesday's assignment folded before Wednesday's record date,
   `contract` reads a zero holding and proposes no dividend. Per-event purity makes this
   sound: each tail transaction is a pure function of its new predecessor state — forced and
   deterministic, not a guess.
4. *Conclusion.* By 2 the output is `sort_< S`; by 1 its fold is the single value
   `foldFrom L0 (sort_< S)`. Any admission order of the same `S` sorts to the same sequence and
   folds to the same state. ∎

**On "execution-time position" (door-time tiebreak, not hidden).** `L`'s rank uses its
*recorded* key with its actual late `doorTime`, which matters only against events sharing
`L`'s exact `execTime` (P1-ii). If none does, `L`'s rank is fixed by `execTime` alone and "the
state as if `L` had arrived on time" is literally exact; if one does, `doorTime` decides and
"execution-time position" means precisely "the `<`-rank" (`execTime`, then `doorTime`, then
`hash`). The theorem is exact under that definition and claims nothing stronger.

**Verdict P3: PROVED-UNDER-ASSUMPTION(per-event purity of `step` = H1–H4).** The settled-money
/ effects / notifications boundary is outside the theorem, governed by C-12.6.

## P4. Idempotence

**(i) Duplicate absorption is a no-op.** An arrival `e'` with `cid e'` already naming some
`e∈S` is a duplicate: the door's idempotence key commits a proposal whose identifier is
already on the log zero further times (C-12.3; lines 1050, 4807–4812), and C-2.7 absorbs it at
the event level. Absorption maps `S∪{e'}` back to `S`, so neither `S`, nor `<`, nor
`foldFrom L0 (sort_< S)` changes. The duplicate costs timeliness only (1062). ∎

**(ii) A duplicate with a DIFFERENT asserted `execTime` — still absorbed; the differing time
is not an ordering fact.** Let `cid e'=cid e` but `execTime e'≠execTime e`. Since `cid` is the
absorption key, `e'` is absorbed by (i): it does **not** enter `S` as a second orderable event,
so its time never reaches the order. That differing time is a *contest of the recorded
assertion*, not a reorder. C-2.7 fixes execution time as "asserted by its source, contestable
only in the world and corrected only by a later event, never edited at the door"
(TA-EXECUTION-TIME). Hence: the door does not edit `e`'s `execTime` to match `e'` (that is
editing at the door, forbidden — `e`'s assertion stands); and a genuine change of the world's
time arrives as a **later correction event** — a *distinct* cause, hence distinct `cid`,
admitted forward under C-12.4 — which enters `S` on its own and folds in the open. A
same-`cid` arrival with a different time changes nothing; a real change of the world's time is
a new event, not a mutation of the old. ∎

**(iii) Refold idempotence — reordering twice is a no-op.** Let `R: S ↦ foldFrom L0 (sort_< S)`.
*Proof.* `sort_<` is idempotent — `sort_<(sort_< S)=sort_< S`, since sorting an already
`<`-ordered sequence returns it (`<` total by P1, sorted order unique). A second reordering
finds `L` already in `S` (a fresh arrival of `L` is absorbed by (i), adding no element), so it
sorts the same `S` and, by P2, folds to the identical state. `R∘R=R`. ∎

**Verdict P4: PROVED** (i, iii); (i)–(ii) rely on `cid` distinguishing distinct causes, whose
injectivity already rests on ASSUMPTION-CR (1070) — **PROVED-UNDER-ASSUMPTION(ASSUMPTION-CR)**,
no new assumption.

## P5. What is NOT a theorem

- **TA-EXECUTION-TIME — trust assumption.** That asserted execution times are legally
  enforceable, court-recognised facts of the world (contestable only in the world, corrected
  only by a later event) is a **trust assumption** about the boundary, not a theorem. The
  proofs *use* it (P1 level one; P4-ii "no edit at the door") but cannot establish it; it sits
  beside TA-ARRIVAL. Labelled Assumption, never Theorem.
- **Door-time strict monotonicity ((DM)) — implementation obligation.** That the single writer
  stamps distinct admissions with strictly increasing door times is a property of the
  *implementation*, discharged by property test, not an axiom. P1's totality does not depend on
  it (proved from ASSUMPTION-CR); (DM) is what makes the hash level unreachable in practice. A
  bug or coarse clock can violate it, so it is *tested*, not assumed.

**Executable properties ch15 must gain.** Each carries a firing witness `prop_*_fires`
asserting its precondition at `≥1%` of histories under `checkCoverage` (standing floor,
5297–5300): a precondition that never generates witnesses nothing and is a failed run, not a
green.
```
-- P1: strict total order on the post-absorption event set.
prop_totalOrderTotal h = totalStrictOrder (lt keyOf) (admittedDistinct h)
prop_totalOrderTotal_fires = checkCoverage $ cover 1.0 hasExecTimeTie
  "distinct events share execTime (level-2 tiebreak exercised)" genPackageHistory
-- gen MUST also inject door-time collisions, or level 3 (the hash) is never witnessed.

-- P2: two full map-then-fold replays of one ordered log agree at every prefix.
prop_replayDeterministic h = scanl step L0 es === scanl step L0 es where es = sortByOrder (admittedDistinct h)
prop_replayDeterministic_fires = checkCoverage $ cover 1.0 hasStatefulContract
  "a contract read the folded ledger (map depends on prior fold)" genHistory

-- P3: refold-after-insert equals fold-in-execution-order (lifts prop_lateInsertRecomputesTail, 5892).
prop_refoldEqualsOnTime late h = isBackDated late ==>
  foldLedger (insertAtOrder late h) === foldLedger (sortByOrder (late : events h))
prop_refoldEqualsOnTime_fires = checkCoverage $ cover 1.0 insertsBeforeHead
  "late execTime precedes an already-folded event (tail actually refolds)" genLateArrival

-- P4-i/ii: a duplicate cid (same OR differing asserted execTime) leaves state unchanged.
prop_duplicateAbsorbed dup h = sameCid dup h ==> foldLedger (admit dup h) === foldLedger h
prop_duplicateAbsorbed_fires = checkCoverage $ cover 1.0 dupWithDifferentTime
  "duplicate bears a different asserted execTime (contest, not reorder)" genDuplicate

-- P5/(DM): single writer stamps strictly increasing door times (the obligation, tested).
prop_doorTimeMonotonic h = strictlyIncreasing (map doorTime (admissionsInOrder h))
prop_doorTimeMonotonic_fires = checkCoverage $ cover 1.0 hasConcurrentArrivals
  "two arrivals contend at the door (serialisation exercised)" genConcurrentArrivals
```
Generator discipline: `prop_totalOrderTotal` must inject door-time collisions (else the hash
tiebreak — the gap P1(a) covers — is never witnessed); `prop_refoldEqualsOnTime` must place
`late` strictly before an already-folded event (else the tail never refolds, vacuous pass);
`prop_duplicateAbsorbed` must draw the different-time duplicate (P4-ii), not only the identical
one.

**Verdict P5: NOT-A-THEOREM** — TA-EXECUTION-TIME (trust assumption) and door-time monotonicity
(implementation obligation, property-tested). Both labelled; neither dressed as proved.
