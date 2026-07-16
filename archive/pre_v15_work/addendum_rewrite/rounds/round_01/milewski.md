# Round 1 Scorecard — MILEWSKI

**Artifacts:** `addendum_rewrite/addendum_stateshome_v2.tex`, `addendum_rewrite/reference/StatesHome.hs`
**Lens:** Authored the Haskell. Judge expressibility — does each concept map cleanly to Haskell? An awkward type is a signal about the design, not only the code.

## Grade: B (84%)

The load-bearing concepts map to Haskell cleanly and faithfully, and that is the heart of
my lens: the event/state machinery (three maps, abstract `Ledger`, smart-constructor
`ValidDelta`, conservation as a monoid identity into `PosDelta`, the `NonEmpty` that makes
"registered but versionless" unrepresentable, the `Maybe` accessor distinguishing
never-held from held-and-flat, replay as a Kleisli fold) is expressed without contortion and
the prose tracks it. Conservation, monotone carrier, atomic delta, and replay determinism
are all faithful — no correctness regression in those.

It is not an A because the prose makes three claims my domain cannot back as written, and
the one concept that maps *awkwardly* to Haskell (C11) is exactly the one the document
states most strongly. The awkwardness is a real signal: C11-as-stated is not the type-level
fact the tex claims. Details below, each actionable.

---

## Blocking issues

### B1 — `amend` does not "emit an atomic re-subscription"; the prose says it does
**Location:** tex §4.4 "Amendment has two tracks." (lines 453–461); .hs `amend` (lines 419–434), signal S1 (lines 448–460).

Tex: the Breaking track "allocates a fresh `u_new`, stamps `superseded_by`, **and emits an
atomic re-subscription that moves holders from `u_old` to `u_new` as paired issuance**."
The reference `amend` does the first two and *not* the third — and deliberately so:
signal S1 in the .hs states the re-subscription is a *separate* paired-issuance event
(`applyAll [burn, mint]`), because a single-unit `StateDelta` cannot express a cross-unit
move. So the prose attributes to one operation a behaviour the reference splits out on
purpose, and the splitting is itself the addendum's expressibility insight. A reader who
goes to `amend` for "emits an atomic re-subscription" finds it does no such thing.
**Fix:** soften to "and a *separate* atomic re-subscription event (paired issuance on each
unit) moves holders," and say the reference leaves re-subscription as paired issuance
outside `amend` (cite S1). Do not implement it inside `amend` — the separation is correct.

### B2 — C11 is over-claimed as a type-level guarantee; the reference never exercises the one site where it bites
**Location:** tex C11 (lines 280–285), §7 bullet (lines 742–744), §9 P10 (line 642), §10 P10 (line 645/636); .hs §C11 (lines 176–219), `SomeWrite` (lines 208–211), signal S3 (lines 469–476), `main` (lines 514–542).

The tex states C11 flatly: "A write to a field by any other handler is a type error," and
§9 lists **P10 as structurally unrepresentable**, alongside P1/P6. My lens cannot stake the
bar on that. The guarantee lives only at a handler-authorship site (a handler typed
`Map WalletId (FieldWrite 'Settle)`), and the index is erased the moment writes share a row
via `SomeWrite`. The reference (a) never defines such a handler — the payoff is described in
a comment (lines 186–189) but only demonstrated by the trivial aliases `_c11_ok_*` and the
commented `_c11_bad`; and (b) the runnable `main` constructs writes ad hoc and wraps them in
`SomeWrite (WAc ...)` directly, **bypassing the authorship check entirely**. At the
delta-construction level it is perfectly representable to place `SomeWrite (WHwm q)` in a
settle context. So P10 is *not* "structurally unrepresentable" the way P1 is; it is an
authorship-site convention backed by a reachable type error only if a typed handler exists.
This is the restraint-rule question for the whole DataKinds/GADT apparatus: in this file the
GADT's concrete purchase over a plain `data FieldWrite = WAc Qty | WBalance Qty | ...` with a
documented writer table is shown only at the margin and is bypassed in the example.
**Fix:** either (i) add one real handler typed by its output (e.g.
`settleHandler :: ... -> Map WalletId (FieldWrite 'Settle)`) and route `main`'s trade/settle
deltas through it, so the type error is reachable in the actual construction path and the
GADT earns its keep visibly; or (ii) downgrade the C11/P10 claims from "type error /
structurally unrepresentable" to "type error at handler authorship; erased at the delta row
(see S3)," so the prose matches what the encoding delivers. (i) is the stronger fix.

### B3 — Handler vocabulary diverges between tex and reference
**Location:** tex C2 (line 230: Trade, SettleVM, CorporateAction, QISRebalance, MandateAmend); .hs `Handler` (line 193: Settle, Trade, Transfer, FeeCrystallise, Subscribe).

The tex names the conservation event classes one way and the reference names the C11
field-writer handlers another. "Trade" is shared, "Settle"/"SettleVM" nearly match, but
`Transfer`/`FeeCrystallise`/`Subscribe` are reference-only and CorporateAction/QISRebalance/
MandateAmend are tex-only. A reader cross-referencing C2 (event classes) with C11 (the
`Handler` enum) cannot tell whether these are the same vocabulary. They are conceptually two
different sets, but nothing in either artifact says so.
**Fix:** state explicitly that the C2 event-class list and the C11 `Handler` (field-writer)
enum are distinct vocabularies, or reconcile the names. One sentence in §7 mapping the
reference `Handler` constructors to the C2 event classes would remove the friction.

### B4 — `psBalance` field and `Transfer` handler have no anchor in the spec prose
**Location:** .hs `PositionState` (line 167, psBalance), `Handler`/`WBalance` (lines 193, 199), field-discipline comment (line 157); tex §3 home-of-each-datum table (lines 168–186), §4.1 fields (lines 198–215).

The reference introduces a conserved additive field `psBalance` written by `Transfer`. The
tex's PositionState inventory is `accumulated_cost`, `hwm`, `entry_nav`, fees, breach flags,
benchmark nav — no `balance` field and no `Transfer` event anywhere. If `psBalance` is meant
to be the framework holding `h(w,u)`, the reference should say so and align names; if it is a
second demonstrative conserved field, the tex should mention it or the reference should drop
it. As stored, the reference carries state the specification does not describe — a
faithfulness gap a reviewer reading top-down will hit.
**Fix:** ground `psBalance`/`Transfer` in the tex (name it as `h(w,u)` or add it to the §3
table), or remove it and demonstrate multi-field conservation with the fields the tex
already names.

---

## Non-blocking (noted, not gating)

- **C4 silently absent from the reference.** §7 "the encoding carries the conditions
  structurally" lists C1, C2/C9, C6/C7, C11, C3/C10, C8 and omits C4. The .hs records this
  honestly as S2 (read-scoping is a Reader/capability concern, not a data shape) and §11 F4
  stages C4 later, so it is covered overall — but §7 should say in one clause that the
  reference does not express C4 (and points to S2), so the omission is stated, not inferred.
  This is the correct expressibility call (C4 is not a shape of stored data); only the
  silence is the issue.
- The `Map String String` opaque `tvFields` payload is the right move (terms content is out
  of scope here) — no action.

---

## What is right (so revision does not regress it)

- Three-map split, `Ledger` abstract with no row deleter, `ValidDelta` abstract with
  `validate` the only constructor, `ProductTerms` abstract over `NonEmpty` — all clean,
  all the purchase named. Keep.
- Conservation as `foldMap ... conserved` into the `PosDelta` monoid, with the vacuous
  zero-holder case (C9) falling out of the empty `foldMap` — this is the cleanest mapping in
  the file and the dividend/len(holders) bug-class exclusion is real. Keep.
- `applyDelta :: ValidDelta -> Ledger -> Either LedgerError Ledger` with the registration
  guard keeping the PT⇔US invariant by construction (replace, not fabricate; adjust
  guaranteed to hit) — faithful and correct. Keep.
- `replay = foldM applyDelta` and the Kleisli (anti)homomorphism framing of P3. Keep.
- Exact `Integer` minor units, never `Float`. Keep.
