# DIRAC — Round 10 — States.tex

## Verdict: NOT-YET

## Lens

Is the three-home structure inevitable — does the empty cell fall out of the
general case, or is it an unexplained special case?

## What is beautiful here

The skeleton is genuinely Dirac-shaped and I want to record that before the
objection. Two orthogonal binary distinctions — key (unit vs (holder, unit)) and
correction discipline (append vs overwrite) — give a clean 2×2. Each axis is
argued exhaustive: the key axis by reification of multi-instrument relationships
into units (§answer, with its assumption honestly flagged), the discipline axis
by "immutable definition vs write-once observation, deletion barred by
immutability." One unifying placement test governs the second axis: a *synchronous
past-dated boundary read* forces a materialized version list, because replay is
the offline rebuild path and cannot serve a synchronous read. That single test is
the right notation for the problem — it places terms, status, and position without
special-casing any of them. Three filled cells, each with a one-line concrete
reason. This is most of the way to inevitable.

## The residue (what blocks OBVIOUS)

The whole weight of "three, not four" rests on the emptiness of the fourth cell
((holder, unit) × correctable definition). The document claims this cell is
"forced, not counted" (line 162). The support establishes the weaker verb.

The placement test is: *does a synchronous past-dated boundary read of this fact
exist?* For terms the answer is shown by one domain example — entitlement cites
the benchmark identity in force on a past date (lines 99–101). For every
(holder, unit) fact the answer "no" is reached by **enumeration plus assertion**:
the document lists the facts it currently holds (held quantity, high-water mark,
write-once entry NAV), notes each is ledger-derived and external figures are
reconciliation inputs not adopted (lines 150–158), and then asserts "every such
fact is consumed at the boundary at its current value alone, none read past-dated"
(lines 156–157).

What is missing is the *principle* that makes a synchronous past-dated boundary
read structurally impossible on the (holder, unit) key — as opposed to merely
absent from today's inventory. A competent fresh reader raises the obvious
symmetric question: "What was my position on date X" is an as-of-date query just
as much as "what were the terms on date X." The document answers the position
version with "served by replay, offline" but the terms version with "synchronous,
from the live projection." That asymmetry is the linchpin that empties the fourth
cell, and it is asserted by example, not derived. As written, the reader can see
the cell is *currently* empty; they cannot see it *must* be. So "forced" is
unearned — it reads as "counted over the present fact set."

The fix is within reach because the document already states both halves it needs
(lines 150–158: every (holder, unit) fact is ledger-derived; external (holder,
unit) figures are not adopted as definitions). It stops one step short of joining
them: state the principle that as-of-date boundary *citation* attaches to
externally-authored definitions (the unit's terms drive entitlement as-of-date),
while every (holder, unit) fact is ledger-derived and enters the boundary only at
its current value (entitlement = f(current position, as-of-date terms)). Then the
(holder, unit) key *cannot* host a correctable definition, and the empty cell
becomes structural rather than enumerated.

A second, smaller seam compounds this. Line 149 says the fourth cell is empty "by
the same boundary test," but lines 159–162 then reframe it: "the question is
instead which key may host a definition." The reader is told it is one test, then
handed a differently-worded criterion. Whether or not these reconcile, presenting
two formulations of the load-bearing argument undercuts inevitability. Collapse to
one criterion.

## Residue, located

1. §why "The fourth cell is empty by the same boundary test" (lines 149–162) and
   §answer (lines 88–102, 156–157): the fourth cell's necessity is established by
   enumerating current (holder, unit) facts and asserting none has a synchronous
   past-dated boundary read. No stated principle makes such a read structurally
   impossible on the (holder, unit) key, so the cell reads as currently empty, not
   necessarily empty, and "forced, not counted" (line 162) is unearned. Fix:
   state the principle joining as-of-date boundary citation to externally-authored
   definitions vs ledger-derived (holder, unit) facts consumed only at current
   value.

2. Lines 149 vs 159–162: the fourth-cell emptiness is argued in two registers —
   "the same boundary test" then "which key may host a definition." Reconcile to a
   single criterion so the linchpin argument has one form.
