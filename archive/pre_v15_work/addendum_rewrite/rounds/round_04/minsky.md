# MINSKY scorecard — StatesHome rewrite, Round 4

Lens: the Haskell reference as the load-bearing artefact — total functions,
exhaustive cases, types as theorems, no representable illegal state. The prose is
held to a single standard: every theorem it states about the types must be
delivered by the types, or be honestly downgraded to a disclosed value-level
check. Read as a fresh competent quant engineer who has NOT seen the prior rounds.

## Grade: A (92%)

No GHC/cabal/runghc in the environment (`no-haskell-toolchain`), so
`reference/StatesHome.hs` was type-checked by hand again. It is clean on every
axis of my lens. The Round-1 blockers stay discharged, the Round-2 wording fixes
hold, and no regression appeared in Round 4. I stake my lens on the following.

### Totality — full marks
Every exported library function is total. `currentTerms` is total via `NonEmpty`
(no `Maybe`, line 110–111); `validate`/`applyDelta`/`replay`/`amend`/`register`
return `Either`; `productTerms`/`unitStatus`/`position` return `Maybe`. The only
partial code is the `expect*` demo glue (493–494), correctly fenced and labelled
as the file's sole partiality.

### Exhaustiveness — full marks
No wildcards in the library. `applyWrite` (215–219) and `conserved` (252–256)
each cover all five `FieldWrite` constructors explicitly. `amend` (419–434)
covers `Maybe` (lookup) × `Fungibility` × the Breaking fresh-id collision guard,
with `otherwise` closing only the guard set — not a constructor catch-all.
`validate`, `register`, `applyDelta` use complete `| cond / | otherwise` pairs.
Adding a `Handler`/`FieldWrite` constructor breaks the build — which is the point.

### Illegal states — sound
`Ledger`, `ValidDelta`, `ProductTerms` are exported abstract (export list 31–59)
with no setter/deleter, so the monotone carrier (C1b), append-only terms (C6),
and "an unconserved delta cannot reach `applyDelta`" (C2) hold by absence.
`register` (325–331) is the sole unit introducer and writes PT and US together;
`applyDelta` (348–366) rejects an unregistered `sdUnit` with `UnknownUnit`;
`amend` Breaking (426–434) writes PT+US for the fresh id and guards id collision —
so "registered in PT ⇔ registered in US" holds by construction, as §13 claims.
The one representable illegal class — out-of-order `Lifecycle` transitions on the
flat enum via unconditional `Map.insert` of `sdStatus` — is honestly disclosed
(§10: "enforced by these tests, not by types — distinct from P5") and not claimed
away. P5 in §9 is correctly scoped to per-key idempotency only.

### Types-as-theorems claims verified
- **P1 / S4**: conservation is a value-level smart-constructor check; the §9 intro
  and the P1 gloss say "unrepresentable" in the precise "unchecked delta cannot
  reach `applyDelta`" sense, and S4 names the boundary explicitly. Stated theorem
  = shipped proof.
- **P3**: `replay (xs <> ys) = replay xs >=> replay ys` holds for `foldM` over
  list concatenation (Kleisli composition in `Either LedgerError`). Line 369/688
  read "Kleisli homomorphism law" — correct, the Round-2 "(anti)homomorphism"
  wart stays fixed.
- **C2 monoid**: `validate` (288–294) folds `conserved` into `PosDelta` and
  demands `mempty`; the empty fold gives the vacuous/zero-holder base case (C9)
  for free. Both `dAc` and `dBalance` must net to zero independently — correct
  per-field conservation. `WEntryNav` write-once (219) and `WHwm` `qmax`
  monotone (218) match their stated disciplines.
- **C3 / S1**: single-unit `StateDelta`; multi-unit atomic events are one
  `ValidDelta` per unit applied as a fold. The C3 paragraph + S1 keep the
  `ac`-only example from reading as a complete two-unit trade. Correct.
- **C11 / S3**: the `FieldWrite h` GADT (196–201) is the field→writer relation;
  the index is erased at `SomeWrite` (208–209), so the guarantee binds at
  authorship, not at the stored row. `_c11_ok_*` typecheck; the commented
  `_c11_bad` would not. Prose carries the S3 caveat. Honest.

The S1–S4 expressibility signals remain exemplary intellectual honesty — they
name what the encoding does not prove (cross-unit conservation, capability
scoping, row-level field canon, value-level conservation) and point at the
correct layer. They should stay verbatim.

## Non-blocking observations (do NOT gate the A)

- **"unique field-writer" vs the two-writer set for `ac` (tex 306, 699) —
  carried unfixed from Round 3.** C11's body (306) says "the unique field-writer
  permitted to mutate it: `ac`→settle/trade …" and P10 (699) repeats "the unique
  field-writer per field," yet the shipped type gives `ac` two authorised writers
  (`WAc :: FieldWrite 'Settle`, `WAcTrade :: FieldWrite 'Trade`, hs 197–198). The
  condition *title* ("per-field **canonical** writer"), the notation table (125,
  "a canonical writer"), the C11 index row (551, "one canonical field-writer"),
  and the §13 prose ("written only by settle and trade", 301) are already
  correct; "unique" is the lone slip, and it self-contradicts inside its own
  sentence ("unique … ac→settle/trade"). The underlying theorem P10 actually
  needs — each field has a *closed* writer-set and any writer outside it is a type
  error at authorship — is delivered by the type; "unique" merely overstates the
  set's cardinality. Self-resolving for a careful reader, so sub-blocking.
  Recommended one-word fix at both sites: "unique field-writer" →
  "canonical field-writer (one writer-set)".
- **P5 gloss "single (w,u)-keyed row" (tex 689)** still reads slightly off for the
  `lifecycle_stage` datum, which lives in the u-keyed `UnitStatus`; the claim
  (single home + overwrite dedup) holds regardless. Cosmetic, unchanged.
- **Demo-comment `Show` forms (hs ~511, 526)** abbreviate derived-record `Show`
  output (`PosDelta 1000 0` vs `PosDelta {dAc = 1000, dBalance = 0}`).
  Illustrative comments in fenced demo glue; not load-bearing.

## Verdict
Totality and exhaustiveness are at full marks; the abstract-type disciplines,
`NonEmpty` terms, empty-fold C9 base case, PT⇔US-by-construction, two-track
`amend`, and the Kleisli/replay law are all correctly typed and faithfully mirror
their conditions. Every theorem the prose states is either delivered by the types
or honestly downgraded to a disclosed value-level check. The single residual is a
one-word imprecision the document itself contradicts elsewhere; it does not derail
the target reader and does not touch correctness. This round clears my bar.
