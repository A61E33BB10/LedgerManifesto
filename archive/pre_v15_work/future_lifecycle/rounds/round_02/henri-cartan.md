# Round 2 — henri-cartan

Lens: definitions before use; each step follows from what precedes; explicit
quantifiers; no handwaving.

Targets reviewed:
- `/home/renaud/Ledger/future_lifecycle/FutureLifeCycle.tex`
- `/home/renaud/Ledger/future_lifecycle/settlement_answer.md`

## Verdict

**NOT-YET** — two located, actionable gaps, both squarely within this lens. The
core is sound: every numeric figure is correct, conservation holds at each event
where it is shown, and the three anchor sub-questions are answered without
evasion. The gaps are an unmet self-stated convention and a missing definition.

## What I verified (independently recomputed, all confirmed)

Per-event, with m = 50, wallets A, B, C, CH:

| Event | ΣΔnet_qty | ΣΔac | ΣVM |
|---|---|---|---|
| Listing | 0 (empty sum, C9) | 0 (empty) | 0 (empty) |
| T1 (A buys 10 from B @100) | 0 | 0 | 0 (no cash leg) |
| Settle d1 (S=102) | 0 | 0 | 0 |
| T2 (C buys 4 from A @103) | 0 | 0 | 0 (no cash leg) |
| Settle d2 (S=101) | 0 | 0 | 0 |
| T3 (B buys 4 from C @101) | 0 | 0 | 0 (no cash leg) |
| Expiry (S=105) | 0 | 0 | 0 |
| Close | 0 | 0 | 0 (no cash) |

- Day-2 anchor figures: VM(A)=−100, VM(B)=+500, VM(C)=−400 — confirmed; the
  naive shared-price formula gives −300 for A, and the +200 intraday gain
  (4 contracts sold one point above the prior mark) reconciles to −100. The
  argument that per-wallet `ac` is load-bearing is correct and non-trivial.
- The centrepiece identity VM(w) = −Δac(w) = net_qty·S·m + ac holds exactly from
  the reset target = −net_qty·S·m; hence ΣVM = −ΣΔac, so VM zero-sum *is* `ac`
  conservation. Sound, not asserted.
- Cumulative VM per wallet (A +2100, B −1700, C −400, CH 0; sum 0) equals
  economic P&L computed independently. Confirmed.
- Monotone/absorbing stage logic: the observation that the rank guard is too weak
  at EXPIRED (2 < 2 is false) and an explicit absorbing test is required, with
  Close admissible because it carries no stage write, is correct and well-argued.

The three anchor sub-questions are each answered directly in both documents
(`.tex` §`sec:anchor` enumerated 1–3; `settlement_answer.md` §§1–3). No evasion.

## Gaps

### Gap 1 — The stated "three sums per event" convention is not met at the two intraday trades

`FutureLifeCycle.tex` lines 144–146 commit explicitly: "Each event is one
`StateDelta`; each shows the three conservation sums ΣΔnet_qty, ΣΔac, ΣVM."

- T2 (line 250) shows only ΣΔnet_qty = 0 and ΣΔac = 0.
- T3 (line 305) shows only ΣΔnet_qty = 0 and ΣΔac = 0.

The cash/VM sum is omitted at both. It is genuinely vacuous — a trade moves no
variation-margin cash (consistent with T1's "Cash. None") — but the document
states the third sum is shown at *every* event, and T1 (line 192) honours this by
writing "ΣVM = 0". Under the review criterion "conservation shown at every event,"
the cash dimension must be exhibited (even as zero) at T2 and T3, or the
convention on lines 144–146 weakened. As written, a stated invariant is broken at
two of the eight events.

Fix (one line each): append to T2 and T3 "ΣVM = 0 (a trade moves no
variation-margin cash)."

### Gap 2 — `net_qty` is used pervasively but never defined as the signed holding

`FutureLifeCycle.tex` §1 (lines 41–42) defines only the signed holding `h(w,u)`.
The symbol `net_qty` (the `\netq` macro) is then introduced in the table header
(line 129) and used in every formula and conservation sum thereafter, but is
never equated to `h(w,u)`. The identification net_qty(w,u) = h(w,u) is left for
the reader to infer from the move semantics. This is a definitions-before-use
defect: the carrier of the quantity conservation law (ΣΔnet_qty = 0) is never
formally defined.

Fix (one sentence in §1): "Write net_qty(w,u) := h(w,u) for the signed quantity
of unit u held by wallet w; the move pattern acts on it as above."

## Not gaps (checked, sound)

- Close with Δnet_qty(CH) = 0: contracts return to CH, but since holder net
  positions already sum to zero, CH's residual is zero; −6 + 6 + 0 = 0 conserves.
  Internally consistent.
- Vacuous settlement over a flat/absent holder (C at d1, expiry): VM = 0,
  Δac = 0; empty/zero sums (C9). Correct.
- Cross-document consistency between `.tex` and `settlement_answer.md`: figures,
  identity, and escalations E1/E2 agree.
- Citations to addendum constraints (C1–C12) are acceptable for a companion
  document; self-containment is not compromised for the lifecycle argument
  itself.
