# UnitStatus: Mutability, Time Travel, Reproducibility

## 1. The question

Should `UnitStatus` be mutable, and what does its mutability imply for time travel (reconstructing any past state) and reproducibility (replay yielding identical results)? The corpus labels `UnitStatus` "mutable, shared across holders" (FutureLifeCycle.tex l.58) while its own deeper rules call its contents projections of the immutable event log (FutureLifeCycle.tex l.178, l.399; States.tex l.391).

## 2. Recommendation

`UnitStatus` is a **materialised projection** of the immutable event log: the current value of a pure, total fold (catamorphism) over the event prefix, stored in an overwrite-in-place cell as a read cache, written only as the image of a logged event under `apply`. It is not an authoritative source of truth. "Mutable" names a storage and write discipline — overwrite-on-event, last-write-wins — not authority. The defect is one prose label, not the design. All nine members concur (9/9).

The mutable cell stays; the label changes. Relabel FutureLifeCycle.tex l.58 and addendum_stateshome_v2.tex l.162, l.196, and the "overwritten on every settle" passage (~l.584), to state that the cache cell is overwritten while the event that determines it is appended immutably. Strengthen (committee-endorsed): add a numbered materialisation-soundness invariant (stored `UnitStatus[u]` equals the pure fold of the unit's status events; no writer outside `apply`), extend the C11 single-writer closure to every `UnitStatus` field, and add gating tests (genesis re-fold equals incremental/snapshotted store; back-dated restatement of `last_settlement_price`/`superseded_by`; external observables captured as logged observation events). Do not version the cell, do not change the `u`-keying, the sealed `Ledger`, registration-totality, or idempotent write-by-replacement. States.tex must not change its model.

## 3. Independent positions

Nine members independently return DERIVED PROJECTION; the mechanism is correct and only the prose label is defective.

- **formalis** — `apply` is pure and total and the sole status writers (`register`, `settle`) are its cases, so π_US ∘ replay is a catamorphism over the prefix; reading (1) would license out-of-band writes that break replay.
- **finops-architect** — the settlement mark lives in the `Settled`/`SettleVM` event, not the cell; the refusal to cache `first_touch_date` is the projection discipline stated outright.
- **minsky** — the types admit only reading (2): the abstract `Ledger` with unexported constructor and selectors and no `setStatus` make the authoritative cell unrepresentable.
- **milewski** — "mutable" conflates authority with representation; the three maps are three step-algebras (append / replace / accumulate) for one fold over one log.
- **jane-street-cto** — every `UnitStatus` field is the image of an event; the design is spooky-safe only because the log is retained — a field poked out of band collapses it into reading (1), so the constraint must be a stated rule.
- **karpathy-code-review** — one mechanism, not two; the seal collapses store and log into a single fold; overwrite is safe because the discarded value is reconstructible by replaying a prefix.
- **nazarov-data-architect** — concurs, and raises a separable dissent: the `Settled`/`SettleVM` payload carries a bare scalar price with no attestation envelope (provider key, source, observation timestamp, fallback chain, signature, snapshot content-address) — the number replays deterministically but is unverifiable. Out of scope of the mutability question; recorded as a separate security defect (v10.3 l.1418/l.2644 unwired into the lifecycle event).
- **correctness-architect** — the equality making "mutable" safe (stored value equals genesis re-fold) holds by construction in the reference but is unguarded; the addendum's planned E1/E2 snapshotting and F3 caching would break it silently, so the invariant must be numbered and tested.
- **testcommittee** — only the projection reading admits a meaningful correctness test (live cell equals fold of the log); under the authoritative reading the cell is the truth, the test is vacuous, and checkpoint-independence is untestable.

**Dissent is on remediation scope, not characterisation.** correctness-architect, testcommittee, and formalis require relabel plus a numbered, tested invariant and full single-writer closure; finops-architect, minsky, milewski, jane-street-cto, and karpathy-code-review frame it as relabel plus one invariant sentence. Reconciled by doing both. nazarov's attestation finding is orthogonal. No clarification round needed.

## 4. Time-travel and reproducibility implications

**Materialised-projection reading (correct).** Time travel is exact: `clone_at(t) = π_US(replay(take_t E))` re-folds the event prefix and never reads the live cell; the overwritten value is irrelevant because its cause — the logged event — is retained. Both v10.3 (l.74) modes hold: "what we knew at t" is the fold over the original prefix; "t with restated data" is the fold over the prefix with appended compensating events. Corrections are events, never in-place edits. Reproducibility is bit-identical: `replay(E)` yields an identical `UnitStatus` for identical, totally ordered `E`, because `apply` is pure and total and the status is its image (foldM/Kleisli homomorphism, addendum P3; exact integer minor units, v10.3 l.619); write-by-replacement is idempotent, so the fold is stable across checkpoint cuts and de-duplication. Determinism rests on three preconditions, all met: a total order on same-timestamp events; every input to `apply` carried in the log (no ambient clock, config, or live feed); deterministic map operations.

**Authoritative-mutable reading (rejected).** Time travel breaks: a value patched in place without a corresponding logged event is unrecoverable on overwrite, state at t ceases to be a function of the event prefix, and v10.3 Property 6 fails — the precise failure the `first_touch_date` rule already forbids. Reproducibility breaks: any out-of-band write, wall-clock read, or nondeterministic iteration folded into the cell makes a fresh replay disagree with the live store for the same t — the non-determinism-in-a-deterministic-context hazard and the internal-reconciliation break the ledger exists to make unrepresentable.

**Governing rule.** On a back-dated correction, `UnitStatus` is re-folded, never patched in place out of band.

**Boundary caveat (does not affect the verdict).** Externally-sourced inputs must enter as logged, snapshotted observation events (deterministic oracle); byte-reproducibility is not attestation (nazarov's separate finding).
