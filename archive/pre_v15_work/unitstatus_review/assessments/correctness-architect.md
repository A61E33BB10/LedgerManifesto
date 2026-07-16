# UnitStatus mutability — assessment (correctness-architect lens)

**Lens:** deterministic simulation and state-space reconstruction.
**Recommendation: DERIVED PROJECTION.** UnitStatus is a *materialised projection* of the
immutable event log — a single-writer, in-place-overwritten cache of a pure fold. The word
"mutable" in the state tables is correct as an *implementation* note (the in-memory cell is
overwritten) but is dangerously under-specified as an *epistemic* claim. It must be qualified,
and the equality that makes the overwrite safe must be stated as an explicit invariant — it is
currently nowhere written down.

---

## 1. The two readings, and the consequence of each

The question gives two readings. From the determinism lens they are not stylistic variants;
they are two different machines with opposite replay behaviour.

### Reading 1 — AUTHORITATIVE-MUTABLE (UnitStatus is a source of truth, overwritten in place)

- **Time travel: BROKEN.** A past value, once overwritten, is gone. There is no event the fold
  can consume to rebuild it, so `clone_at(t)` cannot reproduce the mark *as known at t*. This
  directly violates v10.3 Property 6 (line 74) and forfeits *both* of its mandated modes —
  "what we knew at t" (no antecedent to read) and "t with restated data" (no log to re-fold).
- **Reproducibility: BROKEN.** If any writer can set UnitStatus out of band, the state at t is
  no longer a function of the event prefix. "Same events → same ledger" (States.tex l.384,
  P3 l.692) fails the moment one out-of-band write exists. Violates v10.3 l.77
  ("a deterministic function of its event history").

This is exactly the failure FutureLifeCycle.tex l.396–400 warns about for `first_touch_date`:
a cached value "would make a replay disagree with itself under a back-dated correction."

### Reading 2 — MATERIALISED PROJECTION (cache of the log-fold) — **correct**

- **Time travel: PRESERVED.** Every UnitStatus change is caused by a logged event
  (`Settled`/`SettleVM` carries the mark; `Registered` writes the default; `MandateAmend`
  stamps `superseded_by`; `QISRebalance` writes weights/nav_index/triggered_barrier).
  `clone_at(t)` re-folds the prefix up to t and reconstructs the exact mark known at t;
  re-folding a *corrected* log yields the corrected past. Both v10.3 l.74 modes hold. The
  in-place overwrite is irrelevant: the log retains the antecedent events.
- **Reproducibility: PRESERVED.** `UnitStatus = fold(apply, default, prefix)`, deterministic by
  the purity and totality of `apply` (States.tex l.383–384) and the `foldM` homomorphism
  (P3, l.692; FutureLifeCycle C1(b)). `Map.adjust` in `settle` is merely how the fold computes
  its next accumulator; with exact integer minor units (v10.3 l.619) the result is bit-identical.

The documents' deeper logic is unanimous for Reading 2: States.tex l.391 "every view is a
projection of the stream. Row retention serves audit, not determinism"; FutureLifeCycle l.178
the marks are "projections of the `Settlement` carried by the stage," l.399 "what the fold over
the log determines is derived, not stored"; v10.3 l.84, l.1057 "The unit state machine is a
projection of the CDM lifecycle." Only the table cells (FutureLifeCycle l.58; addendum l.60,
l.162) say bare "mutable," and they are describing the mutation *discipline*, not the source of
truth.

---

## 2. Why "mutable" and "projection" are not in conflict — and the one place they look like it

A value can be **materialised** (stored as the fold's running accumulator in its canonical
single-writer home) without being **authoritative** (a source of truth independent of the log).
UnitStatus is the former. That dissolves the apparent contradiction with the
`first_touch_date` rule:

- `last_settlement_price` lives in UnitStatus and *is* reconstructable from `Settled` events —
  yet it is legitimately "stored," because UnitStatus **is** the home of the settlement-event
  fold and `settle` is its single writer. It is the accumulator of a left fold, not a second
  copy.
- `first_touch_date` is forbidden in PositionState not because it is derivable (so is the mark)
  but because it would be a **second, redundant copy in the wrong home, maintained by a
  different writer (`trade`)**, free to drift from the fold. That is the authoritative-mutable
  failure in miniature.

So the rule of l.400 ("derived, not stored") really means: *do not create a second source of
truth*. It does not forbid materialising the fold in its canonical single-writer home. UnitStatus
passes; a cached `first_touch_date` fails.

The externally-sourced settlement price S is not a counterexample. S enters through an immutable
event that records it; UnitStatus folds that event. Veracity of S is a boundary/external-authority
concern; *determinism of the fold* is internal and intact. (This is the recorded-input discipline:
the oracle value is injected as a logged input, and the projection folds over inputs that carry it.)

---

## 3. The load-bearing invariant is unstated — this is the real finding

The safety of calling UnitStatus "mutable" rests entirely on one equality that **appears nowhere
in C1–C12**:

> **Materialisation soundness (MAT).** For every well-formed prefix `p`, the stored
> `UnitStatus[u]` in `replay(p)` equals the pure fold of the status-affecting events of `u` in
> `p`. Equivalently: every UnitStatus write is an event-handler write reached only through
> `apply`/`replay`; there is no out-of-band writer.

C5 gives only registration-totality; C11 gives single-writer-per-field. Neither states
equality-to-fold. In the **reference** (States.hs) MAT holds *by construction* — a `Ledger` can
only be obtained by folding events from `emptyLedger`, so there is no second copy that could
diverge. But the addendum explicitly plans to leave that regime in production: E1/E2 (fan-out,
snapshotting), F3 (key-space growth → caching), F4 (staged delivery). **The moment UnitStatus is
served from a long-lived incremental store instead of re-folded from genesis, MAT becomes a
property that can be violated, and nothing in the spec forbids or tests its violation.** That is
the gap.

---

## 4. Blockers (must resolve before the "mutable" label is safe to ship)

1. **State MAT as a first-class invariant** alongside C5/C11. The "mutable" label is sound only
   relative to MAT; right now it is asserted, not proved.
2. **Reconciliation property as a gate on any cache/snapshot optimisation:** an incrementally
   maintained UnitStatus store must equal a fold recomputed from genesis. Without this, E1/E2/F3
   silently re-introduce Reading 1.
3. **Restatement / back-dated-correction test on UnitStatus marks**, not only on
   `first_touch_date`. The acid test of l.396–400 must be exercised against
   `last_settlement_price` and `superseded_by`.

## 5. What must change (wording + one invariant + tests) — and what must NOT

**Change:**
- FutureLifeCycle.tex l.58 and addendum l.60/l.162: replace bare "mutable, shared across holders"
  with "**materialised projection of the log; overwritten in place as a single-writer cache;
  reconstructable by fold; shared across holders; registration-total.**" Keep "shared across
  holders" and "registration-total" — both correct.
- Add invariant **MAT** (§3) to the C-list; cross-reference it from C5 and C11.

**Do NOT change:**
- the three-map schema;
- storing `last_settlement_price`/`last_settlement_date` in UnitStatus (it is the fold
  accumulator, not a rogue copy);
- the single-writer discipline; the monotone PositionState carrier; the `Option` accessor.

This is a wording-plus-one-invariant fix, not a redesign. The architecture already *is* a
projection; the documents must *say so* where they currently say "mutable," and must *prove* the
equality where production caching will otherwise let it drift.

## 6. Properties to instrument (stated against the event-fold)

```
# MAT-1  projection soundness / no out-of-band writer
#   stored cache must equal a fold recomputed from genesis
forall es in well_formed_prefixes:
    assert incremental_store(es).UnitStatus == refold_from_genesis(es).UnitStatus

# MAT-2  checkpoint independence (P3 fold homomorphism — already implied, assert it)
forall (pre, post) with es == pre ++ post:
    assert clone_at(end(pre)).UnitStatus == replay(pre).UnitStatus

# MAT-3  restatement / back-dated correction (the first_touch_date acid test, on the mark)
#   inserting a corrected Settled into the log and re-folding must change the reconstructed
#   mark at t, and the stale in-memory value must not leak
assert refold(insert_correction(es)).UnitStatus[u] == expected_corrected_mark
assert refold(insert_correction(es)).UnitStatus[u] != stale_cached_mark

# MAT-4  idempotency of replacement writes (P5) — re-applying Settled@same price is identity
assert apply(Settled u px, apply(Settled u px, l)) == apply(Settled u px, l)

# Fault injection / bugification: inject a legal-but-out-of-band UnitStatus write
#   (bypassing the event log) and assert MAT-1 catches the divergence. This proves MAT is
#   enforced, not merely asserted.
```

---

**Bottom line.** UnitStatus is a derived projection. Mutability is materialisation, not
authority. Under that reading time travel and reproducibility are preserved exactly as v10.3
Property 6 and P3 require; under the authoritative-mutable reading both break. The design is
correct; the *label* is not, and the invariant that makes the label safe (MAT) is missing.
Relabel, state MAT, and gate every caching optimisation on the re-fold reconciliation test.
