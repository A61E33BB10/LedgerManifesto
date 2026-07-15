# Unified Decision Register — Round 1 (consolidated from TE-1..TE-5 Round-0 skeletons)

Rule on EVERY entry: AGREE or DISPUTE (one-sentence reason). Entries consolidate overlapping
Round-0 decisions; where instances differed, the entry states the majority Round-0 form and the
variant in brackets.

- R-01: Temporal runs ONLY the two untrusted machines (Event Monitor + Events Executor); the
  Transaction Executor is an external single-writer service outside Temporal, fronted by one
  idempotent propose/submit-to-door activity — the only write path (M6).
- R-02: The ledger log is the sole book of record; Temporal history is a disposable execution
  cache. Acceptance test: wipe the Temporal cluster and the entire workflow population re-derives
  from the ledger (UnitStatus re-read, watches re-armed).
- R-03: One long-lived workflow instance per unit, keyed by unitId (variant TE-5: WorkflowID =
  lineageId:unitId to make forks first-class), walking the unit's product graph; not per
  contract-firing, not per watch, not per book.
- R-04: The workflow's in-memory node/watch set is a mirror, never authoritative; pending timers
  and signal-waits equal the current node's out-edge set (graph-consistency (i)); rehydrated from
  the ledger on start, ContinueAsNew, or any doubt.
- R-05: Every side effect is an activity (capture arrival, fetch projection, evaluate contract,
  propose to door, emit settlement instruction); workflow code holds only timers, signal-waits,
  selectors, sequencing.
- R-06: Smart contracts run in version-pinned ACTIVITIES, never in workflow code — ledger
  economics versioning never enters Temporal's replay/versioning surface.
- R-07: Idempotence is the door's cause-derived txid computed from recorded inputs (never
  Temporal run/attempt ids); Temporal at-least-once activity delivery is absorbed exactly-once at
  the door; Temporal's own dedup is tolerated as optimisation, never trusted for correctness.
- R-08: Date-based watches = in-workflow durable timers; observation/condition watches (barrier)
  = signal-driven evaluation against recorded observations, never a timer poll.
- R-09: Temporal Schedules are reserved for system cadence (EOD sweeps, overdue-watch
  reconciliation, settlement print); per-unit contractual dates NEVER use Schedules.
- R-10: The watch lifecycle declared→armed→fired/expired is authoritative in the ledger; arming
  writes the recorded acknowledgement through the door; Temporal supplies only the liveness half
  (M1, M3).
- R-11: Signals carry timing + reference (causeEventId / log position) ONLY, never economic
  payload (M4); every signal has a record-derived backstop so a lost signal costs latency, never
  correctness.
- R-12: Capture precedes routing: a pushed arrival is recorded through the door (capture
  envelope, quarantine-or-route) by the ingestion activity BEFORE any workflow signal (M8,
  TA-ARRIVAL); Temporal signal delivery is never the sole record of an arrival.
- R-13: Updates are used where the caller needs the door's admit/refuse synchronously — human
  gates (forward repair authorisation, quarantine disposition, authorised fork) and boundary
  submissions needing a capture receipt; Queries are a non-authoritative liveness view.
- R-14: Unit-creating events (settlement-obligation unit, market-claim legs, partial-split legs)
  spawn CHILD workflows with their own deadline/discharge/fallback (M7 saga); corporate-action
  cascades to EXISTING units fan out as signals (driven by a parent CA workflow), each firing
  proposing its own txid — cascade injectivity, no compensation logic.
- R-15: ContinueAsNew at product-graph node transitions and every K fixings/period, carrying only
  {unitId, nodeId, lineageId/log-cursor} — no business state; ContinueAsNew rehydration and
  disaster recovery are the same re-derivation.
- R-16: No WorkflowRunTimeout/ExecutionTimeout on unit workflows; liveness is bounded by armed
  watch windows (M3) and obligation deadlines (M7) surfaced as overdue items, never by killing
  the run. Door activity: short StartToClose + unlimited retry (safe under txid). Long external
  waits = timer + signal, never long heartbeated activities; only egress/batch activities
  heartbeat.
- R-17: Two versioning axes stay separate: Temporal Build-IDs/GetVersion govern orchestration
  only (with ContinueAsNew boundaries as cutover points, GetVersion rarely needed); ProductTerms
  versions on the log govern economics and alone bear C-2.2.
- R-18: Task queues split by trust AND scaling: door (sole write credential, serialized, back-
  pressure alarmed), contracts (read-only, CPU, versioned), ingestion (must-not-lose), monitor/
  unit-orchestration (idle-many), settlement (egress-only). Write privilege confined at the
  infrastructure boundary.
- R-19: Search attributes (unitId, currentGraphNode, nextWatchDue, obligationDeadline/status,
  overdue flag, quarantine flag, counterparty, causeEventId) are an ops projection derived from
  and reconciled to the ledger — never authoritative; audit reads the ledger.
- R-20: Authorised forks (C-12.5) run in an isolated namespace against the forked lineage's
  ledger, never sharing the production door; simulated ledgers likewise (separate namespace,
  shadow door); lineage identity rides the WorkflowID (see R-03 variant).
- R-21: Economic errors are repaired forward through the door (authorised compensating
  transaction), never by editing workflow code and replaying; a Temporal non-determinism bug
  degrades to a liveness/overdue incident, never wrong ledger state.

Also rule on: R-03's lineageId variant (adopt or plain unitId?).
