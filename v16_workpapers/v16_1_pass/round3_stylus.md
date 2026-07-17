# v16.1 Pass — Round 3 STYLUS review (findings only; no edits applied)

Reviewer: STYLUS (review instance). Target: `ledger_v16_1.tex`, 112pp (**at cap**). Every
replacement is net-negative or net-neutral; aggregate net-negative. DL-03 consolidation is the
subject of S1/S2.

---

## S1 — the 17 chapter-head stubs: uniform, one line, none missing

**Count:** 17 chapters, 17 stubs, none missing. Lines 107, 253, 526, 907, 1534, 1826, 2082,
2467, 3036, 3677, 3937, 4393, 4673, 4862, 5398, 6590, 6851.

**13 uniform** — exactly `Governed by C-… (\S\ref{sec:traceability}).`, one sentence (107, 253,
526, 907, 1534, 1826, 2082, 2467, 3036, 3677, 3937, 4393, 4862).

**2 stub-sentence divergences (fix):**

- **6590 (ch:requirements)** — non-uniform form *and* re-states the table's completeness claim
  (S2 overlap). Current: `Governed by C-14.1--14.15; \S\ref{sec:traceability} maps every
  constitution clause to its chapter.` Replace:
  > Governed by C-14.1--14.15 (\S\ref{sec:traceability}).

  "maps every constitution clause" is the caption's claim, stated once there (S2). Net-negative.

- **6851 (ch:scope)** — the stub embeds a delegation parenthetical, breaking the one-parenthetical
  form. Replace stub:
  > Governed by C-Scope.1--11, C-Auth.1--4, C-6.6 (\S\ref{sec:traceability}).

  and relocate the delegation to the chapter's first body sentence (do not lose it):
  > Managed-account consequences are delegated to the Managed-Account Companion (register
  > line~E75).

  Net-neutral (moved, not cut). Verify it is not already stated in the ch:scope body; if it is,
  delete from the stub only.

**2 post-stub discharge-frames (the stub is clean; the *next* sentence narrates the discharge —
prose-roadmap duplication of the table):**

- **4673 (ch:cdm)** — "The chapter discharges them by a single demonstration:" frames the thesis.
  The table already routes C-6.5, C-2.6 → ch:cdm; the frame duplicates it. Drop the frame, open
  with the thesis:
  > Governed by C-6.5, C-2.6 (\S\ref{sec:traceability}). The industry's Common Domain Model
  > (FINOS CDM, version~6.0.0) maps onto the ledger's declared-data vocabulary; the direction of
  > authority is the constitution's and does not turn.

  Net-negative.

- **5398 (ch:testability)** — parallel, lighter: "The claim it makes good is the constitution's:"
  frames the thesis. Optional trim to open with the thesis directly:
  > Governed by C-13.1--13.3, C-2.5 (\S\ref{sec:traceability}). The ledger is correct because it
  > is built to be tested.

  Lower confidence than 4673 (the frame is faint); apply only if strict uniformity is wanted.

No stub grew into a paragraph in its *own* sentence; the two roadmap-frames sit in the chapter's
second sentence, not the stub.

---

## S2 — sec:traceability caption vs. what the table shows (6805–6841)

**Accurate claims (borne out):** 116 clauses (CONCORDIA recomputed 116); two-way (clause-column
and chapter-column both populated); C-12.6 gap-fill → ch:machines/sec:totalorder (row 6834);
seventeen chapters all appear in the right column. The completeness claim is stated **once**, in
the caption — good (the one restatement, stub 6590, is struck by S1).

**Precision defect — "exactly once" is contradicted at the token level.** The caption says each
clause appears "below exactly once against the chapter that discharges it." But the italic
*also* cross-refs put clause tokens on the page a second time — C-2.7, C-4.10–4.11, C-6.5,
C-8.6–8.9, C-Auth.1/4, C-Scope.9 each appear again in an *also* note. A precise reader sees "6.5
also ch:collateral" and reads the "exactly once" claim as false. The claim is true only for the
**primary clause column**; the caption never states the *also* convention. Scope it and add the
one-clause read-instruction (net-neutral). Replace 6809–6812 "each appearing … chapter-to-clause
total)":
> each listed once in the left column against its primary discharging chapter (clause-to-chapter
> total, no gap); an italic \emph{also} note adds a chapter that co-discharges that clause. Every
> one of the seventeen chapters appears in the right column (chapter-to-clause total).

**Row-count note (for CONCORDIA C1 coordination, no caption fix):** the table has **18 physical
rows**; the "19" in circulation counts row 6833 (`C-11.1--11.5, C-12.1--12.5`) as two
clause-groups. The caption asserts no row count, so no overclaim — but any prose that cites "19
rows" should say "19 clause-groups." Flag so the number is used consistently downstream.

**Minor (no action):** "replacing the seventeen per-chapter opening sentences" is accurate — the
piecemeal *prose* is gone; the surviving stubs are pointers, not the sentences that "stated it
piecemeal."

---

## S3 — first-use integrity after the ~33 category-3 cuts

**Clean.** Every term in the set keeps its defining first-use; no later use is left bare by a
cut.

| Term | First use | Defined there? |
|---|---|---|
| synthesised (firing) | 1229 (step c) | ✓ "synthesised at its record-derived execution position" |
| voided consequence | 1241 (step c) | ✓ "its consequence voided (C-12.6)" |
| explain item | 1257 (step e) | ✓ "a named profit-and-loss explain item" (R1's "explain line" fully gone) |
| firing-derivation | 1284 (remark) | ✓ "is a fixpoint of interleaved fold-and-derive"; refers back to step (c)'s "This derivation" (1248) |
| firing closure | 1271, glossed | ✓ glossed "a fixpoint" + `Lemma~\ref{lem:closure}`; formal def at 1295 |
| lateness segment | 1014 (monitor time) | ✓ split into world's/ours — definition intact |

Notes:
- **"closure"** is first *used* at 1271 (Idempotence analysis) ~24 lines before its formal
  definition at 1295, but glossed and forward-pinned to `lem:closure` — acceptable deductive
  order (result, then lemma), no cut casualty.
- **"dispatch of the reordering step"** — `dispatch` appears **nowhere** in the file (grep: 0
  hits). No orphaned later use, so no first-use violation; the term simply is not in the document.

---

## S4 — ⊥ within-instant position: SUBSTANTIVE, deferred to FORMALIS F1 / correctness-architect

**Do not restyle.** The ⊥ direction is contested by SF-1: step (c) 1234 says the door-null sorts
"**before** every real door time of its execution instant," while the forward-pass (1244, "the
tipping observation **just folded**") and lem:closure existence (1300, same) require the emission
to fold **at/after** its trigger. That is an internal contradiction whose resolution is
FORMALIS's, not STYLUS's. I flag 1234 (and the dependent sites 1298, 1339–1340, and the
forward-pass reasoning 1241–1247) as pending F1; I neither settle nor smooth the direction.

**Pre-drafted prose variants** (ready to drop in once F1 rules; the coordinated symbol edit
across the four sites is FORMALIS's under SF-2, not mine):

- **Variant A — F1 upholds ⊥-before (door-null is a bottom element).** Keep 1234 as written;
  optionally break its comma-chain with em-dashes:
  > … its monitor time null and its door time~$\bot$ --- the null of an event that never crossed
  > the arrival door, record-derived and identical for every party and every rerun --- sorting
  > before every real door time of its execution instant; …

  (Under A, the contradiction with 1244/1300 remains and is FORMALIS's to reconcile.)

- **Variant B — F1 rules the emission folds at/after its trigger (door-null is a top element,
  ⊥→⊤).**
  > … its monitor time null and its door time~$\top$ --- the null of an event that never crossed
  > the arrival door, record-derived and identical for every party and every rerun --- sorting
  > after every real door time of its execution instant, so a synthesised firing never precedes
  > the observation that triggers it; …

  Variant B removes the current contradiction (it agrees with 1244/1300 "just folded"). It
  requires ⊥→⊤ to propagate to 1298 (`(\mathrm{exec},\bot\text{ or }\mathrm{door},\mathrm{hash})`)
  and 1339–1340 (`its door slot $\bot$`) — a FORMALIS coordinated edit, net-zero (symbol swap).

---

## DL-01 change-log paragraph (6983–6986) — style check

Settled and unhedged in substance (the R1/R2 "Under decision … if the Panel rules otherwise,
parks here" is gone — grep confirms no "Under decision" remains). Two register defects:

- **Process-narration + internal jargon.** "The pass's Decision Panel ruled unanimously,
  R-conform:" narrates the deliberation and uses the undefined ruling-code "R-conform," which a
  spec reader cannot decode. State the settled fact; keep the provenance in `decision_log.md`.
- Replace 6983–6986:
  > \emph{Ruled (DL-01).} The door's fail-closed refusal of two simultaneous non-commuting events
  > with no declared precedence survives; the door-time tiebreak orders only pairs harmless to
  > reorder or grounded in a declared precedence (Chapter~\ref{ch:machines}). No amendment, no
  > parking.

  Net-negative. Declarative, no process narration, no jargon. ("No amendment, no parking" is the
  right settled coda.)

**Content flag (not a style call):** dropping "unanimous Decision Panel" removes the ruling's
provenance from the spec. If the change-log is meant to carry that provenance, that is the
coordinator's call — the vote detail lives in `decision_log.md` either way. STYLUS's register
standard favours the fact over the process; flagging rather than deciding.

---

### Net-page ledger
S1 (6590 −, 6851 ~0, 4673 −, 5398 −), S2 caption ~0, DL-01 −. Aggregate **net-negative**; helps
hold cap. S3 no edit; S4 pre-drafts only (pending F1).

### Flags returned
- **SF-1 / FORMALIS F1 + correctness-architect A1** — ⊥ direction is a substantive contradiction
  (1234 vs 1244/1300); variants pre-drafted, not applied.
- **CONCORDIA C1** — the "18 physical rows / 19 clause-groups" count and the *also*=co-discharge
  reading underlie the "exactly once" and "two-way total" claims I tightened; my S2 wording
  assumes C1's bijection audit lands green.
