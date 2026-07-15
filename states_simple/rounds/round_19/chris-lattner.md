# chris-lattner — States.tex, Round 19

Verdict: NOT-YET

## Assessment

The architecture is right and the document mostly earns its strict bar. The arc is
clean: §1 promises two properties (conservation, deterministic replay), §2 places the
state (three homes, two maps), §3 justifies each placement and the empty cell, §4
constructs from the smallest forced pieces, §5 discharges the two promises. The proofs
are sound — `applyMove` as sole `psBal` writer summing two cancelling legs from one
quantity; `register`/`settle` touching only `ledgerUnit`; the sealed constructor and
withheld field selectors closing every other door. A competent first-time reader can
follow the simple path end to end. The type-level moves (price as a group-free newtype,
status correlation carried by `Active Price`, terms as `NonEmpty` with an unexported
constructor, co-presence as the shape of the pair) are genuinely load-bearing and each
buys an impossibility. Most of the document survives the "said once / serves the answer"
test, including the claim/justify/construct layering of the terms-vs-status distinction
across §2/§3/§4, which adds at each layer rather than repeats.

Two items keep it from obvious.

## Residue

### 1. The multi-instrument scoping caveat is stated twice, near-verbatim (§2 vs §3)

§2 (The Answer), lines 56–59:
"a relationship spanning several instruments that does not reduce to a single
(holder, unit) row lies outside this scope (§why)."

§3 (Why Three), lines 149–152:
"A relationship spanning several instruments that does not likewise reduce to a single
(holder, unit) row lies outside the scope of §answer: its fact would be a (holder,
several-units) fact occupying a fourth home and a third map, which the count excludes."

The scoping clause is the same statement in both places. §3 is where it earns its keep:
it lands after the managed-account discharge and adds the actual content (fourth home,
third map, excluded by the count). §2's occurrence is a bare restatement sitting beside
its own forward-reference to §why — so §2 both points to §why and pre-states the thing
§why says. One copy is removable. The fix: in §2, scope by forward-reference only
("the reification and the boundary of this scope are shown in §why") and let §3 carry
the single full statement.

### 2. The psHwm footnote over-reaches the question "where state lives" (§4, lines 229–234)

`psHwm` is `mempty` throughout this file, its writer is out of scope, and the body text
already establishes everything the answer needs from it: it witnesses that the Position
home can carry a non-conserved fact, and it bears no zero-sum invariant. The six-line
footnote then argues the *type theory* of an always-dormant, out-of-scope field — why it
is `Qty` rather than a group-stripped newtype like `Price`, and that the file claims no
aggregate over holders for it. That is construction minutiae about a field that does
nothing here; it does not serve the placement question. It exists only to pre-empt an
inconsistency the document itself raises by giving `Price`'s group-stripping such
prominence. The fix: cut the footnote, or compress it to a single clause on the main
`psHwm` line ("typed `Qty` to match its source; its aggregate is its out-of-scope
writer's to fix"). The `Price` rationale is load-bearing and stays.
