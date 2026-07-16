# Round 18 — jane-street-cto on States.tex

Verdict: **NOT-YET**

Bar applied: a competent engineer, new to this problem, reading the tex six months
on, calls it obvious and writes no commentary; no overclaim.

## What is right (and should not be touched)

The design is correct and, unusually, free of overclaim. I checked the load-bearing
claims against the listings and against `States.hs`:

- **Conservation** is argued honestly as a *writer* invariant, not a store-type
  property (§Why It Is Right, lines 340-349): `applyMove` is the sole `psBal` writer,
  it writes two cancelling legs from one quantity (`negQty q <> q = mempty`),
  `register`/`settle` never touch `psBal`, and the sealed constructor + withheld field
  selectors close every other door. The argument is exactly as strong as it claims —
  no more.
- **`applyMove`/`netDeltas`** is correct on the cases that matter: distinct wallets net
  `-q`/`+q`; a self-move and a zero-quantity move both net `mempty` and write no row
  (`writeNet` skips `d == mempty`). The never-held (`Nothing`) vs held-and-flat
  (`Just`, `psBal = 0`) distinction is preserved by retaining closed rows. This is the
  subtle part and it is right.
- **Replay** determinism rests on `apply` being pure and total (returns `Nothing`, no
  bottom); checkpoint-independence cites the monadic left-fold law correctly
  (`foldM` over a concatenation splits at any cut, for any monad). Types check
  (`flip apply :: Ledger -> Event -> Maybe Ledger`).
- **Illegal-states-unrepresentable** claims are all genuinely enforced: priced-iff-active
  (price rides `Active`), never-versionless terms (`NonEmpty` + unexported constructor),
  terms/status co-presence (pair shape, not policed invariant).
- **No overclaim.** The central headline result — "three homes, no fourth" — is
  explicitly disclosed as *conditional* on a reification proved only for the single
  mandate (n=1) and *assumed* for the multi-instrument case (lines 56-58, 147-150,
  133-140). Disclosing rather than asserting the one unproven premise is exactly right
  and is what keeps the document honest.

Everything above clears the bar. The residue below is clarity, not correctness, and it
is narrow — but it sits on the central data structure, which is why it blocks "obvious."

## Residue (located, actionable)

### 1. The `psHwm` paragraph (§The Construction, lines 222-234) — primary

This is the one paragraph a new reader stalls on, and it is on `PositionState`, the
type that carries conservation.

`psHwm` is a `Qty` field that, in this file, **no writer ever sets** — it is `mempty`
throughout, present only to "witness that the Position home can carry a non-conserved
fact." That is a legitimate, disclosed design choice (it mirrors `appendVersion`, the
other out-of-scope writer). But the paragraph that justifies it is the document's least
obvious passage. It asks the reader to hold three *different* relationships to `Qty`'s
group structure at once:

- `psBal` uses the group (it sums, it conserves);
- `Price` deliberately strips the group ("settled never to sum");
- `psHwm` keeps the `Qty` type but uses none of the group "because its operation is not
  settled here."

A reader debugging a position at 3am sees `psHwm = 0` everywhere, greps for a writer,
finds none, and must reconstruct from this paragraph that the field is an intentional
stub for an out-of-scope valuation event. The justification is present, but it is buried
mid-paragraph and worded defensively.

Actionable fix: the companion `States.hs` (lines 384-388, 579-593) already states this
cleanly — "the high-water mark is set by a valuation event, which is out of scope for
this file -- here it stays at its zero, and its role is purely to show a non-conserved
field riding alongside the conserved balance." Port that framing:
- Flag `psHwm` at the listing itself as a stub written by the out-of-scope valuation
  event (the way `appendVersion`'s out-of-scope status is flagged in prose), so the
  reader learns the field is inert *before* parsing the justification.
- Reduce the `Price`-vs-`psHwm` group-structure contrast to one sentence: `psBal` sums;
  `Price` and `psHwm` are never summed in this file — `Price` because a price is settled
  never to sum, `psHwm` because its writer (and so its algebra) is out of scope.

### 2. Inline comment on `psBal` (line 238) — minor

`psBal :: Qty -- held quantity: primary, conserved, sums to zero`

At the field, "sums to zero" reads as "this value is zero," when the invariant is that
the sum of `psBal` *over all holders of a unit* is zero — an individual `psBal` is
generally nonzero (the buyer's is `+1000`). §Conservation and `netBal` disambiguate, but
the wrong mental model can form at the field before the reader reaches them.

Actionable fix: reword to "per-unit sum over holders is zero," or drop "sums to zero"
from the inline comment and let §Conservation carry it (the paired `psHwm` comment
"not conserved" already supplies the contrast).

## Summary

The solution is correct and does not overclaim. It misses "obvious" on one count: the
`psHwm` paragraph (lines 222-234), on the conservation-carrying type, is the document's
hardest passage and makes an inert field look live without resolving that until late and
defensively. Fix that paragraph (the cleaner framing already exists in `States.hs`) and
the minor `psBal` comment, and this is OBVIOUS.
