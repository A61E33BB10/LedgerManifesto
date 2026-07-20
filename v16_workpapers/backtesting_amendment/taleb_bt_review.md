# TALEB — Backtesting Cross-Manifesto Amendment, Gate Review

**Documents:** MarketData Manifesto 1.2 (9pp — MD-4/11/13 extension clauses + §4 cross-ref) and Valuation Manifesto (17pp at cap — new VM-11 + VM-10 touch).
**Readers:** the desk strategist backtesting a hedge for an exotic; the risk manager comparing two strategies.
**Math checked:** A(C) = (V_N−V_0) + Σ F_k telescopes to endpoints + flows (convention-independent total); Σ = ν·D(ΔV_1…ΔV_N) is a deterministic dispersion of the recorded increments over a declared partition — both correct, and Σ's honesty ("a value read off the record, not a statistical estimate; the partition is a coordinate, not a free choice") is exactly right.

---

## 1. Verdict

**Gate: PASS for both documents.** One doctrine is heard across the two, the signposts are precise (article-numbered, both directions), and the division of labour is clean and told once: the MDM owns the *data side* (served history MD-4, stressed history MD-11, horizon-agnostic frames MD-13) and explicitly hands the *backtest object* to the VM; VM-11 owns the object and cites the MDM for the trajectory. **No drift, essentially no double-telling.** The standout strength is that **look-ahead bias is made structurally impossible** (MD-4: as-at pinned to the historical as-of, "not a discipline to remember") — the single most important backtest fragility, killed by construction.

**One MATERIAL finding** — the survivorship asymmetry: the document kills look-ahead *structurally* but is silent on survivorship, which is **not** structural (it depends on the strategist declaring the instrument universe as-known). A confident "look-ahead cannot arise" invites the reader to assume all backtest biases are handled; the one that isn't is the one that most overstates a strategy. Plus a minor cluster.

**Example ruling: NOT material — VM-11 passes without a worked backtest, and I would NOT compress VM-11 to fund one** (reasoning in §4).

**NOT CONVERGED — narrowly.** The material finding and two of the minors (the "no harder" compute scope, the world-state gloss) are one-clause fixes worth a light pass. Nothing structural; both documents are close.

---

## 2. One doctrine, two documents (area 1) — PASS, two minor seams

**Signposts are precise, both directions.** MDM → VM: MD-13 "that sandwich is the Valuation Manifesto's, stated once there"; §4 "The backtest object is the Valuation Manifesto's… governed by the Valuation Manifesto." VM → MDM: VM-11 "the served or stressed history the Market Data Manifesto makes replayable, gap-free, and frame-correct through the horizon (MD-4, MD-11, MD-13)." A reader of *either* document alone knows exactly where the other half lives, and the pointer names the articles. Told-once discipline is honoured (the sandwich; the shift is "the Valuation Manifesto's term").

- **F-min-1 (MINOR — the realised-vs-counterfactual seam):** MDM §4 attributes to the VM "the certificate comparing the realised world against a counterfactual" (a *world* comparison — MD-11's "what happened vs what could have happened"). But VM-11 develops the *strategy* comparison (same trajectory, different strategy unit), and its "invalid by definition" guard is built around that axis — a reader could misread it as *forbidding* the same-strategy-two-worlds comparison MDM §4 says the VM governs. These are two legitimate axes (vary the strategy / vary the world); VM-11 develops one and never names the other, while MDM attributes the other to it. Fix: either MDM §4 attributes generically ("the VM's chain and comparison machinery"), or VM-11 names both axes so the reader sees they belong to one doctrine.
- **F-min-2 (MINOR — double "a backtest is…"):** MDM MD-4 "A backtest is the valuation doctrine read at historical coordinates" and VM-11 "A backtest is a strategy unit run through a trajectory" are two definitional-form sentences across two documents. They are consistent (framing vs object), and MDM defers the object to VM, but the MDM's could defer the *definition* more visibly ("Read at historical coordinates, the valuation doctrine becomes a backtest — the object the Valuation Manifesto defines, VM-11") to remove any whiff of a competing definition.

## 3. VM-11 density (area 2) — the strategist survives it; the "easy exotic" derivation convinces

VM-11 is the longest article, but it is a clean five-step progression — strategy-is-already-a-unit → backtest = that unit through a trajectory → *ordinary* valuation chain → two numbers (A, Σ) → valid comparison → why it's easy — each paragraph one idea. A desk strategist follows it. Para 1 is dense with Constitution vocabulary (smart contract, virtual ledger, non-valued strategy unit) but its takeaway — "a strategy is already a unit… this article specialises it" — lands.

**The "easy for a sophisticated exotic" derivation is convincing as printed, and the marginal cost lands.** It is *derived*, not asserted: the exotic's pricing already runs as a re-entered observation (VM-1), the strategy's rebalancing already runs as a smart contract (C-6.1), and a backtest is the same fold on a historical trajectory — so "the marginal cost of a backtest is only what it adds: declaring the strategy unit's terms and naming the trajectory." That is concrete and believable — the strategist reads it and knows what to do (declare hedge instruments/rules/triggers; name the history).

- **F-min-3 (MINOR — scope the "no harder" claim to specification, not compute):** "no harder for a sophisticated exotic than for a vanilla" is true for *setup/machinery* (the derivation's actual content) but invites a *compute* misread. An exotic backtest reprices the exotic at *every* step of the trajectory — for a Monte-Carlo/PDE exotic over years of daily steps, that is thousands of expensive repricings. VM-10 already discloses per-step reval cost, so the machinery is honest; but VM-11's "no harder" should be scoped — "no harder to *specify*; the compute is one production valuation per step, the exotic's per-step pricing cost unchanged" — so a strategist doesn't expect a heavy exotic backtest to be cheap. This is the desk's own cost-disclosure discipline (VM-10) applied to the ease claim.

## 4. The worked-example ruling (area 3 / THORP flag 4)

**Ruling: the worked backtest example is NOT material to the gate. VM-11 passes without it, and I would not compress VM-11 to fund it.** Reasoning:
1. The hard object — the valuation *chain* — is already worked with numbers in Part A §3 (the AAPL call, the shifted-world column, the digital break). VM-11 states outright that a backtest *is that same chain* across a trajectory, so the chain needs no re-working.
2. The two functionals are self-evident to *both* named readers: A is total P&L (endpoints + flows), Σ is P&L volatility (dispersion of increments). A risk manager reads these formulas at sight; a number would teach almost nothing the formula doesn't.
3. The validity rule ("compare only at identical coordinates; else invalid by definition") is a decidable check, clearly stated in prose.
Given the 17pp hard cap with zero margin and the grant rule forbidding taking from elsewhere, **compressing VM-11's derivation or validity prose (both load-bearing) to buy a number for two self-evident formulas is a losing trade** — it would remove comprehension to add little. If a certifier later insists on the example over my ruling, the only fundable compression *inside* VM-11 is para 1 (the strategy-as-unit restatement is heavily Constitution-cited and already says "this article restates none of that"; it could shrink to a pointer) — but I do not recommend it. VM-11 passes as printed.

## 5. Promise ledger (area 4)

- **"Fairly straightforward to backtest a sophisticated exotic" — delivered honestly, ease DERIVED.** VM-11 para 5 forces it from VM-1 + the same-fold argument, not assertion. Honest on the specification axis; needs the F-min-3 compute-scope clause to not imply computational parity.
- **The comparison promise — unmistakable.** *Two axes:* Absolute performance A and PnL volatility Σ, both stated with formulas. *No side channel:* A "touches no attribution split… convention-independent," and the doctrine keeps no second running total beside NAV (VM-4). *Invalid-by-definition guard:* "compare validly only at identical coordinates… differ in anything but the strategy unit and the comparison measures two worlds, not two strategies; invalid by definition — a named validity failure the record refuses, the exact analogue of VM-2." This is the strongest thing in VM-11 — it kills the apples-to-oranges backtest fallacy *structurally*, and ties it to VM-2 (no coordinates ⇒ not a comparison, as no coordinates ⇒ not a valuation).

## 6. Fragility — what blows up the backtest

### F1 (MATERIAL) — look-ahead is killed structurally; survivorship is not, and the document doesn't say so.
MD-4 rightly makes look-ahead "structurally impossible, not a discipline to remember" — the #1 backtest sin, killed by as-at pinning. But **survivorship bias — the #2 sin — is not structural.** It depends on how the strategist declares the instrument universe: resolve "the constituents" *as-known at each historical cut* (the served-history machinery supports this — dead/delisted units are on the append-only record and were in force then) and survivorship is avoided; declare *today's* survivors as a fixed list and the backtest faithfully runs a survivorship-biased universe. The machinery supports the honest choice but does not *force* it, so unlike look-ahead this is a discipline. The risk: a reader takes the confident "look-ahead cannot arise" to mean *all* backtest biases are handled, and ships a survivorship-biased comparison that overstates the strategy — exactly what makes the risk manager pick the wrong one. **Fix (one clause, in MD-4 or VM-11):** name the asymmetry — look-ahead is structural; a survivorship-free backtest additionally requires the strategy's instrument universe to be resolved as-known, which the served history supports. For a document that proudly kills look-ahead, the silence on survivorship is the first question a backtesting practitioner asks.

## 7. Jargon (area 5) — minor first-use glosses for the desk reader
- **F-min-4 (MINOR) — "world state"** (VM-11) is used as if self-evident. Pin it at first use: "the market-data state at one historical cut — the observations then in force, in their frame" (VM-10's "only the market-data state differs" already implies it; make it explicit where VM-11 first says "trajectory of world states").
- **F-min-5 (MINOR) — "non-valued strategy unit" vs "its hypothetical portfolio"** is a subtle two-object distinction (the rulebook is the non-valued unit; the *portfolio* holds the value) compressed into one clause. A strategist may briefly wonder why the strategy is "non-valued"; one half-sentence would settle it.
- **F-min-6 (MINOR) — "dispersion rule D"** is adequate but would land instantly with an example ("e.g. standard deviation of the increments; ν the annualisation"), turning Σ into the realized annualized P&L vol the reader already knows.
- *trajectory* (glossed by apposition ✓), *functional* (VM-11 wisely says "a function of the chain," not jargon ✓).

## 8. What I'd require before this ships
1. **F1** — name the look-ahead/survivorship asymmetry: look-ahead structural; survivorship-free requires the universe resolved as-known (served history supports it).
2. **F-min-3** — scope "no harder for a sophisticated exotic" to specification, and note the compute is one production valuation per step (the exotic's per-step pricing cost unchanged).
3. **F-min-1** — reconcile the MDM §4 "realised-vs-counterfactual certificate" with VM-11 (name both comparison axes, or attribute generically).
4. Cheap: pin "world state" (F-min-4); one example for "dispersion rule" (F-min-6); a half-sentence on "non-valued strategy unit" vs its portfolio (F-min-5); defer the MDM's "a backtest is…" definition to VM-11 (F-min-2).

**Strengths worth recording:** look-ahead made structurally impossible; the comparison validity guard kills apples-to-oranges structurally; precise article-numbered cross-references both directions with clean told-once discipline; the "easy exotic" claim genuinely derived from VM-1; the two functionals correct with exemplary honesty (Σ is a record functional, not an estimate; the partition is a coordinate). The amendment inherited this desk's hard-won discipline; the one material gap is a confident structural claim (look-ahead) inviting over-generalisation to a bias (survivorship) that is not structural.

---

# Round 2 — Convergence confirmation

Re-read the changed lines of both documents. All resolved, readably.

- **F1 (survivorship, MATERIAL) — RESOLVED, and it lands.** VM-11 now: "look-ahead is impossible by construction (MD-4), but *survivorship* is not. The instrument universe… a declared term of the strategy unit — resolved as-known (the units in force at each historical cut, delisted names included, all on the append-only record) it is unbiased; declared as today's survivors it runs a biased backtest the structure cannot detect. The record makes that declaration auditable… but cannot police its wisdom: **'look-ahead cannot arise' is not 'bias cannot arise.'**" Precise, honest, and it locates survivorship correctly as a declaration-side residual — better than my ask.
- **F-min-3 ("no harder" scope) — RESOLVED.** "no harder *to specify*… The compute is not thereby cheap — it is one production valuation per step, the exotic's per-step pricing cost unchanged (VM-10); the ledger makes the *specification* easy, never the pricing."
- **F-min-1 (MDM §4 generic) — RESOLVED.** The over-attributed "realised-vs-counterfactual certificate" is gone: "a valuation chain evaluated across a served or stressed history, and the comparison of the chains it produces." No capability attributed that VM-11 doesn't build.
- **F-min-4/6 (glosses) — RESOLVED.** "world state" pinned; dispersion rule exampled ("say the standard deviation of the increments — the manifesto fixing none — and a declared normalisation ν (the annualisation)"). FORMALIS's two wording notes folded.

**Verdict: gate PASS both documents · CONVERGED.** No fresh stall or overpromise; every change narrows or clarifies. From my seat the backtesting cross-manifesto amendment (VM 17pp / MDM 9pp) is ready to ship — one doctrine, two documents, the two canonical backtest sins now both addressed (look-ahead structurally, survivorship named as a declaration-side residual).
