# v15.1 Consistency Pass — Certification Record

Base: certified Ledger_Spec_v15.1. Author (single writer): orchestrator. All certifiers below are
INDEPENDENT of authorship (Constitution §8: no agent certifies its own work). USER GATE decisions
(2026-07-13): D1 RATIFIED, D2 CONFORM, D3 CONFORM, D4 RATIFIED. Authoritative manifesto byte-untouched.

Build state at certification (post-veto-fixes): spec 97pp (≤100), vehicle 12pp, both exit 0;
second-telling boxes = 4; `datum` = 0; residual "failure regime" = 0; residual "the finding" = 0; all
cross-refs resolve.

## Per-objective sign-off

| Objective | Scope | Certifier | Verdict | Notes |
|---|---|---|---|---|
| Self-consistency (Track 3, absolute veto) | whole document | CONCORDIA | **CONFIRMED** | All 7 axes hold; veto NOT exercised. 3 benign non-blocking notes (inv:one-writer/inv:writer dual label by design; heading title-case; "regime" in non-collateral compounds distinct). Manifesto byte-untouched (mtime 2026-07-11). |
| Executable checks fire (anti-vacuity) | ch15 five new tests | WILSON | **VETO → DISCHARGED** | VETO on F1 test (inlined the max, blind to the report). Fixed: prop_availabilityNonNegative now reads the ch12 `availableMass` projection + compares to the max-form. 4 independence conditions applied verbatim (F3 conjoin over all failed nodes; F5 conjunct 2 → `balanceCoordinates === [Owned,Lent,Posted]`; F6 nFixings = declared schedule count; F2 record oracle independent of replayFromLog). |
| Settlement/collateral/valuation domain | F1, F3, D3, F5 | ASHWORTH | **CONFIRMED (3 VETO discharged)** | Re-cert: all four DISCHARGED, no residual vetoes. Named defects F1(max)/F3(no-orphan) confirmed; D3 fixed (now agrees with ch11 Prop); F5 pinned to sub-custody; F1/F3 deeper issues parked openly. Standing condition: RoU coverage-guard is a LIVE BLOCKING open-problem item (re-use disabled until gate built) — applied to ch12 + ch17. |
| Numerical/algebraic re-derivation | F6, F1 | JACOBI | **CONFIRMED** | Fencepost re-derived: N returns ⟺ N+1 closes, C_0 forced before fixing 1; frozen numbers consistent (payout 41000, fixings 124/125/126 = ln(C_i/C_{i-1}), A_126=126 squares). max() load-bearing: owned −5000/Σposted 0 → 0 with max, −5000 without. ch14 worked example arithmetically correct. |
| Prose (§6 form) | all changed passages | STYLUS | **VETO → DISCHARGED** | datum=0, register/vocabulary clean. VETO on "the finding" meta-reference at 5 sites (invisible to the target reader). All 5 replaced verbatim + 1 minor ch13 tightening. Residual "the finding" in drafts = 0. |
| CDM consistency | F6, F2/D4 | ROSETTA-CDM | **CONFIRMED** | close=Observation/return=Reset is the correct CDM 6.0.0 mapping; 253/252 consistent with VarianceReturnTerms; moveless obs-transaction = transfer-free CDM Observation. 2 non-blocking advisories (C_0 may sit in VarianceReturnTerms.initialLevel; ledger single-door is a superset of CDM). |
| Page ledger (≤100) | whole spec | orchestrator (mechanical) | PASS | 97pp, 3pp reserve |

## Vetoes issued and discharged
- **VETO-C1 (WILSON, F1 test).** `prop_availabilityNonNegative` re-derived the `max()` inline, making it
  algebraically identical to `prop_coverageSignConvention` (the door invariant) and blind to a report
  that dropped the `max` — it would stay green under exactly the broken report it targets. DISCHARGED:
  rewritten to read the ch12 `availableMass` projection under test and compare it to the max-form; now
  fires red on a negative-owned wallet if the report drops the max, where the door invariant still
  passes. Rebuilt clean. (Author applied WILSON's own prescribed fix.)
- **VETO-C2 (STYLUS, prose).** The meta-word "the finding" (a reference to the internal consistency
  review, with no antecedent for the target reader) appeared at 5 sites (ch14×2, ch15×3). DISCHARGED:
  all 5 replaced with STYLUS's verbatim architecture-grounded replacements; 1 minor ch13 restatement
  tightened. Residual "the finding" = 0. Rebuilt clean.
- **Conditions (WILSON, non-veto) applied:** F3 quantifies over ALL failed transitions (conjoin); F5
  conjunct 2 asserts `balanceCoordinates === [Owned,Lent,Posted]` (no venue axis); F6 comments pin
  `nFixings` to the declared schedule count; F2 comments pin `observations`/`record` as an independent
  oracle — each removes an `x===x` collapse.

- **VETO-A1 (ASHWORTH, D3 booking).** My D3 SD-booking branch claimed "no market claim or mirror can
  arise" — false: the market claim is a function of cum/ex + settlement timing, not the owned-booking
  policy, so a cum-unsettled trade under SD booking still deprives the buyer (contradicts ch11 Prop
  Entitlement routing). DISCHARGED: struck the false claim; ch09 now states SD booking changes only which
  event writes owned and the market claim is raised under either booking rule. This was a real error in
  my added text.
- **VETO-A2 (ASHWORTH, F1 no-RoU rehypothecation).** The `max`-fix is confirmed correct; the deeper gap is
  that the coverage net nets no-right-of-use (segregated, C-8.8) received collateral as re-usable, so an
  illegal rehypothecation of segregated collateral is representable/admitted. Beyond this pass's
  nine-defect scope (a coverage-invariant redesign). DISPOSITION (ASHWORTH's own recommendation — "park,
  not silent confirm"): stated OPENLY — ch12 re-use line gated to "where the governing agreement grants a
  right of use" + names the C-8.8/coverage-net gap; ch17 open-problems index names "the right-of-use gate
  on collateral re-use." Not fudged, not silently confirmed.
- **VETO-A3 (ASHWORTH, F3 partial settlement).** The no-orphan-writer claim is confirmed; the deeper gap
  is that trigger (b) and the single lifecycle node do not handle partial settlement (silent residual /
  mis-noded unit). PARTIAL FIX: trigger (b) reworded to be quantity-aware ("cumulative confirmed short of
  instructed by the deadline") — closes the silent-residual hole; the quantity-aware node-split parked
  openly in ch17 ("the quantity-aware settlement-obligation unit"). Named, not hidden.
- **F5 caveat (ASHWORTH, non-veto) applied:** ch07 qualifies the reduction to "sub-custody is a wallet
  partition," excluding execution-venue-without-custody and CCP-cleared cases.

## New named residuals surfaced by the review (open problems, not blockers)
- **R-RoU** — right-of-use gate on collateral re-use (C-8.8 vs the coverage net). ch12 + ch17.
- **R-PARTIAL** — quantity-aware settlement-obligation unit (settled leg + failed-residual leg). ch11 + ch17.
These are genuine deeper issues surfaced by the adversarial review, named and stated in the open at the
chapters they touch. Neither is one of the nine named consistency-pass defects; both are recorded as open
problems for a future dedicated cycle. Surfacing them is the mechanism working, not failing.

## Freeze status: **FROZEN 2026-07-13 on unanimous certification.**
All six certifiers signed: CONCORDIA CONFIRMED (absolute veto not exercised), WILSON VETO→discharged,
ASHWORTH 3 VETO→all discharged, JACOBI CONFIRMED, STYLUS VETO→discharged, ROSETTA-CDM CONFIRMED; page
ledger PASS (97pp ≤100). Three vetoes issued and discharged (WILSON F1-test, STYLUS prose, ASHWORTH D3) +
two deeper issues parked openly (R-RoU, R-PARTIAL). Build clean (exit 0), boxes=4, datum=0, the-finding=0,
failure-regime=0. Owner gate (D1/D2/D3/D4) recorded; authoritative manifesto byte-untouched (owner adopts
v1.2). Next: commit + push under A61E33BB10 <a61e33bb10@pm.me>.
