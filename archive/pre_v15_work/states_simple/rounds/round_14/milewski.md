# MILEWSKI — States.tex / States.hs, Round 14

**Verdict: OBVIOUS.**

My lens: the Haskell must read like Hutton — types before functions, each step obvious from
the last, every abstraction named only after the thing it names and only once it earns its
keep. A first-time competent engineer must follow the thread without being asked to take a
categorical name on faith. I read `States.tex` end to end, cross-checked every listing
against `States.hs`, resolved every `\ref` against `States.aux`, and confirmed the build is
clean.

## Delta this round is `.tex` prose only; `.hs` unchanged

`States.hs` mtime (12:33) predates Round 13; `States.tex` (13:07) is the only artifact
touched. The R14 changes are STYLUS prose edits resolving the R13 residue. None touches a
type, signature, body, or listing. The code has been OBVIOUS under my lens since R5 and the
R12 comment-scrub; I re-ran the full Hutton-bar pass fresh anyway (below) and it holds.

All six R14 prose fixes are present and correct:
1. **Headline count made conditional on the reification** (§Answer 60-67): "the binary
   holder-axis, and so the count below, rests on it." The downstream counts inherit the
   conditionality stated once at the axis. Honest — the document no longer reads "exactly
   three" as absolute while its lemma is conceded unproven.
2. **Keystone sentence split** (§Answer): the four-em-dash run-on is gone; the reification
   sentence now carries one em-dash pair.
3. **Reification caveat stated once in full** at §Why Three (154-161); §Answer carries only
   the compressed conditional pointer (63-65). Not pure duplication — the §Answer pointer is
   what makes the count conditional.
4. **psHwm reason stated once** at §Construction (240-243); §right (358) reduced to a bare
   scope-note pointer `(\S\ref{sec:construction})` that resolves to §4 where the reason lives.
5. **Coherence stated positively** (261-262): "Coherence is carried by the pair, not the
   seal; the seal is left to keep conservation true by construction." No backward "no longer"
   reference to a design the fresh reader never saw.
6. **Replay partiality stated** (380-383): `replay` returns `Just` on a well-formed stream,
   `Nothing` on an ill-formed one (repeated registration, or move/settle on an unregistered
   unit), `foldM` halting at the first refusal. The `Maybe` codomain is now accounted for.

Build: `States.log` shows zero undefined refs, zero warnings, zero overfull/underfull boxes.
`States.aux` resolves sec:answer={2}, sec:why={3}, sec:construction={4}, sec:right={5}; all
seven `\ref`s land on their cited content (sec:why uses → §3 reification/empty-cell/terms≠
status; sec:construction uses → §4 three-homes / psHwm reason).

## Fresh Hutton-bar pass (the `.hs` thread)

Clean. Every abstraction is introduced after the value it names and earns its place:
- `Qty` group (Monoid + `negQty`) — the inverse exists solely so a transfer's two legs
  cancel; `foldMap` named only after conservation is written as a sum (steps 1, 4).
- `Price` deliberately not a Monoid/group, contrasted with `Qty` — keeps a price from ever
  being summed into a balance (step 5).
- `Lifecycle = Listed | Active Price` — price rides on `Active`, so active-but-unpriced and
  listed-but-priced are unspellable; the file states the shape-vs-writer-invariant contrast
  with conservation explicitly (step 5).
- `NonEmpty` terms grown only by `appendVersion` — "registered but versionless" not
  representable; append-only by construction via unexported constructor (step 6).
- `PositionState` grows from the step-3 bare `Qty`, held quantity surviving as the first
  field (step 7).
- `Ledger` = two maps for three homes; terms/status co-presence structural in the pair;
  sealed constructor leaves conservation no other door (step 8).
- `applyMove` net-first (`netDeltas` then `writeNet`) — motivated by the zero-move /
  self-move pollution of the never-held vs held-and-flat distinction before it is
  mechanised; "held = named in a move that nets nonzero on it" (step 8).
- `replay = foldM (flip apply)` — named only once it is plainly the word for what is on the
  page; determinism attributed to purity of `apply`, checkpoint-independence to the monadic
  left-fold law, NOT to row retention (step 9).

Laws are honestly classified shape-enforced vs soundness-argued (step 10): conservation and
append-only terms history and the unregistered-unit gate are writer/seal invariants, not
type guarantees; priced-iff-active, NonEmpty terms, pair co-presence, two-key balance,
two-leg move are carried by the shape. The reader is never asked to take a writer discipline
on faith as though it were a shape. Totality/exhaustiveness verified by reading (no GHC in
env): `apply` total over all three `Event` constructors; `settlementPrice`, `currentTerms`
total; `Map.foldrWithKey`/`insertWith`/`adjust` used at correct types.

## Standing flag returned to me (psHwm typed `Qty`) — already adjudicated, not residue

jane-street-cto re-raises giving `psHwm` (and entry NAV) a newtype with no
`Semigroup`/`Monoid`, mirroring `Price`, so HWMs cannot be folded the way `netBal` folds
`psBal`. This is the standing decision I settled in Rounds 2-13 and it stands: a high-water
mark **is** a genuine quantity and combines under the same `Qty` monoid (adding HWMs is a
legal operation); what it lacks is a cancelling-pair writer, so it carries no zero-sum
invariant. Conservation is a property of *how a field is written*, not of its type — making
a legal monoid disappear to "mark" a field non-conserved would decorate, not remove a
representable bug. The `.tex` prose does not overclaim a type guarantee (it states "no
aggregate over holders is claimed for it" — a disclosed discipline), and FORMALIS R13
confirms the prose is honest. So nothing forces a change and this is not new residue. (Note
for the record: were a future round actually to *write* `psHwm` via a valuation event and
want the type to forbid its summation, that would re-open the question — but no such writer
exists in this file.)

## Residue

None.

Non-blocking nit, carried unchanged for 11 rounds (FORMALIS R13 calls it "a licensed
structural simplification, not a misstatement"): `States.tex` renders `TermsVersion` (:223)
and `Move` (:305) as positional constructors where `States.hs` uses record syntax. The
`.tex` is internally consistent (it never uses the dropped field accessors), so a
reader-of-tex-alone is not misled. STYLUS-owned, cosmetic, not residue.

**OBVIOUS.**

— MILEWSKI
