# States.tex — iteration log

## Round 2 (STYLUS) — restructure prose around the corrected States.hs

Scope: full rewrite of `States.tex` to track the corrected `States.hs` (the
solution-only, no-path, ~3-page statement). Three pages, compiles clean
(`pdflatex`, 0 errors). Every `SOLUTION_ESSENCE.md` KEEP item retained.

Per pooled-residue item (`rounds/round_01/_pooled_residue.md`):

- **1, 5, 19 (balance vanished).** `PositionState` now leads with `psBal` as the
  primary, conserved per-position fact; the assembled `Ledger`'s third map is the
  `PositionState` map (the balance map enriched). Conservation is stated and shown
  about the stored structure via `netBal` over `psBal`. The held quantity no
  longer disappears from the answer.
- **2, 6, 10, 14 (Event/apply not shown; transfer over a vanished Balances).**
  `applyMove`, `settle`, `Event`, `apply`, `replay`, `netBal` are now shown.
  `applyMove` writes the two cancelling legs into `psBal`. The standalone
  `transfer`-on-`Balances` listing was cut as scaffolding (Landau): `applyMove` is
  the genuine transfer on the stored structure; the two-legs-from-one-quantity idea
  is carried in the `holding` paragraph and at `applyMove`.
- **2, 11 (Maybe vs "cannot be written").** Reconciled honestly: the `Maybe`
  guards malformed input (a move/settle naming an unregistered unit), not
  conservation. A well-formed move cannot break conservation because its two legs
  cancel by construction. Stated at `applyMove` and again at `replay` (the `foldM`
  failure).
- **3, 22 (non-sequitur: row retention ⇒ fold).** Removed. Determinism is
  attributed to `apply` being a pure, total function; checkpoint-independence to
  the monadic left-fold law. Row retention is stated as a separate property serving
  audit and the never-held/held-flat distinction, explicitly not the cause.
- **4, 9 (no-fourth as universal, not one example).** The Answer now argues the
  universal: every economic fact about a wallet is a fact about its relationship to
  some unit (a holding, mandate, or strategy is a unit it holds), hence a position;
  no economic fact is about a wallet and no unit. KYC/permissions/audit cursor are
  named as identity, not economic state. The claim is qualified precisely as "no
  fourth economic-state home." Mandate used only as illustration.
- **7 (three keys is false).** Reorganised on the principle "distinguished first by
  what it depends on, then by change discipline." Stated once: three homes, not
  three keys — terms and status share the unit key, split by discipline.
- **8, 12, 13 (terms/status necessity; the 2x2 fourth cell; one cleavage).**
  Single classification principle: a 2x2 over {unit, (holder,unit)} x {versioned
  external authority, overwritten in place}. Three occupied cells named; the fourth
  ((holder,unit) under external authority) answered head-on: write-once position
  fields (entry NAV) are folded from the opening event and need no external
  authority, which exists only for externally-sourced unit terms. The terms/status
  split is grounded in provenance/authority (honest), not the false "one map cannot
  hold both fields."
- **15, 20 ("every event is a transfer" false).** Restated: a move conserves by
  its two cancelling legs; a settle moves no quantity and leaves every holding sum
  untouched. Net change over holders is zero for every event kind.
- **16 (status/terms not replayed).** `Settled` is an event; replay rebuilds status
  with positions; registration writes terms. Stated: every view is a projection of
  the stream.
- **17 (psAc/psHwm both Qty).** Addressed on settled grounds (see false-positive
  note below): conservation is a property of how a field is written, not of its
  type; `psHwm` adds but is never written as cancelling legs.
- **18 (price = quantity).** `Price` is now a distinct newtype with neither
  identity nor inverse, and can never be summed into a balance.
- **21 (conservation "fact of the shape" overclaims).** Restated honestly:
  conservation is an invariant of the writer, not a property the store type
  forbids. The map can hold a non-conserving assignment; the only writer of `psBal`
  writes it balanced, and the sealed constructor leaves no other door, so every
  reachable ledger conserves.
- **23, 25 (overwrite discipline never exhibited).** `settle` is shown as the
  overwrite witness, in deliberate contrast to `appendVersion`.
- **24 (ProductTerms constructor exported).** Listing annotated "constructor not
  exported"; prose states the append-only discipline holds by construction.

### False positives / settled non-defects (returned with reason)

- **Item 17** (and the "make psHwm non-conserved unrepresentable" demand): not a
  defect to fix by adding a newtype. The corrected `States.hs` §8 settles that
  conservation is a property of *how a field is written*, not of its type;
  `psHwm` legally adds (total peak exposure is a meaningful sum), it simply does
  not cancel. A newtype marking it non-conserved would only decorate. The tex now
  states this position; the reviewer's implied fix is declined on settled grounds,
  not deferred.
- **Item 18, issuance part:** modelling an issuance of `+/-1` as `Qty` is correct,
  not a confusion — issuance is a transfer of quantity. Only the price/quantity
  conflation was a genuine defect, and it is fixed by the `Price` newtype.

### Layout note
To hold three pages with all load-bearing listings (`apply`, `settle`, `netBal`,
`Price` are required by residue), margins and listing skips were tightened and the
redundant one-sentence capstone (a restatement, not a KEEP item) was removed.

## Round 3 (STYLUS) — align `States.tex` to the corrected `States.hs`; resolve Round-2 residue

Scope: `States.hs` had been corrected since Round 2 (registration is now an `Event`
constructor; `register` is shown and refuses duplicates; `Lifecycle = Listed |
Active`; `psHwm` writer is out of scope, field stays zero). `States.tex` lagged and
contradicted it. This revision aligns the prose and listings to the settled `.hs`
and resolves every Round-2 residue item. Three pages, compiles clean (`pdflatex`,
0 errors, 0 overfull/underfull boxes). Every `SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **karpathy (empty fourth cell asserted, not shown).** §Why Three fourth-cell
  paragraph now states the load-bearing premise: every position is sourced
  internally from the ledger's own move events, so a per-position fact is internal
  by construction; any external per-(holder,unit) figure (custodian holding
  statement, prime-broker position report) is a boundary reconciliation input, not
  a stored, versioned authority. That is what leaves the cell empty.
- **chris-lattner / henri-cartan / formalis (registration not an Event; replay
  can't register; "event" used in two senses; projection claim false for terms).**
  Resolved by the corrected `.hs` and reflected in the tex: `Event` listing now
  shows `Registered UnitId TermsVersion | Moved Move | Settled UnitId Price` with
  the three `apply` cases; replay prose states registration, settlement, and moves
  are all events, so replay from `emptyLedger` introduces each unit and rebuilds
  status and positions — every view a projection of the stream. Conservation
  enumeration now names `register` and `settle` as writers that touch only
  `ledgerPT`/`ledgerUS`, never `psBal` (covers the registration step of the
  induction; henri-cartan's "only" clause).
- **chris-lattner / henri-cartan / dirac (second axis fuses source and retention;
  2x2x2 vs 2x2; settlement price external yet in "internal" cell).** The Answer's
  second axis is now purely **retention discipline** (history retained in store as
  a version list vs only the current value kept, overwritten). Source (external/
  internal) is demoted to one motivation sentence ("retention follows provenance"):
  terms answer to an external authority whose corrections must stay auditable, so
  history is kept; status/positions keep only the current value, recovered by
  replay when a prior is needed. This removes the settlement-price-on-wrong-side
  contradiction (Status is overwrite-in-place regardless of source).
- **dirac (terms cache version list, status caches only current — reconcile with
  projection).** §Why Three terms paragraph adds the reconciling sentence: both are
  rebuilt by replay, but terms additionally retain their version list in the store
  because prior versions are queried directly for audit, while a prior settlement
  value is only ever needed as the current projection.
- **chris-lattner (`emptyLedger`, `zeroP` undefined in the document).** Both now
  shown: `emptyLedger = Ledger Map.empty Map.empty Map.empty` (named the
  conservation base case) and `zeroP = PositionState mempty mempty`.
- **jane-street / minsky / milewski (Lifecycle four stages; Expired/Closed
  uninhabited; settle flips to Active).** tex `Lifecycle` listing now `Listed |
  Active`, prose states only the two stages the writers reach.
- **jane-street / minsky (register absent; coherence and append-only rest on it).**
  `register` is now shown (refuses a unit already present, returns `Nothing`), so
  the terms/status coherence and the append-only "no third door" claim are visible,
  not promised. §Terms paragraph adds that `register` lays down version one only
  where none exists.
- **jane-street (psHwm dynamic verbs unprovable).** Dropped "ratchets, retained
  after close-out" dynamic claims; tex now matches the `.hs` hedge: the high-water
  mark's writer is a valuation event, out of scope here, so `psHwm` stays zero in
  this file, present only to show a non-conserved field beside the conserved
  balance. The line-equivalent conservation argument rests on "no shown writer
  pairs `psHwm` into cancelling legs."

### Layout (Round 3)
Content grew (residue-required `register` listing, `Registered` constructor,
`emptyLedger`/`zeroP`, added sentences), pushing to 4 pages. Reclaimed to 3 without
cutting any KEEP item or required listing: compact custom title block (replacing
`\maketitle`), `geometry` to 0.45in top/bottom and 0.75in sides, listing
`above/belowskip` 0.1em, tighter `titlesec` spacing, `\linespread{0.97}`, and
Landau prose trims (collapsed the duplicate retention-motivation paragraph in The
Answer into one sentence; tightened the conservation and replay paragraphs).

### Residue judged false positive / resolved-in-source (returned with reason)
- The bulk of the Round-2 residue (registration-not-an-event, register-not-shown,
  Lifecycle four stages, register duplicate-overwrite, psHwm dynamic claims) was
  **already corrected in `States.hs`** before this pass; the defect was the tex
  lagging the `.hs`, not a design defect. Fixed by alignment.
- **psHwm "make non-conserved unrepresentable" (carried from Round 2):** declined
  on settled grounds, unchanged — conservation is a property of how a field is
  written, not of its type; `psHwm` legally adds. A newtype would only decorate.

## Round 4 (STYLUS) — re-ground the terms/status split; align to corrected `States.hs`

Scope: `States.hs` had been corrected again since Round 3 (`Lifecycle = Listed |
Active Price` with the price on the constructor; `UnitStatus` reduced to a single
`usLifecycle` field, `usLastSettle` removed; `settle` writes
`UnitStatus (Active px)`). `States.tex` lagged it and still carried the disputed
"forced by representability" justification for the third home. This pass aligns the
listings and re-grounds the split. Three pages, compiles clean (`pdflatex`, 0
errors, 0 overfull/underfull boxes). Every `SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **minsky (UnitStatus permits two illegal states; correlation held only by writer
  invariant).** Resolved in `States.hs` (the `Active Price` constructor makes
  "active with no price" and "listed yet priced" unspellable). The tex listings and
  the §Construction shared-status prose now match: `data Lifecycle = Listed | Active
  Price`, `newtype UnitStatus = UnitStatus { usLifecycle :: Lifecycle }`, `settle`
  via `Map.insert u (UnitStatus (Active px))`, and prose stating the correlation
  holds by the type, not by a writer trusted to set two fields in lockstep. The tex
  was lagging the `.hs`; not a design defect.

- **karpathy / chris-lattner (×2) / dirac (terms/status split asserted as forced;
  no illegal state arises from combining; "only ever needed as the current
  projection" self-contradictory and likely false).** The split is no longer
  claimed forced by representability. §The Answer's second axis is now **authorship
  / provenance** (the external reference-data authority's versioned artifact vs the
  ledger's own record), with the retained shape (version list vs current value) as
  its visible consequence. §The Answer and §Why Three now state plainly that a
  combined unit-keyed cell is representable and the homes are kept apart by
  provenance, not necessity; "both rebuilt by replay" is kept (it is true) and the
  self-contradictory usage sentence ("a prior settlement value is only ever needed
  as the current projection") is deleted, not reworded. dirac's grounding (terms are
  the external authority's artifact held as the system of record's authoritative
  versioned record, auditable at the boundary; status/positions are the ledger's own
  records) is made the load-bearing justification, traceable to CLAUDE.md scope
  (reference-data authority is an external authority reconciled at the boundary).

- **jane-street / karpathy (appendVersion reachable from no event; "every view is a
  projection" / "both rebuilt by replay" false for amended terms).** Took the
  out-of-scope route (route b), since STYLUS does not write Haskell and the current
  `Event = Registered | Moved | Settled` has no amendment constructor. The amendment
  event that drives `appendVersion` is now flagged out of scope in this file,
  exactly as the valuation event that writes `psHwm` is. §Why Three, §Construction
  (register/settle), and §Why It Is Right (replay) all state that within this file
  each terms value has exactly one version, replayed from its `Registered` event, so
  "every view is a projection of the stream" is true as stated and the projection
  claim is narrowed to exclude in-store multi-version term history (the home's
  capability, not exercised here).

- **chris-lattner (psHwm dead field "not free").** Conceded as defensible by the
  reviewer; carried unchanged to match `States.hs`, which keeps `psHwm` to exhibit a
  non-conserved field beside the conserved balance. A `.hs`/milewski call, not a
  STYLUS prose call. See standing decision under Round 2/3.

### Layout (Round 4)
Net new content (authorship axis, amendment-out-of-scope disclosures) was offset by
Landau trims (collapsed the combined-cell concession to one place, reframed the
fourth-cell paragraph onto the authorship axis and shortened it, cut the replay
intro restated by the listing) plus `\linespread{0.95}`. Three pages held.

### Residue judged false positive / out of STYLUS remit (returned with reason)
- **jane-street / karpathy "add an `Amended` event + amend writer" (route a):** not
  actioned here. It is a `States.hs` change (subject-matter / milewski), and the
  task fixes prose around the existing Haskell. Returned to milewski: if amended
  term versions must be replayable, add `Amended UnitId TermsVersion` whose `apply`
  calls `appendVersion` (refusing unregistered units, same `Maybe` shape); the tex
  would then drop the out-of-scope flag and widen the projection claim to terms
  history.
- **chris-lattner / dirac "prove the split is forced, or report two":** STYLUS does
  not decide this content question. The four reviewers converge on provenance as the
  valid non-collapse ground (dirac and karpathy both accept it explicitly), so the
  prose now grounds three homes in provenance and stops calling the split forced.
  Whether "three" should instead be claimed as a correctness necessity (requiring a
  query/correctness property replay cannot serve for terms) is returned to the
  subject-matter agents; the prose does not assert one.

## Round 5 (STYLUS) — align `States.tex` to the merged-map `States.hs`; restore the third-home necessity; rename the second axis to correction discipline

Scope: `States.hs` had been corrected again since Round 4 — the two unit-keyed maps
(`ledgerPT`, `ledgerUS`) are now one pair map `ledgerUnit :: Map UnitId
(ProductTerms, UnitStatus)`; `register` inserts the pair, `settle` does `Map.adjust`
over `snd`; the terms/status split is grounded on change-discipline incompatibility
(a single value cannot be both append-only and overwrite-in-place); `Balances`,
`transfer`, `netOf` are no longer exported. `States.tex` lagged on every point and
still carried the disputed "by provenance, not necessity" framing. This pass aligns
the `.tex` to the `.hs` and resolves all Round-4 residue. Three pages, compiles clean
(`pdflatex`, 0 errors, 0 overfull/underfull boxes). Every `SOLUTION_ESSENCE.md` KEEP
retained.

Per residue item:

- **karpathy (dichotomy asserted, not grounded; multi-unit keys silently excluded).**
  §The Answer now grounds the either/or at first use with the two clauses the
  reviewer named: (a) the scope is one unit's state, so only the unit and a holder of
  it are in view; (b) any relationship spanning several instruments (netting set,
  cross-margin portfolio, cross-currency offset) is itself a unit, so a fact about it
  is a (holder, that-unit) fact. The $2\times2$ is now forced, not posited.
- **karpathy (the "no fourth home" paragraph closes only the wallet-alone case).**
  That paragraph now states explicitly that it closes the holder-alone keying, notes
  the multi-unit keying was already closed (relationships are units), and concludes
  that with both excluded only the unit and the (holder, unit) pair carry economic
  state. Both excluded keyings are now visibly accounted for.
- **chris-lattner (intro thesis "placement forces" contradicts §5).** §The Question
  reworded: the placement *makes attainable*; the sealed single-writer discipline and
  the purity and totality of replay *make hold by construction*. Placement now
  enables; the writers and purity force, matching §Why It Is Right.
- **chris-lattner (self-containedness: `Move`, `WalletId`, `UnitId`, `TermsVersion`,
  `defaultStatus` undeclared).** All now declared in the listings: `WalletId`/`UnitId`
  with `Balances`; `TermsVersion` with `ProductTerms`; `defaultStatus = UnitStatus
  Listed` (showing the initial `Listed` stage) with status; `data Move = Move UnitId
  WalletId WalletId Qty` (positional, fixing the leg order against the `Move u from to
  q` pattern) with `applyMove`. The construction intro now says the listings reproduce
  the `.hs` declarations with deriving clauses elided (not "verbatim").
- **dirac (second axis "authorship" does not carve; same-author facts land in
  opposite cells).** The second axis is renamed to how a correction is recorded: a
  correctable definition (append a version, prior kept) vs a superseding observation
  (overwrite, current kept, prior by replay). §The Answer's Status bullet now states
  an externally sourced figure is status when recorded as a superseding observation —
  what places a fact is how its correction is recorded, not who authored the number —
  with the same index provider's benchmark identity (terms) vs benchmark level
  (status) as the witness. This carves Terms from Status by retention semantics, as
  the reviewer required.
- **jane-street (third home weakest; "by provenance, not necessity" disclaims it).**
  Restored the disciplinary-incompatibility necessity argument from `States.hs` and
  dropped "by provenance, not necessity": a single value admitting both writers would
  be at once an append-only list and an overwrite-in-place cell, so terms and status
  are distinct values with distinct types. They share the key, so they ride as a pair:
  a third home, a third kind of state, not a third map. Matches `SOLUTION_ESSENCE.md`
  KEEP item 4 (two change disciplines cannot share one home).
- **jane-street (Answer advertises four position fields; type shows two).** §The
  Answer's Position bullet trimmed to the exhibited fields, "held quantity and a
  high-water mark." Accumulated cost and entry/benchmark NAV removed from the
  advertised contents; the fourth-cell paragraph keeps a single write-once example
  (entry NAV) marked "elided here," and the managed-account example drops "entry NAV"
  from its list.
- **minsky (collapse the two unit-keyed maps; coherence by shape, not by sealed
  writer).** Applied — the `.tex` now matches the merged `States.hs`: `Ledger` is
  `ledgerUnit :: Map UnitId (ProductTerms, UnitStatus)` plus `ledgerPS`; `emptyLedger`
  two maps; `register` inserts the pair; `settle` uses `Map.adjust` over `snd`;
  `applyMove` and the conservation enumeration gate on / touch `ledgerUnit`. Co-presence
  is now structural (one entry carries both halves or neither) — a tautology, not a
  writer invariant — and the document states "three homes, two maps." The seal is left
  to do only conservation and the append-only terms door.

### Layout (Round 5)
Net new content (two grounding clauses, the externally-sourced-figure sentence, five
inline declarations) offset by Landau trims (collapsed restatements in the status,
applyMove, conservation, managed-account, and replay paragraphs) plus tightened
listing skips, `geometry` 0.4in/0.7in, and `\linespread{0.88}`. Three pages held; the
denser spacing is a layout cost of the residue-required additions, not a content cut.

### Residue judged false positive / out of STYLUS remit (returned with reason)
- **minsky (Balances/transfer/netOf exported, lines 26-29):** out of STYLUS remit —
  it is a `States.hs` export-list / milewski concern, and the `States.tex` exhibits no
  `transfer`/`netOf` function to mistake for the real API. Moreover the current
  `States.hs` module header already states these are deliberately NOT exported, so the
  line reference points to a superseded version; resolved in source. No `.tex` action.
- **psHwm dead-field / "make non-conserved unrepresentable" (standing):** unchanged,
  declined on settled grounds carried from Rounds 2-4 — conservation is a property of
  how a field is written, not of its type; a marker newtype would only decorate.

## Round 6 (STYLUS) — land the never-held/held-flat distinction on the production store; reframe the empty cell as structural

Scope: cut the `Balances`/`holding` teaching scaffolding from `States.tex` and move the
`Nothing` vs `Just 0` distinction onto `position` over `ledgerPS`, the store the system
keeps; reframe the empty fourth cell from authorship (contingent) to received-vs-owned
(structural). Three pages, compiles clean (`pdflatex`, 0 errors, 0 overfull/underfull
boxes). Every `SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **chris-lattner / jane-street-cto x2 (the sharpest idea lands on a discarded type;
  `Balances`/`holding` declared but never used by `Ledger`/`applyMove`; "two maps"
  count contradicted by three declared Map types; line-356 distinction asserted for
  `ledgerPS` but exhibited only on superseded scaffolding).** Resolved by the cut-and-
  relocate route the residue offered. `type Balances`, `holding`, and the
  Maybe/transfer paragraph are removed from §The Construction; step 2 now declares only
  `WalletId`/`UnitId` and states the pair-key fact, forward-referencing the assembled
  store. The never-held/held-flat distinction is exhibited on the real accessor, with
  the exact `States.hs` listing `position :: Ledger -> WalletId -> UnitId -> Maybe
  PositionState` / `Map.lookup (w, u) (ledgerPS l)`, in a new "Reading a position"
  paragraph placed after `applyMove` (where the first-touch flat row and the close-out
  zero are produced). The "two maps" count now matches the listings: only `ledgerUnit`
  and `ledgerPS` are declared. The transfer two-legs idea, previously on the discarded
  `Balances`, is now stated once at `applyMove` (foreshadowed at `Qty`), on the stored
  `psBal`. Line 356's row-retention claim now rests on shown code and was trimmed to
  reference the distinction shown above (Landau: restatement removed).

- **dirac (three-home count rests on the empty fourth cell, but §Why Three argues its
  emptiness by authorship/origin while §The Answer rules authorship out — contingent
  emptiness dressed as structural; the two passages read as contradictory).** §Why
  Three's fourth-cell paragraph is reframed on the unifying principle the document
  already held in pieces: the ledger versions what it RECEIVES at its boundary (a
  correctable definition is a versioned artifact audited against an external authority)
  and DERIVES what it OWNS (a position is the ledger's own record, folded from its own
  move stream, the ledger its single writer). So no received per-(holder, unit)
  definition exists to version; the definition discipline can inhabit only the unit
  key. Reconciled with §The Answer by an explicit clause distinguishing the two
  questions: among unit-keyed facts correction discipline alone separates terms from
  status (authorship irrelevant, §The Answer); the question at the fourth cell is which
  key may host a definition at all (received-vs-owned decisive). The cell is now empty
  by construction; the heading reads "empty by construction, not by survey" and the
  paragraph closes "three homes are forced, not counted." §The Answer gained
  `\label{sec:answer}` for the cross-reference.

### Layout (Round 6)
Net new content (the `position` accessor paragraph + listing, the longer received-vs-
owned fourth-cell paragraph with its reconciliation clause) pushed to 4 pages; the
spillover was the last three lines of the replay paragraph. Reclaimed to 3 without
cutting any KEEP item: `\linespread` 0.88 to 0.86, plus Landau trims (the transfer
mechanics in the `applyMove` paragraph, restated in the conservation paragraph,
shortened to their one introduction; "so the checkpoint point does not matter" cut as a
restatement of "checkpointing is sound"; "never collapsed" cut from the position
paragraph). Denser spacing is the layout cost of the residue-required additions, not a
content cut.

### Residue judged false positive / out of STYLUS remit (returned with reason)
- **jane-street-cto (port the `.hs` "superseded, non-exported precursor" framing for
  `Balances` into the `.tex`):** not actioned as written, and not a residual defect.
  That framing exists in `States.hs` to justify *why the scaffolding is not exported*
  from a module that still teaches it step by step. The `.tex` is solution-only; the
  cleaner resolution the same reviewer's item 1 calls for — make "two maps" literally
  true — is to *remove* the precursor entirely rather than carry it with a disclaimer.
  Both reviewers' alternative ("cut holding/Balances and introduce the pair key + Maybe
  distinction directly on the position map") was taken, which subsumes the port: there
  is no `Balances` listing left to annotate.
- **dirac reconciliation rests on a subject-matter synthesis (FLAG):** the received-
  vs-owned principle is assembled from settled pieces already in the document (CLAUDE.md
  boundary-reconciliation scope; terms audited at the boundary; positions are the
  ledger's own records) at dirac's explicit direction. STYLUS rendered the synthesis as
  prose but does not own the claim that *every* correctable definition is necessarily a
  received external artifact and that no future per-(holder, unit) versioned definition
  can arise. If that universal is not settled, the subject-matter agent must confirm it;
  the prose now states it as structural and should be vetted as such.

## Round 7 (STYLUS) — bridge the column axis to the empty fourth cell on one discriminator; reframe the terms/status contrast and psHwm

Scope: resolve the Round-6 residue centred on the empty fourth cell being proved on a
different axis than the one §The Answer defines. Three pages, compiles clean
(`pdflatex`, 0 errors, 0 overfull/underfull boxes). Every `SOLUTION_ESSENCE.md` KEEP
retained.

Per residue item:

- **karpathy / henri-cartan / jane-street-cto (the empty cell swaps the axis;
  received-vs-owned vs correction-discipline; unargued "versions iff receives"
  biconditional; the bridge "owned ⇒ recoverable ⇒ overwrite" is false since terms are
  replay-rebuilt too).** Reframed the fourth-cell paragraph (§Why Three) to prove
  emptiness **by the seal**, a framework primitive: the (holder, unit) key is written
  only by the ledger's own writers, all overwriting; a correctable definition is a
  distinct discipline (versioning a received artifact), so admitting it on that key
  opens a writer beside `applyMove`, breaking the seal conservation rests on. Then, by
  **minimalism** (CLAUDE.md), nothing is wanted there anyway: a holding is the ledger's
  own, replay-recoverable fact with no external authority whose restatements a
  materialized version list would audit, and the recoverable-and-unaudited is never
  versioned. Heading is now "empty by the seal, not by survey." The bare
  "versions what it receives, derives what it owns" biconditional is deleted. The
  authorship reconciliation with §The Answer is kept (correction discipline alone
  separates terms from status; the fourth-cell question is which key may host a
  definition at all). Removed the redundant "; adopting it is the very writer the seal
  bars" restatement.

- **henri-cartan (state/derive the bridge once at the 2×2; minimalism axiom uninvoked).**
  Grounded the column axis at §The Answer: a correctable definition **materializes** a
  version list (auditable at the boundary without replay); a superseding observation
  keeps only the current value. Both are replay-recoverable, so the discriminator is the
  materialized list, and a list is materialized only to audit an external authority's
  restatements. Minimalism is now explicitly invoked at the fourth cell. NB the
  recoverability biconditional henri-cartan proposed verbatim ("append-keep iff prior
  irrecoverable from the stream") was **declined** — it is false by the document's own
  statement (terms are replay-recoverable yet append-keep, §right); karpathy's
  refutation is adopted instead, with materialization (not recoverability) as the carve.

- **karpathy (terms-vs-status implies a false asymmetry; §right says replay rebuilds
  terms too).** §Why Three terms paragraph now opens "Both terms and status are
  replay-recoverable (§right); they differ in what each materializes," and states
  "Materialization, not recoverability, separates them." The asymmetry the reader could
  infer (terms kept because replay won't serve) is removed.

- **henri-cartan (minor: assert the two disciplines are exhaustive).** Added one clause
  at §The Answer: the two disciplines exhaust a record of truth's options — an immutable
  fact is a definition of one version, a write-once owned field an observation written
  once, deletion barred by immutability.

- **karpathy (key axis {unit,(holder,unit)} asserted via un-demonstrated netting-set /
  cross-margin / cross-currency cases).** Narrowed (karpathy's offered option b): dropped
  the three un-exhibited examples; the principle "a relationship spanning several
  instruments is itself a unit issued to its parties" is now grounded on the **one
  demonstrated case**, the managed-account mandate of §Why Three (issued −1/+1),
  cross-referenced. The demonstration is not duplicated — §The Answer cites it.

- **jane-street-cto (psHwm "running peak" vs Qty additive monoid; "quantities add" is the
  wrong operation for a max-combining field).** §Construction position paragraph reframed:
  `psBal` uses `Qty`'s group structure (cancelling legs ⇒ conserves); `psHwm` **shares
  only `Qty`'s representation**, to exhibit a non-conserved field beside the conserved
  balance; its combine over time is the **running maximum, not addition**, deferred with
  its out-of-scope valuation writer. The "a high-water mark is a quantity, and quantities
  add" justification is removed. §Why It Is Right conservation: dropped "psHwm adds but"
  → "psHwm is never written as cancelling legs," so the wrong operation is no longer
  asserted.

### Layout (Round 7)
Residue additions (materialization grounding + exhaustiveness clause at §The Answer; the
seal/minimalism fourth-cell rewrite; the terms materialization sentences) pushed to 4
pages; the spill was the last 3-4 lines of the final replay paragraph. Reclaimed to 3
without cutting any KEEP item: Landau trims (the §The Answer version-list/single-value
restatement, now derived in §Why Three; the multi-unit restatement, now stated at the key
axis; the supplementary "Maybe is foldM's failure" sentence — the move-level Maybe is
reconciled at `applyMove` and checkpoint soundness stands on the left-fold law) plus
`\linespread` 0.86 → 0.82. The denser spacing is the documented layout cost of the
residue-required additions, not a content cut. (A linter reset linespread to 0.83 once;
0.83 spills to 4 pages, so 0.82 is required and was restored.)

### Residue judged false positive / out of STYLUS remit (returned with reason)
- **henri-cartan's exact biconditional "append-keep iff prior irrecoverable from the
  stream" — declined, not deferred.** It contradicts the settled content: §Why It Is
  Right states replay rebuilds terms (status, positions) from the stream, and the full
  system's amendment events would make terms' priors recoverable too. Adopting it would
  make the prose imply a fact the source contradicts. karpathy flagged the same falsity;
  the resolution adopts karpathy's discriminator (materialization + the seal), which
  derives the empty cell without the false biconditional.
- **The "no external authority defines any (holder, unit) fact" universal (carried FLAG
  from Round 6).** Still a subject-matter claim STYLUS renders but does not own. Round 7
  *reduces its load*: the empty cell now stands first on the **seal** (a derivable
  framework primitive — a second writer of position state breaks conservation), with the
  external-authority/minimalism argument as the "none is wanted anyway" reinforcement. If
  the universal (no per-(holder, unit) fact ever acquires an external defining authority
  whose restatements need boundary audit) is not settled, the subject-matter agent must
  confirm it; the seal argument does not depend on it, but the "none is wanted" sentence
  does.
- **karpathy's netting-set/cross-margin "show issuer + −1/+1 legs" alternative (option a)
  — not taken; option b (narrow) taken instead.** Demonstrating netting sets, cross-margin
  portfolios, or cross-currency offsets as issued units with −1/+1 legs is subject-matter
  content not present in `States.hs` (only the mandate is constructed). STYLUS does not
  author the issuance structure for those cases. FLAG to subject-matter: if the breadth
  claim must name those instruments, supply the concrete issuance (issuer, −1/+1 legs)
  for each, or they remain narrowed to the demonstrated mandate.

## Round 8 (STYLUS) — make the terms/status carve a reproducible test; define replay and economic state at first use; state the multi-unit reification as an assumption; chain the empty cell to one reason; stop asserting psHwm's unsettled combine

Scope: resolve the Round-7 residue centred on (a) the version-list criterion being
circular and mispredicting the benchmark split, (b) undefined load-bearing terms used
before definition, (c) a universal asserted from one example, (d) the empty fourth cell
reading as two reasons and as self-contradiction, and (e) `psHwm` asserting an unsettled
combine operation. Three pages, compiles clean (`pdflatex`, 0 errors, 0 overfull/underfull
boxes). Every `SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **karpathy (the version-list criterion is circular and predicts benchmark level into
  terms, contradicting its placement in status).** Replaced the circular discriminator
  ("a list is materialized only to audit an external authority's restatements against the
  in-force version") with karpathy's offered independent test, stated once at §The Answer
  column axis: a fact is a correctable definition when a past-dated value of it is read at
  the boundary without replay; a superseding observation when only the current value is
  consumed and any past value is recovered by replay. The Status bullet now derives BOTH
  benchmark facts from the test: the same provider authors both, yet the benchmark
  identity in force on a past date drives a boundary entitlement (versioned → terms),
  while only the current benchmark level is consumed, past levels recovered by replay
  (overwrite → status). "Identity is a definition" (circular) is gone; the split follows
  from the test. The fourth-cell paragraph's old "external authority whose restatements a
  materialized version list would audit" criterion was replaced by the owned/recoverable
  chain consistent with the new test.

- **karpathy (replay used at §The Answer but defined only at §Why It Is Right).** Added a
  one-clause definition at first use: "replay re-folds the immutable event stream from
  `emptyLedger` (§right)", inline where "recovered by replay" first appears.

- **henri-cartan ("economic state" used as the discriminator but never defined; wallet-only
  exclusion is enumeration by example).** Defined economic state positively at first use:
  "a fact that enters conservation, valuation, or profit and loss." The wallet-only
  exclusion now follows from the definition — KYC/permissions/audit cursor enter none of
  the three, so they are identity, not economic state — rather than by enumeration.

- **henri-cartan ("no wider key arises" generalised universally from the one mandate case).**
  Stated the reification as an explicit assumption at §The Answer ("on one assumption: a
  relationship spanning several instruments is itself a unit issued to its parties"), with
  the mandate as the case that DISCHARGES it for one relationship, and an explicit flag
  that coverage of every multi-instrument relationship is assumed, not established here.
  Took henri-cartan's "narrow / name as assumption" route (not "argue it covers all"):
  arguing universal coverage over cross-margining and netting sets requires the concrete
  issuance for those instruments, which is subject-matter content absent from `States.hs`
  (carried FLAG from Round 7). The mandate paragraph in §Why Three ties back to the
  assumption ("the assumption of §answer is discharged here for one relationship").

- **dirac / jane-street-cto (the empty cell reads as self-contradiction — two writers
  already act on the key — and as two reasons, the seal and minimalism "in any case",
  contradicting the "empty for one" promise).** Rewrote the fourth-cell paragraph as a
  single chain. (1) Stated the seal as single-writer-PER-FACT, not per-key: the valuation
  event safely writes `psHwm` beside `applyMove`'s `psBal` because they own DISTINCT
  fields. (2) Chained minimalism as the PREMISE the seal needs: every (holder, unit) fact
  is owned and replay-recoverable, so by minimalism no owned fact carries a version list;
  a correctable definition there would version an artifact about a holding `applyMove`
  already owns, hence a SECOND writer of that same fact, breaking the seal. Emptiness now
  falls out of one argument ("the only facts on the key are owned, and versioning an owned
  fact doubles its writer"). Heading reduced to "empty by the seal." This resolves both
  dirac items (E: seal-per-fact reconciles why the valuation event is safe but a
  definition is not; F: minimalism is the premise, not an independent backup) and the
  matching jane-street-cto item (the "empty for one" promise is now true).

- **jane-street-cto (`psHwm :: Qty` type-lies: the prose asserts a running-maximum combine
  the additive `Qty` monoid contradicts, and `States.hs` lines 542-549 assert the OPPOSITE
  — "high-water marks add").** The combine operation for `psHwm` is UNSETTLED between the
  two source documents (and conflates two fold axes: over holders `States.hs` says it
  adds; the prior tex said over time it maxes). STYLUS does not decide mathematics, so the
  tex now asserts NEITHER: removed "its combine over time is the running maximum, not
  addition"; the position paragraph states only the uncontested facts — `psHwm` shares
  `Qty`'s representation, is never written as cancelling legs (so carries no zero-sum
  invariant), and its writer and combining operation are out of scope and not fixed here.
  The conservation paragraph's duplicate psHwm mechanism was collapsed (Landau). The
  listing `psHwm :: Qty` / `zeroP = PositionState mempty mempty` is left to match
  `States.hs` (STYLUS aligns the tex, never edits the .hs). See FLAG below.

### Layout (Round 8)
Net new content (the test paragraph, the economic-state criterion, the assumption clauses,
the seal-per-fact chain) spilled to 4 pages. Reclaimed to 3 without cutting a KEEP item:
Landau trims (the mandate paragraph's closing assumption-flag, a duplicate of §The
Answer's; the economic-state triple "conservation, valuation, or profit and loss" reduced
to "the three" on its third occurrence; the conservation paragraph's psHwm sentence,
whose mechanism now lives in the position paragraph). `\linespread` held at 0.82 (0.80 was
tried as a fallback and reverted once the sentence cuts landed). Verify: `pdflatex` → 3
pages, 0 boxes.

### Residue judged a STYLUS-unsettleable content question (returned to subject-matter)
- **jane-street-cto's `psHwm` type-lie — FLAG, the contradiction must be settled in source,
  not in prose.** `States.hs` (lines 542-549) asserts "high-water marks add" (the over-holders
  Semigroup is addition; summed = total peak exposure); the prior `States.tex` asserted the
  over-time combine is the running maximum. These are not the same operation and the two
  documents disagree on which the field's monoid carries. STYLUS removed the contested
  assertion from the tex and now asserts neither operation. The type-level fix
  jane-street-cto requests (give the mark a `Max` newtype with the correct identity, or drop
  `psHwm` from the file) is a `States.hs`/milewski change deciding a math question; STYLUS
  does not author Haskell or decide mathematics. RETURNED: settle whether `psHwm`'s combine
  is max (identity −∞, a distinct newtype) or addition (current `Qty`, identity 0); the tex
  will then state the settled operation. Until settled, the tex stands on the uncontested
  facts only (no cancelling-leg writer ⇒ no zero-sum invariant), which suffices for the
  conservation argument the field is there to contrast.
- **Multi-instrument coverage universal (carried FLAG from Rounds 6–7).** Now stated in the
  tex explicitly as an assumption (not a derived fact). RETURNED unchanged: if the count's
  "no wider key" must hold for cross-margining / netting sets, supply each one's concrete
  issuance (issuer, −1/+1 legs); else the claim stands as an assumption discharged only for
  the mandate.

## Round 9 (STYLUS) — close the empty cell by the same boundary test; mark the answer conditional in-place; ground terms-distinctness on the in-scope discipline; lift exhaustiveness; sync the zero-move guard

Scope: resolve the Round-8 residue centred on (a) the empty fourth cell being argued
by a criterion (seal + recoverability) different from and self-contradicting the
boundary-read test that fills the other three, (b) the three-home answer resting on an
admittedly-unproven reification without surfacing the conditionality at the
conclusion, (c) the terms-vs-status discriminator naming a past-dated boundary read
the in-scope model cannot exercise, (d) the key-axis exhaustiveness justified only
after the 2x2 is built and a "fourth cell"/"fourth home" naming collision, (e) the
exhaustiveness four-way collapse proved in a single subordinate clause, and (f) the
zero-quantity-move phantom-row hole. Three pages, compiles clean (`pdflatex`, 0
errors, 0 overfull/underfull boxes). Every `SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **karpathy / chris-lattner / dirac / jane-street-cto (empty fourth cell: internal
  contradiction "folded from its own move stream" vs "the valuation event writes the
  high-water mark"; the seal chain assumes an unstated ownership lemma; "by minimalism
  the owned and recoverable is never versioned" re-imports recoverability, the
  criterion §answer disclaims, and is falsified by terms; the cell argued at ~18 dense
  lines in borrowed currency does not read inevitable).** Rewrote the fourth-cell
  paragraph (§Why Three) to close the cell by the **same boundary-read test** that
  fills the other three (dirac/jane-street-cto route). (1) The ownership lemma is now
  stated ONCE, before the chain: every (holder, unit) fact the ledger holds is its own
  --- held quantity folded from the move stream, high-water mark written by the
  valuation event, write-once entry NAV folded from the opening event --- and an
  external per-(holder, unit) figure (custodian statement, prime-broker report) is a
  reconciliation input, not a fact the ledger adopts as a definition. The "folded from
  its own move stream" overclaim is gone (the HWM is now correctly attributed to the
  valuation event), resolving karpathy's contradiction. (2) The test is applied: every
  (holder, unit) fact is consumed at the boundary at its current value alone, none read
  past-dated → by the test of §answer the key hosts no correctable definition → the
  cell is empty, "placed by the one test that fills the other three." (3) The seal is
  DEMOTED to a backstop ("A definition there could not be admitted in any case ---
  ... a second writer, breaking the seal"). (4) The "by minimalism the owned and
  recoverable is never versioned" clause is DELETED (chris-lattner/dirac: it
  re-imported recoverability and was falsified by versioned terms). Heading: "empty by
  the same boundary test." The authorship reconciliation with §answer is kept. Cell now
  ~13 lines, one chain.

- **karpathy / henri-cartan / jane-street-cto (the three-home answer rests on the
  reification "a relationship spanning several instruments is itself a unit," admitted
  unproven; the closure at the no-fourth paragraph reads absolute while the
  conditionality lives 40 lines upstream).** Marked the conclusion conditional
  IN-PLACE. The no-fourth closure (moved up, see chris-lattner item) now reads "both
  excluded --- conditional on that reification --- only the unit and the (holder, unit)
  pair carry economic state." STYLUS cannot prove the general reduction (subject-matter
  absent from `States.hs`); took the narrow/mark-conditional route. The assumption
  statement at §answer p2 and the mandate discharge at §why are unchanged.

- **henri-cartan (terms-distinct-from-status rests on "the version in force on a past
  date is read at the boundary without replay," which the in-scope model cannot express
  or evaluate: no timestamps, opaque-`String` `TermsVersion`, no effective-date index,
  `currentTerms = NE.last` returns only the current version, one version here --- so in
  scope terms is behaviourally indistinguishable from the overwrite cell).** Restated
  the in-scope discriminator on a property the model CAN evaluate (henri-cartan's
  second route; the `States.hs` effective-dating + as-of reader is out of STYLUS
  remit). §Why Three terms paragraph now: the two change disciplines (append-keep vs
  overwrite-discard) cannot share one value --- the disciplinary-incompatibility
  necessity, evaluable here via `appendVersion` keeps / `settle` discards (KEEP item
  4). The past-dated boundary read is named as the REASON terms takes the append
  discipline, with an explicit concession that that read, like the amendment event that
  grows the version list, is out of scope here, so "within this file every terms value
  has exactly one version, and the distinction the file exercises is the change
  discipline its two writers exhibit." The carve test at §answer is unchanged (it
  carves benchmark identity/level non-circularly); the in-scope EXERCISE is now grounded
  on the discipline incompatibility, not on an unexercised boundary read. FLAG below.

- **henri-cartan (the placement test presupposes each fact falls in exactly one case
  but states no tie-break for a fact read past-dated by one consumer and only currently
  by another, so the test is not a well-defined function).** Added the tie-break at
  §answer: "Any past-dated boundary read, by any consumer, makes it a correctable
  definition; only when no consumer reads a past value, the current value alone
  consumed, is it a superseding observation." The test is now total.

- **chris-lattner ("fourth cell" (§answer 2x2 empty cell) and "fourth home"
  (hypothetical wallet-alone home) name two distinct "fourth" referents within six
  lines; the key-axis exhaustiveness is placed AFTER the 2x2 is built and used).**
  Reordered §The Answer: the key-axis exhaustiveness (no key other than unit or
  (holder, unit) carries economic state; economic state defined positively; wallet-only
  facts are identity; the wider keying closed by the reification) now PRECEDES the
  correction-discipline axis and the 2x2 grid, so both axes are justified before the
  grid is drawn. The "fourth home" opener is gone (the moved-up paragraph opens "No key
  other than the unit or the (holder, unit) pair carries economic state"); "fourth
  cell" is now the only "fourth" referent in §answer. The old trailing closure
  paragraph was deleted (folded into the moved-up step).

- **jane-street-cto (one paragraph introduces the new terms, states the boundary test,
  AND proves the disciplines exhaust the space in a single subordinate clause; lift the
  exhaustiveness into its own step or reduce to a checkable claim).** Lifted the
  exhaustiveness into its own step at §answer, ahead of the test: "Two disciplines
  exhaust the choice: a correction either appends a version, keeping the prior, or
  overwrites in place, discarding it --- an immutable fact being a definition of one
  version, a write-once owned field an observation written once, deletion barred by
  immutability." The test (which discipline a fact takes) follows as a separate
  sentence.

- **minsky (`States.hs:515-517`: a zero-quantity move was well-formed input that
  silently created a flat row, a "held and flat" false positive polluting the
  never-held distinction).** RESOLVED-IN-SOURCE in `States.hs` (the `leg` now guards
  `| d == mempty = ps`); the `.tex` listing LAGGED it. Synced the `applyMove` listing
  to add the guard and a comment ("a zero leg writes no row"), and added one sentence to
  the `applyMove` paragraph: "A zero-quantity move is well-formed and accepted, but each
  leg is a no-op (above) that writes no row: held means named in a nonzero move." The
  never-held/held-flat distinction is now honest against zero moves.

### Layout (Round 9)
Net additions (the ownership lemma sentence, the lifted exhaustiveness step, the
conditional markers, the tie-break, the zero-move guard+note) net of the fourth-cell
shortening pushed the replay-paragraph tail onto p4. Reclaimed without cutting a KEEP
item: Landau trims (deleted "The key axis is binary." as a restatement; tightened the
zero-move sentence, dropping the never-held/held-flat re-statement already shown in
"Reading a position"; cut "as is the valuation event that writes a high-water mark"
parenthetical from the terms paragraph; merged the amendment-out-of-scope sentence into
the projection sentence in §right; deleted "which is from purity alone" (restates the
paragraph's opening attribution) and the duplicate "Conservation is a property of how a
field is written, not of its store type" in the conservation paragraph), then
`\linespread` 0.82 → 0.80 for the last stubborn line (whole-sentence cuts rewrapped but
page 3 was brim-full; 0.80 is the documented fallback that round 8 noted achieves 3
pages). Verify: `pdflatex` → 3 pages, 0 boxes.

### Residue judged out of STYLUS remit / returned to subject-matter
- **henri-cartan's `States.hs` route for the terms discriminator (effective-dating +
  an as-of reader + a concrete past-dated boundary read) --- FLAG, out of remit.** To
  EXERCISE the discriminator in scope (prove terms genuinely needs version retention,
  not merely that it CAN hold a list), `States.hs` needs effective-dated terms versions
  and an as-of reader returning a past-dated version, plus one boundary read of it.
  That is a `States.hs`/milewski change (and decides modelling content); STYLUS does not
  write Haskell. RETURNED: until added, the `.tex` grounds the in-scope distinction on
  the change-discipline incompatibility (evaluable) and names the boundary read as the
  out-of-scope reason for the append discipline.
- **minsky `States.hs:737` (closing summary overclaims "each fact was visible in the
  shape," contradicting the file's own disclosure that conservation/append-only/the
  unregistered-unit gate are writer/seal invariants, not shapes) --- out of task scope.**
  This is a `States.hs` comment; this task produces the Round-9 `States.tex`, which does
  NOT commit the overclaim (the `.tex` §Why It Is Right states conservation as a writer
  invariant, not a shape). RETURNED to milewski: reword `States.hs:737` to separate the
  shape-enforced facts (priced-iff-active, NonEmpty terms, terms/status pair, two-key
  balances, two-leg move) from the soundness-argued writer/seal invariants
  (conservation, append-only terms, the unregistered-unit gate).
- **Multi-instrument coverage universal (carried FLAG from Rounds 6-8).** Now marked
  conditional at the conclusion in-place. RETURNED unchanged: if the no-fourth count
  must hold for cross-margining / netting sets, supply each one's concrete issuance
  (issuer, -1/+1 legs); else the conclusion stands conditional on the reification,
  discharged only for the mandate.
- **psHwm combine operation (carried FLAG from Round 8).** Untouched this round; the
  `.tex` still asserts neither max nor addition. The `States.hs`/milewski decision
  (Max newtype with identity -inf, or current additive `Qty`) is unsettled.

## Round 10 (STYLUS) — derive the boundary-read test from the read-path/rebuild-path split; collapse the economic-state restatement; demote the seal at the empty cell; settle psHwm on the source; sync the self-move netting

Scope: resolve the Round-9 residue centred on (a) the boundary-read test asserted not
derived (the central terms/status discriminator), (b) the economic-state conclusion
stated three times, (c) the empty fourth cell proved twice (boundary test + seal),
(d) the `psHwm` type/prose contradiction, (e) the `from==to` self-move phantom-row hole,
and (f) the no-fourth conclusion resting on the unproven reification. Three pages,
compiles clean (`pdflatex`, 0 errors, 0 overfull/underfull boxes). Every
`SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **karpathy / henri-cartan (the boundary-read test is asserted, not derived; "makes"
  hides the step; "recovered by replay" framed as an alternative to materialization).**
  Added the missing load-bearing premise (supplied verbatim by both reviewers) at §The
  Answer column axis: a boundary consumer reads the **live projection synchronously**;
  **replay is the offline rebuild path, not a read the boundary can issue**. The
  derivation now runs: a past-dated boundary read cannot be served by replay → it must
  come from the live projection → the projection must carry the past value → a
  materialized version list (correctable definition); where no past value is read, the
  projection holds only the current scalar, overwritten in place, priors left to offline
  replay (superseding observation). "makes it a correctable definition" replaced by the
  forced chain. Replay is no longer an alternative to materialization for the overwrite
  cell — it is explicitly the offline-only recovery path. The anti-recoverability guard
  is kept ("not what replay can rebuild --- both disciplines' priors are --- but what the
  live projection must materialize"). The §Why Three terms paragraph echo updated: "the
  append discipline exists **to serve a past-dated boundary read from the live
  projection**." FLAG below: the read-path/rebuild-path premise is now load-bearing for
  the entire carve and the empty cell; it is supplied by the reviewers and consistent
  with the types (NonEmpty vs scalar), but the document nowhere else establishes that no
  boundary consumer may issue an as-of replay — subject-matter must confirm this is the
  settled architecture.

- **chris-lattner (the economic-state conclusion "only the unit and (holder,unit) carry
  economic state" stated three times; lines 73-75 add nothing).** Collapsed §The Answer
  66-75 to the two new claims, stating the conclusion once: lead with the result ("No key
  other than the unit or the (holder,unit) pair carries economic state ... given the
  reification above"), define economic state once, give the per-holding reduction, close
  the multi-unit case via the reification, give the identity residue (KYC/permissions/
  audit cursor). Dropped the mid restatement ("No economic fact is about a wallet and no
  unit") and the trailing restatement (old 73-75).

- **jane-street-cto (the closing economic-state sentence nests a parenthetical "both
  excluded --- conditional on that reification ---" inside the conjunction it qualifies,
  forcing three referents).** Resolved by the same collapse: the nested parenthetical is
  gone; the condition is named once ("given the reification above") at the head of the
  single conclusion sentence, read left-to-right.

- **chris-lattner / henri-cartan (the empty fourth cell is proved twice --- boundary test
  then seal --- and the text flags the redundancy).** Kept the boundary test canonical;
  **demoted the seal to a one-clause corroboration** ("The seal corroborates: versioning
  a held quantity \texttt{applyMove} already owns would be a second writer of it,
  barred"). Deleted the long single-writer-per-fact explanation.

- **henri-cartan (the empty cell's universal "no (holder,unit) fact read past-dated"
  rests on the enumeration's unproven completeness; the seal bars only a definition over
  an already-owned fact, not a novel (holder,unit) definition).** Scoped the claim
  honestly: "no (holder,unit) fact **the ledger holds** is one" (over the enumeration,
  not an exhaustive universal). FLAG below: completeness (every economically relevant
  (holder,unit) fact is the ledger's own current-only derived fact) and/or strengthening
  the seal to bar **any** (holder,unit) definition are subject-matter / `States.hs`
  changes; STYLUS marks the gap, does not fill it.

- **jane-street-cto (`psHwm :: Qty` says "carries no zero-sum invariant" and "combining
  operation is not fixed here" --- a contradiction, since `Qty`'s combine is fixed; the
  Price standard is unexplained for psHwm; the reconciling justification is in
  States.hs).** **Ported the States.hs justification** (lines 580-587) and **deleted "its
  combining operation is not fixed here"**: `psHwm` is a `Qty` and rightly --- high-water
  marks add, summing over holders to total peak exposure; what it lacks is a **paired
  writer**, so it carries no zero-sum invariant. This SETTLES the Round-8 "assert neither
  max nor addition" in favour of addition, as the corrected source (the reference STYLUS
  aligns to) dictates. The duplicate "property of how a field is written, not of its
  type" was Landau-cut from this paragraph (stated in §Why It Is Right). The contrast
  with Price (strip group structure) is now principled and visible: Price strips because
  prices do not add; psHwm keeps because high-water marks do.

- **minsky (`from==to` self-move is representable and unrejected: the two legs applied
  sequentially conjure a held-and-flat row for a never-held wallet).** RESOLVED-IN-SOURCE:
  the current `States.hs` `applyMove` already **nets the per-wallet delta** before writing
  (`netDeltas` builds a `Map WalletId Qty` via `insertWith (<>)`; `writeNet` skips
  `mempty`), so a self-move nets to `mempty` and writes no row. The `.tex` listing LAGGED
  it (still showed the sequential `leg to q (leg from (negQty q) ...)` form). Synced the
  `applyMove` listing to `netDeltas`/`writeNet`, rewrote the intro prose (effect is the
  per-wallet net delta; an ordinary move nets $-q$/$+q$, a self-move's legs cancel to
  `mempty`), and updated the `Maybe` paragraph ("a zero-quantity move and a self-move are
  both well-formed ... each nets to `mempty` on every wallet ... held means named in a
  move that nets nonzero on it"). The `.hs` is the corrected reference; never edited.

- **minsky (the no-fourth conclusion rests on the reification, proved only for n=1; state
  it conditional in the headline or establish it generally).** Conditional marking kept
  in-place at the conclusion ("given the reification above"); STYLUS cannot establish the
  general reduction (subject-matter absent from `States.hs`). "In the headline/title"
  declined: truth-conditions belong at the conclusion that asserts them, not in the
  document title. Carried FLAG, returned to subject-matter.

### Layout (Round 10)
Net additions (the live-projection premise ~3 lines; the netting `applyMove` listing +2)
net of cuts (economic-state collapse; seal demotion; psHwm dedup; the rhetorical question
at the test opener removed --- also a hard-constraint fix; `netDeltas` one-lined; the
`applyMove` intro tightened to result-first) still left the 6-line final replay paragraph
on p4. Reclaimed via `\linespread{0.80}` -> `0.78` (the documented page-loss mechanism for
this brim-full document; word-level trims rewrap). Verify: `pdflatex` -> 3 pages, 0 boxes.

### Residue judged resolved-in-source / out of STYLUS remit (returned with reason)
- **minsky self-move --- RESOLVED-IN-SOURCE, not a design defect.** `States.hs` already
  nets per wallet; the `.tex` lagged and is now synced. The reviewer's three options
  (net / reject / declare intended-held) are subsumed by the source's choice (net).
- **henri-cartan enumeration-completeness / seal-strengthening --- FLAG, subject-matter.**
  The empty cell's universal rests on the enumeration of the (holder,unit) facts the
  ledger holds; the seal corroborates only for already-owned facts. Proving completeness,
  or strengthening the seal to bar any (holder,unit) definition, decides modelling/`.hs`
  content. RETURNED: until established, the `.tex` scopes the claim to "facts the ledger
  holds" and stands the empty cell on the boundary test over that enumeration.
- **read-path/rebuild-path premise --- FLAG, load-bearing, confirm settled.** Supplied by
  karpathy + henri-cartan and consistent with the types; now carries the whole terms/
  status carve and the empty cell. RETURNED: confirm as settled architecture that no
  boundary consumer may issue an as-of replay (else the carve collapses, as henri-cartan
  warned).
- **psHwm combine (carried FLAG from Round 8) --- now SETTLED in favour of addition.** The
  corrected `States.hs` states high-water marks add and `Qty` is right; the `.tex` is
  aligned. The earlier "running maximum over time" was the `.tex`'s own framing, never in
  the `.hs`. The Max-newtype option is moot: addition is the intended, correct combine;
  no zero-sum invariant follows not from the operation but from the absence of a paired
  cancelling-leg writer.
- **Multi-instrument reification universal (carried FLAG from Rounds 6-9).** Marked
  conditional at the conclusion in-place. RETURNED unchanged: supply each multi-instrument
  relationship's concrete issuance (issuer, -1/+1 legs), or the conclusion stands
  conditional on the reification, discharged only for the mandate.

## Round 11 (STYLUS) — apply the ROUND10_PIVOT in full: discriminate Terms from Status by AUTHORITY (delete the boundary-read apparatus); one 2x2; fix the HWM overclaim; own the no-fourth reduction; say each conclusion once

Scope: the Round-10 PIVOT (`ROUND10_PIVOT.md`). After ten rounds the correctness lenses
called the document obvious, but five clarity lenses held NOT-YET on one concentrated
issue --- *why Terms is a separate home from Status is not obvious in one pass* --- because
the carve rested on a "past-dated boundary read" test that is out of scope, never exercised
in-file, and self-contradictory (replay can reconstruct a past value). `States.hs` had
already been rewritten to the authority framing (step 6 lines 305-328, step 8 lines 428-442,
the psHwm passage lines 587-599); this pass aligns `States.tex` to it. Three pages, compiles
clean (`pdflatex`, 0 errors, 0 overfull/underfull boxes, 0 undefined refs). Every
`SOLUTION_ESSENCE.md` KEEP retained.

Per pivot item:

- **Pivot 1 (discriminate Terms from Status by AUTHORITY; delete the boundary test).**
  Deleted the entire boundary-read paragraph from §The Answer (the ~13-line run-on with
  the live-projection/synchronous/replay-cannot-serve apparatus), the word "synchronously",
  the "cannot be served by replay" claim, the "materialized version list / live projection
  must materialize" vocabulary, and the benchmark identity/level boundary-entitlement witness
  (Status bullet). Replaced the discriminator with **provenance/authority**, in scope and
  visible in the types: **Terms are externally authored** (exchange/contract/reference-data
  provider owns the truth --- multiplier, expiry, ISIN, fee schedule; the ledger consumes,
  never creates, so a correction is appended as a new version, the prior kept, to preserve
  the authority's history for audit and reconstruction); **Status and positions are
  ledger-authored** (produced by the ledger's own events, so the ledger overwrites status and
  accumulates positions, its event log the whole history). Terms cannot share a home with
  Status because they have different **sources of truth** --- co-mingling is the
  single-source-of-truth violation the framework exists to prevent. Append-only vs overwrite
  is now stated as a **consequence** of authority, not the criterion (answers "disciplines
  attach to fields, not maps"). The change-discipline-incompatibility fact (a single value
  cannot be at once append-only and overwrite-in-place --- KEEP item 4) is RETAINED, now
  grounded in authority rather than being the primitive criterion; not a regression.

- **Pivot 2 (one 2x2 the reader can predict; fourth cell empty for ONE reason).** §The Answer
  now states the placement rule ONCE as two questions: (1) holder-dependent? (per-(holder,unit)
  vs per-unit); (2) externally authored or ledger-authored? Rendered as a compact `tabular`
  2x2 whose cells carry the full content lists (KEEP item 1) --- the table is the argument, no
  per-cell narration. The fourth cell (externally authored x (holder,unit)) is empty for ONE
  structural reason: no external authority issues a fact about a specific holder's specific
  position; a position exists only because the ledger's own events created it. DELETED the
  competing "boundary test", "seal corroborates", and "which key may host a definition"
  arguments (Round-10's three-register empty-cell). Per-position write-once facts (entry NAV,
  benchmark NAV at inception) are ledger-authored write-once fields of the Position row.

- **Pivot 3 (fix the HWM correctness overclaim).** DROPPED "high-water marks add, summing
  over holders to total peak exposure" (false: sum of per-holder HWMs is an upper bound on
  aggregate peak exposure, not equal --- peak of a sum <= sum of peaks). §The Construction
  position paragraph now states only what is true and load-bearing: per-position state
  **composes** (balances add under the `Qty` monoid, rows combine holder by holder, so
  conservation is a single fold over the position map); `psHwm` shares `Qty` but no move
  writes it as cancelling legs, so it carries no zero-sum invariant, and **no aggregate over
  holders is claimed for it**. This SUPERSEDES the Round-10 "settled on addition / total peak
  exposure" --- the "= total peak exposure" gloss was the genuine error; the composition fact
  (rows add) survives, the peak-aggregate gloss is gone. Matches `States.hs` lines 587-599.

- **Pivot 4 (no fourth ECONOMIC home as a stated reduction).** §The Answer holder-axis and the
  §Why Three mandate paragraph now OWN the reduction as the **framework's modeling stance**:
  every economic relationship a wallet has is to some unit it holds (a holding, a mandate, a
  strategy is itself a unit), so every per-wallet economic fact is a (holder,unit) position
  and no fourth wallet-keyed economic home is needed. The mandate is the canonical demonstrated
  instance (manager issues a mandate unit, -1/+1, summing to zero; the client's HWM and entry
  NAV are facts about its position in the mandate unit). What stays wallet-keyed (KYC,
  permissions, audit cursor) is identity, not economic state. DROPPED the dangling "admitted
  unestablished / assumed, not established here" framing (Rounds 8-10) in favour of the
  definitional-choice framing the pivot directs. (FLAG below: the general multi-instrument case
  is adopted as a modeling stance, demonstrated only for the mandate.)

- **Pivot 5 (say each conclusion once, result-first).** "Three homes, two maps" and the
  Terms/Status pairing were stated 3+ times (§2/§3/§4). Now: the count and placement rule are
  stated ONCE at the head of §The Answer ("State lives in three homes, held in two maps"); the
  pairing ("a third home, a third kind of state, not a third map") once at the end of §The
  Answer. §Why Three grounds each home by its one small example without restating the count;
  the §The Construction "three homes, two maps" paragraph's echo ("the third home is not a
  third map") was trimmed to the construction fact (the pair map / co-presence by shape). The
  compressed slogans were expanded into plain declarative clauses: "the multi-unit case is the
  reification's" became the explicit modeling-stance sentence; "three homes are forced, not
  counted" became "exactly three homes carry state", grounded cell-by-cell with the structural
  empty cell. Vestigial axis-2 vocabulary removed: "superseding observation" (§Construction
  status) simplified to "overwritten on each settlement"; "a correctable definition"
  (§Construction terms header) replaced by "Terms are the authority's record, grown only by
  appending."

### Layout (Round 11)
Net effect was a CUT (the dense boundary-test paragraph + the benchmark witness + the
triple restatements removed; a compact 2x2 table added). This relaxed the linespread from the
Round-10 cramped 0.78 to **0.82** (more readable) while holding 3 pages. The 2x2 `tabular`
overflowed by 21pt at p{0.40} columns; fixed with `\footnotesize` + `p{0.39\textwidth}`
columns. Verify: `pdflatex` -> 3 pages, 0 overfull/underfull boxes, 0 undefined refs.

### Enforceability and conformance flags (returned to subject-matter)
- **Authority-of-record discriminator --- FLAG, settled in source, confirm the framing.** The
  carve now turns on "externally authored vs ledger-authored." A settle price, current
  weights, and a benchmark level are externally *sourced* numbers that nonetheless count as
  **ledger-authored records** (the ledger's own event produces and overwrites them; its event
  log is the history), while a multiplier/ISIN/benchmark-identity correction counts as
  **externally authored** (the authority restates, the ledger preserves the version history).
  `States.hs` (step 6) commits to this author-of-RECORD notion; STYLUS renders it but does not
  own the judgment that every externally-sourced status number is correctly ledger-authored-of-
  record (this is the same shape as the Round-5 dirac objection that killed the earlier
  authorship axis --- there resolved by the now-deleted benchmark witness; here resolved by the
  author-of-record framing in source). Subject-matter should confirm the framing holds and does
  not reintroduce a same-author-opposite-cells counterexample.
- **Multi-instrument reification (carried FLAG from Rounds 6-10) --- now framed as a modeling
  stance, not a gap.** Per the pivot, owned as the framework's definitional choice (every
  relationship is a unit), demonstrated for the mandate (n=1). RETURNED unchanged in substance:
  if the no-fourth count must be defended as a theorem for cross-margin / netting sets rather
  than stipulated by the model, supply each one's concrete issuance (issuer, -1/+1 legs);
  else it stands as the modeling stance, demonstrated only for the mandate.
- **psHwm combine (carried from Rounds 8-10) --- the "total peak exposure" gloss is now
  CORRECTED, not merely settled.** Round-10 had ported "high-water marks add, summing to total
  peak exposure" from a then-current `States.hs`; Round-11 (per pivot 3 and the corrected
  `States.hs` lines 587-599) drops the peak-aggregate gloss as a genuine overclaim and keeps
  only the composition fact (rows add under the `Qty` monoid; conservation is one fold). No
  open math question remains: no aggregate over holders is claimed.

## Round 12 (STYLUS) — repair the authority-axis definition so it sorts its own table; cut the §Answer/§Why duplications; seal by withholding the field selectors

Scope: resolve the Round-11 residue. The R11 authority pivot left the axis
*definition* (externally authored = owned by an authority "the ledger consumes but
never writes") contradicting the table, which places exchange-sourced settlement price
and provider-sourced benchmark level under ledger-authored Status. Plus three
§Answer/§Why duplications, the insufficient Haskell seal, and the table's unmodeled
Status facts. Three pages, compiles clean (`pdflatex`, 0 errors, 0 overfull/underfull
boxes, 0 undefined refs). Every `SOLUTION_ESSENCE.md` KEEP retained. `linespread` held
at 0.82 (the R11 net-cut + this round's further §Answer cuts kept slack).

Per residue item:

- **karpathy / henri-cartan (the source-ownership definition contradicts the table; a
  single-pass reader places settlement price and benchmark level in the externally-
  authored Terms column; the criterion separating an exchange-sourced settle price from
  an exchange-sourced multiplier is unstated).** Rewrote the §Answer axis definition
  (was "owned by an outside authority which the ledger consumes but never writes") to the
  **author-of-record** criterion, stated AT the definition so no single-pass reader hits
  the contradiction: "who owns the record's history, not who sources the number." An
  externally authored fact is one the authority owns and restates (ledger preserves
  version by version); a ledger-authored fact the ledger's own events produce and
  overwrite. The settlement-price pre-emption (formerly buried at line 128/199) is now
  AT the definition: "a settlement price, sourced from the exchange, is ledger-authored:
  the record is the ledger's own settlement event ... not the exchange's restated
  definition." This is the additional criterion henri-cartan demanded, stated explicitly
  (the "state the criterion" route, not "replace with identity-vs-current-reckoning" —
  author-of-record is what `States.hs` step 6 commits to). The deleted phrase "consumes
  but never writes" was the root of the contradiction.

- **karpathy (benchmark level / current weights appear only in the table, never argued;
  benchmark level (Status) vs benchmark identity (Terms) split justified only for settle
  price).** EXTENDED, not dropped (KEEP item 1 enumerates current weights + benchmark
  level under shared status; dropping would trigger FORMALIS veto). Added one sentence
  after the table: "One criterion sorts the whole category: a benchmark level the ledger
  records and overwrites is ledger-authored, while the benchmark identity the provider
  restates is the authority's versioned record --- the one externally authored, the other
  not, though both come from that provider." The same-provider-opposite-cells split is
  now justified by the author-of-record criterion, not left to the reader.

- **jane-street-cto (the table lists weights + benchmark level under Status but
  UnitStatus models only Lifecycle; elision flagged for PositionState, never for Status).**
  Same added sentence opens: "Each cell names a category; the listings model a slice of
  it --- for Status, the lifecycle stage carrying the settlement price, with current
  weights and benchmark level elided as the Position row's further fields are." Status
  elision now matches the PositionState treatment, as requested.

- **chris-lattner (the terms authorship argument is made in full in BOTH §Answer 92-101
  and §Why Three; defer it wholly to §Why, keep only placement + the pair/third-home-not-
  third-map consequence).** CUT the §Answer "How a correction is recorded follows from
  authorship ..." paragraph (the overwrite-vs-append argument, the single-source-of-truth
  clause, the distinct-types conclusion). §Answer now keeps only the structural
  consequence + forward ref: "Terms and status share the unit key but cannot be one value
  (§why); they ride together as a pair --- a third home ... not a third map (§right)."
  The argument lives wholly in §Why Three, matching how Position/Status are placed in
  §Answer but argued in §Why.

- **chris-lattner (the empty-fourth-cell reason is argued in full in BOTH §Answer 87-91
  and §Why Three 140-148; cut §Answer to the one-line placement claim).** CUT the §Answer
  fourth-cell derivation to: "The fourth cell --- an externally authored (holder, unit)
  fact --- is empty (§why)." The custodian/prime-broker concretion stays in §Why Three.

- **chris-lattner (§Why Three mandate paragraph 155-158 restates the general framework
  stance it was sent to demonstrate).** CUT the closing restatement ("This is the
  framework's stance in general: every economic relationship ... no fourth ... home is
  needed"). §Why now delivers the mandate instance and stops at "Two mandates are two
  rows; a wallet-keyed value would merge them." The principle is stated once, in §Answer.

- **dirac (authorship is asserted to force the storage shape without the bridging reason;
  "its event log the only history it needs" applies verbatim to terms per §replay, so it
  fails to discriminate).** CUT the non-discriminating phrase "its event log the only
  history it needs" from §Why Three. Re-grounded the split on WHOSE RECORD it is
  (author-of-record, source-faithful): terms are held "as the authority's, not its own ...
  the prior is the authority's record, not the ledger's to discard" (→ version list);
  status is "the ledger's own record ... so the ledger overwrites it, keeping the current
  value, any prior recoverable by replay if wanted" (→ single value). The discriminator
  is now custodianship of the record, not "event log is the only history" (which is true
  of both). dirac's deeper demand — a temporal-validity bridge (prior versions are live
  state for reproducing a past computation) that ENTAILS the shape — is content NOT in
  `States.hs`; FLAGGED below, not authored.

- **dirac (in-scope the version list is always a singleton, so the shape reads
  anticipatory of an out-of-scope future).** The honest scope concession is retained (the
  amendment event is out of scope; every terms value has one version here; the distinction
  exercised is `appendVersion` keeps / `settle` discards). dirac's request to make the
  shape read inevitable in-scope via temporal validity is the same flagged content.

- **jane-street-cto (the seal is insufficient in Haskell: record update `l { ledgerPS =
  bogus }` needs only the exported field LABEL, not the constructor, so conservation-by-
  construction does not follow from "constructor not exported"; it holds only because
  `States.hs` also withholds the field selectors).** FIXED, faithful to `States.hs` header
  (lines 53-60: "The Ledger constructor and its field selectors are deliberately NOT
  exported"). §Construction now: "The constructor and the field selectors `ledgerUnit` and
  `ledgerPS` are not exported, so a Ledger is built only by the writers below and read only
  through the accessors: were a selector exported, record update through it (`l { ledgerPS
  = ... }`) would install a non-conserving map without naming the constructor, bypassing
  the single-writer discipline." Listing comment updated to "constructor + field selectors
  not exported"; §Why It Is Right conservation closes "the sealed constructor and withheld
  field selectors leave no other door."

### Enforceability and conformance flags (returned to subject-matter)
- **dirac's temporal-validity bridge --- FLAG, content not in `States.hs`, not authored.**
  Three critics (karpathy, henri-cartan, dirac) agree the source-ownership definition
  mis-sorts the table; karpathy + henri-cartan are satisfied by STATING the author-of-
  record criterion (done this round, source-faithful to `States.hs` step 6). dirac alone
  requires a stronger bridge: that terms carry *temporal validity* (a past computation
  must be reproducible at the terms then in force, so prior versions are live state),
  which would ENTAIL the version-list shape, rather than authority merely SELECTING the
  append discipline. That reason is NOT in `States.hs` (which grounds the append discipline
  in "preserve the authority's record" / custodianship). Writing it would be sourcing a
  derivation STYLUS does not own; whether the disciplines are grounded in author-of-record
  (current source) or in temporal validity (dirac's proposal) is a CONTENT choice. RETURNED:
  if temporal validity is the intended ground, add it to `States.hs` (e.g. effective-dated
  terms versions consulted as-of for a past computation) and STYLUS will render the
  entailment; until then the tex stands on author-of-record (authority selects the
  discipline), which sorts the table without the boundary-read apparatus deleted in R11.
- **Author-of-record framing (carried FLAG from Round 11) --- now load-bearing AT the
  definition.** The R11 flag asked subject-matter to confirm that every externally-sourced
  status number is correctly ledger-authored-of-record and no same-author-opposite-cells
  counterexample reappears. This round MAKES that framing the explicit axis criterion and
  derives the benchmark identity/level split from it. RETURNED for confirmation that the
  author-of-record criterion is the settled discriminator (it is the recurring oscillation
  point: R4 authorship → R5 killed by the benchmark witness → R5-R10 correction-discipline/
  boundary-read → R11 authority → R12 author-of-record stated at the definition).
- **Multi-instrument reification (carried FLAG, Rounds 6-11) --- unchanged.** Stated once
  in §Answer as the framework's modeling stance, demonstrated for the mandate (n=1); the
  §Why restatement was cut this round (chris-lattner), tightening but not changing the
  flag. RETURNED unchanged: if the no-fourth count must be a theorem for cross-margin /
  netting sets, supply each one's concrete issuance (issuer, -1/+1 legs).

### Layout (Round 12)
Net CUT (three §Answer/§Why duplications removed; the axis definition + table phrase +
selector clause added). `linespread` held at 0.82. Verify: `pdflatex` -> 3 pages, 0
overfull/underfull boxes, 0 undefined refs.

## Round 13 (STYLUS) — kill the triple/duplicate append-vs-overwrite restatements; centralise amendment-out-of-scope in §why; import the n=1 reification conditionality from `States.hs`; repoint two misdirected cross-references

Scope: resolve the Round-12 residue centred on (a) the append-keeps/settle-discards
contrast asserted three times in one §Why-Three paragraph and twice more across sections,
(b) the amendment-out-of-scope caveat re-derived in three sections, (c) the §Answer
concealing that the multi-instrument reification is assumed (not proved) where its own
source `States.hs` marks it conditional on n=1, and (d) two cross-references resolving to
§5 (Why It Is Right) when their substantiation lives in §4 (The Construction). Three
pages, compiles clean (`pdflatex`, 0 errors, 0 overfull/underfull boxes, 0 undefined
refs). Every `SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **chris-lattner (append-keeps/settle-discards asserted thrice in one §Why-Three
  paragraph: narrative 130-133, structural 135-136, explicit tail 140-141).** Cut the
  tail restatement. The structural sentence ("a non-empty version list grown by
  `appendVersion`, a single value replaced by `settle`" --- KEEP item 4, distinct values
  with distinct types, FORMALIS-guarded) STAYS; the narrative ("appended ... and the prior
  kept" / "overwrites it, keeping the current value") STAYS as the *why* (authority owns
  the record). The tail "the discipline its two writers show --- `appendVersion` keeps,
  `settle` discards" became "the distinction is exercised only as the contrast between its
  two writers" --- points to the already-named writers, no re-statement of keeps/discards.
  No KEEP weakened.

- **chris-lattner (amendment-out-of-scope re-derived in three sections: §why 138,
  §Construction 277, §right 384, the latter two citing §why).** Stated ONCE in §why
  (unchanged there). §Construction "Registration and settlement" no longer re-derives it:
  "`appendVersion`, the other terms writer, is driven by no event in this file (§why), so
  `register` and `settle` are the only writers exercised" --- relies on §why, names no
  rationale. §right replay reduced "each terms value from its `Registered` event with one
  version, amendment being out of scope (§why)" to "terms (one version each, §why)" ---
  the one-version fact cited, not the out-of-scope argument re-run.

- **chris-lattner (append-only re-argued in §Construction twice: terms paragraph 211-212
  and Registration paragraph 277-278, both echoing §why).** The terms paragraph's opening
  "Terms grow only by appending a version; the prior version stays" was a verbatim echo of
  its own heading ("grown only by appending") and of §why --- cut; the paragraph now opens
  on its load-bearing job, the type/seal construction (`NonEmpty`, non-exported
  constructor, `register` refuses a duplicate). The Registration paragraph's "Terms grow
  by `appendVersion` instead, never overwriting" --- cut (see amendment item); it now
  describes only what `register`/`settle` do and references.

- **henri-cartan (the .tex presents the reification underpinning "three homes, no fourth"
  as established fact, while its source `States.hs` lines 426-431 / 784-787 marks it proved
  only for n=1 and ASSUMED in general; the .tex concealed the missing general proof).**
  Took route (a): imported the source's conditional qualification (STYLUS cannot supply the
  general proof --- subject-matter). §Answer's universal now reads "is a (holder, unit)
  fact on a reification ... The managed-account mandate of §why demonstrates the reification
  for a single relationship; that a relationship spanning several instruments likewise
  reifies as one unit is assumed, not proved here (§why)." §Why-Three's mandate paragraph
  (which disposed of *multiple mandates* but not *multi-instrument-within-one-relationship*)
  now closes: "This discharges the reification for one mandate; that a relationship spanning
  several instruments is likewise a single unit, and so a single row, is assumed here, not
  proved." The conditionality is now visible at the universal and at the demonstration,
  matching `States.hs`. (Line 98-99 "the fourth cell is empty" left unchanged --- see
  false-positive note.)

- **jane-street-cto / formalis (line 103 ref "not a third map (§right)" resolves to §5,
  which carries only Conservation + Deterministic replay; the pair-not-a-map argument lives
  in §4 "The three homes, two maps", which had no `\label`).** Added
  `\label{sec:construction}` to §The Construction; repointed line 103 to it. Verified via
  `States.aux`: `sec:construction` = §4, `sec:right` = §5.

- **jane-street-cto / formalis (line 217 ref "register ... refuses a unit already present
  (§right)" resolves to §5, which never shows the refusal; it is shown in the `register`
  listing in §4, same section).** Repointed to "(below)" --- a same-section forward
  reference to the `register` listing whose `Map.member u (ledgerUnit l) = Nothing` guard
  is the refusal.

### Layout (Round 13)
Net roughly neutral: the three restatement cuts and two re-derivation cuts offset the
conditionality clauses added at §Answer and §Why-Three. `linespread` held at 0.82.
Verify: `pdflatex` -> 3 pages, 0 overfull/underfull boxes, 0 undefined refs.

### Residue judged false positive / partial (returned with reason)
- **henri-cartan's inclusion of lines 98-99 ("the fourth cell ... is empty") as a site
  concealing the reification gap --- PARTIAL FALSE POSITIVE.** The empty fourth cell is
  the *externally-authored (holder, unit)* cell; its emptiness is argued in §Why-Three
  143-151 by "no authority issues a fact about one holder's position" (positions are the
  ledger's own; external holder-unit figures are reconciliation inputs), which is
  INDEPENDENT of the multi-instrument reification (it concerns external authorship of
  holder-unit facts, not whether every wallet-economic fact reduces to a holder-unit
  fact). So 98-99 needs no conditional marker and was left unchanged. The reification's
  conditionality governs the *key-axis exhaustiveness* ({unit, (holder,unit)} with no
  wider key), which IS now marked at §Answer and the mandate paragraph; the downstream
  counts (line 78 "three cells are occupied", line 151 "exactly three homes carry state")
  inherit it without re-flagging, per the one-statement-one-place discipline the other
  three residue items enforce.
- **The general multi-instrument reduction itself --- STANDING FLAG to subject-matter
  (carried Rounds 6-12, now re-surfaced because `States.hs` re-states the conditionality).**
  STYLUS imports the source's "assumed, not proved" qualification; it does not and cannot
  supply the general proof. If "three homes, no fourth" must be a theorem covering
  cross-margin / netting / cross-currency relationships, the subject-matter agent must
  supply each one's concrete issuance (issuer, -1/+1 legs) discharging the reification, or
  it stands demonstrated only for the single mandate (n=1).

## Round 14 (STYLUS) — make the headline count visibly conditional on the reification at §Answer; split the four-em-dash keystone; reduce the multi-instrument caveat to one full statement; state coherence positively; cut the psHwm duplicate reason at the proof; state replay partiality

Scope: resolve the Round-13 residue centred on (a) the headline result ("fourth cell
empty, exactly three homes") resting on the multi-instrument reification, which the
document proves only for n=1 and concedes "assumed, not proved" twice, so the count
reads absolute while its load-bearing lemma is unproven; (b) that keystone sentence
(§Answer 60-67) nesting four em-dash clauses; (c) the reification caveat stated in full
in two places; (d) the psHwm "no conservation invariant" reason restated at the
conservation proof; (e) "the seal no longer carries coherence" referencing a prior
design the fresh reader never saw; (f) replay partiality unstated. Three pages, compiles
clean (`pdflatex`, 0 errors, 0 overfull/underfull boxes, 0 undefined refs). Every
`SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **karpathy / henri-cartan / dirac (the headline count rests on the multi-instrument
  reification, proved only for n=1; "exactly"/"by construction" overclaim while the
  lemma is conceded unproven).** Took the *restate-the-count-as-conditional* route
  (karpathy/henri-cartan offer it; dirac's route 1 minus the citation, which STYLUS
  cannot supply --- see FLAG). The §Answer holder-axis paragraph now attributes the
  binary holder-axis (no key wider than (holder, unit)) and **so the count below** to
  the reification, explicitly: "the binary holder-axis, and so the count below, rests on
  it." The reification is named once here, demonstrated-for-one / assumed-for-several
  marked as a compressed conditional pointer to §why. STYLUS cannot prove the general
  multi-instrument reification (subject-matter, absent from `States.hs`); the count is
  now honestly conditional rather than absolute, satisfying all three critics without
  authoring the missing proof. The downstream counts (line 78 "three cells occupied";
  the headline "three homes, two maps") inherit the conditionality stated once at the
  axis, per the one-statement-one-place discipline.

- **karpathy secondary (the keystone sentence §Answer 60-67 nests four em-dash clauses,
  fails read-once).** Split. The holder-axis paragraph is now four sentences, each with
  at most one em-dash pair: scope (no em-dash); economic-fact-is-(holder,unit)-or-unit
  by the reification, never a wider key (one pair, defining "economic fact"); the
  conditional pointer (no em-dash); the identity exclusion (one pair). The old
  reification run-on (three em-dash pairs in one sentence) is gone.

- **chris-lattner / henri-cartan / dirac (the reification caveat stated in full twice ---
  §Answer 64-67 pre-narrates the managed-account demonstration + "assumed, not proved",
  §why 160-161 states both again; a not-proved caveat has no proof to defer to, so full
  duplication).** §Answer now carries only the **compressed conditional pointer**
  ("demonstrated for a single relationship and assumed for one spanning several
  instruments (§why)"), not the managed-account demonstration narration. §Why Three's
  mandate paragraph carries the **demonstration** (manager issues the mandate unit, -1/+1,
  two mandates two rows) **and the caveat** ("assumed here, not proved") exactly once.
  The §Answer pointer is load-bearing (it is what makes the count conditional, required by
  the three critics above), so it is not pure duplication of the §why caveat.

- **chris-lattner (psHwm "carries no conservation invariant because no move writes it as
  two cancelling legs" stated at §Construction 241-243 and re-derived at §right 360).**
  The conservation proof (about `psBal`) no longer re-derives the reason. Line 360 reduced
  from "`psHwm`, written by no cancelling-leg writer, carries no such invariant" to a bare
  scope note citing where the fact is established: "`psHwm` carries no such invariant
  (§construction)." The reason lives once, at §Construction.

- **karpathy / jane-street-cto ("The seal no longer carries coherence --- the pair does"
  presupposes a prior design state the fresh reader never saw).** Stated positively, per
  the offered fix: "Coherence is carried by the pair, not the seal; the seal is left to
  keep conservation true by construction." No "no longer"; no backward reference.

- **jane-street-cto (replay partiality unstated; `replay` can return `Nothing` --- duplicate
  `Registered`, `Moved`/`Settled` on an unknown unit --- but the closing paragraph speaks
  only of rebuilding).** Added one sentence to §right replay: "`replay` returns `Just` the
  rebuilt ledger on a well-formed stream and `Nothing` on an ill-formed one --- a repeated
  registration, or a move or settlement on an unregistered unit --- the `foldM` halting at
  the first refusal." The Maybe codomain is now stated, consistent with the per-writer
  `Nothing` semantics already in §Construction.

### Layout (Round 14)
Net roughly neutral: the holder-axis split + the replay partiality sentence offset by the
fourth-cell count cut, the psHwm scope-note shortening, and the compressed §Answer
pointer (the managed-account demonstration narration removed from §Answer). `linespread`
held at 0.82. Verify: `pdflatex` -> 3 pages, 0 overfull/underfull boxes, 0 undefined refs.

### Enforceability and conformance flags (returned to subject-matter)
- **Multi-instrument reification proof --- STANDING FLAG (carried Rounds 6-13), now
  load-bearing AT the count.** The headline count "three homes, two maps" rests on the
  reification (every economic relationship is a unit the wallet holds). It is demonstrated
  for a single mandate (n=1) and assumed for a relationship spanning several instruments.
  STYLUS made the count visibly conditional on it but cannot supply the general proof.
  RETURNED, three routes (any one closes it): (a) supply each multi-instrument relationship's
  concrete issuance (issuer, -1/+1 legs) discharging the reification --- cross-margin,
  netting set, cross-currency offset; (b) cite a named unit-model spec/axiom where "a
  relationship is a unit" is established, and the tex will restate the count as conditional
  on that named source (dirac's route 1; no such citable source is present in `States.hs`
  or `CLAUDE.md`, so STYLUS cannot cite); (c) show an unreified multi-instrument
  relationship still lands in one of the three homes (cannot introduce a per-(holder,
  set-of-units) key). Until one is supplied, the count stands conditional on the reification,
  demonstrated only for n=1.
- **psHwm typed `Qty` (Monoid/group) --- jane-street-cto, FLAG to source/milewski (sharpened
  standing item).** `psHwm` carries `Qty`'s `<>`/`mempty`, so nothing in the type prevents
  folding HWMs the way `netBal` folds `psBal` --- the drift/wrong-sum hazard the spec exists
  to make unrepresentable. The tex prose does not overclaim a type guarantee (it states "no
  aggregate over holders is claimed for it" --- a disclosed usage discipline, not a type
  fact), so the prose is honest as written; but jane-street-cto's fix is a `States.hs`
  change STYLUS cannot author. RETURNED: give HWM (and entry NAV) a value-level newtype with
  no `Semigroup`/`Monoid`, mirroring `Price`, and state why; or justify in source why `Qty`
  is forced. Until settled, the tex stands on the disclosed discipline (no cancelling-leg
  writer => no zero-sum invariant; no aggregate claimed), which suffices for the conservation
  contrast the field is there to draw. This is the same standing decision carried from Rounds
  2-13 (conservation is a property of how a field is written, not its type), now re-raised by
  jane-street-cto as a type-level hazard; the type-level remedy is a source decision.

## Round 15 (STYLUS) — hoist the reification to a stated premise at the head so the count is conditional from the first sentence; reconcile psHwm:Qty with the Price rationale on additivity; cite the authority axis in §why instead of re-deriving it; state the amendment scope boundary once; drop the psHwm comment echo and the duplicate provenance illustration

Scope: resolve the Round-14 residue. Three pages, compiles clean (`pdflatex`, 0 errors,
0 overfull/underfull boxes, 0 undefined refs). Every `SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **karpathy / henri-cartan (the headline count is stated unconditionally --- "Two
  questions place any fact", "three homes" --- while completeness rests on the
  multi-instrument reification the document proves only for n=1; the reader accepts the
  count in §Answer, then learns in §Why it holds on faith --- a backtrack at the point
  the first principle is strictest).** Took the downscope/mark-as-premise route (STYLUS
  cannot prove the general reification --- subject-matter, absent from `States.hs`).
  **Hoisted the reification to a stated premise as the opening sentence of §The Answer**,
  marked demonstrated-for-one / assumed-for-several with its `\S\ref{sec:why}` pointer,
  and made the count explicitly rest on it: "The count below rests on this premise ---
  demonstrated for one relationship in §why, assumed for one spanning several instruments.
  Granted it, state lives in three homes ... two questions place any economic fact." The
  count is now conditional from the first sentence; "any fact" is "any economic fact"
  under "Granted it." The holder-axis paragraph no longer re-narrates the reification: it
  cites the premise ("By the premise, every economic fact ... is a (holder, unit) fact or
  a unit fact"), removing the old in-paragraph re-derivation and the "binary holder-axis,
  and so the count below, rests on it" (now carried by the headline). §Why's mandate
  demonstration + "assumed here, not proved" caveat (the n=1 discharge) is the promised
  fulfilment of the premise, no longer a backtrack. The fourth-cell emptiness (lines
  99-100, 150) is left unmarked --- it is argued independently (no authority issues a fact
  about one holder's position), per the Round-13 false-positive analysis; only the
  key-axis exhaustiveness (the count of three) rests on the reification, and that is now
  conditional at the head.

- **karpathy / jane-street-cto (`psHwm :: Qty` contradicts the Price rationale: Price is
  stripped to a non-group newtype because a level is "never added, never moved between
  wallets", yet the high-water mark --- the same kind of non-transferable level --- is
  typed `Qty`, granting it `<>`/`mempty`/`negQty`; the reconciling rationale exists in
  `States.hs` 579-591 but was dropped from the .tex).** Took the port-the-rationale route
  (jane-street-cto's offered prose fix, in remit). **Ported the source reconciliation into
  the "A position carries more than a balance" paragraph**: "`psHwm` is also a `Qty`, and
  rightly: a high-water mark is a quantity, so adding two is legal, unlike a price (above),
  whose sum is meaningless. What `psHwm` lacks is `psBal`'s paired writer --- no move
  writes it as two cancelling legs --- so it carries no zero-sum invariant ...". The
  discriminator is now **additivity / quantity-hood**, not transferability: a high-water
  mark is a monetary quantity (adding is legal), a price is not (its sum is meaningless).
  To remove the false equivalence at its root, **trimmed the Price line** from "never
  added, never moved between wallets" to "prices are never added" --- additivity is now
  the sole stated criterion, shared between the two passages, so the type choices are
  consistent (Price strips because prices do not add; `psHwm` keeps because high-water
  marks do). The Round-11 honesty (no aggregate over holders claimed) is retained: "adding
  is legal" is the operation's legality, not an aggregate claim. No KEEP weakened; the
  standing `States.hs`/milewski type-level FLAG (give HWM a `Price`-style non-group
  newtype, or justify `Qty` in source) is unchanged --- the prose now carries the source's
  justification for `Qty`, which is the in-remit half.

- **chris-lattner (§Why Three Terms paragraph re-derives the externally-authored vs
  ledger-authored mechanism --- append/keep-prior vs overwrite --- already derived in
  §The Answer 70-73; only the SSOT co-mingling point is non-duplicated).** Collapsed the
  re-derivation to a citation: "Terms are externally authored, status ledger-authored
  (§answer)." Kept the SSOT-violation justification as the reason terms is a distinct home
  ("Co-mingling the authority's record with the ledger's own is the single-source-of-truth
  violation the system exists to prevent, so the two are distinct values: a non-empty
  version list grown by `appendVersion`, a single value replaced by `settle`" --- KEEP
  item 4, distinct values/disciplines, FORMALIS-guarded, retained). The paragraph heading
  was reworded to the SSOT ground ("because the two have different authorities of record").

- **chris-lattner (the amendment/`appendVersion`-out-of-scope caveat stated in full in
  §Why Three and again in §Construction "Registration and settlement").** Stated the scope
  boundary once (the canonical statement stays in §Why Three: "The amendment event that
  grows the list is out of scope here, so within this file every terms value has exactly
  one version ..."). §Construction now cites rather than restates: "`appendVersion`, the
  remaining terms writer, is out of scope (§why), so `register` and `settle` are the only
  writers exercised; neither touches `psBal`." The old "driven by no event in this file"
  re-derivation is gone; the load-bearing consequence (register/settle the only exercised
  writers, neither touching `psBal`) is kept for the conservation argument.

- **chris-lattner (psHwm's "writer out of scope, stays zero here" appears in the prose at
  §Construction and is echoed by the adjacent code comment).** Dropped the echo: the
  listing comment is now `-- high-water mark: not conserved`; the writer-out-of-scope /
  stays-zero fact lives once, in the prose above it. (Line 358 `\S\ref{sec:construction}`
  cite for the no-invariant fact is a citation, not a restatement of the scope note --- left
  unchanged.)

- **chris-lattner (lower-confidence: the "source/provenance does not determine the cell"
  lesson illustrated twice --- the settlement-price example at the axis definition and the
  benchmark level-vs-identity example after the table; revisit after the reification fix,
  the benchmark case may be the single natural home).** Actioned: **cut the settlement-price
  illustration** at the axis definition. Its content (externally sourced yet
  ledger-authored) is subsumed by the benchmark-level half of the post-table example, which
  is strictly stronger (same provider, both cells, and KEEP-required for the benchmark
  identity/level split). The criterion ("who owns the record's history, not who sources the
  number") is stated once at the definition; the benchmark example is now the single worked
  sort. Settlement price remains placed in Status by the table and named in the post-table
  paragraph ("the lifecycle stage carrying the settlement price"); only the redundant
  authority-of-record re-illustration was removed. No KEEP item dropped (the table carries
  the "last settlement price" enumeration).

### Layout (Round 15)
Net CUT (settlement-price illustration ~2.5 lines; §Why Terms authority re-derivation ~3
lines; psHwm comment shortened) against small additions (the psHwm/Price reconciliation
~1.5 lines; the premise hoist is roughly length-neutral with the removed in-paragraph
reification). `linespread` held at 0.82. Verify: `pdflatex` -> 3 pages, 0 overfull/
underfull boxes, 0 undefined refs.

### Residue judged false positive / partial (returned with reason)
- **karpathy's inclusion of lines 99-100 and 150 ("the fourth cell ... is empty", "empty
  by construction") among the unconditional over-claims --- PARTIAL FALSE POSITIVE.** The
  empty fourth cell is the externally-authored (holder, unit) cell; its emptiness is argued
  independently of the multi-instrument reification (no authority issues a fact about one
  holder's position; external holder-unit figures are reconciliation inputs --- §Why Three
  143-150). Only the count of three (key-axis exhaustiveness, "no wider key") rests on the
  reification, and that is now conditional at the head of §The Answer. The fourth-cell
  emptiness needs no conditional marker; left unchanged. Same finding as the Round-13
  false-positive note.

### Enforceability and conformance flags (carried, returned to subject-matter)
- **Multi-instrument reification proof --- STANDING FLAG (carried Rounds 6-14), now stated
  as a named premise at the head of §The Answer.** The count "three homes, two maps" rests
  on the premise that every economic relationship a wallet has is itself a unit it holds;
  demonstrated for one mandate (n=1), assumed for a relationship spanning several
  instruments. STYLUS made the count conditional on it from the first sentence but cannot
  supply the general proof. RETURNED, three routes (any one closes it): (a) supply each
  multi-instrument relationship's concrete issuance (issuer, -1/+1 legs) --- cross-margin,
  netting set, cross-currency offset; (b) cite a named unit-model spec/axiom establishing
  "a relationship is a unit" (none present in `States.hs`/`CLAUDE.md`, so STYLUS cannot
  cite); (c) show an unreified multi-instrument relationship still lands in one of the three
  homes. Until then the count stands conditional on the premise, demonstrated only for n=1.
- **psHwm typed `Qty` (Monoid/group) --- jane-street-cto, STANDING FLAG to source/milewski.**
  The prose now carries the source's in-remit justification for `Qty` (a high-water mark is
  a quantity; adding is legal; a separate non-group newtype would only decorate) and is
  honest (no aggregate over holders is claimed --- a disclosed discipline, not a type fact).
  The type-level remedy jane-street-cto requests (give HWM/entry-NAV a `Price`-style newtype
  with no `Semigroup`/`Monoid`, or justify in source why `Qty` is forced) remains a
  `States.hs`/milewski change deciding the field's algebra; STYLUS aligns the prose, does not
  author Haskell. Unchanged in substance from Rounds 2-14.

## Round 16 (STYLUS) — stop the .tex asserting the contested psHwm additivity rationale; defer the field's type/algebra to its out-of-scope writer (reversing the Round-15 port)

Scope: resolve the single Round-15 residue item (jane-street-cto) — the high-water
mark's type is asserted, not derived, and contradicts the document's own Price
rationale. Three pages, compiles clean (`pdflatex`, 0 errors, 0 overfull/underfull
boxes, 0 undefined refs). Every `SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **jane-street-cto (§Construction "A position carries more than a balance", lines
  227-228: "a high-water mark is a quantity, so adding two is legal, unlike a price"
  — the type is asserted, not derived, and fights the Price rationale; the doc strips
  Price to a non-group newtype because prices are never added (190-193), then types
  psHwm as a full group `Qty` and justifies it by "adding two is legal" while never
  saying what the mark is a quantity OF; its only grounding (valuation-written, beside
  entry NAV) is value/NAV-level, i.e. price-like, whose sum the doc itself calls
  meaningless; the fallback "no aggregate over holders claimed" is a discipline the doc
  elsewhere refuses in favour of types; `netBal` could `foldMap psHwm`, typecheck, and
  produce nonsense.).** Took the reviewer's **route 3** (defer the type/algebra to the
  out-of-scope valuation writer instead of asserting a rationale that fights the
  document) — the only one of the three offered fixes in STYLUS remit. Routes 1 (state
  the referent and show addition is meaningful) and 2 (give psHwm a non-group
  `Price`-style newtype) are subject-matter / `States.hs` decisions STYLUS cannot
  author; see FLAG. The contested sentence "psHwm is also a `Qty`, and rightly: a
  high-water mark is a quantity, so adding two is legal, unlike a price (above), whose
  sum is meaningless" is **removed**. Replaced with: psHwm is typed `Qty`, matching the
  source, but the file **leans on none of `Qty`'s group structure for it** — what a
  high-water mark measures, and so whether and how two compose, is fixed by its writer
  (a valuation event out of scope here), not by this file. The "unlike a price"
  cross-reference is gone, so the contradiction with the Price rationale is gone: the
  prose no longer claims either that HWMs add meaningfully or that their sum is
  meaningless; it **defers**. The conservation contrast is preserved unchanged (no
  paired cancelling-leg writer ⇒ no zero-sum invariant) and the disclosure tightened to
  "no fold aggregates it over holders" (a plain fact about this file, consistent with
  the doc's honest treatment of conservation itself as a writer invariant, not a type
  guarantee). This **reverses the Round-15 port** of the source rationale, which the
  same reviewer requested in Round 15 and now rejects; reversing it on the same
  reviewer's current instruction is not a FORMALIS regression, and no KEEP item depends
  on the additivity rationale (KEEP 2/4 require only that HWM is a per-position fact and
  that the psBal-conserves / psHwm-does-not contrast is visible — both retained).
  Cross-references untouched (none asserted the rationale): §Answer table cell (83) and
  the managed-account paragraph (142-146) only name the mark; §Answer 136 and §right 350
  ("a high-water mark written by the valuation event"; "psHwm carries no such invariant
  (§construction)") are consistent with route 3. The listing `psHwm :: Qty` with comment
  "high-water mark: not conserved" reproduces the source declaration and is left as is;
  the listing commits to no summing, and the prose now relies on none.

### Layout (Round 16)
Net roughly neutral (the deferral sentence is about the length of the removed
additivity sentence). `linespread` held at 0.82. Verify: `pdflatex` -> 3 pages, 0
overfull/underfull boxes, 0 undefined refs.

### Enforceability and conformance flags (returned to subject-matter)
- **psHwm typed `Qty` (Monoid/group) — jane-street-cto, STANDING FLAG to
  source/milewski (carried Rounds 2-15), now the .tex no longer carries a prose
  rationale for the `Qty` choice.** The type-level hazard the reviewer names is real and
  unfixed in source: nothing in `psHwm :: Qty` prevents `foldMap psHwm` from
  typechecking and yielding a meaningless cross-holder sum — the kind of illegal state
  the spec exists to make unrepresentable. STYLUS removed the prose claim that `Qty` is
  right ("adding two is legal") and now defers the field's algebra to its out-of-scope
  writer, so the .tex is honest as written, but the deferral is a prose move, not a
  fix. RETURNED, two routes (either closes it): (a) give the high-water mark (and entry
  NAV) a value-level newtype with no `Semigroup`/`Monoid`, mirroring `Price`, so a
  cross-holder fold of it does not typecheck, and state the referent (what the mark
  measures) that makes its algebra well-defined; or (b) state in source what the
  high-water mark is a quantity OF and show that addition over holders is meaningful,
  justifying `Qty`. Until one is supplied, the .tex stands on the deferral: the field's
  type and combining operation are the valuation writer's to fix, out of scope here;
  in this file psHwm carries only the role of a non-conserved field beside the conserved
  balance and stays zero.
- **Multi-instrument reification proof — STANDING FLAG (carried Rounds 6-15),
  untouched this round.** The count "three homes, two maps" remains conditional on the
  premise (every economic relationship is a unit the wallet holds), stated at the head
  of §The Answer, demonstrated for one mandate (n=1), assumed for a relationship
  spanning several instruments. No change this round; unchanged routes to close it (see
  Round 15).

## Round 17 (STYLUS) — collapse the over-defended psHwm paragraph to a result-first, single-statement form; port the concrete anchor from `States.hs`; trim the §4 conservation-mechanism leak; pin "home"; drop the §5 callback

Scope: resolve the Round-16 residue, concentrated almost entirely on the psHwm
exposition (§The Construction, "A position carries more than a balance", lines
221-234) plus a §5 callback, a §4 conservation-mechanism leak, and a vocabulary pin.
Three pages, compiles clean (`pdflatex`, exit 0, 3 pages, 0 overfull/underfull
boxes, 0 undefined refs). Every `SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **karpathy / jane-street-cto (psHwm buries the lede, reverses itself, restates its
  conclusion; the concrete anchor was dropped from the .tex while the justification
  arrives mid-paragraph).** Rewrote the paragraph result-first. (1) The concrete
  anchor is **ported back from `States.hs` 373-376**: "a per-(holder, unit) peak that
  only ratchets upward and is retained for tax reporting after the position closes" ---
  this says what a high-water mark IS and why it cannot conserve (a ratcheting,
  retained peak has no offsetting counterparty leg), so non-conservation is no longer
  taken on faith. (2) The role leads: "psHwm witnesses that the Position home can carry
  such a non-conserved fact." (3) The R16 reversal is gone --- removed "typed Qty ...
  but the file leans on none of Qty's group structure for it"; the Qty typing is now
  stated once and flatly: "typed Qty to match its source." No "matching the source"
  vagueness, no mid-stream retraction.

- **chris-lattner (psHwm defended ~6 times; "not conserved" ~3x, "writer out of scope"
  ~3x, "stays zero" 2x, plus a 7th defense at line 351).** Collapsed to chris-lattner's
  one-sentence target: typed `Qty` to match its source, written by an out-of-scope
  valuation event, non-conserved (one mechanism: no move writes it as a cancelling leg,
  so no zero-sum invariant), never folded over holders, zero throughout this file. Each
  fact now stated once. The listing keeps `psHwm` (it shows the Position home holds a
  non-conserved per-(holder, unit) fact --- KEEP 2/4). **Deleted the §5 callback** (old
  line 351, "`psHwm` carries no such invariant (§construction)") --- the 7th defense;
  §5 conservation now stands on `psBal` alone, the psHwm contrast living once in §4.

- **chris-lattner (lower-confidence: §4 leaks the conservation proof --- cancelling
  legs, single fold over the position map --- before the move writer and the seal are
  shown in §5).** Trimmed §4 to the claim: "Its primary field, the held quantity psBal,
  conserves (§right)." The mechanism (two cancelling legs, foldMap over the position
  map) is now only in §5, where `applyMove`, the seal, and `netBal` prove it. No KEEP
  loss --- §5 carries the full forcing of conservation (KEEP 5).

- **jane-street-cto (non-blocking: "home" / "cell" / "kind of state" / "map" used
  interchangeably without one pinned definition).** Pinned once at the 2x2: "Each
  occupied cell is a home: one kind of state." The later "a third home, a third kind of
  state, not a third map" then restated the pin, so it was trimmed (Landau) to "a third
  home, not a third map" --- the load-bearing home-vs-map contrast kept, the redundant
  "kind of state" dropped now that the pin establishes the synonymy.

### Layout (Round 17)
Net CUT: the psHwm paragraph dropped from ~13 lines to ~8; the §4 mechanism and the §5
callback were removed; against this, the anchor (~1 line) and the home pin (~1 line)
were added. `linespread` held at 0.82. Verify: `pdflatex` -> exit 0, 3 pages, 0
overfull/underfull boxes, 0 undefined refs.

### Enforceability and conformance flags (returned to subject-matter)
- **minsky / milewski --- `States.tex` / `States.hs` DIVERGENCE on whether the file
  commits to the high-water mark's composition: RETURNED to milewski (source change),
  NOT resolved in the .tex.** After R16 the .tex defers and the .hs comment (579-593)
  still COMMITS to additivity ("a high-water mark is a quantity, and it combines with
  the same monoid ... adding high-water marks is legal ... a separate newtype would
  only decorate, and we do not add it"). The R17 .tex now aligns to the **coherent**
  half of `States.hs`: the anchor at 373-376 ("ratchets up ... kept for tax ... even
  after the position closes") and the no-paired-writer / never-folded disclosure at
  584-587. It does NOT carry the additivity rationale at 579-583/588-593 --- because
  re-porting it (minsky's second option) re-creates the milewski/jane-street-cto
  incoherence with the Price rationale (Price is stripped of the group precisely
  because prices are never added; granting the group to a ratcheting peak fights that)
  that R16 removed, and milewski reasserts that incoherence THIS round. The divergence
  is therefore a two-artifact contradiction whose only non-regressing fix lives in the
  .hs comment, which is milewski's. STYLUS cannot close it by editing the .tex alone
  without regressing, and (per established practice Rounds 8-16, and the task's "do not
  write Haskell") does not edit `States.hs`. RETURNED, minsky's lowest-risk route:
  bring `States.hs` 579-593 into line with the deferral --- withdraw the additivity
  rationale (it touches no declaration or property) and reconcile it with the ratchet
  description at 374 (the two .hs comments are themselves internally inconsistent:
  ratchet = max at 374 vs add = + at 581). The .tex side is now coherent and defers.
- **psHwm typed `Qty` (Monoid/group) --- jane-street-cto / milewski type-strengthening,
  STANDING FLAG to source/milewski (carried Rounds 2-16), unchanged.** Nothing in
  `psHwm :: Qty` prevents `foldMap psHwm` from typechecking to a meaningless
  cross-holder sum. minsky explicitly separates this from the divergence residue and
  confirms it remains a should-strengthen returned to source. STYLUS discloses honestly
  ("never folded over holders") but cannot make the fold type-impossible. RETURNED, two
  routes (either closes it): (a) give the high-water mark (and entry NAV) a value-level
  newtype with no `Semigroup`/`Monoid`, mirroring `Price`, so a cross-holder fold does
  not typecheck, and state what the mark measures; or (b) state in source what the mark
  is a quantity OF and show addition over holders is meaningful, justifying `Qty`.
  Until one is supplied, the .tex stands on the description (a retained per-position
  peak) and the disclosure (no fold in this file).
- **Multi-instrument reification proof --- STANDING FLAG (carried Rounds 6-16),
  untouched this round.** The count "three homes, two maps" remains conditional on the
  premise stated at the head of §The Answer, demonstrated for one mandate (n=1),
  assumed for a relationship spanning several instruments. Unchanged routes to close it
  (see Round 15).

## Round 18 (STYLUS) — cut the two holder-in-key / base-case re-derivations; restore the .hs psHwm reconciliation so `psHwm:Qty` no longer contradicts the Price rule; make the multi-instrument bound concrete in one pass

Scope: resolve the Round-17 residue. Three pages, compiles clean (`pdflatex`, exit 0,
3 pages, 0 overfull/underfull boxes, 0 undefined refs), `\linespread{0.82}` held (the
two duplication cuts offset the additions). Every `SOLUTION_ESSENCE.md` KEEP retained.

Per residue item:

- **chris-lattner (holder-in-key derived twice: §why ¶1 lines 110-114 proves it in full;
  §Construction lines 173-175 re-ran the two-holders→two-balances→holder-in-key
  derivation).** Construction now declares the keys and CITES §why for the why:
  "Two keys name it; the holder is in the key (\S\ref{sec:why})." The re-derivation
  ("Two holders of one unit are two keys, so two balances") is cut. §why is §3,
  §Construction §4 — a backward reference, deductive order preserved.
- **chris-lattner (conservation base case stated twice: §Construction lines 250-251
  "emptyLedger has both maps empty, so its holding sum is zero --- the base case for
  conservation"; §right lines 343-344 "From emptyLedger, whose sum is zero, every event
  preserves it").** Construction now STOPS at "emptyLedger has both maps empty"; the
  base-case framing lives only in §right, the conservation proof's home. Construction
  states the fact (both maps empty); §right draws the base-case consequence (sum zero).
- **jane-street-cto (psHwm:Qty contradicts the Price rule, lines 221-237 vs 191-193: the
  text says psHwm is never summed/folded, yet types it Qty — the summable group — while
  the Price rule one paragraph earlier says a never-summed value must be a newtype "with
  neither identity nor inverse"; States.hs 579-591 resolves it with "leans on none of
  Qty's group structure," which the R17 .tex had DROPPED).** RESTORED the .hs
  reconciliation, aligning the .tex to the coherent half of States.hs 579-593: "typed
  Qty to match its source, yet the file leans on none of Qty's group structure for it;
  what the mark measures, and whether two of them compose, is fixed by its writer --- a
  valuation event out of scope here --- not decided in this file, which makes no
  aggregate claim over holders for it." The contradiction with the Price rule is now
  resolved EXPLICITLY by a contrast sentence: "Price (above) strips the group because a
  price is settled never to sum; psHwm keeps its source type because its operation is
  not settled here." This is NOT the R15/R16 additivity port (which asserted HWMs add
  and fought Price) — it asserts NO operation, exactly the .hs position, so it does not
  reintroduce the incoherence R16 removed. SUPERSEDES the R17 flat "typed Qty to match
  its source" (too bare — left the contradiction unreconciled, jane-street's point).
- **jane-street-cto (psHwm meaning: the text never says what the peak is OF; "retained
  for tax reporting" reads as peak of value while type Qty says peak of quantity).**
  Dropped "for tax reporting" (the value-implying phrase) and stated plainly that what
  the mark MEASURES is fixed by its out-of-scope writer, not decided in this file — the
  honest answer, since States.hs (580-583) also leaves the unit out of scope. STYLUS
  cannot name the unit (subject-matter, absent from States.hs); the type-level remedy
  (a non-summable newtype, or pinning the unit) is a States.hs/milewski decision —
  FLAGGED below (standing FLAG 2). The .tex no longer implies a unit it has not earned.
- **karpathy / henri-cartan (the "no fourth"/completeness half rests on the premise that
  every economic relationship reifies as a single unit, proved only for the single
  mandate; a multi-instrument relationship carrying a fact attached to several units
  would force a (holder, set-of-units) home, breaking the count and the two-map
  structure; a first-time reader cannot see in one pass why the headline is bounded).**
  STYLUS cannot prove the general reduction (subject-matter, absent from States.hs;
  FORMALIS vetoes weakening "no fourth"), so took the bound-the-scope route both
  reviewers offer, MADE CONCRETE at the mandate discharge (§why): "...is likewise a
  single unit --- a single (holder, unit) row, not a (holder, several-units) home that
  would be a fourth home and a third map --- is assumed here, not proved." This names
  henri-cartan's exact failure mode, makes the conditionality's truth-condition visible
  in one pass, and does not weaken "no fourth" (states precisely the condition under
  which it holds). The premise is already stated conditionally up front (§answer 55-59,
  "Granted it"). The unproven premise remains a genuine correctness gap (CLAUDE.md
  principle 1) — FLAGGED, not filled.

### Residue judged false positive / standing FLAG returned to subject-matter
- **karpathy line 96-97 (empty fourth cell) bundled under the reification — PARTIAL
  FALSE POSITIVE (established Round-13/14 ruling).** The empty fourth cell
  (externally-authored × (holder,unit)) is INDEPENDENT of the multi-instrument
  reification: it turns on "no authority issues a fact about one holder's position"
  (§why 133-140), not on whether relationships reduce to single units. Only the
  "no wider key" completeness (key-axis exhaustiveness) is reification-dependent; the
  fourth cell's emptiness is not, and is correctly left unmarked.
- **henri-cartan secondary (§answer 63-67): "nothing wallet-only enters
  conservation/valuation/P&L" is the wallet-only face of the reification premise, not
  independently established.** Same STANDING FLAG as the multi-instrument reification —
  STYLUS cannot prove the universal; returned to subject-matter. No separate .tex fix
  (one-place: the premise is the reification, flagged once).
- **Multi-instrument reification proof — STANDING FLAG (carried Rounds 6-17).** The
  count "three homes, two maps / no fourth" remains conditional on the premise.
  Returned to subject-matter: prove the reduction, or supply concrete issuance
  (issuer, −1/+1 legs) for cross-margin / netting-set relationships; else the claim
  stands demonstrated only for the mandate.
- **psHwm type-strengthening — STANDING FLAG 2 (carried Rounds 2-17).** The .tex now
  reconciles psHwm:Qty with the Price rule in PROSE (leans on none of Qty's structure;
  operation out of scope; no aggregate claim), but the type still permits
  `foldMap psHwm`. The type-level remedy (a newtype with no Semigroup/Monoid mirroring
  Price, or pinning the unit and showing cross-holder addition is meaningful) is a
  States.hs/milewski decision STYLUS cannot author.
- **States.hs 579-593 / .tex divergence (R17 minsky/milewski) — now NARROWED.** The R18
  .tex restores "leans on none of Qty's group structure" (States.hs 580), so the .tex
  no longer drops that .hs clause. The .hs's internal inconsistency persists (the
  additivity rationale at 579-583/588-593 vs the no-aggregate-claim stance at 584-591,
  and the ratchet=max at 374 vs add=+ at 581) — still milewski's to reconcile in the
  .hs; STYLUS does not edit States.hs.

## Round 19 (STYLUS) — bound the count's scope instead of presenting the reification as a leap of faith; compress the psHwm paragraph to the field it earns, footnoting the Price contrast; fix the misreadable psBal comment

Scope: resolve the Round-18 residue centred on (a) the three-home count resting on a
reification the document ASSUMES rather than proves for multi-instrument relationships,
read by a single-pass reader as a load-bearing leap of faith, and (b) the ~13-line
psHwm paragraph defending an always-mempty, never-read, never-folded field. Three
pages, compiles clean (`pdflatex`, 0 errors, 0 overfull/underfull boxes, 0 undefined
refs). Every `SOLUTION_ESSENCE.md` KEEP retained. `\linespread{0.82}` held (net cut).
Resolved refs unchanged (answer=2, why=3, construction=4, right=5).

Per residue item:

- **karpathy / henri-cartan (the count "exactly three homes / two maps" depends on the
  reification premise holding for multi-instrument relationships, ASSUMED not proved;
  the single-pass reader is told to grant a load-bearing premise — a leap of faith).**
  Took henri-cartan's offered route: **BOUND THE SCOPE** to relationships that reify as
  a single (holder, unit) unit, and **state the closure condition excluding the rest**,
  rather than asserting the answer unconditionally then retracting with "assumed, not
  proved." §The Answer opener reworded from "Every economic relationship ... is itself a
  unit ... The count below rests on this premise --- demonstrated for one ... assumed
  for one spanning several instruments. Granted it, state lives in three homes ..." to
  result-first + scope-bound: "Every economic relationship a wallet has **that reifies
  as a single unit it holds** --- a holding, a mandate, a strategy --- has its state in
  three homes, held in two maps. The reification is shown for one relationship in §why;
  **a relationship spanning several instruments that does not reduce to a single (holder,
  unit) row lies outside this scope** (§why). Within it, two questions place any economic
  fact ...". §Why-Three mandate closing reworded from "... is likewise a single unit ...
  is assumed here, not proved" to the explicit closure: "A relationship spanning several
  instruments that does not likewise reduce to a single (holder, unit) row **lies outside
  the scope of §answer**: its fact would be a (holder, several-units) fact **occupying a
  fourth home and a third map, which the count excludes**." This (1) removes the "leap of
  faith" — no premise is granted; the domain is bounded up front; (2) makes the in-scope
  count **unconditional within its stated scope** (a precisification, NOT a weakening —
  FORMALIS: "no fourth" is now stated with its exact domain, stronger in-scope than the
  prior "assumed, might be false"); (3) names what the excluded case would be (the fourth
  home + third map, henri-cartan's failure mode), kept visible. CONSISTENT with the .hs
  conditionality (States.hs 426-431, 784-787 frame it "conditional on that reification" /
  "holds given that ..."); bounded-scope and conditional-on-premise are logically
  equivalent — only the register changed from assumption-then-retraction to declarative
  scope. Citation repointed: §answer holder-axis "By the premise" → "By the
  reification" (the premise word is gone; "the reification" is now the named antecedent).
- **karpathy / chris-lattner / jane-street-cto (the psHwm paragraph: ~13 dense lines
  defending an always-mempty, never-written-in-scope, never-read, never-folded field;
  the reader greps for a writer, finds none, must reconstruct from a buried defensive
  paragraph; the Price/Qty group-structure contrast is off-topic for the placement
  answer and restates the Price rule already at 192-194).** Compressed to result-first
  (~6 body lines, was ~13). Body now carries ONLY the claim that earns the field: psBal
  primary, conserves (§right); psHwm witnesses the Position home can carry a
  non-conserved fact; **its writer is an out-of-scope valuation event, so it is mempty
  throughout this file**; no move writes it as a cancelling leg, so no zero-sum
  invariant. The **Price/Qty meta-argument is DEMOTED TO A FOOTNOTE** (karpathy's exact
  request): "psHwm is typed Qty to match its source, not a newtype like Price (above):
  Price strips the group because a price is settled never to sum, while psHwm's operation
  is not settled here. What it measures and whether two compose is its out-of-scope
  writer's to fix, so the file claims no aggregate over holders for it." This satisfies
  all three reviewers (karpathy: footnoted; chris-lattner: Price-contrast sentences gone
  from the body; jane-street-cto: contrast reduced to a footnote) WITHOUT regressing R18
  (the bare-"typed Qty"-contradicts-Price defect): the reconciliation is preserved, only
  relocated out of the main flow — the Landau move (demote scaffolding once it has done
  its work; the contrast answers a precise reader's objection, belongs in a footnote).
  Dropped the R18 "ratchets up and is retained after the position closes" detail
  (chris-lattner: the home needs the field as a non-conserved witness, not the meditation
  on its algebra; "high-water mark" the name carries the ratcheting-peak meaning; the
  structural "no cancelling-leg writer → no zero-sum invariant" is the load-bearing
  non-conservation reason, stronger than the ratchet anchor). Ported the States.hs
  384-388 framing ("its role is purely to show a non-conserved field riding alongside the
  conserved balance") as the body's lead (jane-street-cto).
- **jane-street-cto (flag psHwm at the LISTING as a stub written by the out-of-scope
  valuation event, the way appendVersion's out-of-scope status is flagged).** Listing
  comment changed from `-- high-water mark: not conserved` to `-- high-water mark: not
  conserved; out-of-scope writer, mempty here` — the grep-for-a-writer reader is answered
  AT the field, no backtracking to the prose.
- **jane-street-cto minor (psBal inline comment "sums to zero" reads as "this value is
  zero"; the invariant is the SUM over holders is zero, an individual psBal is generally
  nonzero).** Comment changed from `-- held quantity: primary, conserved, sums to zero`
  to `-- held quantity: primary, conserved (sum over holders, sec.5)` — names the sum is
  over holders and points to §5 (Conservation/netBal), where the invariant lives, so no
  wrong mental model forms at the field.

### Residue judged false positive / standing FLAG returned to subject-matter
- **Multi-instrument reification proof — STANDING FLAG (carried Rounds 6-18).** Round 19
  reframes the gap from "assumed, not proved" to "bounded scope + closure condition," but
  STYLUS still cannot PROVE that every in-scope multi-instrument relationship reifies as
  a single zero-sum issued unit (exhibiting issuer + cancelling legs, as done for the
  mandate). If the count must hold as a theorem for cross-margin / netting-set
  relationships rather than as a bounded modeling scope, supply each one's concrete
  issuance; else the answer stands bounded to relationships that reify as a single
  (holder, unit) row, demonstrated for the mandate. Subject-matter/.hs decision.
- **psHwm type-strengthening — STANDING FLAG 2 (carried Rounds 2-18).** The footnote
  reconciles psHwm:Qty with the Price rule in PROSE; the type still permits `foldMap
  psHwm`. The type-level remedy (a newtype with no Semigroup/Monoid, or pinning the unit
  and showing cross-holder addition is meaningful) is a States.hs/milewski decision STYLUS
  cannot author. Unchanged.
- **States.hs internal psHwm inconsistency (R17 minsky/milewski) — unchanged, milewski's.**
  The .hs additivity rationale (579-583/588-593) vs no-aggregate stance (584-591), and
  ratchet=max (374) vs add=+ (581), persist in the .hs. The R19 .tex aligns to the
  COHERENT half (384-388 "role is to show a non-conserved field" + no-aggregate); it
  asserts NO operation on psHwm, so it does not import either inconsistent .hs rationale.
  STYLUS does not edit States.hs.

## Round 20 (STYLUS) — crown the single-source-of-truth rule before the two questions; scope §answer by forward-reference only; collapse the psHwm footnote to one clause

Scope: resolve the Round-19 residue centred on (a) the multi-instrument scoping caveat
stated near-verbatim in both §answer and §why, (b) a six-line psHwm footnote arguing the
type theory of a dormant out-of-scope field, and (c) the 2x2 presented as the occupancy
of two posited questions with no governing rule named. Three pages, compiles clean
(`pdflatex`, exit 0, 3 pages, 0 overfull/underfull boxes, 0 undefined refs). Every
`SOLUTION_ESSENCE.md` KEEP retained. `\linespread{0.82}` held (net neutral: the rule
paragraph + intro clause offset by the deleted footnote and the deleted §answer closure
restatement). Resolved refs unchanged (answer=2, why=3, construction=4, right=5).

Per residue item:

- **chris-lattner (the multi-instrument scoping caveat is stated near-verbatim in §answer
  56-59 AND §why 149-152; §why earns it (adds the consequence: fourth home, third map,
  excluded by the count), §answer's copy is a bare restatement sitting beside its own
  forward-reference to §why).** §answer now scopes **by forward-reference only**. The
  closure restatement ("a relationship spanning several instruments that does not reduce
  to a single (holder, unit) row lies outside this scope (§why)") is DELETED from §answer;
  the opening paragraph keeps the scope-bounding headline qualifier ("that reifies as a
  single unit it holds" --- the FORMALIS-safe precisification that keeps the in-scope count
  unconditional) and points to §why for the rest: "The reification, and the scope it
  bounds, are shown in §why." §why 149-152 retains the SINGLE full statement with its
  consequence (the (holder, several-units) fact occupying a fourth home and a third map,
  which the count excludes). Do NOT re-add the closure condition to §answer --- it lives
  once, in §why, where it earns its place.

- **dirac (the three-home structure is presented as the occupancy of a 2x2 spanned by two
  POSITED questions (key, authority), but the single rule that generates both is never
  named; that rule is the project telos --- single source of truth, CLAUDE.md line 6 ---
  and the two questions are its two FAILURE MODES (wrong key = collapse / per-holder
  duplication-drift; wrong authority = co-mingling-drift); §why already gives all three
  home-reasons in collapse/drift/co-mingle vocabulary (116/121/127) but §answer crowns no
  principle. Two consequences: (1) the authority axis serves SSOT, a goal named nowhere in
  the intro or §answer --- on a top-down read the second axis looks chosen, not forced;
  (2) exhaustiveness is shown only by defusing conservation as a competitor, not stated
  from the rule).** Fixed by **promotion + result-first ordering** (dirac: "Material is
  entirely present in §why; not new content").
  - **§answer now NAMES THE RULE before the two questions** (new second paragraph): "One
    rule governs every placement: each economic fact has exactly one home and one writer
    --- single source of truth, so internal reconciliation failure cannot arise. A fact
    fails the rule in only two ways: keyed wrong, one home collapses two facts or one fact
    duplicates across homes that drift; authored wrong, two authorities keep one fact and
    their records drift apart. Each of the two questions forestalls one failure, and
    because there are only these two, there is no third question: whether the fact depends
    on the holder, and who authors it. §why works each failure on a concrete unit." This
    (a) crowns the rule (grounded in CLAUDE.md Purpose line 6, the project's own telos);
    (b) states the two questions AS the rule's two failure modes (wrong key /
    wrong authority); (c) states **exhaustiveness FROM the rule** ("only these two, no
    third question") --- no longer inferred by defusing conservation; (d) maps each failure
    to §why's instances (collapse 116 / duplication-drift 121 / co-mingle-drift 127) via
    the forward-ref, result-first (claim in §answer, proof in §why).
  - **SSOT added to the intro goal list** (§1): "The placement makes one source of truth,
    conservation, and deterministic replay attainable. Each economic fact then has exactly
    one home and one writer, so internal reconciliation failure cannot arise; the sealed
    single-writer discipline, and the purity and totality of replay, make conservation and
    deterministic replay hold by construction." SSOT now appears beside conservation from
    the first page; the conservation/replay forcing (writers + purity) is preserved
    verbatim in force. §why 127 ("the single-source-of-truth violation the system exists to
    prevent") is now a clean back-reference INSTANCING the crowned rule, not an orphan ---
    no edit needed there.

- **chris-lattner (the six-line psHwm footnote (229-234) argues the type theory of psHwm
  --- why Qty not a stripped newtype like Price, no aggregate claimed --- for a field that
  is mempty throughout and whose writer is out of scope; it does not serve "where state
  lives" and exists only to pre-empt the inconsistency the document creates with Price's
  prominent rationale; cut or compress to a single clause).** Took the **compress** route
  (NOT outright cut --- a bare "typed Qty" with no reconciliation is the R17 defect
  jane-street-cto vetoes: a never-summed value contradicting the Price rule). The
  `\footnote{...}` is DELETED; its load-bearing content is folded into a single clause on
  the psHwm sentence: "...so it bears no zero-sum invariant, and it keeps the full Qty type
  rather than a stripped newtype like Price because its operation is not settled here ---
  no aggregate over holders is claimed." This preserves the Price reconciliation (jane-
  street-cto no regression: explains WHY psHwm is Qty and not Price-stripped --- operation
  unsettled) and the no-aggregate disclosure, while removing the off-topic six-line
  footnote (chris-lattner satisfied). NEVER restore the footnote; NEVER write a bare
  "typed Qty to match its source" with no Price reconciliation (R17 defect); NEVER assert
  HWMs add (R16 incoherence with Price).

### Residue judged false positive / standing FLAG returned to subject-matter
- **The SSOT rule + "exactly two failure modes" exhaustiveness is RENDERED per dirac's
  direction, grounded in CLAUDE.md Purpose (line 6: "internal reconciliation failure
  cannot arise", "one source of truth").** dirac (subject-matter) states the principle and
  points to the source; STYLUS promotes it as prose. NOT a STYLUS-authored claim. If the
  "a stored fact can be unfaithful in EXACTLY two ways, and only two" exhaustiveness needs
  independent establishment beyond the project telos (i.e. a proof that key + authority are
  the only two coordinates that locate a stored fact), that is subject-matter --- the prose
  states it as forced by the one rule, per dirac's instruction.
- **Multi-instrument reification proof --- STANDING FLAG (carried Rounds 6-19), unchanged.**
  The count "three homes, two maps / no fourth" stands bounded to relationships that reify
  as a single (holder, unit) row; the general multi-instrument reduction is not proved
  (absent from States.hs). The R20 §answer scope-by-forward-reference does not change the
  bound --- it only removes the duplicate statement of it. Subject-matter/.hs decision.
- **psHwm type-strengthening --- STANDING FLAG 2 (carried Rounds 2-19), unchanged.** The
  one-clause reconciliation states psHwm keeps Qty (operation unsettled, no aggregate
  claimed) in PROSE; the type still permits `foldMap psHwm`. The type-level remedy (a
  newtype with no Semigroup/Monoid mirroring Price) is a States.hs/milewski decision STYLUS
  cannot author. The R17 States.hs internal inconsistency (additivity rationale vs
  no-aggregate stance; ratchet=max at 374 vs add=+ at 581) persists in the .hs and is
  milewski's; the R20 .tex asserts NO operation on psHwm, so it imports neither.
