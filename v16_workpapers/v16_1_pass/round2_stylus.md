# v16.1 Pass — Round 2 STYLUS review (findings only; no edits applied)

Reviewer: STYLUS (review instance), cold read of the Fix-A new text.
Target: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex`, 113pp (**1 over** the 112 cap). Every
replacement below is net-negative or explicitly offset; the round's aggregate is net-negative
and helps close the overflow. DL-03 openers untouched (SF-5).

---

## S1 — firing-derivation rule: stated once (home = step (c)) or re-told?

**Home = step (c), 1226–1232.** It defines both directions: a newly-satisfied watch is
emitted at its record-derived execution position (cause = the reordering arrival, monitor time
null); a firing whose predicate no longer holds keeps its recorded event, consequence voided
(C-12.6); "the ordered prefix determines its own firings."

**Clean references (keep):** theorem statement 1261 ("firings re-derived by step~(c)");
substrate test 1394–1396 ("with firings re-derived (Theorem, `prop_refoldEqualsTimely`)").
Both point, neither re-defines.

**Three re-tellings (defects):**

1. **Interactions false-side, 1308–1312** — re-narrates step (c)'s voided-consequence clause,
   and its example ("a record-date firing that now finds zero shares") duplicates the workflow
   trace (1363).
2. **Interactions true-side, 1312–1315** — re-states the synthesis clause in full ("synthesised
   at its execution position (c), its cause the correction and its monitor time null ... which
   firings are in force is a projection of the ordered prefix").
3. **Remark, 1266–1268** — re-lists the operator's properties: "a firing's condition is a
   recorded fact, its execution time record-derived, its monitor time null, and the clock is
   never read (Chapter 4)" — verbatim step (c) content.

**Replacement for re-tellings 1+2** (collapse the two firing sentences of Interactions,
1308–1315, to one pointer; keep both illustrative examples; net **−5 lines**):

> Watch firings themselves refold by step~(c): a predicate the new order falsifies (a
> record-date firing that now finds zero shares) keeps its recorded event, its consequence
> voided; one the new order newly satisfies (a barrier a corrected close shows breached) is
> synthesised at its execution position --- recorded firings retained as provenance (C-12.6).

The split-settlement (1315–1318) and quarantine (1318–1323) sentences are genuine
interactions — keep unchanged.

**Replacement for re-telling 3** (de-duplication only — remove the property re-list, point to
step (c); net **−1.5 lines**). Replace at 1266–1268:

> The operator is a deterministic function of the ordered arrivals alone (step~(c)).

**HOLD / SF-1 FLAG on re-telling 3.** The words this sentence carries — "deterministic function
of the ordered arrivals **alone**," and the remark's "closure" (1265, 1269) — are the exact
claim FORMALIS F1 / SF-1 contests (the firing-closure is a fixpoint of interleaved
fold-and-derive, not a one-shot function of arrivals). My replacement **preserves the claim
verbatim** and only strips the duplicated property-list; it does **not** settle the fixpoint and
must not read as if it does. If FORMALIS supplies the closure lemma, the pointer `(step (c))`
should instead cite that lemma, and the word "deterministic" is theirs to keep or qualify. **Do
not apply the determinism-sentence rewrite as a style pass — the substantive wording is
FORMALIS's under SF-1.** The pure de-dup above is safe because it changes no truth condition.

---

## S2 — clock-free re-assertions: one anchor + references

**Anchor for the proof:** theorem hypothesis 1277–1279, "per-event purity of $\mathrm{step}$
(clock confinement) ... which is why the specification confines the clock" (points to ch04
Monitor, the standing home). Keep — the theorem needs it.

**One statement that the *new* firing-derivation is clock-free:** step (c) 1230–1231, "reads
the record, not the clock." Keep — it establishes the new operator's clock-freedom at the home.

**Redundant tellings:**
- **1268** ("the clock is never read") — removed by the S1 remark de-dup above. No separate
  action.
- **1249–1251** (Analysis/Determinism, "$\mathrm{step}$ ... consumes the ledger, never the
  clock (Chapter 4)") — third assertion of clock-confinement, ~28 lines before the hypothesis
  restates it. Minor: trim to reference — "$\mathrm{step}$ is a pure function of the ledger
  (clock-confined, Chapter~\ref{ch:machines})" — the hypothesis (1277–1279) owns the claim.
  Borderline (informal determinism prose); optional.

**Not a re-telling (keep):** 1212 ("Detection compares two recorded execution times and reads
no clock") is a distinct sub-claim about *detection*; 1378–1379 ("Its own clocks order
nothing") is a distinct claim that *substrate* clocks are none of the three times — neither
restates re-derivation clock-freedom.

Count: clock-freedom of the re-derivation is asserted **twice** (1230–1231, 1268); 1268 is
struck by S1. Anchor stands at 1277–1279. One optional minor trim at 1250.

---

## S3 — producer clarity: writer synthesises past firings, substrate re-fires forward

**Currently smeared.** The division is spread across two subsections with no single clean
statement, and one sentence blurs it: the writer/refold synthesises past-dated firings (step
(c), sec:totalorder); the substrate re-read "re-fires **forward** ... never rewinding"
(1385); but the acceptance test says "after the re-read has deposited its fresh arming and
**firing** acknowledgements" (1393–1394), which a strong undergraduate can read as the
substrate producing the synthesised past knock-in. That is the A2 conflation.

**The one clean formulation** (replace the producer-ownership sentence at 1379–1380, the
natural single home for the division; net **+1 line**, paid by S1):

> Detection, the refold, and the past-dated firings it synthesises (step~(c)) are the single
> writer's work (\S\ref{sec:totalorder}); the substrate only re-fires \emph{forward} on the
> refolded state, never a past-dated firing.

**Consequent de-ambiguation** (replace 1392–1394 opening; net **−0.5 line**):

> The acceptance test is wipe-and-rebuild, evaluated at quiescence --- after the re-read's
> forward acknowledgements are deposited:

With both, "forward" is the substrate's only production and the past synthesised firing is
unambiguously writer-side. Pairs with correctness-architect A2 — the prose no longer compares
the wrong producer.

---

## S4 — covered-call trace: one instance, C-clauses present

**PASS.** The trace (1358–1371) reads as one worked instance, no doctrine re-glossed:
- envelope / door / order check — mechanics of the instance, no rule re-stated;
- "Three things are born here (**C-12.6**)" (1364) — the R1 asymmetry fix landed; flags and
  explain item now carry their clause;
- open item "under **C-12.4**" (1369) — clause present;
- "Wednesday's record-date firing now finds zero shares" (1363) — the false-side firing
  **shown**, not told (Landau: the example is the argument), consistent with step (c) and with
  theorem 1261 ("firings re-derived by step (c)"); no re-gloss.

Note (no action): the trace exemplifies only the **false-side** (predicate falsified →
consequence voided). The **true-side** (false→true synthesis) has no worked trace; it is
exemplified compactly by "a barrier a corrected close shows breached" in the S1 Interactions
pointer. That asymmetry is a *coverage* matter for the property regime (SF-3 / A3's missing
`prop_firingSynthesized_fires`), not a prose defect.

---

## Additional checks

**Verb synonymy for "the refold produces the newly-satisfied firing" — defect.** Three verbs
for one act: **emitted** (step (c), 1228), **synthesised** (Interactions, 1313), and the act is
also called **re-derived** (theorem 1261, substrate 1395). "one name per component" (CLAUDE.md
§1) is broken. Recommend coining **synthesise(d)** at the home (matches the supervisor/
coordinator term "synthesized firing"), reserving **re-derive** for the operator that computes
*which* firings hold. Fix step (c) 1228 "is emitted at its record-derived execution position"
→ "is **synthesised** at its record-derived execution position --- an emitted event, ... monitor
time null". This also fixes the **first-use** defect: "synthesised" currently debuts in
Interactions (1313), not the home. (Line-neutral.) The operator's canonical *name*
("firing-derivation operator", first used in the remark 1264, mechanism in step (c)) should sit
at one site — **defer to FORMALIS F1**, which is pinning the operator's domain under SF-1.

**"closure" first-use — SF-1 gap, flag not cut.** The remark (1265, 1269) writes "the closure
of the external arrivals" as if a unique closure exists; its existence/uniqueness is exactly
FORMALIS's unproven fixpoint (SF-1). The prose presupposes what is not yet established. **Do not
let it read as well-defined; return to FORMALIS** — STYLUS neither derives the lemma nor
restyles the presupposition away.

**"voided consequence" first-use — OK.** Coined in place at step (c) 1229 ("its consequence
voided (C-12.6)"); used consistently thereafter.

**"data" mass-noun — PASS.** No "datum", no "data are" in the new text. "data-predicate" (1227,
compound adjective) and "data kinds" (408, pre-existing) are correct mass-noun usage.

---

### Net-page ledger (if S1+S3 accepted)
S1 Interactions cut (−5), S1 remark de-dup (−1.5), S3 substrate (+1, −0.5), S2 optional 1250
trim (−0.5), verb/first-use fix (~0). Aggregate **≈ −6.5 lines**, net-negative — contributes to
closing the 1-over. No page-adding remedy; DL-03 openers untouched.

### Flags returned to subject-matter agents (STYLUS does not resolve)
- **SF-1 / FORMALIS F1** — the remark's "deterministic function of the ordered arrivals alone"
  and "closure" carry an unproven fixpoint. S1 de-dup preserves the claim verbatim; the
  determinism wording and the operator's canonical name/definition are FORMALIS's.
- **SF-3 / A3** — the false→true synthesis has no worked instance or firing witness; a prose
  matter only insofar as the trace covers one side. Owned by correctness-architect.
