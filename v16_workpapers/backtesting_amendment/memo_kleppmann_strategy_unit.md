# Co-lead memo — the semantic half of the Backtesting amendment
**From:** KLEPPMANN (co-lead, event-sourcing / data semantics) → THORP (drafts from this)
**Scope:** strategy-as-unit grounding; the cross-manifesto split (I own this); the comparison doctrine's record-semantics.
**Governing principle:** coin nothing new. Everything below is *derived* from primitives already in force; the amendment makes binding what the existing clauses already imply.

---

## 1. Strategy-as-unit: it is already constitutional (C-10.2), we only make it binding for backtests

**A strategy IS a unit — this is not new, it is C-10.2 verbatim:** "A deterministic strategy is a smart contract whose rulebook is the terms of a (non-valued) strategy unit. The hypothetical portfolio it manages is a wallet in a virtual ledger. Each rebalancing is a recorded transaction triggered by stamped market observations." The amendment restates nothing here; it *cites* C-10.2 and specialises it to backtesting.

**Precisely what a strategy unit is on the ledger:**
- A **unit** (C-3.2) whose **ProductTerms** (C-7.2 — immutable, append-only terms versions) *declare* the hedge instruments, the rebalancing rules, and the triggers (watches). Behaviour is **contract, not configuration** because C-2.6 fixes "behaviour carried as declared data rather than hidden in code" and C-6.4 makes the contract "a pure, deterministic function of its inputs: the declared terms … the recorded observations, and the visible unit and position state." The rulebook lives in the terms; the same rulebook run twice on the same record gives the same transactions.
- Its **smart contract fires on the trajectory's events exactly as any product contract fires on market events** (C-6.1): a listed option fires on the settlement print; the strategy fires on its rebalancing trigger. The trigger is an ordinary **watch** (C-6.3, C-14.2) on the trajectory's stamped observations; each firing emits a **recorded rebalancing transaction** (C-10.2). What a firing must carry forward (accrued state, last rebalance) lives in its **home** (C-7.4) — no contract remembers.
- Its portfolio is a **wallet in a virtual ledger** (C-10.1 — notional, settles nothing); the strategy's level is that wallet's **NAV**, "a projection computed by the same fold as any other" (C-10.2, C-8.2). No new primitive: unit + ProductTerms + smart contract + virtual-ledger wallet already suffice.

**A backtest run = a simulated path (C-2.8 / MD-11), driven by a recorded trajectory:**
- C-2.8: "simulated paths branched from any recorded state, driven by generated events … The one non-record input of a simulation is the seed, recorded so that every path replays exactly." MD-11: "simulated market data is real market data under a different seed … production is simply the one path whose observations happened to be real."
- A **backtest is that machine** with the strategy unit inside it: a recorded **trajectory of world states** + the strategy's terms ⇒ a replayable run. The **trajectory is the run's single non-record input** (the seed/shift analogue), recorded, so the run replays bit-for-bit.
- **Historical trajectory = the recorded history itself.** A historical backtest needs no separate input stream; it is the strategy unit replayed at past coordinates (time travel, C-12.1) over the observations that actually occurred. A **derived** trajectory is that history under recorded shifts (§2, MDM side) — a stressed past.

**Where the backtest chain LIVES — the discipline (VM-10 separation, state it, do not weaken it):**
- The run's output is an **ordinary valuation chain** (VM-3): a valuation every step (VM-1), each proven by a PnL-explain certificate with entry+exit greeks (VM-4). It lives in **that simulated path's own record** — VM-10 in force: a simulated valuation re-enters "into the simulated path's own record, never as a link in the real unit's valuation chain."
- **A backtest never writes the real strategy unit's production chain.** Where a backtest's coordinates coincide with production (the same strategy over the real history), its chain *equals* the production chain **by determinism** (C-2.2), i.e. by recomputation — never a second stored copy that could drift. Every backtest run is its own path with its own record; comparison across runs is §3.

---

## 2. The cross-manifesto split (my design) — sentence-level allocation, one-pointer cross-refs, no duplicated normative sentence

**Rule of allocation:** the **MDM owns the world the strategy runs *through*** (the trajectory of observations/frames/models); the **VM owns the strategy and the chain it *produces*** (valuation, certificate, comparison). One fact, one home; the other side carries a single pointer.

**MDM amendment holds (data-side — reconstructing and shifting the past world):**
- **M-a. Past world-state is replayable at any past coordinate with its (observation, model) pairs exactly as they were.** The observation, its cut, its frame, and its recorded bound-model *lineage* are on the record as they stood (MD-6 complete lineage, MD-13 frame, MD-15 binding, C-12.1 two honest answers). *This is the only home of "the models as they were" — see risk D3.*
- **M-b. Shifts compose with history ⇒ stressed pasts are first-class.** A derived trajectory is the historical observation stream under a recorded shift; shifts compose (MD-11 seed-analogue + MD-13 operator composition). The derived trajectory is itself recorded and replayable.
- **M-c. CA operators and the corporate-action sandwich apply through the backtest horizon.** The market-data operator transports data across every corporate action in the historical span (MD-13); frames re-coordinate through the horizon exactly as in production.

**VM amendment holds (strategy/chain-side — the doctrine and the comparison):**
- **V-a. Strategy-as-unit statement** (the subject of the chain): a strategy is a unit whose ProductTerms declare hedge instruments / rebalancing rules / triggers, its contract firing on the trajectory's events — *stated here, grounded by a pointer to C-10.2 + C-6 + C-7.* The VM is the natural home because the strategy is what the valuation chain is *of*.
- **V-b. A backtest = the strategy unit run through a trajectory, output an ordinary valuation chain**, every step a valuation (VM-1) proven by a certificate (VM-4), transitively-repaired (VM-7), CA-sandwiched (VM-9).
- **V-c. VM-10 generalised (the A5 move): the historical world is a derived world whose shifts are what actually happened — one doctrine covers risk, scenario, and backtest.** Risk = valuation on shifted market data; backtest = valuation on a *trajectory* of shifted (or real) market data; the recipe, the chain, the proofs are identical. This is the amendment's thesis sentence and it is **VM-only.**
- **V-d. The two comparison functionals** (terminal performance; PnL volatility over the product's life), both functionals of the chain, and the **validity condition** (§3) — VM-only.
- **V-e. The chain-separation discipline** (backtest chain in its own path's record, never the real unit's chain) — VM-only, extending VM-10; MDM does **not** restate it.

**Cross-reference pairs (each side exactly one pointer; no sentence appears twice):**
1. **V-b → M-(a,b,c):** "the trajectory of world states the strategy runs through is the MDM's replayable/shiftable history (MDM-amend §M)." VM never describes how the past world is reconstructed.
2. **M-(intro) → V-a:** "what consumes a trajectory — the strategy unit and its valuation chain — is the VM's (VM-amend §V)." MDM never describes the strategy or the chain.
3. **V-a → C-10.2** (constitutional grounding of strategy-as-unit) and **→ C-2.6/C-6.4** (behaviour-as-declared-terms). MDM does not touch strategy-as-unit at all.
4. **V-c → MD-11 + C-2.8** (simulated path = real under a different seed/shift) — one pointer establishing that the historical/derived run is the same machine; the *generalisation to backtest* is stated only in V-c.

**Three likeliest divergence risks (same fact stated twice, then drifts):**
- **D1 — the separation statement ("backtest is separate / never the real chain").** Tempting to assert in both. **Fix:** VM owns chain-separation (V-e); MDM states only that a *derived trajectory* is a separate observation stream (M-b) and points to V for the chain. Never let both say "a backtest is separate from production."
- **D2 — "the trajectory/shift is the single recorded non-record input, so the run replays."** C-2.8 (seed), MD-11 (shift), VM-10 (single non-record input) all gravitate here. **Fix:** MDM owns "shift composes with history ⇒ recorded, replayable derived trajectory" (M-b, data-side); VM references it and says only "the run, so driven, yields a replayable chain" (V-b). Guard the wording "single non-record input" against appearing with two different referents (seed vs shift vs trajectory).
- **D3 — "history replays with its (datum, model) pairs *exactly as they were*."** The bound **model** is simultaneously a *data-lineage* fact (MD-15) and a *valuation coordinate* (VM-2: "the models the price is bound to"). If both manifestos assert "the models as they were," they will drift on whether the model is world-state or coordinate. **Fix (sharpest):** the past **(observation, bound-model) pair as-recorded** is stated **once, in the MDM** (M-a, as recorded lineage); the **VM references it as a valuation coordinate** (VM-2) and states only that the valuation *consumes* those pairs. One pair, two roles, one normative sentence.

---

## 3. The comparison doctrine — how the record *proves* two backtests comparable

**Bit-identical coordinates** = same recorded observations at the same cuts, in the same frames, with the same bound models, over the same trajectory — **differing only in the strategy unit.** Everything but the strategy is held fixed; the strategy is the single varied input, exactly as a greek is a shift in one market input (VM-10).

**The record proves comparability because coordinate/lineage sets are checkable-equal.** Each backtest chain carries **complete lineage** (VM-3 / MD-6): the enumerated set of observations, cuts, frames, and bound models it consumed. Two backtests are **comparable iff their lineage sets are identical except for the strategy-unit terms** — and that identity is a *decidable check on the record* (compare the two recorded lineage sets), not a claim of good faith. Determinism (C-2.2: same coordinates ⇒ identical valuation, to the last minor unit) then makes the **comparison itself dispute-ready** (VM-8): the two comparison functionals are deterministic projections over the two chains; a dispute over the comparison is settled by **replay** — recompute both chains and both functionals from the record — never by argument. The comparison is a projection over two chains, and it reproduces bit-for-bit or it is wrong.

**A comparison at non-identical coordinates is invalid *by definition*** — it measures two different worlds, not two strategies, so its number is not a strategy comparison at all. This lands on the **VM side** (V-d), as the exact analogue of VM-2 ("a valuation carried without its coordinates is not a weaker valuation — it is not one"): a comparison whose two lineage sets differ in anything but the strategy unit **is not a comparison**, and the record *refuses* it as a named validity failure (a recorded diagnostic, never a silent number). Validity is thus a checkable predicate on two lineage sets, and the comparison functionals are defined only where it holds.

---

**Net:** nothing new is coined. Strategy-as-unit = C-10.2; backtest = C-2.8/MD-11 simulated path with the strategy inside; chain = VM-3; separation = VM-10; comparison validity = the VM-2 discipline applied to two lineage sets. The amendment's whole job is to make binding, and to *allocate cleanly*, what six clauses already imply.

---

## As-built verification (KLEPPMANN, co-lead) — MDM 1.2 + VM VM-11

**SPLIT-CONFORMS.** The split held to the sentence.
- *MDM owns the world run-through:* MD-4 served history carries D3's single home ("the observation, its cut, its frame, and its recorded bound model stand on the record as they then stood … the single home of 'the model as it was'"); MD-11 stressed history (what-happened = identity shift, symmetric); MD-13 horizon-agnostic operators + one pointer to the VM sandwich. §4 grants the data side, "the backtest object is the Valuation Manifesto's."
- *VM owns strategy/chain/functionals/validity/separation:* VM-11 = C-10.2 verbatim-in-spirit ("restates none of that; it specialises it"), contract-not-configuration via C-2.6/C-6.4/C-6.1, ordinary VM-3 chain, both functionals as declared-recorded terms (parity VM-5/VM-6), validity as the exact VM-2 analogue over two lineage sets, D1 chain-separation with my determinism-coincidence nuance ("equals the production chain by determinism … never a second stored copy that could drift").
- *Cross-reference pairs match:* VM-11→MD-4/11/13 (one consolidated pointer); MDM §4→VM; MD-13→VM sandwich; VM-11→C-10.2 + C-2.6/C-6.4. No normative sentence appears twice.
- *D1–D3 no semantic drift (read, not grepped):* MDM states the trajectory-as-simulated-path only, never chain-separation (D1); "single non-record input" keeps one referent per manifesto with VM-10→MD-11 the sole pointer, VM-11 never re-coins it for "trajectory" (D2); "the model as it was" is stated once in MD-4, and VM uses the bound model only as a comparison/valuation coordinate, never restating the reconstruction fact (D3).

**No deviation found.** Strategy-as-unit is C-10.2's own doctrine, nothing coined; the chain-separation discipline is exact.
