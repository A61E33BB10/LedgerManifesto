# TE-3 — Temporal as an Execution Substrate for the Ledger v16 (Round 0)

**Standing frame.** Temporal runs the two *untrusted* machines of ch04 — the Event Monitor
(the `watch` arrow) and the Events Executor (the `contract` arrow). It **never** runs the
Transaction Executor. The door is not a workflow; it is the single trusted writer that owns
the immutable log. Temporal *proposes*; the door *writes*. This maps the trust boundary of
ch04 onto the workflow/activity boundary exactly: everything above the dotted line is a
Temporal workflow or activity and holds no write privilege (M6); the log below the line is
not Temporal's to hold.

**The one non-negotiable (C-2.2).** The ledger log is the sole book of record. A Temporal
workflow history is *orchestration bookkeeping* — which timer is pending, which activity is
in flight — and is derivable from the log, never the reverse. The acceptance test: **wipe
the Temporal cluster; every workflow must rebuild from the ledger alone.** It can, because a
unit's armed-watch set is the out-edge set of its current graph node (Inv. graph-consistency
(i)) and that node is recorded in `UnitStatus`. Any design where Temporal holds state the
ledger cannot reconstruct is rejected on sight. ch02's "Not event sourcing" is why this is
safe: **replay re-reads transactions and never re-executes contracts**, so Temporal's
orchestration is outside the ledger's correctness argument entirely.

## Workflow / activity boundary

**One workflow instance per unit** (keyed `unitId`), not per contract-firing (ephemeral) and
not per book (history blow-up, no isolation). The unit's product graph *is* a state machine;
the workflow walks it. Its pending timers and signal-waits **equal** the current node's
out-edge set — arming a watch = starting the timer/selector **and** proposing the recorded
acknowledgement transaction through the door (the ch04 handshake: declared → armed on the
*record*, not merely in Temporal).

Workflow code is pure and deterministic: durable timers, a `Selector` over
(timer | observation-signal), sibling-timer cancellation on traversal ("a traversal expires
its sibling edges"), and activity sequencing. No wall-clock reads, no RNG, no map iteration,
no direct I/O. **Every side effect is an activity:** `fetch-projection`,
`evaluate-contract` (pure `contract(Event,Ledger)` fed a fetched projection),
`propose-to-door`, `capture-observation`, `emit-settlement-instruction`.

**Idempotence alignment (the load-bearing join).** `propose-to-door` is at-least-once;
Temporal will retry it. The door's `txid = H(causeEventId, contractId, unitId, seq)` absorbs
this — a retry recomputes the identical tuple and commits zero further times. **At-least-once
(Temporal) + txid idempotence (door) = exactly-once commit.** Critical rule: `txid` is
derived from *recorded ledger inputs*, never from a Temporal run-id/attempt, or a retry would
mint a new txid and double-commit.

## Signals, updates, children, fan-out

- **Signals** for external arrivals (fixings, closes, CA notices, settlement confirmations).
  Per M4 a trigger carries *timing, not data*: the signal carries a **pointer to the already
  recorded observation** (log position), not the value. Ordering is **record-first** — the
  Events Executor captures the envelope through the door (unconditionally, M8) *before*
  routing; the signal is only the nudge. Temporal signal delivery is never the sole record of
  an arrival: if a signal is lost, the observation is still on the log and the overdue-watch
  (M3) plus perimeter reconciliation catches the gap. **M8 rests on the door, not on Temporal.**
- **Updates** for request-response: authorised **forward-repair** (operator submits a
  compensating transaction and needs the door's admit/refuse synchronously) and on-boarding
  "arm-and-confirm". **Queries** only as a liveness view — the authoritative state is the
  ledger's `UnitStatus`, reconciled against, never trusted over.
- **Child workflows** for events that *create* a unit — the settlement-obligation unit
  (`instructed → settled|failed`, its own M7 deadline/fallback) and the market-claim leg.
  Events that *affect existing* units (a dividend touching every unit referencing ACME) **fan
  out as signals** to each referencing unit-workflow; each fires its own contract and proposes
  its own txid — the cascade-injectivity of ch04, one cause, `n` distinct txids, all commit.

## Timers vs Schedules; task queues

Date watches (expiry, fixing date, record/payment date) are **in-workflow durable timers**
(M1) — the date is a declared term of *that* unit's graph. **Temporal Schedules are reserved
for system cadence** (daily market-close ingestion sweep, daily settlement-instruction
projection run), never for per-unit dates: a 252-fixing swap is one workflow arming the next
fixing edge, **not** 252 Schedules. Condition watches (barrier touch) are selector waits on
the recorded-close signal; the predicate is evaluated by the contract, on the record.

Task queues split by machine role **and** scaling profile: `unit-workflow` (millions, idle),
`contract-firing` (CPU, versioned product code), `door` (few, hot, serialized — its
`ScheduleToStart` is the backpressure alarm), `ingestion-capture` (must-not-lose HA),
`settlement`. Never co-locate the idle-many workflows with the hot door activity.

## History size, ContinueAsNew, versioning

A unit lives years (252+ fixings × arm/fire/propose events) — unbounded history.
**ContinueAsNew at ledger-natural checkpoints** (e.g. quarterly / every 50 fixings), carrying
**only** `(unitId, currentNodeId, lastProcessedLogPosition)` — **no ledger state**. The
accrued statistic lives in the ledger home (`PositionState`), not workflow memory; the
workflow reboots by reading `UnitStatus`/`PositionState` and re-arming the out-edges of the
current node. **ContinueAsNew and disaster recovery are the same re-derivation** — which is
exactly the C-2.2 reconstructibility test, made routine.

**Two decoupled version axes.** (1) Temporal workflow-code — Build IDs / `GetVersion` for
orchestration changes. (2) Ledger contract/`ProductTerms` — declared, on-record, versioned by
appending a new terms version (the CA self-loop). The decoupling is the safety net: because
the ledger never re-executes contracts on replay, **a Temporal non-determinism bug degrades
to a liveness/overdue item, never to wrong ledger state.** Economic errors are repaired
**forward** by an authorised compensating transaction through the door — never by editing
workflow code and replaying (that would rewrite history; forbidden by ch02/C-2).

## Failure-model alignment

| Constitution demands | Temporal supplies | Gap the design closes |
|---|---|---|
| M1 durable watches/timers | persisted durable timers | — clean fit |
| M2 at-least-once emission, harmless dup | at-least-once activity + retry | door txid makes dup harmless |
| M5 deterministic replayable orchestration | event-sourced workflow replay | applies to *orchestration only*, not ledger state |
| M6 no write privilege | activities call the door; no direct writes | enforced by TQ isolation + review |
| M8 no captured event lost | signals persisted, at-least-once | **not sufficient alone**: record-first via door is the guarantee |
| M3/M7 overdue items | timer + query surfaces overdue | reconciled to ledger `UnitStatus` |
| C-2.2 any-party reproducibility | (none — third party has no Temporal) | Temporal holds nothing not derivable from the log |

Temporal's guarantees are *liveness and orchestration determinism*. The Constitution's
*integrity* rests on the door alone — which is precisely why running the untrusted machines
on Temporal is legal: no Temporal failure mode reaches ledger state.

## Timeout table (key activities)

| Activity | StartToClose | ScheduleToClose | Heartbeat | Retry |
|---|---|---|---|---|
| `propose-to-door` | 5 s | 60 s (absorbs door backpressure) | — | ∞ w/ capped backoff (M2: must commit) |
| `capture-observation` | 5 s | generous | — | ∞ (M8: loss unrecoverable) |
| `fetch+evaluate-contract` | 10 s | 30 s | — | finite; else → overdue item |
| `emit-settlement-instruction` | 15 s | 60 s | — | ∞ (idempotent, recognises settled) |
| CA fan-out / backfill (long) | hours | ≤ obligation deadline (M7) | 30 s | finite, heartbeat detects stall |

WorkflowTaskTimeout default (10 s, deadlock detection). **No `WorkflowRunTimeout`/
`WorkflowExecutionTimeout` on unit-workflows** — they live years; bound liveness by per-watch
arming windows (M3) and per-obligation deadlines (M7), surfaced as overdue items, never by
killing a live unit. `door` TQ `ScheduleToStart` is a queue-depth alarm.

## Visibility / search attributes

Index unit-workflows by `unitId`, `productType`, `currentGraphNode`, `underlyingRefs`
(CA-routing sanity vs the registry), `nextWatchDate`, `obligationDeadline`, `counterparty`,
`bookId`. Enables ops queries — "armed watches overdue past window" (M3), "obligations past
deadline" (M7), "units referencing ACME" — **without polling the ledger**. These attributes
are an operational index *derived from and reconciled to* the ledger; they are never
authoritative.

---

## Decision register skeleton

D-01: Temporal runs the two untrusted machines (Event Monitor + Events Executor); it evaluates `watch` and drives `contract`, and NEVER evaluates `apply` — the Transaction Executor is not a workflow.
D-02: The ledger log is the sole book of record; Temporal workflow history is orchestration bookkeeping and every workflow must be fully reconstructible from the log (acceptance test: wipe Temporal, rebuild from the log — C-2.2).
D-03: One workflow instance per unit, keyed by unitId — not per contract-firing, not per book; the workflow walks the unit's product graph.
D-04: The workflow's pending timers and signal-waits equal the current node's out-edge set (armed = Inv. graph-consistency (i)); arming a watch starts the timer/selector AND proposes the recorded acknowledgement transaction through the door.
D-05: Every side effect is an activity (fetch-projection, evaluate-contract, propose-to-door, capture-observation, emit-instruction); workflow code is pure and deterministic — durable timers, selectors, sibling-cancellation, sequencing only.
D-06: propose-to-door carries the ledger's cause-derived txid computed from recorded inputs, never from Temporal run/attempt ids; at-least-once retries are absorbed exactly-once by the door's txid idempotence.
D-07: External observations arrive as signals carrying a pointer to the already-recorded observation (timing/reference, not payload) — record-first through the door, then route (M4, M8); Temporal signal delivery is never the sole record of an arrival.
D-08: Use Updates for authorised forward-repair and any request needing the door's admit/refuse synchronously; use Queries only as a liveness view, reconciled against the ledger's UnitStatus.
D-09: Events that create a unit (settlement-obligation, market-claim leg) spawn a child workflow; events that affect existing units (corporate actions) fan out as signals to each referencing unit-workflow, each proposing its own txid (cascade injectivity).
D-10: Date-based watches are in-workflow durable timers (unit lifecycle dates); Temporal Schedules are reserved for system cadence (daily ingestion sweep, daily settlement projection), never for per-unit fixing dates.
D-11: ContinueAsNew at ledger-natural checkpoints carrying only (unitId, currentNodeId, lastProcessedLogPosition) — no ledger state; the workflow reboots by re-reading UnitStatus/PositionState and re-arming out-edges. ContinueAsNew and disaster recovery are the same re-derivation.
D-12: Never set WorkflowRunTimeout/ExecutionTimeout on unit-workflows; bound liveness by per-watch arming windows (M3) and per-obligation deadlines (M7), surfaced as overdue items, not by killing the run.
D-13: Two decoupled version axes — Temporal workflow-code (Build IDs/GetVersion) governs orchestration only; ledger contract/ProductTerms versioning is declared data on the record. A Temporal non-determinism bug degrades to a liveness/overdue item, never to wrong ledger state, because the ledger never re-executes contracts on replay.
D-14: Economic errors are repaired forward by an authorised compensating transaction through the door — never by editing workflow code and replaying; no history rewrite.
D-15: Task queues split by machine role and scaling profile: unit-workflow (idle-many), contract-firing (CPU, versioned), door (hot, serialized, ScheduleToStart backpressure alarm), ingestion-capture (must-not-lose), settlement.
D-16: Search attributes (unitId, currentGraphNode, underlyingRefs, nextWatchDate, obligationDeadline, counterparty) are an operational index derived from and reconciled to the ledger — never authoritative.
