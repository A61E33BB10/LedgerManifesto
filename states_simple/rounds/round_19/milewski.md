# Round 19 — milewski review of `states_simple/States.tex` (+ `States.hs`)

**Verdict: OBVIOUS.** Empty residue.

## What R19 changed (per `iteration_log.md`; all `.tex` prose, `.hs` unchanged since R17, mtime 13:37)

1. **Scope-bound replaces the leap-of-faith register.** §The Answer opener reworded from
   "Every economic relationship ... is itself a unit ... The count rests on this premise —
   demonstrated for one, assumed for several. Granted it, ..." to result-first +
   scope-bound: "Every economic relationship a wallet has **that reifies as a single unit
   it holds** ... has its state in three homes, held in two maps. ... a relationship
   spanning several instruments that does not reduce to a single (holder, unit) row **lies
   outside this scope**." §Why-Three mandate close now states the closure condition: the
   multi-instrument fact "would be a (holder, several-units) fact **occupying a fourth home
   and a third map, which the count excludes**." Holder-axis citation repointed "By the
   premise" → "By the reification."
2. **psHwm paragraph compressed (~13 → ~6 body lines), Price/Qty contrast demoted to a
   footnote.** Body now carries only the earning claim (psBal primary/conserves; psHwm
   witnesses the Position home can carry a non-conserved fact; out-of-scope valuation
   writer leaves it `mempty`; no cancelling-leg writer → no zero-sum invariant). Footnote
   states the deferral (typed `Qty` to match source, leans on none of `Qty`'s group
   structure; what it measures / whether two compose is the out-of-scope writer's to fix;
   no aggregate claimed).
3. **Listing comments fixed (`.tex` only):** psHwm `-- not conserved; out-of-scope writer,
   mempty here` (answers grep-for-a-writer at the field); psBal `-- conserved (sum over
   holders, sec.5)` (was "sums to zero", which read as "this value is zero").

## Verification

- **Bounded-scope reframe is correct and obvious, not circular.** §Answer *defines* the
  scope (relationships reifying as a single (holder, unit) row) and forward-refs §why for
  the demonstration; §why discharges it for one mandate (issuer issues a mandate unit,
  −1/+1 legs) and *excludes* the multi-instrument case by naming exactly what it would
  cost (a fourth home + third map). Definition-in-§Answer + demonstration/exclusion-in-§why
  is a backward/forward reference pair, not a cycle. The in-scope count "three homes, two
  maps, no fourth" is now **unconditional within its stated scope** — a precisification,
  not a weakening: the document no longer *asserts* an unproven universal, so there is no
  false claim in my lens. Grep confirms the leap-of-faith register is gone: no
  "premise"/"granted it"/"assumed"/"leap of faith"/"on faith" survives (the one
  "trusted to" at :192 is the legit priced-iff-active correlation, unrelated).
- **psHwm body+footnote consistent with `.hs` 579–593** (both DEFER; both keep
  `psHwm :: Qty`; neither claims an aggregate; neither claims type-impossibility). No
  contradiction between artifacts — the R17/R18 divergence stays closed.
- **`.hs`/`.tex` listing-comment differences are each appropriate to their medium, no
  false claim.** The `.hs` psBal comment still says "conserved, sums to zero" (`.hs` :380)
  and psHwm "retained on close-out" (:381), un-touched by R19 — but the `.hs` is a
  *narrative thread*: the step-7 intro four lines up (:375) already says "conserves (sums
  to zero **over holders**, step 4)", so the terse field echo is qualified in context. The
  `.tex` listing is standalone, which is exactly why jane-street-cto flagged it there and
  STYLUS fixed it there. Restraint rule: no `.hs` edit owed — the narrative qualifies the
  field comment that the standalone `.tex` listing could not.
- **`.hs` reads like Hutton, unchanged & OBVIOUS since R5** (re-derived by reading): `Qty`
  group earned only to make a transfer's two legs cancel; `Price` non-group earned (never
  summed); `Lifecycle = Listed | Active Price` (priced-iff-active by shape); `NonEmpty`
  terms; sealed two-map `Ledger`; net-first `applyMove` (zero-net / self-move drop, one
  rule); `foldM` replay (determinism = purity + monadic left-fold law). All listings
  type-correct. No GHC in env; verified by reading.
- LaTeX clean: `pdflatex` 3 pages, 0 errors / 0 over- or underfull / 0 undefined refs;
  `States.aux` resolves answer=2, why=3, construction=4, right=5.

## Standing notes (non-blocking; NOT residue — carried, unchanged)

- **psHwm type-strengthening — STANDING FLAG 2 (carried R2–R18).** A Price-style non-group
  newtype (no `Semigroup`/`Monoid`) would make `foldMap psHwm` fail to typecheck, applying
  the document's own step-5 rule ("prefer the shape when it can afford it") to psHwm as it
  is applied to Price. I endorse this strengthening *in principle*. It is NOT this round's
  residue, on my settled R17 position: (1) neither `.hs` nor `.tex` contains a false claim
  — both DEFER and disclose, `netBal` folds `psBal` alone, no aggregate is asserted as
  type-impossible; (2) it must be applied to the `.hs` declaration AND the `.tex` listing
  (`.tex` :157 "the listings reproduce its declarations"; :239 keeps `psHwm :: Qty`)
  *together*, so it is an owner/STYLUS-coordinated change, not a `.hs`-only or `.tex`-only
  edit; minsky adjudicated it a should-strengthen returned to source. R19 (footnote
  reconciliation) does not regress it and does not close it. I do not re-flip an
  adjudicated, owner-returned item absent new information.
- **Positional-vs-record listings nit (carried 15 rounds).** `.tex` renders
  `data TermsVersion = TermsVersion String` (:216) and `data Move = Move UnitId WalletId
  WalletId Qty` (:297) positionally, where `.hs` uses records; `.tex` :161 says "the
  listings reproduce its declarations." `.tex` is internally self-consistent (its
  `applyMove (Move u from to q)` pattern-matches positionally; `currentTerms` treats
  `TermsVersion` opaquely), so a reader of the `.tex` alone is not misled. STYLUS-owned,
  licensed simplification per FORMALIS R13.

## Outside my lens (subject-matter standing flag)

- **Multi-instrument reification proof** — whether every in-scope relationship really
  reduces to a single (holder, unit) row (cross-margin / netting sets), i.e. whether the
  bounded scope is wide enough for the ledger's real relationships. R19 reframes from
  "assumed, not proved" to "bounded scope + closure condition," which removes the false
  *assertion* from my lens; whether the bound must be widened to a theorem is a
  subject-matter call, not a representation defect.
