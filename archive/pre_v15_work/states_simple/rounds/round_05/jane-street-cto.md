# jane-street-cto — Round 5 — States.tex

**Verdict: NOT-YET**

## What is right

The artifact is correct and the derivation is well-staged. I checked the code,
not just the prose:

- `applyMove` writes both legs from one quantity (`leg to q (leg from (negQty q) ...)`);
  conservation holds, including the self-transfer case (`from == to`), where the
  second leg reads the first's write and the pair still sums to `mempty`.
- `register` refuses an existing unit; `settle`/`Map.adjust` touch only the
  status half of the pair; neither touches `psBal`. The conservation argument
  (lines 315-326) is sound.
- `replay = foldM (flip apply)` typechecks and the checkpoint-split claim is the
  standard `foldM` decomposition law over `Maybe`. Determinism follows from
  `apply` being pure and total. Correct.
- Terms as `NonEmpty` with `currentTerms = NE.last` / `appendVersion` appending
  to the tail is internally consistent. The unexported constructor argument
  (lines 208-215) genuinely closes the "shorten history" door.
- The `2x2`, three-occupied-cells taxonomy is crisp and the empty-cell and
  managed-account arguments (§Why Three) hold.

This is close. The blocker is not the logic; it is one load-bearing fact the
`.tex` omits that the `.hs` already states.

## Residue (located, actionable)

### R1 — `Balances`/`holding` appear as a live third map; the "scaffolding,
superseded" framing is dropped from the document (States.tex lines 173-188)

The headline thesis is "three homes, two maps" (lines 87, 243). But the listings
declare **three** `Map` types to the reader: `Balances` (line 176),
`ledgerUnit` (line 256), `ledgerPS` (line 257). `Balances` and its accessor
`holding` are never referenced by `Ledger`, `applyMove`, any writer, or `netBal`
— the production store is `ledgerPS`/`PositionState`.

The source-of-truth `States.hs` (lines 26-31) states the missing fact plainly:
these are "teaching scaffolding ... deliberately NOT exported ... superseded by
the sealed `Ledger` ... Exporting them would offer a second, unsealed move API
able to build a non-conserving balance map by hand." That sentence is exactly
what makes the listing obvious — and it is absent from the `.tex`. The document
says only "The same two legs reappear in applyMove" (line 187), which signals a
precursor but never tells the reader that `Balances`/`holding` are not part of
the final module and must not be used.

Consequence for the six-months reader: they must hold, unaided, the inference
"`Balances` is illustrative, `ledgerPS` is real, and the `two maps` count
excludes `Balances`." That is commentary the document forces them to write.

Fix: port the `.hs` framing into the `.tex` — state at the `Balances` listing
that it is a superseded, non-exported precursor (not one of the two maps, not a
usable move API), lifted into `applyMove`/`PositionState` below.

### R2 — the never-held vs held-and-flat distinction is attached to the
superseded accessor, never to the live store (States.tex lines 181-184 vs 356)

The `Nothing` = *never held* / `Just 0` = *held and flat* distinction — called
load-bearing (settlement entitlement, wash-sale lookback) — is stated on
`holding`, which operates on the orphaned `Balances`. In §Why It Is Right
(line 356) the same distinction is then claimed for the production store
("a closed-out position stays a flat row"). But no read accessor on `ledgerPS`
is shown, so the distinction is asserted for the live store while its mechanism
is only exhibited on the superseded one. The reader cannot see, in the document,
that `Map.lookup (w,u) (ledgerPS l) :: Maybe PositionState` carries the same
`Nothing`/`Just` split.

Fix: exhibit the `ledgerPS` lookup that carries the distinction (or explicitly
state that `holding`'s `Maybe` is the same shape `ledgerPS` lookups return),
so the line-356 claim rests on shown code, not on transfer from scaffolding.

## Note (not a blocker)

`psHwm` is structurally `Qty 0` in every reachable state — no writer ever sets
it. The document pre-empts the obvious "why is this here / what writes it"
question three times (lines 226-233, 325-326), with the writer declared out of
scope. I accept it as a deliberate taxonomy demonstrator, not residue. If R1/R2
are addressed I would not block on this.
