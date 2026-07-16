# Round 10 — milewski (Expressibility lens)

**Grade: A (95%)**

Lens: does each concept map cleanly to Haskell? Awkwardness is read as a signal
about prose, notation, or design.

## Verdict

The single recurring residual that held me at A/93% across rounds 7, 8, and 9 is
**resolved** in this round. No regressions, no new defects in my domain. I bump
off 93% and stake my lens on the result.

## The resolved residual (rounds 6→9 carryover)

For three rounds the P5 gloss (idempotency of lifecycle events) attributed
lifecycle idempotency to a "single `(w,u)` row + C11." That was off-axis and, since
round 9, in direct contradiction with §6 (`sec:untraded`, lines 479–481), which
states the lifecycle runs "entirely through UnitStatus, creating no PositionState
row." Unit lifecycle lives in `UnitStatus[u]` and is idempotent by *replacement*;
C11 governs `PositionState` field-writers, a different map and a different axis.

The current P5 (tex lines 691–699) is exactly the canonical fix I named:

- lifecycle stage lives in `UnitStatus[u]`, `u`-keyed, written by replacement →
  `EXPIRED` over `EXPIRED` is `EXPIRED`; idempotency is structural at a single key;
- the untraded unit's lifecycle discharges P5 touching no `PositionState` row
  (now consistent with `sec:untraded`);
- the non-conserved PS fields carry the same algebra — `hwm` by `max`
  (`max(x,x)=x`), `entry_nav` write-once;
- the additive conserved fields `accumulated_cost` and `balance` draw their
  replay-safety from **P1 (conservation), not replacement** — i.e. the doc no
  longer over-claims that additive fields are idempotent. This is the precise
  distinction I flagged in round 6.

No `C11` appears anywhere in the P5 gloss now; the remaining C11 references
(notation table line 124, condition line 305, index line 552, P10 line 707, F4
staging line 763, reference §8.x) are all legitimate and on-axis. P10 correctly
owns the canonical-writer-set attribution.

## Re-verified clean this round

- **Categorical labels.** `grep` confirms zero `antihomo`. Conservation is a
  *group homomorphism* `Map WalletId [SomeWrite] -> PosDelta` landing at `mempty`
  (.hs 242–276; tex C2). Replay is the *Kleisli / monoid homomorphism*
  `replay (xs <> ys) = replay xs >=> replay ys` (.hs 388–397; tex P3 line 684) —
  homomorphism, order-preserving, not anti. Checkpoint-independence falls out of
  the law (C1(b) stabilises the key set).
- **NonEmpty / Maybe.** `ProductTerms` over `NonEmpty TermsVersion` makes
  "registered but versionless" untypable (P6). `position` returns `Maybe`, the
  load-bearing C1(a) never-held vs held-and-flat distinction. Both faithful.
- **Honesty signals S1–S4 intact.** S1 (cross-unit conservation → paired issuance,
  not a single-unit delta) consistent with §6.4 amendment prose. S2 (C4 read-scoping
  is a capability/Reader concern at the boundary, not stored-data shape). S3 (C11
  binds at authorship, erased at the row via `erase = fmap (map SomeWrite)`;
  `settleHandler :: ... -> Map WalletId [FieldWrite 'Settle]` is the live call site;
  `main` runs `erase . settleHandler`). S4 (conservation is value-level via
  `validate`→`ValidDelta`, not a type fact). The reference says these point at the
  *design*, not contortions, and the prose matches the code's actual reach. This is
  the restraint rule honoured — no abstraction over-sold.
- **Abstract `Ledger`** (no setter/deleter) keeps the monotone carrier (C1(b)) and
  the PT⇔US registration invariant by construction. `applyDelta` only
  inserts/updates; `register` writes both maps; `amend` Breaking writes both for the
  fresh unit. Verified in `main`'s GHOST case (unregistered delta rejected, US never
  fabricated).
- **`balance` reconciliation** stable: notation table (124–127) and §3 (203–205)
  both declare it a demonstrative second conserved field (writer = transfer, distinct
  from ac), explicitly neither `h(w,u)` nor a §3 economic datum.
- **Migration** (line 611–613): `get_unit_state(u)` aliased to the *pair*
  `(product_terms(u), unit_status(u))` — no `++` across two record-typed Maybes (the
  round-3 blocker stays fixed); `position(w,u)` named correctly (no `position_state`
  drift).

## Blocking issues

None. Every concept in my domain maps cleanly and totally to the reference Haskell;
every categorical name is the correct one and is stated last, after the plain-words
law; every place the type system stops short of the guarantee (C4, C11-at-row,
conservation) is named as such rather than papered over. A fresh competent quant
engineer can follow the type story in one careful pass.
