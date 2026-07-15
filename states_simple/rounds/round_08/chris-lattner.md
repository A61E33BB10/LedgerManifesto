# chris-lattner — Round 8 — States.tex

## Verdict: NOT-YET

The architecture is right. The 2×2 (key axis × correction discipline → three homes,
two maps) is clean, the types make illegal states unrepresentable (NonEmpty terms,
price riding on `Active`, sealed constructors), and conservation/replay/ownership are
each carried by a single named writer. This is good infrastructure. But "obviously
right" stakes on a fresh competent reader hitting no nagging gap, and there is one
that the document itself sets up and then steps on, plus a naming collision that
stalls the reader at the load-bearing moment. Both are present-and-not-serving by my
bar.

## Residue (located, actionable)

### 1. The empty-cell argument contradicts the principle it rests beside (primary)

`States.tex` lines 152–154, the paragraph "The fourth cell is empty by the seal":

> "Every (holder, unit) fact is the ledger's own, folded from its own move stream and
> replay-recoverable; **by minimalism the owned and recoverable is never versioned**,
> so no owned fact carries a version list."

This uses *recoverability* as grounds against versioning. But the document already
established, twice and emphatically, that recoverability does **not** decide
versioning:

- line 76–77: "what places a fact is not recoverability but whether a past-dated
  value is read at the boundary."
- line 133–135: "Both terms and status are replay-recoverable ... **Materialization,
  not recoverability, separates them.**"

Terms are written by `register` (a ledger writer — the ledger's own) and are
replay-recoverable (replayed from `Registered` events, line 387), yet Terms *are*
versioned (a `NonEmpty` list). So "the owned and recoverable is never versioned" is
false as stated; it is salvaged only by silently narrowing "owned" to "folded from
the move (`applyMove`) stream" and noting Terms are unit-keyed, not (holder,unit)-keyed
— a reading the sentence does not give. A careful reader reconstructs this and is left
unsure whether the rule means what it says.

The clause is also redundant: the seal's second-writer argument in the same paragraph
("the definition would be a second writer of that fact, breaking the seal") already
closes the cell on its own, and is the headline. The "by minimalism ... owned and
recoverable is never versioned" clause adds a third, weaker, self-contradicting reason.

Action: delete the clause and let the seal carry the cell, or scope "owned" explicitly
(move-stream-folded (holder,unit) facts) and reconcile against Terms in one sentence,
so the empty-cell argument stops re-litigating a criterion the document already retired.

### 2. "Fourth cell" vs "fourth home" collide at the frame seam (secondary)

- line 95: "The **fourth cell** --- a (holder, unit) correctable definition --- is
  empty" (the empty cell of the 2×2, on the (holder,unit) key).
- line 100: "No **fourth home** holds economic state" (a *hypothetical wallet-alone*
  home — a different object; the paragraph immediately turns to "holder-alone keying").

Two distinct referents both named "fourth" within six lines. A first-time reader reads
line 100 as re-arguing the empty cell of line 95 and loses the thread exactly where the
frame is being justified.

Compounding it: the exclusion that completes the key axis — no wallet-alone key, no
multi-unit key, hence the axis is exactly {unit, (holder,unit)} — arrives at lines
100–108, *after* the 2×2 has already been built and its cells enumerated (lines 80–98).
The axis the 2×2 stands on is fully justified only after it has been used. Deductive,
result-first order (per the project's clarity commitment) wants the axis closed before
the grid is drawn on it.

Action: rename one referent (e.g. "wallet-keyed home"), and move the wallet-alone /
multi-unit exclusion ahead of the 2×2 construction so the frame is sealed before it is
populated.

## Not residue (checked, and they hold)

- `psHwm` staying zero with its writer out of scope: earns its place as the witness
  that the seal is single-writer-*per-fact*, not per-key (two writers, distinct fields).
- `ProductTerms` as `NonEmpty` despite one version today: correct — the type encodes
  the correctable-definition discipline; capability over current exercise.
- `appendVersion`/`currentTerms` unused in-file: they realize the terms home's
  interface; the driving amendment event is honestly scoped out.
- The multi-instrument assumption (lines 61–64): flagged as assumed, not smuggled.
- Boundary-read test vs recoverability for Terms-vs-Status: handled cleanly at the
  point of definition — which is precisely why residue #1's regression on it stings.
