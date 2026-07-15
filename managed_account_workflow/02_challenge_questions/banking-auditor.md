# Challenge Questions — banking-auditor lens

Fifteen questions attacking the managed-account workflow (Ledger §6 + Addendum A1) from the
balance-sheet / accrual-accounting / journal-entry-equivalence lens. Each is derived from the
primitives or an enforceable standard; none appeals to market practice as a source of rule.

1. **Accrued fee has no contra and is `"conserved": False`.** `accrued_mgmt_fee` and
   `accrued_perf_fee` are stored scalars in `PositionState[w_client, u_MA]` (A1 l.111, l.438), with
   `Σ_w Δf ≠ 0` for that field. A balance that grows with no equal-and-opposite leg is single-entry.
   §6.9 (l.944) claims every account balance is "a projection of the move stream" with "no separate
   account-level record to reconcile against." The accrued fee *is* a separate account-level record
   and is *not* a projection of the stream. What reconciles the stored accrued fee to an independent
   re-derivation, and against what — given there is, by construction, nothing for it to tie to?

2. **The SBL primitive already does this correctly — why is the fee modelled differently?** The SBL
   section carries an accrued-but-unpaid fee as the *price of a conserved loan unit* (lender `+1`,
   borrower `−1`, price = accrued fee, l.3630; settlement resets price to zero, `−216.71 + 216.71 = 0`,
   l.4201). That is conserved, double-entry, projected, substantiated. The Minimalism principle
   forbids adding a mechanism an existing primitive covers. On what principled ground does the
   managed-account fee accrue as a non-conserved scalar rather than as a priced fee-accrual unit?

3. **`Perf` is gross of capital flows.** The reset oracle is `Perf = V^ref_{t_k} − V^ref_{t_{k-1}}`
   (l.826), but §4 proves `PnL = PnL_price + PnL_flow` with `PnL_flow = Δw(USD) + ΣΔw(i)·P`
   (l.547–554). A fee struck on `Perf` as written is charged on *subscribed capital*, not return — a
   real, irreversible client-money cash-out. The fix-data (`entry_nav`, subscription/redemption cursor)
   exists (A1 l.208–209) but §6 never subtracts net external flows. Where, deterministically, are
   flows removed before the fee is struck, and what proves the corrected `Perf` replays identically?

4. **Multiple investors, one virtual ledger, no unitisation.** §6.7/§6.8 support "multiple investors
   ... referencing the same virtual ledger" with "performance proportional to their notional" (l.969),
   yet "NAV" exists only as per-client scalars (`entry_nav`, `nav_index`) — no NAV-per-share with
   units-outstanding. Investors subscribing at different NAVs into one strategy create the classic
   performance-fee equalisation problem. Which equalisation method (series accounting vs
   equalisation-credit) is specified, where does it live, and is its cross-investor allocation a
   deterministic, stream-reconstructible function?

5. **A management fee accrues on losses; a performance fee floors at zero — one signed move cannot
   encode both.** A single fixed-direction crystallisation move (l.834) is already a partial function
   for `Perf < 0`. On top of that: management fee is an AUM charge that accrues regardless of sign,
   while performance fee is HWM-gated and never reverses below the high-water mark. Conflating "PnL
   settlement" (genuinely sign-flipping) with "fee crystallisation" (floored, gated) mis-signs cash.
   How does the workflow represent the loss case without making the loss-asymmetric fee an illegal /
   unrepresentable state?

6. **No accrual handler exists between resets — interim cut-off fails.** C11 tags `hwm →
   fee_crystallise` (A1 l.145): the only handler that touches HWM/fee fires *at reset `t_k`*. No
   handler is tagged to accrue the fee continuously. At an IAS 34 interim reporting date that is not a
   reset date, the accrued mgmt/perf fee is therefore stale or zero, and the interim balance sheet
   omits the accrual. What handler accrues the fee at an arbitrary reporting date, and how is its
   cadence kept distinct from the crystallise handler without violating the C11 single-mutator tag?

7. **One net move is not a journal entry.** Crystallisation / periodic settlement / TRS each emit one
   net cash move (l.834, l.910, l.937). A correct reset is three economically distinct postings: PnL
   settlement, management-fee crystallisation, performance-fee crystallisation. The single net move
   destroys the gross legs that IFRS 15 revenue recognition and EMIR VALU/MARU reporting require. Why
   is the reset not emitted as a multi-move `SETTLEMENT` + `ACCOUNTING` transaction (the l.1814 pattern
   the framework already uses), netting only at the settlement-instruction boundary?

8. **A wallet debit is not a chart-of-accounts posting.** A move into `w_UB_cash` is, in GL terms,
   ambiguously a settlement of an intercompany payable, fee income, or a return of capital — three
   different statutory postings behind one move. The ledger carries the cash leg only; classification
   is out of scope (§4 scope note). What in the move stream lets an auditor distinguish fee income from
   return of capital from PnL settlement, deterministically, without an out-of-scope accounting overlay?

9. **`u_MA` must carry no price, or exposure is double-counted.** The mandate unit `u_MA` is held
   `w_manager(u_MA) = −1`, `w_client(u_MA) = +1` (briefing §4). If `P_t(u_MA)` is anything but
   undefined/zero, it enters `V_t = Σ w·P` alongside the underlying positions and the client's exposure
   is counted twice — in valuation and in any RWA/leverage projection. Where is `P_t(u_MA) ≡ 0`
   asserted and enforced, and what prevents a priced fee-accrual value (which *must* be priced) from
   leaking onto the same memo unit?

10. **HWM behaviour on partial redemption is unspecified.** When a single-beneficiary client partially
    redeems, the high-water mark is a per-client *value* scalar (A1 l.106). If the HWM is not scaled
    down in proportion to the redeemed fraction, the next performance fee is struck against an inflated
    threshold (under-charge); if it is naively reset, prior loss-carryforward is lost (over-charge). C11
    tags only `hwm → fee_crystallise`, not a redemption handler. Which handler adjusts the HWM on
    subscription/redemption, and what proves the adjustment is conservation-preserving and replayable?

11. **The benchmark level is an unattested feed that drives real fee revenue.** Relative performance
    uses `benchmark_nav_at_inception` (A1 l.210) and the current level from `UnitStatus[u_bench]`
    (l.211). A wrong benchmark level mis-charges a real client-money performance fee, yet the feed has
    no independent price verification governance, and total-return vs price-return basis and benchmark
    corporate-action/rebalancing adjustments are unspecified. Why does a direct input to fee revenue
    carry weaker attestation than `P_t`, and where is the benchmark basis pinned so the fee is auditable?

12. **No clawback row exists for a crystallised performance fee.** Once a performance fee crystallises
    into a cash move out of client money, subsequent underperformance is handled only by the HWM gate
    suppressing future fees — there is no negative entry. If a fee is later found to have been
    crystallised on an erroneous price or benchmark level (revaluation after a stale `P_t`), what is the
    representable correction? Is a negative/clawback crystallisation a legal move in the model, or is
    an over-charged-then-uncorrectable fee a representable illegal *outcome*?

13. **Multi-mandate fee base vs the C4 cross-read prohibition.** A base + overlay on one wallet is two
    rows `(w_client, u_MA,base)` and `(w_client, u_MA,overlay)` (briefing §4), and C4 forbids
    cross-`(w, u_MA)` overlay reads. A management fee on "net NAV" needs the wallet's *aggregate* value,
    which spans both mandates and all underlying positions. How does the fee-move-generation function
    compute its base without performing a forbidden cross-`(w, u_MA)` read, and which row owns the
    shared underlying positions for fee purposes?

14. **Fractional-fee rounding residue and conservation.** Fees are computed at full precision but
    instructions use bankers' rounding "only at instruction generation" (briefing §1). A management fee
    of, say, a fraction of a cent rounds at the cash-move boundary. Conservation (P1) requires
    `src -= q; dst += q` with identical `q`. Where does the rounding residue between the accrued
    full-precision fee and the rounded cash move go — does it accumulate in the (non-conserved) accrued
    scalar, silently breaking the tie between accrual and settlement, and is that residue itself
    conserved?

15. **Crystallisation can drive a cash wallet negative.** The crystallise step emits `w_ref_cash →
    w_UB_cash` for the fee/PnL (l.834). If `w_ref` holds appreciated positions but insufficient *cash*,
    the move makes `w_ref_cash` negative — an overdraft / financing position. A negative cash balance is
    representable (wallets are signed, briefing §1) but is, in accounting terms, a borrowing that must be
    presented gross (IAS 32, no offset without legal right). Is a fee/PnL crystallisation against an
    insufficient cash balance a guarded precondition (reject, no moves) or a silently representable
    overdraft, and if the latter, what discloses the resulting financing liability?
