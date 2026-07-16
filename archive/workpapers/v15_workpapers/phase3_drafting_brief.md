# Phase 3 — Drafting Brief (binding on every author)

You are drafting one or more chapters of Ledger Specification v15. This brief is
binding. Read, before writing a word, in this order:

1. `/home/renaud/Ledger/LedgerManifesto/ledger_manifesto.md` — Constitution v1.1.
   The direction of authority is one-way; your chapter is rated against it, line by
   line. Your chapter OPENS by naming the constitution sections it discharges (one
   sentence, e.g. "This chapter discharges §4 and §7 of the constitution.").
2. `/home/renaud/Ledger/v15_workpapers/phase2_ratified.md` — the ratified budget
   ledger, gap dispositions, Track A content (Ch. 3), frozen thread timelines.
3. `/home/renaud/Ledger/v15_workpapers/phase2_toc_proposal.md` — your chapter's scope
   paragraph, the thread map §3 (instruments, numbers, and which episodes visit your
   chapter), and the five-part episode shape.
4. `/home/renaud/Ledger/v15_workpapers/phase1_design_ruling_memo.md` — the ratified
   collateral ruling, wherever your chapter touches coordinates, collateral,
   entitlements, obligations, or valuation.

## Hard rules

- **First-version document.** v15 never references v13.1, v14.0, or any earlier
  version, and never says "previously" or "the old design". It may and should cite the
  constitution by section.
- **Vocabulary is fixed:** unit, wallet, balance, move, transaction, watch, the
  immutable log, projection, the Event Monitor, the Events Executor, the Transaction
  Executor, smart contract, the market data operator, the three homes, virtual wallet,
  virtual ledger. One name per component; no synonyms. The coordinate vocabulary is the
  constitution v1.1's: the signed vector (owned, lent, posted) whose named rays are
  lent out / borrowed and posted as collateral / received as collateral.
- **Tone:** the constitution's register is the specification's register. Plain
  declarative prose; result first; concrete before abstract; no abstraction unless used
  twice or it makes a statement checkable; precision kept, ornament cut; acronyms
  glossed at first use. No prose roadmaps ("in this section we will..."); no appeals to
  market practice as authority — derive from first principles, then note that the
  binding standard is satisfied.
- **Category theory protocol (STYLUS enforces mechanically):** category-theory language
  is permitted only as a second telling. A concept must first be fully explained in
  plain terms with a concrete example; only then may a short, clearly marked paragraph
  restate it in categorical language to remove residual ambiguity (use the
  `secondtelling` environment). Category theory is not a prerequisite; the reader is
  not assumed to know it; nothing later in the document may depend on the categorical
  restatement. Any categorical term appearing before its concept's plain-language
  telling is a defect.
- **Haskell policy:** short snippets only — newtypes, key data declarations, type
  signatures — roughly ten lines maximum per snippet, no function bodies beyond
  one-liners, no compilable-module ambitions. Use the `lstlisting` environment.
- **Thread episodes** keep the five-part shape: the trigger; the contract that catches
  it; the transactions it produces (numbered rows, exact quantities); what the door
  checks; the design point it substantiates (one closing italic sentence). Numbers come
  from the frozen thread map and the frozen timelines — never invent or vary a number;
  quantities are exact integers in minor units.
- **Page budget:** your budget is in the ratified ledger. Estimate ~520 words of prose
  per page (a table ≈ 0.3–0.5 page; a 10-line listing ≈ 0.25 page). Overrun is a
  PROCRUSTES defect: compress ornament first, then duplication, then compress mechanism
  into statements plus one worked example.
- **Constitutional conflicts:** if your content genuinely conflicts with Constitution
  v1.1, do NOT fudge and do NOT draft around it silently — write the chapter with the
  conforming design, and file the conflict in your completion report with exact
  proposed amendment text; the orchestrator parks it in Ch. 17's open-problems index.
- **Cross-references:** refer to other chapters by their number and title
  (`Chapter~\ref{ch:...}` where labels exist, plain "Chapter 7" otherwise); label your
  chapter `\section{...}\label{ch:<shortname>}` and subsections sparingly.

## Output

Write your chapter to the path given in your task as a LaTeX fragment: `\section{...}`
top level (chapters are sections of one article), subsections as needed, compilable
under the preamble of `Ledger_Spec_v15.0/ledger/ledger_v15_0.tex` (amsmath, booktabs,
enumitem, listings, the theorem environments definition/principle/theorem/proposition/
invariant, and the `secondtelling` environment are available; use `\EUR{}`/`\USD{}` for
amounts). Do not include `\documentclass` or `\begin{document}`.

Your final message must be a SHORT completion report only (not the chapter text):
sections written, estimated page count, thread episodes included, any constitutional
conflict filed (with proposed amendment text), any coordination note for other
chapters. The orchestrator does not read your chapter; Phase 4 reviewers do.
