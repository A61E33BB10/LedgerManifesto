# §6 Managed-Account Workflow — Challenge Questions (correctness-architect)

Fifteen questions attacking the workflow from the correctness lens: hidden assumptions,
edge cases, conservation breaks, representable illegal states, determinism boundaries,
accounting and conformance gaps. Each is derived from the primitives, not from practice.

1. **The `Perf = 0` skip is itself a state transition.** The signed-move fix rejects `q=0`
   and "skips" emission. But the reset still must Reset the baseline and advance the
   idempotency cursor `(w_client, u_MA, t_k)`. Is a zero-performance reset a *no-op*
   `StateDelta` (cursor does not advance — reset becomes re-fireable) or an *empty-move*
   `StateDelta` (cursor advances, zero moves)? One of these is wrong; which, and what
   forbids the other from being representable?

2. **What types a move as an external flow versus a trade?** BLOCKER 2's fix
   `Perf = (V_{t_k} − NetExternalFlows) − V_{t_{k−1}}` presumes every move touching
   `w_ref_cash` is classifiable as flow or not-flow. Subscription, redemption, fee
   crystallisation, and an FX trade all debit/credit `w_ref_cash`. Is the flow/non-flow
   partition a *typed property of `source`/`metadata`* (provable, total) or a convention
   applied at reset time? If the latter, a misclassified move silently contaminates `Perf`
   and the contamination is conserving — undetectable by P1.

3. **Back-dated price correction desynchronises the stored baseline.** If the baseline is
   the C11 scalar `B_k = V_{t_k} − Perf_k` and a price `P_{t_{k−1}}(u)` is corrected after
   `t_k` already settled, `B_k` is now stale against the corrected NAV history. What is the
   defined compensating mechanism — a reversing reset, a recomputed fold, or a correction
   move — and does it preserve idempotency of the *original* reset's cursor entry? Without
   a stated correction model, replay from corrected prices and the stored scalar diverge.

4. **Mandate novation can mint an illegal `u_MA` support.** The `{+1,−1}` cardinality
   refinement holds at issuance. When the client transfers the mandate to a successor
   client (assignment/novation), what move pattern executes? `w_client(u_MA) −= 1;
   w_successor(u_MA) += 1` preserves it — but nothing in the primitives *forbids* a
   manager re-issuing `w_manager(u_MA) −= 1; w_newclient(u_MA) += 1` while the original
   `+1` still stands, yielding support `{+1,+1,−2}`. What enforces single-holdership as an
   invariant, not just an issuance-time accident?

5. **Where does accrued-but-uncrystallised fee live in the balance sheet?** `u_MA` is
   typed non-valued (excluded from `V_t`). Management fee accrues continuously into
   `PositionState[w_client,u_MA].accrued_fee` but the cash move to `w_manager` happens only
   at `t_k`. Between resets, the accrued fee is a real liability of the client and a real
   asset of the manager, yet it is in neither `V_t` (no unit holds it) nor the move stream
   (no move yet). Does §6.9 balance-sheet substantiation — "the move stream is the
   evidence" — therefore *understate* the client's obligations between resets, and is that
   a conformance gap against fair presentation?

6. **The rounding residue needs a conserved counterparty.** Carrying `Σ_k round(Perf_k) −
   Σ_k Perf_k` forward "in `w_ref`" is a USD quantity. USD conservation demands the
   opposite sign sit somewhere. If `w_UB` received `round(Perf_k)` and `w_ref` retained the
   dust, the move conserved — fine. But then "Reset baseline to post-settlement value" must
   use `V_{t_k} − round(Perf_k)`, not `V_{t_k} − Perf_k`, or the residue is *both* retained
   in the book *and* removed from the baseline (double-counted). Which exact quantity does
   the baseline subtract, and is the residue a typed field or does it silently re-enter the
   next period's `Perf`?

7. **Observe reads positions and prices "at `t_k`" — but `t_k` is a timestamp, and ties are
   broken by total order.** A trade transaction stamped exactly `t_k` exists in the total
   order either before or after the reset's Observe. Which? If the reset Observe is not
   pinned in the total order relative to same-timestamp trades, `V^ref_{t_k}` is ambiguous
   and `Perf` is non-deterministic on replay despite every input being recorded. What rule
   places the reset transaction in the total order, and is it stated or assumed?

8. **Overlapping multi-mandate is a representable but unattributable state.** Two rows
   `(w_client, u_MA,base)` and `(w_client, u_MA,overlay)` each carry their own HWM/fees.
   When base and overlay act on the *same* underlying positions, the per-mandate `Perf`
   split is a counterfactual, not a projection of the move stream — not state-sufficient.
   Does the workflow *forbid* overlapping mandates (disjoint tagged sub-partitions
   required), or does it admit the overlapping configuration and then compute a fee from a
   number that is not derivable from recorded state? If admitted, two managers are paid from
   a split that no replay can reproduce.

9. **No type distinguishes "may be negative" from "must be ≥ 0".** A derivative short
   legitimately drives `w(u) < 0`; segregated client cash (CASS 6) must never go negative.
   Both are the same `Wallet → ℝ` type. A crystallisation or management-fee move that drives
   `w_ref_cash` (client money) negative is *representable and conserving* yet regulatorily
   illegal. What carries the non-negativity refinement, and at which wallets — and if it is
   "enforced at the settlement boundary," how does the ledger evidence a constraint it
   cannot represent in its own type?

10. **Crash between the cash move and the cursor advance.** The reset's `StateDelta` (C3)
    must apply Observe + Crystallise + Reset + cursor-advance atomically. If atomicity is
    only over the *three maps* and the idempotency cursor is one of those map writes, then a
    re-fire is deduped — good. But if the cash move (a `ℒ_r` Move/Transaction) and the cursor
    advance (a `PositionState` write) are two transactions, a crash between them double-pays
    on replay. Is the cash settlement move *inside* the same atomic `StateDelta` as the
    cursor, or does P5/P6 idempotency rest on an ordering assumption the schema does not
    enforce?

11. **"Same price vector" for `ℒ_v` and `ℒ_r` — shared object or two reads?** Price
    consistency (l.922) is stated as a requirement on the TRS settlement. `ℒ_v` values
    continuously to produce NAV; `ℒ_r` settles only at `t_k`. Is the snapshot the TRS reads
    at `t_k` the *identical content-addressed object* that produced `ℒ_v`'s NAV at `t_k`
    (sharing one value, verifiable by hash), or two reads of "the same source" reconciled
    after the fact? Only the former makes price consistency hold by construction; the latter
    admits unexplained PnL the framework explicitly warns against.

12. **A passive breach leaves an illegal state persistent and representable.** A
    concentration/leverage limit breached by *appreciation* (no move) never trips an
    admission guard. The mandate text in `ProductTerms[u_MA]` declares the limit, yet the
    over-limit position sits in `PositionState` indefinitely. Does the workflow require the
    valuation sweep to *emit a forced-de-risk move* (restoring the invariant) or merely *set
    a breach flag*? If only a flag, the ledger durably represents a state its own mandate
    declares illegal — is that the intended boundary of "necessary conditions only," and is
    it conformant?

13. **Management fee has no funding precondition.** Performance fee is gated (`≥0`, above
    HWM). Management fee accrues "including on losing periods" and crystallises to
    `w_manager`. On a drawn-down book this move can drive client cash negative to pay the
    manager — a representable insolvent overdraft that conservation permits. Does the
    settlement-solvency property (§B) apply identically to the management-fee boundary, and
    if the book cannot fund it, is the fee an `obligation` (deferred, accrued) or does it
    settle into a negative client-cash row?

14. **A benchmark decline can unlock a performance fee on a flat NAV.** The perf-fee gate is
    NAV above HWM *and* above the benchmark hurdle. The hurdle level derives from the
    benchmark oracle. If the benchmark *falls*, the hurdle falls, and a flat NAV that was
    below-hurdle last period becomes above-hurdle this period — charging the client a
    performance fee for the benchmark's underperformance, not the manager's outperformance.
    Is the HWM-`max` monotonicity sufficient to forbid this, or does the hurdle interact with
    HWM in a way that lets a benchmark drop mint a fee from client money? State the exact
    gate predicate.

15. **The TRS observes `ℒ_v` across the ledger boundary — is that read capability-legal?**
    P7 forbids *moves* crossing `ℒ_v ↔ ℒ_r`, and the phantom-type fix enforces it. But the
    TRS contract in `ℒ_r` *reads* `ℒ_v`'s MTM to compute `TR_k`. C4 forbids cross-`(w,u_MA)`
    overlay reads and routes strategy exports only through `UnitStatus`. Is a cross-ledger
    read a sanctioned capability or a violation of the same discipline that C4 enforces
    within a ledger? If sanctioned, what is the typed read channel (a `UnitStatus`-style
    export from `ℒ_v`), and does it carry the snapshot id needed to satisfy question 11?
