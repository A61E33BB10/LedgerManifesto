# karpathy — States, Round 14

Verdict: **NOT-YET**

The construction (§3) and the two proofs (§5) are tight and read in a single pass:
the `Qty` group, the two cancelling legs, the seal over the constructor/selectors,
the `foldM` replay — each piece is forced by the one before and verified against a
concrete invariant. The code is correct: I traced `netDeltas`/`writeNet` for the
distinct-wallet, self-move, and zero-quantity cases and the row-write / no-row
outcomes match the prose; conservation and totality hold as claimed; `foldM`'s
split-at-any-cut law is real. That layer is obvious.

Two things stop the *answer itself* (§2) from being obvious. Both are located and
actionable.

---

## Residue 1 — the headline count rests on an assumption the document itself does not prove

§2 states the placement unconditionally: "Two questions place any fact" (line 55),
and §2/§3 state the fourth cell is "empty by construction" (lines 99–100, 150) and
the homes are exactly three. But the completeness of that count is conditional. The
document says so in its own words:

- Line 64–65: "The reification is demonstrated for a single relationship and
  **assumed** for one spanning several instruments (§why); the binary holder-axis,
  **and so the count below, rests on it**."
- Line 157–159: "This discharges the reification for one mandate; that a relationship
  spanning several instruments is likewise a single unit, and so a single row, is
  **assumed here, not proved**."

So the load-bearing claim — every economic fact reduces to a (holder, unit) fact or
a unit fact, which is what closes the key space to exactly two options and empties
the fourth cell — is proved only for the single-instrument / single-mandate case and
asserted for the general one. A reader meeting "place *any* fact" and "empty *by
construction*" in §2 accepts the count, then on reaching §4 learns it holds on faith
for the multi-instrument case. That is the backtrack and the leap the bar forbids,
and it sits exactly where the project's first principle is strictest ("A claim is
proved, not asserted").

Actionable: either prove the multi-instrument reification (a relationship spanning N
instruments is one unit, hence one row, with no economic fact escaping to a wider
key), or scope the answer's universal phrasings ("place any fact", "empty by
construction", "three homes") to the proved case so §2 no longer over-claims relative
to §4.

---

## Residue 2 — `psHwm :: Qty` contradicts the document's own reason for the `Price` newtype

The document establishes a clear principle for non-transferable levels (lines
200–203):

> "A price is a number but not a quantity --- never added, never moved between
> wallets --- so `Price` is a separate newtype with neither identity nor inverse,
> never summed into a balance."

A high-water mark is, by §4's own description, exactly such a level: for the managed
account it is the performance-fee NAV high-water (line 155–156), a value level, not a
transferable position quantity. You never add two high-water marks; it has no
meaningful zero and no inverse. Yet it is typed `Qty` (line 245):

```
{ psBal :: Qty       -- held quantity: primary, conserved, sums to zero
, psHwm :: Qty }     -- high-water mark: not conserved; ...
```

`Qty` is precisely the group type whose identity-and-inverse structure exists to make
transfer legs cancel (lines 178–180). Typing `psHwm` as `Qty` grants the high-water
mark `<>`, `mempty`, and `negQty` — the operations the document deliberately
*withholds* from `Price` because they are meaningless for a level. The text defends
only the *consequence* ("no move writes it as two cancelling legs, so it carries no
zero-sum invariant", line 237–239); it never defends the *type choice*, which is the
question its own `Price` argument raises. By the document's standard, an illegal
operation (summing/negating a high-water mark) is representable here.

A first-pass reader who took the `Price` reasoning seriously hits the contradiction
two paragraphs later and must stop: "non-transferable levels get a non-group newtype
— so why is the high-water mark a `Qty`?" The document gives no answer.

Actionable: either give `psHwm` a non-group newtype in the spirit of `Price` (no
identity, no inverse, never summed), or state explicitly why a high-water mark is
genuinely a quantity with group structure and not a level — and reconcile that with
the `Price` justification.

---

Everything else is obvious. Resolve these two and I expect this flips to OBVIOUS.
