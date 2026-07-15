# chris-lattner — States.tex, Round 15

**Verdict: OBVIOUS**

## What the document claims, and whether it lands

The question is "where does a unit's state live." The answer is delivered as a
mechanism, not an assertion: two placement questions (does the fact depend on the
holder? who authors its record?) generate a 2×2; three cells are occupied; the
three occupied cells become three kinds of state held in two maps:

```
ledgerUnit : Map UnitId            (ProductTerms, UnitStatus)   -- Terms + Status, co-present
ledgerPS   : Map (WalletId,UnitId) PositionState               -- Position
```

A competent engineer who has never seen this problem can follow it end to end. The
spine is clean: Question → Answer (the placement) → Why Three (each cell justified
by one concrete reason) → Construction (the Haskell, each declaration forced by the
one before) → Why It Is Right (conservation and replay proved). Every section
discharges exactly the obligation the Question set out: "the placement makes
conservation and deterministic replay attainable; a sealed single-writer discipline
and the purity and totality of replay make them hold by construction."

## Does everything serve the answer?

Yes. I checked the items most at risk of being decoration:

- **psHwm (high-water mark).** Always zero in this file (its writer, the valuation
  event, is out of scope) and read by no function. It still earns its place: it is
  the home the managed-account objection demands. The objection ("managed accounts
  need a wallet-keyed high-water mark") is rebutted by reifying the mandate as a
  unit, which only works if PositionState already carries a non-conserved field.
  psHwm is that field. Its always-zero-ness is disclosed, not hidden.
- **Conservation and replay (§5).** Not tangents — the Question pre-commits to them
  as the properties the placement enables. The seal (withheld constructor + field
  selectors) is the placement decision that makes single-writer conservation hold;
  §5 closes the induction from `emptyLedger`. They belong.
- **Benchmark contrast (level vs identity), managed account, self-move/zero-move.**
  Each pre-empts a specific confusion the abstraction invites (category-vs-instance,
  the obvious counterexample to the empty cell, what "held" means). None idle.

The two questions, three homes, two maps structure is the minimum basis: I could
not find a primitive that an existing one already covers, nor a cell, map, or
newtype I would cut.

## Near-overlaps I weighed, and why they do not block

I held the "nothing said twice" bar hard against the claim→proof structure:

1. **Conservation mechanism** appears in the PositionState construction paragraph
   (lines 224–227, "a move writes two cancelling legs ... so it conserves ...
   conservation is a single fold over the position map") and again in the
   Conservation proof (lines 340–350). This is altitude, not repetition: the
   construction motivates *why psBal is a group-valued type*; the proof adds the
   load-bearing parts the construction does not — uniqueness of the writer,
   non-interference of `register`/`settle`, the induction from `emptyLedger`, and
   the seal that closes the last door. Each instance advances the argument.

2. **"neither touches psBal"** (line 273, in the register/settle paragraph) and
   (lines 346–347, in the proof). The first is a forward note; the second uses it
   as a proof premise. One clause, signposted, not idle.

3. **Self-move / zero-move netting to `mempty`** (line 294) and (lines 316–318,
   marked "(above)"). The first establishes conservation of the legs; the second
   draws the *distinct* consequence (no row is written) and defines "held." Same
   fact, two different conclusions, the reuse explicitly flagged.

In every case the document points forward with "(below)" / "(§...)" and the later
statement carries new content. That is a claim and its proof sharing vocabulary,
which the bar permits; it is not idle duplication.

## Honest disclosure check

The one unproved step — that a relationship spanning several instruments is a
single unit — is flagged as "assumed here, not proved" (line 149), exactly the
STYLUS discipline of flagging the unsettled rather than papering over it. That is a
named boundary, not residue.

The document is obviously right. The simple path is the whole document; nothing
present fails to serve the answer; nothing is said twice that does not advance it.
