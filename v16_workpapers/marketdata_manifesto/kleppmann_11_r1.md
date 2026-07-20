# KLEPPMANN — Review of Market Data Manifesto 1.1 (amendment), Round 1

**Charter:** event-sourcing / data semantics — the log is the source of truth; derived and
frame-transported state must never silently diverge from the record. **Scope of this review:** the
NEW 1.1 machinery only (MD-13 frames + operator algebra; MD-4 frame coordinate; MD-10 recast as
change-of-frame; MD-14 dispute-readiness; MD-15 model binding + MD-6 lineage extension). The 1.0
core (MD-1..MD-12) is certified and I converged on it; I re-touch it only where 1.1 loads new
weight onto it.

**Read:** `MarketDataManifesto_1.1.tex` (all 15 articles + §1/§3/§4/Amendment Record in full); the
handoff note's 1.1 section; cross-checked against Constitution C-9.1/9.2/9.3, C-4.6, C-2.7, C-14.9.

**Headline.** The frame/operator design is mostly right and honestly stated — the operator is a
*projection* computed at read (never a stored adjusted series), the inverse story is honest
(forward composition from preserved originals, no reliance on inversion), and the commutation
claim is correctly conditioned on a fixed as-at cut. But the amendment opens **two divergence
paths on my charter**, both where the new frame machinery meets the certified re-entered-
observation / staleness discipline. In both, a *projection* stays correct (recomputes at read)
while a *re-entered observation* or an *incoming value* silently carries the wrong frame — the
exact class of silent divergence MD-8 claims cannot hide, reintroduced one level up by corporate
actions.

---

## Attack (1) + (4): a corrected corporate-action ratio does not flag stale the fits that consumed the old frame — MATERIAL

**The mechanism.** The market data operator is a projection over `(recorded raw value, recorded CA
terms)` (MD-13: "a deterministic projection --- computed from the recorded action terms and the
recorded value"). So a frame-adjusted value's lineage depends on the **CA event** (the ratio), not
only the raw price. MD-13 correctly says a CA "recorded late, or corrected, is a superseding
recorded event (MD-5, MD-10), so it moves the frame only in a later as-at cut, never silently."

But "moves the frame" is the **projection** side — it recomputes at read, airtight. The
**re-entered-observation** side is not closed. MD-6's lineage enumeration is: "every observation
and derived object it consumed, each pinned to version and cut --- for a model output the model
version, and for any datum used in valuation the model it is bound to." **Corporate-action events
(frame terms) are not in this enumeration.** A CA is a recorded transaction (C-9.1), neither an
"observation" nor a "derived object" nor a "model." And MD-8/MD-10's staleness trigger is written
for a corrected *market-data fact* ("a re-entered observation that consumed the wrong fact"), not a
corrected *CA term*. So the structural staleness check ("its lineage shows the input moved under
it", MD-8) has nothing to fire on when only the CA ratio moves.

> **Scenario.** Tuesday: AAPL close 300 recorded (pre-split frame). Next week: a 2-for-1 split is
> recorded; the operator now carries 300 → 150 at read. A vol surface is **fitted** (model run →
> re-entered observation `O`) consuming the post-split adjusted 150; `O`'s lineage records
> "consumed adjusted-AAPL-price at cut C." Later the ratio is **corrected** — it was actually
> 3-for-1 — recorded as a superseding CA event with a later door time; the operator now carries
> 300 → 100. Every **projection** over the adjusted price recomputes (150 → 100): correct. But `O`
> is a frozen re-entered observation whose raw-price leaf (300) never moved — only the CA event
> did, and the CA event is not a watched lineage input. So the staleness projection does **not**
> flag `O`. A consumer reads "the current fit for X" (MD-8) and gets `O`, fitted under the wrong
> split ratio, **with no staleness flag**. The frame-adjusted projections and the fitted surface
> now disagree, silently — a fit outliving a corrected split. This is exactly the M1 failure the
> document closed for price corrections, reopened for CA-terms corrections.

**Why MD-13's "never silently" does not save it.** That clause governs the frame *move* (the
projection recompute + explain). It does not say the re-entered observations that consumed the old
frame are flagged stale, and — because MD-6's lineage omits CA events — the general MD-8 machinery
cannot reach them. The drafters clearly intended corrected CAs to propagate (they wrote the
superseding-event sentence); they closed the projection half and left the re-entered half open.

**Fix (surgical, two clauses).** (i) MD-6: extend the lineage enumeration to name **recorded
corporate-action events (the frame terms the operator applied)** as a pinned lineage input — a
frame-adjusted value's lineage includes the CA event, and so, transitively, does every re-entered
observation that consumed one. (ii) MD-13/MD-8: state that a corrected or late CA term, being a
superseding event, **flags stale every re-entered observation whose lineage reaches it**, exactly
as a corrected price does — not only recomputes the projections. Then the CA-correction cascade is
symmetric with the price-correction cascade the document already guarantees.

## Attack (2): the frame of an *incoming* value is assumed, not recorded — adjusted-series feeds double-adjust — MATERIAL

1.1 makes frame a coordinate of every value ("a quote is meaningful only given a time coordinate
and a frame", MD-13; MD-4 "one coordinate more than these times"). For the coordinate to be
load-bearing, the frame of each recorded value must be **recorded or derivable**. For a
source-delivered value it is neither recorded nor correctly derivable — it is **assumed**. MD-13
defines: "The unadjusted frame holds a value **as observed**, under the terms at its execution
time." This conflates *as observed* (what the source sent) with *the execution-time / unadjusted
frame*. True for a raw exchange feed; **false for an adjusted-series vendor feed**, which is a
large fraction of real market data (split-adjusted histories, total-return series, back-adjusted
futures).

> **Scenario.** A vendor delivers a split-adjusted AAPL history: "AAPL as-of Tuesday-last-week =
> 75.10" (already adjusted for a 2-for-1 that occurred since). The system records it as an
> observation with execution time Tuesday-last-week. Per MD-13 a raw observation "lives in the
> unadjusted frame ... under the terms at its execution time" — so the system treats 75.10 as the
> **unadjusted** Tuesday close. A consumer asks for the current (post-split) frame; the operator
> applies the split **again**: 75.10 → 37.55. **Double-adjusted, wrong by 2x.** The same value now
> lives in two frames that disagree — the reconciliation failure the manifesto exists to remove,
> introduced by the frame coordinate it just added.

The registry mechanism to fix this already exists (§1: a data kind registers its fields and
operators) — it simply omits the delivery frame. **Fix:** the frame a source delivers in is a
**registered property of the data kind** (and/or recorded observation provenance), not inferred
from execution time; MD-13's definition must decouple "as observed" from "the execution-time
frame" — a value is delivered in a *declared* frame, which may be the execution-time frame (raw
feed) or a later adjusted frame (adjusted series). The operator then transports *from the declared
delivery frame*, and never re-applies an adjustment already baked in.

## Attack (3): MD-15 round-trip validation — the split holds — no material finding

Round-trip repricing runs the model, so it is a **re-entered observation**, not a projection.
MD-15 classifies it correctly: "Both [calibration and validation] are derived objects over
recorded inputs and the declared model term (MD-6), so model-binding never undoes the split, and
the repricing residual is a recorded diagnostic (MD-9)." The residual is a model output → recorded,
read-back unconditional, re-derive needs the retained model + numerical environment (inherited by
the MD-6 reference); the validity verdict (residual vs. declared tolerance) is a projection over
that residual. Binding is recorded lineage (which model, which version), not a truth-claim —
consistent with the 1.0 Conflict-C6 exclusion. The split holds; no re-classification of a raw
observation as a model output. **Clean on my charter.**

*Minor (m1):* MD-15 leaves implicit that the repricing residual, being a re-entered observation,
is itself subject to **staleness** when the datum, the source-instrument prices, or the model
version are later corrected — it is carried only by the MD-6 reference. One clause ("the residual
is a re-entered observation, stale if its inputs move, MD-8") would make the validation diagnostic
obey the same discipline as any other fit, and would also interact correctly with M1 (a corrected
CA ratio should re-open a validation residual computed in the old frame).

---

## What the amendment got right (so the record is fair)

- **MD-13 operator honesty:** the inverse story is correct (most operators non-injective under
  minor-unit rounding C-4.6; framework needs no inverse; every frame reached by forward composition
  from preserved originals C-9.3). No over-claim.
- **Operator is a projection, computed at read** (MD-13/MD-10/C-9.3) — so there is no *stored*
  frame-transported series to drift; the only drift surface is a re-entered observation that
  *consumed* a frame-adjusted value, which is exactly attack (1). Good containment.
- **Commutation** correctly conditioned on a fixed as-at cut, with the necessity counterexample
  (a CA known only at the later cut) — the operator leaves as-of/as-at unchanged, which is the
  right reason, not "orthogonal."
- **MD-14 reach-bounding:** "replay reaches exactly as far as reproduction, never wider" — a
  model-based valuation is dispute-ready only once the model is supplied (C-14.15). Honest; no
  over-promise despite the title.
- **MD-15 price-space framing** holds the projection/re-entered split and keeps model-binding as
  recorded lineage, not a truth-claim.

## Verdict

- **Attack (1)+(4): MATERIAL** — corrected/late CA terms do not flag stale re-entered observations
  that consumed the old frame; MD-6 lineage omits CA events. Concrete silent-divergence scenario.
- **Attack (2): MATERIAL** — the delivery frame of an incoming value is assumed (execution-time /
  unadjusted), not recorded; adjusted-series feeds double-adjust. Concrete scenario.
- **Attack (3): clean**, one MINOR (m1: state the validation residual's staleness explicitly).

Both material findings are the same shape — the new frame machinery closes the **projection** half
of a cascade and leaves the **re-entered / incoming** half open — and both are fixable **within**
the Constitution (extend MD-6 lineage to CA events; register the delivery frame per data kind). No
park required. Because both would materially improve the semantics, this is **NOT CONVERGED**; one
round addressing M1 and M2 is warranted.

---

# Round 2 — Convergence check (1.1 revised)

**Read:** the changed passages — §1 (data-kind registration), MD-4, MD-6 lineage, MD-8, MD-10,
MD-13 (rewritten, now carrying ex-date / terms-resolved / full-precision material), MD-15.

**M1 (corrected CA does not flag stale fits) — RESOLVED, and at the same discipline as a price
correction, not weaker.** Verified on all three touch-points:
- MD-6 lineage now enumerates, as a pinned input, "the corporate-action events whose frame the
  operator applied (MD-13)", and states lineage reaches "the corporate actions behind its frame".
  The CA event is a first-class lineage leaf.
- MD-8 routes it through the *identical* mechanism as a wrong price: "when an input it consumed is
  later corrected or superseded --- a wrong price, or a corrected corporate action behind its
  frame, **both pinned lineage inputs** --- ... its lineage shows the input moved under it, and the
  stale fit stands as a flagged open item for re-derivation". Same trigger (a pinned input moved),
  same effect (flagged open item → re-derivation), same consumption path ("current fit for X"
  carrying the staleness flag). No weaker.
- MD-13 states it outright: "A corrected or late corporate action is a superseding event (MD-5,
  MD-10): every projection over the old frame recomputes, and --- the action being a pinned lineage
  input (MD-6) --- **every re-entered observation whose lineage reaches it is flagged stale,
  exactly as a corrected price does**."
My round-1 scenario (a vol surface fitted under a 2:1 ratio, ratio later corrected to 3:1) now
flags the surface stale — the raw price never moved, but the CA event did and it is a watched
lineage input. Closed.

**M2 (incoming frame assumed → double-adjustment) — RESOLVED; the 75.10 → 37.55 path is
unconstructible from the printed text.** §1 registers "the frame it is delivered in" as a data-kind
property; MD-13 decouples *as observed* from *unadjusted*: "The frame a value arrives in is itself
an asserted, recorded fact of the observation --- provenance registered per data kind (\S1), never
inferred from execution time, since a raw feed delivers unadjusted but a vendor's back-adjusted
series does not. The operator transports from the **declared** delivery frame, so a value already
adjusted at source is never adjusted again." An adjusted-series feed registers an adjusted delivery
frame; the operator starts there and does not re-apply the split. The double-adjustment is now
impossible to construct without *mis-registering* the delivery frame — which is a source assertion,
already covered by MD-3's trust-assumption discipline (a minor: it could be named beside the grain
/ TA-ARRIVAL for symmetry, but it is not a divergence path).

**Minor (MD-15 validation residual staleness) — RESOLVED.** "the repricing residual is itself a
re-entered observation --- a recorded diagnostic (MD-9), stale if its inputs later move (MD-8),
never a silent pass." Explicit now; the split holds and the residual obeys the same staleness
discipline as any fit.

**Ex-date / terms-resolved sanity check — no fresh material divergence.** The new machinery is
sound on my charter:
- *Late resolution is covered by the as-at dependence.* The operator "is determined only once the
  terms are resolved ... it exists from the resolution observation, and before that the frame is
  provisional and legible as such (MD-6), never a silent wrong number." A resolution observation
  arriving late has a door time; the composite operator differs across that cut exactly as MD-13's
  "an action whose door time falls between two cuts is known only at the later" already governs. A
  fit built in the provisional window has the CA in its lineage; the resolution is a *late corporate
  action* → a superseding event → it flags that fit stale by the same MD-13 cascade as M1. No
  silent provisional-then-wrong number: the provisional read is flagged, and resolution supersedes
  it forward, never edits.
- *Anti-scalar-transport is the right call and closes attack-4 directly:* "derived objects ---
  surfaces, curves, correlations --- are never transported by an operator of their own; derived
  quantities are **recomputed from operator-adjusted inputs**". A fitted surface is never
  frame-moved by applying the price operator to the surface; its post-action version is a re-fit
  (a new re-entered observation), and an absent re-fit is legible (MD-6), not a silent wrong frame.
- *Full-precision composition, rounding once at read* — makes the composite grouping-independent so
  two parties reconstruct the identical value; this removes a determinism hazard rather than adding
  one.

*Two non-material clarity notes (no scenario constructs a wrong number; would not materially
improve the semantics):* (i) a resolution completing a provisional operator is classified as "a
late corporate action" only implicitly — one clause tying resolution explicitly to the
superseding-staleness cascade would make it airtight; (ii) provisional-ness is legible via lineage
(audit) but, like staleness before m2', could be surfaced as a first-class flag on the "current fit
for X" consumption projection. Both are surfacing niceties, not divergence paths.

## Round-2 verdict

- **M1 RESOLVED** (same discipline as a price correction, verified across MD-6/MD-8/MD-13).
- **M2 RESOLVED** (delivery frame registered + declared-frame transport; double-adjustment
  unconstructible).
- **MD-15 minor RESOLVED.**
- **Ex-date / terms-resolved: no fresh material finding.** Late resolution is covered by the as-at
  dependence and the superseding-staleness cascade; anti-scalar-transport closes the derived-object
  frame-drift path; only two non-material clarity notes remain.
- **CONVERGED** on my charter (event-sourcing / data semantics). The frame/operator machinery now
  holds the projection / re-entered-observation split through the whole corporate-action cascade,
  in both the correction direction and the incoming-value direction; a further round would produce
  no material improvement.
