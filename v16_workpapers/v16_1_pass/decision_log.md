# v16.1 Pass — Decision Log

## DL-01 (2026-07-17) — The door's fail-closed refusal survives the door-time tiebreak

**Question (memo_w3 E.1):** Does Constitution v1.4's total order (execution time, then
door time, then event hash) supersede v16.0 ch04's fail-closed refusal of two
simultaneous non-commuting events for which no recorded precedence rule exists?

**Ruling: R-conform, unanimous 3–0.** The refusal survives. The total order is a
property of the ADMITTED stream; refusal happens before admission, not by reordering.
The door-time tiebreak orders only pairs that commute (order harmless) or whose order
a recorded precedence fact grounds. For a genuinely simultaneous non-commuting pair
with no precedence fact, harmlessness cannot be proved, so C-2.7's surviving sentence
— "the refusal to reorder anything unless harmlessness is proved" — governs and the
door fails closed.

**Votes:**
- jane-street-cto — R-conform. Only reading under which every sentence of C-2.7 is
  simultaneously true; non-commuting ⇒ door order is by definition not harmless, so
  R-tiebreak nullifies a clause kept verbatim in v1.4. Production reality: execution
  times are often business dates; same-dated non-commuting corporate actions on one
  instrument recur; R-tiebreak lets arrival latency decide entitlement — a fabricated
  world fact that later reads as a reconciliation break. A visible fail-closed stall
  beats a silent race deciding economic meaning.
- minsky — R-conform. The illegal state (economic precedence grounded in an arrival
  race) is unrepresentable when the constructor refuses; R-tiebreak makes it
  representable and narrows the refusal guarantee to nothing while relabeling the
  residue "total" (CLAUDE.md §1). Make the constructor partial and its refusal
  explicit; keep the illegal state unbuildable.
- correctness-architect — R-conform (authored recommendation, memo_w3 E.1): R-tiebreak
  is a Goodhart weakening — totality of the order bought at the cost of "order is a
  world fact."

**Consequence:** no parking; no amendment needed; v16.0's ch04 refusal text is
rethreaded (not weakened) to state its relation to the tiebreak. STYLUS drafts under
R-conform (was already instructed provisionally; ruling confirms).

**Note:** kleppmann was named a standing reviewer by the brief but is not among the
available agent types in this environment; recorded here and in each round record
rather than silently substituted.

## DL-02 (2026-07-17) — The substrate subsection stays product-agnostic

**Question (STYLUS flag 1):** Does the W4 substrate-mapping subsection name Temporal, or
stay product-agnostic ("the orchestration substrate") with a pointer to the companion
temporalv16.tex?

**Ruling: AGNOSTIC, unanimous 3–0.** The subsection's invariants (monitor time stamped
at the boundary; door time assigned inside the ledger; substrate clocks order nothing;
wipe-and-rebuild-from-ledger as the acceptance test) are properties any conforming
substrate must satisfy. Naming a product would assert the coupling the subsection is
designed to refute.

**Votes:**
- jane-street-cto — AGNOSTIC. The wipe-rebuild test IS the proof the substrate is
  replaceable; the pointer keeps Temporal detail one dereference away with no loss;
  named would be the leak, agnostic-plus-pointer is the correct seam.
- minsky — AGNOSTIC. The substrate is a parameter of the contract, not a constant;
  quantifying over "the orchestration substrate" makes the acceptance test total over
  every conforming substrate rather than true of only one.
- correctness-architect — AGNOSTIC. A product-named invariant is checkable against
  exactly one substrate, forfeiting the differential-determinism test against a second
  — the strongest evidence the property is real, not a Temporal artefact. temporalv16
  is the named conformance WITNESS, not the definition.

**Consequence:** STYLUS's sec:substrate framing stands unchanged; temporalv16.tex cited
as companion witness. (CLAUDE.md §5/§10 respected; load-bearing reason is portability
of the invariant.)

## DL-03 (2026-07-17) — Clause-discharge openers consolidate into one ch16 traceability table

**Question:** With the draft at 113pp vs the 112 cap, all mechanical levers pre-banked and
all sanctioned ornament taken, does the pass consolidate the 17 per-chapter
"discharges constitution clauses…" openers into one two-way traceability table in ch16
(~1pp saved, conformance content relocated, not deleted)? The alternative remedy —
document-design changes (margins/font) — was rejected by the orchestrator as
metric-gaming and was not on the ballot.

**Ruling: ADOPT-(a), unanimous 3–0.** A clause map is a coverage property; coverage is
only witnessable with a single complete mechanically-checkable source. One two-way table
makes completeness checkable by inspection (every C-x.y exactly once, no orphan, no gap)
— something seventeen scattered prose paragraphs cannot prove. All three panelists judge
the table better ON THE MERITS, independent of the page cap — which is what
distinguishes it from the rejected metric-gaming remedy.

**Binding conditions (from the votes):**
1. (correctness-architect, non-negotiable) The table is the NORMATIVE source and is
   proven bijectively complete — every clause present, clause→chapter and chapter→clause
   both total — BEFORE any opener is removed; CONCORDIA re-points its two-way walk to
   the table and re-runs it green.
2. (all three) A one-line pointer (or bare clause-ID stub) stays at each chapter head —
   local "what governs this chapter" context survives; the table governs.

**Votes:** jane-street-cto — ADOPT (one fact stated seventeen times becomes one
canonical auditable form). minsky — ADOPT (consolidation turns a distributed convention
into one checkable structure — the traceability equivalent of an exhaustive match).
correctness-architect — ADOPT (global completeness cannot fire as one check over 17
sites; the table makes the audit a single executable pass).

**Execution:** queued for the Round-2 application step (so Round-2 reviewers' line
references stay stable); the pen builds the table first, proves completeness against
the openers, then removes the openers and leaves the stubs.
