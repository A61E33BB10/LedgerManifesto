# TE-1 — Temporal as an Execution Substrate for Ledger v16 (Round 0)

**Standing frame.** Temporal is proposed as the *execution engine* that keeps the three machines
live, durable, and replayable. It is **not** a book of record. The ledger's immutable, hash-chained
log (ch03, ch14) is the sole record and the sole replay authority. The test I apply to every
decision below: *strip Temporal entirely — can any party still reconstruct all ledger state by
replaying the log against the recorded contracts (C-2.2)?* If not, the design has smuggled state
into Temporal history and is rejected. Temporal's own event-sourced history is a **secondary,
rebuildable cache**, never the truth.

## 1. Workflow / activity boundary — where every side effect lives

The three machines (ch04) map cleanly, and the mapping *forces* the single-writer discipline:

| Machine | Temporal element | Side effects |
|---|---|---|
| **Event Monitor** (owns time+attention) | one long-running **workflow per unit** + durable timers; Schedules for calendar sweeps | none in workflow; clock is Temporal timers |
| **Events Executor** (capture + fire contracts) | ingest **activities** (external I/O) + workflow orchestration | `captureArrival`, `fetchProjection` activities |
| **Transaction Executor** (the door, single writer) | **external service, one `admitTransaction` activity** | the *only* write activity |

Everything with a side effect is an activity: capturing an external arrival (network), fetching the
ledger projection a contract reads, and admitting a proposal at the door. **Smart contracts (ch05)
are pure and stateless**, so they *could* run inline; I run them as **version-pinned `runContract`
activities** anyway, to decouple ledger-contract versioning from Temporal workflow versioning and to
make the (event, projection)→proposal map an independently re-runnable artifact for ch14
recomputation. Workflow code holds only orchestration: wait, fire, propose, advance. It never calls
an API and never writes the ledger.

**Why per-unit, not per-firing:** watches are declared per unit and the declared→armed→fired/expired
lifecycle is *unit* state (ch03 §product graph). One workflow per unit is the natural slice of the
Monitor's attention. A per-firing workflow would scatter that lifecycle and lose the durable timer
home.

## 2. Watches: declared → armed → fired / expired

Authority lives in the ledger; Temporal supplies liveness (M1).

- **declared** — a unit-state change on the log (the watch-handshake, ch04). The unit workflow, on
  processing it, registers a **durable timer** (date watch) or begins awaiting an observation signal
  (condition watch).
- **armed** — the Monitor's acknowledgement is *itself a ledger transaction*; the timer being set is
  only the liveness half. A declared-but-unarmed watch is a visible overdue item (M3), surfaced via a
  search attribute, not a silent absence.
- **fired** — timer fires / observation arrives → `runContract` → `admitTransaction` → on commit,
  unit-state → fired. A late firing produces the identical txid (ch04): Temporal delay costs
  timeliness only.
- **expired** — sibling edges of the traversed edge (ch03) expire *by the contract's proposal*; the
  workflow cancels the sibling timers to match.

**Durable timers vs Schedules:** per-unit watches (barrier expiry, fixing dates, payment dates) are
in-workflow durable timers, tied to unit state. Temporal **Schedules** are reserved for
calendar-wide recurring sweeps not owned by one unit (daily settlement-print processing, EOD marks).
A 252-fixing variance swap sleeps to the next fixing date and fires sequentially — not 252 live
timers.

## 3. Signals vs Updates vs Queries

- **Signals** deliver pushed arrivals (fixings, corp-action notices, settlement confirmations) to the
  unit workflow. They carry **only reference + timing, never economic payload (M4)** — the meaning is
  read from the record. Capture precedes routing: the ingest activity records the arrival to the door
  (envelope-first, quarantine-or-route, M8/TA-ARRIVAL) *before* the workflow is signalled.
- **Updates** carry human-in-the-loop actions that need the door's returned admit/refuse:
  forward-repair compensating transactions (C-12.4) and quarantined-event disposition (M8). The
  synchronous response *is* the door's returned value.
- **Queries** expose the workflow's pending-timer view for ops. Explicitly **non-authoritative**: the
  source-of-truth watch state is the ledger projection.

## 4. Child workflows, task queues, worker topology

**Corporate-action cascade** (ch04: one cause, n units) is fan-out/fan-in: a parent **CA workflow**
(triggered by the announcement) signals — or starts a short child per — each affected unit workflow.
Each unit's proposal carries a **distinct txid** (cascade injectivity, ch04), so all *n* commit;
partial failure is per-unit durable (retry the one failed door activity; its txid is not yet on the
log).

**Task queues** separate by scaling profile *and* privilege: `door` (isolated writer, restricted
credentials — this is how M6 "no write privilege" is physically enforced), `ingest`, `contract`,
`monitor`, `projection`. The no-write machines run on workers that literally cannot reach the door's
write path.

## 5. ContinueAsNew, history size, versioning

A unit lives years; 252 fixings + acks + firings = thousands of Temporal events. **ContinueAsNew is
mandatory** — every ~quarter or N events, targeting a few thousand history events per run.
Critically, **ContinueAsNew carries no business state**: on continue the workflow rehydrates its
watch set from the ledger projection (a `fetchProjection` activity). This is the *same* mechanism as
a cold rebuild-from-ledger after total Temporal loss — which is exactly the property the standing
frame demands.

**Versioning has two orthogonal axes.** (1) Ledger-contract economics: versioned by the ledger
(ProductTerms versions, ch03), pinned per `runContract` activity; ledger replay re-runs contracts by
their *recorded* version and never consults Temporal, so ledger replay independence (ch14) is
untouched by any Temporal change. (2) Temporal orchestration: `GetVersion` / Worker Versioning —
but because the workflow holds no business state across ContinueAsNew, most orchestration changes
ride in at a continue boundary without patching in-flight histories.

## 6. Timeout table (key activities)

| Activity | StartToClose | Heartbeat | Retry |
|---|---|---|---|
| `admitTransaction` (door) | 5 s | — | unlimited — **safe: idempotent via txid** |
| `captureArrival` (ingest) | 10 s | — | until recorded (M2/M8) |
| `fetchProjection` (read) | 5 s | — | standard |
| `runContract` (pure) | 10 s | — | safe (deterministic) |
| `emitSettlementInstructions` | 30 s | — | idempotent (writes nothing, ch11) |
| external settlement/approval wait | **not an activity** | — | workflow timer on a signal, with deadline (M7) |
| poll external settlement system | hours | 30 s (HB timeout 60 s) | with heartbeat |

Long external waits (settlement confirmation, approval) are **workflow waits on signals with a
deadline branch**, never long activities — this is exactly M7 obligation liveness: deadline, test for
discharge, fallback (discharged / compensated / defaulted).

## 7. Visibility / search attributes

Index `unitId, contractId, productType, counterparty, watchState, nextDeadline, obligationStatus,
quarantineFlag`. These drive liveness dashboards — "units with an overdue watch" (M3), "obligations
past deadline" (M7), "quarantined events awaiting disposition" (M8) — turning every failure into a
*visible overdue item*. Non-authoritative: ops reads Temporal visibility; audit reads the ledger.

## 8. Failure-model alignment

Temporal delivers **at-least-once activities** and **exactly-once workflow-state transitions (its own
state)** and **durable timers**. The Constitution demands single-writer, txid idempotence, and M1–M8.
The alignment is clean because the two idempotence layers stay **distinct**: Temporal's exactly-once
governs *workflow* state; the ledger's txid check at the door makes at-least-once door activities
exactly-once *at the record*. Settlement is a pure projection that writes nothing (ch11) — it maps to
an idempotent activity, and settlement failure re-enters as a recorded event, never a Temporal-side
reversal. The one requirement Temporal does **not** supply is M5's *ledger* replay: Temporal replay is
secondary, so the design keeps every workflow rebuildable from the log (see §5). **Authorised forks**
(C-12.5) run in an isolated namespace against a shadow ledger, never sharing the production door.

---

## Decision Register (skeleton)

- **D-01:** Temporal is the execution engine, never a book of record; the ledger log alone reproduces all state (C-2.2). Any design needing Temporal history to reconstruct ledger state is rejected.
- **D-02:** One long-running workflow per unit (the unit's slice of the Event Monitor) — not per contract-firing, not per watch.
- **D-03:** The Transaction Executor is not a workflow; it is an external single-writer service fronted by one idempotent `admitTransaction` activity — the only activity permitted to write (M6).
- **D-04:** Smart contracts run as version-pinned `runContract` activities, decoupling ledger-contract economics from Temporal workflow versioning.
- **D-05:** Watch lifecycle declared→armed→fired/expired is authoritative in the ledger; Temporal durable timers are the liveness half only. Arming and acknowledgement are ledger transactions (M1, M3).
- **D-06:** Per-unit date/condition watches use in-workflow durable timers; calendar-wide recurring sweeps use Temporal Schedules.
- **D-07:** Pushed arrivals are captured by an ingest activity that records to the door (envelope-first, quarantine-or-route) BEFORE any workflow signal — capture precedes routing (M8, TA-ARRIVAL).
- **D-08:** Signals carry only reference + timing, never economic payload (M4); Updates carry human-in-the-loop actions (forward repair, quarantine disposition) needing the door's admit/refuse return.
- **D-09:** Corporate-action cascade = a parent CA workflow fanning out to affected unit workflows; distinct per-unit txids guarantee all n commit; partial failure is per-unit durable.
- **D-10:** ContinueAsNew carries no business state; the workflow rehydrates its watch set from the ledger projection — the same mechanism as cold rebuild-from-ledger.
- **D-11:** ContinueAsNew every ~quarter or N events (target <a few thousand history events/run); a 252-fixing unit continues several times over its life.
- **D-12:** Two idempotence layers kept distinct: Temporal workflow-task exactly-once (its own state) and ledger cause-derived txid (the record). Activities are at-least-once; the door makes them exactly-once at the ledger.
- **D-13:** Task-queue split — `door` (isolated writer, restricted creds), `ingest`, `contract`, `monitor`, `projection` — enforces M6 by scaling and privilege separation.
- **D-14:** Door activity: short StartToClose + unlimited retry (safe via txid); external settlement/approval waits are workflow timers on signals with deadlines (M7), not long activities; polling activities heartbeat.
- **D-15:** Search attributes index watchState, nextDeadline, obligationStatus, quarantineFlag for overdue-item dashboards (M3, M7, M8) — non-authoritative; audit reads the ledger.
- **D-16:** Authorised forks run in an isolated namespace against a shadow ledger, never sharing the production door (C-12.5).
