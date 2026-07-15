# Round 1 Scorecard — chris-lattner

**Target:** `future_lifecycle/FutureLifeCycle.tex`, `future_lifecycle/settlement_answer.md`
**Lens:** The lifecycle reads as one clean progression; nothing present that does not serve it.
**Verdict: NOT-YET**

---

## What I checked, and what holds

I walked every event in the table and recomputed conservation independently. The arithmetic is
correct end to end, and the narrative is genuinely a single progression — Listing → T1 → Settle d1
→ T2 → Settle d2 → T3 → Expiry → Close — with each step mapping to exactly one table row and one
`StateDelta`. Nothing in the body is ornamental: the dimension-bridge paragraph earns its place
(it is the type argument that makes `VM = net_qty·S·m + ac` typecheck), the load-bearing subtlety
on day 2 is the heart of the design, and the post-expiry/idempotence invariants close the state
machine. This is good architecture: the example *is* the proof, and the prose only names the
mechanism. Acknowledged.

Conservation, recomputed per event:

- T1: Σ∆net = +10−10 = 0; Σ∆ac = −50000+50000 = 0. ✓
- Settle d1 (S=102): VM = (+1000,−1000,0), Σ = 0; ac → (−51000,+51000,0), Σ∆ac = 0. ✓
- T2 (@103): Σ∆net = +4−4 = 0; ac(A) = −51000+20600 = −30400; Σ∆ac = 0. ✓
- Settle d2 (S=101): VM = (−100,+500,−400), Σ = 0; ac → (−30300,+50500,−20200), Σ∆ac = 0. ✓
- T3 (@101): Σ∆net = 0; ac → (−30300,+30300,0), Σ∆ac = 0. ✓
- Expiry (S=105): VM = (+1200,−1200,0), Σ = 0; ac → (−31500,+31500,0), Σ∆ac = 0. ✓
- Closing identity: cumVM A=+2100, B=−1700, C=−400, CH=0, Σ=0, each equal to economic P&L. ✓

The three anchor sub-questions are answered without evasion in both documents (`§ anchor`
"The three answers, stated plainly", and `settlement_answer.md` §§1–3): settlement is a state
update split shared/per-wallet; it is one atomic event that fans out (not a price-derived
consequence), forced by the cash leg; price lives only in shared `UnitStatus`, its consequence
only in per-wallet `PositionState`. `settlement_answer.md` is clean and internally consistent —
it does not overclaim and does not mention a Close step.

So the two hard gates — three sub-questions, conservation per event — are met *for every event
except the Close*. The NOT-YET rests on the Close step alone.

---

## Gaps

### G1 (blocking) — The "clean progression" ends on a step the reference does not contain, and the abstract asserts otherwise

The abstract states, flatly: *"The reference implementation is `FutureLifeCycle.hs`; this document
is its prose."* That claim is false at the final step. I confirmed against source:
`FutureLifeCycle.hs` `main` (lines 581–658) stops at the `Expire` event and leaves
`net_qty=(6,−6,0)`, `ac=(−31500,+31500,0)`. There is no `Close` event in the `Event` type, no
flatten-against-CH, no delivery-versus-payment. The `.tex` table (line 139) and
`WORKED_EXAMPLE_FUTURE.md` (line 21) both carry a `Close` row to `(0,0,0)`.

The document does flag this in `§ Escalations` under "Source divergence" — honestly and with the
right resolution options. But an escalation does not make the deliverable complete: the abstract
still asserts a provenance ("this document is its prose") that the document's own tail retracts.
Under the project's first commitment — *a claim is proved, not asserted* — an abstract that claims
something the body contradicts is a correctness defect, not merely an open question. The lifecycle
does not in fact read as *one* clean progression: its terminus is contested between two artifacts
both presented as authoritative.

Note also that `WORKED_EXAMPLE_FUTURE.md` brands itself "Verified ... conservation-checked ...
verified by a decimal check after **every** step," yet the reference that supposedly verifies it
does not produce the Close row. The "verified" label does not cover the step the `.tex` leans on
for its clean ending.

**Location:** `FutureLifeCycle.tex` abstract (lines 30–34, the "this document is its prose"
clause) and the `Close` row (line 139); `§ Escalations` "Source divergence" (lines 402–410);
cross-checked against `FutureLifeCycle.hs` `main` lines 634–658 and `WORKED_EXAMPLE_FUTURE.md`
line 21.

**Actionable fix (pick one and make all three artifacts agree):**
1. Add a `Close` event to `FutureLifeCycle.hs` (flatten-against-CH for cash, or DvP for physical)
   so the reference reproduces the `(0,0,0)` terminus — then the abstract's claim becomes true; or
2. Remove the `Close` row from the `.tex` table and `WORKED_EXAMPLE_FUTURE.md`, end the worked
   life at Expiry with `(6,−6,0)` retained, and describe Close-out only as prose in
   `§ Expiry`. Either way, soften the abstract so it does not assert prose-equality with the `.hs`
   beyond what the `.hs` actually computes.

### G2 (minor, same locus) — Conservation at Close is asserted, not shown

Every prior event carries an explicit `Conservation: Σ∆net = 0, Σ∆ac = 0, ΣVM = 0` line. The Close
does not. The "Cash settlement" paragraph (lines 322–327) says only "conservation holding on both
fields" and gives `∆ac(A)=+31500, ∆ac(B)=−31500`. It never shows the `net_qty` sum, and — more
importantly — it leaves CH's leg implicit: "A delivers 6, B covers 6 against the clearinghouse"
only conserves because CH is the conduit (∆net(A)=−6, ∆net(CH)=0, ∆net(B)=+6; ∆ac(CH)=0). The
gate is *conservation shown at every event*; the one event whose conservation is merely asserted is
the one event in dispute (G1). If the Close survives resolution, give it the same explicit three-sum
treatment as the others, with CH's leg written out.

**Location:** `FutureLifeCycle.tex` lines 322–327.

---

## Not gaps (so the record is clear)

- The physical-settlement variant paragraph (lines 329–335) is minimal and serves the progression
  as the alternative terminus; it is not extraneous.
- The vacuous-settlement-over-non-holder handling (C9) is correctly threaded and serves the model.
- `settlement_answer.md` is complete and consistent on its own terms; it carries no Close claim and
  needs no change for this lens.
