# Readability Log

## Pass 1

31 sections rewritten (stylus): shorter one-claim sentences, intuition prepended before formal blocks; all 179 formal blocks byte-identical (mechanical guard: 0 altered/dropped/added).

### Part B (Market-data/Basis, sec09)
Clean: no multiply-defined labels, no errors touching the new material. All formalism (listings, amsthm environments, labels, refs, numbers) left byte-identical; every insertion is `\paragraph*` intuition, a figure, or a `\subsection` of explanatory prose that restates committed facts only.

## Change log — `/home/renaud/Ledger/Ledger_Spec_v13.1/ledger/drafts/sec09.tex`

Nine insertions, no deletions except the one absorbed lead-in noted below. Verified: full document compiles under `pdflatex -halt-on-error` (exit 0); the two new figure labels and the new subsection label are unique; no pre-existing formal block was altered.

| # | Piece | Landed at | Anchor |
|---|-------|-----------|--------|
| 1 | **Mental model** (2 paragraphs, market-data contract) | Head of `\subsection{The market-data contract}` (`sec:basis-contract`) | After "…everything outside reads it.", before `\begin{principle}[Stamping authority]`. Carries the forward ref `(Figure~\ref{fig:md-layers})`. |
| 2 | **Figure (b)** `fig:md-layers` (four-layer architecture) | Same subsection, right after `\end{principle}` (stamping authority), before `\paragraph{The basis projection.}` | Orients the reader in the four layers before the interface prose names them. |
| 3 | **Cross-ref to Figure (a)** | `\paragraph{Direction of flow.}` first sentence | Added `(Figure~\ref{fig:md-flow})` after "…cross the market-data boundary". |
| 4 | **Figure (a)** `fig:md-flow` (data-flow, exact-two-arrows) | After the Direction-of-flow block, before `\paragraph{The obligation set.}` | Sits with the prose stating the two-arrows claim it depicts. |
| 5 | **Analogy 1 — redenomination history** | Before `Definition~\ref{def:basis-id}` | Replaces (absorbs) the two-sentence lead-in "The boundary events on a unit form a chain…" to avoid stating it twice; the analogy ends by pointing into `def:basis-id`. This is the only prose removed. |
| 6 | **Analogy 4 — act as enacted + amendments** | Immediately after `Definition~\ref{def:usbasis}` (`\end{definition}`), before "Re-applying `SetBasis`…" | Anchored where Origin-from-registration totality (C5) is first stated. |
| 7 | **Analogy 2 — commit date vs arrival date** | End of the "A stamp is a basis stamp, not a timestamp" paragraph, before "The coordinate lives where every other unit-level status fact lives:" | Where ordinals-vs-ids and booking order are already discussed. |
| 8 | **Analogy 3 — registry's current-proprietor entry** | After "…welded at the door, not assumed.", before `\begin{principle}[Tip weld]` | Prepended intuition to the tip-weld principle. |
| 9 | **`\subsection{The market-data integrator}`** (`sec:basis-integrator`, 4 paragraphs) | Between the properties-catalogue note ("…is not reported as passed.") and `\subsection{The invariant}` (`sec:basis-invariant`) | New subsection; all refs (`sec:basis-failure`, `app:pricing-coordination`, O2/O4/O6, P-DET, P-MODE, W3, `mQuoteEx`) resolve against existing labels. |

Notes:
- Every `\paragraph*` uses the plain-declarative, no-reader-address register already in the section; no "Intuition:" tags.
- Cross-references added: `fig:md-flow` (Direction of flow), `fig:md-layers` (mental model). Both figures float via `[tb]`.
- No `\label`, `\ref`, listing, theorem, definition, principle, invariant, proposition, condition number, or numeric/symbolic content was changed. The sole prose deletion is the absorbed `def:basis-id` lead-in (Clarity: state once), whose content and the pointer to the definition are preserved inside Analogy 1.

Per the milewski note: the four analogies are submitted as drafts pending FORMALIS sign-off; this pass places and typesets them without altering their wording.
## Passes 2–5 (convergence)
Each section refined through four more stages. Sections reached one-pass readability and stopped
changing: passes 4–5 were largely zero-edit (e.g. sec01/02/04/05/06/08/09 "no further simplification
needed"), with only local refinements remaining (sec03 two sentence splits; sec07 one disambiguating
word "certain" -> "unconditional"). Content guard re-run after pass 5: 179/179 formal blocks
byte-identical. All six reviewers certified.
