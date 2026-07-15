# TE-5 — Round 0: Temporal as the execution substrate for Ledger v16.0

**Standing constraint restated and accepted.** The ledger log is the sole book of record.
Temporal workflow histories are never the source of truth. Any design where Temporal owns
state the ledger cannot reconstruct is rejected. This paper is a substrate proposal, not an
amendment; it changes no clause.

## 1. The one-sentence mapping

Temporal runs the two **untrusted** machines — the Event Monitor and the Events Executor —
and **never** the Transaction Executor. Ch04 already draws the boundary: three roles, one
writer, and the writer is trusted while the other two are not. Temporal is exactly a
liveness-and-durability engine for the untrusted side (M1–M8 are liveness/replay properties,
§16). It supplies durable timers, at-least-once delivery, and replayable orchestration; it is
denied write privilege by construction. Everything Temporal touches degrades, when it fails,
to a *visible overdue item*, never to wrong ledger state — which is precisely the guarantee
Ch04 §"trust boundary" already proves for the two machines Temporal is standing in for.

## 2. Workflow / activity boundary — every side effect is an activity

**Workflow code (deterministic orchestration, no side effects):** the product-graph traversal
of a single unit (Ch03 §termsheet-graphs). The workflow holds the current node, arms the
out-edge set as durable timers/signal-waits, uses a `Selector` so the first guard to fire
traverses and expires its siblings (Invariant graph-consistency iv), then invokes activities.
It carries **no ledger data** — only identifiers — honouring M4 (triggers carry timing, not
data).

**Activities (all side effects live here):**
- `CaptureArrival` — stamps the capture envelope and proposes the moveless observation-
  recording transaction *before* validation (M8, Ch04 Events Executor). At-least-once; unbounded retry.
- `EvaluateContract` — reads the current projection, runs the **pure, stateless** contract
  (Ch05) as a named versioned function, returns the proposal. Keeps the projection out of
  workflow history (bounds size; serves M4).
- `ProposeTransaction` (the door) — hands the txid-bearing proposal to the Transaction
  Executor and returns admit/refuse. The **only** activity with write credentials.
- `EmitSettlementInstruction` — the settlement projection (Ch11): reads the committed log,
  emits instructions to external infra, **writes nothing** to the ledger.

Arming a watch is not a separate primitive: it is a `ProposeTransaction` of the acknowledgement
transaction (Ch04 handshake), so *declared → armed → fired/expired* is a sequence of door writes,
each on the record (M3).

## 3. Signals vs Updates, children, fan-out

- **Signals** deliver external events (fixings, corp-action notices, settlement confirms/fails)
  to a unit-workflow, carrying **only** the `causeEventId`/log position (M4). The authoritative
  write already happened in `CaptureArrival`, so delivery is genuinely fire-and-forget; a
  double-delivered signal re-fires the contract and the door dedups (M2). 
- **Updates** serve the human-in-the-loop gates — forward-repair authorisation, authorised-fork
  authorisation (Ch14, C-12.5), quarantine disposition (M8) — because the operator needs the
  door's admit/refuse returned synchronously.
- **Child workflows** model **settlement-obligation units** (Ch11): each instructed trade spawns
  a child with its own deadline timer, discharge test, and fallback — the obligation-liveness
  saga (M7). Independent failure domain, own timeout policy.
- **Corporate-action cascade** is a **signal fan-out** to the *existing* workflows of every
  referencing unit (enumerated from a projection), not a child spawn — the units already have
  long-lived workflows; each firing proposes its own txid and the door commits n distinct
  transactions (Ch04 injective-over-cascade).

## 4. Task queues and worker topology — trust is enforced at the queue

Queues split by role **and** by credential, so M6 (no write privilege) is an infrastructure
fact, not a code convention:

| Queue | Runs | Credential |
|---|---|---|
| `monitor` | unit-workflows (Event Monitor + traversal) | none |
| `door` | `ProposeTransaction` only | **sole ledger write** |
| `contracts` | `EvaluateContract` | read-only |
| `ingestion` | `CaptureArrival` | append-observation only |
| `settlement` | `EmitSettlementInstruction` | external egress only |

Only `door` workers hold the write capability; losing sticky execution or a whole worker fleet
costs timeliness, never integrity.

## 5. Timers/Schedules, history size, versioning

- **Durable timers** inside the unit-workflow arm every date/condition guard (record date,
  payment date, expiry, each of the 252 variance-swap fixings). A fixing timer fires with no
  value (M4); the workflow then checks the record for the observation, and if it never arrived
  the armed watch **stands overdue** (M1/M3/M7, TA-ARRIVAL). **Schedules** are reserved for
  system cadence: daily settlement-print sweep, EOD NAV projection, an overdue-watch reconciliation
  sweep.
- **ContinueAsNew** fires at each graph-node transition or every K fixings, carrying only
  `{unitId, nodeId, lineageId}`. The accrued payload is rehydrated from the ledger's
  UnitStatus/PositionState, never carried in history — safe precisely because nothing
  authoritative lived only in Temporal. A unit that lives years never accumulates an unbounded
  history.
- **Two versioning axes, kept apart.** Orchestration-code changes ride Temporal Worker
  Versioning, or simply ContinueAsNew onto the new build at a node boundary (cheap because carry-
  over state is minimal). Contract-*computation* changes are a **new versioned pure function plus a
  new ProductTerms version appended to the unit** (Ch03) — a ledger event, reproducible by any
  party from the log. Only this second axis governs C-2.2 replay; Temporal deployments are
  invisible to it.

## 6. Timeout table (key activities)

| Activity | StartToClose | ScheduleToClose | Heartbeat | Retry |
|---|---|---|---|---|
| `ProposeTransaction` (door) | 5 s | 1 min | — | exp, unbounded (idempotent) |
| `EvaluateContract` | 10 s | 2 min | — | exp, ~10 |
| `CaptureArrival` | 5 s | unbounded | — | **unbounded — must never drop (M8)** |
| `EmitSettlementInstruction` | 30 s | ≤ obligation deadline | 10 s | exp, then mark overdue |
| `ReconcileOverdueWatches` (sched.) | 1 min | 5 min | 30 s | exp |

Obligation *waiting* is a **durable timer + signal**, never a long blocking heartbeated
activity — the classic anti-pattern that would pin a worker slot for days.

## 7. Visibility

Search attributes `{currentNode, nextDeadline, overdueFlag, obligationState, underlyingRefs,
productKind, lineageId}` let ops query "units with an overdue watch", "obligations past
deadline", "units referencing ACME" without polling the ledger DB. They are a **projection of
ledger state**, refreshed from it — never authoritative.

## 8. Failure-model alignment

**Temporal gives, and the Constitution consumes:** durable timers → M1; at-least-once activities
→ M2 (duplicates neutralised by the door's cause-derived txid); event-sourced workflow determinism
→ M5 (orchestration replay only); auto-retry-with-backoff → M7.

**Temporal does NOT give — the design supplies it:**
- *Single writer.* No Temporal concept. Supplied by confining write credentials to `door`.
- *Idempotence.* Temporal dedups by run+activity-id; the ledger dedups by `H(cause,contract,unit,seq)`,
  which holds across **different runs, replays, forks, and even a non-Temporal re-driver**. The door
  computes txid itself and never trusts Temporal's dedup for correctness.
- *Any-party reproducibility (C-2.2).* Temporal history is excluded from the record. If all Temporal
  state is lost, the entire workflow population is re-derivable from UnitStatus (each unit's node +
  out-edge set) and re-armed. **Temporal is disposable; the ledger is not.** Ledger replay (Thm
  replay) re-folds the log without re-executing contracts and without touching Temporal at all.

Non-commuting concurrent proposals with no declared precedence are refused at the door (C-2.7);
the workflow surfaces the refusal as a blocked/overdue item awaiting a declared precedence signal.
Temporal concurrency never creates ledger order; the door's monotonic single-writer sequence does.

---

## Decision register skeleton

- **D-01:** The Transaction Executor is an external single-writer service Temporal *calls*, never a Temporal workflow/activity that owns state; Temporal holds no write privilege (M6).
- **D-02:** One long-running workflow instance per unit (its product-graph state machine), WorkflowID = `lineageId:unitId` — not per contract-firing, not per watch.
- **D-03:** The workflow's in-memory node is a mirror, never authoritative; it is rehydrated from the ledger's UnitStatus on start / ContinueAsNew / any doubt.
- **D-04:** Every side effect is an activity; workflow code only traverses the graph and waits. The four side-effecting activities are CaptureArrival, EvaluateContract, ProposeTransaction, EmitSettlementInstruction.
- **D-05:** Date/condition guards are durable timers inside the unit-workflow; Temporal Schedules are reserved for system-cadence sweeps (settlement print, EOD NAV, overdue-watch reconciliation).
- **D-06:** External events reach unit-workflows as Signals carrying only the causeEventId/log-position (M4); the payload is read from the record via activity.
- **D-07:** Human-in-the-loop gates (forward-repair, authorised-fork, quarantine disposition) use Updates, returning the door's admit/refuse to the operator.
- **D-08:** Settlement-obligation units are child workflows with their own deadline timer, discharge test, and fallback — the obligation-liveness saga (M7).
- **D-09:** The corporate-action cascade is a Signal fan-out to existing referencing-unit workflows, not a child spawn; each firing dedups independently at the door.
- **D-10:** Ledger idempotence is the door's `txid = H(cause,contract,unit,seq)`; Temporal's activity dedup is not trusted for correctness, only tolerated as redundant optimisation.
- **D-11:** Task queues split by role AND trust — `door` (sole write credential), `contracts` (read-only), `ingestion`, `settlement` (egress-only), `monitor` — confining write privilege at the infrastructure boundary.
- **D-12:** ContinueAsNew fires at each node transition or every K fixings, carrying only `{unitId, nodeId, lineageId}`; accrued payload is rehydrated from the ledger, never carried in history.
- **D-13:** Two versioning axes are separate: orchestration-code changes ride Worker Versioning / ContinueAsNew-onto-new-code; contract-computation changes are a new versioned pure function plus a new ProductTerms version appended to the ledger — only the latter governs C-2.2 replay.
- **D-14:** Temporal history is excluded from the record; if all Temporal state is lost, the full workflow population is re-derived from UnitStatus and re-armed. Temporal is disposable substrate.
- **D-15:** Search attributes are a convenience projection of ledger state for ops queries — never authoritative, always refreshed from the ledger.
- **D-16:** Obligation waiting is a durable timer + signal, never a long-blocking heartbeated activity; only external egress and batch reconciliation activities heartbeat.
