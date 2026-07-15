# Round 9 — milewski (Expressibility lens)

**Grade: A (93%).** Held at 93%, unchanged from rounds 7 and 8. No regressions, no new
defects. One residual non-blocker persists and continues to cap the score below 94%.

## Lens

Does each concept map cleanly to Haskell? Are the categorical names correct in my exact
domain? Does the prose claim only what the encoding delivers?

## Re-verified clean this round

- **Conservation = group homomorphism landing at the identity** (`conserved : FieldWrite h ->
  PosDelta`, totalled over wallets, "conserving" = image is `mempty`). Stated in words first,
  categorical name last, exactly as the restraint rule requires. The vacuous zero-holder case
  (C9) falls out of the empty `foldMap` — `dividend/len(holders)` bug class excluded by
  construction. Correct.
- **Replay = Kleisli/monoid homomorphism**: `replay (xs <> ys) = replay xs >=> replay ys` in
  the `Either LedgerError` Kleisli category (tex P3, lines 683-690; `.hs` lines 388-397). It is
  a homomorphism (order-preserving), NOT an antihomomorphism — `grep` confirms zero
  "antihomo"/"anti-homo" in both files. Checkpoint-independence is a consequence of the law,
  not a test. Correct and genuinely satisfied by `foldM applyDelta`.
- **`NonEmpty TermsVersion`** makes "registered but versionless" untypable; `currentTerms`
  total without `Maybe` (C6/C7). Correct.
- **`Maybe` accessor on `position`** distinguishes never-held (`Nothing`) from held-and-flat
  (`Just zeroP`) — C1(a), load-bearing, never collapsed. Monotone carrier C1(b) enforced by
  absence of a row deleter on the abstract `Ledger`. Correct.
- **`ValidDelta` abstract, sole constructor `validate`** — unconserved delta cannot reach
  `applyDelta`. S4 honesty intact: conservation is a value-level check, acknowledged ("not a
  type fact"), not dressed up as a type-level guarantee.
- **C11 GADT (`FieldWrite (h :: Handler)`)** — S3 honesty intact: prose says "type error at
  authorship, erased once writes share a delta row," matching `settleHandler ::
  ... -> Map WalletId [FieldWrite 'Settle]` and `erase = fmap (map SomeWrite)`. The `main`
  path builds `tradeSD`/`closeSD` via `erase . settleHandler`, so the authorship-site check is
  exercised live, not only in the static `_c11_ok_*` witnesses. The C2-event-class vs
  C11-field-writer axis divergence is stated explicitly (C11 paragraph, lines 312-316).
- **Migration pair** (line 612): `get_unit_state(u)` aliases the *pair*
  `(product_terms(u), unit_status(u))` — the round-3 `++`-on-two-`Maybe`s defect stays fixed.
  `position(w,u)` named correctly throughout (round-4/5 drift stays fixed).
- **`balance` reconciliation** (notation table 122-127; §3 exclusion 203-205): still declared a
  demonstrative second conserved field, canonical writer = transfer, explicitly "neither
  h(w,u) nor an economic datum of the §3 inventory." Stable.

## Residual non-blocker (caps at 93%; does NOT fail the A bar)

**P5 gloss cites the wrong axis (tex lines 691-692).** The gloss reads:

> P5 (idempotency of lifecycle events) — a single (w,u)-keyed row and a per-field canonical
> writer (C11) make idempotency structural at a single key, not cross-map coordination.

The *claim* (idempotency holds structurally) is true, but the *mechanism* is mis-attributed in
my domain, and it now directly contradicts §sec:untraded. Lines 479-481 state that an untraded
option "moves LISTED→ACTIVE→EXPIRED **entirely through UnitStatus, creating no PositionState
row**." So the canonical lifecycle path touches neither a `(w,u)`-keyed row nor a C11 field —
the two mechanisms P5 names. Unit-level lifecycle lives in `UnitStatus[u]` (u-keyed) and is
idempotent **by replacement** (`usLifecycle = Active` twice = once); C11 governs `PositionState`
field-writers, a different axis. A careful reader reconciling P5 against §sec:untraded hits a
contradiction.

This is the same residual flagged in rounds 7 and 8, unchanged. It is non-blocking: the
guarantee is real and the true mechanism is recoverable. It is the one thing standing between
this document and a higher score in my lens.

**Canonical fix (if §11 is reopened):** attribute P5 to `UnitStatus[u]` replacement
(idempotent by overwrite) plus `hwm` (max) / `entryNav` (write-once) for per-position OTC
lifecycle — both replacement/monotone-idempotent — and contrast with the *additive* `ac` /
`balance` fields, which are conserved under P1, not idempotent. Drop the "(w,u)-keyed row +
C11" attribution for unit-level lifecycle; it is the wrong axis.

## Verdict

A (93%), staked on my lens with the single P5-gloss residual explicitly noted. Every concept
in the addendum maps cleanly to the reference Haskell; every categorical name in my domain is
correct; the prose claims only what the encoding delivers (S1-S4 honesty intact). The P5
mechanism mismatch caps the score but does not fail the bar — a competent quant engineer
understands the design in one careful pass.
