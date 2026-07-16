# FORMALIS Synthesis — Is `UnitStatus` Mutable? Consequences for Time Travel and Reproducibility

**Verdict: DERIVED PROJECTION (unanimous, 9/9).**
`UnitStatus` is a *materialised projection* of the immutable event log — the current value of a
pure, total fold, stored in an overwrite-in-place cell as a read cache. It is **not** an authoritative
source of truth. The word "mutable" in the state tables names a *storage / write discipline*
(overwrite-on-event, last-write-wins), not *authority*. The defect in the corpus is one prose label,
not the design.

---

## 1. The recommendation, stated precisely

Of the two readings put to the committee:

- **(1) AUTHORITATIVE-MUTABLE** — `UnitStatus` is a source of truth changed by in-place mutation; a
  past value, once overwritten, is gone. **Rejected.** Read literally as the authority, this reading
  contradicts the catamorphism the whole system rests on, makes the cell and the log two sources of
  truth that can diverge (the exact internal-reconciliation failure the project exists to forbid,
  CLAUDE.md), and is *unrepresentable* in the reference implementation.
- **(2) MATERIALISED PROJECTION** — `UnitStatus` is a pure fold of the immutable log, stored mutably
  only as a cache; every change is the image of a logged event under a pure function, so replay
  reconstructs it exactly. **This is the correct reading**, and the only one the types admit.

### Why (2) is correct (the load-bearing facts)

- In `States.tex` the only writers of the status half are `register` and `settle`, and both are
  reachable **only** as cases of the pure total `apply` over `Registered`/`Settled` events
  (l.374–381). `replay = foldM (flip apply) emptyLedger`. The `Ledger` constructor and field
  selectors are unexported (l.360–363): there is **no out-of-band `setStatus` door**.
- Therefore, as a theorem: `π_US ∘ replay = fold over the event prefix` — `UnitStatus[u]` after any
  stream is, *by construction*, the catamorphism over that stream. Total on well-formed prefixes,
  deterministic, reconstructible.
- The corpus already classifies the contents as derived: `last_settlement_price`/`date` are
  "projections of the `Settlement` carried by the stage, not independent fields" (FutureLifeCycle
  l.178); the general rule is "what the fold over the log determines is derived, not stored"
  (l.399); "every view is a projection of the stream" (States.tex l.391). Applied field by field,
  *every* `UnitStatus` datum (`lifecycle_stage`, `last_settlement_price/date`, `current_weights`,
  `nav_index`, `triggered_barrier`, `superseded_by`) sits on the derived side.
- The reference performs **no destructive mutation**: `settle` returns a new persistent map via
  `Map.adjust`. Referential transparency is intact. "Mutable" = overwrite-vs-append materialisation,
  not a side effect.
- The decisive corroboration is the design's own refusal to cache `first_touch_date` (l.396–399):
  a cached value would disagree with the fold under a back-dated correction. That is the projection
  discipline stated outright — fatal to reading (1), required by reading (2).

The three "mutation disciplines" are three step-algebras for **one** catamorphism over `[Event]`:
ProductTerms folds by *append*, UnitStatus by *replace* (last-write-wins), PositionState by
*accumulate*. None is authoritative; the immutable event stream is the single source of truth and all
three are equally its projections.

---

## 2. Time-travel consequence (explicit, per reading)

- **Under the correct reading (2):** time travel is **preserved and exact**.
  `clone_at(t) = π_US(replay(take_t E))` — re-fold the event prefix; never read the live cell. The
  overwritten cell is irrelevant because the cause of every past value (the `Settled`/lifecycle
  event) remains in the immutable log. Both modes v10.3 (l.74) requires are served: "what we knew at
  t" = fold over the original prefix; "t with corrected/restated data" = fold over the prefix with
  appended compensating events. Corrections are events, not edits.
- **Under the rejected reading (1):** time travel is **broken**. A value patched in place without a
  corresponding log event is unrecoverable on overwrite; state at t ceases to be a function of the
  event prefix; v10.3 Property 6 fails. Reading (1) is survivable today *only* because every value
  also exists as an event — i.e. because the system is actually (2). Taken literally, (1) is
  self-refuting against Property 6.

**Rule that makes it hold:** on a back-dated correction, `UnitStatus` is **re-folded**, never patched
in place out of band — the `first_touch_date` discipline applied to the marks.

---

## 3. Reproducibility consequence (explicit, per reading)

- **Under the correct reading (2):** `replay(E)` yields a **bit-identical** `UnitStatus` for
  identical, totally ordered `E`, because `apply` is pure/total and the status is its image
  (foldM/Kleisli homomorphism, addendum P3; exact integer minor units, v10.3 l.619). Determinism
  rests on three preconditions, all met in the corpus: (i) a total order on same-timestamp events;
  (ii) every input to `apply` carried *in the log* — no ambient clock, config, or live feed;
  (iii) deterministic map operations. Write-by-replacement is idempotent, so the fold is stable
  across checkpoint cuts and de-duplication.
- **Under the rejected reading (1):** reproducibility **breaks**. Any out-of-band write, wall-clock
  read, or nondeterministic iteration folded into the cell makes a fresh replay disagree with the
  live store for the same t — the CRITICAL non-determinism-in-a-deterministic-context hazard, and the
  internal-reconciliation break the ledger exists to make unrepresentable.

**Boundary caveat (does not affect the verdict):** reproducibility here is byte-reproducibility of
whatever number was captured; externally-sourced inputs (settlement prices, benchmark levels, barrier
observations) must enter as **logged, snapshotted observation events** (deterministic oracle), or the
fold loses purity at the boundary.

---

## 4. What MUST change, what MUST NOT — precise

**Scope of the fix: wording (relabel), plus one invariant and its tests. Not a redesign.**

### States.tex
- **MUST NOT change the model.** l.391 ("every view is a projection of the stream") and the
  `replay = foldM apply` reconstruction are already correct and are the authority the synthesis rests
  on. Optionally state the `UnitStatus` catamorphism law explicitly (`π_US ∘ replay = fold over
  prefix; total on well-formed prefixes; deterministic; reconstructible`) as the §"Why It Is Right"
  paragraph does for the whole ledger — clarification, not correction.

### FutureLifeCycle.tex
- **CHANGE the label, l.58** (state-table "Discipline" cell). The bare "mutable, shared across
  holders" is the single place in the corpus that speaks the wrong voice and licenses an implementer
  to add an off-log writer. Replace with, e.g.:
  *"materialised projection of the log; overwritten in place as a read cache; one value per unit,
  read identically by every holder; registration-total — every change is caused by a logged event
  and reconstructed exactly by replay."*
- **MUST NOT change** l.76–77 home table, l.178 ("projections of the `Settlement`"), or l.399 (the
  general rule). They already state the correct reading and are the textual ground for the fix.

### addendum_stateshome_v2.tex
- **CHANGE the label, l.162** (code comment `-- mutable, shared across holders; reg-total`) and
  **l.196** (home table row `$u$, mutable, shared`) to the same projection-phrasing as above.
- Reword "status is overwritten on every settle" (≈l.584) so it is explicit that the *cache cell* is
  overwritten while the `Settled`/`SettleVM` *event* that determines it is appended immutably.

### Invariant + tests (committee-endorsed strengthening; see split below)
- **ADD** the materialisation-soundness invariant to the C-list (call it MAT): *stored `UnitStatus[u]`
  equals the pure fold of the unit's status events; no writer exists outside `apply`.* In the
  reference this holds by construction; the addendum plans to leave that regime (E1/E2 snapshotting,
  F3 caching), at which point MAT becomes violable and must be asserted, not assumed.
- **EXTEND** the C11 per-field single-writer closure to *all* `UnitStatus` fields so no writer exists
  outside the fold — the one real gap.
- **ADD** gating tests: (i) genesis re-fold == incremental/snapshotted store (gate any caching work);
  (ii) a back-dated restatement test on `last_settlement_price`/`superseded_by` (the `first_touch_date`
  acid test applied to the mark); (iii) qualify external observables ("current benchmark level, from
  index source") to "captured as a logged observation event."

### MUST NOT change (unanimous)
- The **overwrite-in-place (non-versioned) storage** of `UnitStatus`. Do *not* make it
  append-only/versioned like ProductTerms — the log already holds the history; a version list would
  duplicate the log and violate Minimalism for zero correctness gain.
- The **u-keying / "shared across holders"** phrasing (a genuine, correct property — keep verbatim).
- The **sealed `Ledger`** (unexported constructor and field selectors) and the **closed writer set**
  (every writer a case of `apply` on an `Event`; no exported `setStatus`) — these are what make
  reading (1) unrepresentable.
- **Registration-totality**, **idempotent write-by-replacement** (P5), the **monotone PositionState
  carrier / `Option` accessor**, and **keeping `accumulated_cost` in PositionState** (path-dependent,
  conserved per-position).

---

## 5. The split — reported honestly

There is **no split on the verdict**: all nine members independently return DERIVED PROJECTION and
agree the mechanism is correct and only the prose label is the defect.

Two honest divergences exist, both on *remediation scope*, not on the characterisation:

1. **Relabel-only vs relabel-plus-invariant.** A subset — *correctness-architect*, *testcommittee*,
   and *formalis* — argue the fix must go beyond wording: add the numbered, tested MAT invariant and
   close the single-writer set over every `UnitStatus` field, because the safety currently holds only
   *by construction* in the reference and the addendum explicitly plans optimisations (E1/E2/F3) that
   would break that guarantee silently. *finops-architect*, *minsky*, *milewski*, *jane-street-cto*,
   and *karpathy-code-review* frame the fix as primarily a relabel (with an invariant *sentence*).
   These are reconcilable and reconciled above: relabel **and** promote MAT to a tested invariant —
   the wording fix removes the licence for the bug; the invariant + tests prevent the bug surviving
   the planned move off the by-construction regime.

2. **A separate, orthogonal finding from *nazarov-data-architect*.** Nazarov concurs fully on the
   mutability verdict but flags a *distinct* security gap independent of the label: the
   `Settled`/`SettleVM` payload carries the price as a bare scalar with **no attestation envelope**
   (provider key, source, observation timestamp, fallback-chain-as-traversed, signature, snapshot
   content-address). The number replays deterministically but is *unverifiable* — determinism ≠
   attestation. This is out of scope of the mutability question and does not change the verdict, but
   the committee records it as a real, separable defect (the requirement exists at v10.3 l.1418/l.2644
   but is not wired into the lifecycle event that strikes irreversible VM cash).

No clarification round is required: the body is unanimous on the verdict and the divergences are
additive, not contradictory.

---

*FORMALIS Committee — Xavier Leroy (Chair), Coquand, Huet, Paulin-Mohring, de Moura, Avigad, et al.*
*"We do not verify that code runs. We verify that code is correct."*
