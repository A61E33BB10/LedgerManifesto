# Feedback Disposition — v12.0 accessibility & organisation pass

Each external-review item is weighed and marked **adopt** / **adapt** (a better form of the
same intent) / **decline** (with reason). The review is advice, not instruction; nothing is
applied mechanically.

## Organisation

| # | Review item | Disposition | Decision & reason |
|---|-------------|-------------|-------------------|
| O1 | Group sections + appendices under 5–6 `\part` blocks | **adapt** | Adopted as **6 substantive parts + an Appendices part** (7 `\part` total). The review's partition is refined to satisfy the dependency graph: SBL (sec16) hard-depends on obligation liveness (sec14), settlement (sec12) on implementation (sec11), and the invariant catalogue (sec15) on both sec14 and sec16. The seed partition broke two of these; the adopted one does not. See `coverage_map.md`. |
| O2 | "Roadmap and Reading Guidance" after the abstract | **adopt** | Added as front matter: maps the three title pillars (architecture, lifecycle, CDM) to the parts and gives each audience (regulator / implementer / quant / risk manager) a minimal reading path. |
| O3 | "Key Concepts and Terminology" compact glossary after the abstract | **adopt** | Added as front matter — a curated ~20-term orientation list, each a one-line plain gloss with a forward pointer to its formal definition and to the authoritative Glossary (Appendix E). The two are explicitly distinguished (compact = orientation; appE = authoritative). |
| O4 | End each major part with a "Key Invariants and Consequences" summary | **adopt** | Added to the four invariant-establishing parts (I, II, III, V). Result-first restatement with a pointer to each proof and to the consolidated catalogue (sec15). Reinforcement, not repetition. |
| O5 | Early high-level diagrams (overview, conservation, three-home data flow, lifecycle machine) | **adopt** | All four added, each with an over-claiming guard from the reading-path review: projection arrows are one-directional (no reconciliation arrows between views); conservation governs *quantity, not value*; the 2×2 home table is NOT rendered as a categorical product/pullback; the lifecycle machine is per-unit-type, not global. |

## Style and accessibility

| # | Review item | Disposition | Decision & reason |
|---|-------------|-------------|-------------------|
| S1 | Progressive disclosure (gloss → formal → consequences) at first use | **adopt** | Applied as a three-beat at the first use of ~16 major concepts, beats visually separable so a reader can stop after the gloss. First-use homes are enumerated in `coverage_map.md`. |
| S2 | Shorter sentences for rationale and derived properties; one claim per sentence | **adopt** | Applied to design-rationale and derived-property prose only. Every invariant, type statement, theorem, and listing is left verbatim (correctness veto). |
| S3 | Expand every acronym / non-obvious term on first occurrence | **adopt** | Swept document-wide (CDM, TRS, PnL, NAV, VM, GMSLA, SBL, SSR, NAV, CSD, …), even where a full treatment follows later. |
| S4 | One-page non-technical preface for business/regulatory readers | **adopt** | Added before the abstract. Plain, not colloquial. The abstract remains the technical gateway. `finops-architect` confirms the operational claims are accurate and not overstated. |
| S5 | (chris-lattner) Split sec04 so the twelve conditions / UnitStatus-as-projection do not land before lifecycle/replay (sec07) justify them | **adapt** | The risk is real, but fragmenting the central design section across the document harms the implementer who wants the whole state model in one place, and endangers its internal cross-references. Adapted: sec04 is kept whole, given a gloss-first progressive-disclosure head, and its UnitStatus-as-projection claim carries an explicit forward link to the idempotent-replay justification (sec07), with a backward link added there. Same pedagogical intent, lower structural risk, no rigour moved. |

## Category-theoretic formalism

Governing rule (carried forward): a framing appears only if **(a)** exactly true — `formalis`
verifies independently — and **(b)** it makes the idea clearer than plain language would
(`milewski`). The core ideas remain fully legible with every categorical reading skipped.

| # | Review-suggested framing | Disposition | Decision & reason |
|---|--------------------------|-------------|-------------------|
| C1 | Instruments as morphisms | **decline** | Category error. An instrument (`ProductTerms`, a registered unit) is *data* — an object/value, not an arrow. The state→state arrow is the `Transaction` via `applyTx`, not the instrument. The true adjacent fact is captured by C-adopt-3 (replay). |
| C2 | Moves as arrows in a monoidal category; conservation as tensor/identity | **decline** | Analogy, not literal. Moves combine by list concatenation (a free monoid); there is no nameable tensor ⊗ with conservation as its unit. The true structure is the group homomorphism C-adopt-1. |
| C3 | Lifecycle transitions as functors | **decline** | Type error. A transition is an *arrow* in the four-stage preorder, not a functor (which maps a whole category). `Lifecycle` is an enum; "functor" here is decoration. |
| C4 | Conservation as a natural transformation | **decline** | Over-reach. There is no functor pair and no naturality square. Conservation is a group homomorphism whose image is the identity — stated as C-adopt-1. |

**Adopted true framings** (each *REQUIRES FORMALIS SIGN-OFF* before entering prose; each
carries an immediate plain reading and is presented as an optional lens):

- **C-adopt-1 — Conservation as a group homomorphism.** The composite `[Move] → Balances → Qty`
  (column-sum per unit) is a homomorphism into the additive abelian group `Qty`, and it is the
  constant-`mempty` homomorphism: `netDelta`/`unitDelta` land at zero by the monoid laws, not
  by a runtime check. Home: sec02 / invariant P1. *(Largely already present in sec02/sec15;
  elevated and given its plain reading.)*
- **C-adopt-2 — A projection is a fold of the log; the balance projection is a monoid
  homomorphism.** `balances = foldMap contribution : [Move] → Balances` satisfies
  `balances (xs<>ys) = balances xs <> balances ys`; every view (balances, valuation,
  UnitStatus) is a fold of the one event stream. Home: sec10 headline; sec04 generalisation.
- **C-adopt-3 — Replay as a monoid homomorphism (the spine the review's C1/C3 were reaching
  for).** `replay` maps the free monoid of events `([Transaction], <>, [])` into the monoid of
  state-transitions (Kleisli arrows of `Either LedgerError`, `>=>`, `Right`), so
  `replay (xs<>ys) = replay xs >=> replay ys`; determinism and checkpoint-independence are one
  consequence of the homomorphism law. Home: sec04 / sec07, invariant P8.

Optional, local-only (used only if it clarifies its own section, not part of the spine):
`forget : BusinessEvent → CdmTransaction` move-extraction is a monoid homomorphism (sec13);
UnitStatus read identically by all holders is a Reader/environment (sec04).

## Standalone & correctness (carried forward, non-negotiable)

- The document references no prior version, presupposes none, and does not mention this review.
  The version-to-version changelog is an author-facing artifact only.
- No reorganisation or rewrite weakens a type, invariant, conservation law, reproducibility
  guarantee, or regulatory reference. `formalis` holds the veto.
