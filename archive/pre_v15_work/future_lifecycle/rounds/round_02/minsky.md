# minsky — Round 2 review (FutureLifeCycle)

Lens: state types make illegal lifecycle states unrepresentable (incl. re-expiry);
never-held / held / flat distinction exact.

Verdict: **NOT-YET**

---

## What holds (verified, not assumed)

**The status fuse is sound.** `Stage = Registered | Active (Maybe Settlement) |
Expired Settlement` (`FutureLifeCycle.hs:178-183`) makes the two named illegal status
states genuinely unspellable, *even against raw `StateDelta` construction* (the
constructors are exported, so this matters): `Registered`-with-price and
`Expired`-without-mark cannot be written by anyone, handler or caller. `settlement`,
`settlementPrice`, `settlementDate` are total over all three constructors
(`:191-202`). This is the strongest part of the design and the `.tex` §3 derivation of
it is correct.

**Re-expiry is exactly handled.** The lens flag "incl. re-expiry" is discharged. The
rank guard `stageRank new < stageRank cur` is correctly identified as too weak (a
second `Expire` has equal rank, `2 < 2` is false), and an explicit `isExpired cur`
test rejects every stage-writing delta on an expired unit — defense in depth at both
`handle` (`:476` G2) and `applyDelta` (`:549`). `Close` carries `sdStage = Nothing`
(`:429`) and is therefore the one delta admissible on `EXPIRED`. The `.tex` §10
argument and `settlement_answer.md` agree. Correct.

**never-held vs held-flat is exact along the lifecycle path.** `position` returns
`Maybe PositionState` (`:591`); `Nothing` = never held, `Just zeroP` = held-and-flat.
Rows are created only by `applyRow` (`:561`) over wallets present in `sdRows`, and the
settlement/close fan-outs (`settlementFanout :413`, `closeDelta :426`) iterate
`holdersOf` — existing rows only — so a non-holder (C at Settle d1) is never given a
phantom row. The monotone carrier (no exported deleter) keeps flat rows in place. On
the worked-example trajectory this is exact.

**Conservation at every event.** Re-derived independently; all three sums vanish at
each of the seven steps:

| Event | ΣΔnet | ΣΔac | ΣVM |
|-------|------|------|-----|
| T1 (A buys 10/B@100) | +10−10=0 | −50000+50000=0 | — |
| Settle d1 (S=102) | 0 | (−51000+50000)+(51000−50000)=0 | +1000−1000=0 |
| T2 (C buys 4/A@103) | +4−4=0 | −20600+20600=0 | — |
| Settle d2 (S=101) | 0 | 0 | −100+500−400=0 |
| T3 (B buys 4/C@101) | +4−4=0 | −20200+20200=0 | — |
| Expiry (S=105) | 0 | 0 | +1200−1200=0 |
| Close | −6+6+0=0 | +31500−31500+0=0 | 0 |

The day-2 anchor (A = −100, not the naive −300) checks: `6·101·50 − 30400 = −100`,
and the intraday offset `4·(+1)·50 = +200` against the `−300` mark loss is correctly
the reason `ac` must be stored per-position. Closing identity ties cumVM to economic
P&L per wallet (A=+2100, B=−1700, C=−400, Σ=0). The `VM = −Δac` ⇒ "VM zero-sum *is*
ac conservation" observation is correct and well-surfaced.

**The three anchor sub-questions** are answered without evasion in both
`settlement_answer.md` (§1–§3) and `.tex` §7: (1) state update split by layer —
shared price write vs per-holder fan-out; (2) one atomic event that fans out, not a
derived consequence (the cash leg forces the per-holder pass); (3) price only in
shared `UnitStatus`, consequence only in per-wallet `PositionState`. Consistent across
all three artifacts.

---

## Gaps (located, actionable)

### G-minsky-1 — Trade quantity is not constrained positive; q=0 manufactures phantom held-flat rows and silently activates a never-traded unit (primary, blocks)

`Trade :: UnitId WalletId WalletId Qty Price` (`FutureLifeCycle.hs:283`) takes a raw
`Qty` (`newtype Qty Integer`, no smart constructor). `handle`'s Trade case
(`:463-466`) guards only `buyer == seller` and `isExpired`; it never rejects a
non-positive quantity. Two representable, conservation-passing defects follow:

- **q = 0.** `tradeDelta` (`:369-378`) emits `sdRows = {buyer: RowDelta 0 0, seller:
  RowDelta 0 0}`; `validate` passes (`netDelta = mempty`); `applyDelta` then (a)
  promotes `Registered → Active Nothing` via `activateTrade` (`:366`,
  `stageRank 1 < 0` false) and (b) creates rows for buyer and seller at `zeroP` via
  `findWithDefault` (`:563`). Result: a never-traded unit is silently activated and
  two wallets that never held anything now read `Just zeroP` (held-flat) instead of
  `Nothing`. This directly breaks the "Nothing = never held" exactness this lens is
  charged with — the distinction the `.tex` §6 calls "both load-bearing" for
  wash-sale lookback and trade reconstruction is corrupted by a no-op trade. It also
  contradicts G4's own rationale (settle is rejected on `REGISTERED` precisely so a
  never-traded unit is not silently promoted); a q=0 trade promotes it anyway.

- **q < 0.** A negative quantity violates the framework move primitive recalled in
  `.tex` §1 ("a move transfers a *positive* quantity"). `tradeDelta` happily inverts
  the roles (buyer goes short, seller long) and conserves, so `validate` and
  `applyDelta` accept it; the buyer/seller labels become meaningless and the
  positivity invariant of the underlying move is silently broken.

Actionable fix (minsky-preferred, parse-don't-validate): give the trade leg a
positive-quantity type — a `newtype PosQty` with a smart constructor returning
`Either LedgerError PosQty`, used in the `Trade` constructor — so a non-positive
trade is unrepresentable rather than caught. Minimal alternative: add a guard in
`handle`'s Trade case rejecting `q <= Qty 0` with a new `NonPositiveQty UnitId Qty`
error, and state the rule (`q > 0`) in `.tex` §4 and `settlement_answer.md`, neither
of which currently mentions it.

### G-minsky-2 — `Expire` on a `REGISTERED` (never-traded) unit is permitted while `SettleVM` on it is rejected; the asymmetry is undocumented (secondary, clarity/policy)

`handle`'s `Expire` case (`:475-479`) matches `Expired _ -> Left UnitExpired` and
sends everything else, including `Registered`, to the fan-out branch — so a
never-traded unit jumps `REGISTERED → Expired Settlement` (rank 0 → 2, monotone,
`applyDelta` accepts), acquiring a final mark over an empty holder set. Meanwhile
`SettleVM` on `REGISTERED` is explicitly rejected with `NotActive` (G4, `:470`), on
the stated ground that a settle must not silently promote a never-traded unit and that
`REGISTERED` has no mark slot. The same ground appears to apply to `Expire`, yet the
two events diverge. The resulting `Expired Settlement` over a unit that was never
`Active` is a legal *type* state (so this is not an unrepresentability breach), but the
intended policy is not stated anywhere in `.tex` §10 or `settlement_answer.md`.

Actionable: decide and document. Either (a) Expire-on-`REGISTERED` is intended (a
listed future expires whether or not it traded) — then state it in `.tex` §10 next to
G4 and explain why expiry, unlike settle, may originate from `REGISTERED`; or (b) it
is not intended — then reject it symmetrically with G4 (`Registered -> Left NotActive`
in the `Expire` case). As written, a reader cannot tell which, and the divergence from
G4 reads as an oversight rather than a decision.

---

## Note (not a gap)

Transition legality (no economic event after expiry; settle only after first trade;
close only after expiry) is a *runtime* guard in `handle`/`applyDelta`, not a type
fact. This is honestly recorded in signal E2 (`:619-627`) with a sound restraint
argument (indexing the ledger by per-unit stage buys nothing here). Under this lens
that is acceptable: what *can* be made unrepresentable at the state level (the two
status illegalities, the terms/status desync via the fused map `:505`) *is*; only
transition legality remains value-level, by deliberate and stated tradeoff. G-minsky-1
is different in kind — it is an *unguarded* legality hole that also corrupts a
state-level distinction (never-held vs held-flat), not a deliberately-deferred type
refinement.

---

## Why NOT-YET

The state-type core is strong and re-expiry is exact. But the never-held/held/flat
distinction this lens must certify as *exact* is breakable today by a q=0 trade
(G-minsky-1), and trade quantity positivity — a framework primitive invariant — is
unenforced. That is a correctness defect, not a stylistic one. G-minsky-2 is a smaller
policy/clarity gap. Address G-minsky-1 (and state the G-minsky-2 policy) and this
clears.
