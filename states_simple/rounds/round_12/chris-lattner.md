# Round 12 — chris-lattner on States.tex

**Verdict: NOT-YET**

## What is right

The architecture is sound and the spine is clean. Two orthogonal questions
(holder-dependence; authorship) generate a 2x2, three cells occupied, and that
classification *is* the answer — placement falls straight out of the axes. The
construction then earns each home from the one before, and the two properties
named up front (conservation, deterministic replay) are discharged at the end
by construction, not assertion. The sealed-constructor / withheld-selector
discipline is the right single-writer self-defense, and the proof correctly
cites it as "no other door." Relevance is tight: I found nothing present that
fails to serve "where a unit's state lives" — the conservation and replay
proofs serve the attainability claim made in The Question.

The blocker is not relevance and not the simple path. It is the third
criterion: **the terms-vs-status writer discipline is said three times.** This
is the document's most-repeated idea, and the repetition is concentrated enough
to be a clear editorial residue, not a judgment call.

## Residue (located, actionable)

### 1. In-paragraph triplication of "appendVersion keeps / settle discards"
**Where:** §Why Three, paragraph "Terms are a home distinct from status"
(lines 135–141).

The keep/discard contrast is asserted three times inside one paragraph:

- narratively — "a correction the authority issues is appended as a new version
  and the prior kept" ... "the ledger overwrites it" (lines 130–133);
- structurally — "so the two are distinct values: a non-empty version list
  grown by `appendVersion`, a single value replaced by `settle`" (lines 135–136);
- explicitly — "the distinction the file exercises is the discipline its two
  writers show --- `appendVersion` keeps, `settle` discards" (lines 140–141).

The structural sentence and the tail of the last sentence are the same
statement in two phrasings, one line apart. Keep one. The load-bearing *new*
content in the final sentence is only "amendment is out of scope, so every
terms value has one version in this file" — see (2). Cut the redundant restatement
of the contrast.

### 2. "Amendment out of scope ⇒ one version in this file" stated three times
**Where:** §Why Three (line 138); §The Construction, "Registration and
settlement" (line 277, citing §why); §Why It Is Right, "Deterministic replay"
(line 384, citing §why).

The same caveat — amendment is out of scope, therefore every terms value here
carries exactly one version — is re-derived in three sections, twice citing the
section where it already lives. State it once (in §why) and let the later
sections rely on it without re-deriving the out-of-scope rationale. As written,
the reader is told the same thing on first read, then told it serves the writer
count, then told it serves replay — three encounters with one fact.

### 3. "Terms grow by appending, never overwriting" duplicated across Construction
**Where:** §The Construction, "Terms are the authority's record" (lines
211–218) and "Registration and settlement" (lines 271–281), overlapping in turn
with §Why Three (lines 130–136).

"Terms grow only by appending a version; the prior version stays" (211–212) and
"Terms grow by `appendVersion` instead, never overwriting" (277–278) say the
same thing two paragraphs apart, and both echo the §Why Three statement of the
same discipline. The Registration paragraph's job is to describe `register` and
`settle`; it does not need to re-establish the append-only rationale already
fixed in the "Terms are the authority's record" paragraph. Let Registration
state only what those two writers *do* and reference, not re-argue, the
discipline.

## Noted but not a blocker

- §Why It Is Right line 358 ("`psHwm`, written by no cancelling-leg writer,
  carries no such invariant") echoes lines 236–239, but in the proof it
  legitimately delimits the proof's scope to `psBal`. Defensible; not residue.
- The cancelling-legs mechanism appears in Construction (lines 234, 297–302)
  and again in the conservation proof (348–356). This is mechanism-then-global-
  invariant, the correct deductive shape; not duplication.

## What would flip this to OBVIOUS

Collapse the terms-writer discipline (append-keeps / overwrite-discards /
amendment-out-of-scope / one-version-here) to a single statement in §Why Three,
and let §The Construction and §Why It Is Right reference it rather than
re-derive it. The 2x2, the construction, and the two proofs already meet the
bar; only this one idea is currently paid for three times.
