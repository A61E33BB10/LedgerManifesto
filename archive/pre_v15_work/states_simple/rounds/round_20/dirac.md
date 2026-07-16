# DIRAC — States.tex, Round 20

**Verdict: NOT-YET.** One residue, located at the crux. The document is otherwise
unusually tight; the residue is a single notational equivocation that the entire
inevitability claim rides through.

## What the structure must do to clear the bar

The bar is: three homes inevitable from one rule, no unexplained special case, no
competing criteria. The whole edifice rests on one pivot:

    one rule  →  exactly TWO questions  →  2×2  →  three occupied cells  →  three homes

If "exactly two questions" is forced, the count is forced. If it is asserted, the
count is asserted. So the test is whether "two" is *derived* from the rule.

## Where the document is already inevitable (so this is not a broad rejection)

- **Competing criteria are actively disarmed, not merely avoided.**
  - "who *owns* the record's history, not who *sources* the number" (l.79–82, exercised
    on benchmark level vs benchmark identity, l.99–103) kills the obvious rival author
    criterion.
  - Conservation is shown *not* to be a placement criterion: `psHwm`, a non-conserved
    fact, rides in Position beside the conserved `psBal` (l.232–248). A reader tempted to
    sort by "conserved?" is refuted by construction.
  - Temporality is not a third axis: overwrite-vs-version is folded into the author axis
    ("produce and overwrite" vs "preserves version by version", l.81–82). No hidden third
    coordinate.
- **The empty fourth cell is principled, not contingent.** It is empty because the
  ledger's *boundary* treats an external party's statement of one holder's position as a
  reconciliation input, never as an adopted record (l.146–149) — this is the project's
  scope (external authorities are reconciled against, not performed). The managed-account
  near-counterexample is resolved by reification to a (client, mandate-unit) row
  (l.151–160), and the genuine exception (holder, several-units) is named and excluded by
  scope. This is the Dirac move done correctly: the formalism predicts four cells, one is
  empty, the emptiness is investigated and found forced.
- **"Two maps" is not a separate design choice.** It is the occupied-row count of the
  same 2×2: the per-unit row carries two cells (Status, Terms) → one map keyed by unit;
  the per-(holder,unit) row carries one cell → one map. Homes = occupied cells (3); maps =
  occupied key-rows (2). Both numbers fall out of one matrix.

Given all this, the document is one clause away from inevitable. It is not there yet.

## The residue (located, actionable)

**The rule names "home and writer"; the two failure modes, the two questions, and the
2×2 axes are "key and author." The first attribute is mislabeled, and "home" is then
silently re-defined as the cell. The exhaustiveness of "exactly two" is therefore
asserted, never derived.**

Trace the equivocation on the word *home*:

- l.48 / l.61: "each economic fact has exactly **one home and one writer**." Here *home*
  is **one of two attributes**, paired against *writer* — i.e. *home* ≈ key/location.
- l.85: "**Each occupied cell is a home**: one kind of state." Here *home* = **the cell**
  = (key-class × author-class), which already contains the author/writer coordinate.

These two readings cannot both hold. If a home is a cell (l.85), then the rule's "one
home and one writer" reads as "one cell and one writer" — but the writer is the cell's
own author column, so the rule double-counts authorship and its two clauses are no longer
two independent attributes. If instead a home is the key (so that "home" and "writer" are
two genuine attributes), then l.85 mislabels: a cell is a (home, author) pair, not a home.

This matters precisely at the pivot. The exhaustiveness sentence (l.64–68) is:

> "A fact fails the rule in only two ways: keyed wrong …; authored wrong …. Each of the
> two questions forestalls one failure, and **because there are only these two**, there is
> no third question…"

"because there are only these two" is the load-bearing claim and it is bare assertion.
The *reason* there are only two — that the rule is a conjunction of exactly two atomic
requirements, so a fact fails it by violating one conjunct or the other, and the rule
names no third thing — is never stated. And it *cannot* be read off the rule as written,
because the rule's two clauses are "home" and "writer" while the two failures are "keyed"
and "authored": the correspondence home↔keyed is left for the reader to reconstruct, and
it is exactly the place where "home" must mean key (to be the first attribute) yet must
mean cell (to be a home in the count). The argument switches senses of "home" across the
inflection point without saying so.

The cell-space (2×2) cannot repair this, since it is *introduced as the result* of the
two questions (l.84); using it to justify "only two questions" would be circular. The
two-ness must come from the rule alone, and the rule as phrased does not deliver it.

### Fix (one move, removes both faces of the residue)

State the rule as a conjunction of two *named, distinct* attributes — **where it is keyed**
and **who writes it** — and reserve "home" for the occupied cell:

1. Rule: each economic fact has exactly one **key** and one **writer** (single source of
   truth).
2. A conjunction of two requirements fails in exactly two ways — wrong key, wrong writer —
   and names no third, so there are exactly two questions. *(This is the missing
   derivation of exhaustiveness.)*
3. Two binary questions → 2×2 → three occupied cells. **Each occupied cell is a home.**

After this, "home" appears once, meaning cell; the rule's two clauses line up 1:1 with the
two failures and the two questions; and "only these two" is derived, not asserted. The
count becomes inevitable rather than tight.

## Bottom line

No unexplained special case (the empty cell is explained and forced; conservation and
sourcing are explicitly excluded as criteria). But there *is* a competing-sense problem at
the crux: "home" carries two meanings, and the exhaustiveness that fixes the count at
three is asserted through that equivocation rather than derived from the rule's two
clauses. Close the home/key naming and supply the one-clause exhaustiveness argument, and
this is OBVIOUS.
