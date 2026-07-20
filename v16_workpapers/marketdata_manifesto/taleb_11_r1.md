# TALEB — Market Data Manifesto 1.1, Review Round 1

**Read as:** market data operations lead AND collateral-desk practitioner (MD-14's stated audience), cold, full 8 pages, one sitting.
**Scope:** the three new articles MD-13 (frames + operator algebra), MD-14 (dispute-readiness), MD-15 (model binding + price-space validation), plus the MD-1/4/6/8/9/10 extensions and the reworked worked example. The certified MD-1..MD-12 spine is treated as settled (I passed it); I only flag where 1.1 edits touch it.

---

## 1. Verdict

**One-sitting gate: PASS — a practitioner survives all 8 pages.** 14 of the 15 articles read cleanly; the converged 1.0 spine is intact and, where extended (MD-6 failure-by-kind, MD-8 read-through-a-projection), actually improved. The honest read-back/re-derive split still *leads* the abstract and the new articles respect it.

**But three MATERIAL findings, and the document does NOT yet let the reader — especially the collateral desk — come away knowing *exactly* what is promised.** The sharp one is a real book-risk: MD-13's operator algebra is proved on *exact* arithmetic while the document *also* rounds to the minor unit, and rounding breaks the very associativity the reconstruction promise leans on. The loud one is an overpromise: MD-14 tells a collateral desk its disputes are "settled by replay, never debated," when replay settles faithful *reconstruction*, not the *model-choice* disagreement most collateral disputes actually are. **NOT CONVERGED — ready-with-fixes.** All fixes are surgical; none reopens the 1.0 spine.

---

## 2. Comprehensibility findings (one-sitting test)

### F1 (MATERIAL) — MD-13's algebra is stated in mathematician's register without its concrete instances; it is the one density stall in the document.
The frame *concept* lands beautifully (300 pre-split = 150 post-split, "one value in two frames") and the punchline is the best sentence in the new text ("a quote is not a fact until one says as-of when, as-at when, and in which frame"). Between them sits a paragraph that fails the desk's own rule — concrete before abstract:
- **Composition / associativity:** "associative because it is function composition, taken in the actions' execution order." No instance. A split-then-dividend chained forward is never shown. "Function composition" and "associative" are unglossed math terms.
- **Commutation:** "selection by as-of commutes with it: adjust-then-select and select-then-adjust return the same value." Stated purely abstractly, no instance (e.g., "adjust Tuesday to today's frame then pick Tuesday, or pick Tuesday then adjust — either way 75.10"). "Commutes" unglossed.
- **Inverse / injectivity:** "most operators are not injective and have no exact inverse." "Injective" unglossed; the *reason* (rounding loses information) is given, which is good, but no instance of two pre-values colliding.
- **The re-read trap:** "a corporate action whose door time falls between two cuts is known only at the later, so the composite operator differs between them and the orders need not agree." Dense; "the orders need not agree" is ambiguous (which orders?). A practitioner stalls here.

Bar the coordinator set — "each law lands with its concrete instance" — is failed for composition, commutation, and inverse. **Fix:** one worked instance for composition (split then dividend, forward), one for commutation, gloss injective/associative/commutes in plain words or cut the abstraction to the practical statement. The frame concept and punchline stay; the middle algebra is where the reader is asked to take rigor on faith.

### F-min-1 (MINOR) — the conclusion dropped the read-back/re-derive clause that 1.0 carried.
1.0's conclusion said "rebuilt from the record alone where it computes over the record, read back… and re-derived only with the named model where it runs one." 1.1's conclusion regressed to the unqualified "a deterministic function of what the record holds… settled by replay." The abstract still leads with the split and MD-14/MD-15 respect it, so it is not *buried* — but a practitioner who reads abstract+conclusion gets the qualifier up front and the maximal phrasing at the close, which is exactly the shape we fixed in 1.0. Restore the clause.

### F-min-2 (MINOR) — the worked example's "two answers" bundles a correction *and* a frame change into one number.
"Tuesday as published Tuesday… 150.20" vs "Tuesday as valued now… 75.25." The 75.25 is the *corrected* 150.50 carried into the *post-split* frame — so 150.20 → 75.25 folds a +0.30 restatement and a ÷2 reframe together. A practitioner doing the mental check sees 150.20 halved is 75.10, not 75.25, and has to remember the correction bumped it first (the intermediate 75.10 appeared one bullet earlier). It teaches better if the two effects are isolated: show 150.20 → 75.10 (frame only) and 75.10 → 75.25 (correction only), then the combined answer.

---

## 3. Challenge findings — the three new promises against the body

### Promise A — "dispute settled by replay" (MD-14).

**F2 (MATERIAL) — for the collateral audience, "settled by replay, never debated" reads bigger than the body delivers.** MD-14's rhetoric: "any dispute about a recorded value is settled by replay, not by argument… A dispute is recomputed, never debated." It reframes a dispute as "contest a number," and replay then exhibits the chain and reproduces the valuation bit-for-bit. That settles exactly one kind of dispute: *is this number the faithful reconstruction of its recorded datum, provenance, model, frame, and cut?* It does **not** settle the dispute a collateral desk actually has — *your model / methodology is wrong, we mark it differently.* Replay proves your number follows from *your* model and inputs; it cannot adjudicate whose model is right, and MD-15/MD-9/C-Scope.11 correctly put model choice out of scope. So the honest promise is narrower than the words. The document *does* bound replay's reach by reproducibility ("replay reaches exactly as far as reproduction, never wider" — good, and it correctly ties to the retained-model split), but it does **not** bound it by model-choice — the limit that bites the collateral desk. **Fix:** one sentence in MD-14 stating plainly what replay settles (the number is the faithful reconstruction of its recorded ingredients) and what it does not (whether the model or tolerance was the right choice — model choice, out of scope). This turns the worst overpromise in the new text into a matched promise.

**F-min-3 (MINOR, but flagged because the coordinator named it) — the exhibit list omits the cut.** MD-14 lists what replay exhibits: "the datum, its provenance and attestation (source and times), the frame it was read in, and the model it is bound to." The **as-at cut** — the coordinate MD-13 just spent an article establishing as necessary ("agree on (as-of, as-at, frame)") — is not named, though it is implicit in "reproducing bit-for-bit (MD-6)" (MD-6 lineage carries the resolved cut). For a disputant the first question is "as of which knowledge-cut was this mark struck?" Name the cut in the exhibit list so the unmistakable five are datum, provenance/attestation, cut, frame, model.

### Promise B — "a quote needs a time coordinate *and* a frame" (MD-13, MD-4).
**Sized correctly; the "what you must record" is derivable but not stated once.** The reader learns (across MD-13/MD-4/MD-10): store the value *as observed* (its unadjusted frame is fixed by execution time), store corporate actions as first-class events, and *never store adjusted values* — they are derived at read ("the adjusted value computed at each read, the original never overwritten"). That is the correct and honest instruction. **Soft MINOR:** it is spread over three articles; one explicit line for the ops lead ("record the raw value with its three times; the frame is not a field you attach but a coordinate that execution time and the recorded actions determine; adjusted values are always derived, never stored") would make the demand actionable in one place.

### Promise C — "round-trip repricing is the acceptance test" (MD-15).
**Sized correctly, and it does convey that it needs the model.** MD-15 defines validity as repricing "through its bound model… within a declared tolerance," calls calibration and validation "one act seen from opposite directions," and says "model-binding never undoes the split" and the residual "is a recorded diagnostic (MD-9), never a silent pass." A reader who internalised the 1.0 split understands validation runs a model → re-deriving it needs the retained model. This is the strongest of the three new articles. **F-min-4 (MINOR):** "valid" is scoped to "the instruments it was drawn from" (the calibration set), but the sentence "validated where it is used" and the unqualified word "valid" read broader. A datum used to mark an exotic it was *not* drawn from is model-extrapolation, whose validity is model choice (out of scope) — the round-trip passing on vanillas says nothing about the exotic. Clarify that round-trip validity covers the calibration set, not off-set use.

---

## 4. Fragility / what blows up the book

### F3 (MATERIAL — the sharpest) — MD-13's algebra is proved on exact arithmetic, but the document rounds to the minor unit, and rounding breaks associativity and the cross-party reconstruction promise.
MD-13 claims two things that collide:
- "operators… compose… **associative because it is function composition**"; and "**any two parties who agree on (as-of, as-at, frame) reconstruct the identical value**";
- "**adjusted values are rounded to the minor unit** (C-4.6)" (invoked to justify non-invertibility).

Rounded operators are **not** associative: `round(round(x/2)/1.5) ≠ round(x/3)` in general. If rounding to the minor unit is applied *between* operators, the composite adjusted value depends on how the chain is grouped, and two conformant parties — both "following C-9.2/C-4.6" — can differ by a minor unit. That is precisely a collateral **mark break**: a 20-year chain of splits and dividends, each adjustment rounded, and your system and the counterparty's disagree by a cent on the adjusted price behind the call. The document uses rounding to defeat inverses (correct) but does not notice the same rounding threatens the associativity and "identical value" claims it makes elsewhere — precise in the centre, silent in the tail.

**Order-of-magnitude:** one cent per rounding step, up to N steps over the life of a long-dated position — small per step, but path-dependent and non-reconcilable, and reconciliation-failure is the one thing this whole architecture exists to remove. On a large notional the accumulated adjusted-price difference is immaterial to PnL but *fatal to the promise* ("nothing left to reconcile") and to a collateral dispute that turns on the last cent.

**Fix:** state that operators compose at full precision and the C-4.6 rounding to the minor unit is applied **once, when the adjusted value is materialised at read** — not between operators. Then associativity holds, the composite is grouping-independent, and "any two parties reconstruct the identical value" is true. (Or, failing that, pin a canonical grouping.) The word "associative because it is function composition" is only true pre-rounding — say so.

### F-min-5 (MINOR) — MD-13 is silent on elective / optional corporate actions.
Every instance is a *mandatory, deterministic* action (split, proportional figure across a split, clean-ratio reverse split). A collateral/ops desk handles elective actions constantly — choice dividends, mergers with cash/stock election — where the post-event frame depends on a *holder election*, not on the action terms alone. The machinery extends (the election is a recorded decision event; the operator applies to the elected terms), but MD-13's "deterministic projection from the recorded action terms" framing does not say so, and a practitioner will ask. One clause closes it.

### Jargon residue (MINOR, subsumed in F1) — `injective`, `commutes`, `associative`, `function composition` all unglossed. `frame`, `round-trip`, `binding`, `minor unit`, `price space` are all fine. `transport` (§4) is a third verb for the operator's "carries/maps" — nit. "Attestation" is defined as *an observation* in §1 but used as *provenance-metadata* ("source and times") in MD-14 — tiny inconsistency. "Election" does not appear (hence F-min-5).

---

## 5. What I'd require before this ships

1. **F3** — pin rounding placement in MD-13: compose at full precision, round to the minor unit once at read; qualify "associative" as holding for the exact operators. Without it the reconstruction promise and collateral marks are fragile.
2. **F2** — one sentence in MD-14 stating what replay settles (faithful reconstruction of recorded ingredients) and what it does not (whether the model/tolerance was the right choice — model choice, out of scope). Size the flagship new promise to its audience.
3. **F1** — give MD-13's composition and commutation one concrete instance each and gloss injective/associative/commutes; reword the "orders need not agree" caveat. Keep the frame concept and punchline.
4. **F-min-3** — add the cut to MD-14's exhibit list.
5. Minors as cheap: restore the read-back/re-derive clause in the conclusion (F-min-1); isolate correction from frame change in the worked example (F-min-2); clarify MD-15 round-trip covers the calibration set (F-min-4); one clause on elective actions in MD-13 (F-min-5).

**Note for the certifier (not a TALEB finding):** MD-14's abstract says the manifesto "adds" a seventh governing principle. MD-14's body resolves this honestly — dispute-readiness is a *corollary* of auditability + reproducibility ("what those principles already are, once an adversary insists"), not a new axiom, and the trace tag says so. Whether "adds a seventh principle" respects the subordination rule is FORMALIS/CONCORDIA's call, not mine; I note only that the phrasing could read as amending the Constitution's commitment set, which the body does not intend.

---

# Round 2 — Convergence check (1.1 rev 2)

Re-read the revised MD-13, MD-14, MD-15, worked example, and conclusion cold, in both personas. Verified each fix against the *printed words*, not the promise of a fix.

### F3 (rounding / associativity — the book-risk) — **RESOLVED, verified by the printed words.**
MD-13 now prints exactly the fix, and pre-excludes the wrong implementation: "Operators compose at *full precision*, the minor-unit rounding (C-4.6) applied *once* at read, so the composite is grouping-independent and two parties reconstruct the identical value; **rounding between operators would not.**" The collateral cent-break is excluded on the page: per-operator rounding — the thing that breaks associativity and diverges two conformant parties — is named and forbidden, and the associativity claim is attached to the full-precision composed map ("two splits a week apart chain forward into one map"). Stress-tested: "full precision" = exact arithmetic on the recorded (finite-precision) inputs, rounding deferred to read; for rational corporate-action maps and fixing-based operators this is achievable, and any two implementations that honour it agree bit-for-bit. Sound.

### F2 (dispute overpromise) — **RESOLVED, comprehensively.**
MD-14 is now bounded on the page and for the right audience: "replay settles whether the value is the faithful, deterministic consequence of the inputs the record held at its stated (as-of, as-at, frame) — the only question a system of record can answer. It does *not* settle a two-sided economic dispute: a counterparty's mark, from its own surface, model, and frame, replays bit-for-bit too, and which is right is model choice, out of scope." The collateral reality (the other side's mark replays too) is stated head-on. The exhibit list gained **both** cut and frame; replay is pinned to the mark's own cut ("the number that stood then, not a post-correction one"); and the localisation value is stated *with its instance* ("one side applied the split to the strike, the other to the multiplier"). Promise now matches body.

### F1 (algebra density) — **RESOLVED.**
Each law lands with its one-line instance: compose = two splits a week apart chaining into one map; identity = action-free span, and a proportional dividend figure standing across a split; commute = "adjust Tuesday into today's frame then pick Tuesday, or pick then adjust, gives the same value"; fixed-cut = the between-cuts door-time query. The worst unglossed term, "injective," is gone, replaced by "preserves information." The rev-1 re-read trap ("the orders need not agree") is gone, replaced by "the composite operator differs between them."

### Minors — all **RESOLVED.**
Conclusion restored the qualifier ("read back always, re-derived only where a model runs"). Worked example unbundles the two effects explicitly (split alone 150.20→75.10; correction alone 150.20→150.50; combined 75.25 — arithmetic checks). MD-15 scoped: "**valid on its calibration set**… off-set use is model extrapolation, whose validity is model choice, not this round-trip." My earlier F-min-5 (elective actions) was resolved *beyond* the ask: unresolved actions (holder election, proration, scrip reference, merger blended consideration) are handled as **resolution observations** — "before that the frame is provisional and legible as such, never a silent wrong number."

### Fresh, in the expanded MD-13 text
The rev added substantive risk fixes I had not flagged: the **delivery frame** ("a value already adjusted at source is never adjusted again") heads off double-adjustment, the #1 real-world corporate-action bug; operators are correctly noted as non-scalar (special-cash-dividend additive shift; OCC strike/multiplier/deliverable); and derived objects are recomputed from operator-adjusted inputs, never transported directly. All instance-anchored and audience-owned.

- **F-min-6 (MINOR, non-blocking) — the delivery-frame registration is a correctness assumption not tagged as loudly as grain was.** A back-adjusted vendor feed mis-registered as unadjusted would silently double-adjust — the same class as the MD-1 grain assumption. Unlike grain (an internal dedup choice), the delivery frame *is* a property the source delivers, so it already sits inside MD-3's named "delivery is a trust assumption, reconciled at the perimeter," and MD-13 calls it "an asserted, recorded fact… never inferred." So it is arguably already covered; the only gap is that MD-13 doesn't say "…and a mis-registration double-adjusts, caught at the perimeter" as loudly as MD-1 does for grain. One optional clause for consistency. Not a reason to hold the document.
- **Observation (not a finding):** MD-13 is now by far the densest article. It survives the one-sitting test for *this* audience (ops-lead + collateral) because every concept is one they own and each carries an instance; the density is inherent to corporate actions, not ornament.

### Verdict
F3 RESOLVED · F2 RESOLVED · F1 RESOLVED · all minors RESOLVED (incl. elective actions, beyond ask) · gate **PASS** · **CONVERGED.** One non-blocking minor (F-min-6) recorded for optional polish; it does not gate the document. From my seat, 1.1 is ready to ship: an ops lead and a collateral practitioner can each read all 8 pages in one sitting, and the three new promises — frame-and-time coordinates, dispute-by-replay, price-space validity — now match the body exactly, including the read-back/re-derive split carried from the certified 1.0.
