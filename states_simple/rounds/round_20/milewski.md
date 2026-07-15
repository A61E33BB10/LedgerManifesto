# Round 20 — milewski review of `states_simple/States.tex`

**Verdict: OBVIOUS.**

## Scope of the R20 delta
`.tex` mtime 14:15 (today), `.hs` mtime 13:37 — unchanged since R17. The R20 change is
`.tex` prose only, per `iteration_log.md`:
1. **psHwm footnote deleted, folded to one clause** (chris-lattner: the six-line footnote
   argued psHwm's type theory off-topic for "where state lives"). The `\footnote{...}` is
   gone; its load-bearing content is now one clause on the psHwm sentence (`.tex` 238-239):
   "...it keeps the full `Qty` type rather than a stripped newtype like `Price` because its
   operation is not settled here — no aggregate over holders is claimed."
2. SSOT + "exactly two failure modes" rendering and the §Answer scope-by-forward-reference
   dedup (subject-matter/dirac-owned; outside my lens).

## Verified this round
- **Footnote removed cleanly.** `grep footnote` shows only `\footnotesize` (listings style,
  table) — no dangling `\footnote`, no broken ref.
- **The compressed psHwm clause is correct and is NOT a regression.** It preserves the Price
  reconciliation (explains WHY psHwm is `Qty` and not a stripped Price-style newtype:
  operation unsettled) and keeps the no-aggregate disclosure. It makes **no false claim** —
  it does not assert HWMs add (the R16 incoherence), nor write a bare "typed Qty to match
  source" with no reconciliation (the R17 defect). Consistent with the `.hs` deferral
  (579-593: "leans on *none* of `Qty`'s group structure", "makes no aggregate claim at all").
- **`.hs` internally consistent — iteration_log's standing inconsistency claim is STALE.**
  The log's final note ("ratchet=max at 374 vs add=+ at 581 persists, milewski's") references
  an OLDER `.hs`. Re-confirmed (as in R18): `.hs` line 374 "ratchets up" is the *writer's*
  discipline (consistent with deferral, not a `+`); the 579-593 paragraph is pure deferral
  with NO additivity rationale and NO "add=+ at 581" (line 581 reads "measures — and so
  whether two of them compose... is fixed by its writer"). No `.hs` edit owed.
- **All `.tex` listings type-correct and match `.hs`**: Qty group, Price non-group,
  Lifecycle = Listed | Active Price, NonEmpty terms + appendVersion, sealed two-map Ledger
  (terms+status pair), net-first applyMove (per-wallet net, skip `mempty`), foldM replay.
- **LaTeX clean**: pdflatex ×2 → 3 pages, 0 overfull/underfull, 0 undefined refs.

## Hutton-bar pass (fresh)
Each step obvious from the last; every abstraction named after its referent and earned at
introduction (Qty monoid/group only where a transfer's legs must cancel; Price denied the
group because prices are never summed; NonEmpty because "registered but versionless" must be
unspellable; foldM only once the failing left-fold is on the page). Destination derived
bottom-up. Conservation honestly a writer-invariant (store can hold a non-conserving map; the
seal makes the reach exhaustive). Replay determinism = purity of `apply` + the monadic
left-fold law. No-fourth-home stated bounded to single-(holder,unit) reification. The `.tex`
is solution-only by design (omits the Balances/transfer teaching scaffolding). A competent
engineer new to the problem is not misled at any step.

## Non-blocking items (carried, NOT residue)
1. **STANDING FLAG 2 — psHwm non-group newtype.** Endorsed in principle (a Price-style type
   with no Semigroup/Monoid would make the meaningless `foldMap psHwm` fail to typecheck),
   but returned to source: neither artifact makes a false claim (both disclaim any aggregate;
   `netBal` folds `psBal` alone), and the fix must touch the `.hs` declaration AND the `.tex`
   listing (303-…, `psHwm :: Qty` at 245) together — an owner/STYLUS-coordinated change, not a
   `.hs`-only edit. Do not re-flip absent new information.
2. **Positional-vs-record `.tex` listings** (17 rounds): `TermsVersion String` (:224) and
   `Move UnitId WalletId WalletId Qty` (:303) where `.hs` uses records. The `.tex` is
   internally consistent (never uses dropped accessors); FORMALIS R13 ruled it a licensed
   simplification. STYLUS-owned.
3. **Multi-instrument reification proof** — subject-matter standing flag; the count is bounded
   to single-row relationships and says so. Outside my lens.

Empty residue. No GHC in env; both files read in full, `.tex` built.
