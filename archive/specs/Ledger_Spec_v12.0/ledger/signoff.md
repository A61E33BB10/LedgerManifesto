# Sign-off — The Ledger v12.0 (accessibility & organisation pass)

## Verdict: APPROVED — gate MET

All termination criteria are satisfied after three gate rounds:

- Every external-review item is dispositioned (adopt / adapt / decline) in
  `feedback_disposition.md`.
- The document is standalone and self-contained — no reference to any previous version,
  presupposes none (**minsky**, final PASS).
- The reorganisation into parts loses and duplicates nothing; the coverage map matches the
  rendered structure (**jane-street-cto**, final PASS).
- No guarantee, type, invariant, conservation law, or reproducibility property was weakened;
  all three category lenses are true and carry the certified wording (**formalis**, final
  PASS, holding the veto).
- The document is readable by each named audience without loss of rigour (**stylus**,
  **henri-cartan** PASS round 2; **karpathy** one-pass PASS round 1; **chris-lattner** PASS
  round 3).

Build: **155 pages**, 0 fatal, 0 undefined references, 0 warnings, 0 missing glyphs,
0 overfull > 20 pt.

## Gate history

| Round | Scope | Result |
|-------|-------|--------|
| 1 | Full gate, 8 reviewers | 3 PASS; 6 blocking items (Ledger.hs version label; NAV unexpanded; transposed §15/§16 in front matter; three-home diagram valuation summed over wallets; preface overstated external reconciliation) |
| 2 | 6 reviewers, confirm fixes + fresh scan | all 6 prior fixes confirmed; 5 PASS; **chris-lattner escalated** a deeper correctness finding (`value`/`pnl` fold the whole ledger → identically zero) |
| 3 | Final sign-off, 4 reviewers, after the value/pnl fix | **all 4 PASS, 0 blocking** |

## Correctness finding and resolution (surfaced during review)

FORMALIS proved, by construction, that the inherited portfolio valuation
`value :: PriceVec -> Ledger -> Cash` folded over **all** wallets in `ledgerPS`; under
conservation (Σ over all wallets = 0) it — and therefore `pnl` — evaluated to `Cash 0` for
every ledger. This is **pre-existing** (inherited verbatim from the prior reference; the
accessibility pass did not introduce it).

The whole-ledger sum being zero is *by design* — the system is closed and zero-sum.
Portfolio value and PnL are meaningful only at **wallet/portfolio scope**, and the
mathematical Definition was already wallet-scoped. The defect was that the *executable*
did not match its own definition.

Per the owner's decision ("align code to definition"), `value`/`pnl` were rescoped to take a
`[WalletId]` portfolio scope (`reference/Ledger.hs`), and `def:portfolio-value` plus the
sec05 listing were restated accordingly, with an explicit note that the whole-ledger sum is
zero by closure. FORMALIS confirmed (final round): value is no longer identically zero for a
real-wallet portfolio; conservation (P1) is untouched; PnL path-independence (P10) and
state-sufficiency are preserved (and P10 is rescued from vacuity). No other call sites
existed; no property test asserted `value == mempty`.

## Residual minor notes (non-blocking, recorded)

- The reference is type-checked by inspection; GHC was unavailable in the environment. A CI
  compile gate is recommended to mechanically certify the "listings as theorems" claim.
- `coverage_map.md` and `CHANGELOG_v11.0_to_v12.0.md` are author/process artifacts and are
  **not** `\input` into the document; never bundle them into the shipped PDF.
- Stray agent working-memory directories duplicated by the v11→v12 copy were removed from the
  deliverable tree.

## Reviewers

formalis (correctness veto), minsky + jane-street-cto (self-containment & coverage gate),
stylus + henri-cartan + chris-lattner + karpathy (accessibility), with dirac (diagrams) and
finops-architect (preface operational accuracy) on consultation.

## Post-sign-off reference hardening (MINSKY review → FORMALIS-certified)

A subsequent MINSKY review of `reference/Ledger.hs` surfaced two blocking type-safety gaps at
the "illegal states unrepresentable" banner; both are now fixed and **FORMALIS-CERTIFIED by
inspection** (GHC unavailable in-environment):

- **B1** — `Move.mQty` is now `PosQty` (abstract; sole door `mkPosQty`), so a non-positive move
  magnitude is unrepresentable, not merely rejected by `move`. Field reads unwrap via
  `unPosQty`; trusted internal constructions use statically-positive magnitudes; the untrusted
  CDM path (`instructionMoves`) routes through the checked `move`. `Move (..)` stays safely
  exported. The banner is now honest for move magnitude.
- **B2** — portfolio valuation scope is a non-empty abstract `Portfolio (Set WalletId)` built
  only by `mkPortfolio` (rejects `[]`); `value :: Portfolio -> PriceVec -> Ledger -> Cash`
  (scope-first, `Set.member`). The empty-scope identically-zero valuation — the same defect
  class as the earlier whole-ledger zero — is now unreachable by construction.
- **S1** — `pnl :: Portfolio -> Snapshot -> Snapshot -> Cash` with `data Snapshot = Snapshot
  PriceVec Ledger`; endpoints cannot be cross-paired.
- **S3** — `unitTotal` deduplicates its wallet set, so the conservation oracle and `value` share
  set semantics; FORMALIS notes this **strictly strengthens** P1.

`drafts/sec05.tex` was aligned (definition, listing, and the now-five illegal-states paragraph).
Conservation (P1), chain/replay (P8), and path-independent PnL (P10) all preserved. Residuals,
non-blocking and recorded: the CDM boundary silently drops an ill-formed leg (principled fix =
`forget :: BusinessEvent -> Either CdmError CdmTransaction`); `Snapshot` well-pairedness at
capture is the caller's obligation (provenance being inexpressible without time-indexed types).
The simplified per-section Haskell excerpts (`sec02`/`sec06`/`sec09`) were left as standalone
simplifications per the reference-file header, not churned to `PosQty`.
