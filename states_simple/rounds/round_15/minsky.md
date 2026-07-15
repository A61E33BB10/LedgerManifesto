# minsky — Round 15 — States.tex / States.hs

## Verdict: OBVIOUS

## Lens

Does each illegal state the design relies on excluding become *visibly* impossible
in the shape a first-time reader reads — not on faith? And where a fact is *not*
carried by a type, is it disclosed as a writer/seal discipline (with a bounded,
checkable argument) rather than disguised as a shape?

## What is live this round

`States.hs` is byte-identical to my R13/R14 pass (mtime 12:33, unchanged).
`States.tex` was re-edited at 13:20 (after R14 closed at 13:12). The iteration
log records the R15 edits as clarity/honesty moves on prose only:

1. Reification hoisted to a named premise opening §The Answer (tex:55-59), the
   count made conditional from the first sentence; the holder-axis paragraph now
   cites the premise instead of re-deriving it.
2. The psHwm/Price reconciliation ported from source into §Construction
   (tex:221-233): the discriminator is now **additivity**, not transferability.
3. The Price line trimmed to "prices are never added" (tex:192-193) so one
   criterion (additivity) is shared by both passages.
4. §Why-Three Terms authority mechanism collapsed to a citation (tex:123-124).
5. The amendment/`appendVersion`-out-of-scope caveat stated once (tex:130-131),
   cited from §Construction (tex:271-273).
6. The psHwm listing comment shortened to `-- high-water mark: not conserved`.
7. The settlement-price authority illustration cut at the axis definition; the
   benchmark level-vs-identity example left as the single worked sort (tex:88-93).

So the live question is narrow: did any 13:20 edit introduce an overclaim — a
writer invariant dressed as a shape, or a representable illegal state asserted
impossible? It did not. Every edit weakens a claim toward honesty, replaces a
re-derivation with a citation, or cuts redundancy. None strengthens a type
guarantee the code does not carry.

## Type-carried claims — re-tested, each unchanged in the code and visible in the shape

The `.hs` is unchanged, so each carries exactly as in R13/R14; re-confirmed the
`.tex` listings remain faithful slices (deriving/record sugar elided, tex:158):

- `data Lifecycle = Listed | Active Price` (tex:197, hs:258): active-without-price
  and listed-with-price both unspellable; price rides on the constructor. ✓
- `newtype ProductTerms = ProductTerms (NonEmpty TermsVersion)` (tex:214, hs:333),
  constructor absent from the export list (hs:47): "registered but versionless"
  unrepresentable; no importer can lay a short history. ✓
- `Map UnitId (ProductTerms, UnitStatus)` (tex:259, hs:437): co-presence is the
  tuple — one entry carries both halves or neither. ✓
- `(WalletId, UnitId)` key (tex:260, hs:438): buyer +1000 / seller −1000 are two
  keys, cannot collapse. ✓
- `Move UnitId WalletId WalletId Qty` (tex:297, hs:512): one `Qty`, so an
  asymmetric two-quantity move is not a sentence the language admits; the
  cancelling legs are derived in `applyMove` and visible there. ✓
- `Price` newtype with no `Semigroup`/`Monoid` (hs:249, confirmed by grep this
  round): never summed into a balance. ✓

## The R15 additivity rewrite — checked for self-consistency against the code

The one substantive prose change is the psHwm/Price reconciliation. The new
discriminator is additivity:

- `Price` (tex:192-193): "a number but not a quantity --- prices are never added
  --- so `Price` is a separate newtype with neither identity nor inverse." This is
  true to the code: `Price` derives only `Eq, Show` (hs:249); it has no `mempty`
  and no `<>`. "Neither identity nor inverse" is literally the absence of those
  instances, which the reader can confirm in the listing.
- `psHwm` (tex:227-229): "also a `Qty`, and rightly: a high-water mark is a
  quantity, so adding two is legal, unlike a price (above), whose sum is
  meaningless. What `psHwm` lacks is `psBal`'s paired writer ... so it carries no
  zero-sum invariant: a non-conserved field beside the conserved balance, with no
  aggregate over holders claimed for it."

The two passages are now consistent: `Price` strips the group because prices do
not add; `psHwm` keeps `Qty` because high-water marks do. Critically, the prose
does **not** dress this as a shape — it states outright that adding HWMs merely
"is legal" (typechecks) and that **no aggregate over holders is claimed**. The
reader is not misled into faith. This is the in-remit half of the standing
`psHwm :: Qty` flag (carry the source justification); the type-level remedy
(a `Price`-style group-free newtype) remains a source decision, not a
correctness hole — no illegal *state* arises, since `psHwm = Qty n` is a legal
value for any `n` and only an unused, never-claimed aggregate is available. Same
line I held in R13/R14.

## Seal — re-audited, intact

`Ledger` exported bare (hs:61); `ledgerUnit`/`ledgerPS` absent from the export
list. The record-update bypass the .tex names (`l { ledgerPS = ... }`, tex:250)
is genuinely closed — that update needs the selector in scope, and it is not. The
fully-open exported value types leak nothing: a value of each can be built by an
importer but none installed into a `Ledger` except through the four sealed
writers. The R15 edits touch no export and no writer. ✓

## Facts not carried by a type — still disclosed as discipline, not shape

- Conservation: tex:340-350 states plainly it is a writer invariant, "not the
  store type, which can hold a non-conserving assignment." The reachability
  argument is bounded: `applyMove` the only writer of `psBal`, netting per wallet
  and writing deltas summing to `negQty q <> q = mempty`; `register`/`settle`
  never touch `psBal`; base case `emptyLedger`; seal makes the reach exhaustive.
  Re-traced `netDeltas`+`writeNet` (hs:533-554) for from≠to, from==to, q=0 — all
  conserve, none writes a phantom row. Unchanged. ✓
- Append-only terms history: unexported constructor + `register` refusing a
  present unit (tex:203-210). The R15 amendment-caveat consolidation (tex:130-131)
  keeps the load-bearing consequence (register/settle the only exercised writers,
  neither touching `psBal`) and removes only a duplicate. ✓
- Registration gate: only `applyMove`'s `Maybe` guards input (tex:312-318); no
  type claimed to forbid an unregistered-unit position. ✓
- Never-held vs held-and-flat: descriptive, the writer never deletes a row
  (tex:320-328); the `Map` permits deletion and the doc does not claim otherwise. ✓
- No fourth home: explicitly conditional on the reification (tex:55-59), proved
  n=1, assumed for multi-instrument. The R15 hoist makes the *count itself* name
  its dependence from the first sentence — a strict honesty gain, never a type
  claim. ✓

## Overclaim check on the R15 edits specifically

- Premise hoist (tex:55-59): underclaims if anything — it discloses the count
  rests on the premise rather than asserting the premise. No overclaim.
- Additivity rewrite (tex:192-193, 221-233): true to the code (confirmed `Price`
  has no group instance); makes no aggregate claim. No overclaim.
- Citation-collapses (tex:123-124, 271-273) and the cut settlement-price
  illustration: remove restatement; the table still carries "last settlement
  price" under Status and the criterion is stated once. No claim lost, none added.
- Shortened psHwm comment: the writer-out-of-scope/stays-zero fact lives once in
  the prose above; nothing weakened.

Build is clean: `States.log` shows no undefined references and no warnings, so no
cut left a dangling cross-reference.

## Exhaustiveness / totality

`apply` (hs:702-705) and `settlementPrice` (hs:294-296) match every constructor
with no swallowing wildcard — a new `Lifecycle`/`Event` case fails to compile.
`currentTerms` total by `NonEmpty`. All writers total in `Maybe`; `replay` a
`foldM` over a pure total step. No partial pattern hides a case. ✓

(No GHC on this host; Level 1 confirmed by inspection, as in R14 — the code is
byte-identical and the signatures, the `Map.foldrWithKey writeNet` fold, the
`foldMap` over `Qty`, and the `NonEmpty` operations all typecheck as written.)

## Standing flags (not counted as residue)

Both are pre-adjudicated, openly disclosed, and neither makes an illegal *state*
representable:

- **psHwm typed `Qty`**: summing HWMs typechecks (an unused, never-claimed
  operation); no illegal value arises and the doc states no aggregate is claimed
  (tex:228-229, hs:579-591). A should-strengthen returned to source, not a hole.
- **Multi-instrument reification**: a modeling-completeness claim, stated
  conditionally and flagged unproven for n>1. Outside my bar.

Promoting either would be inventing residue to withhold against an
honestly-disclosed, previously-adjudicated state.

## Why OBVIOUS

Every fact the .tex presents as type-carried is type-carried, and a first-time
reader sees each in the shape: price-on-`Active`, `NonEmpty` terms, the co-present
pair, the dual key, the single-`Qty` move, `Price` without a group. Every fact
not type-carried — conservation, append-only history, the registration gate,
never-held/held-and-flat, no-fourth-home — is disclosed as a writer/seal
discipline or a stated, bounded assumption, never dressed as a shape. The seal is
intact and checkable in the export list. The R15 edits refined rationale, made the
count conditional from its first sentence, and aligned the psHwm/Price rationale
on a single criterion (additivity) that is faithful to the code — without
weakening one type guarantee or making one illegal state representable. Obviously
right.

## Residue

None.
