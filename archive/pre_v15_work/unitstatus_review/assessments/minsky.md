# UnitStatus: Mutable Cell or Derived Projection?

**Reviewer:** MINSKY (types, invariants, illegal-state-unrepresentability)
**Recommendation:** **DERIVED PROJECTION** — UnitStatus is a pure fold of the immutable
event log. Its "mutability" is a *storage/materialisation discipline* (overwrite-in-place),
not authority. The word "mutable" in the state tables is locally true as a storage adjective
but is a clarity hazard: it invites the one reading the design must forbid.

---

## 1. Judge by the types, not by the label

The label "mutable, shared across holders" (FutureLifeCycle.tex ~l.58; addendum l.162) is
prose. The arbiter is the type. Look at where a `UnitStatus` value actually lives and who can
write it (States.tex §Construction):

```
data Ledger = Ledger                          -- constructor + field selectors NOT exported
  { ledgerUnit :: Map UnitId (ProductTerms, UnitStatus)
  , ledgerPS   :: Map (WalletId, UnitId) PositionState }
```

`UnitStatus` never appears as a free-standing mutable cell. It is the `snd` of a pair, inside
an **abstract** `Ledger` whose constructor and selectors are withheld. The *entire* set of
operations that can produce a new `UnitStatus` is closed:

```
register :: UnitId -> TermsVersion -> Ledger -> Maybe Ledger   -- writes defaultStatus
settle   :: UnitId -> Price        -> Ledger -> Maybe Ledger   -- writes (Active px)
apply    :: Event  -> Ledger -> Maybe Ledger                   -- = register | applyMove | settle
```

There is no exported `setStatus :: UnitId -> UnitStatus -> Ledger -> Ledger`, and no exported
selector through which `l { ledgerUnit = ... }` could install one. **Every** writer of
`UnitStatus` is a case of `apply`, keyed on a logged `Event`. Therefore the value of
`UnitStatus[u]` after a stream is, by construction, exactly `fold apply` over that stream:

```
replay events l0 = foldM (flip apply) l0 events     -- apply is pure and total
```

That is the definition of a materialised projection: a pure, total fold of the immutable log,
held in a cell that is overwritten between folds for read efficiency. The cell is mutable; the
*value it holds is determined by the log*. This is Minsky-orthodox: mutable state is permitted,
but it is **contained** — sealed type, single-writer discipline, every writer driven by an event.

## 2. The two readings, and why one is an illegal state

**(1) AUTHORITATIVE-MUTABLE** — UnitStatus is a source of truth changed by in-place mutation;
an overwritten past value is gone. **This is an illegal state**, and "make illegal states
unrepresentable" should forbid it. If UnitStatus were an authority mutated off-log, the cell
and the log could disagree — the cell says `Active 105`, the fold of the log says `Active 101`
— which is precisely the internal-reconciliation break the project exists to make
unrepresentable (CLAUDE.md purpose; v10.3 l.84 "all other views … are derived projections").

**(2) MATERIALISED PROJECTION** — UnitStatus is the fold; the cell is a cache. Every change is
caused by a logged event, so replay reconstructs it exactly. **This is the legal state, and the
only one the types admit**, because the sealed `Ledger` + closed writer set leave no door to
reading (1). The out-of-sync cell is not "discouraged"; it is *unrepresentable*, exactly as the
project demands.

So the design is sound in substance. The flaw is purely lexical: the table's word "mutable"
names reading (1)'s defining attribute (authority + in-place loss of the past) when what is
actually true is reading (2) (a fold materialised in an overwrite cell).

## 3. The documents' own criterion settles it against the label

FutureLifeCycle.tex states the decision rule (l.399):

> "what the fold over the log determines is derived, not stored; only what the fold cannot
> reconstruct from prior events is state."

Apply it field by field to UnitStatus: `lifecycle_stage`, `last_settlement_price`,
`last_settlement_date`, `current_weights`, `nav_index`, `triggered_barrier`, `superseded_by` —
every one is written by a logged event (`register`, `SettleVM`/`settle`, expiry, rebalance,
amend). **Nothing in UnitStatus fails the fold.** By the document's *own* criterion UnitStatus
lands wholly on the "derived" side. The same document already concedes this for the marks
(l.178): `last_settlement_price`/`date` are "projections of the Settlement carried by the
stage, not independent fields." States.tex generalises it (l.391): "every view is a projection
of the stream." The "mutable … not stored-vs-derived" framing of the table is therefore in
tension with the prose two pages later; the prose is right.

Note the deeper symmetry that makes the label doubly misleading. ProductTerms ("immutable,
append-only") is *also* a fold of the log — the combining operator is append; UnitStatus's is
last-write-wins; accumulated_cost's is additive. All three maps are projections of one log; the
"mutable / immutable" axis names the **fold's combining operator and materialisation**, not
**authority**. Authority is singular and lives in exactly one place: the immutable event stream.

## 4. Time travel

- **Under reading (2) — supported, and this is the correct reading.** `clone_at(t)` =
  `foldM apply` over the event prefix `≤ t` (v10.3 l.74, l.1392). The current materialised cell
  holds only the fold over the *whole* log; the value at `t` is recovered by **re-folding the
  prefix**, never by reading the cell. Time travel depends on (i) the log being immutable and
  (ii) `apply` being pure and total — both held — and is *independent* of the cell retaining any
  history. The order-sensitivity of UnitStatus (last-settlement-price is last-write-wins over
  the prefix) is irrelevant: it is still a deterministic function of the prefix.

- **Under reading (1) — broken.** If UnitStatus were an authority overwritten in place, the
  state at `t` could not be reconstructed: the past value is gone unless it was also logged —
  and "also logged" *is* reading (2). Time Travel is a non-negotiable project property (v10.3
  Property 6, l.74; "any state can be reached again by replaying the same transactions").
  Reading (1) is therefore incompatible with the foundations, which is independent confirmation
  that (1) must be the illegal state, not the design.

## 5. Reproducibility (deterministic replay)

- **Under reading (2) — holds by construction.** Drop the cell, re-fold the log, get the
  identical `UnitStatus` (States.tex P3 "apply is a pure, total function … same events give the
  same ledger"; addendum P3 `replay (xs<>ys) = replay xs >=> replay ys`). The materialisation is
  a cache with no semantic content of its own. UnitStatus is additionally robust to the one
  hazard a last-write projection could raise — duplicate/reordered events — because stage writes
  are idempotent by replacement (addendum P5: `EXPIRED` over `EXPIRED` = `EXPIRED`; settle at a
  fixed mark is inert, FutureLifeCycle l.436). So the fold is stable across checkpoint cuts and
  de-duplication (FutureLifeCycle l.418).

- **Under reading (1) — fails.** An authority mutated outside the fold cannot be reconstructed
  from the log; cell and log diverge silently. That is the reconciliation break the system is
  built to exclude.

## 6. What must change (and what must not)

**Must NOT change (these are what make reading (1) unrepresentable — protect them):**
- `Ledger` abstract; constructor and field selectors unexported.
- The closed writer set `{register, settle, …}` with every writer a case of `apply` on an
  `Event`. No exported `setStatus`, no exported selector enabling record-update.
- The marks fused onto the stage (`Active (Maybe Settlement)`, `Expired Settlement`) so
  "active without price" / "expired without mark" stay unspellable.
- "shared across holders" — the `u`-keying (not `(w,u)`) is a *genuine and correct* property and
  should stay verbatim.

**Must change — the one word:** stop calling UnitStatus "**mutable**, shared across holders" as
if mutability were its nature. State what the design actually is:

> *UnitStatus[u] is a **projection of the event log**, materialised in an overwrite-in-place
> cell for read efficiency; its sole writer is the fold (`apply`), so no API can set it
> off-log, and replay reconstructs it exactly.*

If a storage-discipline contrast with ProductTerms is wanted, draw it as **fold algebra**:
ProductTerms is the *append-only* fold (history-preserving), UnitStatus the *last-write* fold
(overwrite-materialised) — two projections of one log, not one authority-derived and one
authority-mutable. The single source of truth is the immutable event stream; UnitStatus is
downstream of it like every other view.

This is not pedantry. The label is the only place in the corpus that legitimises an
implementer adding an off-log `setStatus`. The moment that setter exists, reading (1) becomes
representable and Time Travel + Reproducibility break **silently** — no type error, no failing
fold, just a cell that no longer equals the projection. Naming UnitStatus a materialised
projection closes that door in the prose the same way the sealed `Ledger` closes it in the type.

## 7. Verdict

UnitStatus is a **DERIVED PROJECTION**. The substance of the design is correct and already
makes the authoritative-mutable reading unrepresentable; only the characterising word "mutable"
should be corrected to "overwrite-materialised projection of the log," with the `u`-keying
("shared across holders") retained. Types right, program right; fix the noun.
