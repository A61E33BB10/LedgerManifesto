# v16.1 Review — Round 1 Record

**Supervisor:** TuringAward. **Date:** 2026-07-17. **Draft under review:**
`Ledger_Spec_v16.1/ledger/ledger_v16_1.tex` (112pp = hard cap; pdflatex×2 clean).
**Standing reviewers this round:** FORMALIS, CONCORDIA, correctness-architect, STYLUS.
**Named but unavailable:** kleppmann (named in the brief; NOT available in this
environment — recorded here, not silently substituted; see SF-4).

TuringAward authors no spec content. This record opens with the supervision verdict,
then assigns lenses, then logs supervisor flags that must not be missed.

---

## 0. Supervision verdict

**State of the draft.** The v16.1 work items landed and cohere. The three times
(execution/monitor/door) are introduced concretely and threaded (ch4 §Order,
sec:bitemporal, sec:txexec). The total order is stated as a clean lexicographic triple
with each level's role argued (sec:totalorder). The reordering algorithm (a)–(f) is a
genuine procedure, not prose; `thm:refold` carries an explicit non-claim paragraph; the
mitigation table names conforming and non-conforming options with reasons; the covered-call
trace (sec:workflow) is worked end-to-end and matches the constitution's canonical case;
the substrate subsection draws a clean line between ledger facts and orchestration state
with a wipe-and-rebuild acceptance test; the property regime (ch:testability) pins P1/P3,
C-12.6 flagging, duplicate absorption, and the two bitemporal axes, each with a firing
witness. Terminology sweep is effectively complete: the only surviving "valid time" is the
change-log sentence that *documents* the rename (line 6944), which is correct, not a residual.

**Problem classification (my §2, for the record).** This is bitemporal event sourcing.
Safety: committed history is never rewritten and the refold flags *exactly* the changed
states. Liveness: every late arrival eventually refolds; every opened call resolves. Failure
model: crash-recovery, at-least-once emission, single writer at the door, adversary only at
the boundary (the TA-* assumptions). Consistency: deterministic replay of one serial total
order — the execution time is the primary logical clock, door time a Lamport-style
per-lineage tiebreaker, the hash a content-addressed final tiebreak. The reordering step is
an out-of-order insert into an append-only log with deterministic re-derivation of the tail.

**Biggest risks I see (ranked).**
1. **The theorem-vs-prose counterfactual (SF-1, central question of the round).**
   `thm:refold` says the refolded state "equals the state that would have obtained had `e`
   been folded in execution order **from the start**." There are two readings, and they
   diverge exactly on a watch that fired under the superseded tail. Reading A
   (counterfactual world): had `e` been timely, the Monitor might never have emitted the
   now-vacuous record-date firing — under this reading the theorem is **false**, because
   watch firings are clock/Monitor-driven, not fold outputs. Reading B (replay of the *same
   recorded event set* in execution order, the fired watch present as a recorded event whose
   *consequence* recomputes): the theorem is **true**. The prose in sec:totalorder
   ("Interactions") and sec:workflow ("Wednesday's record-date firing now finds zero shares")
   appears to use Reading B — but the theorem's own words ("from the start") read like A.
   This equivocation is the place the draft is most likely wrong. Pin it.
2. **Duplicate absorption on differing execution time (SF-2).** `prop_duplicateAbsorbed`
   absorbs a "duplicate cid (same OR **differing execTime**)". Two events sharing a
   cause-derived identifier but asserting *different* execution times are absorbed to one —
   yet TA-EXECUTION-TIME says a wrong execution time must be corrected by a *later event*,
   not silently swallowed. Possible latent conflict with C-2.7 ("identical under the
   cause-derived identifier is a duplicate"): is a different asserted execution time still
   "identical"? Candidate PARK if it cannot be resolved as a source-error-caught case.
3. **Totality antisymmetry across an authorised fork.** Door time is only *per-lineage*
   monotonic; a fork reissues door times. The claim "the hash is the only level that
   survives a fork" is also what antisymmetry needs when two distinct events share
   (exec, door). The proof must cover the cross-lineage case, not only the door-monotonicity
   failure case.

**Standing supervisor constraint.** The draft is **at the 112pp hard cap**. Every remedy a
reviewer proposes must be surgical and net-zero-or-negative in page delta (displace, don't
append). A finding whose only fix grows the document is itself incomplete until it names what
it displaces. Flag, do not silently absorb, any conflict between a fix and the cap.

**Non-negotiable, restated for all reviewers.** Not reordering is not an option. Any finding
that would weaken, cap, or make-optional the refold is a constitutional conflict to be parked
with exact amendment text (CLAUDE.md §1), never adopted as a "simplification."

---

## 1. Round-1 lens assignment

Each reviewer applies its own charter, but answers these numbered, targeted questions first.
Generic checklists are out of scope this round; these target where the draft is most likely wrong.

### FORMALIS — W2/W3 proof obligations discharged or honestly labelled
- **F1 (central).** Does `thm:refold`'s "the state that would have obtained had `e` been
  folded in execution order from the start" denote the **counterfactual world** (Reading A,
  false — watch firings are Monitor/clock-driven, not fold outputs) or **replay of the same
  recorded event set** (Reading B, true)? Confirm the theorem proves only B, and that the
  non-claim paragraph + sec:totalorder "Interactions" + sec:workflow all commit to B without
  a single sentence that reads as A. If the words admit A, name the exact sentence.
- **F2.** Is the total order a *strict total order* under the stated assumption? Prove
  antisymmetry in the **cross-lineage** case: after an authorised fork reissues door times,
  two distinct events may share (exec, door); totality then rests entirely on the hash. Does
  the proof (sec:totalorder, "Totality is proved under one named assumption…") actually cover
  this case, or only the within-lineage door-monotonicity-failure case?
- **F3.** Does `prop_totalOrderTotal` (P1) establish *trichotomy* over `admittedDistinct h`,
  or only irreflexivity+transitivity? Confirm post-absorption `admittedDistinct` is the
  correct carrier set — i.e. duplicate absorption is a *precondition* of totality, stated as
  such, not a claimed consequence of it.
- **F4.** "Refolding twice equals refolding once" (Analysis, Idempotence). Is this a proved
  corollary of `thm:refold` + determinism, or an independent assertion? If asserted, is it
  labelled as such per the constitution's "proved not asserted" rule?

### CONCORDIA — constitutional adherence + W6 terminology sweep
- **C1.** C-12.6 exactness. The constitution flags "every state the refold changes."
  `prop_reorderFlagged` uses `restatedExactlyChangedStates` (exactly — a state left identical
  carries **no** flag). Confirm the "exactly" neither over-narrows (dropping a state the
  constitution would flag) nor over-flags. Separately verify the explain-item attribution
  **triple** (reordering / causing event / lateness segment) and the lateness split (world =
  execution→monitor, ours = monitor→door) match C-12.6's wording word-for-word.
- **C2 (SF-2).** C-2.7: "An arrival identical under the cause-derived identifier is a
  duplicate to be absorbed." `prop_duplicateAbsorbed` absorbs same-cid **differing-execTime**
  arrivals. Is a differently-timed same-cid arrival "identical"? Reconcile with
  TA-EXECUTION-TIME ("corrected only by a later event, never edited at the door"). If
  irreconcilable, draft the exact PARK entry.
- **C3.** W6 residual. Confirm zero "valid time" / "knowledge time" in body prose *and*
  identifiers *and* type signatures (line 6944 is the licensed change-log exception).
  Confirm "knowledge time" is fully carried by monitor+door with no third-name drift
  ("arrival time," "transaction time," "wall-clock") anywhere.
- **C4 (SF-3).** DL-01. Verify the "conforming reading" in sec:txexec (door fail-closed
  refuses a non-commuting simultaneous pair with no declared precedence) does **not** itself
  narrow C-2.7's "refuse to reorder anything unless harmlessness is proved," and that the
  "Under decision" note in ch17 holds *exact* replacement text ready to park if the Panel
  rules otherwise (CLAUDE.md §1 — parking must carry exact text, not a promise of it).

### correctness-architect — refold determinism and replay
- **A1.** Detection step (a) compares `x` (new event's exec) with `X` (fold head's exec) "at
  admission." Is this comparison a **pure, record-derived** decision (both times read off the
  record) or a door-side read of a live clock? Replay must reproduce the identical
  detect/no-detect branch bit-for-bit. Confirm no clock leaks into the branch.
- **A2.** Snapshots "keyed by total-order position"; an interior insert at `p` "invalidates
  every snapshot ≥ p." An interior insert renumbers the whole tail's ordinal positions. Are
  snapshot keys stable **content-addresses** or renumberable **ordinals**? If ordinals, show
  the surviving snapshots < p keep valid keys under renumbering; if content-addresses, show
  "≥ p" is well-defined.
- **A3.** `prop_refoldEqualsOnTime` fires only when `insertsBeforeHead` and the tail is
  non-trivial. Confirm `genLateArrival` reaches tails of length ≥ 1 that contain a state the
  refold actually **changes** (else P3 passes vacuously on empty/unchanged tails), and that
  the global property genuinely globalises the per-unit `prop_lateInsertRecomputesTail`
  across **cross-unit** interactions in one refold.
- **A4.** Substrate acceptance test: "rebuild every orchestration from the refolded log =
  in-place re-read." Is "a timer that fired under the old order stays fired" backed by the
  firing being a **recorded log event** (so rebuild reproduces it) rather than substrate
  state (which rebuild would not reproduce)? Confirm the acceptance test is decidable from
  the log alone; flag if it is prose-only with no executable property.

### STYLUS — clear but precise, easy but not sloppy
- **S1.** `thm:refold` statement vs its non-claim paragraph. For the target undergraduate,
  the reader must see *exactly* what is and isn't proved without reconciling "equals the state
  that would have obtained" (strong) against "does not claim settled money is rewound"
  (limiting). If the two equivocate (they may — see F1), propose the single sentence that
  fixes the theorem's scope in place. Net page delta ≤ 0.
- **S2.** Repetition audit on the three-times roles. The role of each clock (execution
  carries meaning; door makes it total; hash is the fork-surviving final tiebreak) is told in
  ch4 §Order, sec:bitemporal, and sec:totalorder. State-once rule: flag any level whose role
  is *established* (not merely referred to) in more than one place.
- **S3.** Mitigation table "why" column. Confirm each row's reason is a **checkable
  proposition**, not a restatement of the verdict. E.g. is "the book stays knowingly wrong —
  the covered-call failure" grounded, or circular? Flag any circular row.
- **S4.** sec:substrate density. The paragraph packs long clause-chains ("its own clocks — an
  orchestration clock, an activity's start time, a history entry's recorded time — are none
  of the three times"). Flag sentences carrying more than one result; confirm no substrate
  synonym leaks in for the three named ledger times.

---

## 2. Supervisor flags (must not be missed)

- **SF-1 — the counterfactual equivocation.** The round's central question. Owned by F1 and
  A-line reviewers; I am elevating it so no reviewer treats `thm:refold` as clean prose. If
  the theorem's words admit Reading A, this is a MAJOR correctness defect in the strongest
  claim of the new material, fixable by a one-sentence scope tightening (STYLUS S1) — but it
  must be *decided*, not smoothed.
- **SF-2 — same-cid, differing execution time.** Potential C-2.7 / TA-EXECUTION-TIME
  conflict inside `prop_duplicateAbsorbed`. If unresolved, a PARK candidate with exact text,
  per the non-negotiable. CONCORDIA C2 owns the ruling; I will rule on any dispute.
- **SF-3 — DL-01 must not become a quiet narrowing.** The fail-closed door refusal survives
  (decision_log DL-01, 3-0). Watch that the "conforming reading" does not itself soften
  C-2.7. CONCORDIA C4.
- **SF-4 — kleppmann unavailable.** Named as a standing reviewer by the brief; not available
  in this environment. Not substituted. His natural lens (log-as-source-of-truth,
  bitemporality, the map-then-fold picture he authored in ch2) is partially covered by
  correctness-architect (replay) and CONCORDIA (bitemporal anchoring); the residual gap —
  an independent read of ch2/ch4's picture against the new global total order — is logged as
  uncovered this round and carried to the round-2 assignment.
- **SF-5 — the 112pp cap binds every remedy.** No fix ships that grows the document without
  naming its displacement. Recorded so no reviewer proposes an append-only fix.

**Dispute resolution.** Findings that collide (e.g. STYLUS wants a sentence cut that
FORMALIS needs for a proof) come to me; I rule and record the ruling in the round-2 record.
Convergence among reviewers is necessary, not sufficient — certifier signatures decide.

---

# ROUND-1 RULING (TuringAward, supervisor) — 2026-07-17

All four findings files read. This ruling (1) decides the F1×RT-1 interlock explicitly,
(2) produces the dependency-ordered ACCEPTED-CHANGES list for the drafting STYLUS, and
(3) answers every finding on the record. Roster note carried forward: kleppmann named but
unavailable; not substituted (SF-4).

## A. The F1 × RT-1 interlock — RULING: adopt Fix-A; the findings compose; NO park

**The two findings, precisely.** FORMALIS F1 attacks `thm:refold` from the *true→false*
side: a watch that fired under the superseded tail (the record-date firing on 100 shares)
persists as a recorded event, so the theorem's "state that would have obtained had `e` been
folded from the start" is false if read as the counterfactual world — the timely-world event
set S′ omits that firing. F1 narrows the theorem to *replay of the fixed recorded set S*
(Reading B) and disclaims the timely world. correctness-architect RT-1 attacks from the
*false→true* side, which F1/memo-D.5 never handled: a corrected close (79 ≤ 80) inserted at
Tuesday makes the barrier breached, but **no knock-in firing event exists on the record** —
the Monitor, running forward on the wrong close (81), never emitted one. A refold that only
recomputes consequences of *existing* events leaves the option **not knocked in** — the book
is *wrong*, not merely "different from a counterfactual." So F1's narrowing makes the theorem
true only by describing a refold that RT-1 shows is inadequate as a design.

**Do they compose under Fix-A? Yes — and the composition strengthens the theorem back.**
Fix-A makes a data-predicate/scheduled firing a *deterministic derivation of the refolded
prefix*: the refold re-evaluates every armed watch over the reordered prefix, **synthesises**
any firing the new order newly satisfies (at its record-derived execution position) and
**voids the consequence** of any firing the new order no longer satisfies (C-12.6), the
recorded firing event itself never deleted (C-12.5). Then the fold operates on a set that is
*closed under the firing-derivation operator*: (external arrivals) + (firings the ordered
prefix implies). That closure is a function of the ordered external arrivals alone, so the
refold's closure equals the timely world's closure — and therefore **refold fold-state =
timely fold-state** over the same external arrivals. F1's Reading A and Reading B *converge*.
I verified both directions on the spec's own threads: covered-call true→false (the scheduled
Wednesday firing fires in both paths, its consequence 0 in both — fold states match) and the
knock-in false→true (synthesised at Tuesday in the refold, emitted at Tuesday in the timely
world — fold states match; only provenance and external-effect *timing* differ, which the
residue non-claim already excludes).

**Does 968–970 license Fix-A? Yes, with the correct reading.** Line 967–970: "any party
holding the record and the clock recomputes which events should have been emitted, and when."
For a **data-predicate** watch the *condition met* is a function of the recorded observation
(the close print is on the record); the clock only fixes *monitor time* (provenance), which
is **null for an emitted firing** (1021–1023). The firing's execution time is a
**record-derived world fact** — "the breaching close's observation time" (1013). So "which
firings the prefix implies" is recomputable **from the record alone**, and the refold's
re-derivation **consults no clock** — clock confinement (the one thing the architecture
protects) is intact. 968–970 states this as an *audit* capability; Fix-A promotes it to an
*operational* step of the correction path. That promotion is **entailed**, not invented:
simulability (201–210) already requires the harness to *derive* firings from generated state
(a replayed price path must produce its own barrier firings), and C-13.2 makes verification
"re-running the map on recorded inputs." Fix-A applies that same operator on the refold path.

**Does Fix-A contradict the recorded-firing doctrine? No — recorded firings become
provenance.** The doctrine (958, 972–986, 1357–1358, C-12.5) makes a firing a recorded,
immutable acknowledgement that "the boundary observed condition X." Fix-A deletes nothing.
It separates two things the draft conflated: the recorded firing *event* (provenance: what
the boundary observed and when) from *which firings are in force* under the in-force
execution order (a projection, exactly like a balance). true→false: event stays, consequence
voided (C-12.6) — the draft already does this. false→true: no boundary observation exists,
so the synthesised firing takes **the correction event as its cause/provenance**, null
monitor time, record-derived execution time — structurally an ordinary emitted firing in the
reordering cascade. "A timer that fired under the old order stays fired" (1357) is honoured:
the *event* stays; only *in-force consequence* is recomputed. No constitutional concept is
added — null-monitor-time emitted firings already exist (1021–1023).

**Is a park required? No, and I examined this deliberately (not by omission).** Fix-A is not
a weakening — it is the **conforming reading of C-2.7**: C-2.7 makes meaning live in
execution order, so a refold that leaves a Tuesday barrier-breach unrecorded produces a book
knowingly wrong under execution order — the very "covered-call failure" the mitigation table
already rejects (1271). **Fix-B is the forbidden move**: it scopes the theorem to
reorder-invariant events and parks the state-dependent-firing residual, i.e. it drafts around
C-2.7 by relabelling the residue — CLAUDE.md §1's named failure. Fix-A contradicts no clause
and is entailed by C-2.7 + 968–970 + simulability, so it is adopted as a **drafting
clarification**, not an amendment. **One conditional carried to drafting (honours §1):** if
writing Fix-A shows the Picture chapter (C-3.x) must be *amended* to license a clock-free
firing-derivation inside the refold — I judge this unlikely, the entailment being clean — that
amendment **parks with exact text and is not drafted around.** Zero new parks this round is a
*considered* result: the one place a conflict could have surfaced was examined and found
constitutionally licensed. (The park-index *history* is non-empty — six closed — so the
mechanism is exercised, not dormant.)

**Consequence for F1's remedy.** F1's *finding* is ACCEPTED (the theorem is defective as
worded). F1's *supplied remedy is SUPERSEDED*: its "Scope of the counterfactual" remark
asserts "the timely-world set S′ differs from S, so its fold need not agree" — true only for
the Model-1 draft; under adopted Fix-A the fold *states* agree. **STYLUS must NOT paste F1's
disclaimer.** The composed theorem is stated in item 1 below.

## B. ACCEPTED-CHANGES LIST for the drafting STYLUS (dependency-ordered)

Page budget up front: the accepted set is **net-positive in lines** on current tally (the
executable-witness additions in items 4 and the Fix-A/C2 prose exceed STYLUS's S2 cuts).
The file is **AT the 112 cap**. Every item below is net-zero-or-negative *or paid for by
further ornament cuts*. The property-block witnesses (§3 mandate) are the least compressible;
prose additions must be maximally terse; STYLUS hunts additional ornament (S3's droppable
row-6 tail, mergeable table rows 3&4, the dense 1174–1178 hash paragraph) to reach net ≤ 0.
**If honest compression still exceeds 112 pp, that is a cap-vs-correctness conflict —
correctness wins (§7); escalate the residual page(s) to the coordinator, do not drop a
correctness item to fit.**

**1 — Fix-A + composed theorem + timely oracle + residue non-claim** [RT-1, F1, A3(iii), S1].
*The interlocked unit; draft first.*
 - Expand step (c) "Refold" (1204–1211): the refold re-evaluates every armed data-predicate
   and scheduled watch over the reordered prefix — a firing the new order newly satisfies is
   emitted at its record-derived execution position; a firing whose predicate no longer holds
   keeps its recorded event, its consequence voided (C-12.6); the clock is not consulted.
 - Restate `thm:refold` (1237–1243) as **fold-state equivalence to the timely fold of the
   same external arrivals** (firing-closure re-derived), NOT F1's disclaimed set-replay. Move
   the proof OUT of the theorem environment into a following remark (FORMALIS "outside the
   lenses"). Keep the equality scoped to fold state (balances + three homes).
 - Add the residue non-claim as STYLUS S1's single sentence (round1_stylus.md §S1) — settled
   money, emitted external effects, already-fired notifications are not rewound but discharged
   as C-12.6 residue. This is the honest boundary; it composes with Fix-A.
 - Add one sentence to "Interactions" (1278–1289): recorded firings are retained as
   provenance; a firing the reordered order newly satisfies is synthesised with the correction
   as its cause and null monitor time.
 - Property block (ch:testability, 6106–6110): replace `prop_refoldEqualsOnTime`
   (permutation-invariance-blind) with `prop_refoldEqualsTimely` — full-pipeline timely oracle
   with `late` present from the start, Monitor deriving firings (round1_correctness.md A3(iii)).

**2 — Cross-lineage antisymmetry: carrier restriction + 1176–1178 correction** [F2].
 - Insert the single-lineage carrier restriction after 1168 (LaTeX supplied, round1_formalis.md F2).
 - Replace the misleading 1176–1178 "only level that survives a fork" clause with the supplied
   correction (hash recomputes the *new* lineage's order; across lineages the twins share it,
   so a fork's two lineages are never ordered against each other).

**3 — Snapshot re-key by stable triple** [A2].
 - Rewrite 1257–1259: key snapshots by the (exec, door, hash) triple `T_last` of the last
   folded event; restate invalidation as `T_last ≥ T_e` in the stable key space (supplied,
   round1_correctness.md A2). Fix table row 1273 reason to "any *positional* key is stale under
   interior insertion; the conforming key is the stable last-event triple."

**4 — Property witnesses** [F4, A3(i), A3(ii)]. *Least compressible; §3 requires firing.*
 - Add `prop_refoldIdempotent` + `_fires` (round1_formalis.md F4); thread a pointer to memo
   P4(iii) at the 1232–1233 gloss so idempotence is not bare assertion.
 - Add `prop_refoldChangesState_fires` — footprint-overlap coverage so a *state-changing*
   refold is witnessed, not just a non-empty tail (A3(i)).
 - Add `prop_reorderCrossUnit_fires` — the restated set spans ≥ 2 units/agreements (A3(ii)).

**5 — Absorption-vs-contest seam in prose** [C2].
 - Add the supplied prose after 1168: absorption is by identifier alone whatever execution
   time the arrival asserts; a genuine execution-time contest is a distinct C-12.4 correction
   event (own cause-derived identifier), never absorbed, re-inserted at its true position.
   Absorption drops a duplicate, never a contest. (Complementary to Fix-A: the false→true
   correction of RT-1 enters as exactly this distinct event.) Optional one-clause echo at the
   TA-EXECUTION-TIME residual 6725–6727.

**6 — Detection classification pinned** [A1].
 - Add the half-sentence at 1198 pinning the `x ≥ X` fast-path's *classification correctness*
   (not clock-freeness, which is already sound) to `prop_doorTimeMonotonic`.

**7 — Substrate acceptance test: quiescence + right pair** [A4]. *Merge with item 8 — same paragraph.*
 - State the wipe-and-rebuild test holds "at quiescence" (after the re-read deposits its fresh
   arming/firing acknowledgements). Strengthen "rebuild == in-place re-read" to
   **rebuild == timely** (the item-1 oracle), so an absent derived firing (RT-1) cannot pass.

**8 — Substrate de-density + Temporal de-leak** [S4]. *DL-02 compliance.*
 - Replace 1343–1346 with STYLUS's supplied sentence (splits the four-result sentence AND
   removes the Temporal nouns "activity"/"history entry"; net −1). Optional line-neutral split
   of 1341–1342.

**9 — Ornament cuts (page-budget payers)** [S2]. *Apply to fund items 1/4/5.*
 - Cut the duplicated monitor-time role at 381–387 to STYLUS's replacement (−1/−2).
 - Drop the "; door time never sets meaning" clause at 1116 (owned by 1027) (−0.5).
 - Trim the execution-time-stability gloss at 1249–1251 to a bare TA-EXECUTION-TIME reference (−1).

**10 — Line-neutral corrections.**
 - 1219 "explain **line**" → "explain **item**" (S2/Additional; the definer is the outlier).
 - Covered-call trace (1330): add "(C-12.6)" after "Three things are born here" to match the
   C-12.4 citation on the open item (STYLUS Additional).

## C. Rejected items (one line each)

- **Fix-B** (RT-1 alternative) — REJECTED: parks a state-dependent-firing residual and leaves
  the book knowingly wrong for barrier/threshold watches under late correction; the §1
  drafting-around Fix-A forecloses. Fix-A is required by C-2.7.
- **F1's "Scope of the counterfactual" disclaimer, as worded** — REJECTED/superseded: its
  "timely-world fold need not agree" is false under adopted Fix-A; use the item-1 composed
  statement instead. (The F1 *finding* is accepted.)

## D. Every finding answered on the record

| Finding | Verdict | Disposition |
|---|---|---|
| F1 thm:refold equivocation | DEFECT (accepted) | remedy SUPERSEDED by Fix-A composition — item 1 |
| F2 cross-lineage antisymmetry | DEFECT (accepted) | item 2 (carrier restriction + 1176–1178) |
| F3 trichotomy/carrier | SOUND | no change; F2's restriction discharges the condition |
| F4 refold idempotence untested | DEFECT (accepted) | item 4 (`prop_refoldIdempotent` + memo pointer) |
| C1 C-12.6 exactness | CLEAN | no change |
| C2 absorption vs TA-EXECUTION-TIME | FINDING (accepted) | item 5 (prose seam) — 0 parks |
| C3 W6 terminology sweep | CLEAN | no change (as-known-at note = OBSERVATION only) |
| C4 DL-01 no narrowing | CLEAN | no change; DL-01 stays "under decision" with park-ready text |
| A1 detection branch | SOUND (one dependency) | item 6 (pin classification to door-monotonicity) |
| A2 snapshot ordinal keys | DEFECT (accepted) | item 3 (re-key by stable triple) |
| A3(i) vacuous firing | DEFECT (accepted) | item 4 (`prop_refoldChangesState_fires`) |
| A3(ii) cross-unit flag | DEFECT (accepted) | item 4 (`prop_reorderCrossUnit_fires`) |
| A3(iii) permutation-blind oracle | DEFECT (accepted) | item 1 (`prop_refoldEqualsTimely`) |
| A4 acceptance test ill-posed | DEFECT (accepted) | item 7 (quiescence + rebuild==timely) |
| RT-1 firing synthesis | BLOCKER (accepted) | Fix-A adopted — items 1/7; Fix-B rejected |
| S1 scope sentence | delivered | item 1 (residue non-claim) |
| S2 four re-establishments | accepted | item 9 (page-budget payers) |
| S3 mitigation circularity | CLEAN | no change |
| S4 density + Temporal leak (1345) | accepted | items 7/8 (merge; DL-02 de-leak) |
| S/Additional: explain line→item; C-12.6 citation | accepted | item 10 |

**Accepted: 14 findings actioned (items 1–10). Rejected: 2 (Fix-B; F1's disclaimer wording).
Parks: 0 (Fix-A constitutionally licensed; one conditional park flagged for drafting).
Escalated: none new — DL-01 remains before the Panel; a cap-vs-correctness page overflow, if
it survives compression, escalates to the coordinator with correctness paramount.**

**Dispute-of-record for the certifier chain (round 5):** the Fix-A adoption is a *model
commitment* (firing = derivation-with-provenance, not free input). CONCORDIA and FORMALIS
must sign specifically on (i) Fix-A contradicts no constitutional clause, and (ii) the
composed `thm:refold` is proved, not asserted. My ruling adopts; their signatures decide.
