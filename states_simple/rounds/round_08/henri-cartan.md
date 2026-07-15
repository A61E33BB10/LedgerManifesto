# Round 8 — henri-cartan — States.tex

## Verdict: NOT-YET

The two properties proved in §5 are sound and complete: conservation follows by
induction (sealed constructor, single `psBal` writer, same-unit cancelling legs,
zero base case), and deterministic replay follows from purity, totality, and the
`foldM` split law. These I do not contest.

The document's actual *answer* — "a unit's state lives in exactly three homes" —
rests on a discriminator that the construction can neither evaluate nor exercise,
and on a universal premise the text itself marks unproven. The omitted proofs are
missed.

---

### Residue 1 (primary) — the terms/status discriminator is unrealized and unexpressible

**Location.** §2 "The Answer" ¶4 ("must a past-dated value of the fact be read at
the boundary, or is only its current value consumed?"); §3 "Why Three", paragraph
"Terms are a home distinct from status..."; §4 construction `TermsVersion`,
`ProductTerms`, `currentTerms`.

**Blocker.** The *sole* reason terms is a home distinct from status is that "the
version in force on a past date is read at the boundary without replay." Both are
conceded replay-recoverable; the placing criterion is explicitly *not*
recoverability but the past-dated boundary read. Yet nothing in the model can
select "the version in force on a past date":

- Events carry no timestamps (`Registered UnitId TermsVersion`, `Settled UnitId
  Price`, `Move ...`).
- `TermsVersion = TermsVersion String` is opaque; the list `NonEmpty TermsVersion`
  carries no effective-date index.
- The only reader is `currentTerms = NE.last`, which returns the current version
  only. No as-of-date reader exists.

So "past-dated" is not even a representable notion here, and — since the text states
"every terms value has exactly one version" in this file — the distinguishing
capability is never exercised. In scope, the terms home is a one-element list whose
sole reader returns its one element: behaviourally indistinguishable from the
overwrite cell it is claimed to differ from. The justification for the third home
thus references a capability the in-scope model lacks; the claim that terms *needs*
version retention is asserted, not shown.

**Action.** Either (a) introduce effective-dating on versions plus an as-of-date
reader and exhibit one concrete past-dated boundary read, demonstrating that status
under overwrite cannot answer it while terms can; or (b) restate the terms/status
discriminator on a property the in-scope model can actually evaluate, and drop "read
at the boundary without replay" as the stated reason until it is constructible.

---

### Residue 2 (primary) — the keying axis rests on an admittedly unproven universal

**Location.** §2 "The Answer" ¶2 ("a relationship spanning several instruments is
itself a unit issued to its parties ... that it covers every multi-instrument
relationship is assumed, not established here"); §3 managed-account paragraph.

**Blocker.** The binary keying axis (every fact depends on the unit alone or on a
(holder, unit) pair) is what makes the classification a 2×2, hence "three occupied
cells." That binarity requires that every multi-instrument relationship reduce to an
issued unit. The text discharges this for exactly one relationship (the managed-
account mandate) and explicitly leaves the universal unestablished. A load-bearing
premise of the headline conclusion is therefore unproven by the document's own
admission; the answer follows from definitions *plus* an open assumption.

**Action.** Prove the general reduction (every multi-instrument relationship is
representable as an issued unit, summing to zero), or narrow the stated answer to
the cases established so "three homes" is not claimed more broadly than proved.

---

### Residue 3 (secondary) — the placement test is not shown to be a function

**Location.** §2 "The Answer" ¶3, the test "must a past-dated value ... be read at
the boundary, or is only its current value consumed?".

**Blocker.** The test presupposes each fact falls into exactly one case. No
tie-break is stated for a fact whose past-dated value is read at the boundary by one
consumer while only its current value is consumed by another. Without a rule (e.g.
"any past-dated boundary read forces the definition discipline"), the placement is
not well-defined as a function and the partition into homes is not total.

**Action.** State the tie-break rule explicitly and show it places every fact in one
cell.
