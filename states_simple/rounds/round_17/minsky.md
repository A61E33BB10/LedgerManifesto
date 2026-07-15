# minsky — Round 17 — States.tex / States.hs

## Verdict: OBVIOUS

## Bar

Does each illegal state the design relies on excluding become *visibly* impossible in the
shape a first-time reader reads — not on faith? And, since the task hands the reader *both*
artifacts, does the account cohere across them, so the reader sees one design rather than
backtracking between two contradicting statements of it?

## My standing residue (Round 16) is closed

My R16 NOT-YET was a single, one-sided divergence: the R16 `.tex` had been rewritten to
*defer* the high-water mark's algebra to the out-of-scope valuation writer ("not by this
file"), while the unchanged `.hs` (then hs:579–591) still *committed* to it — "that is
right ... combines with the same monoid ... adding high-water marks is legal ... a separate
newtype would only decorate, and we do not add it." Two artifacts, opposite accounts of one
load-bearing design decision.

The current `States.hs` (mtime 13:37) has been brought into line with the deferral. I
verified the committing language is entirely gone — grep for `combines with the same monoid`
/ `that is right` / `would only decorate` / `we do not add` / `adding high-water` returns
nothing. The replacement comment (hs:579–593) now reads with the `.tex`: "this file leans on
*none* of `Qty`'s group structure for it. What a high-water mark measures — and so whether
two of them compose, and how — is fixed by its writer, a valuation event out of scope for
this file ... For `psHwm` this file makes no aggregate claim at all." The `.tex` side
(tex:221–230) defers identically: "typed `Qty` to match its source, written by a valuation
event out of scope here, never folded over holders, and so zero throughout this file."

The R16 secondary worry — the two `.hs` comments contradicting *each other*, ratchet/max at
hs:374 vs add/`+` at the old hs:581 — is also gone: hs:374 still says "ratchets up," and the
old additive line no longer makes any combination claim. Both files now state ratchet
semantics and defer the algebra; they cohere. The cross-reference the `.tex` invites
(tex:157–159, "the listings reproduce its declarations") no longer lands the reader on a
contradiction.

## What I re-confirmed type-carried and visible (unchanged, still right)

- Price-on-`Active`: `data Lifecycle = Listed | Active Price` (tex:197 / hs:258).
  "active-but-unpriced" and "listed-but-priced" are unspellable; `settlementPrice` is
  exhaustive over exactly the two reachable cases (hs:293–295), no swallowing wildcard.
- Non-empty terms with the constructor withheld: `newtype ProductTerms = ProductTerms
  (NonEmpty TermsVersion)` (tex:214 / hs:333), `ProductTerms` exported bare (hs:47).
  "registered but versionless" unrepresentable; `currentTerms = NE.last` is total.
- Co-present pair `Map UnitId (ProductTerms, UnitStatus)` (tex:255 / hs:437). "in terms but
  not status" excluded by the shape of the entry, not by a policed invariant — visibly so.
- Dual key `(WalletId, UnitId)` for position (tex:256 / hs:438): two holders of one unit are
  two keys, derived at tex:110–114.
- Single-`Qty` `Move`; the two cancelling legs derived inside `applyMove` from one quantity
  (hs:512–554). Conservation is disclosed *honestly* as a writer invariant with a bounded,
  readable argument (only door writes `psBal`; legs sum to `mempty`; sealed constructor leaves
  no other door), never dressed as a shape (tex:336–345 / hs:565–593).
- The seal: `Ledger` exported bare, `ledgerUnit`/`ledgerPS` withheld (hs:61–67) — record
  update through a selector cannot install a non-conserving map without naming the
  constructor.
- `apply` exhaustive over the three `Event` constructors (hs:704–707), no wildcard.
- never-held (`Nothing`) vs held-and-flat (`Just`, `psBal = 0`) kept apart by row retention,
  and a zero-net move (zero quantity or self-move) writes no phantom row (hs:550–554).

All of this the reader sees in the shape or in a short argument over the reachable ledgers
that the prose marks plainly as the second kind (tex:332–350 / hs:806–822). No invariant is
sold as a shape; no shape is propped up by a writer.

## Why the two standing flags are not residue under *my* bar (held consistently R11–R16)

- **`psHwm :: Qty` lets `foldMap psHwm` typecheck (jane-street-cto / milewski).** A
  should-strengthen, not residue under my bar. The design does *not* rely on excluding a
  cross-holder HWM sum: both files explicitly make "no aggregate claim at all" about `psHwm`,
  and `netBal` folds `psBal` alone (hs:599–600 / tex:348–349). An invariant the design does
  not rely on is not an illegal state the design must render impossible. Nothing is taken on
  faith — the reader is told plainly that the algebra is the out-of-scope writer's. Giving it
  a `Price`-style group-free newtype would be a genuine strengthening, but its absence dresses
  no false shape. Returned to source, not gating.
- **Multi-instrument reification (count "three homes, no fourth").** Explicitly conditional:
  demonstrated for one mandate (n=1), "assumed here, not proved" for a relationship spanning
  several instruments (tex:147–149 / hs:419–434). This is a basis-completeness claim, not an
  illegal-state-representability one, and it is marked conditional rather than asserted. Not
  my residue.

## Non-blocking (does not gate)

hs:580 ("leans on *none* of `Qty`'s group structure for it") sits near `zeroP =
PositionState mempty mempty` (hs:391), whose second `mempty` *is* `Qty`'s monoid identity
supplying `psHwm`'s initial value. Under the natural reading — "no *invariant or aggregate*
leans on the group structure" — the sentence survives, since `zeroP` needs only some zero and
nothing depends on it being the identity. A clarity nit for STYLUS/karpathy, not an
illegal-state-on-faith defect; it makes no illegal state representable and dresses no
invariant as a shape. The `.tex` no longer carries this phrasing at all (tex:226–230 states
only "typed `Qty` to match its source ... never folded over holders"), so the two artifacts
do not diverge on it.

## Residue

None.
