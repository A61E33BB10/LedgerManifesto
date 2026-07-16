# UnitStatus mutability — assessment (jane-street-cto)

## Verdict

**DERIVED PROJECTION.** UnitStatus is a materialised projection of the immutable event
log. Its "mutability" is a storage discipline — an in-place-overwritten cache cell — not
an authority. Reading (1) AUTHORITATIVE-MUTABLE is wrong on the design's own terms;
reading (2) MATERIALISED PROJECTION is correct. The word "mutable" in the state tables is
defensible engineering shorthand, but the omission of "derived" is a real documentation
defect that invites the wrong reading and must be fixed. No change to the construction is
required; the wording must change, and one forward-looking constraint must be stated.

## How I reached it (from my lens: contained-and-derived vs spooky-action)

My red-flag list says "mutable shared state." The question my lens forces is binary: is
this mutation **contained and derived** (a cache of a fold, every change caused by a
logged event), or **authoritative** (a second source of truth a holder can observe
diverging from the log)? I derived the answer from what writes UnitStatus and what
reconstructs it, not from the label.

1. **Every UnitStatus change is caused by a logged event, and only by one.** In
   `States.tex` the only writers of the unit cell are `register` and `settle`, and both
   are reached only through events: `apply (Registered u tv) = register …`,
   `apply (Settled u px) = settle …` (States.tex §"Deterministic replay"). The
   constructor and field selectors of `Ledger` are not exported (States.tex
   §Construction), so there is no out-of-band door to the cell. This is the
   single-writer / executor-as-sole-mutation-point discipline of v10.3 (line 1475:
   "the executor is the sole mutation point; no function bypasses it").

2. **UnitStatus is literally reconstructed by folding the log.** `replay = foldM (flip
   apply) l0` rebuilds "every unit's terms, status, and positions, so every view is a
   projection of the stream" (States.tex line ~391). The `Settled u px` event *carries*
   the price; `Active px` in the cell is the image of that event under a pure, total
   `apply`. That is the definition of a materialised projection.

3. **The documents already classify the contents of UnitStatus as projections.**
   `FutureLifeCycle.tex` line ~178: `last_settlement_price`/`last_settlement_date` "are
   projections of the `Settlement` carried by the stage, not independent fields." And the
   general rule, line ~399: "what the fold over the log determines is derived, not stored;
   only what the fold cannot reconstruct from prior events is state." Every field the
   addendum lists under UnitStatus — `lifecycle_stage`, `last_settlement_price`,
   `current_weights`, `nav_index`, `triggered_barrier`, `superseded_by` (addendum
   line ~196) — is the image of an event (settle, rebalance, expire, amend). None is set
   out of band. So by the documents' *own* rule, the entire map is derived.

The label "mutable, shared across holders" (FutureLifeCycle.tex line ~58; addendum
line ~60/162) is therefore true but incomplete: it states the storage discipline
(overwrite in place) and the keying (per unit, read by all holders) and omits the
authority (derived from the log). The same authors who wrote that label also wrote, two
sections later, that the values in it are "projections … not independent fields." The
state table simply lags the deeper text. The honest fix is to make the table agree with
the text, not to defend the table.

This is the **contained-and-derived** case, not the spooky one — *conditionally*. It is
spooky-safe only because three things hold together: (a) the event log is the sole source
of truth and is retained immutably; (b) the cell is a pure total fold of that log; (c) the
event handler is the single writer, with no out-of-band mutation. The reference
implementation enforces all three by the sealed constructor. If any one fails — most
plausibly, someone later adds a UnitStatus field poked directly by an operational tool
with no corresponding event — the cell instantly becomes a second source of truth, replay
stops reconstructing it, and we are in reading (1). That failure mode is the thing to
forbid by rule, not a property to assume.

## Time travel — explicit effect

- **Under (2), the correct reading:** time travel is unaffected and total. Past UnitStatus
  values are reconstructed by `clone_at(t)` = fold over the event prefix up to `t`
  (v10.3 line 74; States.tex `replay`). The live cell only ever holds the *present*
  value; that is fine, because the `Settled`/`Registered`/lifecycle events that produced
  every past value are retained immutably and re-derivable. The in-place overwrite
  destroying the prior cell value costs nothing, because the prior value was never the
  truth — the event was. Both flavours of v10.3's time travel (line 74: "what we knew at
  `t`" vs "time `t` with corrected data") are folds — one over the original prefix, one
  over the restated prefix — and the mutable cell is irrelevant to either. This is exactly
  the `first_touch_date` argument (addendum line ~278; FutureLifeCycle line ~396): a
  *cached* value would "make a replay disagree with itself under a back-dated correction,"
  whereas a *derived* value cannot. UnitStatus being derived is what keeps back-dated
  restatement coherent.

- **Under (1), the wrong reading:** time travel is broken for any UnitStatus value not
  also recorded as an event. The in-place overwrite is destructive; once `Active 102`
  becomes `Active 101`, the old value is gone from the cell, and if it were not redundantly
  present in the log there would be no way to reconstruct the state as of the prior settle.
  Reading (1) is only survivable today *because* every value also exists as an event —
  i.e. because the system is actually operating as (2). Reading (1) is a description that,
  taken literally as the authority, would forbid time travel; it is self-refuting against
  v10.3 Property 6.

## Reproducibility — explicit effect

- **Under (2):** replay yields identical UnitStatus deterministically. `apply` is pure and
  total and `Settled` carries the price, so the same event stream gives the same cell
  values regardless of checkpoint cuts (the `foldM` / Kleisli-composition law, States.tex
  §replay; addendum P3). Reproducibility holds by construction.

- **Under (1):** reproducibility holds only as long as no writer mutates the cell except
  through an event. The moment a UnitStatus field is set out of band — an authoritative
  mutation with no event — replay (which sees only events) cannot reproduce it, and two
  replays of the "same" log diverge from the production cell. Reading (1) names precisely
  the discipline-free version of the design whose reproducibility is not guaranteed. The
  reference implementation forbids this (sealed constructor, event-only `settle`), which is
  another way of saying the implementation is (2), not (1).

## What must change, and what must not

**Change (wording only):**
- Relabel UnitStatus in the discipline tables (FutureLifeCycle.tex line ~58; addendum
  line ~60–61 and the listing at line ~162, and §answer "shared mutable"). Replace
  "mutable, shared across holders" with something that states the authority, e.g.:
  *"derived projection of the event log; materialised per unit and overwritten in place
  (one value, read identically by every holder); sole writer is the event handler."*
  This makes the table agree with the document's own "projections, not independent
  fields" / "derived, not stored" statements.
- State once, as a load-bearing fact, that immutable retention of the settlement /
  lifecycle *events* is what makes the in-place cache safe for time travel — the exact
  parallel to "row retention serves audit" for PositionState (States.tex line ~392).
- Add the forward-looking constraint that is currently only implicit: **every UnitStatus
  field must be the image of the fold (event-sourced); a field set out of band is
  forbidden.** This is the single rule that keeps the map on the (2) side of my red-flag
  test as the schema grows. It is the UnitStatus analogue of the `first_touch_date`
  prohibition already stated for PositionState.

**Must NOT change:**
- The in-place overwrite storage discipline, the per-unit keying, registration-totality
  (C5), and idempotent replacement of the stage (addendum P5) are all correct and should
  stay. In-place materialisation of a derived view is the right, cheap implementation; the
  problem was never the mutation, only the silence about authority.
- The reference implementation needs no change — its sealed constructor and event-only
  writers already encode reading (2).

## One-line summary

UnitStatus is a materialised projection whose cell is overwritten in place; "mutable" is
true of the cell and false of the authority. Fix the label, state the event-sourced-only
constraint, keep the construction.
