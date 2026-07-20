# KLEPPMANN — Round 2 Review, Market Data Manifesto 1.0 (rev-2, 7pp)

**Charter:** event-sourcing / data semantics. The log is the source of truth; derived state must
never silently diverge from the record it is derived from.

**Read:** rev-2 `MarketDataManifesto_1.0.tex` (all 12 articles + §1/§3 in full); rev-2
`handoff_note.md`; cross-checked against Constitution C-2.7, C-4.11/4.12, C-9.2/9.3, C-12.1/12.3,
C-14.9/14.15 and calibration_manifesto INV-04/05/07.

---

## Part A — Did my round-1 findings land, semantically?

**M1 (re-entered observation can silently outlive a correction to its inputs) — RESOLVED.**
The projection/re-entered split is now honoured through the whole cascade, and the fix is
semantically right, not just present:

- MD-6 restores INV-05 in full and correctly: "**complete lineage** — the resolved input cut ...
  each pinned to version and cut — and, for a model output, the model version ... reaches through
  the whole chain to the observations at its leaves." This makes staleness *computable from the
  record*, which is what M1a demanded.
- MD-8 (retitled "A broken state cannot hide") splits the two kinds and names the flagship case:
  a projection stores nothing (drift unrepresentable); a re-entered observation "does store a
  number ... cannot drift in place ... but it can fall out of date when an input it consumed is
  later corrected or superseded ... its staleness is a recorded fact ... a flagged open item
  awaiting re-derivation. So the joint spread surface cannot silently disagree with a corrected
  leg." This is exactly the SPX/SX5E scenario I raised, resolved as *detectable-not-silent*.
- MD-5 (late arrival) and MD-10 (correction) both restrict "refolds / recomputes automatically"
  to projections and route the re-entered class to the stale-flag. Consistent.
- I checked the transitivity that makes this airtight: a downstream derived object pins its inputs
  at a cut (MD-12) and its lineage "reaches ... to the leaves" (MD-6), so staleness propagates
  transitively — a derived-object consumer of a stale re-entered observation is itself stale by
  construction. Sound.

**M2 (uniqueness asserted, not mechanised) — RESOLVED.** MD-1 now states the absorption
discipline under the cause-derived identifier (C-2.7/C-12.3/C-14.3), the three-case split
(redelivery absorbed / correction as a distinct later observation naming its target / new print
at the same instant), the grain as a registered property of the data kind (§1), and both failure
modes (over-absorb loses an observation; under-absorb double-counts). Semantically correct and
matches C-2.7 verbatim.

**m1 (numerical environment / bit-for-bit over-claim) — RESOLVED.** MD-6 and MD-12 now treat a
re-entered observation as a *leaf* for reconstruction (read-back unconditional; re-derivation
needs "the retained model and the numerical environment it ran in"). Exactly right.

**m2 (data-kind schema/identity registration not assembled) — RESOLVED.** §1 now states it
positively: "A kind of market data is declared before any observation of it crosses — its fields,
the market data operators ... (C-9.2), and the grain of the cause-derived identifier ... — all
registered on the record first." This is the schema-on-write backbone I asked for, and it ties
the identifier grain (M2) to the registry.

All four prior findings are genuinely resolved. The rev-2 additions I did **not** flag (MD-11's
"seed suffices only because every model output is captured as a re-entered observation"; MD-10's
bulk-retraction summarised-explain; MD-2's honest TA-ARRIVAL capacity boundary; §3's two-numbers
worked example) I checked and each is semantically consistent with the split — MD-11 in particular
correctly closes the C-2.8 "seed is the single non-record input" hole for model-running paths.

---

## Part B — Fresh findings in the new text

### F1 (MATERIAL, fresh). The new "failure is a recorded fact" sentence re-merges the split it sits next to, and reintroduces stored-derived-state drift for the projection kind.

MD-6, rev-2 addition: "A derivation that **fails** --- a fit that does not converge, a solve with
too few inputs --- is itself **a recorded fact**, with its inputs and diagnostics, **exactly as a
failed capture is recorded (MD-2)**: an absent object never passes for one never attempted."

This is the one place in rev-2 where the projection/re-entered split — imposed everywhere else —
was dropped. The two examples given straddle the seam and are treated identically:

- "a fit that does not converge" is a **model run** → a re-entered observation → correctly stored
  as a recorded fact. Fine.
- "a solve with too few inputs" can be a **projection** — a discount-curve bootstrap is a
  deterministic solve over the record, i.e. a projection. Calling its failure "a recorded fact,
  exactly as a failed capture is recorded" **stores** it. The analogy to MD-2 forces the stored
  reading, because a failed capture (an unprocessable arrival) is literally an admitted moveless
  fact on the record (C-4.12).

A stored projection-failure is precisely the pathology MD-8 says "cannot arise" for a projection,
because a projection failure is **not monotone** — it can flip to success when inputs change:

> **Scenario.** Tuesday: the discount-curve projection over Tuesday's quotes fails "too few
> inputs." Per MD-6 as written, that failure is recorded as a fact. Wednesday: a late
> Tuesday-stamped quote arrives (execution time Tue, door time Wed; MD-5) that makes the solve
> succeed. Now the two honest answers diverge: *as-known-Tuesday* the curve genuinely failed;
> *as-recomputed-now* (cut as-at today) it succeeds. A stored "Tuesday failed" fact carries no
> cut coordinate and drifts against the now-view — the projection would succeed on recompute, but
> the stored failure says "failed." A consumer trusting it raises a phantom outage / uses a
> fallback for a curve that is now computable. That is stored derived state diverging from the
> record — the exact thing the document exists to prevent, and the exact thing MD-8's headline
> ("for a projection it cannot arise") promises is impossible.

The staleness case (MD-8's "its staleness is a recorded fact") does **not** have this problem and
I am **not** flagging it: staleness is *monotone* — a re-entered observation that consumed a
since-corrected input is permanently stale, and re-derivation supersedes it forward, so "recorded
fact" there is safe under either reading. Failure is different because it can flip.

**Fix (surgical, one clause).** Carry the split into the failure treatment: a **projection**'s
failure is itself a projection — recomputed on read, cut-parameterised, so it refreshes to
success on a late arrival with an explain item (MD-5), never stored; a **model run**'s failure
re-enters as an observation (stored, and itself subject to staleness if its inputs are later
corrected). A **failed capture** (MD-2) is stored because it is an *input-side* fact (an arrival),
not an *output-side* derivation — the analogy conflates the two and should be narrowed to the
model-run case. This is a one-sentence repair, not a re-architecture; the document is otherwise
one edit from clean.

### m1' (MINOR, fresh). Absorption leaves no auditable trace of the duplicate arrival, so a redelivery is indistinguishable from a feed gap.

MD-1: a redelivery identical under the cause-derived identifier "is **absorbed** as a duplicate,
**not recorded again**." This is correct as *idempotence of effect* (C-12.3: no duplicate effect).
But the wording, taken literally, drops the arrival entirely.

> **Scenario.** Operations suspects a vendor feed is degrading. They ask: did we receive the 15:00
> SPX redelivery and correctly absorb it, or did we stop receiving it (a gap)? If absorption
> leaves no trace, the record after the first print is identical in both cases — a feed that
> healthily redelivers-and-absorbs looks exactly like a feed that has silently died. The
> divergence a market-data operator most needs to see (a feed going quiet) is invisible.

This sits in tension with the document's own capture ethos (MD-2: "never ... drop silently";
C-5.4: the Events Executor "captures the arrival and records it"). Recommend one clause: an
absorbed duplicate produces no new *observation of the value*, but the *fact of the redelivery*
(its arrival provenance / monitor time) is retained, so absorption is auditable and a feed gap is
distinguishable from a redelivery. May be judged a spec/mechanics matter (like the reverse-index),
but the manifesto currently reads as "silently discarded," which its own MD-2 forbids.

### m2' (MINOR, fresh). "Cannot hide" is an auditability guarantee, not a consumption-safety one; name the canonical read path.

MD-8 defends "a broken state cannot hide" by "its staleness is a recorded fact: the recorded
lineage shows the input moved under it." Precisely, staleness is *computable* from the lineage +
record (a projection: does any input in the cut have a superseding observation at a later door
time?). That fully delivers **auditability** — nothing hides from someone who looks. It does not,
by itself, deliver **consumption safety**: a re-entered observation is a plain observation on the
record, and a *terminal* consumer (a risk report, a human) can read its raw value without running
the lineage check and get the stale number unflagged. Derived-object consumers are safe (staleness
is transitive via MD-12); terminal consumers are not, unless they go through the check.

> **Scenario.** A risk report reads "the AAPL vol surface" by pulling the latest re-entered
> surface observation's value directly. An input close was corrected an hour ago; the surface is
> stale. The staleness *is* computable from its lineage, but the report never computed it and shows
> the stale surface with no flag. Auditable after the fact; not caught at read.

Recommend stating the canonical safe read path: consumption of a re-entered observation goes
through a projection — "the current fit for X" = the projection selecting the latest
non-superseded re-entered observation — so ordinary reads inherit the staleness projection and
cannot grab a stale leaf by accident. MD-8/MD-12 gesture at this; making it explicit closes the
gap between "cannot hide" (audit) and "cannot be used unaware" (consumption).

---

## Verdict

- **Prior M1, M2, m1, m2 — all RESOLVED**, and semantically, not cosmetically. The split now
  holds through the cascade; INV-05 and INV-07 are genuinely restored; the SPX/SX5E case is named
  and defeated as *cannot-hide*.
- **Fresh: 1 MATERIAL (F1), 2 MINOR (m1', m2').** F1 is a real regression introduced by the
  rev-2 failure-as-fact addition: it re-merges the projection/re-entered split in the projection
  direction and reintroduces stored-derived-state drift, contradicting MD-8's own headline. It has
  a concrete flip-to-success scenario and a one-clause fix.
- **NOT CONVERGED** — but narrowly. One material improvement (F1) is available, and it is a
  surgical edit, not a redesign. The two minors sharpen "cannot hide" (audit vs consumption) and
  close the absorption-audit trace. Fix F1 and address the minors and I expect the next round to
  converge on my charter.

---

# Round 3 — Convergence check (rev-3)

**Read:** the three changed passages — MD-1 (absorption provenance + grain), MD-6 (failed-
derivation split), MD-8 (current-fit projection consumption) — against the round-2 findings.

**F1 (projection-failure drift) — RESOLVED.** MD-6 now carries the split into the failure
treatment. A **projection** that fails "is itself a projection: its failure is legible by
recomputation, never stored as a standing fact, and refreshes to success if a late arrival fills
the gap (MD-5)" — this is exactly the non-monotone handling; the flip-to-success scenario I gave
is now impossible, because nothing is stored to drift. A **model run** that fails "re-enters as a
recorded observation carrying its diagnostics and lineage, and is itself subject to staleness."
A failed **capture** "is stored for a different reason: it is an input-side arrival, not an
output-side derivation" — the MD-2 analogy that forced the stored reading is correctly narrowed
to the input-side case. Semantically sound; the contradiction with MD-8's headline is gone.

**m1' (absorption leaves no audit trace) — RESOLVED.** MD-1: "Absorption is not a silent drop:
no new value is recorded, but the fact of the redelivery --- its arrival provenance and monitor
time --- is retained, so a healthy absorb is distinguishable from a feed that has gone quiet."
The feed-gap-vs-redelivery scenario is answered directly, and the value is still deduped (no
double-count), so this closes m1' without reopening M2. The grain failure modes are also
tightened ("too fine ... double-counts; too coarse ... loses it"). Sound.

**m2' ("cannot hide" is audit-only, not consumption-safe) — RESOLVED.** MD-8: "a consumer reads
a re-entered observation through a projection --- 'the current fit for X', which selects the
latest non-superseded observation and carries its staleness flag --- never the raw stored value,
so an ordinary read inherits the check." This is the canonical read path I asked for; a terminal
consumer now inherits the staleness projection by default rather than being able to grab a stale
leaf. Sound.

**Fresh-material hunt on the three edits — nothing material.** I checked the one candidate: MD-8's
absolute "never the raw stored value" reads, in isolation, against MD-12's requirement that a
derived object pin a *specific* re-entered observation at a cut for deterministic composition
(pinning O1-at-cut-C is, literally, referencing a stored value). These reconcile — "consumer"
means the *terminal* reader in MD-8 (who wants the current value) and the *derivation input* in
MD-12 (which wants a fixed historical input, staleness then propagating transitively to its own
current-fit projection). Both readings are correct and the document as a whole (MD-12 explicit on
pinning) fixes the intended one; there is no scenario where the system does the wrong thing. Per
my own discipline (no failure scenario = not a finding) this is a non-material clarity note, not a
finding: if the drafter wishes, MD-8's "never the raw stored value" could be scoped to "for a
current-value read" to remove the surface tension, but it is not required for correctness.
(I also considered redelivery-provenance volume — a chatty feed retains many arrival markers —
but that is a capacity/mechanics matter explicitly deferred like TA-ARRIVAL, with no
correctness consequence: the value is still recorded once.)

## Round-3 verdict

- **F1 RESOLVED. m1' RESOLVED. m2' RESOLVED.** All three landed semantically, not cosmetically.
- **No material finding introduced by the edits.**
- **CONVERGED** on my charter (event-sourcing / data semantics). The log-of-observations model is
  now airtight in both directions: derived state cannot silently diverge from the record — a
  projection recomputes, a re-entered observation is frozen with complete lineage, stale on input
  correction/late-arrival, flagged as an open item, and consumed through a current-fit projection
  that carries the flag; duplicates are absorbed under the cause-derived identifier with the
  arrival retained; corrections repair forward with the cascade split correctly by kind;
  failures are facts of the right kind. A further round would produce no material improvement on
  my charter.
