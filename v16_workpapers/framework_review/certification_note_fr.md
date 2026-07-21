# Certification Note — FrameworkReview (final assembly)

**Artifact certified:** `LedgerManifesto/FrameworkReview.tex` → `FrameworkReview.pdf`
(9 pages, `pdflatex` ×2, exit 0, zero errors).
**Date:** 21 July 2026.

This note records who reviewed what, the rounds and independence behind Part II, the divergence
catalogue and its containments, the red-team survival, and the compiled page counts against both hard
caps. It certifies the *assembly*; the substantive content was established and signed by the named
reviewers and committees below, none of whom certified their own work.

---

## Part I — Merged Systemic Review (peer merge)

**Reviewers.** TuringAward (TA — architecture/algorithms), MINSKY (MK — type discipline, illegal
states), FORMALIS (FL — cross-manifesto formal coherence). The three read the Constitution v1.41 +
Market Data Manifesto 1.3 + Valuation Manifesto 1.0 (incl. Part B, PARK-1) as **one composed system**.

**Certification model.** This part is a **peer merge**: the three reviewers are peers and the merge
keeps every attributed position. There is **no CONCORDIA veto by design** — Part I is a review, not a
ratified specification, so no single certifier gates it; the discipline is instead that no finding is
averaged away and every divergence is carried with its author's name.

**Unanimous gravest finding.** All three, independently, ranked the same collision the gravest:
the **MD-16 / PARK-1 / C-4.11 collision** (H1) — MD-16 records a gate decision's computed functionals
and percentiles (each a map from a derived state to a number, hence a *projection* by C-4.11's own
definition) as **stored fields**, while the Valuation Manifesto **parks** the identical act (storing
`σ_prod²`, PARK-1) on the ground that "a projection stores nothing." The three angles converged
(TA: a certified article silently leaning on an unresolved sibling park; MK: "event-outcome" is the
very reclassification PARK-1 refused without the owner — the CLAUDE.md §1 *worse* failure; FL: silent
non-conformance whose blast radius the parking index hides).

**Divergences preserved (6), never averaged.**
1. **H1 remedy** — FL: no amendment needed (ground on MD-11/C-14.15; only the numeric *fields*
   materialise, drop "not a projection"); TA/MK: treat the *whole* recording as materialisation.
2. **C2 prevention severity** — TA: Gate 1 prevents on an *economic* property outside the Transaction
   Executor, a third correctness category C-13 never sanctions (HIGH); MK/FL: MED, MD-16 read as honest.
3. **C3 A5 discharge** — FL: the *discharge claim* is false; FL mitigant: poles are recorded
   diagnostics, so nothing breaks silently (MK corroborates via the VM-10 finite-bump gap).
4. **W3 Gate-2 blind spot** — TA: thin history is a runtime *refusal*; FL (W2): the test's *vacuous
   pass* — the refuse-behaviour must be *shown to fire*.
5. **W4 σ_prod poles** — FL: PE-6's pole treatment is an honest diagnostic; TA: it clashes with VM-7's
   "forbidden" as alarm fatigue — reconciled by exempting degenerate-carry poles from the broken-chain
   class.
6. **C8 world-map family** — three distinct angles held apart (TA: three names for one concept stress
   C-Auth.4; FL: "VM-5 ≡ 𝒟" is containment not identity; MK: a surface's 𝒟 and its vols' per-datum
   dynamics must agree nowhere).

Part I is inserted **verbatim** from `partI_merged.tex` (only sectioning depth adapted); its labels
H1, C1–C8, W1–W7 are self-contained, so no `partI_*.md` memo was needed.

---

## Part II — Temporal Committee consensus

**Committee.** Five independent `temporal-engineer` instances TEMPORAL-1…TEMPORAL-5 (members) with
two veto-carrying referees per round: **FORMALIS** (rigor) and **TuringAward** (architecture + §4
anti-bias). Authors drafted, referees certified; no agent certified its own work.

**Rounds used: 11** (mandate 10–15; consensus permitted only from round 10; declared round 11). Full
round-by-round record at `temporal_committee/round_log.md`. Round 10 did **not** reach consensus
(TuringAward NO — a single testability blocker: the harvest witnessed only the double-admit half of
injectivity); round 11 closed it additively with `prop_noSilentUnderAdmit` plus FORMALIS's three
witness/generator fixes, after which all five members and both referees signed the same round-11 text.

**Independence of the Round-1 proposals — confirmed.** The five members were spawned **simultaneously,
in a single dispatch, before any member produced output**; each received an identical mandate (only its
own identifier and output path differed) and was instructed not to read any other proposal. Because all
five launched before the first write existed, the independence is **structural, not merely requested —
there was nothing to read**. Evidence in the artifacts: the five reached the same core thesis (no second
substrate/door/book; model outputs re-enter through the one door; projections are read-only; the refold
is the single writer's forward-only work) by five separate routes, and *differed* precisely on the real
forks (MD-16 write atomicity, re-mark cadence, value-determinism closure, refuse-vs-flag). Referees were
spawned fresh each round with no authored stake. Attestation on disk:
`temporal_committee/independence_note.md` (present, verified).

**Divergence catalogue: D1–D16** (16 divergences, D11/D12 sharing one bullet), each carried with its
containment. Top divergences and how each is contained:

- **Nondeterministic model outputs (D2/D14/D16)** → the **compute/emit split** (`runModel` memoized,
  `proposeToDoor` a separate typed activity so a recompute-and-propose worker is unrepresentable) +
  **first-admitted-canonical** (canonical-by-first, bit-reproducibility never an admission precondition)
  + the **β bound** (producer-attested reproducibility class; door checks presence only; `β ≤ VM-6`
  checked at consumption as a VM-7 broken chain; totality by type, COVERAGE-β).
- **Workflow versioning (D9)** → **three-axes separation**: orchestration Build-ID; contract economics;
  model/recipe/dynamic/gate terms on the log — the **Build-ID is never in the fold** (I4 axis-non-leak).
- **History limits (D5)** → **continue-as-new carries no workflow state** — only the identifier triple
  `{unitId|lineageId, nodeId, cut}`; marks, states, and verdicts live on the log and rehydrate.
- **Retry vs exactly-once (D10)** → an **atomic unique-key insert at the door** (not check-then-append),
  so exactly-once admission is a total function of the durable log; **identity key = the fact-identity
  3-tuple** `(input-cut, model-version, recipe/dynamic-version)`, seed and numerical-environment out of
  identity, input-cut exact-grained.

**Red-team scenarios S1–S7 — all HOLD.** S4 exactly-once-as-total-function-of-the-log (the root;
S1/S3/S6/S7 reduce to it); S1 refold-atomic; S7 gate-state-atomic; S3 sandwich-carries-no-workflow-state;
S6 log-is-sole-truth (with the honest edge: economic causality is detection-at-audit, not
door-prevention); S2 deploy-is-orchestration-only; S5 three-times-are-recorded-values. Each maps to a
must-fire property in the firing-witness harvest (11 properties, generators named).

**Consensus: unanimous. Minority report: NONE.** All five members SIGN and both referees sign the
round-11 text; the design is Pareto-optimal across correctness, minimalism, simplicity, and (with the
injectivity witness added) testability. No entry demands anything of the Constitution; the parking test
was exercised and came back empty (two residual open items — a producer's β truthfulness, and the load
model sizing CAN cadence and pool sizes — are parked, not swept).

---

## Vocabulary and symbol check

- **β is the sole symbol** for the value-level bound throughout Part II (no ε_repro, τ, or ε variants);
  every use is in math mode. Verified by grep on the source.
- **Fixed component names** held (unit, watch, the immutable log / the log, projection, the door, the
  Transaction Executor, the market data operator, continue-as-new); no synonyms introduced in the
  Part II conversion.
- One pre-existing "per-datum" occurs inside the **verbatim** Part I fragment (a certified upstream
  artifact); left unchanged, as Part I is inserted verbatim and is out of editorial scope for this
  assembly. Flagged here for the record.

---

## Page counts vs the hard caps

| Part | Pages | Cap | Status |
|---|---|---|---|
| Part I (title + abstract + merged review) | 1–4 (ends p.4; Part II starts p.5) | ends by the page 3–4 boundary | **PASS** |
| Part II (Temporal consensus) | 5–9 = **5 pages** | ≤ 5 | **PASS** |
| Total | **9 pages** | ≤ 8–9 | **PASS** |

**Compression applied to hold the Part II cap** (prose-tightening and typographic only — no mapping row,
divergence, invariant, harvest property, or record kind was dropped): Part II set at `\small` with
`\linespread{0.94}`, `\parskip` 0.5 pt, and reduced longtable pre/post spacing; both longtables at
`\footnotesize`, `\arraystretch 1.0`, `\tabcolsep 3pt`; and prose tightened in the thesis, decomposition
(§3), the production/simulation seam, two tall harvest cells, and the closing paragraphs. A `\clearpage`
separates the parts for a clean, measurable split. Two minor overfull-hbox warnings remain in the harvest
table (≤ 45 pt) from unbreakable `prop_*` identifiers in narrow columns — warnings, not errors; the
compile is error-free.

**Certified.** — Final-assembly agent, FrameworkReview mission.
