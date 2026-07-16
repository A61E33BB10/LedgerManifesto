# FORMALIS — Round 6 — States.tex

**Verdict: OBVIOUS**

The lens: is correctness *visible* — conservation and replay evident consequences of
the structure — and was nothing load-bearing in the essence dropped, weakened, or hidden
to read cleaner? I read `States.tex` against `SOLUTION_ESSENCE.md` and checked every
listing against the live `States.hs` (the listings reproduce the declarations faithfully;
nothing material is paraphrased away).

## Conservation is visible

The argument in §"Why It Is Right" is a clean, complete induction a competent reader can
discharge unaided:

- **Base case.** `emptyLedger` has both maps empty, holding sum `mempty`. Stated.
- **Step.** `applyMove` is the *only* writer of `psBal`, and it writes both legs from one
  quantity, so the per-unit sum changes by `negQty q <> q = mempty`. `register` and
  `settle` touch only `ledgerUnit`, never `psBal`. Stated, with the monoid identity shown
  inline.
- **Exhaustiveness.** "the sealed constructor leaves no other door" — the unexported
  constructor makes the four writers the complete reachable set, so the induction covers
  every reachable ledger. Stated.

The document also keeps the honest, load-bearing qualification that FORMALIS would veto if
hidden: conservation is *an invariant of the writer, not of the store type, which can hold
a non-conserving assignment.* That distinction (the type does not forbid the bad value; the
only door that writes it writes it balanced) is the actual truth of the matter and it is on
the page, not glossed. `psHwm` is correctly excluded from the invariant — "adds but is
never written as cancelling legs" — so the conserved field is precisely scoped. I checked
the `from == to` degenerate case by hand: the two legs still net to `mempty`; no hole.

## Replay determinism is visible

"`apply` is a pure, total function of the event and the prior ledger; the same events give
the same ledger." `apply` is total (every writer returns `Maybe`, defined on all inputs)
and pure. Checkpoint soundness rests explicitly on the monadic left-fold law over `foldM`.
The `Maybe` is correctly characterized as `foldM`'s failure, not a balance guard. I
confirmed the one subtlety FORMALIS cares about — no hidden non-determinism: `Map.toList`
is canonically ordered, and replay applies the *same* operation sequence in both the whole
and the prefix+suffix cut, so equality holds at the observable (content `Eq`) level with no
dependence on internal tree shape. Solid.

## Nothing load-bearing dropped (the veto did not trigger)

All six KEEP items survive, each stated once:

1. Three homes, no fourth — §Answer, §Why Three; "three homes, two maps" keeps *three kinds
   of state* load-bearing while collapsing to two maps by shape.
2. No wallet-keyed economic sector — "No fourth home holds economic state"; KYC/permissions
   flagged as identity, not one of the three.
3. Never-held vs held-and-flat — §"Reading a position"; both readings used (entitlement vs
   lookback), retained row keeps them apart.
4. The three forcing reasons, each by a concrete example (buyer/seller `+1000/-1000`; one
   settle price read identically; append-keeps vs overwrite-discards) — §Why Three.
5. Conservation and replay forced by structure — §Why It Is Right.
6. Mandate-as-unit (`-1`/`+1`, sums to zero) grounds "no fourth sector" — §Why Three.

The DROP discipline holds: no Pareto frontier, no rejected designs, no C1–C12, no risk
register, no round provenance. The "fourth cell empty" and "managed account looks like the
counterexample" passages justify why *this* answer is right (the 2×2 has one structurally
empty cell; the apparent counterexample is absorbed by the mandate unit) — they are not
"we considered X and rejected it" narratives.

## One point where the tex *improves* on the essence, correctly

The essence (item 5) loosely couples row retention to replay being a fold ("rows are
retained ... *so* replaying is a plain left fold"). The tex decouples them: determinism is
"from purity alone," and row retention "serves audit, not determinism." This is the more
precise causal account — retention is genuinely unnecessary for both fold-determinism and
checkpoint soundness (I checked: deleting flat rows would not change replay-from-empty or
the `foldM`-cut equality). Retention remains load-bearing for the never-held/held-and-flat
distinction (item 3), which the tex keeps. So this is a sharpening, not a drop — exactly the
direction FORMALIS wants.

A competent engineer who has never seen this problem can read these pages and *see*
conservation and replay fall out of the shape, without reaching for the omitted proofs.
That is the standard, and it is met.
