# The Inheritance Interface for the Valuation Manifesto

GATHERAL to THORP. What the Valuation Manifesto inherits from its two parents —
the Constitution (`ledger_manifesto_v1_4.tex`) and the Market Data Manifesto 1.1
(`MarketDataManifesto_1.1.tex`, MD-1..MD-15) — and must **cite, not restate**;
and the narrow set of primitives it genuinely owns. The child is rated against
both parents; where it conflicts, the parent wins and the conflict is parked.

---

## 1. Inherited from the Ledger (Constitution) — cite, never re-coin

- **The unit and its recorded state.** A unit carries terms, state, contracts
  (C-4.4); value is read from the ledger, `P(u, σ(u))` (C-8.3, C-14.10). The
  manifesto prices units; it never redefines them.
- **As-of / as-at and the three times.** execution=as-of, door=as-at, monitor=
  provenance (C-2.7, MD-4). Every valuation number carries these; do not restate
  the schema, adopt it.
- **The fold and append-only.** State = initial + fold of the log (C-3.1, C-4.8).
  NAV is *a further fold of the same log* (C-1.4, C-8.2) — this is the load-bearing
  inheritance: valuation adds **no store**.
- **Forward repair.** Corrections repair forward, original never overwritten,
  money moves only under authorised compensation (C-12.4). A re-marked value is a
  new valuation, never an edit.
- **Simulation doctrine — CITE, do not re-coin.** C-2.8: *"We live in a simulation:
  production is simply the one path whose events happened to be real."* The
  manifesto's risk doctrine (scenarios and Greeks as shifted paths, §3) deliberately
  echoes this; it must quote C-2.8 and MD-11, not mint a parallel doctrine.
- **The explain item — the composition question.** C-12.6 fixes *explain item* as a
  named line in *the profit-and-loss explain*, attributed to a reordering-refold,
  its causing event, and the segment of its lateness. A valuation PnL-explain must
  **compose** with this, not collide. Clean statement to adopt:

  > There is **one** profit-and-loss explain: a projection that decomposes ΔNAV
  > between two cuts into named, attributed explain items that **sum to ΔNAV**
  > (an identity, residual line named). A reordering-refold item (C-12.6) and a
  > valuation market-factor item are two **kinds** of line under one roof, each
  > attributed to exactly one cause; they never collide because a reordering line
  > names an event's insertion and a valuation line names a market factor's move.
  > The manifesto **extends the explain-item taxonomy**; it does not re-coin the term.

## 2. Inherited from Market Data (MDM 1.1) — the interface

- **(datum, model) binding by lineage (MD-15).** A datum used in valuation is bound
  to the model it prices through, by *recorded lineage* — which model, which version,
  beside the datum. The valuation record's model-binding **is** MD-15's binding; cite it.
- **The snapshot / cut (MD-12, MD-6).** Every input is pinned to its version and *cut*
  (the as-at boundary fixing which observations are in force). A valuation is struck
  at a cut; "mid-update input" cannot arise (MD-8). Reuse *cut*; do not rename.
- **Frames + the market data operator and its algebra (MD-13) — the sandwich's engine.**
  The CA valuation sandwich's frame-jump explanation **IS** MD-13's operator: it
  transports the pre-ex mark from delivery frame F₁ into post-ex frame F₂, at full
  precision, rounded once (C-4.6). Interface: the manifesto **consumes** the operator
  as a projection at read; it never defines a second operator, never a "valuation
  operator" (Auth.4: one name). Derived marks are *recomputed from operator-adjusted
  inputs* (C-9.3, MD-13), never scalar-transported.
- **Price-space validation (MD-15) — the two-way interface, no circularity.** MDM
  validates a datum by pricing back its calibration set (round-trip); the Valuation
  Manifesto **is** that pricing side. State it as two directions of one act, not a loop:
  MDM asks *"does this datum reprice its own calibration set within tolerance?"* (input
  admission); Valuation asks *"what is this position worth given admitted data and its
  bound model?"* (output). The residual is a re-entered observation (MD-9); no datum
  validates against a valuation that consumed it.
- **Dispute-readiness (MD-14) — EXTEND the exhibit list.** MD-14 settles a mark by
  replay, exhibiting datum, provenance, cut, frame, bound model. Valuation **adds** to
  that exhibit list: the **valuation chain** and its **certificates**. Present as one
  more row in MD-14's exhibit — inheritance, not a second replay doctrine.
- **Staleness / lineage discipline — free.** A valuation over stale re-entered inputs
  (a mark whose leg was corrected) is already handled: MD-8/MD-10 make the input's
  staleness flow through lineage and flag the mark stale, standing as an open item for
  re-derivation. The manifesto **inherits** this; it re-coins no staleness rule.

## 3. What Valuation genuinely adds (the owned primitives)

- **The valuation record** = (as-of, as-at, frame, cut, wallet·unit, model-binding) +
  value + greeks. *Definition:* a re-entered observation of a unit's model price and its
  sensitivities, bound to its model. *From:* MD-15 (bound datum) + MD-6/C-14.15
  (model output re-enters as observation) + MD-4 (coordinates).
- **The valuation chain** = the ordered lineage from a mark back through the price
  vector, model binding, and operator-adjusted inputs to the leaf observations.
  *From:* MD-6 (complete lineage) + MD-12 (derivation composes) + MD-14 (replay).
  It **instantiates** MD-6's lineage for the valuation layer; it does not redefine lineage.
- **The PnL-explain certificate** = an attested, exhaustive decomposition of ΔNAV into
  explain items summing to the total, each attributed to one cause. *From:* C-8.4
  (PnL = ΔNAV) + C-12.6 (named explain item) + MD-6 (deterministic projection).
- **The CA valuation sandwich** = value-before(F₁) / operator / value-after(F₂),
  splitting the ex-date mark jump into the operator's **exact** frame re-coordination
  (a zero-PnL identity, 2000×50 = 1000×100, C-11.3) plus any genuine economic PnL.
  *From:* MD-13 (operator/frames) + C-9.3 + C-11.3 (consistency of reference).
- **Derived worlds / shift operators** = a scenario is a **simulated path** in which one
  or more input observations are shifted by a recorded amount; a Greek is the sensitivity
  across the base and shifted paths. *From:* C-2.8 (Simulability) + MD-11 (simulated
  data is real data under a different seed). **Naming caution in §4.**

## 4. Vocabulary discipline

**Fixed names to use verbatim (no synonym):** unit, wallet, balance, move, transaction,
watch, the immutable log, projection, the Event Monitor / Events Executor / Transaction
Executor, smart contract, **the market data operator**, the three homes, virtual wallet,
virtual ledger (Auth.4); observation, **re-entered observation**, frame, **cut**, complete
lineage, execution/monitor/door time, **as-of**/**as-at** (MDM); NAV, PnL, book cost,
mark-to-market (Pᵐᵏ), mark-to-mid (Pᵐᵈ), mid-life valuation, pricing data layer, pricing
stack, previous close, **explain item** / profit-and-loss explain, *reordered*/*restated*
flags (spec v16.1, C-12.6).

**New names it may coin (checked against the fixed set):**
- *valuation record*, *PnL-explain certificate*, *CA valuation sandwich* — clean, no collision.
- *valuation chain* — allowed, but **always two words**; never bare "chain" (the immutable
  log is *hash-chained*, C-4.8 — reserve "chain" from confusion).
- **"derived world" — recommend AGAINST.** It shadows C-2.8/MD-11's fixed *simulated path*
  + *seed*. Use **"scenario = a simulated path under a recorded shift"**, reusing *path* and
  *seed*. And **do not** call the perturbation a "shift **operator**": *the market data
  operator* is a fixed single name (Auth.4, C-9.2) reserved for corporate-action frame
  transforms; a shift is not a corporate action. Coin **"shift"** (a recorded perturbation
  of an observation stream), never "operator".

## 5. Traps (with resolutions)

- **T1 — CENTRAL: is a stored valuation a projection or a re-entered observation?**
  **Both, at two layers — this decides the whole architecture.** A per-unit **model price
  or greek** stored on the record is a **re-entered observation** (MD-15 bound datum;
  lineage; stale if inputs move; the ledger runs no model, C-14.9). The **NAV/PnL and the
  chain assembly** are a **projection**: `NAV = Σ owned·P` is a pure function of ledger
  state (C-8.2), stores nothing, rebuilds from the record. Reconciliation: "valuation is a
  pure function of ledger state" is true of the **projection recipe**; "a valuation
  re-enters as an observation" is true of each **model-priced leg**. No contradiction — the
  projection consumes re-entered observations as **leaves** (MD-12). A directly-observed
  price (a stock quote) enters the same sum as a plain observation. *Resolution: state the
  two layers explicitly on page one; every downstream primitive follows.*

- **T2 — the PnL-explain / reordering-explain collision.** Do NOT create a second explain.
  *Resolution:* one profit-and-loss explain, exhaustive (items sum to ΔNAV, residual named),
  each item attributed to exactly one cause; reordering-refold lines (C-12.6) and
  market-factor lines are disjoint kinds under one roof. Extend the taxonomy; keep the term.

- **T3 — is the ex-date mark jump PnL?** The sandwich tempts a restatement of MD-13 and a
  false "corporate-action PnL." *Resolution:* the operator's frame re-coordination is a
  **zero-PnL identity** (C-11.3 consistency of reference — same value, new coordinates);
  only genuine economics (a special dividend leaving the position) is PnL and earns its own
  explain-item line. **Cite MD-13's operator/algebra and MD-8/MD-10's staleness wholesale;
  restating either is the way this document fails CONCORDIA's inheritance check.**
