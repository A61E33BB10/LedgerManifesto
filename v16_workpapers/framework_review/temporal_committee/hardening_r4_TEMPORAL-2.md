# Red-team R4 — TEMPORAL-2 (reviewer): S1 mid-refold crash, S7 failover mid-gate

Both attacked hard; **both HOLD**. In each the load-bearing element is that **atomicity is owned by the
ledger door (external single writer), not Temporal**, and the **idempotence key is cause-derived from
recorded inputs**, never a Temporal run/attempt/namespace id. My R2/R3 key wording survives both.

## S1 — mid-refold worker crash. HOLDS (REFOLD-ATOMIC).
- **Crash between compute and door-propose (the named case):** the compute/emit split memoised the model
  output as the recorded activity result, so replay re-presents *identical bytes* (no model re-run);
  door-propose re-runs under the same key `(input-cut, model/recipe/dynamic-version, numerical-env-version)`
  → first-wins absorb → **committed once, no double-fire.** An attempt/run id in the key would present a new
  id → second admission → double-fire. Load-bearing, confirmed.
- **Single-writer crash mid-refold:** refold is idempotent (`prop_refoldIdempotent`, fixpoint closure) and
  append-only (C-12.5); restart re-runs from the insertion point, absorbs the partial tail, reaches the same
  quiescent closure; nothing admitted is rewound; only quiescence is observable. If writer and re-read
  substrate both propose one firing they compute the same id `H(correction,watch,occasion)` → door dedupes:
  the machine boundary is liveness division, not a correctness seam. Forward-only holds.
- **Corollary (key load-bearing twice):** refold *moves* the input-cut, so a post-refold re-derivation keys
  on a *new* cut → a distinct forward as-known fact beside the retained pre-refold mark (MD-8/C-12.1) —
  correct supersession, not a double-fire. Drop input-cut from the key and the correction is silently absorbed → broken state.
- **Residual (not a break):** a non-reproducible model re-derived on refold yields a value in {Pᵢ} — byte-atomic (one admitted), value-open: the §3 value-level bound, not a new state.

## S7 — namespace/DC failover mid-gate. HOLDS (GATE-STATE-ATOMIC).
- Fork A (settled) commits **state + verdict as ONE ledger transaction over one pinned cut** through the
  derived-lineage door. One append is atomic (whole transaction or refuse — *never half-applied*), so a
  **half-verdict is unrepresentable at the ledger layer regardless of Temporal failover.** The retracted
  two-write pole *would* have broken here (failover between the two writes → verdict without state) —
  vindicates the R2 retraction. Raw `dynamic(m)` is intermediate, never admitted; only the gated result
  enters (`kleppmann_dyn_review.md`) — no ungated state is ever visible.
- **Failover / split-brain:** both DCs pin the same cut (recorded log position, read identically), gate to
  the same verdict (decidable predicate on a projection), and propose to the **same single writer** under the
  **same cause-derived id** → first admits, second absorbs → **exactly one {state,verdict} lands.** A
  namespace id in the key would double-admit → divergent verdicts → broken state.
- **PRECONDITION to forbid explicitly:** this rests on **one single writer per lineage across DCs.** Temporal
  global-namespace active-active is safe (it replicates only the disposable cache); **active-active *ledger*
  doors for one authoritative lineage would install two writers** — the true break. Forbid it.
- **Residual (not a break):** same {Pᵢ} spread under split-brain → §3, byte-atomic, value-open.

**Verdict:** S1 HOLDS, S7 HOLDS; the `(input-cut, model/recipe/dynamic-version, numerical-env-version)` key
is load-bearing in each. Both residuals reduce to the known §3 value-level bound; one precondition to state explicitly: no active-active ledger door for a single authoritative lineage.
