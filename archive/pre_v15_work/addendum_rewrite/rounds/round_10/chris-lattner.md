# Round 10 Scorecard — chris-lattner

**Document:** `addendum_rewrite/addendum_stateshome_v2.tex` (851 lines)
**Reference:** `addendum_rewrite/reference/StatesHome.hs` (598 lines)
**Lens:** Progressive disclosure — simple path first and unobstructed; each abstraction
earns its place; notation is interface, not obstacle.

**Grade: A (92%)** — clears the bar, re-staked on my lens. Deliberately at the bar, not
inflated above it.

## Method this round

Fresh full read of the `.tex`, not a carry-forward of the R8/R9 verdicts. I re-derived the
grade and re-stress-tested the one residual friction item rather than inheriting it. I also
re-verified, against the actual reference file, every cross-surface the prose leans on:

- The four expressibility signals S1–S4 exist and assert what §4/§9/§11 cite them for
  (ref lines 468, 482, 489, 501).
- The C11 demonstrator pipeline cited at `.tex` 807–818 is live, not narrated:
  `settleHandler :: [(WalletId,Qty)] -> Map WalletId [FieldWrite 'Settle]` (ref 231),
  `erase = fmap (map SomeWrite)` (ref 238–239), `main` builds `tradeSD` and `closeSD` via
  `erase . settleHandler` (ref 537+), and the commented `_c11_bad = WHwm` (ref 462–463) is
  the rejected cross-handler write, typed `'FeeCrystallise` not `'Settle`, exactly as the
  prose claims.
- `\lstinputlisting{reference/StatesHome.hs}` resolves; `main` uses integer minor units
  throughout, so determinism/conservation are arithmetic facts, not prose.

The A-bar I test: a competent quant engineer who has read none of the prior rounds reaches
the correct model in one careful pass, nothing cryptic in my domain, correctness preserved,
nothing cuttable without loss.

## Why this clears A

- **Simple path is first and unobstructed, at three altitudes.** Abstract (48–62) → §1
  question (72–83) → §3 three-line map block (155–159) → §13 one-sentence answer (834–839).
  The whole schema — three maps, one mutation discipline each, no W-sector — is delivered
  before any condition, GADT, or proof is demanded. The four instruments (§4) and the
  reference (§12) are descents the reader takes only as far as they choose. Gentle on-ramp,
  no ceiling. This is the property I most care about and it holds cleanly.

- **Each abstraction earns its place, and absences are named.** §6 (560–585) discharges
  "and *only* three" with one forcing constraint per map plus an explicit "removing any one
  breaks the corresponding constraint." The absent fourth map is a *named, load-bearing
  absence* (C12, §4.2; design D, §10), not a silent gap. No map is present "in case."

- **Complexity is progressively disclosed across the type machinery.** C2 lands as plain
  sum-to-zero arithmetic in the body (254–270); the fold-homomorphism / `>=>` framing is
  deferred to §9/§11, with `>=>` glossed at first use (683–690). Beginner sees a fact,
  expert sees the law. The C11 note that field-writers and C2 event classes are *different
  axes whose names are not meant to coincide* (313–316) defuses the single worst
  name-collision a careful reader would otherwise hit.

- **Notation is interface, not obstacle.** `0_P` (all-fields-zero value) vs `flat`
  (conserved-fields-zero class) are cleanly separated (128–131); the §3 note that map value
  types share their sector names while the reference uses `ledgerUS`/`ledgerPS` to keep them
  apart (161–164) removes a collision before it bites; every inline tag in the §3 block is
  pre-glossed in §2.

- **Honest about where the encoding stops.** §11 intro (668–676) defines "unrepresentable"
  precisely and concedes conservation is value-level (S4). Naming the seam between
  type-level and value-level guarantees is the mark of infrastructure built to be extended.

Nothing in my domain is cryptic; correctness is preserved; I found nothing whose removal is
a clear net gain to the document as a whole.

## Residual non-blocking friction (re-tested, still below the blocking bar)

- **The `balance` demonstrator is the sharpest exposition cost, and it is unchanged.** The
  §2 notation entry (122–127) still front-loads a dense motivation-before-context clause — a
  field carried "only by the reference … to exercise the C11 per-field-writer discipline" —
  encountered before C11 exists, referencing `h(w,u)` and the §answer inventory
  mid-definition. On first read it is a genuine bump. I re-tested cuttability: it is **not**
  cuttable. C11's per-field-writer claim must be witnessed on a *conserved* field with a
  writer distinct from `ac`'s, and the only other writers (`hwm`→crystallise,
  `entry_nav`→subscribe) sit on *non-conserved* fields, so `balance` is the unique witness
  and earns its place. It remains *relocatable* (the §2 entry could shrink to "reference-only
  demonstrator; see C11" with the rationale living at C11), which would cut friction at zero
  comprehension cost — but relocation is not cutting, so the "nothing cuttable without loss"
  gate is not violated. This is precisely what holds the grade at the bar rather than above
  it.

- **§2 places some notation before its motivation** (`$\Delta f$`, `$0_P$`, `$u_{MA}$`, the
  `balance` rationale, before C11/the reference exist). Conventional for a spec; forward
  pointers mitigate; first-skim takeaways survive a single careful pass.

- **§4 presents conditions out of numeric order** (C2 before C1 in §4.1; §4.4 runs C7, C5,
  C9, C10, C6, C8). Pre-warned as stable tags, not a sequence (212–216), indexed one line
  each in §5, each condition self-contained at its definition. The numbers are names, not a
  dependency order. Comprehension intact.

None of the three gates a single careful pass. I re-stake my lens on **A at 92%** —
deliberately at the bar, not above it: the `balance` exposition cost keeps the simple path
unobstructed but not frictionless.
