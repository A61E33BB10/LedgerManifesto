# v16.1 Pass — Round 1 STYLUS review (findings only; no edits applied)

Reviewer: STYLUS (review instance), cold read of the drafting instance's work.
Target: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex`. File is AT the 112pp cap; every
replacement below is net-zero-or-negative in lines.

---

## S1 — thm:refold scope/non-claim in one sentence

Current (lines 1245–1247), two sentences:

> The theorem is over the fold state alone. It does \emph{not} claim that settled money,
> emitted external effects, or already-fired notifications are rewound; those are C-12.6's
> residue --- the restated flag, the explain item, the open item discharged only by
> authorised compensation (f).

Verdict: collapses to one sentence, net **negative** (drops "It does ... those are").
Preserves both the theorem's silence on the three items and the fact that they are handled
by residue. Replacement:

> The theorem is over fold state alone and claims nothing of settled money, emitted external
> effects, or already-fired notifications: these are not rewound but discharged as C-12.6's
> residue --- the restated flag, the explain item, and the open item that moves only under
> authorised compensation (f).

"fold state" is glossed by the theorem body itself (1238–1239, "balances and the three
homes"); no re-gloss needed. "claims nothing of X" keeps the theorem's scope precise (silent
on X, not asserting X false); "these are not rewound but discharged as ..." states the actual
handling, which is established at step (f) (1222, "money does not"). No claim widened.

---

## S2 — three-time role statements: state once, refer thereafter

**Canonical (operational) role home = ch04 Events Executor, 1009–1027.** All three "whose
clock / what for" roles are fixed there: execution (1009–1016), monitor (1018–1023), door
(1025–1027). This is the intended single site (memory: canonical wording fixed in ch04; ch02
§bitemporal 384–387 disclaims the three times to ch04).

**Sanctioned preview (not a defect):** ch01 §Order (189–194) glosses each time in one clause
each with a `(Chapter 4)` forward pointer, and defines the total-order triple and "refold"
in place. The eight-commitments section previews by design; keep.

### Re-establishment sites (defects — role re-defined, not referred)

**Monitor time — clearest defect.** ch02 §bitemporal (381–384) fully re-defines the role
("provenance only and orders nothing; with execution time it splits an event's lateness into
the world's segment, execution to monitor, and ours, monitor to door") — a verbatim
duplicate of ch04 1019–1021, for a time that isn't even one of the two axes the section
claims to fix. Its own next sentence (384–387) defers the three times to ch04. Cut the
duplicated role; "indexes no view" suffices locally. Replacement for 381–387:

> A third time, \emph{monitor time} --- when the Event Monitor observed the event at the
> boundary (Chapter~\ref{ch:machines}) --- is recorded on every event but indexes no view.
> It, the other two times, and the total order the fold obeys are fixed in
> Chapter~\ref{ch:machines}; this section fixes only the two axes a historical view rides on.

Net: **−1 to −2 lines**; monitor time's role now established once (ch04).

**Lateness split re-stated.** The two-segment definition "execution to monitor / monitor to
door" recurs at 383–384 (cut above), 1020–1021 (canonical, keep), 1220–1221 (step (e)), and
is *instanced* at 1333–1334 (workflow — legitimate example, keep). Site 1220–1221 re-glosses
the segments where a bare reference would do; acceptable but noted (could read "attributed to
the reordering, its cause, and its lateness segments (\S Events Executor)").

**Door time "never sets meaning" — duplicate.** 1027 ("says when the book learned, never
what is true") and 1116 ("door time never sets meaning") state the identical claim ~6 lines
apart. Cheapest cut: drop the clause "; door time never sets meaning" at 1116 (the sentence
already ends its work at "by admission sequence"). Definition (1027) owns the claim.

**Door time "strictly monotonic" — thrice.** 1026 (definition, owns it), 1111 (Transaction
Executor output), 1172 (premise for totality). 1172 needs the premise to argue totality — a
legitimate *use*, keep, but it re-glosses rather than refers. Diffuse; sharpest single cut
remains 1116 above. No action forced beyond noting the definition (1026) is the owner.

**Execution-time stability re-stated.** "corrected by a later event, never edited at the
door" appears at 1015–1016 (execution-time def, cites TA), 1249–1251 (thm hypothesis), and is
the *content* of TA-EXECUTION-TIME at 6716–6727 (its proper home). At 1249–1251 the gloss
duplicates the TA; the load-bearing part is only "so $e$'s position is well-defined." Trim to
reference: "execution-time stability (TA-EXECUTION-TIME), which fixes $e$'s position." Net
**−1 line**.

**Borderline (different role, not pure repeat — no action):** ch02 366–372 states door and
execution in their *axis* role (log prefix ↔ door, knowledge horizon ↔ execution) — a
distinct role from ch04's operational one, legitimately owned by §bitemporal; overlap is only
the glosses "position the writer assigns" / "happened in the world." ch04 total order 1170
("Execution time carries the meaning") justifies the lex order locally — a use, keep.

---

## S3 — mitigation table "why" column: circularity audit

Rows 1263–1276. Verdict per cell (does the *why* give an independent reason, or restate the
verdict?):

| Row | Verdict | Why | Independent reason? |
|---|---|---|---|
| Snapshot + incremental refold <p | yes | acceleration; bit-identical (Thm) | ✓ it is a faster route to the same fold |
| Refold only invalidated tail | yes | what step (c) specifies; prefix <p unchanged | ✓ names the spec + the invariant |
| Tolerance window ≥N days | no | caps lateness; drops court-enforceable exec time | ✓ names the harm (discards a legal fact) |
| Finality cutoff | no | book stays knowingly wrong --- covered-call failure | ✓ names the harm (knowingly-wrong book) |
| Fold in door order | no | fold order ≠ execution order; contradicts C-2.7 | ✓ names mechanism + binding source |
| Snapshot by door position | no | stale after interior insertion; returns wrong state | ✓ names mechanism (staleness) |

**No cell is circular.** Every "why" names a mechanism, harm, or binding source rather than
re-asserting the verdict. Nothing to rewrite for circularity.

Two minor (Landau, not circularity — optional):
- Row 6 tail "returns wrong state" restates the consequence already implied by "stale after
  an interior insertion"; could drop for −0 impact.
- Rows 3 and 4 are two variants of "refuse late arrivals" failing for one root reason
  (dropping execution times / knowingly-wrong book). One row could carry both if a line were
  ever needed; not required now.

---

## S4 — sec:substrate (1339–1362): one result per sentence; Temporal leakage

**Density flags (sentence carries ≥2 results):**

- **1341–1342** (semicolon, two results): "The three times and the refold are ledger facts;
  the orchestration substrate ... supplies none of them and stores none of them." Split:
  premise + consequence are two statements.
- **1343–1346 (worst — ~4 results in one sentence):** "The substrate holds only schedules in
  flight and orchestration position; it survives no wipe, and its own clocks --- an
  orchestration clock, an activity's start time, a history entry's recorded time --- are none
  of the three times, which live on the log and which the substrate reads back as data and
  never writes." Carries: (a) what the substrate holds, (b) survives no wipe, (c) its clocks
  are none of the three times, (d) the three times live on the log, (e) read back as data,
  never written.
- **1356–1359** (two–three results): "A timer that fired under the old order stays fired ---
  ... --- and the re-read orchestration reconciles by the C-12.6 flags, settled quantity
  moving back only as authorised compensation under C-12.4."

**Temporal-product leakage (DL-02 ruled the section product-agnostic):**

- **1345**: "an activity's start time, a history entry's recorded time" — *activity* and
  *history entry* are Temporal's own nouns (Activity; event History). This is the leak;
  the companion `temporalv16.tex` is the named witness for product vocabulary.
- Lesser/borderline (saga/Temporal-adjacent but arguably generic, no hard flag): "recorded
  history" and "compensates its past actions" (1354–1355), "timer" (1356).

**Replacement for 1343–1346** (splits the monster sentence AND removes the leak; net
**−1 line**):

> The substrate holds only schedules in flight and orchestration position, and survives no
> wipe. Its own clocks order nothing: none is any of the three times, which live on the log;
> the substrate reads them back as data and never writes them.

The clock enumeration was illustrative, not load-bearing — the point ("its clocks are none of
the three times") stands without it. If a concrete example is wanted, use agnostic nouns ("a
scheduling clock, a task's start time"), but the cut is cleaner and DL-02-safe.

Optional split for 1341–1342: "The three times and the refold are ledger facts. The
orchestration substrate that schedules the work supplies none of them and stores none of
them." (line-neutral.)

Rest of the section is product-agnostic and clean; the closing pointer (1361–1362, "carried
in the orchestration companion, not here") is exactly the DL-02 seam — keep.

---

## Additional checks

**First-use of the new terms.** execution / monitor / door time, total order, refold are
first used in ch01 §Order (189–194) — but each time is glossed in one clause, the total order
is defined in place, and refold is described in place ("a late arrival ... takes its place
among them and the tail refolds"), all with `(Chapter 4)` forward pointers. First use is
handled, not bare. Full establishment follows in ch02 §bitemporal (axes) and ch04 (roles). No
first-use failure.

**Term inconsistency — "explain line" vs "explain item".** The *defining* site, step (e) line
1219, says "profit-and-loss explain **line**"; every other site (1247, 1319, 1332, 6112,
6114 `explainItemNamed`, 6934) says "explain **item**". The definer is the outlier. Fix at
1219: "published as a named profit-and-loss explain **item**". (Line-neutral.)

**"lateness segment"** is not coined as a formal 2-word term anywhere; the doc uses "the
world's segment / ours" and "the segment of its lateness". Consistent; no first-use issue,
but the lens's term "lateness segment" has no single labelled home — descriptive only.

**Covered-call trace (1330–1337) — where each born item is bound.** The trace names the three
born items in constitutional vocabulary: flags *reordered* / *restated* and the *explain
item* are C-12.6's; the *open item* moving only via authorised compensation is bound to
**C-12.4** explicitly (1335). Asymmetry: the open item cites its constitutional source
(C-12.4) but the flags and explain item cite **no** source (C-12.6) in the trace, though
C-12.6 is what makes "a refold is never silent". Minor: add "(C-12.6)" after "Three things
are born here" or after the flags/explain, to match the C-12.4 citation on the open item and
close the loop back to the constitution. Not load-bearing (the reader has C-12.6 from step
(d)/(e) upstream), but the citation asymmetry reads as an omission.

---

### Net-page ledger for this round (if all accepted)
S2 ch02 cut (−1/−2), S2 1249 trim (−1), S4 1343 rewrite (−1), S1 (−0 to −1), 1116 clause cut
(−0), explain-item fix (0). Aggregate **net-negative** — consistent with the 112 cap.
