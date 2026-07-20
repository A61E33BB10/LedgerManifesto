# Backtesting amendment — drafting note (THORP, co-lead with KLEPPMANN)

Two amendments produced, 2026-07-20, from the three binding memos (KLEPPMANN split,
GATHERAL MDM extensions, JACOBI functionals). House voice, principles only, no engine
design. Both compile `pdflatex ×2` exit 0, no overfull/undefined.

## Documents

| Document | Precedent | Result | Grant | Consumed |
|---|---|---|---|---|
| `MarketData/MarketDataManifesto_1.2.tex` | copy of 1.1 (1.1 untouched — certified versions get successors) | 9 pp | +2 (from 8) | **+1** (1 pp spare) |
| `Valuation/ValuationManifesto_1.0.tex` | amended in place (its precedent) | 17 pp | +2 (from 15) | **+2** (at cap, no margin) |

## Placement map

**MDM 1.2 — three clause extensions, no new MD-n (GATHERAL's design):**
- **MD-4** += served history (M1): the two coordinates ranged over a recorded interval, read
  as-known (default as-at pinned to historical as-of ⇒ look-ahead structurally impossible);
  completeness by read-back (gap-free, C-14.15), exactness by the read-back/re-derive split
  (re-derivation only where the model is retained, MD-6). **D3 home:** "the observation, its
  cut, its frame, and its recorded bound model stand on the record as they then stood (MD-6,
  MD-13, MD-15) — the single home of 'the model as it was.'" Trace += C-14.15.
- **MD-11** += stressed history (M2): a simulated path branched from a historical cut, the
  shift its seed; "what happened" = identity shift, "what could have happened" = any other,
  symmetric; coordinates = historical cut + declared recorded shift, both recorded ⇒ replays.
- **MD-13** += horizon-agnostic operator algebra (M3): ex-date boundary, delivery-frame
  discipline, terms-resolved all hold through the backtest horizon; **one pointer** to the VM's
  sandwich ("stated once there").
- **§4** += one sentence: the backtest object is the Valuation Manifesto's (MDM grants the data
  side; chain + comparison are the VM's).
- **Amendment record — Version 1.2** added; 1.1 record untouched.

**VM (Part A) — one new article + two touches:**
- **VM-11 (new, after VM-10, before §3):** strategy-as-unit (cites C-10.2 verbatim-in-spirit +
  C-7.2 ProductTerms + C-2.6/C-6.4 behaviour-is-contract); backtest = strategy unit run through
  a trajectory ⇒ ordinary VM-3 chain (VM-1/VM-4/VM-7/VM-9, same pure function/certificates/proofs
  as production); **chain separation** (VM-10, D1 guard — lives here); the **two functionals**
  (JACOBI: A(C) convention-independent terminal; Σ(C;π,D,ν) with three declared-recorded terms,
  auditable-change parity with VM-5/VM-6); **comparison validity** (identical lineage sets but for
  the strategy unit — a decidable check; non-identical ⇒ invalid by definition, the VM-2 analogue;
  the comparison a dispute-ready projection over two chains, VM-8); the **exotic-is-easy** claim
  derived (contracts already run on simulated paths; marginal cost = declare the unit + name the
  trajectory).
- **VM-10 touch:** the generalisation (V-c thesis) — the recorded shift may be the identity (what
  actually happened) over a past cut ⇒ historical world is a derived world; one doctrine covers
  risk report / scenario / backtest. Trace += C-12.1 (Time travel).
- **Abstract touch:** "ten articles" → "eleven articles"; one clause announcing the backtest.
- **PARK-1 and all Part B byte-stable** (verified: PARK-1 + "materialised projection" intact).

## Cross-reference pairs established (each side one pointer; no sentence twice)

1. **VM-11 → MDM (MD-4, MD-11, MD-13):** one consolidated pointer — "the served or stressed
   history the Market Data Manifesto makes replayable, gap-free, and frame-correct through the
   horizon." The VM never describes how the past world is reconstructed.
2. **MDM §4 → VM:** the backtest object (chain + comparison certificate) is the Valuation
   Manifesto's. The MDM never describes the strategy or the chain.
3. **MDM MD-13 → VM:** the ex-date sandwich "is the Valuation Manifesto's, stated once there."
4. **VM-11 → C-10.2** (strategy-as-unit) **+ C-2.6/C-6.4** (behaviour-as-declared-terms);
   **VM-11/VM-10 → VM-10** (chain separation, generalisation).

## D1–D3 conformance (verified by grep across both files)

- **D1 (separation stated once, VM-only):** MDM has **0** chain-separation statements; the
  "backtest chain in its own path's record, never the real unit's chain" lives in VM-10 (scenario)
  and is *referenced* by VM-11. MDM M2 speaks only of the *trajectory/observation stream* as a
  simulated path, never the chain.
- **D2 ("single non-record input" — one referent per manifesto):** MDM 1 occurrence (original
  MD-11 seed text); VM 1 occurrence (VM-10, scenario shift). No third referent coined; VM-11
  attributes replayability to the MDM's served/stressed history, never re-coins the phrase for
  "trajectory."
- **D3 ("(observation, bound-model) as they were" — MDM-only):** stated once in MDM MD-4 ("the
  single home of 'the model as it was'"); VM has **0** restatements — it references the pairs as
  valuation coordinates via VM-2 and the MDM pointer.

## Unsettled for FORMALIS / TALEB

1. **VM is at the 17 pp cap — zero margin.** Any review addition to the VM overflows the grant;
   flag before requesting VM edits. MDM has 1 pp spare.
2. **JACOBI functionals — notation in a principles doc.** VM-11 carries two closed forms
   (A(C), Σ(C;π,D,ν)). They state *what the two numbers are*, no estimator fixed (D declared);
   FORMALIS to confirm this is illustration-level, not engine design (CLAUDE.md §5).
3. **Comparison validity as a "named validity failure."** VM-11 declares a comparison at
   non-identical coordinates *invalid by definition* (the VM-2 analogue). FORMALIS/CONCORDIA to
   confirm the record-refusal framing is consistent with VM-2 and does not over-reach.
4. **TALEB (comprehensibility):** VM-11 is dense (strategy-as-unit + two functionals + validity
   in one article). A worked one-line backtest example (a simple strategy over a short historical
   trajectory) could be added to §3 "Life of a Valuation" — but that spends page budget the VM
   does not have; deferred pending a cap decision.

## Review pass — FORMALIS SIGNED, KLEPPMANN split-conforms, TALEB gate PASS (2026-07-20)

FORMALIS signed all five duties (functionals = illustration per §5; convention-independence of
A true; comparison-validity decidable and seated on VM-2; strategy-as-unit citations
verbatim-correct; MDM extensions derive not assert; PARK-1 + Part B byte-stable by git diff).
KLEPPMANN: no split deviation. TALEB: gate PASS both docs, one material + minors. Light pass
applied, VM held at 17pp by tightening (para 1 + closing para) to fund the additions:

- **MATERIAL — survivorship (VM-11, new 2-sentence para):** look-ahead is structural (MD-4);
  survivorship is NOT — the instrument universe is a declared term of the strategy unit, resolved
  by the strategist. As-known (units in force at each historical cut, delisted included, on the
  append-only record) it is unbiased; today's-survivors it is biased and the structure cannot
  detect it. The record makes the universe declaration auditable (on the chain's coordinates) but
  "cannot police its wisdom: 'look-ahead cannot arise' is not 'bias cannot arise.'"
- **F-min-3 (VM-11):** "no harder" scoped to \emph{specification}; compute disclosed as one
  production valuation per step, exotic per-step pricing unchanged (VM-10) — "specification easy,
  never the pricing."
- **F-min-1 (MDM §4):** reconciled per the split — the VM owns the comparison term, so MDM §4 now
  attributes generically ("the comparison of the chains it produces"), dropping the over-specific
  "realised world against a counterfactual" (world axis the VM doesn't develop).
- **F-min-4 (VM-11):** "world state" pinned at first use ("the market-data state at one historical
  cut, the observations then in force in their frame").
- **F-min-6 + FORMALIS note 2 (VM-11):** dispersion rule D given its example ("standard deviation
  of the increments — the manifesto fixing none"); ν glossed ("the annualisation").
- **FORMALIS note 1 (VM-11):** "a named validity failure the record refuses" → "the record yields
  no valid comparison" (exact — comparisons are projected, not door-admitted).

Not applied (not in coordinator's list / TALEB-deferred): F-min-2 (MDM "a backtest is…" deferral),
F-min-5 (non-valued-unit-vs-portfolio — partially folded into the tightened para 1), and the
worked backtest example (TALEB ruled NOT material; VM at cap). Final: MDM 1.2 = 9pp, VM = 17pp;
both pdflatex ×2 exit 0, no overfull/undefined; PARK-1 and Part B byte-stable.
