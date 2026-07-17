# Round 2 — FORMALIS findings (v16.1 pass)

Reviewer: FORMALIS (Leroy chair; Coquand, Huet, Paulin-Mohring, de Moura, Avigad).
Target: `Ledger_Spec_v16.1/ledger/ledger_v16_1.tex`, new Fix-A text in sec:totalorder.
Record: `round2_record.md` (SF-1 the fixpoint; SF-5 no page-adding remedy without named displacement).
Prior: `memo_w2_proofs.md` (P1–P5); `round1_formalis.md`.

---

## F1 (CENTRAL) — the firing-closure is a fixpoint, not a one-shot map — **VERDICT: DEFECT** (escalates to VETO if the honest statement is not supplied)

**Location.** "Why it holds" remark, l.1264–1272 (esp. the false sentence l.1266–1269); step (c) l.1226–1232; thm:refold l.1257–1262.

**The concealment, one level down from Round 1.** The remark says
> "The operator is a deterministic function of the ordered arrivals **alone** — a firing's condition is a recorded fact … the clock is never read." (1266–1269)

It is **not** a function of the arrivals in the one-shot sense the word "alone" asserts. A firing's condition is read off the **folded state**; a synthesised firing takes a **past** execution position (the barrier breach sits at Tuesday's close); refolding across it changes state a later watch reads, which can imply **further** emissions. The object named "the closure of the external arrivals under the operator" (1264–1265) is therefore a **fixpoint of interleaved fold-and-derive**, and the remark hides its well-definedness and termination — exactly the premise F1 was corrected for hiding in Round 1. As a labelled Theorem resting on this, thm:refold is again a strong claim on an unproven base.

**The operator is NOT monotone — the supervisor's suggested lemma is the wrong instrument.** SF-1 proposes "monotone operator, finite domain ⇒ unique least fixpoint (Knaster–Tarski)." That route is unavailable: adding an event can **remove** a firing. Covered call: `derive(S) ∋` the record-date dividend firing; `derive(S ∪ {Tuesday assignment})` does **not** (predicate now finds zero shares). So `S ⊆ S' ⇏ derive(S) ⊆ derive(S')`; the operator is non-monotone and Knaster–Tarski does not apply. Uniqueness must come from **well-founded (stratified) recursion on the execution-time order**, not from a monotone lattice. This correction is load-bearing, not pedantry: a "least fixpoint" proof built on monotonicity would be false.

**Why the fixpoint is nonetheless well-defined — the honest statement (supply, do not assert).** Existence/uniqueness is by stratification, termination needs two named hypotheses, confluence needs determinism, and fold-state equality across the two sides needs a third hypothesis. Replace the false sentence (1266–1269) with a pointer to a lemma, and add the lemma:

```latex
% replaces l.1266-1269
The operator is not a one-shot map: a synthesised emission takes a past
execution position, and refolding across it can imply further emissions, so the
closure is a \emph{fixpoint} of interleaved fold-and-derive. Lemma~\ref{lem:closure}
establishes that this fixpoint exists, is unique, and is reached in finitely many
steps; it is computed from the record alone --- each emission's condition a
recorded fact, execution time record-derived, monitor time null, the clock never
read (Chapter~\ref{ch:machines}) --- and, being a fixpoint of a deterministic
derivation over the execution-time order, is independent of the order emissions
are discovered, so the refold and the timely fold reach the \emph{same} closure.

\begin{lemma}[Firing closure]\label{lem:closure}
Let $A$ be the external arrivals (finite). For finite $S\supseteq A$ let $D(S)$
be the Monitor emissions implied by folding $\mathrm{sort}_<(S)$: at each
total-order position $p$, an emission whose watch's edge-predicate the fold
strictly below $p$ newly satisfies. A \emph{closure} of $A$ is a finite
$F\supseteq A$ with $F = A \cup D(F)$.
\begin{enumerate}
\item \emph{Existence, uniqueness.} An emission at $p=(\mathrm{exec},\mathrm{door},
  \mathrm{hash})$ depends only on the fold strictly below $p$; the dependency
  strictly decreases in the well-order $<$, so $F$ is fixed by well-founded
  recursion along $<$ and is unique. The operator is \emph{not} monotone --- a
  late arrival can suppress an emission (the covered call) --- so uniqueness is
  by stratification on execution time, never a monotone least fixpoint.
\item \emph{Termination.} Under \textup{(H-FIN)} the candidate emission occasions
  (recorded observation points, scheduled dates) within the bounded horizon are
  finite and each watch fires at most once (\texttt{prop\_firedMatchesOneEdge}),
  and under \textup{(H-WF)} the ``arms a further watch'' relation is well-founded;
  then the closure adds finitely many emissions and the door-order iteration
  terminates.
\item \emph{Confluence.} $\mathrm{fold\ step}$ is deterministic (replay
  determinism, P2), so the closure is independent of the order emissions are
  discovered and inserted.
\end{enumerate}
A retained emission whose predicate no longer holds re-runs to a fold-state
no-op \textup{(H-INERT)}: its contract, re-executed against the refolded state,
proposes the empty transaction, so retained superseded emissions leave the fold
state the timely side --- which never held them --- also reaches.
\end{lemma}
```

**Three hypotheses must be NAMED and labelled (not proved), per the veto bar:**
- **(H-FIN)** finite candidate emission occasions in the bounded horizon + each watch fires at most once — an obligation about product/observation structure.
- **(H-WF)** the arms-a-further-watch relation is well-founded — rules out the infinite arming cascade SF-1 flags; a design obligation on product terms, property-testable, not an axiom.
- **(H-INERT)** a superseded emission re-runs to a fold-state no-op — needed because the two sides do **not** have equal event sets (the refold **retains** the record-date firing as provenance, 1311–1314; the timely side never held it). Fold-state equality holds only if the retained firing's re-run contract proposes nothing. The covered call satisfies this ("finds zero shares → proposes no dividend", 1363); the general rule must be stated, else the theorem's fold-state equality has a gap exactly where the two firing-sets differ.

**Page note (SF-5).** The lemma adds ~0.4pp. Correctness outranks the cap (§7): bank against DL-03 or escalate the page to the coordinator — it may not be dropped to fit. The non-monotonicity correction and the three named hypotheses are irreducible; without them thm:refold stands unproven and the VETO holds.

---

## F2 — the operator's domain omits arming acknowledgements — **VERDICT: DEFECT**

**Location.** Step (c) operator l.1226–1232 (says "**firings**"); watch handshake l.1420–1435; substrate l.1383; Interactions l.1314–1315.

**The emitted substructure has three layers, and the operator names one.** The watch handshake is explicit:
- **Declaration** — a **contract-written** unit-state change ("record-date watch declared", 1420–1421). Recomputed by the ordinary tail refold (map-then-fold). ✓ covered.
- **Arming acknowledgement** — "The Monitor acknowledges each declared watch; each acknowledgement is an event like any other, flows through the same pipeline, and lands as a unit-state update: both watches now visibly **armed**" (1431–1433). This is a **Monitor-emitted** event, the **same class** as a firing.
- **Firing** — Monitor-emitted (1434–1435).

Step (c) re-derives only "the watch **firings** the reordered prefix implies" (1226). The **arming acknowledgement** — equally a Monitor emission, equally a projection of the folded prefix — is **omitted from the operator's stated domain**. This is not covered by the ordinary fold (armings are Monitor acts, not contract writes) and is not covered by the firing clause (an arming is not a firing).

**Both halves are unstated for armings.** The refold can (i) **newly arm** a watch the reordered prefix now declares — its arming acknowledgement, then its firing, must both be synthesised; step (c) synthesises only the firing. And (ii) **un-arm** a watch the reordered prefix no longer declares — step (c) states consequence-voiding for a superseded **firing** (1229) but says nothing of a superseded **arming**. The supervisor's "a watch armed by folded state that the refold un-arms" is precisely case (ii), and the printed operator does not reach it.

**Inconsistency to resolve.** Line 1383 already treats the armed-watch set as "the refolded **projection**", and 1314–1315 says "which firings are in force is a projection of the ordered prefix." So the spec elsewhere relies on armings being fold-projected — but the operator that is supposed to produce that projection (step c) names only firings. The domain is under-specified and internally inconsistent.

**Fix — pin the operator's domain to the full Monitor-emitted substructure. Replace the first clause of the step-(c) firing sentence (1226–1228):**
```latex
% replaces "The refold also re-derives the watch firings the reordered prefix
% implies: a data-predicate or scheduled watch the new order newly satisfies"
The refold also re-derives every \emph{Monitor emission} the reordered prefix
implies --- the arming acknowledgement and the firing alike, a watch declaration
being contract-written and so already recomputed by the fold. An emission the new
order newly implies (a watch the reordered prefix newly declares-and-arms, or a
data-predicate or scheduled watch it newly satisfies) is emitted at its
record-derived execution position
```
and extend the voiding clause (1229) so a superseded **arming**, not only a superseded firing, "keeps its recorded event, its consequence voided." Confirm the partition is exhaustive: an emitted event is either a contract write (recomputed by the fold) or a Monitor emission (synthesised by the operator) — no third kind.

---

## F3 — idempotence proved only for the sort, not the post-Fix-A closure — **VERDICT: DEFECT** (conditional on F1)

**Location.** Idempotence gloss l.1252–1255 ("proof in memo P4"); `prop_refoldIdempotent` l.6142 and `_fires` l.6143–6144.

**The pointer is stale for Fix-A.** Memo P4(iii) proves `R∘R = R` from **`sort_<` idempotence + fold determinism** — a permutation-only refold. Under Fix-A, `reorder` now = insert + refold + **close under the firing-derivation operator**. Idempotence of the sort does **not** give idempotence of the closure. What must additionally hold:

1. **Closure is a fixpoint (⇐ F1 / lem:closure).** After the first reorder the set is the closure `F`; `D(F) = F\A`, so the second reorder re-derives **exactly** the same emissions — synthesising none, suppressing none. Without lem:closure this is unproven; F3 inherits the F1 premise.
2. **Re-derived emissions are absorbed under their cause-derived identifier.** A synthesised firing present in `F` must, on the second pass, be **absorbed** (duplicate absorption, C-12.3), not re-emitted as a fresh copy. If synthesised emissions took a fresh identifier each pass, `reorder∘reorder` would accrete duplicates and idempotence would **fail**. The gloss (1252–1255) says only "finds `e` already at its position" — silent on the synthesised emissions, which is where Fix-A idempotence actually turns.

**Fix — extend the printed proof (net-neutral rewording of 1252–1255):**
```latex
\emph{Idempotence.} Refolding twice equals refolding once
(\texttt{prop\_refoldIdempotent}) --- the second pass finds $e$ at its position,
folds the same $\mathrm{sort}_<$ (memo~P4-iii), and re-derives the same closure:
the closure is a fixpoint (Lemma~\ref{lem:closure}), so no emission is added or
suppressed, and a re-derived emission already present is absorbed under its
cause-derived identifier (C-12.3), never duplicated. A duplicate late arrival,
absorbed before ordering, occupies no position and triggers no refold.
```

**Witness gap.** `prop_refoldIdempotent_fires` (6143–6144) requires only `insertsBeforeHead`; it never forces the first pass to **synthesise a firing**, so the closure-idempotence case (second pass must absorb, not duplicate, a synthesised emission) is never witnessed — a §3 zero-firing gap on the Fix-A-specific case. Strengthen the witness to require a first-pass synthesis (shares the generator A3/`prop_firingSynthesized_fires` will add).

---

## Outside the assigned lenses — one item I could not let pass

**`prop_refoldEqualsTimely` (6137–6140) presupposes termination it does not assert.** The oracle runs `runPipeline` on both sides; if the firing closure were infinite (H-FIN/H-WF violated) neither side halts and the property cannot be evaluated — a non-terminating "green." The oracle is sound **only under lem:closure's termination**. One comment line should record that the property assumes the closure is finite (H-FIN, H-WF), so a reviewer does not read a hang as a pass. This reinforces SF-1: the fixpoint's finiteness is load-bearing for the executable regime, not only the proof.
