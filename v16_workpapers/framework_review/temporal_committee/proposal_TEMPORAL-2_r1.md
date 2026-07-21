# Temporal Committee — Proposal TEMPORAL-2, Round 1

**Stance.** The seed (`temporalv16.tex`) settles the *ledger* side: Temporal runs the two untrusted
machines, the door stays outside as single writer, history is a disposable cache. This proposal
*extends the same discipline unchanged* to market data and valuation. The extension needs no new
primitive: every market-data and valuation object is already either (a) an event through the one
door, (b) a version-pinned pure evaluation, or (c) a projection over the record — which are exactly
the three activity classes the seed already defines. The spec's own `\subsection{The orchestration
substrate}` (ch.4, `sec:substrate`) is the governing clause; the seed is its "orchestration
companion," and this proposal must not contradict it. **The spec's three times are execution /
monitor / door** — not trade/valid/decision — and only execution time orders the fold.

---

## 1. Mapping table

| Temporal primitive | Framework object it runs | Binding note |
|---|---|---|
| Long-lived workflow, key `unitId` | a unit walking its product graph; pending timers + signal-waits **=** the current node's armed watch set | in-memory node is a mirror, rehydrated from the record; never authoritative |
| Long-lived workflow, key `unitId` (ledger-created) | settlement-obligation unit (`instructed→settled/failed`), market-claim unit, split successor legs | started by signal-with-start, no parent–child coupling |
| Workflow in isolated namespace, key `lineageId:unitId` | a **simulated path** (MD-11): risk scenario, Monte-Carlo path, or **backtest** strategy unit over a trajectory | runs against its own lineage's door, never the production door |
| Activity — ingestion, I/O | Events Executor **capture**: envelope-first, provenance-first (B1), capture-before-judgement (MD-2) | proposes a moveless observation-recording transaction |
| Activity — **the one door**, sole write credential | Transaction Executor **admission** — the only write path | absorbs at-least-once delivery into exactly-once via the cause-derived `txid` |
| Activity — version-pinned, read-only, queue-routed | smart-contract eval; **market data operator** (CA frame transform, projection at read); MD-6 *projection* derived objects; NAV / PnL / **valuation chain**; **PnL-explain certificate** (VM-4); **MD-16 gate evaluation** | writes nothing; economics/recipe versions live on the log, off Temporal's versioning surface |
| Activity — version-pinned, model run **outside** the fold | V1 / MD-6 *model-run*: a fitted surface, a model price, a greek (VM-1) | output **re-enters through the one door** as a re-entered observation |
| Durable timer | date watch — the **liveness half only** (M1) | the firing's *execution time* is the record-derived declared date, not the timer's wall-clock fire |
| Signal | Monitor emission / observation arrival / correction / CA-cascade notice | carries timing + reference (cause id, log position), never economic payload (M4); record-derived backstop |
| Signal-with-start | inception of a ledger-created unit | fan-out to a possibly-not-running unit workflow |
| Query | non-authoritative liveness view (ops projection, search attributes) | reconciled to the ledger, never authoritative (R-19) |
| Update | human gate: forward repair, quarantine disposition, authorised fork | returns the door's admit/refuse (R-13) |
| ContinueAsNew | node transition / every K fixings-or-steps | = cold rebuild-from-ledger; carries only `{lineageId:unitId, nodeId, log-cursor}` |
| Fan-out by signal (not child-workflow) | CA cascade → affected unit workflows, each proposing its own `txid` | distinct `txid` per leg makes all *n* commit |
| Temporal history | disposable execution cache | **never** the book of record; wipe-and-rebuild is the acceptance test |
| Temporal timer/clock/task-queue arrival order | **not** the total order | the total order `(exec, door, hash)` is the door's alone (R-25) |
| The reordering step / refold | the **single writer's** work | the substrate re-fires *forward* only, never a past-dated firing |

---

## 2. Decomposition

### Ledger (as the seed fixes it — restated only to anchor the extension)
- Event Monitor + Events Executor → durable workflows + ingestion/orchestration activities; contracts in version-pinned queue-routed activities (never local).
- Transaction Executor → external single-writer service fronted by **one** idempotent door activity.
- Watches: date → durable timer; observation/barrier → signal-driven evaluation over recorded observations, never a timer poll.

### Market data
- **Observation door = the one door.** Capture is an ingestion activity (envelope: source + three times, B1) that proposes the moveless observation-recording transaction to the same door activity. **Absorption** (MD-1 exactly-once) is the door's cause-derived-id job at the registered grain — never a substrate dedup.
- **Market data operator** (CA change of frame, C-9.2): a **projection computed at read**, not a workflow and not a durable step — a read-only version-pinned activity over leaf observations; originals never overwritten (B4). Operators compose at full precision, minor-unit rounding once at read (MD-13).
- **Derived objects** split by MD-6. *Projection* kind (a bootstrapped curve) → read-only projection activity, stored nowhere. *Model-run* kind (a fitted surface) → model activity **outside** the fold, output re-enters through the door as a re-entered observation; **staleness** (MD-8) is a projection selecting the latest non-superseded fit and carrying its flag — never substrate state.
- **The two MD-16 gates** (a *dynamic* applied to an admissible base state constructs a *derived state*, an event in the derived stream MD-11):
  1. *Gate 1 — no-arbitrage, by construction:* a decidable predicate `m*∈Θ_AF` over a **single pinned cut** → a version-pinned gate-evaluation activity (read-only projection). The construction activity is **gated on the recorded pass**, so an arbitrageable state is never constructed (prevention).
  2. *Gate 2 — realism/conservative percentiles* (incl. joint realism) over the underlying's own **as-known** history → the same activity class; every threshold is a declared, recorded term.
  - The **gate decision** (pass/fail/**undecidable**, functionals, percentiles, history basis) re-enters through the **derived stream's own door** (isolated lineage) as a recorded event-outcome, pinned as-known — not a live projection. Consumption is **by reference**: a state carrying no admission record cannot be named.

### Valuation
- **VM-1 two layers.** A model-priced leg → pricing activity outside the fold, re-enters through the door (V1). **NAV / PnL / the valuation chain** → read-only projection activity over the record, storing nothing (V3, V5).
- **Valuation chain** (VM-3): append-only sequence of re-entered observations; each new mark is a new door re-entry, never an edit; the chain is a projection selecting latest non-superseded links.
- **PnL-explain certificate** (VM-4) + **residual bound** (VM-6): a projection over two marks and the declared attribution convention (VM-5); the residual `R` and its bound-check are inside that projection; a breach is a recorded named explain line (a broken chain, VM-7), never a substrate flag.
- **CA valuation sandwich** (VM-9): orchestrated by the unit's *own* workflow as the CA event walks its graph — sequence *before-mark → frame re-coordination (a CA transaction admitted at the door) → after-mark → assemble certificate*. The re-coordination is a zero-profit identity; residual `≈0` is the proof. A **late resolved CA** is not a Temporal saga: it is a **reordering** (single writer refolds; the spurious market-move line is reclassified to the frame re-coordination), after which the unit workflow re-reads and re-fires forward.
- **Backtest / derived worlds** (VM-10, VM-11): the *same* per-unit recipe in an isolated namespace, key `lineageId:unitId`. The trajectory of cuts is folded by **one** workflow (not 252 Schedules); the recorded **shift** is the seed, so the path replays bit-for-bit. Output is an ordinary valuation chain on the path's own record, never a link in the real unit's chain.

---

## 3. Divergences and their containments (one per row)

| # | Divergence (Temporal semantics vs framework doctrine) | Containment (the architectural mechanism that neutralises it) |
|---|---|---|
| D1 | **Nondeterminism**: wall clock, randomness, map iteration, direct I/O, and *model evaluation* are all nondeterministic under replay. | All side effects and every model/recipe run live in activities whose results Temporal records; workflow code holds only timers/waits/selectors. The three times live on the log and are read back as data. A Temporal non-determinism bug degrades to a **liveness** incident (R-21) — the ledger replays from its own log, never Temporal's. |
| D2 | **Workflow-code versioning vs economics/recipe versioning** — changing pricing or a market-data recipe must not ride Temporal versioning. | Two separate axes (R-17): Temporal Build-IDs/GetVersion for orchestration (ContinueAsNew boundaries as cutover); **ProductTerms / model / recipe versions on the log** for economics. Model & operator eval run in activities *keyed by the recorded version*, so replay is against the recorded version (MD-6, V1), never the worker's current code. |
| D3 | **History-size limits** — unit workflows live years (252+ fixings); backtests do one valuation *per step* over a trajectory; CA cascades fan wide. | ContinueAsNew at node transitions and every K fixings-or-steps, carrying only `{lineageId:unitId, nodeId, log-cursor}`; all else rehydrates from the record. Valuation chains and gate decisions live on the (path's) record, not in Temporal history. K sized to the derived-stream volume — an operational unknown (see Q1). |
| D4 | **Retry = at-least-once**, but the framework means exactly-once for observations, model outputs, gate decisions, and valuation links. | The door's cause-derived `txid = H(cause, contract, unit, seq)` collapses retries and keeps a cascade injective. Every **re-entry** (re-entered observation, gate decision, valuation link) must dedupe on the recorded `(input-cut, model/recipe-version)` identity, **never** a Temporal run/attempt id (generalises the R0 per-egress-idempotence flag). |
| D5 | **Task-queue / signal-arrival order is not commit order**; sticky execution is a perf optimisation, not correctness. | The total order `(exec, door, hash)` is decided at the door alone (R-25); signal order is orchestration sequencing only. A feed's arrival order ≠ execution order — a late observation **refolds** (MD-5). The substrate's own clocks order nothing (`sec:substrate`). |
| D6 | **Timer semantics vs the three times** — a durable timer fires in substrate/wall-clock time; the fold orders by *execution* time. | A timer firing is a *liveness* signal only; the firing event's execution time is the **record-derived declared date** (monitor time null, door time at admission), so an early/late fire yields the identical transaction. A late fire is an ordinary late arrival → the **door** refolds; the substrate never emits a past-dated firing. Observation/barrier watches are signal-driven, never a timer poll (R-08). |
| D7 | **Temporal cannot refold**; a late arrival reorders the fold interior to history. | The refold is the single writer's work (`sec:totalorder` step c). On a fold change the affected unit orchestration is **signalled to re-read** — discard mirror, rehydrate from the refolded projection, re-fire *forward* under fresh `txid`s. **Forbidden**: replaying orchestration history against the new fold, or substrate-side compensation (both smuggle ledger state into the substrate). Downstream re-entered observations flag stale (MD-8/VM-7) and re-derive as a new forward door re-entry. |
| D8 | **Derived worlds could leak into production** if a scenario/backtest shared the production door or namespace. | Physical namespace + credential separation: simulated paths run in isolated namespaces (`lineageId:unitId`) against their own lineage's door (R-20/R-03); the production door pool alone holds the production write credential (R-18). |
| D9 | **MD-16 "undecidable" is not a pass** — thin history yields undecidable, which naive retry logic could swallow. | An undecidable/failed gate is a **returned value**, not a retryable error (as a door refusal is, R-22): the derived state is not constructed, the refusal is recorded, and it stands as a visible blocked item — never retried to infinity. |
| D10 | **Settlement / model failure invites a Temporal saga or compensation**. | Never. Settlement failure and a wrong model output are **recorded external/derived events** that walk the relevant unit's graph (settlement-obligation unit; or a superseding re-entered observation). Money moves back only as an authorised compensating transaction through the door (C-12.4), never a substrate rollback (R-24). |

---

## 4. Open questions

- **Q1 (operational, MEDIUM confidence).** K for ContinueAsNew and the door-pool sizing depend on production event-volume-per-unit-per-day *and* derived-stream volume (backtest steps, MC paths, gate decisions per underlying). The seed flagged the first; the market-data/valuation extension adds the second, which can dwarf it. Needs a load model.
- **Q2 (constitutional seam probed — no new park).** Three extension seams were tested against the Constitution and each is already resolved: (i) the derived stream as a "second store" — no, it is the same immutable-log mechanism on a distinct lineage (C-2.8, C-12.5); (ii) storing a gate decision vs the recompute-on-read rule (C-4.11) — MD-16 already argues it is a pinned event-outcome, not a live projection; (iii) a late-CA sandwich vs Temporal compensation — resolved by the reordering path (D7). The one live constitutional question in the neighbourhood is the Valuation Manifesto's **PARK-1** (valuation storage); this substrate design must **not** turn it on — gate-decision and valuation-link recording ride the existing re-entered-observation mechanism, which MD-16 states "neither reopens nor turns on" PARK-1. No new parking is proposed, and the seams checked are named so the empty index is *exercised*, not merely empty.
- **Q3.** Backtest fan-out over very long trajectories: confirm one-workflow-folds-the-stream (per R-09's "one workflow, not 252 schedules") holds when per-step pricing is heavy, or whether per-segment child workflows in the *same* lineage are warranted purely for history/parallelism — a decomposition choice, never a correctness one.
