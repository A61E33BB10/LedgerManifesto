# Challenge Questions — `finops-architect` lens

Move-level, double-entry, penny-conservation lens. Each question either has a concrete answer
derivable from the primitives or exposes a genuine framework/§6 flaw worth escalating.

1. **The crystallise move at l.842 hardcodes `from:w_ref_cash, to:w_UB_cash, quantity:Perf_k`
   where `Perf` is signed, yet Def 2.3 requires `q>0`. For `Perf<0` the move is
   non-representable and for `Perf=0` it is an illegal `q=0` move — while the IRS contract at
   l.787 already emits `|Payment|` with direction-from-sign. Is this an internal inconsistency
   the spec must resolve by porting the l.787 pattern to all three settlement sites (l.842,
   l.915, l.937), and if not, what total function maps a signed `Perf` to a `q>0` move without
   it?**
   *Attacks:* representable illegal state. *Target:* §6 crystallise/TRS/periodic-settlement
   move definition.

2. **§6's Perf is `V_{t_k} − V_{t_{k-1}}` (l.826), but §4's own decomposition is
   `PnL = PnL_price + PnL_flow` (l.547) and l.1366 classifies subscriptions/redemptions as
   lifecycle events that move the book. On what basis does §6 crystallise a fee against a
   delta that includes the client's own contributed capital, and exactly which field
   (`subscription/redemption cursor`, A1 l.209) supplies `NetExternalFlows` so that
   `Perf = (V_{t_k} − Flows) − V_{t_{k-1}}`?**
   *Attacks:* conservation/accounting gap (capital vs return). *Target:* §6 Perf formula vs §4.

3. **A performance fee is asymmetric, floored at zero, and ratchets a high-water mark with no
   clawback; the entire economic content is `max(0, NAV_net − max(HWM, hurdle))`. §6's single
   signed `Perf → UB` move encodes none of this. Where in §6 + A1 is the HWM ratchet rule, the
   hurdle, and the loss-carryforward defined, and if nowhere, can §6 be called a
   managed-account workflow before the `fee_crystallise` handler body is specified and
   proved?**
   *Attacks:* hidden assumption / missing primitive. *Target:* fee engine absence (F-LEAD).

4. **The Reset step at l.848 reads and writes a baseline NAV, but the A1
   `PositionState[w,u_MA]` field table (hwm, hwm_date, entry_nav, accrued fees, breach flags,
   cursor, benchmark_nav) names no `last_reset_value`. Which of the three maps homes the reset
   baseline, who is its unique C11 writer, and is `V_{t_k}` in `baseline ← V_{t_k}` the pre- or
   post-crystallisation NAV — given that the pre-move reading claws performance back the next
   period?**
   *Attacks:* accounting gap / state home. *Target:* Reset baseline placement and timing.

5. **A1 l.433 declares `ac: float; balance: float; hwm: float` while the arithmetic primitive
   mandates fixed-precision decimal, not IEEE-754, with bit-identical outputs. Does the
   reference dataclass violate the binding primitive, and since an HWM ratchet computed in
   binary float silently loses pennies across resets, must these be `Decimal` even in
   illustrative code an implementer will copy?**
   *Attacks:* conformance gap / determinism boundary. *Target:* A1 reference dataclass types.

6. **Bankers' rounding at instruction cut means `Σ_k round(Perf_k) ≠ V_n − V_0` by accumulated
   dust. Where does the rounding residual live so that double-entry holds to the penny — must
   it remain in `w_ref` as a conserved un-crystallised remainder and be the named reconciling
   item between economic Perf and moved cash, or is it permitted to be dropped (and if dropped,
   which invariant absorbs the break)?**
   *Attacks:* conservation break / penny accounting. *Target:* rounding residual handling.

7. **Crystallisation moves cash out of `w_ref_cash` while the positions stay in-book (l.944),
   so `w_ref_cash` can go negative; by the primitive (briefing l.24) negative = legal
   obligation. What distinguishes a *funded obligation* from an *insolvent overdraft* at the
   crystallisation boundary, and for a CASS client-money wallet where non-negativity is
   mandatory, where is that refinement enforced — type, guard, or nowhere?**
   *Attacks:* representable illegal state / solvency. *Target:* sign semantics at crystallise.

8. **The briefing claims segregation holds "by algebra" (l.855), but conservation does not
   forbid a perfectly-conservative move whose source is in client A's partition and
   destination is in client B's. Is logical segregation (CASS 6 / MiFID 16(8)) therefore
   *necessary but not sufficient* from conservation alone, requiring an explicit C4
   capability/authorization guard, and must the §6 claim be re-stated as "conservation + C4
   capability scoping" rather than "segregation by algebra"?**
   *Attacks:* hidden assumption / overstated property. *Target:* §6 segregation claim.

9. **TRS settlement (l.915) and `ℒ_v` valuation must use the same price vector or unexplained
   PnL appears with no internal reconciliation path (P7 forbids any cross-ledger move). Is
   price consistency *bound* — same content-addressed price-snapshot id, verifiable by hash —
   or merely asserted in prose, and if asserted, is this the one place the "no internal break"
   guarantee can be silently void?**
   *Attacks:* determinism boundary / reconciliation gap. *Target:* TRS / `ℒ_v` price binding.

10. **`TR_k = (V^v_{t_k} − V^v_{t_{k-1}})/V^v_{t_{k-1}}` (l.887) divides by the prior virtual
    NAV and inverts sign when the virtual book is net short. What is the stated precondition
    `V^v_{t_{k-1}} > 0`, what handler enforces it, and what is the defined behaviour at a flat
    or wound-down virtual book where the denominator is zero?**
    *Attacks:* edge case / partial function. *Target:* TRS total-return ratio.

11. **`V_t` depends on a non-deterministic input `P_t` (l.510); for replay and P10
    path-independence the price vector must be a recorded, content-addressed snapshot rather
    than a live fetch. Is `P_t` a named, hash-pinned input to NAV, fee crystallisation, and the
    mandate guard alike — and absent that pinning, is P10 (PnL path-independence) actually
    achievable across replay?**
    *Attacks:* determinism boundary. *Target:* price input as recorded snapshot.

12. **Quantitative mandate guards are preconditions on move-generation (l.901), and the spec
    asserts "same wallet state + same trade ⇒ same accept/reject." For value-based limits
    (leverage, concentration-by-value) this is false: hold positions and double a price and the
    identical trade flips to reject. Must `P_t` be a named guard input, and how are *passive
    breaches* — a held position appreciating past a concentration cap with no move at all —
    detected, given a move-precondition never fires without a move?**
    *Attacks:* determinism boundary / edge case. *Target:* mandate-constraint guards.

13. **The crystallise move is instantaneous and final inside `ℒ`, but external cash settles
    T+1/T+2 and can fail; immutability forbids editing the original move. How is a settlement
    fail represented — a compensating reversing transaction that itself conserves — and where
    does the Trade→Affirmation→Confirmation→Netting→Settlement→Reconciliation lifecycle attach,
    given §6's projection models only the instantaneous internal move?**
    *Attacks:* accounting gap / boundary. *Target:* settlement finality vs internal finality.

14. **base + overlay is two `PositionState` rows (A1 l.217) each with its own HWM and
    performance fee, but `V^ref` is a single scalar. Splitting it into base-Perf and
    overlay-Perf for two separate performance fees needs an attribution rule the primitives do
    not supply. Is per-mandate fee therefore non-deterministic w.r.t. the move stream until a
    total allocation function is declared in `ProductTerms[u_MA]` and reconstructible from the
    stream — or must overlapping mandates be forced onto disjoint sub-partitions?**
    *Attacks:* accounting gap / determinism. *Target:* multi-mandate fee attribution.

15. **`u_MA` is a real unit (`w_manager=−1, w_client=+1`) and would enter `V_t = Σ w·P` (l.510)
    if priced; the client's economic exposure already *is* the underlying positions in
    `w_ref`. Is `P_t(u_MA) ≡ 0` a hard precondition (else NAV double-counts the wrapper), and
    is that precondition enforced structurally or left as prose — and separately, does the same
    real `u_MA` issuance move trigger an SFTR/EMIR reporting surface (A1-F5) that needs a
    `reportable` flag on `ProductTerms[u_MA]`?**
    *Attacks:* conservation break / conformance gap. *Target:* `u_MA` valuation precondition
    and reporting surface.

16. **Partial redemption at `t ≠ t_k` pays `pro_rata·(NAV_net − accrued_fees_to_date)` and
    leaves a retained zero/non-zero row, but does not re-strike the remaining holder's
    `entry_nav`/HWM basis. Without equalisation, does a partial redemption silently transfer
    fee burden between the redeeming and remaining capital, and where is the equalisation rule
    homed — `ProductTerms[u_MA]` methodology or undefined (a fee-fairness defect)?**
    *Attacks:* edge case / accounting fairness. *Target:* partial redemption / equalisation.
