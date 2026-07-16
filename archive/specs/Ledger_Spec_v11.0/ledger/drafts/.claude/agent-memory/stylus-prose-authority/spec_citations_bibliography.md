---
name: spec-citations-bibliography
description: Missing bibliography blocker — 5 \cite keys render "[?]"; house source style is pinned \footnote
metadata:
  type: project
---

ROUND 6 (2026-06-28) BLOCKER FOUND: the document uses 5 `\cite` keys at 6 sites but NO bibliography/`thebibliography`/`\bibitem` exists anywhere (checked all drafts/*.tex and main ledger_v11_0.tex). Fresh PDF (ledger_v11_0.pdf, built Jun 28 01:53) renders all 6 as "[?]"; aux has 6 `\citation` lines, 0 `bibcite`.

Sites: sec14:286 (isla-ibp), sec16:143 (isla-ibp), appI:5 (sec15c33), appI:32 (ssr), appI:176 (sec10c1a + finra6500).

**House style for external sources is the pinned inline `\footnote`, NOT `\cite`:** sec01:51 (IFRS/GAAP cites in footnote), sec11:76 (sese.023 ISO 20022), sec17:9 (ISDA DRR 2025 Year in Review, Jan 2026, "Figures pinned... not restated as current"). Fix path A: convert the 5 `\cite` to house-style `\footnote` with pinned citable source. Path B: add a References section defining the 5 `\bibitem`. Either way the reference TEXT (ISLA IBP edition, SEC Rule 15c3-3, Reg SHO 203(b)(1), SEC Rule 10c-1a, FINRA Rule 6500 Series) is SOURCING — owner milewski. STYLUS flags, does not invent.

**CDM attribution — ROUND 7 (2026-06-28) RESOLVED, do NOT reflag:** canonical in-doc name is "ISDA Common Domain Model" (sec01:53 first def, appE:17 glossary, sec13:1 title "ISDA CDM Integration", appF:6). appF:6 fixed in R6 (opens "ISDA Common Domain Model", pins "(FINOS-governed)"). Last deviation sec13:5 "The FINOS Common Domain Model (CDM)" — STYLUS fixed in R7 to "The ISDA Common Domain Model (CDM), governed by FINOS". No "FINOS Common Domain Model" naming remains. Fact (ISDA-created, FINOS-governed) settled sec17:9.

**ROUND 7 (2026-06-28) re-verify of citation blocker:** STILL UNRESOLVED. v11.0 main (ledger_v11_0.tex) has NO bibliography; aux = 6 \citation, 0 bibcite; fresh PDF renders 5 "[?]" (pdftotext count = 5). The 5 keys at the 5 sites above persist. v10.3.tex line 7284 has the full thebibliography with all needed bibitems (isla-ibp 7306, sec15c33 7308, sec10c1a 7309, finra6500 7310, ssr 7311) — milewski ports those 5 or converts to house \footnote. Owner milewski.
