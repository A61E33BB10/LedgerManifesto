# jane-street-cto — Round 9 — States.tex

## Verdict: NOT-YET

The argument is sound and the code is correct. I found no conservation bug, no
replay defect, no broken type. The 2×2 placement (key × correction discipline,
three occupied cells, one forced-empty) is a genuinely good decomposition and is
proved, not asserted. The seal-plus-pair construction holds conservation and
co-presence by construction as claimed.

But the bar is: a competent engineer, new to the problem, calls it obvious and
writes no commentary. Two located spots fail that bar — one a self-contradiction
the reader cannot resolve from the file alone, one a deduction compressed past
the point of linear reading.

## Residue

### R1 — `psHwm` is typed `Qty` (a full group) yet the prose disclaims its combination

Lines 248–251 and 254–259, read against the `Price` treatment at lines 214–215.

The document establishes a rule and then appears to break it. For `Price` it
reasons (214–215): "never added, never moved between wallets --- so `Price` is a
separate newtype with neither identity nor inverse, never summed into a balance."
The stated technique is: deny a value the group structure so the type itself
forbids the operation the semantics forbid. Good — that is exactly "make illegal
states unrepresentable."

Then `psHwm` is given the type `Qty` — which carries `<>`, `mempty`, and `negQty`
— while the prose says it "carries no zero-sum invariant" and, flatly, "its
combining operation is not fixed here" (251). A reader stops here: `Qty`'s entire
reason for existing in this file is that it is a monoid/group with a fixed `<>`
(lines 188–193). A field whose type *is* that monoid but whose "combining
operation is not fixed" is a contradiction on its face. The type permits the
precise summation the prose disclaims, and `netBal`-style `foldMap` over `psBal`
sits three lines away to make the temptation concrete. By the file's own `Price`
standard, the reader cannot tell why `psHwm` is not likewise given a type without
the group structure.

This is a real gap in the `.tex`, not a misreading: the companion `States.hs`
(lines 555–562) *does* resolve it — "a high-water mark is a quantity, and
high-water marks add ... a separate newtype ... would only decorate." That
justification (hwm genuinely adds, unlike Price; so `Qty` is right) is the load
-bearing sentence, and it is absent from `States.tex`. Worse, the `.tex` asserts
the opposite ("combining operation is not fixed here"), so the reader of the spec
alone is left with an unexplained asymmetry and an apparent contradiction.

Actionable: in the `\paragraph{A position carries more than a balance.}` block,
either (a) port the `.hs` justification — state that the high-water mark *does*
add (it ratchets) and that this is exactly why reusing `Qty` is correct, deleting
"its combining operation is not fixed here" — or (b) give `psHwm` a distinct
type, matching the `Price` move. Pick one; the file must not both keep the group
type and deny the operation.

### R2 — The closing economic-state deduction is compressed past linear reading

Lines 71–75, specifically the sentence: "The wider, multi-unit keying is closed
by the reification above; both excluded --- conditional on that reification ---
only the unit and the (holder, unit) pair carry economic state."

The conclusion is correct and the supporting clauses are all present, but they
are folded into one sentence with a parenthetical ("both excluded --- conditional
on that reification ---") nested inside the conjunction it qualifies. The reader
must hold three referents at once — what "both" denotes, what "that reification"
denotes (a claim made 16 lines earlier, line 60), and which conclusion is
"conditional" — to parse a single clause. This is the one place in the file where
the deduction cannot be traced by reading left to right; a new reader annotates
or re-reads to recover the chain. The same content elsewhere in the section is
staged cleanly (the per-holding reckoning argument at 66–71 reads linearly).

Actionable: split into two sentences along the existing seam. First state the
result conditionally — "Conditional on the reification of §2.1, the wider
multi-unit keying reduces to (holder, unit), so it carries no economic state of
its own." Then state the closed conclusion — "Both wider keyings thus excluded,
only the unit and the (holder, unit) pair carry economic state." Result first,
condition named once, no nested parenthetical.

## Not residue, but noted

- `appendVersion` (239–240) is defined and never invoked in this file, and
  `psHwm` is never written. Both are deliberate, and the file says so (amendment
  and valuation events out of scope). Inert-but-documented scaffolding is a
  legitimate choice for a placement spec; it does not block obviousness on its
  own. Fixing R1 removes the sharper edge of the `psHwm` case.
- `TermsVersion String` is an unmodeled placeholder; acceptable as scope.
