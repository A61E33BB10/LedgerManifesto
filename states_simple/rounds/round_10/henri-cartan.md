# henri-cartan — Round 10 — States.tex

## Verdict: NOT-YET

## What is obviously right

I verified the load-bearing parts and they hold.

- **Construction.** The Haskell reproduced in §The Construction is correct against
  `States.hs`. `Qty` is a monoid with an explicit inverse; `applyMove` writes the two legs
  `negQty q` and `q` from one quantity, nets per wallet, and skips a `mempty` delta — so the
  self-move and zero-move cases collapse to no row exactly as the prose claims. `register`,
  `settle`, `appendVersion`, `currentTerms`, `position` all do what the text says.
- **Conservation.** §Why It Is Right proves it completely: `applyMove` is the sole writer of
  `psBal`, each move changes the per-unit holding sum by `negQty q <> q = mempty`,
  `register`/`settle` leave `psBal` untouched, the base case `emptyLedger` sums to zero, and
  the sealed constructor makes the reach exhaustive. Nothing is missed here.
- **Deterministic replay.** `apply` is pure and total (every branch returns a defined
  `Maybe`, no partial patterns), `replay` is `foldM`, and the checkpoint-splitting appeal to
  the monadic left-fold law is a genuine, citable identity for `Maybe`. Sound.
- **The three placements, taken individually.** §Why Three gives one concrete forcing reason
  per occupied cell (two holders differ → holder in key; one shared value → unit key; two
  correction disciplines cannot inhabit one value → terms distinct from status). Each is
  clean and complete.

So the two properties the introduction promises are established, and the code is right.

## Residue (what blocks OBVIOUS)

### 1. The minimality claim is stated more strongly than it is proved. (primary)

**Location:** §The Answer, line 162 ("So three homes are forced, not counted"), resting on
line 67 ("No key other than the unit or the (holder, unit) pair carries economic state ...
given the reification above"), which rests on lines 62–64 ("a relationship spanning several
instruments is itself a unit issued to its parties ... that it covers every multi-instrument
relationship is assumed, not established here").

**Blocker:** Exhaustiveness — that there is *no* further key carrying economic state, hence
"three homes, two maps" is the minimum basis and not one candidate among several — is the
project's Minimality principle for this design. It is load-bearing: if the reification fails
for some multi-instrument relationship, a genuine fourth home (and a third map) is not
excluded. The document admits the universal is not established, yet line 162 delivers the
conclusion unconditionally ("forced, not counted"). A conditional theorem with its
hypothesis flagged is rigorous; an unconditional headline whose proof depends on an
admittedly-open universal is not. The companion `States.hs` resolves this correctly (lines
421–435 and 778–781: "stated honestly as *conditional on that reification* ... three homes
suffice and no fourth is forced"); `States.tex` should adopt the same explicit conditional
at line 162, or establish the universal. As written, the reader who reaches line 162 is told
minimality is proved; only by holding lines 62–67 in mind do they learn it is assumed. The
omitted proof is therefore missed precisely where the strongest claim is made.

**Action:** Restate line 162 as conditional on the reification (mirror `States.hs`), or prove
that every multi-instrument relationship reifies as a single issued unit.

### 2. An aggregation claim about `psHwm` is asserted as fact and is not true as stated. (minor)

**Location:** §The Construction, "A position carries more than a balance," lines 246–247:
"high-water marks add, summing over holders to total peak exposure."

**Blocker:** The sum over holders of per-holder high-water marks is `Σ (peak exposure)`,
which is in general an *upper bound* on the aggregate's true peak exposure, not equal to it —
peaks of different holders occur at different times, so `peak(Σ) ≤ Σ peak`. The claim is
presented as a plain fact (unlike the assumption in residue 1, it carries no flag) to justify
giving `psHwm` the `Qty` group structure. The type choice needs only "high-water marks add"
(monoid); the gloss "summing over holders to total peak exposure" overstates. `psHwm` is
out of scope and stays zero, so this is minor — but by the rigor standard it is a statement
asserted true that does not survive scrutiny.

**Action:** Drop the "total peak exposure" gloss, or qualify it as an upper bound on
aggregate peak exposure.

## Note

Residue 1 is the real blocker; it is a discrepancy between `States.tex` and the more
careful `States.hs`, and it touches the Minimality principle directly. Residue 2 is a
correctness blemish in an out-of-scope justification. Conservation, replay, and the
construction itself are obvious and proved.
