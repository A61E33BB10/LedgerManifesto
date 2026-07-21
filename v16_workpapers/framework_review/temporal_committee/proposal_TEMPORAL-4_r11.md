# Temporal as Execution Substrate for the WHOLE Framework — TEMPORAL-4, Round 11 (harvest close)

**Witness/harvest-only — no design change.** FORMALIS signed the consensus (proposal_TEMPORAL-1_r9);
the one MEDIUM on my file was an incomplete harvest list (r9 §3 dropped `prop_exactlyOnceAdmission`
— the S4 root — and `prop_gateStateAtomic`). R11 pins the harvest to T-1's complete set, adds the
injectivity witness, and applies the three witness-obligation folds FORMALIS named. Catalogue,
mapping, decomposition, and the canonical 3-tuple key are **identical to r9**.

**Confirmed unchanged:** canonical key = the clean 3-tuple `(input-cut, model-version,
recipe/dynamic-version)`, seed and numerical-environment OUT of identity (Tier-2 re-derivation
terms) — no residual 4-tuple anywhere. β is the only reproducibility symbol. All seven red-team
scenarios (S1–S7) argued and HOLD, reduced compositionally to I1–I4 + S4 + COVERAGE-β.

## 1. Firing-witness harvest — pinned to T-1's COMPLETE set (each MUST fire, C-2.5)

Exactly-once-admission has **two halves**, both required: the no-double-admit witness and the
injectivity witness `prop_noSilentUnderAdmit`. The three FORMALIS folds are applied in the
obligation column (split sandwich; soften clock-skew to fold-order; value-corrupted audit case).

| Property | Scenario | Firing obligation |
|---|---|---|
| `prop_exactlyOnceAdmission` | **S4 root** (S1/S3/S6/S7 reduce to it) | N same-txid redeliveries × W racing workers × a door crash-restart admit **exactly one** row; the admitted set = {txids durably on the log}, retry/crash-count-independent (atomic unique-key insert, not check-then-append). |
| `prop_noSilentUnderAdmit` | **S4 injectivity half** | distinct fine-grained causes (exact-grained input-cut: log-position/content-hash) → **distinct txids → distinct admissions**; a coarse cut that false-dedups two genuinely different facts is the silent under-admit the witness must catch. |
| `prop_gateStateAtomic` | **S7** | failover injected at each of gate1 / gate2 / construct / propose → state+verdict land **whole or not at all** over the one pinned cut; the re-run is replay-deterministic on the cut; no ungated / half-verdict state is nameable. |
| `prop_refoldIdempotent` | S1 | crash injected at each tail position → recovered log = crash-free refold; refolding twice = refolding once. |
| `prop_refoldEqualsTimely` | S1 | refolded state = the timely fold of the same external arrivals, firings re-derived. |
| `prop_deployMidBacktestInvariant` | S2 | a Build-ID change at each step → admitted set + total order = the no-deploy run (Build-ID ∉ every txid coordinate). |
| `prop_clockSkewInvariant` | S5 | adversarial per-worker/DC offsets → **admitted set + fold RESULT + execution/monitor times** = the zero-skew run; **door-ORDER invariant up to commuting same-execution-time transposition** — a commuting pair's door-time *value* may permute under skew (harmless because it commutes), so the obligation is NOT "recorded three-times unchanged". Only the firing schedule differs. |
| `prop_sandwichCANInvariant` | S3 | **split obligation:** a **pre-CAN-admitted** leg = **byte-identical by read-back** of its durably-recorded emission; a **re-driven** (not-yet-admitted) kind-2 leg = **no-half / no-double + β-bounded** (not byte-identical for a non-reproducible model). The generator MUST inject CAN in **both** positions, else the β-bounded re-drive case is a zero-firing. |
| `prop_wipeRebuildEqualsLog` | S6 | wipe Temporal + rebuild-from-log = pre-wipe state, byte-identical, cache-independent (R-02). |
| `prop_fabricatedTxidRefusedOrAudited` | S6 | a novel / inconsistent fabricated txid is **door-refused** (R-22); **and** a structurally-valid, txid-consistent, **value-corrupted** fabrication (references a real logged cause, wrong value) is **audit-caught** (D7). The generator MUST include the value-corrupted case, else the audit disjunct passes on "refused" alone and never fires. |
| `prop_everyKind2ConsumerChecksBeta` | COVERAGE-β / value bound | no valuation path consuming a kind-2 leaf escapes the β-check — the `currentFit` selector is the sole typed accessor, so a raw path is a type error. |

A named property whose precondition is never generated is a defect (zero firings, C-2.5), not a
green test — the harvest must be delivered and shown to fire, not merely listed.

## 2. What is unchanged from r9 (restated for self-containment)

- **Catalogue** D1–D16, COVERAGE, and the seven scenario rows S1–S7 stand exactly as r9. **D10**
  key = the 3-tuple `(input-cut, model-version, recipe/dynamic-version)`; seed subsumed as a
  recorded parameter of the recipe/dynamic term; seed and env-version are Tier-2, never identity.
- **S2 DEPLOY-IS-ORCHESTRATION-ONLY** (Build-ID ∉ the fold; economics are version-pinned reads over
  log terms; economic change = a new recipe-version/new txid; break iff economics fused into the
  Build-ID, guarded by I4).
- **S5 THREE-TIMES-ARE-RECORDED-VALUES** (order = the door's logical `(exec, door, hash)` from the
  log; door time = the single writer's monotone admission stamp, not a wall clock; no bare clock
  read stamps a fact, by type; skew enters only timer firing → identical txid, S4-absorbed → an
  overdue-watch event; the **fold RESULT and order are skew-invariant**, the door-time value of a
  commuting same-exec pair aside).
- **S3 SANDWICH-CARRIES-NO-WORKFLOW-STATE** (several S4-idempotent legs; CAN carries only
  `{unitId|lineageId, nodeId, cut}` resolved against the log; a pre-admitted leg is read-back
  byte-identical, a re-driven leg is S4-idempotent + β-bounded; the hazard is a carried-stale mark,
  contained by holding no mark in workflow memory).
- The deep invariant: the substrate holds no atomic state, no write credential, and authors none of
  the three times or the order, so any crash, failover, storm, CAN, cache poison, deploy, or clock
  skew degrades to a liveness/backpressure incident or a detectable-and-repaired economic defect —
  never a wrong, duplicated, half, or reordered admitted fact (R-21/R-02, generalized).

## 3. Open questions (unchanged; no new park)

Parking exercised, empty (derived stream ≠ second store; gate verdict = kind-3 pinned event-outcome;
must not turn on Valuation-Manifesto PARK-1). Residuals: **TA-REPRO adequacy** (a producer's attested
β honesty is a governance/perimeter reconciliation, caught by audit — the S6 economic
detection-at-audit edge); the **load model** (K, door/derivation pools); Forks C/D settled-soft. The
only work between here and a signed catalogue is the firing-witness harvest above actually firing —
delivered, not deferred.
