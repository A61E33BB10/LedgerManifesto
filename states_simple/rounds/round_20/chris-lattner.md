# chris-lattner — States.tex, Round 20

**Verdict: NOT-YET**

The architecture is right and the document is, by now, almost entirely load-bearing.
The 2×2 derivation, the empty-cell discharge, the managed-account counterexample, and
the construction-then-proof arc all serve the answer and read cleanly for someone who
has never seen the problem. The Haskell is the proof that the placement is *attainable*,
not decoration, and §5 closes the two properties §1 promised. That is good
infrastructure writing.

It fails the bar on exactly one axis: **nothing said twice.**

## Residue

### 1. The governing rule is stated twice, near-verbatim, across the Question/Answer seam.

- §1 "The Question", line 48:
  > "Each economic fact then has exactly one home and one writer, so internal
  > reconciliation failure cannot arise"
- §2 "The Answer", lines 63–64:
  > "each economic fact has exactly one home and one writer --- single source of truth,
  > so internal reconciliation failure cannot arise"

This is the document's central claim restated within ~15 lines. A first-time reader hits
the identical clause twice before any new information arrives. The cause is structural:
§1 is doing double duty as both "the question" and an abstract — it pre-states the rule,
the consequence, *and* the mechanism names ("sealed single-writer discipline", "purity
and totality of replay") that §4/§5 own. §2 then re-owns the rule before decomposing it.

Actionable fix (one of):
- Let §1 pose the question and name only the *stakes* (one source of truth,
  conservation, deterministic replay) and stop. Let §2 be the sole place the rule "one
  home, one writer ⇒ no reconciliation failure" is stated, then decomposed into the two
  failure modes. This is the cleaner split: question states the prize, answer states the
  rule once.
- Or, if §1 must state the rule, open §2 directly on the decomposition ("The rule fails
  in only two ways…") and drop the restatement at line 63.

Either removes the echo without losing content.

### 2. (Lighter) The fourth-cell "is empty" is asserted three times before it is earned.

The table shows `--- empty ---` (line 94); lines 105–106 restate "The fourth cell … is
empty (§ref)"; §3 (lines 142–149) then proves it. The middle assertion (105–106) carries
only a forward-pointer plus the characterization "an externally authored (holder, unit)
fact" — content the table position and §3's heading already supply. Consider folding the
characterization into the table or letting §3's paragraph heading be the single home of
this claim. This one is marginal; I flag it for the author's judgment, not as the basis
of the verdict.

## What is *not* residue (so it is not re-litigated)

- **`psHwm`, always `mempty` here.** It earns its place: it is the concrete witness that
  the Position home carries a *non-conserved* per-(holder, unit) fact. Without it the
  ledger-authored (holder, unit) cell would hold only the conserved balance and the 2×2
  cell would be asserted, not exhibited. The defensive justification (lines 236–240) each
  forestalls a specific "why here / why this type" question. Keep it.
- **"by construction" recurring.** Distinct claim sites (conservation, append-only,
  co-presence, seal), not one claim repeated. Fine.
- **Self-move / zero-move netting to `mempty` at lines 300 and 322–324.** The second use
  marks itself "(above)" and draws a *different* consequence (row-writing, the definition
  of "held") rather than re-deriving. Acceptable.

Fix residue #1 and this is OBVIOUS.
