# TE-2 — Temporal as Execution Substrate for Ledger v16.0 (Round 0)

**Standing constraint honoured throughout.** Temporal runs the *untrusted* machinery only. The
immutable transaction log stays the sole book of record; every Temporal workflow history is
disposable and must be reconstructible *from* the ledger, never the reverse. Where Temporal and
the Constitution appear to offer the same guarantee, the Constitution's wins and Temporal's is
demoted to liveness.

## 1. Where Temporal sits, and where it must not

v16 already draws my boundary for me (ch04, "The Machines"). Three machines, one writer. The
**Transaction Executor** is the trusted component and the *only* writer; the **Event Monitor** and
the **Events Executor** sit outside the trust boundary and may only propose. Temporal is the
durable runtime for those two untrusted machines and for nothing else. It never becomes the
Transaction Executor, never holds a private store of unit state, and never computes economics.

The load-bearing fact that makes this clean: *replay re-reads admitted transactions and never
re-executes contracts* (ch02, "Not event sourcing"; §1 "Full reproducibility", C-2.2). The
ledger's own reproducibility does **not** depend on Temporal at all. Temporal buys liveness (M1–M8
are liveness/replay properties), not integrity.

## 2. Workflow / activity boundary

- **Workflow = orchestration.** One long-lived workflow *per unit*, mirroring the unit's **product
  graph** (ch03, "Term Sheets as Graphs"): nodes = lifecycle states, out-edges = the current watch
  list. The workflow holds timers, signal waits, and activity calls — nothing else. It carries no
  economics and no state the ledger cannot rebuild.
- **Activities = every side effect.** `readLedgerProjection` (contract input), `computeProposal`
  (fire the pure contract), `submitToDoor` (call the real Transaction Executor — the *only* write),
  `recordObservation` (boundary capture), `emitSettlementInstruction`.
- **The contract runs in an activity, never in workflow code.** This is the decisive call. A smart
  contract is a *versioned* pure function (ch03). If it ran inside the workflow, a contract-version
  change would break Temporal replay determinism — coupling the ledger's economics to Temporal's
  history, exactly what ch02 forbids. Keeping it in an activity keeps the two replay mechanisms
  decoupled: the ledger replays by re-reading transactions; Temporal replays by re-reading its
  history; neither touches the other. This also satisfies **M4** — the trigger carries *timing*;
  all data is read from the record inside the activity.

## 3. Watches: declared → armed → fired/expired

The handshake (ch04) maps directly onto Temporal primitives, with one hard rule: **arming is a
recorded fact, not merely a Temporal-internal timer.**

| Stage | Ledger meaning | Temporal mechanism |
|---|---|---|
| declared | out-edge recorded in unit state | product-graph node written via the door |
| armed | Monitor acknowledges | **durable timer** (date watch) or **signal wait** (condition watch) established **AND** an acknowledgement event written through the door |
| fired | traversal | timer fires / observation signal arrives → `computeProposal` → `submitToDoor` |
| expired | sibling edge dies | sibling timer elapses; workflow retires the edge |

- **Date-based watches** (expiry, coupon, record/payment date, VS-1's 252 fixings) → **durable
  Temporal timers** (M1). Timer state persisted, survives restart.
- **Condition-based watches** (OT-1's barrier close ≤ 80) → **not** timers. The Monitor cannot poll
  the wall clock for a barrier; it evaluates *recorded observations*. So: the observation is
  captured at the boundary first, then a signal wakes the unit-workflow to re-evaluate the guard.
- **Schedules vs durable timers.** Use Temporal **Schedules** only for cross-unit calendar cadence
  (daily settlement-print sweep, an EOD arm-check sweep). A single unit's specific dates are
  per-workflow durable timers — 252 fixings are 252 timers in the unit-workflow, never 252
  Schedules.

## 4. Signals vs Updates; child workflows

- **Updates** for boundary event submission where the caller must know the outcome — returns the
  **capture receipt** (recorded *or* quarantined, plus log position). The Update handler only
  validates the envelope and enqueues; `submitToDoor` does the write, so a handler retry is safe
  (txid idempotence). **Signals** for fire-and-forget liveness nudges (“a new observation landed,
  re-evaluate”). At-least-once signals are safe because the door dedups.
- **Child workflows.** A **corporate-action cascade** (one cause → many referencing units, ch04
  idempotence derivation) is a parent fan-out workflow that fans to each unit-workflow; each applies
  its own adjustment under its own txid (the injective-cascade property). The parent owns no
  economics. A **settlement-obligation** is itself a unit (ch11) → its own child workflow
  (`instructed → settled/failed`); settlement failure is a *recorded external event through the
  door*, **never** a Temporal compensation or reversal (ch11: “failure is a recorded event, never a
  reversal”).

## 5. History size, ContinueAsNew, versioning

- **A unit lives years** (252+ fixings, quarterly coupons). ContinueAsNew **at each product-graph
  node transition**, and **per fixing-batch** (e.g. every 20 fixings) for accrual units like VS-1.
  Because the workflow holds nothing the ledger cannot rebuild (M5), the carried input is minimal:
  `(unitId, nodeId)`. On start the workflow **re-derives its armed watch set from the unit's
  recorded state** (the out-edges of the current node). ContinueAsNew is therefore free.
- **Versioning, cleanly separated.** Temporal versions *orchestration only* (Worker Build-ID
  versioning / `GetVersion` for the rare structural change). The ledger versions *economics*
  (ProductTerms + named versioned pure functions) entirely outside Temporal's replay concern.
  Node-boundary ContinueAsNew points double as version-cutover points — new runs adopt new
  workflow code with no in-flight history migration.

## 6. Task queues and worker topology

Split by trust and scaling: `event-monitor` (timer-heavy watch workflows), `contract-exec`
(proposal activities — CPU, versioned code), **`ledger-door` (low concurrency — the trusted write
path; must not be co-scaled with fan-out work)**, `ingestion` (boundary capture), `settlement`
(instruction emission + confirmation waits). The door worker just calls the real Transaction
Executor, which enforces the single-writer total order and refuses non-commuting concurrent
proposals (C-2.7); Temporal's at-least-once is safe *because* the door serialises and dedups.

## 7. Timeout table (key activities)

| Activity | StartToClose | ScheduleToClose | Heartbeat | Retry |
|---|---|---|---|---|
| `readLedgerProjection` | 5 s | 30 s | — | unlimited (idempotent read) |
| `computeProposal` (pure contract) | 10 s | 1 min | — | unlimited (pure) |
| `submitToDoor` (write) | 15 s | 5 min | — | unlimited + backoff (txid → commit-once) |
| `recordObservation` (capture) | 10 s | unbounded until on record | — | unlimited (M8, no captured event lost) |
| `emitSettlementInstruction` | 10 s | 1 min | — | unlimited (pure/idempotent) |
| external-infra bridge (if any long poll) | 30 s | agreement-driven | **30 s** | bounded → overdue item |

Note: long *waiting* (settlement confirmation, quarantine disposition, precedence resolution) is
done by the **workflow** via signal-wait + a deadline **timer** (→ overdue item, **M7**), never by a
blocking activity. Only genuine long-poll bridges heartbeat.

## 8. Visibility / search attributes

Index `unitId`, `productType`, `currentNode`, `nextWatchDue`, `overdueWatch` flag,
`settlementObligationStatus`, `lastCauseEventId`, counterparty wallet. Ops then query *M3* overdue
armed watches, *M7* obligations past deadline, and *M8* quarantined events awaiting disposition —
without polling the ledger DB. These attributes are a derived secondary index, not a source of
truth.

## 9. Failure-model alignment

| Temporal gives | Constitution demands | Verdict |
|---|---|---|
| durable timers across restart | M1 durable watches/timers | direct match |
| at-least-once activity execution | M2 at-least-once emission | match; door txid makes duplicates harmless |
| exactly-once workflow state transitions (event-sourced) | M5 replayable orchestration (Monitor's own state) | match — for the *untrusted* machine's state only |
| workflow determinism | M4 triggers carry timing not data | match, *iff* contracts stay out of workflow code |
| — (nothing) | single-writer total order | **ledger's** Transaction Executor, not Temporal |
| — (nothing) | cause-derived idempotence | **ledger's** txid, not Temporal request-id dedup |
| — (nothing) | C-2.2 any-party reproducibility | **ledger log**, recomputable with no Temporal at all |

**The test that proves the constraint holds:** delete the entire Temporal cluster. Every workflow
is reconstructed from the ledger log — re-derive armed watches from unit state, re-arm timers,
resume. Temporal history is disposable; the ledger log is authoritative. **Rejected on sight:** any
workflow computing economics; Signals/queries used as a unit-state store; a settlement confirmation
that lives only in Temporal and never reaches the door; a local-activity contract whose result is
not submitted through the door.

---

## Decision Register Skeleton

- **D-01:** Temporal runs the two untrusted machines (Event Monitor + Events Executor) only; the Transaction Executor and the immutable log stay outside Temporal and remain the sole book of record.
- **D-02:** One long-lived workflow instance per unit, keyed by `unitId`, mirroring the unit's product graph — not one per contract-firing, not one per book.
- **D-03:** The smart contract runs in an activity, never in workflow code, so contract/economics versioning never perturbs Temporal replay (ledger replays by re-reading transactions; Temporal by re-reading its history; the two stay decoupled).
- **D-04:** Every side effect is an activity (read projection, compute proposal, submit to door, record observation, emit instruction); workflow code holds only timers, signal waits, and activity calls.
- **D-05:** All writes funnel through a single `submitToDoor` activity calling the real Transaction Executor; Temporal never writes ledger state and never parallelises writes around the door.
- **D-06:** Idempotence is the ledger's cause-derived txid, not Temporal request dedup; at-least-once activities are therefore safe by construction (duplicate submit → same txid → committed once).
- **D-07:** Date-based watches → durable Temporal timers; condition-based watches (barrier breach) → signal-driven evaluation over recorded observations, never a timer poll.
- **D-08:** declared = out-edge recorded in unit state; armed = timer/condition established **and** acknowledgement event written through the door; fired = timer/signal → contract activity; expired = sibling-edge timer elapse — arming is a recorded fact, not a Temporal-internal detail.
- **D-09:** Corporate-action cascade = parent fan-out workflow to each referencing unit-workflow; each applies its own adjustment under its own txid (injective cascade); the parent owns no economics.
- **D-10:** The settlement-obligation is its own unit-workflow (instructed→settled/failed); settlement failure is a recorded external event through the door, never a Temporal compensation/reversal.
- **D-11:** Boundary event submission uses Updates when the caller needs the capture receipt (recorded/quarantined + log position); internal liveness nudges use Signals; Update handlers only enqueue, the door does the write.
- **D-12:** ContinueAsNew at each product-graph node transition and per fixing-batch for accrual units; carried input is only `(unitId, nodeId)` — all watch state re-read from the ledger, since the workflow holds nothing the ledger cannot rebuild (M5).
- **D-13:** Temporal versions orchestration only (Build-IDs / GetVersion); the ledger versions economics (ProductTerms + named pure functions); neither leaks into the other, and node-boundary ContinueAsNew points are the version-cutover points.
- **D-14:** Task queues split by trust/scaling: `event-monitor`, `contract-exec`, `ledger-door` (low-concurrency trusted write path), `ingestion`, `settlement`; the door queue is never co-scaled with fan-out work.
- **D-15:** Search attributes index unitId, product type, current node, next-watch-due, overdue-watch flag, settlement-obligation status, last causeEventId — so M3/M7/M8 overdue and quarantine items are queryable without polling the ledger DB.
- **D-16:** If the Temporal cluster is lost, every workflow is reconstructed from the ledger log (re-derive armed watches, re-arm, resume); Temporal history is disposable, the ledger log authoritative — the standing constraint made operational.
