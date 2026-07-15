# KARPATHY — FutureLifeCycle review, Round 1

Lens: each lifecycle step readable in one pass; linear flow; no leap of faith. The three
anchor sub-questions answered without evasion; conservation shown at every event.

Verdict: **NOT-YET**

---

## What I did

I did not trust the table. I re-derived every figure from the two stated rules
(trade: `ac += -Δ·p·m`; settle: `VM = net·S·m + ac`, then `ac ← -net·S·m`) and checked
the three conservation sums at each event by hand. I then read the named reference
`FutureLifeCycle.hs` and `WORKED_EXAMPLE_FUTURE.md` to test the document's fidelity claims.

## Arithmetic: every figure reproduces (no leap of faith on the numbers)

| Event | net (A,B,C) | ac (A,B,C) | VM (A,B,C) | Σnet | Σac | ΣVM |
|---|---|---|---|---|---|---|
| T1 | (10,-10,0) | (-50000,+50000,0) | — | 0 | 0 | — |
| Settle d1 (102) | (10,-10,0) | (-51000,+51000,0) | (+1000,-1000,0) | 0 | 0 | 0 |
| T2 (@103) | (6,-10,4) | (-30400,+51000,-20600) | — | 0 | 0 | — |
| Settle d2 (101) | (6,-10,4) | (-30300,+50500,-20200) | (-100,+500,-400) | 0 | 0 | 0 |
| T3 (@101) | (6,-6,0) | (-30300,+30300,0) | — | 0 | 0 | — |
| Expiry (105) | (6,-6,0) | (-31500,+31500,0) | (+1200,-1200,0) | 0 | 0 | 0 |
| Close | (0,0,0) | (0,0,0) | — | 0 | 0 | — |

Closing identity verified both ways: cumulative VM (A=+2100, B=-1700, C=-400, CH=0, sum 0)
equals economic P&L computed from prices. The load-bearing -100-vs-naive--300 subtlety is
correct and is *derived*, not asserted. This is exactly the "build it yourself to believe it"
standard, and the numbers pass.

## Anchor sub-questions: answered without evasion

All three are answered directly, twice (settlement_answer.md §§1-3 and FutureLifeCycle.tex
§anchor "The three answers, stated plainly"). Settlement = atomic hybrid `StateDelta`; shared
price write on `UnitStatus`, per-holder fan-out (ac reset + VM cash) on `PositionState`; one
event that fans out, forced by the cash leg, not a derived consequence; price only shared,
consequence only per-wallet. No evasion. The E1/E2 escalations are recorded, not buried.

## Conservation shown at every event: yes (one polish noted below)

Each event carries its sums. Listing is vacuous (empty sum, C9). Trades show Σnet, Σac.
Settlements show Σac, ΣVM. Close shows conservation on net and ac (no cash leg, so no ΣVM).
This satisfies "shown, not asserted."

---

## Gaps (located, actionable) — why NOT-YET

### G1 (blocking) — The named reference does not reproduce the worked example's final state

The document's own abstract makes two fidelity claims that cannot both hold:
"runs the whole life with figures that reproduce `WORKED_EXAMPLE_FUTURE.md` exactly"
(tex lines 31-33) and "The reference implementation is `FutureLifeCycle.hs`" (tex line 33).

- `WORKED_EXAMPLE_FUTURE.md` line 21 and FutureLifeCycle.tex line 139 carry a **Close** row
  flattening to `net=(0,0,0)`, `ac=(0,0,0)`.
- `FutureLifeCycle.hs` `main` stops at `Expire` (l6, lines 634-642) and leaves
  `net=(6,-6,0)`, `ac=(-31500,+31500,0)`. There is no Close event: the `Event` type
  (lines 256-260) has only `Trade | SettleVM | Expire`, so the Close is **not expressible**
  in the reference at all.

The document admits this honestly in §Escalations "Source divergence" (tex lines 402-410).
But an admitted, unresolved contradiction between the two artifacts under review is precisely
an incompleteness — a reader who runs the reference sees a different ending than the prose.
This is a leap of faith the reader cannot discharge.

Actionable resolution (pick one, then make both abstract claims simultaneously true):
- Add a `Close` event to `FutureLifeCycle.hs` — a flatten-against-CH trade at the final mark
  (Δnet(A)=-6, Δnet(B)=+6 at S=105, ac→0, zero cash), or the DvP variant — and run it in
  `main`; or
- Remove the Close row from FutureLifeCycle.tex (line 139) and WORKED_EXAMPLE_FUTURE.md
  (line 21), stopping the narrative at Expiry, and drop the §Expiry "Close" prose
  (tex lines 322-327).

### G2 (blocking) — The two documents contradict each other on the stage at settlement

Read in one pass, the pair disagrees:
- settlement_answer.md line 18: "`lifecycle_stage` unchanged here; it changes only at expiry."
- FutureLifeCycle.tex §settle-mech line 213: "the stage becomes `Active (Just (Settlement S
  d))`."
- FutureLifeCycle.hs line 406: `SettleVM` emits `Just (Active (Just (Settlement s d)))` —
  i.e. it writes the `Stage` value on **every** settle.

Because the .tex and .hs **fuse** the settlement mark into the `Stage` ADT (tex §Listing
lines 162-165; hs lines 171-176), the `Stage` value genuinely changes at each settle
(`Active Nothing → Active (Just ...)`, then mark updates). So settlement_answer.md's flat
"lifecycle_stage unchanged" is false against the model the other two documents implement.

Actionable: reword settlement_answer.md to the fused model — "the coarse stage
REGISTERED/ACTIVE/EXPIRED is unchanged at settle; the settlement mark embedded in the stage
updates" — or drop the "lifecycle_stage unchanged" clause entirely. As written, a reader
holding both documents must paper over the gap.

### G3 (minor) — "routed through CH" with no CH leg in the model

The prose repeatedly says VM cash is "routed through CH" (tex lines 113-114; settlement
rule). But the fan-out (hs `settlementFanout`, lines 376-381) emits legs only over holders;
CH never receives a row and `cashOf CH = 0` throughout. The .hs E1 signal (lines 515-527)
explains CH's leg is the residual, zero here because holder legs balance — but the .tex and
WORKED_EXAMPLE_FUTURE.md do not say this where they say "routed through CH."

Actionable: one clause in FutureLifeCycle.tex §settle-mech noting CH's leg is the residual,
zero in this example because the holder legs already sum to zero, so no CH cash row appears.
Prevents a reader from expecting a CH cash entry that never materialises.

### G4 (polish) — Σnet not restated at the day-2 settle

FutureLifeCycle.tex §anchor (Settle d2) shows ΣVM and Σac but not Σnet (the day-1 settle did
state "Σ∆net=0 (no quantity moved)"). A settle moves no quantity, so it is trivially zero,
but "conservation shown at every event" reads cleaner if Σnet=0 is restated at d2 and at
Expiry. Non-blocking.

---

## Bottom line

The mechanism is sound, the arithmetic is exact, the anchor questions are answered head-on,
and conservation is genuinely shown rather than asserted — this is good first-principles work.
But CORRECT-AND-COMPLETE requires the artifacts to agree. They do not: the reference cannot
even express the worked example's ending (G1), and the two prose documents contradict each
other on the settle-time stage (G2). Resolve G1 and G2 and this passes.
