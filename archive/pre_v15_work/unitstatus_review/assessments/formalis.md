# FORMALIS Assessment — Is `UnitStatus` Mutable, and What Does That Imply?

**Reviewer lens:** formal verification — is state at time *t* a total, deterministic
function of the event prefix? Does in-place mutation break referential transparency or
replay determinism? Treat `UnitStatus(t)` as a candidate catamorphism over the prefix.

**Recommendation: DERIVED PROJECTION.** `UnitStatus` is a pure fold of the immutable
event log. The word *mutable* in the state-home tables is correct only as a description of
the **storage discipline** (a single live value, overwritten on each event, versus
`ProductTerms`' append-only version list). It is **incorrect, and a latent hazard, if read
as reading (1) — an authoritative source of truth whose past, once overwritten, is gone.**
The deeper logic of both documents is the correct one.

---

## 1. The semantic fact: `UnitStatus(t)` is a catamorphism

The reference fixes this beyond dispute.

- `apply :: Event -> Ledger -> Maybe Ledger` is pure and total
  (States.tex §"Deterministic replay", l.374–387).
- `replay events l0 = foldM (flip apply) l0 events`. State after the prefix `E[1..k]` is
  `S(k) = replay (take k E) emptyLedger`.
- `UnitStatus(u)` is a component projection `π_US` of `S(k)`. The **only** writers of the
  status half are `register` and `settle` (States.tex l.283–301), both of which are
  cases of `apply` — i.e. every status write is the image of a *logged* event under a pure
  function of `(event, prior ledger)`.

From these three facts:

> **Theorem (UnitStatus is a fold of the log).** If `apply` is pure and total and every
> write to the status half occurs only inside `apply` as a function of `(event, prior
> ledger)`, then `π_US ∘ replay = π_US ∘ foldM apply`: the status after prefix `E[1..k]`
> equals a fold over that prefix. Hence it is **(a)** total on well-formed prefixes,
> **(b)** deterministic, **(c)** reconstructible for any *k*, **(d)** replay-invariant.

This is exactly reading (2), **materialised projection**. The documents already assert the
conclusion in three independent places — States.tex l.391 "every view is a projection of
the stream"; FutureLifeCycle l.178 the marks are "projections of the `Settlement` carried
by the stage, not independent fields"; FutureLifeCycle l.399 "what the fold over the log
determines is derived, not stored." `UnitStatus` is determined by the fold. Therefore it
is derived, by the documents' own rule.

## 2. In-place mutation does **not** break referential transparency here

In the reference there is **no destructive mutation at all**: `settle` does
`Map.adjust (\(t,_) -> (t, UnitStatus (Active px))) u (ledgerUnit l)` and returns
`Just (l { ledgerUnit = ... })` — a new persistent map, a new `Ledger` value. "Mutable"
names a *replacement* semantics for the live value (overwrite, not version), against
`ProductTerms`' *append* semantics. It does **not** name a side effect. Referential
transparency is intact: `settle u px` is a pure function `Ledger -> Maybe Ledger`.

The overwrite loses no information that time travel needs, because the overwritten value's
*cause* — the prior `Settled u px'` event — remains in the immutable log. `ProductTerms`
keeps its history in the live map (a `NonEmptyList`); `UnitStatus` keeps only the latest in
the live map; **both keep their full history in the event log.** The asymmetry is a
materialisation-policy choice (how much of the fold to cache for read efficiency), not a
difference in source of truth. By Minimalism, `UnitStatus` should *not* be promoted to a
version list — the single live cell plus the log is the minimum basis; a version list would
duplicate what the log already holds.

## 3. The two readings, with explicit consequences

### Reading (2) — MATERIALISED PROJECTION (the design's actual behaviour, correct)

- **Time travel.** `clone_at(t) = π_US(replay (take_t E))` reconstructs any past status
  exactly. The overwritten live cell is irrelevant; the history is in the log. v10.3's two
  distinct time travels — "what we knew at *t*" (snapshot data at *t*) and "*t* with
  corrected data" (restated snapshot) — are *both* served, because both re-fold the log
  against the chosen data version (v10.3 l.74, l.1392–1395).
- **Reproducibility.** `replay E` yields an identical status for identical, *totally
  ordered* `E`, since `apply` is pure/total and the status is its image. Determinism rests
  on three preconditions, all met: (i) a total order on same-timestamp events
  (v10.3 l.190); (ii) every input to `apply` carried in the log — no ambient clock, no
  config, no live feed (v10.3 l.1418 purity requirement plus a deterministic data oracle);
  (iii) deterministic map operations (`Map.adjust` over ordered keys). Reproducible.

### Reading (1) — AUTHORITATIVE-MUTABLE (what the *label* invites; forbidden by this lens)

- **Time travel.** If any status value were patched in place **without a corresponding log
  event** — an admin "set price", a clock-defaulted stage, a correction applied to the cell
  but not the log — that past state becomes unrecoverable, and worse, replay would
  reconstruct a *different* value than was historically observed. This is precisely the
  failure the documents already forbid for `first_touch_date` (FutureLifeCycle l.396–399;
  addendum l.277–281): a cached value reflects pre-correction order while the fold reflects
  corrected order. `UnitStatus` must be held to the **same** rule.
- **Reproducibility.** Any out-of-band write, wall-clock read, or nondeterministic
  iteration folded into the status breaks `replay`: same log, different state. This is the
  determinism violation the committee classes CRITICAL (non-determinism injected into a
  deterministic context).

The whole risk lives in the connotation of the word. The object's storage is mutable; its
**semantics are a projection**. Reading (1) and reading (2) coincide operationally on the
forward run and diverge only on correction/replay — which is exactly where correctness is
decided.

## 4. Totality

Replay is total on well-formed prefixes and returns `Nothing` (via `foldM` halting at the
first refusal) on ill-formed ones — a re-registration, or a settle/expire on an
unregistered or absorbing unit (States.tex l.385–387; FutureLifeCycle l.426–438). The
`Maybe`/`Either` makes the partiality explicit and typed, restricting the domain to
well-formed streams. `UnitStatus` is therefore a *total* function on its proper domain —
the Paulin-Mohring totality requirement is met by typed domain restriction, not by pretending
totality over malformed input.

## 5. The one real gap: extend the canonical-writer closure to `UnitStatus`

The catamorphism property requires that **no writer of `UnitStatus` exists outside
`apply`.** `PositionState` already has this guarantee, made structural by C11 (per-field
canonical writer, a type error at authorship). `UnitStatus` carries no analogous stated
closure, yet its fields (`lifecycle_stage`, `last_settlement_price/date`,
`current_weights`, `nav_index`, `triggered_barrier`, `superseded_by`) are exactly the ones
a future maintainer is tempted to "just set." The reference happens to expose only
`register`/`settle`, but the *specification* should state the closure as an invariant, not
leave it to the reference's current shape.

## 6. What must change — and what must not

**Change (wording / model):**
1. In the state-home tables (FutureLifeCycle l.58; addendum l.162, l.196–199) pair the word
   *mutable* with *derived/projection*: e.g. "**projection of the log, materialised in
   place; overwrite-on-event, every write the image of a logged event under `apply`.**" Do
   not let "mutable, shared across holders" stand alone, because alone it asserts reading
   (1), which contradicts l.178, l.391, and l.399 of the same corpus.
2. State the catamorphism law for `UnitStatus` the way v10.3 P3 / FutureLifeCycle C1(b)
   states it for the whole ledger: `π_US ∘ replay` = fold over the prefix, total on
   well-formed prefixes, deterministic, reconstructible.
3. Extend the C11 canonical-writer discipline to the `UnitStatus` fields: the closed set of
   handlers that may write each is the only door, enforced at authorship.
4. Bind `UnitStatus` explicitly to the `first_touch_date` rule: on a back-dated correction
   it is **re-folded, never patched in place out of band.**

**Must NOT change:**
- The overwrite (non-versioned) storage discipline. It loses no history; the log holds it.
  Forcing a `NonEmptyList` version list onto `UnitStatus` would duplicate the log and
  violate Minimalism.
- The *u*-keying / "shared across holders" — correct and load-bearing.
- The `Maybe`/registration-totality and the monotone-carrier reasoning — correct.

---

**Bottom line.** `UnitStatus(t)` is a total, deterministic catamorphism over the event
prefix. The implementation already behaves as a materialised projection; only the *label*
risks asserting an authoritative-mutable object the rest of the corpus denies. Adopt the
projection characterisation, state the catamorphism law, and close the writer set.
