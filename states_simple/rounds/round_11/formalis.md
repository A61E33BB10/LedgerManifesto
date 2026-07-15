# FORMALIS — States.tex, Round 11

**Verdict: OBVIOUS**

My lens: conservation and deterministic replay must be *visible* consequences of the
structure; no load-bearing fact of `SOLUTION_ESSENCE.md` may be dropped, weakened, hidden,
or contradicted; VETO on any regression. I read the current `States.tex` end to end, checked
it against the essence, cross-checked every listing against `States.hs`, and verified that
the Round-10 pooled residue is resolved without introducing new defects.

## The Round-11 rewrite is a net improvement, not a regression

Round 10 was OBVIOUS but carried a 13-item pool, all converging on one defect: the
placement axis was a "synchronous past-dated boundary read" test that (a) contradicted the
document's own replay claims, (b) rested on an out-of-scope entitlement mechanism never
exercised in-file, and (c) left the empty fourth cell reading "currently empty" rather than
"structurally empty." That framing is **entirely removed** (grep confirms no
`boundary`/`past-dated`/`synchronous` survives) and replaced by a clean authorship axis.

The placement is now a 2×2 over two checkable questions — *holder-dependent or unit-only?*
and *externally authored or ledger-authored?* (lines 55–74). Three cells occupied
(Status, Terms, Position); the fourth is empty by a now-**structural** argument: a position
exists only because the ledger's own events created it, so every per-(holder,unit) fact is
ledger-authored; an external position report is a reconciliation input, not adopted state
(lines 86–91, 140–148). This is exactly the structural derivation dirac/chris-lattner asked
for, and it sits squarely inside scope.

## Listings faithful to the source

Verified declaration-by-declaration against `States.hs`: `applyMove` /`netDeltas`/`writeNet`
(tex 301–315 ↔ hs 527–563, same two-`insertWith` net, same `d == mempty` short-circuit, same
`findWithDefault zeroP` first touch); `register` (tex 281–285 ↔ hs 473–478, inserts
`(ProductTerms (tv :| []), defaultStatus)`, refuses present unit); `settle` (tex 286–291 ↔ hs
492–496, `Map.adjust` over the pair's `snd`); `position` (tex 336–338 ↔ hs 512–513);
`netBal` (tex 357–359 ↔ hs 605–606); `replay = foldM (flip apply)` (tex 370–371 ↔ hs 721);
`appendVersion`/`currentTerms` (tex 224–226 ↔ hs 343–358). Elisions are derive-clauses, as
licensed.

## Conservation is visibly forced

A clean induction a first-time reader reconstructs unaided:
- **Base.** `emptyLedger` both maps empty → every per-unit holding sum is `mempty` (258).
- **Step.** `applyMove` is the *sole* writer of `psBal`, writing both legs from one quantity,
  net `negQty q <> q = mempty`; `register`/`settle` touch only `ledgerUnit` (345–354).
- **Closure.** The `Ledger` constructor is unexported — no other door (353).
Edge cases conserve by the same shape: `q = mempty` and `from = to` both net `mempty` per
wallet and write no row (321–323). The invariant is per-unit (legs share `u`; `netBal`
filters `u'==u`), matching the issued-unit-sums-to-zero model (mandate −1/+1, 152–154).

## Deterministic replay is visibly forced

`apply` is pure and total (every branch returns `Just`/`Nothing`); `replay` is `foldM`.
Same events → same ledger (374–375). Checkpoint soundness rests on the genuine monadic
left-fold split law in `Maybe` (377). The attribution is precise: determinism from
purity/totality, row retention to *audit* (the never-held / held-and-flat accessor
distinction), not to replay (381) — more correct than the essence's looser coupling, and
both underlying facts (rows retained; replay is a fold) are present.

## Every KEEP item present and unweakened

1. Three homes, no fourth — 2×2 with three occupied cells + structural empty fourth. ✓
2. No wallet-keyed economic sector — KYC/permissions/audit-cursor ruled out as identity;
   mandate reified as `(client, mandate-unit)`; "framework's stance" disclosed, not smuggled
   (156–158). ✓
3. never-held vs held-and-flat — `Nothing` (no key) vs `Just`/`psBal` zero, row retained
   because a close-out leg never deletes; both readings cited (entitlement vs lookback,
   325–333). ✓
4. Three forcing reasons by concrete example — buyer +1000/seller −1000 (111–116); one
   settle price/index level read identically (117–123); terms-vs-status grounded in
   authorship with the change-discipline fact fully preserved ("a single value cannot be at
   once an append-only record and an overwrite-in-place cell," 98–99, 132–138). ✓
5. Conservation + replay shown forced by the shape in a few lines. ✓
6. Mandate-as-unit grounds the absence of a fourth sector (−1/+1, two mandates = two rows,
   150–158). ✓

## Round-10 false statement fixed

The Round-10 overclaim "high-water marks add, summing over holders to total peak exposure"
(an upper bound asserted as equality) is **gone**. The current text says `psHwm` "carries no
zero-sum invariant … and no aggregate over holders is claimed for it" (236–238) — correct.

## No DROP-list leakage

No Pareto frontier, no rejected designs, no C/F catalogues, no round counts, no
"we considered X." The four-case study appears only as small examples grounding the forcing
reasons, as licensed.

## Veto check / scrutiny of the reframe

I pressed the one place the rewrite could have weakened: making authorship primary and
change-discipline derived ("how a correction is recorded follows from authorship; it is not
a separate axis," 93–96). The load-bearing fact KEEP-4 requires — two irreconcilable change
disciplines cannot share one home — survives verbatim in both §Answer (98–99) and §Why Three
(132–138), and is now *grown from* authorship rather than asserted. The phrase concerns
corrections specifically (terms append+keep vs status overwrite); position "accumulation" is
a third ledger-owned discipline but is not a correction case, so the sentence is not false in
context. The categorization of "last settlement price"/"benchmark level" as ledger-authored
Status (vs the authority-owned *identity* in Terms) matches the essence's own KEEP-1 table
and the document's authorship definition (the ledger writes the snapshot via its own event,
history in the log). No load-bearing fact dropped, weakened, hidden, or contradicted.

## Residue

None.

**OBVIOUS.**

— FORMALIS Committee
