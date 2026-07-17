# v16.1 Pass — Round 4 STYLUS review (findings only; no edits applied)

Reviewer: STYLUS (review instance). Target: `ledger_v16_1.tex`, **113pp / 1-over** (recorded
DEFERRED-TO-OWNER). Findings only; the S2 dedup respects SF-2/SF-3 (no witness, normative
sentence, or proof step cut to hit 112).

---

## S1 — style of the Round-3 additions

Register is declarative throughout; the ⊤ flip landed as pre-drafted Variant B. Per addition:

- **⊤ passage, step (c) 1234–1237** — CLEAN. "the canonical top value~$\top$ … sorting after
  every real door time of its execution instant, so a synthesised firing never precedes the
  observation that triggers it." First-use of ⊤ defined; consequence stated declaratively; the
  R3 internal contradiction is gone (now agrees with 1249/1305 "just folded").
- **Derivation-order + hash-tie, lem:closure 1313–1318** — CLEAN. "derivation order" defined at
  first use ("the causal order the forward pass builds, record-derived and reproducible by any
  party"); the commuting-⊤→hash sentence is one result, cites H-CR. (Whether "the forward pass
  builds" leaves it a traversal artifact is FORMALIS F1's substantive call, not style.)
- **Hypothesis-label split, 1330–1333** — CLEAN and honest: property-tested (H-FIN at-most-once,
  H-FWD, H-INERT) vs structural (H-WF, H-FIN finiteness), "a violated finiteness hangs the
  closure, it does not fail a test." One-name labels consistent. Good.
- **Re-arm clause, 1227–1229** — acceptable but dense: one sentence carries (i) refold re-derives
  every Monitor emission, (ii) declaration already recomputed, (iii) re-armed watch's arming
  synthesised before its firing. It enumerates under one head; keep, noted.
- **Occasion clause, 1239–1241** — first-use defined, but the apposition drops its copula: "the
  \emph{occasion} the record position … at which the watch's edge is evaluated" reads as two
  juxtaposed nouns. Net-neutral fix — insert a comma:
  > … --- the \emph{occasion}, the record position (observation point or scheduled date) at which
  > the watch's edge is evaluated, distinct edges giving distinct occasions --- …
- **Serialization paragraph, 1445–1452** — declarative and clear, but two form items (content
  unchanged; CONCORDIA C1 owns the clause anchor, so any application needs its sign-off):
  1. **Positive+negative restatement (1447–1448):** "only the quiescent closure is the specified,
     committed, observable state; a partial refold is never committed and never observed." The
     second clause is the first stated negatively — the guarantee is carried by the positive
     form alone. Dedup candidate (feeds S2): drop "; a partial refold is never committed and
     never observed." Guarantee preserved.
  2. **DL-01 rule restated (1450–1452):** "ordered by declared precedence or refused (C-2.7,
     DL-01), never by an arrival-order door tiebreak" restates the rule whose home is the
     Transaction Executor (1113–1118) and whose proof-use is lem:closure (1310–1312). The
     load-bearing new point is "never by an arrival-order door tiebreak"; the rest can point.
     Protected (normative) — flag, do not cut without CONCORDIA.

No addition re-establishes what step (c) or lem:closure already own beyond items 6.1–6.2.

---

## S2 — final honest dedup toward the page: exact arithmetic

**Hunt result: the genuine, non-protected, clarity-safe net-negative candidates are ≤ ~3 source
lines, all in ch04 (sec:totalorder), where they cannot drop the final page.**

Candidates found (whole-pass sweep for restatements that can point / redundant halves):

| Site | Cut | Net lines | Blocker |
|---|---|---|---|
| 1447–1448 | drop the negative restatement "a partial refold is never committed and never observed" | −1 | in the clause-anchored serialization paragraph — needs CONCORDIA C1 |
| 1450–1452 | point to the DL-01 home instead of restating the rule | −1 | normative (SF-3 protected) |
| 1258 (step e) | lateness-split "world's … / ours …" restated | ≤ −1 | load-bearing (the explain-item attribution names the segments) |
| 1239 | occasion comma | 0 | clarity, not a page lever |

Sum of clean, unblocked lines: **~0–1**, none in the document tail.

**Why this cannot reach 112.** The 1-over is *caused* by the Round-3 correctness additions
(lem:closure, the ⊤ prose across four sites, the serialization discipline) — every one a proof
step, a normative sentence, or a witness anchor, i.e. exactly the protected content. The
candidates above sit at lines ~1240–1450 (ch04, early-middle); by this document's page mechanics
(`\raggedbottom` bottom-slack absorbs ~40% of an early cut, and only cuts in the last few pages
propagate ~1:1 to the final page) a one-line cut there does not remove the final page. The tail
(ch16 TA-EXECUTION-TIME and traceability table, ch17 change-log/parking) was already harvested by
the DL-03 consolidation and is now wholly normative/traceability content.

**Certification sentence (verbatim, for the record):**
> 112 is unreachable without cutting normative content.

The residual is the owner's cap call (SF-2), not a cut to force.

---

## S3 — one-name / first-use integrity over the pass's diff set

Clean, with one spelling flag:

- **⊤** — glossed once as "the canonical top value" (1234), then "⊤" / "the door value ⊤" in
  silence (1303, 1317, snapshot slot 1350–1351). **No "top element" anywhere.** No drift.
- **occasion** — defined 1239 (record position: observation point or scheduled date), reused
  identically 1319. Uniform.
- **derivation order** — coined 1314 with its gloss "causal order"; "causal order" appears only
  there (a one-time gloss, not a competing name). Uniform.
- **quiescent closure / quiescence** — 1447, 1450, 1465; consistent.
- **reordering step** — 1204 (def), 1284, 1410, 1423, 6997; no "reorder step" / "reordering
  procedure" variant. Uniform.
- **three times** (execution / monitor / door) — no synonym drift in the new text.
- **synthesised emission vs synthesised firing** — a deliberate **genus/species** pair (emission
  = arming acknowledgement ∪ firing, 1225–1226; firing = a firing specifically), used
  consistently, not synonymy. Noted so it is not "fixed" into one word.

**Flag — "refold" vs "re-folding" spelling.** The pass's term is **refold** (unhyphenated:
noun and verb throughout sec:totalorder), plus the deliberate pun "a re-fold, never a rewrite"
(1224, keep). But ch06/ch14/ch16 use the hyphenated **re-folding** for the general replay/rebuild
of a log prefix (2092, 5193, 5204, 5264, 6501) — pre-existing text, arguably a distinct operation
(replay from scratch vs the reordering-step refold). The hyphen accidentally tracks that
distinction but is fragile. Confirm with the author: either the two are distinct concepts (then
the spelling split is fine and should be intentional) or they are one operation (then unify to
"refold"). Not this pass's internal defect — sec:totalorder is uniformly "refold" — but surfaced
per the "no synonyms anywhere" sweep.

---

### Flags returned
- **CONCORDIA C1** — the S1/S2 serialization dedups (1447–1448 negative restatement; 1450–1452
  DL-01 pointer) touch the clause-anchored normative paragraph; its sign-off gates any
  application.
- **FORMALIS F1** — "the causal order the forward pass builds" (1314): style is declarative; the
  traversal-artifact-vs-record-function question is substantive and theirs.
