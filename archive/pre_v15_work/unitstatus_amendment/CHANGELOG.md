# UnitStatus amendment — changelog

Implements the SETTLED finding of `../unitstatus_review/formalis_synthesis.md`
(DERIVED PROJECTION, 9/9): UnitStatus is a materialised projection of the immutable
event log — a read cache whose every change is caused by a logged event and which
replay rebuilds exactly — not an authoritative mutable source of truth. The corpus
defect was the wording, above all the bare label "mutable". This pass replaces that
wording with one canonical form, used verbatim everywhere.

## Canonical wording (defined once, reused verbatim)

**FULL (prose).** UnitStatus holds one value per unit, shared --- read identically by
every holder. Its value changes over time, but UnitStatus is not a separate source of
truth: the immutable event log is. Every change is caused by a logged event; the stored
value is overwritten in place only as a read cache. Replaying the events up to any point
rebuilds the exact value that held then, so nothing is lost by overwriting and there is
no other way to change the value. A value exists from registration onward.

**COMPRESSED (table/comment cells).** projection of the log, overwritten in place as a
read cache; shared, read identically by every holder; registration-total --- every
change caused by a logged event, rebuilt exactly by replay.

**Materialisation-soundness principle (plain words).** The stored value always equals
what replaying the unit's events produces, and no part of the system writes it except
through a logged event.

## Per-document changes

### States.tex
- CHANGED: the "Status is one stage of the unit's lifecycle, overwritten ..." passage
  now carries the FULL canonical wording (line 203), so "overwritten" reads
  unmistakably as cache overwrite caused by a logged event, not in-place editing of
  truth. Rebuild guarantee stated plainly. Settlement price marked as entering only as
  a logged observation event in the log (line 208).
- LEFT: the model — "every view is a projection of the stream" and replay = `foldM`
  apply. This is the ground the fix rests on; changing it is out of scope.

### FutureLifeCycle.tex
- CHANGED (the single most important edit): the state-table Discipline cell for
  UnitStatus (line 58) now holds the COMPRESSED canonical form, replacing the bare
  "mutable, shared across holders; registration-total" that licensed the off-log writer.
- CHANGED: settlement mark marked as entering only as the `SettleVM` observation event,
  captured as a logged observation, so the fold stays pure at the boundary (lines 220–221).
- LEFT: "shared, read identically by every holder", the "projections of the Settlement"
  statements, and ProductTerms "immutable, append-only, versioned" — all correct; kept
  verbatim (protected list).

### managed_account_workflow.tex
- CHANGED: every UnitStatus relabel harmonised to the canonical wording; the FULL form
  appears at line 101. The document now speaks with one voice.
- CHANGED: the concern passage that voiced the REJECTED reading is rewritten to the
  RESOLVED position (line 522): the price that struck a fee lives in the immutable
  settlement event in the log, so it is rebuilt exactly by replay and is "as reproducible
  as the events that produced it, never 'only as reproducible as a mutable cell.'"
  Reproducing the NUMBER is assured here; ATTESTATION of the externally-sourced price is
  a DISTINCT requirement (Nazarov finding, recorded separately — see below), stated
  honestly and not conflated.
- CHANGED: current benchmark level marked as captured as a logged observation event from
  the index source (line 151).
- LEFT: the deferral to Addendum A1's definition is kept, and now points at the corrected
  A1 wording (A1 amended in this same pass), not the old "mutable, ... not versioned"
  phrasing.
- LEFT (out of scope, not bare-UnitStatus labels): line 500 "mutable" = PositionState
  scalars under the orthogonal E1 store-vs-derive escalation; line 549 "mutable" =
  WalletRegistry LEI under E3. Neither is a UnitStatus mutability label.

### addendum_stateshome_v2.tex (A1 — the authoritative definition the others defer to)
- CHANGED: every "mutable [shared] UnitStatus" relabelled to the canonical wording — the
  code-comment table row (lines 164–166, COMPRESSED), the home-of-each-datum table row
  (line 214, COMPRESSED), and the prose (FULL at lines 177, 631, 865). The two-readings
  hazard note now reads in the RESOLVED voice; read in isolation no cell licenses the
  two-writer inference, because each carries the foreclosing clause "every change caused
  by a logged event".
- CHANGED: made explicit that where status is overwritten on every settle, the CACHE CELL
  is overwritten while the settlement EVENT that determines it is appended immutably;
  externally-sourced values (settlement price, current benchmark level) enter only as a
  logged observation event (lines 186, 373).
- LAYOUT: longtable column spec widened so the long canonical cell wraps cleanly; content
  unchanged, page width preserved.
- LEFT: the numbered MAT C-invariant and the formal C11 single-writer C-list extension are
  NOT added here — commissioned separately (see below). The principle is stated in plain
  words only.

### reference/StatesHome.hs
- CHANGED: the single real code gap closed. `amend`'s Breaking track no longer writes
  `s { usSupersededBy = ... }` directly; it routes through `applyStatus (SetSupersededBy
  uFresh)`. The single-writer closure is now complete: every write to a `UnitStatus`
  field is a case of `applyStatus` (the closed sum `StatusWrite`), folded over the
  event-carried `sdStatus`. `grep "{ us[A-Z]"` returns only the three `applyStatus`
  cases. Genesis (`register` inserting `defaultStatus`) is the one carved-out initial
  write — "a value exists from registration onward". Externally-sourced numbers enter
  only as logged observation events (`SetLastSettle`, comments at lines 152, 191).
- LEFT (protected): `Ledger` sealed (unexported constructor/selectors); no exported
  `setStatus`; UnitStatus NOT versioned (the log holds history); `accumulated_cost` in
  `PositionState`; monotone carrier and `Option` accessor untouched.
- NOT COMPILED: GHC absent in this environment; tests written to run on `base` alone.

### tests/
Three gating tests plus a shared harness (`LedgerTestKit.hs`, bounded-exhaustive
enumeration with minimal-counterexample search and an independent re-fold oracle).
- `Test1_GenesisRefold.hs` — the incrementally-maintained store equals an independent
  hand-written re-fold from genesis, for every stream/unit (bounded-exhaustive, depth 4).
  Gates any future snapshot or cache: divergence turns the build red.
- `Test2_BackdatedRestatement.hs` — both time-travel modes: re-folding the original prefix
  yields the original status (past immutable); appending a correcting settle and a
  Breaking amendment then re-folding yields the corrected status. The only route to a new
  value is appending an event.
- `Test3_ExternalObservables.hs` — external observables enter only via logged observation
  events: replay reproduces status with no ambient input; status-less events change no
  status; stored price equals the logged payload exactly; distinct observations give
  distinct numbers. Records (does not test) that attestation is the distinct Nazarov gap.
- NOT EXECUTED: GHC/runghc/cabal absent in this environment.

## Protected list — verified untouched
- Overwrite-in-place, NON-versioned storage of UnitStatus (not made append-only/versioned).
- "shared, read identically by every holder" / u-keying phrasing — verbatim.
- Sealed Ledger (unexported constructor and field selectors) and the closed writer set
  (every writer a case of `apply`; no exported `setStatus`).
- Registration-totality; idempotent write-by-replacement; monotone PositionState carrier /
  Option accessor; `accumulated_cost` in PositionState.
- ProductTerms "immutable, versioned, append-only" wording — unrelated; left exactly as is.

## Commissioned SEPARATELY — NOT done here
1. The numbered MAT C-invariant and the formal C11 per-field single-writer C-list extension
   in the addendum. This pass states the materialisation-soundness principle in plain prose
   only; the numbered invariant and C-list closure are a separate pass.
2. The Nazarov attestation envelope: attestation that an externally-sourced price is the
   genuine settlement level. Reproducing the NUMBER is assured here; attestation is a
   distinct requirement, recorded in managed_account_workflow.tex E2 and out of scope.
