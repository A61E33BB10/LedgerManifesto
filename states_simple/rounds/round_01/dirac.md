# DIRAC — Round 1 verdict on States.tex

**Verdict: NOT-YET**

The lens: the three-home structure must read as inevitable — the only possible
form, no unexplained special case. It does not, because the count rests on an
asymmetric application of the document's own principle.

## The structure the document actually uses

Two orthogonal axes appear in §"Why Three":

- **Key cardinality**: `unit` vs `(holder, unit)` (paragraphs 1, 2).
- **Mutation discipline**: append-only vs overwrite-in-place (paragraph 3),
  stated as a *general law*: "Append-only and overwrite-in-place are two
  disciplines; one home cannot enforce both without violating one of them."

A single governing principle would generate a 2×2 over {key} × {discipline}.
The document fills three cells:

| | append-only | overwrite |
|----------|-------------|-----------|
| `unit` | Terms | Status |
| `(holder,unit)` | **— (unaddressed)** | Position |

and then defends "there is no fourth" only against a **wallet-keyed** home
(paragraph 4, lines 56–61, 91–98) — a *third* axis. The empty cell of its own
2×2, `(holder,unit) × append-only`, is never addressed.

## The residue (decisive, located, actionable)

The fourth cell is **not** empty. The discipline law is waived for the
position home without a word.

- Line 92 names the per-position facts: "high-water mark, entry NAV, and
  accrued fee." Lines 179–182 pack them into one record `PositionState`.
- **Entry NAV is immutable per position** — a fixed historical fact at the
  moment of entry. HWM ratchets and accrued fee accrues — overwrite.
- Therefore `PositionState` bundles an immutable fact (entry NAV) with
  overwrite facts (HWM, accrued fee) in **one home** — exactly the bundling
  the document declared impossible at lines 86–89 when it forced Terms apart
  from Status: "one home cannot enforce both without violating one of them."

So the document's own discipline law, applied consistently, splits the
unit-keyed row into two homes (terms, status) but is silently suspended on the
(holder,unit) row, where immutable and overwrite coexist. Either:

1. the discipline law is not general (then the terms/status split at lines
   83–89 is not forced, and "Why Three" loses paragraph 3); or
2. the law is general (then Position must itself split — per-position entry
   terms vs per-position running state — and the answer is **four** homes,
   not three).

The structure cannot be inevitable while it both asserts the law and exempts
one row from it without stating why.

## A second, smaller residue: two axes, never unified

Paragraphs 1–2 of "Why Three" justify homes by *key*; paragraph 3 by
*discipline*; paragraph 4 rebuts a fourth on yet another basis (wallet vs
unit). Three different cleavage criteria are used to reach the number three.
For the count to read as inevitable, one principle must generate all three
homes and exclude all others. As written, a reader cannot predict the homes
from a single rule — the hallmark of a structure assembled, not derived.

## What would close it

State one classification principle, apply it once, and show the resulting cell
count exhausts the possibilities — including an explicit treatment of
`(holder,unit) × append-only`. If entry NAV genuinely belongs in Position,
explain why immutability there does *not* demand the separation it demands for
terms (a likely real answer: terms are an out-of-scope external reference-data
authority reconciled at the boundary, whereas entry NAV is produced by the
event fold and so is a projection, not an enforced discipline — but the
document never says this, and §"The Answer"/§"Why Three" justify terms purely
by discipline, not by provenance).
