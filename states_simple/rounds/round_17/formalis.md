# FORMALIS — States.tex, Round 17

**Verdict: OBVIOUS**

My lens: conservation and deterministic replay must be *visible* consequences of the
structure; no load-bearing fact of `SOLUTION_ESSENCE.md` may be dropped, weakened, hidden, or
contradicted; every `\S\ref` a first-time reader follows must land; no false statement. VETO
on any regression. I read `States.tex` end to end, cross-checked every listing against
`States.hs`, resolved every label against `States.aux`, and confirmed a clean build.

## No regression from Round 16

Round 16 closed OBVIOUS, no residue. The artifacts were rebuilt (tex/aux/log/pdf at
13:45–13:46 vs. 13:28 last round), but the prose and every listing are unchanged in substance
and still faithful to `States.hs`. `States.log` shows no warnings, no undefined references, no
rerun pending; `States.pdf` is 3 pages. Nothing weakened, nothing dropped.

## Cross-references all land

`States.aux` labels: `sec:answer`={2}, `sec:why`={3}, `sec:construction`={4}, `sec:right`={5}.
Every `\S\ref` consumer resolves onto matching content: line 57 (n=1 reification) → §3 mandate
paragraph; 96 (fourth cell empty) → §3 "The fourth cell is empty…"; 99/100 (terms≠status,
third home not third map) → §3/§4; 125 (terms externally / status ledger authored) → §2;
222/333 (psBal conserves) → §5; 268 (`appendVersion` out of scope) → §3; 314 ("held" =
nonzero-net) self-contained; 372 (one version each) → §3. No dangling pointer.

## Listings faithful to source

Declaration by declaration vs `States.hs`: `Qty`/`negQty` (166–171 ↔ 93–118);
`WalletId`/`UnitId` (180–182 ↔ keys); `Price`/`Lifecycle`/`UnitStatus{usLifecycle}`/
`defaultStatus` (196–201 ↔ 258–272); `TermsVersion`/`ProductTerms (NonEmpty)`/`currentTerms`
(`NE.last`)/`appendVersion` (`vs <> (tv :| [])`) (213–219 ↔ 329–353); `PositionState`/`zeroP`
(232–237 ↔ 379–391); `Ledger`/`emptyLedger` (254–259 ↔ 436–451);
`register`/`settle` (`Map.adjust (\(t,_) -> (t, UnitStatus (Active px)))`) (272–283 ↔
465–489); `Move`/`applyMove`/`netDeltas`/`writeNet` (293–306 ↔ 512–554); `position` (327–329
↔ 504–505); `netBal` (`foldMap psBal`) (348–350 ↔ 599–600); `Event`/`apply`/`replay` (`foldM
(flip apply)`) (356–363 ↔ 698–715). `Move`/`TermsVersion` rendered positionally where source
uses record syntax — a licensed structural simplification, not a misstatement.

## Conservation and replay visible

- **Conservation forced.** I re-derived `netDeltas` by hand. Self-move (`from == to`):
  `insertWith (<>) f qty {f ↦ negQty qty}` = `{f ↦ qty <> negQty qty}` = `{f ↦ mempty}`,
  which `writeNet` drops — no phantom row. Distinct wallets: `{f ↦ −q, t ↦ +q}`, summing to
  `mempty`. `applyMove` is the sole `psBal` writer; `register`/`settle` touch only
  `ledgerUnit`; `position`/`netBal` only read. Base `emptyLedger` sum zero; closure by sealed
  constructor + withheld field selectors (254–259, 343–345). The seal rationale — an exported
  selector would permit a non-conserving record update bypassing the discipline (244–250) — is
  correct and load-bearing. Every reachable ledger conserves.
- **Determinism forced.** `apply` is pure and total over all three `Event` constructors;
  `replay = foldM (flip apply)`; checkpoint soundness rests on the genuine monadic left-fold
  split law. Row retention attributed to audit, not determinism (374).
- **psHwm** correctly carries no zero-sum invariant and no holder aggregate; stays zero here,
  writer out of scope (221–229, 351). No overclaim.

## KEEP present; no DROP leakage; no false statement

1. Three homes + structurally-empty fourth cell (2×2 table, 78–97). ✓
2. No wallet-keyed economic sector; mandate reification; KYC/permissions/audit-cursor are
   identity not economic state (66–67, 142–149). ✓
3. Never-held vs held-and-flat, both readings used (settlement entitlement vs wash-sale
   lookback) (316–329). ✓
4. Three forcing reasons by concrete example: per-position (buyer +1000/seller −1000,
   110–114); shared status (one number read identically, 116–122); terms≠status, grounded in
   distinct authorities of record *and* append-vs-overwrite disciplines (123–131). ✓
5. Conservation `Σ_holders psBal = 0` + deterministic replay, forced in a few visible lines
   (§5). ✓
6. Mandate-as-unit (−1 manager / +1 client, summing zero) grounding the absent fourth sector
   (142–149); multi-instrument case honestly flagged assumed-not-proved (57–58, 147–149). ✓

`grep` for DROP-listed content (Pareto, sentinel/four-map/sheaf/universe-wallet designs,
C1–C12, F1–F8, mutation/TLC numbers, round counts, "we considered/rejected") returns nothing
in the tex. The "Active with no price"/"Listed yet priced" unrepresentability claim (184–193)
is true of `data Lifecycle = Listed | Active Price`. The "one version per terms value here"
claim (123–131, 268) is true: `register` lays version one; `appendVersion` is driven by no
in-scope event.

## Residue

None. No load-bearing fact dropped, weakened, or contradicted; no false statement; every
pointer lands; conservation and deterministic replay follow visibly from the structure. A
competent first-time reader reaches for no further justification.

**OBVIOUS.**

— FORMALIS Committee
