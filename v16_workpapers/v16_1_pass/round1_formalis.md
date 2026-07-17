# Round 1 — FORMALIS findings (v16.1 pass)

Reviewer: FORMALIS (Leroy chair; Coquand, Huet, Paulin-Mohring, de Moura, Avigad).
Target: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex`.
Authority: Constitution v1.4 C-2.7 (l.166–212), C-12.6 (l.864–874).
Prior proofs: `v16_workpapers/v16_1_pass/memo_w2_proofs.md` (P1–P5).

---

## F1 (CENTRAL) — thm:refold statement equivocation — **VERDICT: DEFECT** (escalates to VETO if the correction is declined)

**Location.** `thm:refold`, lines 1237–1243; confirming context lines 1278–1282 and 1329.

**The two readings.** The theorem says the refolded state equals
> "the state that would have obtained had $e$ been folded in execution order from the start" (1239–1240).

This phrase admits two readings:

- **(A) counterfactual WORLD** — the state that would exist had $e$ *actually arrived timely*.
- **(B) replay of the SAME recorded set** — fold the fixed post-absorption set $S$, with $e$ moved to its execution-order position, from the start.

The proof supplied (1240–1242, "Both are fold step over the same sequence … deterministic: equal input, equal output") proves **(B)**. Reading **(A)** is **false**.

**Counterexample to (A), from the spec's own text.** Watch firings are Event-Monitor-driven and are themselves recorded events in the total order (1278–1279). In the covered call, the Wednesday record-date watch fired on the book's honest 100-share state; that firing event is *in* $S$. On refold it "now finds zero shares" and its consequence takes C-12.6 treatment, "the firing event never deleted" (1280–1281, 1329). But in a **genuinely timely world**, the assignment folds on Tuesday, the shares are gone by Wednesday, and the record-date watch **never fires at all** — no firing event is ever recorded. Hence the timely-world set $S' \neq S$ (S contains the firing; S′ does not). The theorem equates the refold with a fold of $S$; it does **not** equal the fold of $S'$. Where a refolded firing proposes a non-trivial move that its timely-world counterpart would never have generated, the two states diverge. Reading (A) is therefore not a theorem.

**Why the second sentence does not save it.** "Both are fold step over the same sequence, $e$ at the same position in each" (1240–1241) pins $e$'s *position* but is silent on *set membership* of the other events. "The same sequence" is anaphoric and under-specified; it does not say "the same recorded $S$, Monitor-driven firings included, none suppressed." The equivocation survives exactly at the set-membership level — which is where the covered-call firing lives. A strong undergraduate (the CLAUDE.md §6 target reader) reads the main clause as the timely world and is left with a false theorem.

**Exact corrected statement (replace 1237–1243):**

```latex
\begin{theorem}[Refold equals in-order fold of the same events]\label{thm:refold}
Let $S$ be the post-absorption set of admitted events of the authoritative lineage,
and let $e\in S$ be a late arrival. Fold $S$ in admission order and then run the
reordering step that inserts $e$ at its total-order position and refolds the tail; the
resulting ledger state --- balances and the three homes --- equals the state of folding
$S$ once, in total order, from the start. Both sides are $\mathrm{fold\ step}$ over the
single sequence $\mathrm{sort}_<(S)$, and $\mathrm{fold\ step}$ is deterministic: equal
input, equal output.
\end{theorem}

\noindent\emph{Scope of the counterfactual.} The equality is over the \emph{fixed
recorded set} $S$. It does \emph{not} assert that a genuinely timely arrival of $e$
would have produced this state: a timely arrival could have caused the Event Monitor to
record a \emph{different} set of events --- in the covered call, the record-date watch
that fired here on the superseded 100-share state would never have fired at all --- so
the timely-world set $S'$ differs from $S$ and its fold need not agree. What is claimed,
and all that is claimed, is that the fold state is a function of $S$ and the total order
alone, independent of the order in which the events of $S$ arrived at the door.
```

This is memo P3's honest statement ("the fold state is a function of the set `S` and the order `<` alone, independent of arrival order at the door", memo l.155–156). The spec loosened P3's precise quantifier into an evocative world-counterfactual; the correction restores it.

**Escalation.** thm:refold is the one labelled Theorem in scope. Under its natural reading it is false, so as literally worded it "stands unproven." If the correction is declined, this is a **VETO**.

---

## F2 — antisymmetry ACROSS an authorised fork — **VERDICT: DEFECT**

**Location.** Total-order definition 1155–1181 (esp. 1174–1178); Invariant `inv:lineage` 5188–5192; memo P1 Lemma 1/2 (l.47–76) and P1(b) (l.105–110).

**The gap.** Antisymmetry is trichotomy's contrapositive (memo l.44–45, 76). Trichotomy is proved from **key injectivity**, established under **ASSUMPTION-CR** — "hash injective on the finite domain of *distinct well-formed events*" (memo Lemma 1, l.47–51, 59–61). Totality is deliberately rested on CR, **not** on door-time monotonicity (DM), because DM is only property-tested (memo l.63, 98–104).

CR fails across lineages. An authorised fork "rebuilds forward on a new lineage … re-admitting events with fresh door times," where "execution time and hash [are] lineage-invariant" (1176–1178; memo P1(b) l.105–108). So an abandoned-lineage event $e_{\text{old}}$ and its rebuilt twin $e_{\text{new}}$ are **distinct events** with
$$\mathrm{key}(e_{\text{old}}) = (X,\ d_{\text{old}},\ H), \qquad \mathrm{key}(e_{\text{new}}) = (X,\ d_{\text{new}},\ H),$$
**equal execution time and equal hash**, differing only in the reissued door time. Hash is therefore **not injective on the pair** — CR's hypothesis "distinct events ⇒ distinct hash" is violated by construction. The CR proof of key injectivity, hence of trichotomy and antisymmetry, **does not cover the cross-lineage pair**. Were DM also to tie ($d_{\text{old}} = d_{\text{new}}$, unguaranteed since door times are reissued independently across lineages), the keys collide: two distinct events, equal key, order not antisymmetric.

**The printed proof silently assumes one lineage.** Memo P1 ranges over "S = the admitted events after absorption" (l.24–27) without a lineage restriction. Line 1176's phrasing — the hash "is the only level that survives an authorised fork's fresh door times" — actively **misleads**: across lineages the hash does **not** discriminate the twins (it is equal); door time, the reissued level, is the only discriminator. The hash's genuine fork role is *recomputability of one lineage's order from content*, not cross-lineage discrimination.

**The honest scope restriction (missing case is resolved by carrier restriction, not by extra proof).** `inv:lineage` (5190) guarantees "exactly one lineage is authoritative at any position"; cause-derived absorption is necessarily intra-lineage (else a fork could re-admit nothing). So the order's carrier **is** a single authoritative lineage, and cross-lineage twins are never both in one fold. State this explicitly.

**Add to sec:totalorder (after l.1168):**
```latex
The relation is defined over the events of a \emph{single lineage} --- the authoritative
one, of which Invariant~\ref{inv:lineage} guarantees exactly one at each position.
Absorption, and hence the order, is intra-lineage: an abandoned-lineage event and its
rebuilt twin on a new lineage share execution time \emph{and} hash (both
lineage-invariant), are separated only by the reissued door time, and are never both
carried in one fold nor ordered against each other. Within a lineage, distinct events
have distinct content and hence distinct hashes (ASSUMPTION-CR), so key injectivity,
trichotomy, and antisymmetry hold as proved.
```

**Correct l.1176–1178** (the misleading claim). Replace
> "and it is the only level that survives an authorised fork's fresh door times (Chapter~\ref{ch:invariants}), execution time and hash being lineage-invariant where door time is not."

with
```latex
and, because execution time and the hash are lineage-invariant where door time is not,
a party can recompute the \emph{new} lineage's order from execution time and hash alone,
without trusting the reissued door times (Chapter~\ref{ch:invariants}). Across lineages
the hash does not discriminate --- an abandoned event and its rebuilt twin share it ---
which is why a fork's two lineages are never ordered against each other.
```

---

## F3 — trichotomy over the post-absorption carrier; carrier defined before use — **VERDICT: SOUND** (conditional on the F2 restriction, with one note)

**Sub-question 1 — proved total over the post-absorption set?** Yes. Memo P1 / Lemma 2 trichotomy (l.73–76) is proved for distinct `e1,e2 ∈ S`, with `S` the post-absorption set. The spec asserts totality (1164, 1179) and pins it with `prop_totalOrderTotal` over `admittedDistinct h` (6102–6105). The proof holds **provided** the carrier is the single authoritative lineage (F2): CR-injectivity of the hash is what drives trichotomy, and that injectivity is intra-lineage only.

**Sub-question 2 — carrier defined in print before use?** Yes. The carrier is defined in prose at the order's definition site: "an arrival identical under the cause-derived identifier is absorbed once, before ordering, so the relation ranges over distinct events and a duplicate never takes a position" (1166–1168). This precedes the ch15 property at 6102 that names the "post-absorption event set" / `admittedDistinct h`.

**Notes (not defects).**
- The spec contains **no printed proof** of totality; 1179 asserts "Totality is proved under one named assumption" and points outside. Acceptable because totality is not labelled a Theorem and the proof is memo P1 — but in-spec a reader has only the assertion.
- `admittedDistinct`, `totalStrictOrder`, `keyOf`, `lt` (6103) are undefined helpers. Acceptable as §5 illustration since the concept they name is prose-defined at 1166–1168.
- The carrier prose (1166–1168) omits the single-lineage scope; this is the F2 gap, not a second F3 defect.

---

## F4 — refold idempotence: proved in print, or asserted? — **VERDICT: DEFECT**

**Location.** Analysis, "Idempotence", 1232–1235; ch15 property block 6101–6116; memo P4(iii) l.218–222.

**Finding: ASSERTED in print, PROVED only in the memo.** The spec's treatment is a one-line gloss inside the Analysis prose:
> "Refolding twice equals refolding once --- the second pass finds $e$ already at its position and recomputes the identical tail" (1232–1233).

This is an assertion with a plausible reason, not a proof, and it is **not** labelled a Theorem — so the veto ("nothing labelled Theorem/Proposition may stand unproven") does not bite. The actual proof is memo P4(iii): `R = fold step L0 ∘ sort_<`; `sort_<` is idempotent because `<` is a strict total order (P1) so the sorted arrangement is unique; a second reordering finds `e` already in `S` (a fresh arrival absorbed, no element added), sorts the same `S`, and by replay determinism (P2) folds to the identical state; hence `R∘R = R`.

**The substantive defect (§3 executable-guarantee gap).** Idempotence is a stated guarantee (1232) but there is **no executable property** for it in ch15. The property block (6101–6116) has `prop_totalOrderTotal`, `prop_refoldEqualsOnTime`, `prop_reorderFlagged`, `prop_duplicateAbsorbed` — **no `prop_refoldIdempotent`**. CLAUDE.md §3: "An invariant defended only in prose is not an invariant … it must be shown to fire." Refold idempotence is defended only in prose (spec) plus a memo proof; it is untested.

**Remediation.** (i) Thread the P4(iii) proof, or make the gloss carry an explicit pointer to it, so the claim is not merely asserted. (ii) Add the missing property with a firing witness:
```haskell
-- Refold idempotence (memo P4-iii): reordering twice equals reordering once.
prop_refoldIdempotent h = foldLedger (reorder (reorder h)) === foldLedger (reorder h)
prop_refoldIdempotent_fires =   -- require a genuine interior insertion, else vacuous
  checkCoverage $ cover 1.0 insertsBeforeHead "an interior insertion actually refolded" genLateArrival
```

---

## Outside the lenses — one item I could not let pass

**thm:refold embeds its proof inside the theorem environment** (the last sentence, 1240–1242). A theorem states; a proof proves, separately. This is minor structurally, but it is the mechanism by which the false reading (A) hides: the "proof" clause silently narrows the statement to (B) without the statement admitting it. Folded into the F1 correction above (the corrected statement carries the argument in a following remark, not inside the theorem).

No other issue outside the assigned lenses in the reviewed spans.
