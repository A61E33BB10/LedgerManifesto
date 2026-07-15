# Coverage Map — v11.0 → v12.0

Every v11.0 element lands in **exactly one** v12.0 home. Reorganisation loses nothing and
duplicates nothing. To be signed by `minsky` and `jane-street-cto`.

The body stays in its current numeric order except **one** strictly-improving relocation:
sec15 (invariant catalogue) moves to the Part VI capstone, after sec16 — turning its
references to sec14/sec16 invariants from forward into backward references.

## Part structure (7 `\part` blocks; 6 substantive + appendices)

| Part | Title | Sections (in reading order) |
|------|-------|------------------------------|
| I | Foundations: The Closed System and Conservation | sec01, sec02, sec03 |
| II | The Three-Home State Model and `UnitStatus` | sec04 |
| III | Valuation, Contracts, and Instrument Lifecycles | sec05, sec06, sec07, sec08 |
| IV | Accounts, Reporting, Settlement, and CDM Integration | sec09, sec10, sec11, sec12, sec13 |
| V | Obligations, Generalised Positions, and Securities Lending | sec14, sec16 |
| VI | Formal Properties, Limitations, and Context | sec15, sec17, sec18, sec19, sec20 |
| VII | Appendices | appA, appB, appC, appD, appE, appF, appG, appH, appI |

Count: 3+1+4+5+2+5+9 = **29 files**, each in exactly one part.

## Dependency constraints satisfied (definitions-before-use)

- sec02 (Move, conservation) and sec04 (three homes) precede every consumer. ✓
- sec14 (obligation liveness) precedes sec16 (SBL rests on it). ✓
- sec11 (implementation) precedes sec12 (settlement cites it). ✓
- sec08 (futures) precedes sec13 (CDM cites it). ✓
- sec15 (catalogue) follows sec14 and sec16 (now backward references). ✓

## Section → part (no section lost or duplicated)

| File | Title | v12.0 home |
|------|-------|-----------|
| sec01 | Purpose, Scope, and Properties | Part I |
| sec02 | The Closed Ledger System | Part I |
| sec03 | The Unit Store | Part I |
| sec04 | Where Unit State Lives: The Three-Home State Model | Part II |
| sec05 | Portfolio Valuation and PnL | Part III |
| sec06 | Smart Contracts as Move Generators | Part III |
| sec07 | Lifecycle Management | Part III |
| sec08 | The Futures Lifecycle | Part III |
| sec09 | Managed Accounts, Virtual Portfolios, and TRS | Part IV |
| sec10 | Balance Sheet Substantiation and Dual Valuation | Part IV |
| sec11 | Implementation and Operations | Part IV |
| sec12 | The Settlement Layer Interface | Part IV |
| sec13 | ISDA CDM Integration | Part IV |
| sec14 | Orchestration and Obligation Liveness | Part V |
| sec16 | Generalised Positions and Securities Borrowing and Lending | Part V |
| sec15 | Invariants, Conservation Laws, and Property-Based Testing | Part VI (relocated) |
| sec17 | Regulatory Obligations and the Direction of Travel | Part VI |
| sec18 | Scope and Limitations | Part VI |
| sec19 | Conclusion and Open Problems | Part VI |
| sec20 | Frequently Asked Questions | Part VI |
| appA–appI | (nine appendices) | Part VII |

## New v12.0 elements → home (added content, nothing displaced)

| New element | Home | Owner |
|-------------|------|-------|
| Non-technical preface (1 page) | Front matter, before abstract | stylus (finops-architect checks claims) |
| Roadmap and Reading Guidance + 4-audience reading matrix | Front matter, after abstract | stylus / chris-lattner |
| Key Concepts and Terminology (compact glossary, ~20 terms) | Front matter, after roadmap | stylus / henri-cartan |
| Diagram (a) overview — single source of truth | end of sec01 | dirac / stylus |
| Diagram (b) conservation (quantity, not value) | sec02 conservation-law subsection | dirac / stylus |
| Diagram (c) three-home data flow | sec04, after placement rule | dirac / stylus |
| Diagram (d) lifecycle state machine (per unit-type) | sec07 transition-function subsection | dirac / stylus |
| Key Invariants and Consequences — Part I | end of Part I (after sec03) | stylus |
| Key Invariants and Consequences — Part II | end of Part II (after sec04) | stylus |
| Key Invariants and Consequences — Part III | end of Part III (after sec08) | stylus |
| Key Invariants and Consequences — Part V | end of Part V (after sec16) | stylus |

### Added input files (each `\input` exactly once)

Front matter: `front_preface.tex`, `front_roadmap.tex`, `front_concepts.tex`.
Diagrams: `fig_overview.tex` (sec01), `fig_conservation.tex` (sec02), `fig_threehome.tex`
(sec04), `fig_lifecycle.tex` (sec07). Part summaries: `part1_summary.tex`,
`part2_summary.tex`, `part3_summary.tex`, `part5_summary.tex`.

**Part summaries are deliberately asymmetric.** Only Parts I, II, III, and V — the parts
that newly *establish* invariants — carry a "Key Invariants and Consequences" box. Part IV
(interfaces: accounts, reporting, settlement, CDM) and Part VI (the consolidated catalogue
itself, plus limitations/context) carry none by design; no summary was dropped.

## Major concepts → progressive-disclosure first-use home (three-beat applied once each)

| Concept | First-use home |
|---------|----------------|
| Atomic Move | sec02 |
| Ownership-as-balance / closed system | sec02 |
| Conservation law Σ_w w(u)=0 | sec02 |
| Move stream as sole canonical record | sec02 (glossed sec01) |
| Projection (every view derived) | sec01 / formal sec05, sec10 |
| The three homes | sec04 head |
| UnitStatus-as-projection | sec04 (fwd-link to sec07 replay) |
| State-sufficiency | sec05 (teased sec01) |
| Path-independent PnL | sec05 |
| Lifecycle Value Invariance | sec05 (teased sec01) |
| Contracts-as-move-generators | sec06 |
| Transition function / single door | sec07 |
| Idempotent replay | sec07 |
| Position vector (six-coordinate) | sec16 |
| CDM canonical vocabulary / forgetful map | sec13 |
| Conservation as universal test oracle | sec15 |

## Category-lens insertions → home

| Framing | Home |
|---------|------|
| C-adopt-1 conservation = group homomorphism | sec02 / P1 |
| C-adopt-2 projection = fold; balance = foldMap monoid homomorphism | sec10 headline; sec04 generalisation |
| C-adopt-3 replay = monoid homomorphism (Kleisli) | sec04 / sec07 / P8 |

## Invariants & listings — preserved verbatim

All invariants P1–P23, the twelve conditions C1–C12, every theorem, and every Haskell
listing keep their content unchanged; only surrounding prose is reshaped. The reference
`reference/Ledger.hs` is unchanged in substance. `formalis` confirms no guarantee weakened.
