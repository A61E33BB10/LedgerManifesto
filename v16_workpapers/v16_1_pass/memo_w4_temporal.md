# Memo W4 — The Temporal substrate under reordering

Content for one W4 subsection. STYLUS threads it in. The standing register is
`LedgerManifesto/temporalv16.tex` (R-01..R-27); the constitutional anchors are C-2.7 (the
three times, fold in execution order, tail refold) and C-12.6 (reordering is never silent).
Throughout: the immutable log is the sole book of record, and Temporal holds nothing that
survives a wipe.

---

### The three times are ledger data; Temporal supplies none of them

**Arrival and the monitor time.** An arrival reaches the boundary as a push to an ingestion
activity, run by the ingestion worker pool. That activity captures the arrival and proposes
its recording through the one door — the capture envelope, then quarantine-or-route — before
any unit workflow is signalled. Capture precedes routing: the recorded arrival, not the
signal, is the arrival's proof. The monitor time is the observation the ingestion activity
writes into the capture envelope: the time the boundary observed the arrival, recorded as
provenance. It is a value the activity records, never a clock Temporal reads for ordering.
The monitor time orders nothing; it exists so an event's lateness splits into the world's
delay, execution to monitor, and ours, monitor to door.

**Admission and the door time.** The single writer — the Transaction Executor — assigns the
door time when it admits the event, from the ledger's own clock, inside the ledger. The door
activity is only the propose-to-door call; it carries no authority to time the admission.
No Temporal timestamp is ever any of the three times. The workflow clock (`workflow.Now`),
the activity's schedule or start time, and the history event's recorded time are execution-
cache metadata: they vanish when the cluster is wiped, and they order nothing. Execution
time is asserted by the source and carried in the payload; monitor time is the boundary
observation; door time is the writer's stamp. All three live on the log. Temporal reads them
back as data and never writes them.

### Detection and the refold are ledger work, not Temporal work

The out-of-order check runs at the door, on admission. When the writer admits an event whose
execution time precedes events already folded, it detects the insertion and refolds the tail
in execution order, from the insertion point forward. The refold is a fold of the immutable
log by the same version-pinned contracts — a computation inside the trusted single writer.
Temporal does not perform it, observe it, or hold its result; the refold's output is new
admitted transactions on the log, like any other.

**What the affected unit workflows do — one pattern.** A refold changes the ledger state of
every unit whose tail it touched. Each such unit's workflow is **signalled to re-read**: the
refold emits a correction signal carrying only the log position of the reordering (reference
only, no payload), and on that signal the workflow discards its in-memory node mirror and
rehydrates its node and armed-watch set from the refolded ledger projection — cancelling
stale timers and signal-waits, arming the current node's out-edge set. This is the same
rehydration the workflow already runs on start, on ContinueAsNew, and on any doubt; a refold
is exactly "any doubt." The workflow re-fires forward under new cause-derived txids. It never
rewinds its own history.

*Why this pattern and not terminate-and-rebuild.* Rehydration already reconstructs the exact
armed set the refolded ledger implies, so tearing the workflow down and starting a fresh run
buys nothing over re-reading in place — the two converge on the same node and the same
watches. Re-read matches R-23: the workflow re-fires on the correction signal, and Temporal
never rewinds workflow state. The correction signal has a record-derived backstop — the
overdue-watch reconciliation sweep — so a lost signal costs latency, never correctness. If a
refold drives a unit to a terminal node, re-read finds no out-edges and the workflow
completes; if to an earlier node, it re-arms that node's watches. No special path either way.

**The nonconforming pattern, named.** The tempting error is to replay the affected
workflows' Temporal histories as if they were the book — rewinding each workflow to a past
decision and re-running its recorded history against the new fold. This treats Temporal
history as authoritative, smuggling ledger state into the execution cache (violates R-02),
and it produces non-determinism errors on replay because the history was written under the
old fold. Equally forbidden is a Temporal-side saga that "compensates" the workflow's past
actions (R-24). The refold is a ledger fold; the workflow's response is to re-read it, not
to replay itself against it.

### A watch that fired under the old fold

A durable timer may have fired under the old order — a due-date watch that fired because,
before the reordering, the unit still held the position at the record date — and the refold
may leave its predicate false, the position having left earlier in execution time. The
firing already happened and is recorded: arming and firing are recorded acknowledgements
through the door, so the fired watch and any transaction it proposed stand on the log.
Temporal never un-fires; a timer that fired stays fired in history, and the ledger firing
stays recorded.

The re-read workflow reconciles by reading **both**: the refolded ledger state (the
entitlement was never ours) and the recorded firing (the watch did fire, and its proposed
transaction is on the log). It reverses nothing on its own. The refold's C-12.6 flags carry
the reconciliation: the insertion is flagged, every refold-changed state is flagged, and the
difference between what the book said and what it now says is published as a named explain
item. Where the firing already moved settled quantity — a dividend received — that delta
stands as a visible open item and moves back only as an authorised compensating transaction
under C-12.4, proposed through the one door with its own cause-derived txid. Views recompute
automatically; money never does.

### Wipe-and-rebuild is the acceptance test of the mapping

After any reordering, wipe the Temporal cluster and rebuild the whole workflow population
from the refolded log. Each unit workflow rehydrates its node and watch set from the refolded
projection; date watches re-arm as durable timers computed from the declared terms against
the refolded valid-time coordinates; condition watches re-arm as signal-waits over recorded
observations. The recorded firings, the C-12.6 flags, and every open compensating item are
already on the log, so the rebuilt population carries exactly the post-refold operational
state. Because the refold is a pure ledger fold and Temporal held only schedules-in-flight
and orchestration position, the wiped-and-rebuilt state equals the state the in-place
re-read workflows converged to. That equality — reorder-then-wipe-rebuild yields the same
operational state as reorder-in-place — is the acceptance test of the mapping. If the two
differ, state was smuggled into Temporal history, and the mapping is wrong.
