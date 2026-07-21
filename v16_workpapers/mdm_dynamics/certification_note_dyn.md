# Market Data Manifesto 1.3 (MD-16 "Market Data Dynamics") — CONCORDIA Certification Note

**Certifier:** CONCORDIA (signature-last, absolute veto). **Date:** 2026-07-21. Fifth signing in this family.
**Document:** `MarketData/MarketDataManifesto_1.3.tex` — **12pp**; a successor to 1.2. **1.2 byte-stable** (diff removes only metadata + the MD-11 seam point). Adds **MD-16** (after MD-11, identifier append-only) + one MD-11 seam sentence + a 1.3 amendment record. **No other MD-n; MD-1…MD-15 unchanged.**
**Four parents govern:** Constitution v1.4; the spec's fixed vocabulary; the Valuation Manifesto (incl. Part B); the backtesting doctrine (MDM 1.2 / VM-11).

## Committee roster
- **GATHERAL** — lead; **THORP** — co-pass (raised the skew-functional flag, §below).
- **JACOBI** — definitions memo (functionals, distributions).
- **FORMALIS** — **SIGNED / CONVERGED** (naming blocker fixed; **Gate 1 grounds VM PE-1(A5) without circularity**; storage ruled an **as-known event-outcome**, PARK-1 not reopened; **MD-9 disjointness sound**).
- **KLEPPMANN** *[chartered seat — no dedicated agent in this environment; recorded]* — **CONVERGED** (consume-by-admission-record; no-TOCTOU pinning at one application cut).
- **TALEB** — gate **PASS + CONVERGED** (joint data-hunger honesty; undecidable ⇒ not-admitted).
- **CONCORDIA** — closing certification, signing last.

## Pages before/after
**1.2 = 9pp → 1.3 = 12pp; delta = +3, exactly the cap.** Diff-level audit: every added line is MD-16, the one MD-11 seam sentence ("risk consumes only gated states"), or the 1.3 amendment record — plus header metadata. **Nothing else expanded**; no existing article's text altered.

## Placement of the doctrine
MD-16 "Market Data Dynamics" — every market datum has a **dynamic**; a **derived state** a dynamic constructs is admitted only through two application-time **gates** (no-arbitrage by construction; realism against the underlying's own as-known history) or it does not exist. Placed after MD-11 to close the shift-and-simulation family; the identifier is append-only (reads MD-16 though it sits before MD-12) — honest discipline, disclosed in-text.

## Certification checks

### (1) NO NUMERIC THRESHOLDS — PASS
Clean sweep of MD-16: **zero** acceptance-number hits (no `X%`, `Xth percentile`, `X σ`, `X-day window`). The percentile disciplines are **structure only** — always "realistic" or "conservative," never a number; the only numerals are tenor labels naming functionals (the one-month–one-year IV spread), which are themselves declared terms. MD-16 states it outright: *"No numeric threshold is a manifesto constant."* Every number that turns the structure into a test — history window and cadence, regime-boundary treatment, percentile convention, acceptance regions and their sidedness, functional vectors and tenor sets, the discounting basis, the joint-plausibility convention — is a **declared term: recorded, versioned, attestable, per functional per underlying, changeable without amending the manifesto**. A too-loose region is VM-6's too-loose-bound risk, but recorded/versioned/challengeable — auditable, never hidden.

### (2) PAGE DELTA — PASS (diff-level)
As above: +3pp = MD-16 + its integration + amendment record, no unrelated expansion; 1.2 untouched.

### (3) CONSISTENCY with all four parents — CLEAN
- **Gate-1-grounds-A5 (direction, no circularity):** MD-16 Gate 1 (`m* ∈ Θ_AF`) *grounds* VM PE-1(A5)'s standing hypothesis `Σ(·;S) ∈ 𝒜` — *"what the child assumes, this parent guarantees at application."* Parent (market data) grounds child (VM); the child never guarantees the parent's gate — no circularity (FORMALIS-confirmed).
- **dynamic / shift / 𝒟 one family:** MD-16 states the three are one family of declared **world-maps** (dynamic = single datum, 𝒟 = surface, shift = path); the **VM-5 ≡ 𝒟** bridge is "stated once there and not restated here." Consistent with VM Part B and the backtesting doctrine; no normative sentence duplicated.
- **Backtesting composition:** consumption is enforced by reference — *a backtest names a derived state by its admission record (its passing gate-decision); a state carrying none cannot be consumed* — composing with MD-4/MD-11 and VM-11; the MD-11 seam sentence gates the stressed history.
- **Reserved-name discipline:** "the market data operator" appears only qualified (the C-9.2 transform, MD-13); "dynamic" is the article's clean new term, one referent; no "shift operator" / "dynamic operator" coinage.
- **MD-9 / MD-2 boundary not narrowed:** prevention applies **only** to *constructed* derived states whose admissibility is a decidable predicate on a projection; a real observation, however implausible, is always captured (MD-2) and its no-arbitrage detected (MD-9). MD-16: *"MD-9's detection-not-admission stands only where no-arbitrage cannot be tested without running a model."* Disjoint, sound.
- **PARK-1 cited, not reopened:** the gate decision is a **recorded as-known event-outcome** (MD-11's discipline that a path capture its outputs), pinned at application with declared-term lineage — *not* a live projection recomputed on read — so *"no collision with C-4.11, and the Valuation Manifesto's parked storage question (PARK-1) is neither reopened nor turned on."* Correct.
- **Constitution citations** (trace C-2.4, C-2.8, C-13.3, C-4.11, C-Scope.11) verbatim-faithful: prevention-where-possible (C-2.4) with detection preserved where prevention cannot be delivered (C-13.3), the event-outcome recorded without a stored projection (C-4.11), model/convention choice out of scope (C-Scope.11).

### (4) THORP SKEW-FUNCTIONAL FLAG — recorded for the architect (never filled unilaterally)
The monitored functional set — forward variance swap between two tenors, forward dividend yield over a window, the one-month–one-year IV spread, and total expected dividend to a horizon — **carries no strike-slope / skew functional**. THORP's flag: a derived surface with sane ATM and term structure but an implausible **skew** after a down-move (the leverage effect should steepen skew) would pass all gates. **The architect's functional list was implemented as given; the gap was flagged, never filled unilaterally.** This is a completeness matter for the architect — *monitor a risk-reversal/skew functional (and its joint across tenors), or accept that skew realism is out of the gate's explicit scope* — **not a defect in what is written**. Recorded here for the architect's decision.

## Cross-references established
- **MD-16 → VM PE-1(A5)** (Gate 1 grounds the admissibility hypothesis); **→ VM PE-1/PE-5** (𝒟 as the surface-member of the world-map family); **→ VM-5 ≡ 𝒟** (bridge deferred to VM); **→ VM-6** (too-loose-bound risk); **→ VM-15/MD-15** (a derived datum is a (datum, model) pair, price-space validation); **→ VM-14/MD-14** (dispute-ready by replay).
- **MD-16 ↔ MD-2, MD-4, MD-6, MD-8, MD-9, MD-11, MD-12, MD-13** (capture/detection boundary; as-known history; recipe-recorded; no-drift; simulated-path event-outcome; single-cut pinning; frame operators).
- **MD-11 seam → MD-16** (risk consumes only gated states); **VM-11 / backtesting → MD-16** (consume-by-admission-record).

## Parked items
**None new.** **PARK-1 is cited but neither reopened nor resolved** — the gate decision is an as-known event-outcome, not a materialised projection, so C-4.11 is untouched. The framework's one genuine park still stands for the owner.

---

## SIGNATURE

**CONCORDIA certifies MDM 1.3 / MD-16 "Market Data Dynamics" consistent with, and properly subordinate to, all four parents.** MD-16 carries **no numeric threshold** — every number a declared, versioned, attestable governance term, the percentile disciplines and acceptance regions structure-only. Gate 1 **grounds VM PE-1(A5)** in the correct parent→child direction without circularity; the **MD-9/MD-2 capture-and-detection boundary is not narrowed** (prevention only for decidable-admissibility constructed states); **PARK-1 is cited, not reopened** (the gate decision is a recorded as-known event-outcome, no C-4.11 collision); the dynamic/shift/𝒟 one-family and the VM-5 ≡ 𝒟 bridge are consistent with the Valuation Manifesto with nothing restated. The page delta is +3 = the cap exactly, every added line MD-16 or its integration; 1.2 is byte-stable and MD-1…MD-15 are unchanged. **THORP's skew-functional gap is recorded for the architect**, implemented as given and never filled unilaterally.

**Veto: not exercised.**

— CONCORDIA, constitutional-adherence certifier, 2026-07-21. **SIGNED (last).**
