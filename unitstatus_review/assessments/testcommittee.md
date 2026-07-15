# TESTCOMMITTEE Assessment — Is `UnitStatus` Mutable?

**Lens:** Testability. *Tests are the specification.* The question "is `UnitStatus`
mutable?" is decided, for us, by a prior question: **what test would witness that
`UnitStatus` is correct, and which reading of `UnitStatus` makes that test even
writable?** The answer settles the design.

**Recommendation: DERIVED PROJECTION.** `UnitStatus` is a *materialised projection*
of the immutable event log. The word "mutable" in the state tables is a correct but
dangerously worded *storage* note (write-by-replacement at a single key, holding the
current value of the fold); it is **not** an authority claim. The documents' own deeper
logic already says this; the table wording lags behind it and must be corrected.

---

## 1. The adjudicating argument: only reading (2) is testable

Distinguish the two readings the brief names:

- **(1) AUTHORITATIVE-MUTABLE** — `UnitStatus` is itself a source of truth, changed by
  in-place mutation; an overwritten past value is gone.
- **(2) MATERIALISED PROJECTION** — `UnitStatus` is the pure fold of the immutable log,
  stored mutably only as a read cache; every change is caused by a logged event.

A correct `UnitStatus` has exactly one characterising test:

```python
@given(event_streams())
def test_unitstatus_is_the_fold(events):
    """For every prefix, the live (materialised) status equals the fold."""
    for t in cut_points(events):
        live     = run_system(events[:t]).unit_status      # the mutable cell
        replayed = foldM(apply, emptyLedger, events[:t]).unit_status  # pure fold
        assert live == replayed
```

This test requires **two independent paths to `UnitStatus`**: the incremental/live
mutation path, and the pure fold of the log used as oracle. Under reading (2) both
exist and the test is meaningful. **Under reading (1) there is no second path** — the
mutated cell *is* the truth, so there is nothing to compare it against; the test is
vacuous and the property unfalsifiable. The very existence of a meaningful correctness
test forces reading (2). By Commandment 1 (tests are normative) the design `UnitStatus`
*means* is the one its tests can pin down — and that is the projection.

This is not wordplay. The documents already commit to the test's oracle:

- States.tex (~391): `replay` rebuilds each unit's "status" by folding, and
  "every view is a projection of the stream."
- FutureLifeCycle.tex (~178): `last_settlement_price`/`date` are "projections of the
  `Settlement` carried by the stage, not independent fields."
- FutureLifeCycle.tex (~399): "what the fold over the log determines is derived, not
  stored; only what the fold cannot reconstruct from prior events is state."
- addendum P3 / States.tex (~388): `replay` is a `foldM` homomorphism,
  `replay (xs<>ys) = replay xs >=> replay ys`.

Every one of these is the statement `UnitStatus = fold(log)`. The lone dissenting token
is the table cell "mutable, shared across holders" (FutureLifeCycle.tex ~58,
addendum ~162, ledger_v10.3 ~611). Read against the rest, "mutable" can only mean the
*storage discipline* (a cell overwritten in place), in contrast to ProductTerms
(append-only) and PositionState (monotone carrier). It is not a claim that the cell is
the system of record.

---

## 2. Why the *mutable storage* is safe — and what makes it testable

The mutability is not merely tolerable; the specific discipline is what makes the fold a
homomorphism and therefore makes checkpoint-independence testable.

**P5 (addendum ~699): the stage is "written by replacement," so re-applying a stage write
is the identity** (`EXPIRED` over `EXPIRED` = `EXPIRED`). Replacement-from-event — not
in-place *accumulation* — is precisely the algebra that makes duplicate/late replay
idempotent and order-insensitive at a key. Note the deliberate design choice: the one
field that is additive/path-dependent, `accumulated_cost`, is kept **out** of
`UnitStatus` (it lives in PositionState and draws replay-safety from conservation P1,
addendum ~706), and `hwm`/`entry_nav` use `max`/write-once. Nothing in `UnitStatus`
accumulates; everything is replaced from the latest causing event. That is the whole
reason a mutable cell can still be a clean fold.

**Checkpoint-independence is testable with the mutable form** — and *should* be tested,
contra the addendum's "checkpoint-independence is a consequence of this law, not a test"
(P3, ~697):

```python
@given(events=event_streams(), cut=st.integers())
def test_checkpoint_independence(events, cut):
    full  = replay(events, empty)
    split = replay(events[cut:], replay(events[:cut], empty))
    assert full.unit_status == split.unit_status   # cache must not leak the cut
```

A proof is welcome, but "not a test" is a category error for this committee: a theorem
about `apply` does not stop a *bug in `apply`* from breaking the homomorphism. The mutation
score depends on this guard existing (Feathers, Commandment 5/7). The property holds for
the mutable cell **iff every write is replacement-from-a-logged-event** and the key set is
stable (monotone carrier, C1(b)). That "iff" is reading (2) restated.

---

## 3. The killer property test — the one that separates (1) from (2)

ledger_v10.3 (~76) demands the system support *both* "time travel to what we knew at
time t" and "time travel to time t with today's corrected data," without conflating them.
The test that exercises this is the same test that demolishes reading (1):

```python
@given(events=event_streams(), correction=back_dated_events())
def test_restatement_refolds(events, correction):
    log_corrected = insert_back_dated(events, correction)
    # "as corrected": status is the fold of the corrected log...
    assert run_system(log_corrected).unit_status == fold(log_corrected).unit_status
    # ...and "as known at t" is still recoverable from the original prefix.
    assert clone_at(events, t).unit_status == fold(events[:t]).unit_status
```

Under reading (2) this passes: re-folding the corrected log yields corrected history; the
original prefix still yields the original view. Under reading (1) it **cannot even be
written** — once the cell was overwritten in place, the pre-correction value is gone and
there is no log to re-fold, so neither branch has an oracle. The exact failure
FutureLifeCycle.tex ~396 warns about for `first_touch_date` ("a replay would disagree with
itself under a back-dated correction") is the failure reading (1) bakes into `UnitStatus`
itself.

**Characterising property set for a correct `UnitStatus`:**
1. **Fold-equivalence:** `UnitStatus(t) = fold(prefix t)` for every t (§1).
2. **Event-causedness (no hidden input):** every change between consecutive states is
   attributable to exactly one logged event — including external observables. The
   settlement price enters as `Settled u px`; an index level or barrier hit must enter as
   a *logged observation event*, never a live read written into the cell.
3. **Idempotency:** `apply e ; apply e = apply e` for stage writes (P5).
4. **Checkpoint-independence:** §2.
5. **Restatement re-fold:** §3.
6. **Shrinking (Hughes):** when (1) or (2) fails, the counterexample shrinks to the
   minimal event sequence where `live ≠ fold`, pinpointing the handler that mutates
   without logging.

---

## 4. The one genuine risk (where it could drift to OTHER)

`UnitStatus` carries *external* observables: "current benchmark level (shared, from index
source)" (addendum ~355), `triggered_barrier` (~402). If the design ever permits these to
be written into `UnitStatus` **directly from the live source, bypassing the event log**,
then `UnitStatus` becomes a genuine hybrid — neither cleanly authoritative nor cleanly
derived — and reading (2) fails property #2. That would be a real flaw, not a wording
one: time travel and reproducibility would both break for those fields.

The framework already supplies the fix and intends it: the deterministic-oracle rule
(ledger_v10.3 ~1418) — market data is *captured and stored as a versioned snapshot at
execution time*, and replays use the stored snapshot, not a live feed. Provided every
external observable enters `UnitStatus` only through a logged (snapshotted) event, reading
(2) holds and the risk is closed. The recommendation therefore stays DERIVED PROJECTION,
conditioned on making that constraint explicit and tested.

---

## 5. Explicit time-travel and reproducibility implications

**Reading (1) AUTHORITATIVE-MUTABLE (rejected):**
- *Time travel:* **broken.** An overwritten stage/mark is unrecoverable; `clone_at(t)`
  has no source to reconstruct historical `UnitStatus`. Restoring it would require a
  side log of prior values — i.e. re-introducing the event log, conceding reading (2).
  ledger_v10.3 Property 6 and the split/exercise/novation reconstruction tests
  (~1376–1384) fail.
- *Reproducibility:* **broken.** No authoritative fold source; truth lived in mutation.
  Replays can diverge if the oracle is re-read live. Checkpoint-independence (P3) is
  unprovable *and untestable* — there is no fold to equate against.

**Reading (2) MATERIALISED PROJECTION (correct):**
- *Time travel:* **holds.** `UnitStatus(t) = fold(prefix t)`; `clone_at(t)` re-derives it.
  Back-dated corrections re-fold to corrected history; "as known at t" and "with corrected
  data" are both supported (ledger_v10.3 ~76, ~1418). The cell is a cache; the log is truth.
- *Reproducibility:* **holds.** Same events + same captured snapshots ⇒ identical
  `UnitStatus`, by the `foldM` homomorphism (P3) and idempotent replacement writes (P5).
  Checkpoint-independence is both a theorem and an executable property.

---

## 6. What must change — and what must not

**Change (wording/model, not mechanism):**
- The state-table discipline cell for `UnitStatus` must stop reading as bare "mutable,
  shared across holders." Replace with, e.g., *"materialised projection; current value of
  the fold, written by replacement from logged events; shared read; registration-total."*
  Keep "registration-total."
- Promote the characterising invariant to a numbered, tested commitment alongside
  C1/C2: **`UnitStatus(t) = fold over event_prefix(t)`** (fold-equivalence), with the
  event-causedness guard (no field changes except via a logged event; external observables
  enter as snapshotted events).
- Qualify "current benchmark level (shared, from index source)" to "captured as a logged
  observation event," closing the §4 risk in the text.
- Soften "checkpoint-independence is a consequence of this law, not a test" — it is a
  theorem **and** must carry an executable property guard (mutation-tested `apply`).

**Must NOT change:**
- Storing `UnitStatus` as a mutable cell (caching the fold for read efficiency is correct).
- The write-by-replacement discipline — it is exactly what makes idempotency and
  checkpoint-independence hold.
- Keeping `accumulated_cost` out of `UnitStatus` (additive field belongs in PositionState
  under conservation).
- Registration-totality and the "$u\in$ terms $\iff u\in$ status" coupling.

The mechanism is already right. The label is the bug: "mutable" describes the cell, but
reads as a claim about authority. Tests can only specify the projection — so the
specification *is* the projection, and the prose should say so.
