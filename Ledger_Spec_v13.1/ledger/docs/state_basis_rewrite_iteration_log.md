# Iteration log — rewrite of §"The State-Basis Discipline" (sec09)

Lead writer: STYLUS (main loop). Panel: FORMALIS, NOETHER, KARPATHY, THORP, MILEWSKI.
Target: `Ledger_Spec_v13.1/ledger/drafts/sec09.tex`, opening (lines 1–96), plus one-clause
citations in sec06/sec10/sec11. Baseline: 191 pp, build clean.

## Iteration 1 — purpose sentence + skeleton (draft v1), 5-reviewer panel

Draft v1 implemented devices (a)–(f) with the corrected purpose sentence. Findings:

- **FORMALIS** — authority-direction core **ratified** ("preserve verbatim"), but **not ratifiable**
  due to two CRITICAL truth defects: **F1** the purpose para said the door "confirms agreement
  with the state being valued" — false; admission (P25) checks only that the stamp names a
  committed chain point; agreement is a *consumption-seam* check (C13). **F2** "where frames
  disagree the observation is refused" — false; C13 is a disjunction, mismatched frames are
  *transported* along the declared arrow, refused only where none exists. Plus F3 (ProductTerms
  credited with parameters it does not hold), F4 (minted alias "single-basis rule" + false
  citation claim), F5 (futures/managed binding smuggled, not discharged), F6/F7 (paraphrase
  drift), F8/F9 (minor). **Ruling on device (d):** do **not** physically relocate the invariant —
  definition-before-use (its terms are defined later) and single-statement discipline; surface
  by name + reference.
- **NOETHER** — **F1** "the quantity is path-independent" wrong twice: the quantity changes
  (1,000→2,000); the *marked value* is **basis-invariant**; "path-independent" is reserved for
  P10 endpoint PnL. **F2** citations swapped (admission = `prin:invariance-weld`, conservation =
  `thm:basis-value-invariance`, c=0). Arithmetic verified exact. Naming nits.
- **KARPATHY** — arc sound and transitions teach; highest-impact fix: purpose para pre-empts the
  homes/rule paragraphs by naming the stamp/UnitStatus machinery too early — compress it. Cut the
  near/far half of the teaser (duplicates sec:basis-worked). Name the concept once ("basis").
  Plain-ify two jargon sentences.
- **THORP** (cold read) — **Test A PASS, Test B PASS**; the §3 misreading already unformable.
  Register: 5 fixes (the "datum" collision with the survey-datum image the sharpest; the "erased
  store boundary" and roadmap-stack residues of the old coinage habit).
- **MILEWSKI** — opening clean of category theory; one block ("no introduction form" — type-theory
  jargon), one gloss ("erased store boundary").

## Iterations 2–3 — full rewrite (v2) + citation wiring

- Rewrote the opening: purpose para compressed to error-statement + frame-intuition +
  authority-direction (machinery deferred); mental-model repositioned after purpose with a
  one-line bridge naming "basis"; three-home clauses corrected (ProductTerms = rounding rule
  only); named invariant via early reference (not relocation); compact walk with conservation =
  basis-invariance (citations un-swapped); forward pointer. All F1–F9 addressed; jargon removed.
- Wired `Invariant~\ref{inv:basis}` into **sec06** (`prin:state-sufficiency`), **sec10**
  (variation-margin settlement mark), **sec11** (benchmark level) — one clause + one `\ref` each.
- Build: `latexmk` exit 0, **192 pp**, 0 undefined/multiply-defined refs.

## Iteration 4 — convergence (verify landed text)

- **THORP (FRESH instance, never saw v1)** — cold read of sec09 lines 1–96 *in situ*:
  **Test A PASS** ("objective and authority unmistakable; the trap reading is explicitly barred,
  twice over"), **Test B PASS** (problem/solution reproducible from one read), register PASS with
  5 cosmetic nits. **This is the exit gate: fresh-reader reader-test passed, §3 regression barred.**
- **NOETHER** — all three checks **PASS, no errors**: walk correct (factors distinct, theorem at
  c=0, phantom unreachable, citations at right joints), rule paraphrase faithful (clause (ii)
  whole-domain force preserved), three citations attach at the correct datum-meets-balance points.
- **FORMALIS** — **APPROVED AS VERIFIED**: F1–F9 all discharged; three cross-references confirmed
  **zero new normative content** (clarifying citations of the already-general invariant);
  mental-model block confirmed verbatim via git diff. No defects at CRITICAL/HIGH/MEDIUM; one LOW
  informational (line 11 "lifecycle" → "frame-changing events").

### Cosmetic fixes applied (register), then final build
FORMALIS's line-11 wording + THORP's nits 2–5 (cut a redundant appositive; plain-ify "checked for
every unit the stamp names"; "may refuse" → "may refuse to admit"; split the observation-time
sentence). **One item deliberately NOT changed:** the comma splice THORP flagged sits inside the
pre-existing, independently ratified `mentalmodel` block that FORMALIS certified verbatim — left
untouched and flagged for the author rather than silently edited.

## Exit

Converged at iteration 4: a fresh reader (new instance) passed both halves of the reader-test with
the §3 regression barred, and FORMALIS + NOETHER returned zero substantive findings on the landed
text. Remaining items were cosmetic and are applied; the `mentalmodel` comma splice and the sec11
second-hook (F5b) are surfaced to the author. Final build: exit 0, 192 pp, clean refs.

### Fresh-reader cold-read result
**PASS / PASS.** Objective and direction of authority recovered from paragraph one; the original
misreading ("synchronise with authoritative market data") judged impossible to form in good faith.
