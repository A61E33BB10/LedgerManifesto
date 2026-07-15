# DIRAC — Round 19 — States.tex

**Verdict: NOT-YET.** One residue, narrow and located.

## The bar

The three-home structure must read as inevitable *from one rule* — no unexplained
special case, no competing criteria. I tested the document against that and against the
Dirac questions: is the structure inevitable, is the notation revealing, can the
properties be predicted without solving, is the apparent multiplicity unified.

## What is already beautiful (and should not be touched)

The construction is, in substance, correct and largely inevitable. I record this so the
single residue below is not mistaken for a structural complaint.

- **The 2×2 is clean.** Two coordinates — key (unit vs holder+unit) and authority
  (ledger vs external) — span four cells; three are occupied, one is *proved* empty
  (§why, the managed-account counterexample discharged via the issued mandate unit). The
  count "three homes" is the occupancy of that grid. Inevitable, not chosen.
- **Three homes, two maps is not a special case.** It is the general operation
  "group occupied cells by their key": the two per-unit cells (Terms, Status) share the
  unit key and ride as a pair; Position has its own key. Same rule applied uniformly,
  not an exception. Co-presence becomes the shape of the map, not an invariant to police.
- **The tempting third axis is actively defused.** A fresh reader's instinct is to make
  *conserved vs not-conserved* a home criterion. The document forecloses this by placing
  `psHwm` (non-conserved) inside Position alongside `psBal` (conserved): conservation is a
  property of one field, never a home-distinguishing axis. The footnote on `psHwm`'s typing
  is exactly the right restraint (claims no aggregate its out-of-scope writer has not fixed).
- **The authority axis is held firmly once introduced.** "Who owns the record's history,
  not who sources the number" (line 71) and the benchmark level-vs-identity contrast
  (lines 90–95) both pre-empt the competing criterion "comes from outside ⇒ externally
  authored." Mutability (overwrite vs append) is shown to *be* the authority axis, not an
  independent one. No competing criterion survives.
- **The seams fall out of the algebra, not branches.** Self-move and zero-move both net to
  `mempty` and write no row — one statement, no special case. The `Maybe` is uniform
  ("is this unit known?", never "did the balance hold?"). `Nothing`/`Just`/`Just`-flat is
  one read distinction, not three code paths.

By the strict letters: no *unexplained* special case, and no *competing* (conflicting)
criteria. The document clears two of the three clauses cleanly.

## The residue — the one rule is never crowned

The clause it does not yet clear is "inevitable from **one** rule." §answer introduces the
generator as **two questions** (lines 59–60) and leaves them primitive. It never names the
single principle from which both descend — and the document everywhere else *relies* on
that principle without stating it as the generator.

That principle is the project's own telos: **one source of truth; internal reconciliation
failure cannot arise** (CLAUDE.md, line 6) — equivalently, *each economic fact has exactly
one stored representation and one writer; no representable way for two copies to drift or
two facts to collapse.* The two questions are not two criteria. They are the **two failure
modes of that one rule**:

- **Wrong key** fails it two ways: *collapse* (one unit-keyed value stores buyer +1000 and
  seller −1000 as one number — §why, line 116) and *duplication-drift* (a per-unit fact
  copied across holder rows, "a reconciliation break by construction" — line 121).
- **Wrong authority** fails it one way: *co-mingling-drift* (the authority's record and the
  ledger's own held as one value — "the single-source-of-truth violation the system exists
  to prevent," line 127).

So §why already states all three home-reasons in exactly the vocabulary of this one rule
(collapse / drift / co-mingle). The rule is *used* three times and *named* zero times. The
2×2 is therefore presented as the contingent occupancy of two posited axes when it is in
fact the enumeration of the ways one rule — faithful single representation — can fail.

This is not cosmetic under *this* bar. Two specific reading failures follow:

1. **The second axis arrives unmotivated.** The intro states the placement makes
   *"conservation and deterministic replay"* attainable (lines 47–48). The authority axis —
   half the generator — serves neither of those; it serves single-source-of-truth, a goal
   named **nowhere** in the intro or §answer. A reader meets question 2 (line 60) with no
   stated purpose; its reason first appears at line 127, deep in §why. Reading §answer
   top-to-bottom, the authority axis looks chosen, not forced. The inevitability is
   *reconstructable* after §why, not *delivered* at the point the structure is laid down —
   and "reads as inevitable" is the deliverable.

2. **Exhaustiveness is shown by example, not by the rule.** Why exactly two axes and not a
   third? The document defuses the one realistic competitor (conservation) by demonstration,
   which is good. But with the one rule named, exhaustiveness becomes a statement rather than
   a lucky absence: a fact's representation can be unfaithful only by being mis-keyed or
   mis-authored; there is no third way for one truth to split, so there is no third axis.
   Crowning the rule converts "we defused the obvious competitor" into "no competitor can
   exist," which is what makes *three* inevitable rather than merely *currently observed*.

## Located, actionable

- **Where:** §answer, lines 55–77 (the two-question framing and the 2×2), and the intro
  goal statement, lines 47–48.
- **What:** Before positing the two questions, name the one rule — single source of truth /
  faithful single representation, "internal reconciliation failure cannot arise" — and
  state the two questions as its two failure modes (wrong key: collapse or duplication;
  wrong authority: co-mingling). Add single-source-of-truth to the intro's goal list beside
  conservation, so the authority axis is forced by a stated goal rather than introduced
  bare. The material is entirely present in §why; this is promotion and ordering
  (result-first), not new content.

When the two questions read as the two ways one rule can break, the three homes stop being
the occupancy of a grid and become the only shapes faithfulness admits — and the structure
is inevitable from one rule. The document is one principle-naming away.
