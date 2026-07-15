# minsky — Round 18 — States.tex / States.hs

## Verdict: OBVIOUS

## Bar

Does each illegal state the design relies on excluding become *visibly* impossible in the
shape a first-time reader reads — not on faith? And, since the task hands the reader *both*
artifacts, does the account cohere across them, so the reader sees one design, not two
contradicting statements of it?

## What changed since Round 17

`States.hs` is byte-for-byte the file Round 17 cleared (mtime 13:37, unchanged).
`States.tex` was edited after the Round 17 reviews (mtime 13:56). I re-read both in full and
re-checked the one seam an edit could have reopened — the high-water-mark deferral, which was
my standing R16 NOT-YET. It did not reopen. Both files still defer the HWM algebra to the
out-of-scope valuation writer and make *no* aggregate claim:

- tex:228–232 — "leans on none of `Qty`'s group structure for it ... makes no aggregate claim
  over holders for it ... never folded over holders, and so zero throughout this file."
- hs:580–591 — "leans on *none* of `Qty`'s group structure for it ... For `psHwm` this file
  makes no aggregate claim at all."

No committing language (`combines with the same monoid`, `that is right`, `would only
decorate`, `we do not add`) survives in either file. The two artifacts state one design.

## Type-carried and visible — the illegal state cannot be written

These the reader sees in the *shape*, not on a writer's word:

- **Price present exactly when active.** `data Lifecycle = Listed | Active Price`
  (tex:198 / hs:258). "active-but-unpriced" and "listed-but-priced" are unspellable;
  `settlementPrice` (hs:293–295) is exhaustive over exactly the two reachable constructors,
  no swallowing wildcard.
- **Terms never versionless.** `newtype ProductTerms = ProductTerms (NonEmpty TermsVersion)`
  with the constructor withheld (tex:215 / hs:333, exported bare hs:47). "registered but
  versionless" is unrepresentable; `currentTerms = NE.last` is total — no `Maybe`.
- **Terms/status co-present or both absent.** One entry is the pair
  `Map UnitId (ProductTerms, UnitStatus)` (tex:259 / hs:437). "in terms but not status" is
  excluded by the shape of the entry, not by a policed invariant — and the prose says so
  (tex:99–101, tex:244–256 / hs:407–418).
- **Two holders of one unit are two keys.** `Map (WalletId, UnitId) PositionState`
  (tex:260 / hs:438), derived from the buyer/seller divergence (tex:110–114 / hs:142–144).
- **A move is two cancelling legs from one quantity.** `Move` carries a single `Qty`
  (tex:297 / hs:512); the legs `negQty q` / `q` are built inside `applyMove` and net to
  `mempty` per wallet (hs:533–554). An unbalanced move is "a sentence the language will not
  let us write" (hs:208).
- **Exhaustive dispatch.** `apply` covers all three `Event` constructors (hs:704–707), no
  wildcard — future event classes fail to compile rather than fall through.

## Disclosed as writer/seal invariants — argued, not dressed as shape

The design is candid that three properties are *not* type-carried, and gives a bounded
argument for each over the reachable ledgers (tex:336–350 / hs:806–822):

- **Conservation.** `applyMove` is the only door to `psBal`, and it writes two inverse legs;
  `register`/`settle` never touch `psBal`; the sealed constructor + withheld selectors leave
  no other door; from `emptyLedger` (sum zero) every reachable ledger conserves
  (tex:340–349 / hs:565–593).
- **Append-only terms history.** `register` refuses a present unit; the withheld constructor
  admits no hand-built short history (tex:204–211 / hs:343–350, 465–470).
- **Unregistered-unit gate.** `applyMove` and `settle` refuse a unit the stream never
  introduced (tex:312–318 / hs:556–563) — this is the writer-enforced referential link
  "a position exists only for a registered unit" (hs:507–510), disclosed, not sold as shape.

The reader is never asked to take any of these as a shape; each is marked plainly as the
second kind (hs:806–822 names exactly which invariants are shape and which are writer+seal).
The seal itself is real and visible: `Ledger`, `ledgerUnit`, `ledgerPS` exported without
constructor or selectors (hs:61–67) — record update through a selector cannot install a
non-conserving map without naming the hidden constructor (tex:250–254).

## The two standing flags are not residue under my bar (held R11–R18)

- **`psHwm :: Qty` lets `foldMap psHwm` typecheck (jane-street-cto / milewski).** A
  should-strengthen, not residue: the design relies on excluding no cross-holder HWM sum.
  Both files make "no aggregate claim at all" and `netBal` folds `psBal` alone
  (hs:599–600 / tex:352–353). An invariant the design does not rely on is not an illegal
  state it must render impossible; nothing is taken on faith. A `Price`-style group-free
  newtype would genuinely strengthen, but its absence dresses no false shape.
- **Multi-instrument reification ("three homes, no fourth").** Explicitly conditional:
  shown for one mandate (n=1), "assumed here, not proved" for a multi-instrument relationship
  (tex:147–150 / hs:419–434). A basis-completeness claim, marked conditional, not an
  illegal-state-representability claim. Not my residue.

## Non-blocking

Cosmetic presentational gaps between the listings and the source — `Move`/`TermsVersion`
shown positional in `.tex` (tex:214, 297) but record-syntax in `.hs` (hs:329, 512), and
`settlementPrice`/`productTerms`/`unitStatus`/`netOf`/`transfer` present only in `.hs`.
These are the same types either way and the `.tex` declares the listings a slice with
elisions (tex:157–159, tex:89–94); no meaning diverges, so a reader does not backtrack on a
contradiction. Clarity nits for STYLUS, not illegal-state defects.

## Residue

None.
