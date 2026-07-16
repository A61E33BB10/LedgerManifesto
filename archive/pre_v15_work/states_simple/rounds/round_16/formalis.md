# FORMALIS — States.tex, Round 16

**Verdict: OBVIOUS**

My lens: conservation and deterministic replay must be *visible* consequences of the
structure; no load-bearing fact of `SOLUTION_ESSENCE.md` may be dropped, weakened, hidden,
or contradicted; every pointer a first-time reader follows must land on the cited content;
no false statement. VETO on any regression. I read `States.tex` end to end, cross-checked
every listing against `States.hs`, resolved every `\S\ref` against `States.aux`, confirmed a
clean build, and re-verified the KEEP/DROP contract.

## No regression from Round 15

Round 15 closed OBVIOUS, no residue. The tex was rebuilt (aux/pdf/tex all 13:28), but every
property Round 15 verified still holds verbatim. `States.log` shows no warnings, no undefined
references, no rerun pending; `States.pdf` is 3 pages.

## Cross-references all land

Labels in `States.aux`: `sec:answer`={2}, `sec:why`={3}, `sec:construction`={4},
`sec:right`={5}. All eight `\S\ref` consumers resolve onto matching content:
line 57 (n=1 reification) → §3 mandate paragraph; 96 (fourth cell empty) → §3 "The fourth
cell is empty…"; 98 (terms≠status, cannot be one value) → §3 "Terms are a home distinct…";
100 (third home, not third map) → §4 "The three homes, two maps"; 125 (terms externally /
status ledger authored) → §2; 273 (`appendVersion` out of scope) → §3 "The amendment
event…is out of scope"; 351 (psHwm no invariant) → §4; 378 (one version each) → §3. No
dangling pointer.

## Listings faithful to source

Declaration by declaration vs `States.hs`: `Qty`/`negQty` (tex 166–171 ↔ hs 93–118); keys
(180–182 ↔ 134–135); `Price`/`Lifecycle`/`UnitStatus{usLifecycle}`/`defaultStatus`
(196–201 ↔ 249–272); `TermsVersion`/`ProductTerms`/`currentTerms` (`NE.last`)/`appendVersion`
(`vs <> (tv :| [])`) (213–219 ↔ 329–353); `PositionState`/`zeroP` (236–241 ↔ 379–391);
`Ledger`/`emptyLedger` (258–263 ↔ 436–451); `register`/`settle` (`Map.adjust (\(t,_) -> (t,
UnitStatus (Active px)))`) (276–287 ↔ 465–489); `applyMove`/`netDeltas`/`writeNet`
(298–310 ↔ 519–554); `position` (331–333 ↔ 504–505); `netBal` (`foldMap psBal`) (353–354 ↔
597–598); `Event`/`apply`/`replay` (`foldM (flip apply)`) (361–367 ↔ 696–713).
`Move`/`TermsVersion` rendered positionally where source uses record syntax — a licensed
structural simplification, not a misstatement.

## Conservation and replay visible

- **Conservation forced.** `applyMove` is the sole `psBal` writer; `netDeltas` builds the
  per-wallet net map (two distinct wallets → `negQty q` and `q`; a self-move collapses on one
  key via `insertWith (<>)` to `mempty`); `writeNet` drops any `mempty` row, so no phantom
  "held-and-flat" row is conjured. `register`/`settle` touch only `ledgerUnit`. Base
  `emptyLedger` sum zero; closure by sealed constructor + withheld field selectors (258–264,
  348–350). The seal rationale — an exported selector would permit a non-conserving record
  update bypassing the discipline (250–254) — is correct and load-bearing. Every reachable
  ledger conserves.
- **Determinism forced.** `apply` is pure and total over all three `Event` constructors;
  `replay = foldM (flip apply)`; checkpoint soundness rests on the genuine monadic left-fold
  split law. Row retention attributed to audit, not determinism (380).
- **psHwm** correctly carries no zero-sum invariant and no holder aggregate; stays zero here,
  writer out of scope (230–234, 351). No overclaim.

## KEEP present; no DROP leakage; no false statement

1. Three homes + structurally-empty fourth cell (2×2 table, 77–96). ✓
2. No wallet-keyed economic sector; mandate reification; KYC/permissions/audit-cursor are
   identity not economic state (66–67, 142–149). ✓
3. Never-held vs held-and-flat, both readings used (settlement entitlement vs wash-sale
   lookback) (321–329). ✓
4. Three forcing reasons by concrete example: per-position (buyer +1000/seller −1000,
   110–114); shared status (one number read identically, 116–122); terms≠status, grounded in
   distinct authorities of record *and* append-vs-overwrite disciplines (123–131). ✓
5. Conservation `Σ_holders psBal = 0` + deterministic replay, forced in a few visible lines
   (§5). ✓
6. Mandate-as-unit (−1 manager / +1 client, summing zero) grounding the absent fourth sector
   (142–149); multi-instrument case stated as assumed-not-proved (57–58, 147–149). ✓

`grep` for DROP-listed content (Pareto, sentinel/four-map/sheaf/universe-wallet designs,
C1–C12, F1–F8, mutation/TLC numbers, round counts, "we considered/rejected") returns
nothing. The "Active with no price"/"Listed yet priced" unrepresentability claim (184–193)
is true of `data Lifecycle = Listed | Active Price`. The "one version per terms value here"
claim (123–131, 273) is true: `register` lays version one, `appendVersion` driven by no
in-scope event. The n=1 reification is honestly flagged as assumed-not-proved.

## Residue

None. No load-bearing fact dropped, weakened, or contradicted; no false statement; every
pointer lands; conservation and deterministic replay follow visibly from the structure. A
competent first-time reader reaches for no further justification.

**OBVIOUS.**

— FORMALIS Committee
