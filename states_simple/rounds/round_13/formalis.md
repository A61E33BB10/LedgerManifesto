# FORMALIS — States.tex, Round 13

**Verdict: OBVIOUS**

My lens: conservation and deterministic replay must be *visible* consequences of the
structure; no load-bearing fact of `SOLUTION_ESSENCE.md` may be dropped, weakened, hidden,
or contradicted; every pointer a first-time reader follows must land on the justification it
cites. VETO on any regression. I read `States.tex` end to end, cross-checked every listing
against `States.hs`, resolved every `\S\ref` against `States.aux`, and re-verified the
KEEP/DROP contract.

## The Round 12 blocker is fixed

Round 12's single residue was two `\S\ref{sec:right}` pointers that resolved to §5 "Why It
Is Right," which did not contain the cited justifications (they lived in an unlabeled §4).
Confirmed resolved:

- `\label{sec:construction}` now sits on §4 "The Construction" (tex 165); `States.aux`
  resolves `sec:construction`={4}, `sec:answer`={2}, `sec:why`={3}, `sec:right`={5}.
- Line 105 ("a third home … not a third map") now points to `\S\ref{sec:construction}` (§4),
  where "The three homes, two maps" (253–273) is the cited content. Correct.
- The former line-217 pointer became a bare "(below)" on the `register`-refusal claim
  (222); `register`'s listing is at 286, genuinely below. Correct.
- No `\ref{sec:right}` consumer remains; the label is referenced only by its own section.
- Every surviving `\S\ref{sec:why}` (65, 67, 101, 103, 282, 384) lands in §3 "Why Three,"
  which carries the matching content (mandate reification 154–161; empty fourth cell
  144–152; terms≠status 128–142; amendment out of scope 138–142; one-version 142). All true
  locatives.
- Clean LaTeX build: no warnings, no undefined references, no rerun pending.

## The mathematics is sound — everything is visible

- **Listings faithful to source.** `Qty`/`negQty` (tex 178–182 ↔ hs 93–118); keys (192–193
  ↔ 134–135); `Price`/`Lifecycle`/`UnitStatus`/`defaultStatus` (208–212 ↔ 249–272);
  `TermsVersion`/`ProductTerms`/`currentTerms`/`appendVersion` (225–230 ↔ 329–353);
  `PositionState`/`zeroP` (246–250 ↔ 379–391); `Ledger`/`emptyLedger` (268–272 ↔ 436–451);
  `register`/`settle` (286–296 ↔ 465–488); `applyMove`/`netDeltas`/`writeNet` (308–319 ↔
  519–554); `position` (341–342 ↔ 504–505); `netBal` (363–364 ↔ 597–598);
  `Event`/`apply`/`replay` (371–377 ↔ 696–713). `TermsVersion`/`Move` shown positionally
  where source uses record syntax — a licensed structural simplification, not a misstatement.
- **Conservation visibly forced.** Base (`emptyLedger` sum zero, 264–265); step (`applyMove`
  sole `psBal` writer, two cancelling legs `negQty q <> q = mempty`; `register`/`settle`
  touch only `ledgerUnit`, 350–360); closure (sealed constructor + withheld selectors, no
  other door). Edge cases `q = mempty` and `from = to` net `mempty` and write no row
  (321–328); self-move's two legs collapse on one key via `insertWith (<>)` — verified.
- **Determinism visibly forced.** `apply` total over all three `Event` constructors and pure;
  `replay = foldM`; checkpoint soundness by the genuine monadic left-fold split law
  (379–386). Row retention attributed to audit, not determinism (386).
- **All six KEEP items present.** Three homes + structural-empty fourth (2×2, 80–105); no
  wallet-keyed economic sector with mandate reification (62–67, 154–161); never-held vs
  held-and-flat (330–338); three forcing reasons by concrete example (115–152); conservation
  + replay (350–386); mandate-as-unit (154–161).
- **No false statement, no DROP-list leakage.** `psHwm` correctly carries no zero-sum
  invariant and no holder aggregate (240–243, 360). No Pareto frontier, rejected designs,
  condition/risk catalogues, round counts, or "considered and rejected" reasoning.

## Residue

None. The Round 12 cross-reference defect is repaired with no regression elsewhere; no
load-bearing fact is dropped, weakened, or contradicted; conservation and deterministic
replay follow visibly from the structure.

**OBVIOUS.**

— FORMALIS Committee
