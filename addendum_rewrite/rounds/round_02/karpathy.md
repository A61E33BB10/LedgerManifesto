# Round 2 — KARPATHY scorecard

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex`
**Lens:** The one-pass test. Can the target reader (a competent quant engineer who has NOT
read the 27 review rounds) read each section once, top to bottom, without backtracking?
Linear flow, self-documenting, nothing cryptic in my domain, nothing cuttable without loss.

**Grade: A (91%)**

I stake my lens on this. The document now passes the one-pass test.

---

## My three Round-1 blockers — all cleared

1. **P3 fold-identity (was garbled/type-incoherent).** Now §11 P3 (lines 675–678):
   `replay (xs <> ys) = replay xs >=> replay ys` in the `Either LedgerError` Kleisli
   category, with checkpoint-independence stated as a consequence of the law. The
   type-incoherent `apply_all(events[:k]) ++ events[k:]` is gone. This was the one
   genuinely cryptic spot in my domain; it is now correct and matches the reference.

2. **Out-of-order condition numbering (recurring backtrack reflex).** §4 now opens
   (lines 205–209) with an explicit orientation: "C1–C12 are stable references indexed in
   §5 … they follow that index, not order of first appearance, so the first condition met
   below is C2 … read as tags, not as a sequence." The "did I skip C1?" reflex is
   pre-empted before the reader meets C2. Numbers correctly left intact (load-bearing in
   §11 and §7).

3. **Cryptic "∑_w h-style conservation".** §4.1 (line 243) now reads "conservation as
   defined for `h` extends to it, ∑ ac(w,u)=0 for every u." The hyphenated coinage is gone.

---

## Cross-checked: the rest of the pooled set also lands on my lens

These were raised by others but bear directly on one-pass clarity (no cryptic terms, no
unresolved forward references). I verified each in context:

- **`StateDelta` now in the notation table** (line 130), so C2 no longer rests on a term
  defined two subsections later.
- **Conserved-field set enumerated in prose** (notation, lines 122–124: ac and balance
  conserved; hwm, entry_nav non-conserved). C2's "every conserved field" is now evaluable.
- **`0_P` vs flat disambiguated** (lines 126–128; C1(a) line 282 now "Some(p) with p
  flat"). The flat-row-with-crystallised-HWM case no longer contradicts the definition.
- **"lattice" and "sheaf" removed** (P5 → "single (w,u)-keyed row"; design E → "state
  indexed only over the held set"). No undefined unified terms dumped on the reader.
- **Handler-vocabulary collision defused** — C11 (lines 305–308) states the field-writers
  and the C2 event classes are different axes whose names are not meant to coincide. A
  cross-referencing reader is no longer left guessing.
- **C11/P10 over-claim corrected** — authorship-then-erased caveat now in C11, P10, the §7
  bullet, and the §11 intro, which carefully reserves "unrepresentable" and flags
  conservation as a value-level check (S4). The reader is not misled into reading a
  value-level check as a type fact.
- **Two-track amendment / multi-unit events** — the Breaking-track holder move is now a
  separate paired-issuance event (S1), and the QIS rebalance is one StateDelta per unit
  composing to event-level conservation. The "single atomic StateDelta across two units"
  confusion is gone.
- **Pareto scores demoted to ordinal judgments** with a named scorer (lines 614–616); the
  per-design forcing reason carries the argument. No unearned numeric precision.

---

## Non-blocking observations (noted, not counted against the grade)

- **`>=>` (Kleisli fish) in P3 is given without a gloss.** For a general reader this would
  stall, but this document is explicitly Haskell-saturated (ships a Haskell reference,
  uses NonEmptyList / Either LedgerError / GADT throughout), so its target reader is
  assumed Haskell-literate, and the surrounding prose names "Kleisli fold" / "Kleisli
  category" and states the consequence in plain words. Within the document's own frame this
  reads in one careful pass. Not a blocker; flagging in case a later round widens the
  audience.
- **Signals S1/S2/S4 are referenced in prose but enumerated only in the Haskell comments**
  (StatesHome.hs lines 448–478), not in the §10 reference *prose* bullets (only S3 is named
  there). They are findable in the rendered document (the listing is typeset), and every
  in-prose use is a deferrable "where this is encoded" pointer that does not gate the
  sentence's meaning. Minor wayfinding gap, not a one-pass blocker.
- **C11's paragraph (lines 298–309) is dense** — three distinct clarifications in one
  block. But each sentence does necessary disambiguating work and the block reads
  top-to-bottom without backtracking. The density buys the reader out of a worse
  confusion. Acceptable.
- **The thesis ("three maps, no W-sector") recurs** in the abstract, §3, §6, §8, §12. Each
  restatement is at a different altitude (claim / layout / forcing argument / comparative /
  one-sentence), so this is intentional spec structure, not loss-free cuttable redundancy.

---

## Why A and not B

In Round 1 the document was a strong B held back by exactly three localized one-pass
defects in my domain. All three are fixed cleanly, and the round introduced no new
cryptic terms or forward-reference traps — the C11 expansion and the §11 intro rewrite,
the densest new prose, both read linearly. On my lens the target reader now gets a
result-first spine, signposted condition numbering, every load-bearing term defined before
use, and an educational reference. The residual frictions above are deferrable pointers and
audience-frame assumptions, not stalls or backtracks. This clears my bar.
