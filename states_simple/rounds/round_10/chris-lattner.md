# chris-lattner — Round 10 — States.tex

**Verdict: NOT-YET**

## What is right

The architecture is sound and I would defend it. Two orthogonal distinctions
(key: unit vs (holder,unit); correction discipline: append vs overwrite) give a
2x2, three cells occupied, the fourth empty by the same test — that is a real
derivation, not a count. The code earns its claims structurally rather than by
convention: `NonEmpty` makes "registered but versionless" unrepresentable; the
unexported constructors enforce single-writer; the `(ProductTerms, UnitStatus)`
pair makes terms/status co-presence the *shape* of the map rather than an
invariant to police; `Maybe` from `position` carries a load-bearing distinction
(never-held vs held-and-flat). Conservation is argued correctly as a property of
the sole `psBal` writer over the sealed type, with `emptyLedger` as base case.
`applyMove`'s self-move/zero-move handling is correct (legs cancel to `mempty`,
no row written). Illegal states are not representable — the thing I care most
about. No code bug found.

That is the design being right. The charge is narrower: is it *obviously* right
as presented, with the whole document a simple path and nothing present that does
not serve the answer? Not yet. Three located items.

## Residue

### 1. The third home's sole justification is out of scope (substantive)

§2 lines 78–88 and §3 lines 134–139 establish that terms and status are *both*
replay-recoverable; the ONLY thing that separates them is the correction
discipline, and the discipline is chosen by one test — "whether a past-dated
value is read at the boundary." For terms, that past-dated boundary read is the
entire reason append-only exists. But §3 lines 142–147, §4 lines 286–289, and §5
lines 390–391 all state that the past-dated read and the amendment event are out
of scope, and that within this file every terms value has exactly one version.

Consequence for a reader new to the problem: nothing in the document exhibits a
single place where append-only earns its existence. The type-level difference
(`NonEmpty` vs scalar) is a *consequence* of the distinction, not a
justification of it. Asked "why is terms not just an overwrite like status?",
the document can only answer "out of scope." The most elaborate third of "The
Answer" rests on machinery never made concrete here. The third home is therefore
asserted-as-justified, not shown.

Action: either exhibit one past-dated terms read end to end (even a one-line
projection that reads the version in force on a date), or state plainly at the
top of §2 that the third home's justification is taken on scope and not
demonstrated in this file — so the reader knows not to look for it.

### 2. §2 lines 78–90: the placement test is stated three times in one paragraph

The same conclusion — "a past-dated boundary read forces the version list;
otherwise overwrite and recover priors by replay" — appears at lines 78–79
("settled by one test: whether a past-dated value of it is read at the
boundary"), again at lines 82–84 ("A past-dated boundary read therefore cannot
be served by replay: it must come from the live projection, which must then
carry the past value"), and a third time at lines 87–90 ("What places a fact is
therefore not what replay can rebuild ... but what the live projection must
materialize ... forces the version list"). This is the densest passage in the
document and it restates its own result twice. State the test once, result
first; the orthogonality and the `2x2` follow in one step.

### 3. §3 lines 134–147 (Terms paragraph) duplicates §2

§3's job is "why three" with concrete grounding, and the Position and Status
paragraphs (lines 120–132) do add it — the +1000/−1000 buyer/seller, the
drift-by-construction argument. The Terms paragraph does not: lines 137–139 ("A
correction to terms appends a version, keeping the prior; a correction to status
overwrites...") restate §2 lines 78–84, and the pairing conclusion ("ride
together as a pair... a third home, not a third map") is already in §2 line 110
and restated again in §4 lines 260–269. "Three homes, two maps" is asserted at
least three times. Reduce the §3 Terms paragraph to whatever concrete reason it
alone supplies, or fold it into §2.

## Bottom line

The solution is right; the presentation is not yet the simple path. The central
distinction it spends the most prose on is the one whose justification it places
out of scope (item 1), and the prose restates its load-bearing conclusions two
to three times (items 2, 3). Fix item 1 and the document becomes obviously
right; items 2 and 3 are what make the simple path read like the complex one.
