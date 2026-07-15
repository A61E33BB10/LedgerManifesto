# TE-4 — Temporal as the execution substrate for Ledger v16 (Round 0)

**Standing constraint honoured throughout.** The ledger's immutable log is the *sole* book of record.
Temporal workflow histories are a **disposable execution cache** of the two *untrusted* machines. Any
design in which Temporal owns state the ledger cannot re-derive is rejected on sight.

## 1. What Temporal is allowed to be

The v16 machines split cleanly by trust (ch04). Temporal runs **only** the Event Monitor and the Events
Executor — the untrusted machinery whose failures degrade to *visible overdue items*, never to wrong
state. Temporal **never** runs the Transaction Executor: the single writer and its immutable log stay
outside Temporal as a trusted service that Temporal *calls*. Putting the book of record inside workflow
history would be the direct violation.

This split is a gift, not a compromise, because the three things Temporal guarantees are exactly the three
the untrusted machines need:

| Temporal guarantee | v16 requirement it discharges |
|---|---|
| Durable timers surviving restart | **M1** durable watches/timers |
| At-least-once activity execution | **M2** at-least-once emission (duplicate harmless *at the door*) |
| Exactly-once, deterministic workflow-state transitions (event sourcing) | **M5** deterministic replayable orchestration |

The sharpest match: Temporal's *weakest* delivery guarantee — at-least-once activities — is precisely what
the door's **cause-derived txid** `H(causeEventId, contractId, unitId, seq)` (ch04) is engineered to
absorb. A retried activity recomputes the identical tuple, the door commits it zero further times. **No
application-level dedupe is ever added.** This is the whole failure-model alignment in one line.

## 2. Workflow / activity boundary

**One long-lived workflow per *unit*** (OT-1, VS-1, FUT-IDX…), not per contract-firing and not per watch.
The unit is the durable object whose watches, lifecycle and years-long life must persist. The workflow *is*
the Event Monitor's attention for that unit; it holds durable timers and waits, and carries **no product
knowledge** — the same generic orchestration for every instrument, exactly as the spec's machines do.

**Every side effect is an activity. Workflow code only orchestrates (timers, waits, sequencing).**
Activities: (a) read the ledger projection; (b) run the **pure contract**; (c) propose a transaction to the
door; (d) capture an external arrival. Critically, **contracts run in activities, never in workflow code.**
The ledger's own replay "re-reads admitted transactions and *never re-executes contracts*" (ch14, l.152),
so contract logic is deliberately kept out of Temporal's replay/versioning surface too. The two replay
mechanisms — ledger and Temporal — stay fully decoupled. Workflow code stays generic and near-frozen.

## 3. Watches → timers, signals, and the recorded handshake

The lifecycle **declared → armed → fired/expired** (ch03/ch04) lives on the *record*; Temporal only mirrors
it.

- **Date watches** (fixings, expiry, coupon, record/payment dates) → **Temporal durable timers** (M1).
- **Observation/barrier watches** (OMEGA close ≤ 80) → a **signal** that carries only *when/where* (a log
  position), waking the workflow; the workflow then reads the recorded close via an activity and evaluates
  the pure condition. **Signals carry timing, not data (M4)** — putting the observation value in the signal
  payload is a rejection-on-sight violation. Every signal has a record-derived **backstop** (a periodic
  sweep timer / the record's declared-but-unfired projection), so a lost signal costs latency, not
  correctness.
- **armed** = an activity proposes the acknowledgement transaction; once committed the timer/wait is armed.
  A workflow that never commits its ack leaves a **declared-but-unarmed watch standing on the record** —
  visible independent of whether the workflow is alive. This is why *declared* must live on the ledger, not
  in Temporal.

**Corporate-action cascade** (one ACME dividend → one transaction per referencing unit) is fan-out: a
corporate-action workflow enumerates affected units (activity over the record's projection) and **signals
each existing unit workflow**. At-least-once fan-out is safe with no compensation because the door's txid is
*injective over the cascade* (ch04) — n legs, n distinct txids, all commit; retries collapse.

## 4. History size and ContinueAsNew (a unit lives years)

VS-1 is 252 fixings; FUT-IDX prints daily VM; TRS-1 resets quarterly for years — tens of thousands of
history events, past Temporal's ~50k/50MB ceiling. **ContinueAsNew at each period boundary**
(fixing-batch / quarter). The carried-forward state is **only a record cursor** — `unitId` + resume
position — **never accumulated business state**; the new run re-derives everything by folding the record.
This is what keeps ContinueAsNew constraint-legal: even the hand-off is reconstructible from the log. Lose
every Temporal history and you rebuild every unit workflow by folding the ledger for declared-but-unfired
watches and re-arming them. That fold is the *test* of the standing constraint.

## 5. Versioning, task queues, timeouts, visibility

**Versioning.** Generic orchestration is versioned via Worker Versioning / `GetVersion`, but because
contracts sit in activities and ContinueAsNew boundaries are frequent, `GetVersion` is rarely needed: deploy
new orchestration, drain old runs to their next ContinueAsNew, the new run picks up new code. Contract
change = new `contractId` (contracts are stateless, keyed in the txid); the ledger neither knows nor cares
about Temporal build IDs.

**Task queues** split by trust/throughput class: `unit-orchestration`; `door-write` (concurrency tuned to
the single writer — `ScheduleToStart` on this queue is the contention alarm); `ledger-read`+`contract`
(CPU); `market-data-ingest`. Separate worker pools so door back-pressure never starves orchestration.

**Timeout table (key activities).**

| Activity | StartToClose | ScheduleToClose | Heartbeat | Retry |
|---|---|---|---|---|
| propose-to-door (append) | 15s | 5m | — | ∞ backoff (idempotent at door) |
| read-ledger-projection | 30s | 2m | — | 5×, backoff |
| run-contract (pure; candidate local activity) | 30s | 2m | — | 5× |
| capture-external-arrival (M8) | 30s | **∞ / very long** | — | ∞ until on record (never drop) |
| arm-watch (ack) | 15s | 5m | — | ∞ backoff |
| corp-action fan-out enumerate | 2m | 30m | 30s | 3× |
| overdue-watch reconciliation sweep | per-batch | — | 30s | 3× |

`WorkflowTaskTimeout` at default 10s (keep workflow code light — deadlock detection).

**Schedules vs timers.** Temporal **Schedules** drive only *system cadence* — daily EOD projections,
periodic overdue-watch reconciliation. *Per-unit contractual dates* use internal durable timers, not
Schedules (a unit's 252 fixings are 252 timers inside its workflow, not 252 Schedules).

**Visibility.** Search attributes `unitId, instrumentKind, underlying, unitStatus, nextWatchDate,
unarmedWatchCount, settlementObligationStatus` let ops query "units with an unarmed watch past window" (M3)
or "settlement-obligation units unsettled across a record date" (ch11) without touching the ledger DB. They
**index a projection of the record and are never the sole home of any fact** — reconcilable against the
record's own projection.

## 6. Reproducibility (C-2.2) and the settlement boundary

Temporal contributes **nothing** to reproducibility; it rests entirely on the record. Any party with record
+ clock recomputes which events should have fired (ch04). Temporal is one executor among possible ones; a
cold rebuild yields the identical events because emission is a function of record+clock. Therefore
**`workflow.Now()` / random / wall-clock never feed a contract** — the clock is consulted *only* in the
Monitor's timer, whose firing produces a *recorded* event; the contract reads the recorded event.
**Settlement (ch11) is a pure projection** and gets **no worker write privilege (M6)**: it reads committed
moves and emits instructions; it proposes nothing to the door. Settlement failure returns as a *recorded
event*, never a Temporal-side reversal.

---

## Decision register (skeleton)

- **D-01:** Temporal runs only the two untrusted machines (Event Monitor + Events Executor); the Transaction Executor and the immutable log stay outside Temporal as the trusted single writer.
- **D-02:** Temporal workflow history is a disposable execution cache, never the book of record — every workflow must be rebuildable by folding the ledger.
- **D-03:** One long-lived workflow instance per *unit*, not per contract-firing and not per watch.
- **D-04:** All side effects live in activities (read projection, run contract, propose-to-door, capture arrival); workflow code does only orchestration.
- **D-05:** Smart contracts run in activities, never in workflow code, so ledger contract logic never enters Temporal's replay/versioning surface.
- **D-06:** Date watches → Temporal durable timers; observation/barrier watches → signals carrying only a log-position pointer, plus an activity that reads the recorded observation.
- **D-07:** The watch lifecycle (declared→armed→fired/expired) is recorded through the door and Temporal only mirrors it; a declared-but-unarmed watch stands as an overdue item on the record independent of Temporal.
- **D-08:** Signals carry timing/pointers only, never observation data (M4), and every signal has a record-derived backstop so a lost signal costs latency, not correctness.
- **D-09:** Corporate-action cascades are a fan-out that signals existing unit workflows; at-least-once fan-out needs no compensation because the door's cause-derived txid is injective over the cascade.
- **D-10:** ContinueAsNew at each period boundary, carrying forward only a record cursor (unitId + resume position), never accumulated business state.
- **D-11:** Temporal's at-least-once activity delivery is absorbed by the door's cause-derived idempotence — no application-level dedupe is added.
- **D-12:** No Temporal worker holds ledger write credentials (M6); the only write path is the propose-to-door activity calling the single Transaction Executor.
- **D-13:** Orchestration code is versioned via Worker Versioning/GetVersion, but frequent ContinueAsNew boundaries plus contracts-in-activities make GetVersion rarely necessary — drain old runs to their next ContinueAsNew.
- **D-14:** External-event capture is an unconditional ingestion activity that proposes the capture envelope (or quarantine) to the door before any workflow routing (M8); workflow loss cannot drop a captured event.
- **D-15:** Task queues split by trust/throughput class (unit-orchestration, door-write tuned to the single writer, ledger-read/contract, market-data ingest) with separate worker pools.
- **D-16:** Temporal Schedules drive only system cadence (daily EOD projections, overdue-watch reconciliation sweeps); per-unit contractual dates use internal durable timers, not Schedules.
