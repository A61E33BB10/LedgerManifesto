Build is clean: 167 pages, zero undefined references or citations, zero dangling labels, all five bibliography entries cited, all nine appendices referenced from the body. Change log follows.

**File:** `/home/renaud/Ledger/Ledger_Spec_v13.0/ledger/ledger_v13_0.tex` (7833 lines before and after; no content added or removed)

## Changes (moves/merges and connective tissue)

1. **Moved §Frequently Asked Questions from after the Conclusion to before it** (Part VI now ends: Invariants → Regulatory → Scope and Limitations → FAQ → Conclusion and Open Problems). Historical artifact removed: a body section trailing "Conclusion and Open Problems" is review-round accretion — Q&A appended after the document was "finished." As-designed, the body closes with the Conclusion (whose Flagged Open-Items Register ends "…the open items bound what the framework does not yet establish"), then appendices. The FAQ block was relocated byte-exact (78 lines); it is fully self-contained (all cross-references are `\ref`, none positional), and nothing references its position.

2. **Retitled Part IV** to "Accounts, Reporting, Operations, Settlement, and CDM Integration" and added "operations" to the roadmap's Part IV sentence. Historical artifact removed: the part title enumerated four of its five sections, omitting §12 (Implementation and Operations) — a title written before §12 was moved into the part. §12 itself was *not* moved: its closing subsections (From Moves to Settlement Instructions; ISO 20022 Interface) are the designed bridge into §13 (Settlement Layer Interface), so its position is logical.

3. **Converted all hard-coded structural references to `\ref`.** Historical artifact removed: the Roadmap table and Key Concepts glosses cited §§1–7 by literal number while citing every later section by `\ref` — the telltale that the front matter was written against a seven-section draft and later sections were bolted on. Also fixed: "Appendix~E (Glossary)" → `Appendix~\ref{app:glossary}` (the Glossary was the one appendix never `\ref`'d — an orphan by hard-coding); "Appendix~B" (line 1829) → `\ref{app:properties}`; "(\S7.)" and "(\S6.)" in Part III's Key Invariants list → `\ref{sec:lifecycle}`/`\ref{sec:contracts}`. Legal citations (IFRS §§4.1.2, 17 CFR §240…, GMSLA §10) left untouched — statute numbering, not document structure.

4. **Roadmap Part VI range updated** `\S\S\ref{sec:invariants}--\ref{sec:faq}` → `--\ref{sec:conclusion}`, and the regulator row's list reordered (`faq, conclusion`) to match the new reading order.

## Examined and deliberately unchanged (order is as-designed)

- **Part order I–VI**: scalar-to-vector progression is defended in the text itself and logically forced (obligations, §15, must precede SBL, §16; SBL uses settlement/CDM machinery from Part IV).
- **Part II as a single-section part**: the three-home state model is the headline contribution of the abstract; a dedicated part is emphasis, not accretion.
- **Appendix order A–I** (tables → reference → developer guide → verification → worked examples): coherent, every appendix cited from the body 2–9 times.
- **Per-part starred "Key Invariants and Consequences" summaries**: each summarises distinct material collected once in §17 — layered accessibility, not merged-draft duplication.
- **Abstract, title, preface**: no version identity, no change-driven prose; the subtitle's three pillars are load-bearing (the roadmap keys off them).

## Verification

- `latexmk -pdf` exits 0; "Output written on ledger_v13_0.pdf (167 pages)"; latexmk reports no undefined refs/citations, ToC confirms FAQ = §20, Conclusion = §21, Part IV retitled.
- Label/ref cross-check: every `\ref` target exists (empty `comm` diff); no duplicate labels; no remaining bare `\S<digit>` structural references.
- Pre-existing, unrelated warning noted (not introduced, not touched): three "Missing character: no ) in font nullfont" from the architecture-figure TikZ line `\foreach \e in {csd,reg,rgl}{\draw[edge] (\e.north) -- (\e.north|-{(0,-2.75)});}` (~line 380) — a drawing-code quirk, not structural residue; flagged for a drawing-focused pass rather than silently altered here.