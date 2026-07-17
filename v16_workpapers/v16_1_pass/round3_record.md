# v16.1 Review — Round 3 Record

**Supervisor:** TuringAward. **Date:** 2026-07-17. **Draft:** `ledger_v16_1.tex`, **112pp
(back at cap)**, pdflatex ×2 clean. **Standing reviewers:** FORMALIS, CONCORDIA,
correctness-architect, STYLUS. **Named but unavailable:** kleppmann (recorded, not
substituted — SF-4, carried since Round 1).

Round 2 closed with 15 findings actioned + DL-03 + a category-3 sweep, all landed. Rounds 1–2
were not clean, so Round 3 stays in **findings mode**; per the brief a reviewer whose lenses
return clean **switches to red-team mode** on the four assigned scenarios.

---

## 0. Supervision verdict

**State of the new text.** The Round-2 ruling landed well. `lem:closure` (1292–1323) prints the
four hypotheses **named, labelled "not axioms," property-tested** — an honest form that meets the
veto bar (state, don't prove). Knaster–Tarski is correctly rejected as non-monotone (1303–1305),
my Round-2 anti-bias note intact. The canonical identifier `H(correction, watch, occasion)`
(1234–1239) and the widened operator domain (all Monitor emissions, 1225–1240) are in. The
DL-03 traceability table (6805–6841) partitions the clauses two-way; I independently recomputed
the row counts and they sum to **116** (5+8+11+11+1+8+5+1+5+9+3+5+5+5+1+3+15+4+11), and the check
genuinely surfaced a real gap — C-12.6 had no opener anywhere and is now discharged in
ch:machines. This is a materially tighter document at cap.

**Headline defect I found — the ⊥ within-instant position is backwards (SF-1).** This is the
Round-3 blocker candidate and it **corrects my own Round-2 ruling** (§4 anti-bias — I ruled
"⊥ before real door times"; I now believe that is wrong). Three landed sites disagree:

- **Step (c), 1232–1234:** a synthesised firing's door time is ⊥, "**sorting before every real
  door time of its execution instant**." (⊥ *before*.)
- **Lemma, 1300:** a data emission sits "at the **tipping observation just folded**." (Emission
  *after* its trigger.)
- **Forward pass, 1241–1243:** "at each execution position it folds the event there, evaluates
  the armed predicates against the running state, and folds any newly synthesised emission **in
  the same pass**" — i.e. the firing is produced *after* the observation that satisfies it.

A data emission's execution time **is** its triggering observation's instant (the breaching
close's observation time, 1013), and the observation is a real-door arrival. With ⊥ *before*
real door times, the synthesised firing sorts **before** the very observation it is derived
from. Folding in total order then reaches the firing's position before the observation is
folded, so its predicate is not yet satisfied → **the knock-in is lost**, or the pass must
re-insert the firing behind the cursor → the single-forward-pass "no re-insertion" and
`lem:closure`'s "an emission at p depends only on the fold **strictly below** p" (1298–1299)
both break. H-FWD guarantees the firing's *exec* ≥ its trigger's (equal here) but says nothing
about the *within-instant* order; ⊥-before violates causality inside the instant. **The fix is
almost certainly ⊥ sorts *after* all real door times of its instant (a top element ⊤),** which
is still record-derived (recomputability preserved) and matches the lemma's "just folded" and
the forward pass. I put the adjudication to FORMALIS + correctness-architect rather than decree
it — I authored the original ⊥ call and it needs an independent, non-authoring check.

**Second-order risks.** (i) The ⊥→⊤ change, if adopted, is a **coordinated edit** across four
sites (step c 1232–1234, lemma 1298–1308, snapshot key 1339–1340, forward-pass reasoning), not
a one-word swap — it must stay internally consistent. (ii) It is **net-zero pages** (a word
swap "before"→"after/above"), so no cap pressure. (iii) Category-3 removed ~33 asides including
six that "restated lemmas" — a cut that looked like restatement may have carried a load-bearing
qualifier; needs a spot-check.

---

## 1. Round-3 lens assignment

### CONCORDIA — MANDATORY per DL-03: re-run the 116-clause two-way audit GREEN
- **C1 (mandatory, gate).** Re-point the two-way clause audit at `sec:traceability` (6805–6841)
  and run it **green in both directions**: (a) every one of the 116 constitution v1.4 clauses
  appears **exactly once** against a discharging chapter (no gap, no duplicate) — verify each
  listed range **exists** in v1.4, especially the boundary/added ones (**C-2.8, C-4.12, C-6.6,
  C-12.6**); (b) every one of the 17 chapters appears as a discharging chapter; (c) each
  chapter-head **stub** ("Governed by …", e.g. 107, 907, 4673, 6851) agrees **exactly** with
  the table — **no clause orphaned by the opener removal**, no stub naming a clause the table
  routes elsewhere; (d) the C-12.6 fill (→ ch:machines/sec:totalorder) is correct and the
  "gap the scattered openers hid" claim (6812–6814) is true. Report green or the exact orphan.
- **C2.** The `also`-cross-references (6822–6838): spot-check three that a chapter genuinely
  discharges the clause it is cross-listed against (e.g. C-2.7 also ch:machines; C-6.5 also
  ch:cdm; C-Scope.9 also ch:settlement), not merely mentions it.
- **Red-team (if C1/C2 green) — scenario 4:** a duplicate arriving with a **different asserted
  execution time**. Walk it against absorption-by-identifier (1173–1179) and the C2/C3 seam:
  is it absorbed (same cid) or is it a contest (distinct correction event)? Confirm the landed
  text routes it correctly and no real second event is dropped.

### FORMALIS — lem:closure's printed form, and the ⊥ position (headline)
- **F1 (headline, with correctness-architect).** Adjudicate SF-1: does the key's **⊥-before**
  (1232–1234) contradict the lemma's "at the tipping observation just folded" (1300) and the
  "depends only on the fold strictly below p" existence argument (1298–1299)? Rule whether ⊥
  must sort **after** real door times within an instant (⊤). If so, supply the corrected key
  statement and confirm the well-founded recursion's "dependency strictly decreases in `<`"
  then holds for a same-instant data emission (which it does not under ⊥-before).
- **F2.** The coordinator's ⊥-tie question: two synthesised firings at **one execution instant**
  both carry ⊥ door, so they fall to **hash** — the lemma should **say this explicitly** and
  pin it to H-CR (no hash collision on the finite domain). Confirm 1305–1308's "door-then-hash
  tiebreak orders only pairs that commute" actually covers the ⊥–⊥ case (both ⊥, tie → hash).
- **F3.** Hypothesis honesty: are H-FIN/H-WF/H-FWD/H-INERT labels (1320–1322) accurate —
  "named obligations … property-tested … not axioms"? Verify each is in fact witnessed in
  ch:testability (H-FIN/H-WF via the firing witnesses; H-FWD via a product-graph check; H-INERT
  via a superseded-firing no-op property) or, if any is **not** yet witnessed, that the label
  "property-tested" is not overclaiming — a §3 gap if a named hypothesis has no firing test.
- **Red-team (if F1–F3 resolved) — scenario 3:** a late arrival whose refold **re-arms a fired
  watch**. Does H-WF (well-founded arming) forbid the cycle? Does the widened operator (arming
  in domain, F2-Round-2) synthesise the re-arming acknowledgement *and* its consequent firing,
  or can a re-armed watch fire without a synthesised arming? Formalise the terminating case.

### correctness-architect — forward pass under ⊥, category-3 cuts, snapshot end-to-end
- **A1 (headline, with FORMALIS).** Trace the single forward pass over a same-instant data
  emission under the landed **⊥-before** rule: when the pass folds the observation and
  synthesises the firing, the firing's key (exec, ⊥, hash) sorts **behind** the observation
  (exec, real-door, hash) — does the pass then re-insert behind the cursor (contradicting "one
  forward pass, no re-insertion" and the honest `O(|tail'|)` cost) or drop the firing? Confirm
  the defect and that ⊥→⊤ removes it (firing folds at/after its trigger, one pass).
- **A2.** Category-3 cuts: spot-check the **six lemma-restating aside cuts** against what
  `lem:closure` and `thm:refold` actually carry — did any cut remove a load-bearing qualifier
  (a hypothesis, a scope limit, a non-claim) rather than a pure restatement? Name any cut that
  took content the lemma does not itself state.
- **A3.** Snapshot rule end-to-end under ⊥ keys (1339–1340): when a snapshot's **last folded
  event is a ⊥-door emitted firing**, its key `T_last` has ⊥ in the door slot — does
  invalidation `T_last ≥ T_e` and "nearest survivor" stay well-defined and **monotone**, and
  does the ⊥→⊤ decision change which snapshots invalidate? Confirm the key space is a strict
  order with ⊥ (or ⊤) placed consistently with F1's ruling.
- **Red-team (if A1–A3 resolved) — scenarios 1 & 2:** a late arrival admitted **during a
  refold** (is the refold re-entrant under the single writer, or serialized?), and **two late
  arrivals interleaved** (does the order of admitting two late arrivals affect the final state —
  it must not, by `thm:refold` determinism; construct the two admission orders and confirm equal
  fold state).

### STYLUS — post-consolidation heads, table caption, first-use after cuts
- **S1.** The 17 chapter-head **stubs**: uniform format and register? All should be the single
  "Governed by C-… (§ref{sec:traceability})." line with no residual prose roadmap. Flag any
  stub that still narrates or that diverges in form (e.g. 4673 "discharges them by a …" carries
  extra prose; 6851 carries a parenthetical delegation — are these justified exceptions or drift?).
- **S2.** The table's caption / read-instructions (6807–6814): does the prose tell a
  strong-undergraduate reader how to read a two-way completeness table, and do the stated claims
  ("116", "each … exactly once", "two-way", "C-12.6 gap the openers hid") match the table
  exactly? Flag any claim the table does not bear out (coordinate with CONCORDIA C1).
- **S3.** First-use integrity after the ~33 cuts: did any category-3 cut remove the **first-use
  definition** of a term, leaving a later use undefined? Spot-check the terms whose defining
  aside was the kind of "motivational padding / lemma restatement" that was cut (e.g. "closure",
  "firing-derivation operator", "occasion", "⊥").
- **S4 (defer-to-FORMALIS).** The ⊥ prose "sorting before every real door time of its execution
  instant" (1234): **do not restyle it** — if FORMALIS rules ⊥→⊤ (SF-1), this sentence is
  substantively wrong, not merely stylistic. Flag it as pending F1; STYLUS neither settles nor
  smooths the ⊥ direction.

---

## 2. Supervisor flags (must not be missed)

- **SF-1 — the ⊥ inversion (headline).** Corrects my own Round-2 ruling. ⊥-before folds a
  same-instant synthesised firing before its triggering observation, breaking causality, the
  well-founded recursion, and the single-forward-pass. Almost certainly ⊥ must sort **after**
  (⊤). FORMALIS F1 + correctness-architect A1 adjudicate; I will rule on their finding. If
  confirmed, it is a MAJOR correctness defect (wrong fold state or a hidden re-pass), fixable
  net-zero.
- **SF-2 — coordinated edit.** The ⊥ fix touches four sites (step c, lemma, snapshot key,
  forward-pass reasoning) plus any ch:testability witness that assumes ⊥'s position. It must
  land as one consistent edit; a partial fix that leaves one site saying "before" is worse than
  the original.
- **SF-3 — CONCORDIA C1 is a gate, not a lens.** DL-03 conditioned opener removal on the table
  being **proven bijectively complete** and CONCORDIA re-running green this round. Until C1
  reports green, the consolidation is unverified and the 17 openers were removed on trust. This
  is the round's mandatory deliverable.
- **SF-4 — kleppmann unavailable.** The global-total-order picture he authored is exactly what
  the ⊥/within-instant ordering stresses; no independent seat holds it. FORMALIS F1/F2 +
  correctness-architect A1 jointly cover the ground; residual logged.
- **SF-5 — red-team coverage map.** The four brief scenarios are distributed: scenario 1 & 2
  (during-refold; interleaved) → correctness-architect; scenario 3 (re-arm a fired watch) →
  FORMALIS; scenario 4 (duplicate, different exec) → CONCORDIA. A reviewer switches to its
  scenario **only after** its primary lenses resolve; the mandatory CONCORDIA gate (C1) comes
  before its red-team.

**Dispute resolution.** Colliding or co-owned findings (F1 × A1 on ⊥) come to me; I rule and
record it in the Round-4 record. The Fix-A model commitment plus the ⊥-door key are the two
seams the round-5 certifiers (CONCORDIA, FORMALIS) must sign; SF-1's resolution feeds directly
into (ii) "the ⊥-door key preserves C-2.7's total order and party-recomputability."

---

# ROUND-3 RULING (TuringAward, supervisor) — 2026-07-17

All four Round-3 files read. This confirms the unanimous ⊤ ruling and scrutinises the new
tiebreak, accepts the red-team-1 gap as normative and verifies its composition with red-team-2,
orders the rest, holds A2 to Round 4, and rules the page. kleppmann still unavailable (SF-4).

## A. The ⊤ ruling and the derivation-order tiebreak — CONFIRMED

**⊤ confirmed.** My Round-3 headline (SF-1) is upheld **unanimously** by the two adjudicators I
recused myself before — FORMALIS F1 and correctness-architect A1. A synthesised data emission
shares its trigger's execution instant; under the landed **⊥-before** rule it sorted *before*
the observation it is derived from, inverting causality, falsifying `lem:closure`'s "depends
only on the fold strictly below p," and breaking the single forward pass. The fix — **⊥ is a
top element ⊤: an emitted firing sorts *after* every real door time of its instant** — is
net-zero (⊤ is as canonical, record-derived, and party-invariant as ⊥; only which extreme
changes) and it reconciles the outlier (step c 1234, snapshot slot 1340) with the sites already
written ⊤-assuming (lemma 1298–1302, forward pass 1241–1247). **My Round-2 ⊥-before call is
corrected on the record (§4 anti-bias — recorded, not buried): the mechanism I built to
overrule me (recusal + independent adjudication) worked.**

**FORMALIS's derivation-order tiebreak — the coordinator's two questions, ruled.** ⊤ alone
leaves same-instant synthesised **chains** (F1 derives F2 at the same instant) to be ordered by
hash — causally arbitrary. FORMALIS adds: among same-instant synthesised emissions the tiebreak
is the **derivation (causal) order**, hash settling only causally-independent (commuting) pairs.

- *Is it record-derived?* **Yes.** The causal-dependency relation among emissions is a function
  of the deterministic fold over the record (replay determinism, P2); any party re-running the
  forward pass over the same record produces the same emissions in the same order. The order is
  **built** by a terminating pass (H-FIN, H-WF), not solved. One precision to pin on drafting:
  "derivation order" must denote the **causal order** (a record-derived partial order totalised
  by hash for independent pairs), **not** "the order the pass happens to visit" — otherwise
  party-invariance would rest on a traversal artifact. F1's sentence ("above every event its
  predicate reads") and F2's sentence ("commuting → hash under H-CR") together carry exactly
  this; confirm the wording keeps it.
- *Does it reintroduce a fixpoint?* **No — and the coordinator's framing is the proof.** The
  tiebreak places each emission **strictly above what its predicate reads**, which is the
  well-founded recursion's own direction (dependency decreases downward). An order that only
  ever points an emission *above* its dependencies cannot close an *upward* cycle; H-WF
  (well-founded arming) guarantees the causal relation is acyclic, so the tiebreak is a linear
  extension of an acyclic order, totalised by hash. It **realises** the well-founded order
  constructively; it does not solve a self-referential equation. Confirmed, no fixpoint.

**Accept** the ⊤ edit (four sites) and the merged derivation-order + hash-tie sentence.

## B. Red-team-1 gap accepted as normative; composes with red-team-2

correctness-architect's red-team-1 found the single-writer **re-entrancy / refold-completion /
partial-tail-observability** discipline unstated — this is **normative content**, not clarity,
and I accept it with the reviewer's named sentences. Red-team-2 showed interleaved late arrivals
**converge** (total order arrival-independent + refold idempotent), the only residual being
DL-01's same-instant non-commuting pair, and noted it **depends on** red-team-1's completion
obligation. **They compose into one paragraph** (I verified the dependency: (b)'s convergence
presupposes (a)'s completion — a half-finished refold is not a closure):
- (a) the single writer serialises admission-and-refold; each triggered refold **must complete
  its full tail** (a liveness obligation, backstopped by the overdue-watch sweep); **only the
  quiescent closure is the specified, committed, observable state** — partial-refold states are
  not.
- (b) because the total order is **arrival-independent** and the refold **idempotent**, any
  interleaving of late arrivals reaches **one** quiescent closure; the sole residual is DL-01's
  same-instant non-commuting pair (declared precedence or fail-closed refusal, never an
  arrival-order door tiebreak).
No park — this makes an existing normative requirement (single writer + idempotent refold +
overdue backstop) explicit; it contradicts nothing.

## C. Dependency-ordered ACCEPTED-CHANGES list for the pen

1. **⊤ coordinated 4-site edit** [F1/A1]. Flip ⊥→⊤ at step (c) 1234 and snapshot slot 1339–1340;
   apply STYLUS **Variant B** prose (6851-area / 1234); lemma key 1298 to `(exec, door or ⊤,
   hash)`; forward pass 1241–1247 and lemma existence 1298–1302 unchanged (already ⊤-assuming).
   Print the ⊤ direction at the snapshot-key site (A3). **Net-zero.**
2. **Within-instant tiebreak sentence** [F1 derivation-order × F2 hash-tie, MERGED], after 1302:
   same-instant synthesised emissions ordered by derivation (causal) order — record-derived,
   reproducible by P2, each emission strictly above what its predicate reads; two commuting such
   emissions share ⊤ and fall wholly to the hash, well-defined under H-CR. ~+2 lines.
3. **F3 hypothesis-label split + witness** [F3]. Relabel **H-WF and H-FIN(finiteness) as
   structural obligations** discharged by product-graph well-formedness (ch:objects), **not**
   firing-tested (a non-terminating closure hangs, it does not fail — you cannot test
   non-termination by running); keep H-FIN(at-most-once)/H-FWD(data)/H-INERT property-tested;
   add `prop_supersededFiringInert_fires` forcing a **true→false** voided firing (covered-call
   generator) and asserting zero fold-state contribution — H-INERT currently never fires (§3
   zero-firing gap; every generator produces false→true). Relabel net-0; witness ~+3 lines.
4. **occasion definition + re-arming in domain** [FORMALIS red-team 3 flags]. Define "occasion"
   at 1236 (the record position — observation point or scheduled date — at which the watch's
   edge is evaluated; distinct edges → distinct occasions); confirm the widened operator's
   "arming acknowledgement and the firing alike" (1225–1227) covers a **re-arming whose edge
   relocates**, so a re-armed watch's arming is synthesised before its firing (handshake intact).
   ~+2 lines.
5. **Red-team serialization/convergence paragraph** [red-team 1+2], sec:substrate ~1379–1386,
   normative, one paragraph per §B(a)+(b). ~+3 lines.
6. **Mitigation-table key alignment** [FORMALIS outside-lens]. Rows 1352–1353: ordinal `p`/`<p`
   → the triple `T_last < T_e`, so table and prose name one key (§ state-once). Net-0.
7. **CONCORDIA C-4.12 stub mirror** [CONCORDIA finding]. Add `C-4.12` to stubs 907, 5398, 6590
   so each mirrors its table row. ~net-0 (three tokens).
8. **STYLUS stub uniformity + caption + DL-01 de-jargon** [S1, S2, DL-01]. 6590 drop the
   completeness restatement; 6851 relocate the delegation to the body; 4673 drop the roadmap
   frame; 5398 optional; scope the caption's "exactly once" to the **primary** column + add the
   *also*=co-discharge read-instruction (6809–6812); de-jargon the DL-01 change-log paragraph
   (6983–6986) — strike "R-conform" (undefined in the spec) and the process narration, state the
   settled fact (provenance stays in `decision_log.md`; CONCORDIA re-confirms the de-jargoned
   text still matches DL-01, trivial). **Net-negative — the page funders.**

## D. Held to Round 4
- **A2 (category-3 cut audit) — OPEN.** correctness-architect could not diff (workpaper tree
  untracked, no baseline). The pen delivers `cut_manifest_r2.md`; Round 4 diffs the six
  lemma-restating cuts against correctness-architect's 5-item load-bearing checklist (the four
  hypothesis labels + "not axioms"; the non-monotone / not-Knaster–Tarski caveat; thm:refold's
  fold-state-only scope; within-instant precedence/refusal; H-INERT's no-op mechanism). **Order:
  the pen must deliver the manifest so A2 closes in Round 4.**

## E. Every finding answered
| Finding | Verdict | Disposition |
|---|---|---|
| F1 ⊥ inversion (veto-grade) | DEFECT confirmed (⊤) | item 1 (⊤ 4-site) + item 2 (tiebreak) |
| F2 ⊤–⊤ hash tie + H-CR | DEFECT accepted | item 2 (merged) |
| F3 blanket "property-tested" overclaims | DEFECT accepted | item 3 (label split + witness) |
| FORMALIS red-team 3 (re-arm) | PASSES + 2 flags | item 4 (occasion def; re-arming domain) |
| FORMALIS outside-lens (table key `p`) | accepted | item 6 |
| A1 ⊥ inversion | DEFECT co-signed (⊤) | item 1 |
| A3 snapshots under ⊤ | SOUND | item 1 (print ⊤ direction) |
| A2 category-3 cuts | INCONCLUSIVE | **held to Round 4** (manifest) |
| A1 red-team 1 (during-refold) | GAP accepted (normative) | item 5(a) |
| A1 red-team 2 (interleaved) | DETERMINISTIC + note | item 5(b) — composes with 5(a) |
| CONCORDIA Task 1 (116-clause gate) | **GATE GREEN** + 1 finding | item 7 (C-4.12 stubs) |
| CONCORDIA Task 2 (DL-01 change-log) | CLEAN | no change (de-jargon in item 8 preserves accuracy) |
| CONCORDIA Task 3 (red-team 4 duplicate) | CLEAN | no change |
| STYLUS S1 stubs / S2 caption | accepted | item 8 |
| STYLUS S3 first-use | CLEAN | no change |
| STYLUS S4 ⊥ direction | resolved | item 1 (apply Variant B, ⊤) |
| STYLUS DL-01 de-jargon | accepted | item 8 |

**Accepted: 15 findings actioned (items 1–8). Held to Round 4: 1 (A2). Rejected/superseded: 0
(S4 Variant A is the branch not taken, not a rejection). Parks: 0. DL-03 gate: GREEN
(CONCORDIA).**

## F. Page verdict — order STYLUS to fund; escalate any honest residual
File is **at 112**. Genuinely-new content ≈ **+10 lines** (tiebreak +2, `prop_supersededFiringInert_fires`
+3, occasion+re-arming +2, serialization paragraph +3; items 1/6/7 net-zero; the F3 relabel
net-zero). STYLUS's supplied cuts (6590, 4673, 5398, DL-01 de-jargon, caption) ≈ **−6 lines**,
leaving **~+4 over**. **Order:** STYLUS funds the additions to **net ≤ 0** — the supplied set
**plus additional category-3 ornament** (target −4 more) — and **reports the exact line
arithmetic**. **Irreducible (may not be dropped to fit):** `prop_supersededFiringInert_fires`
(§3 firing mandate) and the serialization paragraph (normative). If, after honest maximal
compression, the floor still exceeds 112, **escalate the exact residual to the coordinator —
correctness and §3 win over the cap (§7); the cap yields (further consolidation elsewhere, or a
page), no witness or normative item is cut.**

**Certifier chain (round 5), updated:** (i) `lem:closure` well-defined/terminating under the
**relabelled** hypotheses (structural vs property-tested split honest); (ii) the **⊤**-door key
+ derivation-order tiebreak preserve C-2.7's total order, party-recomputability, and introduce
no fixpoint; (iii) firing-derivation globally consistent (CONCORDIA C1 green, re-affirm after
these edits); (iv) A2's cut audit closes green in Round 4.
