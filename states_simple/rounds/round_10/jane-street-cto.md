# jane-street-cto — Round 10 — States.tex

## Verdict: NOT-YET

The Haskell construction (Sections "The Construction" and "Why It Is Right") is
obvious: the code is small, total, the writers are sealed, conservation and replay
are visible by reading the listings linearly. If the file were only the code and
its captions, I would sign OBVIOUS.

It is not. The load-bearing *argument* — why three homes, by what test — is the
part a new reader must trust, and it does not clear the bar of "read once, write no
commentary." There is also one concrete correctness overclaim. A competent engineer
six months on will reach for a pen.

## Residue (located, actionable)

### 1. psHwm: "total peak exposure" is a false justification (correctness)
Lines 244–247 ("A position carries more than a balance"):
> "psHwm is also a Qty, and rightly: high-water marks add, summing over holders to
> total peak exposure."

Summing per-holder high-water marks yields the **sum of peaks**, not the **peak of
the sum**. These are equal only if every holder peaks on the same date; in general
sum-of-peaks ≥ peak-of-total, so the figure is an upper bound, not "total peak
exposure." This is a stated economic fact that is wrong, and it is the *reason given*
for the field being a Qty. The fact that psHwm stays zero in this file does not
excuse a justification a quant will flag on sight.
Action: drop the "total peak exposure" claim, or restate it correctly (e.g. "an
upper bound on aggregate peak exposure"). The Qty choice can stand on its own
without the false aggregation claim.

### 2. The boundary test is unextractable on one read (clarity of the core rule)
Lines 78–90 ("Why a Unit's State Lives" → Answer): the single rule that places every
fact — versioned vs overwritten — is delivered as one ~13-line run-on with five
em-dash asides nested inside it. The actual rule is never isolated as a sentence;
the reader must synthesize it from the paragraph. This is the most important claim
in the document and it is the hardest to recover.
Action: lead the paragraph with the rule, result-first, in one line — e.g. "A fact
is versioned iff a past-dated value of it can be read synchronously at the boundary;
otherwise it is overwritten, its priors recoverable only offline by replay." Then
let the existing justification follow. The content is correct; only the ordering
defeats the reader.

### 3. Cryptic load-bearing phrases that force decoding
A first-time reader stalls on these because they compress a whole step into a
genitive or a slogan:
- Line 71: "the multi-unit case is the reification's." (means: handled by the
  multi-instrument-relationship-is-itself-a-unit reification of §Answer — but the
  reader must reconstruct that.)
- Line 162: "So three homes are forced, not counted." (the intended contrast —
  derived rather than enumerated — is not self-evident from the words.)
These are not style nits; each is a step in the derivation stated too compressed to
parse without re-reading the surrounding section.
Action: expand each to a plain declarative clause naming what it refers to.

## What is done well
- Illegal states genuinely unrepresentable: `Active Price` folds price into the
  stage (no "active without price"); `NonEmpty TermsVersion` kills "registered but
  versionless"; the unexported constructors and single-writer seal make
  conservation hold by construction, not convention.
- `applyMove` writing two cancelling legs from one quantity, with the self-move /
  zero-move collapse to `mempty` handled and explained, is exactly right.
- The `Maybe` from `position` carrying "never held" vs "held and flat" is a precise,
  well-motivated distinction.

The design is right. The prose presenting *why* it is right is not yet obvious.
Fix item 1 (correctness) and items 2–3 (the two derivation steps that don't survive
a single reading) and this is OBVIOUS.
