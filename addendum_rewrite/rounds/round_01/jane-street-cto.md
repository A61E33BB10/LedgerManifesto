# Round 1 Scorecard — jane-street-cto

**Target:** `/home/renaud/Ledger/addendum_rewrite/addendum_stateshome_v2.tex`
(+ embedded reference `/home/renaud/Ledger/addendum_rewrite/reference/StatesHome.hs`)

**Lens:** Readers over writers — clear in six months to someone new. For the Haskell:
correctness, simplicity, illegal states unrepresentable.

## Verdict: REQUEST CHANGES — Grade B (86%)

The document is genuinely strong. The "force each condition at the instrument that
demands it, collect them later" structure is good pedagogy; the notation table earns its
place; the Haskell is total, deterministic, and makes a large class of illegal states
unreachable through abstract types (`Ledger`, `ValidDelta`, `ProductTerms`) and a GADT
field-writer relation. Most of it reads in one careful pass.

It misses A on four concrete, fixable points — three reader-friction, one
correctness-of-claim. None is cryptic and none compromises the underlying design; all are
actionable by the next revision.

Note: GHC is not installed in this environment, so I could not execute `runghc
StatesHome.hs`. I type-checked the module by hand (kinds, GADT/existential syntax,
`foldMap`/`foldrWithKey` shapes, record updates, `Monoid` instances) and found no errors.
The committee should still run it once in CI before relying on the "it compiles" claim.

## What is done well

- The abstract-type discipline is real, not decorative: no PS row deleter is exported
  (monotone half of C1), `ValidDelta` has only `validate` as a constructor (C2 cannot be
  bypassed at the API), `ProductTerms` has no setter (C6). The export list (lines 31-59)
  is the enforcement, and the comments say so.
- `register` writes PT and US together and `applyDelta` guards on PT-membership, so the
  "registered in PT iff registered in US" invariant holds by construction. The `ghostSD`
  example (tex/Haskell) demonstrates it.
- Integer minor units over `Float` is the correct call and is flagged as the single
  deliberate deviation from the prior Python.
- The §pareto dominance arithmetic checks out: B=(9,9,8) strictly dominates A/C/D/F and
  weakly dominates E; B is the unique Pareto-optimum under a correctness gate >= 7.
- The "EXPRESSIBILITY SIGNALS" block (S1-S4) is honest about what the encoding does *not*
  do (cross-unit conservation, capability scoping, row-level C11). That candor is worth
  more than a falsely tidy listing.

## Blocking issues

### B1 — Condition numbers do not follow introduction order; forces repeated index lookups
Conditions appear in the narrative as **C2, C1, C11** (§future), **C12** (§ma), **C3, C4**
(§qis), **C7, C5, C9, C10, C6, C8** (§untraded). The labels carry no mnemonic, so a
first-time reader meeting "C2" before "C1", "C11" in the opening subsection, and C5/C6/C7
scrambled in §untraded must flip to the §conditions index (lines 486-514) every time to
stay oriented. The rewrite's own principle is "each condition is defined once, at the
instrument that forces it" — renumber so first appearance is C1, C2, C3, ... in reading
order. This is a strict, mechanical improvement for the reader and the single largest
friction in the document.
Location: condition labels throughout §sec:future through §sec:untraded (lines 229-476);
index at §sec:conditions (486-514).

### B2 — "Unrepresentable" is overstated for P1/conservation, contradicting C2 and S4
§sec:unreachable (lines 621-622) says all seven invariants are "structurally
unrepresentable: the illegal state cannot be expressed," and lists P1 (conservation) among
them. But C2 (line 226) states plainly that conservation is "not enforced by types ... it
is enforced one level up, at the event handler," and Haskell S4 (lines 478-483) confirms
conservation is a value-level smart-constructor check returning `Either`. The precise and
correct claim is the one in §sec:reference: "an unconserved delta cannot *reach*
applyDelta" — unreachable *through the API*, not untypable. A Haskell-literate reader will
see `validate :: StateDelta -> Either ConservationError ValidDelta` and feel the blanket
"cannot be expressed" framing is wrong for P1. Reconcile in one place: distinguish the
genuinely type-level guarantees (P6 via `NonEmpty`, P7, P10 via the GADT) from the
abstract-type-plus-smart-constructor guarantees (P1), and drop the uniform "cannot be
expressed" wording for the latter.
Location: §sec:unreachable header and P1 gloss (lines 621-628); cf. line 226 and Haskell
lines 478-483.

### B3 — Two distinct "handler" vocabularies collide
tex C2 (lines 229-241) names event-class handlers `Trade, SettleVM, CorporateAction,
QISRebalance, MandateAmend`. The Haskell `Handler` enum (line 193) is the field-writer set
`Settle, Trade, Transfer, FeeCrystallise, Subscribe`. These are different concepts (event
classes vs per-field canonical writers) sharing the word "handler" and partially
overlapping names (`Trade`, `Settle`/`SettleVM`). A reader cross-referencing the spec
against the reference will try to align two lists that do not align and lose time deciding
whether the mismatch is a bug. Either reconcile the two sets or state explicitly, where C2
and C11 are introduced, that "event-class handler" and "field-writer" are different axes
and the names are not meant to match.
Location: tex C2 (229-241) vs Haskell `Handler` (line 193) and C11 narrative (280-285).

### B4 — C11's type-level guarantee is asserted but never exhibited biting in context
§sec:reference (line 740) and Haskell S3 (lines 469-476) claim a wrong-handler write is "a
type error." The only evidence is the stub `_c11_ok_settle`/`_c11_ok_fee` and a *commented*
`_c11_bad` (lines 437-443). No actual handler in the file produces a
`Map WalletId (FieldWrite 'Settle)` that then flows into a `StateDelta`, and because
`FieldWrite(..)` and `SomeWrite(..)` are both exported (line 45), any caller can place
`SomeWrite (WHwm q)` into `sdRows` under any event with no type error at all. So at the
StateDelta level — the level that actually feeds `applyDelta` — C11 does not bite; it bites
only at a handler-authorship site that the reference does not contain. S3 acknowledges the
erasure, but a reader who wants to *see* the guarantee finds only stubs. Either add one
real authored handler (e.g. `settleHandler :: ... -> Map WalletId (FieldWrite 'Settle)`
feeding a delta) so the guarantee is demonstrated where it matters, or soften the
§sec:reference/tex C11 wording to say the guarantee holds at authorship and is erased at
the row, matching S3 rather than overstating in the body.
Location: Haskell `_c11_*` (437-443), exports (line 45), S3 (469-476); tex C11 (280-285),
§sec:reference bullet (line 740).

## Non-blocking observations (do not fix unless cheap)

- `WEntryNav` write-once (line 219) and `WHwm` qmax (line 218) silently no-op a
  second/lower write. Intended monotone/write-once semantics, but it sits in mild tension
  with the project's fail-loud posture: a second `entryNav` write is a likely caller bug
  yet is swallowed. A comment noting "second write is intentionally ignored, not an error"
  would close the gap. Acceptable as-is.
- The §answer "Home of each datum" table (168-186) overlaps the per-instrument tables.
  Useful as a summary; not cuttable without loss. Fine.
- The Haskell comment blocks are large. For a *specification* reference, optimizing for the
  reader, this is the right trade — keep them.
