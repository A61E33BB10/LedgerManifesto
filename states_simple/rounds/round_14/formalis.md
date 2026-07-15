# FORMALIS — States.tex, Round 14

**Verdict: OBVIOUS**

My lens: conservation and deterministic replay must be *visible* consequences of the
structure; no load-bearing fact of `SOLUTION_ESSENCE.md` may be dropped, weakened, hidden,
or contradicted; every pointer a first-time reader follows must land on the cited
justification; no false statement. VETO on any regression. I read `States.tex` end to end,
cross-checked every listing against `States.hs`, resolved every `\S\ref` against
`States.aux`, confirmed a clean LaTeX build, and re-verified the KEEP/DROP contract.

## No regression from Round 13

Round 13 closed OBVIOUS with no residue. Round 14 carries minor upward line shifts
(~2 lines) from edits in §§1–2, but every structural property Round 13 verified holds:

- **Cross-references resolve.** `States.aux`: `sec:answer`={2}, `sec:why`={3},
  `sec:construction`={4}, `sec:right`={5}. Line 104 ("a third home … not a third map")
  → §4 "The three homes, two maps" (251–263). Every `\S\ref{sec:why}` (65, 100, 103, 281,
  386) lands in §3 "Why Three" on its matching content. No `\ref{sec:right}` consumer
  remains. `States.log`: no warnings, no undefined refs, no rerun pending.

## Listings faithful to source

Verified declaration by declaration against `States.hs`: `Qty`/`negQty` (tex 176–181 ↔ hs
93–118); keys (190–192 ↔ 134–135); `Price`/`Lifecycle`/`UnitStatus{usLifecycle}`/
`defaultStatus` (206–211 ↔ 249–272); `TermsVersion`/`ProductTerms`/`currentTerms` (NE.last)/
`appendVersion` (`vs <> (tv :| [])`) (222–229 ↔ 329–353); `PositionState`/`zeroP` (244–248
↔ 379–391); `Ledger`/`emptyLedger` (266–270 ↔ 436–451); `register`/`settle`
(`Map.adjust (\(t,_) -> (t, UnitStatus (Active px)))`) (284–294 ↔ 466–488);
`applyMove`/`netDeltas`/`writeNet` (306–318 ↔ 521–554); `position` (339–340 ↔ 504–505);
`netBal` (361–362 ↔ 597–598); `Event`/`apply`/`replay` (`foldM (flip apply)`) (369–375 ↔
696–713). `Move`/`TermsVersion` rendered positionally where source uses record syntax — a
licensed structural simplification, not a misstatement.

## Mathematics sound — conservation and replay visible

- **Conservation forced.** `applyMove` is the sole `psBal` writer; `netDeltas` builds the
  per-wallet net map, whose values sum to `mempty` by construction — two distinct wallets
  net `negQty q` and `q`; a self-move collapses on one key via `insertWith (<>)` to
  `negQty q <> q = mempty`; `writeNet` drops any `mempty` row. `register`/`settle` touch
  only `ledgerUnit`. Base `emptyLedger` sum zero (262–263); closure by sealed constructor +
  withheld field selectors (251–263, 348–358). Every reachable ledger conserves.
- **Determinism forced.** `apply` is pure and total over all three `Event` constructors;
  `replay = foldM (flip apply)`; checkpoint soundness rests on the genuine monadic
  left-fold split law (`foldM` over `xs ++ ys` splits at any cut). Row retention attributed
  to audit, not determinism (387).
- **psHwm** correctly carries no zero-sum invariant and no holder aggregate; stays zero in
  this file, writer out of scope (231–241, 358). No overclaim.

## KEEP items all present; no DROP leakage; no false statement

1. Three homes + structurally-empty fourth cell (2×2, 79–104). ✓
2. No wallet-keyed economic sector; mandate reification; KYC is identity not economic
   state (62–68, 154–159). ✓
3. Never-held vs held-and-flat, both readings used (settlement entitlement vs wash-sale
   lookback) (328–341). ✓
4. Three forcing reasons by concrete example: per-position (buyer +1000/seller −1000,
   114–119); shared status (one number read identically, 120–126); terms≠status (two change
   disciplines: append vs overwrite, 127–141). ✓
5. Conservation `Σ_holders = 0` + deterministic replay, forced in a few visible lines (§5).
   ✓
6. Mandate-as-unit (−1 manager/+1 client, summing zero) grounding the absent fourth sector
   (154–159). ✓

No Pareto frontier, rejected designs, C1–C12, F1–F8, round counts, mutation/TLC numbers, or
"considered and rejected" reasoning. The "Active with no price"/"Listed yet priced"
unrepresentability claim (194–203) is true of `data Lifecycle = Listed | Active Price`.
Terms-one-version-in-this-file (137–141) is true: `register` lays version one, `appendVersion`
driven by no event.

## Residue

None. No load-bearing fact dropped, weakened, or contradicted; no false statement; all
pointers land; conservation and deterministic replay follow visibly from the structure. A
competent first-time reader reaches for no further justification.

**OBVIOUS.**

— FORMALIS Committee
