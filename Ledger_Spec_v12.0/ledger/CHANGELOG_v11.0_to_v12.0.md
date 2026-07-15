# CHANGELOG — v11.0 → v12.0

**Author-facing only. This file is NOT part of the specification and is never `\input` into
the document.** v12.0 reads as a standalone whole that references no previous version.

v12.0 is a reorganisation + accessibility pass over v11.0: the same rigorous content, made
navigable for implementers, quants, risk managers, and regulators, with one correctness fix
surfaced during review. Budget decision: substance wins, no fixed page cap (155 pp).

## Organisation

- Grouped the 20 sections + 9 appendices under **7 `\part` blocks** (6 substantive +
  Appendices). See `coverage_map.md` for the section→part mapping.
- One structural reorder: the invariant catalogue (`sec15.tex`) moved to the Part VI
  capstone, after SBL. Consequence: rendered §15 = Generalised Positions/SBL, §16 =
  Invariants. All cross-references use `\ref`/labels and resolve correctly; the front-matter
  literal section pointers were corrected to the rendered numbering.
- Dependency order preserved (sec02 & sec04 before consumers; sec14 before sec16; sec11
  before sec12; sec08 before sec13; sec15 after sec14 & sec16).

## Added (new content; nothing displaced)

- **Non-technical Preface** (front matter, before the abstract): plain-language problem,
  solution, and the operational meaning of conservation by construction. Scoped to internal
  reconciliation (external/boundary reconciliation against custodians/depositories explicitly
  remains).
- **Roadmap and Reading Guidance** (after the abstract): pillars→parts map + a 4-audience
  reading matrix (regulator / implementer / quant / risk manager).
- **Key Concepts and Terminology**: a compact ~27-term orientation glossary deferring to the
  authoritative Glossary (Appendix E).
- **Four early diagrams**: overview (single source of truth), conservation (quantity, not
  value), three-home data flow, lifecycle state machine — each with over-claiming guards.
- **Four "Key Invariants and Consequences" part summaries** (Parts I, II, III, V).

## Accessibility (prose; no rigour changed)

- Progressive-disclosure three-beat (gloss → formal → consequence) at the first use of ~16
  major concepts.
- Design-rationale and derived-property prose split into shorter, one-claim sentences;
  invariants, types, theorems, and listings left verbatim.
- Acronyms expanded once at first use (CDM, ISDA, FINOS, TRS, NAV, SBL, GMSLA, SSR, SFTR,
  CSD, ISIN, OTC, FX, CLS, QIS, IFRS, US GAAP); redundant re-expansions removed.
- sec04 kept whole but given a gloss-first head; its UnitStatus-as-projection claim now
  forward-points to the idempotent-replay justification (§7).

## Category-theoretic lenses (each FORMALIS-certified, optional, plain reading first)

- **Conservation** = a monoid homomorphism from the free monoid `[Move]` into the abelian
  group `Qty`, identically `mempty` (only the `Balances→Qty` column-sum leg is a *group*
  homomorphism). sec02 / sec15.
- **Projection** = a fold of the log; `balances = foldMap contribution` is a monoid
  homomorphism; `value` is a fold of the materialised state. sec04 / sec10.
- **Replay** = a monoid homomorphism from `([Transaction],<>,[])` into the endo-Kleisli
  monoid of `Either LedgerError`. sec04 / sec07.
- The four review-suggested framings (instruments as morphisms; moves as monoidal arrows;
  lifecycle transitions as functors; conservation as a natural transformation) were
  **declined** as category errors/analogies. See `feedback_disposition.md`.

## Correctness fix (surfaced during review; owner-approved)

- `reference/Ledger.hs` — `value`/`pnl` rescoped from the whole ledger to a `[WalletId]`
  portfolio scope, so the executable matches its wallet-level mathematical definition. The
  whole-ledger valuation is zero by closure (by design); a meaningful valuation is always of
  a chosen real-wallet scope. `sec05.tex` `def:portfolio-value` and the listing restated to
  match. Conservation (P1) untouched; PnL path-independence (P10) and state-sufficiency
  preserved (P10 rescued from vacuity). No other call sites. Details in `signoff.md`.

## Self-containment

- Removed the version label from the `reference/Ledger.hs` header.
- No `v10`/`v11`/"supersedes"/"previous version"/"addendum" tokens remain in any deliverable
  (the C8 `superseded_by` family is current domain vocabulary, retained).
- Removed stray agent working-memory directories duplicated by the v11→v12 copy.

## Verdict

Gate MET after three review rounds (all final reviewers PASS, 0 blocking). Build clean: 155
pp, 0 fatal / 0 undefined / 0 warnings / 0 missing glyphs / 0 overfull > 20 pt.
