# MINSKY scorecard — StatesHome rewrite, Round 6

Lens: the Haskell reference (`reference/StatesHome.hs`) as the load-bearing
artefact — total functions, exhaustive cases, types as theorems, no representable
illegal state. The prose is held to one standard: every theorem it states about
the types must be delivered by the types, or be honestly downgraded to a disclosed
value-level check. Read as a fresh competent quant engineer who has NOT seen the
prior rounds.

## Grade: A (93%)

No GHC/runghc in the environment (`NO_GHC`), so `StatesHome.hs` was type-checked by
hand. It is clean on every axis of my lens. The grade is unchanged from Round 5:
the design is sound and the one residual I flagged last round is still cosmetic and
still non-blocking, but it was not picked up, so the percent does not move.

### Totality — full marks
Every exported library function is total. `currentTerms` is total via `NonEmpty`
(no `Maybe`, hs 110–111); `validate`/`applyDelta`/`replay`/`amend`/`register`
return `Either`; `productTerms`/`unitStatus`/`position` return `Maybe`. The only
partial code is the `expect*` demo glue (hs 493–494), correctly fenced and labelled
as the file's sole partiality (hs 488–491).

### Exhaustiveness — full marks
No wildcards in the library. `applyWrite` (hs 214–219) and `conserved` (hs
251–256) each cover all five `FieldWrite` constructors explicitly. `amend` (hs
419–434) covers `Maybe` (lookup) × `Fungibility` × the Breaking fresh-id collision
guard, with `otherwise` closing only the guard set — not a constructor catch-all.
`validate`, `register`, `applyDelta` use complete `| cond / | otherwise` pairs.
Adding a `Handler`/`FieldWrite` constructor breaks the build — which is the point.

### Illegal states — sound
`Ledger`, `ValidDelta`, `ProductTerms` are exported abstract (export list hs
31–59) with no setter/deleter, so the monotone carrier (C1b), append-only terms
(C6), and "an unconserved delta cannot reach `applyDelta`" (C2) hold by absence.
`register` (hs 325–331) is the sole unit introducer and writes PT and US together;
`applyDelta` (hs 348–366) rejects an unregistered `sdUnit` with `UnknownUnit`;
`amend` Breaking (hs 426–434) writes PT+US for the fresh id and guards id collision
— so "registered in PT ⇔ registered in US" holds by construction, as the reference
prose (§14) claims. The one representable illegal class — out-of-order `Lifecycle`
transitions via the unconditional `Map.insert` of `sdStatus` — is honestly
disclosed (tex §10, lines 720–724: "enforced by these tests, not by types —
distinct from P5") and not claimed away. P5 (tex 691–693) is correctly scoped to
per-key idempotency only.

### Types-as-theorems claims verified
- **P1 / S4** (tex 678–684, hs S4 478–483): conservation is a value-level
  smart-constructor check; the §9 intro and the P1 gloss say "unrepresentable" in
  the precise "unchecked delta cannot reach `applyDelta`" sense, and S4 names the
  boundary explicitly. Stated theorem = shipped proof.
- **P3** (tex 685–692, hs 368–377): `replay (xs <> ys) = replay xs >=> replay ys`.
  Verified by hand: `foldM f l0 (xs<>ys) = foldM f l0 xs >>= \l1 -> foldM f l1 ys`,
  exactly `(replay xs >=> replay ys) l0` in the `Either LedgerError` Kleisli
  category. The tex spells `>=>` out in words for the non-Haskell reader.
- **C2 monoid** (hs 288–294): `validate` folds `conserved` into `PosDelta` and
  demands `mempty`; both `dAc` and `dBalance` must net to zero independently —
  correct per-field conservation. The empty `foldMap` gives the vacuous/zero-holder
  base case (C9) for free. `WEntryNav` write-once (hs 219) and `WHwm` `qmax`
  monotone (hs 218) match their stated disciplines.
- **C3 / S1** (tex 424–435, hs S1 448–460): single-unit `StateDelta`; multi-unit
  atomic events are one `ValidDelta` per unit applied as a `foldM`. All-or-nothing
  holds at the value level: `foldM` returns `Left` on first failure and never hands
  back a partial ledger. Correct.
- **C11 / S3** (tex 305–317, hs 196–211): the `FieldWrite h` GADT is the
  field→writer relation; the index is erased at `SomeWrite` (hs 208–209), so the
  guarantee binds at authorship, not at the stored row. `_c11_ok_*` (hs 437–440)
  typecheck; the commented `_c11_bad` (hs 442–443) would not.

The S1–S4 expressibility signals remain exemplary intellectual honesty — they name
what the encoding does not prove and point at the correct layer. They should stay
verbatim.

## Non-blocking observation (does NOT gate the A)

- **`unique-writer` still survives in the Haskell comments (hs 44, hs 177) — carried
  over unfixed from Round 5.** The .tex now consistently says "canonical writer set"
  (tex 305–306, 552–553, 703), and the reference body agrees at hs 156 ("one
  canonical writer per field") and hs 184 ("ac writable by Settle and Trade (two
  constructors)"). But the export-list comment (hs 44) and the section banner (hs
  177) still tag C11 as "per-field unique-writer tagging" while `ac` has two
  authorised writers (`WAc :: 'Settle`, `WAcTrade :: 'Trade`, hs 197–198). This is a
  literal self-contradiction inside the reference and against the .tex. It
  self-resolves within two lines (hs 184 contradicts hs 177 immediately), touches no
  code, no type, and no correctness property, so a careful reader is not derailed —
  exactly the sub-blocking status it had in Round 5. Recommended one-word fix at hs
  44 and hs 177: "unique-writer" → "canonical-writer". I note it again only because
  it was left unaddressed; it is the sole reason the percent does not rise.

- **`StateDelta` `Show` in demo comments (hs ~526)** still abbreviates the derived
  record `Show` (`PosDelta 1000 0` vs `PosDelta {dAc = 1000, dBalance = 0}`).
  Illustrative comments in fenced demo glue; not load-bearing.

## Verdict
Totality and exhaustiveness are at full marks; the abstract-type disciplines,
`NonEmpty` terms, empty-fold C9 base case, PT⇔US-by-construction, two-track `amend`,
and the Kleisli/replay law are all correctly typed and faithfully mirror their
conditions. Every theorem the prose states is delivered by the types or honestly
downgraded to a disclosed value-level check. The single residual is a cosmetic
self-contradiction confined to two Haskell comment lines that the same block
resolves. This round clears my bar; I stake my lens on it.
