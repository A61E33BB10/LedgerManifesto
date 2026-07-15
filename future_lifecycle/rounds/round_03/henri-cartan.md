# Round 3 — henri-cartan review

**Targets.** `future_lifecycle/FutureLifeCycle.tex`, `future_lifecycle/settlement_answer.md`.
**Lens.** Definitions before use; each step follows from what precedes; explicit quantifiers; no
handwaving.

**Verdict: CORRECT-AND-COMPLETE.**

## What was checked

### 1. Arithmetic and conservation at every event (recomputed independently)

I re-derived the entire worked life from the two stated rules (trade leg
`ac += −Δ·p·m`; settle `VM(w)=netq·S·m+ac`, then `ac ← −netq·S·m`) without consulting the
document's figures. Every value matches the table (§2) and the section walk exactly:

| Event | netq (A,B,C) | ac (A,B,C) | Σnetq | Σac | VM (A,B,C) | ΣVM |
|---|---|---|---|---|---|---|
| T1 | (10,−10,0) | (−50000,+50000,0) | 0 | 0 | — | — |
| Settle d1 (102) | (10,−10,0) | (−51000,+51000,0) | 0 | 0 | (+1000,−1000,0) | 0 |
| T2 | (6,−10,4) | (−30400,+51000,−20600) | 0 | 0 | — | — |
| Settle d2 (101) | (6,−10,4) | (−30300,+50500,−20200) | 0 | 0 | (−100,+500,−400) | 0 |
| T3 | (6,−6,0) | (−30300,+30300,0) | 0 | 0 | — | — |
| Expiry (105) | (6,−6,0) | (−31500,+31500,0) | 0 | 0 | (+1200,−1200,0) | 0 |
| Close | (0,0,0) | (0,0,0) | 0 | 0 | — | — |

All three conservation sums (Σ Δnetq, Σ Δac, Σ VM) are zero at every event. Listing is the
vacuous (empty-sum) case, correctly invoked (C9). The closing identity holds: cumulative VM =
(+2100, −1700, −400, CH 0), summing to 0, and each equals the wallet's independently computed
economic P&L. Confirmed by recomputation.

### 2. The three anchor sub-questions — answered without evasion

Both documents answer all three directly, and consistently with each other:

1. *Settlement is a state update; parts split by layer.* Shared = one mark write on
   `UnitStatus[u]` (`last_settlement_price`/`date` as projections of the embedded mark); per-wallet
   = `ac` reset + cash leg on `PositionState[w,u]`. One atomic `StateDelta` touching both. Stated
   plainly (§6 item 1; answer §sub-question 1).
2. *Atomic fan-out, not a derived consequence of the price.* The cash leg is real daily money and
   conservation-bearing, so a per-holder pass is forced regardless of storage; the `ac` reset rides
   the same delta under the single-writer discipline. The day-2 anchor (A's VM = −100, not the
   naive −300) is the load-bearing demonstration that the price-derived alternative is wrong for an
   intraday trader. Verified: 6·(101−102)·50 = −300, offset by intraday +200 = −100. (§6 item 2,
   §7; answer §sub-question 2 + E2.)
3. *Price only shared, consequence only per-wallet.* `last_settlement_price` lives only in
   `UnitStatus[u]`; the `ac` reset and VM cash live only in `PositionState[w,u]` and the move
   stream. (§6 item 3; answer §sub-question 3.)

### 3. Logical architecture (the lens)

- **Definitions before use.** Primitives (wallet, move, transaction, conservation, `net_qty`),
  the three-map discipline, the `markValue` dimension bridge, the conserved field `ac`, the atomic
  `StateDelta`, and `target` are all established in §1–§4.1 before the settlement mechanism uses
  them. The `Stage` algebraic type is given at first relevant use (Listing). The summary table (§2)
  is an explicit forward-looking roadmap, walked in event order thereafter; not a violation.
- **Each step follows from what precedes.** Every pre-settle state is the recorded consequence of
  the prior event (e.g. T2's `ac(A) = −51000 + 20600` uses the day-1 reset). The chain is unbroken.
- **Explicit quantifiers.** Conservation is stated "for every u"; the holder fan-out ranges over
  "the current holders"; the vacuous case is named explicitly. The proof
  `Σ Δac = −S·m·Σnetq − Σac = 0` carries its quantifier and its inductive base.
- **No handwaving.** The identity `VM(w) = −Δac(w)` is exact, making "VM zero-sum = ac
  conservation" a derived equality, not a slogan. The induction lifting per-event conservation to
  the global invariant, and the replay fold law, are one-line standard arguments correctly cited
  (C2, C1(b)) — appropriately brief, not skipped.

### 4. Dimensional and type discipline

`Price` carries no addition; the sole multiplication `markValue : Qty × Price × m → Cash` is the
only bridge, and `VM = netq·S·m + ac` typechecks because both summands are `Cash`. This is sound
and load-bearing.

### 5. Edge cases and invariants

Positive-quantity boundary (`q>0`, with `q=0` and `q<0` both reasoned out), monotone carrier
(`Some`-flat ≠ `None`, retained at zero after Close), absorbing `EXPIRED` (rank guard insufficient
for re-expiry since `2<2` is false, hence an explicit absorbing test; Close alone admissible),
no-op re-settle at a fixed mark, and `first_touch_date` as derived-not-stored — all stated with
their justifications. The two documents do not contradict each other on any figure, rule, or claim.

## Gaps

None blocking. The documents are correct, complete, minimal, and internally consistent; the three
anchor questions are answered without evasion, and conservation is shown — by construction and by
the worked figures — at every event.

## Minor, non-blocking observations (not gaps)

- `VM` appears in §1 (line ~103) to motivate the type bridge before its formal definition in §2 /
  §5. The abstract and inline formula make the meaning unambiguous; acceptable as contextual
  forward reference.
- The physical-settlement variant (§9) is described qualitatively rather than worked numerically.
  Justified: the example is cash-settled and the figures are explicitly unchanged by the variant.
