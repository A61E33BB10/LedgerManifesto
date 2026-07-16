# Round 1 — jane-street-cto

## Verdict: NOT-YET

The three-homes answer is well-motivated and the "why three" cases are sharp. But the
document's two correctness claims — conservation and deterministic replay — do not close
inside the document, and where they are completed (in the deferred `States.hs`) the model
contradicts the prose. A reader six months on will write commentary, and the first
question they write is "where does settlement enter the fold?"

## Residue (located, actionable)

### R1 — The event→Ledger bridge is missing; `Balances` vanishes from the result
`transfer` (lines 144-149) operates on `Balances = Map (WalletId, UnitId) Qty` (line 126).
But the assembled `Ledger` (lines 190-195) has no `Balances` field — it has
`ledgerPS :: Map (WalletId, UnitId) PositionState`. The document never shows the function
that applies an event to the `Ledger`. `replay` (line 213) folds `apply`, but `apply` is
never defined in the document. The reader cannot reconcile "transfer over Balances" with a
Ledger that contains no Balances without leaving the document. Show how a move updates the
three maps, or the construction does not reach its own conclusion.

### R2 — "Every event is a transfer" is false for the state changes the prose insists on
Conservation (line 202) rests entirely on "Every event is a transfer." Yet the document
spends two paragraphs describing changes that are NOT transfers: status is "overwritten on
every settlement" (line 88) and terms "append a version" (lines 86-88). Either these are
events — then the premise is false and conservation does not follow — or they are not
events. In the deferred `States.hs` it is the latter: `data Event = Moved Move`
(States.hs:450) admits only moves, and `applyMove` updates only `psAc`
(States.hs:382); `ledgerUS`, `ledgerPT`, and `psHwm` are never updated by any event. So the
premise is salvaged only by amputating the very disciplines (overwrite-in-place,
append-a-version) that justify homes two and three. The document argues for a richer model
than it can operate.

### R3 — Replay does not reconstruct the Ledger it claims to
"Deterministic replay" (lines 208-221) claims the fold yields "the same state." It yields
only position accumulated cost. Status, terms, and the high-water mark are outside the
event stream and are never rebuilt by `replay`. This contradicts the project's foundational
premise (CLAUDE.md: "every other view ... is a projection of that stream"): if status and
terms are not in the stream, they are not projections, and the single-source-of-truth claim
fails. Replay must fold the settlement and amendment events too, or the document must state
plainly that status/terms live outside the replayable stream and defend that.

### R4 — Conserved and non-conserved fields share a type; the proof rests on prose
`PositionState` carries `psAc :: Qty` (conserved) and `psHwm :: Qty` (not conserved,
ratchets) (lines 179-182). The conservation claim "so does every conserved field" (line
206) depends on a reader knowing which fields conserve — a distinction carried only in
prose and a source comment (States.hs:290-291), not in the types. "Make illegal states
unrepresentable" is unmet: nothing in the type prevents treating `psHwm` as conserved or
summing it across holders. The field that breaks the invariant has the same type as the
field that upholds it.

### R5 — One type for quantity, price, and issuance count
`Qty` is defined as "a quantity, measured in exact minor units" (lines 108, 114). The
document then models a settlement *price* as `usLastSettle :: Maybe Qty` (line 159), and the
mandate issuance as `+1`/`-1` *counts* (lines 95-97) — also `Qty`. A price, a held
quantity, and an issuance count are three distinct primitives collapsed into one. The type
system cannot stop a price being added to a position size. NewType discipline is exactly the
document's stated weapon ("illegal states are not representable"); here it is dropped at the
one place semantic confusion is cheapest to introduce.

## What is done well
The (holder, unit) vs unit keying argument (lines 70-89) is concrete and convincing. The
`Nothing` vs `Just 0` distinction (lines 131-135) is precisely the kind of made-visible
invariant that survives at 3am. The mandate-as-unit collapse of the apparent fourth home
(lines 91-98) is the document's strongest idea. Fix the bridge and the replay/conservation
scope, and this becomes obvious.
