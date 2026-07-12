# Phase 4 — CARTAN thread-number continuity audit (v15 chapter drafts)

**Scope.** Verify the six running-example threads (T1–T6) carry their FROZEN numbers
(phase2_ratified.md; phase2_toc_proposal.md §3) consistently across every chapter that
visits them. READ-ONLY: no chapter edited.

**Sources of truth.** `phase2_ratified.md` (ACME calendar; IDX close series; endpoints);
`phase2_toc_proposal.md` §3 (per-thread frozen numbers and visit map).

**Method.** Keyword grep of all 17 drafts, then normalized numeric scan (LaTeX `{,}`
thin-space and `\USD{}` prefixes stripped) to defeat formatting artifacts, then direct
reading of every episode passage in context. Global anomaly hunt over the largest numeric
tokens confirmed no forked neighbours exist.

---

## Verdict: THREADS UNBROKEN — YES. Zero number forks across all 17 chapters.

Every frozen number is printed identically in every chapter that visits its thread. The two
deliberate couplings (ACME dividend↔split; IDX close series future↔varswap) are consistent,
not forked. The stale `2026-05-29` payment date is absent from every file. Ch.8's
illustrative tickers carry no thread numbers and do not collide with the frozen cast.

One non-fork coverage note (T5×Ch.11) recorded at the end; it does not break number
continuity.

---

## Per-thread continuity tables

### T1 — FUT-IDX (future). Owner KARPATHY. Frozen: mult 10, USD, STM; buy 1 @ 995 day 0; prints 1000/990/1005; VM +50/−100/+150; cum VM 100 = PnL.

| Chapter | Numbers printed | Consistent? |
|--------|-----------------|-------------|
| Ch.2 (picture) | mult 10; buy 1 @ 995.00; prints 1000.00/990.00/1005.00; cum VM 100 = PnL | ✓ |
| Ch.3 (objects) | buy 1 @ 995.00; mult 10 | ✓ |
| Ch.5 (contracts) | mult 10; @ 995; prints 1000/990/1005; VM +50/−100/+150; cum +100 = (1005−995)×10 | ✓ |
| Ch.6 (homes) | mult 10, USD, STM; VM 50; closes 1000/990/1005 | ✓ |
| Ch.7 (valuation) | mult 10; @ 995; prints 1000/990/1005; VM +50/−100/+150; cum 100 = (1005−995)×10 = PnL | ✓ |
| Ch.9 (collateral, D5) | mult 10; day-1 1000.00, day-2 990.00; (1000−990)×10 = 100; CTM adds one return-obligation unit valued at 100 | ✓ |
| Ch.11 (settlement) | mult 10; @ 995.00; day-2 990.00 = −100; cum 50−100+150 = 100 = PnL | ✓ |
| Ch.14 (invariants) | mult 10; @ 995; 1000/990/1005; +50/−100/+150; cum 50−100+150 = 100 = (1005−995)×10 | ✓ |
| Ch.15 (testability) | closes 1000/990/1005; mult 10; cum +50−100+150 = 100 | ✓ |

**T1 CONSISTENT.**

### T2 — OT-1 (one-touch). Owner MINSKY. Frozen: OMEGA spot 95.00; barrier 80.00 touch-at-or-below; payout 1,000,000; premium 350,000; marked 400,000 pre-knock; 50% → collateral 200,000 vs exposure 150,000; knock close 79.00; discharge 850,000 free + 150,000 posted.

| Chapter | Numbers printed | Consistent? |
|--------|-----------------|-------------|
| Ch.2 (picture) | spot 95.00; barrier 80.00; payout 1,000,000; knock close 79.00 | ✓ |
| Ch.3 (objects) | barrier 80.00 touch-at-or-below; payout 1,000,000 | ✓ |
| Ch.4 (machines) | payout 1,000,000; barrier 80.00; close 79.00 | ✓ |
| Ch.5 (contracts) | payout 1,000,000; barrier 80.00; close 79.00 | ✓ |
| Ch.7 (valuation) | barrier 80.00; payout 1,000,000; marked 400,000 → 0 | ✓ |
| Ch.9 (collateral) | payout 1,000,000; marked 400,000; 50%; collateral 200,000 vs exposure 150,000; barrier 80.00; close 79.00; discharge 1,000,000 W-BANK→W-ALPHA, 150,000 posted, 850,000 free; coverage 1,000,000 ≥ 150,000 | ✓ |
| Ch.12 (reporting) | payout 1,000,000; marked 400,000; 50%; 400,000×50% = 200,000 vs 150,000; close 79.00, barrier 80.00; triggered price 0 | ✓ |
| Ch.14 (invariants) | payout 1,000,000; marked 400,000; 50%; collateral 200,000 vs 150,000; close 79.00 ≤ 80.00; discharge 1,000,000 / 150,000 / 850,000; coverage 1,000,000 ≥ 150,000 | ✓ |
| Ch.15 (testability) | payout 1,000,000; marked 400,000; 50%; collateral 200,000 vs 150,000; close 79.00, barrier 80.00 | ✓ |

Premium 350,000 and spot 95.00: premium is never restated in any chapter (spot 95.00 only in Ch.2). Absence, not a fork — no chapter prints a conflicting value. **T2 CONSISTENT.**

### T3 — dividend (ACME). Owner KARPATHY. Frozen: price 100.00; 10,000 shares; 1.50/share; announce 2026-05-04, record 2026-05-15, payment 2026-05-22; entitlement 15,000.00.

| Chapter | Numbers printed | Consistent? |
|--------|-----------------|-------------|
| Ch.4 (machines) | announce 2026-05-04; 1.50/share; record 2026-05-15; payment 2026-05-22 | ✓ |
| Ch.5 (contracts) | 2026-05-04 announce; 2026-05-15 record, 10,000×1.50 = 15,000.00; 2026-05-22 pay 15,000.00 | ✓ |
| Ch.6 (homes) | 2026-05-15 record; 10,000 ACME; 10,000×1.50 = 15,000.00 | ✓ |
| Ch.8 (marketdata) | 2026-05-04 announce; 1.50 → 0.75 under split | ✓ |
| Ch.9 (collateral) | 10,000 ACME; 1.50/share; entitlement 15,000 | ✓ |
| Ch.11 (settlement) | 10,000 ACME; 1.50; record 2026-05-15; payment 2026-05-22; entitlement 15,000; gap micro-example dates 2026-05-14/15/16/22 all consistent | ✓ |

Stale `2026-05-29`: **absent from every file** (grep returned nothing). Payment date is 2026-05-22 everywhere. **T3 CONSISTENT.**

### T4 — split (ACME). Owner NAZAROV. Frozen: 2-for-1 effective 2026-06-01; 10,000→20,000; frame 100.00→50.00; dividend 1.50→0.75; proportional stand.

| Chapter | Numbers printed | Consistent? |
|--------|-----------------|-------------|
| Ch.3 (objects) | 2026-06-01; 2-for-1; 100.00→50.00; 1.50→0.75; 20,000 shares | ✓ |
| Ch.6 (homes) | 2026-06-01; 2-for-1; 100.00 read as 50.00 | ✓ |
| Ch.8 (marketdata) | 2026-06-01; 2-for-1; spot ×½ 100.00→50.00; cash div 1.50→0.75; proportional stand; 10,000→ (paired-leg); witness 10,000×100 = 20,000×50 = 1,000,000 | ✓ |
| Ch.11 (settlement) | two-for-one 2026-06-01; 100.00→50.00; 1.50→0.75; proportional stand; 20,000 vs fresh 50.00 | ✓ |
| Ch.13 (cdm) | corporate-action event representation (no conflicting figure) | ✓ |
| Ch.14 (invariants) | 20,000 × stale 100.00 = phantom 2,000,000 vs true 1,000,000 — refused | ✓ |

**T4 CONSISTENT.**

### T5 — VS-1 (variance swap). Owner GATHERAL. Frozen: 252 fixings; strike 400; notional 1,000/point; fixing 126 A_126 = 1,805,000 (scale 10⁻⁸); fixings 124/125/126 = future days, close@126 = 1,005.00; realised 441; settlement 1,000×(441−400) = 41,000.

| Chapter | Numbers printed | Consistent? |
|--------|-----------------|-------------|
| Ch.2 (picture) | 252 fixings; strike 400; 1,000/point; realised 441; settlement 41,000 | ✓ |
| Ch.3 (objects) | 252 fixings declared; strike 400; 1,000/point | ✓ |
| Ch.5 (contracts) | 252 fixings; firing k finds 1..k−1 | ✓ |
| Ch.6 (homes) | fixing 127; A_126 = 1,805,000 (integer, scale 10⁻⁸); close@126 = 1,005.00; fixings 124/125/126 closes 1000/990/1005 | ✓ |
| Ch.7 (valuation) | 252; strike 400; A_126 = 0.018050 (= 1,805,000 @ 10⁻⁸); fixings 124/125/126; close@126 = 1,005; realised 441; 1,000×(441−400) = 41,000 | ✓ |
| Ch.13 (cdm) | 252; strike 400; 1,000/point; realised 441; 1,000×(441−400) = 41,000 | ✓ |
| Ch.15 (testability) | replay firing 127: accrue(close@126 = 1005, A_126 = 1,805,000) → A_127 | ✓ |

**T5 CONSISTENT.** (Mid-life value V_126 = 22,500 in Ch.7 is a Phase-3 GATHERAL figure, not a frozen number; A_126 = 1,805,000 is frozen and matches.)

### T6 — TRS-1. Owner KARPATHY. Frozen: notional 10,000,000; financing 4% quarterly = 100,000/qtr; inception NAV 10,000,000; first reset NAV 10,300,000 → TR leg 300,000, financing 100,000, net 200,000 payer→receiver; reference resets to 10,300,000.

| Chapter | Numbers printed | Consistent? |
|--------|-----------------|-------------|
| Ch.2 (picture) | notional 10,000,000; 4% quarterly; first reset NAV 10,300,000 | ✓ |
| Ch.7 (valuation) | reference leg = NAV projection of W-QIS; stamped NAV observation | ✓ |
| Ch.8 (marketdata) | first reset; V-1 level stamped 10,300,000 | ✓ |
| Ch.10 (virtual) | notional 10,000,000; 4% p.a. Δt = 0.25; inception NAV 10,000,000; TR leg 10,300,000−10,000,000 = 300,000; financing 10,000,000×4%×0.25 = 100,000; net 200,000; reference 10,000,000→10,300,000 | ✓ |
| Ch.13 (cdm) | notional 10,000,000; 4% quarterly; reset NAV 10,300,000; TR leg 300,000 vs financing 100,000; net 200,000 | ✓ |

**T6 CONSISTENT.**

---

## Couplings

| Coupling | Check | Result |
|----------|-------|--------|
| Dividend ↔ split, one issuer ACME | 1.50 scales to 0.75 under 2-for-1; spot 100.00→50.00 | Ch.8 and Ch.11 both show 1.50→0.75 with 100.00→50.00; witness 10,000×100 = 20,000×50 = 1,000,000. CONSISTENT, not forked. |
| Varswap ↔ future, one IDX close series | fixing 126 close = future day-3 settlement = 1,005.00 | Ch.6 and Ch.7 both state fixings 124/125/126 = future days, closes 1000/990/1005, close@126 = 1,005.00. CONSISTENT, not forked. |

## Ch.8 illustrative tickers (must carry NO thread numbers, no collision)

| Ticker | Context | Thread number? | Collision with frozen cast? |
|--------|---------|----------------|-----------------------------|
| HELIOS / LUMEN | spin-off (Recompose), 120.00 → stub 90.00 + LUMEN 30.00, 1,000 holder | none | none — distinct from ACME/OMEGA/IDX |
| TARGET / ACQUIRER | elective merger, 50.00 cash or 0.4 ACQUIRER @ 125.00, 1,000 holder | none | none — distinct from frozen cast |

Both are marked "Illustratively"; figures are local to the mechanism examples and reuse no frozen thread number.

---

## Non-fork observations (do NOT break number continuity)

1. **T5 × Ch.11 visit promised but not drafted.** phase2_toc_proposal.md §3 (T5 Visits)
   states "Ch. 11: the final 41,000 projects to one cash instruction," but Ch.11 as drafted
   contains no variance-swap episode (its own thread list in §1 names dividend/future/split
   only — the proposal is internally inconsistent between §1 and §3). The 41,000 figure is
   printed consistently wherever it does appear (Ch.2, Ch.7, Ch.13: 441 points, 1,000×(441−400)
   = 41,000). This is a coverage gap, not a number fork; no chapter prints a conflicting
   41,000. Flagged for the committee, not a continuity break.

2. **Ch.7 dual-valuation example** (3,000 units of generic "U" at venue closes
   100.20/100.00/99.60; NAV 300,100 vs 300,000) uses a generic ticker, not a thread cast
   member; no collision.
