# minsky — Round 10 — States.tex / States.hs

## Verdict: OBVIOUS

## Lens

Do the types make the illegal states *visibly* impossible — the reader sees it,
not takes it on faith?

## Both of my prior residues are closed by the paths I sanctioned

- **R8 R1 (summary overclaim).** The old conclusion told the reader every fact was
  "visible in the shape," withdrawing the body's candor about writer invariants.
  Fixed: States.hs:798-814 now ends the file by explicitly partitioning the two
  kinds of fact — those *carried by shape* (priced-iff-active, `NonEmpty` terms,
  terms/status co-presence, (wallet,unit) keying, two-legs-from-one-quantity) and
  those held only by *a short soundness argument over reachable ledgers*
  (conservation, append-only history, the unregistered-unit gate) — "so the reader
  is never asked to take a writer discipline on faith as though it were a shape."
  That is exactly the register-separation I demanded.

- **R8 R2 / R9 R1 (zero-move and self-move conjuring a phantom held-and-flat row).**
  Fixed structurally, not patched. `applyMove` now computes the *per-wallet net
  delta* first (`netDeltas`, States.hs:534-536) and only then writes, with
  `writeNet` skipping any wallet whose net is `mempty` (line 552). I traced both
  twins: `Move u w w q` nets `q <> negQty q = mempty` on the single wallet, and a
  `Qty 0` move nets `mempty` on both — neither writes a row. The demo confirms it
  (States.hs:636-638 self-move → `Nothing`; 626-630 zero-move → `Nothing,Nothing`).
  The asymmetry I flagged in R9 — zero suppressed, self-move not — is gone: one
  rule (net, then write) now covers both, and "held = named in a move that nets
  nonzero on it" is consistent with the code.

- **R9 R2 (no-fourth-home conditional on an n=1 reification).** My R9 actionable was
  disjunctive: prove the reification universally, *or* state "no fourth home" as
  conditional at the headline, not only in the body. The authors took the second
  branch. The assumption is now disclosed at the head of the reasoning
  (States.tex:62-64, before the 2×2) and in the closing summary
  (States.hs:778-781). The reader meets the conditional before the conclusion; the
  epistemic status is visible, not buried. The residue I named is closed by the
  route I authorized — honoring it requires I not move the goalposts.

## Fresh pass: no remaining representable illegal state, no disguised faith-claim

Shape-enforced and visible to a first-time reader without running anything:
`Active Price` makes "active-with-no-price" and "listed-but-priced" unspellable;
`ProductTerms (NonEmpty TermsVersion)` with unexported constructor makes
"registered but versionless" unspellable; one `Map UnitId (ProductTerms,
UnitStatus)` makes "in terms but not status" unspellable; the `(WalletId, UnitId)`
key cannot collapse two holders; `Move … Qty` admits one quantity, both legs
derived from it.

Seal-and-writer facts are checkable, not faith: the export list (States.hs:20-77)
confirms `Ledger` is exported as a type only with `ledgerUnit`/`ledgerPS`
unexported, so "the only door that writes `psBal` writes it balanced, and the
constructor leaves no other door" is a finite audit of one file. `register`
refuses an already-present unit and is the sole terms writer; no exported function
writes amended terms back into a `Ledger`, so history cannot be shortened.

Exhaustiveness/totality: `settlementPrice` and `apply` match every constructor
with no swallowing wildcard (future stages will fail to compile, as they should);
all writers are total in `Maybe`; `currentTerms` is total by `NonEmpty`. Clean.

## Out of my lens (carried by others, not blocking from mine)

The Round-10 NOT-YETs I read concern prose ordering and redundancy
(chris-lattner, jane-street-cto items 2-3) and one quant-prose error — psHwm's
"total peak exposure," which is sum-of-peaks, not peak-of-sum (jane-street-cto
item 1). The psHwm point is a false *justification sentence*, not a type or
illegal-state matter: the `Qty` choice and the "non-conserved" claim are both
correct (no cancelling writer), so nothing in my lens turns on it. These are real,
but they are clarity/quant residue for their owners, not type-visibility residue
for mine.

## Why OBVIOUS

Every fact the document presents as carried by the types *is* carried by the
types, and a competent reader new to the problem sees each one in the shape.
Every fact not carried by the types is now disclosed as such — consistently,
including in the summary and at the headline — and each rests on a bounded,
auditable soundness argument, not on faith. The two representable-input gaps I
caught in prior rounds are closed by construction. From my lens, the solution is
obviously right.
