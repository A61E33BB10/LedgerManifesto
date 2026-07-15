# Round 8 — MILEWSKI (Expressibility lens)

**Grade: A (93%)**

Lens: does each concept map cleanly to Haskell? An awkward mapping is read as a
signal about prose, notation, or design — not just a code nit.

## Verdict

The addendum and `reference/StatesHome.hs` continue to map cleanly onto the
Haskell. No regressions from round 7; no new defects in my domain. Every
categorical claim that my lens owns re-verified correct this round. I stake the
A on it, with one carried, non-blocking imprecision noted below. Holding at 93%
(not higher) because that single residual — flagged in rounds 6 and 7 — is again
unfixed; not lower because nothing regressed and the reference is clean, total,
deterministic, and categorically honest.

## Re-verified correct (the labels my lens owns)

- **Conservation = group homomorphism landing at the identity.** `conserved`
  maps each `FieldWrite` into the abelian group `PosDelta`; `validate` folds
  `foldMap (foldMap conserved)` over the rows and accepts iff the image is
  `mempty` (StatesHome.hs:228–256, 288–294). "Conserving = image is `mempty`"
  is exactly right, and the categorical name is said last, not first.
- **Vacuous zero-holder case (C9) falls out for free.** The empty `foldMap` is
  `mempty`, so a zero-holder event validates with no special case — the
  `dividend / len(holders)` divide-by-zero bug class is unrepresentable because
  the code sums deltas and never divides by a count. Prose (C9, lines 483–488)
  and code (lines 286, 530, 561) agree.
- **Replay = monoid homomorphism, not antihomomorphism.** `replay (xs<>ys) =
  replay xs >=> replay ys` in the `Either LedgerError` Kleisli category
  (tex P3 lines 681–690; StatesHome.hs:368–377). Order-preserving, genuinely
  satisfied by `foldM applyDelta`. Checkpoint-independence is stated as a
  consequence of the law, which is the correct claim. No mislabel anywhere
  (`grep` confirms zero occurrences of "antihomo").
- **`NonEmpty` makes "registered but versionless" untypable** (C6/C7);
  `currentTerms` total without a `Maybe`. Correct.
- **`Maybe` accessor (C1a)** distinguishes never-held (`Nothing`) from
  held-and-flat (`Just zeroP`); monotone carrier (C1b) enforced by absence of
  any row deleter on the abstract `Ledger`. Correct.
- **Honesty signals intact.** S4 (conservation is value-level via `validate` →
  `ValidDelta`, not a type fact) and S3 (C11's index binds at authorship, erased
  at the delta row via `SomeWrite`) are both stated plainly. The C11 prose
  (lines 305–317) and P10 gloss (line 701) match exactly what the GADT delivers
  — "type error at authorship, erased at the row," never overclaimed as
  structurally unrepresentable in the P1 sense.
- **Migration paragraph** (lines 611–613): the round-3 `++`-between-two-Maybes
  blocker stays resolved (the pair `(product_terms(u), unit_status(u))`), and
  the accessor is named `position(w,u)`, matching the export. No drift.

## Sole residual (non-blocking, carried from rounds 6–7)

**P5 mechanism citation is off-axis** — §11, lines 691–692.

> "P5 (idempotency of lifecycle events) — a single (w,u)-keyed row and a
> per-field canonical writer (C11) make idempotency structural at a single key…"

Unit lifecycle (`lifecycle_stage`) lives in `UnitStatus[u]` (tex lines 191, 233;
`usLifecycle`, StatesHome.hs:133) and is idempotent **by replacement**, keyed by
unit `u`. C11 governs `PositionState` **field-writers**, keyed by `(w,u)` (tex
line 552). So the cited mechanism ("(w,u) row + C11") names the wrong sector for
unit-level lifecycle. The *claim* (idempotency is structural, not cross-map
coordination) is true; only the attributed mechanism is mismatched.

Why non-blocking: a reader can still follow that idempotency is local because a
thing's state is concentrated at one key. The friction is "which condition do I
cite," not a correctness error, and it does not touch the reference code. It
caps the score rather than failing the bar.

Canonical fix if §11 is reopened (unchanged from round 7): attribute P5 to
**`UnitStatus` replacement** for unit lifecycle, plus `hwm` (max) and `entry_nav`
(write-once) for per-position OTC lifecycle, and **contrast** with the additive
conserved fields `ac`/`balance`, which are conserved under P1, not idempotent.
Do not cite C11 for unit-level lifecycle — wrong axis.

## Not defects (deliberate, correctly signalled)

- §7 "encoding carries the conditions" omits C4 and C12. C4 is a capability/
  Reader concern at the boundary (S2) — correctly out of the pure data
  reference; C12 is a design argument, not an encoding. Both calls are right.
- `psBalance`/`Transfer` is a demonstrative second conserved field, declared as
  such in the notation table and excluded from the §3 inventory. Consistent
  across tex and `.hs`.
