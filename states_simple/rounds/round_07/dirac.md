# DIRAC — Round 7 — States.tex

**Verdict: NOT-YET**

Lens: is the three-home structure inevitable, with no unexplained special case?

## What is beautiful

The 2×2 is the right object. Two binary axes — key (unit | (holder,unit)) and
correction discipline (correctable definition | superseding observation) — each
argued exhaustive: the key axis closed by "a multi-instrument relationship is itself
a unit" plus "no economic fact is wallet-alone," the discipline axis closed by
"keep prior, or overwrite; deletion barred by immutability." Three occupied cells,
two maps (terms+status ride the shared unit key as a pair). Terms-vs-status as
distinct homes — "a single value cannot be at once an append-only list and an
overwrite-in-place cell" — is inevitable and cleanly put. The managed-account
worked case discharges the obvious counterexample. This part reads as forced.

## Residue (one, located, blocking)

**The empty cell — the linchpin of "three, not four" — rests on a stated reason
that the document contradicts two sentences earlier.**

Location: §Why (`sec:why`), paragraph "The fourth cell is empty by the seal, not by
survey," lines 141–159, specifically 144–146.

Line 144 states that **two** writers already act on the (holder,unit) key:
"applyMove writes the held quantity in place, the valuation event the high-water
mark." Lines 145–146 then justify the empty cell by: admitting a definition "would
open a writer beside applyMove, breaking the seal conservation rests on." A
first-time competent reader cannot see why the valuation event — itself a writer
beside applyMove — does *not* break the seal while a definition writer does. As
phrased, "opening a writer beside applyMove" cannot be what breaks anything, since
the document has just introduced exactly such a writer and called it safe.

The reconciling principle is left for the reader to reconstruct:

1. The seal is **single-writer-per-fact**, not single-writer-per-key. The valuation
   event is safe because it owns a *distinct* field (`psHwm`); conservation depends
   only on how `psBal` is written.
2. A (holder,unit) definition would version an external artifact (custodian /
   prime-broker position report), and that artifact is necessarily *about the
   holding* — a fact `applyMove` already owns — so it would be a **second writer of
   the same fact**. That is the break.
3. Step 2's "necessarily about the holding" depends on the minimalism claim that
   **every (holder,unit) economic fact is self-computed** (folded from the move
   stream / opening event), so no external (holder,unit) figure is ever a genuinely
   new fact.

The text supplies piece 3 but demotes it: "None is wanted in any case ... by
minimalism." The phrase "in any case" presents minimalism as an independent backup
reason, when it is in fact the **premise the seal argument requires** — the chain is
minimalism → "all such facts self-computed" → seal → "any external definition is a
second writer of an owned fact." Presented as two alternative reasons, it also
breaks the paragraph's own promise (lines 110–111): "the empty cell is empty for
one [reason]." As written it claims one and reads as two.

Actionable fix: state the seal as single-writer-*per-fact*; note explicitly that
the valuation event is a safe second key-writer because it owns a different field;
then chain — not juxtapose — minimalism and the seal, so emptiness falls out of one
argument: all (holder,unit) facts are self-computed, hence any external definition
on that key duplicates an owned fact's writer, hence the cell cannot be occupied.

Until the linchpin's reason is single and free of the apparent self-contradiction at
line 144–146, the "three not four" does not read as inevitable.
