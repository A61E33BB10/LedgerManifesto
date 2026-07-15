# Self-Consistency Repair, Reference-Code Alignment, and Clarity Pass — Outcome

Target: `ledger_v13_0.tex` + `reference/Ledger.hs`. Four committee passes (rename+unify →
coherence+properties → clarity → convergence certification), each verified independently.

## Result: CONVERGED (with one standing caveat: GHC/property run pending a toolchain)

Final independent verification — build `latexmk` exit 0, **168 pages** (< 200 hard cap), 0 undefined
refs; forbidden-pattern suite all zero: `BasisPoint` 0/0, mis-sensed "basis point" 0, version identity
0, diff-voice 0, `carry` combinator 0/0, persona/process residue 0/0; PDF metadata version-free; the
P24 verbatim exhibit diffs clean against the reference; no stray artifacts in the tree.

## What was done

**D1 rename (BasisPoint → BasisId).** THORP-ratified name (veto census: `BasisMark`/`StateMark`/
`CAMark` rejected on "mark"=MtM; `BasisRef` on mutable-cell connotation). Total and sense-aware: the
floor-sense `basis-point-notional` (1/10,000) preserved; the CA-state coinage renamed; label
`def:basis-id`; combinator `carry`→`transport`; glosses for `stamp`/`Boundary`; "⊥_u"→"the origin of u".

**F1–F3 single declaration.** FORMALIS ruled the default: §4 declares the final `UnitStatus`/
`StatusWrite` once (field order `usLifecycle, usBasis, usLastSettle, usSupersededBy`; per-unit
`defaultStatus :: UnitId -> UnitStatus`; four absolute-replacement `applyStatus` equations);
§state-basis reduced to pure semantics, all "gains/new/refined/propagates" diff-voice struck. The
reference carries the final types + `txBoundary` + `ledgerBounds` committed-boundary cache + the
origin/tip/invariance welds + new `LedgerError`s. C5 preserved (origin weld makes it a construction,
not a convention); P6 preserved (absolute writes).

**F4–F9.** C13 native everywhere (register, hub, glossary); the invariant hub states the basis
invariants (P24 + C13 rows); P24 authored in Appendix B in the exact catalogue shape + implemented as
a reference oracle (`p24`/`effTip`), with every P-range enumeration updated; the fibre claim checked by
`fibreOK`; every listing classified verbatim/illustrative and every verbatim listing aligned to the
reference (the §4 `Ledger` 4th-field gap and the `Move` `Qty`/`PosQty` divergence both closed); counts
re-verified.

**D2/D3 clarity.** Preface cut (fully duplicative); Key Concepts folded into the Glossary (7 terms
rehomed); FAQ/Conclusion compressed to unique residue; de-pedantry sweep (the document was already very
clean at the sentence level); glossary basis entries added (`BasisId`, basis stamp, tip weld,
invariance weld; `usBasis` named). −3 pages, no fact lost (NOETHER-certified).

**Convergence certification (Pass 4, read-only).** FORMALIS, NOETHER, THORP, MATTHIAS, KARPATHY PASS;
CARTAN + NAZAROV surfaced two residuals, both fixed: stale section-citation comments in `Ledger.hs`
(off-by-one from the §8 state-basis insertion — renumbered against the current ToC) and a reintroduced
"FORMALIS-flagged" persona clause in the paired P24 comment (removed from both files, verbatim match
preserved). Post-fix mechanical re-verification is clean across the whole suite.

## Standing items for the owner (unchanged by this work)
1. **GHC PENDING-TOOLCHAIN.** The reference is type-checked by inspection at every pass; the `-Wall`
   build and the P1–P24 property run must be executed where a Haskell toolchain exists. Never reported
   as passed.
2. **Design decisions (escalated, not improvised).** The invariance weld fails closed on fractional
   entitlements (the cash-in-lieu decomposition is not implemented at the reference door); `OpSpec` and
   the full `Declaration` remain specification-level (a `Pending`/`Terminal` name collision with Part J
   would need a THORP-ratified rename to enter the module). These are protected-design questions, not
   consistency defects.
