# MILEWSKI — Round 7 Scorecard

**Lens:** Expressibility — does each concept map cleanly to Haskell, and where prose/notation
is awkward, is that a signal about the design?

**Grade: A (93%)**

Trajectory: R1 B(84) · R2 B(88) · R3 B(89) · R4 A(90) · R5 A(91) · R6 A(92) · **R7 A(93)**.

I stake my lens on this grade. Every concept in my domain maps to a total, deterministic
Haskell form; every categorical name used is the correct one; every place the encoding
stops short of a type-level guarantee is labelled and honest. A competent quant engineer who
has not read the review history can follow the type story in one careful pass.

---

## What this round fixed (the one live wobble from R6 is closed)

**P5 idempotency: "dedup" vs "structural" inconsistency — RESOLVED.**
In R6 the P5 gloss (then "per-key dedup") contradicted the testing-commitments cross-reference
("P5, whose idempotency is structural"). Both now say *structural*:
- §11 P5 (line 690-693): "...make idempotency structural at a single key, not cross-map
  coordination."
- §12 (line 718-723): "...distinct from P5, whose idempotency is structural."

The two readings are now consistent. The substance is defensible: a lifecycle event is a
`UnitStatus` replacement (`Map.insert u status` — idempotent), `hwm` is `qmax` (idempotent),
`entryNav` is write-once (idempotent). The non-idempotent writers (`WAc`/`WBalance`, additive)
are conserved fields governed by P1, not lifecycle events under P5. Under the natural reading
of P5, "structural" is honest.

---

## Categorical labels — all correct (my domain ownership)

Checked every categorical claim, because the name is exactly what this lens owns:

- **Replay = monoid homomorphism** (P3, line 686-693; .hs line 368-377). Law
  `replay (xs <> ys) = replay xs >=> replay ys` in the `Either LedgerError` Kleisli category.
  Order-preserving homomorphism, NOT antihomomorphism. Genuinely satisfied by `foldM applyDelta`:
  `foldM f z (xs++ys) = foldM f z xs >>= \z' -> foldM f z' ys`, which is exactly `>=>` in the
  ledger argument. The inline plain-words gloss of `>=>` (line 687-689) lets a reader who does
  not know Kleisli follow. Correct.
- **Conservation = group homomorphism landing at the identity** (.hs line 222-256; C2 line
  254-266). `conserved : FieldWrite h -> PosDelta`, totalled over wallets via `foldMap . foldMap`,
  "conserving" = image is `mempty`. The categorical name is said last, after the plain-words law
  — exactly the grounding discipline. Vacuous zero-holder case (C9) falls out of the empty
  `foldMap` with no special case, and the prose names the bug class it kills
  (`dividend/len(holders)`). Correct.
- **NonEmpty** (C6/C7) makes "registered but versionless" untypable; `currentTerms` total
  without `Maybe`. Correct.
- **Maybe accessor** (C1a) carries never-held vs held-and-flat, both load-bearing, never
  collapsed. Correct.

## Honesty at the type/value boundary — intact (S1–S4)

The four expressibility signals are still doing their job; no prose over-claims the encoding:
- **S4 / P1**: conservation is value-level (`validate -> ValidDelta`, `Either`), explicitly
  *not* a type fact. §11 preamble (line 668-676) states "unrepresentable" in the precise sense
  and points at S4. Abstract still says "render seven... unrepresentable rather than merely
  tested" but §11 immediately scopes the word. Honest.
- **S3 / C11 / P10**: the `FieldWrite (h::Handler)` GADT guarantee binds at authorship and is
  *erased* once writes share a delta row via `SomeWrite`. C11 (line 311-313) and P10 (line
  700-704) both say "type error at authorship, erased at the row." Matches the code. This is
  still the weakest of the seven mappings, but the prose is honest about exactly how weak.
- **S1**: cross-unit re-subscription is paired issuance, a separate event; a single-unit
  `StateDelta` cannot span two units. Stated at line 504 and §6 C8. Honest.
- **S2 / P9 / C4**: capability-scoped reads are a boundary/Reader concern, not stored-data
  shape; §11 P9 (line 698-699) says "enforced at the capability layer... not in the data
  reference." Correct call, stated.

## Vocabulary axes kept distinct

C2 event classes (`Trade, SettleVM, CorporateAction, QISRebalance, MandateAmend`) vs C11
field-writers (`Settle, Trade, Transfer, FeeCrystallise, Subscribe`) are explicitly named as
different axes (C11, line 313-317). No drift between tex and reference: tex uses `position(w,u)`
(reference exports `position`); migration alias is the pair `(product_terms(u), unit_status(u))`
— the R3 `++`-on-two-Maybes type error stays fixed. `balance` is the demonstrative second
conserved field, excluded from the §3 inventory on stated grounds (notation table line 122-127,
§3 line 203-205).

---

## Residual non-blocker (does NOT hold off A; recorded for the next reopen)

**P5 mechanism citation is slightly off-target for where lifecycle state lives.** The P5 gloss
(line 690-693) attributes lifecycle-event idempotency to "a single (w,u)-keyed row and a
per-field canonical writer (C11)". But the unit lifecycle stage lives in `UnitStatus[u]`
(u-keyed, idempotent by *replacement*), and C11 governs `PositionState` field-writers, not
`UnitStatus`. So the cited mechanism (PositionState (w,u) row + C11) does not fully match the
state whose idempotency P5 asserts. A careful reader in my domain can momentarily stumble:
"C11 is about PositionState writers — how does that give `UnitStatus` lifecycle idempotency?"

- Severity: precision nit in a one-line gloss; the *claim* (P5 idempotency is structural) is
  true, only the *attributed mechanism* is imprecise.
- Canonical fix if §11 is reopened: attribute P5 idempotency to `UnitStatus` replacement (and,
  for per-position OTC lifecycle, to `hwm` max / `entryNav` write-once), and contrast with the
  additive conserved fields (`ac`, `balance`), which are conserved under P1, not idempotent —
  not to C11, which is the wrong axis for unit-level lifecycle.

This is the only expressibility imperfection I find, it is a wording precision issue rather
than a representation defect, and it is consistent with the level tolerated at A in R5/R6.

---

## Conclusion

The reference is total and deterministic; the illegal states the addendum names as
unrepresentable are exactly the ones the types exclude, and the ones that remain value-level
checks (conservation, read-scoping, row-level field canon) are labelled as such with no
overclaim. The R6 wobble is closed and nothing regressed. **A (93%).**
