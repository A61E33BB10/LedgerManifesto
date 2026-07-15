# Round 1 Scorecard — henri-cartan

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** Documentation architecture — definitions before use, brief motivation first,
explicit quantifiers, no handwaving, self-contained, layered.

## Grade: B (85%)

## Summary

The architecture is, on the whole, exemplary for my lens. Motivation precedes mechanism
(abstract states the question and the answer first; §1 poses the question, §3 gives the
answer, then §4 derives it). The notation table (§2) is fixed before use and cleanly
separates framework primitives from document-local symbols. The conditions are introduced
where the instrument forces them and collected in an index (§5), giving genuine layering:
a casual reader gets the one-sentence answer (§13) and abstract; a specialist gets full
derivation and a reference implementation. Quantifiers are mostly explicit and correctly
ordered ("for every $u$", "for all but finitely many $w$"). TOC, numbered conditions, and
cross-references make it navigable.

It falls short of A on a small number of precision and definition-order defects that force
a careful reader to stop and reconstruct meaning. None compromises correctness; all are
local and actionable.

## Blocking issues

1. **Undefined term "$(w,u)$ lattice" (§9, P5, line 632).** P5's gloss reads "a single
   $(w,u)$ lattice and a per-field canonical writer (C11) make idempotency a per-key dedup."
   The word "lattice" appears nowhere else in the document and no lattice structure is
   defined (join-semilattice of lifecycle stages? the keyspace ordering?). This is cryptic
   in my lens. Either define the lattice at first use or replace with the intended plain
   phrasing (e.g. "a single $(w,u)$-keyed row").

2. **`StateDelta` used before it is characterised; absent from notation (C2, §4.1, line 230
   vs C3, §4.3, line 389).** C2 says handlers "emit a `StateDelta`" with no prior
   definition. The only characterisation — "A `StateDelta` spans ProductTerms, UnitStatus,
   and PositionState; applies in full or not at all" — arrives two subsections later in C3.
   The notation table (§2) lists $\Delta f(w,u)$ but not `StateDelta`. Add `StateDelta` to
   §2, or introduce it at first use in §4.1, so C2 does not depend on a forward reference.

3. **The set of "conserved fields" is never enumerated, yet quantified over (§4.1, line 224;
   C2, line 232; $0_P$, line 122).** C2 asserts $\sum_w \Delta f(w,u)=0$ for "every conserved
   field", and $0_P$ is "all conserved fields zero", but the document only exhibits one
   example (`accumulated_cost`). A reader cannot determine whether `hwm`, `entry_nav`, or the
   fee fields are conserved — i.e. cannot evaluate the universal quantifier or the definition
   of $0_P$. State the conserved-field set explicitly (or the predicate that decides it).

4. **Condition numbering is out of reading order, with no note at first encounter (§4).**
   §4.1 introduces C2, then C1, then C11; §4.2 introduces C12; §4.3 C3, C4; §4.4 C5, C7, C9,
   C10, C6, C8. The labels are a reference scheme, not reading order, and §5 reconciles them
   — but a one-pass reader meets "C2" before "C1" and "C11"/"C12" long before "C3" with no
   signpost. Add a single sentence at the start of §4 (or in §3) stating that C-numbers are
   stable labels indexed in §5, not introduction order.

5. **$0_P$ notation entry forward-references concepts defined two sections later (§2, line
   122-123).** "The first-touch row and the held-and-flat row are both $0_P$" uses
   "first-touch" (explained in §4.1) and "held-and-flat" = $\mathrm{Some}(0_P)$ (defined in
   C1(a), §4.1). In the notation section these terms are not yet established. Either defer the
   illustrative sentence to §4.1 or mark it forward.

6. **Pareto scores asserted without a rubric (§8, table lines 583-588).** "Six designs were
   scored 0--10 on testability, correctness, and simplicity" presents numeric scores
   (A 4/5/4, B 9/9/8, …) with no stated scorer or scoring criterion. The per-design "one
   forcing reason" prose below carries the real argument; the numbers lend an unearned air of
   measurement. Either cite the rubric/source that produced the scores or demote the table to
   an explicitly qualitative ranking.

## Non-blocking observations

- Prose/code terminology drift: prose says `StateDelta`, the reference (§12) says
  `ValidDelta`. §12 bridges it, so acceptable, but a one-line note tying the two names would
  remove the seam.
- §9 names the seven discharged invariants (P1, P3, P5, P6, P7, P9, P10) but never names
  P2, P4, P8 nor why they remain merely tested. Self-containment would improve with one
  sentence accounting for the other three.
- Dependence on v10.3 §11 for the invariant *statements* is the largest self-containment
  gap, but it is explicitly flagged and each invariant is glossed; acceptable as a precise
  external reference.
