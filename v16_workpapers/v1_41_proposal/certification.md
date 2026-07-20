# FORMALIS — Independent Certification of the v1.41 Clarifying Proposal

**Certifier:** FORMALIS (independent; did not draft v1.41 or the proposal memo). **Gate:** publication.
**Files:** `ledger_manifesto_v1_4.tex` (in force, untouched) vs `ledger_manifesto_v1_41.tex` (candidate).
**Claim under certification:** v1.41 differs from v1.4 ONLY in the time-envelope language of C-2.7 and
C-12.6 (plus header/title/its own new history entry), and every difference is semantically CONSERVATIVE
— no normative commitment added, removed, or altered.

---

## 1. Mechanical scope

`diff v1.4 v1.41` yields **exactly six hunks**. Every one lies in an allowed region; none lies elsewhere.

| # | diff locus | region | allowed? |
|---|-----------|--------|----------|
| H1 | line 2 | header comment — version string | YES |
| H2 | 23a24,33 | header comment — appended v1.41 note block | YES |
| H3 | 53c63 | title line — date + version | YES |
| H4 | 178,194c188,211 | C-2.7 three-times / fold-order / total-order passage | YES |
| H5 | 864,873c881,892 | C-12.6 passage | YES |
| H6 | 1131a1151,1165 | appended v1.41 amendment-record entry | YES |

**No hunk falls outside the six sanctioned loci.**

Byte-untouched confirmations (md5 of the corresponding line windows, offsets +17 / +19):
- **Covered-call case (v1.4 196-212 → v1.41 213-229):** `6c9706d3…940b` == `6c9706d3…940b`. IDENTICAL.
- **v1.4's own amendment entry (v1.4 1109-1131 → v1.41 1128-1150):** `169916bb…28f2` == `169916bb…28f2`. IDENTICAL. The v1.41 entry is appended *after* it (v1.41 line 1152), v1.4's entry unmoved in content.
- **Whole gap between the two changed hunks (v1.4 195-863 vs v1.41 212-880):** `diff` reports IDENTICAL — the covered call and every intervening clause are byte-for-byte preserved.

**MECHANICAL-SCOPE RESULT: PASS.**

---

## 2. Per-hunk / per-change semantic verdict

Each changed passage is rated by whether v1.41 carries EXACTLY the v1.4 obligation/permission/definition set
— nothing dropped, nothing added beyond what v1.4 entails, scoped against precision_review C-items.

| Change (loc) | v1.4 content carried | v1.41 delta | Review scope | Verdict |
|---|---|---|---|---|
| **H1/H2 header** | (comment, non-normative) | adds a v1.41 descriptive note; closes "changing no commitment" | metadata | **CONSERVATIVE** |
| **H3 title** | (title, non-normative) | version 1.4→1.41, date 16→20 Jul | metadata | **CONSERVATIVE** |
| **C1 naming triad + exec authority (H4)** | "bears three times"; exec="happened in the world"="enforced in court"; "asserted by its source"; "contestable only in the world"; "corrected only by a later event"; "never edited at the door"; monitor="observed at the boundary"; door="admitted through the one door" | five exec qualifiers relocated verbatim to a dedicated following sentence; one joinery "and"→comma in a conjunctive series | D1/D2 | **CONSERVATIVE** — every qualifier survives; comma-series ≡ and-series; count "three" kept (M1 door-universality untouched) |
| **C2 fold order vs arrival order (H4)** | "processed as they arrive at the door"; "meaning lives in execution order"; "fold's order is execution order"; late-arrival insert + tail refold | principle/mechanism split into two sentences (content identical); added sentence "honours the execution order the events always had, and leaves the order of their arrival at the door untouched" | C3/C4 | **CONSERVATIVE** — added sentence names the two-orders-over-one-record distinction and the refusal's scope that internal consistency (arrival record immutable, C-12.5; fold order ≡ execution order) already forces; no rule added |
| **C3 total order + hash tiebreak + totality premise (H4)** | "decided by execution time, then door time, then the event's hash"; "deterministic, total, and computable by any party from the record alone"; "rests only on … world … and … door" | tail split; hash named "settles only the tie those two can leave, and changes no order they fix"; "Its totality rests on no two distinct events sharing a hash" | C5, C6(a) | **CONSERVATIVE** — states the lexicographic subordination the three-key rule + "rests only on exec/door" already jointly entail; C6(a) premise phrased as premise ("rests on"), **not** a guarantee; no algorithm named, no writer-uniqueness imposed → stays on C6(a) side of the C6(a)/M3 boundary |
| **C4 monitor absence + lateness (H4)** | "monitor's clock orders nothing: it is provenance"; lateness "splits into the world's delay, execution to monitor, and ours, monitor to door" | adds: emitted event "bears no monitor time; its world's segment is zero and its lateness is wholly ours" | C1, C2, C8 | **CONSERVATIVE** — analytic given the definite description "observed at the boundary" + v1.4's pre-existing arrived/emitted distinction ("arrived or emitted", C-5.4; Monitor "emits", C-3.7 etc., all in unchanged text). Touches monitor time + lateness ONLY; says nothing of the door slot or refold-synthesised firings → no M1 |
| **C11 "the head" defined (H5)** | "takes its place before the head"; "Views recompute automatically; money never does"; compensating transaction under C-12.4 | "the head" glossed "— the latest event in the fold's order, the frontier the fold has reached —" | C11 | **CONSERVATIVE** — definition-before-use of a term already used; the fold frontier = greatest element of the (fold=total) order; matches C-2.7's "events already folded"; no new content |
| **C7 lateness split "or"→"and" (H5)** | attribution triad "to the reordering, to the event that caused it, and to the segment of its lateness"; segments world's (exec→monitor) / ours (monitor→door) | connective "or"→"and"; split promoted to its own sentence matching C-2.7's canonical wording | C7, D5 | **CONSERVATIVE** — see §3 |

**No obligation, permission, or definition is dropped; nothing is added beyond v1.4's entailments.**

---

## 3. The connective fix (C7)

- v1.4 C-12.6 read "the segment of its lateness: the world's … **or** ours …"; v1.4 C-2.7 (and the covered
  call) decompose lateness into "the world's delay … **and** ours". The "or" was the internal anomaly.
- v1.41 harmonises C-12.6 to "**and**" and gives the split its own sentence in C-2.7's canonical wording.
- **Attribution semantics unchanged.** The attribution triad is byte-preserved ("to the reordering, to the
  event that caused it, and to the segment of its lateness"). WHO is attributed WHAT is identical: world's
  segment = execution→monitor, ours = monitor→door, same boundaries, same party per segment. The fix only
  conforms C-12.6 to the decomposition C-2.7 and the covered call already fix — resolving an internal
  contradiction toward the already-authoritative clause, adding no obligation the decomposition did not
  already carry. **CONSERVATIVE.**

---

## 4. M-leak check (M1-M5 must not appear in any form)

Grep of the *changed hunks* and the whole file for door-slot / derived-firing / monotonic / uniqueness /
commute / quarantine / fail-closed / harmlessness language:

| term | v1.4 count | v1.41 count | equal? | location |
|---|---|---|---|---|
| door-slot / door slot | 0 | 0 | = | — |
| derived-firing / synthes* firing | 0 | 0 | = | — |
| monoton* | 1 | 1 | = | line 576 (Transaction Executor, **unchanged**) |
| uniqueness | 0 | 0 | = | — |
| commut* | 2 | 2 | = | lines 176, 578 (**unchanged**) |
| quarantine | 2 | 2 | = | lines 499, 1116 (**unchanged**) |
| fail closed | 1 | 1 | = | line 155 (**unchanged**) |
| harmlessness | 1 | 1 | = | line 185 (C-2.7 ordering refusal, **unchanged**) |

Every count is **identical** between v1.4 and v1.41, and every occurrence sits **outside** the two changed
hunks (188-211, 881-892). The changes introduced **none** of these terms. The M2 residue is likewise not
leaked: Change 3 keeps v1.4's pre-existing scope "the log's total order" and says nothing of the
refusal-vs-tiebreak choice; the M1 door slot is never assigned; M3 door-time uniqueness is never imposed
(only *hash* distinctness is named, which is C6(a), not M3); M4 authorisation and M5 third-segment are
absent. **M-LEAK RESULT: PASS — no material item leaked in any form.**

---

## 5. Voice / vocabulary spot-check

- **Signature phrases (register_review §3): all present verbatim.** 14 of 15 matched literally on first pass;
  the 15th — "the time the world would enforce and the time the door assigns" — is present word-for-word,
  its leading article capitalised only because v1.41 promotes it to a sentence opener ("The time the world
  would enforce and the time the door assigns decide the order"). Phrase preserved; no loss. (Task's "13":
  the four execution-time qualifiers count as one register bullet.)
- **No spec vocabulary anywhere in the file:** `⊤`=0, `⊥`=0, `nullable`=0, `NULL`=0, camelCase property
  identifiers = none. **PASS.**

---

## 6. Overall verdict

**CERTIFIED-CONSERVATIVE.**

- Mechanical scope: 6/6 hunks in sanctioned regions; covered call and v1.4's amendment entry byte-untouched.
- Semantics: every v1.4 obligation/permission/definition preserved; every addition is an entailment the
  precision review scoped as CLARIFYING (C1-C12); C6(a) correctly phrased premise-not-guarantee.
- C7 connective fix harmonises without altering attribution.
- No M1-M5 material leaked in any form.
- Voice signatures verbatim; zero spec vocabulary.

No normative commitment is added, removed, or altered. The proposal is cleared for publication as a
ratification-pending clarifying revision.
