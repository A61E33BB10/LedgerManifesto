# KLEPPMANN — Review of MDM 1.3 / MD-16 (Market Data Dynamics)

**Charter:** event-sourcing / data semantics. Gate-at-application as an event/state property: does prevention-by-construction hold as event semantics; is the decision a first-class replayable refusal; is the derived stream separated; is "consume only admissible states" enforceable.

**Read:** `MarketDataManifesto_1.3.tex` (MD-16 in full + the MD-11 backtest sentence); `drafting_note_dyn.md` (incl. the THORP co-pass and the storage-threading paragraph). Cross-checked MD-2/6/8/9/11/12/13/14/15 and C-4.11.

**Headline.** The event framing is genuinely right and mostly airtight: a derived state is *constructed*, not captured; admission is gated; a failed state does not exist (not exists-then-flagged); the gate decision is a first-class recorded outcome analogised to the single writer's admit-or-refuse; and — the sharpest thing in the article — replay uses the terms *as declared at application*, not as they later stand. Attack (2) is clean. My one material finding is on attack (4): the "consume only admissible states" guarantee is enforceable-by-construction for the *gated-construction layer* but is stated as a uniform consequence, when it quietly rests on MD-9 *detection* for the base states a derived world branches from.

---

## Attack (1): prevention-by-construction as event semantics — CLOSED, one MINOR sharpening

Walking the printed machinery: "A derived state is not captured; it is *constructed*, and it is admitted only through two gates, both decided at application time" (MD-16); "An arbitrageable derived state is not produced, so no consumer ever meets one: prevention, not detection" (Gate 1); "a derived state it produces is admissible or it does not exist" (title). So the admitted object exists iff the gates pass — there is no admitted-then-flagged state. **No transient admitted state:** the raw `dynamic(m)` is an intermediate computation; only the gated result *enters the record* as a derived state, so a consumer reading the derived stream never meets an ungated one.

**The TOCTOU is closed, and by the right mechanism.** The gate is "a decidable predicate on a projection over the record (MD-6)," and `m*` carries "the base coordinates it branched from." A predicate on a projection is evaluated over the projection's *pinned* inputs; by MD-6/MD-12 each input is fixed at its own cut and "the mid-update input cannot arise." So the base state `m` is pinned at the application cut, and the gate and the constructed `m*` are **one projection-evaluation over that single pinned cut** — the base cannot move between gate-eval and admission because there is no separate re-read of a mutable base. (A later correction to one of `m`'s inputs does not create a TOCTOU: it flags `m*` stale forward via MD-8/MD-10, exactly as any re-entered quantity, `m*` remaining the as-known-at-cut value it was gated as.)

*MINOR (M1):* the no-TOCTOU is *implied* by "predicate on a projection (MD-6)" but never stated as such. One sentence — "the base is pinned at a single application cut; the two gates and the constructed state are one evaluation over that cut, so the base cannot move between gating and construction (MD-12)" — would make it un-missable rather than inferable. The guarantee itself holds; this is explicitness, not a hole.

## Attack (2): the decision record's semantics — CLEAN, no finding

All three sub-points are explicitly carried:
- **First-class recorded refusal.** "Its gate decision — pass or fail, the functionals computed, their percentiles, the history basis — is the recorded outcome of that event, pinned at application with its declared-term lineage, **as the single writer's admit-or-refuse is recorded with the transaction it decides**." A fail (and the thin-history *undecidable*, "a hypothesis failure honestly flagged, never silently waved through") is a first-class record, analogised to the door refusal — never silent.
- **Replayable bit-for-bit.** The lineage is base coordinates + operator + declared terms + history basis, all recorded; "re-derived only against the terms and history as they then stood — the read-back/re-derive split of MD-6"; "dispute-ready on MD-14's terms." Sufficient to replay the gate itself, so the *verification* is dispute-ready, which is the architect's requirement.
- **Replay uses terms as-declared-at-application.** "the decision turns on declared terms and an as-known history that are themselves versioned, so the number that stood at application is an as-known fact (MD-4), re-derived only against the terms … as they then stood." A later governance change (new window `W`, new percentile convention) is a new version; the old decision's lineage pins the old version, so replay is invariant to it. This is exactly correct and exactly what the architect demanded.

The C-4.11 threading is honest: a gate decision is an *event-outcome* (MD-11's discipline that a path capture its outputs), not a balance-coordinate quantity, and PARK-1 is cited as "neither reopened nor turned on." I concur — this is not a stored-projection divergence; it is a recorded event-outcome, replayable, so it cannot silently diverge.

## Attack (3): derived-stream separation — CLOSED, one MINOR sharpening

"The application of a dynamic is an event in the derived stream — MD-11's simulated path, whose every output is captured." Derived states are *constructed* and live in the derived stream; base observations are *captured* (MD-2). The two are disjoint categories, and the derived stream is MD-11's simulated path — separate from the base by the simulated-path separation already in force (MD-11 / the backtesting amendment). So no volume of derived-state creation writes the base stream, and MD-4 served-history reads only captured base observations.

*MINOR (M3):* the separation is established via the derived-stream placement + captured/constructed disjointness, but the specific invariant — "derived states and their decisions never enter the base stream; base-history serving (MD-4) is unaffected by any volume of derived-state creation" — is not stated as one crisp sentence. It follows; state it, so a reader need not reconstruct it.

## Attack (4): "consume only admissible states" — MATERIAL

MD-16: "backtests and risk reports therefore consume only admissible states, which is what makes MD-11's derived worlds safe to build on." MD-11: "consumes a stressed history only after its states pass the admissibility gates of MD-16."

**For the gated-construction layer this is enforceable-by-construction, not aspirational** — prevention means no inadmissible MD-16-derived state *exists*, so a consumer of derived states inherently gets only admissible ones, no consumer-side check required. That is genuinely strong. **But two things make the sentence, as printed, overstate — and it is not merely a consequence, it needs the enforcement named:**

1. **The scope rests on MD-9 detection at the root.** MD-16 requires "an admissible base state `m`." Where the base is a **black-box fit** (a calibrated surface from an optimiser — MD-9's domain), its admissibility is by *detection, not prevention*: an arbitrageable base can exist, flagged after the fact. Gate 1 checks `m*` directly, so `m*` is prevention-admissible regardless of `m` — but a backtest *also consumes the base `m`* (the unshifted t=0 state) and any derived state's lineage roots in it. So the derived world is **prevention-admissible in its derived layer and detection-admissible at its base**, not uniform prevention.

   > **Scenario.** A backtest stresses a strategy over a derived world whose base surface came from a black-box calibrator carrying an as-yet-undetected butterfly arbitrage. A shift-dynamic is applied; Gate 1 checks `m*` directly and `m*` is arbitrage-free, so it is admitted. The backtest consumes `m*` (admissible by prevention) **and the base surface (arbitrageable, undetected)**. "Backtests consume only admissible states" reads as satisfied; in fact the base fell under MD-9 detection, which had not yet fired. The PnL is computed partly on an inadmissible base.

2. **The enforcement mechanism is not named, so a consumer cannot tell which guarantee a state carries.** Prevention-admissible states (MD-16 gate-decision) and detection-admissible states (MD-9 diagnostic) coexist in what a backtest consumes. Nothing in MD-16 says a consumer **references a state by its admission record** — the passing gate-decision for a gated state, the MD-9 diagnostic for a black-box fit. Without that, "consume only admissible" is a *consequence asserted over the population*, not a *structural property of the read*: a consumer has no printed way to distinguish a prevention-safe state from a detection-only one, nor to refuse a state lacking any admission record.

**Fix (two clauses).** (i) State the enforcement structurally: a consumer references a derived state by its **admission record**, so a state without a passing gate-decision (or, for a black-box fit, its MD-9 diagnostic) has no record to name and cannot be consumed — turning the consequence into a structural impossibility. (ii) Delimit the scope honestly: the guarantee is **prevention for the gated-construction layer**; where a derived world roots in a black-box-fit base, base admissibility is **MD-9-detected**, so the backtest inherits detection at the root and prevention at every derived step — not uniform prevention. This does not weaken MD-16; it stops "consume only admissible states" from reading as a total guarantee it does not deliver.

---

## Verdict

- **Attack (1): CLOSED** (prevention-by-construction holds; no TOCTOU — gate+construction are one projection-evaluation over the pinned base cut, MD-6/MD-12; no transient admitted state; consumers never meet ungated states). MINOR M1: state the no-TOCTOU/base-pinning explicitly.
- **Attack (2): CLEAN.** First-class replayable refusal; lineage replays the gate bit-for-bit; replay uses terms as-declared-at-application (versioned, as-known). No finding — this is the article's strongest part.
- **Attack (3): CLOSED** via MD-11 simulated-path separation + captured/constructed disjointness. MINOR M3: state "base-history serving unaffected by derived-state volume" explicitly.
- **Attack (4): MATERIAL** — "consume only admissible states" is enforceable-by-construction for the gated layer but overstates by (i) resting silently on MD-9 detection for black-box-fit base states and (ii) not naming the consume-by-admission-record enforcement that lets a consumer tell prevention-admissible from detection-admissible states.

**1 MATERIAL, 2 MINOR. NOT CONVERGED** — one round on attack (4)'s scope + enforcement is warranted. The material finding is fixable **within** the framework (name the enforcement; delimit the scope against MD-9) — no park, and it does not disturb the prevention core, which is sound.

---

## Round 2 — confirmation (MD-16 revised, 12pp)

**M4 (attack 4) RESOLVED:** "Consumption is enforced by reference: a backtest or risk report names a derived state *by its admission record* — its passing gate-decision — so a state carrying none cannot be named and cannot be consumed," and the scope is bounded honestly ("prevention governs the *constructed* derived layer, while the calibrated base … is admissible by MD-9 *detection*, not prevention … never uniform prevention"). Both prongs land exactly.
**M1 RESOLVED:** "The base is pinned at a single application cut: the two gates and the constructed state are one evaluation over that cut (MD-12), so the base cannot move between gating and construction." No TOCTOU, explicit.
**M3 RESOLVED:** "Derived states and their decisions live in the derived stream and never enter the base stream, so base-history serving (MD-4) is unaffected by any volume of derived-state creation." Explicit.
**Attack (2) remains clean.** No fresh issue introduced. **CONVERGED** on my charter.
