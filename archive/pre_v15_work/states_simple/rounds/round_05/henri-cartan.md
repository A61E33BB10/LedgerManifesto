# henri-cartan — Round 5 — States.tex

## Verdict: OBVIOUS

## Lens

Rigour. A claimed property must follow from the definitions so directly that the
omitted proof is not missed. I read the document as a working mathematician asks
of a paper: are the theorems stated with all hypotheses, proven completely, and
is the taxonomy that frames them exhaustive and minimal?

## What the document claims, and whether each follows

The solution makes two formal claims and one structural claim. All three are
discharged in-text, not merely asserted.

1. **Conservation** (§"Why It Is Right"). Stated as: every reachable ledger has
   per-unit holding sum `mempty`. The proof is a clean induction with the cases
   closed:
   - Base: `emptyLedger` has empty maps, so `netBal l u = foldMap psBal [] =
     mempty`.
   - Step: `applyMove` is the *only* writer of `psBal`, and it writes
     `negQty q` and `q` together from one quantity, so the sum changes by
     `negQty q <> q = mempty`; `register`/`settle` never touch `psBal`.
   - Closure: the constructor is sealed (confirmed in `States.hs`: `Ledger`
     exported without constructor, `ledgerUnit`/`ledgerPS` not exported), so no
     other door reaches the store.
   The one step left unspelled — that changing two map entries changes `foldMap`
   by the sum of the two deltas — is exactly the abelian-group rearrangement of
   integer addition, and is not missed. The `from == to` degenerate case still
   nets to `mempty` (inner leg `cur - q`, outer reads it and adds `q`), so the
   formula holds without a separate case. The document is also honest that this
   is a writer invariant, not a store-type invariant, and distinguishes `psHwm`
   correctly (adds, but no cancelling-leg writer, so no zero-sum invariant).

2. **Deterministic replay** (§"Why It Is Right"). `apply` is a pure, total
   function (every branch returns `Maybe` via total `Map`/`NonEmpty`
   operations), so equal event streams give equal ledgers. Checkpoint soundness
   is the monadic left-fold split law for `foldM`; the document states the law's
   content ("foldM over a concatenation splits at any cut"). This is a standard,
   citable law and its proof is not missed at this altitude.

3. **Three homes, two maps** (§"The Answer", §"Why Three"). The taxonomy is a
   2×2 over two genuinely binary axes: key ∈ {unit, (holder,unit)} and
   correction discipline ∈ {retain prior versions, overwrite}. The
   correction axis is exhaustive by construction (you either keep history or you
   do not). The key axis is closed by two explicit exclusions — multi-unit
   ("a relationship over several units is itself a unit") and holder-alone
   ("every economic fact about a wallet is a fact about that wallet's
   relationship to some unit … the rest is identity, not economic state"). Each
   occupied cell is shown *necessary* (Position needs the holder key — two
   holders of one future differ in sign; Status needs the unit key — one value
   read identically, per-holder copies drift; Terms distinct from Status —
   append-only list and overwrite-in-place cell cannot be one value), and the
   empty fourth cell is defended with its salient counterexample (the managed
   account) explicitly defused into a (client, mandate-unit) position. Necessity,
   sufficiency, and completeness are therefore all argued, not assumed.

## Residue I considered and rejected

- **The global / ∅ key is never enumerated** in the key-axis exclusions. I
  judged this not a gap: §"The Answer" scopes the question to "one unit's
  state … only the unit and a holder of it are in view," which forecloses a
  key naming neither. Global facts (the event stream itself, reference data) are
  out of scope by that opening, not silently dropped.
- **The foldM split law and the abelian-sum step are stated without proof.**
  Both are standard and the document gives each law's content; a competent
  reader does not miss them.

None of these rises to a located, actionable omission.

## Conclusion

The two correctness theorems are proven completely and follow directly from the
definitions and the sealed-writer discipline; the framing taxonomy is exhaustive
and each cell is justified. Hypotheses are stated, cases are closed, and the one
counterexample is handled. The omitted proofs are the kind no competent engineer
misses. I stake OBVIOUS.
