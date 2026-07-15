# FORMALIS — States.tex, Round 15

**Verdict: OBVIOUS**

My lens: conservation and deterministic replay must be *visible* consequences of the
structure; no load-bearing fact of `SOLUTION_ESSENCE.md` may be dropped, weakened, hidden,
or contradicted; every pointer a first-time reader follows must land on the cited content;
no false statement. VETO on any regression. I read `States.tex` end to end, cross-checked
every listing against `States.hs`, resolved every `\S\ref` against `States.aux`, confirmed a
clean current build, and re-verified the KEEP/DROP contract.

## No regression from Round 14

Round 14 closed OBVIOUS, no residue. Round 15 carries a uniform ~10-line upward shift
(trimming in §§1–2), but every property Round 14 verified still holds. Build is current and
clean: `States.aux` resolves `sec:answer`={2}, `sec:why`={3}, `sec:construction`={4},
`sec:right`={5}; `States.log` has no warnings, no undefined references, no rerun pending;
`States.pdf` is 3 pages, timestamps consistent (tex/aux/pdf all 13:20–13:21).

## Cross-references all land

All eight `\S\ref` consumers resolve onto matching content: line 57 (n=1 reification) → §3;
96 (fourth cell empty) → §3 "The fourth cell is empty…"; 98 (terms≠status, one value) → §3
"Terms are a home distinct…"; 100 (third home, not third map) → §4 "The three homes, two
maps"; 125 (terms externally / status ledger authored) → §2; 272 (`appendVersion` out of
scope) → §3 "The amendment event…is out of scope"; 350 (psHwm no invariant) → §4 position
paragraph; 377 (one version each) → §3. No dangling pointer.

## Listings faithful to source

Declaration by declaration vs `States.hs`: `Qty`/`negQty` (tex 166–171 ↔ hs 93–118); keys
(180–182 ↔ 134–135); `Price`/`Lifecycle`/`UnitStatus{usLifecycle}`/`defaultStatus` (196–201
↔ 249–272); `TermsVersion`/`ProductTerms`/`currentTerms` (NE.last)/`appendVersion`
(`vs <> (tv :| [])`) (213–219 ↔ 329–353); `PositionState`/`zeroP` (236–241 ↔ 379–391);
`Ledger`/`emptyLedger` (258–263 ↔ 436–451); `register`/`settle` (`Map.adjust (\(t,_) -> (t,
UnitStatus (Active px)))`) (276–287 ↔ 465–489); `applyMove`/`netDeltas`/`writeNet` (298–310 ↔
519–554); `position` (331–333 ↔ 504–505); `netBal` (353–354 ↔ 597–598);
`Event`/`apply`/`replay` (`foldM (flip apply)`) (361–367 ↔ 696–713). `Move`/`TermsVersion`
rendered positionally where source uses record syntax — a licensed structural simplification,
not a misstatement.

## Conservation and replay visible

- **Conservation forced.** `applyMove` is the sole `psBal` writer; `netDeltas` builds the
  per-wallet net map whose values sum to `mempty` (two distinct wallets → `negQty q` and `q`;
  a self-move collapses on one key via `insertWith (<>)` to `mempty`); `writeNet` drops any
  `mempty` row. `register`/`settle` touch only `ledgerUnit`. Base `emptyLedger` sum zero;
  closure by sealed constructor + withheld field selectors (257–263, 348–349). Every reachable
  ledger conserves. The seal rationale — that an exported selector would permit a
  non-conserving record update bypassing the discipline (250–254) — is correct and load-bearing.
- **Determinism forced.** `apply` is pure and total over all three `Event` constructors;
  `replay = foldM (flip apply)`; checkpoint soundness rests on the genuine monadic left-fold
  split law. Row retention attributed to audit, not determinism (379).
- **psHwm** correctly carries no zero-sum invariant and no holder aggregate; stays zero here,
  writer out of scope (231–233, 350). No overclaim.

## KEEP present; no DROP leakage; no false statement

1. Three homes + structurally-empty fourth cell (2×2 table, 77–96). ✓
2. No wallet-keyed economic sector; mandate reification; KYC/permissions/audit-cursor are
   identity not economic state (66–67, 142–149). ✓
3. Never-held vs held-and-flat, both readings used (settlement entitlement vs wash-sale
   lookback) (320–328). ✓
4. Three forcing reasons by concrete example: per-position (buyer +1000/seller −1000,
   110–114); shared status (one number read identically, 116–122); terms≠status (append vs
   overwrite disciplines, 123–131). ✓
5. Conservation `Σ_holders psBal = 0` + deterministic replay, forced in a few visible lines
   (§5). ✓
6. Mandate-as-unit (−1 manager/+1 client, summing zero) grounding the absent fourth sector
   (142–149). ✓

No Pareto frontier, rejected designs, C1–C12, F1–F8, round counts, or mutation/TLC numbers.
The "Active with no price"/"Listed yet priced" unrepresentability claim (184–193) is true of
`data Lifecycle = Listed | Active Price`. The "one version per terms value in this file"
claim (123–131, 272) is true: `register` lays version one, `appendVersion` driven by no
in-scope event. The n=1 reification is stated as assumed-not-proved for the multi-instrument
case (57–58, 147–149) — honest, not overstated.

## Residue

None. No load-bearing fact dropped, weakened, or contradicted; no false statement; every
pointer lands; conservation and deterministic replay follow visibly from the structure. A
competent first-time reader reaches for no further justification.

**OBVIOUS.**

— FORMALIS Committee
