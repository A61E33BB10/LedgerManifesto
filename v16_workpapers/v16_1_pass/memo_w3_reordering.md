# Memo W3 — Reordering: the three-time envelope, the total order, and the refold

Author role: W3 content author, v16.1 pass (adopting Constitution v1.4). CONTENT for
STYLUS to thread; this memo does not edit the spec. Anchors cite v16.0 by its one name.
Basis: C-2.7 (amended), C-2.8, C-12.3–C-12.6, new TA-EXECUTION-TIME.

---

## A. THE ENVELOPE (three times on every event)

A.1 The v16.0 **capture envelope** (ch04 ~line 1003) already stamps every arrival with
two fields — *delivering source* and *arrival's log position* — applied by the Events
Executor at arrival, before payload validation, carried even when the payload is
malformed. W3 extends this one stamp to carry **three times**. No second mechanism: the
same envelope gains three named time fields. Source is retained; the log-position field is
subsumed by door time (A.5).

A.2 **Execution time** — *when the event happened in the world.*
  - Whose clock: the event's **source** asserts it (the trade's execution timestamp, the
    exercise notice's exercise time, the print's observation time). For an event the
    Event Monitor *emits* rather than receives (A.6), execution time is the world-fact
    time the watched condition became true, read from the record — the record date for a
    record-date firing, the breaching close's observation time for a barrier touch, the
    scheduled datetime for an expiry — never the Monitor's wall-clock read.
  - What it is FOR: the sole determinant of the fold's order (Section B), the time a court
    would enforce (C-2.7), the axis along which the covered-call assignment lands before
    the record date. A legally enforceable, contestable **fact**: TA-EXECUTION-TIME (E.4).
  - What it may NOT be used for: it is **never edited at the door**. A wrong execution
    time is corrected only by a *later event that names the wrong one* (C-12.4 forward
    repair), exactly as a wrong price is. The door does not adjust, round, clamp, or
    reject an execution time for being late, early, or out of order.

A.3 **Monitor time** — *when the Event Monitor observed the event at the boundary.*
  - Whose clock: the Event Monitor's, at the single place the clock is consulted (ch04,
    ~line 428; ch02 Simulability). It is a *boundary observation* of arrival, not a
    world fact.
  - What it is FOR: **provenance only.** With execution time it splits an event's
    lateness into two segments — the *world's* delay (execution → monitor) and *ours*
    (monitor → door). This split is the raw material of the PnL explain item (C.e).
  - What it may NOT be used for: **it orders nothing** (C-2.7: "the monitor's clock
    orders nothing"). Monitor time never appears in the total order and never gates
    admission.

A.4 **Monitor time is NULLABLE.** It is NULL exactly for events that never cross the
boundary from outside — the events the Event Monitor *emits* from the record and clock
rather than *captures* from a source (ch04 ~line 993, "for each event, arrived or
emitted"). In v16.0's terms: watch firings (record-date, payment-date, expiry,
barrier-touch) and the watch **acknowledgements** that flow through the same pipeline
(ch04 ~line 1177). These are born inside, with no arrival to observe; execution time is
the record-derived world fact (A.2), monitor time NULL. A NULL monitor time *records* that
an event was internally generated — provenance, not a defect; its lateness has only *ours*
(execution → door), the world's segment collapsed to zero.

A.5 **Door time** — *when the single writer admitted the event through the one door.*
  - Whose clock: the **Transaction Executor**'s, assigned at admission; **strictly
    monotonic** — the single writer already presents a strictly monotonic committed
    sequence (ch04 ~line 1086), so no two admitted events share a door time in a lineage.
  - What it is FOR: the second level of the total order (B), resolving two events sharing
    an execution time by admission sequence; and the anchor of the hash chain / arrival
    record (B.4). It subsumes the envelope's former log-position field.
  - What it may NOT be used for: it is **not the fold order** and carries no economic
    meaning. Door time says *when we learned*, never *what is true*.

A.6 **Origin table** (v16.0 event kinds, which time is which):

| event kind | execution time | monitor time | door time |
|---|---|---|---|
| external trade / fill | source-asserted execution ts | boundary observation | admission |
| exercise / assignment notice | source-asserted exercise time | boundary observation | admission |
| fixing / official close print | source-asserted observation time | boundary observation | admission |
| emitted watch firing (record-date, expiry, barrier) | record-derived world fact | **NULL** | admission |
| watch acknowledgement | record-derived (arming instant) | **NULL** | admission |
| quarantined event (unroutable arrival, W4) | source-asserted if present, else envelope-only | boundary observation | admission |

---

## B. THE TOTAL ORDER

B.1 **Definition.** The **total order** on admitted events is the lexicographic order
```
    e1 < e2  iff  (exec e1, door e1, hash e1)  <_lex  (exec e2, door e2, hash e2)
```
on the triple (execution time, door time, event hash). It is **deterministic, total, and
computable by any party from the record alone** (C-2.7): every component is on the
record. This total order is the **fold order** — the order in which map-then-fold
advances (ch03, ~line 331) — and it is the meaning of the record.

B.2 **Why each tiebreak level exists.**
  - **Level 1 — execution time.** The world's fact, court-enforceable (A.2). It carries
    the meaning: buy-then-record-date vs record-date-then-buy is an execution-time
    difference, and the fold must honour it.
  - **Level 2 — door time.** Strictly monotonic and unique per lineage (A.5). It makes
    the order *total* even for two events that genuinely share an execution time,
    resolving them by admission sequence — a record fact, so any party recomputes it.
    Because door time is unique within a lineage, (exec, door) is already a *strict*
    total order there.
  - **Level 3 — event hash.** A content-derived backstop that guarantees totality
    **without relying on door-time uniqueness**. Its role is real across an authorised
    fork (C-12.5), where door-time sequences are per-lineage and two events on different
    lineages could carry equal door times; the hash disambiguates from content alone. It
    also makes the order robust to any door-time-collision pathology, so the order is a
    pure function of recorded content in the limit.

B.3 **Duplicates are absorbed BEFORE ordering.** An arrival identical under the
**cause-derived identifier** (ch04, ~line 1042, `txid = H(cause, contract, unit, seq)`)
is a **duplicate**, absorbed once, *never a neighbour to be ordered* (C-2.7). Absorption
is prior to the total order: the ordering relation of B.1 is defined over *distinct*
events (distinct cause-derived identity), so a duplicate never occupies a position and
never triggers a refold (D.2). This is exactly v16.0's existing idempotence discipline
(a duplicate is inert); W3 states only that absorption is *upstream* of ordering.

B.4 **Interaction with the hash chain — the two coexist.** After this pass there are two
distinct orderings of the same events, and they must never be conflated:
  - The **hash chain** records **admission (door) order.** It is append-only,
    position-dependent (ch14, ~line 4717: "the hash chain is position-dependent"), and
    is the **incorruptible arrival record** — *what arrived, and in what sequence we
    learned it.* A late arrival is appended at the chain's head like any other; the chain
    is never reordered, never rewritten (C-12.5).
  - The **total order** (B.1) is the **fold order** — *what the events mean.* A late
    arrival takes its execution-time place among earlier events and the tail refolds
    (Section C).
  - The two coexist by design: **chain = incorruptible record of arrival; total order =
    meaning.** This is precisely the v16.0 bitemporal split generalised — the
    transaction-time axis (log prefix / "what was known") is the hash chain; the
    valid-time re-sequencing that v16.0 already performs for a unit's fixings (ch03
    ~line 1484; ch06 ~line 1772; ch14 ~line 4934) is the total order, now lifted from
    per-unit fixing series to the *global* event fold.

B.5 **What "the log" means after this pass.** "The log" in v16.0 was used for both the
append-only committed sequence and the fold order, because in v16.0 they coincided except
for the per-unit valid-time fixing re-sequencing. After W3 the two are named separately:
  - the **immutable log / hash chain** = the append-only committed sequence in door
    order (the arrival record);
  - the **total order** = the execution-time lexicographic order (B.1) the fold obeys.
  Both order *one* set of committed transactions — still **one record, many folds of it**
  (ch03 ~346). No second store: the total order is *computed* from the three-time envelope
  on the one log, exactly as the as-of view is computed from valid-time indices already on
  it.

---

## C. THE REORDERING STEP

Normative algorithm. Each step is anchored to v16.0 machinery by its one name. Input: a
newly admitted event `e_new` with execution time `x = exec(e_new)`; the current fold has
head execution time `X = exec(head)`, where `head` is the last event in the total order.

C.a **Detection (at admission, in the Transaction Executor).** On admitting `e_new`,
compare `x` against `X`. If `x >= X`, `e_new` extends the fold at its head — the timely
path, no refold. If `x < X`, `e_new` is a **late arrival**: its execution time precedes
events already folded. Detection is a comparison of two recorded execution times; it
reads no clock (clock confinement, ch04 ~line 428). Duplicates are already absorbed
(B.3), so a late duplicate is never detected here — it is inert.

C.b **Insertion into the total order.** Locate the position of `e_new` in the total order
(B.1) by its triple `(x, door(e_new), hash(e_new))`. Call the events strictly after that
position the **tail**. The insertion point is deterministic and computable by any party.
Nothing is moved in the hash chain: `e_new` is appended at the chain head (door order);
only its *position in the fold order* is interior.

C.c **Refold.** Every event in the tail refolds — its transaction is recomputed against
the ledger the reordered prefix now builds. The fold is a **pure function of the ordered
log** (C-2.8 Simulability; ch14 Replay determinism, ~line 4945): re-running map-then-fold
over the total order from the insertion point forward is deterministic and consults only
the ordered log. This is v16.0's existing tail-recompute (`A_k, A_{k+1}, ...` recomputed
from k forward, ch03 ~line 1492) generalised from a unit's accrual to the global fold.

  **What happens to the previously emitted transactions.** They are **not erased.** They
  are the *as-known history* — what the book said before `e_new` arrived — and they
  survive as the **as-known-at view** over the pre-insertion prefix (ch03 ~line 375;
  ch14 Time-travel Theorem clause (a), as-known-at permanence). The refold **appends**
  the recomputed tail as new committed transactions further down the log; it never edits
  or removes a byte. This reconciles with:
  - the **hash chain** (B.4): append-only, position-dependent, never rewritten;
  - **C-12.5** (no rewrite): the record is corrected forward, never overwritten; a
    corrected observation is a new recorded fact at its own position, the earlier view
    preserved beside it (ch03 ~line 500).
  Concretely: the log now carries both the superseded tail (as-known-at) and the
  recomputed tail (as-of), distinguished by their transaction-time positions and by the
  flags of C.d. A refold is a **re-fold, never a rewrite.**

C.d **Flagging (C-12.6: reordering never silent).** "Flagged" is a **recorded, queryable
mark**, not prose. Three marks are written, each a recorded fact folded into a home /
UnitStatus and reconstructible by replay:
  - `reordered` on the **insertion**: the event `e_new` carries a recorded mark that it
    took a place before the head, naming its execution time and the insertion position.
  - `restated` on **every state the refold changed**: each balance, home fact, or
    UnitStatus whose recomputed value differs from its as-known-at value carries a mark
    naming the causing event `e_new`. A state the refold left identical carries no mark
    (the refold is a no-op there — D.2).
  - the **explain item** (C.e) is itself the published, queryable difference.
  These marks are queryable predicates over the log (e.g. `isReordered e`, `isRestated
  (w,u,coord)`), so an auditor recomputes exactly which states moved and why, from the
  record alone.

C.e **Explain — the named PnL explain item.** The difference between what the book said
and what the book now says is published as a **named profit-and-loss explain line**
(C-12.6), attributed three ways:
  - to the **reordering** (the mechanism);
  - to the **causing event** `e_new`;
  - to the **segment of its lateness**: the *world's* (execution → monitor) and *ours*
    (monitor → door), read off the three-time envelope (A.2–A.5).

  **Worked example — the covered call.** Monday: 100 shares against a short American call;
  record date Wednesday. **Tuesday** the holder exercises early (rational — capture the
  dividend), so at Tuesday's *execution time* the shares are called away. The assignment
  notice reaches the door only **Thursday**. As-known-at Wednesday, the book honestly
  showed 100 shares and a dividend entitlement `100 × D` — both wrong in the world, where
  the shares left Tuesday. Thursday the assignment arrives, `exec = Tuesday < X =
  Wednesday's record-date firing`: detection (C.a) fires, insertion at Tuesday (C.b), tail
  refolds (C.c) — shares leave Tuesday, **Wednesday's record-date firing now finds zero
  shares**, entitlement `100 × D` was never ours. Flags (C.d): assignment `reordered`;
  share balance, position home, vanished entitlement `restated`. Explain line (C.e):
  **"dividend entitlement −(100 × D), reordering, cause = Tuesday assignment, lateness:
  world's = Tue→clearing-house observation, ours = observation→Thu door."** The vanished
  dividend is *named*, not silent.

C.f **Money — views recompute, money never does.** The refold recomputes **views**
automatically (balances, NAV, PnL, reports are folds of the ordered log) but moves **no
money.** Where it changes a quantity already **settled** — a settled leg of a
settlement-obligation unit, cash remitted — the delta does **not** reverse: it **stands as
a visible open item** and moves only as an **authorised compensating transaction under
C-12.4** (ch15 gate `prop_noRepairWithoutAuth`, ~line 5244: counterparty agreement +
recorded human authorisation; phase 0, none fires without human intervention). Any
dividend **already received** moves back only so; the refold never claws it back. This is
v16.0's existing rule for a superseded accrual tail ("any figure already *posted* is
corrected by an authorised compensating transaction, never left standing", ch03 ~1495).

---

## D. ANALYSIS

D.1 **Determinism.** Same log ⇒ same refolded state. The refold (C.c) is `fold step` over
the total order (B.1); both are functions of the record alone — the total order is
computed from the three-time envelope on the log, and `step = apply ∘ contract` consumes
the Ledger, never the clock (ch03 ~line 411). No wall-clock, arrival order, or external
feed enters. Any party re-deriving the total order and refolding obtains the identical
state — v16.0 Replay determinism (Theorem ~4945) with the fold order named as the total
order, not log order.

D.2 **Idempotence.** Refolding twice equals refolding once: the refold is a pure function
of the ordered log; applied again over the now-current order it inserts nothing new (the
event already sits at its position) and recomputes the identical tail. A **duplicate late
arrival** is absorbed under the cause-derived identifier *before* ordering (B.3): it
occupies no position, changes the total order not at all, and triggers **no refold** —
inert, exactly as v16.0 guarantees (ch04 ~1055, "constant under retry"). Idempotence of the
refold and of the door are one fact seen twice.

D.3 **Correctness (for FORMALIS).** *Claim.* Let `L` be the committed log and let `e` be a
late arrival inserted at its execution-time position. Let `S_refold` be the state after
the refold of C.c, and let `S_timely` be the state that would have obtained had `e` been
admitted in execution order (i.e. folded at its position with no later events yet present,
then the remaining events folded after it in total order). Then `S_refold = S_timely`,
bit for bit.
  *Proof sketch.* Both are `fold step` over the **same** sequence — the events in total
  order (B.1) — because insertion places `e` at the same position in both, and the total
  order is a function of the three-time envelopes, not of arrival. `fold step` is
  deterministic. Hence equal inputs, equal output. ∎
  *Hypotheses FORMALIS must discharge* (flagged, not assumed):
  - **(H1) Contract purity** — `contract : (Event, Ledger) -> Transaction` is a pure
    function; no contract reads a wall clock or any off-record input (ch05 purity;
    C-2.8). If a contract read `now()`, the refold's transactions would differ from the
    timely ones and the theorem fails. The spec's **clock confinement** (ch04 ~line 428:
    the clock is consulted only in the Event Monitor, and everything downstream is a
    function of the record) is exactly H1's guarantee — cite it.
  - **(H2) Execution-time stability** — `exec(e)` is fixed once recorded and is never
    edited (A.2, TA-EXECUTION-TIME). A later correction is a *new* event, folded in turn;
    it does not mutate `exec(e)`. Without H2 the insertion position is not well-defined.
  - **(H3) Order-determinacy of the total order** — the triple `(exec, door, hash)` is a
    strict total order on distinct events (B.2). Ties are impossible after duplicate
    absorption (B.3) and door-time strict monotonicity (A.5), so the fold sequence is
    unique.
  *Boundary:* view-level equality is unconditional; money-level equality holds only up to
  the visible open items C.f leaves on **settled** (terminal — D.5) quantities.

D.4 **Cost.** The refold re-runs `fold step` over the tail: **O(|tail| × fold-step
cost)**, where `|tail|` is the number of events with execution time (or tiebreak) after
the insertion point. Worst case is a **years-late correction** (a restated close from many
periods ago), whose tail is the whole subsequent history — potentially millions of events.
Unbounded lateness ⇒ unbounded tail; this is intrinsic to honouring execution order and
must not be capped (the non-negotiable design fact).
  *Snapshot / checkpoint strategy.* Snapshots (materialised fold states) are keyed by
  **position in the total order**. An insertion at position `p` **invalidates every
  snapshot at total-order position ≥ p**; snapshots strictly before `p` survive. The
  conforming mitigation is **snapshot + incremental refold from the nearest surviving
  snapshot**: restore the snapshot at the greatest position `< p`, then refold forward.
  This bounds *typical* cost (recent late arrivals refold a short tail) without ever
  refusing a late arrival — the snapshot is an acceleration of the same total-order fold,
  not a change to it.

  | mitigation | conforming? | why |
  |---|---|---|
  | snapshot + incremental refold from nearest surviving snapshot < p | **yes** | pure acceleration of the total-order fold; result bit-identical to full refold (D.1) |
  | keep hash chain append-only, refold only the invalidated tail | **yes** | tail-only refold is what C.c specifies; untouched prefix is unchanged (Prop. independent-commute, disjoint footprints) |
  | tolerance window: refuse arrivals older than N days | **no** | caps lateness; drops a court-enforceable execution time — constitutional conflict (E) |
  | best-effort / finality cutoff refusing late arrivals | **no** | refuses to refold; the book stays knowingly wrong (the covered-call failure) |
  | fold in **door order**, treat execution time as metadata | **no** | fold order ≠ execution order; contradicts amended C-2.7 outright |
  | snapshot keyed by door position, never invalidated on insert | **no** | door-position snapshot is stale after an interior insertion; returns wrong state |

D.5 **Interactions.**
  - **A watch that already fired on state the refold changes.** A watch firing is itself
    a **recorded event** with its own execution time (A.6). It is *in the log* and *in the
    total order*, so it refolds like any other tail event: the refold recomputes the
    watch's **predicate over the refolded state**. If the predicate no longer holds — the
    Wednesday record-date firing now finds zero shares (C.e), or a barrier the refold
    shows was never breached — the firing's *consequences* (its emitted transactions) get
    the **C-12.6 treatment**: `restated` flag + explain item + C-12.4 for any settled
    money. The firing event is not deleted (C-12.5); its consequence is superseded by the
    refold and the difference is published. v16.0's watch properties
    (`prop_firedMatchesOneEdge`, `prop_actionEqualsRecorded`, ch15 ~line 5465) must be
    re-stated over the *refolded* state, not the as-known-at state (D.6).
  - **An obligation already split.** A **settled** leg of a settlement-obligation unit is
    **terminal** (ch11 ~line 3968: partial fill splits into a settled leg and a
    failed-residual leg, each at its own node). A refold that changes an upstream quantity
    cannot un-settle a settled leg — settled money moved. The refold restates the *view*
    of the split; the settled leg stands, and any delta between the refolded quantity and
    the settled quantity is a **visible open item** discharged only by authorised
    compensation (C.f, C-12.4). The failed-residual leg, still at `instructed`, refolds
    freely.
  - **The quarantined-event path (a late arrival that is ALSO unroutable).** A late
    arrival whose kind is undeclared, whose reference cannot be resolved, or whose payload
    fails validation is recorded as a **quarantined event** under its capture envelope
    (W4, ch08 ~line 2652; ch04 ~line 1008) — carrying its three times, execution time
    included (A.6). It is **not** inserted into the fold yet (it routes to nothing). When
    its kind is later registered or its reference resolved, the processing transaction's
    **cause is the quarantined event** (ch08 ~line 2700), which carries the *original*
    execution time — so **at that moment** the event takes its execution-time place and
    the tail refolds (C). Quarantine defers routing; execution-time insertion applies when
    routing resolves. Quarantine and reordering **compose**: a late-and-unroutable arrival
    is first held (never dropped), then, on resolution, refolded at its true execution
    time.

D.6 **Rethreading list for STYLUS** (pointer + one line each):
  1. **ch02 ~186–194 (Order).** Add three times; fold order = execution order; keep
     "refusal to reorder" but scope it to the hash chain, not the fold order.
  2. **ch03 ~331–342 (map/fold).** "In the total order" now means execution order, not
     log/door order.
  3. **ch03 ~348–392 (bitemporal).** Generalise valid-time re-sequencing from observations
     to *all* events; name the total order as the global lift of the valid-time fold.
  4. **ch03 ~483–505 (Not event sourcing).** Split "single total order" into hash chain
     (arrival) + total order (meaning).
  5. **ch04 ~1001–1011 (capture envelope).** Extend to three times; monitor time NULLABLE
     for emitted events.
  6. **ch04 ~1084–1096 (single-writer / door-refusal).** Door time strictly monotonic;
     execution gives precedence; non-commuting-simultaneous refusal survives (E.1).
  7. **ch03 ~1484; ch06 ~1772; ch15 ~5840 (fixing fold episodes).** Re-cast as the
     per-unit special case of the global execution-time total order.
  8. **ch14 ~4712–4732 (independent commutation).** Governs permuting the hash chain /
     door order; the fold-order refold is a separate mechanism.
  9. **ch14 ~4895–4975 (Time travel & replay).** Add the reordering refold as the global
     generalisation; restate replay determinism over the total order.
  10. **ch15 ~5464, ~5840 (watch & replay props).** Add `prop_reorderRefoldEqualsTimely`,
      `prop_reorderIdempotent`, `prop_reorderFlagged` (C-12.6 firing witness); re-scope
      watch properties over refolded state (D.5).
  11. **ch16 ~6464–6497 (trust assumptions).** Add **TA-EXECUTION-TIME** beside TA-ARRIVAL.
  12. **ch17 ~6624–6713 (parking index).** Record E.1's residual if the owner rules on it.

## E. PARKING CANDIDATES

Three v16.0 passages read against amended C-2.7 — two **rethreading only** (no
weakening); one carries a genuine interpretive **residual** for the owner.

E.1 **ch04 ~line 1086–1096 — "the total order = the strictly monotonic committed
sequence" and the door-refusal.** The text equates the total order with the *door*-ordered
committed sequence ("every projection folds the same total order"). Under amended C-2.7 the
fold's total order is **execution** order, decoupled from the door-monotonic hash chain
(B.4/B.5). *Conformance:* rename — the strictly monotonic sequence is the **hash chain /
arrival record**; the **total order** is (exec, door, hash). **Rethreading, not a conflict**
(the door sequence and the fold order coexist; no guarantee is narrowed).
  *Residual (genuine, flag for the owner).* The same passage refuses two non-commuting
  same-execution-time events with no declared precedence ("fail closed"). Amended C-2.7
  makes the order total via the door-time tiebreak, which would instead *order* such a pair
  by arrival. **R-conform (recommended):** the refusal survives (C-2.7 still "forces the
  refusal to reorder anything unless harmlessness is proved"); the tiebreak serves totality
  only for events harmless to reorder or already admitted — no weakening, no amendment.
  **R-tiebreak:** the tiebreak supersedes the refusal, so arrival order silently picks the
  winner among simultaneous non-commuting events — Goodhart: "totality of the order"
  bought at the cost of "order is a world fact." If the owner intends R-tiebreak, **park**
  with amendment softening ch04 ~1088–1096. I adopt R-conform here.

E.2 **ch03 ~line 492–494 — "a single total order, not a set of per-aggregate streams."**
Correct and retained; conformance only clarifies that the *one* total order is now the
execution-time order, still one (not per-aggregate). **Rethreading, not a conflict.**

E.3 **ch03/ch06/ch15 valid-time fixing folds (~1484, ~1772, ~5846).** These already fold a
*unit's* fixings in valid-time (execution) order and refold the tail — the correct
behaviour, merely **scoped per unit**. Amended C-2.7 lifts it to the global event fold.
*Conformance:* present them as the special case of the global total order (B.4). **No
conflict** — the machinery is already conformant; W3 generalises its scope.

E.4 **New trust assumption — TA-EXECUTION-TIME** (ch16, beside TA-ARRIVAL). *Statement:*
the fold trusts asserted execution times as **legally enforceable, contestable facts**,
resolved by correction events, never edits. *Owner:* source / perimeter governance.
*Violation:* a source asserts a wrong execution time (e.g. a mis-stamped exercise notice).
*Detection:* reconciliation against the counterparty's / clearing house's own record;
the wrong time is corrected by a **later event** (C-12.4), never a door edit. *Residual:*
an execution time nobody contests is folded as asserted — the sibling of TA-KIND's and
TA-ARRIVAL's residuals. Not a gap in the fold: everything folded is on the record and
replayable.
