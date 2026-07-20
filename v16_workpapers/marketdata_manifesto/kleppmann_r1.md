# KLEPPMANN — Review of Market Data Manifesto 1.0

**Charter:** event-sourcing and data semantics. The log is the source of truth; every
derived view is a pure function of it; derived state must never silently diverge from the
record it is derived from. I review semantics, not prose (TALEB gates comprehensibility).

**Documents read in full:** `MarketDataManifesto_1.0.tex` (MD-1..MD-12); `handoff_note.md`;
Constitution `ledger_manifesto_v1_4.tex` (C-2.7 three-times, C-2.8, C-4.8, C-4.11, C-4.12,
C-9.2/9.3, C-11.5, C-12.1/12.3/12.4/12.6, C-13.2/13.3, C-14.3/14.9/14.11/14.15);
`calibration_manifesto.tex` (spot-checked A1–A7, INV-01..INV-10, the spread-option broken-state
section).

**Headline.** The rev-1 two-name split (projection vs. re-entered observation, closing the
FORMALIS D1 relabel trap) is the right architecture and I endorse it. My findings are all one
shape: **the split is introduced in MD-6/MD-7 and then not honoured in MD-8, MD-10, MD-5, and
MD-12**, which revert to saying "every derived object" recomputes/refolds. That silently
re-merges the two classes exactly where the distinction is load-bearing — the correction and
late-arrival cascades — and it drops the calibration manifesto's guard (INV-07) for the class
that, by C-14.9, the ledger will *not* recompute. This is the classic derived-state-diverges-
from-source hazard, appearing precisely where the document claims (MD-8) it has been designed out.

---

## MATERIAL

### M1. A re-entered observation can silently outlive a correction to its inputs (the dual-write hazard, at the model boundary)

**The mechanism the document relies on, and where it breaks.** A *projection* is recomputed
on read, so a correction to its inputs cascades automatically — airtight. A *re-entered
observation* (any model output: a fitted surface, a filtered calibration, a joint vol/corr fit)
is, by C-14.9, **not** run by the ledger. Its number is frozen on the record as an observation.
When an input it consumed is later corrected (MD-10) or a late arrival lands in its window
(MD-5), the frozen value does **not** recompute — the ledger cannot re-run the model. Yet the
document asserts, without carving out this class:

- MD-8: "A derived object is *always* recomputed from the record … so it cannot lag the record."
- MD-10: "*every* derived object recomputes automatically."
- MD-5: "*every* derived object downstream refolds."

All three are true for projections and **false for re-entered observations**. MD-8 goes furthest:
it declares the drifted-parameter pathology *unrepresentable* ("there is no stored parameter to
drift"). But a re-entered observation **is** a stored parameter — that is what "the ledger records
model outputs and never runs one" (C-14.9) means. The pathology the calibration manifesto named
(θ_sys ≠ θ*) is representable again, one level up, for every model output on the record.

**Worst scenario — MD-8 dissolves the very example it cannot dissolve.** MD-8's spread-option
argument: "the surface for one index and the surface for another are two reads of one record …
an on-demand read is the correct joint conditional expectation and no divergence can be stored."
This silently assumes the joint surface is a recompute-on-read *projection*. The calibration
manifesto's flagship broken state (calibration_manifesto §"Spread options and asynchronous
volatility updates") is a **joint vol+correlation calibration** — an optimiser/filter, i.e. a
model run, i.e. a *re-entered observation* under C-14.9, **not** a projection. Concretely:

1. Tuesday: a joint SPX/SX5E vol+correlation fit runs in the (governance-retained) model and
   re-enters as observation `O` with value `V`, consuming Tuesday's SPX and SX5E option quotes.
2. Thursday: the exchange corrects one Tuesday SPX quote — a forward repair, a new observation
   naming the wrong one (MD-10).
3. Every *projection* over that quote recomputes on read. But `O` still sits on the record with
   value `V`, computed from the **wrong** SPX quote. The ledger will not re-fit — C-14.9.
4. Friday, a spread-option mark reads `O`. It gets the stale joint surface. **Nothing flags it.**

MD-8 claims this exact state "cannot be represented." It can. MD-8 dissolves it only by
reclassifying a model run as a projection.

**Why detection is not automatic here (and why the document currently has no mechanism).**
The framework's whole stance is detection-not-prevention (C-13.2/13.3). For the projection class,
detection is free (recompute and compare). For the re-entered class it is **not** free — it
requires two things the manifesto does not mandate:

- **(1a) Recorded lineage strong enough to detect staleness.** MD-6 says the re-entered
  observation re-enters "carrying its provenance (C-14.15)" — and C-14.15 says "sufficient
  provenance," but sufficient *there* means "enough to reproduce the number given the model,"
  which is a **different** sufficiency from "enough to know when an input changed under me."
  The calibration manifesto had the stronger, correct form and the extraction weakened it:
  **INV-05 — "Every calibrated parameter set carries a complete provenance chain back to *all*
  input attestations and the MCA"** — became "carrying its provenance." To detect staleness the
  re-entered observation must record its **resolved input cut** (the specific observations it
  consumed, each pinned to version+cut) and the **model version**, on the record, as its own
  provenance. "Carrying its provenance" does not compel that; INV-05 did.

- **(1b) A staleness signal — dropped entirely.** The calibration manifesto's **INV-07 —
  "When the age of a calibrated object *or its inputs* exceeds thresholds … staleness is
  signalled"** — is the guard for exactly the case where the object cannot auto-recompute. It is
  in **no** article. The handoff exclusion table claims "INV-01…INV-10 … folded into the
  articles," but INV-07's substance (a signal when an *input* to a frozen derived object is
  superseded) is nowhere. It was dropped on the belief that MD-8 dissolves the need — but MD-8
  only covers the projection class, so INV-07 was dropped precisely where it is still required.

**Fix (direction, not prose).** Restrict the "recomputes automatically / cannot lag / refolds"
claims in MD-8, MD-10, MD-5 to **projections**. For the re-entered-observation class, state the
detection-not-recompute treatment explicitly: a re-entered observation records its resolved input
cut and model version (restore INV-05's strength); and when any input in that recorded cut is
corrected (MD-10) or superseded by a late arrival (MD-5), the re-entered observation is flagged
as a **visible open item / named explain item** requiring re-derivation — it does not, and cannot,
silently recompute (restore INV-07). This keeps the two-name split honest all the way through the
cascade, and it is the *positive* version of MD-8: the drift is not unrepresentable, it is
**detectable**, which is all the framework ever promises anywhere else.

### M2. "Recorded exactly once" is asserted, never mechanised — the absorption discipline is missing on the highest-duplication surface in the system

MD-1: "an observation is recorded exactly once … Nothing about market data is written twice."
This names the *result* (uniqueness) but not the *mechanism*. The Constitution supplies the
mechanism — the **cause-derived identifier**: "An arrival identical under the cause-derived
identifier is a duplicate to be absorbed, never a neighbour to be ordered" (C-2.7); idempotence
under it (C-11.5, C-12.3); "a duplicate is harmless because of idempotence checking" (C-14.3).
The manifesto **never cites C-12.3, C-14.3, or the cause-derived identifier**, and never uses the
words absorb, duplicate, or idempotent. Market data is where redelivery is most severe — vendors
resend snapshots, replay incrementals, double-publish across venues — so of all documents this is
the one that must state the absorption discipline, and it is silent.

The silence is not merely cosmetic; it leaves a genuine ambiguity unresolved. Three arrivals must
be told apart, and only the cause-derived identifier's **grain** tells them apart:

- the *same print redelivered* → absorbed (idempotence, C-12.3);
- a *restated print* → a correction, a new observation naming the old one (MD-10);
- a *genuinely new print at the same instant* → a second observation, recorded.

**Scenario.** Two real trades print at the identical execution instant on the same venue at
different prices. If the cause-derived identifier for this data kind keys on
`(source, observable, execution-time)`, the second collides with the first and is **silently
absorbed — a lost observation**, a capture-guarantee breach (C-4.12). If it keys on
`(…, value)`, a benign metadata-jittered redelivery of one print is recorded **twice** and
double-counts in any averaging/weighting recipe. The manifesto must state (i) that market-data
redelivery is absorbed by idempotence under the cause-derived identifier (C-12.3), and (ii) that
the identifier's grain is a **registered property of the data kind** (ties to m2). Without this,
MD-1's "exactly once" is a guarantee by fiat, and an implementer cannot tell which of loss or
double-count they will get.

---

## MINOR

### m1. MD-12 "bit-for-bit from the record" over-claims for any chain containing a re-entered model output

MD-12: "bit-for-bit reconstruction runs that chain from the record." True for a chain of
projections. For a chain that passes through a re-entered observation, reconstruction-from-the-
record reaches that observation's **recorded value** (a leaf input) but cannot *reconstruct that
value* — that needs the retained model (C-14.15) and, as the calibration manifesto was careful to
state (A6/INV-04: "the code version and numerical environment … up to the numerical tolerance
declared in that environment"), the retained numerical environment. MD-6's reproduction clause
drops the numerical-environment dependency and MD-12 then claims bit-for-bit over the whole chain.
Fix: treat a re-entered observation as a **leaf input** for reconstruction (its recorded value),
not a reconstructible node; and either restore the numerical-environment caveat or fold it into
the "retained model … governance, out of scope" carve-out explicitly.

### m2. The data-kind schema/identity discipline is inherited but never assembled into a market-data article

Question 5 asks whether anything contradicts the Constitution's registry/capture discipline.
Nothing **contradicts** it — but for *the* market data manifesto, the schema-on-write backbone is
under-stated. The pieces are cited piecemeal: C-4.12 quarantine of an undeclared kind (MD-2), and
C-9.2 operators "declared once … never improvised" (MD-10). What is never stated positively is the
market-data registration act: **a data kind — its fields, its market data operators, and its
cause-derived-identifier (identity) grain — is registered on the record before any observation of
that kind crosses the door.** This is the schema-on-write discipline for observables, and it is
where M2's "identifier grain is a registered property of the data kind" lands. Recommend one
explicit sentence or short article. Rated MINOR because every piece is inherited from the
Constitution; the gap is that they are not assembled where a market-data reader needs them.

---

## What the extraction got RIGHT (so the record is fair)

- The **two-name split** (MD-6, D1) is correct and closes the reproducibility-relabel trap.
- **MD-4** maps as-of/as-at onto execution/door faithfully; monitor time kept as provenance —
  no bitemporal feature bolted on, exactly C-2.7.
- **MD-5** handles out-of-order arrival with an execution-ordered fold and tail refold + explain
  item (C-2.7/C-12.6). No article assumes in-order arrival. (Its only defect is the "every derived
  object refolds" over-claim = M1.)
- **MD-10** correctly separates a *correction* (forward repair, new observation naming the old,
  C-12.4) from a *corporate-action adjustment* (market data operator, computed at each read,
  C-9.2/9.3). Clean, and the worked example gets the correction-vs-late-arrival distinction right.
- **MD-9** correctly places no-arbitrage on the derived object, not the record (the record may
  hold crossing quotes) — faithful to A3→derived and to capture-precedes-judgement.
- **INV-08** (dependency ordering / "mid-update input") is faithfully carried as **MD-12**; the
  pin-to-cut argument is sound for that concern (distinct from M1's staleness concern).

---

## Verdict

**2 MATERIAL, 2 MINOR.** M1 and M2 each carry a concrete failure scenario and are, in my
charter, real: M1 is a derived-state-diverges-from-source hazard the document claims to have
eliminated; M2 is an unmechanised uniqueness assertion on the system's highest-duplication
surface. Both are fixable **within** the Constitution (they specialise C-14.9/14.15/12.3/12.4 and
restore calibration-manifesto INV-05/INV-07) — no park required. Because both would materially
improve the semantics, this is **NOT CONVERGED**; one more round addressing M1 and M2 is
warranted. The prose is not my gate.
