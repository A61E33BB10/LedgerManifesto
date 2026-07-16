# karpathy — Round 9 — States.tex

**Verdict: NOT-YET**

## Lens

The bar: a competent engineer who has never seen this problem reads it once and
sees both *what* the answer is and *why it must hold* — no leap of faith, no
backtracking. I do not affirm to be agreeable; OBVIOUS would stake my lens.

## What already passes

- **Conservation** (§Why It Is Right, lines 353–367) is airtight in one pass.
  `applyMove` is the sole `psBal` writer; it writes `negQty q` and `q` together;
  their `<>` is `mempty`; `register`/`settle` never touch `psBal`; base case is
  `emptyLedger`; the sealed constructor leaves no other door. I can derive it.
- **Deterministic replay** (lines 369–389): `apply` pure and total, `foldM` split
  law for checkpoints. Clean.
- **First axis** (key = unit vs (holder,unit)) is honest: the multi-instrument
  reification is explicitly *assumed, not established* (lines 62–64), so it is a
  flagged premise, not a hidden one. Acceptable.
- The empty-fourth-cell *second* argument (single-writer seal, lines 159–161) is
  crisp: a versioning definition over `psBal` would be a second writer.

## The residue (located, actionable)

The contribution rests on the **second axis** — the boundary-read test that
separates a *correctable definition* (terms, append, keep prior) from a
*superseding observation* (status, overwrite, discard prior). This step is
asserted, not derived, and the document's own wording forces a backtrack.

**Location: §The Answer, lines 81–89, echoed in §Why Three, lines 134–146.**

The text states the test and then pre-empts the obvious objection:

> "Both are replay-recoverable; what places a fact is not recoverability but
> whether a past-dated value is read at the boundary."

But it never says *why* a past-dated boundary read forces a materialized version
list, **given that it has just told me replay recovers any past value anyway**
(line 88: status's "any past level recovered by replay"; line 155: the same for
every (holder,unit) fact). If replay reconstructs status's past values, then by
the document's own logic replay can serve a past-dated *terms* read too — so the
live version list looks like a performance choice, not a forced home. The reader
stops and re-reads: "recoverability is dismissed as the criterion, yet
recoverability is the only mechanism offered for serving past values — so what
actually forces the list?" That is a leap of faith at the precise hinge of the
paper.

**The missing premise** (which makes the test a derivation instead of an
assertion): a boundary consumer reads the *live projection* synchronously; replay
is the *rebuild* path, not the read path. Therefore a past value that must be
readable **at the boundary** has to be present in the projection's value *type* —
which forces a `NonEmpty` version list — whereas a value never read past-dated
needs only a scalar, its history left implicit in the event stream and
reconstructed by replay solely on rebuild. Under that premise the chain closes in
one pass:

```
past-dated boundary read
  -> projection must expose past values at read time (replay is offline, not on the boundary path)
  -> projection value type is a version list (not a scalar)
  -> a correction appends, prior kept           [Terms]

only-current consumed
  -> projection value type is a scalar
  -> a correction overwrites, prior dropped, recovered by replay on rebuild  [Status]
```

Right now the document compresses this whole derivation into the verb "*makes*"
("Any past-dated boundary read ... **makes** it a correctable definition — a
materialized version list", line 84). "Makes" hides the inference. The reader has
to supply the read-path/rebuild-path distinction himself, and the repeated
"recovered by replay" framing actively points him the wrong way.

**Fix (one sentence, plus a wording cleanup):** at lines 86–89 add the explicit
distinction — the boundary read is served from the live projection, replay only
rebuilds it offline — and conclude that what a past-dated boundary read forces is
the projection's *value type* (scalar vs version list). Then stop invoking
"recovered by replay" as if it were an alternative to materialization for the
overwrite cells; say instead that replay rebuilds *whichever* value type the test
selected. That single move turns the central test from a stated rule into a
visible consequence, and the paper becomes OBVIOUS.

## Secondary note (not blocking on its own)

§Why Three line 146 says the distinction the file exercises is "the change
discipline its two writers exhibit: `appendVersion` keeps, `settle` discards." Good
— but this is a demonstration of the discipline, not the *reason* for it; it
inherits the same gap above. Closing the primary residue covers it.
