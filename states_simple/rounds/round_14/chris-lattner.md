# States.tex — Round 14 review (chris-lattner)

**Verdict: NOT-YET**

## What is right

The architecture is sound and the answer is clearly delivered. "State lives in
three homes, held in two maps," followed by two orthogonal placement questions
(holder-dependence, authorship) producing a 2×2 with three occupied cells — this
is the right backbone. The progression from `Qty` (group) → keys → status → terms
→ position → ledger → writers is genuinely forced step-by-step, each piece earning
the next. The conservation argument (single writer touches `psBal`, sealed
constructor closes the other doors, induction from `emptyLedger`) and the
deterministic-replay argument (pure total `apply`, `foldM` split law) both close.
No cell, map, type, or writer is unmotivated. The empty fourth cell is justified,
not asserted. This is close.

It fails the bar on one criterion only: **nothing said twice.** The same
mechanism is explained at full length in more than one place, where a citation
plus the one new point would suffice. These are located and actionable.

## Residue

### R1 (strong) — the authorship mechanism is derived twice

`§The Answer` (lines 70–77) defines the authorship axis by its mechanism:
externally authored = "the ledger preserves version by version"; ledger-authored =
"the ledger's own events produce and overwrite," closed with the settlement-price
example. That fully establishes append-vs-overwrite.

`§Why Three`, "Terms are a home distinct from status…" (lines 127–137), then
re-derives the *same* mechanism: "a correction the authority issues is appended as
a new version and the prior kept… Status is the ledger's own record: its own
settlement event produces the value, so the ledger overwrites it." A first-time
reader hits this paragraph having just learned it.

The only non-duplicated content in 127–141 is the load-bearing one: co-mingling
the authority's record with the ledger's own *is the single-source-of-truth
violation the system exists to prevent* (134–136). That is the actual "why" and
should stand alone. Fix: in `§Why Three`, cite the axis from `§The Answer` rather
than restate append-vs-overwrite, and keep the SSOT-violation justification as the
reason terms is a distinct home.

### R2 (medium) — "amendment out of scope, one version each" said twice

`§Why Three` (138–141): "The amendment event that grows the list is out of scope
here, so within this file every terms value has exactly one version, and the
distinction is exercised only as the contrast between its two writers."

`§Construction`, "Registration and settlement" (279–281): "appendVersion, the
other terms writer, is driven by no event in this file (§why), so register and
settle are the only writers exercised." Same fact, re-stated (the `(§why)`
citation is present but the content is repeated rather than merely used). State the
scope boundary once.

### R3 (mild) — psHwm "writer out of scope, stays zero here" echoed

The prose at line 240 ("Its writer, a valuation event, is out of scope here, so
psHwm stays zero in this file") is immediately echoed by the code comment at line
246 ("writer out of scope, stays zero here"), and again referenced at 358. The
prose/comment pair sit adjacent and carry the same payload; a comment should label
or add, not repeat the sentence above it. Drop the echo from the comment.

### R0 (note, lowest confidence) — the authorship criterion is illustrated twice

The lesson "provenance does not determine the cell" is taught by the
settlement-price example (77, "sourced from the exchange, is ledger-authored") and
again by the benchmark level-vs-identity example (95–97, "both come from that
provider"). The benchmark case adds "one provider yields both," a slightly
stronger form, so this is defensible — but it is the same teaching landing twice
within two paragraphs. Worth a second look once R1 is resolved, since collapsing
R1 may make the benchmark illustration the natural single home for this point.

## Bottom line

The simple path is the whole document and everything present serves the answer —
that half of the bar is met. The "nothing said twice" half is not: the
authorship/append-overwrite mechanism (R1) and the out-of-scope caveat (R2) are
each stated in full in two sections. Resolve R1 and R2 (and trim R3), and this is
OBVIOUS.
