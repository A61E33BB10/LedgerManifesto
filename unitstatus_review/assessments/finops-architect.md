# UnitStatus mutability — finops-architect assessment

Lens: audit and reconstruction. Can a past settlement mark be reproduced to the penny
after the fact, and does in-place mutation leave a defensible audit trail?

## Recommendation

**DERIVED PROJECTION.** UnitStatus is a materialised projection (a cached fold) of the
immutable event log. Its "mutable" label names the write discipline of the *store cell*
(overwrite by replacement), not the *authority* of the datum. The source of truth is the
event stream; UnitStatus is a view of it, exactly as balances, PnL, and PositionState.ac
are views of it. The word "mutable" is correct in the narrow store sense and dangerous
in the authority sense; the documents must be made to say which they mean.

## The tension, resolved

The documents do not contradict each other on substance; they contradict each other on
*wording*. Three load-bearing statements settle the matter, and all three point the same
way:

1. CLAUDE.md / Purpose: "one immutable event stream; every other view ... is a projection
   of that stream." UnitStatus is named nowhere as an exception.
2. States.tex (~391): "every view is a projection of the stream. Row retention serves
   audit, not determinism." Its `Event` type is
   `Registered UnitId TermsVersion | Moved Move | Settled UnitId Price` — the settlement
   *price lives in the event*. `apply (Settled u px) = settle u px` writes UnitStatus by
   replacement, but `replay = foldM (flip apply)` reconstructs that cell from the log.
3. FutureLifeCycle.tex (~178): `last_settlement_price` / `last_settlement_date` are
   "projections of the `Settlement` carried by the stage, not independent fields"; (~399)
   the general rule — "what the fold over the log determines is derived, not stored; only
   what the fold cannot reconstruct from prior events is state."

Apply rule (3) to UnitStatus field by field. `lifecycle_stage` ← Registered/SettleVM/
Expire events. `last_settlement_price` / `last_settlement_date` ← the SettleVM/Expire
event's price and date. `current_weights`, `nav_index`, `triggered_barrier` ←
QISRebalance events. `superseded_by` ← amend events. **Every** UnitStatus field is
reconstructible by folding the log. There is no residual datum in UnitStatus that the fold
cannot rebuild. By the documents' own rule, UnitStatus is therefore derived, materialised
as a cache — not an independent source of truth.

The "mutable, shared across holders" label (addendum line 162; FutureLifeCycle line 58)
and "status is overwritten on every settle" (addendum line 584) describe how the cache
cell is written. They are accurate about the store and silent about authority. Read as
"authoritative-mutable," they are wrong and contradict the project ground.

## The two readings, scored on my lens

### Reading 1 — AUTHORITATIVE-MUTABLE (rejected)

UnitStatus is itself the record of truth; settle overwrites `last_settlement_price` in
place; the prior mark is gone.

- **Time travel:** broken. `clone_at(t)` cannot recover the day-1 mark of 102 once day-2
  has overwritten it with 101. State at t is no longer a function of the event prefix; it
  is whatever the last writer left. v10.3's Property 6 (line 74) fails.
- **Reproducibility:** broken. Replay cannot reproduce an intermediate state that was
  destroyed. The EMIR Art. 11 / MiFID II RTS 25 reconstruction the spec claims (v10.3
  ~1350) collapses: an auditor replaying the day cannot verify each VM call against the
  mark used, because the mark history was overwritten.
- **Audit verdict:** pencils, not pens. Overwriting destroys lineage a controller needs.
  This would be a fatal flaw — but it is not what the design does.

### Reading 2 — MATERIALISED PROJECTION (correct)

UnitStatus is a fold of the immutable log, stored by replacement only as a read cache;
every write is the deterministic image of a logged event.

- **Time travel:** sound. The mark 102 is not destroyed by the day-2 overwrite, because
  the cache cell is not the record — the SettleVM(d1, 102) event in the immutable log is.
  `clone_at(t)` re-folds events up to t and rebuilds 102 exactly. Both senses v10.3 line 74
  distinguishes are served: "what we knew at t" (re-fold the prefix as logged) and "t with
  corrected data" (re-fold including the appended compensating event), because corrections
  are events (v10.3 ~1648), not edits to the cell.
- **Reproducibility:** sound and to the penny. Arithmetic is exact integer minor units
  (FutureLifeCycle "integer throughout and never divides"), `apply` is pure and total, the
  ingestion boundary de-duplicates so the stream is unique. Same prefix → bit-identical
  UnitStatus.
- **Audit verdict:** pens, not pencils. The overwrite of a derived cache leaves no lineage
  gap, because the lineage lives in the append-only event log, which is never overwritten.

The decisive corroboration is the design's own treatment of `first_touch_date`
(FutureLifeCycle ~398; States addendum ~278): it is *not* cached "because the cached value
would reflect the pre-correction order while the fold reflects the corrected one." That is
exactly the projection discipline. It is fatal to Reading 1 and required by Reading 2: a
cache is only safe when the log is authoritative and the cache is rebuilt by folding, never
trusted across a back-dated correction.

## The operational red flag (condition on the recommendation)

DERIVED PROJECTION is sound *only if the materialisation discipline is enforced*. The audit
guarantee is destroyed the moment any code path mutates UnitStatus without a corresponding
immutable event, or persists UnitStatus as the record of truth and discards the SettleVM
event. Two obligations must be stated explicitly, not left implied:

1. **Every UnitStatus write is event-caused.** No writer mutates UnitStatus except as the
   deterministic image of a validated, logged StateDelta (C2/C3, C11 single canonical
   writer). A "set last_settlement_price" side door is the authoritative-mutable failure
   reintroduced.
2. **Reconstruction re-folds; it never trusts the cell.** `clone_at(t)` rebuilds UnitStatus
   from the event prefix. The stored cell is an optimisation that must be checkable against
   the fold (parallel-run reconciliation: cached cell == fold of prefix), never the
   authority a query reads as truth.

C11 (per-field canonical writer) and C2/C3 (atomic validated delta) already provide the
machinery. What is missing is the *statement* that UnitStatus mutation is, by construction,
the materialisation of a logged event and nothing else.

## What must change (wording, not model)

- Re-label UnitStatus. Replace "mutable, shared across holders" with "materialised
  projection of the log: a fold stored by replacement as a read cache; reg-total; shared
  across holders." Replace "status is overwritten on every settle" (addendum ~584) with
  language that the *cache cell* is overwritten while the SettleVM event that determines it
  is appended immutably.
- Add one sentence to the invariants stating that every UnitStatus write is the image of a
  logged event and that reconstruction re-folds the prefix.

## What must NOT change

- The three-map model. UnitStatus stays a single u-keyed map written by replacement.
- The immutable event log as sole source of truth.
- Write-by-replacement as the cache discipline (it is what gives P5 idempotency of stage
  writes — `EXPIRED` over `EXPIRED` is `EXPIRED`).

The fix is to make the documents speak with one voice: UnitStatus is mutable the way a
materialised view is mutable, not the way a source of truth is mutable.
