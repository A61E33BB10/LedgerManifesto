# TALEB — Market Data Manifesto 1.0, Review Round 1

**Reading as:** a desk quant / market data operations lead, one sitting, no prior exposure to the Constitution.
**Gate:** can they read it in one sitting and come away knowing exactly what is promised and what is demanded — and does the document's confidence ever outrun what it can guarantee?

---

## 1. Verdict

**SEND-BACK (ready-with-fixes) — NOT CONVERGED.** This is a careful, well-argued document and the projection/re-entered-observation split is a genuine piece of thinking. But it does **not** pass the one-sitting gate for the practitioner it names, for two reasons that recur throughout: (a) it leans on Constitution vocabulary — **fold, home, cut** — that the target reader does not own and that is never glossed in plain words; and (b) at every headline it states the **maximal** guarantee ("reconstruction is unconditional", "never stored", "capture everything") and parks the qualifier in the body, so a reader who takes the headlines at face value walks away believing more than the document actually promises. All fixes are surgical additions. None require re-architecture. Six material findings ⇒ this round produces material improvement ⇒ not converged.

---

## 2. Comprehensibility findings (the one-sitting test)

### M1 (MATERIAL) — Three load-bearing words the practitioner does not own, never defined: *fold*, *home*, *cut*.
A market data ops lead reads FP/DB systems, not category theory or this Constitution. These stall them cold:
- **"fold"** — "never a fact the fold may assume" (MD-3), "every derived object downstream refolds" (MD-5), "the initial state plus the fold of all recorded observations" (MD-11). *Fold* is the single most important verb in the document (the whole state model is "initial state + fold of the log") and it is nowhere said in plain words: *replay the log in order, accumulating state.*
- **"home"** — "folded into a home where the contracts that need it can read it" (§1, MD-1). Undefined. The reader has no picture of what a home is or why an observation lands in one.
- **"cut"** — "each pinned to its own version and cut" (MD-6), "evaluated at which version and cut" (MD-12). Never defined — yet *cut* is exactly the as-of/as-at boundary the practitioner needs for the "what did we know when" query (see M6). Leaving it undefined guts the most practically important machinery in the document.
- Lesser: **"moveless"** (abstract, §1) and **"the dotted line that holds the three internal machines"** (MD-3) assume Constitution knowledge. *Moveless* is semi-self-evident; the *dotted line* is not.
**Fix:** one plain-language gloss at first use for fold, home, cut (a clause each). The document already glosses execution/monitor/door time beautifully in MD-4 — do the same for these three.

### M2 (MATERIAL) — "Reconstruction" is ambiguous between *read-back* and *re-derive*, and the ambiguity sits on the headline promise.
The abstract: "Reconstruction from recorded prices is unconditional; reconstruction of a model's own output additionally requires the retained model." A practitioner reads "reconstruction of a model's output requires the model" as **"I can't get my old surface back without the model"** — which is false and alarming. The truth is layered and never stated in the reader's terms:
- A recorded model output *is a recorded observation* (MD-6) → **reading it back is always possible, from the record alone.**
- Re-**deriving** that output from its inputs (proving the surface follows from the quotes) → needs the retained model.
The document uses "reconstruction/reproduction" to mean *re-derive*, but the reader's default is *read back*. This single word-sense collision is on the load-bearing sentence.
**Fix:** pin the sense once — "You can always read back any recorded value, including a model output. What needs the model is re-deriving that output from its inputs." One sentence removes the worst misread in the document.

### M6 (MATERIAL) — The practitioner's daily question — "yesterday's curve *as published yesterday* vs *as I'd recompute it today*" — has the machinery but no usable demonstration.
The concepts are present and correct: MD-4 ("what was known as of a past date, and what is known now about that date"), MD-5 ("the as-known view survives unrewritten beside the corrected one"). But the document never shows the **two queries side by side producing two different numbers.** This is the question behind every P&L dispute and every audit; a practitioner needs to see, concretely, *how you ask for each* and *that they differ.* The worked example (§3) walks correction-forward but stops before showing "Tuesday-as-published = X, Tuesday-as-recomputed-today = Y."
**Fix:** one two-line numeric contrast in §3 (see M8), naming the *cut* that selects each view.

### Minor comprehensibility
- **m9** — "projection" and "derived object" are used in the §1 vocabulary map before MD-6 defines them (forward-ref). Reader meets the term before its meaning. Cheap to reorder or gloss.
- **m10** — "named explain item" (MD-5/10): a quant owns "PnL explain"; an ops lead may not. Half-defined by context. One clause would close it.

---

## 3. Challenge findings (assumptions named and stress-tested)

### M3 (MATERIAL) — MD-8 and MD-6 collide: "never stored, recompute on read" vs "model output re-enters as a *stored* observation."
MD-8: "there is no stored parameter to drift... A derived object is always recomputed from the record — computed when needed and **never stored** — so it cannot lag the record." MD-6: "its output **re-enters as a new observation**" — i.e., a fitted surface's parameters **are stored.** A sharp reader bounces between the two: *which is it — never stored, or stored as an observation?* The intended reconciliation ("a recorded observation is *the record*, not a separate copy beside it that drifts") is real but is **not stated where the collision happens.** MD-8's whole argument works cleanly only for **projections** (two reads of one record); it asserts the conclusion for the model case without making the (different, weaker) argument that model outputs don't drift *because each fit is a new observation pinned to its inputs, never an in-place update.*
- This is also why the **title** "Broken states are unrepresentable" overclaims for the model case: for projections, unrepresentable; for model outputs, the correct claim is "representable but non-drifting by construction."
**Fix:** in MD-8, split the argument explicitly — projections: nothing stored; model outputs: stored as observations, but drift-free because a new fit is a new observation, not a mutation.

### The dumb-smart question MD-8 invites and doesn't answer: *"Nobody recomputes a calibrated surface on every read — everyone caches. Isn't a cache a stored copy that drifts?"*
The document's answer *is* the re-entered observation (a legitimised cache with provenance), but the reader has to assemble it themselves from MD-6 + MD-8. Say it: a cache of a model output is fine **iff** it is a recorded observation pinned to its inputs.

### The simpler alternative I'd have demanded — and it was already litigated.
FORMALIS's D1 (handoff C-7) already rejected the tempting simplification (one broadened "projection = any deterministic function of recorded inputs"), because it silently attaches the full-reproducibility guarantee to model outputs that cannot meet it. That was the right call and I would not relitigate it — the two-name split is the honest design. My findings are about *explaining* the split, not replacing it.

---

## 4. Fragility / what blows up the book

### M4 (MATERIAL) — "Capture everything" is stated as unconditional, with no acknowledgement of the open-firehose capacity envelope.
MD-2: "the Ledger captures, then classifies; **it never refuses to record**"; even a corrupted payload "is still not lost." C-4.12: every arrival recorded, never lost. **Order-of-magnitude reality check:** at 09:30 a full options feed (OPRA) peaks in the tens of millions of messages/second; a day is ~10^12 messages; "record every one, immutably, forever, including the garbage" is petabytes/year *for market data alone* and a write path that must not drop under exactly the load where it is most stressed. The document presents capture-everything as **free.** If the pipe drops messages at the open — the one moment it matters — the central guarantee ("never lost") is violated and the document has no words for it.
- This is the classic *precise-in-the-centre, silent-in-the-tail* pattern: confident principle, no capacity boundary.
**Fix:** one honest boundary clause. Either (a) scope it — "capture-then-classify is a *principle*; whether an implementation's pipe can capture the open firehose is a capacity question outside this document — but the principle forbids using capacity as a licence to silently drop," or (b) state what the record holds when admission is rate-limited. Silence is the overpromise.

### M5 (MATERIAL) — The document only speaks of *successful* derivations. A calibration that fails to converge is not, as written, clearly a recorded fact.
MD-9 records a fit that *ran but violated a declared constraint* ("records that it cannot — a visible diagnostic"). It does **not** cover the fit that *fails to converge*, returns NaN, hits max-iterations, or the projection with **missing inputs.** For those, MD-6's mechanism ("output re-enters as an observation") has no output to re-enter — so the natural outcome is **nothing recorded**, and an *absent* derived object becomes indistinguishable from "we never tried." That directly contradicts the document's own capture-everything ethos (MD-2) applied one level up. By its own philosophy, a **failed derivation must itself be a recorded observation** — "attempted at cut C, did not converge, provenance X" — not an absence.
**Fix:** one clause (naturally in MD-6 or MD-9): a failed derivation — non-convergence, numerical failure, insufficient inputs — is a recorded fact with provenance, exactly as a failed capture is (MD-2).

### M3 has a fragility teeth, not just a wording one.
An implementer who takes MD-8 literally ("derived object = recompute on read, never store") will **not capture a model output as an observation** — and will lose the production surface the day the model version is lost (model retention being explicitly out of scope, §4). MD-8's blanket "recompute on read" is *safe for projections and dangerous for model outputs.* This is the sharpest book-risk in the document: follow the wrong half of MD-6/MD-8 for a fitted surface and the object is unrecoverable. (Fix is the M3 fix — make the two-case split unmissable.)

### Minor fragility
- **m7 (bulk retraction)** — a vendor voids a whole day. MD-10's correction model is one-observation-at-a-time ("a new observation naming the wrong one"), and MD-5/10 publish "*every* changed value" as "a named explain item." A whole-day void → an **explain-item storm** across the book, with no notion of aggregating a mass correction. The document treats "every change flagged" as unconditionally good; a flood of flags is its own operational failure (alert fatigue drowns the signal). The principle holds; the *usability at blast-radius* is unaddressed. Worth a clause acknowledging mass corrections summarise.
- **m11 (MD-11 replay)** — "the seed is the single non-record input" is true for replay *only because* it assumes every model output along the path was captured as an observation. Fine, but the assumption is silent; if a simulation generates model outputs on the fly and records only the seed, it cannot replay without the model. One clause.

---

## 5. The worked example (§3) — teaches the flow, not a computation

### M8 (MATERIAL, cheap) — no numbers.
"The official close of a single stock on a Tuesday" walks the lifecycle well, but there is **not one price in it.** My standing test is a worked example with one concrete number the reader can check. Put a number through it: *AAPL closes 150.20 Tuesday (execution time Tue 16:00, door time Tue 18:30); it feeds the vol surface; Thursday the exchange restates it to 150.50 (new observation, same execution time, door time Thu).* Then show the payoff of M6: *the surface as-published-Tuesday used 150.20; the surface as-recomputed-now uses 150.50; here is the cut that selects each.* That one number turns §3 from a flow diagram into something a reader can verify — and simultaneously closes M6.

### m-late-arrival — the more surprising mechanism isn't walked.
§3 illustrates *correction* (MD-10) but not *late arrival + refold* (MD-5) — the genuinely counterintuitive case (a Tuesday-stamped observation arriving Thursday reorders the fold and refits Wednesday's surface). The interesting, fragile mechanism gets no worked walk-through. One added bullet.

---

## 6. What I'd require before this ships

1. **M1** — plain-language gloss at first use for **fold, home, cut** (one clause each), matching the quality of MD-4's time glosses.
2. **M2** — one sentence pinning *reconstruction* = *re-derive from inputs*, and stating that reading back any recorded value (including a model output) is always possible.
3. **M3** — make the MD-6/MD-8 two-case split unmissable in MD-8: projections aren't stored; model outputs are stored as observations and don't drift because a new fit is a new observation. Soften the MD-8 title's overclaim for the model case.
4. **M4** — one honest boundary clause on capture-everything: principle vs capacity, with the drop-under-load case named rather than left silent.
5. **M5** — one clause: a failed derivation (non-convergence / numerical failure / missing inputs) is a recorded fact with provenance, not an absence.
6. **M6 + M8** — put one number through §3 and show the as-published vs as-recomputed contrast, naming the cut that selects each.

Minor (fold in if cheap, not blocking): m7 mass-correction summarisation, m9 forward-ref of projection/derived object, m10 "explain item", m11 MD-11 capture assumption, late-arrival worked bullet.

**Note for the record:** I found **no** overreach on the constitutional side — no parked conflict is being fudged, and the honest thing here is that FORMALIS's D1 split already closed the one real relabel trap (broadened "projection"). My entire quarrel is that the *practitioner-facing* layer promises bigger than the *careful* body delivers, and three Constitution words block a one-sitting read. Fix those and this ships.
