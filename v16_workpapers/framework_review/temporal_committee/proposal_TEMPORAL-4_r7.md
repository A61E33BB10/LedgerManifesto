# Temporal as Execution Substrate for the WHOLE Framework — TEMPORAL-4, Rounds 6+7 (batched red-team)

R6+R7 add two catalogue rows (S3 CA-sandwich continue-as-new; S6 poisoned-cache replay), fold
the three MEDIUM preconditions the referees named into D10, and promote the two "no raw path"
claims to by-type. **β is the only reproducibility-bound symbol** (no ε_repro/τ anywhere).
Everything else stands as r5. Neither scenario breaks a row; S6 carries an honest edge.

**Catalogue unchanged from r5** except: **D10** (three preconditions folded) and two new rows
**S3, S6**. Three record kinds unchanged (kind-1 projection; kind-2 re-entered observation; kind-3
recorded decision pinned as-known).

## 1. Corrected / new rows

| # | Divergence | Containment |
|---|---|---|
| **D10** | **Retry vs exactly-once ADMISSION — the door's dedup is load-bearing.** | Exactly-once-admission = the cause-derived txid is a **UNIQUE KEY enforced by an ATOMIC conditional-append at the single writer** (not check-then-append/TOCTOU); a **total function of the DURABLE LOG**, invariant under redelivery/interleaving/door-crash-restart (S4). **Three preconditions, by construction (not deployment discipline):** (i) **durable-before-ack** — the append is durable *before* the door acks the proposer, else a crash after ack loses an "admitted" fact (under-write); (ii) **one leader + quorum log per lineage** — the single writer is a quorum-replicated log with one fenced-lease leader per lineage, so split-brain double-write is unrepresentable (I1); (iii) **exact-grained input-cut** — the cut coordinate is a log-position / content-hash, NEVER a coarse label ("latest", a truncated stamp), else a coarse cut false-dedups two distinct facts → silent under-admit (the injective dual of the double-admit). **Key = `(input-cut, model-version, recipe/dynamic-version, seed)`**, all recorded BEFORE compute dispatches; the **`seed` slot is present iff the recipe/dynamic declares the derivation stochastic** — the recipe-version governs seed presence, so the arity is one-voice. **Env-version is OUT** (env-in-key → two facts → double-admit under split-brain; a Tier-2 lineage term). Never a Temporal run/attempt id. |
| **S3** | **History-limit continue-as-new mid CA-sandwich** (§2). | SANDWICH-CARRIES-NO-WORKFLOW-STATE — see §2. No row breaks; the sandwich holds no economic state in Temporal memory. |
| **S6** | **Poisoned-cache replay after wipe-rebuild** (§2). | LOG-IS-SOLE-TRUTH — see §2. No row breaks; honest edge: economic causality is detection-at-audit, not door-prevention. |

**By-type enforcement (design intent; FORMALIS certifies in the reference impl).** Two "no raw
path" claims are enforced by TYPE, not convention: (a) `proposeToDoor`'s sole input is
`runModel`'s recorded output — the fused worker is unrepresentable (D14); (b) the `currentFit`
selector is the sole typed accessor reading a kind-2 leaf, so a raw kind-2 read bypassing the
β-check is a type error, not a forgettable convention (COVERAGE-β). By-construction, not a runtime guard.

## 2. Red-team R6+R7

### S3 — history-limit CAN mid CA-sandwich → SANDWICH-CARRIES-NO-WORKFLOW-STATE
The CA valuation sandwich (before-mark in the old frame / the CA frame-change transaction /
after-mark in the new frame / PnL-explain certificate) survives a history-limit-forced
continue-as-new at **any** step because it holds **no economic state in Temporal history**:
- It is struck **as a projection from the log**: the before-mark reads the pre-CA cut, the
  after-mark reads the post-CA cut — both cuts recorded — so the sandwich is a pure function of
  `{nodeId, pre-cut, post-cut}`; the operator is a projection at read. **No intermediate** (a
  before-mark value, an operator output) is ever held in a workflow variable.
- It is **several idempotent legs, not one door transaction** — necessarily, because the
  before-mark is struck against the pre-CA state and the after-mark against the post-CA state,
  temporally bracketing the frame-change transaction. Each recorded leg (a model-priced mark =
  kind-2 re-entry; the certificate's residual = a recorded diagnostic) is an **S4-idempotent door
  admission** keyed on `(node, cut, leg-tag)`; the decomposition itself is a kind-1 projection
  recomputed on read.
- ContinueAsNew carries only `{unitId|lineageId, nodeId, cut}` (R-15). On resume the workflow
  re-reads the record: legs already admitted are found on the log and absorbed (S4); the missing
  legs are re-driven, each S4-collapsed to one row. **Completion is a deterministic function of
  the recorded cut**, so the resumed sandwich is byte-identical to the CAN-free one — never a
  half-sandwich, never a double-strike.
- **Finding (contained):** survival holds ONLY IF no intermediate is kept in workflow memory. IF
  an implementation held the before-mark (or the operator output) in a workflow variable across
  the frame-change wait, a CAN between before- and after-mark would drop it → half-sandwich.
  Containment: strike the sandwich as a projection from the recorded cuts; the workflow holds only
  `{nodeId, cut}`. Witness `prop_sandwichCANInvariant` — inject CAN at before-mark / operator /
  after-mark / certificate, assert completed = CAN-free — MUST fire (zero firings = defect, C-2.5).
  The same audit as S1's no-model-in-fold: it turns entirely on state being off workflow memory.

### S6 — poisoned-cache replay after wipe-rebuild → LOG-IS-SOLE-TRUTH (two halves)
- **Rebuild is cache-independent.** Wipe-and-rebuild reads only the LOG (R-02); rebuilt state =
  pre-wipe state, byte-identical. The cache never feeds the rebuild, so a poisoned cache entry
  cannot alter a rebuilt fact.
- **Poison cannot become trusted truth.** The cache holds **no write credential — only the door
  writes** (I1 fenced lease). A replayed OLD txid is absorbed by the atomic unique-key insert
  (S4). A cache-fabricated NOVEL proposal is either **door-refused** as an unresolvable structural
  reference (its cause is not on the record — R-22), or, where structurally valid, admitted and
  **caught by the decidable audit-recompute** (D7).
- **Honest edge (stated, not hidden):** economic causality is **detection-at-audit, not
  door-prevention** — economic correctness needs model/product knowledge the door must not hold
  (C-13.2). So the guarantee is precisely: *no poison silently becomes trusted truth, and no
  rebuilt state is anything but a function of the log* — NOT "no structurally-valid poison ever
  touches the log." A structurally-valid but economically-fabricated fact (a compromised worker
  proposing a well-formed, uncaused transaction) **can** be admitted, exactly as an
  economically-wrong contract's output can, and is caught by recomputation and repaired forward
  (C-13.2, C-12.4). This is the Constitution's own two-layer correctness (C-13.1 structural by
  construction / C-13.2 economic by recomputation), not a new weakness.
- Because inputs cross the door **envelope-first** (capture precedes routing), a poisoned cache
  can corrupt only **orchestration/timing** (which watch fires, when) — a liveness effect caught
  by the overdue-watch sweep — never a recorded input.
- **Finding (contained):** poison degrades to at most a *detectable* economic defect (repaired
  forward) or a liveness incident — never a structurally-broken state, never a rebuilt state
  differing from the clean log. Witness `prop_poisonedReplayCleanRebuild` — seed a forged cache,
  replay, wipe, rebuild-from-log; assert rebuilt = clean rebuild and every fabricated txid is
  door-refused or audit-flagged — MUST fire.

**Both reduce to already-proven properties** (no new mechanism): S3 → S1 (no state in workflow
memory) + S4-idempotent legs; S6 → S4 (absorb) + I1 (no write credential) + D7 (decidable audit).
The deep invariant is unchanged: the substrate holds no atomic state and no write credential, so a
crash, failover, storm, CAN, or cache poison degrades to a liveness/backpressure incident or a
detectable-and-repaired economic defect — never a wrong, duplicated, or half admitted fact
(R-21/R-02, generalized).

## 3. Open questions (unchanged; no new park)
Parking exercised, empty (derived stream ≠ second store; gate verdict = kind-3 pinned event-outcome;
must not turn on Valuation-Manifesto PARK-1). Residuals: **TA-REPRO adequacy** (a producer's
attested β honesty is a governance/perimeter reconciliation, caught by audit and counterparty
challenge — the same standing as S6's economic detection-at-audit edge); the **load model** (K,
door/derivation pools); Forks C/D settled-soft. Queued red-team scenarios not yet argued: S2 (deploy
mid-backtest → axis-isolation, largely pre-argued by D9 I4), S5 (clock skew → times-on-the-log,
pre-argued by D11/D12). Firing-witness harvest owed: `prop_refoldIdempotent`, `refold-equals-timely`,
`prop_everyKind2ConsumerChecksBeta`, `prop_sandwichCANInvariant`, `prop_poisonedReplayCleanRebuild`
— each must be shown to fire (zero firings = defect, C-2.5).
