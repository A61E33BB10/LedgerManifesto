# Deferred Settlement — the Temporal substrate framing

**Cell:** deferred-settlement design cell, Round 1. **Author:** temporal-engineer.
**Binding:** `LedgerManifesto/temporalv16.tex` (27-entry unanimous register).
**Grounding:** certified `ledger_v16_0.tex` §11 (settlement-obligation unit) and §9 (event-kind registry, routing, observation door).

§11 already designed deferred settlement: the settlement-obligation unit, `instructed → settled/failed`, the partial edge, the market claim, the due-date trigger reading *cumulative confirmed quantity*. This memo answers one thing — what that unit is when thought natively in Temporal — and flags, not absorbs, where the substrate could drift. Acceptance test throughout (R-02): wipe Temporal and the whole settlement-obligation unit-workflow population re-derives from the ledger. If losing Temporal loses a settlement fact, the framing is wrong.

## The eight headline claims

**1. The workflow is the settlement-obligation unit's own unit-workflow (R-03/R-14) — born `instructed` by signal-with-start on the recorded instruction event, walking its single product graph to `settled`/`failed`; nothing else here is a workflow.**
It is a ledger-created unit — the instruction transaction mints it and re-books `owned` at that instant (§11, trade-date D3) — so per R-14 it starts its *own* workflow via signal-with-start, never as a Temporal child of the trade. Record-first is the backstop (R-27): the unit exists on the log even if the start signal is lost, and the R-09 cadence sweep re-starts any settlement-obligation unit whose workflow is not running.

**2. The activities are the four side-effecting steps — capture the custody witness *through the door*, evaluate the unit's contract on the record-date/due-date firings, propose the transition to the door, emit the settlement instruction at the boundary (egress only); workflow code holds only timers, signal-waits, selectors (R-05).**
Capture records the confirmation or fail notice as a moveless observation-recording transaction through the one door *before any signal exists* (R-12, §9). Evaluate is `EvaluateContract`, version-pinned and queue-routed, never a local activity (R-06/R-26). Propose-to-the-door is the single idempotent write activity (R-01/M6). Emit-the-instruction reads the committed move and the unit's node and pushes the ISO 20022 message out — **it writes nothing** (R-24, §11).

**3. A timer firing at t_d is the due-date watch's liveness half and carries no data (M4): on firing, an activity reads the record — cumulative confirmed quantity against instructed Q — and the *contract*, not Temporal, proposes `settled` / partial-split / `failed`.**
The due-date watch is a date watch, hence an in-workflow durable timer (R-08). §11 is explicit that this trigger "reads quantity, not mere presence": the timer only wakes the unit; the quantity and the decision come from the record and the contract.

**4. A witness signal carries only the log-position / causeEventId of an already-recorded custody confirmation (R-11/R-12); it is a latency optimisation over the t_d backstop, so a lost signal costs latency, never the record.**
Capture precedes routing, so the confirmation is on the log before the signal fires; the signal carries reference and timing only, never the confirmed quantity (M4). Lose the signal and the t_d timer of claim 3 still wakes the unit, reads the same recorded quantity, and reaches the same terminal node — later, identical.

**5. The window [T, t_d] is the workflow's quiet wait — T = workflow start (owned already re-booked at instruction, D3); the window = a durable timer plus signal-waits equal to the `instructed` node's out-edge set (R-04); t_d = the timer; the cycle length T+0..T+5 is *just the timer duration read from the declared terms* (`dueDate`).**
No separate machinery for the window: one timer, a few signal-waits (confirm→settled, partial→split, fail/deadline→failed, record-date→market-claim). **T+0 collapse means the timer duration is zero, so the timer is immediate — no special path.** T+0 atomic settlement and a T+5 cross-border fail are one construction parameterised by timer length; the substrate never branches on the cycle.

**6. Fails and partials are *ledger* transitions (contract proposes, door admits, UnitStatus records); Temporal only re-arms watches — and the partial-split's failed-residual leg is a genuinely new unit-workflow (R-14), while the fails edge and the market-claim branch stay in the same workflow.**
Three cases the register keeps distinct: (a) `instructed → failed` is the *same* unit at a later node — same workflow, a ContinueAsNew boundary (R-15); (b) the market-claim leg is a *branch of the unit's own graph* — same workflow (R-14); (c) the partial edge mints two *new* units, so the parent workflow **completes** and each leg starts its own workflow by signal-with-start (R-14/DL-02). No Temporal-side compensation or saga rollback anywhere (R-24): a fail is a recorded event walking the graph.

**7. Temporal must never own the in-flight quantity, the reconciliation-identity inputs, or the witness facts.**
The in-flight quantity (`q_s`, `Q`, `q_r`) lives on the log; timer and signals carry none of it (M4). The routing-identity inputs — the `owned` plane, cum/ex status, the settlement node, the market-claim signs — are recorded facts the contract reads, never Temporal state. The witness facts (sese.025/camt.054/fail notices) are observations captured through the door under envelope, never sole-recorded in a signal (R-12). Strip Temporal and all of it survives: node re-read from UnitStatus, timer re-armed from `dueDate` (R-02).

**8. The mapping is consistent with the register — it restates §11's trust boundary — with two precision flags for Round-2, neither a contradiction.**
*Flag A (split ≠ ContinueAsNew).* The partial edge is a node transition but must **not** use ContinueAsNew: that continues the *same* `unitId`, whereas the split legs are *new* units (R-14). Smuggling them into the parent's identity would lose the fails-cascade's per-leg txid separation. *Flag B (per-unit egress must inherit projection idempotence).* §11's `settle` is a whole-ledger projection; placing egress inside each unit-workflow is faithful *only if* the emit dedupes on the recorded settlement node exactly as the projection does — idempotence riding (unit, node), never a Temporal run/attempt id, the same discipline as the door's cause-derived txid (R-07).

---

*Confidence: HIGH on the architecture mapping and the negative space (they restate §11's trust boundary). The two flags are the load-bearing seams for Round-2 — places an implementation drifts silently, not places the register is wrong.*
