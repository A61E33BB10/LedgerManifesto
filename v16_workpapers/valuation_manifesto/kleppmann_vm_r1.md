# KLEPPMANN — Review of the Valuation Manifesto 1.0, Round 1

**Charter:** event-sourcing / data semantics. The log is the source of truth; the valuation
chain, its certificates, and the shifted-world vectors must never silently diverge from the
record they derive from, and the chain must inherit the corpus's forward-repair discipline in
full. **Scope:** the chain and certificate semantics (VM-3..VM-10, §3), read against the two
parents (Constitution C-2.7/C-8.2/C-8.4/C-11.3/C-12.1/C-12.4/C-12.6/C-14.9; MDM MD-5/MD-8/MD-10/
MD-13/MD-14).

**Read:** `ValuationManifesto_1.0.tex` (all 10 articles + §1/§3/§4/§5 in full); `drafting_note.md`;
cross-checked the FORMALIS return and the MDM clauses it inherits.

**Headline.** The two-layer split (leg = re-entered observation; NAV/chain = projection) is clean
and correctly inherited, and the certificate-as-proof question (attack 2) is answered well: the
plug identity is explicitly disclaimed as proof and the content is located in the declared bound.
But the chain's response to a **retroactive change** — a mid-chain input correction, or a
late-arriving corporate action whose ex-date sits inside an already-chained span — is
under-specified in exactly the way the append-only discipline most needs. Forward-repair is stated
for the *directly affected* link but not for **forward propagation along the chain**, and the
stated staleness path (VM-7) does not fire for the reordering case. Two material findings, both on
this one seam.

---

## Attack (1): forward propagation along the chain — a certificate can prove from a superseded predecessor — MATERIAL

**What is specified.** VM-3: the chain is append-only, a re-mark is a new link forward, never an
edit, the as-known value surviving (C-12.1, C-12.4). VM-7: a link that "consumed a corrected or
superseded input ... its lineage marks it stale ... a flagged open item for re-derivation,"
repaired forward. Good — for the **directly affected** link.

**What is not specified.** A link's certificate proves the transition from its predecessor: "today's
exit sensitivities are tomorrow's entry sensitivities, so the explain carries measured
sensitivities at both ends" (VM-3). So link `L(k+1)`'s certificate **consumes** `L(k)` (its entry
greeks = `L(k)`'s exit greeks). When `L(k)` is superseded, the document never states that the
**downstream** links are flagged stale, nor — the coordinator's exact question — whether
`L(k+1)`'s certificate is re-proven from the **superseding** predecessor `L(k)'` or left proving
from the **superseded** `L(k)`.

> **Scenario.** Chain `L1(Mon) → L2(Wed) → L3(Thu)`, each a re-entered observation. `L3`'s
> certificate proves the Wed→Thu change using `L2`'s exit delta/gamma as entry greeks. Thursday a
> vendor restates Tuesday's underlying close (MD-10); `L2` consumed it. Per VM-7, `L2` is flagged
> stale and a superseding `L2'` is minted forward. But `L3`'s certificate still proves `L2 → L3`
> from `L2`'s **wrong** exit greeks — it is internally consistent (`R := ΔNAV − Σ lines` holds by
> construction, VM-4) yet proves a transition **from a mark that no longer heads its segment**. If
> the corrected leaf was in `L2`'s window but not `L3`'s, `L3`'s *value* is fine and nothing in the
> stated text flags `L3`'s *certificate* stale — the proof-of-work certificate silently attests a
> superseded predecessor.

**Why the machinery is present but the statement is missing.** `L(k)` is a re-entered observation
`L(k+1)`'s certificate consumed, so by MD-6 ("every ... derived object it consumed") it *is* a
pinned lineage input, and MD-8 *would* flag `L(k+1)` stale — VM-3 even says "the chain is the
valuation layer's instance of complete lineage." So the fix composes from existing parts; it is
simply not said. **Fix:** state that the chain inherits forward-repair *transitively* — a
superseded link flags stale every downstream link whose certificate chained from it; each is
re-proven **forward from the superseding predecessor** (never edited); the as-known branch
survives beside the corrected one (C-12.1), so the chain resolves into the two honest answers
rather than silently forking. This is the explicit answer to "superseded or superseding predecessor":
**superseding, forward.**

## Attack (4): the sandwich under a late-arriving corporate action — the reordering refold is not routed to VM-9, and VM-7's stated staleness path does not fire — MATERIAL

VM-9 covers two CA-timing cases: **provisional** (terms not yet resolved → frame provisional,
sandwich struck as such) and **corrected/mis-declared** (residual materially above the three
tolerances → "MD-8 and MD-10 handle as a superseding event"). It does **not** cover the third
case the coordinator flagged: a **resolved** CA that reaches the door **late**, after valuations
were already chained across its ex-date. That is a *reordering* (C-2.7/MD-5), not a
*lineage-supersession* — and the distinction is load-bearing:

- VM-7's stated staleness path is "a re-entered valuation record that **consumed** ... a restated
  corporate action **behind its frame** ... its lineage marks it stale." A link struck **before**
  the late CA arrived **never had the CA in its lineage** (the operator did not apply it — it was
  unknown). So VM-7's path **does not fire** for the intervening links. Only MD-5's reordering
  ("a late arrival whose execution time precedes observations already folded ... a re-entered
  observation whose input window it lands in ... is flagged stale") fires — and **VM-9 never routes
  the sandwich to MD-5's reordering.**

> **Scenario.** A 2:1 split has ex-date Tuesday but reaches the door Friday. Wed and Thu closes
> print post-split (~150) while the ledger, ignorant of the split, still reads the Monday frame
> (~300). The chain books a **spurious ~50% "market-move loss"** in the `L1(Mon)→L2(Wed)`
> certificate — a split masquerading as a crash. Friday the split arrives. To repair, MD-5 must
> insert it at Tuesday, flag `L2`/`L3` stale (they are execution-time *after* the ex-date), a
> **sandwich must be struck retroactively** at the Tuesday transition (VM-9's "every corporate
> action triggers a valuation sandwich"), and the spurious market-move line must be **reclassified
> as a zero-profit frame re-coordination**, the reordering carried in the explain (C-12.6, via
> VM-4). Every mechanism exists — but the composition is unstated, and an implementer following
> VM-7 (the article that *names* CA-driven staleness) would look for the CA in the intervening
> links' lineage, not find it, and **not flag them stale.** The spurious loss persists silently.

**Fix.** VM-9 (or VM-7) must route the late-resolved-CA case to the reordering refold explicitly:
a CA arriving after valuations were chained across its ex-date takes its place at the ex-date
(C-2.7/MD-5), flags the intervening links stale **by the reordering trigger** (not the
lineage-supersession trigger), strikes its sandwich retroactively at the ex-date, and reclassifies
the intervening market-move lines as frame re-coordination, the reordering attributed in the
explain (C-12.6). This is one paragraph composing existing machinery; without it, the article that
purports to handle CA staleness (VM-7) points at the wrong trigger for the commonest CA-data
failure a desk sees.

---

## Attack (2): what the certificate certifies — HANDLED, no finding

The plug-identity trap is explicitly avoided. VM-4: "Because the residual is the balancing term
... the certificate reconciles to the change in net asset value **by construction, not by
coincidence** ... Attribution decomposes ΔNAV; it never recomputes it." The content is then
located in the bound, VM-6: "'Explained' means the residual sits below a declared bound ...
certified only when each instrument's residual is within its bound and the aggregate is within
the aggregate bound." And the residual is given genuine sensor content (small ∧ mean-zero ∧
regime-independent vs. structurally large/sign-biased). VM-9's sandwich residual is a **genuine
differential check**, not a plug: the post-frame value is *recomputed from operator-adjusted
inputs* ("never scalar-transported") and compared to the operator-transported pre-value, so
`≈0` is two independent computations agreeing within three declared tolerances, and a material
residual "says the operator or the delivery frame was mis-declared." The document nowhere lets the
plug identity masquerade as the proof. Well done.

## Attack (3): two chains, one unit — HANDLED, with a MINOR

Two **cuts** → the two honest answers, both on the record (C-12.1, VM-3). Two **parties, same
model/convention, different marking cadence** → different decompositions of the *same* total,
which reconcile because "the identity that the parts sum to ΔNAV holds on every path ... no second
running total ... is kept beside NAV to disagree with it" (VM-4, C-8.4) — every chain's lines sum
to the one ΔNAV. Two **parties, different model/convention** → localised to the differing term by
replay, not adjudicated (VM-5, VM-8), which is correct (adjudication is model choice, out of
scope). So divergent chains are detectable and reconcilable/localisable on the record.

*Minor:* the document says "**a** valuation chain" (singular) for a unit but never states that a
unit may legitimately carry **more than one** chain (per convention/cadence/desk) and that they
reconcile through the single ΔNAV (C-8.4) and localise to their recorded convention coordinate
(VM-5). One sentence would close the question "can there be two chains for one unit?" — the answer
is yes, and they reconcile through the one ΔNAV.

## Attack (5): shifted-world entries stay out of the real chain — HANDLED, with a MINOR

The separation is present at the principle level: a scenario is a **simulated path** under a
recorded shift (MD-11), "base and simulated worlds share their units, their models, and the market
data operator; only the market-data state differs" (VM-10), and §3 renders the shifted world as a
**column**, structurally apart from the chain **table**. "A stress run is a derived object with
full lineage" — its own object, not a production link.

*Minor:* VM-10 says a simulated valuation "re-enters as an observation **like any other** (VM-1)."
Taken alone this could be misread as re-entry into the **production** log. The intended reading —
inherited from MD-11/C-2.8/C-10.1 — is re-entry into the **simulated path's own** record. State
it: a simulated valuation is a link of its own simulated path and is **never** a link in the real
unit's valuation chain; the shift, like the seed, is that path's single non-record input. This
seals the boundary the chain's integrity depends on.

---

## Verdict

- **Attack (1): MATERIAL** — forward propagation of a supersession along the chain is unstated;
  a certificate can silently prove from a superseded predecessor. Answer to make explicit:
  re-proven **forward from the superseding predecessor**, as-known branch surviving.
- **Attack (4): MATERIAL** — the late-resolved-CA (reordering) case is not routed to VM-9's
  sandwich, and VM-7's named CA-staleness path does not fire for links struck *before* the CA
  (it is a reordering, not a lineage-supersession); a spurious split "loss" can persist silently.
- **Attack (2): clean** (certificate content correctly located in the bound; no plug-as-proof).
- **Attack (3): handled**, one MINOR (multiple chains per unit reconcile through the one ΔNAV).
- **Attack (5): handled**, one MINOR (simulated valuation re-enters its own path, never the real
  chain).

Both material findings are the same shape as the seam I chased in the parents: the machinery to
handle the retroactive change **exists and composes**, but the **statement** that closes the
forward/intervening cascade is missing, and in the attack-4 case the article that names the
relevant mechanism points at the **wrong trigger**. Both are fixable **within** the two parents
(transitive forward-repair over the chain; route the late CA to the reordering refold) — no park.
Because both would materially improve the semantics, this is **NOT CONVERGED**; one round on
attacks (1) and (4) is warranted.

---

# Round 2 — Convergence check (VM 1.0 revised, 8pp)

**Read:** the changed passages — VM-3 (multi-chain clause), VM-6 (anti-plug + bound-adequacy),
VM-7 (transitive forward repair), VM-8 (collateral-dispute scope), VM-9 (late-CA reordering),
VM-10 (simulated-path separation + risk-vs-books).

**M1 (forward propagation along the chain) — RESOLVED, and the re-prove direction is exact.**
VM-7 now states: "Staleness propagates forward along the chain: a superseded link flags stale
every downstream link whose certificate chained from it, and each re-proves *forward from the
superseding predecessor* --- never editing the old proof --- so a certificate can never keep
attesting a transition from a mark that no longer heads its segment (MD-6, MD-8). The as-known
branch survives beside the corrected one (C-12.1), so the chain resolves into the two honest
answers rather than silently forking." This is the exact answer to the round-1 question
(superseded vs. superseding): **superseding, forward.** Transitive (whole tail, not one link),
append-only (never editing the old proof), and the two honest answers survive (no silent fork).
My round-1 scenario — `L3`'s certificate proving from a superseded `L2` — is now impossible:
`L3` is flagged and re-proven forward from `L2'`.

**M2 (late CA meets the sandwich) — RESOLVED, and the reordering route genuinely reaches the
links struck *before* the CA.** VM-9 adds the third timing case verbatim to the gap I raised:
"a resolved action that reaches the door *late* ... This is a reordering, not a lineage
supersession: **the intervening links never carried the action in their lineage, so they are
flagged stale by the reordering trigger (C-2.7, MD-5), not by the frame-supersession path of
VM-7.** The action takes its place at the ex-date, its sandwich is struck *retroactively* there,
and the spurious market-move line ... --- a two-for-one split reaching the door three days late
reads as a fifty-percent crash until it arrives --- is reclassified as the zero-profit frame
re-coordination, the reordering carried as its own line in the profit-and-loss explain (C-12.6).
The loss is never left standing." This names the exact trap (VM-7's path does *not* fire; MD-5's
reordering does), and the reordering genuinely reaches the intervening links: their frame depends
on the CA terms in force as-of their execution time, so the late CA lands in their frame-window
and MD-5 flags them. The trace now cites MD-5. Correct.

**Minors — all RESOLVED.**
- *Multiple chains per unit:* VM-3 now states "A unit may carry more than one valuation chain at
  once --- one per re-marking convention, cadence, or desk --- and they do not compete: each
  decomposes the one change in net asset value (C-8.4) and localises to its own recorded
  convention coordinate (VM-5)." Exact.
- *Simulated-path separation:* VM-10 now states a simulated valuation re-enters "into the
  simulated path's *own* record, never as a link in the real unit's valuation chain." The
  boundary the chain's integrity depends on is sealed; the added risk-vs-books sentence is a
  correct bonus.
- *Collateral dispute:* VM-8 scopes it ("replay settles the mark inside the call, never the
  collateral-agreement terms"). Consistent with MD-14's reach-bounding.

**Two strengthenings beyond my asks, both correct.** VM-6's *anti-plug* now says outright that
reconciliation "proves *nothing* ... only the residual *below its declared bound* certifies ---
Reconciliation is automatic; explanation is earned," and adds the *bound-adequacy* guard (a
too-loose bound would silently empty VM-7; guarded by recording the residual whatever the bound,
and by making bound calibration an auditable event, named as a governance assumption "as the
parent named the identifier grain and the delivery frame"). This closes attack (2) more
thoroughly than round 1 required.

**Fresh-material hunt on the edits — nothing material.** The transitive VM-7 propagation and the
VM-9 reordering compose cleanly: for a late CA, MD-5 flags the intervening links and VM-7 then
flags *their* downstream links; the overlap is harmless (both say "flag"), and the as-known /
corrected branches are consistent across both articles. VM-10's "risk and books cannot disagree
by construction" is precise, not over-claimed: it is the *one-recipe / two-systems* break that
cannot arise; the greek-vs-full-reval gap is separately computed and recorded (E + R), so no
silent divergence is implied.

## Round-2 verdict

- **M1 RESOLVED** (transitive forward repair; re-prove forward from the superseding predecessor;
  two honest answers, no silent fork).
- **M2 RESOLVED** (late CA routed to the reordering refold; the intervening links flagged by the
  reordering trigger, not VM-7's frame-supersession path; retroactive sandwich; spurious loss
  reclassified).
- **All three minors RESOLVED**; two correct strengthenings added.
- **No fresh material finding introduced.**
- **CONVERGED** on my charter (event-sourcing / chain integrity). The valuation chain and its
  certificates now inherit the corpus's forward-repair discipline *transitively* — for both a
  mid-chain input correction and a late-arriving corporate action — and the certificate's content
  is correctly located in the declared bound, with the plug-identity explicitly disqualified as
  proof. A further round would produce no material improvement.
