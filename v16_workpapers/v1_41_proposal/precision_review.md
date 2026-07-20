# FORMALIS — Precision Review of the TIME-ENVELOPE language (Constitution v1.4)
**For the v1.41 clarifying proposal.** v1.41 may only state more plainly what the text already
means. Anything that decides an undecided question, narrows a guarantee, or adds a normative
commitment is **MATERIAL**, excluded, and listed for the owner. The v1.4 file is never edited;
this is input to a separate proposal document.

Sources: C-2.7 three-times paragraph (177-194) + covered-call (196-212); C-12.6 (864-873);
ordering paragraph (166-175). Evidence: DL-01 (decision_log.md), round3_record.md +
round3_formalis.md (⊥/⊤), memo_w3_reordering.md §A.

The test I apply: a fix is CLARIFYING only if the text, with its own determinism and
recomputability commitments, already **entails** the reading and no other coherent reading
survives. If two coherent readings survive and the fix picks one, it is MATERIAL — a total
order's tiebreak may not be settled by prose.

---

## CLARIFYING items (safe for v1.41)

**C1 — "the monitor time at which the Event Monitor observed it at the boundary" (180-181): absent for emitted events.**
- *Misreading:* a reader takes "An event bears three times" (177) as universal and infers
  every event — including a watch firing the Monitor *emits* from the record — carries a
  monitor time, presumably the Monitor's wall-clock read at emission.
- *Verdict: CLARIFYING.* The phrase is a definite description; it denotes *the time of a
  boundary observation*. An event the Monitor emits has **no boundary observation**, so the
  description fails to denote — "no monitor time" is analytic, not additive. The only rival
  reading (populate it with an emission-instant wall-clock read) is foreclosed by the same
  paragraph: the order must be "computable by any party from the record alone" (188-189) and
  "the monitor's clock orders nothing: it is provenance" (190-191). A non-recomputable
  wall-clock read on the record would break both. The lateness split for an internally-born
  event then has a zero world's-segment (execution=monitor), consistent with absence.
- *Residual (owner, not a blocker):* IF the owner intends emitted events to carry a
  **recorded, deterministic** Monitor-side emission stamp, calling monitor time "absent"
  becomes MATERIAL. Nothing in v1.4 supports populating it, so I rule CLARIFYING.
- *v1.41 target:* say monitor time is *the boundary observation, absent when the Event
  Monitor emits the event rather than observing it.* State absence; do not mandate a
  representation (a NULL field is §10 implementation, out of scope).

**C2 — "An event bears three times" (177): universality is false for the monitor slot.**
- *Misreading:* every event has all three, no exceptions.
- *Verdict: CLARIFYING for the monitor slot* (C1): read as *bears up to three times* —
  execution always; door on admission; monitor only when observed at the boundary. (The
  **door** slot's universality is a separate, MATERIAL question — see M1.)

**C3 — "the refusal to reorder anything unless harmlessness is proved" (174-175) vs. the fold reorders late arrivals (184-186).**
- *Misreading:* the two sentences contradict — one forbids all reordering, the next says a
  late arrival "takes its place among" already-folded events and "everything after it is
  refolded," which *is* reordering.
- *Verdict: CLARIFYING.* Internal consistency forces the scope: "reorder anything" governs
  the **arrival record / hash chain** (never rewritten, C-12.5), while the **fold order** is
  *by definition* execution order, so re-sequencing the fold to honour a late arrival's
  execution time is not the reorder the refusal forbids. Any other reading is self-
  contradictory within C-2.7. State the scope explicitly; state nothing new.

**C4 — "Events are processed as they arrive at the door ... the fold's order is execution order" (183-184): two distinct orders.**
- *Misreading:* the fold consumes events in arrival order (contradicting "fold's order is
  execution order").
- *Verdict: CLARIFYING.* Admission/processing order (arrival, door) and fold order
  (execution) are two orders over one record; the text already asserts both. Name the
  distinction (arrival record vs. fold order) once.

**C5 — "resting only on the time the world would enforce and the time the door assigns" (189-190) vs. "then the event's hash" (188).**
- *Misreading:* the hash both is and is not part of the order — 188 makes it level 3, 189-190
  omits it.
- *Verdict: CLARIFYING.* Reconcile: within a lineage (exec, door) already decides; the hash
  is the content-derived **backstop** for totality where door times can coincide (across an
  authorised fork, C-12.5). "Rests on execution and door" is the normal case; the hash never
  changes an outcome those two already decide. Say so.

**C6 — "deterministic, total, and computable by any party from the record alone" (188-189): two silent premises.**
- *Misreading:* totality and recomputability are unconditional.
- *Verdict: CLARIFYING* to name what they rest on: (a) **no hash collision** on the well-formed
  event domain (else the level-3 backstop ties and the order is not total); (b) "the record
  alone" must include events **derived deterministically** from it (a synthesised firing is a
  function of the fold, not a literal arrival). Both are already relied on. (Asserting a
  *specific* hash algorithm would be material — do not.)

**C7 — the lateness split: C-2.7 "splits into the world's delay, execution to monitor, AND ours, monitor to door" (191-192) vs. C-12.6 "the world's ... OR ours" (869-870).**
- *Misreading:* the connective mismatch invites reading C-12.6 as "attribute the lateness to
  **one** segment," when C-2.7 decomposes it into **both**.
- *Verdict: CLARIFYING.* The covered-call explain names both segments at once ("world's =
  Tue→observation, ours = observation→door", memo C.e); the intent is a decomposition, not a
  choice. Harmonise C-12.6's "or" to the C-2.7 "and/each" so the explain attributes across
  **both** segments. Pure wording; no normative change.

**C8 — the lateness split presumes a monitor time exists (191-192, 869-870).**
- *Misreading:* every late arrival's lateness has two non-trivial segments.
- *Verdict: CLARIFYING.* For an emitted event (C1) monitor time is absent, so the world's
  segment (execution→monitor) is zero and the whole lateness is "ours." State that the
  two-segment split applies to a boundary-observed arrival. (Consistent with C1; nothing new.)

**C9 — "corrected only by a later event, never edited at the door" (179-180): "later" in which order?**
- *Misreading:* "later" reads as later execution time — but a correction may assert an
  *earlier* execution time than the event it fixes (indeed the covered-call assignment does).
- *Verdict: CLARIFYING.* "Later" means **later-arriving** (admitted afterwards, later in door
  order); the correction's own execution time is unconstrained. Pin the axis.

**C10 — "corrected" (179) vs. "contestable" (179) vs. C-12.6 "compensating transaction under C-12.4" (872-873): three words, distinct operations.**
- *Misreading:* correcting a wrong execution **fact** and moving **money** to undo a settled
  delta are the same act.
- *Verdict: CLARIFYING* to separate the vocabulary: a wrong execution time is a **fact**
  corrected by a later forward event (never a door edit); a settled money delta a refold
  exposes is an **open item** discharged only by an authorised **compensating transaction**
  (C-12.4). Distinct mechanisms, distinct words; state that they are distinct. *(Residual →
  M4: whether a fact-correction itself needs C-12.4-grade authorisation is unanswered.)*

**C11 — C-12.6 "A late arrival that takes its place before the head" (864): "the head" is undefined.**
- *Misreading:* head of the arrival chain? the fold? C-2.7 (184-186) describes the same event
  but never names "the head."
- *Verdict: CLARIFYING.* Define once: **the head** is the greatest event in the total (fold)
  order — the current fold frontier. Definition-before-use; no new content.

**C12 — covered-call "any dividend already received moves back only as an authorised compensating transaction" (210-211): "moves back".**
- *Misreading:* "moves back" reads as a claw-back / reversal of the original receipt.
- *Verdict: CLARIFYING* (minor): it is a **new compensating transaction**, not a reversal or
  edit (memo C.f: "the refold never claws it back").

---

## MATERIAL items (EXCLUDED from v1.41 — for the owner)

**M1 — the door time of an event that never crosses the door is undefined. (177-183, 188)**
- *Text:* "the door time at which the single writer admitted it through the one door" (182-183);
  "The log's total order is decided by execution time, then door time, then the event's hash"
  (187-188).
- *The gap:* a firing the fold **synthesises during a refold** (round3: "the fold's own
  derived firings") never separately crosses the door, so the definite description does not
  denote — it has no door time. Yet it must sit in the total order at its execution instant,
  which is exactly an equal-execution-time tie needing the door tiebreak.
- *Why MATERIAL:* the v16.1 pass had to **invent** a value and a rule — first ⊥, corrected to
  ⊤ ("sorts after every real door time of its instant"), plus a **within-instant
  derivation-order tiebreak** for synthesised *chains* (round3 §A; round3_formalis F1). Which
  extreme (⊥ vs ⊤) and which chain-tiebreak the design picks **determines the fold order of
  synthesised firings, hence economic outcomes** (a lost knock-in under ⊥). This is a new
  normative commitment the constitution does not make.
- *What v1.41 MAY clarify (safe residue):* that emitted/derived events **participate in the
  same total order**, and that at equal execution time the tiebreak is "door then hash" — plus
  the honest statement that **the constitution does not assign a door slot to an event with no
  door crossing**, so that slot is determined by the specification, not the Constitution.
  Naming the gap is clarifying; filling it is the owner's.

**M2 — the door-time tiebreak vs. the refusal, at equal execution time. (DL-01) (174-175, 187-188)**
- *Text:* "the refusal to reorder anything unless harmlessness is proved" (174-175);
  "decided by execution time, then door time, then the event's hash — deterministic, total"
  (187-188).
- *The gap:* two **simultaneous non-commuting** events with distinct door times. The totality
  claim, read plainly, orders them **by door time** (= by admission/arrival latency). The
  refusal, read plainly, **refuses** (order not provably harmless → fail closed). Two
  constitutionally-coherent readings — R-tiebreak and R-conform.
- *Why MATERIAL:* it took a **3-panelist unanimous ruling** (DL-01) to choose R-conform, and
  that ruling **reads a restriction into the tiebreak** the text does not state ("door time
  orders only pairs that commute or whose order a recorded precedence fact grounds"). Picking
  R-conform narrows the plain "total" claim (arrival latency no longer decides a non-commuting
  pair); picking R-tiebreak lets arrival order fabricate a world fact. **Either choice adds a
  commitment.** *Directly answering the brief: one clarifying sentence CANNOT settle this,
  because settling it is material — a clarifying sentence states what the text already
  unambiguously means, and here it does not.*
- *What v1.41 MAY clarify:* that "total" is asserted **over the admitted stream** (the order
  is a property of events past the door), leaving *whether* a simultaneous non-commuting pair
  is admitted to the refusal — which is the parked/owned question, not resolved by prose.

**M3 — door-time uniqueness / strict monotonicity is assumed but unstated. (182-183, 187)**
- *Text:* "the door time at which the single writer admitted it" (182-183); "then door time" (187).
- *The gap:* the tiebreak's determinism leans on door times being distinct within a lineage
  (else (exec, door) ties and the hash decides). The text says neither that door time is a
  monotonic **sequence index** nor a wall-clock **timestamp**; uniqueness follows from the
  former, not the latter.
- *Why partly MATERIAL:* asserting **strict uniqueness** constrains the single writer (no two
  admissions share a door time) — a new commitment the constitution does not *need* (the hash
  backstops totality regardless).
- *v1.41 MAY clarify:* door time is **assigned in admission order** (implied by "the single
  writer ... the one door"). The *distinct per lineage* claim is material, left to the spec.

**M4 — does correcting an execution time require C-12.4-grade authorisation? (179-180 vs. 872-873)**
- *Text:* execution time "corrected only by a later event" (179-180); money moves "only as an
  authorised compensating transaction under C-12.4" (872-873).
- *The gap:* the text puts an **authorisation gate** on money but says only "a later event"
  for a fact-correction. Whether an execution-time correction is itself gated (counterparty
  agreement, human authorisation) or flows freely as an ordinary forward event is unanswered.
- *Why MATERIAL:* answering it either adds an authorisation requirement or affirms its
  absence — both are normative. Excluded; flagged for the owner. (Clarifying part is C10: the
  two are *distinct* operations.)

**M5 — lateness exhaustiveness: a door-to-fold (quarantine-hold) segment? (191-192, 869-870)**
- *Text:* lateness "splits into the world's delay, execution to monitor, and ours, monitor to
  door" (191-192).
- *The gap (owner's question):* the two segments cover execution→door; door≈fold on the
  timely path, so no third segment is needed normally. But a **quarantined** late arrival
  (held unroutable, memo D.5) sits between door crossing and routing resolution before it
  enters the fold — a gap the two segments do not name.
- *Verdict:* **CLARIFYING** that the split is exhaustive of execution→door (door is the last
  boundary, fold follows admission). **MATERIAL** only if the owner wants a third (door→fold /
  hold) segment in the explain — a new attribution, excluded.

## Summary for the owner
The clarifying set (C1-C12) can ship in v1.41 without touching a normative commitment. The
material set (M1-M5) records the design decisions the constitution leaves open — the door slot
of a never-crossing event, the refusal-vs-tiebreak choice, door-time uniqueness, and the
authorisation/segment residuals — none of which a clarifying sentence may settle.
