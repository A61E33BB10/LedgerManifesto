# FORMALIS — States.tex, Round 18

**Verdict: OBVIOUS**

My lens: conservation and deterministic replay must be *visible* consequences of the
structure; no load-bearing fact of `SOLUTION_ESSENCE.md` may be dropped, weakened, hidden, or
contradicted; every `\S\ref` a first-time reader follows must land; no false statement. VETO on
any regression. I read `States.tex` end to end, cross-checked every listing against `States.hs`,
resolved every label against `States.aux`, and confirmed a clean build.

## No regression from Round 17

Round 17 closed OBVIOUS, no residue. The tex was rebuilt since (13:56 vs. 13:45), but the prose
and every listing are unchanged in substance and still faithful to `States.hs`. `States.log`
shows no warnings, no undefined references, no rerun pending; `States.pdf` is 3 pages. Nothing
weakened, nothing dropped, nothing added.

## Cross-references all land

`States.aux` labels: `sec:answer`={2}, `sec:why`={3}, `sec:construction`={4}, `sec:right`={5}.
Every `\S\ref` consumer resolves onto matching content: 57 (n=1 reification) → §3 mandate
paragraph; 97 (fourth cell empty) → §3 "The fourth cell is empty…"; 99/100 (terms≠status, third
home not third map) → §3/§4; 125 (terms externally / status ledger authored) → §2; 223/337
(psBal conserves) → §5; 272 (`appendVersion` out of scope) → §3; 318 ("held" = nonzero-net)
self-contained; 376 (one version each) → §3. No dangling pointer.

## Listings faithful to source

Declaration by declaration vs `States.hs`: `Qty`/`Semigroup`/`Monoid`/`negQty` (166–171 ↔
93–118); `WalletId`/`UnitId` (180–182 ↔ 134–135); `Price`/`Lifecycle`/`UnitStatus{usLifecycle}`/
`defaultStatus` (196–201 ↔ 249–272); `TermsVersion`/`ProductTerms (NonEmpty)`/`currentTerms`
(`NE.last`)/`appendVersion` (`vs <> (tv :| [])`) (213–219 ↔ 329–353); `PositionState`/`zeroP`
(236–241 ↔ 379–391); `Ledger`/`emptyLedger` (257–262 ↔ 436–451); `register`/`settle`
(`Map.adjust (\(t,_) -> (t, UnitStatus (Active px)))`) (275–286 ↔ 465–489);
`Move`/`applyMove`/`netDeltas`/`writeNet` (296–309 ↔ 512–554); `position` (330–332 ↔ 504–505);
`netBal` (`foldMap psBal`) (351–353 ↔ 599–600); `Event`/`apply`/`replay` (`foldM (flip apply)`)
(359–366 ↔ 698–715). `Move` and `TermsVersion` are record types in source, rendered positionally
in the listing — a licensed structural simplification preserving the types' meaning (one `String`
field; four fields), not a misstatement. Deriving clauses elided, as the tex states (159).

## Conservation and replay visible

- **Conservation forced.** Re-derived `netDeltas`/`writeNet` by hand. Self-move (`from == to`):
  the two `insertWith (<>)` collapse to `{f ↦ qty <> negQty qty}` = `{f ↦ mempty}`, which
  `writeNet` drops — no phantom row. Distinct wallets: `{f ↦ −q, t ↦ +q}`, summing to `mempty`.
  `applyMove` is the sole `psBal` writer; `register`/`settle` touch only `ledgerUnit`;
  `position`/`netBal` only read. Base `emptyLedger` sum zero; closure by sealed constructor +
  withheld field selectors (257–262, 347–349), with the correct rationale that an exported
  selector would permit a non-conserving record update bypassing the discipline (250–255). Every
  reachable ledger conserves.
- **Determinism forced.** `apply` is pure and total over all three `Event` constructors;
  `replay = foldM (flip apply)`; checkpoint soundness rests on the genuine monadic left-fold
  split law. Row retention attributed to audit, not determinism (378).
- **psHwm** correctly carries no zero-sum invariant and no holder aggregate; stays zero here,
  writer out of scope (222–234, 353). No overclaim; `netBal` sums `psBal` alone.

## KEEP present; no DROP leakage; no false statement

1. Three homes + structurally-empty fourth cell (2×2 table, 78–97); Terms/Status example lists
   match the essence verbatim. ✓
2. No wallet-keyed economic sector; mandate reification; KYC/permissions/audit-cursor are
   identity not economic state (66–67, 142–150). ✓
3. Never-held vs held-and-flat, both readings used (settlement entitlement vs wash-sale
   lookback) (320–329). ✓
4. Three forcing reasons by concrete example: per-position (buyer +1000 / seller −1000,
   110–114); shared status (one number read identically, 116–122); terms≠status, grounded in
   distinct authorities of record *and* append-vs-overwrite disciplines (123–131). ✓
5. Conservation `Σ_holders psBal = 0` + deterministic replay, forced in a few visible lines
   (§5). ✓
6. Mandate-as-unit (−1 manager / +1 client, summing zero) grounding the absent fourth sector
   (142–150); multi-instrument case honestly flagged assumed-not-proved (57–58, 148–150). ✓

`grep` for DROP-listed content (Pareto, sentinel/four-map/sheaf/universe-wallet designs,
C1–C12, F1–F8, mutation/TLC numbers, round counts, "we considered/rejected") returns nothing in
the tex. The "Active with no price"/"Listed yet priced" unrepresentability claim (188–195) is
true of `data Lifecycle = Listed | Active Price`. The "one version per terms value here" claim
(123–131, 272) is true: `register` lays version one; `appendVersion` is driven by no in-scope
event.

## Residue

None. No load-bearing fact dropped, weakened, or contradicted; no false statement; every pointer
lands; conservation and deterministic replay follow visibly from the structure. A competent
first-time reader reaches for no further justification.

**OBVIOUS.**

— FORMALIS Committee
