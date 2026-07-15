# Round 3 Scorecard — MILEWSKI (Expressibility lens)

**Concept under review:** StatesHome addendum (`addendum_stateshome_v2.tex`) + reference
(`reference/StatesHome.hs`).
**Question my lens answers:** does each concept map cleanly to Haskell, and where the mapping
is awkward, is that awkwardness surfaced honestly (a signal about prose/notation/design) rather
than hidden behind over-claiming prose?

**Grade: B (89%).** Up from B 88% (round 2). The round-2 headline blocker is resolved; one
small but genuine expressibility flaw in my own domain holds it off A.

---

## What is now right (resolved since round 2)

1. **`balance` is reconciled (round-2 issue B5, was the standing blocker).** The notation table
   (lines 122–127) now states precisely what `balance` is: a *second conserved field, moved by a
   transfer, carried only by the reference to exercise the C11 per-field-writer discipline with a
   canonical writer distinct from `accumulated_cost`; neither the framework holding `h(w,u)` nor
   an economic datum of the §3 inventory.* §3 (lines 203–205) explicitly excludes it from the
   "home of each datum" table on the same grounds. This is exactly the canonical fix I named.
   The reference (`conserved (WBalance q) = PosDelta mempty q`) and the notation now agree.

2. **Categorical labels are correct.** Every occurrence is "homomorphism"; the round-2
   "(anti)homomorphism" mislabel is gone. The replay law `replay (xs <> ys) = replay xs >=> replay ys`
   (tex line 683, hs line 369) is the correct monoid homomorphism into the `Either LedgerError`
   Kleisli category, and `foldM applyDelta` genuinely satisfies it. This is the load-bearing
   structure and it is stated correctly — I stake my lens on that specifically.

3. **C11 prose is now honest.** Condition C11 (lines 305–316), P10 (lines 700–702), and the
   §11 intro (lines 668–675) all state the guarantee as "type error at authorship, erased once
   writes share a delta row," and the "unrepresentable" intro pre-empts the over-claim by
   defining the word precisely and pointing at signal S4 for the value-level conservation check.
   The C2-event-class / C11-field-writer axis divergence (round-2 issue) is stated explicitly
   (lines 311–316). The Expressibility Signals block (S1–S4) institutionalizes exactly this lens.

4. **Totality/determinism hold.** Every exported function is total (`NE.last`, `validate`,
   `applyDelta`, `replay`, `amend`, accessors); the only partial code is `expect` in `main`,
   acknowledged at lines 488–490. Exact `Integer` minor units keep conservation an arithmetic
   fact. Multi-unit atomicity (S1 paired issuance via `replay [burn, mint]`) is value-level
   all-or-nothing by purity — correct, and honestly described.

---

## Blocking issue (one)

**B1 — `++` used between two distinct record types in a Haskell-anchored document.**
Location: line 611. `get_unit_state(u)` is described as a deprecated alias for
`product_terms(u) ++ unit_status(u)`. In a document whose reference is Haskell, `++` is list
concatenation with a specific type; `productTerms` returns `Maybe ProductTerms` and `unitStatus`
returns `Maybe UnitStatus` — two different record types that cannot be `++`-ed. A Haskell-literate
reader (the target) snags here. This is the one spot in my exact domain (notation/expressibility)
that is type-incorrect rather than merely loose. Fix: write it as a pair `(product_terms(u), unit_status(u))`
or as prose ("the pair of terms and status"). One-line change; it is what keeps this off A.

---

## Non-blocking (noted, not gating)

- **Naming drift in the migration paragraph.** Line 612 maps the old `get_unit_state(w,u)` to
  `position_state(w,u)`, but the reference exports the accessor as `position` (hs line 387). These
  are v10.3 migration-target names, not the reference API, so the drift is contained to one
  paragraph — but a reader cross-checking against the reference will not find `position_state`.
  Consider naming the reference accessor to match, or noting the rename.
- **§13 "encoding carries the conditions" (lines 790–814) silently omits C4 and C12.** C4 is
  correctly out of the pure data reference (capability/Reader concern, signal S2) and C12 is a
  schema-shape claim; both are defensible omissions, but a one-clause "C4/C12 are not data-shape
  conditions; see S2 / §why-three" would close the loop for the careful reader.
- **`balance` is declared and wired into conservation but never exercised in `main`.** Fine —
  it is labelled "demonstrative" — but a single transfer leg in the runnable example would let the
  reader *see* the second canonical writer act, rather than infer it.

---

## Verdict

Every concept maps cleanly to Haskell; the one genuinely awkward concept (C11's authorship-only,
erased-at-row guarantee) is surfaced honestly as an Expressibility Signal rather than dressed up —
which is precisely how my lens wants awkwardness handled. Correctness is fully preserved and the
prose no longer over-claims the encoding. The single remaining defect (B1) is small, locatable,
and in my exact domain; fixing that one line earns the A. **B, 89%.**
