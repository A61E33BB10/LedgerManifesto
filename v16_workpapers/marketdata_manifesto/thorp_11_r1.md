# THORP — CA-practitioner reality check on Market Data Manifesto 1.1

**Reviewer:** THORP (equity-derivatives desk; CA ops as lived)
**Target:** `MarketData/MarketDataManifesto_1.1.tex`, the 1.1 amendment — MD-13 (frames + operator
algebra), MD-14 (dispute-readiness), MD-15 (price-space validation), and the frame coordinate
where it threads MD-1/MD-4/MD-10.
**Question:** does the printed frame/operator/replay story survive a live corporate-actions
calendar on a real equity-derivatives book?
**Constitution checked:** `LedgerManifesto/ledger_manifesto.tex` §9 (C-9), the clause MD-13 rests
on. This matters for two findings.

**Verdict up front:** the *frame* idea is right and the bitemporal machinery is genuinely strong —
ex-date moves and corrected ratios fall out honestly from the as-at cut, and the forward-composition
inverse story is exactly how a desk thinks. But MD-13 asserts a **determinism the CA desk knows is
conditional**, misses the **announce-vs-ex-date** distinction that decides when a frame actually
changes, **narrows a Constitution guarantee** (derived objects), and MD-14 **overclaims what replay
settles**. Five MATERIAL, two MINOR. **NOT CONVERGED** — the fixes are all principle-level wording,
no new mechanism, no Constitution amendment.

---

## What survives contact (state these so the desk trusts the rest)

- **Ex-date move / ratio correction via the as-at cut.** MD-13's "a CA recorded late or corrected is
  a superseding recorded event, so it moves the frame only in a later as-at cut." Walk it: split
  announced Jan 1 (ex Jan 15), exchange moves ex to Jan 20 on Jan 10. A price observed Jan 17: at an
  as-at cut before Jan 10 it read post-split; at a cut after, it reads pre-split. Both are honest.
  That is exactly the bitemporal answer a desk wants and most vendors get wrong. **Correct.**
- **The inverse story.** "Most operators are not injective (minor-unit rounding), the framework
  needs none, every frame is reached forward from the preserved original." Reverse splits,
  cash-in-lieu, and rounding all destroy information; forward composition from preserved originals is
  precisely how you avoid the reconstruction trap. **Correct and desk-sound (FORMALIS E1 landed).**
- **The frame is exhibited in a dispute (MD-14).** Listing "the frame it was read in" among what
  replay exhibits is the single most useful thing for a cross-ex-date dispute — see M5, it *locates*
  the disagreement even though it does not *settle* it.
- **Split example arithmetic.** 150.20 → 75.10 (2:1); restate 150.50 → 75.25. Fine.

---

## MATERIAL findings

### M1 — MD-13 asserts the operator is determined once terms are *known*; on elective/proration/fixing events it is determined only once terms are *resolved*, and the resolving fact is not market data.

**The claim.** MD-13: the operator is "computed from the recorded action terms and the recorded
value," and "Fix an as-at cut and the observations and corporate-action terms known as of it are
fixed, **so the composite operator is determined**." The load-bearing step is *terms known ⟹
operator determined*.

**The desk scenario (airtight, unarguably market data).** A UK-style **scrip dividend** where the
share-alternative reference price is an average of the five daily closes around ex. The vendor's
**price-series adjustment factor** for that event — the number applied to all history to make a
continuous series — *cannot be computed at announcement*. It needs the reference price, which is a
**fixing** recorded only after the pricing window closes. So the operator is a function of the terms
**plus a later-recorded observation**, not the announced terms alone.

**Second illustration (election, not fixing).** A merger where each target share becomes cash *or*
acquirer stock, **subject to proration** to a 50/50 aggregate. To carry the target's historical price
into acquirer-equivalent units (a real total-return-series question for a vol or beta estimate
spanning the event), you need the **blended consideration**, which depends on the **realized
proration factor** — an aggregate of *all holders' elections*, known only after the election
deadline. Not announced terms. Not market data. A separately-recorded realized outcome.

**Why it bites.** At an as-at cut *after* announcement but *before* the fixing/deadline, the terms
are "known" (announced) yet the operator is **not determined**. MD-13's "known ⟹ determined" is
false in exactly the cases the desk fights over. Note the Constitution does **not** overclaim here:
C-9 says the operator is "intrinsic to the pairing of the kind of data and the kind of event" — it
never says the operator is a pure function of *announced* terms. MD-13 narrowed it.

**Principle-level fix.** Distinguish **terms known** from **terms resolved**. The operator is
determined only once the terms are *resolved* — all fixings, elections, and proration outcomes
recorded as completing/superseding events (MD-5, MD-10). Before resolution the frame is
**provisional and legible as such** — precisely MD-6's failed-projection treatment ("not yet
resolvable," never silently a wrong number). One added sentence to MD-13; it plugs straight into
machinery the manifesto already has.

**Trading consequence of getting it wrong.** A book that treats an announced-but-unresolved scrip or
merger as a determined frame will mark and collateralise off an adjustment factor that does not yet
exist — and then silently restate when the fixing lands. That silent restate *inside a collateral
mark* is the dispute in M5.

---

### M2 — The frame boundary is the **ex-date** (the CA's as-of), not when its terms became known (its as-at); MD-13 never pins it, so announced/cancelled CAs and dividend *announcements* are mishandled.

**The gap.** A CA is not a point — it is a lifecycle: announcement → (revisions) → **ex-date** →
record → pay. The market-data frame changes at **ex-date** (the price re-coordinates when the market
goes ex); the **terms become known** at announcement, a different coordinate that can move
independently. MD-13 composes operators "in execution order" and says a CA "changes the meaning of
every value recorded before it," but **never states that the CA's frame-change boundary is its
ex-date**. The §3 example just says "the next week a split is recorded" — announce vs ex never
appears.

**Scenario (a) — cancellation.** A 2-for-1 split announced, then **cancelled before ex-date**. Desk
truth: a pending CA before its ex-date adjusts **nothing** — no historical price is touched until ex.
So a cancelled-before-ex CA must be the **identity operator on the price series**, full stop, and
cancellation just removes a pending event. But if MD-13 lets the frame change at *known-time*
(door/as-at), then between announcement and cancellation you would show an adjusted frame and then
have to **un-adjust** on cancellation — the exact "reach backward and inverse" move MD-13's own
architecture forbids. Anchoring the boundary at ex-date makes cancellation clean; leaving it
unpinned invites the un-adjust.

**Scenario (b) — dividend announcement is information, not a frame change.** A dividend is *announced*
(or revised upward). The implied-dividend curve and the forward move. That is **new information — new
observations, MD-5 (refold projections)** — **not** a change of frame. The frame event for a dividend
is the **ex-date** (and only for a total-return frame). MD-13, which treats "a corporate action" as a
frame event uniformly, invites conflating the announcement (information) with the ex (frame) and
**double-counting** — adjusting for the dividend *and* folding the announcement as news.

**Principle-level fix.** State that a CA carries its own MD-4 times: its **ex-date is its execution
time / as-of** (the frame boundary), distinct from **when its terms became known (as-at)**. Before
ex — or if cancelled — the operator is the **identity on the price series** (nothing adjusts "until
fresh post-event data are recorded," which is C-9's own phrase). And distinguish a CA that *carries
values across a frame* (ex-date) from a CA *announcement* that *delivers new observations* (MD-5).
The manifesto already has both times and both mechanisms; it just has not applied MD-4's structure to
the CA itself.

**Trading consequence.** Adjust between announce and ex and every historical mark, vol point, and VaR
scenario spanning that window is wrong by the split ratio for the duration; then a cancellation forces
a backward un-adjust the architecture says never happens.

---

### M3 — The **frame of an arriving observation is an asserted, recorded fact from the source** — not a derivable default — and a "frame" is fixed by the convention/recipe, not by the CA terms alone.

**The claim.** MD-13 treats the arrival frame as derivable: a value "lives in the pre-split frame it
was quoted in," "the unadjusted frame holds a value as observed, under the terms at its execution
time." The mental model is: sources deliver *unadjusted* execution-time values, and the ledger
computes adjusted frames itself.

**The desk reality.** Vendors deliver **pre-adjusted** series. Bloomberg / Refinitiv / index
providers ship AAPL's history **already split-adjusted to today**, and they ship **both** adjusted and
unadjusted lines. The number "75.10" arriving for "AAPL Tuesday close" is **meaningless** unless you
also record **which frame the vendor expressed it in** — unadjusted, or adjusted as-of what date,
price-return or total-return. That frame is the **vendor's assertion**, exactly as much a stated fact
as the value itself. If you record it as if it were the unadjusted execution-time value, you have
mis-framed it — and vendor A's "150.20" and vendor B's "75.10" for the same as-of look like a
reconciliation break when they are the *same fact in two frames*. MD-1 says an observation is
"attributed to a source" and records the value and provenance; **nowhere is the frame named as part
of that recorded, asserted provenance.**

**Second half — the frame is under-specified.** MD-13 defines a frame as "the coordinate system fixed
by the corporate-action terms in force." But **price-return vs total-return** is **not a CA term** —
it is a **convention/recipe choice** about *which* actions the operator applies (dividends adjusted in
TR, not in PR) and *how* (ratio rounding). Two "adjusted frames" with identical terms-in-force can be
different frames. So MD-13's punchline — "any two parties who agree on (as-of, as-at, frame)
reconstruct the identical value" — **fails as written**: two parties agree on as-of, as-at, and
"adjusted," and still get 150.20 vs 150.18 because one used TR and one PR, or different rounding.

**Principle-level fix.** Two sentences. (i) In MD-1/MD-13: the **frame in which an observation is
expressed is itself an asserted fact of the observation, captured as provenance alongside source and
times** — because sources deliver values in frames of their own choosing, and by MD-13's own
punchline an observation whose frame is not recorded is not a datum. (ii) In MD-13: a **frame is fixed
by the CA terms in force *and the declared adjustment convention* (which action kinds the operator
applies, the rounding rule, PR vs TR)** — not by the terms alone. Then the reconstruction claim is
true.

**Trading consequence.** Without capturing the arrival frame, every cross-vendor reconciliation
throws false breaks (same fact, different frame) and — worse — a silent frame mismatch feeds a wrong
number into a mark that then "replays" perfectly (M5).

---

### M4 — The operator algebra silently assumes **proportional/scalar** maps and the manifesto **dropped the Constitution's rule** that derived objects are re-derived, not transported.

**The claim.** MD-13: "For each corporate action and kind of data it **carries a value** from the
frame before the action to the frame after," and the running examples are all clean scalars (halve,
double; "a proportional figure stands across a split"). Read literally, "kind of data" invites
transporting a **vol surface or a curve** by its own operator.

**The desk reality — three ways the scalar model breaks.**
- **Vol surface across a split.** The strike axis re-coordinates (a 300 strike → 150), but implied vol
  **at fixed moneyness is the identity** (scale-invariant). So the operator on a surface is a strike
  **re-coordinatization**, not a rescale of the vol values — already not a scalar.
- **Special cash dividend.** A cash dividend shifts the **forward additively** (subtract PV of the
  dividend), which re-moneynesses every strike by a **strike-dependent, non-uniform** amount
  (moneyness is `log(K/F)`; an additive `F` shift is non-linear in moneyness). The surface operator is
  **non-linear per strike**, nothing like "a proportional figure stands."
- **Listed options — OCC contract adjustment.** OCC adjusts the *contract*, not the underlier price:
  a 2:1 split doubles contracts / halves strike; a **3-for-2** adjusts strike by 2/3 and multiplier by
  3/2 (odd strikes) or the deliverable to 150 shares; an **ordinary** cash dividend is **not** adjusted
  but a **special/large** one **is** (strike cut, sometimes with cash-in-lieu). This is a *different
  operator, under different rules (OCC), for a different data kind* than the exchange's price
  adjustment. MD-13 does say the operator is per-data-kind — good — but the examples and the algebra
  never signal that these operators are non-proportional, non-injective, and rule-divergent.
- **Adjust ≠ re-derive.** A surface *fitted from pre-split option prices then re-coordinated* equals
  the surface *re-fitted from post-split prices* **only** for a clean split (scale invariance). For a
  special dividend, an odd-ratio split with cash-in-lieu, or any rounded/multiplier-changed contract,
  they **disagree** — because rounding and cash-in-lieu break the invariance. So "carry the object
  across the frame" and "re-derive from carried inputs" **coincide only when the operator commutes
  with the derivation**, which is the exception, not the rule.

**The constitutional point (this is why M4 is serious).** C-9 already says it right: *"Derived
quantities are **recomputed from operator-adjusted inputs**."* The operator acts on **leaf market
data**; derived objects are **re-derived from operator-adjusted leaves**, never transported by an
operator of their own. **MD-13 dropped that sentence.** Under CLAUDE.md §1 that is a *narrowing of a
constitutional guarantee* — the more serious failure class, because it reads as still true while
quietly generalising the scalar operator onto objects it does not fit.

**Principle-level fix.** Restore C-9's own distinction in MD-13: **the market data operator acts on
leaf observations; derived objects (surfaces, curves, correlations) are recomputed from
operator-adjusted inputs (MD-6/MD-12), not carried by a scalar operator** — and state plainly that
per-data-kind operators are **not in general proportional or injective** (additive dividend shifts,
strike/multiplier/deliverable re-coordination, cash-in-lieu). The associative-composition and
identity claims survive untouched — they are over frames, per data kind — but the scalar mental model
must go.

**Trading consequence.** Transport a vol surface by a scalar "operator" across a special dividend and
every skew point is wrong by a strike-dependent amount; hedge off it and your vanna/volga book bleeds
on names paying large specials — the single most common place desk P&L-explain shows an unexplained
residual through a dividend.

---

### M5 — MD-14 **overclaims what replay settles.** Replay settles *faithfulness* (is the number the deterministic consequence of the record's own inputs); it does **not** settle an economic dispute between two counterparties with different data, models, or frames.

**The claim.** MD-14: "**any** dispute about a recorded value is settled by replay, not by argument …
A dispute is recomputed, never debated." The worked example: a counterparty contests a collateral mark
that used Tuesday's surface; replay exhibits the datum, provenance, bound model, and frame, reprices
bit-for-bit, "the dispute is recomputed, not debated."

**The desk reality — a collateral dispute is two-sided.** Under a CSA, your counterparty has **their
own mark**, from **their own surface, their own dividend forecast, their own model, in their own
frame**. Your replay reproduces **your** number bit-for-bit from **your** inputs — but *that was never
in dispute*. Nobody claims your arithmetic is unfaithful to your own inputs. They claim your **inputs
and model** are wrong. Their mark **also** replays bit-for-bit from their record. **Two
bit-for-bit-reproducible marks that disagree — replay settles nothing about which is right.** A
collateral dispute is resolved by the CSA dispute mechanism (exchange of marks, then mid-market from N
reference dealers or a third-party valuation agent), not by one side replaying its own chain. Tell a
collateral-management desk that their disputes are "recomputed, never debated" and you will get a
laugh — 2008 was full of marks that each replayed perfectly and were billions apart.

**What replay *does* do — and it is valuable, so keep it.** Exhibiting the datum, its frame, and its
bound model **localises** the disagreement: it shows the two marks differ because one applied the
split to the strike and the other to the multiplier, or one adjusted the option for the special
dividend and the other did not, or the surfaces were fitted in different frames (M3). That is the
genuinely useful output — replay + frame-exhibit **pinpoints the differing input/frame/model**, and
settles the *sub-question* of faithful reproduction. Which input is *economically* correct is price
formation and model choice — **explicitly out of scope (§4)**.

**Second defect — as-at pinning.** Across a corrected/late CA (ratio restated, ex-date moved), "the
disputed valuation" is a mark **as struck on date T**, under the terms **then in force**. To reproduce
*that* number, replay must **pin the as-at to the disputed mark's original cut** — not recompute
as-of-now, which (post-correction) yields a *different* number and "fails" to reproduce the disputed
mark. §3 gets the two-answers structure right (Tuesday-as-published vs Tuesday-as-valued-now), but
MD-14 never says replay must fix the as-at to the mark's own cut. Without that, the dispute-readiness
claim is hollow on exactly the CA-correction case where disputes actually arise.

**Principle-level fix.** Scope MD-14: **replay settles whether a recorded value is the deterministic
consequence of the inputs the record held at its stated (as-of, as-at, frame) — the auditability /
faithfulness question, the only kind a system of record can settle. It localises an economic dispute
to a specific differing input, frame, or model; it does not adjudicate which input is economically
correct (price formation and model choice, §4).** And state that replay is **pinned to the disputed
value's own (as-of, as-at, frame) cut.** Reach exactly as far as reproduction — which MD-14 already
says elsewhere ("its reach is MD-6's"); this makes the opening claim consistent with its own close.

**Trading consequence (the worst in the review).** Read literally, MD-14 says your marks are
undisputable because they replay. In a CSA that is the posture that **manufactures** litigation: it
lets a party systematically post an off-market but internally-tidy mark and wave "it replays" at a
counterparty who cannot challenge it inside the record. Under-collateralisation dressed as
determinism. The fix costs two clauses and removes the free-money reading.

---

## MINOR findings

### m1 — "A corporate action is a recorded transaction like any other" understates the lifecycle the frame principle leans on.

MD-13 (echoing C-9) treats a CA as one atomic recorded transaction. A CA ops desk lives the opposite:
a single event is announced, revised, and completed over weeks, sourced from **DTCC / the exchange /
Bloomberg / Refinitiv that routinely disagree on the terms** and must be golden-sourced before
anything downstream is safe. Deferring CA *terms* to out-of-scope (§4) is a legitimate cut — **but
MD-13 then defines the frame in terms of "the terms in force,"** so it cannot fully wash its hands of
the terms' structure. **Fix (one clause):** acknowledge that "terms in force" is itself a
bitemporal, revisable, sometimes election-contingent, multi-source-reconciled object — so
"fixed by the terms in force" does not read as "fixed and simple." No mechanism, just honesty about
what the frame rests on.

### m2 — The singular "the market data operator" idealises away per-authority operator disagreement.

There is no single operator on a real desk: the exchange's price adjustment, OCC's contract
adjustment, and each index provider's methodology are **different operators that disagree**, and
picking/reconciling them is the actual CA-ops job. The manifesto fairly defers operator *choice* to
model choice (out of scope) and C-9 makes the ledger the authority — fine — but the deferred hard part
should be **named** as deferred, so the doc does not read as if a canonical operator falls out of the
terms. **Fix:** one half-sentence noting operator choice and cross-authority reconciliation are the
deferred hard part, not a solved one.

---

## Summary

| # | Sev | One line | Fix locus |
|---|-----|----------|-----------|
| M1 | MATERIAL | Operator determined by terms *resolved*, not *known* — electives/proration/fixings | MD-13 |
| M2 | MATERIAL | Frame boundary is ex-date (as-of), not terms-known (as-at); announce/cancel/div-announcement | MD-13, §3 |
| M3 | MATERIAL | Arrival frame is an asserted recorded fact; frame = terms **and** convention (PR/TR, rounding) | MD-1, MD-13 |
| M4 | MATERIAL | Scalar-operator model breaks for derived data; **restore C-9's "derived recomputed from adjusted inputs"** | MD-13 |
| M5 | MATERIAL | Replay settles faithfulness, not the two-sided economic dispute; pin as-at to the mark's cut | MD-14 |
| m1 | MINOR | CA-as-single-transaction understates the lifecycle the frame leans on | MD-13 |
| m2 | MINOR | "The" operator idealises away per-authority disagreement | MD-13 |

All fixes are principle-level wording. None adds mechanism. None amends the Constitution — M4 in fact
*restores* a Constitution guarantee (C-9's "derived quantities are recomputed from operator-adjusted
inputs") that MD-13 dropped, and M1 relaxes MD-13 back to C-9's more general statement. **No parking
required.**

**NOT CONVERGED** pending M1–M5.

---

# ROUND 2 — re-review of the revised 1.1 (still 8pp)

Re-read `MarketDataManifesto_1.1.tex` in full. Verified each Round-1 item as printed against desk
reality, and hunted for anything MATERIAL the edits introduced.

## Round-1 items — disposition

**M1 — RESOLVED.** MD-13 (l.413–418): "the operator is determined only once the terms are *resolved*,
not merely announced ... a scrip reference price, a merger's blended consideration ... it exists from
the *resolution* observation, and before that the frame is provisional and legible as such (MD-6),
never a silent wrong number." Desk-correct and precisely the two cases I raised. "Exists from the
resolution observation" is the right formulation — the operator does not pre-exist its resolving fact;
it comes into being when that fact is recorded. The provisional-frame window (post-ex but
pre-resolution — e.g. a merger effective but proration not yet struck) composes correctly with M2
(see below), and lands in MD-6's legible-not-silent failure treatment.

**M2 — RESOLVED.** MD-13 (l.407–411): a CA "carries its own three times. Its **ex-date** is its
as-of --- the moment the price re-coordinates, the frame boundary --- distinct from when its terms
became known. Before ex, or if the action is cancelled, the operator is the identity on the price
series, so a cancelled-before-ex action never forces an un-adjust; an announcement, or a revised
dividend, is not a frame change but new information that refolds projections (MD-5)." Boundary pinned
at ex-date, identity-before-ex, no un-adjust on cancel, announcement/revision as information. Correct.

**M3 — RESOLVED, and strongly.** MD-13 (l.396–405): frame = "the corporate-action terms in force
*and* the declared adjustment convention (which actions the operator applies, price- or total-return,
the rounding rule)"; the arrival frame is "an *asserted, recorded fact* of the observation ---
provenance registered per data kind (§1), never inferred from execution time, since a raw feed
delivers unadjusted but a vendor's back-adjusted series does not. The operator transports from the
*declared* delivery frame, so **a value already adjusted at source is never adjusted again**." §1
(l.108) now registers "the frame it is delivered in" as a data-kind field. The no-double-adjust
clause is the exact operational safeguard against the classic ingest-a-split-adjusted-series-then-
split-it-again bug — the single most common CA-ops data error, now explicitly forbidden at principle
level.

**M4 — RESOLVED, verbatim.** MD-13 (l.427) and MD-10 (l.361–362): "**derived quantities are
recomputed from operator-adjusted inputs** (C-9.3, MD-6, MD-12) ... never scalar-transported"; the
operator "acts on *leaf* observations and is not in general a proportional scalar --- a special cash
dividend shifts a forward additively, a listed option's OCC adjustment re-coordinates strike,
multiplier, and deliverable." The C-9.3 constitutional line is restored in both articles; the scalar
mental model is gone; the two non-scalar examples are exactly the desk cases. The narrowing is
repaired.

**M5 — RESOLVED.** MD-14 (l.465–477): exhibit list now carries "the **cut** it was struck at, the
**frame** it was read in ... the as-at pinned to the mark's own cut, so the number that stood then is
reproduced, not a post-correction one"; bounded to "whether the value is the faithful, deterministic
consequence of the inputs the record held"; and "It does *not* settle a two-sided economic dispute: a
counterparty's mark, from its own surface, model, and frame, replays bit-for-bit too, and which is
right is model choice, out of scope (§4). But exhibiting the frame and the bound model *localises* the
disagreement --- one side applied the split to the strike, the other to the multiplier." The
"undisputable because it replays" free-money reading — my worst-case in Round 1 — is neutralised.

## Edits introduced — trade-tested, all clean

- **"Compose at full precision, round once at read" (MD-13 l.428–431)** is a genuine improvement, not
  a defect. Full-precision function composition is associative; a single terminal rounding makes the
  composite grouping-independent (round-between-operators would break it, correctly flagged). This is
  the desk-correct way to chain adjustment factors — accumulate the factor product at full precision,
  round only the displayed price. One observation, not a finding: this is the *ledger's* declared
  convention and will differ from a vendor that publishes a 4-dp factor and rounds per step; that
  divergence is a frame mismatch (M3), not a reconciliation break — which the frame-carries-the-
  rounding-rule fix already makes coherent.
- **MD-6 lineage now records "the corporate-action events whose frame the operator applied" (l.262–263)**,
  and **MD-8 (l.308–314) / MD-13 (l.448–451) stale any re-entered observation whose lineage reaches a
  corrected or restated CA** ("cannot silently disagree with ... a restated split"). Correct and
  necessary: a ratio correction must flag every surface framed through it. Coherent with the split.
- **MD-15 "valid *on its calibration set*; off-set use is model extrapolation" (l.496–499)** is a
  desk-correct tightening — a surface reprices the strikes it was calibrated to, not the far-OTM wing
  it never saw. Closes a "valid everywhere" overclaim before it could become a finding.
- **§3 worked example (l.529–536)** now separates the two effects cleanly (split reframes 150.20→75.10;
  correction lifts 150.20→150.50; valued-now 75.25). Arithmetic checks (150.50/2 = 75.25).

## One optional clarity note (not a finding, does not block)

MD-13 holds two rules that are individually correct and jointly coherent but stated apart: a *revised
dividend before ex* is "new information that refolds projections" (l.411), while a *corrected or late
CA* is "a superseding event" that stales re-entered observations (l.448). They do not conflict — the
identity-before-ex rule (M2) means a pre-ex revision cannot be a frame change (there is no live
operator yet), so it can only be information; a post-ex correction supersedes the live operator. A
strong-undergraduate reader (CLAUDE.md §6) would be helped by one bridging half-clause making the
before-ex/after-ex split explicit. Optional polish; the content is already right.

## Round-2 disposition

| Item | R1 severity | R2 status |
|------|-------------|-----------|
| M1 operator resolved-not-announced | MATERIAL | RESOLVED |
| M2 ex-date frame boundary | MATERIAL | RESOLVED |
| M3 delivery frame asserted + convention | MATERIAL | RESOLVED |
| M4 derived recomputed (C-9.3 restored) | MATERIAL | RESOLVED |
| M5 replay bounded to faithfulness | MATERIAL | RESOLVED |
| Introduced edits (5, above) | — | all clean, no new MATERIAL |
| Bridging clause before-ex/after-ex | — | optional, non-blocking |

All five MATERIAL findings resolved as printed. No MATERIAL defect introduced by the edits. MD-13 no
longer asserts any determinism a CA desk knows is conditional; the frame/operator/replay story now
survives contact with a live corporate-actions calendar.

**CONVERGED.**
