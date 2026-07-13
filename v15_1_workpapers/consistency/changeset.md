# v15.1 Consistency Pass — Changeset (for certification)

Base: certified Ledger_Spec_v15.1 (92pp → now 96pp, builds clean, boxes=4, datum=0).
Author: orchestrator (single writer). Certifiers must be independent (no agent certifies own work).
Authoritative manifesto `LedgerManifesto/leddeger_manifesto.{tex,md,pdf}` is BYTE-UNTOUCHED.

## Owner gate (2026-07-13) — ratified/conformed
- **D1 RATIFIED** deposit-neutrality at fair value (C-8.7). Recorded in `constitution_v1_2_proposed.tex`
  as a RATIFIED box; parking_index PARK-4 marked ratified; ch07 Prop 7.3 + ch17§3 updated to "ratified,
  awaiting manifesto adoption."
- **D2 CONFORM** ch01 §1.2: struck "commitments are ordered by what arbitrates a conflict" → joint
  non-negotiability. No constitutional change.
- **D3 CONFORM** ch09 Timing: booking moment is a declared term of the agreement (default trade-date),
  settlement-date branch added. §4 untouched.
- **D4 RATIFIED** observation = moveless transaction through the one door (C-4.8 clarification). Recorded
  as RATIFIED box in the vehicle; parking_index new RATIFIED-D4 entry; ch17§3 new bullet.

## Track 2 findings (each closed on a green ch15 acceptance test)
- **F1** ch12: coverage-net availability `max(bal_owned,0) − Σ_G bal_posted,G` (was missing the max →
  negative for negative-owned shorts, contradicting ch14 `Σposted ≤ max(owned,0)`). New test
  `prop_availabilityNonNegative` (fires on a negative-owned wallet). ch15 `prop_coverageSignConvention`
  already used the max form.
- **F2** (D4) record=log Option 1: ch08 §obs-door recast (Ingest = Proposed Transaction, moveless);
  ch04 Events Executor "proposes their recording, never writes"; ch03 record=log; ch02 typed-picture
  note; ch05 previous-close as a home read; ch14 new subsection "The record is the log" + test
  `prop_replayReconstructsRecord`.
- **F3** ch11: named the writer of instructed→failed (the settlement-obligation unit's own contract;
  two recorded triggers: fail notice OR due-date watch finding no confirmation). Test
  `prop_failWriterAttribution` (no orphan failed node).
- **F4** rename boundary set W1–W4 "failure regimes" → "failure modes" (ch08/ch14/ch16/ch15); "regime"
  reserved for the 3 collateral inflow regimes; ch08 disjointness sentence added. Residual grep
  "failure regime" = 0. ch15 generator universe already names the two sets distinctly.
- **F5** ch07: venue = custody wallet (existing primitive), NOT a new coordinate; NAV^mk folds over
  custody wallets. Test `prop_navMkFoldsOverCustodyWallets`.
- **F6** variance swap: a fixing is a return over two closes; 252 fixings read 253 closes (C_0..C_252).
  ch13/ch08/ch11/ch06 conformed (frozen numbers 252/400/1000/441/41000 preserved; fixings 124/125/126
  preserved). Test `prop_varianceFixingsReadOnePlusCloses`. Independent derivation: N returns ⟺ N+1
  closes (gatheral).

## Invariants that must still hold (do not regress)
- Frozen thread numbers unchanged; no thread renumbered. Build clean; ≤100pp (96); boxes ≤4; datum=0.
- One-way authority: manifesto untouched; every constitutional change is owner-ratified and staged in
  the vehicle only.
