# Unified Decision Register — Round 2 (amended per Round-1 rulings)

Round-1 tally: R-01,02,04–12,15,17–21 unanimous AGREE (carried; not re-voted). Amendments below
resolve the three disputes and add six entries from the missing-decision returns. Rule AGREE or
DISPUTE on EACH of: R-03v, R-13', R-14', R-16', R-22..R-27. One line each.

- R-03v (was the lineageId variant; Round-1 split 3–2): WorkflowID = PLAIN unitId in the
  authoritative production namespace — lineage is a namespace-level fact (R-20 isolates every
  fork and simulation in its own namespace with its own door), so embedding lineageId in the
  production key is redundant and wrongly implies co-habitation; lineageId:unitId is RESERVED for
  shared simulation/exploration namespaces where non-authoritative lineages deliberately
  co-locate; a rebooting workflow learns its lineage from its namespace binding, which survives
  ContinueAsNew and DR (answering TE-3's rehydration concern).
- R-13': Updates are for HUMAN GATES ONLY (forward-repair authorisation, quarantine disposition,
  authorised fork), returning the door's admit/refuse to the operator; boundary/arrival capture
  NEVER rides a unit-workflow Update — it goes through the stateless ingestion→door path (R-12),
  else Temporal is briefly the sole record of an arrival (M8/TA-ARRIVAL). Queries remain a
  non-authoritative liveness view.
- R-14': Unit-creating events (settlement-obligation unit, market-claim unit, partial-split
  successor legs) START the created unit's OWN INDEPENDENT unit-workflow keyed by its unitId
  (signal-with-start; no Temporal parent-child linkage — parental coupling is ledger-absent
  relational state, and M7 deadline/discharge/fallback lives on the created unit's own graph);
  branches of a unit's OWN product graph (the market-claim BRANCH at a node) are traversed by
  that unit's single workflow, never fragmented into children; corporate-action cascades to
  EXISTING units fan out as signals, each firing proposing its own txid.
- R-16': No WorkflowRunTimeout/ExecutionTimeout on unit workflows; liveness bounded by armed
  watch windows (M3) and obligation deadlines (M7) as overdue items. Door activity: short
  StartToClose with unlimited retry FOR TRANSIENT/INFRA FAILURES ONLY — a door REFUSAL is a
  RETURNED VALUE, not a retryable error (see R-22). Long external waits = timer + signal; only
  egress/batch activities heartbeat.
- R-22 (new): A door refusal (C-2.7 non-commuting with no declared precedence; inadmissible
  proposal) breaks the retry loop and surfaces as a visible blocked/overdue item awaiting a
  resolution signal (declared precedence or corrected proposal) — never retried to infinity,
  never a workflow crash; refusal is a returned value.
- R-23 (new): A late/back-dated observation is an ordinary capture-through-the-door arrival; the
  affected unit-workflows re-fire on the correction signal with a NEW cause-derived txid (forward
  correction, never a duplicate); the valid-time re-derivation of derived tails is a pure ledger
  fold — Temporal NEVER rewinds or edits workflow state for a bitemporal correction.
- R-24 (new): Settlement failure returns as a recorded external event through the door and walks
  the settlement-obligation unit's graph — never modeled as a Temporal-side compensation/saga
  rollback; the settlement projection holds no write privilege and proposes nothing.
- R-25 (new): The workflow's signal-arrival order is orchestration sequencing ONLY, never the
  committed order; where two proposals do not commute, the door enforces declared precedence or
  refuses (C-2.7) — the ledger's total order is decided at the door alone.
- R-26 (new): EvaluateContract is a NORMAL queue-routed activity on the contracts queue, never a
  local activity — a local activity rides the orchestration worker's lifetime and code version,
  re-coupling contract versioning to workflow code against R-17's two-axis separation.
- R-27 (new): Signals/fan-out to a unit whose workflow may not be running (or is mid-
  ContinueAsNew) use signal-with-start; record-first capture (R-12) remains the correctness
  backstop, so delivery loss costs latency, never the record.

---
## CONVERGENCE RECORD
Round 0: five independent papers. Round 1: 18/21 unanimous; disputes R-13 (TE-1), R-14 (TE-2,
TE-5), R-16 (TE-1, TE-3); variant split 3-2; six missing decisions raised. Round 2 (amended
register): 49/50 rulings AGREE; sole dispute TE-2 on R-14'. Round 3 (scoped fact-check against
the certified v16.0 partial-edge text): TE-2 withdraws — "each split leg is a genuinely new unit
in the ledger's own terms". FINAL STATUS: UNANIMOUS on all 27 entries (R-01..R-27 as amended).
No Decision Panel required. Independence caveat (recorded, not absorbed): the five instances
share the temporal-engineer agent type's persistent memory; TE-5 disclosed consulting it, so
Round-0 independence is partial — mitigated by the adversarial round structure and the
fact-check discipline.
