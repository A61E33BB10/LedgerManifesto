# jane-street-cto — Round 8 — States.tex

## Verdict: NOT-YET

The design is correct and the Haskell backs it. Conservation (§Why It Is Right) and
deterministic replay are clean, convincing, single-pass arguments — those sections are
obvious. The defect is in the two sections that carry the actual thesis (§The Answer,
§Why Three): they are compressed past the point where a competent engineer new to the
problem reads them once and writes no margin notes. Worse, the keystone — the emptiness
of the fourth cell — is closed by a *different* criterion than the one used to fill the
other three, and the bridge is an unshown "by minimalism." A new reader annotates. That
fails the bar.

I am not nitpicking density for its own sake. Each item below is a place where the
*argument*, not just the prose, forces the reader to reconstruct something the page should
have handed them.

## Residue (located, actionable)

### R1 — The fourth cell is closed by a different test than the other three. §Why Three, lines 146–164 (and the 2×2 setup at §The Answer, lines 65–78).

The 2×2 is presented as decided by two clean axes: (key: unit vs (holder,unit)) and
(correction discipline, settled by one test — "must a past-dated value be read at the
boundary, or is only its current value consumed?", line 67–68). Three cells are placed by
that test. The fourth cell's *emptiness*, however, is argued not by that test but by the
seal: "versioning an owned fact doubles its writer" (line 156). The document even
notices the criterion has shifted — "here the question is which key may host a definition
at all, and the seal answers it" (line 158–159).

So the reader is handed a 2×2 whose fourth quadrant is not adjudicated by the 2×2's own
axes. That is the single biggest "write commentary to understand it" moment in the spec.

The two arguments *are* reconcilable, and cheaply: the placement test alone closes the
cell once you grant that no (holder,unit) fact is boundary-sourced (they are all folded
from the move stream; external per-holding figures — custodian statements, PB reports —
are reconciliation inputs, not adopted, lines 159–162). No boundary source ⇒ no
past-dated boundary read ⇒ no correctable definition ⇒ fourth cell empty, *by the same
test that placed the other three*. The seal then becomes the independent, secondary
reason such a fact also *could not* be admitted even if one tried.

Actionable: close the fourth cell with the placement test first (one sentence: no
(holder,unit) fact is read past-dated at the boundary, therefore the correctable-
definition discipline never applies on that key), and demote the seal/owned-fact chain to
"and the seal would forbid it anyway." As written, the bridge premise — "by minimalism
the owned and recoverable is never versioned" (line 152) — is asserted, not shown, and it
is doing the load-bearing work. Status is *also* overwrite-owned and replay-recoverable,
yet its sibling terms *is* versioned; so "owned + recoverable ⇒ not versioned" is exactly
the inference the reader cannot take on the word "minimalism." Show it via the boundary
test or state it as the test, not as a virtue.

### R2 — The completeness of the answer rests on an explicitly-unproved universal, but §The Answer reads as settled. Lines 63–64 vs lines 100–108.

The reduction "every multi-instrument relationship / every wallet economic fact is a
(holder, unit) fact" is flagged as "assumed, not established here" (line 64). Yet two
load-bearing conclusions depend on it: the emptiness of the fourth cell (R1) and the
closure of holder-alone keying (lines 100–108). The mandate example (lines 166–172)
discharges it for *one* relationship and says the general case is assumed.

The problem for obviousness: lines 100–108 ("This closes the holder-alone keying… only
the unit and the (holder, unit) pair carry economic state") read as a *settled*
conclusion, with no inline marker that it is conditional on the unproved universal. A
reader who tracks the dependency writes the margin note "depends on the deferred
mandate-reduction — is the whole closure conditional?" That note is exactly what
"obvious, no commentary" forbids.

Actionable: mark the holder-alone closure (line 100–108) as conditional on the
assumption of line 63–64 in-place — currently the conditionality lives 40 lines upstream
and the conclusion is stated absolutely. One clause ("granting the reduction of §The
Answer") removes the note.

### R3 — Two new terms, their decision test, and their exhaustiveness proof are packed into one breath. §The Answer, lines 65–78.

The paragraph (a) names the two disciplines (correctable definition / superseding
observation), (b) states the boundary-read test that separates them, and (c) proves they
*exhaust* the space — "These exhaust a record of truth's disciplines — an immutable fact
is a definition of one version, a write-once owned field an observation written once,
deletion barred by immutability" (lines 71–73) — all in one paragraph. The exhaustiveness
claim is the subtle one (it collapses immutable-fact and write-once-field into the two
named disciplines) and it is delivered as a single subordinate clause. A first-time reader
cannot verify it in stride; they stop, unpack the four-way collapse, and annotate.

Actionable: lift the exhaustiveness argument out of the introduction paragraph into its
own short step, or reduce it to a claim the reader can check rather than a clause they must
decode while also absorbing the new vocabulary and the test.

## What is already obvious (so this is not a wholesale rejection)

- §Why It Is Right / Conservation (lines 349–364): invariant-of-the-writer framing,
  single-writer-of-psBal, base case at emptyLedger, sealed constructor closing the reach —
  this is exactly right and reads once.
- Deterministic replay (lines 366–388): purity ⇒ determinism, foldM split for
  checkpointing, "every view is a projection of the stream." Clean.
- The Position §Construction Maybe distinction (never-held vs held-and-flat, lines 329–342)
  is well-motivated and obvious.
- The "three homes, two maps" structural collapse (terms+status as a pair under one key,
  co-presence as shape not invariant) is a genuinely good move and clearly stated
  (lines 261–278).

The thesis is right. Two of the five sections are not yet obvious, and the empty-cell
keystone is argued off-axis. Fix R1–R3 and this clears the bar.
