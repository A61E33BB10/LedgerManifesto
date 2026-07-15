# UnitStatus: mutable cell or derived projection?

**Reviewer:** MILEWSKI (representation / category-theoretic lens)
**Recommendation:** DERIVED PROJECTION — the "mutable" label is operational
materialisation only. `UnitStatus` is a catamorphism over the immutable event log.
The implementation is sound; the prose label is the flaw and must change.

---

## 1. The question, separated into two axes

The single word "mutable" in the state table (addendum l.162; FutureLifeCycle l.58)
silently conflates two independent questions. Keeping them apart dissolves the apparent
contradiction between the documents.

- **Axis A — Authority.** Is `UnitStatus` a *source of truth* (a value that can be set
  independently of any logged event), or a *function of the event prefix* (every value it
  ever holds is caused by, and recoverable from, the log)?
- **Axis B — Representation.** Is the *stored* cell updated in place (a materialised cache)
  or recomputed on every read?

"Mutable / immutable / monotone" in the three-map table is an **Axis-B / write-discipline**
statement. The two readings the committee names differ on **Axis A**:

- Reading (1) AUTHORITATIVE-MUTABLE = Axis A "source of truth" + Axis B "in place."
- Reading (2) MATERIALISED PROJECTION = Axis A "derived" + Axis B "in place."

The documents' deeper logic fixes Axis A unambiguously to *derived*. So the correct reading
is (2), and (1) is not merely undesirable — it is incompatible with the project's
foundational commitments.

## 2. The documents fix Axis A to "derived"

The settlement marks living in `UnitStatus` are called, in the same breath as the "mutable"
label:

- "`last_settlement_price` and `last_settlement_date` are **projections** of the
  `Settlement` carried by the stage, not independent fields." (FutureLifeCycle l.178)
- "what the fold over the log determines is **derived, not stored**; only what the fold
  cannot reconstruct from prior events is state." (FutureLifeCycle l.399)
- "every view is a **projection** of the stream." (States.tex l.391)

v10.3 is even more explicit, and it is the load-bearing commitment the rest rests on:

- Time Travel property: "The exact ledger state at any historical timestamp can be
  reconstructed by replaying the immutable move stream **and unit-state events** up to that
  time." (v10.3 l.74) — unit-state changes ARE events in the log.
- "Because **every lifecycle event** (split, exercise, novation, basket redefinition) is
  recorded as an explicit state change on the relevant unit, the cloned view at any
  historical date carries the correct unit state." (v10.3 l.1384)
- "The unit state machine is a **projection** of the CDM lifecycle onto the ledger."
  (v10.3 l.1057)
- "`UnitStatus[u]` is `u`-keyed and written by replacement, so re-applying a stage write
  is **idempotent**." (v10.3 l.700)

There is no exception carved for `UnitStatus`. It is a view like balances and PnL. The
"mutable" in the table is describing *how the cache is written* (by replacement, vs the
append-only `ProductTerms` and the monotone `PositionState`), not whether it is authoritative.

## 3. The law, stated with FORMALIS-grade rigor

The event log is the **free monoid** on the event alphabet: `[Event]`, generators = single
events, `<>` = concatenation, unit = `[]`. Replay is the **unique monoid homomorphism** out
of it into the monoid of Kleisli endomorphisms on `Ledger` (Kleisli because application is
partial — `Either LedgerError`):

```
replay :: [Event] -> Ledger -> Either LedgerError Ledger
replay = foldM (flip step)          -- step = handle >=> validate >=> applyDelta
```

`UnitStatus` is the post-composition of that homomorphism with a pure projection:

```
unitStatus :: UnitId -> Ledger -> Maybe UnitStatus
unitStatus u = fmap snd . Map.lookup u . ledgerUnits
```

**The law for UnitStatus.** For a well-formed stream `es` and unit `u`:

```
unitStatus u (replay es emptyLedger) = deriveStatus u es
```

where `deriveStatus u` is the pure fold of the status algebra over the sub-word of `es`
that touches `u`. The status algebra is *last-write-wins on the stage*: a monoid action of
the event word on the initial status, where `Settled`/lifecycle events replace the carried
`Settlement` and `Registered` initialises. Because `replay` is a homomorphism out of the
free monoid, the value is **uniquely determined by the generators** (the per-event `apply`).

Two consequences are therefore theorems, not tests:

- **Checkpoint-independence / time travel.** `replay (xs <> ys) = replay xs >=> replay ys`
  (v10.3 P3). Hence `unitStatus u` after folding the prefix up to `t` equals the status as
  of `t`. `clone_at(t)` re-derives it exactly.
- **Replay determinism / reproducibility.** `step` is pure and total; every write to the
  cell is caused by a validated event delta; replacement is idempotent (l.700). Re-folding
  the same (or replayed-at-least-once) stream yields the identical cell.

The three maps' "mutation disciplines" are, categorically, **three choices of step
algebra for one catamorphism**: `ProductTerms` folds by *append* (free, history-preserving),
`UnitStatus` folds by *replace* (last-write-wins), `PositionState` folds by *accumulate*
(group action, no deletion). None is authoritative; the **event log is the sole source of
truth** and all three are equally its projections. Labelling one "immutable" and another
"mutable" reads as a difference in *authority* when it is only a difference in *step
operation* — that is the root of the confusion.

## 4. Effect of each reading on time travel and reproducibility

**Reading (1) AUTHORITATIVE-MUTABLE — breaks both.**
- *Time travel:* a value set independently of the log, once overwritten, is gone. The fold
  has no generator to reproduce it; `clone_at(t)` cannot reconstruct the past status. Time
  travel fails for exactly the fields the spec most needs it for (settlement marks,
  lifecycle stage at exercise/novation, v10.3 l.1378–1384).
- *Reproducibility:* `replay` no longer re-derives `UnitStatus`, so the homomorphism law
  fails and "the ledger is a deterministic function of its event history" (v10.3 l.77) is
  false. This is a foundational violation, not a degradation.

**Reading (2) MATERIALISED PROJECTION — preserves both.**
- *Time travel:* `UnitStatus[u]` at `t` = `snd`-projection of the fold over the event
  prefix to `t`. Exactly recoverable; the discarded cache value is never authoritative.
- *Reproducibility:* every write is event-caused and replacement is idempotent, so replay
  reconstructs an identical cell; checkpointing is sound by the fold law.

The entire soundness of caching `UnitStatus` hinges on one invariant: **every write to the
cell is caused by a logged event.** This is precisely the bug class FutureLifeCycle l.396–399
warns about — a value cached *outside* the fold (there, `first_touch_date`) makes replay
disagree with itself under a back-dated correction. The distinction is sharp and worth
stating: materialising the fold's *output* (UnitStatus) is safe because replay overwrites
it; materialising a value the fold is never asked to produce is the hazard. Materialisation
vs compute-on-read is an **efficiency choice orthogonal to authority** — `UnitStatus` is
materialised (it is a read-heavy shared observable, read identically by every holder: a
Reader / representable functor), `first_touch_date` is computed on read; both are equally
derived.

## 5. Should UnitStatus be mutable at all, and should the type say so?

Yes, the stored cell may be updated in place — that is the correct *materialisation* of a
read-heavy projection, and the implementation already confines it correctly:

- `Ledger` is abstract; **no `setUnitStatus` is exported.**
- The only writer is `applyDelta`, gated on `ValidDelta`, which is built only from a
  validated event. Thus the "every write is event-caused" invariant holds **by
  construction**, not by convention.
- The `(ProductTerms, UnitStatus)` fuse and the `Stage = Registered | Active (Maybe
  Settlement) | Expired Settlement` shape make the two unreachable states (registered-
  with-mark, expired-without-mark) unrepresentable.

So the **type already says the right thing on Axis A.** The implementation is sound under
reading (2). The flaw is purely in the **prose label**, which licenses reading (1) to a
naive reader and contradicts the same documents three lines away.

## 6. What must change, and what must not

**Change (prose only):** the three-map table's `UnitStatus` discipline "mutable, shared
across holders." It conflates write-discipline with authority. Replace with wording that
(a) names `UnitStatus` a projection of the log, like every other view; (b) describes its
write-discipline as *event-driven replacement / write-through cache of the fold*; (c)
retains "shared across holders" (the Reader/representable point). The cleanest fix relabels
all three disciplines by their **fold algebra** — `ProductTerms`: *append-only*;
`UnitStatus`: *replace (last-write-wins)*; `PositionState`: *accumulate (monotone)* — so the
column reads as the step operation over one immutable log, never as a claim of independent
authority.

**Do not change:** the materialised storage of `UnitStatus`; the sole-writer `applyDelta`
discipline gated by `ValidDelta`; the shared-observable (Reader) nature; the idempotent
write-by-replacement. These are correct and are what make reading (2) hold by construction.

**One sentence the spec should add, because it is the whole point:** *UnitStatus is stored
mutably as a write-through cache of the fold; it is never set independently of a logged
event, so replay reconstructs it exactly and the cache cannot become an unaudited source of
truth.*
