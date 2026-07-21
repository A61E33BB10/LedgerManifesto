# Red-team R8-9 — TEMPORAL-2 (reviewer): S2 deploy-invariance, S5 clock-skew, + key-arity reconciliation

## Key-arity reconciliation (verify first — S2 rests on it). CLEAN.
Canonical: `txid = H(input-cut, model-version, recipe/dynamic-version)`; **both SEED and ENV are OUT.**
- **Env out:** a re-derivation term (how precisely a value reproduces), not fact identity (settled R5).
- **Seed out:** not an independent fact-identity dimension. It is captured by **recipe/dynamic-version**
  (a declared recorded recipe term — MD-7 "whatever is declared is recorded") in production, or by
  **input-cut / lineage** (MD-11 — the seed/shift is the simulated path's recorded coordinate) in
  simulation. So the 3-tuple is injective over facts; a separate seed dimension would be redundant.
- **Poisoned seed cannot false-dedup:** two genuinely-different draws are different recipe-versions
  (production) or different lineages/input-cuts (simulation) → different keys. *Precondition:* the seed is
  a **declared** recipe/dynamic term (MD-7); a hidden per-run seed would false-dedup — but that violates
  MD-7, not the key.
- **Poisoned seed cannot split one fact:** seed is not in the key, so a retry — even one re-drawing a
  nondeterministic seed — recomputes the same (cut, model-version, recipe-version) → same txid → dedup.
  This is the R5 env-in-key lesson applied to seed: keeping seed OUT prevents exactly the split that
  seed-IN + a nondeterministic seed source would cause. CLEAN.

## S2 — DEPLOY-IS-ORCHESTRATION-ONLY. HOLDS.
Build-ID (Temporal Worker Versioning, orchestration axis i) is **not** in the key; the key holds
model/recipe versions (axes ii/iii, on the log).
- **Deploy cannot change a fact's txid:** txid = H(recorded terms); Build-ID is not an input to H. Same
  (cut, model-version, recipe-version) → same txid under any Build-ID. Deploy-invariant.
- **Deploy cannot admit a duplicate:** a cross-Build-ID retry (B1 proposes, deploy rolls to B2, B2
  re-proposes on replay) recomputes the **same** txid → door absorbs. Build-ID-in-key *would*
  double-admit — the same lesson as env/seed.
- **Deploy cannot change a fact's value:** economic values come from version-pinned model/recipe
  activities (keyed by model/recipe-version), never workflow code; the determinism rule keeps economics
  out of workflow code, so an orchestration-code deploy leaves values untouched.
- **No replay-against-new-code hazard:** Worker Versioning drains old runs to their next CAN boundary on
  the pinned Build-ID (R-17); the CAN boundary is the cutover. Even a botched deploy (a non-determinism
  error) degrades to a **liveness** incident (R-21), never wrong ledger state — the log is authoritative
  and the door re-validates. The (txid, value) set is deploy-invariant. HOLDS.

## S5 — THREE-TIMES-ARE-RECORDED-VALUES vs clock skew. HOLDS.
The substrate's clocks are **none** of the three times (spec `sec:substrate`: "its own clocks order
nothing"). Execution time = source-asserted/record-derived (payload or scheduled date); monitor time =
the one clock read, provenance only, **orders and gates nothing**; door time = the single writer's
strictly-monotonic admission sequence.
- **Skew cannot reorder the fold:** the fold orders by (execution, door, hash) — all recorded values.
  Execution time (which orders) is not a substrate clock read; a skewed worker cannot change a
  source-asserted execution time (TA-EXECUTION-TIME, never edited at the door). A skew-induced late
  arrival is refolded to correct execution order → timeliness cost, never correctness ("late firing →
  identical transaction"). HOLDS.
- **Door-time monotonicity failure** (a failover to a skewed clock) is backstopped by the event hash
  (lineage-invariant, recomputable): the total order stays total (`prop_doorTimeMonotonic` + hash). HOLDS.
- **Seams undisturbed:** C-4.11 (projections recompute over recorded values, no clock), PARK-1 (gate /
  valuation records ride pinned as-known event-outcomes, no clock — not turned on), C-2.8 (sim replays
  from recorded seeds/shifts, no wall clock), C-12.5 (append-only). Every seam operates over recorded
  values; skew touches only monitor time, which gates nothing. HOLDS.

**Verdict:** key-arity reconciliation CLEAN (3-tuple injective; seed + env out, both captured elsewhere);
S2 HOLDS (Build-ID not in key → deploy changes no txid and no value; botched deploy → liveness only);
S5 HOLDS (three times are recorded values; skew touches only order-nothing monitor time; the hash
backstops any door-time skew). Precondition to state: the seed is a declared recipe/dynamic term (MD-7),
never a hidden per-run draw.
