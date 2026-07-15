# karpathy — Round 6 — States.tex

**Verdict: NOT-YET**

Bar: a competent engineer who has never seen this problem sees *what* the answer
is and *why* it must hold in a single pass — no leap of faith, no backtracking.

The code is obviously right. The placement argument is not yet, in three located
spots. The keystone is residue 1.

---

## What is already obvious (and good)

- **The 2×2 framing** (key axis × correction axis → Terms / Status / Position /
  empty) is a clean, memorable spine. The reader grasps the shape immediately.
- **The code.** `applyMove` is the only `psBal` writer and writes both legs from
  one quantity, so `negQty q <> q = mempty` — conservation by construction.
  `register`/`settle` touch only `ledgerUnit`. `appendVersion` appends at the
  tail, `currentTerms = NE.last` reads the tail — consistent. `position`'s
  `Maybe` separates *never held* (no key) from *held and flat* (`Just` zero
  row). `replay = foldM (flip apply)` over pure/total `apply` is deterministic
  and checkpoint-splittable. I can derive each of these from first principles in
  one pass. No correctness defect.

The residues below are all in the prose that justifies *the placement* — the
document's actual claim.

---

## Residue 1 (keystone): the empty-cell proof silently swaps its criterion for "definition"

§answer fixes the correction axis as **how a correction is recorded**, and
explicitly rules provenance out: "what places a fact is how its correction is
recorded, not who authored the number" (lines 76–78). Under that axis,
*definition* = append-a-version-and-keep-prior; *observation* = overwrite.

§why then proves the fourth cell empty using a **different** criterion —
provenance: "A correctable definition is a versioned artifact the ledger
*receives at its boundary* and audits against an external authority... A
position is *owned*... so no received per-(holder,unit) definition exists to
version" (lines 132–146). The paragraph itself flags the swap ("This does not
reopen authorship") — an author's tell that the seam is showing.

For the proof to land, these two notions of "definition" must coincide, and the
doc never closes that. Worse, the obvious bridge ("owned ⟹ recomputable by
replay ⟹ overwrite suffices ⟹ not a definition") is **false on the doc's own
terms**: Terms are *also* event-derived/recomputable (from `Registered`
events, and §right says replay rebuilds terms), yet Terms use append-and-keep,
not overwrite. So recomputability is not what excludes the (holder,unit)
definition.

The actual load-bearing discriminator is unstated: *a definition requires an
external authority that defines that key's facts for the ledger to version and
audit against.* The unit key has one (the registrar/issuer → terms). The
(holder,unit) key has none — positions are defined by the ledger's own move
stream; custodian/PB statements are reconciliation inputs, not authorities the
ledger adopts. Adopting one would install a second writer of position state,
breaking the sealed single-writer discipline the §question opens with.

**Action:** In the "fourth cell is empty by construction" paragraph (lines
132–146), factor out the real discriminator — *is there an external authority
that defines this key's facts?* — and state the single-writer consequence
(adopting a per-(holder,unit) external definition installs a second writer of
owned position state, violating the seal). That converts the empty cell from an
asserted reconciliation of two "definition" senses into a one-pass deduction.

## Residue 2: Terms-vs-Status leans on a recovery asymmetry that §right contradicts

§why contrasts: terms "appends a version and keeps the prior, auditable at the
boundary; a new status overwrites... any prior recovered by replay" (lines
121–130). The juxtaposition reads as: status's prior comes from replay,
terms' prior must be kept because replay won't serve. But §right (lines 359–371)
says replay rebuilds terms too. So terms' prior is *also* replay-recoverable;
the genuine reason terms materialize a version list is boundary audit *without*
replay — not history recovery. A single-pass reader infers the false asymmetry,
then hits §right and backtracks.

The valid argument is present but buried: the two correction *shapes*
(non-empty list vs single cell) cannot inhabit one value (line 122), and terms
materialize all versions *so current state is auditable at the boundary without
replaying the stream*. 

**Action:** In the terms paragraph (lines 120–130), say plainly that both terms
and status are replay-recoverable, and that terms additionally materialize the
version list specifically for boundary audit without replay — that
materialization, not recoverability, is the discriminator. Drop the implication
that status alone is replay-recovered.

## Residue 3 (secondary): "a netting set is itself a unit" is asserted, not shown

The key axis collapses to exactly {unit, (holder,unit)} only because "a
relationship spanning several instruments — a netting set, a cross-margin
portfolio, a cross-currency offset — is itself a unit" (lines 60–62), resting on
"a unit is anything that can be held" (line 44). Whether a netting set or
cross-margin portfolio is *held* is never demonstrated. The managed-account
example (lines 147–153) demonstrates the move concretely — but for a *mandate*
(issued −1/+1), a different case. The reader takes the netting-set reduction on
faith.

**Action:** Show the netting-set / cross-margin case reduces to a held,
issued unit the same way the mandate does (who issues it, the −1/+1 legs), or
narrow the claim to the cases actually exhibited.

---

Residue 1 is a genuine logical seam in the central claim, not a wording nit:
the empty cell is the load-bearing half of "why three," and its proof currently
requires the reader to silently identify two different definitions of
"definition." Fix 1, tidy 2 and 3, and this reaches OBVIOUS.
