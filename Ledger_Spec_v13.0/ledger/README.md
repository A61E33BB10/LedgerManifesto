# The Ledger — Unified Design Specification

`ledger_v13_0.tex` is the entire specification in one self-contained LaTeX file: every
section, appendix, TikZ figure, and Haskell listing is inline — no `\input` dependency
beyond standard LaTeX (`glyphtounicode`).

- Build: `latexmk -pdf ledger_v13_0.tex` → 166 pages, 7 parts.
- The document reads as the single, self-contained statement of the framework: it carries
  no version identity in its text, headers, or PDF metadata.

## Files
- `ledger_v13_0.tex` — the specification (the deliverable).
- `ledger_v13_0.pdf` — compiled, 166 pp.
- `reference/Ledger.hs` — the consolidated runnable reference the embedded listings excerpt.
- `review_first_version/` — the committee review record (census, dispositions, per-iteration
  change logs, certifications). A process artifact; not part of the specification.

## Reference property harness
`reference/Ledger.hs` compiles under GHC 9.10 (`~/.ghcup/bin`; needs only base + containers).
- `make typecheck` — type-check the reference `-Wall -Werror`.
- `make props` — build and run the property suite (`test/RunProps.hs`): P24, P25, P-DET..P-PARTITION, F8.
