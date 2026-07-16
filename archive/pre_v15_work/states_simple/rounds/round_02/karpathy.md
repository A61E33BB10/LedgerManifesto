# karpathy — States.tex, Round 2

**Verdict: NOT-YET**

Big progress over round 1. The three blockers I raised then are gone:

- The held quantity now lives explicitly in `psBal` as the primary, conserved
  field of `PositionState`, and `ledgerPS` carries it — the "carries more than a
  balance" line is now literally true, and the conservation proof is about the
  map the answer actually contains.
- `Event`, `apply`, and `replay` are shown; the `Maybe` is correctly explained
  as a guard on input (unregistered unit), reconciled with the can't-fail thesis.
- The deterministic-replay "so" is fixed: determinism is attributed to purity of
  `apply` and the monadic left-fold law, with row-retention correctly demoted to
  a separate audit property.

Conservation (§Why It Is Right) is now genuinely self-evident: one writer of
`psBal`, two legs from one quantity summing to `mempty`, induction from
`emptyLedger`, sealed constructor closing the reach. A single pass lands it.

What still costs a pass is one quarter of the central answer.

## Residue that blocks obviousness

### The empty fourth cell is asserted, not ruled out (§The Answer, lines 51-72; §Why Three, "The fourth cell is empty…", lines 111-121)

The whole answer is a 2×2: two key choices (unit vs. (holder,unit)) crossed with
two disciplines (externally-sourced versioned authority vs. internal overwrite).
Three cells are shown to be occupied for one concrete reason each — those read
cleanly. The fourth cell — **(holder, unit) under a versioned external
authority** — is declared empty, and that emptiness is one of the four facts the
reader came to verify.

The argument given is: a per-position fact set once and never rewritten (entry
NAV) is "a write-once field … folded from the event that opens the position," and
"needs no versioned external authority, because that authority exists only for
externally-sourced unit terms." The last clause restates the conclusion. The
load-bearing premise is *all per-position facts are internal*, and a
finance-literate engineer immediately has a counterexample on the page's own
terms: a custodian holding statement, a prime-broker position report, a fund
administrator's per-investor NAV — these are external, versioned (restated), and
per-(holder, unit). On a first read they look exactly like an occupied fourth
cell, and the one-sentence dismissal does not say why they are not.

The real reason exists — positions are *sourced internally* from the ledger's own
move events, so any external per-position figure is a boundary **reconciliation
input**, not a sourced authority — but it is nowhere in the document. (It lives in
the project's scope note, not in this self-contained proof.) Until that sentence
is on the page, the reader who pictures a custodian statement has to take the
empty cell on faith.

**Fix (one or two sentences in the fourth-cell paragraph):** state that the
ledger sources every position from its own internal move events, so a
per-position fact is internal by construction; therefore any external,
per-(holder, unit) figure is something the ledger reconciles against at its
boundary, not an authority it stores — which is precisely what leaves the
externally-sourced × (holder, unit) cell empty.

## Not blocking, noted

- The companion `no fourth home` paragraph (lines 74-79) leans on the broad
  definition "a unit is anything that can be held," and the managed-account/
  mandate hard case (lines 117-121) carries it concretely. That now reads as
  derived rather than asserted — acceptable.
- `register` is named ("Registration writes a unit's terms and status together")
  but not shown in the `.tex`, while the conservation proof asserts "`applyMove`
  is the only function that touches `psBal`." The prose states register writes
  terms and status (not positions), which is enough to grant the claim; no
  backtrack. Minor.
