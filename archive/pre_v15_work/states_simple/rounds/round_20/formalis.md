# FORMALIS — States.tex, Round 20

**Verdict: OBVIOUS**

My bar: conservation and deterministic replay must be *visible* consequences of the structure; no
load-bearing fact of `SOLUTION_ESSENCE.md` may be dropped, weakened, hidden, or contradicted; every
`\S\ref` a first-time reader follows must land; no false statement. VETO on any regression from the
Round 19 OBVIOUS. I read `States.tex` end to end, re-derived the conservation arithmetic by hand,
cross-checked every listing against `States.hs`, resolved every label against `States.aux`, and
confirmed the artefact (`States.pdf` = 3 pages; `States.log` shows no warning, no undefined
reference, no rerun pending).

## No regression from Round 18/19

Round 19 closed OBVIOUS, no residue. The prose and every listing are unchanged in substance and
still faithful to `States.hs`. Page count, label set (`sec:answer`=2, `sec:why`=3,
`sec:construction`=4, `sec:right`=5), and a clean log all match the Round 19 record. Nothing
weakened, dropped, added, or contradicted.

## Conservation is visible

Re-derived `netDeltas`/`writeNet` independently against tex 302–316 (↔ `States.hs` 519–554):
- Distinct wallets: `netDeltas` builds `{from ↦ −q, to ↦ +q}`, summing to `mempty`.
- Self-move (`from == to`): the two `Map.insertWith (<>)` collapse to `{from ↦ negQty q <> q} =
  {from ↦ mempty}`, which `writeNet` drops — no phantom row. The zero-quantity move drops the same
  way. Both confirmed well-formed-and-accepted yet row-free (tex 322–324). Correct, and matches the
  essence's load-bearing never-held vs held-and-flat distinction (tex 326–334).
- `applyMove` is the sole `psBal` writer; `register`/`settle` touch only `ledgerUnit` (tex 281–293,
  346–356); `position`/`netBal` only read. Base `emptyLedger` sum is zero; closure is by the sealed
  constructor and withheld field selectors, with the *correct* rationale (tex 254–260) that an
  exported selector would permit a non-conserving record update bypassing the discipline. Every
  reachable ledger conserves — forced, not asserted.
- `psHwm` correctly carries no zero-sum invariant and no holder aggregate; stays `mempty` (writer
  out of scope); `netBal` sums `psBal` alone (tex 358–359 ↔ hs 599–600). No overclaim.

## Determinism is visible

`apply` is pure and total over all three `Event` constructors (tex 366–370 ↔ hs 704–707);
`replay = foldM (flip apply)` (tex 371–372). Checkpoint soundness rests on the genuine monadic
left-fold split law (tex 380–381). Row retention attributed to audit, not determinism (tex 384) —
the honest separation the essence requires. "Every view is a projection of the stream" is literally
true here because Registered/Settled/Moved are all events (tex 381–384).

## Listings faithful to source

Declaration by declaration vs `States.hs`: `Qty`/`Semigroup`/`Monoid`/`negQty`;
`WalletId`/`UnitId`; `Price`/`Lifecycle`/`UnitStatus{usLifecycle}`/`defaultStatus`;
`TermsVersion`/`ProductTerms (NonEmpty)`/`currentTerms (NE.last)`/`appendVersion (vs <> (tv :| []))`;
`PositionState`/`zeroP`; `Ledger`/`emptyLedger`; `register`/`settle`
(`Map.adjust (\(t,_) -> (t, UnitStatus (Active px)))`); `Move`/`applyMove`/`netDeltas`/`writeNet`;
`position`; `netBal`; `Event`/`apply`/`replay`. `Move` and `TermsVersion` are records in source,
rendered positionally in the tex — a licensed simplification disclosed at tex 170 ("deriving
clauses elided"), preserving the types' meaning, not a misstatement.

## KEEP present; no DROP leakage; no false statement

1. Three homes + structurally-empty fourth cell, 2×2 table (tex 87–106); Terms/Status example
   lists match the essence verbatim in substance. ✓
2. No wallet-keyed economic sector: mandate reification (tex 150–160), KYC/permissions/audit-cursor
   are identity not economic state (tex 75–76); the multi-instrument case honestly flagged
   *assumed, not proved* (tex 57–59, 157–160). ✓
3. Never-held vs held-and-flat, both readings used (settlement entitlement vs wash-sale lookback)
   (tex 326–334). ✓
4. Three forcing reasons by concrete example: per-position (buyer +1000 / seller −1000,
   tex 119–124); shared status (one number read identically, tex 125–131); terms ≠ status, grounded
   in distinct authorities of record *and* the append-vs-overwrite change discipline
   (tex 132–140). The essence's change-discipline reason is present, not lost to the authorship
   axis. ✓
5. Conservation (`Σ_holders psBal = mempty`) + deterministic replay, forced in a few visible lines
   (§5). ✓
6. Mandate-as-unit (−1 manager / +1 client, summing zero) grounding the absent fourth sector
   (tex 150–160). ✓

The authorship 2×2 is the document's own derivation of *why three*; it is internally consistent and
richer than the essence's framing without contradicting it. The "fourth cell empty" (externally
authored (holder,unit)) and the "no fourth wallet-keyed sector" (the reification) are two distinct
claims, and both are made — no conflation. The "Active-with-no-price / listed-yet-priced
unspellable" claim (tex 199–204) is true of `data Lifecycle = Listed | Active Price`. The "one
version per terms value here" claim (tex 137–140, 277–279) is true: `register` lays version one;
`appendVersion` is driven by no in-scope event. No DROP-listed content (Pareto, rejected designs,
C-catalogue, F-register, mutation/TLC numbers, round counts, "we considered/rejected") appears.

## Residue

None. No load-bearing fact dropped, weakened, or contradicted; no false statement; every pointer
lands; conservation and deterministic replay follow visibly from the structure. A competent
first-time reader reaches for no further justification.

**OBVIOUS.**

— FORMALIS Committee
