# FORMALIS — States.tex, Round 19

**Verdict: OBVIOUS**

My lens: conservation and deterministic replay must be *visible* consequences of the structure;
no load-bearing fact of `SOLUTION_ESSENCE.md` may be dropped, weakened, hidden, or contradicted;
every `\S\ref` a first-time reader follows must land; no false statement. VETO on any regression.
I read `States.tex` end to end, cross-checked every listing against `States.hs`, resolved every
label against `States.aux`, and confirmed a clean build.

## No regression from Round 18

Round 18 closed OBVIOUS, no residue. The prose and every listing are unchanged in substance and
still faithful to `States.hs`. `States.log` reports no warnings, no undefined references, no rerun
pending; `States.pdf` is 3 pages. Nothing weakened, dropped, added, or contradicted.

## Cross-references all land

`States.aux` labels: `sec:answer`={2}, `sec:why`={3}, `sec:construction`={4}, `sec:right`={5}.
The eleven `\ref` consumers (2× answer, 7× why, 1× construction, 1× right) all resolve onto
matching content: 57 (n=1 reification) → §3 mandate paragraph; 97 (fourth cell empty) → §3 "The
fourth cell is empty…"; 99/100 (terms≠status, third home not third map) → §3/§4; 125 (terms
externally / status ledger authored) → §2; 223/337 (psBal conserves) → §5; 272 (`appendVersion`
out of scope) → §3. No dangling pointer.

## Listings faithful to source

Declaration by declaration vs `States.hs`: `Qty`/`Semigroup`/`Monoid`/`negQty` (169–173 ↔
93–118); `WalletId`/`UnitId` (183–184 ↔ 134–135); `Price`/`Lifecycle`/`UnitStatus{usLifecycle}`/
`defaultStatus` (199–203 ↔ 249–272); `TermsVersion`/`ProductTerms (NonEmpty)`/`currentTerms`
(`NE.last`)/`appendVersion` (`vs <> (tv :| [])`) (216–221 ↔ 329–353); `PositionState`/`zeroP`
(237–241 ↔ 379–391); `Ledger`/`emptyLedger` (258–262 ↔ 436–451); `register`/`settle`
(`Map.adjust (\(t,_) -> (t, UnitStatus (Active px)))`) (276–286 ↔ 465–489);
`Move`/`applyMove`/`netDeltas`/`writeNet` (297–309 ↔ 512–554); `position` (331–332 ↔ 504–505);
`netBal` (`foldMap psBal`) (352–353 ↔ 599–600); `Event`/`apply`/`replay` (`foldM (flip apply)`)
(360–366 ↔ 698–715). `Move` and `TermsVersion` are record types in source, rendered positionally
in the tex — a licensed structural simplification preserving the types' meaning, stated at 159
("deriving clauses elided"), not a misstatement.

## Conservation and replay visible

- **Conservation forced.** Re-derived `netDeltas`/`writeNet` by hand. Self-move (`from == to`):
  the two `insertWith (<>)` collapse to `{f ↦ qty <> negQty qty} = {f ↦ mempty}`, which `writeNet`
  drops — no phantom row. Distinct wallets: `{f ↦ −q, t ↦ +q}`, summing to `mempty`. `applyMove`
  is the sole `psBal` writer; `register`/`settle` touch only `ledgerUnit`; `position`/`netBal`
  only read. Base `emptyLedger` sum zero; closure by sealed constructor + withheld field selectors
  (258–262, 244–256, 347–349), with the correct rationale that an exported selector would permit a
  non-conserving record update bypassing the discipline. Every reachable ledger conserves.
- **Determinism forced.** `apply` is pure and total over all three `Event` constructors;
  `replay = foldM (flip apply)`; checkpoint soundness rests on the genuine monadic left-fold split
  law. Row retention attributed to audit, not determinism (378).
- **psHwm** correctly carries no zero-sum invariant and no holder aggregate; stays `mempty` here,
  writer out of scope (224–234, footnote). No overclaim; `netBal` sums `psBal` alone.

## KEEP present; no DROP leakage; no false statement

1. Three homes + structurally-empty fourth cell (2×2 table, 79–98); Terms/Status example lists
   match the essence. ✓
2. No wallet-keyed economic sector; mandate reification; KYC/permissions/audit-cursor are identity
   not economic state (66–68, 142–152). ✓
3. Never-held vs held-and-flat, both readings used (settlement entitlement vs wash-sale lookback)
   (320–329). ✓
4. Three forcing reasons by concrete example: per-position (buyer +1000 / seller −1000, 111–116);
   shared status (one number read identically, 117–123); terms≠status, grounded in distinct
   authorities of record *and* append-vs-overwrite disciplines (124–132). ✓
5. Conservation `Σ_holders psBal = mempty` + deterministic replay, forced in a few visible lines
   (§5). ✓
6. Mandate-as-unit (−1 manager / +1 client, summing zero) grounding the absent fourth sector
   (143–152); multi-instrument case honestly flagged assumed-not-proved (57–58, 148–152). ✓

`grep` for DROP-listed content (Pareto, sentinel/four-map/sheaf/universe-wallet designs, C1–C12,
F1–F8, mutation/TLC numbers, round counts, "we considered/rejected") returns nothing load-bearing
in the tex (the single grep hit is `inputenc` in the preamble — a false positive). The "Active
with no price"/"Listed yet priced" unrepresentability claim (188–197) is true of
`data Lifecycle = Listed | Active Price`. The "one version per terms value here" claim (124–132,
272–273) is true: `register` lays version one; `appendVersion` is driven by no in-scope event.

## Residue

None. No load-bearing fact dropped, weakened, or contradicted; no false statement; every pointer
lands; conservation and deterministic replay follow visibly from the structure. A competent
first-time reader reaches for no further justification.

**OBVIOUS.**

— FORMALIS Committee
